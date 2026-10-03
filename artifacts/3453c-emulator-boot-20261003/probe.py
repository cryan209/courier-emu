import json,sys
from pathlib import Path
from courier_emu import worker
from courier_emu.bridge import CourierDspBridge
out=Path(__file__).resolve().parent
resets=[]
old=CourierDspBridge.set_reset
def reset(self,asserted):
    if asserted and not self._reset_asserted:
        resets.append({'instructions':self._instructions,'dsp':self.core.state(),'pmst':self.core.register(7),'io':self.core.io_port_stats([0x57,0x58,0x5e,0x5f]),'mmr':{f'{i:02x}':self.core.register(i) for i in range(0x20,0x2b)}})
    return old(self,asserted)
CourierDspBridge.set_reset=reset
sys.argv=['probe','2_3_33.XMF','--with-dsp','--instructions','2000000','--board-id','0','--tick-ms','5','--daa-codec']
try:worker.main()
finally:(out/'reset-trace.json').write_text(json.dumps(resets,indent=2)+'\n')
