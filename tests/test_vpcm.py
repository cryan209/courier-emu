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


class UcodeLevelTests(unittest.TestCase):
    def test_the_laws_differ_by_their_bias(self) -> None:
        # Ucode 100 is chord 6, step 4. A-law has no bias; mu-law carries 132.
        self.assertEqual(vpcm.ucode_level(100, law='a'), 10496)
        self.assertEqual(vpcm.ucode_level(100, law='mu'), 10364)
        # Each law reaches its own full scale.
        self.assertEqual(vpcm.ucode_level(127, law='a'), 32256)
        self.assertEqual(vpcm.ucode_level(127, law='mu'), 32124)

    def test_levels_rise_with_the_ucode_inside_a_chord(self) -> None:
        for law in ('a', 'mu'):
            for chord in range(8):
                levels = [vpcm.ucode_level((chord << 4) | s, law=law) for s in range(16)]
                self.assertEqual(levels, sorted(levels))
                self.assertEqual(len(set(levels)), 16)


DIL = ROOT / "artifacts/dil-alaw-01/dil-requested-alaw.g711"
SP = "101010101101001010110100101011010010110101001011010100101101010010"
TP = "000000001000010000100001000010000100010000100001000010000100001000"


@unittest.skipUnless(IMAGE.exists() and DIL.exists(), "no board capture in this working tree")
class DilAgainstTheLadderTests(unittest.TestCase):
    """A DIL a digital modem sent in answer to this Courier's own Ja.

    The firmware generates the ladder; the far end sends levels for it. These
    check the two against each other, which is the comparison the datapump's
    own matcher makes.
    """

    @classmethod
    def setUpClass(cls) -> None:
        raw = DIL.read_bytes()
        cls.linear = [vpcm.alaw_decode(b) for b in raw]
        cls.segments = [cls.linear[i * 66:(i + 1) * 66] for i in range(197)]
        cls.ucodes = vpcm.assemble(CourierRom.load(IMAGE))["ucodes"]

    def test_the_capture_is_one_cycle_of_the_requested_shape(self) -> None:
        # N segments of LSP symbols, all three straight out of the descriptor.
        self.assertEqual(len(self.linear), 197 * 66)

    def test_every_sign_follows_the_descriptor(self) -> None:
        wrong = [(s, i) for s in range(197) for i in range(66)
                 if (self.segments[s][i] > 0) != (SP[i] == '1')]
        self.assertEqual(wrong, [])

    def test_the_reference_slots_carry_the_reference_level(self) -> None:
        for s in range(197):
            for i, flag in enumerate(TP):
                if flag == '0':
                    self.assertEqual(abs(self.segments[s][i]), vpcm.ucode_level(0))

    def test_each_segment_carries_the_level_of_its_generated_ucode(self) -> None:
        training = [i for i, flag in enumerate(TP) if flag == '1']
        for s, ucode in enumerate(self.ucodes):
            levels = {abs(self.segments[s][i]) for i in training}
            self.assertEqual(len(levels), 1, f'segment {s} is not one level')
            self.assertEqual(levels.pop(), vpcm.ucode_level(ucode, law='a'),
                             f'segment {s} does not carry Ucode {ucode}')


IMPAIRED = ROOT / "artifacts/dil-ulaw-impaired-01/dil-received-ulaw.g711"


@unittest.skipUnless(IMAGE.exists() and DIL.exists() and IMPAIRED.exists(),
                     "no captures in this working tree")
class ScoringTests(unittest.TestCase):
    """Scoring a DIL against the ladder, clean and impaired."""

    @classmethod
    def setUpClass(cls) -> None:
        cls.desc = vpcm.assemble(CourierRom.load(IMAGE))

    def test_a_clean_dil_scores_as_untouched(self) -> None:
        r = vpcm.score_dil(DIL.read_bytes(), self.desc, law='a')
        self.assertEqual(r['signs_wrong'], 0)
        self.assertEqual(r['exact'], r['training_symbols'])
        self.assertEqual(r['gain'], 1.0)
        self.assertEqual(r['reference_non_zero'], 0)

    def test_the_impaired_dil_shows_a_six_db_pad(self) -> None:
        r = vpcm.score_dil(IMPAIRED.read_bytes(), self.desc, law='mu')
        # Amplitude only: every sign still follows SP.
        self.assertEqual(r['signs_wrong'], 0)
        self.assertAlmostEqual(r['gain_db'], -6.0, delta=0.2)

    def test_the_impaired_dil_also_carries_additive_noise(self) -> None:
        # A pad scales, so it leaves the reference slots at their own level.
        # Anything else in them had to be added.
        r = vpcm.score_dil(IMPAIRED.read_bytes(), self.desc, law='mu')
        self.assertGreater(r['reference_non_zero'], r['reference_symbols'] // 4)
