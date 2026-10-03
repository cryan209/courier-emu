"""3453C host interface, driven by the recovered ROM and resident instructions.

The first loader writes data RAM, which aliases external program RAM at
1000..7FFF. No payload words are installed by this transport: the DSP's IN
instructions do that. Runtime uses the same ASIC at DSP I/O 8057..805F.
"""
from . import boot_rom

class Board3453:

    def __init__(self, bridge):
        self.bridge = bridge
        self.started = False
        self.destination = bridge.image.dsp_program_segments()[0][0]
        self.entry = self.destination
        self.groups = 0
        self.words_verified = 0
        self.finished = False
        self.header = 0
        self.word = 0
        self.overlay_pending = False
        self.overlay_mark = 0
        self.overlay_groups = 0
        self.core.configure_host_mailbox()
        self.core.configure_si3034_codec()
        self.core.set_host_io_base(0x8000)
        self.core.library.courier_c5x_set_shared_window(self.core.handle, 0x1000, 0x7fff)
        self.core.load_rom(boot_rom.mask_rom_3453c())
        self.core.set_mpmc_pin(0)
        self.core.load_program(bytes(len(bridge.expected_bootstrap)), self.destination)
        self.core.set_io(0x57, 0)
        self.core.set_pc(0)

    @property
    def core(self):
        return self.bridge.core

    def reset(self):
        self.started = False
        self.finished = False
        self.groups = 0
        self.overlay_pending = False
        self.overlay_groups = 0
        self.destination = self.bridge._download_destination
        self.entry = self.destination
        self.core.set_io(0x57, 0)

    def start(self):
        if self.started:
            return
        self.core.set_io(0x58, self.entry)
        for _ in range(0x1000):
            if self.core.state()['pc'] == 0xf61:
                break
            self.core.step(1)
        else:
            raise RuntimeError(f'3453C ROM did not reach loader: {self.core.state()}')
        self.started = True

    def commit(self, finish=False):
        self.start()
        b = self.bridge
        core = self.core
        payload = bytes(b.window)
        if not finish:
            for n in range(4):
                core.set_io(0x58 + n, int.from_bytes(payload[2 * n:2 * n + 2], 'little'))
        before = core.io_port_stats([0x57]).get('0x57', {}).get('writes', 0)
        core.set_io(0x57, core.io(0x57) | (0x200 if finish else 0x100))
        for _ in range(0x1000):
            core.step(1)
            if core.io_port_stats([0x57]).get('0x57', {}).get('writes', 0) > before:
                break
        else:
            raise RuntimeError('3453C DSP loader failed to acknowledge')
        if finish:
            self.finished = True
            b.launched = True
            if b.bootstraps:
                b.active = True
            # The DSP executes BACC; the host does not install an entry PC.
            for _ in range(16):
                if core.state()['pc'] == self.entry:
                    break
                core.step(1)
            else:
                raise RuntimeError('3453C ROM did not enter downloaded resident')
            core.set_io(0x57, 6)
            b._runtime_mode = True
            b._runtime_ready = True
            return
        installed = b''.join((core.program(self.destination + n).to_bytes(2, 'little') for n in range(4)))
        if installed != payload:
            raise RuntimeError(f'3453C ROM download mismatch at {self.destination:04X}')
        self.words_verified += 4
        self.destination += 4
        self.groups += 1
        b.bootstrap.extend(payload)
        b.transfer_commands += 1
        if len(b.bootstrap) >= b.bootstrap_target_size:
            b.bootstrap_match = b.bootstrap[:b.bootstrap_target_size] == b.expected_bootstrap
            if not b.bootstrap_match:
                raise RuntimeError('3453C resident differs from transfer')
            b.active = True
            b.bootstraps += 1
            b._last_bootstrap_bytes = len(b.bootstrap)
            b._last_bootstrap_match = True

    def overlay_commit(self):
        core = self.core
        b = self.bridge
        destination = core.register(0x1f)
        payload = bytes(b.window)
        for n in range(4):
            core.set_io(0x58 + n, int.from_bytes(payload[2 * n:2 * n + 2], 'little'))
        before = core.io_port_stats([0x57]).get('0x57', {}).get('writes', 0)
        core.set_io(0x57, core.io(0x57) | 0x200)
        core.interrupt(1)
        for _ in range(20000):
            core.step(1)
            stats = core.io_port_stats([0x57]).get('0x57', {})
            if stats.get('writes', 0) > before and stats.get('last_write') == 0x300:
                break
        else:
            raise RuntimeError(f"3453C overlay did not acknowledge at {destination:04X}, PC={core.state()['pc']:04X}")
        # The loader restores BMAR from its saved pointer at 1158, then
        # records the completed transfer's end in 7F62 at 116B. Foreground
        # code can use BMAR meanwhile, so its pre-interrupt value is unrelated.
        destination = (core.data(0x7f62) - 4) & 0xffff
        actual = b''.join(core.program((destination + n) & 0xffff).to_bytes(2, 'little')
                          for n in range(4))
        if actual != payload:
            raise RuntimeError(f'3453C overlay mismatch at {destination:04X}')
        self.overlay_groups += 1
        b.overlay_words_verified += 4

    def write(self, port, size, value, pc=None):
        b = self.bridge
        value &= 0xff
        if port in b._lanes:
            _, lane = b._lanes[port]
            b.window[lane] = value
            return
        if port == 0x1e:
            if value == 1 and (not self.finished):
                self.commit()
            elif value == 2 and (not self.finished):
                self.commit(finish=True)
            elif self.finished and value == 4:
                if self.overlay_groups:
                    self.overlay_groups = 0
                else:
                    self.overlay_pending = True
                    self.overlay_mark = self.core.data_write_count(0x7f62)
            elif self.finished and value == 2:
                self.overlay_commit()
            return
        if port in (0x58, 0x5a):
            shift = 8 if port == 0x5a else 0
            self.header = self.header & ~(0xff << shift) | value << shift
            return
        if port in (0x5c, 0x5e):
            shift = 8 if port == 0x5e else 0
            self.word = self.word & ~(0xff << shift) | value << shift
            return
        if port == 0x1c and self.finished:
            status = self.core.io(0x57)
            if value & 2:
                if b._runtime_inbound:
                    b._runtime_inbound.popleft()
                self.core.set_io(0x57, status | 2)
                status |= 2
            if value & 1:
                self.core.set_io(0x5e, self.header)
                self.core.set_io(0x5f, self.word)
                self.core.set_io(0x57, status | 1)
                b._record_runtime_message((self.header, self.word), pc)
                b.host_messages_delivered += 1

    def read(self, port, size):
        b = self.bridge
        if not self.finished and port in (0x1c, 0x1e):
            return (1 << size * 8) - 1
        if port == 0x1e:
            if self.overlay_pending:
                if self.core.data_write_count(0x7f62) == self.overlay_mark:
                    return 3
                self.overlay_pending = False
            return 7
        if port == 0x1c:
            status = self.core.io(0x57)
            return (0 if status & 1 else 1) | (2 if b._runtime_inbound or not status & 2 else 0)
        if port in (0x58, 0x5a, 0x5c, 0x5e):
            if b._runtime_inbound:
                tag, word = b._runtime_inbound[0]
            else:
                tag, word = (self.core.io_output(0x5e), self.core.io_output(0x5f))
            data = tag if port in (0x58, 0x5a) else word
            return data >> (8 if port in (0x5a, 0x5e) else 0) & 0xff
        return None
