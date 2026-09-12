import sys, time, json
from pathlib import Path
sys.path.insert(0, str(Path(__file__).resolve().parents[2]))
from courier_emu.isdn import IsdnMachine
from courier_emu.nac import NacImage
from courier_emu.isdn_console import _on_the_wire, _readable
from unicorn import UC_HOOK_CODE, UC_HOOK_MEM_WRITE
from unicorn.x86_const import UC_X86_REG_AL,UC_X86_REG_DS, UC_X86_REG_CS, UC_X86_REG_IP, UC_X86_REG_SI
import argparse
parser = argparse.ArgumentParser(description="Reproduce I-modem terminal framing failures through the raw UART.")
parser.add_argument('--mode', choices=['raw', 'suffix', 'prefix-handler'], default='raw')
parser.add_argument('--output', type=Path, required=True)
args = parser.parse_args()
log=[]
commands=['AT','ATI','ATI6','ATY11','AT']
if args.mode == 'suffix':
    commands=[command[2:] for command in commands]
schedule=[(5_000_000+i*20_000_000,c+'\r') for i,c in enumerate(commands)]
hooked=False
out=bytearray()
last=None

def event(kind, **kw):
    record=dict(n=m.instructions,kind=kind,**kw)
    log.append(record)
    print(json.dumps(record), flush=True)

def snapshot():
    return {hex(a):bytes(m.machine.mem_read(0x26000+a,s)).hex() for a,s in [(0xc922,2),(0xc926,2),(0xe49a,20),(0xd08b,1),(0xd2a1,1),(0xd2c5,5),(0xe770,1),(0xe78e,2)]}

def pump(machine):
    global hooked, last
    uc=machine.machine
    if not hooked:
        hooked=True
        def on_result(uc,a,s,d): event('result',code=uc.reg_read(UC_X86_REG_AL),state=snapshot())
        def on_callback(uc,access,a,s,v,d):
            event('callback',address=hex(a),value=hex(v),pc=hex(uc.reg_read(UC_X86_REG_CS)*16+uc.reg_read(UC_X86_REG_IP)))
        def select_receiver(uc,a,s,d):
            # Raw/suffix deliberately reproduce the pre-fix route. The normal
            # emulator now makes the prefix-handler selection itself.
            receiver = b'\x96\xf5' if args.mode == 'prefix-handler' else b'\x8d\xec'
            uc.mem_write(0x34834, receiver)
        uc.hook_add(UC_HOOK_CODE,select_receiver,begin=0xc7bf1,end=0xc7bf1)
        uc.hook_add(UC_HOOK_CODE,on_result,begin=0xacf8c,end=0xacf8c)
        uc.hook_add(UC_HOOK_MEM_WRITE,on_callback,begin=0x32922,end=0x32927)
    data=m.take_serial()
    if data:
        out.extend(data)
        last=m.instructions
    if out and m.instructions-last>100_000:
        event('rx',text=_readable(out)); out.clear()
    if schedule and m.instructions>=schedule[0][0]:
        _,line=schedule.pop(0)
        event('tx',text=line,state=snapshot())
        m.send_serial(_on_the_wire(line))

m=IsdnMachine(NacImage.load('Ie030002.nac'),serial_pump=pump,flash_nvram=Path('flashnvram.sav').read_bytes(),profile=False)
t=time.monotonic(); result=m.run(105_000_000)
print('elapsed',time.monotonic()-t,result.status,flush=True)
args.output.write_text(json.dumps(log, indent=2)+'\n')
