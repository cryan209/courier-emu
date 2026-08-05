from __future__ import annotations

from pathlib import Path
import tempfile
import unittest

from courier_emu.flash import ERASED_BYTE, FLASH_SIZE, ParameterFlash
from courier_emu.parameters import SECTOR_COUNT, SECTOR_SIZE, ParameterSector


class ParameterFlashTests(unittest.TestCase):
    def test_a_new_part_reads_erased(self) -> None:
        # The store's blank check at 0x7e0e3 scans for 0xffff words, so an
        # unwritten part has to answer that way or every write is refused.
        flash = ParameterFlash()
        self.assertEqual(len(flash.data), FLASH_SIZE)
        self.assertEqual(set(flash.data), {ERASED_BYTE})
        self.assertTrue(all(sector["erased"] for sector in flash.sectors()))

    def test_programming_only_clears_bits(self) -> None:
        flash = ParameterFlash()
        self.assertEqual(flash.program_word(0, 0xF0F0), 0xF0F0)
        # A second program can clear further bits but never set them again.
        self.assertEqual(flash.program_word(0, 0xFF00), 0xF000)
        self.assertEqual(flash.programmed_words, 2)

    def test_setting_a_bit_without_an_erase_is_counted(self) -> None:
        flash = ParameterFlash()
        flash.program_word(0, 0x0000)
        flash.program_word(0, 0xFFFF)
        # Sixteen bits the part could not restore: the firmware programmed a
        # word it had not erased, which on silicon leaves the old value.
        self.assertEqual(flash.refused_bits, 16)
        self.assertEqual(int.from_bytes(flash.data[:2], "little"), 0)

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

    def test_erase_picks_the_sector_the_offset_lands_in(self) -> None:
        flash = ParameterFlash()
        self.assertEqual(flash.erase_sector(SECTOR_SIZE * 2 + 8)[0], SECTOR_SIZE * 2)

    def test_a_missing_file_opens_erased(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "absent.flash"
            flash = ParameterFlash.load(path)
            self.assertEqual(set(flash.data), {ERASED_BYTE})
            self.assertFalse(path.exists())
            flash.save()
            self.assertEqual(len(path.read_bytes()), FLASH_SIZE)

    def test_a_single_sector_file_loads_into_the_first_sector(self) -> None:
        # `parameters` writes one 4 KiB sector, which is a reasonable thing
        # to hand to a part that holds four of them.
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "sector.bin"
            sector = ParameterSector(serial="TEST123")
            sector.save(path)
            flash = ParameterFlash.load(path)
            self.assertEqual(bytes(flash.data[:SECTOR_SIZE]), sector.build())
            self.assertEqual(set(flash.data[SECTOR_SIZE:]), {ERASED_BYTE})

    def test_a_wrong_sized_file_is_refused(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "short.flash"
            path.write_bytes(b"\xff" * 100)
            with self.assertRaises(ValueError):
                ParameterFlash.load(path)

    def test_a_built_sector_reports_a_valid_checksum(self) -> None:
        flash = ParameterFlash()
        flash.data[:SECTOR_SIZE] = ParameterSector(serial="AB12").build()
        sectors = flash.sectors()
        self.assertTrue(sectors[0]["checksum_valid"])
        self.assertFalse(sectors[0]["erased"])
        self.assertTrue(all(sectors[index]["erased"] for index in range(1, SECTOR_COUNT)))

    def test_status_carries_the_counters(self) -> None:
        flash = ParameterFlash()
        flash.erase_sector(0)
        flash.program_word(0, 0x1234)
        status = flash.status()
        self.assertEqual(status["erases"], 1)
        self.assertEqual(status["programmed_words"], 1)
        self.assertEqual(status["bytes"], FLASH_SIZE)
        self.assertEqual(len(status["sectors"]), SECTOR_COUNT)


if __name__ == "__main__":
    unittest.main()
