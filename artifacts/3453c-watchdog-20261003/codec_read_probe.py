"""Isolate the stock C52 resident's Si3034 readback ISR sequence.

Loads the resident directly to isolate serial behavior from the CPU loader.
No guest RAM flags, return values or handler PCs are forced.
"""
import json
from pathlib import Path
from courier_emu.bridge import CourierDspBridge
from courier_emu.xmf import XmfImage

b = CourierDspBridge(XmfImage.load('2_3_33.XMF'))
c = b.core
origin, code = b.image.dsp_program_segments()[0]
c.load_program(code, origin)
c.set_pc(origin)
c.set_io(0x57, 6)
c.step(500_000)
c.set_si3034_line(True, True, False)
initial = c.codec_state()
c.set_io(0x5e, 0x7c)
c.set_io(0x5f, 0)
c.set_io(0x57, c.io(0x57) | 1)
records = []
for _ in range(60_000):
    pc = c.state()['pc']
    if pc in (0x11ba, 0x11d0, 0x11e9, 0x11fc):
        state = c.codec_state()
        records.append(dict(pc=f'{pc:04x}', drr=c.serial_state()['drr'],
            primary_frames=state['frames_clocked'], controls=state['secondary_frames'],
            last_control=state['last_control_word'], pending=c.data(0x12f)))
    c.step(1)
report = dict(initial_codec=initial, trace=records, pending=c.data(0x12f),
              expected_line_status=0x44)
Path(__file__).with_suffix('.json').write_text(json.dumps(report, indent=2)+'\n')
c.close()
