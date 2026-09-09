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

## Not established, and a correction

An earlier version of this document claimed that `main211`'s C52 payload
contains no TDM-register writes, and drew a contrast between the analog
Courier's plain serial port and the Quad's TDM port. **That claim is
withdrawn.** It rested on counting `lamm`/`samm` opcode words, which misses the
normal idiom entirely: on the C5x, memory-mapped registers `0x00..0x5f` are
data page 0, so a tight ISR reaches `TRCV`/`TDXR` with `ldp #0` and ordinary
direct addressing (`lacc @30`, `sacl @31`), not with `lamm`/`samm`.

It also contradicts this repository's own hardware-derived model:
`native/c5x_core.cpp` implements the full TDM register file (`0x30`–`0x35`) and
its comments describe "the legacy TDM path" and "the C52's low-bank TDM ISR",
with the ASIC as TDM clock master converting a 25 MHz/258-cycle slot stream to
the 9.6 kHz line rate. Those comments come from live board probes and outrank a
static word scan.

So the following are **open**:

- Whether the Quad's use of the TDM port is a *difference* from the analog
  Courier, or the same arrangement on a different chip. Not settled.
- `TCSR` (`0x33`) and `TRTA` (`0x34`) — channel select and timeslot address —
  have no confirmed access site in either Quad payload. Every candidate found
  by scanning is a linear-disassembly artifact: the `lamm @30` clusters near
  `0xdd02c`, `0xdd0d6`, `0xdd294`, `0xdd348` are tables of monotone small
  values decoding as runs of `lar ar0, @xx`, and the `0x89b0`/`0x09b0` hits sit
  among `mpy #imm` coefficient data in the overlay region. Absence of evidence
  here is not evidence of absence — a direct-addressed write on page 0 would
  not appear in any of these scans.
- Which companding law is in force, and how the four channels map onto
  timeslots. This was the interesting question and it remains unanswered.
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
