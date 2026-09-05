"""Capture live Courier RAM through read-only ATGLK2 commands.

Two sequential passes preserve changes rather than inventing a frozen snapshot.
The peripheral control block at ff00..ffff is excluded from all reads.
"""
from __future__ import annotations

import argparse
from collections import Counter
from datetime import datetime, timezone
from hashlib import sha256
import json
from pathlib import Path
import re
import time

from .flash_dump import TARGETS, PAGE, TERMINAL, SerialPort, command_for, parse_page, validate_identity

RAM_END = 0xFF00
SETTINGS_START, SETTINGS_END = 0x752, 0x764
RECORD_ADDRESSES = (0x761, 0x752, 0x755, 0x758, 0x75B, 0x75E)


def decode_settings(data: bytes) -> list[dict]:
    """Decode the three redundant bytes as the captured routine at e237 does."""
    if len(data) != SETTINGS_END - SETTINGS_START:
        raise ValueError("expected 18 cached settings bytes")
    result = []
    for setting, address in enumerate(RECORD_ADDRESSES, 1):
        raw = data[address - SETTINGS_START:address - SETTINGS_START + 3]
        a, b, c = raw
        values = [(((a >> 2) | (a << 6)) + 5) & 255,
                  (((b << 1) | (b >> 7)) - 15) & 255, c ^ 0x1D]
        value, count = Counter(values).most_common(1)[0]
        result.append({"setting": setting, "ram_address": address, "raw_hex": raw.hex(),
                       "decoded_copies": values, "all_copies_agree": count == 3,
                       "majority_valid": count >= 2, "value": value if count >= 2 else None})
    return result


def collect(port, output: Path, *, upper: bool = False) -> dict:
    start, end = (0x10000, 0x20000) if upper else (0, RAM_END)
    length = end - start
    output.mkdir(parents=True, exist_ok=False)
    (output / "responses").mkdir()
    (output / "blocks").mkdir()
    started = time.monotonic()
    report = {
        "status": "running", "device": port.device, "baud": port.baud,
        "started_utc": datetime.now(timezone.utc).isoformat(),
        "physical_start": start, "length_per_pass": length, "passes_required": 2,
        "pages_captured": 0, "failed_attempts": [], "passes": [],
        "firmware_upload": False, "memory_write_commands": False,
        "excluded_ranges": [{"start": 0xFF00, "end_exclusive": 0x10000,
                             "reason": "relocated peripheral control block, not ordinary RAM"}],
        "assumptions": ["The upper window is an uncharacterized CPU address range; data alone does not identify its physical owner."
                        if upper else "ATI7's 64 KiB RAM is visible in the lowest 64 KiB CPU window.",
                        "Each pass is a live sequential capture, not an atomic machine snapshot.",
                        "The AT command itself changes command buffers, stack and other working RAM.",
                        "A cached EEPROM subset is not a complete EEPROM image."],
    }
    statuses = Counter()

    def checkpoint():
        report["elapsed_seconds"] = round(time.monotonic() - started, 2)
        report["terminal_status_counts"] = dict(statuses)
        temporary = output / "manifest.json.tmp"
        temporary.write_text(json.dumps(report, indent=2) + "\n")
        temporary.replace(output / "manifest.json")

    def read_page(address, label):
        for attempt in range(1, 4):
            name = f"{label}-{address:05x}-a{attempt}.txt"
            try:
                raw = port.query(command_for(address, allow_ram=True, allow_upper_ram=upper))
                (output / "responses" / name).write_bytes(raw)
                block, terminal = parse_page(raw, address, allow_ram=True, allow_upper_ram=upper)
                statuses[terminal] += 1
                return block, name, terminal
            except (ValueError, TimeoutError) as exc:
                report["failed_attempts"].append({"address": address, "label": label,
                                                   "attempt": attempt, "error": str(exc)})
                (output / "responses" / f"{name}.resync").write_bytes(port.drain())
                checkpoint()
        raise RuntimeError(f"invalid RAM capture response at {address:05x}; partial files retained")

    checkpoint()
    try:
        (output / "startup.bin").write_bytes(port.drain())
        attention = port.query("AT")
        (output / "attention.txt").write_bytes(attention)
        if not TERMINAL.search(attention) or TERMINAL.search(attention)[1] != b"OK":
            raise RuntimeError("modem did not answer AT with OK")
        identity = port.query("ATI7")
        (output / "ati7.txt").write_bytes(identity)
        report["identity"], target = validate_identity(identity)
        report["firmware"] = {"supervisor": target[0], "dsp": target[1]}
        # The anchors are per-build, so they follow the revision the board just
        # reported rather than one hard-coded pair.
        first, reset = TARGETS[target]
        if not re.search(rb"Ram\s+64k\b", identity, re.I):
            raise RuntimeError("expected the demonstrated 64k RAM profile")
        anchors = {}
        for address in (0x80000, 0xFFF00):
            anchors[address] = read_page(address, "anchor-before")[0]
        if not anchors[0x80000].startswith(first) or anchors[0xFFF00][-16:] != reset:
            raise RuntimeError("firmware anchors differ from the anchors recorded for this firmware")
        print(json.dumps({"event": "identity-and-anchors-confirmed", "physical_start": start,
                          "ram_end_exclusive": end}), flush=True)
        images = []
        with (output / "pages.jsonl").open("x") as log:
            for number in (1, 2):
                image = bytearray()
                pass_started = time.monotonic()
                for address in range(start, end, PAGE):
                    block, response, terminal = read_page(address, f"pass{number}")
                    (output / "blocks" / f"pass{number}-{address:05x}.bin").write_bytes(block)
                    image.extend(block)
                    log.write(json.dumps({"pass": number, "physical_address": address,
                                          "bytes": len(block), "sha256": sha256(block).hexdigest(),
                                          "response": response, "terminal": terminal,
                                          "elapsed_seconds": round(time.monotonic() - started, 3)}) + "\n")
                    log.flush()
                    report["pages_captured"] += 1
                    if report["pages_captured"] % 64 == 0:
                        checkpoint()
                        print(json.dumps({"event": "progress", "pages": report["pages_captured"],
                                          "total": 2 * length // PAGE}), flush=True)
                if len(image) != length:
                    raise RuntimeError("RAM pass has the wrong length")
                filename = f"ram-pass{number}.bin"
                with (output / filename).open("xb") as stream:
                    stream.write(image)
                images.append(bytes(image))
                report["passes"].append({"image": filename, "sha256": sha256(image).hexdigest(),
                                         "seconds": round(time.monotonic() - pass_started, 2)})
                checkpoint()
        for address, original in anchors.items():
            if read_page(address, "anchor-after")[0] != original:
                raise RuntimeError("firmware anchor changed during the RAM capture")
        if upper:
            # Bracket an upper read with fresh low reads; do not write test
            # patterns into a running modem to force an alias determination.
            comparisons = []
            for low in (0, 0x700, 0x2000, 0x8000, 0xE000, 0xFE00):
                before = read_page(low, "alias-low-before")[0]
                high = read_page(low + 0x10000, "alias-upper")[0]
                after = read_page(low, "alias-low-after")[0]
                stable = [i for i in range(PAGE) if before[i] == after[i]]
                comparisons.append({"lower_address": low, "upper_address": low + 0x10000,
                                    "lower_stable_bytes": len(stable),
                                    "upper_matches_stable_lower_bytes": sum(high[i] == before[i] for i in stable),
                                    "matches_lower_before": high == before,
                                    "matches_lower_after": high == after})
            report["alias_samples"] = comparisons
        changed = [start + i for i, (a, b) in enumerate(zip(*images)) if a != b]
        differences = {"changed_bytes": len(changed), "physical_addresses": changed,
                       "meaning": "observed differences; matching bytes do not prove an atomic or immutable snapshot"}
        (output / "differences.json").write_text(json.dumps(differences, indent=2) + "\n")
        if not upper:
            settings = []
            for number, image in enumerate(images, 1):
                cached = image[SETTINGS_START:SETTINGS_END]
                (output / f"settings-cache-pass{number}.bin").write_bytes(cached)
                settings.append({"pass": number, "sha256": sha256(cached).hexdigest(),
                                 "records": decode_settings(cached)})
            report["settings_cache"] = {"start": SETTINGS_START, "end_exclusive": SETTINGS_END,
                                         "matches_between_passes": images[0][SETTINGS_START:SETTINGS_END] == images[1][SETTINGS_START:SETTINGS_END],
                                         "passes": settings}
        report.update(status="complete", changed_bytes=len(changed), anchors_rechecked=True,
                      finished_utc=datetime.now(timezone.utc).isoformat())
        return report
    except BaseException as exc:
        report.update(status="incomplete", error=f"{type(exc).__name__}: {exc}")
        raise
    finally:
        checkpoint()


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--device", required=True)
    parser.add_argument("--baud", type=int, choices=(9600, 19200, 38400, 57600, 115200), default=115200)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--window", choices=("lower", "upper"), default="lower",
                        help="lower: 00000..0feff; upper: 10000..1ffff plus six lower/upper alias comparisons")
    args = parser.parse_args()
    if args.output.exists():
        parser.error("output directory already exists; use a new directory")
    try:
        with SerialPort(args.device, args.baud, allow_ram=True,
                        allow_upper_ram=args.window == "upper") as port:
            report = collect(port, args.output, upper=args.window == "upper")
        print(json.dumps({k: v for k, v in report.items() if k != "identity"}, indent=2))
        return 0
    except (OSError, ValueError, RuntimeError) as exc:
        print(json.dumps({"status": "failed", "error": str(exc), "output": str(args.output)}), flush=True)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
