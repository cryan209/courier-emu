"""Recover and execute the original x2/4.03 scrambler routines.

Run from the repository root: .venv/bin/python artifacts/x2-scrambler-hunt/verify.py
No modem hardware is accessed.
"""
from pathlib import Path
import sys
import struct
import random
import json

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT))
from tools.unpack_sdl import packet_runs
from tools.c5x_disasm import disassemble
from courier_emu.rom import CourierRom
from courier_emu.dsp import NativeC5x

OUT = Path(__file__).resolve().parent


def extract_x2():
    runs = packet_runs((ROOT / 'firmware/legacy-usrobotics/sdl6-x2.exe').read_bytes())
    blob = b''.join(r['payload'] for r in runs)
    # INFO fill handler installs the address of its following instruction.
    anchor = blob.index(bytes.fromhex('59aeffff'))
    assert blob[anchor + 4:anchor + 6] == bytes.fromhex('48ae')
    next_pc = struct.unpack_from('<H', blob, anchor + 6)[0]
    bias = anchor + 8 - 2 * next_pc
    assert blob[bias + 0x10000:bias + 0x10004] == bytes.fromhex('00bc57ae')
    return blob, bias


def scalar(state, value, count, tap, receive=False):
    result = 0
    for bit in range(count):
        incoming = (value >> bit) & 1
        decoded = incoming ^ ((state >> (23 - tap)) & 1) ^ (state & 1)
        result |= decoded << bit
        state = (state >> 1) | ((incoming if receive else decoded) << 22)
    return result, state


def main():
    blob, bias = extract_x2()
    rom = CourierRom.load(ROOT / 'artifacts/courier-board-21210-capture-403/courier-board.rom')
    resident = rom.dsp_download
    image403 = rom.data[resident.offset:resident.end]
    builds = [('x2', blob[bias+0x10000:bias+0x10000+0x4000], 0x8c63, 0x8c94),
              ('403', image403, 0x8cb7, 0x8ce8)]
    report = {'x2_flat_bias': hex(bias), 'tests': []}
    # The fixed-GPC training generator is byte-identical, including register ABI.
    ov8 = next(o for o in rom.dsp_overlays if o.index == 8)
    ov8bytes = rom.data[ov8.offset:ov8.offset + ov8.length]
    training = ov8bytes[(0xf938-ov8.entry_word)*2:(0xf94a-ov8.entry_word)*2]
    hit = blob.index(training)
    assert blob.find(training, hit + 1) == -1
    # x2's six-bit caller names ED2E; independently anchors this overlay.
    assert blob[hit-0x34*2:hit-0x34*2+4] == struct.pack('<2H',0x7e80,0xed2e)
    report['training'] = {'x2_entry': '0xed2e', '403_entry': '0xf938',
                          'identical_words': len(training)//2,
                          'x2_flat_offset': hex(hit)}
    # A caller-supplied target, not concatenation order, establishes x2 PCs.
    x2_training_bias = hit - 2 * 0xed2e
    pcm_words = [0] * 65536
    pcm_end = 0xf178
    pcm_words[0xe000:pcm_end] = struct.unpack_from('<%dH' % (pcm_end-0xe000), blob, x2_training_bias+2*0xe000)
    excerpts = []
    for first,last in [(0xe847,0xe86b),(0xecf8,0xed40)]:
        excerpts.extend(f'{i.pc:04x}  {" ".join(f"{v:04x}" for v in i.words):14} {i.text}'
                        for i in disassemble(pcm_words,first,last))
    (OUT/'x2-pcm-training.asm').write_text('\n'.join(excerpts)+'\n')
    for key, signature in [('SP',bytes.fromhex('554b2db5b4d24a2b01')),
                           ('TP',bytes.fromhex('002184102284104200')),
                           ('descriptor_header',bytes.fromhex('a0aec500a0ae4141'))]:
        report.setdefault('v90_descriptor_signatures', {})[key] = {
            'x2_count': blob.count(signature), '403_count': rom.data.count(signature)}
    rng = random.Random(0x239018)
    for name, program, tx, rx in builds:
        words = [0] * 65536
        words[0x8000:0x8000+len(program)//2] = struct.unpack('<%dH' % (len(program)//2), program)
        (OUT / f'{name}-scramblers.asm').write_text('\n'.join(
            f'{i.pc:04x}  {" ".join(f"{v:04x}" for v in i.words):14} {i.text}'
            for i in disassemble(words, tx-21, rx+28)) + '\n')
        core = NativeC5x.from_program(0x8000, program)
        for receive, entry in [(False, tx), (True, rx)]:
            # Set DP=6 and ARP=1, call original code, stop before next instruction.
            wrapper = struct.pack('<5H', 0xbc06, 0x8b89, 0x7a80, entry, 0x8b00)
            core.load_program(wrapper, 0xf000)
            for flag in (0, 1):
                tap = (18 if flag else 5) if receive else (5 if flag else 18)
                cases = 0
                for count in range(1, 10):
                    for _ in range(32):
                        state = rng.getrandbits(23)
                        value = rng.getrandbits(count)
                        hi, lo, data, mask, width = (0x31e, 0x31f, 0x320, 0x321, 0x322) if receive else (0x358, 0x359, 0x350, 0x351, 0x352)
                        for addr, val in [(hi,state >> 16),(lo,state & 65535),(data,value),(mask,(1<<count)-1),(width,count),(0x6f,flag << int(receive))]:
                            core.set_data(addr, val)
                        core.set_pc(0xf000)
                        for step in range(80):
                            core.step(1)
                            if core.state()['pc'] == 0xf004:
                                break
                        else:
                            raise AssertionError(core.state())
                        expected = scalar(state, value, count, tap, receive)
                        actual = core.data(data), (core.data(hi) << 16) | core.data(lo)
                        assert actual == expected, (name,receive,flag,count,hex(state),value,actual,expected)
                        cases += 1
                report['tests'].append(dict(build=name, direction='descrambler' if receive else 'scrambler', entry=hex(entry), flag=flag, taps=[tap,23], cases=cases))
        core.close()
    # Test the actual fixed-polynomial PCM training generator, both standalone
    # random states and a continuous zero-seeded 768-bit sequence.
    with NativeC5x.from_program(0xed2e, training) as core:
        core.load_program(struct.pack('<5H',0xbc06,0x8b89,0x7a80,0xed2e,0x8b00),0xf000)
        state = 0
        for case in range(256):
            if case >= 128:
                state = rng.getrandbits(23)
            for addr,value in [(0x379,state>>16),(0x37a,state&65535),(0x37c,63),(0x37e,6)]:
                core.set_data(addr,value)
            core.set_pc(0xf000)
            for _ in range(40):
                core.step(1)
                if core.state()['pc'] == 0xf004:
                    break
            else:
                raise AssertionError(core.state())
            expected,state = scalar(state,63,6,18)
            assert (core.data(0x37d),(core.data(0x379)<<16)|core.data(0x37a)) == (expected,state)
    report['training']['six_bit_cases'] = 256
    (OUT / 'verification.json').write_text(json.dumps(report, indent=2) + '\n')
    print(json.dumps(report, indent=2))


if __name__ == '__main__':
    main()
