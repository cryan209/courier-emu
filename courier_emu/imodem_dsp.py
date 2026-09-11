"""I-modem C5x endpoint: captured bootstrap, native runtime mailbox/overlays."""
from hashlib import sha256
from pathlib import Path

from .dsp import NativeC5x
from .imodem_mailbox import ImodemMailbox

ROM_SHA256 = '3e30fb31ac87fc9d0b8a85da245511ef3caa4e83249f56b5852d9d0829e93f67'


class ImodemDsp(ImodemMailbox):
    def __init__(self):
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
        except RuntimeError as exc:
            self.error = str(exc)
            self.tx_ready = False
            raise

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
        # A modeled idle DS0 supplies the resident's serial receive clock.
        # Its physical routing from the Am79C30 is not yet connected.
        self.core.configure_digital_pcm(idle_codeword=0xff)
        self.core.configure_line_frame_interrupt(5, 0xffff)
        self.bootstrap_words = len(self.boot_words)
        self._reply_writes = 0
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
        return result
