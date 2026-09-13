# What the 2806 actually touches in its EEPROM

[asic-pinout.md](asic-pinout.md) maps the 93C66 to its pins; this maps it to its
use. The board's own flash capture was run under
`artifacts/eeprom-access-map-20260913/`, with the NVRAM model's trace recording
every Microwire command the firmware issues. It is what the firmware does, not
what a datasheet says it could.

## The boot sequence, in order

| step | words | what happens |
|---|---|---|
| 1 | `0x00` | read - comes back `0xffff` on a blank part |
| 2 | `0x00` | **write-enable, write `0x0000`, write-disable** |
| 3 | `0x5e`-`0x66` | read - words 94..102, the datapump block |
| 4 | `0x00`-`0xf2` | read, linearly |

**266 reads and one write**, 243 of the 256 words touched. Words `0xf3`-`0xff` -
the top thirteen - are never read at all.

Three things are worth drawing out.

**The firmware initialises word 0 when it finds the part blank.** That is the
one write a boot performs, and it is unconditional on an erased device: read
`0xff`, enable, zero it, disable. So a "blank EEPROM" is not a state the
firmware leaves alone, and any fixture that starts blank has already been
modified by the time the first `AT` is parsed.

**Words 94..102 are read before the sweep, not during it.** That block is
already documented from the other end - [dsp-rom-probe.md](dsp-rom-probe.md)
has the DSP's driver caching exactly those words - and here it is the first
thing the supervisor fetches after the word-0 check. It is not part of the
general profile read; it is a separate, earlier errand.

**The sweep reads nearly everything.** Whatever the profile is, the firmware
pulls the whole store in rather than addressing individual settings, which is
why a blank fixture affects so much at once.

## What `AT&W` does not do here

[idsdl-extended-registers.md](idsdl-extended-registers.md) records that
"`AT&W` alone programs the standard USR profile at EEPROM words `0x00`-`0x22`",
measured on the 302 image with a persistent `--nvram` file.

**That could not be reproduced.** `AT&W` answers `OK` and programs nothing
beyond the boot-time word 0 - on the 2806 capture and on `IDSDL302.ROM`, through
the same CLI route with a persistent `--nvram` file, and with `ATE0&W`,
`ATS0=3&W` and `AT&F&W` in case the write needed a changed setting. `AT&W1`
answers `ERROR`, so the command parser is being reached. Every run: `writes: 0`.

This is recorded as a discrepancy rather than a correction, because the earlier
measurement was a measurement too and the difference in setup has not been
found. It matters because the DTE format is one of the things `&W` stores - the
harness's inability to store a profile is the other half of why every run comes
up at [7 data bits and even parity](running-the-25mhz-image.md).

## Why this is worth having without a captured part

There is still **no captured 93C66 image in this repository**. This map does not
replace one - it says which words matter, not what is in them. But it narrows
what a capture would need to cover, and it says something a capture could not:
that the firmware writes to the part during an ordinary boot, so a dump taken
after the board has run is not a dump of the factory state.
