"""The configuration sector's CRC and record layout."""
import struct
from pathlib import Path

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
        BUS_CONFIGURATION, DATA_DIRECTORY_NUMBER, DATA_SPID, DATA_TEI,
        DIALING_MODE, SWITCH_PROTOCOL, VOICE_DIRECTORY_NUMBER, VOICE_SPID,
        VOICE_TEI, set_data_directory_number, set_data_spid,
        set_dialing_mode, set_voice_directory_number, set_voice_spid,
    )
    assert (SWITCH_PROTOCOL, BUS_CONFIGURATION) == (0, 1)
    assert (VOICE_SPID, DATA_SPID) == (2, 23)
    assert (VOICE_DIRECTORY_NUMBER, DATA_DIRECTORY_NUMBER) == (44, 65)
    assert (VOICE_TEI, DATA_TEI, DIALING_MODE) == (86, 88, 90)

    sealed = set_voice_directory_number(seal(blank_sector()), "5551000")
    block = read_isdn_block(sealed)
    assert block[44:52] == b"5551000\x00"
    assert page_is_sealed(sealed[:PAGE_SIZE])

    # Each of these byte sequences was produced by an isolated AT command +
    # AT&W run and was the only ISDN-block difference from the baseline page.
    cases = (
        (set_voice_spid, "11112222", 2, b"11112222\x00"),
        (set_data_spid, "22223333", 23, b"22223333\x00"),
        (set_data_directory_number, "44445555", 65, b"44445555\x00"),
    )
    for setter, value, offset, expected in cases:
        sector = setter(seal(blank_sector()), value)
        block = read_isdn_block(sector)
        assert block[offset:offset + len(expected)] == expected
        assert all(page_is_sealed(
            sector[page * PAGE_SIZE:(page + 1) * PAGE_SIZE]
        ) for page in range(2))
    dialing = set_dialing_mode(seal(blank_sector()), 1)
    assert read_isdn_block(dialing)[90] == ord("1")


def test_a_directory_number_that_does_not_fit_is_refused():
    from courier_emu.imodem_config import set_voice_directory_number
    with pytest.raises(ValueError):
        # The recovered field spans 21 bytes and needs one byte for NUL.
        set_voice_directory_number(seal(blank_sector()), "123456789012345678901")


def test_the_identity_fields_sit_where_the_firmware_reads_them():
    from courier_emu.imodem_config import (
        MAC_ADDRESS, MAC_ADDRESS_LENGTH, SERIAL_NUMBER, SERIAL_NUMBER_LENGTH,
        SERIAL_NUMBER_SPAN, read_mac_address, read_serial_number,
        set_record_bytes,
    )
    # 0x011 for 15 bytes, then 0x020 for 8 - contiguous, as observed. ATI7
    # prints only the first twelve of the serial.
    assert SERIAL_NUMBER_LENGTH == 12
    assert SERIAL_NUMBER + SERIAL_NUMBER_SPAN == MAC_ADDRESS
    assert MAC_ADDRESS + MAC_ADDRESS_LENGTH == 0x028

    sealed = set_record_bytes(seal(blank_sector()), SERIAL_NUMBER,
                              b"IMD0123456789\x00\x00")
    sealed = set_record_bytes(sealed, MAC_ADDRESS,
                              bytes.fromhex("00c04901ab74") + b"\x00\x00")
    for page in range(2):
        # Twelve characters, which is what ATI7 printed for this same record.
        assert read_serial_number(sealed, page) == b"IMD012345678"
        assert read_mac_address(sealed, page)[:3] == bytes.fromhex("00c049")
        assert page_is_sealed(sealed[page * PAGE_SIZE:(page + 1) * PAGE_SIZE])


def test_serial_number_setter_writes_both_pages_and_pads_the_display_field():
    from courier_emu.imodem_config import read_serial_number, set_serial_number

    sealed = set_serial_number(seal(blank_sector()), "IMODEM1")
    for page in range(2):
        assert read_serial_number(sealed, page) == b"IMODEM1     "
        assert page_is_sealed(
            sealed[page * PAGE_SIZE:(page + 1) * PAGE_SIZE]
        )


def test_serial_number_setter_rejects_non_ascii_and_overlength_values():
    from courier_emu.imodem_config import set_serial_number

    with pytest.raises(ValueError, match="ASCII"):
        set_serial_number(
            seal(blank_sector()),
            "I-m\N{LATIN SMALL LETTER O WITH DIAERESIS}dem",
        )
    with pytest.raises(ValueError, match="at most 12"):
        set_serial_number(seal(blank_sector()), "1234567890123")


def test_aty14_is_the_six_reversed_factory_header_bytes():
    from courier_emu.imodem_config import read_aty14, set_aty14

    blank = seal(blank_sector())
    assert read_aty14(blank) is None, "erased header is the firmware's `,,,,,` case"

    displayed = (0, 0, 30, 7, 30, 0)
    sealed = set_aty14(blank, displayed)
    for page in range(2):
        assert read_aty14(sealed, page) == displayed
        start = page * PAGE_SIZE + 1
        assert sealed[start:start + 6] == bytes(reversed(displayed))
        assert page_is_sealed(
            sealed[page * PAGE_SIZE:(page + 1) * PAGE_SIZE]
        )


def test_aty14_setter_validates_the_six_byte_record():
    from courier_emu.imodem_config import set_aty14

    blank = seal(blank_sector())
    with pytest.raises(ValueError, match="requires 6"):
        set_aty14(blank, [0] * 5)
    with pytest.raises(ValueError, match="fit in a byte"):
        set_aty14(blank, [0, 0, 0, 0, 0, 256])


def test_a_record_write_that_would_hit_the_trailer_is_refused():
    from courier_emu.imodem_config import TRAILER_OFFSET, set_record_bytes
    with pytest.raises(ValueError):
        set_record_bytes(seal(blank_sector()), TRAILER_OFFSET - 1, b"ab")


def test_the_verified_data_bearer_values_are_binary_at_025f():
    from courier_emu.imodem_config import (
        DATA_BEARER, DATA_BEARERS, read_data_bearer, set_data_bearer,
    )

    assert DATA_BEARER == 0x25F
    assert DATA_BEARERS[3] == "Modem/Fax Emulation"
    for value in DATA_BEARERS:
        sector = set_data_bearer(seal(blank_sector()), value)
        assert read_data_bearer(sector) == value
        assert read_data_bearer(sector, page=1) == value
        assert all(page_is_sealed(
            sector[page * PAGE_SIZE:(page + 1) * PAGE_SIZE]
        ) for page in range(2))


def test_an_unknown_data_bearer_is_refused():
    from courier_emu.imodem_config import set_data_bearer
    with pytest.raises(ValueError):
        set_data_bearer(seal(blank_sector()), 7)


def test_a_scripted_spid_command_reaches_the_firmware_and_flash():
    """End-to-end guard for the CR-before-LF command delivery race."""
    image = Path("Ie030002.nac")
    if not image.exists():
        pytest.skip("local I-modem firmware not available")

    from courier_emu.isdn import IsdnMachine
    from courier_emu.isdn_console import scripted_pump
    from courier_emu.nac import NacImage

    transcript = []
    commands = ["AT", "AT*S1=11112222", "AT&W"]
    machine = IsdnMachine(
        NacImage.load(image), profile=False,
        serial_pump=scripted_pump(commands, every=0, transcript=transcript),
    )
    machine.run(35_000_000)

    assert [text for _, direction, text in transcript if direction == "sent"] == [
        command + "\r" for command in commands
    ]
    pages = (
        bytes(machine.flash.contents[offset:offset + PAGE_SIZE])
        for offset in range(0x78000, 0x7C000, PAGE_SIZE)
    )
    assert any(
        page_is_sealed(page)
        and read_isdn_block(page).startswith(b"\xff\xff11112222\x00")
        for page in pages
    )
