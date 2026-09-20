import struct

import pytest

from courier_emu.dsp import NativeC5x


def words(*values):
    return struct.pack(f'<{len(values)}H', *values)


def pmst(core, value):
    core.load_program(words(0xAE07, value), 0x6000)  # SPLK @PMST,#value
    core.set_pc(0x6000)
    core.step(1)


@pytest.mark.parametrize('model,first,size', [('c51', 0x2000, 0x400), ('c53', 0x4000, 0xC00)])
def test_saram_mapping_and_external_storage_are_independent(model, first, size):
    with NativeC5x.from_program(0x6000, b'', model=model) as core:
        for offset in (0, size - 1):
            core.load_program(words(0x1111), first + offset)
            core.set_data(0x800 + offset, 0x2222)
        pmst(core, 0x30)  # RAM + OVLY
        for offset in (0, size - 1):
            core.set_data(0x800 + offset, 0x3333)
            assert core.program(first + offset) == 0x3333
        # Both switches independently expose external storage.
        pmst(core, 0x10)
        assert core.data(0x800) == 0x2222
        assert core.program(first) == 0x3333
        pmst(core, 0x20)
        assert core.data(0x800) == 0x3333
        assert core.program(first) == 0x1111
        # One word beyond the selected part's SARAM stays external.
        pmst(core, 0x30)
        core.load_program(words(0x4444), first + size)
        core.set_data(0x800 + size, 0x5555)
        assert core.program(first + size) == 0x4444
        assert core.data(0x800 + size) == 0x5555
        core.reset()
        pmst(core, 0x30)
        assert core.program(first + size - 1) == 0x3333


@pytest.mark.parametrize('model,size', [('c51', 0x2000), ('c53', 0x4000)])
def test_rom_size_and_mpmc(model, size):
    with NativeC5x.from_program(0x6000, b'', model=model) as core:
        core.load_rom(words(0x1234), size - 1)
        core.load_program(words(0x5678), size - 1)
        pmst(core, 0)
        assert core.program(size - 1) == 0x1234
        pmst(core, 0x08)
        assert core.program(size - 1) == 0x5678
        with pytest.raises(RuntimeError, match='on-chip ROM'):
            core.load_rom(words(0), size)


def test_c53_does_not_inherit_courier_external_ram_wiring():
    with NativeC5x.from_program(0x8000, words(0x1234), model='c53') as core:
        core.set_data(0x8000, 0x5678)
        assert core.program(0x8000) == 0x1234
        assert core.data(0x8000) == 0x5678


def test_unknown_model_is_rejected():
    with pytest.raises(ValueError, match='unsupported DSP model'):
        NativeC5x.from_program(0, b'', model='c52')


@pytest.mark.parametrize('model,first', [('c51', 0x2000), ('c53', 0x4000)])
def test_guest_table_write_and_instruction_fetch_use_saram(model, first):
    with NativeC5x.from_program(0x6000, b'', model=model) as core:
        pmst(core, 0x30)
        core.set_data(0x60, first)
        core.set_data(0x61, 0xB92A)  # LACL #42
        core.load_program(words(0x6960, 0xA761), 0x6000)  # LACL @60; TBLW @61
        core.set_pc(0x6000)
        core.step(2)
        assert core.data(0x800) == 0xB92A
        core.set_pc(first)
        core.step(1)
        assert core.state()['acc'] == 42


def test_cnf_program_writes_reach_physical_b0():
    # SETC CNF; LACL @60; TBLW @61; CLRC CNF
    with NativeC5x.from_program(0x6000, words(0xBE45, 0x6960, 0xA761, 0xBE44)) as core:
        core.set_data(0x60, 0xFE00)
        core.set_data(0x61, 0x1234)
        core.set_pc(0x6000)
        core.step(3)
        assert core.program(0xFE00) == 0x1234
        core.step(1)
        assert core.data(0x100) == 0x1234


@pytest.mark.parametrize('model', ['c51', 'c53'])
@pytest.mark.parametrize('mpmc', [0, 1])
def test_vector_page_uses_program_memory_not_data_registers(model, mpmc):
    with NativeC5x.from_program(0, b'', model=model) as core:
        # Distinct executable words across the entire vector/reserved area.
        core.load_rom(words(*([0xB911] * 0x40)))
        core.load_program(words(*([0xB922] * 0x40)), 0)
        core.set_mpmc_pin(mpmc)
        core.reset()
        assert core.state()['pc'] == 0
        assert core.register(7) >> 11 == 0
        assert all(core.program(a) == (0xB922 if mpmc else 0xB911)
                   for a in range(0x40))
        core.step(1)
        assert core.state()['acc'] == (0x22 if mpmc else 0x11)
        # Program 0005 is executable memory, distinct from data GREG at 0005.
        core.set_pc(5)
        core.step(1)
        assert core.register(5) == 0xFF00
        assert core.state()['acc'] == (0x22 if mpmc else 0x11)
        core.nmi()
        core.step(1)
        assert core.state()['pc'] == 0x25
        assert core.state()['acc'] == (0x22 if mpmc else 0x11)


@pytest.mark.parametrize('model', ['c51', 'c53'])
def test_relocated_interrupt_executes_branch_and_reset_returns_to_zero(model):
    with NativeC5x.from_program(0x6000, b'', model=model) as core:
        core.set_mpmc_pin(0)
        core.load_rom(words(0xB911))
        # Relocate to external page 5800, enable INT2, clear INTM.
        core.load_program(words(0xAE07, 0x5800, 0xAE04, 2, 0xBE40), 0x6000)
        core.load_program(words(0x7980, 0x6100), 0x5804)  # B 6100
        core.load_program(words(0xB933), 0x6100)
        core.set_pc(0x6000)
        core.step(3)
        core.interrupt(1)
        assert core.state()['pc'] == 0x5804
        core.step(1)
        assert core.state()['pc'] == 0x6100
        core.step(1)
        assert core.state()['acc'] == 0x33
        core.reset()
        assert core.state()['pc'] == 0
        assert core.register(7) >> 11 == 0
        core.step(1)
        assert core.state()['acc'] == 0x11
