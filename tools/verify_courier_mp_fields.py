#!/usr/bin/env python3
"""Execute the captured Courier 403 MP field packer with controlled inputs.

This verifies local packing, not analogue acquisition or call scheduling.
"""
import json
import struct
import sys
from pathlib import Path
ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))
from courier_emu.dsp import NativeC5x
from courier_emu.rom import CourierRom
from tools.recover_3453c_x2 import listing
OUT = ROOT / 'artifacts/x2-courier-mp-20261005'


def invoke(core, entry, stop=0x7008, callback=None):
    core.load_program(struct.pack('<9H', 0xbc06, 0x8b89, 0xbe47, 0xbe42,
                                  0xbe4a, 0xbf01, 0x7a80, entry, 0x8b00), 0x7000)
    core.set_pc(0x7000)
    calls = 0
    for _ in range(2000):
        if core.state()['pc'] == stop:
            return calls
        if core.state()['pc'] == callback:
            calls += 1
        core.step(1)
    raise AssertionError(core.state())


def main():
    OUT.mkdir(exist_ok=True)
    image = CourierRom.load(ROOT / 'artifacts/courier-board-21210-capture-403/courier-board.rom')
    segments = image.dsp_program_segments()
    origin, resident = segments[0]
    org, pcm = segments[3]
    words = [0] * 65536
    for start, data in (segments[0], segments[1], segments[3]):
        words[start:start + len(data)//2] = struct.unpack(f'<{len(data)//2}H', data)
    (OUT / 'fields.asm').write_text(''.join(listing(words, a, b) for a, b in
        [(0xf856,0xf8d1),(0xf4f7,0xf508),(0xe724,0xe72c),
         (0xe11c,0xe14c),(0xe970,0xe982),(0xea4f,0xeabd),(0xeabd,0xead8)]))
    count = 0
    consumer_cases = 0
    examples = []
    with NativeC5x.from_program(origin, resident) as core:
        core.load_program(segments[1][1], segments[1][0])
        core.load_program(pcm, org)
        for ceiling in range(16):
            for requested in range(16):
                for mask in (0,1,2,0x3fe,0x1ffe,0x7fff):
                    low = (ceiling * 17 + requested) & 255
                    offset = (ceiling + requested) & 7
                    for a,v in {0xfff3:(1 << ceiling)-1,0x37d:requested,
                                0x364:offset,0x941:mask,0x940:0x7c03,
                                0x943:0xaa00|low}.items():core.set_data(a,v)
                    invoke(core,0xf895)
                    packed = core.state()['acc'] & 65535
                    expected = (min(ceiling,requested)<<2) | (mask.bit_length()<<6)
                    assert packed == expected, (ceiling,requested,mask,packed,expected)
                    assert core.data(0x943)==(offset<<8)|low
                    assert core.data(0x940)==0x7c03
                    count += 1
                    if (ceiling,requested,mask)==(13,1,0x1ffe):
                        examples.append({'ceiling':ceiling,'requested':requested,'mask':hex(mask),'packed':hex(packed)})
        core.load_program(struct.pack('<H',0xef00),0x7100)
        for offset in range(9):
            for allocation in range(20,44):
                for a,v in {0x351:allocation-offset,0x364:offset,0x343:0x7100,
                            0x323:0,0x34b:0,0x320:0,0x37b:1,
                            0x37e:0,0x37f:0}.items():core.set_data(a,v)
                calls = invoke(core,0xe11c,callback=0x7100)
                assert calls==allocation,(offset,allocation,calls)
                consumer_cases += 1
    report={'consumer_bit_count_cases':consumer_cases,
            'consumer_rule':'E11C consumes data[0351]+data[0364] bits, demonstrated with a return-only per-bit callback; no mapper semantics asserted.',
            'firmware_sha256' :image.digest,'packing_cases':count,
            'qualification':'Original local MP field packer with seeded masks, requested ceiling, offset and low byte; no full call scheduling.',
            'formula':'N1=min(bit_length(data[FFF3]),data[037D]); N2=bit_length(data[0941]&7FFF); returned=(N1<<2)|(N2<<6); W4=(data[0364]<<8)|(old_W4&FF)',
            'examples':examples}
    (OUT/'verification.json').write_text(json.dumps(report,indent=2)+'\n')
    print(json.dumps(report,indent=2))

if __name__=='__main__':main()
