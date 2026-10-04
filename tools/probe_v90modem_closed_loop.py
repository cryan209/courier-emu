#!/usr/bin/env python3
"""Clock an original Courier endpoint against the actual v90modem engine.

Analog uses the existing exchange-codec calibration. I-modem carries byte-
exact PCMU. No recording supplies either peer's response. Pace the engine's
media clock because its training timeouts use wall time.
"""
import argparse
import hashlib
import json
import os
from pathlib import Path
import select
import struct
import subprocess
import sys
import tempfile
import time
ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))
os.environ.setdefault('COURIER_LINE_FRAME_MS', '20')
from courier_emu.line import LineLink, LineFrame, CALL_ANSWERED, CALL_RINGING, CALL_CLEARED
from courier_emu.bearer_line import BearerLineLink
from courier_emu.sip import linear_to_ulaw, ulaw_to_linear


class EnginePeer:
    def __init__(self, output, engine, fast=False):
        self.output, self.engine, self.fast = output, engine, fast
        self.process = None
        self.samples = 0
        self.frames = 0
        self.sent_non_ff = self.received_non_ff = 0
        self.error = None
        self.log = self.rx = self.tx = None

    def start(self):
        if self.process is not None: return
        self.log = (self.output/'engine.log').open('wb')
        self.rx = (self.output/'engine-rx.g711').open('wb')
        self.tx = (self.output/'engine-tx.g711').open('wb')
        env = os.environ.copy(); env['ME_MODE'] = 'x2'
        self.environment = {k:v for k,v in env.items() if k.startswith('ME_')}
        self.engine_sha256 = hashlib.sha256(self.engine.read_bytes()).hexdigest()
        self.process = subprocess.Popen([str(self.engine), '/private/tmp/'+self.output.name+'-pty'],
            stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=self.log, env=env)
        self.origin = time.monotonic()

    def exchange(self, octets):
        self.start()
        if not octets: return b''
        assert len(octets) <= 4096
        if not self.fast:
            delay = self.origin + self.samples/8000 - time.monotonic()
            if delay > 0: time.sleep(delay)
        self.rx.write(octets)
        self.process.stdin.write(struct.pack('<H',len(octets))+octets)
        self.process.stdin.flush()
        reply = bytearray()
        while len(reply) < len(octets):
            if not select.select([self.process.stdout],[],[],30)[0]:
                raise TimeoutError('engine frame')
            chunk = self.process.stdout.read(len(octets)-len(reply))
            if not chunk: raise EOFError('engine closed')
            reply.extend(chunk)
        self.tx.write(reply)
        self.samples += len(octets); self.frames += 1
        self.sent_non_ff += sum(x!=255 for x in octets)
        self.received_non_ff += sum(x!=255 for x in reply)
        return bytes(reply)

    def stop(self):
        if self.process:
            if not self.process.stdin.closed: self.process.stdin.close()
            try: self.process.wait(timeout=10)
            except subprocess.TimeoutExpired:
                self.process.kill(); self.process.wait()
            for f in (self.log,self.rx,self.tx): f.close()

    def status(self):
        return {'frames':self.frames,'octets_sent':self.samples,'octets_received':self.samples,
                'sent_non_ff':self.sent_non_ff,'received_non_ff':self.received_non_ff,
                'error':self.error,'wall_clock_paced':not self.fast,
                'environment':getattr(self,'environment',{}),
                'engine_sha256':getattr(self,'engine_sha256',None),
                'engine_exit':self.process.returncode if self.process else None}


def analog(args):
    out=args.output; peer=EnginePeer(out,args.engine,args.fast)
    with tempfile.TemporaryDirectory(prefix='x2-loop-') as temp:
        socket=str(Path(temp)/'line.sock')
        command=[sys.executable,'-m','courier_emu','run',
            str(ROOT/'artifacts/courier-board-21210-capture-403/courier-board.rom'),
            '--instructions',str(args.instructions),'--line-link',socket,'--line-listen',
            '--with-dsp','--nvram-fixture','idsdl403','--board-id','7','--dip-preset','default',
            '--tick-ms','5','--at','ATX1S27=1S54=0S58=48&A3&B1Q0&U26&N39DT5551234',
            '--serial-input-after','5000000','--summary','--line-record',str(out/'analog'),
            '--dsp-trace-range','b1a1:b1c2','--dsp-write-watch','039f']
        for a in ('039f','03a4','03a5','03c8','006f','0078','0340'):
            command += ['--dsp-peek',a]
        env=os.environ.copy();env['COURIER_LINE_DIGITAL']='1';env['COURIER_DSP_TRACE_LIMIT']='10000'
        log=(out/'analog-stderr.log').open('wb')
        proc=subprocess.Popen(command,cwd=ROOT,stdout=(out/'analog-result.json').open('wb'),stderr=log,env=env)
        line=LineLink(socket,digital=True); codec=BearerLineLink(line)
        tx=bytes([255])*160;answered=False
        try:
            line.open()
            while line.connected and proc.poll() is None:
                if not answered and line.peer_call_state>=CALL_RINGING:
                    answered=True;peer.start()
                through=answered and line.peer_call_state<CALL_CLEARED
                samples=[codec._clip(ulaw_to_linear(v)*codec.into_courier) for v in tx] if through else [0]*160
                line.exchange(LineFrame(line.frames*160*2500,answered,False,samples,
                                        CALL_ANSWERED if through else line.peer_call_state))
                incoming=line.receive_audio()
                if through:
                    rx=bytes(linear_to_ulaw(codec._clip(v*codec.from_line)) for v in incoming)
                    tx=peer.exchange(rx)
                if line.peer_call_state==CALL_CLEARED: break
        finally:
            line.close();peer.stop()
            try:proc.wait(timeout=10)
            except subprocess.TimeoutExpired:proc.terminate();proc.wait()
            log.close()
        result={'type':'analog403','command':command,'analog_exit':proc.returncode,
                'line':line.status(),'codec':{'from_line':codec.from_line,'into_courier':codec.into_courier},
                'engine':peer.status()}
        (out/'call.json').write_text(json.dumps(result,indent=2)+'\n')


def imodem(args):
    from tools import probe_imodem_pair as pair
    peer=EnginePeer(args.output,args.engine,args.fast)
    pair.G711Peer=lambda path,listen:peer
    saved=sys.argv
    sys.argv=['closed-loop','--worker','originate','--socket','unused',
        '--result',str(args.output/'imodem-result.json'),'--protocol','x2',
        '--instructions',str(args.instructions),'--settings',args.imodem_settings,
        '--nvram',str(args.nvram),'--trace-negotiation']
    original_machine=pair.IsdnMachine
    trace={'addresses':['039f','03e2','f6a0','f6a1','f6ba','fef0','fef1','ffdc','ffde','036d','03ed','039a','03cf','03db','ffd9','0322','02b2'],
           'samples':[],'writes':[],'gate_captures':[],'gate_instructions':[]}
    seen=None;next_at=0;dumped=False
    def machine(*a,**kw):
        prior=kw['serial_pump']
        def pump(current):
            nonlocal seen,next_at,dumped
            prior(current)
            core=current.mailbox.core
            if core is None:return
            if core is not seen:
                core.set_data_trace_range(0x039f,0x039f) if args.classifier else core.set_data_trace_range(0xf6a0,0xf6c0)
                core.set_pc_capture(0xde14 if args.classifier else 0x9596,[int(a,16) for a in trace['addresses']])
                core.set_pc_trace_range(0xddf6,0xde1b) if args.classifier else core.set_pc_trace_range(0x9596,0x965c)
                core.set_data_event_limit(2000)
                core.trace_data_writes(clear=True)
                seen=core
            if current.instructions<next_at:return
            next_at=current.instructions+250000
            trace['gate_instructions'].extend(core.pc_trace())
            core.clear_pc_trace()
            trace['gate_captures'].extend(core.pc_captures())
            core.clear_pc_captures()
            trace['writes'].extend(core.data_events())
            core.trace_data_writes(clear=True)
            trace['samples'].append({'instructions':current.instructions,
                'engine_samples':peer.samples,'state':core.state(),
                'cells':{a:core.data(int(a,16)) for a in trace['addresses']}})
            if not dumped and current.instructions>80000000:
                (args.output/'native-program.bin').write_bytes(struct.pack('<65536H',*(core.program(i) for i in range(65536))))
                dumped=True
        kw['serial_pump']=pump
        return original_machine(*a,**kw)
    pair.IsdnMachine=machine
    try:
        options=pair.arguments();pair.run_side(options)
    finally:
        sys.argv=saved;peer.stop();pair.IsdnMachine=original_machine
        (args.output/'native-control.json').write_text(json.dumps(trace,indent=2)+'\n')
    (args.output/'call.json').write_text(json.dumps({'type':'imodem','engine':peer.status(),
        'nvram':str(args.nvram),'settings':options.settings,'instructions':args.instructions},indent=2)+'\n')


def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('type',choices=['analog','imodem']);p.add_argument('--output',type=Path,required=True)
    p.add_argument('--engine',type=Path,default=ROOT.parent/'v90modem/v90_engine_peer')
    p.add_argument('--nvram',type=Path,default=ROOT/'artifacts/imodem-pair-x2-full-rate-routed-20261002/nvram-230400-switch2.sav')
    p.add_argument('--instructions',type=int,default=300_000_000);p.add_argument('--fast',action='store_true')
    p.add_argument('--classifier',action='store_true',help='trace the native PCM classifier instead of the INFO0 gate')
    p.add_argument('--imodem-settings',default='S54=0S58=58&A3&B1Q0',
                   help='disable I-modem server (2), symmetric (8), and V.90 (32); retain constellation option 16')
    args=p.parse_args();args.output=args.output.resolve()
    args.output.mkdir(parents=True,exist_ok=False)
    (analog if args.type=='analog' else imodem)(args)
if __name__=='__main__':main()
