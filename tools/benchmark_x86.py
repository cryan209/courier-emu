#!/usr/bin/env python3
"""Measure actual firmware throughput; optionally report guarded native exits."""
from __future__ import annotations

import argparse
import json
import os
from pathlib import Path
import sys
import time

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("image")
    parser.add_argument("--instructions", type=int, default=10_000_000)
    parser.add_argument("--with-dsp", action="store_true")
    parser.add_argument("--python", action="store_true", help="disable native batches")
    parser.add_argument("--profile-exits", action="store_true", help="adds profiling overhead")
    args = parser.parse_args()
    if args.instructions <= 0:
        parser.error("--instructions must be positive")
    os.environ["COURIER_X86_NATIVE"] = "0" if args.python else "1"
    os.environ["COURIER_X86_PROFILE"] = "1" if args.profile_exits else "0"
    from courier_emu.images import load_image
    from courier_emu.isdn import IsdnMachine
    from courier_emu.machine import CourierMachine
    from courier_emu.nac import NacImage
    from courier_emu.xmp import XmpImage
    from courier_emu.timebase import IMODEM_386EX
    from courier_emu.x86_native import build_library

    if not args.python:
        build_library()  # exclude one-time compilation from execution timing
    image = load_image(args.image)
    isdn = isinstance(image, (NacImage, XmpImage))
    machine = (IsdnMachine if isdn else CourierMachine)(image, with_dsp=args.with_dsp)
    start = time.perf_counter()
    result = machine.run(args.instructions)
    seconds = time.perf_counter() - start
    timebase = IMODEM_386EX if isdn else machine.timebase
    rate = machine.instructions / seconds
    native = machine.uc._native
    print(json.dumps({
        "image": args.image, "with_dsp": args.with_dsp, "status": result.status,
        "instructions": machine.instructions, "wall_seconds": seconds,
        "million_instructions_per_second": rate / 1e6,
        "realtime_multiple": rate / timebase.instructions_per_second,
        "timebase": timebase.describe(),
        "native_share": native.retired / max(1, machine.uc.retired) if native else 0,
        "native": native.statistics() if native else None,
    }, indent=2))
    return 0 if result.status == "instruction-limit" else 1


if __name__ == "__main__":
    raise SystemExit(main())
