# Analogue loopback: the firmware demodulating its own transmitter

Each run replays the ROM's own bring-up for one of the four 300 bps bands -
transmit setup, receive setup, then `d94e`, `d895`, `d879` - installs nothing
by hand, and feeds every transmitted word back as the next received word. The
bits come out of the firmware's own receiver at `d8aa`.

| mode | sampling offset | bit errors over 511 |
|---|---:|---:|
| `v21-originate` | 41 | 0 |
| `v21-answer` | 43 | 0 |
| `bell103-originate` | 44 | 0 |
| `bell103-answer` | 42 | 0 |

The offset is the receiver's group delay, stable per mode. The symbol period of
48 samples is measured, not derived, and does not yet reconcile with the
transmit shift register's one bit per invocation; see `docs/fsk-modulation.md`.
