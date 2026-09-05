"""The V.90 DIL descriptor, assembled by the firmware's own code.

The reference values are the descriptor this modem was captured transmitting -
a 2058-bit Ja with a valid CRC - so these tests compare the ROM against the
wire, not against another reading of the ROM.
"""
from __future__ import annotations

from pathlib import Path
import unittest

from courier_emu.rom import CourierRom
from courier_emu import vpcm


ROOT = Path(__file__).resolve().parents[1]
IMAGE = ROOT / "artifacts/courier-board-21210-capture-403/courier-board.rom"

# Recovered from the captured Ja: 197 training Ucodes.
LADDER = [116, 115, 114, 113, 112] + [
    value
    for start, top in ((0x10, 0x7F), (0x20, 0x7F), (0x30, 0x7F),
                       (0x40, 0x7F), (0x50, 0x6F), (0x50, 0x6F))
    for step in range(16)
    for value in (127 - (start + step), 127 - (top - step))
]


@unittest.skipUnless(IMAGE.exists(), "no board capture in this working tree")
class DescriptorTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.desc = vpcm.assemble(CourierRom.load(IMAGE))

    def test_the_fixed_fields_match_the_transmitted_descriptor(self) -> None:
        self.assertEqual(self.desc["n"], 197)
        self.assertEqual(self.desc["lsp"], 66)
        self.assertEqual(self.desc["ltp"], 66)
        # H1-8 is eight tens, packed two per word; REF is eight zeros.
        self.assertEqual(self.desc["h"], [0x0A0A] * 4)
        self.assertEqual(self.desc["ref"], [0] * 4)

    def test_the_training_ucodes_are_generated_not_stored(self) -> None:
        # 197 of them, and none is a table lookup: the firmware counts one
        # index up from 11 and another down from 127, storing 127 - value.
        self.assertEqual(len(self.desc["ucodes"]), 197)
        self.assertEqual(self.desc["ucodes"], LADDER)

    def test_the_ladder_repeats_its_final_block(self) -> None:
        # The last two generator calls take identical parameters, which is why
        # the captured ladder ends with the same 32 Ucodes twice.
        ucodes = self.desc["ucodes"]
        self.assertEqual(ucodes[-32:], ucodes[-64:-32])

    def test_the_ladder_is_not_a_table_in_the_flash(self) -> None:
        data = CourierRom.load(IMAGE).data
        self.assertNotIn(bytes(self.desc["ucodes"][:24]), data)
