"""The configuration sector's CRC and record layout."""
import struct

import pytest

from courier_emu.imodem_config import (
    CRC_OFFSET, ISDN_BLOCK, ISDN_BLOCK_LENGTH, PAGE_SIZE, SECTOR_SIZE, SEED,
    crc16, page_crc, page_is_sealed, read_isdn_block, seal, set_isdn_byte,
    set_switch_protocol,
)


def test_the_transcription_is_reflected_crc16_ccitt():
    # The published check value for CRC-16/KERMIT, which is what the routine
    # at 0xba80f computes. If the transcription were wrong this would not hold.
    assert crc16(b"123456789", 0) == 0x2189


def test_the_seed_is_the_one_solved_for():
    assert SEED == 0x169E
    # The relation the two captured pages gave: with a zero seed the stored
    # word differs from the computed one by a constant, the same for both.
    body = bytes(range(256)) * 16
    assert crc16(body, SEED) != crc16(body, 0)


def blank_sector() -> bytearray:
    sector = bytearray(b"\xff" * SECTOR_SIZE)
    for page in range(2):
        base = page * PAGE_SIZE
        sector[base + 0x02E] = page
        sector[base + 0xFFA:base + 0xFFE] = bytes((0x01, 0x00, page, 0x00))
    return sector


def test_sealing_makes_every_page_verify():
    sector = blank_sector()
    assert not page_is_sealed(bytes(sector[:PAGE_SIZE]))
    sealed = seal(sector)
    for page in range(2):
        assert page_is_sealed(sealed[page * PAGE_SIZE:(page + 1) * PAGE_SIZE])


def test_sealing_is_stable():
    sealed = seal(blank_sector())
    assert seal(sealed) == sealed


def test_setting_the_switch_protocol_writes_an_ascii_digit_to_both_pages():
    sealed = set_switch_protocol(seal(blank_sector()), 4)
    for page in range(2):
        assert read_isdn_block(sealed, page)[0] == ord("4")
        assert page_is_sealed(sealed[page * PAGE_SIZE:(page + 1) * PAGE_SIZE])


def test_an_unknown_switch_protocol_is_refused():
    with pytest.raises(ValueError):
        set_switch_protocol(seal(blank_sector()), 9)


def test_the_isdn_block_ends_where_the_next_field_begins():
    # 0x1b0 + 0x5b is 0x20b, which is where the record's next field starts in
    # a captured sector - the check that the block length is right.
    assert ISDN_BLOCK + ISDN_BLOCK_LENGTH == 0x20B


def test_a_byte_past_the_block_is_refused():
    with pytest.raises(ValueError):
        set_isdn_byte(seal(blank_sector()), ISDN_BLOCK_LENGTH, 0)


def test_a_wrong_sized_sector_is_refused():
    with pytest.raises(ValueError):
        seal(b"\xff" * 16)


def test_the_recovered_field_offsets():
    from courier_emu.imodem_config import (
        BUS_CONFIGURATION, DATA_TEI, SWITCH_PROTOCOL, VOICE_DIRECTORY_NUMBER,
        VOICE_TEI, set_voice_directory_number,
    )
    assert (SWITCH_PROTOCOL, BUS_CONFIGURATION) == (0, 1)
    assert (VOICE_DIRECTORY_NUMBER, VOICE_TEI, DATA_TEI) == (44, 86, 87)

    sealed = set_voice_directory_number(seal(blank_sector()), "5551000")
    block = read_isdn_block(sealed)
    assert block[44:52] == b"5551000\x00"
    assert page_is_sealed(sealed[:PAGE_SIZE])


def test_a_directory_number_that_does_not_fit_is_refused():
    from courier_emu.imodem_config import set_voice_directory_number
    with pytest.raises(ValueError):
        set_voice_directory_number(seal(blank_sector()), "123456789")


def test_the_identity_fields_sit_where_the_firmware_reads_them():
    from courier_emu.imodem_config import (
        MAC_ADDRESS, MAC_ADDRESS_LENGTH, SERIAL_NUMBER, SERIAL_NUMBER_LENGTH,
        read_mac_address, read_serial_number, set_record_bytes,
    )
    # 0x011 for 15 bytes, then 0x020 for 8 - contiguous, as observed.
    assert SERIAL_NUMBER + SERIAL_NUMBER_LENGTH == MAC_ADDRESS
    assert MAC_ADDRESS + MAC_ADDRESS_LENGTH == 0x028

    sealed = set_record_bytes(seal(blank_sector()), SERIAL_NUMBER,
                              b"IMD0123456789\x00\x00")
    sealed = set_record_bytes(sealed, MAC_ADDRESS,
                              bytes.fromhex("00c04901ab74") + b"\x00\x00")
    for page in range(2):
        assert read_serial_number(sealed, page).split(b"\x00")[0] == b"IMD0123456789"
        assert read_mac_address(sealed, page)[:3] == bytes.fromhex("00c049")
        assert page_is_sealed(sealed[page * PAGE_SIZE:(page + 1) * PAGE_SIZE])


def test_a_record_write_that_would_hit_the_trailer_is_refused():
    from courier_emu.imodem_config import TRAILER_OFFSET, set_record_bytes
    with pytest.raises(ValueError):
        set_record_bytes(seal(blank_sector()), TRAILER_OFFSET - 1, b"ab")
