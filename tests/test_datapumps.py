"""Every modulation this firmware carries, read out of the image."""
import pytest

from courier_emu import datapumps, fsk
from courier_emu.rom import CourierRom

ROM = 'artifacts/courier-board-21210-capture-403/courier-board.rom'


@pytest.fixture(scope='module')
def rom():
    return CourierRom.load(ROM)




def test_the_families_match_the_datapump_table_reversed(rom):
    """Nine families, nine slots, fastest first."""
    families = datapumps.carrier_families(rom)
    tables = fsk.mode_tables(rom)
    assert len(families) == fsk.MODE_SLOTS == len(tables[0x10])
    # The two slowest families are the two slots that have been measured.
    assert families[:2] == ('Bell 103', 'V.21')
    assert tables[0x10][-1] == 0xD7E9 and tables[0x10][-2] == 0xD808


















































