"""Assembling a whole I-modem flash out of the update payload.

The payload is `0xb8000` bytes based at `0x40000`, and it splits at `0x80000`,
the flash window's base:

* **`0x40000`-`0x80000`** is the updater - dense (3.8% erased), and it holds the
  entry the harness uses, `4030:0000`.
* **`0x80000`-`0xf8000`** is the runtime firmware, 18.5% erased, and it is
  *already at its final addresses*.  Everything that executes during a run
  (`a45ef`, `a543b`, `b1269`) and every DSP image (`d0d60`-`eab0c`) is in it.
  That is not a coincidence of two bases: payload offset X sits at `0x40000+X`,
  and flash offset X-`0x40000` sits at `0x80000+X-0x40000` - the same address.

So the payload carries the whole 480 KiB of firmware, correctly placed, and the
one thing missing from a bootable part is the top **32 KiB**: `0xf8000`-`0xfffff`,
the boot block with the reset vector.  The updater never supplies it - it erases
at `0xf8100` and programs nothing above - because it does not replace the block
it boots from.

`build()` fills that gap with a **synthetic** boot block.  Two honesty notes,
because this is manufactured rather than recovered:

* The real block's contents are unknown.  What is written here is a reset
  vector and a far jump, nothing more; the 386EX bring-up is left to the
  payload's own initialiser, which is observed to do it in full (chip selects,
  both 8259s, the 8254, both SIOs, the port config) rather than guessed at.
* **The application's own entry point is not recovered.**  A real boot block
  jumps somewhere inside `0x80000`-`0xf8000`; this one jumps to the update
  initialiser at `4030:0000`, which only exists when the updater half is mapped
  too.  So the result boots from the reset vector like a board, and then runs
  the updater, not the application.
"""
from __future__ import annotations

from dataclasses import dataclass


FLASH_BASE = 0x80000
FLASH_SIZE = 0x80000
BOOT_BLOCK_OFFSET = 0x78000          # physical 0xf8000
RESET_VECTOR_OFFSET = 0x7FFF0        # physical 0xffff0
ERASED = 0xFF

# The updater's initialiser, and the harness's entry.
DEFAULT_ENTRY = (0x4030, 0x0000)


def far_jump(segment: int, offset: int) -> bytes:
    """`jmp far segment:offset` - the whole of the synthetic boot block."""
    return bytes((0xEA, offset & 0xFF, offset >> 8, segment & 0xFF, segment >> 8))


def build(payload: bytes, base: int = 0x40000, entry: tuple[int, int] = DEFAULT_ENTRY) -> bytes:
    """A 512 KiB flash: the payload's runtime half, plus a synthetic boot block."""
    start = FLASH_BASE - base
    if start < 0 or start > len(payload):
        raise ValueError(f"payload at {base:#x} does not reach the flash window")
    body = payload[start : start + FLASH_SIZE]
    rom = bytearray([ERASED]) * FLASH_SIZE
    rom[: len(body)] = body
    for index in range(BOOT_BLOCK_OFFSET, FLASH_SIZE):
        rom[index] = ERASED
    stub = far_jump(*entry)
    rom[RESET_VECTOR_OFFSET : RESET_VECTOR_OFFSET + len(stub)] = stub
    return bytes(rom)


@dataclass(frozen=True)
class ImodemRom:
    """A built flash, shaped so the ISDN harness can take it directly."""

    payload: bytes
    load_base: int = FLASH_BASE
    synthetic_boot_block: bool = True

    @classmethod
    def from_update(cls, image, entry: tuple[int, int] = DEFAULT_ENTRY) -> "ImodemRom":
        base, flat = image.flatten() if hasattr(image, "flatten") else (
            image.load_base,
            image.payload,
        )
        return cls(build(flat, base, entry))

    def describe(self) -> dict[str, object]:
        erased = self.payload.count(ERASED)
        return {
            "size": len(self.payload),
            "load_base": self.load_base,
            "erased_fraction": round(erased / len(self.payload), 4),
            "reset_vector": self.payload[RESET_VECTOR_OFFSET : RESET_VECTOR_OFFSET + 5].hex(" "),
            "boot_block": "synthetic",
        }
