#!/usr/bin/env python3
"""Decode what one end of the PCMU bearer heard before x2 data: V.8, INFO0, tones, source.

Input is a raw log of the octets one end received (``COURIER_PAIR_WIRELOG`` in
tools/probe_imodem_pair.py writes one file per endpoint process).  Output is JSON:
a segment timeline, the V.8 octets, each INFO0 frame with its CRC result and named
capability bits, and the start of the digital startup source and of data.

Needs numpy.  Decoding is signal processing on the saved octets, not firmware state.
"""
from __future__ import annotations

import json
import sys

import numpy as np

RATE = 8000


def ulaw_table() -> np.ndarray:
    out = []
    for b in range(256):
        c = ~b & 0xFF
        v = ((((c & 15) << 3) + 0x84) << ((c >> 4) & 7)) - 0x84
        out.append(-v if c & 0x80 else v)
    return np.array(out, float)


def tone(x, f):
    t = np.arange(len(x)) / RATE
    return abs((x * np.exp(-2j * np.pi * f * t)).sum())


def fsk_bits(x, f1, f0, start, end, baud=300):
    spb = RATE / baud
    best = max(np.arange(0, spb, 1.0), key=lambda off: sum(
        abs(tone(x[int(p):int(p + spb)], f1) - tone(x[int(p):int(p + spb)], f0))
        for p in np.arange(start + off, end - spb, spb)))
    bits, p = [], start + best
    while p + spb <= end:
        seg = x[int(p):int(p + spb)]
        bits.append(1 if tone(seg, f1) > tone(seg, f0) else 0)
        p += spb
    return bits


def octets(bits):
    out, i = [], 0
    while i + 10 <= len(bits):
        if bits[i] == 0 and bits[i + 9] == 1:
            out.append(sum(bits[i + 1 + k] << k for k in range(8)))
            i += 10
        else:
            i += 1
    return out


def crc16(bits):
    crc = 0xFFFF
    for b in bits:
        feedback = (crc ^ b) & 1
        crc >>= 1
        if feedback:
            crc ^= 0x8408
    return crc


def info0(x, carrier, t0, t1):
    n = np.arange(len(x))
    z = x * np.exp(-2j * np.pi * carrier * n / RATE)
    k = np.ones(13) / 13
    z = np.convolve(z.real, k, "same") + 1j * np.convolve(z.imag, k, "same")
    a, b, spb = int(t0 * RATE), int(t1 * RATE), RATE / 600
    def score(off):
        s = z[np.arange(a + off, b - 1, spb).astype(int)]
        return np.sum(np.abs((s[1:] * np.conj(s[:-1])).real))
    off = max(np.arange(0, spb, 0.25), key=score)
    s = z[np.round(np.arange(a + off, b - 1, spb)).astype(int)]
    bits = [0 if v.real > 0 else 1 for v in s[1:] * np.conj(s[:-1])]
    text = "".join(map(str, bits))
    frames, i = [], text.find("01110010")
    while i >= 0:
        body, crc = bits[i + 8:i + 25], bits[i + 25:i + 41]
        if len(crc) == 16:
            frames.append({"body_bits_12_to_28": "".join(map(str, body)),
                           "crc_ok": crc16(bits[i + 8:i + 41]) in (0xF0B8, 0)})
        i = text.find("01110010", i + 1)
    return frames


ITU = {18: "3200 sym/s high carrier", 21: "asym LSB", 22: "asym", 23: "asym MSB",
       24: "CME", 25: "1664-point", 26: "clock LSB", 27: "clock MSB", 28: "ack"}


def name_bits(body):
    return {f"{12 + i}": f"{ITU.get(12 + i, '')} = {b}".strip() for i, b in enumerate(map(int, body))
            if 12 + i in ITU}


def windows(x, w=80):
    """Per 10 ms window: (start second, rms, dominant frequency or 0)."""
    out = []
    for i in range(len(x) // w):
        seg = x[i * w:(i + 1) * w]
        rms = float(np.sqrt((seg ** 2).mean()))
        peak = 0
        if rms >= 20:
            spec = np.abs(np.fft.rfft(seg * np.hanning(w), n=800))
            peak = (int(np.argmax(spec[5:])) + 5) * 10
        out.append((i * w / RATE, rms, peak))
    return out


def runs(win, test, minimum):
    out, start = [], None
    for k, (t, rms, peak) in enumerate(win + [(None, 0, -1)]):
        hit = t is not None and test(rms, peak)
        if hit and start is None:
            start = k
        if not hit and start is not None:
            if (k - start) * 0.01 >= minimum:
                out.append((win[start][0], win[k - 1][0] + 0.01))
            start = None
    return out


def main(path):
    raw = np.frombuffer(open(path, "rb").read(), dtype=np.uint8)
    x = ulaw_table()[raw]
    win = windows(x)
    result = {"file": path, "seconds": round(len(raw) / RATE, 2), "events": []}
    ev = result["events"]

    def add(t0, t1, kind, **extra):
        ev.append({"from_s": round(t0, 3), "to_s": round(t1, 3), "kind": kind, **extra})

    for t0, t1 in runs(win, lambda r, p: abs(p - 2100) <= 40 and r > 500, 0.5):
        add(t0, t1, "answer tone ANSam, about 2100 Hz")
    # V.8 FSK: channel 1 (980/1180) and channel 2 (1650/1850), 300 baud
    for name, lo, hi, f1, f0 in (("V.21 ch1 980/1180", 940, 1220, 980, 1180),
                                 ("V.21 ch2 1650/1850", 1600, 1900, 1650, 1850)):
        for t0, t1 in runs(win, lambda r, p, lo=lo, hi=hi: lo <= p <= hi and r > 500, 0.3):
            bits = fsk_bits(x, f1, f0, int(t0 * RATE), int(t1 * RATE))
            o = octets(bits)
            add(t0, t1, name, octets_hex=" ".join(f"{v:02x}" for v in o[:14]),
                note="first 14 decoded octets")
    # Tones A (2400) and B (1200) and the INFO0 burst just before each
    for freq, label, carrier_name in ((2400, "tone A, 2400 Hz (answer modem)", "answer"),
                                      (1200, "tone B, 1200 Hz (call modem)", "call")):
        for t0, t1 in runs(win, lambda r, p, f=freq: abs(p - f) <= 20 and r > 500, 0.2):
            if t1 - t0 > 0.15 and (t1 - t0) < 1.0:
                frames = info0(x, freq, t0 - 0.12, t0 + 0.02)
                add(t0, t1, label)
                if frames:
                    for f in frames:
                        add(t0 - 0.12, t0, f"INFO0 from the {carrier_name} modem",
                            body_bits_12_to_28=f["body_bits_12_to_28"], crc_ok=f["crc_ok"],
                            named_bits=name_bits(f["body_bits_12_to_28"]))
    first7e = next((i for i in range(len(raw) - 7) if all(raw[i:i + 7] == 0x7E)), None)
    if first7e is not None:
        add(first7e / RATE, first7e / RATE + 2010 / RATE, "startup source (7e x1747, zeros, 128 pairs)")
        sustained = [r for r in runs(win, lambda r, p: r > 5000, 0.3) if r[0] > first7e / RATE + 0.25]
        if sustained:
            add(sustained[0][0], result["seconds"], "full-scale scrambled data")
    ev.sort(key=lambda e: e["from_s"])
    return result


if __name__ == "__main__":
    if len(sys.argv) < 2:
        raise SystemExit(__doc__)
    print(json.dumps(main(sys.argv[1]), indent=1))
