"""I-modem C5x endpoint: captured bootstrap, native runtime mailbox/overlays."""
from collections import deque
from hashlib import sha256
import os
from pathlib import Path
import time

from .dsp import ImodemShared, NativeC5x
from .imodem_mailbox import ImodemMailbox
from .timebase import ASIC_DSP_CLOCK_HZ

# Eight-bit time slots in one peripheral-port frame. Two, because the DSP's
# serial port is in sixteen-bit word format: see _sync_pcm.
PP_SLOTS = 2
# What an unconnected slot carries, and what the part clocks when the MUX has
# nothing on that channel.
IDLE_CODEWORD = 0xff

# The model assumes a 40.32 MHz C51 machine clock from the ASIC. The can's
# frequency alone does not establish the ASIC output or C51 clock-mode pins;
# see docs/asic-pinout.md, "What is still unknown". Using the same figure for
# the PCM divider and pacing gives exactly 8 kHz. CPU instruction
# throughput is not a usable substitute for that clock during a live call:
# Unicorn may run faster or slower than real time, while RTP continues to
# deliver one sample every 125 us.
DIGITAL_PCM_CLOCK_HZ = ASIC_DSP_CLOCK_HZ
REALTIME_STEP_BATCH = 65_536
# Return each serial frame to the receive FIFO before the C51 can clock the
# next one. A 1024-instruction slice is shorter than a 5040-cycle PCM frame.
PCM_STEP_BATCH = 1024

# PCM frames the DSP may run between visits from the harness. Receive octets
# for the next PCM_LOOKAHEAD_FRAMES frames are fed to it ahead of time (they
# come from the DSC's B-channel queues, which only the harness fills), and its
# transmitted octets are exchanged in batches of up to PCM_BATCH_FRAMES.
# COURIER_PCM_BATCH=0 exchanges one frame at a time. The harness turns this
# on (enable_pcm_batch) only with the native port model, where the C5x runs
# between visits; it is exact: the I-modem's state matches the unbatched
# path's, bit for bit, apart from the octets held ahead.
PCM_BATCH_FRAMES = int(os.environ.get("COURIER_PCM_BATCH", "4"))
PCM_LOOKAHEAD_FRAMES = max(8, 2 * PCM_BATCH_FRAMES)

ROM_SHA256 = 'd57bc46e1bcd6d4dc8872b97bba2d98ba8fb6b8661440c566b534f0b3f82fac9'


class _LaneStore:
    """Window bytes by port, held in memory the native port model also uses."""

    def __init__(self, shared):
        self._bytes = shared.lanes

    def get(self, port, default=None):
        return self._bytes[port] if 0 <= port < len(self._bytes) else default

    def __getitem__(self, port):
        return self._bytes[port]

    def __setitem__(self, port, value):
        self._bytes[port] = value & 0xFF


def _shared_field(name, kind):
    """A mailbox attribute that lives in the shared struct (see ImodemShared)."""
    def get(self):
        return kind(getattr(self._sh, name))

    def put(self, value):
        setattr(self._sh, name, kind(value))

    return property(get, put)


class ImodemDsp(ImodemMailbox):
    pcm_batch = False
    # The DSP's stream window: the sender's port-0x60 word, high byte on 0x62.
    STREAM_PORTS = (0x60, 0x62)
    # Scalars the native port model reads and updates in place.
    tx_ready = _shared_field("tx_ready", bool)
    host_pending = _shared_field("host_pending", bool)
    consumed = _shared_field("consumed", int)
    latch_writes = _shared_field("latch_writes", int)
    _reply_writes = _shared_field("reply_writes", int)
    _pcm_cursor = _shared_field("pcm_cursor", int)
    _cycle_debt = _shared_field("cycle_debt", float)

    def __init__(self, dsc=None, *, foreground_overlay_assist=False):
        self._sh = ImodemShared()
        # The native B-channel path, once attach_native_bearer has set it up.
        self._nb = None
        self._pcm_partial_py = b''
        # Network-side halves of frames taken early and not yet finished.
        self._ahead = deque()
        self._ahead_state = None
        # The B channels carrying a call, which the harness sets as it learns
        # of one (empty: nothing is fed ahead).
        self.lookahead_channels = ()
        super().__init__(self._command)
        self.core = None
        self.tx_ready = False
        self.lanes = _LaneStore(self._sh)
        self.boot_words = []
        self.boot_origin = None
        self.boot_status = 0xff
        self.reset_status = True
        self.host_pending = False
        self.consumed = 0
        self.download_blocks = 0
        self.overlay_reads = 0
        self.overlay_writes = {1: 0, 2: 0, 4: 0}
        self.overlay_recent = []
        self.overlay_control = []
        self._call_overlay_mode = False
        # Diagnostic only: executing a guest command handler on the host is
        # not hardware emulation. The default must expose the missing native
        # dispatch transition rather than conceal it with writes to DSP RAM.
        self.foreground_overlay_assist = foreground_overlay_assist
        self.foreground_overlay_assists = 0
        self.bootstrap_words = 0
        self.error = None
        self._reply_writes = 0
        self.dsc = dsc
        self.pcm_frame_service = None
        self.pcm_tx = bytearray()
        self._pcm_cursor = 0
        self._pcm_partial = b''
        self._realtime_origin = None
        self.realtime_cycles = 0
        self._loader_started = False
        self.latch_writes = 0
        # Cycles owed to the C51 and not yet run, and its running cost per
        # instruction, which sizes each step so it does not overshoot.
        self._cycle_debt = 0.0
        self._cpi = 1.35

    # The odd octet of a frame that was split between two exchanges: native
    # memory once the native bearer is attached.
    @property
    def _pcm_partial(self):
        return self._nb.partial if self._nb is not None else self._pcm_partial_py

    @_pcm_partial.setter
    def _pcm_partial(self, value):
        if self._nb is not None:
            self._nb.partial = value
        else:
            self._pcm_partial_py = value

    def attach_native_bearer(self):
        """Run the B-channel exchange natively (see native_bearer.py).

        Only with a DSC that can keep its queues in native memory and nothing
        yet in flight; returns whether it did.
        """
        dsc = self.dsc
        if (self._nb is not None or dsc is None or self._ahead
                or len(self.pcm_tx) or self._pcm_partial
                or not hasattr(dsc, 'enable_native_bearer')):
            return False
        from .native_bearer import PCM, AheadView, NativeBearer, Stream
        bearer = NativeBearer()
        dsc.enable_native_bearer(bearer)
        self._nb = bearer
        self.pcm_tx = Stream(bearer, PCM)
        self._ahead = AheadView(bearer)
        return True

    def _publish_mode(self):
        """Tell the native path which channels carry the call and what batching is allowed."""
        self._nb.set_mode(self.lookahead_channels, self.pcm_frame_service is not None,
                          PCM_LOOKAHEAD_FRAMES if PCM_BATCH_FRAMES else 0)

    def close(self):
        if self.core is not None and self._ahead:
            # Frames the C5x finished are still owed their exchange, and what
            # was fed ahead for it was never the C5x's to consume.
            try:
                self.flush_pcm(refill=False)
            except RuntimeError:
                pass
            self.cancel_lookahead()
        if self.core is not None:
            self.core.close()
            self.core = None
        self.tx_ready = False
        # Foreground overlay ownership belongs to this DSP instance. A new
        # mask-ROM bootstrap must use the resident dispatcher even if its
        # first command is not the usual 0002:d100 recovery command.
        self._call_overlay_mode = False
        self._realtime_origin = None
        self._ahead.clear()

    def _drain_overlay(self):
        """Replay the 0x1e accesses the native port model served into the logs.

        They are replayed in order before anything else touches the logs, so
        the logs read as though every access had come through `read`/`write`.
        """
        sh = self._sh
        count = sh.ov_len
        if not count:
            return
        log = bytes(sh.ov_log[:count])
        sh.ov_len = 0
        recent, control = self.overlay_recent, self.overlay_control
        for entry in log:
            value = entry & 7
            if entry & 8:
                if value in self.overlay_writes:
                    self.overlay_writes[value] += 1
                    if len(control) >= 32:
                        control.pop(0)
                    control.append(("strobe", value))
                if len(recent) >= 32:
                    recent.pop(0)
                recent.append(("write", value))
                if value & 2:
                    self.download_blocks += 1
            else:
                self.overlay_reads += 1
                if len(recent) >= 32:
                    recent.pop(0)
                recent.append(("read", value))

    def _command(self, tag, value):
        if self.core is None:
            return
        self._drain_overlay()
        # Image 6 is the first call-time overlay in every supported I-modem
        # build and is loaded at a000. Startup's image 10/11 destinations are
        # d100/9260 and continue through the ordinary idle dispatcher.
        if tag == 2 and value == 0xA000:
            self._call_overlay_mode = True
        elif tag == 2 and value == 0xD100:
            # A failed call reloads the startup pair. Let the resident handle
            # those commands again after reset, rather than retaining the
            # foreground call-overlay shortcut across a new bootstrap.
            self._call_overlay_mode = False
        active_overlay_request = (self.foreground_overlay_assist
                                  and tag == 2 and self._call_overlay_mode)
        if tag == 2:
            self.overlay_control.append(("command", value,
                                         int(active_overlay_request)))
        self.core.set_io(0x5e, tag)
        self.core.set_io(0x5f, value)
        self.core.set_io(0x57, self.core.io(0x57) | 1)
        # Historical diagnostic bypass for the formerly stalled foreground
        # handoff: reproduce command 2's handler (840f..8414) on the host.
        # Current native runs execute the handoff successfully without this
        # bypass. Keep it explicitly opt-in for comparing older traces, never
        # as part of the default hardware/mailbox path.
        if active_overlay_request:
            self.foreground_overlay_assists += 1
            self.core.set_data(0x0BFF, value)
            # The supervisor strobes bit 10 *before* sending command 2 and
            # waits for it to clear before publishing any overlay words.
            # Match 8411..8413's acknowledgement of all three download bits,
            # as well as the command-consumed bit. Clearing only bit 0 leaves
            # the CPU stuck at b1545 until its two-second reload timeout.
            self.core.set_io(0x57, self.core.io(0x57) & ~0x0701)
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
            while count > 0:
                batch = min(count, PCM_STEP_BATCH)
                self.core.step(batch)
                self._sync()
                self._sync_pcm()
                count -= batch
        except RuntimeError as exc:
            self.error = str(exc)
            self.tx_ready = False
            raise

    def step_cycles(self, cycles):
        """Run the C51 for the clock cycles it is owed, not an instruction count.

        Its PCM highway and timers run on cycles, and an instruction costs one
        to dozens of them, so stepping instructions ran the B channel's 8 kHz
        fast against the 386 by whatever the DSP's load made its CPI.
        """
        if self.core is None or self.error is not None:
            self._cycle_debt = 0.0
            return
        sh = self._sh
        sh.cycle_debt += cycles
        if sh.cycle_debt < 1:
            return
        core = self.core
        native_step_cycles = getattr(core, 'step_cycles', None)
        if native_step_cycles is not None:
            native_advance = getattr(core, 'advance_imodem', None)
            if native_advance is not None:
                ran = elapsed = 0
                remaining = int(sh.cycle_debt)
                sync_values = self._sync_values
                while remaining > 0:
                    done, spent, status, tag, value, writes, octets = native_advance(
                        remaining, sh.pcm_cursor)
                    sync_values(status, tag, value, writes)
                    if octets:
                        self._sync_pcm(octets)
                    ran += done
                    elapsed += spent
                    remaining -= spent
            else:
                ran, elapsed = native_step_cycles(int(self._cycle_debt))
                self._sync()
                self._sync_pcm()
            sh.cycle_debt -= elapsed
            if ran > 0:
                self._cpi = 0.9 * self._cpi + 0.1 * max(1.0, elapsed / ran)
            return
        state = self.core.state()
        start_cycles, start_instructions = state['cycles'], state['instructions']
        target = start_cycles + int(self._cycle_debt)
        current = start_cycles
        while current < target and self.core is not None and self.error is None:
            self.step(max(1, int((target - current) / self._cpi)))
            if self.core is None:
                break
            state = self.core.state()
            current = state['cycles']
        self._cycle_debt -= current - start_cycles
        ran = state['instructions'] - start_instructions
        if ran > 0:
            self._cpi = 0.9 * self._cpi + 0.1 * max(
                1.0, (current - start_cycles) / ran)

    def service_pending(self):
        """Do what the harness owes after the native port model stopped.

        The model runs the C5x the way `step_cycles` does and stops where
        that loop would have called into the harness - a finished PCM frame,
        or a reply to offer - leaving the rest of the owed cycles in the
        ledger. This performs those calls and carries on with the remainder.
        """
        sh = self._sh
        sh.needs_service = 0
        core = self.core
        if core is None or self.error is not None:
            return
        status, tag, value, writes, octets = core.imodem_collect(
            sh.pcm_cursor, sh.tx_pending)
        if not status & 2 and self.rx is None and writes > sh.reply_writes:
            # Offering the reply stamps the timeline, which exchanges the
            # frames waiting: the octets are taken only after that.
            self._sync_values(status, tag, value, writes)
            octets = self._take_octets(core, sh)
        else:
            sh.tx_pending = 0
            self._sync_values(status, tag, value, writes)
        if octets:
            if self._ahead and not self._lookahead_valid():
                self.cancel_lookahead()
            self._sync_pcm(octets)
        self.prefeed()
        self.step_cycles(0)

    def resume_service(self):
        """Carry on a service pass the native port model began, from where it stopped.

        The model ran the C5x owed cycles frame by frame and met something it
        leaves to Python - a reply to offer, or frames it cannot settle from
        what was fed ahead - after the run and before taking its results, so
        this takes them and runs what is still owed.
        """
        core = self.core
        if core is None or self.error is not None:
            return
        sh = self._sh
        status, tag, value, writes, octets = core.imodem_collect(sh.pcm_cursor, 0)
        self._sync_values(status, tag, value, writes)
        if octets:
            self._sync_pcm(octets)
        self.step_cycles(0)

    def pace_realtime(self, active, now=None, *, max_wall_seconds=None):
        """Advance the digital PCM clock against monotonic wall time.

        The ordinary harness couples C51 progress to 386 instructions.  That
        remains useful and deterministic for offline runs.  A live SIP bearer
        is different: its far end has an independent 8 kHz clock, so while the
        B channel is active we advance the modeled C51 clock at 40.32 MHz
        directly from elapsed wall time.  This keeps both directions at one
        codeword per 125 us. The supervisor peripheral clock follows the same
        wall time during live calls (see IsdnMachine._peripheral_instructions).
        """
        if not active or self.core is None:
            self._realtime_origin = None
            return
        current_time = time.monotonic() if now is None else float(now)
        cycles = self.core.state()['cycles']
        if self._realtime_origin is None:
            self._realtime_origin = (current_time, cycles)
            return
        origin_time, origin_cycles = self._realtime_origin
        target = origin_cycles + int(
            max(0.0, current_time - origin_time) * DIGITAL_PCM_CLOCK_HZ
        )
        # A delayed host must not monopolize the scheduler catching up the
        # DSP while the supervisor's timer edges collapse into one PIC bit.
        # Leave the absolute cycle target intact for the next CPU slice.
        deadline = (time.monotonic() + max_wall_seconds
                    if max_wall_seconds is not None else None)
        native_step_cycles = getattr(self.core, 'step_cycles', None)
        if cycles < target and native_step_cycles is not None:
            native_advance = getattr(self.core, 'advance_imodem', None)
            if native_advance is not None:
                elapsed = 0
                while cycles < target:
                    _, spent, status, tag, value, writes, octets = native_advance(
                        target - cycles, self._pcm_cursor)
                    self._sync_values(status, tag, value, writes)
                    if octets:
                        self._sync_pcm(octets)
                    cycles += spent
                    elapsed += spent
                    if deadline is not None and time.monotonic() >= deadline:
                        break
            else:
                _, elapsed = native_step_cycles(target - cycles)
                self._sync()
                self._sync_pcm()
            self.realtime_cycles += elapsed
            return
        while cycles < target:
            # Every instruction consumes at least one C5x cycle.  Limiting a
            # batch to the remaining cycle deficit prevents a large burst
            # from running materially ahead of the RTP clock; the final few
            # instructions close any difference caused by multi-cycle ops.
            count = min(REALTIME_STEP_BATCH, target - cycles)
            self.step(max(1, count))
            new_cycles = self.core.state()['cycles']
            self.realtime_cycles += new_cycles - cycles
            cycles = new_cycles
            if deadline is not None and time.monotonic() >= deadline:
                break

    def _sync_values(self, status, tag, value, writes):
        sh = self._sh
        if sh.host_pending and not status & 1:
            sh.consumed += 1
            sh.host_pending = 0
        sh.tx_ready = 0 if status & 1 else 1
        if not status & 2 and self.rx is None and writes > sh.reply_writes:
            self.offer_reply(tag, value)
            sh.reply_writes = writes

    def _sync_pcm(self, octets=None):
        sh = self._sh
        if octets is None:
            octets = self.core.g711_tx(sh.pcm_cursor)
        sh.tx_pending = 0
        sh.pcm_cursor += len(octets)
        nb = self._nb
        if nb is not None and octets:
            # Every frame the native path can settle is settled there, and its
            # octets recorded; what it leaves - from a frame it does not keep
            # the books for - is done below.
            self._publish_mode()
            pending = nb.exchange(self.core.handle, octets)
            if not pending:
                return
            self._pcm_partial = pending[len(pending) - len(pending) % PP_SLOTS:]
        else:
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
        dsc = self.dsc
        slots = dsc.peripheral_slots(PP_SLOTS)
        ahead = self._ahead
        frames = len(pending) // PP_SLOTS
        if (nb is None and ahead and frames and len(ahead) >= frames
                and self.pcm_frame_service is None):
            # Several frames whose network side was settled early: finish them
            # in one go if the routing allows.
            entries = [ahead[index] for index in range(frames)]
            if dsc.bearer_finish_batch(
                    entries, pending[:frames * PP_SLOTS], slots, IDLE_CODEWORD):
                for _ in range(frames):
                    ahead.popleft()
                return
        for frame in range(frames):
            sent = pending[frame * PP_SLOTS:(frame + 1) * PP_SLOTS]
            peripheral = {port: octet for port, octet in zip(slots, sent) if port}
            if ahead:
                # The network side of this frame was settled earlier, and its
                # receive octets are already queued in the core.
                dsc.bearer_finish_frame(ahead.popleft(), peripheral)
            else:
                # One MUX exchange per frame, whatever the slot count: B1 still
                # carries one octet per 125 us, which is what makes it 64 kbit/s.
                outputs = dsc.clock_bearer(peripheral)
                incoming.extend(outputs.get(port, IDLE_CODEWORD) if port
                                else IDLE_CODEWORD for port in slots)
            if self.pcm_frame_service is not None:
                self.pcm_frame_service()
        if incoming:
            self.core.queue_g711_rx(bytes(incoming))

    def enable_pcm_batch(self):
        """Let the C5x run several PCM frames between visits (see PCM_BATCH_FRAMES)."""
        if PCM_BATCH_FRAMES:
            self.pcm_batch = True
            self._sh.flush_octets = PP_SLOTS * PCM_BATCH_FRAMES

    def _lookahead_valid(self):
        """Whether frames fed ahead were settled under the DSC's current state."""
        if not self._ahead:
            return True
        if self._nb is not None:
            self._publish_mode()
            return self._nb.lookahead_valid()
        dsc = self.dsc
        return self._ahead_state == dsc.bearer_state(self.lookahead_channels)

    def prefeed(self):
        """Keep the core's receive queue fed a few frames ahead (see PCM_BATCH_FRAMES)."""
        if not PCM_BATCH_FRAMES or self.dsc is None or self.core is None:
            return
        if self._nb is not None:
            self._publish_mode()
            self._nb.prefeed(self.core.handle)
            return
        if self._ahead and not self._lookahead_valid():
            self.cancel_lookahead()
        want = PCM_LOOKAHEAD_FRAMES - len(self._ahead)
        if want * 2 < PCM_LOOKAHEAD_FRAMES:
            return
        dsc = self.dsc
        state = dsc.bearer_state(self.lookahead_channels)
        entries, octets = dsc.bearer_take_ahead(
            dsc.peripheral_slots(PP_SLOTS), want, self.lookahead_channels)
        if entries:
            self._ahead.extend(entries)
            self._ahead_state = state
            self.core.queue_g711_rx(octets)

    @staticmethod
    def _take_octets(core, sh):
        """The octets the C5x has transmitted that have not been exchanged.

        The native model publishes how many are waiting, so the usual case is
        one native call; the count is only a hint and anything else falls back
        to asking the core.
        """
        waiting = sh.tx_pending
        sh.tx_pending = 0
        return core.imodem_collect(sh.pcm_cursor, waiting)[4]

    def flush_pcm(self, refill=True):
        """Exchange every transmitted frame the C5x has finished, then refill."""
        core = self.core
        if core is None or self.error is not None:
            return
        sh = self._sh
        octets = self._take_octets(core, sh)
        if octets:
            if self._ahead and not self._lookahead_valid():
                self.cancel_lookahead()
            self._sync_pcm(octets)
        if refill:
            self.prefeed()

    def cancel_lookahead(self):
        """Hand back receive octets fed ahead, before the MUX's routing changes."""
        ahead = self._ahead
        if not ahead:
            return
        if self._nb is not None:
            self._nb.cancel(self.core.handle if self.core is not None else None)
            return
        if self.core is not None:
            self.core.drop_g711_rx_tail(PP_SLOTS * len(ahead))
        self.dsc.bearer_return_ahead(list(ahead))
        ahead.clear()

    def read(self, port):
        if self.core and not self.reset_status and not self._loader_started:
            status = self.core.io(0x56)
            if port == 0x18:
                # Bit 7 is a word from the stream sender at 0x8980, which
                # clears PA6 bit 7 as it writes port 0x60; the ISR at b4992
                # tests it before the collector at [c9f9] reads 0x62/0x60.
                return 0x40 | (~status & 0xbf)
            if port == 0x1a:
                return 0xc0 | (~(status >> 8) & 0x3f)
            if port in self.STREAM_PORTS:
                word = self.core.io_output(0x60)
                return (word >> (8 if port == 0x62 else 0)) & 0xff
            if 0x40 <= port < 0x58 and port % 2 == 0:
                offset = port - 0x40
                word = self.core.io_output(0x58 + offset // 4)
                return (word >> (8 if offset & 2 else 0)) & 0xff
        if port == 0x18:
            return self.boot_status
        if port == 0x1a:
            return 0xff if self.reset_status else 0
        if port == 0x1e:
            if self.reset_status:
                return 0xff
            self._drain_overlay()
            result = ((~self.core.io(0x57) >> 8) & 7) if self.core else 7
            self.overlay_reads += 1
            if len(self.overlay_recent) >= 32:
                self.overlay_recent.pop(0)
            self.overlay_recent.append(("read", result))
            return result
        if port == 0x1c and self.reset_status:
            return 0xff
        self._sync()
        return super().read(port)

    def write(self, port, value):
        value &= 0xffff
        if 0x40 <= port <= 0x5e and port % 2 == 0:
            self.lanes[port] = value & 0xff
        if (self.core and not self.reset_status and not self._loader_started
                and port in (0x18, 0x1a) and not (port == 0x18 and value == 0xff)):
            # Six directional holding registers share the boot download
            # window. PA6 low bits mean an incoming word is occupied; high
            # bits mean the corresponding outgoing word has been taken.
            bits = value & 0x3f
            if port == 0x18:
                # 0x80 acknowledges a stream word: PA6 bit 7 is what the
                # resume poll at 0x894a waits on before sending the next.
                bits |= value & 0x80
                for bank in range(6):
                    if bits & (1 << bank):
                        self.core.set_io(0x58 + bank, self._word(0x40 + 4 * bank))
            else:
                bits <<= 8
            self.core.set_io(0x56, self.core.io(0x56) | bits)
            self.latch_writes += 1
            return
        if port == 0x18:
            if not self._loader_started and value & 0xff != 0xff:
                # Keep the completion latch until the CPU releases reset
                # status with port 1c bit 1; the runtime banks open after it.
                if self.core is not None:
                    self.core.set_io(0x56, value & 0xff)
                self.latch_writes += 1
                return
            if value & 0xff == 0xff:
                self.boot_origin = self._word(0x40)
                self.boot_words = []
                self._begin_boot()
                self.boot_status = 0xff
                self.reset_status = True
                self.rx = None
                self.host_pending = False
            elif value in (1, 2):
                base = 0x40 if value == 1 else 0x50
                self._commit_boot_group(value, base)
                self.bootstrap_words += 4
                self.boot_status = 3
            elif value == 4:
                self._commit_boot_group(value, None)
                self._finish_boot()
                self.boot_status = 7
                self.reset_status = True  # completion bus, released by CPU bit-1 ACK
            return
        if port == 0x1e:
            if self.core and not self.reset_status:
                self._drain_overlay()
                masked = value & 7
                if masked in self.overlay_writes:
                    self.overlay_writes[masked] += 1
                    if len(self.overlay_control) >= 32:
                        self.overlay_control.pop(0)
                    self.overlay_control.append(("strobe", masked))
                if len(self.overlay_recent) >= 32:
                    self.overlay_recent.pop(0)
                self.overlay_recent.append(("write", masked))
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
                if value & 2:
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

    def _begin_boot(self):
        self.close()
        rom = (Path(__file__).resolve().parent.parent /
               'artifacts/dsp-onchip-rom-20mhz-8k/c5x-onchip-rom-8k.bin').read_bytes()
        if sha256(rom).hexdigest() != ROM_SHA256:
            raise ValueError('recovered DSP mask ROM checksum mismatch')
        self.core = NativeC5x.from_program(0, b'')
        self.core.configure_rom_codec()
        self.core.load_rom(rom)
        self.core.set_mpmc_pin(0)
        self.core.reset()
        for _ in range(64):
            self.core.step(1)
        # The core's reset fills every ASIC register with all ones, which is
        # the right default for a window the CPU has not written. @56 is not
        # one: it is the download handshake the loader polls at 0638, and bit
        # 2 of it is the finish strobe. Left at ones the loader reads "done"
        # on its first poll, takes the 0651 exit, and is out of the download
        # loop before the CPU has strobed a single group. No strobe latch
        # comes out of reset asserted, so the register starts clear.
        self.core.set_io(0x56, 0)
        self.core.set_io(0x58, self.boot_origin)
        self.core.nmi()
        for _ in range(4096):
            if self.core.state()['pc'] in (0x0638, 0x0639, 0x063b):
                break
            self.core.step(1)
        else:
            raise RuntimeError('C51 ROM loader did not reach its ASIC poll')
        self.bootstrap_words = 0
        self._loader_started = True

    def _commit_boot_group(self, strobe, base):
        if self.core is None or not self._loader_started:
            raise RuntimeError('DSP download strobe without ASIC reset command')
        before = self.core.io_port_stats([0x56])['0x56']['writes']
        if base is not None:
            # The two CPU-facing windows form one contiguous DSP-side ASIC
            # bank.  The mask-ROM loader consumes 58..5b for strobe 1 and,
            # without rewinding AR6, 5c..5f for strobe 2.
            dsp_base = 0x58 + 4 * (strobe - 1)
            for index in range(4):
                self.core.set_io(dsp_base + index, self._word(base + 4*index))
        self.core.set_io(0x56, strobe)
        for _ in range(4096):
            self.core.step(1)
            if self.core.io_port_stats([0x56])['0x56']['writes'] > before:
                return
        state = self.core.state()
        raise RuntimeError(
            f'C51 ROM loader did not acknowledge strobe {strobe} '
            f'(pc {state["pc"]:04x}, idle {state["idle"]}, '
            f'@56 {self.core.io(0x56):04x}, cycles {state["cycles"]}, '
            f'instructions {state["instructions"]}, '
            f'bootstrap words {self.bootstrap_words})')

    def _finish_boot(self):
        # The completion strobe closes the download; later 18h writes are
        # the latch, not the loader's.
        self._loader_started = False
        self.core.configure_rom_codec(False)
        self.core.configure_host_mailbox()
        # The peripheral port clocks a DS0 even when its MUX is disconnected.
        self.core.configure_digital_pcm(
            idle_codeword=IDLE_CODEWORD, clock_hz=DIGITAL_PCM_CLOCK_HZ)
        # The first serial interrupt arrives before any transmit frame can be
        # observed and returned by _sync_pcm.
        self.core.queue_g711_rx(bytes((IDLE_CODEWORD,)) * PP_SLOTS)
        self.core.configure_line_frame_interrupt(5, 0xffff)
        self._reply_writes = 0
        self._pcm_cursor = 0
        self._pcm_partial = b''
        self._ahead.clear()
        self._realtime_origin = None
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
        self._drain_overlay()
        result = super().status()
        result.update(endpoint='native-c5x', bootstrap_words=self.bootstrap_words,
                      consumed=self.consumed, download_blocks=self.download_blocks,
                      overlay_reads=self.overlay_reads,
                      overlay_writes=self.overlay_writes,
                      overlay_recent=self.overlay_recent,
                      overlay_control=self.overlay_control,
                      foreground_overlay_assist=self.foreground_overlay_assist,
                      foreground_overlay_assists=self.foreground_overlay_assists,
                      latch_writes=self.latch_writes,
                      error=self.error, core=self.core.state() if self.core else None,
                      memory_map=self.core.memory_map() if self.core else None,
                      core_stack=self.core.stack() if self.core else None,
                      dsp_status=self.core.io(0x57) if self.core else None)
        names = {3: 'Ba', 4: 'Bb', 5: 'Bc', 6: 'Bd', 7: 'Be', 8: 'Bf'}
        slots = (self.dsc.peripheral_slots(PP_SLOTS) if self.dsc
                 else [None] * PP_SLOTS)
        result['pcm'] = {'octets': len(self.pcm_tx), 'sample_rate': 8000,
                         'frames': len(self.pcm_tx) // PP_SLOTS,
                         'slots': [names.get(port) for port in slots],
                         'attached': self.dsc is not None,
                         'realtime_cycles': self.realtime_cycles,
                         'rx_empty_frames': (self.core.g711_rx_underruns()
                                             if self.core else None),
                         'rx_pending_octets': (self.core.g711_rx_pending()
                                               if self.core else None),
                         'serial': self.core.serial_state() if self.core else None}
        return result
