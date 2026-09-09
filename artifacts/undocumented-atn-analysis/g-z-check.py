"""Check G? and Z suffix decoding offline, stopping before side effects."""
import json
from pathlib import Path
from unicorn import Uc, UC_ARCH_X86, UC_MODE_16, UC_HOOK_CODE
from unicorn.x86_const import *
rom=Path('artifacts/courier-board-21210-capture-403/courier-board.rom').read_bytes()
rows=[]
for command,suffix,entry in [('ATG?','?',0x25c02)]+[('ATZ'+s,s,0x2631c) for s in ('','0','1','2','3','4','5','!')]:
 u=Uc(UC_ARCH_X86,UC_MODE_16);u.mem_map(0,0x100000);u.mem_write(0x80000,rom)
 u.mem_write(0x2000,suffix.encode()+b'\0')
 for reg,value in ((UC_X86_REG_CS,0xa4e2),(UC_X86_REG_DS,0),(UC_X86_REG_ES,0),
                   (UC_X86_REG_SS,0),(UC_X86_REG_SP,0x7000),(UC_X86_REG_SI,0x2000),
                   (UC_X86_REG_CX,len(suffix))):u.reg_write(reg,value)
 row={'command':command}
 def hook(cpu,address,size,user):
  stops={0x80480:'restart',0x81eed:'G-fallback-call',0xa632b:'Z!-return'}
  if address in stops:
   row.update(stop=stops[address],AX=f'{cpu.reg_read(UC_X86_REG_AX):04x}',
              BP=cpu.reg_read(UC_X86_REG_BP),suffix_remaining=cpu.reg_read(UC_X86_REG_CX),
              byte_049b=cpu.mem_read(0x49b,1)[0]);cpu.emu_stop()
 u.hook_add(UC_HOOK_CODE,hook);u.emu_start(0x80000+entry,0x100000,count=1000)
 assert 'stop' in row,row
 rows.append(row)
print(json.dumps(rows,indent=2))
Path('artifacts/undocumented-atn-analysis/g-z-results.json').write_text(json.dumps(rows,indent=2)+'\n')
