"""Does the firmware's dial code execute during ATDT123?"""
import collections, sys
from unicorn import Uc, UC_HOOK_CODE
from courier_emu.cli import load_image
from courier_emu.machine import CourierMachine
from courier_emu.daa import CourierDaa

LOW, HIGH = 0x6a000, 0x6b100        # KNOWN-LIVE control: the mailbox consumer
WATCH = {0x6ad5b:'consumer out A',0x6aea5:'consumer out B',0x6b05f:'3-word sender'}
seen=collections.Counter(); first={}; order=[]

_orig = Uc.hook_add
def hook_add(self, htype, callback, user_data=None, begin=1, end=0, *a, **k):
    r=_orig(self, htype, callback, user_data, begin, end, *a, **k)
    if htype==UC_HOOK_CODE and not getattr(self,'_probe',False):
        self._probe=True
        def probe(uc, address, size, ud):
            seen[address]+=1
            if address in WATCH and address not in first:
                first[address]=len(order); order.append(address)
        _orig(self, UC_HOOK_CODE, probe, None, LOW, HIGH)
    return r
Uc.hook_add = hook_add

disable = "--disable-shortcircuit" in sys.argv
m=CourierMachine(load_image('main211.xmf'), with_dsp=True,
                 serial_input=b"ATDT123\r", daa=CourierDaa("dial-tone"))
if disable:
    m.dsp_bridge.core.set_dtmf_digits = lambda *a, **k: None
res=m.run(9_000_000)
print(f"short-circuit {'disabled' if disable else 'kept'}; "
      f"{sum(seen.values())} instructions executed in {LOW:#07x}-{HIGH:#07x}, "
      f"{len(seen)} distinct addresses")
print("\nwatched sites:")
for a,name in sorted(WATCH.items()):
    print(f"   {a:#07x} {name:24s} {'EXECUTED x%d' % seen[a] if seen[a] else 'never'}")
if seen:
    lo,hi=min(seen),max(seen)
    print(f"\nexecuted address span in region: {lo:#07x}..{hi:#07x}")
    print("hottest:", [(hex(a),c) for a,c in seen.most_common(8)])
