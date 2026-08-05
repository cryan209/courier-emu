from __future__ import annotations

from dataclasses import dataclass, field
from pathlib import Path
from typing import Any


# The supervisor's persistent configuration lives in a 16 KiB parameter flash
# searched at physical 0xf8000, which the XMF update image does not carry. The
# search at 0x7e07c walks four 4 KiB sectors, checksums bytes 0x000..0xffd,
# compares against the word at 0xffe, and keeps the sector with the highest
# 32-bit version at 0xffa. The winner is copied to 0x0a06 one byte for one, so
# sector offset i lands at RAM 0x0a06 + i.
#
#   offset       RAM              role
#   0x00         0x0a06           flags: bit 0 skips the feature decode,
#                                 1 country, 2 [0x0a04], 3 [0x0a03]
#   0x01..0x06   0x0a07..0x0a0c   country, features, type2, type1, unused2,
#                                 unused1 - the six ATY14 fields, printed by
#                                 0x85250 from 0x0a0c down to 0x0a07
#   0x11..0x1c   0x0a17..0x0a22   serial number, 12 ASCII characters read as
#                                 9 at 0x0a17 plus 3 at 0x0a20 (0x835bb)
#   0x1d..0x2f   0x0a23..0x0a35   packed config, expanded at 0x64044 through
#                                 the (shift, mask) table at 0x63f8d into the
#                                 36 profile bytes 0x0932..0x0955
#   0x30..0x61   0x0a36..0x0a67   working-profile image, scattered at 0x6406f
#                                 to 0x08de + the offsets listed at 0x63fd6
#   0xffa..0xffd                  32-bit version, highest wins
#   0xffe..0xfff                  CRC-16/CCITT over 0x000..0xffd
SECTOR_SIZE = 0x1000
SECTOR_BASE = 0xF8000
SECTOR_COUNT = 4

FIELD_OFFSET = 0x01           # country, features, type2, type1, unused2, unused1
SERIAL_OFFSET = 0x11
SERIAL_LENGTH = 12
PACKED_OFFSET = 0x1D
PROFILE_OFFSET = 0x30
VERSION_OFFSET = 0x0FFA
CHECKSUM_OFFSET = 0x0FFE

# Both of these are the firmware's own power-on defaults, read back from RAM
# after a boot with no sector fitted and re-encoded into the packing the sector
# uses. Supplying them reproduces the profile the firmware would have built for
# itself, so a synthesised sector changes the ATY14 fields and the serial number
# without disturbing anything else.
PACKED_CONFIG = bytes.fromhex("11338840010401010100060000000000000000")
PROFILE_IMAGE = bytes.fromhex(
    "012b0d0a08023c02060e4632000100000a1113960501000814000900000000"
    "000000000000000f0000400000000001000a00"
)

# ATC8 feature bits, decoded at 0x7e024 through the five-entry table at 0x7e072.
#
# Bit 4 is labelled x2 in archived notes for older Courier firmware, but that is
# not what it does here. It is the only entry contributing [0x19d7] bit 0x20,
# and in this 2002 build that bit gates the ",V90" entry in the ATI7 options
# list at 0x77d47 and selects the 5608 product code at 0x82e7d. The "x2" string
# does sit in the options table at 733c:49d6, but nothing in the image ever
# loads it, so this firmware cannot report x2 at all.
FEATURE_BITS: dict[str, int] = {
    "hst": 0x01,
    "fax": 0x02,
    "terbo": 0x04,
    "v34": 0x08,
    "v90": 0x10,
}


def checksum(data: bytes) -> int:
    """CRC-16/CCITT as the per-byte update at 0x72930 computes it."""
    crc = 0xFFFF
    for byte in data[:CHECKSUM_OFFSET]:
        low = (byte ^ (crc & 0xFF)) & 0xFF
        crc = (crc & 0xFF00) | low
        value = (low << 4) & 0xFFFF
        crc ^= value
        value >>= 1
        crc = ((crc & 0xFF) << 8) | (crc >> 8)
        crc ^= value
        value = (value << 4) & 0x07FF
        crc ^= value
        value = (value << 1) & 0xFFFF
        crc = (crc & 0xFF00) | ((crc & 0xFF) ^ ((value >> 8) & 0xFF))
    return crc & 0xFFFF


def features_value(names: list[str] | tuple[str, ...]) -> int:
    value = 0
    for name in names:
        try:
            value |= FEATURE_BITS[name]
        except KeyError:
            known = ", ".join(FEATURE_BITS)
            raise ValueError(f"unknown feature {name!r}; known features are {known}") from None
    return value


@dataclass
class ParameterSector:
    """A synthesised Courier parameter sector.

    Dumping the real part is not practical, so this builds one the firmware
    accepts: the recovered field layout, the firmware's own default profile, and
    a matching checksum.
    """

    country: int = 0
    features: int = 0
    type1: int = 30
    type2: int = 7
    unused1: int = 0
    unused2: int = 0
    serial: str = ""
    version: int = 1
    # The flags byte gates each unpacked field, applying it when the bit is
    # clear: 0x7e01d feature decode, 0x7e03c country, 0x7e04f type2 into
    # [0x0a04], 0x7e05c type1 into [0x0a03]. Bit 3 keeps [0x0a03] at zero,
    # which leaves the flash defaults going to the working profile at 0x08df
    # rather than the stored profile at 0x095d. It also decides whether the
    # factory diagnostics exist: 0x8339f gates the ATY15 switch page on bit
    # 0x04 of [0x0a03], so a sector with bit 3 clear and type1 bit 0x04 set
    # is what makes that command answer instead of reporting ERROR.
    flags: int = 0x08
    packed_config: bytes = PACKED_CONFIG
    profile_image: bytes = PROFILE_IMAGE

    def __post_init__(self) -> None:
        for name in ("country", "features", "type1", "type2", "unused1", "unused2", "flags"):
            value = getattr(self, name)
            if not 0 <= value <= 0xFF:
                raise ValueError(f"{name} must fit in a byte, got {value}")
        if len(self.serial) > SERIAL_LENGTH:
            raise ValueError(f"serial number is at most {SERIAL_LENGTH} characters")
        if not self.serial.isascii():
            raise ValueError("serial number must be ASCII")
        if len(self.packed_config) != len(PACKED_CONFIG):
            raise ValueError(f"packed config must be {len(PACKED_CONFIG)} bytes")
        if len(self.profile_image) != len(PROFILE_IMAGE):
            raise ValueError(f"profile image must be {len(PROFILE_IMAGE)} bytes")

    @property
    def feature_names(self) -> list[str]:
        return [name for name, bit in FEATURE_BITS.items() if self.features & bit]

    def build(self) -> bytes:
        sector = bytearray(SECTOR_SIZE)
        sector[0] = self.flags
        # 0x85250 prints 0x0a0c first and 0x0a07 last, so the record order is
        # country, features, type2, type1, unused2, unused1.
        sector[FIELD_OFFSET : FIELD_OFFSET + 6] = bytes(
            (self.country, self.features, self.type2, self.type1, self.unused2, self.unused1)
        )
        if self.serial:
            # 0x77bb9 treats four 0xffff words as "no serial fitted"; padding
            # with spaces keeps a short serial printable.
            text = self.serial.ljust(SERIAL_LENGTH).encode("ascii")
            sector[SERIAL_OFFSET : SERIAL_OFFSET + SERIAL_LENGTH] = text
        else:
            sector[SERIAL_OFFSET : SERIAL_OFFSET + SERIAL_LENGTH] = b"\xff" * SERIAL_LENGTH
        sector[PACKED_OFFSET : PACKED_OFFSET + len(self.packed_config)] = self.packed_config
        sector[PROFILE_OFFSET : PROFILE_OFFSET + len(self.profile_image)] = self.profile_image
        sector[VERSION_OFFSET : VERSION_OFFSET + 4] = (self.version & 0xFFFFFFFF).to_bytes(
            4, "little"
        )
        sector[CHECKSUM_OFFSET:SECTOR_SIZE] = checksum(bytes(sector)).to_bytes(2, "little")
        return bytes(sector)

    def save(self, path: str | Path) -> None:
        Path(path).write_bytes(self.build())

    def status(self) -> dict[str, Any]:
        return {
            "country": self.country,
            "features": self.features,
            "feature_names": self.feature_names,
            "type1": self.type1,
            "type2": self.type2,
            "serial": self.serial,
            "version": self.version,
            "flags": self.flags,
            # 0x85250 prints the six fields in this order.
            "aty14": ",".join(
                f"{value:03d}"
                for value in (
                    self.unused1,
                    self.unused2,
                    self.type1,
                    self.type2,
                    self.features,
                    self.country,
                )
            ),
        }


def load_sector(path: str | Path) -> bytes:
    """Read a sector image, accepting a bare 4 KiB record."""
    data = Path(path).read_bytes()
    if len(data) != SECTOR_SIZE:
        raise ValueError(f"parameter sector must be {SECTOR_SIZE} bytes, got {len(data)}")
    return data
