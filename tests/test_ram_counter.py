"""The tick-hooked counter routine, and the properties that make it safe."""
from __future__ import annotations

import unittest

from courier_emu import ram_counter as rc


class RoutineTests(unittest.TestCase):
    def test_it_chains_to_the_firmware_handler(self) -> None:
        # The last five bytes must be a far jump to the vector's original
        # target: that is what performs the real work and acknowledges the
        # interrupt controller. Without it the tick stops.
        code = rc.routine()
        self.assertEqual(
            code[-5:],
            bytes((0xEA, rc.ORIGINAL_OFFSET & 0xFF, rc.ORIGINAL_OFFSET >> 8,
                   rc.ORIGINAL_SEGMENT & 0xFF, rc.ORIGINAL_SEGMENT >> 8)),
        )

    def test_every_register_it_touches_is_restored(self) -> None:
        code = rc.routine()
        # push ax, pushf, push ds ... pop ds, popf, pop ax, in that order.
        self.assertEqual(code[:3], bytes((0x50, 0x9C, 0x1E)))
        self.assertEqual(code[11:14], bytes((0x1F, 0x9D, 0x58)))

    def test_it_sets_its_own_data_segment(self) -> None:
        # xor ax,ax ; mov ds,ax - it does not inherit DS from whatever the
        # interrupt landed in.
        self.assertEqual(code_slice := rc.routine()[3:7], bytes((0x31, 0xC0, 0x8E, 0xD8)))
        self.assertEqual(len(code_slice), 4)

    def test_the_counter_address_is_the_one_it_increments(self) -> None:
        code = rc.routine(0x1234)
        self.assertEqual(code[7:11], bytes((0xFF, 0x06, 0x34, 0x12)))

    def test_it_touches_no_latch_port_and_no_flash(self) -> None:
        # No IN/OUT of any kind: 0xe4-0xe7 are the immediate forms and
        # 0xec-0xef the DX forms. The hook relay and NVRAM strobe are ports, so
        # a routine with no port access cannot reach them.
        self.assertFalse(set(rc.routine()) & {0xE4, 0xE5, 0xE6, 0xE7, 0xEC, 0xED, 0xEE, 0xEF})


class HookTests(unittest.TestCase):
    def test_arming_changes_only_the_segment_word(self) -> None:
        # The whole point: one atomic word write, so the board is never left
        # holding a half-updated far pointer.
        self.assertEqual(rc.arm_command(), "ATGLK2W3E,0300")
        self.assertEqual(rc.disarm_command(), "ATGLK2W3E,8000")

    def test_the_offset_word_is_never_written(self) -> None:
        cells = {rc.VECTOR_OFFSET_CELL, rc.VECTOR_SEGMENT_CELL}
        self.assertEqual(cells, {0x3C, 0x3E})
        for command in rc.place_commands() + [rc.arm_command(), rc.disarm_command()]:
            address = int(command[len("ATGLK2W"):].split(",")[0], 16)
            self.assertNotEqual(address, rc.VECTOR_OFFSET_CELL)

    def test_the_hook_segment_keeps_the_original_offset_valid(self) -> None:
        # This is what makes the single write legal: the routine has to live
        # exactly where the unchanged offset lands under the new segment.
        self.assertEqual((rc.HOOK_SEGMENT << 4) + rc.ORIGINAL_OFFSET, rc.ROUTINE_BASE)

    def test_placement_writes_bytes_and_zeroes_the_counter(self) -> None:
        commands = rc.place_commands()
        code = rc.routine()
        self.assertEqual(len(commands), len(code) + 1)
        self.assertEqual(commands[0], f"ATGLK2W{rc.ROUTINE_BASE:X},50")
        self.assertEqual(commands[-1], f"ATGLK2W{rc.COUNTER:X},0000")

    def test_widths_follow_the_monitor_digit_rule(self) -> None:
        # Two digits store a byte, four store a word; the value never decides.
        self.assertEqual(rc.write_byte(0x3A77, 0x0F), "ATGLK2W3A77,0F")
        self.assertEqual(rc.write_word(0x3A77, 0x0F), "ATGLK2W3A77,000F")

    def test_the_routine_does_not_reach_the_command_buffer(self) -> None:
        # 0x0a83 is the AT command buffer. Landing on it would overwrite the
        # monitor's own input, which is why the routine is not at 0x0a77.
        self.assertGreater(rc.ROUTINE_BASE, 0x0A83 + 0x40)


if __name__ == "__main__":
    unittest.main()
