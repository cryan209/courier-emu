"""Continuous peripheral time when a live bearer has an external clock."""
from dataclasses import dataclass
import time


@dataclass
class PeripheralClock:
    rate: int
    instructions: int = 0
    value: int = 0
    origin_time: float | None = None
    origin_value: int = 0

    def read(self, instructions: int, realtime: bool, now: float | None = None) -> int:
        # Offline runs remain deterministic. During a live call the PIT must
        # share the DSP's wall clock even if the host executes the CPU slowly.
        if self.origin_time is not None:
            now = time.monotonic() if now is None else now
            self.value = max(self.value, self.origin_value + int(
                max(0.0, now - self.origin_time) * self.rate))
        else:
            self.value += max(0, instructions - self.instructions)
        self.instructions = instructions
        if realtime and self.origin_time is None:
            self.origin_time = time.monotonic() if now is None else now
            self.origin_value = self.value
        elif not realtime:
            self.origin_time = None
        return self.value
