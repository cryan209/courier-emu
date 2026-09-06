# Arming slot 0: overlay 6 runs

[datapump-slots.md](datapump-slots.md) named slot 0 V.34 and
[fsk-modulation.md](fsk-modulation.md) read its dispatch off `9b34`, but the
overlay had never been executed. The supervisor's DSP download carries only the
resident bank, `8000..eea7`, so program `9d00` holds resident words and the
12,594-word V.34 image sits in flash at `36e90` untouched.

`courier_emu.v34` publishes it with `load_program` and enters it the way the
firmware does. Three things had to be right, and each was wrong first.

**Data page 0, not 7.** `9b34`'s `splk @7c, #9b48` and `9b44`'s `add @7c` are
separated by `9b41`'s `ldp #000`. Enter the dispatcher with DP 7 and the two
halves address different cells: `add @7c` reads data `007c`, `tblr` reads
program `0000`, and the `bacc` lands in whatever is at the bottom of program
memory. The caller enters with DP 0.

**The mode flags cannot be preset.** `9b3c` calls `9b2c`, which ends
`retd / lacb / sacl @27` - it *writes* `@27` from what `d648` returns. Anything
put there beforehand is overwritten before `9b5a` tests it.

**They come from a list at data `fea1`, walked with ARP 1.** `9b2d` sets
`ar1, #fea1`, and `d665` reads `*+`; with ARP 0 it reads AR0 instead and the
scan terminates on the first zero. `d665` keeps the first word whose low five
bits are 5, `d64d` takes bits 5-7 of it, and the result becomes `@27`. The word
`#0045` gives `@27` = 2, whose bit 1 is slot 0's flag.

## What it does

| | originate (`9b34`) | answer (`9b38`) |
|---|---|---|
| enters `9d00` | yes | yes |
| instructions to return | 2,237 | 2,236 |
| `@6f` marker | `4042` | `4042` |
| `@1a` transmit callback | `aafb` | `aafb` |
| `@1b` receive callback | `9daf` | `9daf` |

The marker is the check worth having: `#4042` is the value
[fsk-modulation.md](fsk-modulation.md) read out of `9d00` statically, before
anything ran. The overlay executes to it and returns cleanly.

## No tone, and why that is the expected result

`aafb` returns in 278 instructions and installs its own successor
(`splk @1a, #ab3f`, then `ab83`), so the transmit chain advances per sample.
Its body is filter banks - 46-tap and 140-tap `mac` runs into `@78`, `@79`,
`@7d`, `@7e`.

Overlay 6 touches no converter at all ([vpcm-datapump.md](vpcm-datapump.md)),
so its samples reach the line only through the resident mixer. Driven that way
the chain runs and the mixer buffer stays zero. A V.34 modulator with no
start-up state, no symbol rate committed and no data source has nothing to
send, so silence is what it should do - but it means **no V.34 signal has been
produced or measured here**, and the arming above is a bring-up, not a carrier.

`v34.transmit_callback` keeps that measured rather than assumed:
`tests/test_v34.py` pins the chain advancing *and* the silence, so whichever
one changes will be visible.
