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







class ClassifyTests(unittest.TestCase):
    """The probe's classifier, which is what turns passes into the map."""

    def test_a_port_reading_its_own_address_is_the_undriven_bus(self) -> None:
        states = {"idle": [{0x90: 0x90}, {0x90: 0x90}]}
        self.assertEqual(classify(states, [0x90])[0x90]["kind"], "alias")





if __name__ == "__main__":
    unittest.main()
