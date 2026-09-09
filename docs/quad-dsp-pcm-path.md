# Where the PCM goes on the Quad x2 Modem NAC

The question: does the G.711 codeword stream reach the C50 DSP directly, or
does the 80186 supervisor carry it? The answer for the supervisor is settled —
it is not in the sample path. The DSP-side detail is only partly recovered, and
this document is explicit about which is which.

## Proven: the 80186 is not in the sample path

The supervisor's entire I/O map, taken from every `mov dx, imm16` followed by
an `in`/`out` in the real 16-bit code region (`0x80000..0xc49a3`), is:

| Ports | Role |
| --- | --- |
| `0x0000`, `0x0200`, `0x0260`, `0x0280` | the four-entry board latch bank at `cs:0x931`, with an output shadow at `[0x216..0x21d]` |
| `0x0220`–`0x022a` | the management USART — see [nmc-sdl-protocol.md](nmc-sdl-protocol.md) |
| `0x0042`, `0x0200`, `0x0240` | the backplane handshake group |

All of these are byte-at-a-time, and none sits in a sample-rate loop. The
supervisor's DSP interface is a queue in shared RAM — the 35 initialisation
writes at `0x02ca..0x030e` that the execution run records (`QF` at `pc=8016a`,
`QR` at `pc=80176`) — which is control messaging, the same shape as the analog
Courier's mailbox in [dsp-cpu-interconnect.md](dsp-cpu-interconnect.md).

So no codeword copy loop exists on the 80186. Whatever carries PCM reaches the
DSP without the supervisor touching each sample.

## Proven: the Quad's DSP programs `TSPC` in its resident init

Both builds carry byte-identical code at the head of the DSP resident bank:

```
splk  @18, #0003
dmov  @18
lacl  #38
samm  @32        ; TSPC, the TDM serial port control register
lacl  #f8
samm  @32
```

| Build | Resident base | `samm @32` sites |
| --- | --- | --- |
| `QF060003` 6.0.3 | `0xc49b0` | word `0x099` (`0xc4ae2`), word `0x09b` (`0xc4ae6`) |
| `QR060103` 6.1.3 | `0xc2230` | word `0x085` (`0xc233a`), word `0x087` (`0xc233e`) |

Written first as `0x38`, then as `0xf8` — the same value with the top two bits
set, the ordinary configure-then-release shape for this register. Both sites
are anchored, in the entry path, and identical across two independent builds.

## Proven by execution: the Quad's serial port is byte-formatted

The DSP residents run under this repository's own C5x core
(`courier_emu.dsp.NativeC5x`, program loaded at origin `0x8000`, entry
`0x8000`). Against the SDL 3.02 analog reference from `IDSDL302.ROM`
(`rom-info` gives its DSP payload as flash `0x29080..0x368fc`, entry word
`0x8000`):

| Image | `SPC` | `SPC` writes | `TSPC` | `TSPC` writes | final `pc` |
| --- | --- | --- | --- | --- | --- |
| `QF060003` Quad | `0x40cc` | 118 | `0xf8` | 118 | `0x265b` |
| `QR060103` Quad | `0x40cc` | 28 | `0xf8` | 28 | `0x82e0` |
| SDL 3.02 analog | `0x40c8` | 2 | `0xf8` | 2 | `0x814d` |

`TSPC` is `0xf8` on **both** products, so the TDM port is not what separates
them. The whole difference is one bit in `SPC`, the standard serial port
control register: `0x40c8` against `0x40cc`.

Per the C5x user's guide in this tree (`spru056d`, Table 9-13), bit 2 is **FO,
Format**:

> FO = 0 — The data is transmitted and/or received as 16-bit words.
> FO = 1 — The data is transferred as 8-bit bytes. The data is transferred with the MSB first.

So the analog Courier moves **16-bit words** and the Quad moves **8-bit bytes,
MSB first**. That is the G.711 codeword, and it is the concrete register-level
form of the analog/digital split. It agrees with
[ac01-codec-protocol.md](ac01-codec-protocol.md), where the TLC320AC01
"exchanges one 16-bit word each way per frame" — a 14-bit linear sample plus
two control bits, which is exactly what FO = 0 carries.

The rest of both values decode the same way: `Soft` set, `RRST` and `XRST` set
(both halves out of reset), `FSM` set, and — the part that matters for a
chassis card — **`TXM = 0` and `MCM = 0`**: frame sync is an input and the
transmit clock comes from the `CLKX` pin. The DSP is a slave on somebody
else's PCM timing, which is what sitting on a shared highway requires.

### Why the Quad rewrites the registers

The 302 payload programs `SPC`/`TSPC` twice and moves on, because this
repository models its AC01 codec and therefore its frame clock. The Quad
payload rewrites them 118 (QF) and 28 (QR) times, because nothing supplies the
external clock and frame sync its `TXM = 0` / `MCM = 0` configuration waits
for, so it keeps resetting the port and retrying. That is the expected shape of
a missing peer, not a fault in the image.

Caveat on the runs: QF's final `pc` of `0x265b` is below the `0x8000` program
origin, so that instance has run out of loaded program space by the end of two
million instructions. QR stays inside it at `0x82e0`. The register counts above
are still meaningful — they accumulate during the init phase — but QF's late
execution should not be read as firmware behaviour.

## Not established, and a correction

An earlier version of this document contrasted the analog Courier's "plain
serial port" with the Quad's "TDM port", on the strength of a scan finding no
TDM-register writes in a `main211` payload. **That claim is withdrawn**, for
three reasons, and the execution results above supersede it: `TSPC` is `0xf8`
on the analog SDL 3.02 image too.

1. **Wrong reference image.** `main211` is not a behavioural reference for this
   tree; 302 and 403 are. Every comparison here now uses the SDL 3.02 payload
   out of `IDSDL302.ROM`.
2. **Wrong method.** Counting `lamm`/`samm` opcode words misses the normal
   idiom: on the C5x, memory-mapped registers `0x00..0x5f` are data page 0, so
   code reaches them with `ldp #0` and direct addressing (`lacc @30`), or
   indirectly — the Quad's own `SPC` writes are `lar ar1, #22` followed by
   `splk *, #000c` / `splk *, #40cc`, invisible to every static scan tried.
3. **It contradicted this repository's own model.** `native/c5x_core.cpp`
   implements the full TDM register file (`0x30`–`0x35`), and its comments
   describe the legacy TDM path with the ASIC as TDM clock master. Those come
   from live board probes and outrank a static word scan.

Still **open**:

- `TCSR` (`0x33`) and `TRTA` (`0x34`) — channel select and timeslot address —
  have no confirmed access in either Quad payload, statically or in two million
  executed instructions. Given `TXM = 0` / `MCM = 0`, the card is a timing
  slave, so timeslot selection may be done by board logic outside the DSP
  rather than by these registers at all. Not settled either way.
- Which companding law is in force. FO = 1 establishes 8-bit MSB-first
  transfers; it does not distinguish A-law from mu-law.
- How the four channels are separated. One serial port carries byte-formatted
  PCM, but nothing found so far says how four calls share it.
- The per-sample receive/transmit ISR has not been located in either payload.

## Method note

Static scanning of a C5x payload is unreliable and every result above that
depends on it is labelled accordingly. Three failure modes, all observed here:

1. A word such as `0x0830` is `lamm @30` only at an instruction boundary. More
   often it is the immediate operand of a preceding `lar arN, #0830`.
2. Coefficient and pointer tables disassemble into plausible instruction runs.
   `tools/c5x_disasm.py`'s `anchored()` filter removes some but not all.
3. Direct addressing is page-relative, so identifying a register access needs
   the value of `DP`, which linear decoding through data cannot track soundly.

The `TSPC` pair survives all three because it is `lacl #imm` / `samm` — an
opcode with no page dependence, at an anchored site, in the entry path, and
duplicated across two independently built images.

Settling the rest wants the DSP executed rather than read: `courier-emu
dsp-run` against the Quad resident, with the TDM registers watched, would show
the ISR and the timeslot writes directly.
