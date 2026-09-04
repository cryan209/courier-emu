"""Which callers into the dial region actually execute during ATDT123?"""
import collections, sys, struct
from unicorn import Uc, UC_HOOK_CODE
from courier_emu.cli import load_image
from courier_emu.machine import CourierMachine
from courier_emu.daa import CourierDaa

SITES=[0x4a7d2,0x4b4a0,0x4deab,0x500b0,0x50ab5,0x574d3,0x5e8e2,0x6015e,0x60165,
       0x66fab,0x67019,0x6a26a,0x71f9f,0x72623,0x729cc,0x72b9e,0x72be7,0x72c5c,
       0x72caa,0x72cd3,0x72cfc,0x7313c,0x7c2f8,0x81c75,0x88a51]
seen=collections.Counter()
_orig=Uc.hook_add
def hook_add(self,htype,cb,ud=None,begin=1,end=0,*a,**k):
    r=_orig(self,htype,cb,ud,begin,end,*a,**k)
    if htype==UC_HOOK_CODE and not getattr(self,'_p',False):
        self._p=True
        def probe(uc,address,size,d_):
            if address in TARGETS: seen[address]+=1
        # one range hook per site keeps the callback rate low
        for s in SITES:
            _orig(self,UC_HOOK_CODE,probe,None,s,s)
    return r
TARGETS=set(SITES)
Uc.hook_add=hook_add
m=CourierMachine(load_image('main211.xmf'), with_dsp=True,
                 serial_input=b"ATDT123\r", daa=CourierDaa("dial-tone"))
m.run(9_000_000)
print("callers into the dial region, during ATDT123:")
for s in SITES:
    print(f"   {s:#07x}  {'EXECUTED x%d'%seen[s] if seen[s] else '-'}")
print(f"\n{sum(1 for s in SITES if seen[s])}/{len(SITES)} executed")
