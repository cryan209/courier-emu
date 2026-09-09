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

# The resident's origin, from the load table: source paragraph 0x2000, length
# 0xf450, destination 0x8000. The captured stream spans 0x8000..0xfa28.
RESIDENT_ORIGIN = 0x8000
RESIDENT_WORDS = 0xF450 // 2

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
    pending: list[int] = field(default_factory=list)
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
            self.pending.clear()
            return
        self._in_reset = False
        if self.core is None:
            # Phase one: the C50's own boot loader pulls the resident in before
            # any of its code is running. That boot path is not modelled, so the
            # stream is taken at wire speed and the burst acked immediately. The
            # image still comes from the CPU - nothing here supplies it.
            self._collect(value)
            return
        if value == 4:
            self._completion = True
            self.pending.append(self.lanes.get(LANE_BASE, 0))
            return
        group = LANE_BASE if value & 1 else (LANE_BASE + 0x10 if value & 2 else None)
        if group is None:
            return
        self.bursts += 1
        for index in range(4):
            port = group + LANE_STRIDE * index
            self.pending.append(self.lanes.pop(port, 0))

    def _collect(self, value: int) -> None:
        group = LANE_BASE if value & 1 else (LANE_BASE + 0x10 if value & 2 else None)
        if group is None:
            return
        self.bursts += 1
        for index in range(4):
            self.program.append(self.lanes.pop(group + LANE_STRIDE * index, 0))
        if len(self.program) >= RESIDENT_WORDS and not self.started:
            self._start_core()

    def _start_core(self) -> None:
        from .dsp import NativeC5x
        words = self.program[-RESIDENT_WORDS:]
        image = b"".join(word.to_bytes(2, "little") for word in words)
        self.core = NativeC5x.from_program(RESIDENT_ORIGIN, image)
        self.core.set_pc(RESIDENT_ORIGIN)
        self.started = True
        self.program = []

    def _ready_bits(self) -> int:
        if self.core is None:
            return 0x01 | 0x02

        # The strobed group's bit is raised only when the DSP has taken every
        # word the CPU queued for it. Bit 2 answers the completion strobe.
        if self.pending:
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
            slice_size = 1 if self.pending else min(budget, 256)
            self.core.set_io(DSP_FETCH_MMR, self.pending[0] if self.pending else 0xFFFF)
            self.core.step(slice_size)
            self.steps += slice_size
            budget -= slice_size
            self._drain_pulls()

    def _drain_pulls(self) -> None:
        library = self.core.library
        handle = self.core.handle
        count = int(library.courier_c5x_get_io_event_count(handle))
        import ctypes as _ctypes
        while self._event_cursor < count:
            values = (_ctypes.c_uint64 * 5)()
            library.courier_c5x_get_io_event(handle, self._event_cursor, values, 5)
            self._event_cursor += 1
            write, port = int(values[0]), int(values[1])
            if not write and port == DSP_FETCH_MMR and self.pending:
                self.program.append(self.pending.pop(0))
                self.pulls += 1

    def status(self) -> dict[str, object]:
        return {
            "steps": self.steps, "pulls": self.pulls, "bursts": self.bursts,
            "resets": self.resets, "pending": len(self.pending),
            "program_words": len(self.program), "completion": self._completion,
        }
