from __future__ import annotations

from dataclasses import asdict, dataclass
import math


DAA_SAMPLE_RATE = 9_600
DAA_FRAME_SAMPLES = 960
DAA_LINE_STATES = ("disconnected", "quiet", "dial-tone", "ringing")


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
    def dial_tone_qualified(self) -> bool:
        # The supervisor waits for detector byte 0x0649 to reach five. Model
        # that debounce as five 100 ms ASIC frames rather than asserting it at
        # the instant the hook relay closes.
        return self.qualified_samples >= 5 * DAA_FRAME_SAMPLES

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
        if not self.dial_tone_present:
            return [0] * count
        self.qualified_samples += count
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
        )
        return value
