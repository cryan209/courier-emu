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
