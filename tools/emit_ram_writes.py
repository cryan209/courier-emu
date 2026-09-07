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


def word_writes(image: bytes, base: int, present: bytes | None = None) -> list[str]:
    """The ATGLK2W commands that place `image` at `base`.

    Each command is a serial round trip at about 165 ms, so a 4 KiB image costs
    nearly six minutes and roughly three quarters of that is spent writing
    zeros. `present` is what the caller believes is already at `base` - the
    image placed by the previous run, or an all-zero block on a freshly power
    cycled board - and words that already match it are skipped.

    This trades time for an assumption, so it is only ever safe in company:
    **always send verify.txt afterwards and diff it against the image.** A
    wrong `present` shows up there as a mismatch, before anything executes.
    """
    if base % 2:
        raise ValueError("base must be even so the image is written as words")
    if base + len(image) > 0x10000:
        raise ValueError("image does not fit below 0x10000, which is all the "
                         "write primitive can address")
    padded = image + (b"\0" if len(image) % 2 else b"")
    if present is None:
        skip = lambda offset, word: False
    else:
        expected = present + bytes(max(0, len(padded) - len(present)))
        skip = lambda offset, word: expected[offset:offset + 2] == padded[offset:offset + 2]
    out = []
    for offset in range(0, len(padded), 2):
        word = int.from_bytes(padded[offset:offset + 2], "little")
        if not skip(offset, word):
            out.append(f"ATGLK2W{base + offset:04X},{word:04X}")
    return out


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
    parser.add_argument("--assume-zero", action="store_true",
                        help="skip writing words that are already 0000. About three "
                             "quarters of a probe image is zeros, so this cuts the "
                             "placement from ~6 minutes to ~2. Only true on RAM that "
                             "is actually zero - a freshly power cycled board, not one "
                             "that already holds a previous image")
    parser.add_argument("--against", type=Path, default=None,
                        help="skip words that already match this image - the one "
                             "previously placed at the same base. Two builds of the "
                             "same probe differ in a handful of words, so a re-run "
                             "costs seconds instead of minutes")
    args = parser.parse_args()

    image = args.image.read_bytes()
    entry = args.base if args.entry is None else args.entry
    if args.against and args.assume_zero:
        raise SystemExit("--against and --assume-zero are two different claims "
                         "about what is on the board; pass one")
    present = None
    if args.against:
        present = args.against.read_bytes()
    elif args.assume_zero:
        present = bytes(len(image) + 1)
    place = word_writes(image, args.base, present)
    verify = page_reads(args.base, len(image))
    arm = arm_commands(entry, args.vector)

    # Read the placement back out of its own commands: a transcription or
    # endianness error here would be silent and would run as code.
    rebuilt = bytearray(present[:len(image)] if present else b"")
    rebuilt += bytes(max(0, len(image) - len(rebuilt)))
    for line in place:
        address = int(line[7:11], 16) - args.base
        value = int(line.split(",")[1], 16)
        rebuilt[address:address + 2] = value.to_bytes(2, "little")
    if bytes(rebuilt[:len(image)]) != image:
        raise SystemExit("internal error: emitted commands do not reproduce the image")

    args.output.mkdir(parents=True, exist_ok=True)
    (args.output / "place.txt").write_text("\n".join(place) + "\n")
    (args.output / "verify.txt").write_text("\n".join(verify) + "\n")
    (args.output / "arm.txt").write_text("\n".join(arm) + "\n")

    print(f"  image      {len(image)} bytes at {args.base:#06x}"
          f"..{args.base + len(image) - 1:#06x}")
    full = len(image) // 2 + len(image) % 2
    note = "" if present is None else (
        f" - {full - len(place)} of {full} skipped as already present; "
        f"VERIFY IS NOT OPTIONAL")
    print(f"  place.txt  {len(place)} write commands (round-trip checked){note}")
    print(f"  verify.txt {len(verify)} page dumps")
    print(f"  arm.txt    hooks vector {args.vector:#04x} to {entry:#06x}; "
          f"read the old value first and keep it")
    print(f"  ports {', '.join(hex(p) for p in FORBIDDEN_PORTS)} are never written "
          f"by these commands: they place data and one vector, nothing else")
    return 0


sys.exit(main())
