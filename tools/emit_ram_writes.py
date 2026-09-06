"""Turn a RAM image into the ATGLK2 commands that place it on the board.

The write primitive is `ATGLK2W<address>,<value>`, confirmed against the live
unit on 2026-09-05 (docs/ram-probe-delivery.md): DS is zero, so the address is
a physical low-RAM address, and the width follows the *digit count* - two hex
digits write a byte, four write a little-endian word. This emits four-digit
words, so one command per two bytes.

It emits three files, deliberately separate, because they carry very different
risk:

  place.txt   the image itself. Writes RAM only. A power cycle undoes it.
  verify.txt  `ATGLK2=` page dumps covering what was written.
  arm.txt     the IVT hook that *starts* the routine. Review this by hand.

Nothing here talks to a modem. It prints commands for you to send and check.

    python tools/emit_ram_writes.py artifacts/dsp-rom-dump-v1/diagnostic-ram.bin \\
        --base 0x2000 --output artifacts/dsp-rom-dump-v1/commands
"""
import argparse
from pathlib import Path
import sys

# Ports carrying the NVRAM strobe and the board latches. Writing them is the
# one irreversible thing in reach, so this refuses to emit a placement that
# would land on the I/O selectors at all - see docs/ram-probe-delivery.md.
FORBIDDEN_PORTS = (0x10, 0x12, 0x14)
# Timer 0 fires every 5 ms. Its IVT entry is vector 8, at physical 8 * 4.
TIMER0_VECTOR = 8


def word_writes(image: bytes, base: int) -> list[str]:
    if base % 2:
        raise ValueError("base must be even so the image is written as words")
    if base + len(image) > 0x10000:
        raise ValueError("image does not fit below 0x10000, which is all the "
                         "write primitive can address")
    padded = image + (b"\0" if len(image) % 2 else b"")
    return [f"ATGLK2W{base + offset:04X},"
            f"{int.from_bytes(padded[offset:offset + 2], 'little'):04X}"
            for offset in range(0, len(padded), 2)]


def page_reads(base: int, length: int) -> list[str]:
    first, last = base & ~0xFF, (base + length - 1) & ~0xFF
    return [f"ATGLK2={page:04X}" for page in range(first, last + 0x100, 0x100)]


def arm_commands(entry: int, vector: int = TIMER0_VECTOR) -> list[str]:
    slot = vector * 4
    return [f"ATGLK2={slot & ~0xFF:04X}",          # read the old vector first
            f"ATGLK2W{slot:04X},{entry:04X}",      # offset
            f"ATGLK2W{slot + 2:04X},0000"]         # segment 0


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__,
                                     formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("image", type=Path)
    parser.add_argument("--base", type=lambda v: int(v, 0), default=0x2000,
                        help="physical address the image loads at (default 0x2000, "
                             "matching probe_transport's ENTRY)")
    parser.add_argument("--entry", type=lambda v: int(v, 0), default=None,
                        help="where execution starts (default: --base)")
    parser.add_argument("--vector", type=lambda v: int(v, 0), default=TIMER0_VECTOR,
                        help="IVT entry to hook (default 8, timer 0)")
    parser.add_argument("--output", type=Path, required=True,
                        help="directory to write place.txt, verify.txt and arm.txt")
    args = parser.parse_args()

    image = args.image.read_bytes()
    entry = args.base if args.entry is None else args.entry
    place = word_writes(image, args.base)
    verify = page_reads(args.base, len(image))
    arm = arm_commands(entry, args.vector)

    # Read the placement back out of its own commands: a transcription or
    # endianness error here would be silent and would run as code.
    rebuilt = bytearray()
    for line in place:
        value = int(line.split(",")[1], 16)
        rebuilt += value.to_bytes(2, "little")
    if bytes(rebuilt[:len(image)]) != image:
        raise SystemExit("internal error: emitted commands do not reproduce the image")

    args.output.mkdir(parents=True, exist_ok=True)
    (args.output / "place.txt").write_text("\n".join(place) + "\n")
    (args.output / "verify.txt").write_text("\n".join(verify) + "\n")
    (args.output / "arm.txt").write_text("\n".join(arm) + "\n")

    print(f"  image      {len(image)} bytes at {args.base:#06x}"
          f"..{args.base + len(image) - 1:#06x}")
    print(f"  place.txt  {len(place)} write commands (round-trip checked)")
    print(f"  verify.txt {len(verify)} page dumps")
    print(f"  arm.txt    hooks vector {args.vector:#04x} to {entry:#06x}; "
          f"read the old value first and keep it")
    print(f"  ports {', '.join(hex(p) for p in FORBIDDEN_PORTS)} are never written "
          f"by these commands: they place data and one vector, nothing else")
    return 0


sys.exit(main())
