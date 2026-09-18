"""The ASIC register table, and the bridge constants derived from it.

These pin the two numberings apart. The CPU and the DSP reach this chip
through separate decoders and collide on 0x5e, where the CPU means the high
byte of the word and the DSP means the tag; publishing a CPU-side value into
the DSP's register space once overwrote a tag the part was waiting to have
collected.
"""
import unittest

from courier_emu import asic
from courier_emu.bridge import (
    CourierDspBridge, DSP_RUNTIME_PORTS, DSP_STREAM_PORT, DSP_TAG_PORT,
    DSP_WORD_PORT, HOST_STATUS_CELL, HOST_TAG_CELL, HOST_WORD_CELL,
)


class AsicRegisterTable(unittest.TestCase):
    def test_the_two_spaces_collide_on_5e(self):
        """CPU 0x5e is the word's high byte; DSP 0x5e is the tag."""
        self.assertEqual(asic.cpu_ports("word"), (0x5C, 0x5E))
        self.assertEqual(asic.dsp_register("tag"), 0x5E)
        self.assertEqual(asic.dsp_register_for_cpu_port(0x5E), (0x5F, 1))

    def test_cpu_side_registers_have_no_dsp_address(self):
        """The status latch is an ASIC latch, not a C50 register."""
        with self.assertRaises(KeyError):
            asic.dsp_register("status-latch")
        for name in ("panel-latch", "hook", "indicators-mr", "indicators-cd"):
            with self.assertRaises(KeyError):
                asic.dsp_register(name)

    def test_no_cpu_port_crosses_to_a_register_it_does_not_own(self):
        for register in asic.REGISTERS:
            if register.dsp is None:
                continue
            for half, port in enumerate(register.cpu):
                self.assertEqual(
                    asic.dsp_register_for_cpu_port(port), (register.dsp, half))

    def test_the_bridge_mirror_is_the_tag_and_word_only(self):
        """Not the status: its acknowledgement sets bits, not the latch."""
        self.assertEqual(CourierDspBridge.MIRROR, {
            0x58: (0x5E, 0), 0x5A: (0x5E, 1),
            0x5C: (0x5F, 0), 0x5E: (0x5F, 1),
        })

    def test_the_bridge_constants_are_the_measured_addresses(self):
        self.assertEqual(
            (DSP_TAG_PORT, DSP_WORD_PORT, DSP_STREAM_PORT), (0x5E, 0x5F, 0x60))
        self.assertEqual(
            (HOST_STATUS_CELL, HOST_TAG_CELL, HOST_WORD_CELL), (0x57, 0x5E, 0x5F))
        self.assertEqual(DSP_RUNTIME_PORTS, (0x58, 0x5A, 0x5C, 0x5E))


if __name__ == "__main__":
    unittest.main()
