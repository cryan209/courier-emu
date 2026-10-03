#!/usr/bin/env python3
"""Probe six-position Quad mapper at stock-controller-verified source offsets.
See verify_quad_pcm_placement.py for independent byte placement evidence.
Component checks do not establish a complete x2 connection.
"""
import ctypes, json, random, struct, subprocess, tempfile
from pathlib import Path
import sys
ROOT=Path(__file__).resolve().parents[1];sys.path.insert(0,str(ROOT))
from courier_emu.quad_image import QuadImage
from courier_emu.dsp import NativeC5x
from tools.probe_quad_pcm_codewords import RESIDENT,PCM_CORE,PCM_MODE
from tools.recover_x2_server import listing
OUT=ROOT/'artifacts/x2-mapper-negotiation-20261004'
def main():
 OUT.mkdir(exist_ok=True);q=QuadImage.controller(ROOT/'docs/x2/Qf060003.zip');w=[0]*65536
 for o,n,pc in (RESIDENT,PCM_CORE,PCM_MODE):
  payload=q.data[o:o+n]
  w[pc:pc+len(payload)//2]=struct.unpack(f'<{len(payload)//2}H',payload)
 (OUT/'mapper-alignment.asm').write_text('; Source offsets verified against stock controller RAM copies\n'+listing(w,0xab06,0xab2e)+listing(w,0xc6e5,0xc789)+listing(w,0xc840,0xc9f7))
 report={'profile':'QF060003','alignment_status':'stock controller RAM source copies verified by verify_quad_pcm_placement.py','checks':{}}
 with tempfile.TemporaryDirectory() as tmp:
  lib=Path(tmp)/'mapper.dylib';subprocess.run(['clang','-shared','-fPIC','-Wall','-Wextra','-Werror',str(OUT/'mapper_lift.c'),'-o',str(lib)],check=True);lift=ctypes.CDLL(str(lib))
  d=(ctypes.c_uint16*65536)()
  o,n,pc=RESIDENT
  with NativeC5x.from_program(pc,q.data[o:o+n]) as c:
   for o,n,pc in (PCM_CORE,PCM_MODE):c.load_program(q.data[o:o+n],pc)
   def put(a,v):d[a]=v;c.set_data(a,v)
   def invoke(entry,acc=0,ar1=0x4bb,stop=None,tc=False):
    driver=[0xbc07,0x8b89,0xbf80,acc,0xbf09,ar1,0xbe4b if tc else 0xbe4a,0x7a80,entry,0x8b00]
    c.load_program(struct.pack('<10H',*driver),0x7000);c.set_pc(0x7000)
    for _ in range(3000):
     if c.state()['pc']==(0x7009 if stop is None else stop):return c.state()['acc']&65535
     c.step(1)
    raise AssertionError(c.state())
   def compare(addrs):
    for a in addrs:assert c.data(a)==d[a],(hex(a),hex(c.data(a)),hex(d[a]))
   rng=random.Random(0xc6e5)
   for mask in range(4096):
    assert invoke(0xc6e5,mask)==lift.mapper_active_positions(ctypes.c_uint16(mask))
    put(0x3fc,rng.getrandbits(16));put(0x3ff,mask)
    lift.mapper_distribute_sizes(d,ctypes.c_uint16(0x4bb));invoke(0xc6f4)
    compare([0x3fd,0x3fe,0x3ff,*range(0x4b6,0x4bc)])
   report['checks']['six_position_count']=4096;report['checks']['size_distribution']=4096
   for _ in range(192):
    put(0x3c2,sum(rng.randrange(4)<<(2*i) for i in range(6)));put(0x3dc,3);put(0x3dd,4)
    for a in range(0x500,0xa10):put(a,0)
    for a in range(0xe8f4,0xeb80):put(a,0)
    for i in range(10):put(0xa60+i,rng.getrandbits(16));put(0x880+i,rng.getrandbits(16))
    lift.mapper_expand_descriptors(d);invoke(0xc92a)
    compare([*range(0xebed,0xebf3),*range(0xe8f4,0xe8fa),*range(0x500,0xa10),*range(0xe8f4,0xeb80)])
   report['checks']['six_descriptor_expansion']=192
   program=(ctypes.c_uint16*65536)(*w)
   for _ in range(512):
    put(0x340,rng.getrandbits(16));put(0xffd9,rng.getrandbits(16))
    put(0xe8f1,rng.getrandbits(16));put(0xe8f2,rng.getrandbits(16))
    lift.mapper_unpack_parameters(program,d);invoke(0xc870,stop=0xc8ab)
    compare([0x3ed,0x3e4,0x3ee,0x3ef,0x3c2,0x3c3,0x3c4])
   report['checks']['negotiated_parameter_unpacking']=512
   for _ in range(512):
    for a in (0xff48,0xff49,0xff4a,0xff4b,0x3c0):put(a,rng.getrandbits(16))
    lift.mapper_receive_parameters(d);invoke(0xab06,stop=0xab2e,tc=True)
    compare([0x340,0x341,0xe8f1,0xe8f2])
   report['checks']['received_parameter_transfer']=512
   for mask in range(4096):
    for a in (0xff48,0xff49,0xff4a,0xff4b,0x3c0,0xffd9):put(a,rng.getrandbits(16))
    record=sum(((0,1,2,5)[(mask>>(2*i))&3] | (8 if rng.randrange(2) else 0))<<(4*i) for i in range(6))
    put(0xff4a,record&65535);put(0xff4b,(d[0xff4b]&0xff00)|(record>>16))
    put(0x3dc,3);put(0x3dd,4)
    for a in range(0xe8f4,0xeb80):put(a,0)
    for i in range(10):put(0xa60+i,rng.getrandbits(16));put(0x880+i,rng.getrandbits(16))
    lift.mapper_receive_parameters(d);invoke(0xab06,stop=0xab2e,tc=True)
    lift.mapper_unpack_parameters(program,d);invoke(0xc870,stop=0xc8ab)
    lift.mapper_expand_descriptors(d);invoke(0xc92a)
    compare([*range(0xebed,0xebf3),*range(0xe8f4,0xeb80),0x3c2,0x3c3,0x3c4])
   report['checks']['received_record_to_six_banks']=4096
   # Execute the unmodified startup caller, constructor, level conversion and
   # expansion together. Candidate 2 and unused tenth entries are preseeded;
   # assertions cover codeword preservation, sizes and final bank selection,
   # not a manual reconstruction of the intervening compander.
   for case in range(128):
    mask=rng.randrange(4096);flag=4 if case&1 else 0
    put(0x3c2,mask);put(0xffd9,flag)
    for a,v in ((0x3ee,0x2000),(0x3ec,0),(0x3fb,0),(0x3eb,0)):put(a,v)
    for i in range(9):put(0xeccf+i,i);put(0xedce+i,rng.randrange(1,32768))
    for a in (*range(0x880,0x88a),*range(0xa60,0xa6a)):put(a,0)
    driver=[0xbc07,0xbf0a,0xedce,0x8b89,0xbe4a,0x7a80,0xc840,0x8b00]
    c.load_program(struct.pack('<8H',*driver),0x7000);c.set_pc(0x7000)
    for steps in range(3000):
     if c.state()['pc']==0xc4ab:break
     c.step(1)
    else:raise AssertionError(c.state())
    for i in range(9):assert (c.data(0xa60+i)&255)==w[(0xc9d7 if flag else 0xc9ce)+i]
    assert all(c.data(a)==9 for a in range(0x4b6,0x4bc))
    assert c.data(0x3dc)==c.data(0x3dd)==9
    for i in range(6):
     field=(mask>>(2*i))&3;src=0x880 if field else 0xa60
     for j in range(10):assert c.data(0xe8f4+i*128+j)==(c.data(src+j)|(0x100 if field&1 else 0))
   report['checks']['startup_constructor_and_consumers']=128
   report['startup_check_scope']='Unmodified C840 through C4AB; seeded second candidate and tenth entries; checks table bytes, sizes, and bank selection, not independent compander semantics.'
   report['position_decode_table']=[w[0xc9ef+i] for i in range(8)]
   report['tables']={str(flag):[hex(w[(0xc9d7 if flag else 0xc9ce)+i]) for i in range(9)] for flag in (0,4)}
 report['total_cases']=sum(report['checks'].values());(OUT/'verification.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report,indent=2))
if __name__=='__main__':main()
