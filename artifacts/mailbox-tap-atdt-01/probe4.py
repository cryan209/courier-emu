import collections
from unicorn import Uc, UC_HOOK_CODE, UC_HOOK_MEM_READ
from unicorn.x86_const import UC_X86_REG_CS, UC_X86_REG_IP
from courier_emu.cli import load_image
from courier_emu.machine import CourierMachine
from courier_emu.daa import CourierDaa
reads=collections.Counter()
_orig=Uc.hook_add
def hook_add(self,htype,cb,ud=None,begin=1,end=0,*a,**k):
    r=_orig(self,htype,cb,ud,begin,end,*a,**k)
    if htype==UC_HOOK_CODE and not getattr(self,'_p',False):
        self._p=True
        def rd(uc,access,address,size,value,d_):
            cs=uc.reg_read(UC_X86_REG_CS); ip=uc.reg_read(UC_X86_REG_IP)
            reads[(((cs<<4)+ip)&0xFFFFF, cs)] += 1
        _orig(self,UC_HOOK_MEM_READ,rd,None,0x0298,0x0299)
    return r
Uc.hook_add=hook_add
m=CourierMachine(load_image('main211.xmf'), with_dsp=True,
                 serial_input=b"ATDT123\r", daa=CourierDaa("dial-tone"))
m.run(9_000_000)
print("readers of [0x298]  (pc, cs) -> implied callback target cs*16+0x1d9f:")
for (pc,cs),n in reads.most_common(10):
    print(f"   pc={pc:#07x} cs={cs:#06x}  x{n:<6d}  target -> {((cs<<4)+0x1d9f)&0xFFFFF:#07x}")
