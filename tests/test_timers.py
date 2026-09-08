from __future__ import annotations

import unittest

from courier_emu.daa import INSTRUCTIONS_PER_MS
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









class TimerBlockTests(unittest.TestCase):
    def block(self, **kwargs: object) -> TimerBlock:
        block = TimerBlock(**kwargs)  # type: ignore[arg-type]
        block.controller.write(IMASK, 0x0000)
        return block






    def test_the_instruction_clock_converts_to_timer_ticks(self) -> None:
        """Timer 0's own programming is what pins the ratio down.

        Both builds set timer 0 for 5.000 ms on their own crystal, so the
        compare they write has to come back out as 5 ms of harness time.
        main211 writes 0x7e00, and 5 ms at daa.py's 4,348 instructions per
        millisecond is 21,740 of them.
        """
        self.assertEqual(ticks_for(5 * INSTRUCTIONS_PER_MS), 0x7E00)


if __name__ == "__main__":
    unittest.main()
