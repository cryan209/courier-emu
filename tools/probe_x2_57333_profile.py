#!/usr/bin/env python3
"""Probe preselected QF060003 rate-index 15 builders and exact-symbol inverses.

This seeds candidate records; it does not reproduce peer negotiation.
"""
import ctypes,json,math,random,subprocess,sys,tempfile
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1];sys.path.insert(0,str(ROOT))
from tools.recover_x2_payload import Runner,unpack_frame,apply_signs
out=ROOT/'artifacts/x2-57333-profile-20261004';out.mkdir(exist_ok=True);rows=[]
rng=random.Random(57333);checks=0
tmp=tempfile.TemporaryDirectory();lib=Path(tmp.name)/'inverse.dylib'
subprocess.run(['clang','-shared','-fPIC','-Wall','-Wextra','-Werror',str(ROOT/'artifacts/x2-payload-mapper-20261004/payload_lift.c'),'-o',str(lib)],check=True)
lift=ctypes.CDLL(str(lib))
for mode in range(3):
 for flags in (0,1,4,5):
  for active in range(3):
   r=Runner();record=sum(2<<(4*i) for i in range(active))
   r.put({0x340:mode<<11,0xe8f1:record&65535,0xe8f2:0x600|(record>>16),0xffd9:flags,0x3fb:1,0x39f:64})
   row={}
   try:
    steps=r.run(0xc862,acc=15,spm=1)
    sizes=[r.core.data(0x4bb-i) for i in range(6)]
    banks=[[r.core.data(0xe8f4+128*i+j) for j in range(n)] for i,n in enumerate(sizes)]
    unique=[len({x&127 for x in bank}) for bank in banks];capacity=math.prod(sizes)
    row={'mode':mode,'flags':flags,'active':active,'record':record,'sizes':sizes,'unique':unique,'capacity':capacity,'steps':steps,'valid':capacity>=2**37 and sizes==unique}
    if row['valid']:
     template={a:r.core.data(a) for a in [0x3c0,0x3c2,0x3ed,0x3ef,0x3a3,*range(0x4b6,0x4bc),*range(0xed4f,0xedcf),*range(0xe8f4,0xebf4)]}
     assert template[0x3c0]==37 and template[0x3ed]==6
     (out/f'profile-{mode}-{flags}-{active}.json').write_text(json.dumps({'row':row,'data':template},indent=2)+'\n')
     for case in range(64):
      value=0 if case==0 else (1<<43)-1 if case==1 else rng.getrandbits(43)
      cursor=rng.randrange(128);parity0=rng.getrandbits(16)
      ring=((value<<cursor)|(value>>(128-cursor)))&((1<<128)-1)
      d=template.copy();d.update({0x3af:cursor,0x3da:parity0,0x3fb:1,0x39f:64,0x4d2:0})
      for i in range(8):d[0x248+i]=(ring>>(16*i))&65535
      data=(ctypes.c_uint16*65536)()
      for addr,word in d.items():data[addr]=word
      r.put(d);unpack_frame(d);apply_signs(d)
      r.run(0xc5df,spm=1);r.run(0xc642,spm=1)
      r.compare(d,[0x3af,0x3da,*range(0x4bc,0x4c2)])
      octets=(ctypes.c_uint8*6)(*[d[0x4c1-i] for i in range(6)])
      parity=ctypes.c_uint16(parity0);decoded=ctypes.c_uint64()
      assert lift.payload_inverse(data,octets,ctypes.byref(parity),ctypes.byref(decoded))==0
      assert decoded.value==value and parity.value==d[0x3da]
      checks+=1
     row['exact_symbol_roundtrips']=64
   except AssertionError:
    if row.get('valid'):raise
    row={'mode':mode,'flags':flags,'active':active,'status':'did not return','pc':hex(r.core.state()['pc'])}
   print(row,flush=True);rows.append(row);r.core.close()
(out/'search-spm1.json').write_text(json.dumps(rows,indent=2)+'\n')
(out/'verification.json').write_text(json.dumps({'profile':'QF060003','rate_index':15,'amplitude_bits':37,'independent_sign_bits':6,'frame_bits':43,'builder_product_scaling_mode':1,'candidate_contexts':len(rows),'valid_contexts':sum(x.get('valid',False) for x in rows),'exact_symbol_roundtrips':checks,'qualification':'Seeded builder inputs and exact-symbol inverse; no established call.'},indent=2)+'\n')
tmp.cleanup()
