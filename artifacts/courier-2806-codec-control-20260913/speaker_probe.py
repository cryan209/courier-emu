from pathlib import Path
import json,re
from courier_emu.flash_dump import SerialPort,command_for,parse_page
from courier_emu.dsp_mailbox import _transact
out=Path('artifacts/courier-2806-codec-control-20260913');log=[]
with SerialPort('/dev/cu.usbserial-FT4TQOFT',115200,allow_ram=True) as p:
 p.drain()
 def cmd(c):
  assert c in ['ATI7','ATI4','ATM0','ATM1','ATM2','ATM3','AT']
  raw=_transact(p,c,4);log.append({'command':c,'raw':raw.decode()});(out/'transcript.json').write_text(json.dumps(log,indent=2));return raw
 identity=cmd('ATI7');assert b'22AEB36ACKND' in identity
 profile=cmd('ATI4');assert re.search(rb'\sM1\s',profile)
 try:
  for mode in [0,1,2,3,0]:
   assert b'OK' in cmd(f'ATM{mode}')
   data=bytearray()
   for a in range(0,0x1000,256):
    raw=p.query(command_for(a,allow_ram=True));page,_=parse_page(raw,a,allow_ram=True);data.extend(page)
   name=f'm{mode}-{len(log)}';(out/(name+'.bin')).write_bytes(data);print(name,flush=True)
 finally:
  cmd('ATM1');cmd('ATI4');cmd('AT')
