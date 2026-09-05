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

## 2. Audio reaches the DSP on the C5x serial port, not through the CPU

**Hardware, negative half.** `AT&T8` runs analogue loopback with self-test:
the modem generates its own pattern, drives the full modulator/analogue/
demodulator path, and - unlike `&T1` - leaves the DTE in command mode, so the
`ATGLK2` monitor still answers while audio is flowing. The test returned `000`
errors, so the path really ran.

Sweeping I/O ports `0x00..0x7f` idle and during the test
(`artifacts/io-port-loopback-01/`), only four ports differ:

| port | idle | during `&T8` |
|---|---|---|
| `0x18` | FF | C0, C1, C6 |
| `0x1a` | FF | C0, C1 |
| `0x1c` | FD | F9 |
| `0x1e` | FF | FB |

All four are mailbox handshake and status registers. **No CPU I/O port carries
audio samples.** The 80186 is not in the audio path.

**Firmware, positive half.** Across the whole DSP image the only peripheral
registers touched are `DRR` (`@20`, serial receive) and `DXR` (`@21`, serial
transmit). The TDM registers `0x30..0x35` are never referenced anywhere.

The port is set up at reset (`main211` program addresses):

```
00bc  lar  ar1, #22        ; SPC, the serial port control register
00bd  splk *, #0008
00bf  splk *, #40c8        ; MCM = 0: the bit clock comes from outside
```

`MCM = 0` means the DSP takes `CLKX` from an external source - **the codec is
the clock master**, which is exactly what pacing the modeled line on the codec
assumed, now confirmed from the firmware rather than inferred.

The frame handlers are a four-phase rotating chain. Each phase reads one word
from `DRR`, writes one to `DXR`, and installs the next phase's address:

```
01ad  lamm @20   ; read the codec sample
01ae  sacl *+    ; store through ar7
01bc  samm @21   ; write the outgoing sample
01c3  lacc #81de ; -> next phase
```

`01a8 -> 01de -> 01f4 -> 020d -> 01a3`, cycling. That is the software framing
measured earlier as roughly ten writes per codec sample: several serial slots
per audio frame, not several audio samples.

Codec and DAA control is separate from the audio, on the DSP's own I/O ports
`0x68..0x6c` (`out @7d,0068` ... `out @7e,006c` at reset, and `out @7f,006a`
inside the receive handler).

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

This is an argument from the image and its internal consistency, not a readout.
It does not say what is physically on the die, and it does not rule out mask
ROM contents that are simply never mapped. What it does rule out is the worry
that drove the probe work: that some of the running DSP code is unavailable.

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
