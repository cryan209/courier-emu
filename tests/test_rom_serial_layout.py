from pathlib import Path

import pytest

from courier_emu.machine import serial_callback_table
from courier_emu.rom_serial import RomSerialLayout, locate_rom_serial


@pytest.mark.parametrize("path,expected", [
    ("IDSDL302.ROM", RomSerialLayout(0x26a, 0xf23, 0xf170, 0x931d, 0x93b0, 0x33e, 0xea7)),
    ("artifacts/courier-board-21210-capture-403/courier-board.rom",
     RomSerialLayout(0x164, 0xf54, 0xf1a0, 0x93b0, 0x9443, 0x237, 0xd93)),
])
def test_resident_serial_layout(path, expected):
    source = Path(__file__).resolve().parent.parent / path
    if not source.exists():
        pytest.skip("reference ROM not present")
    data = source.read_bytes()
    assert locate_rom_serial(data, serial_callback_table(data)) == expected
    assert locate_rom_serial(data, expected.callbacks + 2) is None
    # A partly recognized ROM must not enable the adapter.
    damaged = bytearray(data)
    damaged[expected.attention] = 0
    assert locate_rom_serial(bytes(damaged), expected.callbacks) is None


def test_unknown_rom_has_no_serial_adapter():
    assert locate_rom_serial(bytes(0x80000), 0x26a) is None


def test_terminal_stays_connected_after_last_queued_byte():
    from courier_emu.images import load_image
    from courier_emu.machine import CourierMachine
    source = Path(__file__).resolve().parent.parent / "IDSDL302.ROM"
    if not source.exists():
        pytest.skip("reference ROM not present")
    machine = CourierMachine(load_image(source), serial_input=b"AT\r")
    machine.serial_rx.clear()
    assert machine._terminal_attached
    unattached = CourierMachine(load_image(source))
    assert not unattached._terminal_attached
    unattached.serial_rx.extend(b"AT\r")
    assert unattached._terminal_attached
    unattached.serial_rx.clear()
    assert unattached._terminal_attached
