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


def test_the_help_text_names_the_option_bits(rom):
    """S58 carries the two PCM schemes; S56 names the overlays."""
    assert datapumps.s_register_bits(rom, datapumps.PCM_OPTIONS) == {
        1: 'x2', 2: 'BLER monitor', 32: 'V.90'}
    modulation = datapumps.s_register_bits(rom, datapumps.MODULATION_OPTIONS)
    assert modulation[32] == 'V34+' and modulation[64] == 'V34'
    assert modulation[128] == 'VFC'
    # The overlay predicates gate on exactly those two bits of that register,
    # which is what names overlay 6 V.34 and overlay 7 V.FC.
    options = datapumps.S_REGISTER_BASE + datapumps.MODULATION_OPTIONS
    assert options == 0x4C6
    for bit in (0x40, 0x80):
        assert datapumps._test_byte(options, bit) in rom.data


def test_x2_and_v90_are_two_bits_over_one_receiver(rom):
    control = datapumps.pcm_control(rom)
    assert control['x2']['disable_bit'] == 1
    assert control['V90']['disable_bit'] == 0x20
    assert control['x2']['s_register'] == control['V90']['s_register'] == 58
    # x2 hands the DSP a capability word; V.90's branch has an empty body.
    assert control['x2']['command'] == 0x70
    assert control['V90']['command'] is None
    assert control['V90']['empty_setup'] and not control['x2']['empty_setup']


def test_both_ladders_step_by_one_pcm_frame(rom):
    ladders = datapumps.pcm_ladders(rom)
    assert len(ladders['x2']) == 16 and len(ladders['V90']) == 28
    assert ladders['x2'][0] == 33333 and ladders['V90'][0] == 28000
    assert ladders['x2'][-1] == ladders['V90'][-1] == 64000
    for rates in ladders.values():
        for rate in rates:
            # Every rate is a whole number of bits per six-symbol frame.
            assert abs(rate / datapumps.PCM_STEP
                       - round(rate / datapumps.PCM_STEP)) < 0.01
    # V.90 covers every x2 rate and five slower ones besides.
    assert set(ladders['x2']) < set(ladders['V90'])


def test_overlay_eight_forks_into_two_receivers(rom):
    """One bit of the datapump flag word picks which state machine runs."""
    site, bit, families = datapumps.receiver_fork(rom)
    assert site == 0xDE0B and bit == 8
    assert families[True] == 0xE4C5      # bit set
    assert families[False] == 0xF442     # bit clear
    # The two entries are far apart and in different halves of the image.
    assert families[True] < 0xF000 < families[False]


def test_the_two_receivers_share_code_verbatim(rom):
    """Two state machines from one source leave duplicated runs behind."""
    runs = datapumps.receiver_twins(rom)
    assert len(runs) >= 8
    for first, last, twin, twin_last in runs:
        assert last - first == twin_last - twin
        assert twin - first > 0x400
    # The e-family and f-family halves are what repeat.
    assert any(0xE900 <= a < 0xEB00 and 0xF700 <= c < 0xF900
               for a, _, c, _ in runs)


def test_the_pcm_sample_path_is_selected_beside_the_receiver_bit(rom):
    """Commands 4d and 4f differ only in the receiver flag."""
    commands = datapumps.mode_commands(rom)
    assert commands[0x4F]['sample_path'] == datapumps.PCM_SAMPLE_PATH
    assert commands[0x4D]['sample_path'] == datapumps.PCM_SAMPLE_PATH
    assert commands[0x4E]['sample_path'] != datapumps.PCM_SAMPLE_PATH
    assert commands[0x4F]['flag'] == ('set', 0x0100)
    assert commands[0x4D]['flag'] == ('clear', 0xFEFF)
    assert commands[0x4E]['flag'] == ('clear', 0xFEFF)


def test_the_mode_commands_are_sent_with_the_tag_in_ah(rom):
    """Two sites, both fanning out from one profile byte to the three tags."""
    sites = datapumps.receiver_selector(rom)
    assert len(sites) == 2
    assert {site for site, _ in sites} == {0x4749, 0xBE6F}
    for _, tags in sites:
        assert tags == {0: 0x4D, 1: 0x4E, 2: 0x4F}


def test_the_receiver_is_chosen_by_a_saved_setting(rom):
    """Not V.8, not INFO: a stored profile byte with an active/stored pair."""
    assert datapumps.receiver_setting_is_configured(rom)
    # Both copies sit at the same offset into their profile block, past the
    # S-registers the help text documents.
    offset = datapumps.RECEIVER_SETTING - datapumps.PROFILE_ACTIVE
    assert offset == datapumps.RECEIVER_SETTING_STORED - datapumps.PROFILE_STORED
    assert offset > datapumps.PCM_OPTIONS
