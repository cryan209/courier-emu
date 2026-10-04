#!/usr/bin/env python3
"""Execute Courier 403 DSP rate reporting and supervisor result selection.

Controlled mailbox/call inputs exercise original firmware instructions.
The separately preserved live trace establishes which inputs the call uses.
"""
import json
import struct
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))
from courier_emu.dsp import NativeC5x
from courier_emu.rom import CourierRom
from courier_emu.nac import NacImage
from courier_emu import x86_interpreter as x86
from tools.recover_3453c_x2 import listing
from tools.x86_disasm import disassemble
from tools.imodem_x2_map import V90_IMAGES

OUT = ROOT / 'artifacts/x2-courier-rate-report-20261005'
ROM = ROOT / 'artifacts/courier-board-21210-capture-403/courier-board.rom'


def cpu(image):
    core = x86.Uc(x86.UC_ARCH_X86, x86.UC_MODE_16)
    core.mem_map(0, 0x100000)
    core.mem_write(image.base, image.data)
    core.reg_write(x86.UC_X86_REG_SP, 0x7000)
    return core


def run_cpu(core, entry, segment, stop):
    core.reg_write(x86.UC_X86_REG_CS, segment)
    core.reg_write(x86.UC_X86_REG_IP, entry - segment * 16)
    reached = []
    def done(uc, address, size, user):
        reached.append(address)
        uc.emu_stop()
    core.hook_add(x86.UC_HOOK_CODE, done, begin=stop, end=stop)
    core.emu_start(entry, 0, count=2000)
    assert reached, hex(core.reg_read(x86.UC_X86_REG_IP))


def main():
    OUT.mkdir(exist_ok=True)
    image = CourierRom.load(ROM)
    segments = image.dsp_program_segments()
    words = [0] * 65536
    for start, data in (segments[0], segments[1], segments[3]):
        words[start:start+len(data)//2] = struct.unpack(f'<{len(data)//2}H', data)
    (OUT / 'dsp-report.asm').write_text(''.join(listing(words, a, b) for a, b in
        [(0xe188, 0xe214), (0xa63a, 0xa692), (0xe2dd, 0xe307)]))
    (OUT / 'supervisor-report.asm').write_text('\n'.join(
        f'{i.address:05x}  {i.bytes.hex():18s} {i.mnemonic:8s} {i.op_str}'
        for a, n in [(0x93cd9, 16), (0x94399, 18), (0x93d77, 24), (0x82fb9, 68),
                     (0x89f54, 19), (0xca811, 3)] for i in disassemble(image, a, n))+'\n')

    # Original E19C..E1AC builds the argument following the queued tag 006A.
    # Wire N1 stays one, independently of the local saved receive index.
    dsp_cases = 0
    threshold_cases = 0
    with NativeC5x.from_program(*segments[0]) as core:
        for start, data in (segments[1], segments[3]):
            core.load_program(data, start)
        thresholds = words[0xc77d:0xc77d+15]
        assert thresholds == [0x2c40,0x2f00,0x3340,0x3540,0x3640,0x3640,
                              0x3740,0x38c0,0x3b00,0x3c00,0x3c00,0x3ec0,
                              0x40c0,0x4100,0x4680]
        for i, value in enumerate(thresholds):
            core.set_data(0xcf2c+i, value)
        for metric in [t+delta for t in thresholds for delta in (-1,0,1)]+[0x3f20]:
            for address, value in {0x39f:0x4060,0xfff4:0,0xfffb:0xff00,
                                   0x37b:1}.items():
                core.set_data(address, value)
            driver = [0xbc06,0x8b89,0xbe47,0xbe42,0xbe4a,0xbf01,
                      0xbf80,metric+0x300,0x7a80,0xe2dd,0x8b00]
            core.load_program(struct.pack('<11H', *driver),0x7000)
            core.set_pc(0x7000)
            for _ in range(2000):
                if core.state()['pc']==0x700a:
                    break
                core.step(1)
            else:
                raise AssertionError(core.state())
            expected=max([0]+[i+1 for i,t in enumerate(thresholds) if t<=metric])
            assert core.state()['acc'] & 65535 == expected
            threshold_cases += 1
        for saved in range(1, 16):
            for mask in (0x3fe, 0x1ffe, 0x7fff):
                for address, value in {0x39f:0x4062, 0x340:13<<6, 0x941:mask,
                                       0x940:0x8344, 0x31c:saved, 0xfff4:0, 0x37b:1,
                                       0x78:0xbd0, 0x79:0xbd0}.items():
                    core.set_data(address, value)
                driver = [0xbc06, 0x8b89, 0xbe47, 0xbe42, 0xbe4a, 0xbf01,
                          0x7a80, 0xe19c, 0x8b00]
                core.load_program(struct.pack('<9H', *driver), 0x7000)
                core.set_pc(0x7000)
                for _ in range(2000):
                    if core.state()['pc'] == 0xe1ae:
                        break
                    core.step(1)
                else:
                    raise AssertionError(core.state())
                high = (mask & ((1 << 13)-1)).bit_length()
                assert core.data(0xbd0) == (high << 8) | saved, (saved, mask, core.data(0xbd0), core.state(), core.data(0x87a))
                assert core.data(0x940) == 0x8344
                dsp_cases += 1

    # Original tag-6A handler reads high then low from the two mailbox lanes.
    # Exercise masking as well as every legal saved index, without a host
    # assignment to the resulting rate cell.
    supervisor_cases = 0
    results = []
    for index in range(1, 16):
        for upper_low_bits in (0, 0xe0):
            core = cpu(image)
            incoming = 0x0a00 | upper_low_bits | index
            def receive(uc, port, size, user):
                assert size == 1 and port in (0x5c, 0x5e)
                return incoming >> (8 if port == 0x5e else 0) & 255
            core.hook_add(x86.UC_HOOK_INSN, receive, None, 1, 0, x86.UC_X86_INS_IN)
            run_cpu(core, 0x93cd9, 0x8f46, 0x93d0b)
            assert core.mem_read(0xa27, 1) == bytes([index])
            assert core.mem_read(0x238, 1)[0] & 4
            assert core.mem_read(0xa18, 1) == b'\x0a'
            for verbosity, arq in ((0,0), (1,0), (1,1), (3,0), (3,1)):
                core.mem_write(0x4da, b'\x01')
                core.mem_write(0x4e2, bytes([verbosity]))
                core.mem_write(0x22a, bytes([arq]))
                core.mem_write(0x7000, struct.pack('<H',0x7000))
                core.reg_write(x86.UC_X86_REG_SP, 0x7000)
                run_cpu(core, 0x82fb9, 0x8000, 0x87000)
                enum = core.reg_read(x86.UC_X86_REG_AX)
                # Execute the original pointer lookup, stopping before the
                # output driver. It receives the selector on the stack.
                core.mem_write(0x7000, struct.pack('<H',enum))
                core.reg_write(x86.UC_X86_REG_SP, 0x7000)
                run_cpu(core, 0x89f57, 0x8000, 0x89f5f)
                pointer = core.reg_read(x86.UC_X86_REG_SI)
                raw = bytes(core.mem_read(0x80000+pointer, 40)).split(b'\0')[0]
                assert raw[:1] == b'\xfe'
                text = raw[1:].decode('ascii')
                allocation = {1:25, 2:28}.get(index, index + 28)
                expected_rate = allocation * 8000 // 6
                # Firmware truncates its repeating decimal rates as strings.
                assert text.split('/')[0] == str(expected_rate), (index, text)
                suffix = '' if verbosity == 0 else (
                    ('/ARQ' if arq else '') + ('/x2' if verbosity >= 2 else ''))
                assert text == str(expected_rate) + suffix
                supervisor_cases += 1
                if upper_low_bits == 0 and verbosity == 3 and arq:
                    results.append({'index':index, 'result_enum':hex(enum),
                                    'string_address':hex(0x80000+pointer), 'text':text})
    report = {'firmware_sha256':image.digest, 'dsp_report_cases':dsp_cases,
              'threshold_boundary_cases':threshold_cases,
              'live_ceiling_arithmetic':'4220 + FF00 - 0200 = 3F20, between threshold 12 (3EC0) and threshold 13 (40C0), yielding index 12.',
              'supervisor_selection_cases':supervisor_cases,
              'qualification':'Controlled inputs through original DSP report builder, supervisor mailbox handler, result selector and pointer lookup; live scheduling is recorded separately.',
              'rate_rule':'x2 result index 1 selects 33333, 2 selects 37333; n=3..15 selects floor((n+28)*8000/6) bit/s.',
              'results':results}
    server_image = NacImage.load(ROOT / 'Ie030002.nac')
    _, blob = server_image.flatten()
    server_words = [0] * 65536
    server_segments = []
    for image_id in (5,6):
        offset, count, start = V90_IMAGES[image_id]
        data = blob[offset:offset+count*2]
        server_segments.append((start,data))
        server_words[start:start+count] = struct.unpack(f'<{count}H',data)
    allocations = server_words[0xd24a:0xd24a+15]
    assert allocations == [19,22,25,26,27,28,29,30,31,32,33,34,35,36,37]
    with NativeC5x.from_program(*server_segments[0]) as core:
        for start, data in server_segments[1:]:
            core.load_program(data,start)
        for index in range(1,16):
            for address, value in {0x39f:0x1462,0x340:(index<<2)|(13<<6),
                                   0xf6d9:0x7fff,0x3fb:1}.items():
                core.set_data(address,value)
            driver=[0xbc07,0x8b89,0xbe47,0xbe42,0xbe4a,0xbf01,
                    0x7a80,0xcff4,0x8b00]
            core.load_program(struct.pack('<9H',*driver),0x7000)
            core.set_pc(0x7000)
            for _ in range(2000):
                if core.state()['pc']==0xcffd:
                    break
                core.step(1)
            else:
                raise AssertionError(core.state())
            assert core.data(0x3a2)==index-1
            assert core.data(0x3c0)==allocations[index-1]
        consumer_cases=0
        for amplitude in allocations:
            for md in range(7):
                for cursor in (0,123):
                    for address, value in {0x3c0:amplitude,0x3ed:md,
                                           0x3af:cursor,0x3fb:1}.items():
                        core.set_data(address,value)
                    driver=[0xbc07,0x8b89,0xbe47,0xbe42,0xbe4a,0xbf01,
                            0x7a80,0xcc95,0x8b00]
                    core.load_program(struct.pack('<9H',*driver),0x7000)
                    core.set_pc(0x7000)
                    for _ in range(2000):
                        if core.state()['pc']==0xccbe:
                            break
                        core.step(1)
                    else:
                        raise AssertionError(core.state())
                    assert core.data(0x3af)==(cursor+amplitude+md)&127
                    consumer_cases+=1
    (OUT/'imodem-selector.asm').write_text(''.join(listing(server_words,a,b) for a,b in
        [(0xabbc,0xac27),(0xcff4,0xd01c),(0xcc95,0xccbe),(0xb7aa,0xb7d2),
         (0xce85,0xcf04)]))
    report['imodem_selector_cases']=15
    report['imodem_sha256']=server_image.describe()['sha256']
    report['imodem_bit_consumer_cases']=consumer_cases
    report['imodem_bit_consumer_rule']='CC95..CCBE advances the source bit-ring cursor by B+MD, including cursor wrap. The live selected values B=19 and W4 high byte MD=5 imply 24 source bits per invocation, distinct from the displayed 33333 nominal label. No analogue or terminal throughput measurement is asserted.'
    report['imodem_selector_rule']='Tested x2 TX branch: intersect the local F6D9 mask with the received W1 N1 ceiling; save selected index minus one at 03A2 and table D24A amplitude allocation at 03C0. N1=1 selects index zero and amplitude allocation 19.'
    (OUT / 'verification.json').write_text(json.dumps(report,indent=2)+'\n')
    print(json.dumps(report,indent=2))


if __name__ == '__main__':
    main()
