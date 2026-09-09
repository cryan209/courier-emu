"""The XMD container: a whole 512 KiB Courier flash, chained-XOR obfuscated.

An XMD is `0x80` bytes of header followed by a complete flash image - not an
update payload like the XMF and XMP, but the whole part, boot block and 80186
reset stub included.  Sixteen of them sit in `docs/New Folder With Items`, and
until the obfuscation was recovered none of them could be read.

The obfuscation is a **chained XOR over 128-byte blocks**: every byte of a
block is XOR'd with one key byte, and the key for a block is the **last plain
byte of the block before it**.  The first block's key is `0x55`.  So decoding
runs forward with no known plaintext:

```
key = 0x55
for each 128-byte block:
    plain = block ^ key
    key = plain[-1]
```

That is not guesswork.  `IDSDL302.XMD` and `IDSDL302.ROM` are the same
firmware, one obfuscated and one a board dump, so the per-block key was
recovered by XOR and then tested against every candidate rule: `plain[n-1]`'s
last byte matches the key of block `n` in **199 of 199** blocks checked, where
sums, XORs and running offsets of either side match 0 to 4.  Decoding the whole
file that way reproduces the ROM dump to 524,284 of 524,288 bytes; the four
that differ are one 128-byte block, which is what a board's own serialisation
looks like beside the distributed image.

Every XMD in the tree decodes to an image whose reset stub parses, whose
supervisor signature is present, and whose DSP overlay table reads out.
"""
from __future__ import annotations

from dataclasses import dataclass
from hashlib import sha256
from pathlib import Path


HEADER_SIZE = 0x80
FLASH_SIZE = 0x80000
EXPECTED_SIZE = HEADER_SIZE + FLASH_SIZE
BLOCK_SIZE = 0x80
FIRST_KEY = 0x55

# The flash sits at the top of the 80186's megabyte, as CourierRom expects.
FLASH_PHYSICAL_BASE = 0x80000


class XmdFormatError(ValueError):
    """Raised when a file does not match the recovered Courier XMD layout."""


def decode(data: bytes, first_key: int = FIRST_KEY) -> bytes:
    """Undo the chained XOR. Each block's key is the previous block's last byte."""
    body = data[HEADER_SIZE:]
    out = bytearray()
    key = first_key
    for start in range(0, len(body), BLOCK_SIZE):
        block = bytes(byte ^ key for byte in body[start : start + BLOCK_SIZE])
        out += block
        key = block[-1]
    return bytes(out)


@dataclass(frozen=True)
class XmdImage:
    """An obfuscated whole-flash Courier image and its decoded body."""

    path: Path
    data: bytes
    flash: bytes

    @classmethod
    def load(cls, path: str | Path) -> "XmdImage":
        source = Path(path)
        data = source.read_bytes()
        if len(data) != EXPECTED_SIZE:
            raise XmdFormatError(
                f"expected a {EXPECTED_SIZE:#x}-byte Courier XMD, got {len(data):#x}"
            )
        flash = decode(data)
        # The 80186 reset stub is the check that the decode landed: the last
        # sixteen bytes are `cli / mov dx / mov ax / out dx, ax / jmp far`.
        if not (flash[-16] == 0xFA and flash[-9] == 0xEF and flash[-8] == 0xEA):
            raise XmdFormatError(
                "the decoded image does not end in an 80186 reset stub"
            )
        return cls(source.resolve(), data, flash)

    @property
    def header(self) -> bytes:
        return self.data[:HEADER_SIZE]

    @property
    def load_base(self) -> int:
        return FLASH_PHYSICAL_BASE

    @property
    def payload(self) -> bytes:
        return self.flash

    @property
    def digest(self) -> str:
        return sha256(self.data).hexdigest()

    def extract(self, target: str | Path) -> Path:
        """Write the decoded flash out, ready for CourierRom.load."""
        destination = Path(target)
        destination.write_bytes(self.flash)
        return destination

    def describe(self) -> dict[str, object]:
        return {
            "path": str(self.path),
            "digest": self.digest,
            "header": self.header[:16].hex(" "),
            "flash_bytes": len(self.flash),
            "load_base": FLASH_PHYSICAL_BASE,
            "reset_stub": self.flash[-16:].hex(" "),
        }
