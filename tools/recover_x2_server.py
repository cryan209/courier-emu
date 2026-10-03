#!/usr/bin/env python3
"""Extract and execution-check manual C lifts from pre-V.90 IM020104.NAC.

Run: .venv/bin/python tools/recover_x2_server.py
No hardware access. Uses the existing recovered I-modem overlay map.
"""
from pathlib import Path
import ctypes
import hashlib
import json
import random
import struct
import subprocess
import sys
import tempfile

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))
from courier_emu.dsp import NativeC5x
from tools.imodem_x2_map import flat, DSP_IMAGES, ARCHIVE, MEMBER
from tools.c5x_disasm import disassemble
from courier_emu.quad_image import QuadImage
from tools.probe_quad_pcm_codewords import RESIDENT, PCM_CORE, PCM_MODE

OUT = ROOT / "artifacts/x2-server-decomp-20261004"
RANGES = [(0x83c4, 0x84af), (0x851c, 0x8559), (0x8faa, 0x8ff3),
          (0x91a1, 0x91b4), (0x927f, 0x9292), (0x9617, 0x9633),
          (0xe11a, 0xe184), (0xe4ca, 0xe4f0), (0xe585, 0xe5b8),
          (0xe1d2, 0xe253), (0xe2b1, 0xe31a), (0xe438, 0xe4ca),
          (0xe5e7, 0xe6af), (0xe7e7, 0xe7f2)]


def listing(words, first, last):
    return "\n".join(f"{i.pc:04x}  {' '.join(f'{v:04x}' for v in i.words):14} {i.text}"
                     for i in disassemble(words, first, last)) + "\n"


def main():
    base, blob = flat()
    OUT.mkdir(parents=True, exist_ok=True)
    words = [0] * 65536
    report = {"archive": str(ARCHIVE.relative_to(ROOT)), "member": MEMBER,
              "flat_base": base, "flat_sha256": hashlib.sha256(blob).hexdigest(),
              "images": [], "checks": {}, "c_lift_verified": True}
    for index, (segment, length, origin) in zip((5, 11, 10), DSP_IMAGES):
        offset = segment * 16 - base
        payload = blob[offset:offset+length]
        words[origin:origin+length//2] = struct.unpack(f"<{length//2}H", payload)
        report["images"].append({"index": index, "segment": segment,
                                  "bytes": length, "program_origin": origin})
        (OUT / f"image-{index}.asm").write_text(
            f"; IM020104 image {index}, origin {origin:04x}\n"
            "; Linear listing; includes tables/data.\n" + listing(words, origin, origin+length//2))
    (OUT / "server-focused.asm").write_text("\n".join(
        f"; range {lo:04x}..{hi:04x}\n" + listing(words, lo, hi) for lo, hi in RANGES))
    rng = random.Random(0x020104)
    with tempfile.TemporaryDirectory(prefix="x2-server-lift-") as tmp:
        libpath = Path(tmp) / "lift.dylib"
        subprocess.run(["clang", "-shared", "-fPIC", "-Wall", "-Wextra", "-Werror",
                        str(OUT / "x2_server_lift.c"), str(OUT / "quad_pcm_lift.c"),
                        "-o", str(libpath)], check=True)
        lift = ctypes.CDLL(str(libpath))
        d = (ctypes.c_uint16 * 65536)()
        first = DSP_IMAGES[0]
        offset = first[0]*16-base
        with NativeC5x.from_program(first[2], blob[offset:offset+first[1]]) as core:
            for segment, length, origin in DSP_IMAGES[1:]:
                offset = segment*16-base
                core.load_program(blob[offset:offset+length], origin)

            def put(address, value):
                core.set_data(address, value)
                d[address] = value

            def compare(addresses, label):
                for address in addresses:
                    assert core.data(address) == d[address], (
                        label, hex(address), hex(core.data(address)), hex(d[address]))

            def invoke(entry, dp=0, acc=None, ar1=None, stop=None):
                wrapper = [0xbc00 | dp, 0x8b89]
                if acc is not None: wrapper.extend((0xbf80, acc))
                if ar1 is not None: wrapper.extend((0xbf09, ar1))
                wrapper.extend((0x7a80, entry))
                return_pc = 0x7000 + len(wrapper)
                wrapper.append(0x8b00)
                core.load_program(struct.pack(f"<{len(wrapper)}H", *wrapper), 0x7000)
                core.set_pc(0x7000)
                for step in range(500):
                    if core.state()["pc"] == (stop if stop is not None else return_pc):
                        return core.state()["acc"] & 65535
                    core.step(1)
                raise AssertionError((hex(entry), core.state()))

            for entry, name, cells in [(0x91a1, "server_tag70", (0xffdb, 0xffd9)),
                                        (0x91ae, "server_tag71", (0xffda,))]:
                for _ in range(128):
                    value, flags = rng.getrandbits(16), rng.getrandbits(16)
                    put(0x7a, value); put(0xffd9, flags)
                    getattr(lift, name)(d, ctypes.c_uint16(value))
                    invoke(entry)
                    compare(cells, name)
                report["checks"][name] = 128

            for value in range(256):
                actual = invoke(0xe7e7, acc=value)
                assert actual == lift.server_reverse_octet(ctypes.c_uint16(value))
            report["checks"]["octet_reversal"] = 256

            for mode in range(8):
                put(0x3e0, mode)
                expected = lift.server_mode_family_target(ctypes.c_uint16(mode))
                invoke(0xe172, dp=7, stop=expected)
            report["checks"]["mode_family_dispatch"] = 8

            # Two complete startup-source cycles, including delayed returns.
            put(0x3f3, 0); put(0x3f4, 0x6d3); put(0x3f5, 0xe1d2)
            for _ in range(4096):
                entry = d[0x3f5]
                expected = lift.server_probe_word(d, ctypes.c_uint16(0x380))
                assert invoke(entry, dp=7) == expected
                compare((0x3f3, 0x3f4, 0x3f5), "startup probe source")
            report["checks"]["startup_probe_source"] = 4096

            for _ in range(128):
                flags = rng.getrandbits(16)
                put(0x39f, flags); put(0xffdb, rng.getrandbits(14))
                put(0xffdc, rng.getrandbits(14))
                expected = lift.server_select_capability(d)
                actual = invoke(0x927f, dp=7, stop=0x9617)
                assert actual == expected
                compare((0xfef0, 0xfef1), "capability")
            report["checks"]["capability_selection"] = 128

            for _ in range(128):
                put(0x39f, rng.getrandbits(16)); put(0xffdb, rng.getrandbits(14))
                put(0xffdc, rng.getrandbits(16)); put(0x3fb, 1)
                lift.server_pack_info0_capability(d)
                invoke(0x927f, dp=7)
                compare((0xfef0,0xfef1), "INFO0 capability writer")
            report["checks"]["info0_capability_packing"] = 128

            for receive, entry, page in [(False, 0x8faa, 0x380), (True, 0x8fe1, 0x300)]:
                for count in range(1, 10):
                    for _ in range(32):
                        state = rng.getrandbits(23)
                        data, width, mask, hi, lo = ((0x20, 0x22, 0x21, 0x1e, 0x1f)
                            if receive else (0, 2, 1, 0x58, 0x59))
                        put(page+data, rng.getrandbits(count))
                        put(page+width, count); put(page+mask, (1<<count)-1)
                        put(page+hi, state>>16); put(page+lo, state & 65535)
                        fn = lift.server_descramble if receive else lift.server_scramble
                        fn(d, ctypes.c_uint16(page))
                        invoke(entry, dp=page>>7)
                        compare((page+data, page+hi, page+lo), "scrambler")
                report["checks"]["descrambler" if receive else "scrambler"] = 288

            for mode in (0, 1):
                put(0x3e0, mode)
                put(0x3ee, 6); put(0x3ef, 7)
                lift.server_width_setup(d, ctypes.c_uint16(0x380), ctypes.c_uint16(0x300))
                invoke(0xe5e7, dp=7)
                compare([0x380+i for i in (1,2,3,4,5,6,0x58,0x59)] +
                        [0x300+i for i in (0x1e,0x1f,0x21,0x22,0x24,0x25,0x26,0x71)], "width")
            report["checks"]["width_setup"] = 2

            for width in (7, 8):
                put(0x382, width); put(0x384, 0); put(0x385, 0)
                for _ in range(256):
                    lift.server_training_word(d, ctypes.c_uint16(0x380))
                    invoke(0xe4d1, dp=7)
                    compare((0x380,0x384,0x385), "training reservoir")
            report["checks"]["training_words"] = 512

            for receive in (False, True):
                for width in (7, 8):
                    for scramble in (False, True):
                        for reverse in (False, True):
                            for _ in range(32):
                                put(0x6f, 0)  # close original source/sink dispatch gates
                                put(0x3e0, 0x200 if scramble else 0)
                                put(0xffd9, 0x8000 if reverse else 0)
                                if receive:
                                    put(0x889, rng.getrandbits(8))
                                    put(0x321, (1<<width)-1); put(0x322, width)
                                    state=rng.getrandbits(23)
                                    put(0x31e,state>>16); put(0x31f,state&65535)
                                    lift.server_receive_preloaded(d, ctypes.c_uint16(0x889))
                                    invoke(0xe67b, dp=7, ar1=0x889)
                                    compare((0xff00,0x320,0x31e,0x31f), "rx callback")
                                else:
                                    put(0x380,rng.getrandbits(8))
                                    put(0x381,(1<<width)-1); put(0x382,width)
                                    state=rng.getrandbits(23)
                                    put(0x3d8,state>>16); put(0x3d9,state&65535)
                                    lift.server_transmit_preloaded(d, ctypes.c_uint16(0x888))
                                    invoke(0xe65f, dp=7, ar1=0x888)
                                    compare((0xff01,0xff0c,0x888,0x380,0x3d8,0x3d9), "tx callback")
                report["checks"]["rx_callback" if receive else "tx_callback"] = 256
        quad = QuadImage.controller(ROOT / "docs/x2/Qf060003.zip")
        qwords = [0]*65536
        for offset, length, origin in (RESIDENT, PCM_CORE, PCM_MODE):
            qwords[origin:origin+length//2] = struct.unpack(
                f"<{length//2}H", quad.data[offset:offset+length])
        (OUT / "quad-pcm-focused.asm").write_text(
            "; QF060003 larger PCM-mode overlay, dual x2/V.90 build\n" +
            listing(qwords,0xc7ad,0xc7c0) + listing(qwords,0xc994,0xc9e0))
        qprogram = (ctypes.c_uint16*65536)(*qwords)
        offset, length, origin = RESIDENT
        with NativeC5x.from_program(origin,quad.data[offset:offset+length]) as core:
            for offset, length, origin in (PCM_CORE,PCM_MODE):
                core.load_program(quad.data[offset:offset+length],origin)
            # put/compare/invoke close over the current core variable.
            for flags in range(8):
                put(0xffd9,flags)
                lift.quad_pcm_parameters(d)
                invoke(0xc7ad,dp=7)
                compare((0x3a3,0x3eb,0x3ec,0x3ea),"quad parameters")
                lift.quad_pcm_codewords(qprogram,d,ctypes.c_uint16(0x500))
                invoke(0xc9bf,dp=7,acc=0x500)
                compare(range(0x500,0x509),"quad codewords")
                for kind, entry in enumerate((0xc994,0xc9a5,0xc9b6)):
                    for mode in range(3):
                        put(0x3e4,mode)
                        expected=lift.quad_pcm_selector(qprogram,d,ctypes.c_uint(kind))
                        assert invoke(entry,dp=7)==expected
        report["quad"]={"archive":"docs/x2/Qf060003.zip",
                         "flat_sha256":hashlib.sha256(quad.data).hexdigest(),
                         "scope":"Shared x2/V.90 parameter/table helpers"}
        report["checks"]["quad_pcm_helpers"]=88
    report["total_cases"] = sum(report["checks"].values())
    (OUT / "verification.json").write_text(json.dumps(report, indent=2)+"\n")
    print(f"Verified {report['total_cases']} server C/native cases; output: {OUT}")


if __name__ == "__main__":
    main()
