"""Live-capture regression; these tests never open a serial port."""
import json
from pathlib import Path
import pytest
from courier_emu.rom import CourierRom
from courier_emu.mailbox_compare import compare, execute, program, validate, TABLE

ROOT = Path(__file__).resolve().parents[1]
ROM = ROOT / 'artifacts/courier-board-21210-capture-403/courier-board.rom'
CAPTURE = ROOT / 'artifacts/dsp-mailbox-312-comparison-01/manifest.json'
pytestmark = pytest.mark.skipif(not ROM.exists(), reason='DSP 3.1.2 capture missing')


def test_query_and_noop_match_the_live_capture():
    report = compare(CourierRom.load(ROM), json.loads(CAPTURE.read_text()))
    assert all(s['tag_matches'] for s in report['steps'])
    assert all(s['value_matches'] for s in report['steps'] if s['command'] != 0x62)
    assert report['steps'][1]['reply'] is None
    # 62 depends on real sample/state RAM; do not fake that value to match.


def test_acknowledging_request_preserves_reply_ready():
    rom = CourierRom.load(ROM)
    assert execute(rom, 7, acknowledge=False)['reply'] is None
    result = execute(rom, 7)
    assert result['reply'] == [0x31, 0]
    assert [e['value'] for e in result['writes'] if e['port'] == 0x57] == [1, 2]


def test_old_firmware_profile_is_rejected():
    old = ROOT / 'artifacts/courier-board-21210-capture-01/courier-board.rom'
    with pytest.raises(ValueError, match='profile'):
        validate(CourierRom.load(old))


def test_current_tone_handlers_are_present_and_table_is_not_the_old_table():
    w = program(CourierRom.load(ROM))
    assert w[TABLE + 0x0B] == 0xEC63
    assert w[0xEC63] != 0xEF00
    assert w[TABLE + 0x13] == 0xEE20
    assert w[0xEE20:0xEE29] == [0xBC07, 0x087A, 0xBFB0, 0x000F, 0xBE09, 0xBF90, 0xEE34, 0xA674, 0xB801]
    for tag, address in [(0x19, 0x03AD), (0x1A, 0x0392), (0x1B, 0x03F1)]:
        handler = w[TABLE + tag]
        assert w[handler:handler+2] == [0x097A, address]
