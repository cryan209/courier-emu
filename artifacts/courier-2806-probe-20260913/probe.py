from pathlib import Path
import json, hashlib
from datetime import datetime, timezone
from courier_emu.flash_dump import SerialPort, command_for, parse_page, validate_identity
from courier_emu.asic_probe import MonitorPort, MAILBOX_PORTS
out=Path('artifacts/courier-2806-probe-20260913')
reference=Path('artifacts/courier-2806-25mhz-flash-20260912/courier-board.rom').read_bytes()
report={'started':datetime.now(timezone.utc).isoformat(),'device':'/dev/cu.usbserial-FT4TQOFT','baud':115200,'flash':[], 'ports':[], 'writes':False}
def save(): (out/'results.json').write_text(json.dumps(report,indent=2)+'\n')
with SerialPort(report['device'],115200) as p:
 p.drain()
 raw=p.query('ATI7'); validate_identity(raw)
 report['identity']=raw.decode(); save()
 assert '22AEB36ACKND' in report['identity'] and '25 Mhz' in report['identity']
 for base in range(0x80000,0x100000,0x10000):
  for offset in (0,0x4000,0xff00):
   addr=base+offset; copies=[]
   for i in range(2):
    raw=p.query(command_for(addr)); (out/f'flash-{addr:05x}-{i}.txt').write_bytes(raw)
    data,status=parse_page(raw,addr); copies.append(data)
   report['flash'].append({'address':hex(addr),'stable':copies[0]==copies[1],'matches_reference':copies[0]==reference[addr-0x80000:addr-0x80000+256],'sha256':hashlib.sha256(copies[0]).hexdigest()})
   save()
  print('Flash region',hex(base),'checked',flush=True)
with MonitorPort(report['device'],115200) as p:
 p.drain()
 # Skip all mailbox lanes and the download window: characterize GPIO and decode only.
 numbers=[n for n in range(256) if n not in MAILBOX_PORTS and not 0x40<=n<=0x62]
 from courier_emu.asic_probe import VALUE
 for repeat in range(2):
  readings={}
  for n in numbers:
   raw=p.query(f'ATGLK2I00{n:02X}'); m=VALUE.search(raw)
   readings[f'{n:02x}']={'value':int(m[1],16) if m else None,'raw':raw.decode('ascii',errors='backslashreplace')}
   if m is None: raise RuntimeError(f'Unrecognized response at {n:02x}: {raw!r}')
  report['ports'].append(readings); save(); print('Port pass',repeat+1,'complete',flush=True)
 report['final_attention']=p.query('AT').decode(); save()
report['finished']=datetime.now(timezone.utc).isoformat(); save()
print('Complete',flush=True)
