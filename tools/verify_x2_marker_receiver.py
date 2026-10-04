#!/usr/bin/env python3
"""Run the original QF060003 Quad parse of the 7-bit x2 marker body.

Run from the repository root: .venv/bin/python tools/verify_x2_marker_receiver.py
The receiver at 9790 arms the INFO receiver for a 7-bit body; this executes the
original parse (97b5 to 97dd/9800) on every body value and both role-flag values
and compares it with the field layout the Courier transmitter builds.
"""
from pathlib import Path
import json
import struct
import sys

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))
from courier_emu.quad_image import QuadImage
from courier_emu.dsp import NativeC5x
from tools.probe_quad_pcm_codewords import RESIDENT

OUT = ROOT / "artifacts/x2-marker-receiver-20261004"


def main():
    image = QuadImage.controller(ROOT / "docs/x2/Qf060003.zip")
    offset, length, origin = RESIDENT
    cases = []
    with NativeC5x.from_program(origin, image.data[offset:offset + length]) as core:
        for role in (0, 1):
            for body in range(128):
                for address in range(0xff00, 0xff30):
                    core.set_data(address, 0)
                # The receiver copies the body so its first-sent bit is bit 9
                # of ff08 and its last-sent bit is bit 15.
                core.set_data(0x6f, role << 1)
                core.set_data(0xff08, body << 9)
                core.load_program(struct.pack("<5H", 0xbc06, 0x8b89, 0x7980,
                                              0x97b5, 0x8b00), 0x7c00)
                core.set_pc(0x7c00)
                for _ in range(300):
                    core.step(1)
                    pc = core.state()["pc"]
                    if pc in (0x97dd, 0x9800):
                        break
                else:
                    raise AssertionError((role, body, core.state()))
                first, second, carrier = (body >> 1) & 7, (body >> 4) & 7, body & 1
                mine, other = (first, second) if role else (second, first)
                actual = (core.data(0x35a), core.data(0x35b), core.data(0xff20 + other),
                          pc == 0x9800)
                assert actual == (mine, other, carrier, mine == 6), (role, body, actual)
                cases.append({"role_bit1": role, "body": body, "own_field": mine,
                              "other_field": other, "carrier": carrier,
                              "pcm_marker_accepted": pc == 0x9800})
    report = {"image": "docs/x2/Qf060003.zip", "parse": "97b5..97dd", "cases": len(cases),
              "accepted": sum(c["pcm_marker_accepted"] for c in cases),
              "results": cases}
    OUT.mkdir(parents=True, exist_ok=True)
    (OUT / "verification.json").write_text(json.dumps(report, indent=1) + "\n")
    print(f"Verified {len(cases)} original-instruction parses; output: {OUT}")


if __name__ == "__main__":
    main()
