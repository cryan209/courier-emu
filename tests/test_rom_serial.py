"""The board ROM reaches its serial port and identifies itself."""
import codecs
from pathlib import Path

import pytest

from courier_emu.images import load_image
from courier_emu.machine import CourierMachine

ROM = Path("artifacts/courier-board-21210-capture-01/courier-board.rom")
# The live board's own strap code: BOARD_CAPABILITY[7] is 0x22, which is what
# the modem's RAM holds at [0x693].
BOARD_ID = 7


@pytest.mark.skipif(not ROM.exists(), reason="board ROM capture not present")
def test_rom_emits_its_plug_and_play_identifier():
    machine = CourierMachine(
        load_image(ROM), tick_ms=10, board_id=BOARD_ID, serial_input=b"ATI\r"
    )
    machine.run(60_000_000)
    # Seven-bit data with the eighth bit set on the wire.
    text = bytes(byte & 0x7F for byte in machine.serial).decode("ascii")
    assert "Courier V.Everything EXT" in text
    assert "MODEM" in text and "PNPC107" in text
    assert machine.uart.transmitted == len(machine.serial)
    assert machine.uart.received == 4
    assert not machine.serial_rx
