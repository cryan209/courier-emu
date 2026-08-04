from __future__ import annotations

import tempfile
import unittest
from pathlib import Path

from courier_emu.parameters import (
    CHECKSUM_OFFSET,
    FEATURE_BITS,
    PACKED_OFFSET,
    PROFILE_OFFSET,
    SECTOR_SIZE,
    SERIAL_LENGTH,
    SERIAL_OFFSET,
    VERSION_OFFSET,
    ParameterSector,
    checksum,
    features_value,
    load_sector,
)


class ChecksumTest(unittest.TestCase):
    def test_matches_values_measured_from_the_firmware(self) -> None:
        # Both sectors were checksummed by the firmware's own routine at
        # 0x72930 while running under the emulator.
        sector = bytearray(b"\xff" * SECTOR_SIZE)
        sector[0:5] = bytes((0, 0, 0, 0, 4))
        sector[VERSION_OFFSET:CHECKSUM_OFFSET] = (2).to_bytes(2, "little") + (1).to_bytes(
            2, "little"
        )
        self.assertEqual(checksum(bytes(sector)), 0x6184)

        sector = bytearray(b"\xff" * SECTOR_SIZE)
        sector[0:7] = bytes((0, 0, 31, 7, 30, 0, 0))
        sector[VERSION_OFFSET:CHECKSUM_OFFSET] = (2).to_bytes(2, "little") + (1).to_bytes(
            2, "little"
        )
        self.assertEqual(checksum(bytes(sector)), 0x9665)

    def test_ignores_the_stored_checksum_word(self) -> None:
        base = bytearray(SECTOR_SIZE)
        first = checksum(bytes(base))
        base[CHECKSUM_OFFSET:SECTOR_SIZE] = b"\x5a\xa5"
        self.assertEqual(checksum(bytes(base)), first)


class FeatureBitsTest(unittest.TestCase):
    def test_reported_x2_unit_reads_thirty_one(self) -> None:
        # A unit with every feature bit set reports 031 in ATY14 field 5.
        self.assertEqual(features_value(tuple(FEATURE_BITS)), 31)

    def test_x2_is_bit_four(self) -> None:
        self.assertEqual(FEATURE_BITS["x2"], 0x10)

    def test_unknown_feature_is_rejected(self) -> None:
        with self.assertRaises(ValueError):
            features_value(("v92",))


class ParameterSectorTest(unittest.TestCase):
    def test_builds_a_full_sized_sector_with_a_valid_checksum(self) -> None:
        data = ParameterSector().build()
        self.assertEqual(len(data), SECTOR_SIZE)
        stored = int.from_bytes(data[CHECKSUM_OFFSET:SECTOR_SIZE], "little")
        self.assertEqual(stored, checksum(data))

    def test_field_order_matches_the_printed_dump(self) -> None:
        # 0x85250 prints 0x0a0c down to 0x0a07, so the record holds country,
        # features, type2, type1, unused2, unused1.
        sector = ParameterSector(country=1, features=31, type2=7, type1=30, unused2=2, unused1=3)
        data = sector.build()
        self.assertEqual(tuple(data[1:7]), (1, 31, 7, 30, 2, 3))
        self.assertEqual(sector.status()["aty14"], "003,002,030,007,031,001")

    def test_reported_unit_reproduces_its_dump(self) -> None:
        sector = ParameterSector(features=features_value(tuple(FEATURE_BITS)))
        self.assertEqual(sector.status()["aty14"], "000,000,030,007,031,000")

    def test_serial_is_space_padded_ascii(self) -> None:
        data = ParameterSector(serial="12345678").build()
        self.assertEqual(
            data[SERIAL_OFFSET : SERIAL_OFFSET + SERIAL_LENGTH], b"12345678    "
        )

    def test_absent_serial_is_all_ones(self) -> None:
        # 0x77bb9 reads four words and treats all-0xffff as no serial fitted.
        data = ParameterSector().build()
        self.assertEqual(
            data[SERIAL_OFFSET : SERIAL_OFFSET + SERIAL_LENGTH], b"\xff" * SERIAL_LENGTH
        )

    def test_serial_length_and_encoding_are_checked(self) -> None:
        with self.assertRaises(ValueError):
            ParameterSector(serial="0123456789abc")
        with self.assertRaises(ValueError):
            ParameterSector(serial="café")

    def test_byte_fields_are_range_checked(self) -> None:
        with self.assertRaises(ValueError):
            ParameterSector(features=256)

    def test_profile_regions_are_populated(self) -> None:
        data = ParameterSector().build()
        self.assertNotEqual(data[PACKED_OFFSET], 0)
        self.assertNotEqual(data[PROFILE_OFFSET], 0)

    def test_round_trips_through_a_file(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "params.bin"
            ParameterSector(serial="ABC").save(path)
            self.assertEqual(load_sector(path), ParameterSector(serial="ABC").build())

    def test_wrongly_sized_sector_is_rejected(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "short.bin"
            path.write_bytes(b"\x00" * 64)
            with self.assertRaises(ValueError):
                load_sector(path)


if __name__ == "__main__":
    unittest.main()
