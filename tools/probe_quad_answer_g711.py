"""Render QF060003 ANS and ANSam variants through its own G.711/serial path."""
from __future__ import annotations

import argparse
import hashlib
import json
import math
from pathlib import Path
import struct
import wave

from courier_emu.quad_audio import ANSWER_VARIANTS, render_answer_g711

ROOT = Path(__file__).resolve().parents[1]
RAM = ROOT / "artifacts/quad-identify-20260910/ram.bin"


def write_wave(path: Path, samples: list[int]) -> None:
    with wave.open(str(path), "wb") as output:
        output.setnchannels(1)
        output.setsampwidth(2)
        output.setframerate(8_000)
        output.writeframes(struct.pack(f"<{len(samples)}h", *samples))


def measure(samples: list[int], rate: int = 8_000) -> dict[str, object]:
    def magnitude(frequency: float) -> float:
        return abs(sum(
            sample * complex(math.cos(2 * math.pi * frequency * i / rate),
                             math.sin(2 * math.pi * frequency * i / rate))
            for i, sample in enumerate(samples)
        ))
    carrier = magnitude(2100)
    return {
        "carrier_hz": max(range(2080, 2121), key=magnitude),
        "sideband_ratio": {
            "2084.95": round(magnitude(2084.95) / carrier, 4),
            "2115.05": round(magnitude(2115.05) / carrier, 4),
        },
        "rms": round(math.sqrt(sum(x * x for x in samples) / len(samples)), 1),
        "peak": max(map(abs, samples)),
    }


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--ram", type=Path, default=RAM)
    parser.add_argument("--output", type=Path,
                        default=ROOT / "artifacts/quad-answer-g711-20260910")
    parser.add_argument("--seconds", type=float, default=2.0)
    args = parser.parse_args()
    if args.seconds <= 0:
        parser.error("--seconds must be positive")
    args.output.mkdir(parents=True, exist_ok=True)
    ram = args.ram.read_bytes()
    count = round(args.seconds * 8_000)
    report = {
        "producer": "QF060003 answer-tone callbacks, compressor 0x817f, ISR 0x83e1",
        "sample_rate": 8_000,
        "symbols_per_tone": count,
        "tones": {},
    }
    for variant in ANSWER_VARIANTS:
        report["tones"][variant] = {}
        for law in ("a", "mu"):
            codewords, decoded, state = render_answer_g711(
                ram, variant, law=law, count=count)
            name = f"qf-{variant}-{law}law.g711"
            (args.output / name).write_bytes(codewords)
            preview = f"qf-{variant}-{law}law.wav"
            write_wave(args.output / preview, decoded)
            report["tones"][variant][law] = {
                "file": name,
                "preview": preview,
                "sha256": hashlib.sha256(codewords).hexdigest(),
                "unique_codewords": len(set(codewords)),
                "measured": measure(decoded),
                "armed": {key: hex(value) for key, value in state["armed"].items()},
                "dxr_writes": state["serial"]["dxr_writes"],
                "last_dxr_pc": hex(state["serial"]["last_dxr_pc"]),
            }
    (args.output / "results.json").write_text(json.dumps(report, indent=2) + "\n")
    print(json.dumps(report, indent=2))


if __name__ == "__main__":
    main()
