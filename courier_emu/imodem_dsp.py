"""I-modem C5x endpoint: captured bootstrap, native runtime mailbox/overlays."""
from hashlib import sha256
from pathlib import Path

from .dsp import NativeC5x
from .imodem_mailbox import ImodemMailbox

# Eight-bit time slots in one peripheral-port frame. Two, because the DSP's
# serial port is in sixteen-bit word format: see _sync_pcm.
PP_SLOTS = 2
# What an unconnected slot carries, and what the part clocks when the MUX has
# nothing on that channel.
IDLE_CODEWORD = 0xff

ROM_SHA256 = '3e30fb31ac87fc9d0b8a85da245511ef3caa4e83249f56b5852d9d0829e93f67'


class ImodemDsp(ImodemMailbox):
    def __init__(self, dsc=None):
        super().__init__(self._command)
        self.core = None
        self.tx_ready = False
        self.lanes = {}
        self.boot_words = []
        self.boot_origin = None
        self.boot_status = 0xff
        self.reset_status = True
        self.host_pending = False
        self.consumed = 0
        self.download_blocks = 0
        self.bootstrap_words = 0
        self.error = None
        self._reply_writes = 0
        self.dsc = dsc
        self.pcm_tx = bytearray()
        self._pcm_cursor = 0
        self._pcm_partial = b''

    def close(self):
        if self.core is not None:
            self.core.close()
            self.core = None
        self.tx_ready = False

    def _command(self, tag, value):
        if self.core is None:
            return
        self.core.set_io(0x5e, tag)
        self.core.set_io(0x5f, value)
        self.core.set_io(0x57, self.core.io(0x57) | 1)
        self.host_pending = True
        self.tx_ready = False

    def _sync(self):
        if self.core is None:
            self.tx_ready = False
            return
        status = self.core.io(0x57)
        if self.host_pending and not status & 1:
            self.consumed += 1
            self.host_pending = False
        self.tx_ready = not bool(status & 1)
        # PA7 bit 1 is DSP room-to-send; DSP clears it to publish a reply.
        # Output-latch write evidence distinguishes startup clears from replies.
        if not status & 2 and self.rx is None:
            writes = self.core.io_port_stats([0x5f]).get('0x5f', {}).get('writes', 0)
            if writes > self._reply_writes:
                self.offer_reply(self.core.io_output(0x5e), self.core.io_output(0x5f))
                self._reply_writes = writes

    def step(self, count):
        if self.core is None or self.error is not None:
            return
        try:
            self.core.step(count)
            self._sync()
            self._sync_pcm()
        except RuntimeError as exc:
            self.error = str(exc)
            self.tx_ready = False
            raise

    def _sync_pcm(self):
        octets = self.core.g711_tx(self._pcm_cursor)
        self._pcm_cursor += len(octets)
        self.pcm_tx.extend(octets)
        if self.dsc is None or not octets:
            return
        # The serial port is in sixteen-bit word format - the firmware writes
        # SPC = 40c8, so FO is clear - and at 8 kHz that is two eight-bit
        # peripheral-port time slots per 125 us frame, MSB first. The core
        # hands them over and takes them back in that order, so a frame is a
        # pair: the first slot, then the second. An odd octet at the end of a
        # scheduler slice is half a frame and waits for its other half rather
        # than being clocked as a whole one.
        pending = self._pcm_partial + octets
        self._pcm_partial = pending[len(pending) - len(pending) % PP_SLOTS:]
        incoming = bytearray()
        slots = self.dsc.peripheral_slots(PP_SLOTS)
        for frame in range(len(pending) // PP_SLOTS):
            sent = pending[frame * PP_SLOTS:(frame + 1) * PP_SLOTS]
            # One MUX exchange per frame, whatever the slot count: B1 still
            # carries one octet per 125 us, which is what makes it 64 kbit/s.
            outputs = self.dsc.clock_bearer({
                port: octet for port, octet in zip(slots, sent) if port
            })
            incoming.extend(outputs.get(port, IDLE_CODEWORD) if port
                            else IDLE_CODEWORD for port in slots)
        if incoming:
            self.core.queue_g711_rx(bytes(incoming))

    def read(self, port):
        if port == 0x18:
            return self.boot_status
        if port == 0x1a:
            return 0xff if self.reset_status else 0
        if port == 0x1e:
            if self.reset_status:
                return 0xff
            return ((~self.core.io(0x57) >> 8) & 7) if self.core else 7
        if port == 0x1c and self.reset_status:
            return 0xff
        self._sync()
        return super().read(port)

    def write(self, port, value):
        value &= 0xffff
        if 0x40 <= port <= 0x5e and port % 2 == 0:
            self.lanes[port] = value & 0xff
        if port == 0x18:
            if value & 0xff == 0xff:
                self.close()
                self.boot_origin = self._word(0x40)
                self.boot_words = []
                self.boot_status = 0xff
                self.reset_status = True
                self.rx = None
                self.host_pending = False
            elif value in (1, 2):
                base = 0x40 if value == 1 else 0x50
                self.boot_words.extend(self._word(base + 4*i) for i in range(4))
                self.boot_status = 3
            elif value == 4:
                if self.boot_origin == 0x8000 and self.boot_words and self.core is None:
                    self._start()
                self.boot_status = 7
                self.reset_status = True  # completion bus, released by CPU bit-1 ACK
            return
        if port == 0x1e:
            if self.core and not self.reset_status:
                if value & 3:
                    base = 0x40 if value & 1 else 0x48
                    dsp_base = 0x58 if value & 1 else 0x5a
                    for i in range(2):
                        self.core.set_io(dsp_base+i, self._word(base+4*i))
                self.core.set_io(0x57, self.core.io(0x57) | ((value & 7) << 8))
                if value & 2:
                    self.download_blocks += 1
            return
        if port == 0x1c:
            if self.reset_status:
                if value == 2:
                    self.reset_status = False
                    if self.core:
                        self.core.set_io(0x57, self.core.io(0x57) | 2)
                return
            super().write(port, value)
            if value & 2 and self.core:
                self.core.set_io(0x57, self.core.io(0x57) | 2)
            return
        if port in self.LANES:
            super().write(port, value)

    def _word(self, port):
        return self.lanes.get(port, 0) | (self.lanes.get(port+2, 0) << 8)

    def _start(self):
        rom = (Path(__file__).resolve().parent.parent /
               'artifacts/dsp-onchip-rom-01/c5x-onchip-rom.bin').read_bytes()
        if sha256(rom).hexdigest() != ROM_SHA256:
            raise ValueError('recovered DSP mask ROM checksum mismatch')
        program = b''.join(word.to_bytes(2, 'little') for word in self.boot_words)
        self.core = NativeC5x.from_program(self.boot_origin, program)
        self.core.configure_host_mailbox()
        self.core.load_rom(rom)
        self.core.set_mpmc_pin(0)
        self.core.set_pc(self.boot_origin)
        # The peripheral port clocks a DS0 even when its MUX is disconnected.
        self.core.configure_digital_pcm(idle_codeword=IDLE_CODEWORD)
        self.core.configure_line_frame_interrupt(5, 0xffff)
        self.bootstrap_words = len(self.boot_words)
        self._reply_writes = 0
        self._pcm_cursor = 0
        self._pcm_partial = b''
        # The bootstrap completion bus must not expose a running mailbox
        # before resident initialization clears PA7. Wait for its first IDLE,
        # rather than delivering a command that that initialization discards.
        for _ in range(20000):
            self.core.step(1)
            if self.core.state()['idle']:
                break
        else:
            self.close()
            raise RuntimeError('DSP resident did not reach its initial IDLE')

    def status(self):
        result = super().status()
        result.update(endpoint='native-c5x', bootstrap_words=self.bootstrap_words,
                      consumed=self.consumed, download_blocks=self.download_blocks,
                      error=self.error, core=self.core.state() if self.core else None,
                      dsp_status=self.core.io(0x57) if self.core else None)
        names = {3: 'Ba', 4: 'Bb', 5: 'Bc', 6: 'Bd', 7: 'Be', 8: 'Bf'}
        slots = (self.dsc.peripheral_slots(PP_SLOTS) if self.dsc
                 else [None] * PP_SLOTS)
        result['pcm'] = {'octets': len(self.pcm_tx), 'sample_rate': 8000,
                         'frames': len(self.pcm_tx) // PP_SLOTS,
                         'slots': [names.get(port) for port in slots],
                         'attached': self.dsc is not None,
                         'serial': self.core.serial_state() if self.core else None}
        return result
