from pathlib import Path
import json,re
import courier_emu.dsp_mailbox as mailbox
mailbox.READ_REPLY=re.compile(rb"[\r\n]([0-9A-F]{2})[\r\n]+OK[\r\n]+$")
from courier_emu.rom import CourierRom
from courier_emu.mailbox_compare import program
from courier_emu.dsp_mailbox import MailboxPort,Session
from tools.c5x_disasm import disassemble
out=Path('artifacts/courier-2806-mailbox-20260913')
w=program(CourierRom.load('artifacts/courier-2806-25mhz-flash-20260912/courier-board.rom'))
assert w[0x8408]==0x84cb and w[0x842e]==0x8222 and w[0x8222]==0xef00
assert w[0x84cb:0x84d3]==[0x7e80,0x83c8,0xbf80,0x8031,0x7d80,0x83c8,0xbc10,0x1018]
(out/'dsp-disassembly.txt').write_text('\n'.join(f'{i.pc:04x} '+ ' '.join(f'{x:04x}' for x in i.words)+'  '+i.text for a,b in [(0x839b,0x8401),(0x83c8,0x839b),(0x84cb,0x84d3),(0x8222,0x8223)] for i in disassemble(w,a,b))+'\n')
r={'steps':[],'scope':'Monitor-level mailbox staging and commit with native supervisor running; query 07 and no-op 2d only.'}
with MailboxPort('/dev/cu.usbserial-FT4TQOFT',115200) as p:
 p.drain();s=Session(p)
 def save():
  (out/'results.json').write_text(json.dumps(r,indent=2)+'\n');(out/'transcript.json').write_text(json.dumps(s.transcript,indent=2)+'\n')
 r['identity']=s.command('ATI7').decode();save()
 assert '22AEB36ACKND' in r['identity'] and '25 Mhz' in r['identity'] and '7.3.14' in r['identity']
 def snap(label):
  entry={'label':label,'ports':s.window()};r['steps'].append(entry);save();print(entry,flush=True)
 snap('baseline')
 for tag,value in [(7,0xa55a),(0x2d,0x5aa5),(7,0x1234)]:
  assert s.read_port(0x1c)&1, 'Input holding register not free'
  for port,v in [(0x58,tag),(0x5a,0),(0x5c,value&255),(0x5e,value>>8)]: s.write_port(port,v);save()
  snap(f'{tag:02x}: staged only')
  s.write_port(0x1e,0);save();snap(f'{tag:02x}: after 1e=00, before commit')
  s.write_port(0x1c,1);save();snap(f'{tag:02x}: after 1c=01 commit')
  snap(f'{tag:02x}: repeated read')
 r['final_attention']=s.command('AT').decode();save()
