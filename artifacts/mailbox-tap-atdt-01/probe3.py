"""What does the dial callback cell [0x298] point at, and who runs it?"""
import collections
from unicorn import Uc, UC_HOOK_CODE, UC_HOOK_MEM_WRITE
from courier_emu.cli import load_image
from courier_emu.machine import CourierMachine
from courier_emu.daa import CourierDaa

writes=collections.Counter(); order=[]
_orig=Uc.hook_add
def hook_add(self,htype,cb,ud=None,begin=1,end=0,*a,**k):
    r=_orig(self,htype,cb,ud,begin,end,*a,**k)
    if htype==UC_HOOK_CODE and not getattr(self,'_p',False):
        self._p=True
        def w(uc,access,address,size,value,d_):
            pc=uc.reg_read(21)  # UC_X86_REG_IP is not enough; use CS:IP below
            cs=uc.reg_read(30); ip=uc.reg_read(21)
            at=((cs<<4)+ip)&0xFFFFF
            key=(address,size,value)
            writes[key]+=1
            if len(order)<24: order.append((at,address,size,value))
        _orig(self,UC_HOOK_MEM_WRITE,w,None,0x0296,0x029b)
    return r
Uc.hook_add=hook_add
m=CourierMachine(load_image('main211.xmf'), with_dsp=True,
                 serial_input=b"ATDT123\r", daa=CourierDaa("dial-tone"))
m.run(9_000_000)
print("writes to 0x0296-0x029b:")
for (addr,size,val),n in writes.most_common(12):
    print(f"   [{addr:#06x}] size={size} value={val:#06x}  x{n}")
print("\nfirst writes (pc, addr, size, value):")
for at,addr,size,val in order[:16]:
    print(f"   pc={at:#07x}  [{addr:#06x}] size={size} = {val:#06x}")
