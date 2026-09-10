"""Execute QF060003's resident PCM-mapping codeword table constructor."""
from __future__ import annotations

import argparse
import json
from pathlib import Path
import struct

from courier_emu.dsp import NativeC5x
from courier_emu.quad_image import QuadImage

ROOT = Path(__file__).resolve().parents[1]
QF = ROOT / "docs/x2/Qf060003.zip"
OUT = ROOT / "artifacts/quad-pcm-codewords-20260910"

# QF060003 overlay rows recovered in docs/quad-c50-overlay-loader.md.
RESIDENT = (0x449B0, 0xF450, 0x8000)
PCM_CORE = (0x53E00, 0x42E0, 0xA180)
PCM_MODE = (0x5C1F0, 0x15D6, 0xC300)
CONSTRUCTOR = 0xC9C0
MODE_FLAGS = 0xFFD9
DESTINATION = 0x0500
SELECTORS = (0xC995, 0xC9A6, 0xC9B7)
PARAMETER_SETUP = 0xC7AE


def execute(image: QuadImage, flag: int) -> tuple[bytes, int]:
    def payload(row: tuple[int, int, int]) -> bytes:
        offset, length, _ = row
        return image.data[offset:offset + length]

    resident = payload(RESIDENT)
    pcm_core = payload(PCM_CORE)
    pcm_mode = payload(PCM_MODE)
    # ACC supplies the destination consumed by SAMM @11.  ARP=1 makes the
    # constructor's RPT #8 / TBLR *+ advance that destination as its caller
    # does.  Returning to PC 5 is the observable completion boundary.
    driver = struct.pack(
        "<7H", 0xBF80, DESTINATION, 0x8B89,
        0x7A80, CONSTRUCTOR, 0x7980, 5,
    )
    with NativeC5x.from_program(RESIDENT[2], resident) as core:
        core.load_program(pcm_core, PCM_CORE[2])
        core.load_program(pcm_mode, PCM_MODE[2])
        core.load_rom(driver)
        core.set_mpmc_pin(0)
        core.set_data(MODE_FLAGS, flag)
        core.set_pc(0)
        for _ in range(100):
            core.step(1)
            if core.state()["pc"] == 5:
                break
        else:
            raise RuntimeError(f"PCM constructor did not return: {core.state()}")
        values = bytes(core.data(DESTINATION + index) & 0xFF for index in range(9))
        return values, core.state()["instructions"]


def select(image: QuadImage, entry: int, flag: int, mode: int) -> int:
    def payload(row: tuple[int, int, int]) -> bytes:
        offset, length, _ = row
        return image.data[offset:offset + length]

    # Every selector uses * after loading AR1 with ffd9, so ARP=1 is part of
    # their shared ABI. The caller supplies the submode in data word 0x64.
    driver = struct.pack(
        "<7H", 0xBC07, 0x8B89, 0x7A80, entry, 0x7980, 4, 0,
    )
    with NativeC5x.from_program(RESIDENT[2], payload(RESIDENT)) as core:
        core.load_program(payload(PCM_CORE), PCM_CORE[2])
        core.load_program(payload(PCM_MODE), PCM_MODE[2])
        core.load_rom(driver)
        core.set_mpmc_pin(0)
        core.set_data(MODE_FLAGS, flag)
        core.set_data(0x3E4, mode)
        core.set_pc(0)
        for _ in range(100):
            core.step(1)
            if core.state()["pc"] == 4:
                return core.state()["acc"] & 0xFFFF
    raise RuntimeError(f"selector {entry:04x} did not return")


def parameters(image: QuadImage, flag: int) -> dict[str, str]:
    def payload(row: tuple[int, int, int]) -> bytes:
        offset, length, _ = row
        return image.data[offset:offset + length]

    driver = struct.pack(
        "<7H", 0xBC07, 0x8B89, 0x7A80, PARAMETER_SETUP,
        0x7980, 4, 0,
    )
    with NativeC5x.from_program(RESIDENT[2], payload(RESIDENT)) as core:
        core.load_program(payload(PCM_CORE), PCM_CORE[2])
        core.load_program(payload(PCM_MODE), PCM_MODE[2])
        core.load_rom(driver)
        core.set_mpmc_pin(0)
        core.set_data(MODE_FLAGS, flag)
        core.set_pc(0)
        for _ in range(100):
            core.step(1)
            if core.state()["pc"] == 4:
                return {
                    hex(address): hex(core.data(address))
                    for address in (0x3A3, 0x3EB, 0x3EC, 0x3EA)
                }
    raise RuntimeError("PCM parameter setup did not return")


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--image", type=Path, default=QF)
    parser.add_argument("--output", type=Path, default=OUT)
    args = parser.parse_args()
    args.output.mkdir(parents=True, exist_ok=True)
    image = QuadImage.controller(args.image)
    report = {
        "firmware": args.image.name,
        "routine": hex(CONSTRUCTOR),
        "mode_flags": hex(MODE_FLAGS),
        "tables": {},
        "selectors": {},
        "parameter_setup": {
            "routine": hex(PARAMETER_SETUP),
            "bit0-clear": parameters(image, 0),
            "bit0-set": parameters(image, 1),
        },
    }
    for name, flag in (("bit2-clear", 0), ("bit2-set", 4)):
        values, instructions = execute(image, flag)
        filename = f"{name}.g711"
        (args.output / filename).write_bytes(values)
        report["tables"][name] = {
            "flag": hex(flag), "file": filename,
            "codewords": [hex(value) for value in values],
            "instructions": instructions,
        }
    for entry in SELECTORS:
        report["selectors"][hex(entry)] = {
            f"mode-{mode}": {
                "bit2-clear": hex(select(image, entry, 0, mode)),
                "bit2-set": hex(select(image, entry, 4, mode)),
            }
            for mode in range(3)
        }
    (args.output / "results.json").write_text(json.dumps(report, indent=2) + "\n")
    print(json.dumps(report, indent=2))


if __name__ == "__main__":
    main()
