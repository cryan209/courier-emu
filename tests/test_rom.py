from __future__ import annotations

from pathlib import Path
import unittest

from courier_emu.rom import (
    LCS_START,
    RESET_VECTOR,
    ROM_SIZE,
    UCS_START,
    CourierRom,
    RomFormatError,
)


ROOT = Path(__file__).resolve().parents[1]
IMAGE = ROOT / "IDSDL302.ROM"


@unittest.skipUnless(IMAGE.exists(), "no Courier ROM image available")
class CourierRomTests(unittest.TestCase):
    def setUp(self) -> None:
        self.rom = CourierRom.load(IMAGE)

    def test_the_reset_stub_places_the_rom(self) -> None:
        # An XMF carries only an update payload, so its address is a modelling
        # choice. A ROM ends with the 80186 reset vector, and the stub there
        # programs the chip select that decodes the ROM before it jumps, so the
        # image says where it lives.
        self.assertEqual(self.rom.base, 0x80000)
        self.assertEqual(self.rom.base + ROM_SIZE, 0x100000)
        self.assertEqual(self.rom.reset.chip_select_register, UCS_START)
        self.assertEqual(self.rom.reset.boot_physical, 0xFDA21)

    def test_the_setup_table_gives_the_flash_and_ram_map(self) -> None:
        selects = self.rom.chip_selects()
        self.assertEqual(selects["flash"]["start"], 0x80000)
        self.assertEqual(selects["ram"]["start"], 0x00000)
        self.assertEqual(selects["ram"]["stop"], 0x20000)

    def test_the_peripheral_control_block_is_mapped_where_the_harness_hooks_it(
        self,
    ) -> None:
        # The relocation register moves the control block into memory space at
        # 0x0ff00, which is the window the 80186 harness already watches.
        block = self.rom.chip_selects()["peripheral_control_block"]
        self.assertEqual(block["address"], 0x0FF00)
        self.assertEqual(block["memory_mapped"], 1)

    def test_the_setup_tables_are_recovered_whole(self) -> None:
        writes = self.rom.peripheral_writes()
        self.assertEqual(len(writes["word_writes"]), 36)
        self.assertEqual(len(writes["byte_writes"]), 9)
        ports = dict(writes["word_writes"])
        self.assertIn(UCS_START, ports)
        self.assertIn(LCS_START, ports)
        # The byte table seeds the board latches, and it seeds two of them with
        # exactly the values the 2002 firmware's own boot writes.
        latches = dict(writes["byte_writes"])
        self.assertEqual(latches[0x12], 0x7F)
        self.assertEqual(latches[0x14], 0xF5)

    def test_the_parameter_region_is_where_the_search_looks(self) -> None:
        # The search at 0x7e07c walks four sectors from 0xf8000. On a part that
        # has never been configured they read erased, which is why an image
        # alone cannot supply one.
        sectors = self.rom.parameter_sectors
        self.assertEqual(sectors[0]["physical"], 0xF8000)
        self.assertTrue(all(sector["erased"] for sector in sectors[:3]))
        self.assertFalse(any(sector["checksum_matches"] for sector in sectors))

    def test_the_application_image_starts_at_the_bottom_of_the_rom(self) -> None:
        self.assertEqual(self.rom.at(0x80000, 4), b"\xbd\x0b\x00\xe9")

    def test_reading_outside_the_rom_is_refused(self) -> None:
        with self.assertRaises(ValueError):
            self.rom.at(0x7FFFF, 1)
        with self.assertRaises(ValueError):
            self.rom.at(0xFFFF0, 32)

    def test_describe_reports_the_recovered_map(self) -> None:
        described = self.rom.describe()
        self.assertEqual(described["base"], "0x80000")
        self.assertEqual(described["reset_vector"], f"{RESET_VECTOR:#07x}")
        self.assertEqual(described["boot_entry"], "fc00:1a21")


class RomFormatTests(unittest.TestCase):
    def test_an_update_payload_is_not_a_rom(self) -> None:
        with self.assertRaises(RomFormatError):
            CourierRom.load(ROOT / "main211.xmf")

    def test_a_rom_without_a_reset_stub_is_refused(self) -> None:
        import tempfile

        with tempfile.NamedTemporaryFile(suffix=".ROM") as handle:
            handle.write(b"\x00" * ROM_SIZE)
            handle.flush()
            with self.assertRaises(RomFormatError):
                CourierRom.load(handle.name)


if __name__ == "__main__":
    unittest.main()
