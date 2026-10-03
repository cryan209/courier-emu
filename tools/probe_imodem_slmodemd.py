"""Compare native answering I-modem with Tower's calling SmartLink datapump.

The companion relay is installed temporarily in the idle d-modem container.
Only audio crosses SSH; its wall-clock latency does not
advance either datapump. Each 20 ms block clocks exactly 160/192 samples.
"""
import argparse
import json
from pathlib import Path
import select
import shlex
import struct
import subprocess
import hashlib

from courier_emu.bri import BriNetwork
from courier_emu.isdn import IsdnMachine
from courier_emu.isdn_console import scripted_pump
from courier_emu.isdn_console import _on_the_wire
from courier_emu.sio import received
from courier_emu.nac import NacImage
from courier_emu.resample import BandLimitedResampler
from courier_emu.sip import linear_to_ulaw, ulaw_to_linear
from tools.probe_imodem_analog_pair import OverlayAudit
from tools.tower_pcm_reconstruction import TowerPcmReconstruction


class SmartLinkPeer:
    realtime_clock = False

    def __init__(self, output, gain=1.0, protocol='v34', reconstruction='auto', payload=False, error_correction=False, payload_packets=150, training_gain=1.0, interpolation_points=32):
        self.output = output
        self.gain = gain
        self.protocol = protocol
        self.payload = payload
        self.error_correction = error_correction
        self.payload_packets = payload_packets
        self.process = None
        self.up, self.down = BandLimitedResampler(), BandLimitedResampler()
        self.reconstruction = ('tower' if protocol == 'v90' else 'bandlimited') if reconstruction == 'auto' else reconstruction
        if self.reconstruction == 'tower':
            self.up = TowerPcmReconstruction(training_gain=training_gain, interpolation_points=interpolation_points)
        self.pending = bytearray()
        self.received = []
        self.cursor = 0
        self.blocks = 0
        self.offered = False
        self.ready = False
        self.primed = False
        self.instructions = 0
        self.ended = False
        self.remote = '/tmp/' + output.name

    def poll(self): pass

    def remote_ended(self): return self.ended

    def incoming_call(self):
        if not self.offered and self.instructions >= 35_000_000:
            self.offered = True
            return '', '7349195'

    def start(self):
        if self.process is None:
            self.process = subprocess.Popen([
                'ssh', '-T', 'root@tower.net.cryan.nz', 'docker', 'exec', '-i',
                '-e', 'IMODEM_PROBE_PROTOCOL=' + self.protocol,
                '-e', 'IMODEM_PROBE_PAYLOAD=' + ('1' if self.payload else '0'),
                '-e', 'IMODEM_PROBE_EC=' + ('1' if self.error_correction else '0'),
                '-e', 'IMODEM_PROBE_PAYLOAD_PACKETS=' + str(self.payload_packets),
                'd-modem', '/tmp/slmodemd_socket_peer.py', self.remote],
                stdin=subprocess.PIPE, stdout=subprocess.PIPE,
                stderr=(self.output / 'peer-stderr.log').open('wb'), bufsize=0)
            # The driver inserts 192 startup silence samples, before processing.
            self.read_exact(384)
            self.ready = True

    def read_exact(self, count):
        data = bytearray()
        while len(data) < count:
            if not select.select([self.process.stdout], [], [], 20)[0]:
                raise TimeoutError('SmartLink audio reply')
            chunk = self.process.stdout.read(count - len(data))
            if not chunk: raise EOFError('SmartLink audio closed')
            data.extend(chunk)
        return data

    def clock(self, dsc, channel, instructions):
        self.instructions = instructions
        stream = dsc.bearer_tx[1]
        fresh = stream[self.cursor:]
        self.cursor = len(stream)
        if channel is None or not self.ready or self.ended: return
        if not self.primed:
            dsc.queue_bearer(channel, b'\xff' * 160)
            self.primed = True
        self.pending.extend(fresh)
        while len(self.pending) >= 160:
            chunk = self.pending[:160]; del self.pending[:160]
            pcm = self.up.convert([int(ulaw_to_linear(v) * self.gain) for v in chunk], 8000, 9600)
            assert len(pcm) == 192, len(pcm)
            offered = struct.pack('<192h', *pcm)
            with (self.output / 'smartlink-rx.s16le').open('ab') as f:
                f.write(offered)
            self.process.stdin.write(offered)
            try:
                reply = self.read_exact(384)
            except EOFError:
                self.ended = True
                return
            with (self.output / 'smartlink-tx.s16le').open('ab') as f: f.write(reply)
            self.received.extend(self.down.convert(list(struct.unpack('<192h', reply)), 9600, 8000))
            # Fractional floating-point boundaries can emit 161 then 159;
            # retain the extra sample, preserving the continuous time grid.
            assert len(self.received) >= 160, len(self.received)
            samples = self.received[:160]; del self.received[:160]
            dsc.queue_bearer(channel, bytes(linear_to_ulaw(v) for v in samples))
            self.blocks += 1

    def stop(self):
        if self.process and self.process.poll() is None:
            self.process.stdin.close()
            try: self.process.wait(timeout=10)
            except subprocess.TimeoutExpired: self.process.terminate(); self.process.wait()

    def status(self):
        return {'blocks': self.blocks, 'samples_8k': self.blocks * 160,
                'samples_9600': self.blocks * 192, 'receive_gain': self.gain,
                'remote_output': self.remote, 'protocol': self.protocol,
                'receive_reconstruction': self.reconstruction,
                'error_correction_requested': self.error_correction,
                'training_gain': getattr(self.up, 'training_gain', 1.0),
                'interpolation_points': getattr(self.up, 'interpolation_points', None),
                'reconstruction_clipped_samples': getattr(self.up, 'clipped_samples', None),
                'reconstruction_peak_before_clamp': getattr(self.up, 'peak_before_clamp', None)}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output', type=Path, required=True)
    parser.add_argument('--instructions', type=int, default=230_000_000)
    parser.add_argument('--protocol', choices=['v34', 'v90'], default='v34')
    parser.add_argument('--smartlink-rx-gain', type=float, default=0.25,
                        help='SmartLink input scale (d-modem uses 0.25 during handshake)')
    parser.add_argument('--smartlink-rx-reconstruction', choices=['auto', 'bandlimited', 'tower'], default='auto',
                        help='auto uses Tower sinc-to-Lagrange reconstruction for V.90')
    parser.add_argument('--capture-pc', type=lambda v: int(v, 16), default=0x9d4c)
    parser.add_argument('--data-trace', type=lambda v: int(v, 16))
    parser.add_argument('--payload-check', action='store_true')
    parser.add_argument('--payload-packets', type=int, default=150,
                        help='Packets per direction; leave time after the final packet to drain the link')
    parser.add_argument('--payload-start-delay-blocks', type=int, default=50,
                        help='20 ms blocks to wait after local CONNECT before sending data')
    parser.add_argument('--smartlink-training-gain', type=float, default=1.0,
                        help='Additional downstream gain from TRN1d onward in the Tower profile')
    parser.add_argument('--smartlink-interpolation-points', type=int, choices=[8, 12, 16, 24, 32, 64, 128], default=32,
                        help='Training-stage interpolation length; 32 is the fastest verified stable profile')
    parser.add_argument('--error-correction', action='store_true',
                        help='Require error correction on I-modem (&M5), enable SmartLink LAPM')
    parser.add_argument('--flash-nvram', type=Path,
                        help='Use a saved I-modem profile instead of factory settings')
    parser.add_argument('--imodem-initialization',
                        help='Override the initial AT command to reproduce another harness configuration')
    args = parser.parse_args()
    args.output.mkdir(parents=True, exist_ok=True)
    if (args.output / 'smartlink-tx.s16le').exists():
        parser.error('Use a fresh output directory to keep waveforms from separate calls distinct')
    subprocess.run(['ssh', 'root@tower.net.cryan.nz',
                    'docker exec -i d-modem sh -c '
                    "'cat > /tmp/slmodemd_socket_peer.py; chmod +x /tmp/slmodemd_socket_peer.py'"],
                   input=Path(__file__).with_name('slmodemd_socket_peer.py').read_bytes(), check=True)
    peer = SmartLinkPeer(args.output, args.smartlink_rx_gain, args.protocol,
                         args.smartlink_rx_reconstruction, args.payload_check, args.error_correction, args.payload_packets,
                         args.smartlink_training_gain, args.smartlink_interpolation_points)
    bri = BriNetwork(establish='terminal', media_peer=peer, call_to='7349195')
    transcript = []
    s58 = 33 if args.protocol == 'v34' else 1
    ec_config = '&M5&K0' if args.error_correction else '&M0'
    initialization = args.imodem_initialization or f'ATS58={s58}{ec_config}&B0'
    command_pump = scripted_pump([initialization, 'ATA'], after=30_000_000,
                         every=25_000_000, transcript=transcript)
    snapshots, captures, writes = [], [], []
    next_snapshot = 0
    next_capture = 0
    traced_core = None
    payload_next = None
    payload_sequence = 0
    payload_received = bytearray()
    payload_sent = []
    terminal_reply = ''
    cells = [0x006d, 0x006e, 0x006f, 0x031a, 0x0337, 0x039f,
             0x03b4, 0x03d0, 0x03d2, 0x03e8, 0x03e9, 0x088c, 0x088d,
             0x0393, 0x0394, 0x03e1, 0x03e2, 0x0323, 0x038f,
             0x03b8, 0x03ba, 0x038b, 0x03bd,
             0x03c8, 0x03c9, 0x03ca, 0x03cb, 0x03cc, 0x03cd,
             0x03a4, 0x03c5, 0x03d7, 0x039a, 0x039b,
             0xffd9, 0xffdf, 0xdcf5, 0xdcf6, 0xdcf7,
             0x031b, 0x031a, 0x0310, 0x0311, 0x0312, 0x0313,
             0x032c, 0x032d, 0x0334, 0x0336, 0x034d,
             0x03b4, 0x03d0, 0x03d2,
             0x0380, 0x0381, 0x0382, 0x03d8, 0x03d9,
             0x03ae, 0x03af, 0x03e3, 0x03e4, 0x03e5,
             0x03e6, 0x03e7, 0x03e8] + list(range(0x0270, 0x0279)) + list(range(0x0248, 0x0250))
    if args.capture_pc in (0x814d, 0x8164, 0x8155):
        cells = [0x038f, 0x0394, 0x0395, 0x039f, 0x03fd,
                 0x0be9, 0x0bea, 0x0beb, 0x0bec, 0x0bed, 0x0bf0,
                 0x0011, 0x0012, 0x0010, 0x0001, 0x038d, 0x038e,
                 0x0889, 0x03f8, 0x03f9, 0x0020, 0x0810, 0x0811] + list(range(0x010c, 0x011a))
    (args.output / 'capture-addresses.json').write_text(json.dumps(cells))
    def pump(current):
        nonlocal next_snapshot, next_capture, traced_core, payload_next, payload_sequence, terminal_reply
        if payload_next is not None:
            payload_received.extend(received(current.take_serial(), current.dte_framing()))
        previous_transcript = len(transcript)
        command_pump(current)
        if args.payload_check and payload_next is None:
            terminal_reply += ''.join(v for _, direction, v in transcript[previous_transcript:]
                                      if direction == 'received')
            if 'CONNECT ' in terminal_reply and terminal_reply.endswith('\r\n'):
                payload_next = peer.blocks + args.payload_start_delay_blocks
        if payload_next is not None and payload_sequence < args.payload_packets and peer.blocks >= payload_next:
            packet = ('IMODEM_TO_SL %06d ' % payload_sequence +
                      hashlib.sha256(str(payload_sequence).encode()).hexdigest() + '\r\n').encode()
            current.send_serial(_on_the_wire(packet, current.dte_framing()))
            payload_sent.append({'block': peer.blocks, 'hex': packet.hex()})
            payload_sequence += 1
            payload_next = peer.blocks + 50
        core = current.mailbox.core
        if core is not None and core is not traced_core:
            core.set_pc_capture(args.capture_pc, cells)
            if args.data_trace is not None:
                core.set_data_trace_filter(args.data_trace)
                core.trace_data_writes()
            traced_core = core
        # Native capture rings hold 64 entries. Drain at 2 ms, below 20
        # receiver callbacks, independently of the coarser state snapshots.
        if core and current.instructions >= next_capture:
            captures.extend(core.pc_captures()); core.clear_pc_captures()
            if args.data_trace is not None:
                writes.extend(core.data_events()); core.trace_data_writes()
            next_capture = current.instructions + 10_000
        if core and current.instructions >= next_snapshot:
            snapshots.append({'instructions': current.instructions, 'blocks': peer.blocks,
                              'state': core.state(), 'cells': {f'{a:04x}': core.data(a) for a in cells}})
            next_snapshot = current.instructions + 1_000_000
    machine = IsdnMachine(NacImage.load('Ie030002.nac'), with_dsp=True,
                          bri=bri,
                          flash_nvram=args.flash_nvram.read_bytes() if args.flash_nvram else None,
                          serial_pump=pump)
    audit = OverlayAudit(machine.mailbox)
    machine.mailbox.write = audit.write
    try:
        result = machine.run(args.instructions).to_dict()
        result.update(peer=peer.status(), transcript=transcript, overlays=audit.records)
        result['probe_configuration'] = {
            'imodem_initialization': initialization,
            'flash_nvram': str(args.flash_nvram) if args.flash_nvram else None,
        }
        result['snapshots'] = snapshots
        if machine.mailbox.core:
            captures.extend(machine.mailbox.core.pc_captures())
            for space in ['program', 'data']:
                read = getattr(machine.mailbox.core, space)
                (args.output / f'dsp-{space}.bin').write_bytes(b''.join(
                    read(a).to_bytes(2, 'little') for a in range(65536)))
        (args.output / 'detector-captures.json').write_text(json.dumps(captures))
        (args.output / 'data-writes.json').write_text(json.dumps(writes))
        (args.output / 'result.json').write_text(json.dumps(result, indent=2))
        (args.output / 'imodem-tx.g711').write_bytes(bytes(bri.media_tx))
        (args.output / 'imodem-rx.g711').write_bytes(bytes(machine.dsc.bearer_rx_heard[1]))
        (args.output / 'payload-received.bin').write_bytes(payload_received)
        (args.output / 'payload-sent.json').write_text(json.dumps(payload_sent, indent=2))
        # The external firmware keeps its active settings in segment 2600.
        # Preserve the guest's unpacked configuration for profile comparisons.
        (args.output / 'supervisor-data.bin').write_bytes(machine.machine.mem_read(0x26000, 65536))
    finally:
        peer.stop()
        machine.mailbox.close()
        if peer.process:
            for name in ['slmodemd.log', 'tty.log', 'payload-sent.jsonl']:
                remote_file = shlex.quote(peer.remote + '/' + name)
                fetched = subprocess.run(['ssh', 'root@tower.net.cryan.nz',
                                          f'docker exec d-modem cat {remote_file}'],
                                         stdout=subprocess.PIPE, stderr=subprocess.PIPE)
                if fetched.returncode == 0:
                    (args.output / name).write_bytes(fetched.stdout)


if __name__ == '__main__': main()
