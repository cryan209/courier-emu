from pathlib import Path
import serial,time,json,re,struct,sys
from courier_emu.flash_dump import parse_page,command_for,validate_identity
from courier_emu.probe_transport import parse_capture
out=Path(sys.argv[1]);ram=(out/'diagnostic-ram.bin').read_bytes();base=0x3000
assert not (out/'frame.txt').exists(), 'refusing to overwrite a hardware capture'
s=serial.Serial(sys.argv[2],115200,timeout=.05,exclusive=True)
log=(out/'serial-transcript.txt').open('wb')
def query(c,timeout=3):
 s.write((c+'\r').encode());data=b'';end=time.monotonic()+timeout
 while time.monotonic()<end:
  data+=s.read(4096)
  if re.search(rb'\r\n(?:OK|ERROR)\r\n',data):break
 log.write(data);log.flush()
 if b'\r\nOK\r\n' not in data and not c.startswith('ATGLK2='):raise RuntimeError((c,data))
 return data
def page(addr):return parse_page(query(command_for(addr,allow_ram=True)),addr,allow_ram=True)[0]
def write(a,v):
 assert base<=a<base+len(ram) or a in (0x20,0x22,0xff36)
 query(f'ATGLK2W{a:04X},{v:04X}')
try:
 query('AT');identity=query('ATI7');validate_identity(identity);(out/'identity.txt').write_bytes(identity)
 ivt=page(0);original=struct.unpack_from('<HH',ivt,0x20)
 raw=query('ATGLK2=0000:FF00');(out/'pcb-before.txt').write_bytes(raw)
 # PCB parser omits policy-level RAM range check, retaining the same row format.
 rows=re.findall(rb'^ *0000:([0-9A-Fa-f]{4})\s+((?:[0-9A-Fa-f]{2} ){15}[0-9A-Fa-f]{2})',raw,re.M)
 if not rows:raise RuntimeError('cannot parse PCB before arming')
 pcb=b''.join(bytes.fromhex(v.decode()) for a,v in rows)
 timer=struct.unpack_from('<H',pcb,0x36)[0]
 assert original==(0x108f,0x8000) and timer==0x8021,(original,timer)
 changed=0
 for start in range(base,base+len(ram),256):
  old=page(start)
  chunk=ram[start-base:start-base+256]
  for i in range(0,len(chunk),2):
   if chunk[i:i+2]!=old[i:i+2]:write(start+i,int.from_bytes(chunk[i:i+2],'little'));changed+=1
  print(f'placed {start:04x}, changed words {changed}',flush=True)
 verified=b''.join(page(a) for a in range(base,base+len(ram),256))[:len(ram)]
 (out/'readback.bin').write_bytes(verified)
 assert verified==ram,'RAM verify failed'
 print('verified exact RAM image; starting probe',flush=True)
 write(0x20,base);write(0x22,0)
 s.write(b'ATGLK2WFF36,A021\r');data=b'';end=time.monotonic()+7
 while time.monotonic()<end:data+=s.read(4096)
 (out/'frame.txt').write_bytes(data);log.write(data);log.flush();print(repr(data),flush=True)
 result=parse_capture(data[data.index(b'CDRP1 START'):]);(out/'hardware.json').write_text(json.dumps(result,indent=2))
 query('AT');ivt_after=page(0)
 assert ivt_after[0x20:0x24]==ivt[0x20:0x24], 'vector not restored by watchdog'
 (out/'pcb-after.txt').write_bytes(query('ATGLK2=0000:FF00'))
 print('hardware frame captured; AT answering and original vector restored',flush=True)
finally:s.close();log.close()
