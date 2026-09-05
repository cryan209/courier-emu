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

    def test_placement_packs_two_bytes_per_command(self) -> None:
        # Each command is a serial round trip, so a 354-byte routine placed a
        # byte at a time would take twice as long as it needs to.
        code = rs.routine()
        commands = rs.place_commands()
        self.assertEqual(len(commands), (len(code) + 1) // 2 + 1)
        # First command carries code[0] as the low byte and code[1] as the high.
        self.assertEqual(commands[0],
                         f"ATGLK2W{rc.ROUTINE_BASE:X},{code[1] << 8 | code[0]:04X}")

    def test_the_routine_never_grows_into_the_cursor(self) -> None:
        code = rs.routine(ports=rs.EVEN_PORTS, allow_latches=True)
        self.assertLess(rc.ROUTINE_BASE + len(code), rs.INDEX)

    def test_latches_need_an_explicit_opt_in(self) -> None:
        self.assertIn(0x10, rs.EVEN_PORTS)
        with self.assertRaises(ValueError):
            rs.routine(ports=rs.EVEN_PORTS)
        self.assertTrue(rs.routine(ports=rs.EVEN_PORTS, allow_latches=True))


class DecodeTests(unittest.TestCase):
    def test_an_unwrapped_run_stops_at_the_cursor(self) -> None:
        ring = bytes((0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77, 0x88)) + bytes(8)
        records = rs.decode(ring, rs.BUFFER + 8, wrapped=False)
        self.assertEqual(len(records), 2)
        self.assertEqual(records[0], {"tick": 0, "18": 0x11, "1A": 0x22,
                                      "1C": 0x33, "1E": 0x44})
        self.assertEqual(records[1]["1E"], 0x88)

    def test_a_wrapped_ring_is_unrolled_from_the_cursor(self) -> None:
        # Oldest sample sits at the cursor, so a cursor halfway round puts the
        # second half of the ring first.
        ring = bytes(range(16))
        records = rs.decode(ring, rs.BUFFER + 8)
        self.assertEqual(len(records), 4)
        self.assertEqual(records[0]["18"], 8)      # oldest is at the cursor
        self.assertEqual(records[-1]["1E"], 7)     # newest is just before it

    def test_the_cursor_is_taken_modulo_the_ring(self) -> None:
        ring = bytes(range(16))
        self.assertEqual(rs.decode(ring, rs.BUFFER + 8),
                         rs.decode(ring, rs.BUFFER + 8 + len(ring)))

    def test_a_partial_final_tick_is_dropped(self) -> None:
        self.assertEqual(len(rs.decode(bytes(16), rs.BUFFER + 6, wrapped=False)), 1)


if __name__ == "__main__":
    unittest.main()
