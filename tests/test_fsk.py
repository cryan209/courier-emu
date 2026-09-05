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


@pytest.mark.parametrize('mode', sorted(fsk.MODES))
def test_the_firmware_demodulates_its_own_transmitter(rom, mode):
    """Analogue loopback: every transmitted word fed back as the next received
    one, through the ROM's own modulator at d95f and receiver at d8aa."""
    import random

    random.seed(3)
    bits = [random.randint(0, 1) for _ in range(40)]
    _, soft, armed = fsk.loopback(rom, bits, mode=mode)
    assert armed['modulator'] == fsk.MODULATOR
    assert armed['receiver'] == 0xD8AA
    offset = fsk.best_offset(soft, bits, fsk.LOOPBACK_SAMPLES_PER_BIT, mode)
    # The offset is the receiver's group delay, not a free parameter.
    assert 38 <= offset <= 46
    recovered = fsk.slice_bits(soft, len(bits),
                               fsk.LOOPBACK_SAMPLES_PER_BIT, offset, mode)
    assert recovered == bits


def test_the_loopback_carries_a_real_signal(rom):
    """Both directions move: the line swings, and so does the soft decision."""
    _, soft, _ = fsk.loopback(rom, [1, 0] * 8, mode='v21-answer')
    transmitted, _, _ = fsk.loopback(rom, [1, 0] * 8, mode='v21-answer')
    assert max(abs(x) for x in transmitted) > 2000
    assert min(soft) < 0 < max(soft)


def test_the_receive_setup_chooses_the_band_the_receiver_hears(rom):
    """One band's signal, four receivers: only its own band centre recovers it.

    This is the measurement the loopback reading rests on. Without it, "the
    receiver sits in the transmitter's own band" is an argument about
    constants rather than a property of the firmware.
    """
    state, bits = 0x1FF, []
    for _ in range(60):
        bits.append(state & 1)
        state = (state >> 1) | (((state ^ (state >> 4)) & 1) << 8)
    errors = fsk.band_scan(rom, bits, 'v21-answer')
    assert errors[0xD7A4] == 0                       # 1750, the answer centre
    assert min(errors[s] for s in (0xD7AC, 0xD7C8, 0xD7D0)) > len(bits) // 4


def test_the_start_commands_dispatch_nine_datapumps(rom):
    """Mailbox commands 10 and 11, each through its own table."""
    tables = fsk.mode_tables(rom)
    assert set(tables) == set(fsk.START_COMMANDS)
    assert tables[0x10] == (0x9D00, 0xB000, 0xB052, 0xC533, 0xCD61, 0xCD79,
                            0xDA31, 0xD808, 0xD7E9)
    assert tables[0x11] == (0x9D00, 0xB000, 0xB052, 0xC7FD, 0xCCE0, 0xCCFA,
                            0xD9BC, 0xD7FC, 0xD7D8)
    # The two FSK slots are the own-band entries, in both tables.
    loops = {entry for entry, loop in fsk.loopback_pairs().items() if loop}
    assert set(tables[0x10][7:]) | set(tables[0x11][7:]) == loops
    # The first two slots are the overlays' own entry addresses.
    entries = {overlay.entry_word for overlay in rom.dsp_overlays}
    assert set(tables[0x10][:2]) <= entries


def test_the_mode_flags_index_the_tables_in_order(rom):
    """The selector is read out of the image, not repeated here."""
    flags = fsk.mode_flags(rom)
    assert len(flags) == fsk.MODE_SLOTS
    assert flags[0] == (0x27, 14) and flags[1] == (0x26, 11)
    assert flags[7] == (0x27, 3) and flags[8] == (0x26, 9)
    assert all(cell in (0x26, 0x27) for cell, _ in flags)


def test_no_overlay_sets_up_an_fsk_band(rom):
    """The four 300 bps bands are resident: the overlays carry none of them."""
    import struct as _struct

    setups = {0xAE72, 0xAE73}          # splk @72 / @73, the mark and space cells
    overlays = rom.dsp_overlays
    for overlay in overlays:
        raw = rom.data[overlay.offset:overlay.offset + overlay.length]
        words = _struct.unpack('<%dH' % (len(raw) // 2), raw)
        pairs = [words[i + 1] for i, word in enumerate(words[:-1])
                 if word in setups]
        band = [value for value in pairs if 0x2000 <= value <= 0x5000]
        if overlay.entry_word == 0x8000:          # the resident bank
            assert sorted(band) == [0x22D8, 0x260B, 0x29F5, 0x2D28,
                                    0x3AAB, 0x41C7, 0x4800, 0x4F1C]
        else:
            assert band == []
