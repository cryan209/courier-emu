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

## Trying to make it produce samples

Not achieved. What follows is how far it gets and what each remaining blocker
is, so the next attempt starts from here rather than from the beginning.

### Frame timing is the first blocker, and it is real

Given a frame clock — `NativeC5x.configure_rom_codec(True)` — the Quad
resident stops thrashing its serial port:

| | `SPC` writes | `TSPC` writes | final `pc` |
| --- | --- | --- | --- |
| no frame clock | 118 | 118 | `0x265b` (out of program space) |
| frame clock | **2** | **2** | `0x82eb` |

The 118 rewrites are therefore a stalled retry loop, not normal behaviour,
which is consistent with the `TXM = 0` / `MCM = 0` reading: the port waits on
external timing.

Read that table narrowly. `configure_rom_codec` does not supply a sustained
frame clock here — the run ends with `primary_frames = 2` and
**`frames_clocked = 0`**. What it changes is the `XRDY` answer: per
`native/c5x_core.cpp`, without the codec `XRDY` keeps an optimistic value,
and with it `XRDY` follows the codec's frame clock. Two frames were enough
for the firmware to settle its init. That is not the same as a working
timing source, and the table should not be read as one.

**This is a diagnostic, not a model.** The codec being enabled is the AC01,
which exchanges 16-bit words; the Quad runs `FO = 1`, 8-bit bytes. It is the
wrong peer, used only to establish that *some* frame source unblocks init.
A Quad board model needs its own timing source, not this one.

### Where it then waits

The firmware reaches a structured host-command wait at program `0x82d9`:

```
82d9  setc  intm
82da  calld 23f0, *
82dc  lar   ar1, #ff57      ; delay slot
82de  clrc  intm
82df  and   #0200           ; test bit 9 of what came back
82e1  bcnd  82ec, neq       ; set -> go do work
...
82ea  idle                  ; else wait for an interrupt
```

Two things follow. First, the address in `ar1` is `0xff57`, and nearby code
uses `0xff58` and `ldp #1fe` / `@63` (`0xff63`). Those are **global data
memory**, not I/O ports. So the Quad's CPU-to-DSP link is shared memory, unlike
the analog Courier's ASIC mailbox on DSP I/O ports `0x5e`/`0x5f`
([dsp-cpu-interconnect.md](dsp-cpu-interconnect.md)). It is the DSP-side view of
the supervisor's queue at `0x02ca..0x030e`.

Identifying `0xff57` as *the* host flag cell is inference from the delay-slot
`lar`; the routine at `0x23f0` has not been read.

Second, writing `0x0200` into `0xff57`, `0xff58` and `0xff63` does **not**
advance it. The cells read back changed, so the write lands, but the branch
outcome does not — either the flag is fetched some other way, or the wait is on
the interrupt rather than the flag.

### Interrupts do wake it

Delivering any of IRQ 0-7 moves it off `idle` into a loop at program `0x8109` /
`0x810c`, where it then runs steadily. But across 300,000 further instructions
there are still **no `DXR` or `TDXR` writes** and the codec clocks no frames.
It is running, and idle in the sense of having nothing commanded.

### What a tone would need

On the analog Courier a tone is a short mailbox conversation — tags `0x16`,
`0x19`, `0x1a`, `0x1b`, then `0x13:<digit index>`
([driving-the-tones.md](driving-the-tones.md), and `audio-312-path.md` for the
oscillator it drives). The Quad's equivalent command set is **unknown**: its
link is shared memory rather than that mailbox, so neither the tags nor the
cells transfer.

The remaining work, in order:

1. Read the routine at `0x23f0` to learn how the host word is actually
   fetched, and which cell carries the ready flag.
2. Decode the supervisor's side of the same queue — the 35 writes at
   `0x02ca..0x030e` are its initialisation, so the command encoding is
   reachable from the 80186 code that fills it.
3. Supply a frame source appropriate to `FO = 1` byte transfers rather than
   borrowing the AC01.

Only then is asking for a tone meaningful.


## Feeding it idle codewords

The right instinct for real hardware: a PCM receiver is never starved, and an
idle channel carries an idle codeword rather than nothing. The firmware agrees
— it has an `S71 T1 Idle Disconnect Pattern` register.

It does not help yet, and the reason is worth recording.

Queued 20,000 idle codewords into the receive side and stepped 1.5 M
instructions, trying mu-law `0xff` and `0x7f`, A-law `0x55` and `0xd5`, plus
`0x0000` and `0xffff` as controls, through both `queue_serial_rx` and
`queue_codec_rx`. Every variant gives the identical result:

```
pc=0x03e6  dxr=0x0001  tdxr_writes=0  rx_consumed=0  frames=2  clocked=0
```

Two things are wrong there, and neither is the codeword value.

`rx_consumed` stays 0: nothing is clocking frames, so the queue is never
drained. Feeding the right byte cannot matter while no frame sync consumes it.

More seriously, `pc = 0x03e6` is **outside the loaded program**. The resident
bank occupies program `0x8000..0xfa28`. A control run with no receive data and
no interrupt stays put at `0x82eb`; queueing receive data alone — without
delivering any IRQ — is enough to derail it, because the core raises a receive
interrupt and the firmware's handler leaves loaded space immediately.

So the blocker is not the idle pattern. It is that **the DSP program is
incomplete**: only the resident bank is loaded. Per
[x2/README.md](x2/README.md), the remaining 23,944 (QF) / 19,884 (QR) C50 words
are an overlay store whose selection mechanism is not yet decoded, and the
interrupt path evidently reaches code that is not in the resident. Any
experiment that provokes an interrupt will run off into unmapped memory until
the overlays are placed.

That reorders the remaining work. Before a tone, or an idle stream, is
meaningful:

1. Recover the Quad's C50 overlay placement, so a full program is loaded and
   interrupt handlers land in real code.
2. Then supply framing suited to `FO = 1` byte transfers, at which point an
   idle codeword stream becomes the correct thing to feed.
3. Then decode the shared-memory command queue to ask for a tone.
