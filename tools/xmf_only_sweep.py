#!/usr/bin/env python3
"""Find harness logic keyed to addresses no ROM image can execute.

The XMF payloads load at 0x40000 and the board ROMs at 0x80000, so a physical
address literal in [0x40000, 0x80000) can only ever be reached by an XMF run.
Most of those in this harness are legitimate - the XMF supervisor's own boot,
delay and serial quirks, which a ROM does not share and does not need. The ones
that matter are blocks providing a *service* both image families need, where
only the XMF address was ever found: those run for the payloads and silently do
nothing for the board firmware.

Three have been found the hard way, each after a long chase:

  the serial ISR-exit blocks, gated behind a hot-address set they could not
  reach (fixed);
  `carrier-detect-override` mapped onto port 0x14 bit 0x40, which on the ROMs
  is the front-panel button (fixed);
  the DAA detector byte at [0x649], published only at 0x5DB9D/0x5DBE7, so a
  ROM dial answers NO DIAL TONE with a fully qualified detector unread (open).

Run it after adding any address-keyed block. It cannot tell a legitimate
XMF-only quirk from a missing ROM counterpart - that judgement is the reader's
- but it puts every candidate in one list.
"""
from __future__ import annotations

import argparse
import pathlib
import re

XMF_ONLY = range(0x40000, 0x80000)
ROM_ONLY = range(0xF8000, 0x100000)
LITERAL = re.compile(r"0x[0-9A-Fa-f]{5}\b")


def scan(path: pathlib.Path) -> list[tuple[int, str, list[int], list[int]]]:
    rows = []
    for number, line in enumerate(path.read_text().splitlines(), 1):
        if line.lstrip().startswith("#") or '"""' in line:
            continue
        values = [int(m.group(0), 16) for m in LITERAL.finditer(line)]
        xmf = [v for v in values if v in XMF_ONLY]
        rom = [v for v in values if v in ROM_ONLY or 0x80000 <= v < 0xF8000]
        if xmf:
            rows.append((number, line.strip(), xmf, rom))
    return rows


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("paths", nargs="*", default=None)
    parser.add_argument("--paired", action="store_true",
                        help="include lines that also name a ROM-range address")
    args = parser.parse_args()
    paths = ([pathlib.Path(p) for p in args.paths]
             or sorted(pathlib.Path("courier_emu").glob("*.py")))
    total = 0
    for path in paths:
        rows = [r for r in scan(path) if args.paired or not r[3]]
        if not rows:
            continue
        print(f"\n=== {path} ({len(rows)})")
        for number, line, xmf, rom in rows:
            note = f"  [also ROM: {', '.join(f'{v:#07x}' for v in rom)}]" if rom else ""
            print(f"  {number:5d}  {line[:92]}{note}")
        total += len(rows)
    print(f"\n{total} lines keyed only to addresses a ROM image cannot reach")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
