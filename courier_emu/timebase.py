"""What each board's clock is, and what an instruction costs on it.

Three constants used to carry this between them - `pit.CYCLES_PER_INSTRUCTION`
at 5, `timers.CYCLES_PER_INSTRUCTION` at 5.93, and `timers.
INSTRUCTIONS_PER_SECOND` at 4,348,000 - and each described a different part
while being imported by whatever needed a rate. The 5 is the 386EX I-modem's;
the 5.93 is the 80C186EB's; the 4,348,000 is the 186's rate *on main211's
25.8048 MHz crystal*, and it was serving the 20.16 MHz 302/403 as well, where
it is 28% fast.

The two figures separate cleanly. Cycles per instruction is a property of the
part and the code mix, so both 186 boards share it; the crystal is a property
of the board. A rate is the one divided by the other, and keeping them apart is
what lets one model serve every board here.

## Where each number comes from

`docs/hardware-timebase-and-audio-path.md` establishes the 186 boards from the
one timer both firmwares program for 5.000 ms on their own crystal:

| build | CLKOUT | T0CMPA | counts/s | period |
|---|---|---:|---:|---:|
| board 7.4.16 | 20.16 MHz | `0x6270` = 25,200 | 5,040,000 | 5.000 ms |
| main211 2.1.1 | 25.8048 MHz | `0x7e00` = 32,256 | 6,451,200 | 5.000 ms |

The 80C186EB halves its oscillator input, so the 40.320 MHz can on the 302/403
gives CLKOUT 20.16 MHz and the 2806's 51.6096 MHz crystal gives 25.8048 MHz
(`docs/running-the-25mhz-image.md`, which confirms the latter a second way
through the UART divisors: 25.8048 MHz divides to exactly 19200 and 9600).
Internally clocked 80186 timers count CLKOUT/4.

5.93 cycles an instruction is `timers.py`'s, from daa.py's codec sample count
rather than from a cycle table - an empirical whole-run average, which is what
a rate wants. A static weighting of the 80C186EB timing table over 20M
instructions of `MAIN_2.3.31` boot gives 9.96, but boot is unusually branch-
and call-heavy (23% Jcc, 10% RET, 8% CALL) and is not the mix a call runs at.

The DSP's clock is **not** the CPU's on every board. `docs/asic-pinout.md`
traces the C5x's `X2/CLKIN` to the ASIC, which runs from the shared 40.320 MHz
can on both 186 boards - so the 2806's faster crystal is the CPU's alone and
the DSP runs at the same rate either way. That is why `dsp_cycles_per_x86`
differs between two boards that share a `cycles_per_instruction`.
"""
from __future__ import annotations

from dataclasses import dataclass


@dataclass(frozen=True)
class Timebase:
    """One board's clock, and what an instruction costs on it."""

    name: str
    #: CLKOUT, after the part's own division of its oscillator input.
    cpu_clock_hz: int
    #: An empirical whole-run average, not a cycle-table figure.
    cycles_per_instruction: float
    #: CLKOUT is divided by this to clock the internal timers.
    timer_divisor: int
    #: The attached signal processor's own clock, where there is one. It does
    #: not follow the CPU's: on the 186 boards it comes out of the ASIC.
    dsp_clock_hz: int | None = None
    #: What the firmware writes to T0CMPA, where that identifies the board.
    timer0_compare: int | None = None

    @property
    def instructions_per_second(self) -> int:
        return round(self.cpu_clock_hz / self.cycles_per_instruction)

    @property
    def timer_clock_hz(self) -> int:
        return self.cpu_clock_hz // self.timer_divisor

    @property
    def ticks_per_instruction(self) -> float:
        """The crystal cancels here: this is only cycles_per_instruction / N.

        Which is why the timer block behaved the same on both 186 boards even
        while the absolute rate it was paired with belonged to one of them.
        """
        return self.cycles_per_instruction / self.timer_divisor

    @property
    def dsp_cycles_per_x86(self) -> float:
        """C5x clock cycles to each 80186 instruction.

        Cycles, not instructions: the core charges what each instruction
        costs (1.35 a call's mix, n+2 for a repeated MAC), and its codec
        frames and timers run on those cycles. Stepping this many
        instructions ran the DSP's sample clock 5-35% fast against the line,
        by however much its current code happened to cost.
        """
        if self.dsp_clock_hz is None:
            return 0.0
        # Taken from the clocks rather than through instructions_per_second,
        # which is rounded to a whole instruction and would carry that rounding
        # into a ratio that is exactly 5.93 on the board both parts share.
        return (self.dsp_clock_hz / self.cpu_clock_hz) * self.cycles_per_instruction

    def describe(self) -> dict[str, object]:
        return {
            "name": self.name,
            "cpu_clock_hz": self.cpu_clock_hz,
            "cycles_per_instruction": self.cycles_per_instruction,
            "instructions_per_second": self.instructions_per_second,
            "timer_clock_hz": self.timer_clock_hz,
            "dsp_clock_hz": self.dsp_clock_hz,
            "dsp_cycles_per_x86": round(self.dsp_cycles_per_x86, 4),
        }


# The 40.320 MHz can feeds the ASIC on both 186 boards, and the ASIC clocks the
# C52 from it. Stated once because it is the one figure the two boards share.
ASIC_DSP_CLOCK_HZ = 20_160_000

COURIER_20MHZ = Timebase(
    name="courier-20.16",
    cpu_clock_hz=20_160_000,
    cycles_per_instruction=5.93,
    timer_divisor=4,
    dsp_clock_hz=ASIC_DSP_CLOCK_HZ,
    timer0_compare=0x6270,
)

COURIER_25MHZ = Timebase(
    name="courier-25.8048",
    cpu_clock_hz=25_804_800,
    cycles_per_instruction=5.93,
    timer_divisor=4,
    dsp_clock_hz=ASIC_DSP_CLOCK_HZ,
    timer0_compare=0x7E00,
)

# The ISDN Courier is a different part throughout: a KU80386EX25 from a 50.000
# MHz oscillator halved, whose timer control unit is prescaled by CLKPRS rather
# than by a fixed divide - the firmware writes 12, so 2 * (12 + 2) = 28. Its
# five cycles an instruction is pit.py's figure for real-mode code on that
# part. Its signal processor is reached over the mailbox rather than clocked
# against the CPU here, so it declares no DSP clock.
IMODEM_386EX = Timebase(
    name="imodem-386ex",
    cpu_clock_hz=25_000_000,
    cycles_per_instruction=5.0,
    timer_divisor=28,
)

BOARDS = (COURIER_20MHZ, COURIER_25MHZ, IMODEM_386EX)
BOARDS_BY_NAME = {board.name: board for board in BOARDS}

# The 302/403 is the behavioural reference, so it is what a run assumes until
# the firmware says otherwise.
DEFAULT_COURIER = COURIER_20MHZ

# The firmware states its own crystal by what it programs for a 5.000 ms timer
# 0, and verifies its own value afterwards (the 7.4.16 board at 0x4a83b, `cmp
# word [0xff32], 0x6270`). That makes this identification evidence rather than
# a guess - but only for the two values below; any other compare leaves the
# assumed board in place.
BY_TIMER0_COMPARE = {
    board.timer0_compare: board
    for board in BOARDS
    if board.timer0_compare is not None
}


def board_for_timer0_compare(value: int) -> Timebase | None:
    """Which board programs `value` into T0CMPA, if the value identifies one."""
    return BY_TIMER0_COMPARE.get(value & 0xFFFF)
