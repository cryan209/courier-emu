#!/usr/bin/env python3
"""Execute QF060003 record reception, rate selection and PCM data handoff.

Inputs are synthetic demodulated bits and local call state. No analogue
acquisition, client measurement/report construction or full call is claimed.
"""
import ctypes, hashlib, json, math, random, struct, subprocess, sys, tempfile
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1];sys.path.insert(0,str(ROOT))
from tools.recover_x2_payload import Runner
from tools.recover_x2_server import listing
from tools.probe_quad_pcm_codewords import RESIDENT, PCM_CORE, PCM_MODE
from courier_emu.quad_image import QuadImage
OUT=ROOT/'artifacts/x2-rate-handoff-20261004'
POINTS={0xab06:'accepted record',0xab24:'PCM record transfer',0xac34:'rate resolver',0xc862:'selected index to builder',0xc92a:'bank expansion',0xc52a:'data preparation',0xc544:'data callback',0xc5df:'frame grouping',0xc52e:'payload source activation',0x86cd:'host queue notification'}

def invoke(r,entry,dp=7,stop=None,limit=50000,trace=None):
 driver=[0xbc00|dp,0x8b89,0xbe47,0xbe42,0xbe4a,0xbf01,0x7a80,entry,0x8b00]
 r.core.load_program(struct.pack('<9H',*driver),0x7000);r.core.set_pc(0x7000)
 return resume(r,0x7008,stop,limit,trace)

def resume(r,returned,stop=None,limit=50000,trace=None):
 for _ in range(limit):
  state=r.core.state();pc=state['pc']
  if trace is not None and pc in POINTS:
   trace.append({'pc':hex(pc),'event':POINTS[pc],'acc':state['acc']&65535,'cells':{hex(a):r.core.data(a) for a in (0x340,0x341,0xe8f1,0xe8f2,0x3a2,0x3c0,0x3ed,0x3c8,0x3c9,0x3ca,0x3cb,0x3cd,0x3af,0x3d6,0x6f,0xffd9)}})
  if pc==stop:return True
  if pc==returned:return False
  r.core.step(1)
 raise AssertionError(('instruction limit',r.core.state()))

def encode_record(words):
 bits=[1]*17+[0];crc=65535
 for word in words:
  for i in range(16):
   bit=(word>>i)&1;bits.append(bit);v=crc^bit;crc=(v>>1)^(0x8408 if v&1 else 0)
  bits.append(0)
 return bits+[(crc>>i)&1 for i in range(16)],crc

def receive(r,words,corrupt=None,trace=None):
 # A9EA is the original demodulated-bit dispatcher. AAA4 installs the
 # original continuation; no FF48..FF4B or working record is seeded.
 r.put({0x39f:0x8040,0x323:0,0x325:0,0x3fb:1})
 invoke(r,0xaaa4,dp=6)
 bits,crc=encode_record(words)
 if corrupt is not None:bits[corrupt]^=1
 accepted=False
 for bit in bits:
  r.put({0x322:1,0x320:bit})
  accepted=invoke(r,0xa9ea,dp=6,stop=0xab2e,trace=trace)
  if accepted:break
 return accepted,crc

def frame_integer(r,count):
 cursor=r.core.data(0x3af);ring=sum(r.core.data(0x248+i)<<(16*i) for i in range(8))
 return ((ring>>cursor)|(ring<<(128-cursor)))&((1<<count)-1)

def main():
 OUT.mkdir(exist_ok=True);rng=random.Random(0xac34);report={'profile':'QF060003','qualification':'Synthetic demodulated records and seeded local call state; original receiver, selector, constructor and callback scheduler. No full call or analogue probe measurement.','checks':{}};events=[]
 q=QuadImage.controller(ROOT/'docs/x2/Qf060003.zip');report['controller_sha256']=hashlib.sha256(q.data).hexdigest();w=[0]*65536
 for o,n,pc in (RESIDENT,PCM_CORE,PCM_MODE):w[pc:pc+n//2]=struct.unpack(f'<{n//2}H',q.data[o:o+n])
 (OUT/'handoff.asm').write_text(''.join(listing(w,a,b) for a,b in [(0xa8ba,0xa8d4),(0xa9ea,0xa9fa),(0xaa45,0xaa6f),(0xaaa4,0xab2e),(0xac34,0xac92),(0xb096,0xb0a5),(0xc4ab,0xc4ba),(0xc524,0xc558),(0xc5c3,0xc5df),(0xc7e7,0xc7f1),(0xc85e,0xc8ab)]))
 # Sparse masks, every one-hot bit/peer-limit combination, and randomized
 # masks. Bit i permits local index i+1; zero produces sentinel index zero.
 r=Runner();selection=[]
 cases=[(limit,1<<bit) for limit in range(1,16) for bit in range(15)]+[(rng.randrange(16),rng.randrange(32768)) for _ in range(1024)]
 for peer,mask in cases:
  r.put({0x39f:0x8040,0x340:peer<<2,0xff39:mask,0x3fd:1,0x3fb:1})
  invoke(r,0xac34)
  expected=(mask&((1<<peer)-1)).bit_length();actual=r.core.state()['acc']&65535
  assert actual==expected,(peer,mask,actual,expected)
  if len(selection)<15 or peer==15 and mask==0:selection.append({'peer_limit':peer,'local_mask':mask,'selected_index':actual})
 report['checks']['rate_mask_and_peer_limit']=len(cases);r.core.close()
 # Accept arbitrary four-word bodies and reject mutations without committing
 # the working record. The decoded staging buffer may change on rejection.
 for case in range(128):
  words=[rng.getrandbits(16)&0x7ffe,rng.getrandbits(16),rng.getrandbits(16),rng.getrandbits(16)]
  for corrupt in (None,18+case%16,86+case%16):
   r=Runner();sentinel=[0xa55a,0x5aa5,0x1234,0x5678];r.put(dict(zip((0x340,0x341,0xe8f1,0xe8f2),sentinel)))
   accepted,_=receive(r,words,corrupt)
   assert accepted==(corrupt is None),(case,corrupt)
   actual=[r.core.data(a) for a in (0x340,0x341,0xe8f1,0xe8f2)]
   assert actual==(words if accepted else sentinel),(case,corrupt,actual)
   r.core.close()
 report['checks']['accepted_records']=128;report['checks']['rejected_corrupt_records']=256
 # All fifteen rates, both output flags, plus rate-15 bank variants.
 profiles=[(i,32767,0,flag,0) for i in range(1,16) for flag in (0,1)]
 profiles += [(15,32767,0,flag,record) for flag,record in [(0,2),(1,2),(4,0),(4,2),(4,0x22)]]
 profiles += [(15,32767,1,0,0),(15,32767,1,4,2),(15,32767,1,4,0x22),(15,0x3fff,0,0,0),(15,0x81,0,0,0)]
 with tempfile.TemporaryDirectory() as tmp:
  lib=Path(tmp)/'payload.dylib';subprocess.run(['clang','-shared','-fPIC','-Wall','-Wextra','-Werror',str(ROOT/'artifacts/x2-payload-mapper-20261004/payload_lift.c'),'-o',str(lib)],check=True);lift=ctypes.CDLL(str(lib));results=[];sample_count=0
  for peer,mask,mode,flag,record in profiles:
   r=Runner();trace=events if (peer,mask,mode,flag,record)==(15,32767,0,0,0) else None
   words=[(mode<<11)|(peer<<2),15<<6,record,0x600];accepted,crc=receive(r,words,trace=trace);assert accepted
   # Supply local mask and startup call state. No working record or selected
   # rate index is overwritten after reception.
   r.put({0xff39:mask,0x3ee:0x8000,0x3ef:0x2000,0xffd9:flag,0x3cc:5,0x3f4:5,0x3ca:0,0x3de:0,0x3df:0,0x3ae:0,0x3af:0,0x3d8:0,0x3d9:0,0x3da:0,0x3d1:255,0x3d2:8})
   invoke(r,0xc840,stop=0xc4ab);invoke(r,0xaa45,dp=6);assert r.core.data(0x3cd)==0xc7e7
   def refill():
    while ((r.core.data(0x3ae)-r.core.data(0x3af))&127)<=96:
     r.core.set_data(0x3d0,rng.randrange(256));invoke(r,0xb2ba)
   startup=[]
   for i in range(6):
    refill();invoke(r,0xb096,trace=trace);startup.append(r.core.data(0x3a7))
   assert r.core.data(0x3c8)==0xc52a and r.core.data(0x3ca)==0xff0
   selected=(mask&((1<<peer)-1)).bit_length();assert selected>0
   expected_b=w[0xc9e0+selected-1];parity=ctypes.c_uint16(r.core.data(0x3da));data=(ctypes.c_uint16*65536)()
   count=expected_b+6
   for frame in range(32):
    refill();expected=frame_integer(r,count);octets=[]
    for i in range(6):
     refill();invoke(r,0xb096,trace=trace if frame==0 else None);octets.append(r.core.data(0x3a7)^r.core.data(0x3a3));sample_count+=1
    assert r.core.data(0x3a2)==selected-1 and r.core.data(0x3c0)==expected_b and r.core.data(0x3ed)==6 and r.core.data(0x3c8)==0xc544
    if frame==0:
     for a in [0x39f,0x3c0,0x3c2,0x3ed,*range(0x4b6,0x4bc),*range(0xe8f4,0xebf4)]:data[a]=r.core.data(a)
     sizes=[data[0x4bb-i] for i in range(6)];assert math.prod(sizes)>=1<<expected_b
     assert all(len({data[0xe8f4+128*i+j]&127 for j in range(n)})==n for i,n in enumerate(sizes))
    decoded=ctypes.c_uint64();assert lift.payload_inverse(data,(ctypes.c_uint8*6)(*octets),ctypes.byref(parity),ctypes.byref(decoded))==0
    assert decoded.value==expected and parity.value==r.core.data(0x3da)
   if trace is not None:
    remaining=r.core.data(0x3ca)
    assert remaining==0xff0-32*6
    for _ in range(remaining):
     refill();invoke(r,0xb096)
    assert r.core.data(0x3c8)==0xc52e and r.core.data(0x3ca)==0
    r.put({0x78:0xbd0,0x79:0xbd0})
    invoke(r,0xb096,stop=0xc544,trace=trace)
    assert r.core.data(0x3d6)==0x84fb and r.core.data(0x6f)&4 and r.core.data(0xffd9)&2
    assert r.core.data(0xbd0)==3
    report['source_activation']={'script':hex(0xc7e7),'startup_samples':6,'mapped_samples_before_activation':0xff0,'activation_entry':hex(0xc52e),'source_callback':hex(r.core.data(0x3d6)),'host_queue_word':r.core.data(0xbd0),'qualification':'Original scheduler reaches source activation after its countdown; prefetched ring input bypasses external source queues.'}
   results.append({'peer_limit':peer,'local_mask':mask,'mode':mode,'flags':flag,'record':record,'selected_index':selected,'amplitude_bits':expected_b,'sign_bits':6,'radices':sizes,'startup_samples':startup,'data_frames':32,'record_crc':crc})
   r.core.close()
 report['checks']['record_to_rate_banks_and_data']=len(results);report['checks']['continuous_data_frame_inverses']=32*len(results);report['checks']['continuous_data_samples']=sample_count
 report['selection_rule']='For tested PCM TX direction: selected_index = bit_length(local_mask_ff39 & ((1 << peer_limit) - 1)), peer_limit = (received_word_0 >> 2) & 15. Builder index = selected_index - 1.'
 report['receive_format']='Tested mode 039F=8040, bit 7 clear: at least 17 one bits then zero; four LSB-first 16-bit words, each followed by zero; 16 LSB-first CRC bits. CRC starts FFFF, reflected polynomial 8408, no final XOR.'
 report['profiles']=results;report['selection_examples']=selection
 (OUT/'verification.json').write_text(json.dumps(report,indent=2)+'\n');(OUT/'57333-trace.json').write_text(json.dumps(events,indent=2)+'\n');print(json.dumps({'checks':report['checks'],'output':str(OUT)},indent=2))
if __name__=='__main__':main()
