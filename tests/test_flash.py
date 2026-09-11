from __future__ import annotations

from pathlib import Path
import tempfile
import unittest

from courier_emu.flash import ERASED_BYTE, FLASH_SIZE, ParameterFlash
from courier_emu.parameters import SECTOR_COUNT, SECTOR_SIZE, ParameterSector


class ParameterFlashTests(unittest.TestCase):

    def test_programming_only_clears_bits(self) -> None:
        flash = ParameterFlash()
        self.assertEqual(flash.program_word(0, 0xF0F0), 0xF0F0)
        # A second program can clear further bits but never set them again.
        self.assertEqual(flash.program_word(0, 0xFF00), 0xF000)
        self.assertEqual(flash.programmed_words, 2)


    def test_erase_restores_one_sector_only(self) -> None:
        flash = ParameterFlash()
        flash.program_word(0, 0x0000)
        flash.program_word(SECTOR_SIZE, 0x0000)
        start, size = flash.erase_sector(0)
        self.assertEqual((start, size), (0, SECTOR_SIZE))
        self.assertEqual(flash.erases, 1)
        self.assertEqual(int.from_bytes(flash.data[:2], "little"), 0xFFFF)
        # The neighbouring sector keeps what was programmed into it.
        self.assertEqual(
            int.from_bytes(flash.data[SECTOR_SIZE : SECTOR_SIZE + 2], "little"), 0
        )








if __name__ == "__main__":
    unittest.main()


# -- the part the board actually carries -----------------------------------

from courier_emu.flash_device import (  # noqa: E402
    AMD, AM29F400AT, FLASH_BASE, FlashDevice,
)


def amd_part() -> FlashDevice:
    part = FlashDevice()
    part.load(b"\x00" * part.size)
    return part


def unlock(part: FlashDevice, command: int, offset: int = 0xAAAA) -> None:
    """AMD's three-write sequence: aa at 0xaaaa, 55 at 0x5554, the command."""
    part.on_write(FLASH_BASE + 0xAAAA, 1, 0xAA)
    part.on_write(FLASH_BASE + 0x5554, 1, 0x55)
    part.on_write(FLASH_BASE + offset, 1, command)


def test_the_part_identifies_as_the_am29f400at_on_the_board():
    part = amd_part()
    assert part.manufacturer == AMD
    assert part.device == AM29F400AT
    unlock(part, 0x90)
    assert part.take_patches()[-1] == (FLASH_BASE, b"\x01\x00\x23\x22")


def test_amd_sector_erase_erases_only_that_sector():
    part = amd_part()
    unlock(part, 0x80)
    unlock(part, 0x30, offset=0x78100)
    assert part.erases == 1
    # SA8 is the first 8 KiB boot sector, 0x78000..0x79fff - which is where
    # the updater's one erase lands.
    assert part.contents[0x78000:0x7A000] == b"\xff" * 0x2000
    assert part.contents[0x77FFF] == 0x00
    assert part.contents[0x7A000] == 0x00


def test_amd_program_clears_bits_and_leaves_the_rest():
    part = amd_part()
    part.contents[0x1000] = 0xFF
    unlock(part, 0xA0)
    part.on_write(FLASH_BASE + 0x1000, 1, 0x5A)
    assert part.programs == 1
    assert part.contents[0x1000] == 0x5A
    assert part.contents[0x1001] == 0x00


def test_the_sector_map_is_the_top_boot_geometry():
    part = FlashDevice()
    assert part._sector(0x00000) == (0x00000, 0x10000)
    assert part._sector(0x6FFFF) == (0x60000, 0x10000)
    assert part._sector(0x70000) == (0x70000, 0x08000)
    assert part._sector(0x78100) == (0x78000, 0x02000)
    assert part._sector(0x7A000) == (0x7A000, 0x02000)
    assert part._sector(0x7FFFF) == (0x7C000, 0x04000)
