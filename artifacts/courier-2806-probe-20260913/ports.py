from pathlib import Path
import json,re
from courier_emu.asic_probe import MonitorPort,MAILBOX_PORTS
out=Path('artifacts/courier-2806-probe-20260913'); r=json.loads((out/'results.json').read_text());r['ports']=[]
def save(): (out/'results.json').write_text(json.dumps(r,indent=2)+'\n')
with MonitorPort(r['device'],115200) as p:
 p.drain(); print(repr(p.query('ATI7')),flush=True)
 for repeat in range(2):
  readings={};r['ports'].append(readings)
  for n in range(256):
   if n in MAILBOX_PORTS or 0x40<=n<=0x62: continue
   for attempt in range(3):
    raw=p.query(f'ATGLK2I00{n:02X}')
    m=re.search(rb'[\r\n]([0-9A-F]{2})[\r\n]+OK[\r\n]+$',raw)
    if m: break
    p.drain()
   readings[f'{n:02x}']={'value':int(m[1],16) if m else None,'raw':raw.decode('ascii',errors='backslashreplace')};save()
   if not m: raise RuntimeError(repr(raw))
  print('Pass',repeat+1,'complete',flush=True)
 r['final_attention']=p.query('AT').decode();save()
