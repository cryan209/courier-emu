"""Instruction costs from SPRU056D, excluding separately executed delay slots."""
import struct

import pytest

from courier_emu.dsp import NativeC5x


def words(*values):
    return struct.pack('<%dH' % len(values), *values)


@pytest.mark.parametrize('opcode', [0xBF80, 0xBFC0, 0xBFD0])
def test_long_immediate_load_and_logic_take_two_cycles(opcode):
    with NativeC5x.from_program(0x6000, words(opcode, 7)) as core:
        core.set_pc(0x6000)
        core.step(1)
        assert core.state()['cycles'] == 2


@pytest.mark.parametrize('branch', [
    (0x7E80, 0x6010),  # CALLD
    (0xF300, 0x6010),  # BCNDD unconditional
    (0x7F80, 0x6010),  # BANZD with nonzero AR0
    (0xBE3D,),         # CALAD
    (0xFF00,),         # RETD
])
def test_delayed_transfer_costs_two_cycles_plus_its_delay_slots(branch):
    # LAR AR0=1, LACC target, PUSH return target; then the transfer and NOPs.
    setup = (0xBF08, 1, 0xBF80, 0x6010, 0xBE3C)
    with NativeC5x.from_program(0x6000, words(*setup, *branch, 0x8B00, 0x8B00)) as core:
        core.set_pc(0x6000)
        core.step(3)
        before = core.state()['cycles']
        core.step(1)
        assert core.state()['cycles'] - before == 4
        assert core.state()['pc'] == 0x6010
