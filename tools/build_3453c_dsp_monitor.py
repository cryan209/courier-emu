#!/usr/bin/env python3
"""Build and verify an experimental 3453C 2.3.33 DSP monitor. Never flashes hardware."""
from pathlib import Path
import argparse, hashlib, json, struct, sys
sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from courier_emu.xmf import XmfImage, DSP_CALL_SITE
from courier_emu.dsp import NativeC5x
from tools.c5x_disasm import disassemble
from capstone import Cs, CS_ARCH_X86, CS_MODE_16

BASE_DIGEST='c8d44a1c984a203f6e9a91b14c77382706ea05fc2b860081f986c47b6fa7c41e'
MONITOR=0x75e0
CPU=0x8a000
QUERY=0x8a100
BULK=0x8a200
CACHE=0x3ff00

def pack(words): return struct.pack(f'<{len(words)}H',*words)
def crc(data):
    value=0
    for byte in data:
        value ^= byte
        for _ in range(8):value=(value>>1)^(0x8408 if value&1 else 0)
    return value

class DspAssembler:
    def __init__(self):self.words=[];self.labels={};self.fixups=[]
    def emit(self,*words):self.words.extend(words)
    def label(self,name):self.labels[name]=MONITOR+len(self.words)
    def branch(self,name,opcode=0x7980):self.fixups.append((len(self.words)+1,name));self.emit(opcode,0)
    def finish(self):
        for offset,name in self.fixups:self.words[offset]=self.labels[name]
        return self.words

class X86Assembler:
    def __init__(self,base):self.base=base;self.code=bytearray();self.labels={};self.fixups=[]
    def emit(self,data):self.code.extend(bytes.fromhex(data) if isinstance(data,str) else data)
    def label(self,name):self.labels[name]=self.base+len(self.code)
    def branch(self,name,opcode):
        self.emit(opcode);self.fixups.append((len(self.code),name,1));self.emit(b'\0')
    def long_branch(self,name,opcode):
        self.emit(bytes([int(opcode,16)^1,3,0xe9]))
        self.fixups.append((len(self.code),name,2));self.emit(b'\0\0')
    def finish(self):
        for offset,name,width in self.fixups:
            disp=self.labels[name]-(self.base+offset+width)
            if width==1 and not -128<=disp<=127:raise ValueError(f'short branch overflow: {name}')
            self.code[offset:offset+width]=(disp&((1<<(8*width))-1)).to_bytes(width,'little')
        return bytes(self.code)
    def string(self,text):self.emit('9ac30f4d7a');self.emit(text.encode()+b'\0')

def dsp_code():
    a=DspAssembler()
    # The hook runs with DP=0, ARP=1. Exact matching prevents high-tag aliases.
    a.emit(0x697d,0xbfa0,0x0088);a.branch('identify',0xe388)
    a.emit(0x697d,0xbfa0,0x0089);a.branch('data',0xe388)
    a.emit(0x697d,0xbfa0,0x008a);a.branch('program',0xe388)
    a.emit(0x697d,0xbfa0,0x008b);a.branch('rom',0xe388)
    a.emit(0x697d,0xbfa0,0x008c);a.branch('pmst',0xe388)
    a.emit(0x697d,0xba87,0x7980,0x12c2) # original stock comparison
    a.label('identify');a.emit(0xae7b,0xd541,0xbf80,0x8070);a.branch('reply')
    a.label('data')
    a.emit(0x697a,0xbfa0,0x0100);a.branch('range',0xe3c4) # lt
    a.emit(0x697a,0xbfa0,0x03ff);a.branch('range',0xe304) # gt
    a.emit(0x017a,0x6980,0x907b,0xbf80,0x8071);a.branch('reply')
    a.label('program')
    # Bit test avoids dependence on SXM when rejecting 8000..FFFF.
    a.emit(0x407a);a.branch('range',0xe100) # bit15, branch TC
    a.emit(0x697a,0xa67b,0xbf80,0x8072);a.branch('reply')
    a.label('pmst');a.emit(0x0807,0x907b,0xbf80,0x8071);a.branch('reply')
    a.label('rom')
    a.emit(0x697a,0xbfa0,0x1fff);a.branch('range',0xe304)
    # Mask interrupts before mapping ROM. Save the complete PMST on the
    # hardware stack, clear only MP/MC, table-read from code above the ROM
    # window, then restore PMST before restoring the original interrupt mask.
    a.emit(0x8e7c,0x8f7e,0xbe41,0x7607,0x5e07,0xfff7,
           0x697a,0xa67b,0x8a07,0x467c)
    a.branch('rommasked',0xe100);a.emit(0xbe40)
    a.label('rommasked');a.emit(0x0f7e,0x0e7c,0xbf80,0x8072)
    a.branch('reply')
    a.label('range');a.emit(0xae7b,0x0001,0xbf80,0x8073)
    a.label('reply')
    # Clear TC first: 12C8 sets TC=1 only after it queues the tag.
    # Dispatcher is normally called in a masked interrupt context. Keep the
    # two-word reply atomic against a sender interrupt; restore INTM explicitly
    # from SST ST0 bit 9 (LST does not restore INTM), then restore ST1.
    a.emit(0x8e7c,0x8f7e,0xbe41,0xbe4a,0x7a80,0x12c8);a.branch('done',0xe200)
    a.emit(0x697b,0x7a80,0x12d3)
    a.label('done');a.emit(0x467c);a.branch('masked',0xe100);a.emit(0xbe40)
    a.label('masked');a.emit(0x0f7e,0x0e7c,0xef00)
    words=a.finish()
    # Both hardware transfer loops send groups of four words.
    words.extend([0x8b00]*((-len(words))%4))
    return words

def cpu_code():
    a=X86Assembler(CPU)
    a.emit('55 8bec 9c 60 06') # BP anchors the original far return IP
    a.emit('83f870');a.branch('stock','72')
    a.emit('83f873');a.branch('stock','77')
    a.emit('bbf03f 8ec3 26a30000 e45e 8ae0 e45c 26a30200')
    a.emit('26ff060400 26c706060041d5')
    a.emit('c74602be00');a.branch('exit','eb')
    a.label('stock');a.emit('3c80');a.branch('ignored','73')
    a.emit('c746027a00');a.branch('exit','eb')
    a.label('ignored');a.emit('c74602be00')
    a.label('exit');a.emit('07 61 9d 5d cb')
    return a.finish()

def query_code():
    a=X86Assembler(QUERY);a.emit('46 49 60 06 b8f03f 8ec0 9c fa')
    a.emit('26813e060041d5');a.branch('ready','74')
    # Initialize cache on first query. Call ATGU before sending a request.
    a.emit('26c70600000000 26c70602000000 26c70604000000 26c706060041d5')
    a.label('ready')
    # Snapshot all three fields with interrupts masked; restore IF before printing.
    a.emit('268b160000 268b1e0200 268b0e0400 9d 51 53 52')
    a.string('\r\nDSPMON ')
    for index in range(3):
        a.emit('58 9a7ab2bb57')
        if index<2:a.string(' ')
    a.string('\r\n');a.emit('07 61 f8 c3')
    return a.finish()

def bulk_code():
    """ATGD program / ATGE mapped-ROM range, four hex digits per word."""
    a=X86Assembler(BULK)
    a.emit('80fb44');a.branch('selected','74')
    a.emit('80fb45');a.long_branch('fallback','75')
    a.label('selected')
    a.emit('83f909');a.long_branch('bad','75')
    a.emit('46 49 60 06')
    # Validate all eight characters before the stock permissive hex parser.
    a.emit('8bfe b90800')
    a.label('hex');a.emit('8a05 3c30');a.long_branch('invalid','72')
    a.emit('3c39');a.branch('digit','76')
    a.emit('3c41');a.long_branch('invalid','72')
    a.emit('3c46');a.long_branch('invalid','77')
    a.label('digit');a.emit('47');a.branch('hex','e2')
    a.emit('b90400 9a45b2bb57 50 b90400 9a45b2bb57 8be8 5e')
    # BX retains D/E across the hex parser; DX holds the request tag between
    # parsing and the first request, then is recreated for each word.
    a.emit('ba8a00 b8ff7f 80fb44');a.branch('bound','74')
    a.emit('ba8b00 b8ff1f')
    a.label('bound');a.emit('3be8');a.long_branch('invalid','77')
    a.emit('3bf5');a.long_branch('invalid','77')
    a.emit('b8f03f 8ec0')
    a.string('\r\nDSPDUMP ')
    a.label('word')
    # PUSHA + PUSH ES: saved BX is SS:[SP+10]. Recreate the tag after
    # printing, since the stock output helpers clobber DX.
    a.emit('8bdc 36807f0a44 ba8a00');a.branch('tag','74')
    a.emit('ba8b00');a.label('tag')
    a.emit('268b3e0400 8bc2 8bde 9a77077067')
    # Bounded wait; interrupts remain enabled to service the mailbox.
    a.emit('ba4000')
    a.label('outer');a.emit('b9ffff')
    a.label('wait');a.emit('263b3e0400');a.branch('reply','75')
    a.branch('wait','e2');a.emit('4a');a.branch('outer','75')
    a.string('\r\nDSPTIMEOUT\r\n');a.branch('invalid','eb')
    a.label('reply');a.emit('26813e00007200');a.branch('invalid','75')
    a.emit('26a10200 9a7ab2bb57 3bf5');a.branch('done','74')
    a.emit('46');a.branch('word','eb')
    a.label('done');a.string('\r\nDSPEND\r\n')
    a.emit('07 61 83c608 33c9 f8 c3')
    a.label('invalid');a.emit('07 61')
    a.label('bad');a.emit('f9 c3')
    a.label('fallback');a.emit('83f904');a.branch('eight','75')
    a.emit(b'\xe9'+struct.pack('<H',(0x82583-(a.base+len(a.code)+3))&0xffff))
    a.label('eight');a.emit(b'\xe9'+struct.pack('<H',(0x8258e-(a.base+len(a.code)+3))&0xffff))
    return a.finish()

def build(source,output):
    image=XmfImage.load(source);old=image.data
    if image.digest!=BASE_DIGEST:raise ValueError('requires the verified stock 2.3.33 image')
    if crc(old[:0x200])!=struct.unpack_from('<H',old,0x200)[0] or crc(old[0x206:])!=struct.unpack_from('<H',old,0x202)[0]:raise ValueError('stock boot CRC mismatch')
    data=bytearray(old);changes=[]
    def change(offset,new,reason,expected=None):
        before=bytes(data[offset:offset+len(new)])
        if expected is not None and before!=expected:raise ValueError(f'precondition at {offset:x}')
        data[offset:offset+len(new)]=new
        changes.append({'file_offset':f'{offset:05X}','bytes':len(new),'reason':reason,'before_sha256':hashlib.sha256(before).hexdigest(),'after_sha256':hashlib.sha256(new).hexdigest()})
    resident,overlay6,low,overlay8=image.dsp_segments()
    code=pack(dsp_code())
    if MONITOR!=resident.origin+resident.words:raise ValueError('resident endpoint moved')
    if MONITOR+len(code)//2>0x7fc0:raise ValueError('monitor overlaps DSP reply ring')
    for s in (overlay6,low,overlay8):
        if s.origin<MONITOR+len(code)//2 and s.origin+s.words>MONITOR:raise ValueError('overlay overlaps monitor')
    # Move the stored overlay, retaining its DSP load origin and size.
    destination=0x50000
    change(destination,old[overlay6.file_offset:overlay6.end],'relocated overlay 6',b'\xff'*overlay6.size)
    change(0x668ce-0x40000,struct.pack('<H',0x9000),'overlay 6 source segment',struct.pack('<H',0x4ceb))
    change(resident.end,code,'appended DSP monitor',old[resident.end:resident.end+len(code)])
    change(resident.file_offset+2*(0x12c0-resident.origin),pack([0x7980,MONITOR]),'DSP dispatcher hook',pack([0x697d,0xba87]))
    new_end=resident.size+len(code)
    count=0
    for match in DSP_CALL_SITE.finditer(image.supervisor[:65536]):
        entry,start,end=(struct.unpack('<H',match[n])[0] for n in (1,3,4))
        if (entry,start,end)==(0x1000,0,resident.size):
            change(image.supervisor_offset+match.start(4),struct.pack('<H',new_end),'resident download extent',struct.pack('<H',resident.size));count+=1
    if not count:raise ValueError('no resident download call sites')
    table=image.supervisor_offset+0xedde
    change(table+6*resident.index+2,struct.pack('<H',new_end),'resident overlay-table extent',struct.pack('<H',resident.size))
    rx=cpu_code();query=query_code();bulk=bulk_code()
    change(CPU-0x40000,rx,'CPU reply capture trampoline',b'\xff'*len(rx))
    change(QUERY-0x40000,query,'ATGU cache query',b'\xff'*len(query))
    change(BULK-0x40000,bulk,'ATGD program range stream',b'\xff'*len(bulk))
    change(0x8257e-0x40000,b'\xe9'+struct.pack('<H',(BULK-0x82581)&0xffff)+b'\x90\x90','ATGD selector',bytes.fromhex('83f904750b'))
    change(0x67774-0x40000,bytes.fromhex('9a0000008a90'),'CPU reply interception',bytes.fromhex('3c807202eb44'))
    disp=(QUERY-(0x8257b+3))&0xffff
    change(0x8257b-0x40000,b'\xe9'+struct.pack('<H',disp),'ATGU query selector',bytes.fromhex('e98401'))
    payload_crc=crc(data[0x206:]);change(0x202,struct.pack('<H',payload_crc),'boot payload CRC')
    assert len(data)==len(old)
    assert crc(data[:0x200])==struct.unpack_from('<H',data,0x200)[0]
    assert crc(data[0x206:])==struct.unpack_from('<H',data,0x202)[0]
    output.mkdir(parents=True,exist_ok=True)
    candidate=output/'2_3_33-dsp-monitor.candidate.xmf';candidate.write_bytes(data)
    report={'status':'experimental; isolated handlers verified; full boot untested','source_sha256':image.digest,'patched_sha256':hashlib.sha256(data).hexdigest(),
            'boot_header_crc':f'{crc(data[:0x200]):04X}','boot_payload_crc':f'{payload_crc:04X}',
            'monitor_program_origin':f'{MONITOR:04X}','monitor_words':len(code)//2,'resident_call_sites_updated':count,
            'cache_physical_address':f'{CACHE:05X}','changes':changes,
            'limitations':['Full 3453C boot and hardware patch execution untested.', 'Monitor reserves CPU RAM 3FF00..3FF07; live allocator ownership not yet verified.',
                'Relocated overlay source at physical 90000 needs complete boot/overlay validation.', 'ATGU is repurposed; call it before the first request to initialize the reply cache.',
                'DSP data reads limited to 0100..03FF; program reads 0000..7FFF.', 'No writes implemented.']}
    segments=[(resident.origin,bytes(data[resident.file_offset:resident.file_offset+new_end])),
              (overlay6.origin,bytes(data[destination:destination+overlay6.size])),
              (low.origin,bytes(data[low.file_offset:low.end])),(overlay8.origin,bytes(data[overlay8.file_offset:overlay8.end]))]
    decoded=XmfImage.load(candidate).dsp_program_segments()
    assert tuple(segments)==decoded, 'patched download metadata disagrees with the emitted segments'
    verify(data,segments,report)
    (output/'manifest.json').write_text(json.dumps(report,indent=2)+'\n')
    mem=[0]*65536;mem[MONITOR:MONITOR+len(code)//2]=dsp_code()
    (output/'monitor-dsp.asm').write_text('\n'.join(f'{i.pc:04x}: {" ".join(f"{w:04x}" for w in i.words):12} {i.text}' for i in disassemble(mem,MONITOR,MONITOR+len(code)//2))+'\n')
    md=Cs(CS_ARCH_X86,CS_MODE_16);lines=[]
    for address,blob in [(CPU,rx),(QUERY,query),(BULK,bulk)]:
        for i in md.disasm(blob,address):lines.append(f'{i.address:05x}: {i.bytes.hex():24} {i.mnemonic} {i.op_str}')
    (output/'monitor-cpu-linear.asm').write_text('; Inline printer strings are data, not instructions.\n'+'\n'.join(lines)+'\n')
    print(json.dumps({k:report[k] for k in ('status','patched_sha256','monitor_words','verification')},indent=2))

# Verification functions are below; each uses the actual emitted machine code.
def verify(data,segments,report):
    results=[]
    def replay(tag,value=0,full=False,overlays=False,unmasked=False):
        with NativeC5x.from_program(*segments[0]) as core:
            for index in ([1,2,3] if overlays else [2]):core.load_program(segments[index][1],segments[index][0])
            harness=[0x5d07,0x18b8,0xbe40 if unmasked else 0xbe41,0x8b89,0x7a80,0x12b1,0x8b89,0x7a80,0x12e4]
            halt=0x7e00+len(harness);harness.extend([0x7980,halt])
            core.load_program(pack(harness),0x7e00)
            core.load_rom(pack([0x6000^n for n in range(0x2000)]))
            core.set_mpmc_pin(1);core.set_data(0x78,0x7fc0 if not full else 0x7fcb);core.set_data(0x79,0x7fc0)
            core.set_data(0x0123,0xbeef);core.set_data(0x012f,0x0403)
            core.set_io(0x8057,1 if full else 3);core.set_io(0x805e,tag);core.set_io(0x805f,value)
            core.set_pc(0x7e00);seen=0;status=1 if full else 3
            producer_before=core.data(0x78)
            mapped_steps=0
            for _ in range(600):
                core.step(1);events=core.io_events()
                if not core.register(7)&8:
                    mapped_steps+=1
                    assert core.state()['flags']&0x80, 'interrupts enabled while ROM mapped'
                    assert MONITOR<=core.state()['pc']<MONITOR+len(dsp_code()), 'execution left safe monitor while ROM mapped'
                for event in events[seen:]:
                    if event['write'] and event['port']==0x8057:
                        status &= ~event['value'];core.set_io(0x8057,status)
                seen=len(events)
                if core.state()['pc']==halt:break
            else:raise AssertionError(f'request {tag:x} failed to return')
            tags=[e['value'] for e in events if e['write'] and e['port']==0x805e]
            values=[e['value'] for e in events if e['write'] and e['port']==0x805f]
            if full:assert core.data(0x78)==producer_before, 'partial reply queued on overflow'
            assert core.register(7)==0x18b8, 'PMST not restored'
            assert bool(core.state()['flags']&0x80)!=unmasked, 'INTM not restored'
            if tag==0x8b and value<=0x1fff:assert mapped_steps>0
            result={'request':[tag,value],'full_ring':full,'overlays_loaded':overlays,'reply':[tags[-1],values[-1]] if tags and values else None,'instructions':core.state()['instructions']}
            results.append(result);return result['reply']
    assert replay(0x88)==[0x70,0xd541]
    assert replay(0x89,0x123)==[0x71,0xbeef]
    assert replay(0x8a,0x12c0)==[0x72,0x7980]
    assert replay(0x8a,MONITOR)==[0x72,0x697d]
    assert replay(0x89,0xff)==[0x73,1]
    assert replay(0x89,0x400)==[0x73,1]
    assert replay(0x8a,0x8000)==[0x73,1]
    assert replay(0x80)==[0x7e,3]
    assert replay(0x6c) is None
    assert replay(0x88,full=True) is None
    assert replay(0x88,overlays=True)==[0x70,0xd541]
    assert replay(0x8a,MONITOR,overlays=True)==[0x72,0x697d]
    assert replay(0x8c)==[0x71,0x18b8]
    assert replay(0x8b,0)==[0x72,0x6000]
    assert replay(0x8b,0x1fff)==[0x72,0x7fff]
    assert replay(0x8b,0x2000)==[0x73,1]
    assert replay(0x8b,0x123,unmasked=True)==[0x72,0x6123]
    assert replay(0x8b,0x123,full=True,unmasked=True) is None
    report['dsp_replays']=results
    report['cpu_tests']=verify_cpu(data)+verify_bulk(data)
    report['verification']={'dsp_cases_passed':len(results),'cpu_cases_passed':len(report['cpu_tests']),
        'header_and_payload_crc_valid':True,'scope':'Isolated machine-code handlers and relocated overlay survival; full boot and hardware not validated.'}

def verify_cpu(data):
    from courier_emu import x86_interpreter as x
    def cpu():
        c=x.Uc(0,0,profile='186eb');c.native_enabled=False;c.mem_map(0,len(c.memory));c.memory[0x40000:0xf8000]=data
        c.reg_write(x.UC_X86_REG_DS,0);c.reg_write(x.UC_X86_REG_SS,0);c.reg_write(x.UC_X86_REG_SP,0x7000)
        return c
    results=[]
    for tag,expected in [(0x70,0x677be),(0x71,0x677be),(0x72,0x677be),(0x73,0x677be),(0x7e,0x6777a),(0x47,0x6777a),(0x80,0x677be),(0x170,0x6777a)]:
        c=cpu();c.reg_write(x.UC_X86_REG_CS,0x6770);c.reg_write(x.UC_X86_REG_AX,tag);c.reg_write(x.UC_X86_REG_ES,0x1234)
        c.memory[CACHE:CACHE+8]=struct.pack('<4H',0,0,9,0xd541)
        def incoming(u,port,size,unused):return {0x5e:0xbe,0x5c:0xef}[port]
        c.hook_add(x.UC_HOOK_INSN,incoming,None,1,0,x.UC_X86_INS_IN)
        c.hook_add(x.UC_HOOK_CODE,lambda u,a,s,d:u.emu_stop(),None,expected,expected)
        c.emu_start(0x67774,expected,count=150)
        actual=(c.reg_read(x.UC_X86_REG_CS)<<4)+c.reg_read(x.UC_X86_REG_IP)
        assert actual==expected,(tag,actual,expected)
        assert c.reg_read(x.UC_X86_REG_AX)==tag and c.reg_read(x.UC_X86_REG_ES)==0x1234 and c.reg_read(x.UC_X86_REG_SP)==0x7000
        cache=struct.unpack('<4H',c.memory[CACHE:CACHE+8])
        assert cache==((tag,0xbeef,10,0xd541) if 0x70<=tag<=0x73 else (0,0,9,0xd541)),cache
        results.append({'case':'reply filter','tag':tag,'resume_address':f'{actual:05X}','cache':cache})
    for valid in (False,True):
        c=cpu();c.reg_write(x.UC_X86_REG_CS,0x813c);c.reg_write(x.UC_X86_REG_SP,0x6ffe);c.memory[0x6ffe:0x7000]=struct.pack('<H',0x100)
        c.reg_write(x.UC_X86_REG_AX,0x4567);c.reg_write(x.UC_X86_REG_ES,0x2345)
        c.reg_write(x.UC_X86_REG_SI,0x1230);c.reg_write(x.UC_X86_REG_CX,1)
        c.memory[CACHE:CACHE+8]=struct.pack('<4H',0x71,0xbeef,10,0xd541 if valid else 0)
        text=[]
        def printer(u,address,size,unused):
            if address not in (0x7b493,0x62e2a):return
            sp=u.reg_read(x.UC_X86_REG_SP);ip,cs=struct.unpack('<2H',u.memory[sp:sp+4]);phys=(cs<<4)+ip
            if address==0x7b493:
                end=u.memory.index(0,phys);text.append(bytes(u.memory[phys:end]).decode());ip+=(end-phys)+1
            else:text.append(f'{u.reg_read(x.UC_X86_REG_AX):04X}')
            u.reg_write(x.UC_X86_REG_SP,sp+4);u.reg_write(x.UC_X86_REG_CS,cs);u.reg_write(x.UC_X86_REG_IP,ip)
        c.hook_add(x.UC_HOOK_CODE,printer,None,0x7b493,0x7b493)
        c.hook_add(x.UC_HOOK_CODE,printer,None,0x62e2a,0x62e2a)
        c.hook_add(x.UC_HOOK_CODE,lambda u,a,s,d:u.emu_stop(),None,0x814c0,0x814c0)
        c.emu_start(0x8257b,0x814c0,count=200)
        actual=(c.reg_read(x.UC_X86_REG_CS)<<4)+c.reg_read(x.UC_X86_REG_IP)
        assert actual==0x814c0,hex(actual)
        value=''.join(text);assert value==('\r\nDSPMON 0071 BEEF 000A\r\n' if valid else '\r\nDSPMON 0000 0000 0000\r\n'),repr(value)
        assert c.reg_read(x.UC_X86_REG_AX)==0x4567 and c.reg_read(x.UC_X86_REG_ES)==0x2345 and c.reg_read(x.UC_X86_REG_SP)==0x7000
        assert c.reg_read(x.UC_X86_REG_SI)==0x1231 and c.reg_read(x.UC_X86_REG_CX)==0
        results.append({'case':'ATGU cache display','initialized':valid,'output':value})
    return results

def verify_bulk(data):
    from courier_emu import x86_interpreter as x
    results=[]
    cases=[('D00000003',True),('D7FFF7FFF',True),('D00030000',False),
           ('D80008000',False),('D000Z0001',False),('D0000000',False),('D00000001',False),
           ('E00000003',True),('E1FFF1FFF',True),('E20002000',False)]
    for index,(command,success) in enumerate(cases):
        timeout=index==6
        c=x.Uc(0,0,profile='186eb');c.native_enabled=False;c.mem_map(0,len(c.memory))
        c.memory[0x40000:0xf8000]=data
        for reg,value in [(x.UC_X86_REG_CS,0x813c),(x.UC_X86_REG_DS,0),(x.UC_X86_REG_SS,0),
                          (x.UC_X86_REG_SP,0x6ffe),(x.UC_X86_REG_SI,0x1000),
                          (x.UC_X86_REG_CX,len(command)),(x.UC_X86_REG_BX,ord(command[0]))]:c.reg_write(reg,value)
        c.memory[0x1000:0x1000+len(command)]=command.encode()
        c.memory[0x6ffe:0x7000]=struct.pack('<H',0x100)
        c.memory[CACHE:CACHE+8]=struct.pack('<4H',0,0,0xffff,0xd541)
        text=[];requests=[]
        def hook(u,address,size,unused):
            if address==0x814c0:u.emu_stop();return
            if address in (0x7b493,0x62e2a,0x67e77):
                sp=u.reg_read(x.UC_X86_REG_SP);ip,cs=struct.unpack('<2H',u.memory[sp:sp+4]);phys=(cs<<4)+ip
                if address==0x7b493:
                    end=u.memory.index(0,phys);text.append(bytes(u.memory[phys:end]).decode());ip+=end-phys+1
                    u.reg_write(x.UC_X86_REG_DX,0xabcd)
                elif address==0x62e2a:
                    text.append(f'{u.reg_read(x.UC_X86_REG_AX):04X}')
                    u.reg_write(x.UC_X86_REG_DX,0xabcd) # real printer clobbers DX
                else:
                    assert u.reg_read(x.UC_X86_REG_AX)==(0x8a if command[0]=='D' else 0x8b)
                    word=u.reg_read(x.UC_X86_REG_BX);requests.append(word)
                    if not timeout:
                        sequence=(struct.unpack_from('<H',u.memory,CACHE+4)[0]+1)&0xffff
                        u.memory[CACHE:CACHE+8]=struct.pack('<4H',0x72,word^0xbeef,sequence,0xd541)
                u.reg_write(x.UC_X86_REG_SP,sp+4);u.reg_write(x.UC_X86_REG_CS,cs);u.reg_write(x.UC_X86_REG_IP,ip)
            # Shorten only the timeout budget, retaining the actual branch path.
            if timeout and u.memory[address:address+3]==bytes.fromhex('b9ffff'):
                u.reg_write(x.UC_X86_REG_DX,1);u.reg_write(x.UC_X86_REG_CX,2)
                u.reg_write(x.UC_X86_REG_IP,u.reg_read(x.UC_X86_REG_IP)+3)
        c.hook_add(x.UC_HOOK_CODE,hook)
        c.emu_start(0x8257e,0x814c0,count=4000)
        assert c.reg_read(x.UC_X86_REG_SP)==0x7000
        assert bool(c.reg_read(x.UC_X86_REG_FLAGS)&1)!=success
        value=''.join(text)
        if success:
            start,end=int(command[1:5],16),int(command[5:],16)
            assert requests==list(range(start,end+1))
            assert value=='\r\nDSPDUMP '+''.join(f'{w^0xbeef:04X}' for w in requests)+'\r\nDSPEND\r\n'
            assert c.reg_read(x.UC_X86_REG_CX)==0 and c.reg_read(x.UC_X86_REG_SI)==0x1009
        elif timeout:assert value=='\r\nDSPDUMP \r\nDSPTIMEOUT\r\n'
        else:assert not requests and not value
        results.append({'case':'ATGD range stream','command':command,'success':success,'timeout':timeout,'words':len(requests)})
    return results

if __name__=='__main__':
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--source',type=Path,default=Path(__file__).resolve().parents[1]/'2_3_33.XMF')
    parser.add_argument('--output',type=Path,default=Path(__file__).resolve().parents[1]/'artifacts/3453c-dsp-monitor-patch-20261003')
    args=parser.parse_args();build(args.source,args.output)
