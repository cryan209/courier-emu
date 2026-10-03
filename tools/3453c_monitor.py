#!/usr/bin/env python3
"""Query the experimental monitor after installation; never installs firmware."""
from pathlib import Path
import argparse, hashlib, json, os, re, struct, sys, time
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from courier_emu.xmodem_sdl import Port

class Monitor:
    def __init__(self,port):self.port=port
    def command(self,text,timeout=3):
        self.port.write(text.encode('ascii')+b'\r')
        data=bytearray();deadline=time.monotonic()+timeout
        while time.monotonic()<deadline:
            byte=self.port.byte(.1)
            if byte is not None:data.append(byte)
            if b'\r\nERROR\r\n' in data:
                # Initial hardware build prints a valid cache record but leaves
                # U for the outer parser, which then reports ERROR.
                if text=='ATGU' and re.search(rb'DSPMON [0-9A-Fa-f]{4} [0-9A-Fa-f]{4} [0-9A-Fa-f]{4}',data):return bytes(data)
                raise RuntimeError(f'{text}: modem returned ERROR')
            if b'\r\nOK\r\n' in data:return bytes(data)
        raise TimeoutError(f'{text}: serial response timed out')
    def cached(self):
        reply=self.command('ATGU')
        match=re.search(rb'DSPMON ([0-9A-Fa-f]{4}) ([0-9A-Fa-f]{4}) ([0-9A-Fa-f]{4})',reply)
        if not match:raise RuntimeError('DSPMON marker absent; monitor patch is not installed. No DSP request sent.')
        return tuple(int(v,16) for v in match.groups())
    def request(self,tag,address=0,timeout=3):
        before=self.cached()[2]
        self.command(f'ATG{tag:04X}{address:04X}')
        deadline=time.monotonic()+timeout
        while time.monotonic()<deadline:
            returned,value,sequence=self.cached()
            if sequence!=before:
                if returned==0x73:raise ValueError('DSP monitor rejected the address')
                expected={0x88:0x70,0x89:0x71,0x8a:0x72,0x8b:0x72,0x8c:0x71}[tag]
                if returned!=expected:raise RuntimeError(f'Unexpected fresh monitor reply {returned:04X}')
                return value
            time.sleep(.1)
        raise TimeoutError('DSP did not return a fresh monitor reply')
    def program_stream(self,start,end,rom=False):
        validate_range('rom' if rom else 'program',start,end)
        self.port.write(f'ATG{"E" if rom else "D"}{start:04X}{end:04X}\r'.encode())
        def until(marker,limit=256):
            data=bytearray();deadline=time.monotonic()+5
            while marker not in data:
                byte=self.port.byte(.1)
                if byte is not None:data.append(byte)
                if b'ERROR' in data or b'DSPTIMEOUT' in data:raise RuntimeError(bytes(data).decode('ascii','replace'))
                if len(data)>limit:raise RuntimeError('Unexpected bulk dump framing')
                if time.monotonic()>deadline:raise TimeoutError('Bulk dump response timed out')
            return bytes(data)
        until(b'DSPDUMP ')
        for _ in range(end-start+1):
            encoded=bytearray();deadline=time.monotonic()+5
            while len(encoded)<4:
                byte=self.port.byte(.1)
                if byte is not None:
                    if byte not in b'0123456789ABCDEF':raise RuntimeError('Invalid or incomplete DSP word in stream')
                    encoded.append(byte)
                if time.monotonic()>deadline:raise TimeoutError('DSP word stream stalled')
            yield int(encoded,16)
        if until(b'\r\nOK\r\n')!=b'\r\nDSPEND\r\n\r\nOK\r\n':
            raise RuntimeError('Unexpected bulk dump completion')

def validate_range(space,start,end):
    if space not in ('data','program','rom'):raise ValueError('space must be data, program, or rom')
    low,high={'data':(0x100,0x3ff),'program':(0,0x7fff),'rom':(0,0x1fff)}[space]
    if not low<=start<=end<=high:
        raise ValueError(f'{space} range must be ordered and within {low:04X}..{high:04X}')


def dump_range(monitor,space,start,end,output,progress=None,fast=False):
    """Stream an inclusive word-address range, retaining partial data on failure."""
    validate_range(space,start,end)
    if fast and space=='data':raise ValueError('Fast streaming supports program or rom memory only')
    output=Path(output)
    partial=output.with_name(output.name+'.partial')
    metadata=output.with_name(output.name+'.json')
    partial_metadata=partial.with_name(partial.name+'.json')
    for path in (output,partial,metadata,partial_metadata):
        if path.exists():raise FileExistsError(f'Refusing to overwrite {path}')
    count=end-start+1;received=0;digest=hashlib.sha256()
    started=time.monotonic()
    report={'space':space,'start_word':f'{start:04X}','end_word':f'{end:04X}',
            'word_addressing':'inclusive','byte_order':'little-endian','expected_words':count,
            'completed_words':0,'complete':False,
            'transport':('ATGE ROM stream' if space=='rom' else 'ATGD stream') if fast else 'individual ATG/ATGU requests',
            'consistency':'Sequential live reads; memory may change during capture.'}
    def save_report(path):
        report['completed_words']=received;report['bytes']=received*2
        report['sha256']=digest.hexdigest()
        report['elapsed_seconds']=round(time.monotonic()-started,3)
        path.write_text(json.dumps(report,indent=2)+'\n')
    # Exclusive creation keeps existing dumps and unfinished captures intact.
    with partial.open('xb') as stream:
        try:
            save_report(partial_metadata)
            words=(monitor.program_stream(start,end,rom=True) if space=='rom' else monitor.program_stream(start,end)) if fast else (monitor.request({'data':0x89,'program':0x8a,'rom':0x8b}[space],address) for address in range(start,end+1))
            for address,word in zip(range(start,end+1),words):
                encoded=struct.pack('<H',word)
                stream.write(encoded);digest.update(encoded);received+=1
                if progress:progress(received,count,address)
            # Exhaust the stream so its completion marker is checked.
            if next(words,None) is not None:raise RuntimeError('Excess DSP words')
            stream.flush();os.fsync(stream.fileno())
        except BaseException as error:
            report['error']=f'{type(error).__name__}: {error}'
            save_report(partial_metadata)
            raise
    report['complete']=True;save_report(partial_metadata)
    # Hard links publish complete files without replacing an existing target.
    os.link(partial,output)
    os.link(partial_metadata,metadata)
    partial.unlink();partial_metadata.unlink()
    return report


def main(argv=None):
    p=argparse.ArgumentParser(description=__doc__)
    def connection(parser,suppress=False):
        parser.add_argument('--device',default=argparse.SUPPRESS if suppress else '/dev/cu.usbserial-FT4TQOFT')
        parser.add_argument('--baud',type=int,default=argparse.SUPPRESS if suppress else 19200)
    connection(p)
    commands=p.add_subparsers(dest='operation',required=True)
    connection(commands.add_parser('identify'),True)
    connection(commands.add_parser('pmst'),True)
    for space in ('data','program','rom'):
        sub=commands.add_parser(space);connection(sub,True)
        sub.add_argument('address',type=lambda s:int(s,16),help='hexadecimal DSP word address')
    sub=commands.add_parser('dump',help='save an inclusive DSP word-address range')
    connection(sub,True)
    sub.add_argument('space',choices=['data','program','rom'])
    sub.add_argument('start',type=lambda s:int(s,16))
    sub.add_argument('end',type=lambda s:int(s,16),help='inclusive final word address')
    sub.add_argument('--output',type=Path,required=True)
    sub.add_argument('--fast',action='store_true',help='use ATGD streaming (requires the bulk monitor build)')
    args=p.parse_args(argv)
    try:
        if args.operation=='dump':
            validate_range(args.space,args.start,args.end)
            if args.fast and args.space=='data':raise ValueError('--fast supports program or rom memory only')
            for path in (args.output,Path(str(args.output)+'.json'),Path(str(args.output)+'.partial'),Path(str(args.output)+'.partial.json')):
                if path.exists():raise FileExistsError(f'Refusing to overwrite {path}')
            if not args.output.parent.is_dir():raise ValueError('output directory does not exist')
        elif args.operation not in ('identify','pmst'):validate_range(args.operation,args.address,args.address)
    except (ValueError,FileExistsError) as error:p.error(str(error))
    with Port(args.device,args.baud) as port:
        monitor=Monitor(port)
        if args.operation=='dump':
            last=time.monotonic()
            def progress(done,total,address):
                nonlocal last
                now=time.monotonic()
                if now-last>=5 or done==total:
                    print(f'{done}/{total} words ({done*2:,} bytes), through {address:04X}',file=sys.stderr,flush=True)
                    last=now
            report=dump_range(monitor,args.space,args.start,args.end,args.output,progress,args.fast)
            print(f'Saved {report["bytes"]:,} bytes to {args.output}')
        else:
            value=monitor.request({'identify':0x88,'data':0x89,'program':0x8a,'rom':0x8b,'pmst':0x8c}[args.operation],getattr(args,'address',0))
            if args.operation=='identify' and value!=0xd541:raise RuntimeError('Unexpected monitor signature')
            print(f'{value:04X}')


if __name__=='__main__':main()
