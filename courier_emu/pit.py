from __future__ import annotations

from dataclasses import dataclass, field

from .timebase import IMODEM_386EX


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

# The counter input clock, derived from the firmware rather than assumed.
#
# The divisors it programs - 1860, 8928, 35714, all mode 2 - are not the round
# PC values, so the PC-AT 1.193182 MHz this used to assume was only ever the
# company the rest of the board keeps. What settles it is the firmware's own
# arithmetic on the S-registers, whose units Hayes fixes: converting each one
# into the ticks its timers count states the tick rate outright.
#
#   S7  wait for carrier   seconds    x 100   0xa9a27  mov ah,0x64 ; mul ah
#   S9  carrier detect     1/10 s     x 10    0xa9a45  mov ah,0x0a ; mul ah
#   S12 escape guard       1/50 s     x 2     0xa50a1  shl ax,1
#   S25 DTR delay          1/100 s    x 1     0xa61c1  stored as it is read
#
# Four statements, one answer: a tick is 1/100 s. Those countdowns are serviced
# by the handler on vector 0x2a, which is IRQ10, and which is the same handler
# that advances the free-running tick counter at [c8cb] - 0x405f8 and 0xa4690
# execute 4,804 times each over a 20M-instruction run. So IRQ10 runs at 100 Hz,
# and of the three divisors only 8928 gives 100 Hz, at this clock:
#
#   counter 0  /1860    480.000 Hz   2.0833 ms
#   counter 1  /8928    100.000 Hz   10 ms exactly - the system tick
#   counter 2  /35714    24.999 Hz   40 ms (35712 would be 25.000 Hz)
#
# The old 1.193182 MHz made the same counter 133.645 Hz, so every timeout the
# firmware set was a third short.
#
# The board and the firmware then say the same thing a second way, exactly.
# The 8254 here is the 386EX's own timer control unit - which is why it sits at
# 0xf040 beside the interrupt controllers at 0xf020/0xf0a0 and the serial ports
# at 0xf4f8/0xf8f8 - so it runs on that part's prescaled clock. The board
# carries a 50.000 MHz oscillator for the 386EX, halved to the KU80386EX25's
# 25 MHz (docs/imodem-board-map.md), and the firmware writes CLKPRS at 0xf804
# with 12 during setup, which prescales by 2 * (12 + 2):
#
#   25 MHz / 28 = 892,857.14 Hz
#
# At that clock the ideal divisors for 480, 100 and 25 Hz are 1860.12, 8928.57
# and 35714.29, and what the firmware programs is 1860, 8928 and 35714 - the
# nearest integer to each. No other prescale comes close: 26 and 30 are 7% out
# on all three.
# These are the I-modem board's, and `timebase.IMODEM_386EX` is where they
# live now - the paragraphs above are the derivation. Naming the board keeps
# this part's five cycles an instruction from being imported by the 80C186EB
# Courier, which costs 5.93 and runs off a different crystal again.
CPU_CLOCK_HZ = IMODEM_386EX.cpu_clock_hz
TIMER_PRESCALE = IMODEM_386EX.timer_divisor
CLOCK_HZ = IMODEM_386EX.timer_clock_hz   # 892,857

# The instruction clock the harness runs at, and the one place it is stated.
#
# The clock above is the part's; what is left is how many of its cycles an
# instruction costs, and that is the one number here that no reading of the
# firmware supplies - it is a property of the part and the code mix. The board
# fixes everything around it: the 386EX is 25 MHz and the DSP's C5x is
# single-cycle at 20.16 MHz. Five cycles an instruction is what real-mode code
# on this part costs, and it is the figure taken here; it puts the CPU at 5M
# instructions a second, and the DSP at 4.03 of its instructions to each of
# those, which is where isdn.DSP_INSTRUCTIONS_PER_CPU_INSTRUCTION's 4 comes
# from. That constant is derived from this one now rather than stated twice.
#
# This used to be 2,500,000 - ten cycles an instruction - while sio.py carried
# 20,160,000 for the same CPU, which is 1.24. Neither is a 386EX, and having
# both meant a 9600-baud character was 21,000 instructions to the serial model
# and 8.4 ms to the timers, where it is 1.04 ms. The two are one constant now.
CYCLES_PER_INSTRUCTION = IMODEM_386EX.cycles_per_instruction
INSTRUCTIONS_PER_SECOND = IMODEM_386EX.instructions_per_second   # 5,000,000


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
