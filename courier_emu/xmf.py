from __future__ import annotations

from dataclasses import dataclass
from hashlib import sha256
from pathlib import Path
import re
import struct


HEADER_SIZE = 0x200
SUPERVISOR_OFFSET = 0x1B5E0
FLASH_PHYSICAL_BASE = 0x40000
EXPECTED_SIZE = 0xB8000
ENTRY_SIGNATURE = bytes.fromhex("bd0b00e96411")
BOOT_SIGNATURE = bytes.fromhex("b800108ed033c08ed88ec0bec002")
ENTRY_SEGMENT = (FLASH_PHYSICAL_BASE + SUPERVISOR_OFFSET) >> 4
ENTRY_OFFSET = 0x410

# The DSP program area is not one flat load, and its origins are not a
# property of the container: the supervisor names them. It requests a
# destination through the same instructions a flash ROM's supervisor uses -
#
#     mov ax, <entry>     ; the C5x program word to load at and enter
#     call <reset>
#     mov ax, <start>     ; first source offset in the window below
#     mov cx, <end>       ; one past the last
#     call <downloader>
#
# and, inside the downloader, `mov ax, <segment> ; mov es, ax`. The further
# images come from a table the loader indexes - `mov bl, 6 ; mul bl ;
# mov bx, <base>` - whose rows are start, end and destination, with the source
# segment chosen by comparing the index against 6, 7 and 8 and falling through
# to the resident's.
#
# This is read rather than assumed because the two XMF families disagree about
# it. 2.1.1 and 2.2.05 place every image in `8000..ffff`; 2.3.x places them in
# `0000..7fff`, including one that loads at program `0000`. A fixed set of
# origins recovered from one of them silently mislocates the other, and an
# origin is what decides whether a branch target needs bit 15 masked off.
DSP_CALL_SITE = re.compile(rb"\xb8(..)\xe8(..)\xb8(..)\xb9(..)\xe8(..)", re.S)
DSP_SOURCE_WINDOW = re.compile(rb"\xb8(..)\x8e\xc0", re.S)
DSP_OVERLAY_TABLE = re.compile(rb"\xb3(.)\xf6\xe3\xbb(..)", re.S)
DSP_OVERLAY_SEGMENT = re.compile(rb"\xb8(..)\x83\xfb(.)\x74", re.S)
DSP_DOWNLOADER_WINDOW = 0x120
DSP_OVERLAY_WIDTH = 6
CODE_SEGMENT_SIZE = 0x10000


_SEGMENTS: dict[str, tuple["DspSegment", ...]] = {}


class XmfFormatError(ValueError):
    """Raised when a file does not match the recovered Courier XMF layout."""


@dataclass(frozen=True)
class DspSegment:
    """One image the supervisor downloads, as its own code describes it."""

    index: int
    origin: int
    file_offset: int
    size: int
    resident: bool

    @property
    def end(self) -> int:
        return self.file_offset + self.size

    @property
    def words(self) -> int:
        return self.size // 2

    def describe(self) -> dict[str, object]:
        return {
            "index": self.index,
            "origin": self.origin,
            "file_offset": self.file_offset,
            "size": self.size,
            "words": self.words,
            "resident": self.resident,
        }


@dataclass(frozen=True)
class XmfImage:
    path: Path
    data: bytes
    supervisor_offset: int = SUPERVISOR_OFFSET
    entry_offset_value: int = ENTRY_OFFSET

    @classmethod
    def load(cls, path: str | Path) -> "XmfImage":
        source = Path(path)
        data = source.read_bytes()
        if len(data) != EXPECTED_SIZE:
            raise XmfFormatError(
                f"expected a {EXPECTED_SIZE:#x}-byte Courier XMF, got {len(data):#x}"
            )
        if not data.startswith(b"Courier V.Everything"):
            raise XmfFormatError("missing Courier V.Everything text header")
        # 2.2.05 keeps the same DSP layout but moves the supervisor boundary
        # by 0x20 bytes. Locate the invariant boot block, then derive the
        # boundary instead of rejecting that otherwise compatible image.
        boot_offset = data.find(BOOT_SIGNATURE, HEADER_SIZE)
        if boot_offset < 0:
            raise XmfFormatError("missing 80186 boot signature")
        candidates = []
        for entry_offset in (0x410, 0x4C0):
            supervisor_offset = boot_offset - entry_offset
            if supervisor_offset < HEADER_SIZE:
                continue
            credit_window = data[supervisor_offset : supervisor_offset + 0x600]
            if b"INT80186 Modem Functions" in credit_window:
                candidates.append((supervisor_offset, entry_offset))
        if not candidates:
            raise XmfFormatError("could not locate the 80186 supervisor boundary")
        supervisor_offset, entry_offset = candidates[0]
        entry = data[supervisor_offset : supervisor_offset + 4]
        if entry not in (ENTRY_SIGNATURE[:4], b"GXE\n"):
            raise XmfFormatError(
                f"missing 80186 entry signature at file offset {supervisor_offset:#x}"
            )
        return cls(source.resolve(), data, supervisor_offset, entry_offset)

    @property
    def load_base(self) -> int:
        return FLASH_PHYSICAL_BASE

    @property
    def digest(self) -> str:
        return sha256(self.data).hexdigest()

    @property
    def header(self) -> bytes:
        return self.data[:HEADER_SIZE]

    @property
    def header_text(self) -> str:
        return self.header.rstrip(b"\x1a\x00\r\n").decode("ascii", "replace")

    @property
    def dsp(self) -> bytes:
        return self.data[HEADER_SIZE : self.supervisor_offset]

    @property
    def supervisor(self) -> bytes:
        return self.data[self.supervisor_offset :]

    @property
    def dsp_word_count(self) -> int:
        return len(self.dsp) // 2

    def dsp_words(self) -> tuple[int, ...]:
        return struct.unpack(f"<{self.dsp_word_count}H", self.dsp)

    def _resident_call_site(self) -> tuple[int, int, int] | None:
        """The resident download's source segment, file offset and length.

        A supervisor calls the downloader from several places - these images
        match five times - so the candidates are compared on what they say
        about the payload rather than on where they were found, and a
        disagreement is refused rather than chosen between.
        """
        head = self.supervisor[:CODE_SEGMENT_SIZE]
        candidates: set[tuple[int, int, int, int]] = set()
        for match in DSP_CALL_SITE.finditer(head):
            entry, _, start, end, _ = (
                struct.unpack("<H", match[index])[0] for index in range(1, 6)
            )
            if end <= start or (end - start) % 2:
                continue
            target = (match.start(5) + 2 + struct.unpack("<h", match[5])[0]) & 0xFFFF
            window = DSP_SOURCE_WINDOW.search(
                head[target : target + DSP_DOWNLOADER_WINDOW]
            )
            if window is None:
                continue
            segment = struct.unpack("<H", window[1])[0]
            offset = (segment << 4) - FLASH_PHYSICAL_BASE + start
            length = end - start
            if offset < HEADER_SIZE or offset + length > self.supervisor_offset:
                continue
            candidates.add((segment, offset, length, entry))
        if not candidates:
            return None
        if len(candidates) > 1:
            raise XmfFormatError(
                "the DSP download call site matched with conflicting parameters; "
                "refusing to choose between them"
            )
        return candidates.pop()

    def dsp_segments(self) -> tuple[DspSegment, ...]:
        """Every image the supervisor downloads, resident first.

        The resident is one row of the overlay table, so that is checked rather
        than asserted: if no row reproduces what the download call site
        independently says, the table was not found and only the resident is
        returned. The table's length is not marked and rows past its end still
        look like plausible ranges, so a row is kept only when the loader has a
        source segment for its index.
        """
        cached = _SEGMENTS.get(self.digest)
        if cached is not None:
            return cached
        call_site = self._resident_call_site()
        if call_site is None:
            raise XmfFormatError(
                "no DSP download call site found; this image's C5x payload "
                "cannot be located, so its program origins are unknown"
            )
        source_segment, offset, length, entry = call_site
        resident = DspSegment(-1, entry, offset, length, True)
        found: list[DspSegment] = []
        head = self.supervisor[:CODE_SEGMENT_SIZE]
        table = DSP_OVERLAY_TABLE.search(head)
        if table is not None and table[1][0] == DSP_OVERLAY_WIDTH:
            base = struct.unpack("<H", table[2])[0]
            sources = {
                match[2][0]: struct.unpack("<H", match[1])[0]
                for match in DSP_OVERLAY_SEGMENT.finditer(
                    head[table.end() : table.end() + DSP_DOWNLOADER_WINDOW]
                )
            }
            for index in range(0x10):
                row = base + DSP_OVERLAY_WIDTH * index
                if row + DSP_OVERLAY_WIDTH > len(head):
                    break
                start, end, origin = struct.unpack_from("<3H", head, row)
                source = sources.get(index)
                if source is None:
                    continue
                row_offset = (source << 4) - FLASH_PHYSICAL_BASE + start
                row_length = end - start
                if row_length <= 0 or row_length % 2:
                    continue
                if (
                    row_offset < HEADER_SIZE
                    or row_offset + row_length > self.supervisor_offset
                ):
                    continue
                found.append(
                    DspSegment(index, origin, row_offset, row_length, False)
                )
            # The resident is the fall-through row: the one with no source
            # segment of its own, matching what the call site already said.
            for index in range(0x10):
                row = base + DSP_OVERLAY_WIDTH * index
                if row + DSP_OVERLAY_WIDTH > len(head):
                    break
                if index in sources:
                    continue
                start, end, origin = struct.unpack_from("<3H", head, row)
                row_offset = (source_segment << 4) - FLASH_PHYSICAL_BASE + start
                if (row_offset, end - start, origin) == (offset, length, entry):
                    resident = DspSegment(index, entry, offset, length, True)
                    break
        segments = (resident, *found)
        _SEGMENTS[self.digest] = segments
        return segments

    def dsp_program_segments(self) -> tuple[tuple[int, bytes], ...]:
        """Return the C5x program-memory origin and bytes for each segment."""
        return tuple(
            (segment.origin, self.data[segment.file_offset : segment.end])
            for segment in self.dsp_segments()
        )

    @property
    def last_programmed_offset(self) -> int:
        index = len(self.data) - 1
        while index >= 0 and self.data[index] == 0xFF:
            index -= 1
        return index

    @property
    def entry_segment(self) -> int:
        return (FLASH_PHYSICAL_BASE + self.supervisor_offset) >> 4

    @property
    def entry_offset(self) -> int:
        return self.entry_offset_value

    @property
    def entry_physical(self) -> int:
        return (self.entry_segment << 4) + self.entry_offset

    @property
    def error_blink_target(self) -> int:
        displacement = struct.unpack_from("<h", self.data, self.supervisor_offset + 4)[0]
        error_entry = FLASH_PHYSICAL_BASE + self.supervisor_offset
        return error_entry + 6 + displacement

    def file_to_physical(self, file_offset: int) -> int:
        if not 0 <= file_offset < len(self.data):
            raise ValueError("file offset outside image")
        return FLASH_PHYSICAL_BASE + file_offset

    def physical_to_file(self, address: int) -> int:
        offset = address - FLASH_PHYSICAL_BASE
        if not 0 <= offset < len(self.data):
            raise ValueError("physical address is not backed by this image")
        return offset

    def extract(self, directory: str | Path) -> tuple[Path, Path, Path]:
        output = Path(directory)
        output.mkdir(parents=True, exist_ok=True)
        header_path = output / "header.bin"
        dsp_path = output / "tms320c52.bin"
        supervisor_path = output / "int80186.bin"
        header_path.write_bytes(self.header)
        dsp_path.write_bytes(self.dsp)
        supervisor_path.write_bytes(self.supervisor)
        return header_path, dsp_path, supervisor_path

    def describe(self) -> dict[str, object]:
        return {
            "path": str(self.path),
            "size": len(self.data),
            "sha256": self.digest,
            "header_size": HEADER_SIZE,
            "dsp_offset": HEADER_SIZE,
            "dsp_size": len(self.dsp),
            "dsp_words": self.dsp_word_count,
            "dsp_program_segments": [
                segment.describe() for segment in self.dsp_segments()
            ],
            "supervisor_offset": self.supervisor_offset,
            "supervisor_size": len(self.supervisor),
            "flash_physical_base": FLASH_PHYSICAL_BASE,
            "entry": f"{self.entry_segment:04x}:{self.entry_offset:04x}",
            "entry_physical": self.entry_physical,
            "error_entry": f"{ENTRY_SEGMENT:04x}:0000",
            "error_blink_target": self.error_blink_target,
            "last_programmed_offset": self.last_programmed_offset,
        }
