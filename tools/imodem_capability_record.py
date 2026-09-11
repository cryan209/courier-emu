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

PAGE_SIZE = 0x1000
SECTOR_SIZE = 0x2000
VERSION_OFFSET = 0xFFC
TRAILER_OFFSET = 0xFFE
RESIDUE = 0xF0B8
SEED = 0xFFFF

# What the firmware writes into the shadow when no record validates. Starting
# from it means a record changes only the fields it names.
ABSENT = 0xFF


def crc_step(dx: int, byte: int) -> int:
    """One byte of the CRC at 0xc5415, instruction for instruction."""
    al = (byte ^ (dx & 0xFF)) & 0xFF          # lodsb ; xor ah,ah ; xor al,dl
    ah = al                                   # mov ah, al
    al = (al << 4) & 0xFF                     # mov cl,4 ; shl al,cl
    ah = (ah ^ al) & 0xFF                     # xor ah, al
    al = 0                                    # mov al, 0
    dl = (dx >> 8) & 0xFF                     # mov dl, dh
    dx = ((ah << 8) | dl) & 0xFFFF            # mov dh, ah
    ax = ((ah << 8) | al) & 0xFFFF
    ax = (ax >> 5) & 0xFFFF                   # mov cl,5 ; shr ax,cl
    dx ^= ax
    ax = (ax >> 7) & 0xFFFF                   # mov cl,7 ; shr ax,cl
    return (dx ^ ax) & 0xFFFF


def crc(data: bytes, dx: int = SEED) -> int:
    for byte in data:
        dx = crc_step(dx, byte)
    return dx


def seal(page: bytearray) -> bytearray:
    """Solve the trailing two bytes so the page reaches the residue.

    The CRC is a shift register over the whole page, so the trailer is found
    by carrying the state up to it once and trying both bytes - 65,536 pairs
    at two steps each, rather than re-CRCing the page 65,536 times.
    """
    if len(page) != PAGE_SIZE:
        raise ValueError(f"a page is {PAGE_SIZE} bytes, not {len(page)}")
    state = crc(bytes(page[:TRAILER_OFFSET]))
    for candidate in range(0x10000):
        low, high = candidate & 0xFF, candidate >> 8
        if crc_step(crc_step(state, low), high) == RESIDUE:
            page[TRAILER_OFFSET] = low
            page[TRAILER_OFFSET + 1] = high
            return page
    raise AssertionError("no trailer reaches the residue")


def build(fields: dict[int, int], version: int = 1) -> bytes:
    """A sector holding one sealed page, absent-valued except for `fields`."""
    page = bytearray(bytes([ABSENT]) * PAGE_SIZE)
    for offset, value in fields.items():
        page[offset] = value & 0xFF
    page[VERSION_OFFSET:VERSION_OFFSET + 2] = version.to_bytes(2, "little")
    seal(page)
    sector = bytearray(bytes([ABSENT]) * SECTOR_SIZE)
    sector[:PAGE_SIZE] = page
    return bytes(sector)


def _number(text: str) -> int:
    return int(text, 0)


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__,
                                     formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("output", help="sector file, for --flash-overlay 0xf8000=FILE")
    parser.add_argument("--set", action="append", default=[], metavar="OFFSET=VALUE",
                        help="set a page byte; numbers accept 0x notation")
    parser.add_argument("--version", type=_number, default=1,
                        help="the sequence word at 0xffc (default 1)")
    args = parser.parse_args(argv)

    fields: dict[int, int] = {}
    for assignment in args.set:
        key, separator, value = assignment.partition("=")
        if not separator:
            raise SystemExit(f"invalid assignment: {assignment!r}")
        fields[_number(key)] = _number(value)

    sector = build(fields, version=args.version)
    with open(args.output, "wb") as handle:
        handle.write(sector)
    print(f"wrote {args.output}: page residue {crc(sector[:PAGE_SIZE]):#06x}, "
          f"{len(fields)} field(s) set")
    return 0


if __name__ == "__main__":
    sys.exit(main())
