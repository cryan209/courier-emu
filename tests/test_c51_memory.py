"""C51 bus mapping, checked using guest program-memory writes."""
import struct

import pytest

from courier_emu.dsp import NativeC5x


def words(*values):
    return struct.pack('<' + 'H' * len(values), *values)


@pytest.mark.parametrize('address', [0, 0x7ff, 0x800, 0x1fff, 0x2000, 0x23ff, 0x2400])
def test_program_write_respects_rom_and_saram_boundaries(address):
    # Enable RAM and OVLY; load address into ACC; TBLW from B2 data cell.
    code = words(0xbc00, 0x5d07, 0x0030, 0xbf80, address, 0xa760, 0xbe22)
    with NativeC5x.from_program(0x8000, code) as core:
        core.load_rom(words(*([0x1357] * 0x2000)))
        core.set_mpmc_pin(0)
        core.set_data(0x60, 0x2468)
        core.set_pc(0x8000)
        core.step(4)
        assert core.program(address) == (0x1357 if address < 0x2000 else 0x2468)
        if 0x2000 <= address < 0x2400:
            assert core.data(address - 0x1800) == 0x2468
            core.set_data(address - 0x1800, 0x5678)
            assert core.program(address) == 0x5678


def test_mpmc_exposes_external_program_memory_beneath_rom():
    with NativeC5x.from_program(0x8000, words(0xbe22)) as core:
        core.load_rom(words(*([0x1357] * 0x2000)))
        core.load_program(words(0x2468), 0x1fff)
        core.set_mpmc_pin(0)
        assert core.program(0x1fff) == 0x1357
        core.set_mpmc_pin(1)
        assert core.program(0x1fff) == 0x2468


@pytest.mark.parametrize('origin,image', [(0x2000, words(1)), (0xffff, words(1)), (0x1fff, words(1, 2))])
def test_rom_load_rejects_out_of_range(origin, image):
    with NativeC5x.from_program(0x8000, words(0xbe22)) as core:
        with pytest.raises(RuntimeError, match='exceeds'):
            core.load_rom(image, origin)


def test_ram_and_ovly_control_the_two_saram_windows_independently():
    # Set RAM/OVLY, clear RAM, then clear OVLY.
    code = words(0xbc00, 0x5d07, 0x0030, 0x5e07, 0xffef, 0x5e07, 0xffdf, 0xbe22)
    with NativeC5x.from_program(0x8000, code) as core:
        core.load_program(words(0x1111), 0x2000)
        core.set_data(0x800, 0x2222)
        core.set_pc(0x8000)
        core.step(2)
        assert core.program(0x2000) == 0x2222
        assert core.memory_map()['ram'] == core.memory_map()['ovly'] == 1
        core.step(1)
        assert core.program(0x2000) == 0x1111
        assert core.memory_map()['ram'] == 0
        assert core.memory_map()['ovly'] == 1
        core.step(1)
        assert core.memory_map()['ovly'] == 0
