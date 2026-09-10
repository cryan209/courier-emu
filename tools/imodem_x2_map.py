#!/usr/bin/env python3
"""Rebuild the first-x2 I-modem (IM020104) address spaces and disassemble them.

Two spaces share one flash image:

* the 8086 supervisor, flat-addressed from the NAC's own 0x40000 load base;
* the joined C5x program the DSP runs, images 5/11/10 laid down at 8000,
  9194 and d000 as the build's overlay table names them.

Usage (addresses are hex, end exclusive):

    python tools/imodem_x2_map.py dsp e172 e186
    python tools/imodem_x2_map.py sup addca ade12
"""
from __future__ import annotations

import struct
import sys
import zipfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))

from courier_emu.nac import NacImage  # noqa: E402
from tools.c5x_disasm import disassemble  # noqa: E402

ARCHIVE = ROOT / "docs/x2/im020104.zip"
MEMBER = "IM020104.NAC"

# Overlay rows of the first-x2 build: source segment, byte count, C5x load word.
# Segments are physical/16, and the flat image starts at the NAC's load base.
DSP_IMAGES = ((0xE005, 0x2322, 0x8000),   # image 5, resident-class
              (0xD84C, 0x7B86, 0x9194),   # image 11
              (0xD4EF, 0x35C2, 0xD000))   # image 10, the new x2 engine


def flat(path: Path | None = None) -> tuple[int, bytes]:
    """The whole flash as one array, with the physical address it starts at."""
    if path is not None:
        return NacImage.load(path).flatten()
    with zipfile.ZipFile(ARCHIVE) as archive, archive.open(MEMBER) as handle:
        scratch = ROOT / "build" / MEMBER
        scratch.parent.mkdir(exist_ok=True)
        scratch.write_bytes(handle.read())
    return NacImage.load(scratch).flatten()


def dsp_memory(blob: bytes, base: int) -> list[int]:
    memory = [0] * 0x10000
    for segment, length, load in DSP_IMAGES:
        start = segment * 16 - base
        for index in range(length // 2):
            memory[load + index] = struct.unpack_from("<H", blob, start + 2 * index)[0]
    return memory


def main() -> None:
    space, first, last = sys.argv[1], int(sys.argv[2], 16), int(sys.argv[3], 16)
    base, blob = flat()
    if space == "dsp":
        for instruction in disassemble(dsp_memory(blob, base), first, last):
            words = " ".join(f"{word:04x}" for word in instruction.words)
            print(f"{instruction.pc:04x}: {words:<10} {instruction.text}")
        return
    from capstone import CS_ARCH_X86, CS_MODE_16, Cs
    for instruction in Cs(CS_ARCH_X86, CS_MODE_16).disasm(
            blob[first - base:last - base], first):
        print(f"{instruction.address:05x}: {instruction.bytes.hex():<14} "
              f"{instruction.mnemonic} {instruction.op_str}")


if __name__ == "__main__":
    main()
