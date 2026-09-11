"""Assembling a whole I-modem flash out of the update payload.

Historical layout hypothesis below: the VRTX trace now proves that the lower
payload contains the kernel and eight task entries needed by the demonstrated
startup path, and a400:0008 is the TID_MODEM task entry. Do not interpret the
updater/runtime split here as an established hardware boot mapping. See
docs/imodem-vrtx-startup.md. The synthetic image builder remains experimental.

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
* The block jumps straight to the application's cold start.  A real one would
  do the 386EX bring-up first; this one does not, so anything the application
  expects the boot block to have configured is not configured.  Pass
  `UPDATER_ENTRY` to boot the update program instead, which brings the chip up
  itself.
"""
from __future__ import annotations

from dataclasses import dataclass


FLASH_BASE = 0x80000
FLASH_SIZE = 0x80000
BOOT_BLOCK_OFFSET = 0x78000          # physical 0xf8000
RESET_VECTOR_OFFSET = 0x7FFF0        # physical 0xffff0
ERASED = 0xFF

# `a400` is the firmware's code segment - the DSP overlay loader runs there and
# every flash-half vector the update program installs names it - and `a400:0008`
# loads the DSP: `cld ; mov ax,2600 ; mov ds,ax ; mov es,ax ; … ; mov cx,247c ;
# call <download>`, 0x247c being the resident DSP image's length to the byte.
#
# This is the TID_MODEM task entry: 4607:042b creates it through VRTX service
# 00, and the scheduler executes it. Its call to 7561:443e is a callback, not
# evidence that this is merely an updater helper. It still requires prior
# kernel/subsystem initialization, so it is not a standalone cold-start entry.
# Keep the existing constant name for callers; see docs/imodem-vrtx-startup.md.
DSP_LOAD_ENTRY = (0xA400, 0x0008)

# Historical name for the initializer that reaches VRTX and nine firmware
# tasks. Its relationship to the real boot-block handoff remains unverified.
UPDATER_ENTRY = (0x4030, 0x0000)
DEFAULT_ENTRY = UPDATER_ENTRY


# The board's own bring-up, carried in the image as two tables: three-byte
# records (port word, byte value) ending in a zero, then four-byte records
# (port word, word value).  The 8254's three mode writes anchor the first.
INIT_ANCHOR = bytes.fromhex("43f03443f07443f0b4")
PORT_LOW, PORT_HIGH = 0xF000, 0xF8FF


def init_records(payload: bytes) -> tuple[list[tuple[int, int]], list[tuple[int, int]]]:
    """The byte and word port-writes the firmware's own init table performs."""
    start = payload.find(INIT_ANCHOR)
    if start < 0:
        raise ValueError("the 386EX init table is not in this payload")
    byte_records: list[tuple[int, int]] = []
    offset = start
    while True:
        port = int.from_bytes(payload[offset : offset + 2], "little")
        if not PORT_LOW <= port <= PORT_HIGH:
            break
        byte_records.append((port, payload[offset + 2]))
        offset += 3
    offset += 1                                   # the zero between the sections
    word_records: list[tuple[int, int]] = []
    while True:
        port = int.from_bytes(payload[offset : offset + 2], "little")
        if not PORT_LOW <= port <= PORT_HIGH:
            break
        word_records.append((port, int.from_bytes(payload[offset + 2 : offset + 4], "little")))
        offset += 4
    return byte_records, word_records


def bring_up_code(payload: bytes) -> bytes:
    """Straight-line `mov dx / mov al|ax / out` for every record, in order."""
    byte_records, word_records = init_records(payload)
    out = bytearray(b"\xfa")                      # cli
    for port, value in byte_records:
        out += b"\xba" + port.to_bytes(2, "little")
        out += bytes((0xB0, value)) + b"\xee"
    for port, value in word_records:
        out += b"\xba" + port.to_bytes(2, "little")
        out += b"\xb8" + value.to_bytes(2, "little") + b"\xef"
    return bytes(out)


def far_jump(segment: int, offset: int) -> bytes:
    """`jmp far segment:offset` - the whole of the synthetic boot block."""
    return bytes((0xEA, offset & 0xFF, offset >> 8, segment & 0xFF, segment >> 8))


def build(
    payload: bytes,
    base: int = 0x40000,
    entry: tuple[int, int] = DEFAULT_ENTRY,
    bring_up: bool = True,
) -> bytes:
    """A 512 KiB flash: the payload's runtime half, plus a synthetic boot block.

    With `bring_up`, the block replays the firmware's own initialisation table
    before jumping - the same ports and values, in the same order, read out of
    the image rather than composed here.
    """
    start = FLASH_BASE - base
    if start < 0 or start > len(payload):
        raise ValueError(f"payload at {base:#x} does not reach the flash window")
    body = payload[start : start + FLASH_SIZE]
    rom = bytearray([ERASED]) * FLASH_SIZE
    rom[: len(body)] = body
    for index in range(BOOT_BLOCK_OFFSET, FLASH_SIZE):
        rom[index] = ERASED
    block = bring_up_code(payload) if bring_up else b""
    block += far_jump(*entry)
    rom[BOOT_BLOCK_OFFSET : BOOT_BLOCK_OFFSET + len(block)] = block
    reset = far_jump(0xF800, 0x0000) if bring_up else far_jump(*entry)
    rom[RESET_VECTOR_OFFSET : RESET_VECTOR_OFFSET + len(reset)] = reset
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
