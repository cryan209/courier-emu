"""Execute captured 403 ATN instructions; stop at state dispatch/restart.
No board connection and no synthetic DSP responses.
"""
import json
from pathlib import Path
from unicorn import Uc, UC_ARCH_X86, UC_MODE_16, UC_HOOK_CODE
from unicorn.x86_const import *
rom = Path('artifacts/courier-board-21210-capture-403/courier-board.rom').read_bytes()
rows = []
for suffix in ('0', '1', '7', '255', '256', 'X', 'L'):
    uc = Uc(UC_ARCH_X86, UC_MODE_16)
    uc.mem_map(0, 0x100000)
    uc.mem_write(0x80000, rom)
    uc.mem_write(0x2000, suffix.encode())
    for reg, val in ((UC_X86_REG_CS,0x8000),(UC_X86_REG_DS,0),(UC_X86_REG_ES,0),
                     (UC_X86_REG_SS,0),(UC_X86_REG_SP,0x7000),
                     (UC_X86_REG_SI,0x2000),(UC_X86_REG_CX,len(suffix))):
        uc.reg_write(reg,val)
    row = {'command':'ATN'+suffix}
    def hook(cpu,address,size,user):
        stops = {0x8f554:'supervisor-state-dispatch',0x80480:'restart-entry',
                 0x883bf:'fixed-transfer-entry',0x88471:'return-without-dispatch'}
        if address in stops:
            row.update(stop=stops[address], AX=f'{cpu.reg_read(UC_X86_REG_AX):04x}',
                       manual_flag=cpu.mem_read(0xa16,1)[0])
            cpu.emu_stop()
    uc.hook_add(UC_HOOK_CODE,hook)
    uc.emu_start(0x883a6,0x100000,count=10000)
    assert 'stop' in row,row
    rows.append(row)
print(json.dumps(rows,indent=2))
Path('artifacts/undocumented-atn-analysis/handler-results.json').write_text(json.dumps(rows,indent=2)+'\n')
