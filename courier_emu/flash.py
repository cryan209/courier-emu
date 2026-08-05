"""The parameter flash, and the boot-block service that programs it.

An XMF update image carries the application only. The flash driver lives in
the boot block above it, reached through `int 0x0a` with an ASCII service
letter in BL, so in a run built from an update payload every one of those
calls lands on a vector that is not there. `AT&W` is the visible consequence:
it assembles a sector image in RAM, asks for an erase, and stops.

The services this models are the two the parameter store needs:

    E (0x45)  erase the 4 KiB sector selected by ES
    W (0x57)  program the word in AX at ES:DI, then advance DI

Both come from the store's own writer at 0x7dfa8: it blank-checks the
destination at 0x7e0e3, erases when that fails, then walks the assembled
image a word at a time. S (0x53) and L (0x4c) belong to the firmware-update
and block-lock paths and are deliberately not modelled - a run that reaches
them stops the way it always did, rather than continuing on a guess.

The store itself is four 4 KiB sectors at 0xf8000, each ending in a 32-bit
version and a CRC. `parameters.py` documents the layout and builds one; this
keeps a whole flash part so the firmware's own writer can rotate between
sectors as it was designed to.
"""

from __future__ import annotations

from dataclasses import dataclass, field
from pathlib import Path
from typing import Any

from .parameters import (
    CHECKSUM_OFFSET,
    SECTOR_BASE,
    SECTOR_COUNT,
    SECTOR_SIZE,
    VERSION_OFFSET,
    checksum,
)

FLASH_SIZE = SECTOR_SIZE * SECTOR_COUNT
ERASED_BYTE = 0xFF

SERVICE_ERASE = 0x45  # 'E'
SERVICE_WRITE = 0x57  # 'W'


@dataclass
class ParameterFlash:
    """A 16 KiB parameter part with erase-then-program semantics."""

    data: bytearray = field(
        default_factory=lambda: bytearray([ERASED_BYTE] * FLASH_SIZE)
    )
    path: Path | None = None
    erases: int = 0
    programmed_words: int = 0
    # A program can only clear bits. Counting the ones that would have to be
    # set says the firmware wrote to a sector it had not erased, which on the
    # part itself would leave the old value behind.
    refused_bits: int = 0

    @classmethod
    def load(cls, path: str | Path) -> ParameterFlash:
        """Open a flash image, creating an erased one if it is not there."""
        location = Path(path)
        if not location.exists():
            return cls(path=location)
        raw = location.read_bytes()
        if len(raw) == SECTOR_SIZE:
            # A single sector, as the `parameters` subcommand writes it.
            data = bytearray([ERASED_BYTE] * FLASH_SIZE)
            data[:SECTOR_SIZE] = raw
        elif len(raw) == FLASH_SIZE:
            data = bytearray(raw)
        else:
            raise ValueError(
                f"parameter flash must be {SECTOR_SIZE} or {FLASH_SIZE} bytes, "
                f"got {len(raw)}"
            )
        return cls(data=data, path=location)

    def sector_of(self, offset: int) -> int:
        return offset // SECTOR_SIZE

    def erase_sector(self, offset: int) -> tuple[int, int]:
        """Erase the sector containing this offset; return its span."""
        start = (offset // SECTOR_SIZE) * SECTOR_SIZE
        self.data[start : start + SECTOR_SIZE] = bytes(
            [ERASED_BYTE] * SECTOR_SIZE
        )
        self.erases += 1
        return start, SECTOR_SIZE

    def program_word(self, offset: int, value: int) -> int:
        """Program one little-endian word, returning what the part now holds."""
        old = int.from_bytes(self.data[offset : offset + 2], "little")
        programmed = old & value
        self.refused_bits += bin(value & ~old & 0xFFFF).count("1")
        self.data[offset : offset + 2] = programmed.to_bytes(2, "little")
        self.programmed_words += 1
        return programmed

    def save(self) -> None:
        if self.path is not None:
            self.path.write_bytes(bytes(self.data))

    def sectors(self) -> list[dict[str, Any]]:
        report = []
        for index in range(SECTOR_COUNT):
            sector = bytes(
                self.data[index * SECTOR_SIZE : (index + 1) * SECTOR_SIZE]
            )
            stored = int.from_bytes(
                sector[CHECKSUM_OFFSET : CHECKSUM_OFFSET + 2], "little"
            )
            report.append(
                {
                    "erased": sector == bytes([ERASED_BYTE] * SECTOR_SIZE),
                    "version": int.from_bytes(
                        sector[VERSION_OFFSET : VERSION_OFFSET + 4], "little"
                    ),
                    "checksum": f"{stored:#06x}",
                    "checksum_valid": stored == checksum(sector[:CHECKSUM_OFFSET]),
                }
            )
        return report

    def status(self) -> dict[str, Any]:
        return {
            "base": f"{SECTOR_BASE:#07x}",
            "bytes": FLASH_SIZE,
            "path": str(self.path) if self.path else None,
            "erases": self.erases,
            "programmed_words": self.programmed_words,
            "refused_bits": self.refused_bits,
            "sectors": self.sectors(),
        }
