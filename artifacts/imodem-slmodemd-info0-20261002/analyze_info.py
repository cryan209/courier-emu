import sys,json
from pathlib import Path
import numpy as np
sys.path.insert(0,'/Users/scottcryan/courier-emu')
from courier_emu.sip import ulaw_to_linear
from tools.encode_x2_v90_fields import crc16_v34,bits_value
p=Path(sys.argv[1]); x=np.array([ulaw_to_linear(v) for v in (p/'imodem-tx.g711').read_bytes()])
# Answer INFO carrier 2400 Hz, 600 symbols/s. Test all symbol clock phases.
records=[]
for carrier in [2400,1200]:
 z=x*np.exp(-2j*np.pi*carrier*np.arange(len(x))/8000)
 cs=np.r_[0,np.cumsum(z)]
 for phase in np.arange(0,8000/600,.25):
  edges=np.round(np.arange(phase,len(x)-14,8000/600)).astype(int)
  sym=(cs[edges[1:]]-cs[edges[:-1]])/np.diff(edges)
  d=(sym[1:]*sym[:-1].conjugate()).real
  for inv in [0,1]:
   bits=((d<0)^inv).astype(int).tolist()
   sync=[1,1,1,1,0,1,1,1,0,0,1,0]
   for i in range(len(bits)-70):
    if bits[i:i+12]!=sync:continue
    for n in [17,30]:
     body=bits[i+12:i+12+n]; crc=bits_value(bits[i+12+n:i+28+n]); expected=crc16_v34(body)
     quality=float(np.mean(np.abs(sym[i:i+32])))
     if quality>150:
      records.append(dict(carrier=carrier,phase=float(phase),inv=inv,time=float(edges[i+1]/8000),length=n,body=bits_value(body),crc=crc,expected=expected,valid=crc==expected,quality=quality))
print('n',len(records),'valid',sum(v['valid'] for v in records))
print(json.dumps(sorted(records,key=lambda r:(not r['valid'],-r['quality']))[:35],indent=2))
(p/'info0-demod.json').write_text(json.dumps(records,indent=2))
