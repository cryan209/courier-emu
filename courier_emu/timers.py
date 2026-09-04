from __future__ import annotations

from dataclasses import dataclass, field
from typing import Any


# The peripheral control block is relocated into memory at 0x0ff00, which the
# 1998 ROM's own setup table does with `out 0xffa8, 0x10ff`. Both firmwares
# then reach the timers as ordinary memory.
PCB_BASE = 0xFF00

# 80C186EB timer block. This is not the original 80186 layout - that one puts
# timer 0 at PCB offset 0x50 - and the register addresses both firmwares use
# are the EB's:
#
#   T0  count 0xff30  compare A 0xff32  compare B 0xff34  control 0xff36
#   T1  count 0xff38  compare A 0xff3a  compare B 0xff3c  control 0xff3e
#   T2  count 0xff40  compare A 0xff42                    control 0xff46
TIMER_REGISTERS: dict[int, tuple[int, str]] = {
    0xFF30: (0, "count"),
    0xFF32: (0, "compare_a"),
    0xFF34: (0, "compare_b"),
    0xFF36: (0, "control"),
    0xFF38: (1, "count"),
    0xFF3A: (1, "compare_a"),
    0xFF3C: (1, "compare_b"),
    0xFF3E: (1, "control"),
    0xFF40: (2, "count"),
    0xFF42: (2, "compare_a"),
    0xFF46: (2, "control"),
}
TIMER_WINDOW = (min(TIMER_REGISTERS), max(TIMER_REGISTERS) + 1)

# Control word bits.
CONTROL_ENABLE = 0x8000
CONTROL_INHIBIT = 0x4000  # write gate for ENABLE; not itself stored
CONTROL_INTERRUPT = 0x2000
CONTROL_REGISTER_IN_USE = 0x1000
CONTROL_MAX_COUNT = 0x0020
CONTROL_RETRIGGER = 0x0010
CONTROL_PRESCALER = 0x0008
CONTROL_EXTERNAL = 0x0004
CONTROL_ALTERNATE = 0x0002
CONTROL_CONTINUOUS = 0x0001

COUNT_MODULUS = 0x10000

# Interrupt controller registers, at the same peripheral control block. The
# boot block programs these through I/O space and only then relocates the block
# into memory, so both paths reach the same model.
IMASK = 0xFF08
TIMER_CONTROL = 0xFF12
SOURCE_CONTROL = {
    0xFF12: "timer",
    0xFF14: "dma0",
    0xFF16: "dma1",
    0xFF18: "int0",
    0xFF1A: "int1",
    0xFF1C: "int2",
    0xFF1E: "int3",
}
# IMASK holds the same per-source mask bits the control registers do, in this
# order, so a write to either has to move the other.
IMASK_ORDER = ("timer", "dma0", "dma1", "int0", "int1", "int2", "int3")
CONTROL_MASK_BIT = 0x08

# 80186 interrupt types for the three timers. The timers share one control
# register in the interrupt controller but have separate vectors.
TIMER_VECTORS = (8, 18, 19)

# The 1998 ROM calibrates its system tick from an external interrupt rather
# than from a timer alone. 0x9eb73 starts timer 1 as a stopwatch and unmasks
# INT1; the INT1 handler at 9ea4:0722 reads timer 1's count, sets timer 2's
# compare to one and a half times it, unmasks the timer interrupt, and stops
# both timer 1 and INT1. Timer 2 is the tick from then on.
#
# So timer 1's compare of 54,166 ticks - 10.8 ms - is a timeout, not a period:
# on hardware the INT1 edge always arrives first, and a run with no source for
# it lets timer 1 wrap into a handler that only makes sense in another context.
# What drives INT1 physically is not established here. Because the handler
# measures the interval between the unmask and the edge, that interval is the
# calibration, and the tick that comes out of it is one and a half times it.
# The default below therefore lands the tick at the 10 ms the answer machine's
# ring qualification window independently points to.
INT0_VECTOR = 12
INT1_VECTOR = 13
INT1_CALIBRATION_MS = 7

# Timers are advanced on register access and on this stride, which has to be
# short enough that a max count is never missed: the shortest period either
# firmware programs is timer 1's 54,166 ticks, about 12,000 instructions.
TIMER_POLL_INSTRUCTIONS = 1_024

# The timers count the CPU clock divided by four. The Courier's split is a
# 20 MHz 80186 against a 25 MHz C52, so the timer clock is 5 MHz, and the
# harness executes 1,111 instructions per millisecond - the rate the answer
# machine's own ring qualification window pins down in daa.py. Those two give
# the ratio below, and it is a useful cross-check that it lands where it does:
# timer 0 is programmed with a compare of 25,200, which works out at one
# interrupt every 5,600 instructions, against the 4,096 the harness had been
# using as a hand-tuned constant.
TIMER_CLOCK_HZ = 5_000_000
INSTRUCTIONS_PER_SECOND = 1_111_000


def ticks_for(instructions: int) -> int:
    return instructions * TIMER_CLOCK_HZ // INSTRUCTIONS_PER_SECOND


@dataclass
class Timer:
    """One 80C186EB timer, counting from the harness's instruction clock."""

    index: int
    control: int = 0
    compare_a: int = 0
    compare_b: int = 0
    count: int = 0
    # Tick at which `count` was last true, so a count written by the firmware
    # stays the origin for everything after it.
    origin: int = 0
    max_counts: int = 0

    @property
    def enabled(self) -> bool:
        return bool(self.control & CONTROL_ENABLE)

    @property
    def continuous(self) -> bool:
        return bool(self.control & CONTROL_CONTINUOUS)

    @property
    def counts_internally(self) -> bool:
        """Whether this timer advances from the modelled clock at all.

        An external-clock timer counts a pin this harness has no source for,
        and a prescaled timer counts timer 2's output. Neither is modelled, so
        both are reported as not counting rather than counted wrongly.
        """
        return not self.control & (CONTROL_EXTERNAL | CONTROL_PRESCALER)

    @property
    def period(self) -> int:
        """Counts between one max count and the next.

        A compare of zero is a full 65,536, which is what the ROM's timer
        self-test relies on: it enables timer 2 with both the count and the
        compare at zero and waits for the wrap.
        """
        compare = self.compare_a or COUNT_MODULUS
        if self.control & CONTROL_ALTERNATE:
            # Alternating mode runs A then B. Modelling the pair as one period
            # keeps the max-count rate right, which is what the firmware waits
            # on; which half is live is reported through RIU only as written.
            compare += self.compare_b or COUNT_MODULUS
        return compare

    def advance(self, tick: int) -> None:
        """Bring the count up to `tick`, latching every max count on the way."""
        if not self.enabled or not self.counts_internally:
            self.origin = tick
            return
        elapsed = tick - self.origin
        if elapsed <= 0:
            return
        period = self.period
        total = self.count + elapsed
        wraps, self.count = divmod(total, period)
        self.origin = tick
        if not wraps:
            return
        self.max_counts += wraps
        self.control |= CONTROL_MAX_COUNT
        if not self.continuous:
            # A single-shot timer stops itself on its one max count, and the
            # count it stops at is the compare, not a wrapped remainder.
            self.control &= ~CONTROL_ENABLE
            self.count = 0

    def ticks_to_max_count(self) -> int | None:
        """Ticks until the next max count, or None if it will never come."""
        if not self.enabled or not self.counts_internally:
            return None
        return self.period - self.count

    def write(self, name: str, value: int) -> None:
        if name != "control":
            setattr(self, name, value & 0xFFFF)
            return
        # ENABLE only changes when INHIBIT is set in the same write, and INHIBIT
        # is a gate rather than a stored bit. MAX COUNT is a status bit the
        # firmware clears by writing it back as zero.
        control = self.control
        if value & CONTROL_INHIBIT:
            control = (control & ~CONTROL_ENABLE) | (value & CONTROL_ENABLE)
        writable = (
            CONTROL_INTERRUPT
            | CONTROL_REGISTER_IN_USE
            | CONTROL_MAX_COUNT
            | CONTROL_RETRIGGER
            | CONTROL_PRESCALER
            | CONTROL_EXTERNAL
            | CONTROL_ALTERNATE
            | CONTROL_CONTINUOUS
        )
        self.control = (control & ~writable) | (value & writable)

    def status(self) -> dict[str, Any]:
        return {
            "control": f"{self.control:#06x}",
            "enabled": self.enabled,
            "continuous": self.continuous,
            "compare_a": self.compare_a,
            "compare_b": self.compare_b,
            "count": self.count,
            "max_counts": self.max_counts,
        }


@dataclass
class InterruptController:
    """Just the mask side of the 80186 interrupt controller.

    Priority, nesting, and the poll registers are not modelled - what the
    firmware needs from this is the gate. The 1998 ROM's boot table writes
    IMASK = 0x0079, which masks the timers, and the external interrupt that
    calibrates its tick is what later clears the timer mask by writing zero to
    the timer control register. Delivering a timer interrupt through a mask the
    firmware has deliberately set lands in a half-installed handler.
    """

    masked: dict[str, bool] = field(
        default_factory=lambda: {name: True for name in IMASK_ORDER}
    )
    writes: int = 0

    def write(self, address: int, value: int) -> bool:
        if address == IMASK:
            self.writes += 1
            for index, name in enumerate(IMASK_ORDER):
                self.masked[name] = bool(value & (1 << index))
            return True
        name = SOURCE_CONTROL.get(address)
        if name is None:
            return False
        self.writes += 1
        self.masked[name] = bool(value & CONTROL_MASK_BIT)
        return True

    def enabled(self, name: str) -> bool:
        return not self.masked.get(name, True)

    def status(self) -> dict[str, Any]:
        return {"writes": self.writes, "masked": dict(self.masked)}


@dataclass
class TimerBlock:
    """The three peripheral timers, addressed as memory at the relocated PCB.

    `answers_reads` is what separates the two firmwares this harness runs. A
    ROM boots from its reset vector and programs the whole control block on the
    way, so its timers can be read back from the model. An XMF is entered at
    the application, past the boot block that sets the block up, and its delays
    are already served by the harness's hand-calibrated helpers - answering its
    reads from the model instead puts its timer interrupt service routine on a
    path it does not return from. Its writes are still tracked, so a run still
    reports what the firmware programmed.
    """

    fast: bool = True
    answers_reads: bool = True
    timers: list[Timer] = field(default_factory=lambda: [Timer(index) for index in range(3)])
    # Ticks granted to satisfy polls immediately, counted for reporting only.
    # The grant itself is applied to the polled timer's own origin, so it does
    # not reach the shared clock - see `read`.
    granted: int = 0
    accelerated: int = 0
    reads: int = 0
    writes: int = 0
    interrupts: int = 0
    controller: InterruptController = field(default_factory=InterruptController)
    _pending: list[int] = field(default_factory=list)

    def _tick(self, instructions: int) -> int:
        return ticks_for(instructions)

    def read(self, address: int, size: int, instructions: int) -> int | None:
        """Return the value at a timer register, or None if it is not one."""
        entry = TIMER_REGISTERS.get(address)
        if entry is None:
            return None
        index, name = entry
        timer = self.timers[index]
        self.reads += 1
        timer.advance(self._tick(instructions))
        if name == "control" and self.fast and self.answers_reads and not timer.control & CONTROL_MAX_COUNT:
            # Both firmwares busy-wait on MAX COUNT for their calibrated
            # delays. Granting the wait at the first poll is the same
            # acceleration the harness already applies to the delay helpers,
            # and it advances the timer's own count rather than faking the bit,
            # so the count and the max-count total stay consistent.
            #
            # The grant moves only this timer's origin. Advancing a clock the
            # other two share would age them by the whole of every delay
            # anyone waits on, which is how a scratch delay ends up wrapping
            # the timer another part of the firmware is measuring with - the
            # ROM's timer 1 took its first max count 4.8 periods early that
            # way, on a grant collected by polls of timer 0.
            remaining = timer.ticks_to_max_count()
            if remaining is not None:
                timer.origin -= remaining
                self.granted += remaining
                self.accelerated += 1
                timer.advance(self._tick(instructions))
        if not self.answers_reads:
            return None
        value = timer.control if name == "control" else getattr(timer, name)
        return value & 0xFF if size == 1 else value & 0xFFFF

    def write(self, address: int, size: int, value: int, instructions: int) -> bool:
        if self.controller.write(address, value):
            return True
        entry = TIMER_REGISTERS.get(address)
        if entry is None:
            return False
        index, name = entry
        timer = self.timers[index]
        self.writes += 1
        timer.advance(self._tick(instructions))
        if size == 1:
            current = timer.control if name == "control" else getattr(timer, name)
            value = (current & 0xFF00) | (value & 0xFF)
        timer.write(name, value)
        timer.origin = self._tick(instructions)
        return True

    def tick(self, instructions: int) -> None:
        """Advance every timer and latch an interrupt for each max count."""
        tick = self._tick(instructions)
        for timer in self.timers:
            before = timer.max_counts
            timer.advance(tick)
            if timer.max_counts == before or not timer.control & CONTROL_INTERRUPT:
                continue
            # One request per max count, not one per poll: the request is the
            # edge, and the firmware acknowledges it through the interrupt
            # controller rather than by clearing a level.
            if len(self._pending) < 8:
                self._pending.append(TIMER_VECTORS[timer.index])

    def pending_interrupt(self) -> int | None:
        if not self.controller.enabled("timer"):
            # A masked source still latches its request in the controller; it
            # is delivery that waits. Dropping it instead would replay a stale
            # tick the moment the firmware unmasks.
            return None
        return self._pending[0] if self._pending else None

    def take_interrupt(self) -> int | None:
        if not self._pending:
            return None
        self.interrupts += 1
        return self._pending.pop(0)

    def status(self) -> dict[str, Any]:
        return {
            "fast": self.fast,
            "modelled": self.answers_reads,
            "interrupts": self.interrupts,
            "reads": self.reads,
            "writes": self.writes,
            "accelerated_waits": self.accelerated,
            "granted_ticks": self.granted,
            "controller": self.controller.status(),
            "timers": [timer.status() for timer in self.timers],
        }
