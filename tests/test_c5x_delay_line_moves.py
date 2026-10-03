"""SPRU056D DMOV/LTD copy only within on-chip data RAM."""
import struct

import pytest

from courier_emu.dsp import NativeC5x


@pytest.mark.parametrize("opcode", [0x7790, 0x7290])  # DMOV/LTD *-
@pytest.mark.parametrize("address, moves", [
    (0x0060, True), (0x02FF, True), (0x0300, True),
    (0x0800, True), (0x8100, False), (0xCFFF, False),
    (0x0018, False),
])
def test_delay_line_copy_respects_the_memory_region(opcode, address, moves):
    code = struct.pack('<5H', 0xBF09, address, 0x8B89, opcode, 0x8B00)
    with NativeC5x.from_program(0x6000, code) as core:
        core.host_write(7, 0x30)  # SARAM mapped into data and program space.
        write = core.host_write if address < 0x60 else core.set_data
        write(address, 7)
        write(address + 1, 0x1234)
        core.set_pc(0x6000)
        core.step(4)
        actual = core.register(address + 1) if address < 0x60 else core.data(address + 1)
        assert actual == (7 if moves else 0x1234)
        assert core.state()['ar1'] == address - 1
        assert core.serial_state()['delay_move_ignored'] == (0 if moves else 1)
        if opcode == 0x7290:
            assert core.register(0x0C) == 7  # LTD still loads TREG0.
