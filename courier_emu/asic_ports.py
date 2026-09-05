"""The 20.16 MHz board's ASIC port space, measured rather than assumed.

Captured from the physical unit on `/dev/cu.usbserial-21210` (ID_SDL 4.03d,
supervisor 7.4.16 / DSP 3.1.2) with `courier_emu.asic_probe`, which reads every
port through the monitor's `ATGLK2I` selector and writes nothing. The raw
passes are in `artifacts/asic-ports-01/`.

Three facts about the shape of the space, each from 128 or 256 samples:

* **Only even addresses are decoded.** Every odd port in `0x00`-`0x7f` reads
  `0x00`, all 64 of them. The ASIC presents 16-bit registers and the monitor
  reads a byte, so the odd half is the high byte and nothing drives it.
* **The decode stops at `0x7f`.** Above it, all 64 even ports read back their
  own address and all 64 odd ports read `0x00` - an undriven bus returning the
  last thing on it, not a device.
* **The default is `0x00`, not `0xff`.** 96 of the 128 ports below `0x80` read
  zero. This matters because the harness returns `0xff` for any port it does
  not model, which is the opposite of what the board does.

What this is not: a functional model. These are the values the ports hold with
the modem idle and on hook. `IDLE` is a starting state, not a specification -
four ports move under load, and everything here was sampled with the loop on
hook and no call, so a constant in this table is only constant across the
states that were reachable without taking the line.
"""
from __future__ import annotations

# Ports whose idle value is not zero, all of them even and all below 0x80.
# 0x10, 0x12 and 0x14 are the board latches - hook relay, NVRAM strobe and the
# carrier-detect pair - so their values are board state rather than ASIC state.
# 0x42..0x56 are the DSP download window, which the supervisor writes in
# thousands and never reads; they idle high.
IDLE: dict[int, int] = {
    0x0A: 0xF7, 0x0C: 0x60, 0x0E: 0x07,
    0x10: 0x86, 0x12: 0x8A, 0x14: 0x7E,
    0x18: 0xFF, 0x1A: 0xFF, 0x1C: 0xFD, 0x1E: 0xFF,
    0x42: 0xFF, 0x46: 0xFF, 0x4A: 0xFF, 0x4E: 0xFF, 0x52: 0xFF, 0x56: 0xFF,
    0x58: 0x20, 0x5C: 0x0E, 0x60: 0x4B,
    0x64: 0x78, 0x66: 0x09, 0x68: 0x8F, 0x6A: 0xA7, 0x6C: 0xE8,
    0x70: 0xAA, 0x72: 0xB6, 0x74: 0x97, 0x76: 0x51, 0x78: 0x51,
    0x7A: 0x06, 0x7C: 0x4F, 0x7E: 0xB3,
}

DECODE_LIMIT = 0x80
DEFAULT = 0x00

# The four that moved between idle and `AT&T8` analogue loopback. 0x1c and
# 0x1e are the mailbox status pair and both move on bit 2, which is the bit the
# supervisor's mailbox interrupt acknowledges. 0x18 also varied *within* the
# active state, so it carries live signal rather than a settled level.
UNDER_LOAD: dict[int, tuple[int, ...]] = {
    0x18: (0xC0, 0xC6, 0xC7),
    0x1A: (0xC0,),
    0x1C: (0xF9,),
    0x1E: (0xFB,),
}

# Values that differ between the two captures of this board, so they are state
# rather than identity: 0x58, 0x60, 0x68, 0x6a and 0x70 read 0x06, 0x0b, 0x8d,
# 0xa3 and 0xae in artifacts/io-port-map/hardware-2016mhz/atglk2b.txt, taken
# when the unit ran stock 7.3.14. The rest of 0x64..0x7e matched across both,
# which is what makes that block look like fixed configuration.
STABLE_ACROSS_CAPTURES = (0x64, 0x66, 0x6C, 0x72, 0x74, 0x76, 0x78, 0x7A, 0x7C, 0x7E)


def idle_value(port: int, size: int = 1) -> int:
    """What the board returns for `port` with the modem idle and on hook.

    Above the decode limit the bus reads back the address on an even port and
    zero on an odd one; that is the absence of a device, and reproducing it is
    the point - firmware probing there should see what the board shows.
    """
    if port >= DECODE_LIMIT:
        low = port & 0xFF if not port & 1 else 0x00
    else:
        low = IDLE.get(port, DEFAULT) if not port & 1 else 0x00
    if size == 1:
        return low
    high = idle_value(port + 1, 1)
    return low | (high << 8)


def seed(size_aware: bool = False) -> dict[int, int]:
    """The decoded space as a `port -> value` map, for seeding `port_values`."""
    return {port: idle_value(port) for port in range(0, DECODE_LIMIT)}
