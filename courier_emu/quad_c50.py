"""The Quad's CPU-side link to its C50 datapumps.

The supervisor at `0xcec04` resets the DSP, sends a command word, and streams a
program image to it. Decoded from QF060003:

* Eight 16-bit lanes at ports `0xc0, 0xc4, ... 0xdc`, each split low byte at the
  port and high byte at the port + 2. `0xcec3f` initialises all eight with
  `0x0083`; the transfer loops use four at a time.
* `[0x9d38]` selects the lane group - `0xc0` for the path at `0xced05`, `0xd0`
  for the one at `0xced12` - and `[0x9d37]` is that group's strobe value, 1 or 2.
* After each four-word burst the CPU writes the strobe to `0x98` and spins at
  `0xced9e` until `test [0x9d37], al` on a read of `0x98` is non-zero.
* The final word comes from `[0x9d3a]`, strobed with 4 and acknowledged on bit 2
  at `0xcee12`.
* `0xcec72` writes `0xffff` to `0x98`/`0x9a` and `0x9c`/`0x9e` and then polls
  both pairs until they read `0xffff` back, which is the reset presence check.

This module is deliberately a **passive tap** for now. It is fed from a run's
own I/O event log rather than wired into the machine's port handlers, so it
cannot change a single cycle of timing, and it reassembles the streamed words so
the images the Quad actually ships to its datapumps can be compared against the
load table in docs/quad-c50-overlay-loader.md before anything drives the return
path. Wiring the read side into `CourierMachine` is the step that comes with
making it answer, not before.

Nothing here executes the captured image or answers on the DSP's behalf. The
CPU already believes every transfer succeeds - `0xced12` returns carry-clear on
all 24 loads in a 12M-instruction run - because the unmodelled `0x98` floats
high and reads as ready. Making the link answer honestly means running the
image on the C5x core, and that is not what this does.
"""
from __future__ import annotations

from dataclasses import dataclass, field

# Eight lanes, four ports apart, low byte at the port and high byte at +2.
LANE_BASE = 0xC0
LANE_COUNT = 8
LANE_STRIDE = 4
LANE_PORTS = tuple(LANE_BASE + LANE_STRIDE * index for index in range(LANE_COUNT))

# Status and strobe. 0x98 carries the per-group ready bits the transfer loop
# waits on; the reset check reads 0x98/0x9a and 0x9c/0x9e as word pairs.
STATUS_PORT = 0x98
STATUS_PORTS = (0x98, 0x9A, 0x9C, 0x9E)


@dataclass
class QuadC50Transfer:
    """One strobed burst: the lane group and the words the CPU placed in it."""

    strobe: int
    words: tuple[int, ...]


@dataclass
class QuadC50Link:
    lanes: dict[int, int] = field(default_factory=dict)
    transfers: list[QuadC50Transfer] = field(default_factory=list)
    words: list[int] = field(default_factory=list)
    strobes: dict[int, int] = field(default_factory=dict)
    status_writes: list[int] = field(default_factory=list)
    resets: int = 0
    max_transfers: int = 200_000

    @classmethod
    def from_io_events(cls, events) -> "QuadC50Link":
        """Reassemble the stream from a completed run's recorded port writes."""
        link = cls()
        for event in events:
            if event.direction == "out":
                link.write(event.port, event.size, event.value)
        return link

    def write(self, port: int, size: int, value: int) -> bool:
        if port in self.lanes_low:
            self.lanes[port] = (self.lanes.get(port, 0) & 0xFF00) | (value & 0xFF)
            return False
        if port in self.lanes_high:
            base = port - 2
            self.lanes[base] = (self.lanes.get(base, 0) & 0x00FF) | ((value & 0xFF) << 8)
            return False
        if port == STATUS_PORT:
            self._strobe(value & 0xFF)
            return False
        if port in STATUS_PORTS:
            self.status_writes.append(value & 0xFFFF)
            return False
        return False

    @property
    def lanes_low(self) -> tuple[int, ...]:
        return LANE_PORTS

    @property
    def lanes_high(self) -> tuple[int, ...]:
        return tuple(port + 2 for port in LANE_PORTS)

    def _strobe(self, value: int) -> None:
        self.strobes[value] = self.strobes.get(value, 0) + 1
        if value == 0xFF:
            # 0xcec97's presence write, not a burst.
            self.resets += 1
            self.lanes.clear()
            return
        group = LANE_BASE if value & 1 else (LANE_BASE + 0x10 if value & 2 else None)
        if group is None:
            return
        ports = [group + LANE_STRIDE * index for index in range(4)]
        words = tuple(self.lanes.get(port, 0) for port in ports)
        if len(self.transfers) < self.max_transfers:
            self.transfers.append(QuadC50Transfer(value, words))
            self.words.extend(words)
        for port in ports:
            self.lanes.pop(port, None)

    def status(self) -> dict[str, object]:
        return {
            "transfers": len(self.transfers),
            "words": len(self.words),
            "strobes": dict(sorted(self.strobes.items())),
            "resets": self.resets,
            "status_writes": len(self.status_writes),
        }

    def image(self) -> bytes:
        """The streamed words, little-endian, in the order the CPU sent them."""
        return b"".join(word.to_bytes(2, "little") for word in self.words)


# The DSP-side host link. `docs/quad-c50-overlay-loader.md` identifies MMR 0x57
# as the status/request register the resident's fetch stub polls and 0x58 as the
# word-fetch port it pulls program words through.
DSP_STATUS_MMR = 0x57
DSP_FETCH_MMR = 0x58
# The stub at 0x23f1 is one `lamm *` with ar1 auto-incrementing, so it walks a
# five-word window from 0x57: the status word and four data words. Four is the
# CPU's burst size, and the lanes correspond one for one - 0xc0 to 0x58, 0xc4 to
# 0x59, 0xc8 to 0x5a, 0xcc to 0x5b.
DSP_WINDOW = (0x58, 0x59, 0x5A, 0x5B)

# The resident's origin, from the load table: source paragraph 0x2000, length
# 0xf450, destination 0x8000. The captured stream spans 0x8000..0xfa28.
RESIDENT_ORIGIN = 0x8000
RESIDENT_WORDS = 0xF450 // 2

# 0xcec3f writes 0x0083 into all eight lanes and strobes both groups, so every
# load begins with eight of these before the image itself.
LANE_INIT_WORDS = 8
LANE_INIT_VALUE = 0x0083

# The recovered on-chip mask ROM, shared with the 302/403 path in bridge.py.
from .bridge import C50_ROM_FRAME_IRQ as ROM_FRAME_IRQ  # noqa: E402

ROM_SHA256 = "3e30fb31ac87fc9d0b8a85da245511ef3caa4e83249f56b5852d9d0829e93f67"

# Both processors run from the board's 20.16 MHz clock, so the C5x advances at
# the 80186's cycles-per-instruction, exactly as bridge.py derives it for the
# 302/403. Reused rather than restated so the two cannot drift apart.
from .bridge import DSP_STEPS_PER_X86  # noqa: E402


@dataclass
class QuadC50Endpoint:
    """An active link: the CPU's lanes feed a C5x core that answers on 0x98.

    The CPU strobes four-word bursts and spins until the strobed bit reads back
    on `0x98` (`0xced9e`). Here that bit is raised only once the DSP has pulled
    the queued words through its fetch port, so the CPU waits on the DSP rather
    than on a floating bus.

    The core is stepped on an instruction budget alongside the CPU, carrying the
    fractional remainder between batches the way `bridge.py` does, so the average
    ratio stays exact instead of truncating once per service call.
    """

    core: object | None = None
    lanes: dict[int, int] = field(default_factory=dict)
    window: tuple[int, ...] | None = None
    window_group: int | None = None
    acks: int = 0
    reboots: int = 0
    program: list[int] = field(default_factory=list)
    steps: int = 0
    pulls: int = 0
    bursts: int = 0
    resets: int = 0
    started: bool = False
    _debt: float = 0.0
    _in_reset: bool = True
    _completion: bool = False
    _event_cursor: int = 0
    resets_seen: int = 0

    # -- CPU side ---------------------------------------------------------
    def read(self, port: int, size: int) -> int | None:
        if port == STATUS_PORT:
            if self._in_reset:
                # 0xcec72 writes 0xffff to 0x98/0x9a and 0x9c/0x9e and polls
                # both pairs back; the all-ones signature is the presence check.
                return 0xFF
            return self._ready_bits()
        if port in STATUS_PORTS and self._in_reset:
            return 0xFF
        return None

    def write(self, port: int, size: int, value: int) -> bool:
        if port in LANE_PORTS:
            self.lanes[port] = (self.lanes.get(port, 0) & 0xFF00) | (value & 0xFF)
            return False
        if port - 2 in LANE_PORTS:
            base = port - 2
            self.lanes[base] = (self.lanes.get(base, 0) & 0x00FF) | ((value & 0xFF) << 8)
            return False
        if port == STATUS_PORT:
            self._strobe(value & 0xFF)
            return False
        return False

    def _strobe(self, value: int) -> None:
        if value == 0xFF:
            self.resets += 1
            self._in_reset = True
            self.lanes.clear()
            self.window = None
            self.window_group = None
            # 0xcec38 and 0xcec12 both reset the part before the stream, and the
            # CPU repeats the whole load each time. On the board that reset puts
            # the C50 back in its boot ROM, so the loader is there to receive the
            # image again. Keeping one running core across resets left every
            # load after the first with nothing to receive it: the resident is
            # past its boot-time pulls by then and goes quiescent, which is
            # exactly the silence the CPU was timing out on.
            if self.core is not None:
                self.core.close()
                self.core = None
                self.started = False
                self.reboots += 1
            self.program = []
            return
        self._in_reset = False
        if value == 4:
            # The completion strobe is answered on bit 2 at 0xcee12 in both
            # phases; letting it fall through to the collector, which only
            # knows the two group strobes, times every load out.
            self._completion = True
            return
        if self.core is None:
            # Phase one: the C50's own boot loader pulls the resident in before
            # any of its code is running. That boot path is not modelled, so the
            # stream is taken at wire speed and the burst acked immediately. The
            # image still comes from the CPU - nothing here supplies it.
            self._collect(value)
            return
        group = LANE_BASE if value & 1 else (LANE_BASE + 0x10 if value & 2 else None)
        if group is None:
            return
        self.bursts += 1
        self.window = tuple(self.lanes.pop(group + LANE_STRIDE * i, 0) for i in range(4))
        self.window_group = group

    def _collect(self, value: int) -> None:
        group = LANE_BASE if value & 1 else (LANE_BASE + 0x10 if value & 2 else None)
        if group is None:
            return
        self.bursts += 1
        for index in range(4):
            self.program.append(self.lanes.pop(group + LANE_STRIDE * index, 0))
        # 0xcec3f primes all eight lanes with 0x0083, but 0xcec12's second call
        # to the reset routine lands between that and the stream, so what
        # accumulates after the last reset is the image alone. Counting the init
        # words in shifts the image and the DSP executes from the wrong place.
        if len(self.program) >= RESIDENT_WORDS and not self.started:
            self._start_core()

    def _start_core(self) -> None:
        """Boot the C50 the way bridge.py already boots it on the 302/403.

        Same part - board-parts.md identifies it as a TMS320C50/LC50, not the
        'C52 the core is named after - so the boot path is the same one that
        works there: the recovered mask ROM, MP/MC low, a *zeroed* program
        space, and the loader fed its destination, length and words. The
        loader writes the resident; nothing here pre-loads a copy for it to
        execute, which is the mistake bridge.py's own comment warns about and
        the one this endpoint was making.
        """
        from hashlib import sha256
        from pathlib import Path

        from .dsp import NativeC5x

        rom = (Path(__file__).resolve().parent.parent /
               "artifacts/dsp-onchip-rom-01/c5x-onchip-rom.bin").read_bytes()
        if sha256(rom).hexdigest() != ROM_SHA256:
            raise ValueError("recovered DSP boot ROM checksum mismatch")
        words = self.program[:RESIDENT_WORDS]
        core = NativeC5x.from_program(RESIDENT_ORIGIN, bytes(RESIDENT_WORDS * 2))
        core.load_rom(rom)
        core.set_mpmc_pin(0)
        # The boot strap the ROM reads to pick its mode. Not codec-specific -
        # without it the ROM takes another path and runs into an invalid opcode
        # at program 0x3f.
        core.host_write(0xFFFF, 4)
        core.set_pc(0)
        # Deliberately *not* configure_rom_codec(). That mode is the Courier
        # ASIC's, and it redefines two things the Quad needs as they are:
        #
        #   * port 0x57 becomes an acknowledgement register whose writes clear
        #     bits (c5x_core.cpp IO_WRITE16), so the resident's 0x0300 would
        #     clear bits 8 and 9 instead of setting them - which is exactly why
        #     0x57 read back 0x0000 here and the host link looked dead;
        #   * XRDY is gated on a codec frame clock this board does not drive,
        #     so the loader's reset handshake would spin for ever.
        #
        # The boot words do not need that mode. The loader takes them from DRR
        # gated by RRDY, and the ordinary path serves both from the codec
        # receive queue, with XRDY answered optimistically off XRST.
        core.queue_codec_rx([RESIDENT_ORIGIN, len(words), *words, 0])
        self.core = core
        self.started = True
        self.program = []

    def _ready_bits(self) -> int:
        if self.core is None:
            # Phase one still has to answer the completion strobe on bit 2, or
            # the wait at 0xcee34 times out and the load is retried for ever.
            return 0x01 | 0x02 | (0x04 if self._completion else 0)
        # The strobed group's bit is raised only once the DSP has acknowledged
        # the window by writing 0x57, which is what it does at 0x8313 after
        # reading all five words.
        if self.window is not None:
            return 0
        return 0x01 | 0x02 | (0x04 if self._completion else 0)

    # -- DSP side ---------------------------------------------------------
    def service(self, cpu_instructions: int) -> None:
        """Advance the C5x by its share of `cpu_instructions`."""
        if self.core is None:
            return
        self._debt += cpu_instructions * DSP_STEPS_PER_X86
        budget = int(self._debt)
        if budget <= 0:
            return
        self._debt -= budget
        while budget > 0:
            # All four words are present at once, so the stub's consecutive
            # reads see a coherent window and the core need not be single
            # stepped for it.
            if self.window is not None:
                for port, word in zip(DSP_WINDOW, self.window, strict=True):
                    self.core.set_io(port, word)
            slice_size = min(budget, 64)
            self.core.step(slice_size)
            self.steps += slice_size
            budget -= slice_size
            self._drain_pulls()

    def _drain_pulls(self) -> None:
        library = self.core.library
        handle = self.core.handle
        count = int(library.courier_c5x_get_io_event_count(handle))
        if count < self._event_cursor:
            # C5xCore::reset() clears the event log. Without this the cursor
            # stays past the end and the drain silently stops for good, which
            # is what made an earlier run report acknowledgements with no reads.
            self._event_cursor = 0
            self.resets_seen += 1
        import ctypes as _ctypes
        while self._event_cursor < count:
            values = (_ctypes.c_uint64 * 5)()
            library.courier_c5x_get_io_event(handle, self._event_cursor, values, 5)
            self._event_cursor += 1
            write, port = int(values[0]), int(values[1])
            if not write and port == DSP_FETCH_MMR:
                self.pulls += 1
            elif write and port == DSP_STATUS_MMR and self.window is not None:
                # 0x8313's write is the acknowledge: the window has been taken.
                self.program.extend(self.window)
                self.window = None
                self.window_group = None
                self.acks += 1

    def status(self) -> dict[str, object]:
        return {
            "steps": self.steps, "pulls": self.pulls, "bursts": self.bursts,
            "resets": self.resets, "acks": self.acks,
            "core_log_resets": self.resets_seen, "reboots": self.reboots,
            "window_open": self.window is not None,
            "program_words": len(self.program), "completion": self._completion,
        }
