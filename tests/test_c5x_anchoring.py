"""Rejecting data that disassembles into plausible instructions."""
from __future__ import annotations

from pathlib import Path
import struct
import sys
import unittest

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "tools"))
from c5x_disasm import anchored, disassemble  # noqa: E402

ROOT = Path(__file__).resolve().parents[1]
IMAGE = ROOT / "artifacts/courier-board-21210-capture-403/courier-board.rom"


@unittest.skipUnless(IMAGE.exists(), "no board capture in this working tree")
class AnchoringTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        data = IMAGE.read_bytes()
        words = list(struct.unpack_from("<%dH" % ((0x3D0F4 - 0x36E90) // 2), data, 0x36E90))
        program = [0] * 0x10000
        program[0x9D00:0x9D00 + len(words)] = words[:0x10000 - 0x9D00]
        cls.overlay6 = disassemble(program, 0x9D00, 0x9D00 + len(words) - 2)

        resident = list(struct.unpack_from("<%dH" % ((0x36E8E - 0x29140) // 2), data, 0x29140))
        program = [0] * 0x10000
        program[0x8000:0x8000 + len(resident)] = resident[:0x10000 - 0x8000]
        cls.resident = disassemble(program, 0x8000, 0x8000 + len(resident) - 2)

    def test_the_residents_serial_isr_is_anchored(self) -> None:
        # 8182 reads DRR and 818f writes DXR, inside a routine with branches.
        for pc in (0x8182, 0x818F, 0x808A):
            self.assertTrue(anchored(self.resident, pc), f"{pc:04x} should be code")

    def test_overlay_sixes_apparent_serial_access_is_not(self) -> None:
        # These decode as `lamm @20` and `lamm @30` but sit in data tables, and
        # reading them as I/O is what produced a wrong two-converter finding.
        for pc in (0xC019, 0xC207, 0xCA64, 0xCBF2):
            self.assertFalse(anchored(self.overlay6, pc), f"{pc:04x} should be data")
