# What the 4.03d board has actually confirmed

Everything here was read off the physical 20.16 MHz Courier running supervisor
7.4.16 / DSP 3.1.2, or watched on its front panel, and then compared against an
emulator run of that board's own ROM capture. It is kept separate from the
analysis documents because a board reading settles a question that a run
cannot: the emulator can be self-consistent and still wrong, which is how the
403 datapump carried a zero transmit level through a 600-test suite.

All reads were `AT`, `ATI*` and `ATGLK2=` page reads. Nothing here wrote to the
board.

## Confirmed

| what | board | emulator | where |
|---|---|---|---|
| identity | `7.4.16` / `3.1.2`, serial `0009540034268322` | same | `ATI7` |
| transmit levels | `[0cd9]=32c8`, `[0cdb]=0c08` | was `0000`, now matches | [datapump-dispatch-gate.md](datapump-dispatch-gate.md) |
| settings page | `B0 F1 M1 X7 &A3 &B1 &G2 &H1 &I0 &K1 ...` | same | `ATI5` |
| NVRAM self test | `TESTING NVRAM  OK` | same | `0x81412` |
| product code | `5607A` | same | `ATI0` |
| ROM checksum | `6C04` | same | `ATI1` |
| self test | runs only with the front panel button held | same, `--port 0x14=0xb5` | `0x877cd` |

The self test reproduces line for line, through the dipswitch page to
`SELF TEST COMPLETED`.

## The settings EEPROM

The boot block copies the whole 512-byte part into RAM `0x058e..0x078d` and
checksums it there at `0x81412`: byte 511 holds the sum of bytes 0..509, with
byte 510 added and taken straight back out.

That window is why `artifacts/courier-board-21210-ram-403/` contains the part
itself, and `CourierNvram.idsl403_fixture()` is those 512 bytes rather than
anything synthesised. Three things agree it is the store: it is identical
across both capture passes, its stored byte `0xbd` matches the rule where the
neighbouring ranges give `0xbe` and `0xbc`, and it carries the +S register
block at the offset derived from the ROM before the capture was read.

**A checksum-valid fixture over erased bytes is worse than no fixture.** An
intermediate revision did that, the firmware trusted the erased profile, and
the run lost its DTE output entirely.

## The front panel

`0x877cd` gates the self test on port `0x14` bit `0x40` reading low, and
`0x87e34` then spins while it is still low - a contact being released. It is
the button, not a DIP switch, and mapping `carrier-detect-override` onto it
was booting every `--dip-preset dedicated-line` run into the self test.

The lamp stage walks a nine-entry table at `0x8275f`, one line per ~281,500
instructions. Watching the board through it names eight:

| idx | port/bit | lamp | idx | port/bit | lamp |
|---|---|---|---|---|---|
| 0 | `0x12`/`0x10` | HS | 5 | `0x12`/`0x02` | MR |
| 1 | `0x14`/`0x40` | AA | 6 | `0x14`/`0x02` | CS |
| 2 | `0x14`/`0x10` | CD | 7 | `0x14`/`0x80` | SYN |
| 3 | `0x14`/`0x01` | *(silent)* | 8 | `0x14`/`0x20` | ARQ/FAX |
| 4 | `0x10`/`0x01` | OH, and the relay | | | |

Index 4 reads as a lamp *lighting* mid-sweep rather than going out, in both the
board's sequence and the emulated run. That is what identifies OH and the relay
as one line: the sweep drives `0x10` bit `0x01` and never touches bit `0x04`.

The speaker is port `0x00` bit `0x40`, pulsed high then straight back low by
`0x81703` - one click, called once per lamp as the sweep releases them, which
is the ticking that stage makes.

## Still open

- **Which lamp is index 3.** The alignment needs exactly one of the nine steps
  to have been invisible and puts it there. If the silent step is elsewhere,
  every row below it shifts.
- **SYN versus `carrier-detect-b`.** Index 7 puts SYN on `0x14`/`0x80`, but
  `0x5de57` drives `0x01` and `0x80` together as a pair. Both cannot hold.
- **What port `0x10` bit `0x04` is.** It is asserted on a dial 43,500
  instructions after bit `0x01` and never during the self test, so the
  `hook-relay` name on it is the older reading and has not been re-derived.
- **What gates the monitor speaker.** `0x81703` is unconditional and all three
  of its callers are boot or self test, so the audio heard during a call is a
  different, analogue path. `ATM` is settable now - `ATI4` reports `M0` after
  `ATM0` - so a dial under each setting is the next probe.
- **The tail of the board's lamp sequence.** After `SELF TEST COMPLETED` the
  board drives CS, RD and AA in a pattern the emulated run does not reproduce
  at all; it makes 38 panel writes in 600M instructions and none of them fall
  there.
