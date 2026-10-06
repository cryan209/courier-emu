"""Band-limited streaming rate conversion for the line <-> codec boundary.

The socket line carries 8 kHz samples and the AC01 converts at whatever rate
the firmware programs - 7200, 7578.95, 8000, 9600 or 10266.67 Hz - so audio
crossing between them has to be re-sampled. Physically that crossing is the
exchange codec's reconstruction filter on one side and an anti-alias filter on
the other: the line between them is analogue and band-limited below 4 kHz.

Linear interpolation, which stood in for that, is a poor model of it for a
modem. Carrying a band-limited signal from 8 kHz to 9600 Hz it scored 9.4 dB
SNR across 300-3800 Hz (25 dB at 1 kHz, 5.5 dB at 3.3 kHz): the passband
droops and every component leaves an image that folds back in band. That caps
V.34, and PCM downstream - which lives on the top of the band - cannot
survive it at all.

This interpolates with a Kaiser-windowed sinc instead. The cutoff sits just
under the lower of the two Nyquist frequencies, so it passes what the line
passes, and the ratio is arbitrary: the output instant is tracked in input
samples and the kernel is read from a finely tabulated set of phases.
"""
from __future__ import annotations

import math
from bisect import bisect_left, bisect_right
from operator import mul

# Input samples each side of the output instant. 64 narrows the transition
# band enough that 8 kHz <-> 9600 Hz stays at 62-75 dB SNR for tones from
# 1 kHz to 3.7 kHz in both directions, and 30-39 dB at 3.8 kHz; 32 lost 3.7
# kHz to 20 dB, which is the top of the band PCM downstream relies on.
HALF_TAPS = 64
TAPS = 2 * HALF_TAPS
# Kaiser beta for about 80 dB of stopband, well under a 14-bit converter.
KAISER_BETA = 8.0
# Cutoff as a fraction of the lower Nyquist frequency: the middle of the
# transition band. 0.98 of 4000 Hz is 3920 Hz.
CUTOFF = 0.98
# Kernel phases per input sample. The fractional position is rounded to the
# nearest one; at 1024 that timing error is under 0.1 us at 8 kHz.
PHASES = 1024

# C-implemented dot product where the interpreter has one (3.12+); the FIR
# below runs it once per output sample.
_dot = getattr(math, "sumprod", None) or (lambda a, b: sum(map(mul, a, b)))


def _bessel_i0(x: float) -> float:
    total, term, k = 1.0, 1.0, 1
    while term > 1e-12 * total:
        term *= (x / (2 * k)) ** 2
        total += term
        k += 1
    return total


def _kernel(cutoff: float) -> list[tuple[float, ...]]:
    """The windowed sinc at each phase, `cutoff` in cycles per input sample.

    Phase p holds the taps for an output instant p/PHASES of the way from
    input sample HALF_TAPS-1 to HALF_TAPS of the window. Each phase is
    normalised to unit DC gain, so a constant passes through exactly.
    """
    norm = _bessel_i0(KAISER_BETA)
    table = []
    for phase in range(PHASES):
        fraction = phase / PHASES
        taps = []
        for k in range(TAPS):
            t = k - (HALF_TAPS - 1) - fraction      # input minus output time
            x = 2 * cutoff * t
            sinc = 1.0 if x == 0 else math.sin(math.pi * x) / (math.pi * x)
            ratio = t / HALF_TAPS
            window = (_bessel_i0(KAISER_BETA * math.sqrt(1 - ratio * ratio))
                      / norm) if abs(ratio) < 1 else 0.0
            taps.append(2 * cutoff * sinc * window)
        total = sum(taps)
        table.append(tuple(tap / total for tap in taps))
    return table


_KERNELS: dict[float, list[tuple[float, ...]]] = {}


def _kernel_for(cutoff: float) -> list[tuple[float, ...]]:
    key = round(cutoff, 9)
    if key not in _KERNELS:
        _KERNELS[key] = _kernel(key)
    return _KERNELS[key]


class BandLimitedResampler:
    """Streaming arbitrary-ratio conversion through a band-limiting kernel.

    Output initially lags input by HALF_TAPS input samples. Equal rates pass
    through untouched until conversion starts. Retunes preserve the output
    timeline and the input history's physical sample spacing.
    """

    def __init__(self) -> None:
        self.input_rate = 0.0
        self.output_rate = 0.0
        self.converted = 0
        self._history: list[float] = [0.0] * TAPS
        # Output instant, in input samples, relative to _history[HALF_TAPS-1].
        self._position = 0.0
        self._kernel: list[tuple[float, ...]] | None = None
        # Keep extra input history for a clock change: its old sample spacing
        # must survive until the FIR window has crossed the boundary.
        self._recent_input: list[float] = [0.0] * (2 * TAPS)
        self._timed_samples: list[float] | None = None
        self._timed_times: list[float] = []
        self._input_time = 0.0
        self._next_time = 0.0

    def _convert_retuned(self, samples: list[int], input_rate: float,
                         output_rate: float) -> list[int]:
        """Interpolate across an input-clock edge in physical time.

        Regular windows still use the cached polyphase kernel. Only windows
        straddling the rate change need nonuniform sinc weights. Re-labeling
        the old history at the new spacing otherwise shifts the whole tone,
        even when the output remains a perfectly continuous 8 kHz stream.
        """
        if self._timed_samples is None:
            old_rate = self.input_rate
            self._timed_samples = list(self._recent_input)
            self._timed_times = [k / old_rate for k in
                                 range(-len(self._recent_input), 0)]
            self._next_time = (self._position - HALF_TAPS - 1) / old_rate
        history = self._timed_samples
        times = self._timed_times
        history.extend(float(s) for s in samples)
        times.extend(self._input_time + k / input_rate for k in range(len(samples)))
        self._input_time += len(samples) / input_rate
        self.input_rate, self.output_rate = input_rate, output_rate
        kernel = _kernel_for(CUTOFF * min(input_rate, output_rate) / 2 / input_rate)
        self._kernel = kernel
        result = []
        instant = self._next_time
        support = HALF_TAPS / input_rate
        cutoff = CUTOFF * min(input_rate, output_rate) / 2
        norm = _bessel_i0(KAISER_BETA)
        while instant + support <= times[-1] + 1e-12:
            center = bisect_right(times, instant) - 1
            base = center - (HALF_TAPS - 1)
            end = base + TAPS
            if (base >= 0 and end <= len(times) and
                    abs(times[end - 1] - times[base] - (TAPS - 1) / input_rate) < 1e-10):
                phase = round((instant - times[center]) * input_rate * PHASES)
                if phase == PHASES:
                    base, phase = base + 1, 0
                value = _dot(kernel[phase], history[base:base + TAPS])
            else:
                # A clock edge creates two spacings in the same window.
                # Integrate over their actual times, with local sample widths,
                # rather than discarding or replaying either side's samples.
                first = max(1, bisect_left(times, instant - support))
                last = min(len(times) - 1, bisect_right(times, instant + support))
                value, total = 0.0, 0.0
                for k in range(first, last):
                    delta = times[k] - instant
                    x = 2 * cutoff * delta
                    sinc = 1.0 if x == 0 else math.sin(math.pi * x) / (math.pi * x)
                    ratio = delta / support
                    window = _bessel_i0(KAISER_BETA * math.sqrt(max(0, 1 - ratio * ratio))) / norm
                    width = (times[k + 1] - times[k - 1]) / 2
                    weight = 2 * cutoff * sinc * window * width
                    value += history[k] * weight
                    total += weight
                value = value / total if total else 0.0
            result.append(max(-32768, min(32767, round(value))))
            instant += 1 / output_rate
        self._next_time = instant
        # Enough past samples for subsequent retunes in the codec's supported
        # range, while keeping long calls bounded in memory.
        keep = max(0, bisect_left(times, instant - 2 * TAPS / min(input_rate, output_rate)) - 1)
        del history[:keep]
        del times[:keep]
        self.converted += len(result)
        return result

    def convert(self, samples: list[int], input_rate: float,
                output_rate: float) -> list[int]:
        if not samples:
            return []
        if input_rate > 0 and output_rate > 0 and (self._timed_samples is not None or
                (self.input_rate > 0 and input_rate != self.input_rate)):
            return self._convert_retuned(samples, input_rate, output_rate)
        self._recent_input = (self._recent_input + [float(s) for s in samples])[-2 * TAPS:]
        if input_rate <= 0 or output_rate <= 0 or (output_rate == input_rate and
                                                  self.input_rate == 0):
            # Nothing has programmed the codec yet, or the rates agree.
            self._history = (self._history + [float(s) for s in samples])[-TAPS:]
            return list(samples)
        if output_rate != self.output_rate or input_rate != self.input_rate:
            input_changed = input_rate != self.input_rate
            self.input_rate, self.output_rate = input_rate, output_rate
            self._kernel = _kernel_for(
                CUTOFF * min(input_rate, output_rate) / 2 / input_rate)
            if input_changed:
                self._position = 0.0
        kernel = self._kernel
        step = input_rate / output_rate
        history = self._history + [float(s) for s in samples]
        # _position counts from history[HALF_TAPS-1]; an output needs
        # HALF_TAPS inputs after it, so it is ready while the window fits.
        result: list[int] = []
        position = self._position
        limit = len(history) - TAPS
        while position <= limit:
            base = int(position)
            phase = int((position - base) * PHASES + 0.5)
            if phase == PHASES:
                base, phase = base + 1, 0
                if base > limit:
                    break
            value = _dot(kernel[phase], history[base:base + TAPS])
            result.append(max(-32768, min(32767, int(round(value)))))
            position += step
        consumed = len(history) - TAPS
        self._history = history[consumed:]
        self._position = position - consumed
        self.converted += len(result)
        return result
