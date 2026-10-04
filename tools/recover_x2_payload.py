#!/usr/bin/env python3
"""Recover and compare QF060003 six-position payload mapping against DSP.
Seeded negotiated constellations; does not assert an established x2 call.
"""
from pathlib import Path
import ctypes, json, random, struct, sys, subprocess, tempfile
ROOT=Path(__file__).resolve().parents[1];sys.path.insert(0,str(ROOT))
from courier_emu.quad_image import QuadImage
from courier_emu.dsp import NativeC5x
from tools.probe_quad_pcm_codewords import RESIDENT,PCM_CORE,PCM_MODE
OUT=ROOT/'artifacts/x2-payload-mapper-20261004'

def window(d,cursor):
 i=(cursor>>4)&7
 return (((d[0x248+((i+1)&7)]<<16)|d[0x248+i])>>(cursor&15))&0xffffffff

def take(d,n):
 cursor=d[0x3af];value=window(d,cursor)
 d[0x3af]=(cursor+n)&127
 return value

def take_long(d,n):
 if n<=16:return take(d,n)
 lo=take(d,16)&65535;hi=take(d,n-16)&65535
 return (hi<<16)|lo

def unpack_frame(d):
 # C5DF through C641. MD signs precede B amplitude bits in the ring.
 d[0x3e3]=take(d,d[0x3ed])&65535
 bits=d[0x3c0];n=min(bits,32)
 low=take_long(d,n)&((1<<n)-1 if n else 0)
 high=take(d,bits-n)&((1<<(bits-n))-1 if bits-n else 0)
 value=(high<<32)|low
 for i in range(6):
  divisor=d[0x4bb-i];value,digit=divmod(value,divisor)
  entry=d[0xe8f4+128*i+digit]
  d[0x4c1-i]=entry&255;d[0x4c7-i]=(entry&0x7f00)>>8
  d[0x4cd-i]=((digit<<8) if d[0x39f]&128 else (entry&0x7f00))|(5-i)
 d[0x3e0]=(value>>32)&65535;d[0x3e1]=(value>>16)&65535;d[0x3e2]=value&65535
 d[0x3c3]=d[0x3c2]

def s16(x):return x-65536 if x&32768 else x

def apply_signs(d):
 # C64F through C6E4: differential independent signs, rank selection,
 # exhaustive DC-disparity minimization, then low-octet sign toggles.
 md=d[0x3ed];raw=d[0x3e3];signs=0
 for i in range(md):
  bit=raw&1;raw=(raw>>1)|(bit<<15)
  d[0x3da]^=bit<<15
  signs|=((d[0x3da]>>15)&1)<<i
 if md:d[0x3e3]=signs
 if md==6:
  ranks=list(range(6));free_mask=0
 else:
  keys=[d[0x4cd-i] for i in range(6)]
  ranks=[sum(key>k for key in keys) for k in keys]
  for i,r in enumerate(ranks):d[0x4c1-i]+=r<<8
  fixed_sum=s16(d[0x4d2])*8;free=[];pending=signs
  for i,r in enumerate(ranks):
   level=s16(d[0xed4f+d[0x4c7-i]])
   if r<md:
    fixed_sum+= -level if pending&1 else level;pending>>=1
   else:
    d[0x4cd-len(free)]=level&65535;free.append(level)
  free_mask=0;best=0x3fff8000
  for mask in range((1<<len(free))-1,-1,-1):
   score=abs(fixed_sum+sum(-v if mask&(1<<j) else v for j,v in enumerate(free)))
   if score<best:best=score;free_mask=mask
 # Original final stage consumes the independent and free streams separately.
 pending=d[0x3e3]
 for i,r in enumerate(ranks):
  if r<md:bit=pending&1;pending>>=1
  else:bit=free_mask&1;free_mask>>=1
  d[0x4c1-i]=(d[0x4c1-i]^(bit<<7))&255
 d[0x3e3]=pending

class Runner:
 def __init__(self):
  q=QuadImage.controller(ROOT/'docs/x2/Qf060003.zip');o,n,pc=RESIDENT
  self.core=NativeC5x.from_program(pc,q.data[o:o+n])
  for o,n,pc in (PCM_CORE,PCM_MODE):self.core.load_program(q.data[o:o+n],pc)
 def put(self,d):
  for a,v in d.items():self.core.set_data(a,v)
 def run(self,entry,stop=None,acc=None,spm=0):
  driver=[0xbc07,0x8b89,0xbe47,0xbe42,0xbe4a,0xbf00|spm]
  if acc is not None:driver += [0xbf80,acc]
  driver += [0x7a80,entry,0x8b00]
  self.core.load_program(struct.pack(f'<{len(driver)}H',*driver),0x7000);self.core.set_pc(0x7000)
  for steps in range(40000):
   if self.core.state()['pc']==(0x7000+len(driver)-1 if stop is None else stop):return steps
   self.core.step(1)
  raise AssertionError(self.core.state())
 def compare(self,d,addrs):
  for a in addrs:
   actual=self.core.data(a)
   if actual!=d[a]:raise AssertionError((hex(a),hex(actual),hex(d[a]),self.core.state()))

def main():
 OUT.mkdir(exist_ok=True);tmp=tempfile.TemporaryDirectory();lib=Path(tmp.name)/'payload.dylib'
 subprocess.run(['clang','-shared','-fPIC','-Wall','-Wextra','-Werror',str(OUT/'payload_lift.c'),'-o',str(lib)],check=True)
 lift=ctypes.CDLL(str(lib));data=(ctypes.c_uint16*65536)()
 def load(d):
  for a,v in d.items():data[a]=v
 def check_lift(d,fn,addrs):
  getattr(lift,fn)(data)
  for a in addrs:assert data[a]==d[a],(fn,hex(a),hex(data[a]),hex(d[a]))
 rng=random.Random(0xc5df);r=Runner();report={'profile':'QF060003','builder_product_scaling_mode':1,'checks':{}}
 for case in range(512):
  d={0x3ed:rng.randrange(7),0x3c0:rng.randrange(1,43),0x3af:rng.randrange(128),0x3c2:rng.getrandbits(12),0x39f:0,0x3fb:1}
  for a in range(0x248,0x250):d[a]=rng.getrandbits(16)
  for i in range(6):
   d[0x4bb-i]=rng.randrange(2,128)
   for j in range(128):d[0xe8f4+128*i+j]=rng.getrandbits(16)
  r.put(d);load(d);unpack_frame(d);check_lift(d,'payload_unpack',[0x3af,0x3e3,0x3e0,0x3e1,0x3e2,0x3c3,*range(0x4bc,0x4ce)]);r.run(0xc5df)
  r.compare(d,[0x3af,0x3e3,0x3e0,0x3e1,0x3e2,0x3c3,*range(0x4bc,0x4ce)])
 report['checks']['amplitude_unpacking']=512
 for case in range(1024):
  d={0x3ed:case%7,0x3e3:rng.getrandbits(16),0x3da:rng.getrandbits(16),0x3fb:1,0x39f:0,0x4d2:rng.getrandbits(16)}
  for i in range(6):
   d[0x4c1-i]=rng.randrange(256);idx=rng.randrange(128)
   d[0x4c7-i]=idx;d[0x4cd-i]=(idx<<8)|(5-i)
  for a in range(0xed4f,0xedcf):d[a]=rng.randrange(1,32768)
  original=d.copy();r.put(d);load(d);apply_signs(d);check_lift(d,'payload_signs',[0x3e3,0x3da,*range(0x4bc,0x4c2)]);r.run(0xc642)
  try:r.compare(d,[0x3e3,0x3da,*range(0x4bc,0x4c2)])
  except AssertionError:
   (OUT/'failure.json').write_text(json.dumps({'case':case,'input':original,'expected':d,'actual':{a:r.core.data(a) for a in [0x3e3,0x3da,*range(0x4bc,0x4d3)]}},indent=2));raise
 report['checks']['differential_signs_and_dc_search']=1024
 for case in range(1024):
  n=1+case%8
  d={0x6f:(case//8)&1,0x3d0:rng.getrandbits(8),0x3d1:(1<<n)-1,0x3d2:n,0x3d8:rng.getrandbits(16),0x3d9:rng.getrandbits(16),0x3ae:case%128}
  for a in range(0x248,0x250):d[a]=rng.getrandbits(16)
  r.put(d);load(d);lift.payload_append(data);r.run(0xb2ba)
  r.compare({a:data[a] for a in d},[0x3d0,0x3d8,0x3d9,0x3ae,*range(0x248,0x250)])
 report['checks']['source_scrambler_and_ring_append']=1024
 # These are seeded builder profiles, not captured peer negotiations.
 report['negotiated_profiles']=[];roundtrips=0
 for rate in range(1,16):
  for flag in (0,1):
   r.core.close();r=Runner()
   # Full unmodified builder after the rate resolver has supplied its index.
   seed={0x340:0,0xe8f1:0,0xe8f2:0x600,0xffd9:flag,0x3fb:1,0x39f:64}
   r.put(seed)
   try:r.run(0xc862,acc=rate,spm=1)
   except AssertionError as e:raise AssertionError(('builder profile',rate,flag)) from e
   template={a:r.core.data(a) for a in [0x3c0,0x3c2,*range(0x4b6,0x4bc),*range(0xed4f,0xedcf),*range(0xe8f4,0xebf4)]}
   sizes=[template[0x4bb-i] for i in range(6)]
   capacity=1
   for size in sizes:capacity*=size
   assert capacity>=1<<template[0x3c0],(rate,flag,sizes,template[0x3c0])
   assert all(len({template[0xe8f4+128*i+j]&127 for j in range(size)})==size for i,size in enumerate(sizes))
   report['negotiated_profiles'].append({'rate_index':rate,'flags':flag,'amplitude_bits':template[0x3c0],'sizes':sizes})
   for case in range(28):
    d=template.copy();d.update({0x3ed:case%7,0x3af:rng.randrange(128),0x3da:rng.getrandbits(16),0x3fb:1,0x39f:64,0x4d2:rng.getrandbits(16)})
    for a in range(0x248,0x250):d[a]=rng.getrandbits(16)
    ring=sum(d[0x248+i]<<(16*i) for i in range(8));cursor=d[0x3af]
    rotated=(ring>>cursor)|((ring&((1<<cursor)-1))<<(128-cursor))
    expected=rotated&((1<<(d[0x3c0]+d[0x3ed]))-1);previous=d[0x3da]
    r.put(d);load(d)
    unpack_frame(d);check_lift(d,'payload_unpack',[0x3af,*range(0x4bc,0x4ce)])
    apply_signs(d);check_lift(d,'payload_signs',[0x3da,*range(0x4bc,0x4c2)])
    r.run(0xc5df);r.run(0xc642)
    r.compare(d,[0x3af,0x3da,*range(0x4bc,0x4c2)])
    octets=(ctypes.c_uint8*6)(*[d[0x4c1-i] for i in range(6)])
    parity=ctypes.c_uint16(previous);decoded=ctypes.c_uint64()
    assert lift.payload_inverse(data,octets,ctypes.byref(parity),ctypes.byref(decoded))==0,(rate,flag,case)
    assert decoded.value==expected,(rate,flag,case,hex(decoded.value),hex(expected))
    assert parity.value==d[0x3da]
    roundtrips+=1
 report['checks']['firmware_constellations_mapping_and_inverse']=roundtrips
 # Continuous original C544 calls exercise frame dispatch, C5DF, C642,
 # C558/C565 and six output steps without manually reseeding intermediates.
 # Original C862 first constructs the actual constellation banks.
 continuous=0
 for rate in range(1,16):
  for flag in (0,1):
   r.core.close();r=Runner()
   r.put({0x340:0,0xe8f1:0,0xe8f2:0x600,0xffd9:flag,0x3fb:1,0x39f:64})
   try:r.run(0xc862,acc=rate,spm=1)
   except AssertionError as e:raise AssertionError(('continuous builder profile',rate,flag)) from e
   template={a:r.core.data(a) for a in [0x3c0,0x3c2,0x3ed,0x3ef,0x3a3,*range(0x4b6,0x4bc),*range(0xed4f,0xedcf),*range(0xe8f4,0xebf4)]}
   for md in range(7):
    d=template.copy();d.update({0x3ed:md,0x3af:0,0x3ae:127,0x3da:rng.getrandbits(16),0x3fb:1,0x39f:64,0x3cc:5,0x3f4:5,0x3ca:6,0x3cb:0xc64b,0x3de:0,0x3df:0,0x3c5:0,0x3c6:0,0xffd9:flag,0xe8e4:0})
    for a in range(0x4ce,0x4d4):d[a]=0
    for a in range(0x248,0x250):d[a]=rng.getrandbits(16)
    r.put(d);load(d);unpack_frame(d);lift.payload_unpack(data);apply_signs(d);lift.payload_signs(data)
    for i in range(6):
     expected=lift.payload_sample(data);r.run(0xc544,spm=1)
     if data[0x273]!=r.core.data(0x273):print('sample context',rate,flag,md,i, 'level',r.core.data(0x3fd),'filtered',r.core.data(0x4d1),'scale',r.core.data(0x3ef),'model',[data[a] for a in (0x3fd,0x4d1,0x3ef)],flush=True)
     r.compare({a:data[a] for a in [0x3a7,0x3af,0x3cc,0x3ca,0x3de,0x3fd,0x273,0x3c5,0x3c6,*range(0x4ce,0x4d4)]},[0x3a7,0x3af,0x3cc,0x3ca,0x3de,0x3fd,0x273,0x3c5,0x3c6,*range(0x4ce,0x4d4)])
     assert expected==r.core.data(0x3a7)
     continuous+=1
 report['checks']['continuous_frame_mapper_output_samples']=continuous
 streams=0;stream_samples=0;stream_bytes=0;examples=[]
 for rate in (10,15):
  for role in (0,1):
   for law in (0,1):
    for md in range(7):
     r.core.close();r=Runner()
     r.put({0x340:0,0xe8f1:0,0xe8f2:0x600,0xffd9:law,0x3fb:1,0x39f:64});r.run(0xc862,acc=rate,spm=1)
     d={a:r.core.data(a) for a in [0x3c0,0x3c2,0x3ed,0x3ef,0x3a3,*range(0x4b6,0x4bc),*range(0xed4f,0xedcf),*range(0xe8f4,0xebf4)]}
     d.update({0x6f:role,0x3ed:md,0x3af:0,0x3ae:0,0x3da:0,0x3fb:1,0x39f:64,0x3cc:5,0x3f4:5,0x3ca:6,0x3cb:0xc64b,0x3de:0,0x3df:0,0x3c5:0,0x3c6:0,0xffd9:law,0xe8e4:0,0x3d8:0,0x3d9:0,0x3d1:255,0x3d2:8})
     for a in range(0x4ce,0x4d4):d[a]=0
     for a in range(0x248,0x250):d[a]=0
     load(d);r.put(d);original=[];recovered=[];pending=0;pending_bits=0;parity=ctypes.c_uint16(0);descrambler_hi=0;descrambler_lo=0
     for frame in range(32):
      # C544 checks availability on every sample call. Keep more than one
      # whole frame after the first call consumes this frame.
      count=data[0x3c0]+md
      while ((data[0x3ae]-data[0x3af])&127)<=2*count:
       byte=rng.randrange(256);original.append(byte);data[0x3d0]=byte;r.core.set_data(0x3d0,byte)
       lift.payload_append(data);r.run(0xb2ba)
       r.compare({a:data[a] for a in [0x3d0,0x3d8,0x3d9,0x3ae,*range(0x248,0x250)]},[0x3d0,0x3d8,0x3d9,0x3ae,*range(0x248,0x250)])
      if data[0x3ca]==0:data[0x3ca]=6
      lift.payload_unpack(data);lift.payload_signs(data)
      emitted=[]
      for i in range(6):
       expected=lift.payload_sample(data);r.run(0xc544,spm=1);assert expected==r.core.data(0x3a7)
       emitted.append(expected);stream_samples+=1
       r.compare({a:data[a] for a in [0x3af,0x3da,0x3cc,0x3ca,0x4d1,0x4d2]},[0x3af,0x3da,0x3cc,0x3ca,0x4d1,0x4d2])
      octets=(ctypes.c_uint8*6)(*[x^data[0x3a3] for x in emitted]);decoded=ctypes.c_uint64()
      assert lift.payload_inverse(data,octets,ctypes.byref(parity),ctypes.byref(decoded))==0
      pending|=decoded.value<<pending_bits;pending_bits+=count
      while pending_bits>=8:
       word=pending&255;pending>>=8;pending_bits-=8
       if role:byte=(word^(word<<5)^(descrambler_hi>>2)^descrambler_lo)&255
       else:byte=(word^(descrambler_lo>>5)^descrambler_lo)&255
       recovered.append(byte)
       history=((((descrambler_hi|(word<<7))&65535)<<16)|descrambler_lo)>>8
       descrambler_hi=history>>16;descrambler_lo=history&65535
      if frame==0 and role==0 and law==0 and md==3:examples.append({'rate_index':rate,'source_octets':original.copy(),'frame_bits':count,'mapped_octets':emitted,'decoded_frame_integer':hex(decoded.value)})
     assert recovered==original[:len(recovered)],(role,law,md)
     assert parity.value==r.core.data(0x3da)
     streams+=1;stream_bytes+=len(recovered)
 report['checks']['continuous_byte_streams']=streams
 report['checks']['continuous_stream_samples']=stream_samples
 report['decoded_source_bytes']=stream_bytes
 report['stream_scope']='32 frames per stream; byte scrambling, ring wrap/refill, original C544 output, ideal inverse and byte descrambling. Preselected rate indices 10 and 15; all MD 0..6, both scrambler role flags and final format XOR states.'
 (OUT/'example.json').write_text(json.dumps(examples,indent=2)+'\n')
 r.core.close();tmp.cleanup();report['total_cases']=sum(report['checks'].values())
 (OUT/'verification.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report,indent=2))
if __name__=='__main__':main()
