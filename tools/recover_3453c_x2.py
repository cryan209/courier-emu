#!/usr/bin/env python3
"""Extract overlay-aware DSP listings and verify manually lifted scramblers.

Run from the repository root: .venv/bin/python tools/recover_3453c_x2.py
Uses only local firmware and the native DSP emulator; no hardware access.
The listings are linear disassembly, not proof that every word is code.
"""
from pathlib import Path
import json
import random
import struct
import sys
import ctypes
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))
from courier_emu.xmf import XmfImage
from courier_emu.dsp import NativeC5x
from tools.c5x_disasm import disassemble

OUT = ROOT / "artifacts/3453c-x2-decomp-20261004"
FOCUS = {
    5: [(0x12b4, 0x130d), (0x130d, 0x1395), (0x5b17, 0x5b21)],
    6: [(0x1dc9, 0x1df2)],
    7: [(0x0890, 0x08cc), (0x08e3, 0x0924), (0x0969, 0x09c6),
        (0x0e4f, 0x0e69)],
    8: [(0x63e8, 0x6433)],
}


def scalar(state, value, count, tap, receive=False):
    result = 0
    for bit in range(count):
        incoming = (value >> bit) & 1
        output = incoming ^ ((state >> (23 - tap)) & 1) ^ (state & 1)
        result |= output << bit
        state = (state >> 1) | ((incoming if receive else output) << 22)
    return result, state


def listing(words, first, last):
    return "\n".join(
        f"{i.pc:04x}  {' '.join(f'{v:04x}' for v in i.words):14} {i.text}"
        for i in disassemble(words, first, last)
    ) + "\n"


def main():
    image = XmfImage.load(ROOT / "docs/3453C_v2.3.33/2_3_33.XMF")
    OUT.mkdir(parents=True, exist_ok=True)
    segments = image.dsp_segments()
    report = {"image": str(image.path.relative_to(ROOT)), "sha256": image.digest,
              "segments": [s.describe() for s in segments], "scramblers": [],
              "tag70": []}
    focused = []
    for segment in segments:
        words = [0] * 65536
        words[segment.origin:segment.origin + segment.words] = struct.unpack(
            f"<{segment.words}H", image.data[segment.file_offset:segment.end])
        header = (f"; SHA256 {image.digest}\n; overlay {segment.index}, "
                  f"file {segment.file_offset:05x}, program origin {segment.origin:04x}\n"
                  "; Linear listing: tables/data may decode as instructions.\n")
        (OUT / f"overlay-{segment.index}.asm").write_text(
            header + listing(words, segment.origin, segment.origin + segment.words))
        for first, last in FOCUS.get(segment.index, []):
            focused.append(header + listing(words, first, last))
    (OUT / "x2-focused.asm").write_text("\n".join(focused))

    resident = next(s for s in segments if s.resident)
    low = next(s for s in segments if s.index == 7)
    rng = random.Random(0x3453c)
    # Compile the actual C lift and compare it to both the independent scalar
    # recurrence and the original machine code, including the state-register ABI.
    library_dir = tempfile.TemporaryDirectory(prefix="3453c-x2-lift-")
    library_path = Path(library_dir.name) / "lift.dylib"
    subprocess.run(["clang", "-shared", "-fPIC", "-Wall", "-Wextra", "-Werror",
                    str(OUT / "x2_dsp_lift.c"), "-o", str(library_path)], check=True)
    lift = ctypes.CDLL(str(library_path))
    c_data = (ctypes.c_uint16 * 65536)()
    report["c_lift_verified"] = True
    with NativeC5x.from_program(resident.origin,
                              image.data[resident.file_offset:resident.end]) as core:
        core.load_program(image.data[low.file_offset:low.end], low.origin)

        def invoke(entry, dp, stop=None):
            core.load_program(struct.pack("<5H", 0xbc00 | dp, 0x8b89,
                                          0x7a80, entry, 0x8b00), 0x7c00)
            core.set_pc(0x7c00)
            for step in range(100):
                core.step(1)
                if core.state()["pc"] == (0x7c04 if stop is None else stop):
                    return step + 1
            raise AssertionError(core.state())

        for receive, entry in [(False, 0x0890), (True, 0x08b0)]:
            for flag in (0, 1):
                tap = (18 if flag else 5) if receive else (5 if flag else 18)
                cases = 0
                for count in range(1, 10):
                    for _ in range(32):
                        state = rng.getrandbits(23)
                        value = rng.getrandbits(count)
                        hi, lo, data, mask, width = (
                            (0x31e, 0x31f, 0x320, 0x321, 0x322) if receive else
                            (0x358, 0x359, 0x350, 0x351, 0x352))
                        for address, v in [(hi, state >> 16), (lo, state & 65535),
                                           (data, value), (mask, (1 << count) - 1),
                                           (width, count), (0x6f, flag << int(receive))]:
                            core.set_data(address, v)
                            c_data[address] = v
                        c_function = lift.pcm_descramble_batch if receive else lift.pcm_scramble_batch
                        c_function(c_data)
                        invoke(entry, 6)
                        actual = core.data(data), (core.data(hi) << 16) | core.data(lo)
                        assert actual == scalar(state, value, count, tap, receive), (
                            entry, flag, count, actual)
                        assert actual == (c_data[data], (c_data[hi] << 16) | c_data[lo])
                        cases += 1
                report["scramblers"].append({"entry": f"{entry:04x}",
                    "direction": "receive" if receive else "transmit",
                    "flag": flag, "tap": tap, "cases": cases})
        for value in (0, 0x0400, 0x0600, 0xffff):
            for initial in (0, 0x1234, 0xffff):
                for address, v in [(0x7a, value), (0x7feb, 0),
                                   (0x7fe8, initial), (0x7fee, initial)]:
                    core.set_data(address, v)
                    c_data[address] = v
                lift.x2_tag70(c_data, ctypes.c_uint16(value))
                steps = invoke(0x08f8, 0)
                actual = [core.data(a) for a in (0x7feb, 0x7fe8, 0x7fee)]
                assert actual == [(value | 0x4000) & 0x7fff, 0x8000, initial | 1]
                assert actual == [c_data[a] for a in (0x7feb, 0x7fe8, 0x7fee)]
                report["tag70"].append({"input": value, "initial_flags": initial,
                                        "output": actual, "steps": steps})
        # The negotiation start (0a64) queues INFO0 capability from the plain word
        # at 7fec; the command-70 word at 7feb is stored but never read.
        queue_cases = 0
        for plain in (0, 0x0600, 0x1234, 0xffff):
            for x2_word in (0, 0x0600, 0xabcd):
                for flags in (0, 0x40):
                    for address, v in [(0x7fec, plain), (0x7feb, x2_word),
                                       (0x77b3, 0), (0x77ba, flags),
                                       (0x7f18, 0), (0x7f19, 0)]:
                        core.set_data(address, v)
                    invoke(0x0a64, 7)
                    word = (plain | 0x4000) & 0x7fff
                    assert (core.data(0x7f18), core.data(0x7f19)) == (
                        word >> 1, (word & 1) << 15), (plain, x2_word, flags)
                    queue_cases += 1
        report["info0_capability_queue_cases"] = queue_cases
        shared_cases = 0
        for tag, entry, address in [(0x71, 0x090b, 0x7fea),
                                     (0x72, 0x0921, 0x7fbc),
                                     (0x74, 0x091c, 0x77c9),
                                     (0x76, 0x0912, 0x77c7),
                                     (0x77, 0x0919, 0x77c8)]:
            for value in (0, 0x1234, 0x8000, 0xffff):
                core.set_data(0x7a, value)
                core.set_data(address, 0x5555)
                c_data[0x7a], c_data[address] = value, 0x5555
                fn = getattr(lift, f"pcm_tag{tag:02x}")
                fn(c_data) if tag == 0x74 else fn(c_data, ctypes.c_uint16(value))
                invoke(entry, 0)
                assert core.data(address) == c_data[address]
                assert core.data(0x7a) == c_data[0x7a]
                shared_cases += 1
        report["shared_handler_cases"] = shared_cases
        for _ in range(256):
            for address in (0x7f00, 0x7f26, 0x7fe8):
                value = rng.getrandbits(16)
                core.set_data(address, value)
                c_data[address] = value
            lift.pcm_peer_qualification(c_data)
            invoke(0x0e4f, 7, stop=0x0e69)
            assert core.data(0x7fe8) == c_data[0x7fe8]
        report["peer_qualification_fragment_cases"] = 256
        for _ in range(64):
            for address in (0x7fe8, 0x7fe9):
                value = rng.getrandbits(16)
                core.set_data(address, value)
                c_data[address] = value
            lift.pcm_clear_negotiation_bits(c_data)
            invoke(0x09a0, 7, stop=0x09a8)
            for address in (0x7fe8, 0x7fe9):
                assert core.data(address) == c_data[address]
        report["negotiation_cleanup_cases"] = 64
        for flags in (0, 0x4000, 0x2000, 0x6000, 0x8000, 0xffff):
            core.set_data(0x7fe8, flags)
            c_data[0x7fe8] = flags
            core.load_program(struct.pack("<5H", 0xbc00, 0x8b89,
                                          0x7a80, 0x5b17, 0x8b00), 0x7c00)
            core.set_pc(0x7c00)
            for _ in range(30):
                if core.state()["pc"] == 0x112b:
                    break
                core.step(1)
            else:
                raise AssertionError(core.state())
            assert core.state()["acc"] == lift.pcm_state_selector(c_data)
        report["state_selector_cases"] = 6
        overlay6 = next(s for s in segments if s.index == 6)
        core.load_program(image.data[overlay6.file_offset:overlay6.end], overlay6.origin)
        for base, previous in ((0, 0x1234), (0xffff, 0x8000), (0x0400, 0x5678)):
            for address, value in [(0x7fec, base), (0x7f00, previous),
                                   (0x7efb, 0xffff), (0x7efc, 0xffff)]:
                core.set_data(address, value)
                c_data[address] = value
            lift.pcm_initial_capability(c_data)
            core.load_program(struct.pack("<4H", 0xbc00, 0x8b89,
                                          0x7980, 0x1dc9), 0x7c00)
            core.set_pc(0x7c00)
            for _ in range(30):
                if core.state()["pc"] == 0x1dd9:
                    break
                core.step(1)
            else:
                raise AssertionError(core.state())
            for address in (0x6f, 0x7f00, 0x7f18, 0x7efb, 0x7efc):
                assert core.data(address) == c_data[address], (address, core.data(address))
        report["initial_capability_fragment_cases"] = 3
        pcm = next(s for s in segments if s.index == 8)
        core.load_program(image.data[pcm.file_offset:pcm.end], pcm.origin)
        training_state = 0
        for case in range(256):
            if case >= 128:
                training_state = rng.getrandbits(23)
            for address, value in [(0x379, training_state >> 16),
                                   (0x37a, training_state & 65535),
                                   (0x37c, 63), (0x37e, 6)]:
                core.set_data(address, value)
                c_data[address] = value
            lift.pcm_training_ones(c_data)
            invoke(0x6421, 6)
            actual = core.data(0x37d), (core.data(0x379) << 16) | core.data(0x37a)
            assert actual == scalar(training_state, 63, 6, 18)
            assert actual == (c_data[0x37d], (c_data[0x379] << 16) | c_data[0x37a])
            training_state = actual[1]
        report["training_generator"] = {"overlay": 8, "entry": "6421",
                                         "cases": 256, "width": 6,
                                         "continuous_bits_from_zero": 768}
    report["total_cases"] = (
        sum(r["cases"] for r in report["scramblers"]) + len(report["tag70"])
        + report["training_generator"]["cases"]
        + sum(v for k, v in report.items() if k.endswith("_cases")))
    (OUT / "verification.json").write_text(json.dumps(report, indent=2) + "\n")
    library_dir.cleanup()
    print(f"Verified {report['total_cases']} client C/native cases; output: {OUT}")


if __name__ == "__main__":
    main()
