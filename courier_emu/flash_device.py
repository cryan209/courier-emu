"""The flash part, as the I-modem's update image drives it.

`Ie030002.nac` is an update image: entered at its recovered initialiser it
identifies the flash, then erases and programs it.  So a harness that wants to
get past the first second of that run needs more than an array - it needs the
part's command interface.

The boot code at `34970`, copied to RAM, asks who the flash is: an Intel
sequence first (`ff` read-array, `90` read-identifier, manufacturer word at
offset 0, device word at offset 1, `ff` back), and if the manufacturer is not
`0089`, an AMD one (`aa`/`55`/`90` through `aaaa`/`5554`, `f0` to leave).  The
family that answers picks a set of erase and program entry points, stored at
`e2d6`-`e2dc`.  With Intel answering, what follows is the Intel command set:
`50` clear status, `20`+`d0` block erase, `40` program, `70` read status.

Two rules make the model faithful rather than convenient.  Command writes never
disturb the array - a real part decodes them - and the array only ever loses
bits: programming ANDs, and erasing is the one thing that sets them back to
one.  The block size is the one number here not recovered from the image; it is
a parameter, defaulting to the 64 KiB an Intel 28F0xx uses.
"""
from __future__ import annotations

from dataclasses import dataclass, field


FLASH_BASE = 0x80000
FLASH_SIZE = 0x80000
# The erase the update image performs is at offset 0x78100 - physical 0xf8100,
# which is the first address past the end of the NAC payload (0x40000+0xb8000).
# A 64 KiB block there would take the boot block with it; an 8 KiB one erases
# only the region past the payload, which is what a top-boot part gives you and
# what an updater that does not replace its own boot block would want. Still a
# parameter: the part is not identified beyond its Intel manufacturer word.
BLOCK_SIZE = 0x2000

INTEL = 0x0089
AMD = 0x0001

# The part fitted on the board is an AMD Am29F400AT - a 4 Mbit, 512 KiB, top
# boot flash, which is the flash window exactly. Its device code is 0x2223.
AM29F400AT = 0x2223

# The Am29F400AT's sector map: seven 64 KiB sectors, then 32, 8, 8 and 16 KiB
# at the top, where a top-boot part puts its small sectors. This is the fixed
# geometry of that part, not a parameter - and it is what the updater's one
# erase lands in. It erases at flash offset 0x78100, which is SA8, the first
# 8 KiB boot sector, and programs nothing above it. SA9 and SA10 are therefore
# left alone by an update, which is what a settings store in flash looks like.
AM29F400AT_SECTORS = (
    (0x00000, 0x10000), (0x10000, 0x10000), (0x20000, 0x10000),
    (0x30000, 0x10000), (0x40000, 0x10000), (0x50000, 0x10000),
    (0x60000, 0x10000), (0x70000, 0x08000), (0x78000, 0x02000),
    (0x7A000, 0x02000), (0x7C000, 0x04000),
)

AMD_UNLOCK = (0xAAAA, 0x5554, 0xAAAA)

READ_ARRAY = "array"
AUTOSELECT = "autoselect"
STATUS = "status"

# Intel status register: write state machine ready, no error, Vpp good.
STATUS_READY = 0x80


@dataclass
class FlashDevice:
    """Array, autoselect and the Intel program/erase command set."""

    contents: bytearray = field(default_factory=bytearray)
    manufacturer: int = AMD
    device: int = AM29F400AT
    base: int = FLASH_BASE
    size: int = FLASH_SIZE
    block_size: int = BLOCK_SIZE
    sectors: tuple = AM29F400AT_SECTORS
    mode: str = READ_ARRAY
    status: int = STATUS_READY
    unlock: int = 0
    _pending: str | None = None
    _erase_address: int | None = None
    _erase_armed: bool = False
    commands: list[tuple[int, int]] = field(default_factory=list)
    autoselects: int = 0
    erases: int = 0
    programs: int = 0
    patches: list[tuple[int, bytes]] = field(default_factory=list)

    def load(self, contents: bytes) -> None:
        """Take the array, padded to the part's size with erased bytes.

        The update payload stops at 0xf8000, short of the window's top, so the
        rest of the part is not in the image - erased is the honest value for
        it rather than absent.
        """
        self.contents = bytearray(contents[: self.size])
        if len(self.contents) < self.size:
            self.contents.extend(b"\xff" * (self.size - len(self.contents)))

    def contains(self, address: int) -> bool:
        return self.base <= address < self.base + self.size

    # -- the array ---------------------------------------------------------

    def _array(self, offset: int, size: int) -> bytes:
        if offset < 0 or offset + size > len(self.contents):
            return b"\xff" * size
        return bytes(self.contents[offset : offset + size])

    def _program(self, offset: int, size: int, value: int) -> None:
        """Flash programming clears bits; it never sets them."""
        self.programs += 1
        for index in range(size):
            if 0 <= offset + index < len(self.contents):
                byte = (value >> (8 * index)) & 0xFF
                self.contents[offset + index] &= byte

    def _sector(self, offset: int) -> tuple[int, int]:
        """The sector an offset falls in, from the part's own geometry."""
        for start, size in self.sectors:
            if start <= offset < start + size:
                return start, size
        # No map: fall back to the uniform block size, which is what a part
        # this model does not know the geometry of would need.
        start = offset - (offset % self.block_size)
        return start, self.block_size

    def _erase(self, offset: int) -> None:
        self.erases += 1
        start, size = self._sector(offset)
        end = min(start + size, len(self.contents))
        for index in range(max(start, 0), end):
            self.contents[index] = 0xFF

    def _erase_chip(self) -> None:
        self.erases += 1
        for index in range(len(self.contents)):
            self.contents[index] = 0xFF

    # -- commands ----------------------------------------------------------

    def on_write(self, address: int, size: int, value: int) -> None:
        """Decode one write and queue whatever the window should read back."""
        offset = address - self.base
        command = value & 0xFF
        self.commands.append((offset, command))

        if self._pending == "amd_program":
            self._pending = None
            self._program(offset, size, value)
            self.mode = READ_ARRAY
            self._queue_array(address, size)
            return
        if self._pending == "program":
            self._pending = None
            self._program(offset, size, value)
            self.mode = STATUS
            self._queue_array(address, size)
            self._queue_status(address)
            return
        if self._pending == "erase":
            self._pending = None
            if command == 0xD0:
                self._erase(self._erase_address or offset)
            self.mode = STATUS
            self._queue_array(address, size)
            self._queue_status(address)
            return

        self._queue_array(address, size)

        # AMD's command set is a three-write unlock: aa at 0xaaaa, 55 at
        # 0x5554, then the command. Erase takes a second unlock and a 30 that
        # names the sector, or a 10 for the whole part.
        if self.unlock == 2:
            self.unlock = 0
            if command == 0x90:
                self._autoselect()
                return
            if command == 0xA0:
                self._pending = "amd_program"
                return
            if command == 0x80:
                self._erase_armed = True
                return
            if self._erase_armed and command == 0x30:
                self._erase_armed = False
                self._erase(offset)
                self._queue_array(address, size)
                return
            if self._erase_armed and command == 0x10:
                self._erase_armed = False
                self._erase_chip()
                self._queue_array(address, size)
                return
            self._erase_armed = False
            return

        if command == 0xAA and offset == AMD_UNLOCK[0]:
            self.unlock = 1
            return
        if command == 0x55 and offset == AMD_UNLOCK[1] and self.unlock == 1:
            self.unlock = 2
            return
        self.unlock = 0

        if command in (0xFF, 0xF0):
            self.mode = READ_ARRAY
            self._erase_armed = False
        elif command == 0x70:
            self.mode = STATUS
            self._queue_status(address)
        elif command == 0x50:
            self.status = STATUS_READY
            self.mode = STATUS
            self._queue_status(address)
        elif command == 0x20:
            self._pending = "erase"
            self._erase_address = offset
        elif command in (0x40, 0x10):
            self._pending = "program"
        elif command == 0x90:
            self._autoselect()

    def _autoselect(self) -> None:
        self.mode = AUTOSELECT
        self.autoselects += 1
        self.patches.append((self.base, self.identifiers()))

    def _queue_array(self, address: int, size: int) -> None:
        self.patches.append((address, self._array(address - self.base, size)))

    def _queue_status(self, address: int) -> None:
        self.patches.append((address, bytes((self.status, 0x00))))

    def identifiers(self) -> bytes:
        return (self.manufacturer & 0xFFFF).to_bytes(2, "little") + (
            self.device & 0xFFFF
        ).to_bytes(2, "little")

    def take_patches(self) -> list[tuple[int, bytes]]:
        found, self.patches = self.patches, []
        return found

    def status_report(self) -> dict[str, object]:
        return {
            "manufacturer": f"{self.manufacturer:#06x}",
            "device": f"{self.device:#06x}",
            "mode": self.mode,
            "autoselects": self.autoselects,
            "erases": self.erases,
            "programs": self.programs,
            "commands": [f"{offset:#07x}:{command:02x}" for offset, command in self.commands[:24]],
        }
