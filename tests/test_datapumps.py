"""Every modulation this firmware carries, read out of the image."""
import pytest

from courier_emu import datapumps, fsk
from courier_emu.rom import CourierRom

ROM = 'artifacts/courier-board-21210-capture-403/courier-board.rom'


@pytest.fixture(scope='module')
def rom():
    return CourierRom.load(ROM)


def test_the_modem_lists_nine_modulation_families(rom):
    """`AT*C`'s help text is the firmware's own list, slowest first."""
    assert datapumps.carrier_families(rom) == (
        'Bell 103', 'V.21', 'V.22', 'V.22bis', 'V.23',
        'V.32', 'HST', 'V.FC', 'V.34')
    menu = datapumps.carrier_menu(rom)
    assert len(menu) == 76 and menu[0] == (0, 'Bell 103, 3')


def test_the_families_match_the_datapump_table_reversed(rom):
    """Nine families, nine slots, fastest first."""
    families = datapumps.carrier_families(rom)
    tables = fsk.mode_tables(rom)
    assert len(families) == fsk.MODE_SLOTS == len(tables[0x10])
    # The two slowest families are the two slots that have been measured.
    assert families[:2] == ('Bell 103', 'V.21')
    assert tables[0x10][-1] == 0xD7E9 and tables[0x10][-2] == 0xD808


def test_overlay_eight_only_ever_loads_with_overlay_six(rom):
    """The PCM layer is chained onto the V.34 core by the loader itself."""
    chain = datapumps.overlay_chain(rom)
    assert chain[6] == (6, 8)
    assert chain[7] == (7,) and chain[5] == (5,)
    # And it can be: 8's range collides with neither 6's nor 7's, while 6 and 7
    # collide with each other.
    span = {o.index: (o.entry_word, o.entry_word + o.length // 2)
            for o in rom.dsp_overlays}
    def overlaps(a, b):
        return a[0] < b[1] and b[0] < a[1]
    assert overlaps(span[6], span[7])
    assert not overlaps(span[6], span[8]) and not overlaps(span[7], span[8])


def test_the_fax_tags_dispatch_five_slots_each(rom):
    tables = datapumps.fax_dispatch(rom)
    assert set(tables) == set(datapumps.FAX_TAGS)
    for tag, table in tables.items():
        assert len(table) == datapumps.FAX_SLOTS
        assert table[-1] == 0xDEF0            # the empty slot, shared
    # Slot 1 is V.21 channel 2 in all three, through the FSK setup routines.
    assert tables[0x21][1] == 0xD853 and tables[0x22][1] == 0xD808


def test_the_fax_datapumps_carry_v29_and_v27ter_carriers(rom):
    """1700 Hz is V.29's carrier and no other modulation's here."""
    for tag in (0x21, 0x22):
        carriers = datapumps.fax_carriers(rom, tag)
        assert carriers[3] == (1700,)
        assert carriers[2] == (1800,) and carriers[4] == (1800,)
        assert carriers[1] is None and carriers[5] is None


def test_the_fax_subsystem_sits_where_overlay_eight_loads(rom):
    """So a V.90 or x2 connection and Class 1 fax cannot both be resident."""
    overlay = next(o for o in rom.dsp_overlays if o.index == 8)
    first, last = overlay.entry_word, overlay.entry_word + overlay.length // 2
    table = datapumps.fax_dispatch(rom)[0x21]
    assert first <= 0xDC48 < last                    # the dispatch
    assert all(first <= entry < last for entry in table[2:5])
    assert first <= 0xE4D5 < last                    # the V.27ter datapump
    # The V.21 slot is the exception: it is the FSK code, which sits below
    # dc00 and survives the overlay.
    assert table[1] < first
