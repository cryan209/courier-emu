from __future__ import annotations

from dataclasses import asdict, dataclass
import math


DAA_SAMPLE_RATE = 9_600
DAA_FRAME_SAMPLES = 960
DAA_LINE_STATES = ("disconnected", "quiet", "dial-tone", "ringing")

# The harness has no wall clock; its only time base is the 80186 instruction
# count. The answer machine calibrates that: it accepts a ring burst once its
# tick counter at [0x1d50] reaches the country minimum at [0x1f5c], which this
# firmware loads with 180, and a 2,000,000-instruction burst is exactly what
# takes that counter to 180. At the North American 2 s ring that puts one
# firmware tick at 10 ms and the instruction clock at 1,111 per millisecond.
INSTRUCTIONS_PER_MS = 1_111

RING_ON_MS = 2_000
RING_OFF_MS = 4_000
# The supervisor needs roughly five million instructions to reach its command
# loop, so the first burst waits until the modem is actually listening.
RING_START_MS = 8_000


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
