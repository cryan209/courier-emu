#!/usr/bin/env python3
"""Type at the I-modem's AT interface, and report how it chose its answer.

The transcript alone does not say why a bare `AT` answers `NO CARRIER`. This
also traces the decision, by watching three points the disassembly names:

  a8067  cmp [d08b],1   the go-idle epilogue: OK only if the recorded
  a806e  test [d2a1],47 disconnect cause is 1, and a second flag is set
  ab33b  mov [d08b],al  the cause recorder, first writer wins

so a run prints the cause, where it was recorded, and the answer it produced.

    .venv/bin/python tools/imodem_at_probe.py --send AT --send ATI3 \
        --output artifacts/imodem-at/probe.json
"""
from __future__ import annotations

import argparse
import json
from pathlib import Path
import sys

sys.path.insert(0, str(Path(__file__).resolve().parent.parent))

from courier_emu.isdn import IsdnMachine
from courier_emu.isdn_console import scripted_pump
from courier_emu.nac import NacImage

# The go-idle epilogue's test, and the cause recorder it reads.
RESULT_DECISION = 0xA8067
CAUSE_RECORDER = 0xAB33B
CAUSE_BYTE = 0xD08B
FLAGS_BYTE = 0xD2A1
# Result codes, from the table at 0xcef4b.
RESULT_NAMES = {0: "OK", 1: "CONNECT", 2: "RING", 3: "NO CARRIER", 4: "ERROR"}


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--image", default="Ie030002.nac")
    parser.add_argument(
        "--send", action="append", default=[],
        help="a command line to type; the firmware swallows the first one, "
             "so lead with a throwaway AT",
    )
    parser.add_argument("--after", type=int, default=5_000_000)
    parser.add_argument("--every", type=int, default=20_000_000)
    parser.add_argument("--instructions", type=int, default=0)
    parser.add_argument("--output", type=Path)
    args = parser.parse_args()

    lines = args.send or ["AT", "AT", "ATI3"]
    limit = args.instructions or args.after + args.every * (len(lines) + 1)

    transcript: list[tuple[int, str, str]] = []
    decisions: list[dict[str, object]] = []
    causes: list[dict[str, object]] = []
    inner = scripted_pump(lines, after=args.after, every=args.every,
                          transcript=transcript)
    hooked = [False]

    def pump(machine: IsdnMachine) -> None:
        inner(machine)
        if hooked[0] or machine.machine is None:
            return
        hooked[0] = True
        from unicorn import UC_HOOK_CODE
        from unicorn.x86_const import (UC_X86_REG_AL, UC_X86_REG_CS, UC_X86_REG_DS,
                                       UC_X86_REG_SI)

        uc = machine.machine

        def on_decision(_uc, _address, _size, _data) -> None:
            base = uc.reg_read(UC_X86_REG_DS) * 16
            cause = uc.mem_read(base + CAUSE_BYTE, 1)[0]
            flags = uc.mem_read(base + FLAGS_BYTE, 1)[0]
            code = 0 if cause == 1 and flags & 0x47 else 3
            decisions.append({
                "instructions": machine.instructions,
                "cause": cause,
                "flags": flags,
                "result": code,
                "answer": RESULT_NAMES.get(code, str(code)),
            })

        def on_cause(_uc, _address, _size, _data) -> None:
            # ab329 pops the return address into SI and reads the cause as an
            # inline byte, so SI - 1 is the argument and SI - 4 the call site.
            site = uc.reg_read(UC_X86_REG_CS) * 16 + uc.reg_read(UC_X86_REG_SI)
            causes.append({
                "instructions": machine.instructions,
                "cause": uc.reg_read(UC_X86_REG_AL),
                "recorded_at": hex(site - 4),
            })

        uc.hook_add(UC_HOOK_CODE, on_decision,
                    begin=RESULT_DECISION, end=RESULT_DECISION)
        uc.hook_add(UC_HOOK_CODE, on_cause,
                    begin=CAUSE_RECORDER, end=CAUSE_RECORDER)

    machine = IsdnMachine(NacImage.load(args.image), serial_pump=pump)
    result = machine.run(limit)

    report = {
        "image": args.image,
        "sent": lines,
        "status": result.status,
        "session": [
            {"instructions": count, "direction": direction, "text": text}
            for count, direction, text in transcript
        ],
        "disconnect_causes": causes,
        "result_decisions": decisions,
        "serial": result.serial,
    }
    text = json.dumps(report, indent=2, sort_keys=True)
    if args.output:
        args.output.parent.mkdir(parents=True, exist_ok=True)
        args.output.write_text(text + "\n")
    print(text)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
