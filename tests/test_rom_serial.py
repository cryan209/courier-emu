"""The board ROMs reach their serial port and accept terminal input."""
from pathlib import Path

import pytest

from courier_emu.images import load_image
from courier_emu.machine import CourierMachine
from courier_emu.nvram import CourierNvram

REFERENCE_ROM = Path("IDSDL302.ROM")
# The live board's own strap code: BOARD_CAPABILITY[7] is 0x22, which is what
# the modem's RAM holds at [0x693].
BOARD_ID = 7


@pytest.mark.skipif(not REFERENCE_ROM.exists(), reason="reference ROM not present")
def test_seeded_ticked_rom_opens_dte_and_answers_at():
    machine = CourierMachine(
        load_image(REFERENCE_ROM),
        nvram=CourierNvram.idsl302_fixture(),
        tick_ms=5,
        board_id=BOARD_ID,
        serial_input=b"AT\r",
    )
    machine.run(60_000_000)
    text = bytes(byte & 0x7F for byte in machine.serial).decode("ascii")
    assert "\r\nOK\r\n" in text
    assert machine.uart.transmitted == len(machine.serial)
    assert machine.uart.received == 3
    assert not machine.serial_rx


@pytest.mark.parametrize("rom", [
    REFERENCE_ROM,
    Path("artifacts/courier-board-21210-capture-403/courier-board.rom"),
])
def test_rom_repeated_commands_and_quiet_mode(rom):
    if not rom.exists():
        pytest.skip("reference ROM not present")
    commands = b"AT\rATI\rATQ1\rATQ0\rAT\r"
    machine = CourierMachine(
        load_image(rom), nvram=CourierNvram.idsl302_fixture(), tick_ms=5,
        board_id=BOARD_ID, serial_input=commands,
    )
    machine.run(60_000_000)
    text = bytes(byte & 0x7f for byte in machine.serial).decode("ascii")
    # AT, ATI, Q0 and the final AT answer; Q1 itself must be silent.
    assert text.count("\r\nOK\r\n") == 4, repr(text)
    assert any(character.isdigit() for character in text), repr(text)
    assert machine.uart.transmitted == len(machine.serial)
    assert machine.uart.received == len(commands)
    assert not machine.serial_rx
