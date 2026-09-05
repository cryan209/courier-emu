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


def test_madd_reads_its_coefficients_from_program_memory():
    """MADD/MADS take a PROGRAM address from BMAR, and advance it under RPT.

    Reading data memory instead returned zero for every coefficient table this
    firmware uses, which silenced the FSK modulator and ANSam alike.
    """
    import struct

    from courier_emu.dsp import NativeC5x
    from courier_emu.rom import CourierRom

    rom = CourierRom.load(
        'artifacts/courier-board-21210-capture-403/courier-board.rom')
    coefficients = (2, 3, 5, 7)
    window = (11, 13, 17, 19)
    table, halt = 0x0020, 0x0010
    driver = [0xBC00,           # ldp  #000   - BMAR is reachable on page 0
              0xAE1F, table,    # splk @1f, #<table>
              0xBF00,           # spm  #0
              0xBF09, 0x0300,   # lar  ar1, #0300
              0x8B89,           # mar  *, ar1 - MADS indexes through ARP
              0xBC07,           # ldp  #007
              0xBE59,           # zap
              0xBB03,           # rpt  #03
              0xAAA0,           # mads *+
              0xBE04,           # apac
              0x9840,           # sach @40
              0x9041,           # sacl @41
              0x7980, halt]
    driver += [0] * (table - len(driver)) + list(coefficients)

    with NativeC5x(rom) as core:
        core.load_rom(struct.pack('<%dH' % len(driver), *driver))
        core.set_mpmc_pin(0)
        for offset, value in enumerate(window):
            core.set_data(0x300 + offset, value)
        core.set_pc(0)
        for _ in range(64):
            core.step(1)
            if core.state()['pc'] == halt:
                break
        product = (core.data(0x3C0) << 16) | core.data(0x3C1)

    expected = sum(c * w for c, w in zip(coefficients, window))
    assert product == expected, (
        f'MADS accumulated {product}, expected {expected}: the coefficients '
        'are not being walked through program memory')
