# A modulation, not a tone: V.21 and Bell 103 from the firmware's own modulator

[answer-tone.md](answer-tone.md) got the datapump to emit a 2100 Hz answer
tone. That is a signalling tone: one oscillator, no data. This document gets
the same firmware to run an actual **modulation** - 300 bps FSK, keyed by a
data bit - and finds the eight-entry table that pairs each transmitter with a
receiver, four of which are the analogue-loopback self-test configuration.

Getting there required fixing four opcodes in the C5x core. Those are the
reason none of this worked before, and they are the most portable result here.

## The four bands, found by arithmetic

Reading the resident bank for 16-bit constants that are phase increments at the
dial path's 7200 Hz turns up four adjacent pairs, in six setup routines at
`d790`-`d7d7`:

| setup | `@72` | `@73` | frequencies | modulation |
|---|---|---|---|---|
| `d790` | `22d8` | `29f5` | 980 / 1180 Hz | V.21 channel 1 (originate) |
| `d79a` | `2d28` | `260b` | 1270 / 1070 Hz | Bell 103 originate |
| `d7b4` | `3aab` | `41c7` | 1650 / 1850 Hz | V.21 channel 2 (answer) |
| `d7be` | `4f1c` | `4800` | 2225 / 2025 Hz | Bell 103 answer |

Four more routines set a receive carrier: `d7c8` 1080 Hz, `d7d0` 1170 Hz,
`d7a4` 1750 Hz, `d7ac` 2125 Hz. Those are the band centres of the four
transmit pairs.

Every one of these eight numbers lands on a standard 300 bps frequency only if
the sample rate is 7200 Hz. With `0x4aab` and `0x0ca7` from the answer tone,
that is now three independent confirmations of the rate that
[audio-312-path.md](audio-312-path.md) originally inferred from DTMF alone.

## The modulator

Program `d95f`, installed in the mixer's first callback slot:

```text
d95f  bit    7, @50     ; the data bit - bit 8 of the cell
d960  lacc16 @72        ; mark increment
d961  xc     1, ntc
d962  lacc16 @73        ; ...or space
d963  add16  @63        ; frequency offset
d964  add16  @40        ; phase accumulator
d965  sach   @40
d966  calld  8b0f       ; sine
d96a  bit    11, @70    ; transmit enable
d96c  xc     1, tc      ; ...else feed the filter a zero
d96d  lacc   @42
d970  calld  8a88       ; shaping filter, coefficients addressed by @5f
d975  mpy    @67        ; amplitude
d977  sach   @47, 1     ; the transmit sample
```

`courier_emu.fsk` calls the ROM's own setup routine, installs `d95f`, and runs
the same mixer and serial ISR as `audio312` and `answer_tone`. **This harness
supplies the data bit from outside, once every 24 samples**, and on that basis
a 511-bit maximal-length sequence modulates and demodulates with zero bit
errors in three of the four bands:

| mode | mark | space | bit errors over 511 |
|---|---:|---:|---:|
| `v21-originate` | 980 | 1180 | 0 |
| `v21-answer` | 1650 | 1850 | 0 |
| `bell103-answer` | 2225 | 2025 | 0 |
| `bell103-originate` | 1270 | 1070 | 34 |

The last row is a limit of the **demodulator in this tool**, not of the
firmware: its two tones are 200 Hz apart at one bit per 24 samples, closer than
non-coherent energy detection can separate, and a real Bell 103 receiver uses a
discriminator rather than two matched filters. The modulator itself is exact -
holding the bit produces 1270.0 Hz and 1070.0 Hz measured.

> **Withdrawn: the 300 baud figure was this harness's, not the firmware's.**
> An earlier version of this document called 24 samples a bit "exactly
> 300 baud", because 7200/24 is 300. That is arithmetic about a number this
> harness chose, not a measurement of the ROM. The firmware has its own
> transmit bit clock and it says something else: `@50` is a shift register that
> `d978`-`d983` shifts right **once per modulator invocation**, reloading when
> the marker bit falls out, so it presents one data bit per invocation. Since
> the same invocation advances the carrier phase by an increment that is only a
> V.21 frequency at 7200 Hz, taking both at face value gives 7200 bps, which is
> not a 300 bps modulation. Something about how often this datapump's callback
> actually runs is therefore still unaccounted for, and until it is, no baud
> figure here is the firmware's. What the increments do establish is the
> **modulation's identity** - the frequencies are exact - not its bit rate.

```sh
.venv/bin/python -m courier_emu.fsk \
  --rom artifacts/courier-board-21210-capture-403/courier-board.rom \
  --output /tmp/fsk --mode v21-answer
```

Saved runs for all four are in `artifacts/fsk-01/`.

## The loopback table

Eight dispatch entries at `d7d8`-`d812` each call one transmit setup and one
receive setup. Sorting them by whether the receiver sits inside the
transmitter's own band splits them exactly in half:

| entry | transmitter | receive carrier | |
|---|---|---:|---|
| `d7d8` | Bell 103 answer 2225/2025 | 2125 | **own band** |
| `d7e3` | Bell 103 answer 2225/2025 | 1170 | normal |
| `d7e9` | Bell 103 originate 1270/1070 | 1170 | **own band** |
| `d7f4` | Bell 103 originate 1270/1070 | 2125 | normal |
| `d7fc` | V.21 answer 1650/1850 | 1750 | **own band** |
| `d802` | V.21 answer 1650/1850 | 1080 | normal |
| `d808` | V.21 originate 980/1180 | 1080 | **own band** |
| `d80e` | V.21 originate 980/1180 | 1750 | normal |

A modem in a call never listens to its own transmit band - that is the whole
point of splitting the band in two. A configuration that does is a modem
listening to itself, which is what analogue loopback needs. So four of these
eight entries are the loopback self-test's datapump configuration, one per
300 bps modulation.

That is an argument from the table's structure. It is not a run.

## The loopback attempt, and where it stops

Closing the loop was tried and **does not work yet**. The bring-up itself does:
replaying entry `d7fc`'s own calls - `d7b4` transmit config, `d7a4` receive
config, then `d829`'s `d94e`, `d895` and `d879` - leaves the firmware's own
state installed, with `@1a` = `d95f`, `@1b` = `d8aa`, and `@70` = `0x0013`. The
receiver raises `INTR 17` every sample, which needs a vector at program `0x0022`
that the resident bank does not contain; a bare `RETE` there lets the path run.
With each transmitted `DXR` fed back as the next `DRR` through
`queue_serial_rx`, 1152 samples execute without leaving the firmware.

Two things then stop it, and neither is resolved:

* `DXR` reads zero from the second sample on, although the mixer's output cell
  `@47` and the sample buffer are both varying correctly. With the receiver
  installed the circular buffer advances differently than it does in the
  transmit-only harness, and this harness's habit of forcing the pointer back
  to `0x0bc0` each frame is no longer right.
* The demodulator's soft decision at `@6a` stays positive throughout, so no bit
  is ever recovered.

So: the transmitter is confirmed, the receiver is installed and executing, and
the loop is not closing. Reporting it as anything more would be wrong.

## The core bug that hid all of this

`MAC`, `MACD`, `MADD` and `MADS` are the C5x's FIR instructions: each walks a
coefficient table in **program** memory alongside a data window. Two things
were wrong in `native/c5x_ops.ipp`, and together they made every filter in the
firmware return zero or nonsense:

* **The coefficient address did not advance under `RPT`.** These four relied on
  the outer repeat loop, which re-executes the instruction with the program
  address reset. A `rpt #0e ; macd *-` therefore convolved a 15-sample window
  against one constant coefficient instead of fifteen different ones.
* **`MADD` and `MADS` read their coefficient from data memory** at BMAR. They
  address program memory. Every coefficient table this firmware uses - `d9a3`,
  `d9b2`, `d98f`, `872f` - is a program address sitting just past the code that
  scans it, so the data-memory read returned zero for all of them.

Both are fixed in the shape the file already uses for `TBLR` and `BLPD`:
consume the repeat internally, incrementing a local `pfc`. All four now also
load `TREG0` with the data operand, as SPRU056D specifies.

`tests/test_c5x_anchoring.py` pins it with a four-tap `MADS` whose answer is
checked against hand arithmetic; reverting either half of the fix fails it.

The fix is what made this document possible, and it retroactively removes a
limitation recorded in [answer-tone.md](answer-tone.md): ANSam's `8712` and
`8716` variants were silent only because their shaping filter returned zero.
They now render, with the 15 Hz modulation visible as a symmetric sideband pair
at 2085 and 2115 Hz, each about 10% of the carrier.

## Two traps for anyone extending this

Both cost real time here, and both are silent - the code runs and produces a
plausible wrong answer.

1. **ARP, not the register name.** `BANZ *-`, `MADS *+` and friends index
   through whichever register `ARP` points at. `LAR AR1, ...` does not change
   `ARP`. The firmware's mixer sets `ARP` to 1 at `80c9`, so a harness that
   enters below that line silently uses `AR0`.
2. **Data page 0 is the memory-mapped registers.** `SPLK @1f, #x` writes BMAR
   only with `DP` at 0; on any other page it writes an ordinary variable.
