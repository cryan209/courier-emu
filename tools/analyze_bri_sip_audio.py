#!/usr/bin/env python3
"""Summarize the two G.711 captures from an inbound BRI-over-SIP run.

The inputs are deliberately directional: --from-caller is RTP received from
the originating modem and delivered toward the I-modem DSP; --from-imodem is
the B-channel stream emitted by that DSP and sent back as RTP.
"""
from __future__ import annotations

import argparse
import json
import math
from pathlib import Path
import struct
import wave

from courier_emu.sip import PCMU_RATE, ulaw_to_linear


PROBES = {
    980: "v21-mark",
    1180: "v21-space",
    1300: "calling-tone",
    2100: "ansam",
}
WINDOW = 1600  # 200 ms: long enough to resolve V.8 tones and ANSam.


def _magnitude(samples: list[int], frequency: float) -> float:
    if not samples:
        return 0.0
    omega = 2 * math.pi * frequency / PCMU_RATE
    cosine, sine = math.cos(omega), math.sin(omega)
    coefficient = 2 * cosine
    first = second = 0.0
    for sample in samples:
        current = sample + coefficient * first - second
        second, first = first, current
    return math.hypot(first - second * cosine, second * sine) / len(samples)


def analyze(path: Path) -> tuple[dict[str, object], list[int]]:
    codewords = path.read_bytes()
    samples = [ulaw_to_linear(value) for value in codewords]
    windows = [samples[start:start + WINDOW]
               for start in range(0, len(samples), WINDOW)
               if len(samples[start:start + WINDOW]) >= WINDOW // 2]
    strongest: dict[str, dict[str, float | int]] = {}
    for frequency, name in PROBES.items():
        values = [_magnitude(block, frequency) for block in windows]
        best = max(range(len(values)), key=values.__getitem__) if values else 0
        strongest[name] = {
            "hz": frequency,
            "magnitude": round(values[best], 1) if values else 0.0,
            "at_seconds": round(best * WINDOW / PCMU_RATE, 3),
        }
    ansam_values = [_magnitude(block, 2100) for block in windows]
    ansam_best = max(range(len(ansam_values)), key=ansam_values.__getitem__) \
        if ansam_values else 0
    ansam_window = windows[ansam_best] if windows else []
    carrier = _magnitude(ansam_window, 2100)
    sidebands = {
        str(frequency): round(_magnitude(ansam_window, frequency), 1)
        for frequency in (2084.95, 2115.05)
    }
    sideband_ratio = {
        frequency: round(value / carrier, 4) if carrier else 0.0
        for frequency, value in sidebands.items()
    }
    rms = math.sqrt(sum(value * value for value in samples) / len(samples)) \
        if samples else 0.0
    return ({
        "path": str(path.resolve()),
        "octets": len(codewords),
        "seconds": round(len(codewords) / PCMU_RATE, 3),
        "idle_codewords": sum(value == 0xff for value in codewords),
        "non_idle_codewords": sum(value != 0xff for value in codewords),
        "rms": round(rms, 1),
        "peak": max((abs(value) for value in samples), default=0),
        "strongest_windows": strongest,
        "ansam_2100hz_window": {
            "at_seconds": round(ansam_best * WINDOW / PCMU_RATE, 3),
            "sideband_magnitude": sidebands,
            "sideband_to_carrier_ratio": sideband_ratio,
        },
    }, samples)


def write_wave(path: Path, samples: list[int]) -> None:
    with wave.open(str(path), "wb") as output:
        output.setnchannels(1)
        output.setsampwidth(2)
        output.setframerate(PCMU_RATE)
        output.writeframes(struct.pack(f"<{len(samples)}h", *samples))


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("--from-caller", type=Path, required=True)
    parser.add_argument("--from-imodem", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    args.output.mkdir(parents=True, exist_ok=True)

    caller, caller_samples = analyze(args.from_caller)
    imodem, imodem_samples = analyze(args.from_imodem)
    write_wave(args.output / "caller-to-imodem.wav", caller_samples)
    write_wave(args.output / "imodem-to-caller.wav", imodem_samples)
    report = {
        "sample_rate": PCMU_RATE,
        "caller_to_imodem_dsp_bearer": caller,
        "imodem_dsp_bearer_to_caller": imodem,
        "interpretation": (
            "Confirm the run JSON reports bri.media.rx_delivered >= the SIP "
            "received_from_rtp count. A strong 2100 Hz window in the I-modem "
            "capture plus symmetric 2084.95/2115.05 Hz sidebands is ANSam "
            "evidence; energy near 980/1180 Hz "
            "and changing non-idle audio in the caller capture is V.8 evidence."
        ),
    }
    report_path = args.output / "audio-analysis.json"
    report_path.write_text(json.dumps(report, indent=2, sort_keys=True) + "\n")
    print(json.dumps(report, indent=2, sort_keys=True))


if __name__ == "__main__":
    main()
