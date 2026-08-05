from __future__ import annotations

import unittest

from courier_emu.timers import (
    CONTROL_CONTINUOUS,
    CONTROL_ENABLE,
    CONTROL_INHIBIT,
    CONTROL_INTERRUPT,
    CONTROL_MAX_COUNT,
    IMASK,
    TIMER_CONTROL,
    TIMER_VECTORS,
    InterruptController,
    Timer,
    TimerBlock,
    ticks_for,
)


ENABLE = CONTROL_ENABLE | CONTROL_INHIBIT
T2_CONTROL = 0xFF46
T2_COMPARE = 0xFF42
T2_COUNT = 0xFF40
T1_CONTROL = 0xFF3E


class TimerTests(unittest.TestCase):
    def test_enable_needs_the_inhibit_gate(self) -> None:
        # The 80186 only takes a new ENABLE when INHIBIT is set in the same
        # write, which is what lets the firmware update mode bits without
        # having to know whether the timer is running.
        timer = Timer(0)
        timer.write("control", CONTROL_ENABLE | CONTROL_CONTINUOUS)
        self.assertFalse(timer.enabled)
        self.assertTrue(timer.continuous)
        timer.write("control", ENABLE | CONTROL_CONTINUOUS)
        self.assertTrue(timer.enabled)
        timer.write("control", CONTROL_CONTINUOUS)
        self.assertTrue(timer.enabled)
        timer.write("control", CONTROL_INHIBIT | CONTROL_CONTINUOUS)
        self.assertFalse(timer.enabled)

    def test_a_zero_compare_is_a_full_range_count(self) -> None:
        # The ROM's self-test enables timer 2 with the count and the compare
        # both at zero and waits for the wrap.
        timer = Timer(2)
        timer.write("control", ENABLE)
        self.assertEqual(timer.period, 0x10000)
        timer.advance(0xFFFF)
        self.assertFalse(timer.control & CONTROL_MAX_COUNT)
        timer.advance(0x10000)
        self.assertTrue(timer.control & CONTROL_MAX_COUNT)
        self.assertEqual(timer.max_counts, 1)

    def test_a_single_shot_timer_stops_itself(self) -> None:
        timer = Timer(2)
        timer.compare_a = 100
        timer.write("control", ENABLE)
        timer.advance(250)
        self.assertEqual(timer.max_counts, 2)
        self.assertFalse(timer.enabled)
        timer.advance(10_000)
        self.assertEqual(timer.max_counts, 2)

    def test_a_continuous_timer_keeps_wrapping(self) -> None:
        timer = Timer(1)
        timer.compare_a = 100
        timer.write("control", ENABLE | CONTROL_CONTINUOUS)
        timer.advance(250)
        self.assertEqual(timer.max_counts, 2)
        self.assertEqual(timer.count, 50)
        self.assertTrue(timer.enabled)

    def test_a_disabled_timer_does_not_count(self) -> None:
        timer = Timer(0)
        timer.compare_a = 10
        timer.advance(1_000)
        self.assertEqual(timer.count, 0)
        self.assertEqual(timer.max_counts, 0)

    def test_max_count_is_cleared_by_writing_it_back(self) -> None:
        timer = Timer(2)
        timer.write("control", ENABLE | CONTROL_CONTINUOUS)
        timer.compare_a = 10
        timer.advance(100)
        self.assertTrue(timer.control & CONTROL_MAX_COUNT)
        timer.write("control", CONTROL_CONTINUOUS)
        self.assertFalse(timer.control & CONTROL_MAX_COUNT)


class InterruptControllerTests(unittest.TestCase):
    def test_the_boot_mask_covers_the_timers(self) -> None:
        # The 1998 ROM's setup table writes IMASK = 0x0079.
        controller = InterruptController()
        controller.write(IMASK, 0x0079)
        self.assertFalse(controller.enabled("timer"))
        self.assertTrue(controller.enabled("dma0"))
        self.assertFalse(controller.enabled("int1"))

    def test_a_control_register_moves_the_same_mask(self) -> None:
        # IMASK and the per-source control registers are two views of one set
        # of mask bits, so the later write wins either way.
        controller = InterruptController()
        controller.write(IMASK, 0x0079)
        controller.write(TIMER_CONTROL, 0x0000)
        self.assertTrue(controller.enabled("timer"))
        controller.write(TIMER_CONTROL, 0x000A)
        self.assertFalse(controller.enabled("timer"))

    def test_unrelated_addresses_are_left_alone(self) -> None:
        controller = InterruptController()
        self.assertFalse(controller.write(0xFF46, 0))
        self.assertEqual(controller.writes, 0)


class TimerBlockTests(unittest.TestCase):
    def block(self, **kwargs: object) -> TimerBlock:
        block = TimerBlock(**kwargs)  # type: ignore[arg-type]
        block.controller.write(IMASK, 0x0000)
        return block

    def test_the_self_test_wait_is_answered_at_the_first_poll(self) -> None:
        # 0x80444 enables timer 2 and spins on MAX COUNT. Granting the wait is
        # the same acceleration the harness applies to the delay helpers.
        block = self.block(fast=True)
        block.write(T2_CONTROL, 2, ENABLE, 0)
        block.write(T2_COMPARE, 2, 0, 0)
        block.write(T2_COUNT, 2, 0, 0)
        control = block.read(T2_CONTROL, 2, 0)
        self.assertIsNotNone(control)
        self.assertTrue(control & CONTROL_MAX_COUNT)
        self.assertEqual(block.accelerated, 1)

    def test_the_grant_moves_only_the_timer_that_was_polled(self) -> None:
        # A scratch delay on one timer must not age the timer another part of
        # the firmware is measuring an interval with.
        block = self.block(fast=True)
        block.write(T1_CONTROL, 2, ENABLE | CONTROL_CONTINUOUS, 0)
        block.write(T2_CONTROL, 2, ENABLE, 0)
        block.read(T2_CONTROL, 2, 0)
        self.assertEqual(block.timers[1].count, 0)
        self.assertEqual(block.timers[1].max_counts, 0)

    def test_reads_are_left_to_memory_when_the_block_is_not_modelled(
        self,
    ) -> None:
        block = self.block(answers_reads=False)
        block.write(T2_CONTROL, 2, ENABLE, 0)
        self.assertIsNone(block.read(T2_CONTROL, 2, 0))
        # The write is still tracked, so a run reports what was programmed.
        self.assertTrue(block.timers[2].enabled)

    def test_a_masked_timer_holds_its_request(self) -> None:
        block = TimerBlock()
        block.controller.write(IMASK, 0x0079)
        block.write(T2_CONTROL, 2, ENABLE | CONTROL_INTERRUPT | CONTROL_CONTINUOUS, 0)
        block.write(T2_COMPARE, 2, 100, 0)
        block.tick(100_000)
        self.assertIsNone(block.pending_interrupt())
        block.controller.write(TIMER_CONTROL, 0)
        self.assertEqual(block.pending_interrupt(), TIMER_VECTORS[2])

    def test_a_timer_without_the_interrupt_bit_never_requests(self) -> None:
        block = self.block()
        block.write(T2_CONTROL, 2, ENABLE | CONTROL_CONTINUOUS, 0)
        block.write(T2_COMPARE, 2, 100, 0)
        block.tick(100_000)
        self.assertIsNone(block.pending_interrupt())

    def test_the_instruction_clock_converts_to_timer_ticks(self) -> None:
        # 1,111 instructions per millisecond against a 5 MHz timer clock.
        self.assertEqual(ticks_for(1_111), 5_000)


if __name__ == "__main__":
    unittest.main()
