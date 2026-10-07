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

import ctypes
import math
import os
from array import array
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


_NORM = _bessel_i0(KAISER_BETA)
_WINDOWS: list[tuple[float, ...]] | None = None


def _windows() -> list[tuple[float, ...]]:
    """The Kaiser window at each tap of each phase.

    It depends on the tap's offset from the output instant and not on the
    cutoff, so every kernel shares it; only the sinc is computed per cutoff.
    """
    global _WINDOWS
    if _WINDOWS is None:
        table = []
        for phase in range(PHASES):
            fraction = phase / PHASES
            row = []
            for k in range(TAPS):
                t = k - (HALF_TAPS - 1) - fraction
                ratio = t / HALF_TAPS
                row.append(_bessel_i0(KAISER_BETA * math.sqrt(1 - ratio * ratio))
                           / _NORM if abs(ratio) < 1 else 0.0)
            table.append(tuple(row))
        _WINDOWS = table
    return _WINDOWS


def _kernel(cutoff: float) -> list[tuple[float, ...]]:
    """The windowed sinc at each phase, `cutoff` in cycles per input sample.

    Phase p holds the taps for an output instant p/PHASES of the way from
    input sample HALF_TAPS-1 to HALF_TAPS of the window. Each phase is
    normalised to unit DC gain, so a constant passes through exactly.
    """
    windows = _windows()
    table = []
    for phase in range(PHASES):
        fraction = phase / PHASES
        row = windows[phase]
        taps = []
        for k in range(TAPS):
            t = k - (HALF_TAPS - 1) - fraction      # input minus output time
            x = 2 * cutoff * t
            sinc = 1.0 if x == 0 else math.sin(math.pi * x) / (math.pi * x)
            taps.append(2 * cutoff * sinc * row[k])
        total = sum(taps)
        table.append(tuple(tap / total for tap in taps))
    return table


_KERNELS: dict[float, list[tuple[float, ...]]] = {}
_FLAT_KERNELS: dict[float, array] = {}


def _kernel_for(cutoff: float) -> list[tuple[float, ...]]:
    key = round(cutoff, 9)
    if key not in _KERNELS:
        _KERNELS[key] = _kernel(key)
    return _KERNELS[key]


def _flat_kernel_for(cutoff: float) -> array:
    """The same table as one array, row after row, for the native loop."""
    key = round(cutoff, 9)
    flat = _FLAT_KERNELS.get(key)
    if flat is None:
        flat = _FLAT_KERNELS[key] = array(
            "d", (tap for row in _kernel_for(cutoff) for tap in row))
    return flat


_NATIVE = None


def _native_retuned():
    """The native per-sample loop of `_convert_retuned`, or False without it."""
    global _NATIVE
    if _NATIVE is None:
        _NATIVE = False
        if os.environ.get("COURIER_NATIVE_RESAMPLE", "1") != "0":
            try:
                from .dsp import load_library
                function = load_library().courier_resample_retuned
                function.restype = ctypes.c_size_t
                function.argtypes = [
                    ctypes.c_void_p, ctypes.c_size_t, ctypes.c_void_p, ctypes.c_size_t,
                    ctypes.c_void_p, ctypes.c_double, ctypes.c_double, ctypes.c_double,
                    ctypes.c_double, ctypes.c_double, ctypes.c_double,
                    ctypes.c_void_p, ctypes.c_size_t,
                    ctypes.c_void_p, ctypes.c_void_p]
                _NATIVE = function
            except Exception:  # no library: the Python below is the reference
                _NATIVE = False
    return _NATIVE


class _NativeTimed:
    """BandLimitedResampler's retuned state, kept in native memory.

    The Python attributes it replaces (_timed_samples, _timed_times,
    _input_time, _next_time) are only seeded from; afterwards this is the
    state, so that the analog worker's native line service converts on the
    same copy (see courier_worker_poll).
    """

    def __init__(self, library, history: array, times: array, input_time: float,
                 next_time: float, input_rate: float, output_rate: float) -> None:
        self.library = library
        self.handle = library.courier_timed_create(_NORM)
        library.courier_timed_seed(
            self.handle, history.buffer_info()[0], len(history),
            times.buffer_info()[0], len(times), input_time, next_time,
            float(input_rate), float(output_rate))
        self._out = array("h")

    def convert(self, samples: list[int], input_rate: float, output_rate: float,
                kernel: array) -> list[int]:
        values = array("h", samples)
        count = self.library.courier_timed_convert(
            self.handle, values.buffer_info()[0], len(values),
            float(input_rate), float(output_rate), kernel.buffer_info()[0])
        if not count:
            return []
        out = array("h", bytes(2 * count))
        self.library.courier_timed_take(self.handle, out.buffer_info()[0])
        return out.tolist()

    def __del__(self) -> None:  # pragma: no cover - interpreter shutdown order
        try:
            self.library.courier_timed_destroy(self.handle)
        except Exception:
            pass


_TIMED_LIBRARY = None


def _native_timed_library():
    """The library with the native retuned state, or False without it."""
    global _TIMED_LIBRARY
    if not _native_retuned():
        return False
    if _TIMED_LIBRARY is None:
        _TIMED_LIBRARY = False
        from .dsp import load_library
        library = load_library()
        c = ctypes
        library.courier_timed_create.restype = c.c_void_p
        library.courier_timed_create.argtypes = [c.c_double]
        library.courier_timed_destroy.argtypes = [c.c_void_p]
        library.courier_timed_seed.argtypes = [
            c.c_void_p, c.c_void_p, c.c_size_t, c.c_void_p, c.c_size_t,
            c.c_double, c.c_double, c.c_double, c.c_double]
        library.courier_timed_convert.restype = c.c_size_t
        library.courier_timed_convert.argtypes = [
            c.c_void_p, c.c_void_p, c.c_size_t, c.c_double, c.c_double, c.c_void_p]
        library.courier_timed_take.argtypes = [c.c_void_p, c.c_void_p]
        library.courier_timed_converted.restype = c.c_uint64
        library.courier_timed_converted.argtypes = [c.c_void_p]
        _TIMED_LIBRARY = library
    return _TIMED_LIBRARY


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
        self._timed_samples: array | None = None
        self._timed_times: array = array("d")
        self._input_time = 0.0
        self._next_time = 0.0
        self._timed: _NativeTimed | None = None

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
            self._timed_samples = array("d", self._recent_input)
            self._timed_times = array("d", (k / old_rate for k in
                                            range(-len(self._recent_input), 0)))
            self._next_time = (self._position - HALF_TAPS - 1) / old_rate
            library = _native_timed_library()
            if library:
                self._timed = _NativeTimed(
                    library, self._timed_samples, self._timed_times,
                    self._input_time, self._next_time, self.input_rate, self.output_rate)
        if self._timed is not None:
            # The same arithmetic, on the native copy of the state.
            self.input_rate, self.output_rate = input_rate, output_rate
            kernel_cutoff = CUTOFF * min(input_rate, output_rate) / 2 / input_rate
            self._kernel = _kernel_for(kernel_cutoff)
            result = self._timed.convert(samples, input_rate, output_rate,
                                         _flat_kernel_for(kernel_cutoff))
            self.converted += len(result)
            return result
        history = self._timed_samples
        times = self._timed_times
        history.extend(map(float, samples))
        times.extend(self._input_time + k / input_rate for k in range(len(samples)))
        self._input_time += len(samples) / input_rate
        self.input_rate, self.output_rate = input_rate, output_rate
        kernel_cutoff = CUTOFF * min(input_rate, output_rate) / 2 / input_rate
        kernel = _kernel_for(kernel_cutoff)
        self._kernel = kernel
        result = []
        instant = self._next_time
        support = HALF_TAPS / input_rate
        cutoff = CUTOFF * min(input_rate, output_rate) / 2
        norm = _NORM
        native = _native_retuned()
        if native:
            flat_kernel = _flat_kernel_for(kernel_cutoff)
            out = array("h", bytes(2 * 1024))
            instant_cell, status_cell = ctypes.c_double(), ctypes.c_int()
        while instant + support <= times[-1] + 1e-12:
            if native:
                # The whole of it, a sample at a clock edge included.
                written = native(
                    history.buffer_info()[0], len(history),
                    times.buffer_info()[0], len(times),
                    flat_kernel.buffer_info()[0], input_rate, output_rate,
                    instant, support, cutoff, norm, out.buffer_info()[0], len(out),
                    ctypes.addressof(instant_cell), ctypes.addressof(status_cell))
                if written:
                    result.extend(out[:written])
                instant = instant_cell.value
                continue
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
