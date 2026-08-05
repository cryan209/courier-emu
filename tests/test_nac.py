from __future__ import annotations

from pathlib import Path
import struct
import tempfile
import unittest

from courier_emu.images import load_image
from courier_emu.nac import (
    HEADER_SIZE,
    RECORD_DATA,
    RECORD_EOF,
    RECORD_EXTENDED_SEGMENT,
    RECORD_START_SEGMENT,
    STREAM_LENGTH_OFFSET,
    TRAILER_SIZE,
    NacFormatError,
    NacImage,
)
from courier_emu.xmf import XmfFormatError
from courier_emu.xmp import XmpImage


ROOT = Path(__file__).resolve().parents[1]
IMAGE = ROOT / "Ie030002.nac"
XMP_IMAGE = ROOT / "Ie030002.xmp"
XMF_IMAGE = ROOT / "main211.xmf"


@unittest.skipUnless(IMAGE.exists(), "ISDN Courier NAC image is not present")
class NacImageTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.image = NacImage.load(IMAGE)

    def test_header_declares_the_record_stream_length(self) -> None:
        self.assertEqual(
            self.image.stream_length,
            len(self.image.data) - HEADER_SIZE - TRAILER_SIZE,
        )

    def test_header_identifies_the_product_and_version(self) -> None:
        self.assertEqual(self.image.product, "IE(")
        self.assertEqual(self.image.version, (3, 0, 2))

    def test_the_stream_opens_by_setting_the_flash_segment(self) -> None:
        first = self.image.records[0]
        self.assertEqual(first.file_offset, HEADER_SIZE)
        self.assertEqual(first.kind, RECORD_EXTENDED_SEGMENT)
        self.assertEqual(first.data, bytes([0x40, 0x00]))
        # Segment 0x4000 puts the image at physical 0x40000, so the base comes
        # from the file rather than from an assumption in the harness.
        self.assertEqual(self.image.load_base, 0x40000)

    def test_the_stream_ends_with_an_eof_record(self) -> None:
        self.assertEqual(self.image.records[-1].kind, RECORD_EOF)
        self.assertEqual(self.image.records[-1].data, b"")

    def test_record_kinds_are_limited_to_the_recovered_set(self) -> None:
        kinds = {record.kind for record in self.image.records}
        self.assertEqual(
            kinds,
            {RECORD_DATA, RECORD_EOF, RECORD_EXTENDED_SEGMENT, RECORD_START_SEGMENT},
        )

    def test_data_records_never_exceed_sixteen_bytes(self) -> None:
        self.assertTrue(all(record.length <= 0x10 for record in self.image.data_records))

    def test_start_segment_address(self) -> None:
        self.assertEqual(self.image.start_segment, 0x0CE0)
        self.assertEqual(self.image.start_offset, 0x0000)
        self.assertEqual(self.image.entry_physical, 0xCE00)

    def test_flatten_covers_the_whole_flash_payload(self) -> None:
        base, image = self.image.flatten()
        self.assertEqual(base, 0x40000)
        self.assertEqual(len(image), 0xB8000)

    def test_spans_are_disjoint_and_ordered(self) -> None:
        spans = self.image.spans
        self.assertTrue(spans)
        for (address, payload), (next_address, _) in zip(spans, spans[1:], strict=False):
            self.assertLess(address + len(payload), next_address)
        self.assertEqual(self.image.painted_bytes, sum(len(p) for _, p in spans))

    def test_extract_writes_header_and_flattened_image(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            header_path, image_path = self.image.extract(directory)
            self.assertEqual(header_path.read_bytes(), self.image.header)
            self.assertEqual(image_path.read_bytes(), self.image.flatten()[1])

    def test_load_image_dispatches_to_nac(self) -> None:
        self.assertIsInstance(load_image(IMAGE), NacImage)

    def test_describe_reports_the_undecoded_trailer(self) -> None:
        described = self.image.describe()
        self.assertEqual(described["format"], "nac")
        self.assertEqual(described["version"], "3.0.2")
        # The two bytes after the EOF record are not a byte sum of the stream
        # and match no common CRC-16, so they are reported verbatim.
        self.assertEqual(described["trailer_undecoded"], self.image.trailer.hex())


@unittest.skipUnless(
    IMAGE.exists() and XMP_IMAGE.exists(), "both ISDN Courier images are needed"
)
class NacAgreesWithXmpTests(unittest.TestCase):
    """The NAC and the XMP carry the same firmware in different containers."""

    @classmethod
    def setUpClass(cls) -> None:
        cls.nac = NacImage.load(IMAGE)
        cls.xmp = XmpImage.load(XMP_IMAGE)

    def test_same_load_base_and_size(self) -> None:
        base, image = self.nac.flatten()
        self.assertEqual(base, self.xmp.load_base)
        self.assertEqual(len(image), len(self.xmp.payload))

    def test_flattened_images_are_identical(self) -> None:
        self.assertEqual(self.nac.flatten()[1], self.xmp.payload)

    def test_every_painted_span_matches_the_xmp_payload(self) -> None:
        for address, payload in self.nac.spans:
            offset = address - self.xmp.load_base
            self.assertEqual(self.xmp.payload[offset : offset + len(payload)], payload)

    def test_unpainted_bytes_are_erased_flash(self) -> None:
        _, image = self.nac.flatten()
        painted = bytearray(len(image))
        for address, payload in self.nac.spans:
            start = address - self.nac.load_base
            painted[start : start + len(payload)] = b"\x01" * len(payload)
        gaps = [i for i, seen in enumerate(painted) if not seen]
        self.assertTrue(gaps)
        self.assertTrue(all(self.xmp.payload[i] == 0xFF for i in gaps))


@unittest.skipUnless(IMAGE.exists(), "ISDN Courier NAC image is not present")
class NacRejectionTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.data = IMAGE.read_bytes()

    def _load(self, data: bytes) -> NacImage:
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "broken.nac"
            path.write_bytes(data)
            return NacImage.load(path)

    def test_rejects_a_short_file(self) -> None:
        with self.assertRaises(NacFormatError):
            self._load(b"\x00" * 8)

    def test_rejects_a_wrong_declared_stream_length(self) -> None:
        broken = bytearray(self.data)
        struct.pack_into("<I", broken, STREAM_LENGTH_OFFSET, self.image_length() + 1)
        with self.assertRaises(NacFormatError):
            self._load(bytes(broken))

    def image_length(self) -> int:
        return len(self.data) - HEADER_SIZE - TRAILER_SIZE

    def test_rejects_an_unknown_record_type(self) -> None:
        broken = bytearray(self.data)
        # The first record is the extended segment record at the stream start.
        broken[HEADER_SIZE + 3] = 0x7F
        with self.assertRaises(NacFormatError):
            self._load(bytes(broken))

    def test_rejects_a_data_record_before_any_segment_record(self) -> None:
        broken = bytearray(self.data)
        broken[HEADER_SIZE + 3] = RECORD_DATA
        with self.assertRaises(NacFormatError):
            self._load(bytes(broken))

    @unittest.skipUnless(XMF_IMAGE.exists(), "XMF image is not present")
    def test_an_xmf_is_not_a_nac(self) -> None:
        with self.assertRaises(NacFormatError):
            NacImage.load(XMF_IMAGE)


class LoadImageReportsEveryFormat(unittest.TestCase):
    def test_message_names_all_four_containers(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            junk = Path(directory) / "junk.bin"
            junk.write_bytes(b"not a firmware image")
            with self.assertRaises(XmfFormatError) as caught:
                load_image(junk)
        message = str(caught.exception)
        for name in ("XMF", "ROM", "XMP", "NAC"):
            self.assertIn(name, message)
