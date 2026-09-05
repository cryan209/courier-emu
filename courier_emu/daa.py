from __future__ import annotations

from dataclasses import asdict, dataclass
import math


DAA_SAMPLE_RATE = 9_600
DAA_FRAME_SAMPLES = 960
DAA_LINE_STATES = ("disconnected", "quiet", "dial-tone", "ringing")

# The harness has no wall clock; its only time base is the 80186 instruction
# count, so this constant sets what a millisecond means everywhere on the line.
#
# It used to be 1,111, calibrated by assuming the burst that takes the answer
# machine's tick counter at [0x1d50] to the country minimum of 180 at [0x1f5c]
# is one 2 s ring. That assumption is now known to be wrong, and the derivation
# was circular besides: machine.py synthesizes the tick itself at
# tick_ms * INSTRUCTIONS_PER_MS, so "2,000,000 instructions reaches 180 ticks"
# is arithmetic on the two constants rather than a measurement of either.
#
# What is measured is the tick. See docs/hardware-timebase-and-audio-path.md:
# the board fits 1.000031 seconds per S18 unit over twelve &T1 runs, both
# builds convert S-register seconds to ticks by multiplying by 200, and both
# program 80186 Timer 0 - which counts at CLKOUT/4 - for exactly 5.000 ms on
# their own crystal. One tick is 5 ms, so 180 ticks is 900 ms: a minimum ring
# qualification, not a whole 2 s burst.
#
# That leaves the codec-clocked figure as the only one standing. It is what the
# native C52 bridge actually consumes: 132,480 samples in 60,000,000
# instructions is 13.80 s of line time, or 4,348 instructions per millisecond.
# main211 is the 25.8048 MHz build (its Timer 0 max count is 0x7e00, which only
# lands on 5 ms at that clock), so 4,348 is 5.9 cycles per instruction - an
# ordinary 80186 mix, where 1,111 would have been 23.
#
# This is still the harness's own rate rather than a measurement off a board:
# it inherits the C5x cycle model and the 5:4 scheduling ratio, and it varies
# with how much the DSP stalls in a given run. Runs that keep the datapump busy
# imply nearer 5,800. What is no longer in doubt is the order of magnitude.
INSTRUCTIONS_PER_MS = 4_348

RING_ON_MS = 2_000
RING_OFF_MS = 4_000
# The supervisor needs roughly five million instructions to reach its command
# loop, so the first burst waits until the modem is actually listening. At
# 4,348 instructions per millisecond that is 1.15 s, and this keeps the old
# instruction offset rather than the old millisecond figure.
RING_START_MS = 2_000


@dataclass
class RingSource:
    """Ring cadence presented to the ring detector on input port 0x14.

    The answer machine at 0x70fb4 polls that bit directly and every one of its
    states waits on an edge, so a line that never changes level parks it in its
    first state. This drives the level from the instruction count, which is the
    only clock the harness has.
    """

    on_ms: int = RING_ON_MS
    off_ms: int = RING_OFF_MS
    start_ms: int = RING_START_MS
    count: int = 0  # 0 rings until the run ends
    bursts: int = 0

    def __post_init__(self) -> None:
        if self.on_ms <= 0 or self.off_ms <= 0:
            raise ValueError("ring cadence needs a positive on and off time")
        if self.start_ms < 0:
            raise ValueError("ring start time cannot be negative")
        if self.count < 0:
            raise ValueError("ring count cannot be negative")

    @property
    def period_ms(self) -> int:
        return self.on_ms + self.off_ms

    def present(self, instructions: int) -> bool:
        """Return whether a ring burst is on the line at this instruction."""
        elapsed = instructions - self.start_ms * INSTRUCTIONS_PER_MS
        if elapsed < 0:
            return False
        burst, phase = divmod(elapsed, self.period_ms * INSTRUCTIONS_PER_MS)
        if self.count and burst >= self.count:
            return False
        ringing = phase < self.on_ms * INSTRUCTIONS_PER_MS
        if ringing:
            self.bursts = max(self.bursts, burst + 1)
        return ringing

    def status(self) -> dict[str, int]:
        return {
            "on_ms": self.on_ms,
            "off_ms": self.off_ms,
            "start_ms": self.start_ms,
            "count": self.count,
            "bursts_delivered": self.bursts,
        }


@dataclass
class CourierDaa:
    """Behavioral line-side DAA inferred from the supervisor and C52 firmware."""

    line_state: str = "disconnected"
    sample_rate: int = DAA_SAMPLE_RATE
    off_hook: bool = False
    operation: str = "idle"
    generated_samples: int = 0
    qualified_samples: int = 0

    def __post_init__(self) -> None:
        if self.line_state not in DAA_LINE_STATES:
            choices = ", ".join(DAA_LINE_STATES)
            raise ValueError(f"invalid DAA line state {self.line_state!r}; choose {choices}")

    @property
    def line_connected(self) -> bool:
        return self.line_state != "disconnected"

    @property
    def dial_tone_present(self) -> bool:
        return (
            self.off_hook
            and self.operation == "originate"
            and self.line_state == "dial-tone"
        )

    @property
    def detector_present(self) -> bool:
        """Whether the line offers what the 0x0649 detector wait is looking for.

        `ATA` reaches the same wait at 0x5dbe7 that `ATD` does, and with no
        producer for the detector byte the firmware answers `NO DIAL TONE` to a
        plain `ATA`. An answering seizure has no dial tone to find, so what it
        qualifies on is a connected line. Treating the byte as the line-side
        detector rather than a dial-tone-only counter is an inference from that
        shared wait, not something the image states.
        """
        if not self.off_hook or not self.line_connected:
            return False
        if self.operation in ("answer", "dialing"):
            return True
        return self.dial_tone_present

    @property
    def detector_qualified(self) -> bool:
        # The supervisor waits for detector byte 0x0649 to reach five. Model
        # that debounce as five 100 ms ASIC frames rather than asserting it at
        # the instant the hook relay closes.
        return self.qualified_samples >= 5 * DAA_FRAME_SAMPLES

    @property
    def dial_tone_qualified(self) -> bool:
        return self.dial_tone_present and self.detector_qualified

    def seize(self, operation: str = "originate") -> None:
        self.off_hook = True
        self.operation = operation
        self.qualified_samples = 0

    def release(self) -> None:
        self.off_hook = False
        self.operation = "idle"
        self.qualified_samples = 0

    def begin_dialing(self) -> None:
        if self.off_hook:
            self.operation = "dialing"

    def set_call_progress(self, state: str) -> None:
        if self.off_hook and state in ("trying", "ringing", "connected", "failed"):
            self.operation = state

    def observe(self, count: int) -> None:
        """Count samples supplied by a modeled line rather than by `render`.

        The detector debounce is a property of the line having been sampled,
        not of this class having generated the samples. An exchange or a
        linked peer feeding the codec directly still has to advance it.
        """
        if count <= 0 or not self.detector_present:
            return
        self.generated_samples += count
        self.qualified_samples += count

    def render(self, count: int) -> list[int]:
        """Return signed 16-bit samples presented to the Courier line ADC."""
        if count <= 0:
            return []
        start = self.generated_samples
        self.generated_samples += count
        if not self.detector_present:
            return [0] * count
        self.qualified_samples += count
        if not self.dial_tone_present:
            # An answering seizure qualifies on the line itself and hears
            # whatever the far end sends, which is silence until something
            # else feeds this DAA.
            return [0] * count
        scale = 4_000
        return [
            round(
                scale * math.sin(2 * math.pi * 350 * index / self.sample_rate)
                + scale * math.sin(2 * math.pi * 440 * index / self.sample_rate)
            )
            for index in range(start, start + count)
        ]

    def status(self) -> dict[str, str | int | bool]:
        value = asdict(self)
        value.update(
            line_connected=self.line_connected,
            dial_tone_present=self.dial_tone_present,
            dial_tone_qualified=self.dial_tone_qualified,
            detector_present=self.detector_present,
            detector_qualified=self.detector_qualified,
        )
        return value
