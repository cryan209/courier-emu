from pathlib import Path
import json,re
from courier_emu.flash_dump import SerialPort,command_for,parse_page
from courier_emu.dsp_mailbox import _transact
out=Path('artifacts/courier-2806-codec-control-20260913');r={'steps':[],'transcript':[]}
with SerialPort('/dev/cu.usbserial-FT4TQOFT',115200,allow_ram=True) as p:
 p.drain()
 def cmd(c):
  assert c in ['ATI7','AT','ATI4','ATM0','ATM1','ATM2','ATM3','ATL0','ATL1','ATL2','ATL3','ATGLK2I0012']
  raw=_transact(p,c,4);r['transcript'].append({'cmd':c,'raw':raw.decode()});save();assert b'OK' in raw;return raw
 def save(): (out/'volume-results.json').write_text(json.dumps(r,indent=2)+'\n')
 def page(a):
  for attempt in range(3):
   raw=p.query(command_for(a,allow_ram=True))
   try:return parse_page(raw,a,allow_ram=True)[0]
   except ValueError:
    r.setdefault('read_errors',[]).append({'address':a,'raw_hex':raw.hex()});save();p.drain()
  raise RuntimeError('RAM read failed repeatedly')
 assert b'22AEB36ACKND' in cmd('ATI7')
 before=page(0x500);origL,origM=before[0xe7:0xe9];assert origL<4 and origM<4
 r['original']={'L':origL,'M':origM};save()
 def snap(label):
  state=page(0x500);shadow=page(0x300);flags=page(0x600)
  raw=cmd('ATGLK2I0012');value=int(re.search(rb'[\r\n]([0-9A-F]{2})[\r\n]+OK',raw)[1],16)
  r['steps'].append({'label':label,'L':state[0xe7],'M':state[0xe8],'port12':value,'shadow030f':shadow[0x0f],'board_flags0693':flags[0x93]});save();print(r['steps'][-1],flush=True)
 try:
  snap('before')
  for mode in range(4):cmd(f'ATL{mode}');snap(f'L{mode}')
  for mode in range(4):cmd(f'ATM{mode}');snap(f'M{mode}')
 finally:
  cmd(f'ATL{origL}');cmd(f'ATM{origM}');snap('restored');cmd('AT')
