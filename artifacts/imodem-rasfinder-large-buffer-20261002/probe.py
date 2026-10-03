import json
import time
from pathlib import Path
from courier_emu import cli
from tools.probe_imodem_analog_pair import OverlayAudit

out = Path(__file__).resolve().parent
from courier_emu.sip import SipSession
from courier_emu.bearer_sip import BearerSipLine
bearer_init = BearerSipLine.__init__
def buffered_init(self,*args,**kwargs):
    kwargs['receive_buffer_samples'] = 800
    kwargs['transmit_buffer_samples'] = 800
    bearer_init(self,*args,**kwargs)
BearerSipLine.__init__ = buffered_init
packets, fills = [], []
init = SipSession.__init__
class ObservedSocket:
    def __init__(self, sock): self.sock = sock
    def __getattr__(self, name): return getattr(self.sock,name)
    def recvfrom(self,*args):
        data,addr = self.sock.recvfrom(*args)
        packets.append([time.monotonic(),'rx',data[:12].hex(),len(data)])
        return data,addr
    def sendto(self,data,*args):
        packets.append([time.monotonic(),'tx',data[:12].hex(),len(data)])
        return self.sock.sendto(data,*args)
def observed_init(self,*args,**kwargs):
    init(self,*args,**kwargs); self.rtp_socket = ObservedSocket(self.rtp_socket)
SipSession.__init__ = observed_init
exchange = BearerSipLine.exchange
def observed_exchange(self,octets):
    before=self.underrun
    value=exchange(self,octets)
    if self.underrun != before:
        fills.append([time.monotonic(),self.octets_out,self.underrun-before,self.session.state])
    return value
BearerSipLine.exchange=observed_exchange
original = cli.IsdnMachine

class AuditedMachine(original):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        audit = OverlayAudit(self.mailbox)
        self.mailbox.write = audit.write
        pump = self.serial_pump
        snapshots, captures, traces = [], [], []
        started = time.monotonic()
        next_snapshot = 0
        traced_core = None
        addresses = list(range(0x0300, 0x0380)) + list(range(0x03b0, 0x0400))
        addresses += [0x006d,0x006e,0x006f,0x088c,0x088d,0x088e,0x088f,0x0bf0,0x0bf1]
        (out/'capture-addresses.json').write_text(json.dumps(addresses))
        cells = [0x006d,0x006e,0x006f,0x031a,0x032b,0x032c,0x032d,
                 0x0337,0x033a,0x035b,0x038f,0x039f,0x03c8,0x03cb,0x03cd,
                 0x088c,0x088d,0x0bf0,0x0bf1,0x03b4,0x03b5,0x03d0,0x03d2,0x0264]
        def observe(machine):
            nonlocal next_snapshot, traced_core
            if pump: pump(machine)
            if machine.instructions < next_snapshot: return
            core = machine.mailbox.core
            if core and core is not traced_core:
                core.set_pc_trace_range(0x92a9,0x92ae)
                core.set_pc_capture(0x92a9,addresses)
                traced_core = core
            if core:
                captures.extend(core.pc_captures()); core.clear_pc_captures()
                traces.extend(core.pc_trace()); core.clear_pc_trace()
            if machine.bri.call_state == 'active':
                snapshots.append({'wall_seconds':time.monotonic()-started,
                    'instructions':machine.instructions,'dsp':core.state() if core else None,
                    'stack':core.stack() if core else None,
                    'cells':{f'{a:04x}':core.data(a) for a in cells} if core else {},
                    'replies':list(machine.mailbox.replies)[-2:]})
            next_snapshot = machine.instructions + 100_000
        self.serial_pump = observe
        close = self.mailbox.close
        def capture_close():
            core = self.mailbox.core
            if core:
                captures.extend(core.pc_captures()); traces.extend(core.pc_trace())
                (out/'dsp-program.bin').write_bytes(b''.join(core.program(i).to_bytes(2,'little') for i in range(65536)))
                (out/'dsp-data.bin').write_bytes(b''.join(core.data(i).to_bytes(2,'little') for i in range(65536)))
            (out/'packets.json').write_text(json.dumps(packets))
            (out/'fills.json').write_text(json.dumps(fills))
            (out/'checkpoints.json').write_text(json.dumps(snapshots))
            (out/'retrain-captures.json').write_text(json.dumps(captures))
            (out/'retrain-trace.json').write_text(json.dumps(traces))
            (out/'overlay-verification.json').write_text(json.dumps(audit.records,indent=2))
            close()
        self.mailbox.close = capture_close

cli.IsdnMachine=AuditedMachine
raise SystemExit(cli.main([
 'isdn-run','Ie030002.nac','--with-dsp','--no-flash-nvram','--instructions','200000000',
 '--bri-network','--bri-establish','terminal','--bri-sip','asterisk.net.cryan.nz',
 '--bri-sip-username','2903','--bri-sip-record',str(out/'rasfinder-to-imodem.g711'),
 '--bri-tx-g711',str(out/'imodem-to-rasfinder.g711'),
 '--bri-rx-heard',str(out/'imodem-heard.g711'),'--send-after','30000000','--send-every','0',
 '--send','AT*V2=3','--send','ATS58=33','--send','AT&W','--send','ATDT3999']))
