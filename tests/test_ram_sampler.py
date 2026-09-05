"""The tick-hooked port sampler."""
from __future__ import annotations

import unittest

from courier_emu import ram_counter as rc
from courier_emu import ram_sampler as rs


class SafetyTests(unittest.TestCase):
    def test_the_board_latches_are_refused(self) -> None:
        # Unlike the counter, this routine contains IN opcodes, so "no port
        # access" is no longer the guarantee. An allowlist replaces it.
        for port in (0x10, 0x12, 0x14):
            with self.assertRaises(ValueError):
                rs.routine(ports=(port,))

    def test_a_port_outside_a_byte_is_refused(self) -> None:
        with self.assertRaises(ValueError):
            rs.routine(ports=(0x100,))

    def test_it_still_chains_to_the_firmware_handler(self) -> None:
        self.assertEqual(
            rs.routine()[-5:],
            bytes((0xEA, rc.ORIGINAL_OFFSET & 0xFF, rc.ORIGINAL_OFFSET >> 8,
                   rc.ORIGINAL_SEGMENT & 0xFF, rc.ORIGINAL_SEGMENT >> 8)),
        )

    def test_every_register_it_touches_is_restored(self) -> None:
        code = rs.routine()
        self.assertEqual(code[:4], bytes((0x50, 0x9C, 0x1E, 0x57)))   # ax flags ds di
        self.assertEqual(code[-9:-5], bytes((0x5F, 0x1F, 0x9D, 0x58)))  # di ds flags ax


class EncodingTests(unittest.TestCase):
    def test_one_in_store_increment_per_port(self) -> None:
        one = rs.routine(ports=(0x18,))
        two = rs.routine(ports=(0x18, 0x1A))
        self.assertEqual(len(two) - len(one), 5)
        self.assertIn(bytes((0xE4, 0x1A, 0x88, 0x05, 0x47)), two)

    def test_the_wrap_compares_against_the_end_of_the_buffer(self) -> None:
        code = rs.routine(ports=(0x18,), buffer=0x4000, size=0x1000)
        self.assertIn(bytes((0x81, 0xFF, 0x00, 0x50)), code)   # cmp di, 0x5000
        self.assertIn(bytes((0xBF, 0x00, 0x40)), code)         # mov di, 0x4000

    def test_placement_ends_by_pointing_the_cursor_at_the_buffer(self) -> None:
        commands = rs.place_commands()
        self.assertEqual(commands[-1], f"ATGLK2W{rs.INDEX:X},{rs.BUFFER:04X}")
        self.assertEqual(len(commands), len(rs.routine()) + 1)


class DecodeTests(unittest.TestCase):
    def test_one_record_per_tick_in_port_order(self) -> None:
        raw = bytes((0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77, 0x88))
        records = rs.decode(raw, 8)
        self.assertEqual(len(records), 2)
        self.assertEqual(records[0], {"tick": 0, "18": 0x11, "1A": 0x22,
                                      "1C": 0x33, "1E": 0x44})
        self.assertEqual(records[1]["1E"], 0x88)

    def test_it_stops_at_the_cursor_rather_than_the_buffer_end(self) -> None:
        raw = bytes(64)
        self.assertEqual(len(rs.decode(raw, 8)), 2)

    def test_a_partial_final_tick_is_dropped(self) -> None:
        self.assertEqual(len(rs.decode(bytes(16), 6)), 1)


if __name__ == "__main__":
    unittest.main()
