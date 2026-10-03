"""Exercise the original resident's secondary serial exchange, without PC patches."""
from pathlib import Path

import pytest

from courier_emu.bridge import CourierDspBridge
from courier_emu.xmf import XmfImage

ROOT = Path(__file__).resolve().parents[1]


@pytest.mark.parametrize('connected,off_hook,status', [
    (True, True, 0x44), (True, False, 0x40), (False, True, 0x40),
])
def test_stock_resident_reads_si3034_line_status(connected, off_hook, status):
    bridge = CourierDspBridge(XmfImage.load(ROOT / '2_3_33.XMF'))
    core = bridge.core
    try:
        # Load the unchanged resident directly to isolate serial timing from
        # the supervisor's loader and host-mailbox transport.
        origin, code = bridge.image.dsp_program_segments()[0]
        core.load_program(code, origin)
        core.set_pc(origin)
        core.set_io(0x57, 6)
        core.step(500_000)
        assert core.codec_state()['sample_rate'] == 7200
        core.set_si3034_line(connected, off_hook, False)
        reads = core.codec_state()['register_reads']
        core.set_io(0x5e, 0x7c)
        core.set_io(0x5f, 0)
        core.set_io(0x57, core.io(0x57) | 1)
        core.step(60_000)
        assert core.codec_state()['register_reads'] == reads + 1
        assert core.codec_state()['last_control_word'] == 0x2cff
        # The guest itself ORs DRR into its pending reply cell.
        assert core.data(0x12f) == 0x0200 | status
    finally:
        core.close()
