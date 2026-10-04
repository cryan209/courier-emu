#!/usr/bin/env python3
"""Generate the I-modem's pattern A and optionally check it against a PCMU capture.

Usage: server_pattern_a.py [octets.g711 START_S]

Pattern A is the first 363 octets of the server's post-marker training script
(c9c8 for 352 symbols, then c9dd for 11).  Per symbol n, with c = n // 11 and
k = n % 11:

    sign  = bit k of 0x5b8                         (Barker-11: + + + - - - + - - + -)
    level = bit k of 0x712 for even c, of its complement for odd c
    octet = (0xbd if level else 0xab), with bit 7 flipped when sign is 1,
            and bit 7 flipped again for the last 11 symbols (n >= 352)

With a capture, START_S is searched in a 50 ms window for the best alignment.
"""
from __future__ import annotations

import sys

BARKER = 0x5B8
LEVELS = 0x712
LENGTH = 363


def pattern(length: int = LENGTH) -> bytes:
    out = bytearray()
    for n in range(length):
        c, k = divmod(n, 11)
        word = LEVELS if c % 2 == 0 else ~LEVELS & 0xFFFF
        octet = 0xBD if (word >> k) & 1 else 0xAB
        if (BARKER >> k) & 1:
            octet ^= 0x80
        if n >= 352:
            octet ^= 0x80
        out.append(octet)
    return bytes(out)


def main(argv):
    expected = pattern()
    if len(argv) < 2:
        print(expected.hex())
        return
    data = open(argv[0], "rb").read()
    center = int(float(argv[1]) * 8000)
    best = max(range(center - 200, center + 200),
               key=lambda s: sum(a == b for a, b in zip(data[s:s + LENGTH], expected)))
    matched = sum(a == b for a, b in zip(data[best:best + LENGTH], expected))
    print(f"best start {best / 8000:.4f} s: {matched} of {LENGTH} octets match")
    print(f"octets after the pattern: {data[best + LENGTH:best + LENGTH + 8].hex()}")


if __name__ == "__main__":
    main(sys.argv[1:])
