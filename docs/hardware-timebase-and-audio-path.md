# The hardware tick, the audio path, and the DSP's low program memory

Three questions the harness had been carrying as assumptions. All three are now
answered from the physical board and from the firmware images it runs, and each
answer has more than one independent source.

The board is the 20.16 MHz, 512 KiB Courier on `/dev/cu.usbserial-21210`,
running ID_SDL v4.03d - supervisor 7.4.16, DSP 3.1.2.

## 1. One firmware tick is 5.000 ms

Three independent lines agree, and none of them is a model.

**The board.** `S18` sets a self-test duration in seconds and `&T1` runs local
analogue loopback for that long, entirely inside the modem: no phone line, no
off-hook, no NVRAM. `courier_emu.tick_probe` timed four settings three times
each (`artifacts/tick-probe-01/`):

| S18 | measured |
|---:|---:|
| 2 | 9.845, 9.845, 9.841 s |
| 4 | 11.843, 11.841, 11.845 s |
| 8 | 15.846, 15.846, 15.845 s |
| 12 | 19.845, 19.843, 19.841 s |

Least squares over the twelve points gives **1.000031 seconds per S18 unit**
with a worst residual of 3.0 ms, on a fixed 7.843 s loopback setup overhead.
So a firmware second is a true second, to about three parts in ten thousand.

**The firmware.** Both builds convert an S-register byte, which is in seconds,
to a countdown by multiplying by 200 (`mov ah,0xc8 ; mul ah`), at five sites in
each image. Seconds x 200 = ticks, and a second is a second, so one tick is
5.0 ms.

**The silicon.** The supervisor programs 80186 Timer 0's compare A once, and
later checks it. On the 80186 an internally clocked timer counts at CLKOUT/4:

| build | clock | T0CMPA | counts/s | period |
|---|---|---:|---:|---:|
| board 7.4.16 | 20.16 MHz | `0x6270` = 25,200 | 5,040,000 | **5.000 ms** |
| main211 2.1.1 | 25.8048 MHz | `0x7e00` = 32,256 | 6,451,200 | **5.000 ms** |

Two different builds on two different crystals, each choosing the max count
that lands on exactly 5.000 ms. The board's value is written at `0x008ce` and
verified by the firmware itself at `0x4a83b` (`cmp word [0xff32], 0x6270`).

The board's oscillator can reads **40.320 MHz** (see [board-parts.md](board-parts.md)),
and the 80C186 divides its oscillator input by two, so CLKOUT is 20.16 MHz.
That removes the one ambiguity in this table: 25,200 counts is a round figure
either way - 5.000 ms at CLKOUT = 20.16 MHz, or 10.000 ms had 20.16 been the
crystal and CLKOUT half of it. The `&T1` slope had already chosen the first,
since seconds convert to ticks by multiplying by 200. The can agrees.

This also settles something the "pairing trap" note flagged: **main211 is the
25.8048 MHz build**, not a 20.16 MHz one. Its timer constant only lands on
5 ms at 25.8048 MHz.

### What this does to the harness constants

`daa.py`'s `INSTRUCTIONS_PER_MS = 1_111` is refuted, and its own comment says
why. It was derived by assuming the burst that takes the tick counter to 180 is
a 2 s North American ring, giving a 10 ms tick. At the real 5 ms tick, 180
ticks is 900 ms - an ordinary minimum ring-burst qualification, which is what
that counter is for.

Worse, the derivation is circular: `machine.py` synthesizes the tick itself at
`tick_ms * INSTRUCTIONS_PER_MS`, so "2,000,000 instructions reaches 180 ticks"
is arithmetic on the two constants, not a measurement of either.

That leaves the codec-implied figure as the only one still standing. 4,348
instructions per millisecond at 20.16 MHz is 4.64 cycles per instruction, an
ordinary 80186 mix. 1,111 would be 18.1 cycles per instruction, which is not.

### The change, and what it did to the answered-call runs

Applied: `INSTRUCTIONS_PER_MS` 1,111 -> 4,348, `SUGGESTED_TICK_MS` 10 -> 5, and
`RING_START_MS` 8,000 -> 2,000 ms, which keeps the old *instruction* offset now
that a millisecond is worth four times as many instructions.

Measured at equal line time - the 40M baseline against 156M at the new rate, so
both runs carry about 355 line frames (`artifacts/clock-recalibration-01/`):

| `./courier link main211.xmf --summary` | before | after |
|---|---:|---:|
| line frames | 354 | 357 |
| `codec_rx_queued` | 323,520 | 338,880 |
| `codec_rx_consumed` | 66,267 | 271,475 |
| **backlog ratio** | **4.88** | **1.25** |
| `v8_dispatches` | 89 | 89 |
| result | `CONNECT` | `CONNECT` |

The receive backlog was the thing that invalidated every earlier reading of
whether the datapump had heard the line. It is not gone, but it is down from
five times to a quarter, and `CONNECT` and the overlay's dispatch count are
unchanged, so the call still comes up the same way.

`--tick-source dsp` gains something separate. The two sides used to disagree -
side b reported no serial text at all, 9,785 ticks against side a's 1,455, 710
detector replies against 45, and zero line frames. They are now symmetric: both
`OK`, both 1,455 ticks, both 45 detector replies, both 11 frames, and both
seeing the peer off hook.

`--exchange` barely moves, which is the check that this went in the right
place: that path was already paced on the codec rather than on
`INSTRUCTIONS_PER_MS`, so it should be insensitive to the constant, and it is
(8,800 ms of line time against 9,000, same `dtmf_blocks`, same dial-tone stall).

What is left is the residual 1.25. The rate that would balance this path is
nearer 5,435 instructions per millisecond - 4.75 cycles per instruction at
main211's 25.8048 MHz, as ordinary as 4,348's 5.9. Two honest options remain,
and this document takes neither: fit the constant to the balance, or pace the
link on the codec the way the modeled line already is. The second is the
structural fix; the first is a number.

## 2. The 80186 is not in the audio path; where it goes on the DSP side is
still open

**This section originally claimed the audio arrives on the C5x serial port via
a four-phase handler chain at program `0x01a8`. That was wrong, and the
correction is below the measurement that stands.**

### What stands: no CPU port carries audio

`AT&T8` runs analogue loopback with self-test and, unlike `&T1`, leaves the DTE
in command mode, so the `ATGLK2` monitor answers while audio flows - it
returned `000` errors, so the path ran. Sweeping ports `0x00..0x7f` idle
against active (`artifacts/io-port-loopback-01/`), only four move:

| port | idle | during `&T8` |
|---|---|---|
| `0x18` | FF | C0, C1, C6 |
| `0x1a` | FF | C0, C1 |
| `0x1c` | FD | F9 |
| `0x1e` | FF | FB |

All four are mailbox handshake and status registers. **No CPU I/O port carries
audio samples**, so the 80186 is not in the audio path. That is a board
measurement and it is unaffected by what follows.

### The correction

Two claims made here from static reading do not survive the runs' own
instrumentation:

*"The only peripheral registers the DSP image touches are DRR and DXR; the TDM
registers `0x30..0x35` are never referenced."* Wrong. `TRCV` (`0x30`) is read
**676,558 times** in a 60M-instruction run, at program `0x8c1e` - twice for
every `DRR` read. The scan that missed it only matched `lamm/samm` forms and
did not cover the resident bank's addressing.

*"The frame handlers are a four-phase rotating chain, one `DRR` read and one
`DXR` write each."* That code exists, but it does not run. `dxr_writes` is
**3** in the same run, all at program `0x00c6`, which is the reset-time
initialisation. `tdxr_writes` and `tspc_writes` are **0**. The DSP never
transmits on either serial port after reset.

What the DSP actually does, per run counters:

| source | reads | program |
|---|---:|---|
| `DRR` (`0x20`) | 338,279 | `0x8c1c` |
| `TRCV` (`0x30`) | 676,558 | `0x8c1e` |
| ASIC external I/O `0x50` | 338,279 | `0x8c1f` |
| ASIC external I/O `0x52` | 411,025 | - |
| ASIC external I/O `0x54` | 676,556 | - |

All in one polling loop in the resident bank, and `0x52`'s count equals
`line_frame_interrupts` exactly. So the repo's existing position - that the
C52's live view of the outside world is the ASIC boundary
(`courier_firmware_analysis.md`, "DAA chipset identity") - is at least as well
supported as the serial-port reading, and this document should not have
asserted otherwise.

What is genuinely open is which of these the *hardware* uses for audio. The
harness answers all of them, so run counts cannot separate them; they only show
the firmware polls all three.

### What the low-address code is

The dormant code at `0x0176..0x0223` is a codec control path, and a specific
one: it drives a TI `TLC320AC0x`, whose protocol is to request a secondary
control frame with bit 0 of the transmitted word. See
[board-parts.md](board-parts.md). It runs at reset - the three `DXR` writes are
its initialisation - and then stops. Whether it is dormant because the ASIC
fronts the codec on this board, or because one firmware serves two hardware
variants, is not settled here.

## 3. The C52's internal mask ROM is not what the modem executes

The open question in [dsp-rom-probe.md](dsp-rom-probe.md) was whether the
bootstrap at DSP program `0000..0fff` is mask ROM. It is not, and the image
says so:

- The firmware's own DSP payload has a segment at **origin `0x0000`** covering
  program words `0000..75d9`. That spans the entire 4K mask-ROM window.
- The origin is confirmed by the code, not just by a harness constant: every
  branch is self-consistent with it. `bcnd 80c3` at `01cc` targets `00c3`, and
  the handler chain stores `81de/81f4/820d/81a3` for code that sits at
  `01de/01f4/020d/01a3`.
- Program `0000` is not a vector table. It is straight-line reset code that
  runs *through* the INT3 and TXNT vector slots, with `setc intm` at `0005`
  disabling interrupts first:

```
0000  ldp  #000
0001  splk @57, #ffff
0005  setc intm
0007  splk @2a, #0010   ; CWSR
0009  splk @28, #000a   ; PDWSR - program/data wait states
000b  splk @29, #0001   ; IOWSR - I/O wait states
```

- Programming wait states is only meaningful for **external** memory. On-chip
  memory needs none.

Taken together: the C52 runs in microprocessor mode with external program
memory, its reset vector included. The mask ROM is never mapped, so it holds
no boot loader the modem uses, and the download must be the 80186 writing
external DSP program RAM while the DSP is held in reset - the alternative that
document raised and could not choose.

The practical consequence is the useful one: **the DSP program is not missing.**
All of `0000..75d9`, `8000..d9ef` and the `de83` overlay come from the flash
image already captured. There is nothing behind a mask-ROM protection bit that
the modem itself executes.

There is a stronger test than any of the above, and it was already in the runs.
The bridge does not assume the transfer: it accumulates the supervisor's actual
download stream and compares it against the image. Every answered-call run
reports `bootstrap_match: true` at `bootstrap_bytes: 60344` - 30,172 words, the
whole origin-`0x0000` segment. The supervisor really does transfer code whose
content is `0x0000`-origin, spanning the entire 4K mask-ROM window, so program
`0000..0fff` is written by the CPU and is therefore RAM.

That matters because the DSP is custom-marked `(C) US ROBOTICS`, which is
exactly what a mask-ROM part looks like, and the arguments above - branch
targets, wait states, code running through the vector slots - would all read
the same way if the low words were mask ROM that the flash image merely carries
a copy of. The download stream is what discriminates.

None of this is a readout. It does not say what is physically on the die, and
it does not rule out mask ROM contents that are simply never mapped. What it
does rule out is the worry that drove the probe work: that some of the running
DSP code is unavailable.

### Still unavailable

A host-controlled read of arbitrary DSP program memory. Tag `46` streams real
DSP program words to the host and was confirmed on hardware, but only from the
fixed base `0x860b` with an index the DSP chooses from six values. No mailbox
tag exposes a table-read address. Reading `0000..0fff` off the die still needs
JTAG or code execution on the DSP.

## Reproducing

```sh
.venv/bin/python -m courier_emu.tick_probe \
  --device /dev/cu.usbserial-21210 --baud 115200 \
  --output artifacts/tick-probe-01
```

Needs no phone line and never takes the loop off hook. `S18` is read first and
restored afterwards, and the transport's allowlist contains no `&W`, so nothing
reaches NVRAM.

The `&T8` port sweep is recorded in `artifacts/io-port-loopback-01/`. It sends
only reads plus `AT&T8` and `AT&T0`.
