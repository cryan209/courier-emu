"""Overlay 6, the V.34 datapump, armed through the firmware's own dispatcher."""
import pytest

from courier_emu import v34
from courier_emu.rom import CourierRom

ROM = 'artifacts/courier-board-21210-capture-403/courier-board.rom'


@pytest.fixture(scope='module')
def rom():
    return CourierRom.load(ROM)


def test_the_overlay_is_the_one_slot_zero_names(rom):
    entry, image = v34.overlay(rom)
    assert entry == v34.OVERLAY_ENTRY
    assert len(image) // 2 == 12594


@pytest.mark.parametrize('side', sorted(v34.DISPATCH))
def test_the_dispatcher_reaches_the_overlay_and_it_returns(rom, side):
    armed = v34.arm(rom, side)
    assert armed['entered_overlay'] and armed['returned']
    # Slot 0 is chosen by bit 1 of @27, and @27 is what d648 built.
    assert armed['mode_flags'] & (1 << v34.MODE_BIT)


def test_the_entry_writes_the_marker_the_disassembly_predicted(rom):
    # docs/fsk-modulation.md read #4042 off 9d00 without running it.
    assert v34.arm(rom)['marker'] == v34.MARKER


@pytest.mark.parametrize('side', sorted(v34.DISPATCH))
def test_the_entry_installs_both_datapump_callbacks(rom, side):
    armed = v34.arm(rom, side)
    assert armed['transmit_callback'] == v34.TRANSMIT_CHAIN
    assert armed['receive_callback'] == v34.RECEIVE_CHAIN


def test_the_transmit_chain_runs_advances_itself_and_is_silent(rom):
    samples, chain = v34.transmit_callback(rom, count=32)
    assert len(samples) == 32
    # aafb installs its successor, so the chain must not still be at the entry.
    assert chain != v34.TRANSMIT_CHAIN
    # No start-up state and no data source: silence is the expected result.
    assert not any(samples)


def test_an_unknown_side_is_refused(rom):
    with pytest.raises(ValueError):
        v34.arm(rom, 'v34')
