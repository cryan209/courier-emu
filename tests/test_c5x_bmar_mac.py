import struct

import pytest

from courier_emu.dsp import NativeC5x


def words(*values):
    return struct.pack(f'<{len(values)}H', *values)


@pytest.mark.parametrize('opcode,move', [(0xAB90, True), (0xAA90, False)])
@pytest.mark.parametrize('dma,pma,taps,cycles', [
    (0x30f, 0x7000, 1, 2),
    (0x30f, 0x7000, 12, 13),
    (0x810f, 0x7000, 12, 25),
])
def test_bmar_filter_pipeline_and_products(opcode, move, dma, pma, taps, cycles):
    # Signed convolution, descending delay line, ascending coefficients.
    code = words(0xBF09, dma, 0x8B89, 0xBB00 | (taps - 1), opcode, 0xBE04)
    with NativeC5x.from_program(0x6000, code) as core:
        core.host_write(0x1f, pma)
        core.load_program(words(*range(1, taps + 1)), pma)
        for k in range(taps):
            core.set_data(dma - k, (-k - 1) & 0xffff)
        core.set_data(dma + 1, 0x1234)
        core.set_pc(0x6000)
        core.step(3)
        before = core.state()['cycles']
        core.step(1)
        assert core.state()['cycles'] - before == cycles
        core.step(1)  # APAC: include the final product in the convolution.
        assert core.state()['acc'] == -sum(k * k for k in range(1, taps + 1))
        on_chip = dma < 0x500
        assert core.data(dma + 1) == (0xffff if move and on_chip else 0x1234)


@pytest.mark.parametrize('opcode,cycles', [(0xAB90, 23), (0xAA90, 13)])
def test_bmar_saram_delay_line_bus_contention(opcode, cycles):
    code = words(0xBF09, 0x80f, 0x8B89, 0xBB0B, opcode)
    with NativeC5x.from_program(0x6000, code) as core:
        core.host_write(7, 0x30)  # SARAM data window enabled.
        core.host_write(0x1f, 0x7000)
        core.set_pc(0x6000)
        core.step(3)
        before = core.state()['cycles']
        core.step(1)
        assert core.state()['cycles'] - before == cycles


def test_macd_does_not_move_external_data():
    with NativeC5x.from_program(0x6000, words(0xA361, 0x7000)) as core:
        core.host_write(7, 0x00)
        core.load_program(words(0xBF09, 0x8100, 0x8B89, 0xA390, 0x7000), 0x6000)
        core.set_data(0x8100, 7)
        core.set_data(0x8101, 0x1234)
        core.set_pc(0x6000)
        core.step(3)
        assert core.data(0x8101) == 0x1234
