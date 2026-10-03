"""Static DSP map and isolated stock mailbox replay; never opens a serial port."""
from pathlib import Path
import json
import struct
import sys
ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT))
from courier_emu.xmf import XmfImage
from courier_emu.dsp import NativeC5x
from tools.c5x_disasm import disassemble
OUT = Path(__file__).resolve().parent
image = XmfImage.load(ROOT / '2_3_33.XMF')
resident = next(s for s in image.dsp_segments() if s.resident)
low = next(s for s in image.dsp_segments() if s.index == 7)
memory = [0] * 65536
for s in (resident, low):
    memory[s.origin:s.origin+s.words] = struct.unpack(f'<{s.words}H', image.data[s.file_offset:s.end])
assert memory[0x12c0:0x12c8] == [0x697d, 0xba87, 0xef04, 0xbf90, 0x1394, 0xa67c, 0x107c, 0xbe20]
assert memory[0x130d+0x80] == 0x1292
assert memory[0x130d+0x84] == 0x126d
rows = []
for tag in range(0x88):
    target = memory[0x130d+tag]
    source = low if target < 0x1000 else resident
    rows.append({'tag': f'{tag:02X}', 'target': f'{target:04X}',
                 'table_file_offset': f'{resident.file_offset+2*(0x130d+tag-resident.origin):05X}',
                 'handler_file_offset': f'{source.file_offset+2*(target-source.origin):05X}'})
(OUT/'commands.json').write_text(json.dumps(rows, indent=2)+'\n')
lines = [f'; image SHA256 {image.digest}', '; program-word addresses; tables emitted as data']
for first,last in [(0x112b,0x1175),(0x1247,0x130d),(0,0xc0)]:
    lines.append(f'\n; code {first:04X}..{last-1:04X}')
    for ins in disassemble(memory, first,last):
        lines.append(f'{ins.pc:04x}: {" ".join(f"{w:04x}" for w in ins.words):12} {ins.text}')
lines.append('\n; receive dispatch table')
lines.extend(f'{0x130d+tag:04x}: {memory[0x130d+tag]:04x} ; tag {tag:02x}' for tag in range(0x88))
(OUT/'mailbox.asm').write_text('\n'.join(lines)+'\n')

def replay(tag, state=0, value=0):
    # Raw functions, fixture ring/state, no boot, codec or real ASIC model.
    with NativeC5x(image) as core:
        core.load_program(image.data[low.file_offset:low.end], low.origin)
        core.load_program(struct.pack('<8H', 0x8b89,0x7a80,0x12b1,0x8b89,0x7a80,0x12e4,0x7980,0x7e06),0x7e00)
        core.set_mpmc_pin(1)
        core.set_data(0x78,0x7fc0); core.set_data(0x79,0x7fc0)
        core.set_data(0x12f,(state<<8)|3)
        core.set_io(0x8057,3); core.set_io(0x805e,tag); core.set_io(0x805f,value)
        core.set_pc(0x7e00)
        seen=0; status=3
        for _ in range(500):
            core.step(1)
            events=core.io_events()
            for event in events[seen:]:
                if event['write'] and event['port']==0x8057:
                    status &= ~event['value']; core.set_io(0x8057,status)
            seen=len(events)
            if core.state()['pc']==0x7e06: break
        else: raise RuntimeError(f'tag {tag:02x} did not return')
        writes=[e for e in events if e['write']]
        tags=[e['value'] for e in writes if e['port']==0x805e]
        data=[e['value'] for e in writes if e['port']==0x805f]
        return {'tag':f'{tag:02X}','state':state,'reply':[tags[-1],data[-1]] if tags and data else None,
                'instructions':core.state()['instructions'],'writes':writes}
results=[replay(0x80,state) for state in range(6)] + [replay(0x6c),replay(0x88)]
assert [r['reply'] for r in results[:6]] == [None,[0x7b,0],[0x7c,30],[0x7d,3],[0x7e,3],None]
assert all(r['reply'] is None for r in results[6:])
report={'image_sha256':image.digest,'segments':[s.describe() for s in image.dsp_segments()],
        'scope':'Isolated stock DSP functions in C51 emulator, fixture data and ASIC acknowledgement; not full boot or C52 hardware validation.',
        'replays':results}
(OUT/'replay.json').write_text(json.dumps(report,indent=2)+'\n')
print(json.dumps([{'tag':r['tag'],'state':r['state'],'reply':r['reply']} for r in results]))
