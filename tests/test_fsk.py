"""DSP 3.1.2's FSK modulator: V.21 and Bell 103, from the firmware's own code."""
import pytest

from courier_emu import fsk
from courier_emu.answer_tone import measure
from courier_emu.rom import CourierRom

ROM = 'artifacts/courier-board-21210-capture-403/courier-board.rom'


@pytest.fixture(scope='module')
def rom():
    return CourierRom.load(ROM)


@pytest.mark.parametrize('mode,mark,space', [
    ('v21-originate', 980, 1180),
    ('v21-answer', 1650, 1850),
    ('bell103-originate', 1270, 1070),
    ('bell103-answer', 2225, 2025),
])
def test_each_mode_keys_its_own_two_frequencies(rom, mode, mark, space):
    """A held bit produces that mode's tone, to within a hertz."""
    for bit, expected in ((1, mark), (0, space)):
        samples, _ = fsk.render(rom, [bit] * 40, 24, mode)
        assert measure(samples)['frequency_hz'] == pytest.approx(expected, abs=1.0)


def test_the_symbol_rate_is_300_baud(rom):
    """24 samples a bit at the dial path's 7200 Hz is exactly 300 baud."""
    assert fsk.RATE / 24 == 300.0


def test_a_511_bit_pattern_survives_modulation(rom):
    """V.21 answer, modulated by the ROM and demodulated independently."""
    state, bits = 0x1FF, []
    for _ in range(511):
        bits.append(state & 1)
        state = (state >> 1) | (((state ^ (state >> 4)) & 1) << 8)
    samples, armed = fsk.render(rom, bits, 24, 'v21-answer')
    assert armed['callback'] == fsk.MODULATOR
    assert armed['increment_mark'] == 0x3AAB   # 1650 Hz at 7200
    assert armed['increment_space'] == 0x41C7  # 1850 Hz at 7200
    recovered = fsk.demodulate(samples, 1650, 1850, 24)
    assert recovered == bits


def test_four_dispatch_entries_put_the_receiver_on_the_transmit_band(rom):
    """That pairing is analogue loopback: the modem listening to itself."""
    pairs = fsk.loopback_pairs()
    assert sum(pairs.values()) == 4
    assert {entry for entry, loop in pairs.items() if loop} == {
        0xD7D8, 0xD7E9, 0xD7FC, 0xD808}


def test_an_unknown_mode_is_refused(rom):
    with pytest.raises(ValueError):
        fsk.render(rom, [1], 4, 'v34')
