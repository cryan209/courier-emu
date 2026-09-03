"""Isolated hardware ATGLK2 handler using saved blocks, no serial access.

The AT dispatcher and serial helpers are bypassed. This observes parser state,
not the hardware terminal result. Uncaptured memory is not accessed.
"""
from pathlib import Path
import json
import struct
from unicorn import Uc, UC_ARCH_X86, UC_MODE_16, UC_HOOK_CODE, UC_HOOK_MEM_WRITE
from unicorn import x86_const as r

root = Path('artifacts/courier-board-21210-capture-01')
blocks = sorted((root / 'blocks').glob('*.bin'))
firmware = b''.join(p.read_bytes() for p in blocks)
assert len(firmware) >= 0x27000
results = []
for suffix in ('LK2=8000:0000', 'LK2=8000'):
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
        elif address in (0x815EC, 0x815F0, 0x89E11):
            if address in (0x815EC, 0x815F0):
                output.append(cpu.reg_read(r.UC_X86_REG_AL))
            else:
                output.extend(b'\r\n')
            sp = cpu.reg_read(r.UC_X86_REG_SP)
            if address == 0x815F0:
                ip = struct.unpack('<H', cpu.mem_read(sp, 2))[0]
                cs = cpu.reg_read(r.UC_X86_REG_CS)
                cpu.reg_write(r.UC_X86_REG_SP, sp + 2)
            else:
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
        assert fields[0] == (f'8000:{i * 16:04X}' if ':' in suffix else f'0000:{0x8000 + i * 16:04X}')
        for field in fields[1:]:
            reconstructed.extend(int(field, 16).to_bytes(2 if word_mode else 1, 'little'))
    assert returned and len(lines) == 16
    assert reconstructed == (firmware[:256] if ':' in suffix else bytes(256))
    assert not nonstack_writes
    results.append({'command': 'ATG' + suffix, 'rows': len(lines), 'bytes': len(reconstructed),
                    'matches_expected_memory': True, 'remaining_cx': cpu.reg_read(r.UC_X86_REG_CX), 'next_byte': bytes(cpu.mem_read(cpu.reg_read(r.UC_X86_REG_SI), 1)).hex(), 'carry': cpu.reg_read(r.UC_X86_REG_EFLAGS) & 1, 'nonstack_writes': nonstack_writes,
                    'first_line': lines[0], 'last_line': lines[-1]})
report = {'mode': 'captured hardware handler; dispatcher and serial helpers bypassed', 'results': results}
(root / 'handler-check.json').write_text(json.dumps(report, indent=2) + '\n')
print(json.dumps(report, indent=2))
