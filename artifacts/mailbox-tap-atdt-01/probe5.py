import collections
from unicorn import Uc, UC_HOOK_CODE
from courier_emu.cli import load_image
from courier_emu.machine import CourierMachine
from courier_emu.daa import CourierDaa
TARGET=0x5d37f            # cs 0x5b5e : 0x1d9f, the armed dial callback
seen=collections.Counter()
_orig=Uc.hook_add
def hook_add(self,htype,cb,ud=None,begin=1,end=0,*a,**k):
    r=_orig(self,htype,cb,ud,begin,end,*a,**k)
    if htype==UC_HOOK_CODE and not getattr(self,'_p',False):
        self._p=True
        def probe(uc,address,size,d_): seen[address]+=1
        _orig(self,UC_HOOK_CODE,probe,None,TARGET,TARGET+0x60)
    return r
Uc.hook_add=hook_add
m=CourierMachine(load_image('main211.xmf'), with_dsp=True,
                 serial_input=b"ATDT123\r", daa=CourierDaa("dial-tone"))
d=m.run(9_000_000).to_dict()
print(f"armed dial callback at {TARGET:#07x}: "
      f"{'EXECUTED, %d instrs over %d addresses' % (sum(seen.values()), len(seen)) if seen else 'NEVER EXECUTED'}")
if seen:
    print("  addresses:", [hex(a) for a in sorted(seen)][:20])
print("  final [0x298] =", hex(d['supervisor_call_cells']['0298']),
      " [0x1cf0] =", hex(d['supervisor_call_cells']['1cf0']))
daa=d['dsp_bridge']['daa']
print("  daa:", {k:daa[k] for k in ('operation','off_hook','line_state','detector_qualified',
                                    'dial_tone_present','dial_tone_qualified') if k in daa})
