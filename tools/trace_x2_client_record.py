#!/usr/bin/env python3
"""Check original pre-V.90 and later client PCM report packers.

The diagnostic probe starts at the bitmap summarizer with seeded measurements.
The separate negotiation probe executes the measurement/host-limit intersection.
Neither claims analogue acquisition or a complete peer record exchange.
"""
import json, random, struct, sys
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT))
from courier_emu.xmf import XmfImage
from courier_emu.dsp import NativeC5x
OUT=ROOT/'artifacts/x2-client-record-20261004'
PROFILES=[('v211','docs/3453Bv2.1.1/3453Bv2.1.1.xmf',0xde1d,0xde6c,0xd26b,0xf7c0,0xf7c4,0xf7c6,0xffe8),
          ('v2333','docs/3453C_v2.3.33/2_3_33.XMF',0x5ec3,0x5f12,0x526b,0x77be,0x77c2,0x77c4,0x7fe8)]

def invoke(core,entry,stop,dp=7,limit=10000):
    core.load_program(struct.pack('<9H',0xbc00|dp,0x8b89,0xbe47,0xbe42,0xbe4a,0xbf01,0x7a80,entry,0x8b00),0x7b00)
    core.set_pc(0x7b00)
    for steps in range(limit):
        if core.state()['pc']==stop:return steps
        core.step(1)
    raise AssertionError(core.state())

def main():
    OUT.mkdir(exist_ok=True);rng=random.Random(0xde1d);report={'qualification':'Seeded measurement bitmaps and local parameters; original diagnostic report summarizer and packer, separate peer-record rate intersection. No analogue acquisition or peer exchange.','profiles':[]}
    for name,path,entry,stop,base,dest,source,rate,flags in PROFILES:
        im=XmfImage.load(ROOT/path);segments=im.dsp_segments();resident=next(s for s in segments if s.resident);pcm=next(s for s in segments if s.index==8)
        examples=[]
        with NativeC5x.from_program(resident.origin,im.data[resident.file_offset:resident.end]) as core:
            core.load_program(im.data[pcm.file_offset:pcm.end],pcm.origin)
            for case in range(512):
                # The six windows are reached by advancing eight words before
                # each 32-bit read. Include the exact popcount boundary.
                counts=[(case+i)%33 for i in range(6)] if case<33 else [rng.randrange(33) for _ in range(6)]
                maps=[]
                for i,n in enumerate(counts):
                    positions=rng.sample(range(32),n);bitmap=sum(1<<b for b in positions);maps.append(bitmap)
                    core.set_data(base+8*(i+1),bitmap>>16);core.set_data(base+8*(i+1)+1,bitmap&65535)
                f=rng.randrange(65536);mode=rng.randrange(8);r=rng.randrange(32);initial=rng.randrange(2);aux=rng.randrange(65536);low=rng.randrange(65536);local=rng.randrange(2)
                for a,v in [(0x3fb,1),(0x3e4,mode),(flags,f),(0x361,local),(dest,initial),(dest+1,low),(source,aux),(rate,r)]:core.set_data(a,v)
                steps=invoke(core,entry,stop)
                below=sum(n<20 for n in counts)
                expected0=initial|((below<<1)&14)|((mode<<10)&0x1c00)|((r<<5)&0x3e0)|(0x4000 if f&1 else 0)|(0x2000 if local else 0)|(0x10 if f&0x100 else 0)
                expected1=(low&63)|((aux<<6)&0xffc0)
                actual=[core.data(dest),core.data(dest+1)]
                assert actual==[expected0,expected1],(name,case,counts,hex(f),local,actual,[expected0,expected1],core.state())
                if case<4 or case==19:examples.append({'popcounts':counts,'below_twenty':below,'mode':mode,'rate_field':r,'flags':f,'local_0361':local,'source_aux':aux,'initial_first':initial,'initial_second':low,'packed_words':actual,'steps':steps})
        report['profiles'].append({'name':name,'image':path,'sha256':im.digest,'entry':hex(entry),'stop':hex(stop),'bitmap_base':hex(base),'destination':hex(dest),'cases':512,'examples':examples})
    im=XmfImage.load(ROOT/PROFILES[1][1]);segments=im.dsp_segments();resident=next(s for s in segments if s.resident);pcm=next(s for s in segments if s.index==8)
    rate_profiles=[];cases=0
    for name,path,entry,stop,base,dest,source,rate,flags in PROFILES:
        image=XmfImage.load(ROOT/path);ss=image.dsp_segments();res=next(s for s in ss if s.resident);pcm=next(s for s in ss if s.index==8)
        start,end,mask,host,word,roleword=(0xe773,0xe7a3,0xd2a0,0xf7c9,0xfcd0,0xffe9) if name=='v211' else (0x6818,0x6848,0x52a0,0x77c7,0x7cce,0x7fe9)
        examples=[]
        with NativeC5x.from_program(res.origin,image.data[res.file_offset:res.end]) as core:
            core.load_program(image.data[pcm.file_offset:pcm.end],pcm.origin)
            for role in (0,1):
                for offset in range(8):
                    for limit in range(1,32):
                        measurement=rng.randrange(1<<31);hostmask=rng.randrange(1<<31);initial=rng.randrange(65536)
                        for a,v in [(0x3fb,1),(0x364,offset),(roleword,role<<5),(0x37d,limit+20-offset),(mask,measurement&65535),(mask+1,measurement>>16),(host,hostmask>>16),(host+1,hostmask&65535),(word,initial)]:core.set_data(a,v)
                        invoke(core,start,end,dp=6)
                        eligible=measurement&hostmask&((1<<limit)-1);selected=eligible.bit_length()
                        expected=(initial&(0x7007 if role else 0x7003))|(selected<<(3 if role else 2))
                        actual=core.data(word)
                        assert actual==expected and core.data(0x31c)==selected,(name,role,offset,limit,hex(eligible),actual,expected,core.data(0x31c))
                        cases+=1
                        if len(examples)<6:examples.append({'role_bit_5':role,'offset_0364':offset,'limit':limit,'measurement_mask':measurement,'host_mask':hostmask,'eligible':eligible,'selected':selected,'packed_first_word':actual})
        rate_profiles.append({'profile':name,'entry':hex(start),'stop':hex(end),'cases':496,'working_word':hex(word),'measurement_mask_low':hex(mask),'host_mask_high':hex(host),'examples':examples})
    report['peer_record_rate_intersection']={'cases':cases,'profiles':rate_profiles}
    im=XmfImage.load(ROOT/PROFILES[1][1]);segments=im.dsp_segments();resident=next(s for s in segments if s.resident)
    # Execute the original bit-source state machine, before analogue waveform
    # modulation. Loading all live overlays is essential: 2E3A belongs to 6.
    from tools.trace_x2_rate_handoff import encode_record
    from tools.recover_x2_payload import Runner
    wire_examples=[]
    with NativeC5x.from_program(resident.origin,im.data[resident.file_offset:resident.end]) as core:
        for s in segments:
            if not s.resident:core.load_program(im.data[s.file_offset:s.end],s.origin)
        for case in range(64):
            words=[rng.getrandbits(16) for _ in range(4)]
            words[0]&=0x7ffe
            for a,v in [(0x3fb,1),(0x39f,0x4000),(0x33d,0x7cce),(0x3c9,4),(0x3d4,17),(0x3d6,0x2e3a)]:core.set_data(a,v)
            for i,v in enumerate(words):core.set_data(0x7cce+i,v)
            expected,crc=encode_record(words);actual=[]
            for bit in expected:
                invoke(core,core.data(0x3d6),0x7b08)
                actual.append((core.state()['accb']>>31)&1)
            assert actual==expected,(case,actual,expected)
            assert core.data(0x3d6)==0x2e80
            # Feed generated bits through the original server bit dispatcher,
            # rather than copying the working parameters across firmware.
            server=Runner();server.put({0x39f:0x8040,0x323:0,0x325:0,0x3fb:1})
            from tools.trace_x2_rate_handoff import invoke as server_invoke
            server_invoke(server,0xaaa4,dp=6);accepted=False
            for bit in actual:
                server.put({0x322:1,0x320:bit});accepted=server_invoke(server,0xa9ea,dp=6,stop=0xab2e)
            assert accepted and [server.core.data(a) for a in (0x340,0x341,0xe8f1,0xe8f2)]==words
            server.core.close()
            if case<3:wire_examples.append({'words':words,'crc':crc,'bits':actual})
    report['client_serializer_to_server_receiver']={'cases':64,'client_entry':'0x2e3a','client_buffer':'0x7cce','server_receiver':'0xaaa4 / 0xa9ea','body_words':4,'bits':102,'qualification':'Unmodified client serializer and server receiver; four-word source bodies and message length are seeded. This does not prove client call-state selection or constellation-record production.','examples':wire_examples}
    # The same machinery exists before V.90. Verify the original serializer
    # independently, including its variable-length body and CRC continuation.
    old=XmfImage.load(ROOT/PROFILES[0][1]);oldsegments=old.dsp_segments();oldresident=next(s for s in oldsegments if s.resident)
    oldcases=0
    with NativeC5x.from_program(oldresident.origin,old.data[oldresident.file_offset:oldresident.end]) as core:
        for s in oldsegments:
            if not s.resident:core.load_program(old.data[s.file_offset:s.end],s.origin)
        for count in (1,2,4,6,7,9):
            for case in range(16):
                words=[rng.getrandbits(16) for _ in range(count)]
                for a,v in [(0x3fb,1),(0x39f,0x4000),(0x33d,0xfcd0),(0x3c9,count),(0x3d4,17),(0x3d6,0xade2)]:core.set_data(a,v)
                for i,v in enumerate(words):core.set_data(0xfcd0+i,v)
                expected,crc=encode_record(words);actual=[]
                for bit in expected:
                    invoke(core,core.data(0x3d6),0x7b08)
                    actual.append((core.state()['accb']>>31)&1)
                assert actual==expected,(count,case,actual,expected)
                oldcases+=1
    report['pre_v90_serializer']={'entry':'0xade2','buffer':'0xfcd0','cases':oldcases,'word_counts':[1,2,4,6,7,9],'qualification':'Original 3453B 2.1.1 serializer with seeded source bodies and lengths; confirms framing predates V.90, not selection of any length during an actual call.'}
    # Execute the position-bank report constructor in both images.
    # Each input contains six eight-word groups; equality classes are varied.
    constructors=[]
    for name,image,segments,entry,base,dest,work,length in [('v211',old,oldsegments,0xf16b,0xcdb3,0xfcd0,0xfcd6,0xce9f),('v2333',im,segments,0x720a,0x4db3,0x7cce,0x7cd4,0x4e9f)]:
        resident=next(s for s in segments if s.resident);records=[]
        with NativeC5x.from_program(resident.origin,image.data[resident.file_offset:resident.end]) as core:
            for s in segments:
                if not s.resident:core.load_program(image.data[s.file_offset:s.end],s.origin)
            for case in range(76):
                pattern=random.Random(0x720a+case)
                groups=[[pattern.getrandbits(16) for _ in range(8)] for _ in range(6)]
                if case<32:
                    for i in range(6):groups[i]=groups[(case>>i)% (i+1)]
                other=[g[:] for g in groups]
                if case&1:other[case%6][case%8]^=1
                if case>=64:
                    n=(case-64)//2+1
                    groups=[[100*(i%n)+k for k in range(8)] for i in range(6)]
                    other=[[v+(case&1) for v in g] for g in groups]
                for i,v in enumerate(sum(groups,[])):core.set_data(base+i,v)
                for i,v in enumerate(sum(other,[])):core.set_data(base+48+i,v)
                headers=[0x1234,0x2345,0x3456,0x4567,0x5678]
                for i,v in enumerate(headers):core.set_data(dest+i,v)
                core.set_data(work+1,0)
                invoke(core,entry,0x7b08,limit=50000)
                classes=[];labels=[]
                for a,b in zip(groups,other):
                    pair=(tuple(a),tuple(b))
                    if pair not in classes:classes.append(pair)
                    labels.append(classes.index(pair))
                different=groups!=other;n=len(classes)
                packed0=sum(labels[i]<<(4*i) for i in range(4))
                packed1=labels[4]|(labels[5]<<4)|(int(different)<<8)
                expected_words=headers+[packed0,packed1]
                expected_words+=sum((list(a) for a,b in classes),[])
                if different:expected_words+=sum((list(b) for a,b in classes),[])
                assert [core.data(dest+i) for i in range(len(expected_words))]==expected_words,(name,case,labels,[core.data(dest+i) for i in range(len(expected_words))],expected_words)
                assert core.data(length)==len(expected_words)
                assert [core.data(base-7+i) for i in range(7)]==[core.data(dest+i) for i in range(7)]
                records.append({'preserved_header_words':headers,'position_labels':labels,'distinct_classes':n,'second_matrix':different,'packed_positions':[core.data(work-1),core.data(work)],'parameter_length':core.data(length),'second_matrix_words':core.data(0x7d)})
                # The original initializer consumes the constructor's count
                # and installs the source pointer, callbacks and preamble.
                serializer=0xade2 if name=='v211' else 0x2e3a
                for a,v in [(0x3fb,1),(0x39f,0x4000),(0x3df,1)]:core.set_data(a,v)
                setup,callback=(0xc5e8,0xc615) if name=='v211' else (0x4650,0x467d)
                # Older overlay 7 overlaps the upper part of overlay 6.
                # Restore the actual initializer's owner before executing it.
                owner=next(s for s in segments if s.index==6)
                core.load_program(image.data[owner.file_offset:owner.end],owner.origin)
                invoke(core,setup,callback)
                assert core.data(0x33d)==dest and core.data(0x3c9)==len(expected_words),(name,case,hex(core.data(0x33d)),hex(dest),core.data(0x3c9),len(expected_words),core.data(length),core.state())
                assert core.data(0x3d6)==serializer and core.data(0x3d4)==17 and core.data(0x3c8)==callback
                expected_bits,_=encode_record(expected_words);actual_bits=[]
                for bit in expected_bits:
                    invoke(core,core.data(0x3d6),0x7b08)
                    actual_bits.append((core.state()['accb']>>31)&1)
                assert actual_bits==expected_bits,(name,case,'constructed report serialization')
        constructors.append({'profile':name,'entry':hex(entry),'cases':76,'examples':records[:8]+records[-12:]})
        if name=='v211':oldrecords=records
        else:assert records==oldrecords
    report['position_report_constructor']={'profiles':constructors,'cross_version_equal_cases':76,'constructed_records_serialized':152,'native_initializers':['0xc5e8','0x4650'],'qualification':'Seeded six groups of eight measurement words and a second comparison matrix. Existing five header words are preserved; packed controls are written at offsets five and six, followed by selected bitmap blocks. The final seven-word BLDD copies the message buffer back into scratch, not scratch into the message. Original initializers install the source pointer, returned length, preamble and callbacks before each original serializer executes. This variable-length record is not asserted to be the Quad four-word negotiation body; analogue acquisition and complete call scheduling remain open.'}
    (OUT/'packer-verification.json').write_text(json.dumps(report,indent=2)+'\n')
    print(json.dumps({'diagnostic_packer_cases':1024,'peer_record_rate_cases':cases,'client_serializer_to_server_receiver':64,'output':str(OUT)},indent=2))
if __name__=='__main__':main()
