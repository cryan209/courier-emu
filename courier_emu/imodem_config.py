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

The field offsets below agree by two independent routes: ATI12's descriptor
table names every field address, and isolated AT command + AT&W sessions put
the SPIDs, both directory-number channels, TEIs and dialing mode at those
addresses.  The pages written by the firmware verify against `page_crc`, too.
"""
from __future__ import annotations

import struct
from pathlib import Path

from .flash_device import FLASH_BASE


SECTOR_ADDRESS = 0xF8000     # where the part answers, cpu side
SECTOR_SIZE = 0x2000         # SA8, the first 8 KiB boot sector
PAGE_SIZE = 0x1000
PAGES = SECTOR_SIZE // PAGE_SIZE

GENERATION_OFFSET = 0x02E
TRAILER_OFFSET = 0xFFA
CRC_OFFSET = 0xFFE
SEED = 0x169E

# The part of the flash an update does not carry, and therefore the part that
# survives one: the Am29F400AT's three top boot sectors, CPU 0xf8000-0xfffff.
#
# The NAC payload ends at 0xf8000 exactly (0x40000 + 0xb8000), so everything
# below this is the firmware image and is reloaded from the image every boot;
# everything at or above it is the part's own non-volatile store. SA8 holds the
# configuration record described above, and an `AT&W` run writes SA9's two
# pages as well - the sealed pages observed at 0x7a000 and 0x7b000. SA10 is not
# written by anything seen so far, and is carried anyway because it is on the
# same side of the payload boundary and guessing it empty would be a claim.
NVRAM_BASE = 0xF8000
NVRAM_SIZE = 0x8000
DEFAULT_NVRAM_FILE = "flashnvram.sav"


def nvram_from_flash(contents: bytes) -> bytes:
    """Cut the non-volatile region out of a whole flash window."""
    offset = NVRAM_BASE - FLASH_BASE
    region = bytes(contents[offset:offset + NVRAM_SIZE])
    return region + b"\xff" * (NVRAM_SIZE - len(region))


def load_nvram(path: Path | str) -> bytes | None:
    """Read a saved store, or None if there is not one yet.

    Short files are padded with erased bytes and long ones truncated, so a
    store written by an earlier version of this harness still loads.
    """
    file = Path(path)
    if not file.exists():
        return None
    data = file.read_bytes()[:NVRAM_SIZE]
    return data + b"\xff" * (NVRAM_SIZE - len(data))


def save_nvram(path: Path | str, contents: bytes) -> None:
    """Write the non-volatile region of a flash window out."""
    Path(path).write_bytes(nvram_from_flash(contents))


# The unit's identity, near the front of the record. The firmware's own
# printer names both: at cd270 it loads bx with 0xd2e6 before the literal
# "MAC " and bx with 0xd2d7 before "Serial Number ", so those are where they
# live in RAM - and painting the sector shows d2d7 loaded from page offset
# 0x011 and d2e6 from 0x020, contiguous.
# ATI7 prints the serial as twelve characters: writing thirteen and reading
# the report back gives twelve, so twelve is the field. The copied span runs
# the full fifteen bytes to the MAC field, and what the last three carry is
# not established.
SERIAL_NUMBER = 0x011
SERIAL_NUMBER_LENGTH = 12
SERIAL_NUMBER_SPAN = 15
MAC_ADDRESS = 0x020
MAC_ADDRESS_LENGTH = 8

# ATY14 is the factory configuration header immediately following the
# absent-field mask.  The handler at 0xcd19e reads d2cc back through d2c7,
# printing each byte as decimal.  Since the whole selected page is copied to
# 2600:d2c6, those are page offsets 0x006 back through 0x001.  Its guard at
# 0xcd1c6 prints only five commas when offsets 0x000..0x004 are all erased;
# that is the familiar missing-factory-record response, not six zero values.
ATY14_FIELDS = 0x001
ATY14_FIELD_COUNT = 6

# The ISDN settings, as loaded into 2600:d476.
ISDN_BLOCK = 0x1B0
ISDN_BLOCK_LENGTH = 0x5B

# The block's field offsets, read off the firmware's own ATI12 descriptor
# table at 0xc4570-0xc4700 rather than diffed out of a run. Each row there is
# `80 83 <label> <descriptor>`, and a settings row's descriptor is
# `01 <lo> d4` - the RAM address 2600:d4<lo> the row displays. Subtracting the
# block's own base, d476, turns each into an index:
#
#     *W  d476  0      *S1 d478  2      *P1 d4a2  44     *T1 d4cc  86
#     *M  d477  1      *S2 d48d  23     *P2 d4b7  65     *T2 d4ce  88
#                                                        *O  d4d0  90
#
# The spacings give the field widths, and they account for the block exactly:
# 1 + 1 + 21 + 21 + 21 + 21 + 2 + 2 + 1 = 91, which is the checksummed length
# at c4ecb. That total is the check on the reading - a wrong offset anywhere
# would leave a gap or an overlap.
SWITCH_PROTOCOL = 0           # *W, an ASCII digit '0'-'8'
BUS_CONFIGURATION = 1         # *M, '0' point to point, '1' multipoint
VOICE_SPID = 2                # *S1, ASCII, NUL terminated
DATA_SPID = 23                # *S2
VOICE_DIRECTORY_NUMBER = 44   # *P1, the ADP directory number
DATA_DIRECTORY_NUMBER = 65    # *P2, the data port directory number
NUMBER_LENGTH = 21            # what all four of those fields span
VOICE_TEI = 86                # *T1, two ASCII digits, '00' is automatic
DATA_TEI = 88                 # *T2
TEI_LENGTH = 2
DIALING_MODE = 90             # *O

# The data-bearer selector is outside the 91-byte ATI12 block.  Seven
# isolated ``AT*V2=n`` + ``AT&W`` sessions wrote the value literally here:
# the only record difference between the sealed generations, apart from the
# generation and CRC, was 00..06 at page offset 0x25f.
DATA_BEARER = 0x25F           # *V2, a binary value (not an ASCII digit)
DATA_BEARERS = {
    0: "Auto Detect",
    1: "V.120",
    2: "V.110",
    3: "Modem/Fax Emulation",
    4: "Clear Channel",
    5: "Auto Mode PPP",
    6: "X.75",
}

# The dialing mode's own renderer at 0xc3304 is four instructions of
# specification: it reads d4d0, clamps anything outside '0'..'1' to '2', and
# indexes a three-entry table. So the field is ASCII and there are exactly
# two valid values - which is why an unset 0xff reads back as Invalid Value.
DIALING_MODES = {
    0: "En-Bloc mode",
    1: "Overlap Sending mode",
}

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


def read_serial_number(sector: bytes, page: int = 0) -> bytes:
    """The twelve serial characters ATI7 prints from 2600:d2d7."""
    base = page * PAGE_SIZE + SERIAL_NUMBER
    return bytes(sector[base:base + SERIAL_NUMBER_LENGTH])


def set_serial_number(sector: bytes | bytearray, serial: str) -> bytes:
    """Set ATI7's fixed-width factory serial field in both pages."""
    try:
        encoded = serial.encode("ascii")
    except UnicodeEncodeError:
        raise ValueError("serial number must be ASCII") from None
    if len(encoded) > SERIAL_NUMBER_LENGTH:
        raise ValueError(
            f"serial number is at most {SERIAL_NUMBER_LENGTH} characters"
        )
    return set_record_bytes(
        sector, SERIAL_NUMBER, encoded.ljust(SERIAL_NUMBER_LENGTH, b" ")
    )


def read_aty14(sector: bytes, page: int = 0) -> tuple[int, ...] | None:
    """Return ATY14's six values in display order, or None for `,,,,,`.

    The page stores fields 1 through 6 in ascending order and the command
    prints them in reverse.  The firmware treats an erased mask plus first
    four fields as absent even though fields five and six are not tested.
    """
    base = page * PAGE_SIZE + ATY14_FIELDS
    stored = bytes(sector[base:base + ATY14_FIELD_COUNT])
    if sector[page * PAGE_SIZE:page * PAGE_SIZE + 5] == b"\xff" * 5:
        return None
    return tuple(reversed(stored))


def set_aty14(
    sector: bytes | bytearray, values: tuple[int, ...] | list[int]
) -> bytes:
    """Set the six factory fields using the order displayed by ATY14."""
    if len(values) != ATY14_FIELD_COUNT:
        raise ValueError(f"ATY14 requires {ATY14_FIELD_COUNT} values")
    if any(not 0 <= value <= 0xFF for value in values):
        raise ValueError("ATY14 values must fit in a byte")
    return set_record_bytes(sector, ATY14_FIELDS, bytes(reversed(values)))


def read_mac_address(sector: bytes, page: int = 0) -> bytes:
    """The 8 bytes the firmware copies to 2600:d2e6."""
    base = page * PAGE_SIZE + MAC_ADDRESS
    return bytes(sector[base:base + MAC_ADDRESS_LENGTH])


def read_data_bearer(sector: bytes, page: int = 0) -> int:
    """Read the binary ``*V2`` selector from a configuration page."""
    return sector[page * PAGE_SIZE + DATA_BEARER]


def set_record_bytes(sector: bytes | bytearray, offset: int,
                     data: bytes) -> bytes:
    """Write raw bytes at a page offset in every page, and reseal."""
    if offset + len(data) > TRAILER_OFFSET:
        raise ValueError("that would run into the trailer")
    out = bytearray(sector)
    for page in range(PAGES):
        base = page * PAGE_SIZE + offset
        out[base:base + len(data)] = data
    return seal(out)


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
    return set_string(sector, VOICE_DIRECTORY_NUMBER, NUMBER_LENGTH, number)


def set_data_directory_number(sector: bytes | bytearray, number: str) -> bytes:
    return set_string(sector, DATA_DIRECTORY_NUMBER, NUMBER_LENGTH, number)


def set_voice_spid(sector: bytes | bytearray, spid: str) -> bytes:
    return set_string(sector, VOICE_SPID, NUMBER_LENGTH, spid)


def set_data_spid(sector: bytes | bytearray, spid: str) -> bytes:
    return set_string(sector, DATA_SPID, NUMBER_LENGTH, spid)


def set_dialing_mode(sector: bytes | bytearray, mode: int) -> bytes:
    """Set `*O`. Unset, it reads back as `Invalid Value`, and ATI12 says so."""
    if mode not in DIALING_MODES:
        raise ValueError(f"dialing mode must be one of {sorted(DIALING_MODES)}")
    return set_isdn_byte(sector, DIALING_MODE, ord(str(mode)))


def set_data_bearer(sector: bytes | bytearray, bearer: int) -> bytes:
    """Set ``*V2`` in both pages, in the literal binary form the modem writes."""
    if bearer not in DATA_BEARERS:
        raise ValueError(f"data bearer must be one of {sorted(DATA_BEARERS)}")
    return set_record_bytes(sector, DATA_BEARER, bytes([bearer]))


def set_switch_protocol(sector: bytes | bytearray, protocol: int) -> bytes:
    """Set `*W`, which the firmware stores and validates as an ASCII digit."""
    if protocol not in SWITCH_PROTOCOLS:
        raise ValueError(
            f"switch protocol must be one of {sorted(SWITCH_PROTOCOLS)}"
        )
    return set_isdn_byte(sector, SWITCH_PROTOCOL, ord(str(protocol)))
