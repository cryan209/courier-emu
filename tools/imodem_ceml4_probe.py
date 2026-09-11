#!/usr/bin/env python3
"""Isolated Ie030002 CEML4 bearer-selection probe using original guest code.

Calls the two BCH_ENABLED helpers with synthetic call/channel state; records
queued command words and replays their mailbox transmit code. This is not a
complete ISDN call, DSP execution, or proof of PCM sample flow.
"""
from pathlib import Path
import argparse
import json
import struct
import sys
sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from courier_emu.xmp import XmpImage


def probe(image, selector):
    import unicorn as u
    from unicorn import x86_const as x
    cpu = u.Uc(u.UC_ARCH_X86, u.UC_MODE_16)
    cpu.mem_map(0, 0x100000)
    cpu.mem_write(0x40000, image.payload)
    cpu.mem_write(0xce00, image.payload[0x58d50:0x5cf10])
    cpu.reg_write(x.UC_X86_REG_DS, 0xce0)
    cpu.reg_write(x.UC_X86_REG_SS, 0x3000)
    cpu.reg_write(x.UC_X86_REG_EFLAGS, 2)
    def word(a, v): cpu.mem_write(a, struct.pack('<H', v))
    def byte(a, v): cpu.mem_write(a, bytes([v]))
    # Call slot 0 has connection identifier 11h and first bearer selector 6/7.
    byte(0xce00+0xa634, 0x11)
    byte(0xce00+0x8eea, 0x11)
    byte(0xce00+0x8ee9, selector)
    byte(0xce00+0xa636, 0)
    byte(0xce00+0xa642, 0)
    word(0x26000+0xc9ae, 0xc9b2)
    word(0x26000+0xc9b0, 0xc9b2)
    def call(seg, off, args):
        # A synthetic far-call frame, returning to a stop address in low RAM.
        cpu.mem_write(0x30f00, struct.pack('<'+'H'*(2+len(args)), 0, 0x2000, *args))
        cpu.reg_write(x.UC_X86_REG_SP, 0xf00)
        cpu.reg_write(x.UC_X86_REG_CS, seg)
        cpu.reg_write(x.UC_X86_REG_IP, off)
        cpu.emu_start(seg*16+off, 0x20000, count=10000)
        if cpu.reg_read(x.UC_X86_REG_CS)*16+cpu.reg_read(x.UC_X86_REG_IP) != 0x20000:
            raise RuntimeError('helper did not return')
    call(0x7561, 0x4290, [0, 0x11])
    call(0x7561, 0x1ecf, [0])
    tail = struct.unpack('<H', cpu.mem_read(0x26000+0xc9b0, 2))[0]
    raw = bytes(cpu.mem_read(0x26000+0xc9b2, tail-0xc9b2))
    queued = list(struct.unpack('<'+'H'*(len(raw)//2), raw))
    expected = [0xff00, 0x5e, selector-5]
    if queued != expected:
        raise AssertionError((queued, expected))
    ports = []
    def out(cpu, port, size, value, data): ports.append([port, size, value])
    cpu.hook_add(u.UC_HOOK_INSN, out, None, 1, 0, x.UC_X86_INS_OUT)
    # Consume the marker through the ISR's staging code before payload output.
    cpu.reg_write(x.UC_X86_REG_DS, 0x2600)
    cpu.reg_write(x.UC_X86_REG_SI, 0xc9b2)
    cpu.reg_write(x.UC_X86_REG_CS, 0xb3d9)
    cpu.reg_write(x.UC_X86_REG_IP, 0x4014)
    cpu.emu_start(0xb7da4, 0xb7db2, count=100)
    cpu.reg_write(x.UC_X86_REG_CS, 0xb3d9)
    cpu.reg_write(x.UC_X86_REG_IP, 0x3efb)
    cpu.emu_start(0xb7c8b, 0xb7d57, count=100)
    expected_ports = [[0x58,1,0x5e],[0x5a,1,0],[0x5c,1,selector-5],[0x5e,1,0]]
    if ports != expected_ports:
        raise AssertionError((ports, expected_ports))
    return {'bearer_selector': selector, 'slot': 0, 'connection_id': 0x11,
            'record_selector': cpu.mem_read(0xce00+0xa63a,1)[0],
            'queued_words': queued, 'mailbox_writes': ports}


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output', type=Path, required=True)
    args=parser.parse_args()
    image=XmpImage.load('Ie030002.xmp')
    report={'image_sha256':image.digest,'scope':__doc__,
            'cases':[probe(image,6),probe(image,7)]}
    args.output.parent.mkdir(parents=True,exist_ok=True)
    args.output.write_text(json.dumps(report,indent=2)+'\n')
    print(json.dumps(report['cases'],indent=2))

if __name__=='__main__': main()
