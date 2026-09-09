"""Keep the initialized DSP comparison separate from fixture-only diagnostics."""
import json
from pathlib import Path

from courier_emu.mailbox_compare import compare_booted_g_capture, execute
from courier_emu.rom import CourierRom

ROOT = Path(__file__).resolve().parents[1]


def test_booted_dsp_matches_g_command_hardware_capture():
    rom = CourierRom.load(ROOT / 'artifacts/courier-board-21210-capture-403/courier-board.rom')
    capture = json.loads((ROOT / 'artifacts/g-eight-hex-board/hardware.json').read_text())
    report = compare_booted_g_capture(rom, capture)
    assert len(report['steps']) == 5
    for step in report['steps']:
        assert step['matches'], step
        assert step['request_consumed'], step
        assert step['new_reply'] == (step['command'] != 'ATG002D0000'), step
    # The older isolated test deliberately omits resident initialization.
    # Its 0012 reply must not be silently "fixed" to match initialized hardware.
    assert execute(rom, 0x62)['reply'] == [0x69, 0x12]
    assert report['steps'][0]['emulated'] == [0x69, 0x15]
