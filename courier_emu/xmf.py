from __future__ import annotations

from dataclasses import dataclass
from hashlib import sha256
from pathlib import Path
import struct


HEADER_SIZE = 0x200
SUPERVISOR_OFFSET = 0x1B5E0
DSP_BOOT_OFFSET = 0x2F0
DSP_BOOT_SIZE = 0xEBB4
DSP_BOOT_ORIGIN = 0x0000
DSP_OVERLAY_OFFSET = DSP_BOOT_OFFSET + DSP_BOOT_SIZE
DSP_OVERLAY_SIZE = 0x135C
DSP_OVERLAY_ORIGIN = 0xDE83
DSP_RESIDENT_OFFSET = DSP_OVERLAY_OFFSET + DSP_OVERLAY_SIZE
DSP_RESIDENT_SIZE = SUPERVISOR_OFFSET - DSP_RESIDENT_OFFSET
DSP_RESIDENT_ORIGIN = 0x8000
FLASH_PHYSICAL_BASE = 0x40000
EXPECTED_SIZE = 0xB8000
ENTRY_SIGNATURE = bytes.fromhex("bd0b00e96411")
BOOT_SIGNATURE = bytes.fromhex("b800108ed033c08ed88ec0bec002")
ENTRY_SEGMENT = (FLASH_PHYSICAL_BASE + SUPERVISOR_OFFSET) >> 4
ENTRY_OFFSET = 0x410


class XmfFormatError(ValueError):
    """Raised when a file does not match the recovered Courier XMF layout."""


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

    def dsp_program_segments(self) -> tuple[tuple[int, bytes], ...]:
        """Return the recovered C52 program-memory origin and bytes for each segment."""
        return (
            (DSP_BOOT_ORIGIN, self.data[DSP_BOOT_OFFSET:DSP_OVERLAY_OFFSET]),
            (DSP_OVERLAY_ORIGIN, self.data[DSP_OVERLAY_OFFSET:DSP_RESIDENT_OFFSET]),
            (DSP_RESIDENT_ORIGIN, self.data[DSP_RESIDENT_OFFSET:self.supervisor_offset]),
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
                {
                    "origin": origin,
                    "file_offset": file_offset,
                    "size": len(segment),
                    "words": len(segment) // 2,
                }
                for (origin, segment), file_offset in zip(
                    self.dsp_program_segments(),
                    (DSP_BOOT_OFFSET, DSP_OVERLAY_OFFSET, DSP_RESIDENT_OFFSET),
                    strict=True,
                )
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
