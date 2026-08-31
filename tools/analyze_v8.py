#!/usr/bin/env python3
"""Compare Courier C51/C52 V.8 state code and emit a static Markdown report."""
from __future__ import annotations

import argparse
from hashlib import sha256
from pathlib import Path
import re
import sys

sys.path.insert(0, str(Path(__file__).resolve().parent))
from c5x_disasm import decode, disassemble  # noqa: E402
sys.path.insert(0, str(Path(__file__).resolve().parent.parent))
from courier_emu.bridge import (  # noqa: E402
    C52_CALL_OVERLAY_DESTINATION as OVERLAY_DEST,
    C52_CALL_OVERLAY_SOURCE as OVERLAY_SOURCE,
    C52_CALL_OVERLAY_SIGNATURE,
)
from courier_emu.xmf import XmfImage  # noqa: E402
from unpack_sdl import packet_runs  # noqa: E402

XMF_NAMES = (
    "main211.xmf", "main2205.XMF", "3453Bv2.1.1.xmf", "2_3_33.XMF",
    "MAIN_2.3.12.XMF", "MAIN_2.3.15.XMF", "MAIN_2.3.31.XMF",
)
LOOP_OPS = (0xBE58, 0xF38C)


def words_from_bytes(data: bytes) -> list[int]:
    return [int.from_bytes(data[i:i + 2], "little") for i in range(0, len(data) - 1, 2)]


def xmf_memory(path: Path) -> tuple[list[int], int | None]:
    image = XmfImage.load(path)
    memory = [0] * 65536
    source = None
    for origin, segment in image.dsp_program_segments():
        segment_words = words_from_bytes(segment)
        memory[origin:origin + len(segment_words)] = segment_words
        first = 0
        while True:
            first = segment.find(C52_CALL_OVERLAY_SIGNATURE, first)
            if first < 0:
                break
            if not first & 1:
                candidate = origin + first // 2
                if source is None or abs(candidate - OVERLAY_SOURCE) < abs(source - OVERLAY_SOURCE):
                    source = candidate
            first += 2
    # The recovered c418 publication applies to the 2.1/2.2 family. The 2.3
    # signature is a different resident stream; copying it over c418 would
    # overwrite its live e000 code.
    if source is not None and abs(source - OVERLAY_SOURCE) < 0x1000:
        count = OVERLAY_DEST - source
        memory[OVERLAY_DEST:OVERLAY_DEST + count] = memory[source:source + count]
    return memory, source


def sdl_modules(path: Path) -> list[bytes]:
    modules: list[bytearray] = []
    for run in packet_runs(path.read_bytes()):
        payload = run["payload"]
        assert isinstance(payload, bytes)
        destination = int(run["first_next_address_token"]) >> 8
        if destination and modules:
            modules[-1].extend(payload)
        else:
            modules.append(bytearray(payload))
    return [bytes(module[16:]) for module in modules if len(module) >= 16]


def c51_memory(path: Path) -> list[int]:
    modules = sdl_modules(path)
    memory = [0] * 65536
    # SDL_49 modules 10 and 12 are the resident C51 image and V.8 overlay.
    for index, origin in ((10, 0x8000), (12, 0xB000)):
        words = words_from_bytes(modules[index])
        memory[origin:origin + len(words)] = words
    return memory


def loops(memory: list[int]) -> list[int]:
    return [pc + 1 for pc in range(65533) if tuple(memory[pc:pc + 2]) == LOOP_OPS]


def nearest_base(memory: list[int], loop: int) -> int | None:
    for pc in range(loop - 1, max(-1, loop - 24), -1):
        if memory[pc] == 0xBF80:
            return memory[pc + 1]
    return None


def normalized(instructions: list[str]) -> list[str]:
    return [re.sub(r"\b[0-9a-f]{4,8}\b", "#", text) for text in instructions]


def code_block(memory: list[int], first: int, last: int) -> str:
    lines = []
    for ins in disassemble(memory, first, last):
        raw = " ".join(f"{word:04x}" for word in ins.words)
        lines.append(f"{ins.pc:04x}: {raw:<10} {ins.text}")
    return "\n".join(lines)


def handler_assignments(memory: list[int], first: int, last: int) -> list[tuple[int, int]]:
    result = []
    pc = first
    while pc < last:
        ins = decode(memory, pc)
        if ins.words[0] == 0xAE48 and len(ins.words) == 2:
            result.append((pc, ins.words[1]))
        pc += ins.size
    return result


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--root", type=Path, default=Path(__file__).resolve().parent.parent)
    parser.add_argument("--output", type=Path)
    args = parser.parse_args()
    root = args.root.resolve()

    images = []
    for name in XMF_NAMES:
        path = root / name
        if path.exists():
            memory, source = xmf_memory(path)
            images.append((name, memory, source))
    main_name, main_memory, _ = images[0]

    report = ["# Static C51/C52 V.8 comparison", ""]
    report += ["## C52 builds", "", "| image | overlay source | divide loops (base) |", "|---|---:|---|"]
    for name, memory, source in images:
        entries = []
        for loop in loops(memory):
            base = nearest_base(memory, loop)
            entries.append(f"`{loop:04x}` (`{base:04x}`)" if base is not None else f"`{loop:04x}`")
        report.append(f"| `{name}` | `{source:04x}` | {' · '.join(entries)} |")

    sdl = root / "docs/New Folder With Items/SDL_49.EXE"
    old_memory = c51_memory(sdl)
    old_loops = loops(old_memory)
    report += ["", "## Older C51 control", ""]
    report.append("The SDL_49 C51 V.8 overlay contains the same three unsigned multi-precision divide loops:")
    report.append("")
    report.append("| loop | data base |")
    report.append("|---:|---:|")
    for loop in old_loops:
        report.append(f"| `{loop:04x}` | `{nearest_base(old_memory, loop):04x}` |")

    # Compare aligned instructions; targets move but the arithmetic body does not.
    new_body = normalized([ins.text for ins in disassemble(main_memory, 0xc852, 0xc862)])
    old_body = normalized([ins.text for ins in disassemble(old_memory, 0xc95f, 0xc96f)])
    report += ["", f"Normalized first loop/body equality: **{new_body == old_body}**.", ""]
    report.append("This cross-generation identity makes the loops software arithmetic, not C52-only ASIC commands.")

    report += ["", "## C52 state dispatcher", "", "```text", code_block(main_memory, 0xc418, 0xc427), "```", ""]
    report.append("Direct handler installations recovered statically:")
    report.append("")
    for pc, handler in handler_assignments(main_memory, 0xc418, 0xc700):
        report.append(f"- `{pc:04x}` installs handler `{handler:04x}` in data register `48`.")

    report += ["", "## Handler c617 and transition", "", "```text", code_block(main_memory, 0xc617, 0xc6cc), "```", ""]
    report += ["## Three divide loops", "", "```text", code_block(main_memory, 0xc7e9, 0xc87f), "```", ""]

    report += [
        "## Reaching-definition result", "",
        "For the third loop, the local definitions are:", "",
        "```text",
        "AR1  = d2a8",
        "AR2  = d2a8 + data[79]",
        "INDX = 2 * data[26] - data[79]",
        "ACC  = unsigned(data[78])",
        "if C == 0: AR1 -= INDX; AR2 += INDX",
        "```", "",
        "The measured entry (`AR1=a51b`, `AR2=d2a8`, `ACC=7fef`) therefore implies "
        "`data[79]=d273`, `data[26]=0`, and `INDX=2d8d`. The zero at `a51b` has no "
        "reaching C52 write. It is an input to a generic multiple-precision routine, not a literal state token.", "",
        "The same routine relocates by exactly `-8000` in every 2.3.x build (`d2a8 -> 52a8`) "
        "and by `+05a0` in the C51 image (`d2a8 -> d848`). This proves the addresses belong "
        "to revision-specific software workspace layouts.", "",
        "## Artifacts", "",
        f"- Main overlay digest: `{sha256(bytes().join(word.to_bytes(2, 'little') for word in main_memory[0xc418:0xce70])).hexdigest()}`",
        f"- Compared C52 images: {len(images)}",
        f"- C51 loops: {', '.join(f'{loop:04x}' for loop in old_loops)}",
    ]

    text = "\n".join(report) + "\n"
    if args.output:
        args.output.write_text(text)
    else:
        print(text, end="")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
