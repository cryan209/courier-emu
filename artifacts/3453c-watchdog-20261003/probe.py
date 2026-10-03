"""Trace real watchdog handlers and C52 state with disposable parameters."""
import argparse
from collections import deque
from dataclasses import asdict
import json
from pathlib import Path
import shutil
import tempfile

from courier_emu.codec import CodecBringUp, SiliconDaa
from courier_emu.daa import CourierDaa
from courier_emu.flash import ParameterFlash
from courier_emu.machine import CourierMachine
from courier_emu.xmf import XmfImage

p = argparse.ArgumentParser()
p.add_argument('--parameters', type=Path, required=True)
p.add_argument('--output', type=Path, required=True)
p.add_argument('--timers', choices=['none','interrupts','full'], default='none')
p.add_argument('--tick-source', choices=['dsp','timer'])
p.add_argument('--real-delays', action='store_true')
p.add_argument('--instructions', type=int, default=10_000_000)
a = p.parse_args()
strobes = deque(maxlen=64)
with tempfile.TemporaryDirectory() as tmp:
    flash = Path(tmp) / 'parameters.bin'
    shutil.copyfile(a.parameters, flash)
    m = CourierMachine(XmfImage.load('2_3_33.XMF'), with_dsp=True,
        board_id=0, tick_ms=5, tick_source=a.tick_source, fast_delays=not a.real_delays,
        serial_input=b'ATX1S27=1S58=1DT5551234\r',
        daa=CourierDaa('disconnected'), codec=CodecBringUp(SiliconDaa(1, revision=19)),
        parameter_flash=ParameterFlash.load(flash),
        pc_watch={0x67711:'int0-watchdog', 0x58750:'timer-watchdog-reset',
                  0x5a246:'qualification-abort', 0x5a79d:'hook-release'},
        peek={0x176:'watchdog', 0x694:'abort'})
    if a.timers != 'none':
        m.emulate_interrupts = True
        m.timers.answers_reads = a.timers == 'full'
    board = m.dsp_bridge.board3453
    original_write = board.write
    def write(port, size, value, pc=None):
        if port == 0x1e and value in (2,4):
            c = board.core
            strobes.append(dict(cpu_instructions=m.instructions,pc=pc,value=value,
                finished=board.finished,overlay_pending=board.overlay_pending,
                dsp=c.state(),imr=c.register(4),ifr=c.register(6),pmst=c.register(7),
                bmar=c.register(0x1f),pa7=c.io(0x57)))
        return original_write(port,size,value,pc)
    board.write = write
    try:
        report = m.run(a.instructions).to_dict()
    except RuntimeError as exc:
        report = dict(error=str(exc), instructions=m.instructions,
            bridge=asdict(m.dsp_bridge.status()), timers=m.timers.status(),
            pc_watch_counts=dict(m.pc_watch_counts), pc_watch=m.pc_watch_events,
            panel=m.panel.status(), peek=m._peek_values())
    c = board.core
    report['diagnostic'] = dict(timers=a.timers,real_delays=a.real_delays,
        vectors={str(v):bytes(m.uc.mem_read(v*4,4)).hex() for v in [8,12,15,18,19]},
        strobes=list(strobes), imr=None if c.closed else c.register(4),
        ifr=None if c.closed else c.register(6),pmst=None if c.closed else c.register(7),
        board=dict(finished=board.finished,started=board.started,groups=board.groups,
            destination=board.destination,overlay_pending=board.overlay_pending))
    a.output.write_text(json.dumps(report,indent=2)+'\n')
    c.close()
