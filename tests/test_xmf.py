from __future__ import annotations

from pathlib import Path
import tempfile
import unittest

from courier_emu.xmf import (
    DSP_BOOT_ORIGIN,
    DSP_BOOT_SIZE,
    DSP_OVERLAY_ORIGIN,
    DSP_OVERLAY_SIZE,
    DSP_RESIDENT_ORIGIN,
    DSP_RESIDENT_SIZE,
    EXPECTED_SIZE,
    FLASH_PHYSICAL_BASE,
    HEADER_SIZE,
    SUPERVISOR_OFFSET,
    XmfFormatError,
    XmfImage,
)


ROOT = Path(__file__).resolve().parents[1]
IMAGE = ROOT / "main211.xmf"


class XmfImageTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.image = XmfImage.load(IMAGE)

    def test_known_image_identity_and_layout(self) -> None:
        self.assertEqual(len(self.image.data), EXPECTED_SIZE)
        self.assertEqual(
            self.image.digest,
            "7699fbad0e906954b1ec7db315af0c17b758f5f4059ba0357401eadebdde1bd4",
        )
        self.assertEqual(len(self.image.header), HEADER_SIZE)
        self.assertEqual(len(self.image.dsp), SUPERVISOR_OFFSET - HEADER_SIZE)
        self.assertEqual(self.image.dsp_word_count, 0xD9F0)
        self.assertEqual(self.image.last_programmed_offset, 0x4941B)






if __name__ == "__main__":
    unittest.main()
