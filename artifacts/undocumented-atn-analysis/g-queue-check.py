"""Offline G eight-hex-digit queue check; no hardware access."""
import json
from pathlib import Path
from unicorn import Uc,UC_ARCH_X86,UC_MODE_16,UC_HOOK_CODE
from unicorn.x86_const import *
rom=Path('artifacts/courier-board-21210-capture-403/courier-board.rom').read_bytes()
u=Uc(UC_ARCH_X86,UC_MODE_16);u.mem_map(0,0x100000);u.mem_write(0x80000,rom)
u.mem_write(0x2000,b'00541234\0');u.mem_write(0x194,b'\x98\x01\x98\x01')
for r,v in ((UC_X86_REG_CS,0xa4e2),(UC_X86_REG_DS,0),(UC_X86_REG_ES,0),(UC_X86_REG_SS,0),(UC_X86_REG_SP,0x7000),(UC_X86_REG_SI,0x2000),(UC_X86_REG_CX,8)):
 u.reg_write(r,v)
stopped=[]
def stop(cpu,address,size,user):
 if address==0xa5c78:stopped.append(address);cpu.emu_stop()
u.hook_add(UC_HOOK_CODE,stop);u.emu_start(0xa5c02,0x100000,count=1000)
assert stopped
raw=bytes(u.mem_read(0x198,6));words=[int.from_bytes(raw[i:i+2],'little') for i in range(0,6,2)]
assert words==[0xff00,0x54,0x1234],words
result={'command':'ATG00541234','hardware_tested':False,'queue_words':[f'{w:04x}' for w in words],'head':int.from_bytes(u.mem_read(0x196,2),'little'),'limitation':'Empty synthetic queue; stopped before return and actual transmission. Arbitrary values chosen to verify order, not as a board command recommendation.'}
Path('artifacts/undocumented-atn-analysis/g-queue-results.json').write_text(json.dumps(result,indent=2)+'\n');print(result)
