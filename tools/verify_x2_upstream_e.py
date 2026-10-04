#!/usr/bin/env python3
"""Execute Ie030002's post-record E gate with decoded bit input.

The original A881 dispatcher maintains the consecutive-one count and invokes
its saved coroutine. Starting at AABF isolates the already-accepted-record
boundary; this is not a demodulator or record-acceptance test.
"""
import json
import struct
import sys
from pathlib import Path
ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))
from courier_emu.dsp import NativeC5x
from courier_emu.nac import NacImage
from courier_emu.rom import CourierRom
from tools.imodem_x2_map import V90_IMAGES
from tools.recover_3453c_x2 import listing

OUT = ROOT / 'artifacts/x2-upstream-e-20261005'


def main():
    image = NacImage.load(ROOT / 'Ie030002.nac')
    _, blob = image.flatten()
    words = [0]*65536
    segments = []
    for i in (5,6):
        offset,count,start=V90_IMAGES[i]
        data=blob[offset:offset+count*2]
        segments.append((start,data))
        words[start:start+count]=struct.unpack(f'<{count}H',data)
    OUT.mkdir(exist_ok=True)
    (OUT/'receiver.asm').write_text(''.join(listing(words,a,b) for a,b in
        [(0xa881,0xa891),(0xa939,0xa947),(0xaabf,0xaad5)]))
    courier_words = [0]*65536
    courier_segments=CourierRom.load(ROOT/'artifacts/courier-board-21210-capture-403/courier-board.rom').dsp_program_segments()
    for start,data in (courier_segments[0],courier_segments[1],courier_segments[3]):
        courier_words[start:start+len(data)//2]=struct.unpack(f'<{len(data)//2}H',data)
    (OUT/'transmitter.asm').write_text(''.join(listing(courier_words,a,b) for a,b in
        [(0xae83,0xae8a),(0xaf2e,0xaf3c),(0xaf7d,0xaf99)]))
    cases=[]
    sequences=[[1]*n for n in (16,17,18,19,20,21)]
    sequences += [[1]*19+[0]+[1]*n for n in (17,19,20)]
    for bits in sequences:
        with NativeC5x.from_program(*segments[0]) as core:
            core.load_program(segments[1][1],segments[1][0])
            # Driver uses original CALA dispatcher, which returns via AAD1.
            def run(entry, bit=0):
                core.set_data(0x320,bit)
                core.set_data(0x322,1)
                driver=[0xbc06,0x8b89,0xbe47,0xbe42,0xbe4a,0xbf01,0x7a80,entry,0x8b00]
                core.load_program(struct.pack('<9H',*driver),0x7000)
                core.set_pc(0x7000)
                for _ in range(100):
                    pc=core.state()['pc']
                    if pc==0xa891:return True
                    if pc==0x7008:return False
                    core.step(1)
                raise AssertionError(core.state())
            assert not run(0xaabf)
            found=False
            for bit in bits:
                found=run(0xa881,bit)
                if found:break
            # An interruption after sync returns to the record parser; it must
            # accept a new MP before waiting for E again.
            expected=len(''.join(map(str,bits)).split('0')[0])>=20
            assert found==expected,(bits,found,core.data(0x323))
            cases.append({'input_bits':''.join(map(str,bits)), 'entered_A891':found,'counter':core.data(0x323)})
    report={'firmware_sha256':image.digest,'cases':cases,
            'boundary':'Original A881 consecutive-one dispatcher and AABF/AAC0 coroutine after accepted record; A891 reached on bit twenty. No receiver setup or analogue data acquisition asserted.'}
    (OUT/'verification.json').write_text(json.dumps(report,indent=2)+'\n')
    print(json.dumps(report,indent=2))
if __name__=='__main__':main()
