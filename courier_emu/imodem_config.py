"""The I-modem's configuration sector, and the CRC that seals it.

The modem keeps its settings in flash, not in the 93C66 the other Couriers
carry: sector SA8 of the Am29F400AT, at CPU `0xf8000`, 8 KiB holding **two
4 KiB pages** of the same record.  See docs/imodem-config-sector.md for how
that was found; this module is what a caller needs to read one or build one.

Each page is:

    +0x000            the record
    +0x1b0 .. +0x20a  the 91-byte ISDN settings block, copied verbatim to
                      2600:d476 - its first byte is the switch protocol,
                      which the accessor at c3570 requires to be an ASCII
                      digit '0'..'8' or stores as 0xff, which is what
                      ATI12 prints as "Invalid Switch Type"
    +0xffa .. +0xffd  01 00 <generation> 00
    +0xffe            the CRC, little endian

The CRC is the routine at `0xba80f`, transcribed below.  It is a **reflected
CRC-16-CCITT** - poly 0x1021, the algorithm usually called CRC-16/KERMIT - and
the transcription checks against that standard's own check value: the CRC of
`123456789` with seed 0 is `0x2189`.

The seed is `0x169e`, and how it was arrived at is worth stating because it is
the one number here that was solved for rather than read.  Both pages of a
captured sector differ in exactly two bytes, so if a single seed explains both
CRCs then `stored ^ crc(page, 0)` must be equal for the two - and it is,
`0x0267` both times.  Solving the resulting linear system over GF(2) gives
`0x169e`, and it reproduces both stored words exactly.  Being a seed rather
than an xor-out is not separable from the sector alone, since every page is
the same length; `0x0267` as an xor-out on a zero seed fits equally well.

What settles it is not the arithmetic but the firmware: a sector resealed with
this and a switch protocol of ASCII `4` boots, and `ATI12` prints
`Switch Protocol *W   4   ETSI NET3`.  The firmware accepts a record this
module built.

The field offsets below were recovered the other way round, and more cheaply:
set each setting over the AT interface, let the firmware write its own sector,
and diff it.  That also showed what the firmware wants for the settings to
take - it answers `*ATZ! Required*  :  Settings Have Changed` until a reset -
and it is the check on this module's CRC from the other side, since a sector
the *firmware* wrote verifies against `page_crc` too.
"""
from __future__ import annotations

import struct


SECTOR_ADDRESS = 0xF8000     # where the part answers, cpu side
SECTOR_SIZE = 0x2000         # SA8, the first 8 KiB boot sector
PAGE_SIZE = 0x1000
PAGES = SECTOR_SIZE // PAGE_SIZE

GENERATION_OFFSET = 0x02E
TRAILER_OFFSET = 0xFFA
CRC_OFFSET = 0xFFE
SEED = 0x169E

# The ISDN settings, as loaded into 2600:d476.
ISDN_BLOCK = 0x1B0
ISDN_BLOCK_LENGTH = 0x5B

# Field offsets within the block, recovered the way the user suggested and the
# only way that needs no guessing: set each one over the AT interface, let the
# firmware write the sector itself, and diff it. Every one of these was
# observed changing in response to its own command, and `ATI12` names it back.
SWITCH_PROTOCOL = 0           # *W, an ASCII digit '0'-'8'
BUS_CONFIGURATION = 1         # *M, '0' point to point, '1' multipoint
VOICE_DIRECTORY_NUMBER = 44   # *P1, ASCII, NUL terminated
VOICE_DIRECTORY_LENGTH = 8
VOICE_TEI = 86                # *T1, ASCII, '00' is automatic assignment
DATA_TEI = 87                 # *T2

# The switch types the firmware's own help page at 0xbf9f0 lists for *W=n.
SWITCH_PROTOCOLS = {
    0: "AT&T 5ESS Custom",
    1: "Northern Telecom DMS-100",
    2: "US National ISDN-1",
    3: "US National ISDN-2",
    4: "ETSI NET3",
    5: "Germany 1TR6",
    6: "France VNx",
    7: "Japan NTT INSnet64",
    8: "Australia TS.013",
}


def crc16(data: bytes, seed: int = SEED) -> int:
    """The routine at 0xba80f, instruction for instruction.

    Reflected CRC-16-CCITT. `crc16(b"123456789", 0)` is `0x2189`, which is
    that algorithm's published check value - the transcription's own proof.
    """
    dx = seed & 0xFFFF
    for byte in data:
        al = (byte ^ (dx & 0xFF)) & 0xFF             # xor al, dl
        dx = (dx & 0xFF00) | al                      # mov dl, al
        ax = (al << 4) & 0xFFFF                      # mov ah,0 ; shl ax, 4
        dx ^= ax                                     # xor dx, ax
        ax = (ax >> 1) & 0xFFFF                      # shr ax, 1
        dx = ((dx & 0xFF) << 8) | (dx >> 8)          # xchg dl, dh
        dx ^= ax                                     # xor dx, ax
        ax = ((ax << 4) & 0xFFFF) & 0x07FF           # shl ax, 4 ; and ah, 7
        dx ^= ax                                     # xor dx, ax
        ax = (ax << 1) & 0xFFFF                      # shl ax, 1
        dx = (dx & 0xFF00) | ((dx & 0xFF) ^ (ax >> 8))   # xor dl, ah
    return dx & 0xFFFF


def page_crc(page: bytes) -> int:
    """What a page's trailing word should hold."""
    if len(page) != PAGE_SIZE:
        raise ValueError(f"a page is {PAGE_SIZE} bytes, not {len(page)}")
    return crc16(page[:CRC_OFFSET])


def page_is_sealed(page: bytes) -> bool:
    return struct.unpack_from("<H", page, CRC_OFFSET)[0] == page_crc(page)


def seal(sector: bytes | bytearray) -> bytes:
    """Recompute both pages' CRCs, so the firmware will accept the record."""
    out = bytearray(sector)
    if len(out) != SECTOR_SIZE:
        raise ValueError(f"a sector is {SECTOR_SIZE} bytes, not {len(out)}")
    for page in range(PAGES):
        base = page * PAGE_SIZE
        value = page_crc(bytes(out[base:base + PAGE_SIZE]))
        struct.pack_into("<H", out, base + CRC_OFFSET, value)
    return bytes(out)


def read_isdn_block(sector: bytes, page: int = 0) -> bytes:
    """The 91 bytes the firmware copies to 2600:d476."""
    base = page * PAGE_SIZE + ISDN_BLOCK
    return bytes(sector[base:base + ISDN_BLOCK_LENGTH])


def set_isdn_byte(sector: bytes | bytearray, index: int, value: int) -> bytes:
    """Set one byte of the ISDN block in every page, and reseal."""
    if not 0 <= index < ISDN_BLOCK_LENGTH:
        raise ValueError(f"the ISDN block is {ISDN_BLOCK_LENGTH} bytes")
    out = bytearray(sector)
    for page in range(PAGES):
        out[page * PAGE_SIZE + ISDN_BLOCK + index] = value & 0xFF
    return seal(out)


def set_string(sector: bytes | bytearray, index: int, length: int,
               text: str) -> bytes:
    """Write an ASCII, NUL-terminated field - the form *P1 is stored in."""
    encoded = text.encode("ascii")
    if len(encoded) >= length:
        raise ValueError(f"{text!r} does not fit in {length} bytes with its NUL")
    out = bytearray(sector)
    for page in range(PAGES):
        base = page * PAGE_SIZE + ISDN_BLOCK + index
        out[base:base + length] = encoded + b"\x00" + bytes(
            [0xFF] * (length - len(encoded) - 1)
        )
    return seal(out)


def set_voice_directory_number(sector: bytes | bytearray, number: str) -> bytes:
    return set_string(sector, VOICE_DIRECTORY_NUMBER,
                      VOICE_DIRECTORY_LENGTH, number)


def set_switch_protocol(sector: bytes | bytearray, protocol: int) -> bytes:
    """Set `*W`, which the firmware stores and validates as an ASCII digit."""
    if protocol not in SWITCH_PROTOCOLS:
        raise ValueError(
            f"switch protocol must be one of {sorted(SWITCH_PROTOCOLS)}"
        )
    return set_isdn_byte(sector, SWITCH_PROTOCOL, ord(str(protocol)))
