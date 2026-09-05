"""The DSP's own answer-tone generator, rendered through its mixer and ISR."""
import pytest

from courier_emu import answer_tone
from courier_emu.rom import CourierRom

ROM = 'artifacts/courier-board-21210-capture-403/courier-board.rom'


@pytest.fixture(scope='module')
def rom():
    return CourierRom.load(ROM)


def test_arming_matches_the_firmwares_own_call(rom):
    """86d1, entered with the caller's #4aab, arms the tone as the ROM does."""
    _, _, armed = answer_tone.render(rom, count=1, variant='ans')
    assert armed['increment'] == answer_tone.ANSWER_INCREMENT
    assert armed['callback'] == answer_tone.VARIANTS['ans']
    assert armed['amplitude'] == 0x0898  # 86d5's own value


def test_the_bare_tone_is_2100_hz(rom):
    samples, serial, _ = answer_tone.render(rom, count=2048, variant='ans')
    assert serial['dxr_writes'] == 2048
    measured = answer_tone.measure(samples)
    assert measured['frequency_hz'] == pytest.approx(2100.0, abs=1.0)


def test_the_reversal_variant_flips_phase_every_450_ms(rom):
    """8739 reloads 0x0ca7 = 3239 samples, which is V.25's 450 ms."""
    samples, _, armed = answer_tone.render(rom, count=11520,
                                           variant='ans-reversals')
    assert armed['reversal_counter'] == 0x0CA7
    measured = answer_tone.measure(samples)
    assert measured['frequency_hz'] == pytest.approx(2100.0, abs=1.0)
    assert measured['reversal_period_samples'], 'no phase reversal detected'
    for spacing in measured['reversal_period_samples']:
        # The detector's resolution is one 64-sample block.
        assert abs(spacing - 0x0CA7) <= 64


def test_the_reversal_counter_needs_the_mixers_arp(rom):
    """Entering below 80c9 leaves ARP wrong and BANZ reverses every sample."""
    samples, _, _ = answer_tone.render(rom, count=512, variant='ans-reversals')
    assert max(abs(x) for x in samples) != min(abs(x) for x in samples)


def test_an_unknown_variant_is_refused(rom):
    with pytest.raises(ValueError):
        answer_tone.render(rom, count=1, variant='v34')
