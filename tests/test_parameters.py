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






class ParameterSectorTest(unittest.TestCase):
    def test_builds_a_full_sized_sector_with_a_valid_checksum(self) -> None:
        data = ParameterSector().build()
        self.assertEqual(len(data), SECTOR_SIZE)
        stored = int.from_bytes(data[CHECKSUM_OFFSET:SECTOR_SIZE], "little")
        self.assertEqual(stored, checksum(data))











if __name__ == "__main__":
    unittest.main()
