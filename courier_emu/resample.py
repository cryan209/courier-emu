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

    Output lags input by HALF_TAPS input samples, a fixed delay. Equal rates
    pass through untouched. A change of rate restarts the history, as the
    linear converter did: samples buffered at one spacing mean nothing at
    another.
    """

    def __init__(self) -> None:
        self.input_rate = 0.0
        self.output_rate = 0.0
        self.converted = 0
        self._history: list[float] = [0.0] * TAPS
        # Output instant, in input samples, relative to _history[HALF_TAPS-1].
        self._position = 0.0
        self._kernel: list[tuple[float, ...]] | None = None

    def convert(self, samples: list[int], input_rate: float,
                output_rate: float) -> list[int]:
        if not samples:
            return []
        if input_rate <= 0 or output_rate <= 0 or output_rate == input_rate:
            # Nothing has programmed the codec yet, or the rates agree.
            self._history = (self._history + [float(s) for s in samples])[-TAPS:]
            return list(samples)
        if output_rate != self.output_rate or input_rate != self.input_rate:
            self.input_rate, self.output_rate = input_rate, output_rate
            self._kernel = _kernel_for(
                CUTOFF * min(input_rate, output_rate) / 2 / input_rate)
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
            value = sum(map(mul, kernel[phase], history[base:base + TAPS]))
            result.append(max(-32768, min(32767, int(round(value)))))
            position += step
        consumed = len(history) - TAPS
        self._history = history[consumed:]
        self._position = position - consumed
        self.converted += len(result)
        return result
