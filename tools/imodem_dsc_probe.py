#!/usr/bin/env python3
"""Trace the I-modem's Am79C30 accesses, with the code address behind each.

The register file answers what the firmware wrote; what it does not say is
*where* the firmware asks, and that is what the ISDN side needs next - which
register the line-state poll reads, and from what loop.  This wraps the DSC
and records every select/read/write with the CS:EIP of the instruction.

    .venv/bin/python tools/imodem_dsc_probe.py --send AT --send AT --send ATI12
"""
from __future__ import annotations

import argparse
import json
from collections import Counter
from pathlib import Path
import sys

sys.path.insert(0, str(Path(__file__).resolve().parent.parent))

from courier_emu.am79c30 import Am79C30
from courier_emu.isdn import IsdnMachine
from courier_emu.isdn_console import scripted_pump
from courier_emu.nac import NacImage


class TracingDsc(Am79C30):
    """The register file, plus a note of who touched it."""

    def attach(self, machine: IsdnMachine) -> None:
        self._machine = machine
        self.events: list[tuple[int, str, int, int, int]] = []
        self.sites: Counter = Counter()

    def _pc(self) -> int:
        uc = getattr(self, "_machine", None) and self._machine.machine
        if uc is None:
            return 0
        from unicorn.x86_const import UC_X86_REG_CS, UC_X86_REG_EIP
        return uc.reg_read(UC_X86_REG_CS) * 16 + uc.reg_read(UC_X86_REG_EIP)

    def read(self, port: int) -> int:
        register = self.selected or 0
        value = super().read(port)
        pc = self._pc()
        self.events.append((self._machine.instructions, "read", register, value, pc))
        self.sites[("read", register, pc)] += 1
        return value

    def write(self, port: int, value: int) -> None:
        pc = self._pc()
        kind = "select" if port == 0x0300 else "write"
        register = value if kind == "select" else (self.selected or 0)
        super().write(port, value)
        self.events.append((self._machine.instructions, kind, register, value, pc))
        self.sites[(kind, register, pc)] += 1


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--image", default="Ie030002.nac")
    parser.add_argument("--send", action="append", default=[])
    parser.add_argument("--after", type=int, default=5_000_000)
    parser.add_argument("--every", type=int, default=20_000_000)
    parser.add_argument("--instructions", type=int, default=0)
    parser.add_argument("--tail", type=int, default=40)
    parser.add_argument("--output", type=Path)
    args = parser.parse_args()

    lines = args.send or ["AT", "AT", "ATI12"]
    limit = args.instructions or args.after + args.every * (len(lines) + 1)

    transcript: list[tuple[int, str, str]] = []
    inner = scripted_pump(lines, after=args.after, every=args.every,
                          transcript=transcript)

    dsc = TracingDsc()

    def pump(machine: IsdnMachine) -> None:
        inner(machine)

    machine = IsdnMachine(NacImage.load(args.image), serial_pump=pump)
    machine.dsc = dsc
    dsc.attach(machine)
    result = machine.run(limit)

    def fmt(event):
        count, kind, register, value, pc = event
        return {"instructions": count, "op": kind, "register": dsc.name(register),
                "value": f"{value:#04x}", "pc": hex(pc)}

    report = {
        "status": result.status,
        "sent": lines,
        "events": len(dsc.events),
        "first": [fmt(e) for e in dsc.events[:20]],
        "tail": [fmt(e) for e in dsc.events[-args.tail:]],
        "sites": [
            {"op": op, "register": dsc.name(reg), "pc": hex(pc), "count": n}
            for (op, reg, pc), n in dsc.sites.most_common(40)
        ],
        "session": [
            {"instructions": c, "direction": d, "text": t}
            for c, d, t in transcript
        ],
    }
    text = json.dumps(report, indent=2, sort_keys=True)
    if args.output:
        args.output.parent.mkdir(parents=True, exist_ok=True)
        args.output.write_text(text + "\n")
    print(text)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
