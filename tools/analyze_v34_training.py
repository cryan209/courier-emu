#!/usr/bin/env python3
"""Decode a V.34 style start-up signal from a line recording: S, S-bar, PP and TRN.

Usage: analyze_v34_training.py recording.wav START_S END_S [--baud 3200] [--carrier 1920]

Demodulates the 8 kHz recording at the given carrier and symbol rate, recovers symbol
timing from the symbol-rate line, slices a four-point constellation (fourth-power
carrier phase), then finds the period-2 run (S and S-bar), the period-48 run (PP) and
checks the rest for scrambled ones by descrambling with 1 + x^-5 + x^-23 and with
1 + x^-18 + x^-23.  Needs numpy.  START_S should be the first sample of the burst.
"""
from __future__ import annotations

import itertools
import json
import sys
import wave

import numpy as np

FS = 8000


def load(path):
    with wave.open(path) as w:
        return np.frombuffer(w.readframes(w.getnframes()), dtype=np.int16).astype(float)


def baseband(x, t0, t1, carrier):
    n = np.arange(int(t0 * FS), int(t1 * FS))
    z = x[n] * np.exp(-2j * np.pi * carrier * n / FS)
    taps = 127
    k = np.arange(taps) - (taps - 1) / 2
    h = np.sinc(2 * 1700 / FS * k) * np.hamming(taps) * 2 * 1700 / FS
    return np.convolve(z.real, h, "same") + 1j * np.convolve(z.imag, h, "same")


def symbols(z, baud):
    p = np.abs(z) ** 2
    k = np.arange(len(p))
    c = np.sum((p[100:] - p[100:].mean()) * np.exp(-2j * np.pi * baud * k[100:] / FS))
    step = FS / baud
    offset = ((-np.angle(c) / (2 * np.pi)) * step) % step
    t = np.arange(offset, len(z) - 1, step)
    i = t.astype(int)
    f = t - i
    return z[i] * (1 - f) + z[i + 1] * f


def runs(ok, minimum):
    out, i = [], 0
    while i < len(ok):
        if ok[i]:
            j = i
            while j < len(ok) and ok[j]:
                j += 1
            if j - i >= minimum:
                out.append((i, j))
            i = j
        else:
            i += 1
    return out


def main(path, t0, t1, baud=3200, carrier=1920):
    x = load(path)
    z = baseband(x, t0, t1, carrier)
    s = symbols(z, baud)
    amp = np.abs(s)
    onset = int(np.argmax(amp > 0.5 * np.median(amp[amp > 0])))
    result = {"recording": path, "baud": baud, "carrier_hz": carrier, "symbols": len(s),
              "onset_symbol": onset}
    ph0 = np.angle(np.mean(s[onset + 50:] ** 4)) / 4
    angle = np.angle(s * np.exp(-1j * ph0)) / (np.pi / 2)
    q = np.round(angle).astype(int) % 4
    two = runs(q[2:] == q[:-2], 20)
    if two:
        a, b = two[0]
        result["S_alternating_points"] = {"start": a, "end": b + 2, "length": b + 2 - a}
        # S-bar follows: the same alternation with the opposite points
        c = b + 2
        nxt = runs(q[c + 2:c + 60] == q[c:c + 58], 8)
        if nxt:
            result["S_bar"] = {"start": c, "length": nxt[0][1] + 2}
    start_pp = result.get("S_bar", {}).get("start", onset) + result.get("S_bar", {}).get("length", 0)
    d48 = np.abs(s[48:] - s[:-48]) / np.abs(s).mean() < 0.25
    pp = [r for r in runs(d48, 100) if r[0] >= start_pp - 8]
    if pp:
        a, b = pp[0]
        result["PP_period_48"] = {"start": a, "end": b + 48, "length": b + 48 - a,
                                  "periods": (b + 48 - a) / 48}
    trn_start = result.get("PP_period_48", {}).get("end", start_pp)
    body = q[trn_start:]
    best = None
    for tap in (5, 18):
        for perm in itertools.permutations(range(4)):
            m = np.array(perm)[body]
            bits = np.empty(2 * len(m), int)
            bits[0::2], bits[1::2] = m & 1, (m >> 1) & 1
            r = bits[23:] ^ bits[23 - tap:len(bits) - tap] ^ bits[:len(bits) - 23]
            frac = float(r[400:3000].mean())
            if best is None or max(frac, 1 - frac) > best[0]:
                best = (max(frac, 1 - frac), tap, perm, r, frac)
    score, tap, perm, r, frac = best
    ones = r == (1 if frac > 0.5 else 0)
    chunk, fractions = 200, []
    for k in range(0, len(body), chunk):
        seg = ones[max(2 * k - 46, 0):2 * (k + chunk) - 46]
        fractions.append(round(float(seg.mean()), 2) if len(seg) else None)
    good = [i for i, f in enumerate(fractions) if f is not None and f > 0.9]
    end_guess = trn_start + (good[-1] + 1) * chunk if good else None
    result["TRN_scrambled_ones"] = {
        "start": trn_start, "polynomial": f"1 + x^-{tap} + x^-23", "dibit_map_quadrant_to_value": list(perm),
        "constant_bit_fraction_first_3000_bits": round(score, 3),
        "approx_end_symbol": end_guess, "approx_length": None if end_guess is None else end_guess - trn_start,
        "per_200_symbol_constant_fraction": fractions}
    result["seconds_per_symbol"] = 1 / baud
    return result


if __name__ == "__main__":
    args = [a for a in sys.argv[1:] if not a.startswith("--")]
    opts = dict(zip(sys.argv[1:], sys.argv[2:]))
    if len(args) < 3:
        raise SystemExit(__doc__)
    print(json.dumps(main(args[0], float(args[1]), float(args[2]), int(opts.get("--baud", 3200)),
                          float(opts.get("--carrier", 1920))), indent=1))
