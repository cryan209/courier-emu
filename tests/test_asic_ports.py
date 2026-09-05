"""The measured 20.16 MHz ASIC port map, and the probe that classifies it."""
from __future__ import annotations

import unittest

from courier_emu import asic_ports
from courier_emu.asic_probe import classify


class AsicPortsTests(unittest.TestCase):
    def test_only_even_ports_are_decoded(self) -> None:
        # Every odd port in the decoded range read 0x00 on the board: the ASIC
        # presents 16-bit registers and the monitor reads a byte.
        for port in range(1, asic_ports.DECODE_LIMIT, 2):
            self.assertEqual(asic_ports.idle_value(port), 0x00)
        self.assertTrue(all(port % 2 == 0 for port in asic_ports.IDLE))

    def test_the_default_is_zero_not_all_ones(self) -> None:
        # This is the discrepancy with the harness, which returns 0xff for any
        # port it does not model.
        self.assertEqual(asic_ports.DEFAULT, 0x00)
        self.assertEqual(asic_ports.idle_value(0x20), 0x00)

    def test_above_the_decode_limit_the_bus_returns_the_address(self) -> None:
        for port in range(asic_ports.DECODE_LIMIT, 0x100, 2):
            self.assertEqual(asic_ports.idle_value(port), port)
        for port in range(asic_ports.DECODE_LIMIT + 1, 0x100, 2):
            self.assertEqual(asic_ports.idle_value(port), 0x00)

    def test_a_word_read_takes_the_odd_port_as_its_high_byte(self) -> None:
        self.assertEqual(asic_ports.idle_value(0x64, 2), 0x0078)
        self.assertEqual(asic_ports.idle_value(0x0A, 2), 0x00F7)

    def test_seed_covers_the_decoded_space_only(self) -> None:
        seed = asic_ports.seed()
        self.assertEqual(len(seed), asic_ports.DECODE_LIMIT)
        self.assertEqual(seed[0x7E], 0xB3)
        self.assertNotIn(0x80, seed)

    def test_the_ports_that_move_are_not_listed_as_stable(self) -> None:
        for port in asic_ports.UNDER_LOAD:
            self.assertNotIn(port, asic_ports.STABLE_ACROSS_CAPTURES)


class ClassifyTests(unittest.TestCase):
    """The probe's classifier, which is what turns passes into the map."""

    def test_a_port_reading_its_own_address_is_the_undriven_bus(self) -> None:
        states = {"idle": [{0x90: 0x90}, {0x90: 0x90}]}
        self.assertEqual(classify(states, [0x90])[0x90]["kind"], "alias")

    def test_moving_within_one_state_is_volatile(self) -> None:
        states = {"idle": [{0x18: 0xC0}, {0x18: 0xC6}]}
        self.assertEqual(classify(states, [0x18])[0x18]["kind"], "volatile")

    def test_steady_within_each_state_but_differing_between_them(self) -> None:
        states = {"idle": [{0x1A: 0xFF}, {0x1A: 0xFF}],
                  "loopback": [{0x1A: 0xC0}, {0x1A: 0xC0}]}
        entry = classify(states, [0x1A])[0x1A]
        self.assertEqual(entry["kind"], "state")
        # 0xff ^ 0xc0 = 0x3f, the bits that were seen to move.
        self.assertEqual(entry["bits_seen_changing"], "3F")

    def test_a_port_that_never_answered_is_unreadable(self) -> None:
        states = {"idle": [{0x33: None}, {0x33: None}]}
        self.assertEqual(classify(states, [0x33])[0x33]["kind"], "unreadable")


if __name__ == "__main__":
    unittest.main()
