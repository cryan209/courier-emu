#!/usr/bin/env python3
"""Decode the I-modem's post-E signal: V.42 detection pattern, then HDLC frames.

Usage: decode_server_post_e.py octets.g711 START_S END_S

After the constellation training (stretch E) the server keeps sending one frame of six
symbols per 24 bits through the same mapper (nine-entry table a5 a8 ab ae b3 b9 bf cb df,
five independent signs, 19 amplitude bits), scrambled with 1 + x^-18 + x^-23.  The
descrambled bit stream is ones, then the V.42 answer detection pattern (ten-bit characters
'E' and 'C'), then HDLC flags and LAPM frames, least significant bit first.  This tool
descrambles, removes zero insertion between flags and checks the CRC-16 of each frame.
"""
from __future__ import annotations

import json
import sys

sys.path.insert(0, __file__.rsplit("/", 1)[0])
from decode_server_training_e import decode, descramble  # noqa: E402

TABLE = [0xA5, 0xA8, 0xAB, 0xAE, 0xB3, 0xB9, 0xBF, 0xCB, 0xDF]


def crc16(data: bytes) -> int:
    crc = 0xFFFF
    for b in data:
        crc ^= b
        for _ in range(8):
            crc = (crc >> 1) ^ 0x8408 if crc & 1 else crc >> 1
    return crc ^ 0xFFFF


def frames(stream: str):
    pos, out = 0, []
    while True:
        a = stream.find("01111110", pos)
        if a < 0:
            return out
        b = stream.find("01111110", a + 8)
        if b < 0:
            return out
        body = stream[a + 8:b]
        pos = b
        if not body:
            continue
        bits, ones, bad = [], 0, False
        for c in body:
            if ones == 5:
                if c == "1":
                    bad = True
                    break
                ones = 0
                continue
            ones = ones + 1 if c == "1" else 0
            bits.append(c)
        if bad or len(bits) % 8 or len(bits) < 32:
            out.append((a, b, None, len(bits), bad))
            continue
        raw = bytes(int("".join(bits[i:i + 8])[::-1], 2) for i in range(0, len(bits), 8))
        out.append((a, b, raw, len(bits), crc16(raw) == 0x0F47 or crc16(raw[:-2]) == int.from_bytes(raw[-2:], "little")))


def main(path, t0, t1):
    data = open(path, "rb").read()
    start = int(t0 * 8000)
    start -= start % 6 - 1
    octets = list(data[start:start + int((t1 - t0) * 8000) // 6 * 6])
    bits, _, _, nframes = decode(octets, TABLE, 5)
    stream = "".join(map(str, descramble(bits)))
    result = {"start_s": t0, "frames_decoded": nframes, "hdlc": []}
    for a, b, raw, n, ok in frames(stream):
        t = t0 + (a + 23) / 24 * 6 / 8000
        result["hdlc"].append({"t": round(t, 3), "bits": n, "crc_ok": bool(ok) if raw else None,
                               "bytes": raw.hex() if raw else None})
    return result


if __name__ == "__main__":
    if len(sys.argv) < 4:
        raise SystemExit(__doc__)
    print(json.dumps(main(sys.argv[1], float(sys.argv[2]), float(sys.argv[3])), indent=1))
