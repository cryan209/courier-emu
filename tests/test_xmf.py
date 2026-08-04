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

    def test_recovered_address_mapping_and_entry(self) -> None:
        self.assertEqual(self.image.entry_offset, 0x410)
        self.assertEqual(self.image.entry_physical, 0x5B9F0)
        self.assertEqual(self.image.error_blink_target, 0x5C74A)
        self.assertEqual(self.image.file_to_physical(0x333C0), 0x733C0)
        self.assertEqual(self.image.physical_to_file(0x7A590), 0x3A590)
        self.assertEqual(self.image.file_to_physical(0), FLASH_PHYSICAL_BASE)

    def test_recovered_dsp_program_segments(self) -> None:
        segments = self.image.dsp_program_segments()
        self.assertEqual(
            [(origin, len(data)) for origin, data in segments],
            [
                (DSP_BOOT_ORIGIN, DSP_BOOT_SIZE),
                (DSP_OVERLAY_ORIGIN, DSP_OVERLAY_SIZE),
                (DSP_RESIDENT_ORIGIN, DSP_RESIDENT_SIZE),
            ],
        )
        self.assertEqual(segments[0][1][:8], bytes.fromhex("00bc57aeffff7aae"))
        self.assertEqual(segments[1][1][:14], b"\xff" * 12 + bytes.fromhex("00bc"))
        self.assertEqual(segments[2][1][:8], bytes.fromhex("2c77304030983190"))

    def test_extraction_round_trips(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            header, dsp, supervisor = self.image.extract(directory)
            self.assertEqual(header.read_bytes(), self.image.header)
            self.assertEqual(dsp.read_bytes(), self.image.dsp)
            self.assertEqual(supervisor.read_bytes(), self.image.supervisor)

    def test_rejects_wrong_file(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "wrong.xmf"
            path.write_bytes(b"not firmware")
            with self.assertRaises(XmfFormatError):
                XmfImage.load(path)


if __name__ == "__main__":
    unittest.main()
