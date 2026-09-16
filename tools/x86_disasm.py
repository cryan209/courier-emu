#!/usr/bin/env python3
"""Disassemble 16-bit 80186 code out of a Courier ROM by physical address.

The repository has a C5x disassembler but nothing for the supervisor side, so
reading an 80186 routine meant decoding bytes by hand. This wraps capstone.

Addresses are physical, the same ones `--trace-pc`, `hot_addresses` and
`executed_addresses.py` print, so a site found in a trace can be pasted
straight in:

    PYTHONPATH=. python3 tools/x86_disasm.py IDSDL302.ROM 876b1 --count 20

Needs the `disasm` extra, which pyproject already declares for capstone.

Linear disassembly from an arbitrary offset is a guess: starting mid
instruction produces plausible-looking nonsense for a few lines before it
resynchronises. Start from an address something actually branched to.
"""
from __future__ import annotations

import argparse

import capstone

from courier_emu.rom import CourierRom


def disassemble(rom: CourierRom, start: int, count: int):
    """Yield `count` instructions from the physical address `start`."""
    engine = capstone.Cs(capstone.CS_ARCH_X86, capstone.CS_MODE_16)
    # The longest 8086 encoding is six bytes, so this cannot run short.
    data = rom.at(start, min(count * 6, len(rom.data) - (start - rom.base)))
    for index, instruction in enumerate(engine.disasm(data, start)):
        if index >= count:
            return
        yield instruction


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("image")
    parser.add_argument("address", help="physical start address, hex")
    parser.add_argument("--count", type=int, default=24,
                        help="instructions to print (default 24)")
    args = parser.parse_args()
    rom = CourierRom.load(args.image)
    for instruction in disassemble(rom, int(args.address, 16), args.count):
        print("%05x  %-18s %s %s" % (
            instruction.address, instruction.bytes.hex(),
            instruction.mnemonic, instruction.op_str))


if __name__ == "__main__":
    main()
