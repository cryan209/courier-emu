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
