#!/usr/bin/env python3
"""Decode the Courier's phase 4 MP sequence (16-point constellation) from its line recording.

Usage: decode_courier_mp16.py analog-tx.wav [WINDOW_START_S WINDOW_END_S MP_FIRST MP_LAST]

Defaults are the 53333/x2 call: window 35.1-42.0 s of the analog recording, MP in burst
symbols 5000-7500 (the `af63` state, instructions 956.25M-983.99M in the DSP trace).  The
symbols come from demod_psk_burst.demodulate (3200 baud, 1920 Hz).  Each is placed in one of
the four rotation orbits of the V.34 16-point constellation (rings 4/8/4 at radii 1.41, 3.16,
4.24 grid units, in the 45-degree-rotated frame the DSP's table `c20f` uses), the rotation Z
is differentially decoded, the four bits per symbol (orbit index high, difference low, least
significant first) are descrambled with 1 + x^-5 + x^-23 and the 17-ones frame sync is
located.  The conventions fixed by search on this capture: clockwise Z (sign -1), orbit offsets
(0, 1, 2, 2), orbits 1 and 2 as measured.  Prints each distinct 104-bit frame and its fields
per V.34 Table 20.  The CRC of the frames does not verify against Figure 14 at any alignment
tried, and the frame is 104 bits where Table 20 has 88.
"""
from __future__ import annotations

import cmath
import collections
import math
import re
import sys

sys.path.insert(0, __file__.rsplit("/", 1)[0])
from demod_psk_burst import demodulate  # noqa: E402

ORBIT_OFFSET = (0, 1, 2, 2)


def classify(symbols, phase):
    out = []
    for v in symbols:
        p = v * cmath.exp(-1j * phase)
        r, a = abs(p), math.degrees(cmath.phase(p)) % 360
        if r < 3000:
            orbit, base = 0, 0.0
        elif r > 5200:
            orbit, base = 3, 0.0
        elif a % 90 < 45:
            orbit, base = 1, 26.565
        else:
            orbit, base = 2, 63.435
        out.append((orbit, int(round((a - base) / 90)) % 4))
    return out


def decode_bits(cls):
    bits, prev = [], 0
    for orbit, z in cls:
        zz = (-z + ORBIT_OFFSET[orbit]) % 4
        nibble = (orbit << 2) | ((zz - prev) % 4)
        prev = zz
        bits += [(nibble >> k) & 1 for k in range(4)]
    return "".join(str(bits[i] ^ bits[i - 5] ^ bits[i - 23]) for i in range(23, len(bits)))


def fields(f):
    def val(a, b):
        return sum(f[a + i] << i for i in range(b - a + 1))
    mask = val(35, 49)
    return {
        "start_bits_17_34_51_68": [f[17], f[34], f[51], f[68]],
        "type": f[18], "max_call_to_answer_N": val(20, 23), "max_answer_to_call_N": val(24, 27),
        "aux": f[28], "trellis": val(29, 30), "nonlinear": f[31], "shaping": f[32], "ack": f[33],
        "rate_mask_rates": [2400 * (i + 1) for i in range(15) if mask >> i & 1],
        "asymmetric": f[50], "reserved_52_67": val(52, 67),
        "bits_69_84": "".join(map(str, f[69:85])), "fill_85_87": f[85:88],
        "extra_88_103": "".join(map(str, f[88:104])),
    }


def main(path, t0=35.1, t1=42.0, first=5000, last=7500):
    syms = demodulate(path, t0, t1, 1920, 3200)
    phase = cmath.phase(sum(v ** 4 for v in syms[first:last])) / 4
    bits = decode_bits(classify(syms[first:last], phase))
    starts = [m.start() for m in re.finditer("1{17,}0", bits)]
    frames = collections.Counter(bits[s:s + 104] for s in starts if s + 104 <= len(bits))
    print(f"{len(bits)} bits, {len(starts)} frame syncs, spacing {collections.Counter(b - a for a, b in zip(starts, starts[1:])).most_common(2)}")
    for frame, n in frames.most_common(3):
        print(n, frame)
    if frames:
        import json
        print(json.dumps(fields([int(c) for c in frames.most_common(1)[0][0]]), indent=1))


if __name__ == "__main__":
    a = sys.argv
    main(a[1], *(float(x) for x in a[2:4]), *(int(x) for x in a[4:6])) if len(a) > 2 else main(a[1])
