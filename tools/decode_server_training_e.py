#!/usr/bin/env python3
"""Decode the server's last training stretch (E) with the payload mapper of spec clauses 10 and 11.

Usage: decode_server_training_e.py octets.g711 START_S [SYMBOLS]

E sends six codewords per frame from a nine-entry table (a5 a7 ad af b7 bd c5 cf e5, or
95 97 9d 9f a7 ad b5 bf d5).  Per frame the amplitude digits (table index of each symbol,
position 0 least significant, base 9) give a 19-bit integer X, and the toggles of the MD
highest-ranked positions (largest table index first, ties by position) are the parity
chain of MD independent sign bits.  The bits are the MD sign bits then the 19 bits of X,
least significant first.  Descrambled with 1 + x^-18 + x^-23 they are constant ones.
"""
from __future__ import annotations

import json
import sys

TABLES = {"low": [0xA5, 0xA7, 0xAD, 0xAF, 0xB7, 0xBD, 0xC5, 0xCF, 0xE5],
          "high": [0x95, 0x97, 0x9D, 0x9F, 0xA7, 0xAD, 0xB5, 0xBF, 0xD5]}


def descramble(bits, tap=18):
    return [bits[i] ^ bits[i - tap] ^ bits[i - 23] for i in range(23, len(bits))]


def decode(octets, table, md, b=19):
    index = {}
    for i, o in enumerate(table):
        index[o], index[o ^ 0x80] = i, i
    frames = len(octets) // 6
    bits, parity, maximum, out_of_table = [], 0, 0, 0
    for f in range(frames):
        group = octets[6 * f:6 * f + 6]
        if any(o not in index for o in group):
            out_of_table += 1
            continue
        digits = [index[o] for o in group]
        toggles = [1 if not o & 0x80 else 0 for o in group]
        x = 0
        for d in reversed(digits):
            x = x * 9 + d
        maximum = max(maximum, x)
        if md < 6:
            ranked = sorted(range(6), key=lambda p: (-digits[p], p))
            positions = sorted(ranked[:md])
        else:
            positions = list(range(6))
        for p in positions:
            bits.append(toggles[p] ^ parity)
            parity = toggles[p]
        bits.extend((x >> i) & 1 for i in range(b))
    return bits, maximum, out_of_table, frames


def main(path, start, symbols=10002):
    data = open(path, "rb").read()
    first = int(round(start * 8000))
    octets = list(data[first:first + symbols])
    result = {"file": path, "start_s": start, "symbols": len(octets)}
    for name, table in TABLES.items():
        if not all(o in {t for t in table} | {t ^ 0x80 for t in table} for o in octets[:600]):
            continue
        scores = []
        for md in range(7):
            bits, maximum, bad, frames = decode(octets, table, md)
            if len(bits) <= 100:
                continue
            ones = sum(descramble(bits)) / (len(bits) - 23)
            scores.append({"md": md, "constant_fraction": round(max(ones, 1 - ones), 4),
                           "max_x": maximum, "frames": frames, "frames_outside_table": bad})
        result["table"] = name
        result["octets"] = [f"{t:02x}" for t in table]
        result["by_independent_sign_count"] = scores
        best = max(scores, key=lambda s: s["constant_fraction"])
        result["decoded"] = {"md": best["md"], "bits_per_frame": 19 + best["md"],
                             "bit_rate": round((19 + best["md"]) * 8000 / 6)}
    return result


if __name__ == "__main__":
    if len(sys.argv) < 3:
        raise SystemExit(__doc__)
    print(json.dumps(main(sys.argv[1], float(sys.argv[2]),
                          int(sys.argv[3]) if len(sys.argv) > 3 else 10002), indent=1))
