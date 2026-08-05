from __future__ import annotations

from dataclasses import dataclass
from hashlib import sha256
from pathlib import Path
import struct


# An XMP is the ISDN Courier's update payload. Unlike an XMF it carries no
# product text header, and its body is obfuscated: every payload byte is XOR'd
# with a single constant. The key is recoverable without any code analysis,
# because erased flash still dominates the image -- the pad byte at the top of
# the payload reads 0xba, and 0xff ^ 0xba is 0x45.
MAGIC = b"USR XMP\x00"
HEADER_SIZE = 0x80
PAYLOAD_SIZE = 0xB8000
EXPECTED_SIZE = HEADER_SIZE + PAYLOAD_SIZE
OBFUSCATION_KEY = 0x45
ERASED_BYTE = 0xFF

# The payload begins with a far-callable dispatch stub:
#   push ds / pusha / mov ax, 000d / mov ds, ax / mov si, 0000
#   mov bx, [si] / shl bx, 1 / cmp bx, 000a / ja short / jmp cs:[bx+001b]
BOOT_SIGNATURE = bytes.fromhex("1e60b80d008ed8be00008b1cd1e383fb")

# At payload offset 0x38 the firmware clears the 80386 debug registers. This is
# the cheapest positive identification of the 386 image: dr0..dr3 and dr7 do not
# exist on the 80186 supervisor that the XMF pipeline handles.
#   xor eax, eax / mov dr0, eax / mov dr1, eax
DEBUG_REGISTER_OFFSET = 0x38
DEBUG_REGISTER_SIGNATURE = bytes.fromhex("6633c00f23c00f23c8")

# The boot code installs its INT1 (#DB) handler as 4000:0148, so the payload
# decodes at physical 0x40000, the same flash base the 80186 board uses. Header
# word `load_hint` reads 0x40, which is consistent with that base in 4 KiB
# units, but nothing in the image confirms the unit -- see describe().
FLASH_PHYSICAL_BASE = 0x40000

# A programmed region is separated from the next by at least this much erased
# flash. Smaller 0xff runs occur inside ordinary code and tables.
REGION_GAP = 0x400


class XmpFormatError(ValueError):
    """Raised when a file does not match the recovered Courier XMP layout."""


@dataclass(frozen=True)
class XmpImage:
    """An obfuscated ISDN Courier update payload and its decoded body."""

    path: Path
    data: bytes
    payload: bytes

    @classmethod
    def load(cls, path: str | Path) -> "XmpImage":
        source = Path(path)
        data = source.read_bytes()
        if len(data) != EXPECTED_SIZE:
            raise XmpFormatError(
                f"expected a {EXPECTED_SIZE:#x}-byte Courier XMP, got {len(data):#x}"
            )
        if not data.startswith(MAGIC):
            raise XmpFormatError("missing USR XMP magic")
        payload = bytes(byte ^ OBFUSCATION_KEY for byte in data[HEADER_SIZE:])
        if not payload.startswith(BOOT_SIGNATURE):
            raise XmpFormatError(
                f"missing dispatch stub at payload offset 0; "
                f"key {OBFUSCATION_KEY:#04x} may be wrong for this image"
            )
        window = payload[
            DEBUG_REGISTER_OFFSET : DEBUG_REGISTER_OFFSET + len(DEBUG_REGISTER_SIGNATURE)
        ]
        if window != DEBUG_REGISTER_SIGNATURE:
            raise XmpFormatError(
                f"missing 80386 debug-register init at payload offset "
                f"{DEBUG_REGISTER_OFFSET:#x}"
            )
        return cls(source.resolve(), data, payload)

    @property
    def header(self) -> bytes:
        return self.data[:HEADER_SIZE]

    @property
    def digest(self) -> str:
        return sha256(self.data).hexdigest()

    @property
    def payload_digest(self) -> str:
        return sha256(self.payload).hexdigest()

    @property
    def load_base(self) -> int:
        return FLASH_PHYSICAL_BASE

    @property
    def format_word(self) -> int:
        """Header word at 0x08. Reads 0x0f01; its meaning is not recovered."""
        return struct.unpack_from("<H", self.data, 0x08)[0]

    @property
    def header_word(self) -> int:
        """Header word at 0x0a. Reads 0x26b9; not a checksum of the payload."""
        return struct.unpack_from("<H", self.data, 0x0A)[0]

    @property
    def load_hint(self) -> int:
        """Header dword at 0x0c. Reads 0x40; see FLASH_PHYSICAL_BASE."""
        return struct.unpack_from("<I", self.data, 0x0C)[0]

    @property
    def header_table(self) -> bytes:
        """The 0x70 bytes at header offset 0x10.

        Plaintext, not obfuscated, and clearly structured -- a handful of 16-bit
        values recur throughout it -- but its layout is not yet recovered, so it
        is exposed as raw bytes rather than decoded into fields.
        """
        return self.data[0x10:HEADER_SIZE]

    @property
    def last_programmed_offset(self) -> int:
        index = len(self.payload) - 1
        while index >= 0 and self.payload[index] == ERASED_BYTE:
            index -= 1
        return index

    def programmed_regions(self) -> tuple[tuple[int, int], ...]:
        """Return (start, end) payload spans separated by erased flash."""
        regions: list[tuple[int, int]] = []
        start: int | None = None
        index = 0
        size = len(self.payload)
        while index < size:
            if self.payload[index] == ERASED_BYTE:
                run = index
                while run < size and self.payload[run] == ERASED_BYTE:
                    run += 1
                if run - index >= REGION_GAP:
                    if start is not None:
                        regions.append((start, index))
                        start = None
                    index = run
                    continue
                if start is None:
                    start = index
                index = run
                continue
            if start is None:
                start = index
            index += 1
        if start is not None:
            regions.append((start, size))
        return tuple(regions)

    def file_to_physical(self, payload_offset: int) -> int:
        if not 0 <= payload_offset < len(self.payload):
            raise ValueError("payload offset outside image")
        return FLASH_PHYSICAL_BASE + payload_offset

    def physical_to_file(self, address: int) -> int:
        offset = address - FLASH_PHYSICAL_BASE
        if not 0 <= offset < len(self.payload):
            raise ValueError("physical address is not backed by this image")
        return offset

    def extract(self, directory: str | Path) -> tuple[Path, Path]:
        output = Path(directory)
        output.mkdir(parents=True, exist_ok=True)
        header_path = output / "header.bin"
        payload_path = output / "int80386.bin"
        header_path.write_bytes(self.header)
        payload_path.write_bytes(self.payload)
        return header_path, payload_path

    def describe(self) -> dict[str, object]:
        regions = self.programmed_regions()
        return {
            "path": str(self.path),
            "format": "xmp",
            "size": len(self.data),
            "sha256": self.digest,
            "header_size": HEADER_SIZE,
            "obfuscation_key": OBFUSCATION_KEY,
            "payload_size": len(self.payload),
            "payload_sha256": self.payload_digest,
            "format_word": self.format_word,
            "header_word": self.header_word,
            "load_hint": self.load_hint,
            "header_table_undecoded": self.header_table.hex(),
            "flash_physical_base": FLASH_PHYSICAL_BASE,
            "programmed_regions": [
                {
                    "start": start,
                    "end": end,
                    "size": end - start,
                    "physical": self.file_to_physical(start),
                }
                for start, end in regions
            ],
            "last_programmed_offset": self.last_programmed_offset,
        }
