import struct

import pytest

from courier_emu.dsp import NativeC5x


def program(*words: int) -> bytes:
    return struct.pack(f"<{len(words)}H", *words)


def test_greg_keeps_low_byte_and_reads_unused_bits_high():
    # SPLK @GREG,#80; LAMM @GREG
    with NativeC5x.from_program(
        0, program(0xAE05, 0x0080, 0x0805), rebuild=True
    ) as core:
        assert core.register(0x05) == 0xFF00
        core.step(1)
        assert core.register(0x05) == 0xFF80
        core.step(1)
        assert core.state()["acc"] & 0xFFFF == 0xFF80


def run_mapped_read(greg: int) -> int:
    # Set GREG, put a sentinel in the selected view at 8000, then read through
    # the core's mapped data-space API. Instruction-level GREG access is
    # covered above without making this test depend on an ARP setup sequence.
    with NativeC5x.from_program(
        0, program(0xAE05, greg, 0x8B00), separate_global_memory=True
    ) as core:
        core.step(1)
        core.set_data(0x8000, 0x1234)
        return core.data(0x8000)


def test_greg_80_routes_upper_half_to_global_storage():
    assert run_mapped_read(0x80) == 0x1234


def test_greg_zero_leaves_upper_half_on_local_board_mapping():
    assert run_mapped_read(0x00) == 0x1234


def test_global_and_local_views_do_not_alias():
    words = [0xAE05, 0x0000, 0x8B00]
    with NativeC5x.from_program(0, program(*words), separate_global_memory=True) as core:
        core.step(1)
        core.set_data(0x8000, 0x1111)
        core.load_program(program(0xAE05, 0x0080), 0)
        core.set_pc(0)
        core.step(1)
        core.set_data(0x8000, 0x2222)
        assert core.data(0x8000) == 0x2222
        core.load_program(program(0xAE05, 0x0000), 0)
        core.set_pc(0)
        core.step(1)
        assert core.data(0x8000) == 0x1111


def test_greg_does_not_invent_a_board_memory_bank():
    with NativeC5x.from_program(0, program(0xAE05, 0x80)) as core:
        core.set_data(0x8000, 0x1234)
        core.step(1)
        assert core.data(0x8000) == 0x1234
        core.set_data(0x8000, 0x5678)
        assert core.program(0x8000) == 0x5678


@pytest.mark.parametrize('greg', [0x80, 0xC0, 0xE0, 0xF0, 0xF8, 0xFC, 0xFE, 0xFF])
def test_documented_global_allocation_boundaries(greg):
    boundary = greg << 8
    code = program(0xAE05, greg, 0xAE05, 0)
    with NativeC5x.from_program(0, code, separate_global_memory=True) as core:
        core.set_data(boundary - 1, 0x1111)
        core.set_data(boundary, 0x2222)
        core.set_data(0xFFFF, 0x3333)
        core.step(1)
        assert core.data(boundary - 1) == 0x1111
        assert core.data(boundary) == 0
        assert core.data(0xFFFF) == 0
        core.set_data(boundary, 0x4444)
        core.step(1)
        assert core.data(boundary) == 0x2222
        assert core.data(0xFFFF) == 0x3333
