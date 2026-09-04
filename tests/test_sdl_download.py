from pathlib import Path
import struct

import pytest

from courier_emu.sdl_download import (
    BLOCKS, CRC_WORD, FLASH_BASE, IMAGE_LENGTH, KNOCK, LoaderModel, build_records,
    describe, erased_spans, flash_crc, payload_spans, record, resident_image,
)

ROOT = Path(__file__).resolve().parents[1]
REFERENCE = ROOT / "IDSDL302.ROM"
CAPTURE = ROOT / "artifacts" / "courier-board-21210-capture-01" / "courier-board.rom"

pytestmark = pytest.mark.skipif(
    not (REFERENCE.exists() and CAPTURE.exists()), reason="flash images not present"
)


def stored_crc(image: bytes) -> int:
    return struct.unpack_from("<H", image, CRC_WORD - FLASH_BASE)[0]


def test_crc_reproduces_the_word_both_images_carry():
    # The loader compares its own computation against this word at reset, so
    # agreeing with it on two independently built images pins the algorithm.
    for path in (REFERENCE, CAPTURE):
        image = path.read_bytes()
        assert flash_crc(image, image_type=2) == stored_crc(image)


def test_knock_matches_the_constant_in_the_boot_block():
    capture = CAPTURE.read_bytes()
    assert capture[0x7C141:0x7C141 + len(KNOCK)] == KNOCK


def test_erase_skips_the_parameter_blocks_and_keeps_the_boot_block():
    for image_type in (2, 4):
        spans = erased_spans(image_type)
        assert (0xF8000, 0x2000) not in spans
        assert (0xFA000, 0x2000) not in spans
        assert BLOCKS[6] in spans
    assert erased_spans(2)[0] == BLOCKS[2]
    assert erased_spans(4)[0] == BLOCKS[0]


def test_payload_leaves_the_crc_word_to_the_loader():
    for image_type in (2, 4):
        covered = payload_spans(image_type)
        assert not any(
            start <= CRC_WORD < start + length for start, length in covered
        )
        assert sum(length for _, length in covered) == sum(
            length for _, length in erased_spans(image_type)
        ) - 2


def test_record_checksum_sums_to_zero():
    body = record(0x1234, 0, bytes(range(16)))
    assert sum(body) & 0xFF == 0
    assert body[:4] == bytes((16, 0x12, 0x34, 0))


@pytest.mark.parametrize("image_type", (2, 4))
def test_stream_reconstructs_the_image_without_touching_protected_flash(image_type):
    image = REFERENCE.read_bytes()
    model = LoaderModel(erased_spans(image_type))
    # Feeding raises if any record programs flash the loader has not erased.
    assert model.feed(build_records(image, image_type)) == 0x17
    for index in range(IMAGE_LENGTH):
        if model.written[index]:
            assert model.memory[index] == image[index]
    assert not any(model.written[0xF8000 - FLASH_BASE:0xFC000 - FLASH_BASE])
    assert not any(model.written[CRC_WORD - FLASH_BASE:CRC_WORD - FLASH_BASE + 2])


def test_full_image_download_writes_every_erased_byte():
    image = REFERENCE.read_bytes()
    model = LoaderModel(erased_spans(4))
    model.feed(build_records(image, 4))
    assert sum(model.written) == IMAGE_LENGTH - 0x4000 - 2


def test_resident_image_keeps_unerased_blocks_from_the_current_flash():
    image = REFERENCE.read_bytes()
    preserved = CAPTURE.read_bytes()
    resident = resident_image(image, preserved, image_type=2)
    assert resident[0:0x40000] == preserved[0:0x40000]
    assert resident[0x78000:0x7C000] == preserved[0x78000:0x7C000]
    assert resident[0x40000:0x77FFE] == image[0x40000:0x77FFE]
    assert resident[0x77FFE:0x78000] == b"\xff\xff"


def test_type_two_expectation_equals_the_word_the_reference_ships():
    image = REFERENCE.read_bytes()
    preserved = CAPTURE.read_bytes()
    report = describe(image, preserved, image_type=2, chunk=128)
    assert report["expected_crc"] == report["stored_crc_in_image"] == stored_crc(image)
    assert report["model_mismatches"] == 0
    assert report["model_result"] == 0x17


def test_type_four_expectation_differs_and_is_deterministic():
    image = REFERENCE.read_bytes()
    preserved = CAPTURE.read_bytes()
    report = describe(image, preserved, image_type=4, chunk=128)
    # The type 4 walk sums c0000..fffff before the type 2 span, so it covers the
    # parameter blocks and the boot block; the value is not the shipped word.
    assert report["expected_crc"] != stored_crc(image)
    assert report["model_mismatches"] == 0
    other = describe(image, preserved, image_type=4, chunk=64)
    assert other["expected_crc"] == report["expected_crc"]
