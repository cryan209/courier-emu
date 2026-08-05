from __future__ import annotations

import unittest

from courier_emu.pit import (
    ACCESS_LOW_THEN_HIGH,
    CONTROL_PORT,
    COUNTER_PORTS,
    ProgrammableIntervalTimer,
    ticks_for,
)


def instructions_for_ticks(ticks: int) -> int:
    """Smallest instruction count that reaches `ticks` input ticks."""
    count = 0
    while ticks_for(count) < ticks:
        count += 1_000
    return count


class ControlWordTests(unittest.TestCase):
    def setUp(self) -> None:
        self.pit = ProgrammableIntervalTimer()

    def test_handles_only_its_own_ports(self) -> None:
        for port in COUNTER_PORTS + (CONTROL_PORT,):
            self.assertTrue(self.pit.handles(port))
        for port in (0xF020, 0xF0A1, 0x1E, 0xF044):
            self.assertFalse(self.pit.handles(port))

    def test_the_firmwares_control_words_select_mode_two(self) -> None:
        # 0x34, 0x74, 0xb4 are what the ISDN firmware writes: counters 0, 1, 2,
        # each low-then-high access, mode 2, binary.
        for value, index in ((0x34, 0), (0x74, 1), (0xB4, 2)):
            self.pit.write(CONTROL_PORT, value, 0)
            counter = self.pit.counters[index]
            self.assertEqual(counter.mode, 2)
            self.assertEqual(counter.access, ACCESS_LOW_THEN_HIGH)
            self.assertFalse(counter.bcd)

    def test_two_byte_load_takes_both_halves(self) -> None:
        self.pit.write(CONTROL_PORT, 0x34, 0)
        self.pit.write(COUNTER_PORTS[0], 0x44, 0)
        # Still unprogrammed until the high byte lands.
        self.assertFalse(self.pit.counters[0].programmed)
        self.pit.write(COUNTER_PORTS[0], 0x07, 0)
        self.assertEqual(self.pit.counters[0].initial, 0x0744)
        self.assertEqual(self.pit.counters[0].initial, 1860)

    def test_the_firmwares_divisors(self) -> None:
        for control, port, low, high, expected in (
            (0x34, COUNTER_PORTS[0], 0x44, 0x07, 1860),
            (0x74, COUNTER_PORTS[1], 0xE0, 0x22, 8928),
            (0xB4, COUNTER_PORTS[2], 0x82, 0x8B, 35714),
        ):
            self.pit.write(CONTROL_PORT, control, 0)
            self.pit.write(port, low, 0)
            self.pit.write(port, high, 0)
        self.assertEqual(
            [counter.initial for counter in self.pit.counters], [1860, 8928, 35714]
        )


class CountingTests(unittest.TestCase):
    def setUp(self) -> None:
        self.pit = ProgrammableIntervalTimer()
        self.pit.write(CONTROL_PORT, 0x34, 0)
        self.pit.write(COUNTER_PORTS[0], 0x44, 0)
        self.pit.write(COUNTER_PORTS[0], 0x07, 0)
        self.counter = self.pit.counters[0]

    def test_a_zero_count_means_the_full_range(self) -> None:
        pit = ProgrammableIntervalTimer()
        pit.write(CONTROL_PORT, 0x34, 0)
        pit.write(COUNTER_PORTS[0], 0x00, 0)
        pit.write(COUNTER_PORTS[0], 0x00, 0)
        self.assertEqual(pit.counters[0].period, 0x10000)

    def test_the_counter_counts_down_and_reloads(self) -> None:
        self.assertEqual(self.counter.count(0), 1860)
        self.assertEqual(self.counter.count(1), 1859)
        self.assertEqual(self.counter.count(1859), 1)
        # Reaching zero reloads, so the next tick is the top of the range.
        self.assertEqual(self.counter.count(1860), 1860)

    def test_wraps_accumulate(self) -> None:
        self.assertEqual(self.counter.wraps(0), 0)
        self.assertEqual(self.counter.wraps(1859), 0)
        self.assertEqual(self.counter.wraps(1860), 1)
        self.assertEqual(self.counter.wraps(1860 * 7 + 5), 7)

    def test_take_wraps_reports_each_wrap_once(self) -> None:
        self.assertEqual(self.counter.take_wraps(1860 * 3), 3)
        self.assertEqual(self.counter.take_wraps(1860 * 3), 0)
        self.assertEqual(self.counter.take_wraps(1860 * 5), 2)

    def test_reloading_restarts_the_period(self) -> None:
        self.counter.load(100, 5_000)
        self.assertEqual(self.counter.origin, 5_000)
        self.assertEqual(self.counter.count(5_000), 100)
        self.assertEqual(self.counter.wraps(5_050), 0)
        self.assertEqual(self.counter.wraps(5_100), 1)

    def test_a_counter_that_was_never_programmed_does_not_wrap(self) -> None:
        pit = ProgrammableIntervalTimer()
        self.assertEqual(pit.counters[1].wraps(10**9), 0)
        self.assertEqual(pit.counters[1].count(10**9), 0)


class ReadbackTests(unittest.TestCase):
    def setUp(self) -> None:
        self.pit = ProgrammableIntervalTimer()
        self.pit.write(CONTROL_PORT, 0x34, 0)
        self.pit.write(COUNTER_PORTS[0], 0x44, 0)
        self.pit.write(COUNTER_PORTS[0], 0x07, 0)

    def test_two_byte_read_returns_low_then_high(self) -> None:
        low = self.pit.read(COUNTER_PORTS[0], 0)
        high = self.pit.read(COUNTER_PORTS[0], 0)
        self.assertEqual(low | (high << 8), 1860)

    def test_latch_freezes_the_value(self) -> None:
        self.pit.write(CONTROL_PORT, 0x00, 0)  # latch counter 0
        latched = self.pit.counters[0].latched
        self.assertEqual(latched, 1860)
        instructions = instructions_for_ticks(500)
        low = self.pit.read(COUNTER_PORTS[0], instructions)
        high = self.pit.read(COUNTER_PORTS[0], instructions)
        # The latched value is returned even though the counter has moved on.
        self.assertEqual(low | (high << 8), 1860)

    def test_read_back_command_is_ignored(self) -> None:
        before = self.pit.counters[0].initial
        self.pit.write(CONTROL_PORT, 0xC2, 0)
        self.assertEqual(self.pit.counters[0].initial, before)

    def test_status_reports_the_programmed_rates(self) -> None:
        status = self.pit.status(0)
        counter = status["counters"][0]
        self.assertEqual(counter["initial"], 1860)
        self.assertEqual(counter["mode"], 2)
        self.assertAlmostEqual(counter["hz"], self.pit.clock_hz / 1860, places=6)
