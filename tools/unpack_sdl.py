#!/usr/bin/env python3
"""Extract the packetized modem image from old USRobotics SDL executables.

The DOS downloader stores firmware as runs of 16-byte payload records.  Each
record is followed by a checksum byte, a 0x10 byte, and a 24-bit big-endian
address token.  The token advances by 0x1000 for each 16 payload bytes.  Runs
are separated by small descriptor/control records.

This tool preserves each run separately because the meaning of the address
token and the inter-run descriptors is not yet fully recovered.
"""

from __future__ import annotations

import argparse
import json
from pathlib import Path

RECORD_DATA = 16
RECORD_SIZE = 21
ADDRESS_STEP = 0x1000
ADDRESS_MASK = 0xFFFFFF


def packet_runs(data: bytes, minimum_records: int = 8) -> list[dict[str, object]]:
    candidates: list[tuple[int, int, int, int]] = []
    limit = len(data) - RECORD_SIZE
    for start in range(max(0, limit)):
        if data[start + 17] != RECORD_DATA:
            continue
        first_next = int.from_bytes(data[start + 18 : start + 21], "big")
        end = start + RECORD_SIZE
        records = 1
        while end + RECORD_SIZE <= len(data):
            expected = (first_next + records * ADDRESS_STEP) & ADDRESS_MASK
            if data[end + 17] != RECORD_DATA:
                break
            if int.from_bytes(data[end + 18 : end + 21], "big") != expected:
                break
            end += RECORD_SIZE
            records += 1
        if records >= minimum_records:
            candidates.append((start, end, records, first_next))

    # The byte immediately before a run can accidentally look like a one-record
    # prefix. Keep the longest candidate for each overlapping packet sequence.
    selected: list[tuple[int, int, int, int]] = []
    for candidate in sorted(candidates, key=lambda item: (item[0], -item[2])):
        if selected and candidate[0] < selected[-1][1]:
            if candidate[2] > selected[-1][2]:
                selected[-1] = candidate
            continue
        selected.append(candidate)

    result: list[dict[str, object]] = []
    for index, (start, end, records, first_next) in enumerate(selected):
        payload = bytearray()
        checksums = bytearray()
        cursor = start
        for _ in range(records):
            payload.extend(data[cursor : cursor + RECORD_DATA])
            checksums.append(data[cursor + RECORD_DATA])
            cursor += RECORD_SIZE
        result.append(
            {
                "index": index,
                "file_offset": start,
                "file_end": end,
                "records": records,
                "payload_size": len(payload),
                "first_next_address_token": first_next,
                "payload": bytes(payload),
                "checksums": bytes(checksums),
            }
        )
    return result


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("image", type=Path)
    parser.add_argument("output", type=Path)
    parser.add_argument("--minimum-records", type=int, default=8)
    args = parser.parse_args()

    runs = packet_runs(args.image.read_bytes(), args.minimum_records)
    args.output.mkdir(parents=True, exist_ok=True)
    manifest: list[dict[str, int | str]] = []
    for run in runs:
        name = f"segment-{int(run['index']):02d}.bin"
        (args.output / name).write_bytes(run.pop("payload"))  # type: ignore[arg-type]
        checksum_name = f"segment-{int(run['index']):02d}.checksums.bin"
        (args.output / checksum_name).write_bytes(run.pop("checksums"))  # type: ignore[arg-type]
        manifest.append({"file": name, "checksums": checksum_name, **run})  # type: ignore[dict-item]
    # A nonzero address token continues the previous destination image. Runs
    # split because descriptor/control bytes are interspersed in the EXE, not
    # because the destination starts over. Also publish the reconstructed
    # images so callers do not need to understand that packaging detail.
    modules: list[dict[str, int | str | list[int]]] = []
    module_data: list[bytearray] = []
    for run in manifest:
        destination = int(run["first_next_address_token"]) >> 8
        segment_index = int(run["index"])
        segment = (args.output / str(run["file"])).read_bytes()
        if destination and module_data:
            expected = len(module_data[-1])
            if destination != expected:
                modules[-1]["address_discontinuity"] = destination - expected
            module_data[-1].extend(segment)
            modules[-1]["segments"].append(segment_index)  # type: ignore[union-attr]
            modules[-1]["payload_size"] = len(module_data[-1])
        else:
            module_data.append(bytearray(segment))
            modules.append(
                {
                    "index": len(modules),
                    "file": f"module-{len(modules):02d}.bin",
                    "segments": [segment_index],
                    "payload_size": len(segment),
                }
            )
    # Each reconstructed module begins with a 16-byte SDL descriptor. Bytes
    # 10..13 are the constant 02 00 00 02 and bytes 14..15 are the big-endian
    # 80186 load segment. The following module normally begins one paragraph
    # beyond the rounded-up end of the previous one, confirming that this is a
    # segment rather than a C51 program address.
    flash = bytearray(b"\xff" * 0x100000)
    occupied: list[tuple[int, int]] = []
    for module, payload in zip(modules, module_data):
        (args.output / str(module["file"])).write_bytes(payload)
        if len(payload) < 16 or payload[10:14] != b"\x02\x00\x00\x02":
            module["descriptor_error"] = "missing 02000002 marker"
            continue
        load_segment = int.from_bytes(payload[14:16], "big")
        load_address = load_segment << 4
        image = payload[16:]
        image_name = f"image-{int(module['index']):02d}-{load_address:05x}.bin"
        (args.output / image_name).write_bytes(image)
        module["descriptor_prefix"] = payload[:10].hex()
        module["load_segment"] = load_segment
        module["load_address"] = load_address
        module["image"] = image_name
        module["image_size"] = len(image)
        end = load_address + len(image)
        if end > len(flash):
            module["descriptor_error"] = "image exceeds 80186 address space"
            continue
        overlaps = [span for span in occupied if load_address < span[1] and end > span[0]]
        if overlaps:
            # SDL applies modules in file order; later modules are patches or
            # alternate banks and therefore intentionally replace earlier
            # bytes. Preserve that behavior in the reconstructed flash.
            module["overwrites"] = [f"{span[0]:05x}..{span[1]:05x}" for span in overlaps]
        flash[load_address:end] = image
        occupied.append((load_address, end))
    (args.output / "flash-1m.bin").write_bytes(flash)

    (args.output / "manifest.json").write_text(
        json.dumps({"packet_runs": manifest, "modules": modules}, indent=2) + "\n"
    )
    print(
        f"extracted {len(runs)} packet runs into {len(modules)} modules, "
        f"{sum(int(run['payload_size']) for run in runs)} payload bytes"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
