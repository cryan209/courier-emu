from __future__ import annotations

from dataclasses import dataclass
from hashlib import sha256
from pathlib import Path
import re
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

# The DSP holds no resident program. The supervisor downloads one over the I/O
# ports at every boot, which is why a flash image carries the datapump and why
# a feature could be added to a shipped modem by replacing the image.
#
# The call site that starts that download names every parameter the extraction
# needs, so none of them is hardcoded: the 25 MHz supervisor keeps the same
# payload at a different offset behind the same instructions, and a fixed
# offset recovered from one image silently reads the wrong bytes out of another.
#
#     mov ax, 8000        ; entry, as a C52 program word address
#     call <reset>        ; reset the part and request that entry
#     mov ax, <start>     ; first source offset within the window below
#     mov cx, <end>       ; one past the last
#     call <downloader>
#
# and, inside the downloader, the source window itself:
#
#     mov ax, <segment>
#     mov es, ax
#
# Two independent checks agree on the result for the captured 20.16 MHz board:
# the C52 reset code sits at the offset this derives, and the resident mailbox
# sender lands inside the startup region identified separately.
DSP_ENTRY_WORD = 0x8000
DSP_CALL_SITE = re.compile(rb"\xb8(..)\xe8(..)\xb8(..)\xb9(..)\xe8(..)", re.S)
DSP_SOURCE_WINDOW = re.compile(rb"\xb8(..)\x8e\xc0", re.S)
# How far into the downloader to look for its own source window, and the span
# the call site and downloader both live in. Both are near calls, so caller and
# callee share one code segment.
DSP_DOWNLOADER_WINDOW = 0x120
# The overlay loader is table driven. It masks a 4-bit code, multiplies by the
# entry width, and adds the table base - `mov bl, 6 ; mul bl ; mov bx, imm16` -
# then picks a source segment by comparing that same code against 6, 7 and 8,
# falling through to the resident segment. Both are matched structurally rather
# than by address, because the table moves between builds.
DSP_OVERLAY_TABLE = re.compile(rb"\xb3(.)\xf6\xe3\xbb(..)", re.S)
DSP_OVERLAY_SEGMENT = re.compile(rb"\xb8(..)\x83\xfb(.)\x74", re.S)
CODE_SEGMENT_SIZE = 0x10000


@dataclass(frozen=True)
class DspDownload:
    """Where a ROM keeps its C52 program, read out of the code that sends it."""

    call_site: int
    reset: int
    downloader: int
    source_segment: int
    offset: int
    length: int
    entry_word: int

    @property
    def end(self) -> int:
        return self.offset + self.length

    def describe(self) -> dict[str, Any]:
        return {
            "call_site": f"{self.call_site:#07x}",
            "reset": f"{self.reset:#07x}",
            "downloader": f"{self.downloader:#07x}",
            "source_segment": f"{self.source_segment:#06x}",
            "flash_range": f"{self.offset:#07x}..{self.end:#07x}",
            "words": self.length // 2,
            "entry_word": f"{self.entry_word:#06x}",
        }


@dataclass(frozen=True)
class DspOverlay:
    """One row of the overlay table: where a C52 image lives and where it lands.

    The resident payload is a row of this same table, which is what identifies
    the rest of them - its row reproduces the download call site's own answer.
    """

    index: int
    source_segment: int
    offset: int
    length: int
    entry_word: int

    @property
    def end(self) -> int:
        return self.offset + self.length

    def describe(self) -> dict[str, Any]:
        return {
            "index": self.index,
            "source_segment": f"{self.source_segment:#06x}",
            "flash_range": f"{self.offset:#07x}..{self.end:#07x}",
            "words": self.length // 2,
            "entry_word": f"{self.entry_word:#06x}",
        }


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

    @property
    def dsp_download(self) -> "DspDownload | None":
        """The C52 payload's location, recovered from the download call site.

        A supervisor calls the downloader from more than one place - the
        captured board has three - so candidates are compared on what they say
        about the payload rather than on where they were found. A disagreement
        there means the byte pattern matched something that is not this call
        site, and a guess between two answers would hand the DSP the wrong
        program rather than fail visibly, so it raises instead.
        """
        candidates: list[DspDownload] = []
        for match in DSP_CALL_SITE.finditer(self.data[:CODE_SEGMENT_SIZE]):
            entry, _, start, end, _ = (
                struct.unpack("<H", match[index])[0] for index in range(1, 6)
            )
            if entry != DSP_ENTRY_WORD or end <= start:
                continue
            reset = (
                match.start(2) + 2 + struct.unpack("<h", match[2])[0]
            ) & 0xFFFF
            target = (
                match.start(5) + 2 + struct.unpack("<h", match[5])[0]
            ) & 0xFFFF
            window = DSP_SOURCE_WINDOW.search(
                self.data[target : target + DSP_DOWNLOADER_WINDOW]
            )
            if window is None:
                continue
            segment = struct.unpack("<H", window[1])[0]
            offset = (segment << 4) - self.base + start
            length = end - start
            if offset < 0 or offset + length > len(self.data) or length % 2:
                continue
            candidates.append(
                DspDownload(
                    match.start(), reset, target, segment, offset, length, entry
                )
            )
        if not candidates:
            return None
        def payload(download: DspDownload) -> tuple[int, ...]:
            return (
                download.source_segment,
                download.offset,
                download.length,
                download.entry_word,
            )

        if any(payload(other) != payload(candidates[0]) for other in candidates[1:]):
            raise RomFormatError(
                "the DSP download call site matched with conflicting parameters; "
                "refusing to choose between them"
            )
        return candidates[0]

    @property
    def dsp_overlays(self) -> tuple["DspOverlay", ...]:
        """Every C52 image the supervisor can send, resident and overlay alike.

        The resident payload is one row of the overlay table, so this is checked
        rather than asserted: the row matching `dsp_download` must be present, or
        the table was not found and nothing is returned. The table's length is
        not marked, and rows past its end can still look like valid ranges, so a
        row is kept only if the loader has a source segment for its index - it
        compares against 6, 7 and 8 - or it is the resident row the fall-through
        serves.
        """
        download = self.dsp_download
        if download is None:
            return ()
        head = self.data[:CODE_SEGMENT_SIZE]
        table = DSP_OVERLAY_TABLE.search(head)
        if table is None:
            return ()
        width = table[1][0]
        base = struct.unpack("<H", table[2])[0]
        segments = {
            struct.unpack("<H", match[2] + b"\x00")[0]: struct.unpack("<H", match[1])[0]
            for match in DSP_OVERLAY_SEGMENT.finditer(
                head[table.end() : table.end() + DSP_DOWNLOADER_WINDOW]
            )
        }
        found = []
        for index in range(0x10):
            row = base + width * index
            if row + 6 > len(head):
                break
            start, end, entry = struct.unpack_from("<3H", head, row)
            segment = segments.get(index, download.source_segment)
            offset = (segment << 4) - self.base + start
            length = end - start
            if length <= 0 or length % 2 or offset < 0 or offset + length > len(self.data):
                continue
            row_is_resident = (segment, offset, length, entry) == (
                download.source_segment, download.offset, download.length,
                download.entry_word)
            if index not in segments and not row_is_resident:
                continue
            found.append(DspOverlay(index, segment, offset, length, entry))
        resident = (download.source_segment, download.offset, download.length,
                    download.entry_word)
        if not any((o.source_segment, o.offset, o.length, o.entry_word) == resident
                   for o in found):
            return ()
        return tuple(found)

    def dsp_program_segments(self) -> tuple[tuple[int, bytes], ...]:
        """Return the C52 program-memory origin and bytes the ROM downloads.

        One segment, unlike an XMF's three: a ROM's supervisor makes a single
        download call, so what it sends is one contiguous run of words at the
        entry it requests. Whether the rest of the datapump region reaches the
        DSP by some other path is not established.
        """
        download = self.dsp_download
        if download is None:
            raise RomFormatError(
                "no DSP download call site found; this ROM's C52 payload "
                "cannot be located, so it cannot be attached to a DSP"
            )
        return ((download.entry_word, self.data[download.offset : download.end]),)

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
            "dsp_download": (
                self.dsp_download.describe() if self.dsp_download else None
            ),
        }
