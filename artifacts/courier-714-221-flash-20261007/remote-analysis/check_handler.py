"""Offline execution of saved firmware only; no serial or modem access."""
from pathlib import Path
import json
from courier_emu.x86_interpreter import *
ROOT = Path(__file__).resolve().parents[1]
ROM = (ROOT / 'courier-board.rom').read_bytes()
def encode(v):
 a=(v-5)&255; a=((a<<2)|(a>>6))&255
 c=(v+15)&255; c=((c>>1)|(c<<7))&255
 return bytes((a,c,v^29))
def run(frame, valid=True, state=3):
 u=Uc(UC_ARCH_X86,UC_MODE_16);u.mem_map(0,0x100000);u.mem_write(0x80000,ROM)
 for reg,value in [(UC_X86_REG_CS,0x8000),(UC_X86_REG_DS,0),(UC_X86_REG_ES,0),(UC_X86_REG_SS,0),(UC_X86_REG_SP,0x8000),(UC_X86_REG_SI,0x1a80),(UC_X86_REG_CX,len(frame))]:u.reg_write(reg,value)
 u.mem_write(0x8000,(0xf000).to_bytes(2,'little'))
 u.mem_write(0x1a80,frame);u.mem_write(0xb97,bytes([state]));u.mem_write(0x748,encode(15) if valid else b'\0\0\0')
 events=[]
 def hook(uc,a,size,data):
  if a==0x8da13:
   events.append({'event':'EEPROM writer reached','record':bytes(uc.mem_read(0x748,3)).hex()})
   # Skip hardware EEPROM I/O; return directly to caller.
   uc.reg_write(UC_X86_REG_IP,0xda46)
  if a==0x8f000:uc.emu_stop()
 u.hook_add(UC_HOOK_CODE,hook)
 u.emu_start(0x8cd32,0x8f001,count=10000)
 return {'frame':frame.hex(),'link_state':state,'events':events,'record_after':bytes(u.mem_read(0x748,3)).hex(),'expected_31':encode(31).hex(),'ip':hex(u.reg_read(UC_X86_REG_IP))}
if __name__=='__main__':
 result=[run(bytes.fromhex(x),state=s) for x,s in [('01020a0225',3),('03020a0225',3),('01120a0225',3),('01020a0125',3),('01020a0225',0)]]
 print(json.dumps(result,indent=2))
