#!/usr/bin/env python3
"""Enumerate every 80186 IN/OUT site in a captured Courier flash image.

A linear sweep over a 512 KiB image desynchronizes inside the DSP datapump and
the coefficient tables, so each candidate opcode is accepted only when several
disassemblies started at earlier offsets converge onto it. Port numbers loaded
into DX are resolved only when an immediate `mov dx` reaches the site without an
intervening branch, call, or non-immediate redefinition of DX; anything else is
reported unresolved rather than guessed.

**This tool finds sites; it must never be used to prove one absent.** The
consensus test has false negatives as well as false positives: a genuine
instruction preceded by short or irregular code attracts few converging
predecessors and is rejected. `mov dx, 0x40` at `0e3ad`, inside the DSP
downloader, follows `push cx; pushf; cli` and draws only three votes. Any
negative claim has to be settled against raw bytes, not against this output.

Usage:
    python tools/io_port_scan.py <flash.rom> <output-dir>
"""
from __future__ import annotations

import collections
import json
import sys
from pathlib import Path

import capstone

# Regions that hold 80186 code. The datapump at 0x29800..0x44000 is big-endian
# C5x words and the block at 0x7c000..0x7e000 is the coefficient table; both
# decode as dense nonsense and are excluded rather than filtered afterwards.
CODE_REGIONS = ((0x00000, 0x29800), (0x44000, 0x7C000), (0x7E000, 0x80000))

IMMEDIATE = {0xE4: ("in", 1), 0xE5: ("in", 2), 0xE6: ("out", 1), 0xE7: ("out", 2)}
VIA_DX = {0xEC: ("in", 1), 0xED: ("in", 2), 0xEE: ("out", 1), 0xEF: ("out", 2)}

BOUNDARY_LOOKBACK = 40
BOUNDARY_VOTES = 4
DX_LOOKBACK = 80


class Scanner:
    def __init__(self, image: bytes) -> None:
        self.rom = image
        self.md = capstone.Cs(capstone.CS_ARCH_X86, capstone.CS_MODE_16)

    def in_code(self, addr: int) -> bool:
        return any(start <= addr < end for start, end in CODE_REGIONS)

    def is_boundary(self, addr: int, *, votes: int = BOUNDARY_VOTES) -> bool:
        """True when disassembly from `votes` earlier offsets lands on `addr`."""
        hits = 0
        for start in range(max(0, addr - BOUNDARY_LOOKBACK), addr):
            for insn in self.md.disasm(self.rom[start : addr + 2], start):
                if insn.address == addr:
                    hits += 1
                    break
                if insn.address > addr:
                    break
            if hits >= votes:
                return True
        return False

    def resolve_dx(self, site: int) -> int | None:
        for start in range(max(0, site - DX_LOOKBACK), site - 2):
            if not self.is_boundary(start, votes=3):
                continue
            loaded: int | None = None
            reached = False
            for insn in self.md.disasm(self.rom[start : site + 1], start):
                if insn.address == site:
                    reached = True
                    break
                if insn.mnemonic == "mov" and insn.op_str.startswith("dx, 0x"):
                    loaded = int(insn.op_str.split("0x")[1], 16)
                elif insn.mnemonic in ("call", "lcall", "jmp", "ljmp", "ret", "retf"):
                    loaded = None
                elif insn.mnemonic.startswith("j"):
                    loaded = None
                elif insn.op_str.startswith("dx") and ", dx" not in insn.op_str:
                    loaded = None
            if reached:
                return loaded
        return None

    def scan(self) -> list[dict]:
        sites: list[dict] = []
        for addr, byte in enumerate(self.rom):
            if not self.in_code(addr):
                continue
            if byte in IMMEDIATE:
                # `9a`/`ea` far pointers whose offset low byte is e4..e7 decode
                # as an immediate IN/OUT; so do `call rel16` displacements. The
                # predecessor check removes the far-pointer class outright.
                if addr and self.rom[addr - 1] in (0x9A, 0xEA):
                    continue
                if self.is_boundary(addr):
                    direction, size = IMMEDIATE[byte]
                    sites.append({"address": addr, "direction": direction, "size": size,
                                  "port": self.rom[addr + 1], "form": "immediate"})
            elif byte in VIA_DX:
                if self.is_boundary(addr):
                    direction, size = VIA_DX[byte]
                    sites.append({"address": addr, "direction": direction, "size": size,
                                  "port": self.resolve_dx(addr), "form": "dx"})
        return sites


def summarize(sites: list[dict]) -> dict:
    ports: dict[int, collections.Counter] = collections.defaultdict(collections.Counter)
    for site in sites:
        if site["port"] is not None:
            ports[site["port"]][f"{site['direction']}{site['size'] * 8}"] += 1
    return {
        f"{port:#06x}": {
            "accesses": dict(sorted(counter.items())),
            "sites": sorted(
                f"{s['address']:05x}" for s in sites if s["port"] == port
            ),
        }
        for port, counter in sorted(ports.items())
    }


def main() -> int:
    if len(sys.argv) != 3:
        print(__doc__.strip(), file=sys.stderr)
        return 2
    image = Path(sys.argv[1]).read_bytes()
    out = Path(sys.argv[2])
    out.mkdir(parents=True, exist_ok=False)

    sites = Scanner(image).scan()
    unresolved = [s for s in sites if s["port"] is None]

    (out / "sites.json").write_text(json.dumps(sites, indent=1))
    (out / "ports.json").write_text(json.dumps(summarize(sites), indent=1))
    (out / "manifest.json").write_text(json.dumps({
        "image": str(Path(sys.argv[1]).resolve()),
        "code_regions": [[f"{a:#07x}", f"{b:#07x}"] for a, b in CODE_REGIONS],
        "validated_sites": len(sites),
        "unresolved_dx_sites": len(unresolved),
        "boundary_votes": BOUNDARY_VOTES,
        "assumptions": [
            "Immediate opcodes inside another instruction's displacement or immediate can still survive; confirm any isolated site against its raw bytes.",
            "Consensus decoding accepts an opcode as an instruction; it is not a proof.",
            "The boundary test also rejects genuine instructions preceded by short or irregular code, so absence from this output is not evidence of absence.",
            "Unresolved DX sites are omitted from the port map, so counts are lower bounds.",
            "A site's existence does not mean the path is reachable at run time.",
        ],
    }, indent=1))
    print(f"{len(sites)} sites, {len(unresolved)} unresolved DX -> {out}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
