from __future__ import annotations

from dataclasses import dataclass
from hashlib import sha256
from pathlib import Path
import struct
from typing import Any

from .parameters import SECTOR_COUNT, SECTOR_SIZE, checksum


# A Courier flash ROM is the whole part, unlike an XMF, which carries only the
# application payload of an update. The image ends with the 80186 reset vector,
# so the map does not have to be assumed: the reset stub programs the chip
# select that decodes the ROM and then jumps into the boot block.
ROM_SIZE = 0x80000
RESET_VECTOR = 0xFFFF0

# The reset stub is
#   cli
#   mov dx, <chip select register>
#   mov ax, <start address>
#   out dx, ax
#   jmp far <boot segment>:<boot offset>
RESET_STUB = struct.Struct("<BBHBHBBHH")
RESET_CLI = 0xFA
RESET_MOV_DX = 0xBA
RESET_MOV_AX = 0xB8
RESET_OUT_DX_AX = 0xEF
RESET_JMP_FAR = 0xEA

# 80C186EB chip-select unit, addressed through the peripheral control block.
# Each of these holds a start or stop address in bits 15..6 and wait-state and
# ready configuration in bits 5..0.
UCS_START = 0xFFA4
UCS_STOP = 0xFFA6
LCS_START = 0xFFA0
LCS_STOP = 0xFFA2
RELOCATION_REGISTER = 0xFFA8
# The relocation register's bit 12 selects memory space and its low twelve bits
# are the block's address in units of 256 bytes.
RELOCATION_MEMORY_BIT = 0x1000

APPLICATION_OFFSET = 0
APPLICATION_SIGNATURE = b"INT80186 Modem Functions"
APPLICATION_SIGNATURE_WINDOW = 0x600


def _address(register: int) -> int:
    """Decode a chip-select start or stop register into a physical address."""
    return (register & 0xFFC0) << 4


class RomFormatError(ValueError):
    """Raised when a file does not match the recovered Courier ROM layout."""


@dataclass(frozen=True)
class ResetStub:
    """The 80186 reset vector's chip-select setup and boot entry."""

    chip_select_register: int
    chip_select_value: int
    boot_segment: int
    boot_offset: int

    @property
    def base(self) -> int:
        """Physical address the ROM decodes at, per its own chip select."""
        return _address(self.chip_select_value)

    @property
    def boot_physical(self) -> int:
        return self.boot_segment * 16 + self.boot_offset


@dataclass(frozen=True)
class CourierRom:
    """A complete Courier flash image, mapped where its reset stub says."""

    path: Path
    data: bytes
    reset: ResetStub

    @classmethod
    def load(cls, path: str | Path) -> "CourierRom":
        source = Path(path)
        data = source.read_bytes()
        if len(data) != ROM_SIZE:
            raise RomFormatError(
                f"expected a {ROM_SIZE:#x}-byte Courier ROM, got {len(data):#x}"
            )
        reset = cls._parse_reset(data)
        if reset.base + len(data) != 0x100000:
            raise RomFormatError(
                f"reset stub decodes the ROM at {reset.base:#07x}, which does not "
                "reach the reset vector at the top of the address space"
            )
        window = data[APPLICATION_OFFSET : APPLICATION_OFFSET + APPLICATION_SIGNATURE_WINDOW]
        if APPLICATION_SIGNATURE not in window:
            raise RomFormatError("80186 supervisor identification string not found")
        return cls(source.resolve(), data, reset)

    @staticmethod
    def _parse_reset(data: bytes) -> ResetStub:
        stub = data[ROM_SIZE - 16 : ROM_SIZE]
        try:
            (
                cli,
                mov_dx,
                register,
                mov_ax,
                value,
                out,
                jmp,
                offset,
                segment,
            ) = RESET_STUB.unpack(stub[: RESET_STUB.size])
        except struct.error as exc:  # pragma: no cover - fixed-size slice
            raise RomFormatError("reset vector is too short to hold the stub") from exc
        expected = (RESET_CLI, RESET_MOV_DX, RESET_MOV_AX, RESET_OUT_DX_AX, RESET_JMP_FAR)
        if (cli, mov_dx, mov_ax, out, jmp) != expected:
            raise RomFormatError(f"unrecognised reset stub at {RESET_VECTOR:#07x}")
        return ResetStub(register, value, segment, offset)

    @property
    def digest(self) -> str:
        return sha256(self.data).hexdigest()

    @property
    def load_base(self) -> int:
        return self.base

    # A ROM starts where the processor starts, not where an update payload is
    # entered, and its boot block dispatches its own software interrupts.
    entry_segment = 0xF000
    entry_offset = 0xFFF0
    entry_physical = RESET_VECTOR
    emulates_interrupts = True

    @property
    def base(self) -> int:
        return self.reset.base

    def at(self, physical: int, count: int) -> bytes:
        """Read from the ROM by physical address."""
        offset = physical - self.base
        if offset < 0 or offset + count > len(self.data):
            raise ValueError(f"{physical:#07x} is outside the ROM")
        return self.data[offset : offset + count]

    @property
    def parameter_sectors(self) -> list[dict[str, Any]]:
        """Report each parameter sector the search at 0xf8000 would walk.

        A part that has never been configured reads erased here, which is what
        the search expects to find programmed on a unit that has been.
        """
        from .parameters import CHECKSUM_OFFSET, SECTOR_BASE, VERSION_OFFSET

        sectors = []
        for index in range(SECTOR_COUNT):
            sector = self.at(SECTOR_BASE + index * SECTOR_SIZE, SECTOR_SIZE)
            stored = int.from_bytes(sector[CHECKSUM_OFFSET : CHECKSUM_OFFSET + 2], "little")
            sectors.append(
                {
                    "physical": SECTOR_BASE + index * SECTOR_SIZE,
                    "erased": sector == b"\xff" * SECTOR_SIZE,
                    "version": int.from_bytes(
                        sector[VERSION_OFFSET : VERSION_OFFSET + 4], "little"
                    ),
                    "checksum": stored,
                    "checksum_matches": stored == checksum(sector),
                }
            )
        return sectors

    def peripheral_writes(self) -> dict[str, list[list[int]]]:
        """Recover the two hardware setup tables the boot stub replays.

        The stub walks a word table with `out dx, ax` and a byte table with
        `out dx, al`, both addressed `cs:`-relative from the boot segment. The
        counts come from the `mov cx` immediates in the stub itself rather than
        from a fixed length.
        """
        boot = self.reset.boot_physical
        code = self.at(boot, 0x40)
        words = self._table(code, boot, size=2)
        bytes_ = self._table(code, boot, size=1, after=words[0] if words else 0)
        return {
            "word_writes": [[port, value] for port, value in words[1]],
            "byte_writes": [[port, value] for port, value in bytes_[1]],
        }

    def _table(
        self, code: bytes, boot: int, *, size: int, after: int = 0
    ) -> tuple[int, list[tuple[int, int]]]:
        """Find `mov si, imm; mov cx, imm` and read the table it points at."""
        marker = code.find(b"\xbe", after)
        while marker >= 0:
            if code[marker + 3 : marker + 4] == b"\xb9":
                source = int.from_bytes(code[marker + 1 : marker + 3], "little")
                count = int.from_bytes(code[marker + 4 : marker + 6], "little")
                stride = 2 + size
                table = self.at(self.reset.boot_segment * 16 + source, count * stride)
                entries = [
                    (
                        int.from_bytes(table[index : index + 2], "little"),
                        int.from_bytes(table[index + 2 : index + 2 + size], "little"),
                    )
                    for index in range(0, count * stride, stride)
                ]
                return marker + 6, entries
            marker = code.find(b"\xbe", marker + 1)
        return after, []

    def chip_selects(self) -> dict[str, dict[str, int]]:
        """Decode the flash and RAM chip selects out of the setup table."""
        writes = dict(
            (port, value) for port, value in self.peripheral_writes()["word_writes"]
        )
        selects: dict[str, dict[str, int]] = {}
        for name, start, stop in (
            ("flash", UCS_START, UCS_STOP),
            ("ram", LCS_START, LCS_STOP),
        ):
            if start in writes and stop in writes:
                selects[name] = {
                    "start": _address(writes[start]),
                    "stop": _address(writes[stop]),
                }
        if RELOCATION_REGISTER in writes:
            value = writes[RELOCATION_REGISTER]
            selects["peripheral_control_block"] = {
                "address": (value & 0x0FFF) << 8,
                "memory_mapped": int(bool(value & RELOCATION_MEMORY_BIT)),
            }
        return selects

    def describe(self) -> dict[str, Any]:
        return {
            "path": str(self.path),
            "size": len(self.data),
            "sha256": self.digest,
            "base": f"{self.base:#07x}",
            "reset_vector": f"{RESET_VECTOR:#07x}",
            "boot_entry": (
                f"{self.reset.boot_segment:04x}:{self.reset.boot_offset:04x}"
            ),
            "chip_selects": {
                name: {key: f"{value:#07x}" if key != "memory_mapped" else value
                       for key, value in fields.items()}
                for name, fields in self.chip_selects().items()
            },
            "peripheral_writes": self.peripheral_writes(),
            "parameter_sectors": self.parameter_sectors,
        }
