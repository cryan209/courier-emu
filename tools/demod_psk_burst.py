#!/usr/bin/env python3
"""Demodulate a stretch of an 8 kHz mono recording to complex symbols, standard library only.

Usage: demod_psk_burst.py recording.wav START_S END_S CARRIER_HZ BAUD out.pkl

Mixes to baseband at CARRIER_HZ, low-pass filters (127-tap windowed sinc, 1700 Hz), recovers
symbol timing from the symbol-rate line of the squared envelope, interpolates, and pickles the
list of complex symbol values.  Slice quadrants with the 4th-power carrier phase.  numpy-free
stand-in for tools/analyze_v34_training.py, for the Courier's phase 3 and phase 4 bursts
(3200 baud, 1920 Hz).
"""
from __future__ import annotations

import cmath
import math
import pickle
import struct
import sys
import wave

FS = 8000


def demodulate(path, t0, t1, carrier, baud):
    with wave.open(path) as w:
        x = struct.unpack("<%dh" % w.getnframes(), w.readframes(w.getnframes()))
    n0, n1 = int(t0 * FS), int(t1 * FS)
    zr = [x[n] * math.cos(2 * math.pi * carrier * n / FS) for n in range(n0, n1)]
    zi = [-x[n] * math.sin(2 * math.pi * carrier * n / FS) for n in range(n0, n1)]
    taps, fc = 127, 1700 / FS
    h = []
    for k in range(taps):
        kk = k - (taps - 1) / 2
        s = 1.0 if kk == 0 else math.sin(2 * math.pi * fc * kk) / (2 * math.pi * fc * kk)
        h.append(s * (0.54 - 0.46 * math.cos(2 * math.pi * k / (taps - 1))) * 2 * fc)

    def conv(a):
        half, out = taps // 2, [0.0] * len(a)
        for i in range(len(a)):
            out[i] = sum(a[j] * h[i - j + half] for j in range(max(0, i - half), min(len(a), i + half + 1)))
        return out

    z = [complex(a, b) for a, b in zip(conv(zr), conv(zi))]
    p = [abs(v) ** 2 for v in z]
    mean = sum(p[100:]) / len(p[100:])
    c = sum((p[k] - mean) * cmath.exp(-2j * math.pi * baud * k / FS) for k in range(100, len(p)))
    step = FS / baud
    offset = ((-cmath.phase(c) / (2 * math.pi)) * step) % step
    symbols, t = [], offset
    while t < len(z) - 1:
        i = int(t)
        f = t - i
        symbols.append(z[i] * (1 - f) + z[i + 1] * f)
        t += step
    return symbols


if __name__ == "__main__":
    if len(sys.argv) != 7:
        raise SystemExit(__doc__)
    s = demodulate(sys.argv[1], float(sys.argv[2]), float(sys.argv[3]), float(sys.argv[4]), float(sys.argv[5]))
    pickle.dump(s, open(sys.argv[6], "wb"))
    print(len(s), "symbols")
