#!/usr/bin/env python3
"""Recover flat firmware images from the USR SDL upgrade packages in docs/usrdl/.

Two carriers hold the same firmware, and this handles both.

The DOS loaders (SDL*.EXE) embed the image as a run of binary download
records, each covering sixteen bytes:

    [len=0x10] [addr hi] [addr lo] [type=00] [16 data bytes] [checksum]

The checksum makes the whole record sum to zero mod 256, which is what
identifies a record rather than a coincidence: on SDL.EXE 13,193 consecutive
records validate.  Addresses are only 16 bits and wrap, so they order the
records within a segment but do not place them in a 512 KiB flash; where the
address does not advance by 0x10 this reports a segment boundary instead of
inventing a mapping.

The .XMD files are the same firmware for the modem's own XMODEM loader: a
64-byte header followed by the image under a flat XOR 0x55.  The header is not
decoded here - it varies per build around an "NHCFG" marker and most likely
carries a checksum and a model gate, but that is not established.
"""

import argparse
import hashlib
import json
import re
import sys
from pathlib import Path

RECORD_LEN = 0x10
XMD_XOR = 0x55
XMD_HEADER_LEN = 64


def parse_records(blob):
    """Yield (address, data) for every checksum-valid download record."""
    out = []
    i = 0
    n = len(blob)
    while i + 5 + RECORD_LEN <= n:
        if blob[i] != RECORD_LEN:
            i += 1
            continue
        hi, lo, typ = blob[i + 1], blob[i + 2], blob[i + 3]
        data = blob[i + 4:i + 4 + RECORD_LEN]
        check = blob[i + 4 + RECORD_LEN]
        if typ != 0 or (RECORD_LEN + hi + lo + typ + sum(data) + check) & 0xFF:
            i += 1
            continue
        out.append(((hi << 8) | lo, data))
        i += 5 + RECORD_LEN
    return out


def extract_loader(path):
    """Flat image plus the segment boundaries, from a DOS SDL loader."""
    records = parse_records(path.read_bytes())
    image = bytearray()
    breaks = []
    previous = None
    for address, data in records:
        if previous is not None and address != (previous + RECORD_LEN) & 0xFFFF:
            breaks.append({"image_offset": len(image),
                           "from": previous, "to": address})
        previous = address
        image += data
    return bytes(image), records, breaks


def extract_xmd(path):
    """Flat image from an .XMD, with its undecoded header returned separately."""
    blob = path.read_bytes()
    header, body = blob[:XMD_HEADER_LEN], blob[XMD_HEADER_LEN:]
    return bytes(b ^ XMD_XOR for b in body), header


def strings_of(image, minimum=5):
    return {m.group().decode("latin1")
            for m in re.finditer(rb"[\x20-\x7e]{%d,}" % minimum, image)}


def describe(path, image, extra):
    return {
        "source": str(path),
        "image_bytes": len(image),
        "image_sha256": hashlib.sha256(image).hexdigest(),
        **extra,
    }


def cmd_extract(args):
    report = []
    for name in args.inputs:
        path = Path(name)
        if path.suffix.upper() == ".XMD":
            image, header = extract_xmd(path)
            extra = {"carrier": "xmd", "header_hex": header[:16].hex()}
        else:
            image, records, breaks = extract_loader(path)
            extra = {"carrier": "sdl-loader",
                     "records": len(records),
                     "segment_breaks": breaks}
        if args.out:
            out = Path(args.out) / (path.stem + ".img")
            out.parent.mkdir(parents=True, exist_ok=True)
            out.write_bytes(image)
            extra["written"] = str(out)
        report.append(describe(path, image, extra))
    json.dump(report, sys.stdout, indent=1)
    print()


def load_any(path):
    path = Path(path)
    if path.suffix.upper() == ".XMD":
        return extract_xmd(path)[0]
    if path.suffix.lower() == ".img":
        return path.read_bytes()
    return extract_loader(path)[0]


def cmd_compare(args):
    left, right = Path(args.left), Path(args.right)
    a, b = strings_of(load_any(left)), strings_of(load_any(right))
    shared = a & b
    print(f"{left.name}: {len(a)} strings")
    print(f"{right.name}: {len(b)} strings")
    print(f"shared: {len(shared)}"
          f"  ({100 * len(shared) / len(a):.1f}% of {left.name},"
          f" {100 * len(shared) / len(b):.1f}% of {right.name})")
    for label, only in ((left.name, a - b), (right.name, b - a)):
        printable = sorted(s for s in only if re.fullmatch(r"[ -~]{5,}", s)
                           and sum(c.isalpha() or c.isspace() for c in s) > len(s) * 0.7)
        print(f"\nonly in {label} ({len(only)} total, {len(printable)} word-like):")
        for s in printable[:args.limit]:
            print("   ", s.strip())


def main():
    parser = argparse.ArgumentParser(description=__doc__,
                                     formatter_class=argparse.RawDescriptionHelpFormatter)
    sub = parser.add_subparsers(dest="command", required=True)

    e = sub.add_parser("extract", help="recover flat images")
    e.add_argument("inputs", nargs="+")
    e.add_argument("--out", help="directory to write <stem>.img into")
    e.set_defaults(func=cmd_extract)

    c = sub.add_parser("compare", help="string-level diff of two images")
    c.add_argument("left")
    c.add_argument("right")
    c.add_argument("--limit", type=int, default=40)
    c.set_defaults(func=cmd_compare)

    args = parser.parse_args()
    args.func(args)


if __name__ == "__main__":
    main()
