# One band, four receivers

The firmware's own modulator transmits V.21 answer, 1650/1850. The transmitter
is left on the originate band and gated off, so the only thing reaching the
receiver is that signal, and it is offered to each of the four receive setups
in turn.

| receive setup | carrier | bit errors over 120 |
|---|---:|---:|
| `d7a4` | 1750, the answer band centre | 0 |
| `d7ac` | 2125 | 56 |
| `d7c8` | 1080 | 64 |
| `d7d0` | 1170 | 64 |

Only the band centre of the signal recovers it. That is the measurement behind
calling the four same-band dispatch entries analogue loopback rather than
reading it off the constants. The manifest also carries the two datapump
tables that mailbox commands `10` and `11` dispatch through, and the mode flags
that index them. See `docs/fsk-modulation.md`.
