#!/usr/bin/env python3
"""Build the product-capability record the I-modem looks for at 0xf8000.

This is the record whose absence makes every AT command answer NO CARRIER.
See docs/imodem-at-interface.md for that chain; this tool is the format.

**The format is recovered and verified; the field values are not.** The
firmware's own loader accepts a record built here - it validates, it is
preferred by version, and its bytes arrive at 2600:d2c6 - which is what
establishes the CRC transcription and the layout. What each field should
*hold* on a real unit is not known, and guessing is how you get a worse
machine rather than a better one: setting d2c9 bit 0 makes the firmware mask
IRQ3 and stop talking altogether.

How the firmware reads it, from `0xc532b`:

* four 0x1000-byte pages are walked from segment f800 (physical 0xf8000);
* each is validated at `0xc53fd` - a CRC-16 over the whole page, seeded
  0xffff, whose residue must be **0xf0b8**;
* `0xc5372` keeps the one with the highest word at offset 0xffc;
* the winner is copied verbatim to 2600:d2c6..e2c5;
* if none validates, `0xc5312` fills that 4 KiB with 0xff instead.

Because the page lands whole at d2c6, the page's own offsets are the fields:

    [0x000] -> d2c6   "field absent" mask: bit 1 skips [2], bit 2 skips [3],
                      bit 3 skips [4]
    [0x001] -> d2c7   masked against a table at cs:04ac to build the options
                      byte at e358
    [0x002] -> d2c8   copied on to c8e4
    [0x003] -> d2c9   copied on to d2c5, whose bit 0 gates the one site
                      (0xc83d0) that can set [e770] bit 2
    [0x004] -> d2ca   copied on to d2c4, ATI7's " MODEM" suffix
    [0xffc] version/sequence word
    [0xffe] the CRC trailer this tool solves for
"""
from __future__ import annotations

import argparse
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent.parent))

from courier_emu.imodem_config import (          # noqa: E402
    CRC_OFFSET as TRAILER_OFFSET,
    PAGES,
    PAGE_SIZE,
    SECTOR_SIZE,
    page_is_sealed,
    seal,
    set_aty14,
    set_serial_number,
)

VERSION_OFFSET = 0xFFC

# What the firmware writes into the shadow when no record validates, from
# 0xc5312. Starting from it means a record changes only the fields it names.
ABSENT = 0xFF


# The two CRCs are the same check. courier_emu.imodem_config.crc16 is the
# routine at 0xba80f -- reflected CRC-16-CCITT -- storing its value at 0xffe;
# the loader's validator at 0xc53fd instead runs its own pass over the whole
# page including that trailer and requires the residue 0xf0b8. Sealing with
# either satisfies the other, trailer byte for trailer byte, so the sealing
# here is simply the module's.


def build(fields: dict[int, int], version: int = 1) -> bytes:
    """A sector holding one sealed page, absent-valued except for `fields`."""
    sector = bytearray(bytes([ABSENT]) * SECTOR_SIZE)
    for offset, value in fields.items():
        sector[offset] = value & 0xFF
    sector[VERSION_OFFSET:VERSION_OFFSET + 2] = version.to_bytes(2, "little")
    return seal(bytes(sector))


def _number(text: str) -> int:
    return int(text, 0)


def _aty14(text: str) -> tuple[int, ...]:
    try:
        values = tuple(
            int(value.strip(), 16)
            if value.strip().lower().startswith("0x")
            else int(value.strip(), 10)
            for value in text.split(",")
        )
    except ValueError:
        raise argparse.ArgumentTypeError(
            "ATY14 values must be six decimal or 0x-prefixed bytes"
        ) from None
    if len(values) != 6 or any(not 0 <= value <= 0xFF for value in values):
        raise argparse.ArgumentTypeError(
            "ATY14 values must be exactly six bytes in display order"
        )
    return values


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__,
                                     formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("output", help="sector file, for --flash-overlay 0xf8000=FILE")
    parser.add_argument("--set", action="append", default=[], metavar="OFFSET=VALUE",
                        help="set a page byte; numbers accept 0x notation")
    parser.add_argument("--version", type=_number, default=1,
                        help="the sequence word at 0xffc (default 1)")
    parser.add_argument(
        "--aty14", type=_aty14, metavar="V6,V5,V4,V3,V2,V1",
        help="set the six factory bytes in the order ATY14 displays them",
    )
    parser.add_argument(
        "--serial", metavar="TEXT",
        help="set ATI7's factory serial number (ASCII, at most 12 characters)",
    )
    args = parser.parse_args(argv)

    fields: dict[int, int] = {}
    for assignment in args.set:
        key, separator, value = assignment.partition("=")
        if not separator:
            raise SystemExit(f"invalid assignment: {assignment!r}")
        fields[_number(key)] = _number(value)

    sector = build(fields, version=args.version)
    if args.aty14 is not None:
        sector = set_aty14(sector, args.aty14)
    if args.serial is not None:
        sector = set_serial_number(sector, args.serial)
    with open(args.output, "wb") as handle:
        handle.write(sector)
    sealed = [page_is_sealed(sector[i * PAGE_SIZE:(i + 1) * PAGE_SIZE])
              for i in range(PAGES)]
    additions = len(fields) + (6 if args.aty14 is not None else 0)
    additions += 1 if args.serial is not None else 0
    print(f"wrote {args.output}: pages sealed {sealed}, "
          f"{additions} field(s) set")
    return 0


if __name__ == "__main__":
    sys.exit(main())
