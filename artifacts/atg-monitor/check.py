"""Isolated IDSDL302 ATG handler check; firmware file opened read-only.

The AT dispatcher is bypassed. Only serial formatting helpers are intercepted;
the reference's suffix parser, address parser and memory reads execute normally.
"""
from pathlib import Path
import json
import struct
from unicorn import Uc, UC_ARCH_X86, UC_MODE_16, UC_HOOK_CODE, UC_HOOK_MEM_WRITE
from unicorn import x86_const as r

source = Path('IDSDL302.ROM')
firmware = source.read_bytes()
results = []
for suffix in ('=8000:0000', 'LK2=8000:0000', 'R8000:0000', 'LK2R8000:0000'):
    cpu = Uc(UC_ARCH_X86, UC_MODE_16)
    cpu.mem_map(0, 0x100000)
    cpu.mem_write(0x80000, firmware)
    cpu.mem_write(0x6000, suffix.encode() + b'\r')
    cpu.mem_write(0xEFF0, struct.pack('<H', 0x1000))
    for reg, val in ((r.UC_X86_REG_CS, 0xA0CA), (r.UC_X86_REG_IP, 0x4F09),
                     (r.UC_X86_REG_DS, 0), (r.UC_X86_REG_ES, 0),
                     (r.UC_X86_REG_SS, 0), (r.UC_X86_REG_SP, 0xEFF0),
                     (r.UC_X86_REG_SI, 0x6000), (r.UC_X86_REG_CX, len(suffix)),
                     (r.UC_X86_REG_BX, ord('G')), (r.UC_X86_REG_EFLAGS, 2)):
        cpu.reg_write(reg, val)
    output = bytearray()
    returned = []
    nonstack_writes = []

    def code(cpu, address, size, _):
        if address == 0xA1CA0:
            returned.append(True)
            cpu.emu_stop()
        elif address in (0x815EC, 0x8E951):
            if address == 0x815EC:
                output.append(cpu.reg_read(r.UC_X86_REG_AL))
            else:
                assert cpu.reg_read(r.UC_X86_REG_BX) == 0x9E05
                output.extend(b'\r\n')
            sp = cpu.reg_read(r.UC_X86_REG_SP)
            ip, cs = struct.unpack('<HH', cpu.mem_read(sp, 4))
            cpu.reg_write(r.UC_X86_REG_SP, sp + 4)
            cpu.reg_write(r.UC_X86_REG_CS, cs)
            cpu.reg_write(r.UC_X86_REG_IP, ip)

    def write(cpu, access, address, size, value, _):
        if not 0xEE00 <= address < 0xEFF2:
            nonstack_writes.append([address, size, value])

    cpu.hook_add(UC_HOOK_CODE, code)
    cpu.hook_add(UC_HOOK_MEM_WRITE, write)
    cpu.emu_start(0xA5BA9, 0x100000, count=100000)
    lines = output.decode().strip().splitlines()
    reconstructed = bytearray()
    word_mode = suffix.removeprefix('LK2').startswith('R')
    for i, line in enumerate(lines):
        fields = line.split()
        assert fields[0] == f'8000:{i * 16:04X}'
        for field in fields[1:]:
            reconstructed.extend(int(field, 16).to_bytes(2 if word_mode else 1, 'little'))
    assert returned and len(lines) == 16
    assert reconstructed == firmware[:256]
    assert not nonstack_writes
    assert source.read_bytes() == firmware
    results.append({'command': 'ATG' + suffix, 'rows': len(lines), 'bytes': len(reconstructed),
                    'matches_firmware': True, 'nonstack_writes': nonstack_writes,
                    'first_line': lines[0], 'last_line': lines[-1]})
print(json.dumps({'mode': 'isolated handler; serial helper interception', 'results': results}, indent=2))
