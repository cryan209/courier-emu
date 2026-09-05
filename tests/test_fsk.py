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


def test_the_firmware_bit_clock_advances_once_per_invocation(rom):
    """@50 is a shift register the modulator advances every call.

    This is why no baud figure in this harness is the firmware's: the ROM
    presents one data bit per modulator invocation, which does not reconcile
    with 300 bps at the 7200 Hz the carrier increments imply.
    """
    import struct

    from courier_emu.answer_tone import FIXTURES
    from courier_emu.dsp import NativeC5x

    driver = [0xBC07, 0xBF01, 0xBF0F, 0x0BC0, 0x7980, 0x80C7,
              0xBC07, 0x7A80, 0xD7B4, 0x7A80, 0xD94E, 0x7980, 0]
    driver += [0] * (0x23 - len(driver))
    driver[0x22] = 0xBE3A          # RETE for the receiver's INTR 17

    with NativeC5x(rom) as core:
        core.load_rom(struct.pack('<%dH' % len(driver), *driver))
        core.set_mpmc_pin(0)
        for address, value in FIXTURES:
            core.set_data(address, value)
        core.set_pc(6)

        def until(pc, limit):
            for _ in range(limit):
                core.step(1)
                if core.state()['pc'] == pc:
                    return
            raise RuntimeError(hex(pc))

        until(0, 400)
        assert core.data(0x3D0) == 0x0704   # d94e's own reload
        seen = []
        for _ in range(6):
            seen.append(core.data(0x3D0))
            until(0x80C3, 900)
            core.set_pc(0x8178)
            until(0x8199, 150)
            core.set_data(0x390, 0x0BC0)
            core.set_pc(0)

    assert seen == [0x0704, 0x0382, 0x01C1] * 2


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
