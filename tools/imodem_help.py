#!/usr/bin/env python3
"""Decode the I-modem's built-in S-register help table.

The help screens are stored tokenized: bytes a0..ff index a length-prefixed
word dictionary that sits immediately before the text, and bytes 80..9f are
run-length indents.  Decoding it gives the firmware's own name for every
S-register bit, which is what settles bit polarity - `bd` is "Disable" and
`ee` is "Enable", so a register whose bits read "Disable x2" is inverted
before it reaches the datapump.

    python tools/imodem_help.py <image.NAC> [S58]
"""
from __future__ import annotations

import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))

from courier_emu.nac import NacImage  # noqa: E402

DICT_ANCHOR = b"\x03Off\x02On\x06Repeat"


def dictionary(blob: bytes) -> tuple[dict[int, str], int]:
    start = blob.index(DICT_ANCHOR)
    words, cursor = [], start
    while True:
        length = blob[cursor]
        if length == 0 or length > 0x40:
            break
        words.append(blob[cursor + 1:cursor + 1 + length].decode("latin1"))
        cursor += 1 + length
    # The dictionary ends flush against ff, so its length fixes the first token.
    origin = 0x100 - len(words)
    return {origin + i: word for i, word in enumerate(words)}, cursor


def expand(raw: bytes, words: dict[int, str]) -> str:
    text = []
    for byte in raw:
        if byte in words:
            text.append(words[byte])
        elif 0x80 <= byte < 0xA0:
            text.append(" " * (byte & 0x1F))
        else:
            text.append(chr(byte))
    return " ".join("".join(text).split())


def registers(path: str | Path) -> dict[str, list[tuple[int, str]]]:
    _, blob = NacImage.load(path).flatten()
    words, text_start = dictionary(blob)
    # Headings and bit lines share one block that runs from the dictionary's end.
    block = blob[text_start:text_start + 0x4000]
    marks = [(m.start(), m.group(1).decode())
             for m in re.finditer(rb"(S\d{1,3})[\x20\xd0-\xdf]", block)]
    out: dict[str, list[tuple[int, str]]] = {}
    for index, (offset, name) in enumerate(marks):
        end = marks[index + 1][0] if index + 1 < len(marks) else len(block)
        rows = []
        for line in re.finditer(
                rb"[\x80-\x9f](\d{1,3})(?:\xed| = )([^\x00]{0,60})\x00",
                block[offset:end]):
            rows.append((int(line.group(1)), expand(line.group(2), words)))
        if rows:
            out.setdefault(name, rows)
    return out


def main() -> None:
    table = registers(sys.argv[1])
    wanted = sys.argv[2:]
    for name, rows in table.items():
        if wanted and name not in wanted:
            continue
        print(name)
        for value, text in rows:
            print(f"  {value:>3} = {text}")


if __name__ == "__main__":
    main()
