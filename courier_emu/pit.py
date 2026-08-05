from __future__ import annotations

from dataclasses import dataclass, field


# Intel 8254 programmable interval timer, as the ISDN Courier wires it: three
# counters at I/O 0xf040..0xf042 with the control port at 0xf043. That is the
# PC-AT layout displaced by 0xf000, which is how the whole board is arranged --
# the 8259s land at 0xf020/0xf0a0 and the system control port at 0xf092.
BASE = 0xF040
COUNTER_PORTS = (0xF040, 0xF041, 0xF042)
CONTROL_PORT = 0xF043
PORT_WINDOW = (BASE, CONTROL_PORT)

# Control word fields.
SELECT_SHIFT = 6
ACCESS_SHIFT = 4
ACCESS_LATCH = 0
ACCESS_LOW = 1
ACCESS_HIGH = 2
ACCESS_LOW_THEN_HIGH = 3
MODE_SHIFT = 1
MODE_MASK = 0x07
BCD_BIT = 0x01
READ_BACK = 3  # select field 0b11 is the 8254 read-back command

COUNT_MODULUS = 0x10000

# The counter input clock. Every other port on this board follows the PC-AT
# layout, so the PC-AT 1.193182 MHz dot-clock derivative is the reasonable
# default, but nothing recovered from the firmware confirms it: the divisors it
# programs (1860, 8928, 35714) are not the round PC values, so the ISDN board
# may well clock its 8254 from something else. Treat this as the one knob that
# sets absolute time, and override it once a calibration is found.
CLOCK_HZ = 1_193_182

# The instruction clock the harness runs at. The 80186 side calibrates this from
# the answer machine's ring qualification window; nothing equivalent has been
# recovered for the 386, so this is a stated assumption rather than a
# measurement, and it only matters as a ratio against CLOCK_HZ.
INSTRUCTIONS_PER_SECOND = 2_500_000


def ticks_for(instructions: int, clock_hz: int = CLOCK_HZ) -> int:
    """Convert the harness instruction count into 8254 input ticks."""
    return instructions * clock_hz // INSTRUCTIONS_PER_SECOND


@dataclass
class Counter:
    """One 8254 counter, counting down from the harness's instruction clock."""

    index: int
    mode: int = 0
    access: int = ACCESS_LOW_THEN_HIGH
    bcd: bool = False
    initial: int = 0
    # Input tick at which `initial` was loaded, so a reprogrammed counter starts
    # its period from the write rather than from the start of the run.
    origin: int = 0
    programmed: bool = False
    # Write and read sequencing for the two-byte access mode.
    write_low: int | None = None
    read_high_next: bool = False
    latched: int | None = None
    # Wraps already reported to the interrupt controller.
    reported_wraps: int = 0

    @property
    def period(self) -> int:
        """A programmed count of zero means the full 16-bit range."""
        return self.initial if self.initial else COUNT_MODULUS

    def elapsed(self, ticks: int) -> int:
        return max(0, ticks - self.origin)

    def count(self, ticks: int) -> int:
        """The value a read would see now."""
        if not self.programmed:
            return 0
        remainder = self.elapsed(ticks) % self.period
        return (self.period - remainder) % COUNT_MODULUS

    def wraps(self, ticks: int) -> int:
        """How many times the counter has reached zero since it was loaded."""
        if not self.programmed:
            return 0
        return self.elapsed(ticks) // self.period

    def load(self, value: int, ticks: int) -> None:
        self.initial = value & 0xFFFF
        self.origin = ticks
        self.programmed = True
        self.reported_wraps = 0

    def take_wraps(self, ticks: int) -> int:
        """Consume and return wraps not yet handed to the interrupt controller."""
        total = self.wraps(ticks)
        new = total - self.reported_wraps
        self.reported_wraps = total
        return max(0, new)


@dataclass
class ProgrammableIntervalTimer:
    """The three-counter 8254, driven by the harness instruction clock."""

    clock_hz: int = CLOCK_HZ
    counters: tuple[Counter, Counter, Counter] = field(
        default_factory=lambda: (Counter(0), Counter(1), Counter(2))
    )
    control_writes: int = 0

    def ticks(self, instructions: int) -> int:
        return ticks_for(instructions, self.clock_hz)

    def handles(self, port: int) -> bool:
        return port in COUNTER_PORTS or port == CONTROL_PORT

    def write(self, port: int, value: int, instructions: int) -> None:
        value &= 0xFF
        ticks = self.ticks(instructions)
        if port == CONTROL_PORT:
            self._control(value, ticks)
            return
        counter = self.counters[COUNTER_PORTS.index(port)]
        if counter.access == ACCESS_LOW:
            counter.load(value, ticks)
        elif counter.access == ACCESS_HIGH:
            counter.load(value << 8, ticks)
        elif counter.write_low is None:
            # Low byte of a two-byte load; the counter keeps running until the
            # high byte arrives, which is what the real part does.
            counter.write_low = value
        else:
            counter.load(counter.write_low | (value << 8), ticks)
            counter.write_low = None

    def _control(self, value: int, ticks: int) -> None:
        self.control_writes += 1
        select = value >> SELECT_SHIFT
        if select == READ_BACK:
            # Read-back is not used by this firmware; ignoring it keeps the
            # model honest about what has actually been observed.
            return
        counter = self.counters[select]
        access = (value >> ACCESS_SHIFT) & 0x03
        if access == ACCESS_LATCH:
            counter.latched = counter.count(ticks)
            counter.read_high_next = False
            return
        counter.access = access
        counter.mode = (value >> MODE_SHIFT) & MODE_MASK
        counter.bcd = bool(value & BCD_BIT)
        counter.write_low = None
        counter.read_high_next = False
        counter.latched = None

    def read(self, port: int, instructions: int) -> int:
        if port == CONTROL_PORT:
            return 0
        ticks = self.ticks(instructions)
        counter = self.counters[COUNTER_PORTS.index(port)]
        value = counter.latched if counter.latched is not None else counter.count(ticks)
        if counter.access == ACCESS_LOW:
            return value & 0xFF
        if counter.access == ACCESS_HIGH:
            return (value >> 8) & 0xFF
        if counter.read_high_next:
            counter.read_high_next = False
            counter.latched = None
            return (value >> 8) & 0xFF
        counter.read_high_next = True
        return value & 0xFF

    def status(self, instructions: int) -> dict[str, object]:
        ticks = self.ticks(instructions)
        return {
            "clock_hz": self.clock_hz,
            "control_writes": self.control_writes,
            "counters": [
                {
                    "index": counter.index,
                    "mode": counter.mode,
                    "initial": counter.initial,
                    "period": counter.period if counter.programmed else 0,
                    "count": counter.count(ticks),
                    "wraps": counter.wraps(ticks),
                    "hz": (
                        self.clock_hz / counter.period
                        if counter.programmed and counter.period
                        else 0.0
                    ),
                }
                for counter in self.counters
            ],
        }
