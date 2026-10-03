import math

import pytest

from courier_emu.bearer_line import BearerLineLink, ULAW_FULL_SCALE_DBM0
from courier_emu.line import LineLink


def test_si3034_bearer_levels_match_tip_ring_electrical_characteristics():
    peer = BearerLineLink(LineLink('/tmp/unused-si3034-test.sock', digital=True), codec='si3034')
    # A digital full-scale sine represents 1 V peak into 600 ohms at TIP/RING.
    line_power_dbm = 10 * math.log10(0.5 / 600 * 1000)
    assert ULAW_FULL_SCALE_DBM0 + 20 * math.log10(peer.from_line) == pytest.approx(line_power_dbm)
    # The same physical receive sine reaches SDO 0.9 dB below full scale.
    sine_at_line = 32767 * 10 ** ((line_power_dbm - ULAW_FULL_SCALE_DBM0) / 20)
    assert sine_at_line * peer.into_courier == pytest.approx(32767 * 10 ** (-0.9 / 20))


def test_default_ac01_bearer_levels_retain_the_board_daa_loss():
    peer = BearerLineLink(LineLink('/tmp/unused-ac01-test.sock', digital=True))
    assert 20 * math.log10(peer.from_line) == pytest.approx(8.75 - 3.21 - 11.4)
    assert 20 * math.log10(peer.into_courier) == pytest.approx(3.21 - 8.75)
