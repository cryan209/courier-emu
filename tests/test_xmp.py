from __future__ import annotations

from pathlib import Path
import tempfile
import unittest

from courier_emu.images import load_image
from courier_emu.xmf import XmfFormatError
from courier_emu.xmp import (
    BOOT_SIGNATURE,
    DEBUG_REGISTER_OFFSET,
    DEBUG_REGISTER_SIGNATURE,
    EXPECTED_SIZE,
    FLASH_PHYSICAL_BASE,
    HEADER_SIZE,
    MAGIC,
    OBFUSCATION_KEY,
    PAYLOAD_SIZE,
    XmpFormatError,
    XmpImage,
)


ROOT = Path(__file__).resolve().parents[1]
IMAGE = ROOT / "Ie030002.xmp"
XMF_IMAGE = ROOT / "main211.xmf"


@unittest.skipUnless(IMAGE.exists(), "ISDN Courier XMP image is not present")
class XmpImageTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.image = XmpImage.load(IMAGE)

    def test_container_sizes(self) -> None:
        self.assertEqual(len(self.image.data), EXPECTED_SIZE)
        self.assertEqual(len(self.image.payload), PAYLOAD_SIZE)
        self.assertEqual(HEADER_SIZE + PAYLOAD_SIZE, EXPECTED_SIZE)
        self.assertTrue(self.image.data.startswith(MAGIC))

    def test_payload_is_the_body_xored_with_the_key(self) -> None:
        body = self.image.data[HEADER_SIZE:]
        expected = bytes(byte ^ OBFUSCATION_KEY for byte in body)
        self.assertEqual(self.image.payload, expected)

    def test_decoded_signatures(self) -> None:
        self.assertTrue(self.image.payload.startswith(BOOT_SIGNATURE))
        window = self.image.payload[
            DEBUG_REGISTER_OFFSET : DEBUG_REGISTER_OFFSET + len(DEBUG_REGISTER_SIGNATURE)
        ]
        self.assertEqual(window, DEBUG_REGISTER_SIGNATURE)

    def test_decoding_reaches_the_far_end_of_the_image(self) -> None:
        # The VRTX kernel banner and the ISDN rate-adaptation strings sit deep in
        # the payload, so finding them proves the key is constant across it.
        self.assertIn(b"Copyright 1988, Ready Systems", self.image.payload)
        self.assertIn(b"SET_V110_ENTRY", self.image.payload)

    def test_erased_flash_decodes_to_ff(self) -> None:
        regions = self.image.programmed_regions()
        self.assertGreaterEqual(len(regions), 2)
        gap = self.image.payload[regions[0][1] : regions[1][0]]
        self.assertTrue(gap)
        self.assertEqual(set(gap), {0xFF})

    def test_address_translation_round_trips(self) -> None:
        self.assertEqual(self.image.load_base, FLASH_PHYSICAL_BASE)
        self.assertEqual(self.image.file_to_physical(0), FLASH_PHYSICAL_BASE)
        self.assertEqual(self.image.physical_to_file(FLASH_PHYSICAL_BASE + 0x100), 0x100)
        with self.assertRaises(ValueError):
            self.image.physical_to_file(FLASH_PHYSICAL_BASE - 1)
        with self.assertRaises(ValueError):
            self.image.file_to_physical(PAYLOAD_SIZE)

    def test_extract_writes_header_and_payload(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            header_path, payload_path = self.image.extract(directory)
            self.assertEqual(header_path.read_bytes(), self.image.header)
            self.assertEqual(payload_path.read_bytes(), self.image.payload)

    def test_describe_reports_the_undecoded_header_table(self) -> None:
        described = self.image.describe()
        self.assertEqual(described["format"], "xmp")
        self.assertEqual(described["obfuscation_key"], OBFUSCATION_KEY)
        # The 0x70-byte table at header offset 0x10 is not yet reverse
        # engineered, so it must be reported verbatim rather than as fields.
        self.assertEqual(described["header_table_undecoded"], self.image.header_table.hex())

    def test_load_image_dispatches_to_xmp(self) -> None:
        self.assertIsInstance(load_image(IMAGE), XmpImage)

    def test_rejects_a_wrong_key(self) -> None:
        data = bytearray(self.image.data)
        data[HEADER_SIZE] ^= 0xFF
        with tempfile.TemporaryDirectory() as directory:
            broken = Path(directory) / "broken.xmp"
            broken.write_bytes(bytes(data))
            with self.assertRaises(XmpFormatError):
                XmpImage.load(broken)

    def test_rejects_a_truncated_file(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            short = Path(directory) / "short.xmp"
            short.write_bytes(self.image.data[: EXPECTED_SIZE - 1])
            with self.assertRaises(XmpFormatError):
                XmpImage.load(short)

    def test_rejects_a_missing_magic(self) -> None:
        data = bytearray(self.image.data)
        data[0] = ord("X")
        with tempfile.TemporaryDirectory() as directory:
            broken = Path(directory) / "nomagic.xmp"
            broken.write_bytes(bytes(data))
            with self.assertRaises(XmpFormatError):
                XmpImage.load(broken)


class XmpRejectionTests(unittest.TestCase):
    @unittest.skipUnless(XMF_IMAGE.exists(), "XMF image is not present")
    def test_an_xmf_is_not_an_xmp(self) -> None:
        with self.assertRaises(XmpFormatError):
            XmpImage.load(XMF_IMAGE)

    def test_load_image_reports_all_three_formats(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            junk = Path(directory) / "junk.bin"
            junk.write_bytes(b"not a firmware image")
            with self.assertRaises(XmfFormatError) as caught:
                load_image(junk)
        message = str(caught.exception)
        self.assertIn("XMF", message)
        self.assertIn("ROM", message)
        self.assertIn("XMP", message)
