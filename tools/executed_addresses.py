#!/usr/bin/env python3
"""Every 80186 address one run executed, and the diff between two runs.

`hot_addresses` is a top-20 profile, which cannot answer "did this branch run
at all". The machine already counts every address under `track_executed`; this
exposes the whole set and diffs it, which is the cheapest way to find the code
one AT command takes and another does not.

    PYTHONPATH=. python3 tools/executed_addresses.py IDSDL302.ROM \
        --at 'AT&T1' --out t1.json
    PYTHONPATH=. python3 tools/executed_addresses.py --diff t0.json t1.json

The diff prints contiguous runs rather than bare addresses, because a routine
that ran shows up as a span and a branch that did not shows up as a gap. Feed
the interesting spans to `x86_disasm.py`.

Per-address counting disables the native batches, so a run takes minutes where
the same limit through `./courier run` takes seconds. Ask for the smallest
instruction limit that still reaches what you are looking for.
"""
from __future__ import annotations

import argparse
import json

from courier_emu.cli import DIP_PRESETS, load_image
from courier_emu.machine import CourierMachine


def executed(image: str, command: str, limit: int, preset: str) -> dict[str, int]:
    """Run one AT command and return {address: times executed}, hex keys."""
    machine = CourierMachine(
        load_image(image),
        track_executed=True,
        with_dsp=True,
        serial_input=command.encode("ascii") + b"\r" if command else b"",
        dip_closed=frozenset(DIP_PRESETS[preset]),
    )
    machine.run(limit)
    return {f"{address:05x}": count for address, count in machine.executed.items()}


def runs(addresses, gap: int = 16):
    """Group sorted addresses into spans, breaking on a gap of more than `gap`."""
    addresses = sorted(addresses)
    if not addresses:
        return
    first = previous = addresses[0]
    for address in addresses[1:]:
        if address - previous > gap:
            yield first, previous
            first = address
        previous = address
    yield first, previous


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("image", nargs="?")
    parser.add_argument("--at", default="", metavar="COMMAND",
                        help="AT command to send after boot")
    parser.add_argument("--instructions", type=int, default=40_000_000)
    parser.add_argument("--dip-preset", default="dedicated-line",
                        choices=sorted(DIP_PRESETS))
    parser.add_argument("--out", metavar="PATH", help="write the counts as JSON")
    parser.add_argument("--diff", nargs=2, metavar=("BASE", "OTHER"),
                        help="report addresses in OTHER that BASE never ran")
    args = parser.parse_args()

    if args.diff:
        base = set(json.load(open(args.diff[0])))
        other = set(json.load(open(args.diff[1])))
        only = [int(address, 16) for address in other - base]
        spans = list(runs(only))
        print(f"{len(only)} addresses in {len(spans)} runs")
        for low, high in spans:
            print("  %05x-%05x (%d)" % (low, high, high - low + 1))
        return

    if not args.image:
        parser.error("an image is required unless --diff is given")
    counts = executed(args.image, args.at, args.instructions, args.dip_preset)
    if args.out:
        with open(args.out, "w") as handle:
            json.dump(counts, handle)
    print(f"{args.at or 'no command'}: {len(counts)} addresses")


if __name__ == "__main__":
    main()
