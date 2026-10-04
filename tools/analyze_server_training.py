#!/usr/bin/env python3
"""Segment a PCMU octet stream by the set of codewords in use and describe each segment.

Usage: analyze_server_training.py octets.g711 START_S END_S

For each stretch with a constant set of octets: its time range, its linear levels
(G.711 mu-law), the smallest exact period, and, for two-level stretches, whether
descrambling the sign bits with 1 + x^-18 + x^-23 or 1 + x^-5 + x^-23 gives constant
bits (scrambled ones), where the constant run ends and the period of what follows.
"""
from __future__ import annotations

import json
import sys

import numpy as np


def ulaw(b):
    c = ~int(b) & 0xFF
    v = ((((c & 15) << 3) + 0x84) << ((c >> 4) & 7)) - 0x84
    return -v if c & 0x80 else v


def smallest_period(x, limit=200, threshold=0.995):
    for p in range(1, min(limit, len(x) // 3)):
        if np.mean(x[p:] == x[:-p]) >= threshold:
            return p
    return None


def descramble(bits, tap):
    return bits[23:] ^ bits[23 - tap:len(bits) - tap] ^ bits[:len(bits) - 23]


def describe(octets, t0):
    values = sorted(set(octets.tolist()), key=ulaw)
    out = {"from_s": round(t0, 4), "to_s": round(t0 + len(octets) / 8000, 4), "octets": len(octets),
           "levels": [ulaw(v) for v in values], "octet_values": [f"{v:02x}" for v in values]}
    period = smallest_period(octets)
    if period:
        out["exact_period_octets"] = period
    if len(values) == 2:
        bits = (octets == values[0]).astype(int)
        best = max(((tap, inv, float(descramble(bits ^ inv, tap).mean()))
                    for tap in (5, 18) for inv in (0, 1)), key=lambda t: abs(t[2] - 0.5))
        tap, inv, frac = best
        if abs(frac - 0.5) > 0.4:
            r = descramble(bits ^ inv, tap)
            const = 1 if frac > 0.5 else 0
            bad = np.where(r != const)[0]
            out["scrambled_constant"] = {
                "polynomial": f"1 + x^-{tap} + x^-23", "constant_bit": const,
                "first_other_bit_at_s": None if len(bad) == 0 else round(t0 + (bad[0] + 23) / 8000, 4)}
            if len(bad):
                rest = r[bad[0]:]
                p = smallest_period(rest, 100, 0.99)
                if p:
                    out["after_constant_run"] = {"bits": len(rest), "period_bits": p,
                                                "pattern": "".join(map(str, rest[:p]))}
    return out


def main(path, start, end):
    raw = np.frombuffer(open(path, "rb").read(), dtype=np.uint8)
    a, b = int(start * 8000), int(end * 8000)
    first = a + int(np.argmax(raw[a:b] != 0x7F))   # skip leading digital zero
    window = 32
    starts, current = [first], set(raw[first:first + window].tolist())
    i = first
    while i + window <= b:
        # first octet from here that the current set does not contain
        outside = next((x for x in range(i, min(i + window, b)) if raw[x] not in current), None)
        if outside is None:
            i += window
            continue
        starts.append(outside)
        current = set(raw[outside:outside + window].tolist())
        if len(current) > 8:
            break    # many-level data: report the rest as one segment
        i = outside + window
    starts.append(b)
    return {"file": path, "first_non_zero_octet_s": round(first / 8000, 4),
            "segments": [describe(raw[x:y], x / 8000) for x, y in zip(starts, starts[1:])]}


if __name__ == "__main__":
    if len(sys.argv) != 4:
        raise SystemExit(__doc__)
    print(json.dumps(main(sys.argv[1], float(sys.argv[2]), float(sys.argv[3])), indent=1))
