from __future__ import annotations

import unittest

from courier_emu.panel import (
    BOARD_CAPABILITY,
    DEFAULT_BOARD_ID,
    NVRAM_BOARD_IDS,
    STRAP_DRIVE_LINES,
    USABLE_BOARD_IDS,
    CourierPanel,
)


class CourierPanelTest(unittest.TestCase):
    def test_first_write_per_port_is_recorded_as_a_baseline(self) -> None:
        panel = CourierPanel()
        panel.observe_write(0x12, 0xBF, pc=0x5E2E0, instruction=100)
        self.assertEqual(len(panel.events), 1)
        self.assertTrue(panel.events[0].describe().endswith("initial"))

    def test_unchanged_writes_produce_no_event(self) -> None:
        panel = CourierPanel()
        panel.observe_write(0x12, 0xBF, pc=0x5E2E0, instruction=1)
        panel.observe_write(0x12, 0xBF, pc=0x5E2E0, instruction=2)
        self.assertEqual(len(panel.events), 1)
        self.assertEqual(panel.writes[0x12], 2)

    def test_hook_relay_is_asserted_by_driving_its_bit_low(self) -> None:
        # 0x5e2b4 and 0x5e2e9 swap the set and clear bodies for signal 0x0408,
        # so a cleared latch bit is the seized line.
        panel = CourierPanel()
        panel.observe_write(0x10, 0xF6, pc=0x5E2E0, instruction=1)
        self.assertFalse(panel.off_hook)
        panel.observe_write(0x10, 0xF2, pc=0x5E317, instruction=2)
        self.assertTrue(panel.off_hook)
        self.assertIn("+hook-relay", panel.events[-1].describe())
        panel.observe_write(0x10, 0xF6, pc=0x5E2E0, instruction=3)
        self.assertFalse(panel.off_hook)
        self.assertIn("-hook-relay", panel.events[-1].describe())

    def test_strap_sense_idles_high_with_no_line_pulled_low(self) -> None:
        # 0x5bfe8 aborts the scan unless the sense line reads high while every
        # drive line is high.
        panel = CourierPanel(board_id=0)
        panel.observe_write(0x12, 0xFF, pc=0, instruction=0)
        panel.observe_write(0x14, 0xFF, pc=0, instruction=0)
        self.assertTrue(panel.strap_sense())

    def test_strap_sense_reports_the_bit_of_the_line_pulled_low(self) -> None:
        for code in range(16):
            panel = CourierPanel(board_id=code)
            for port, mask, index in STRAP_DRIVE_LINES:
                panel.observe_write(0x12, 0xFF, pc=0, instruction=0)
                panel.observe_write(0x14, 0xFF, pc=0, instruction=0)
                panel.observe_write(port, 0xFF & ~mask, pc=0, instruction=0)
                self.assertEqual(
                    panel.strap_sense(),
                    bool((code >> index) & 1),
                    f"code {code} line {port:#04x}/{mask:#04x}",
                )

    def test_floating_straps_report_no_capability(self) -> None:
        panel = CourierPanel()
        self.assertIsNone(panel.board_capability)
        self.assertTrue(panel.strap_sense())

    def test_board_id_must_fit_the_four_strap_lines(self) -> None:
        with self.assertRaises(ValueError):
            CourierPanel(board_id=16)
        with self.assertRaises(ValueError):
            CourierPanel(board_id=-1)

    def test_default_board_id_is_usable_and_has_an_eeprom(self) -> None:
        # Capability bit 0x40 is the fatal-blinker branch at 0x5bb0f and bit
        # 0x08 is the settings-EEPROM bit every NVRAM path tests.
        self.assertIn(DEFAULT_BOARD_ID, USABLE_BOARD_IDS)
        self.assertIn(DEFAULT_BOARD_ID, NVRAM_BOARD_IDS)
        capability = BOARD_CAPABILITY[DEFAULT_BOARD_ID]
        self.assertFalse(capability & 0x40)
        self.assertTrue(capability & 0x08)

    def test_non_panel_ports_are_ignored(self) -> None:
        panel = CourierPanel()
        panel.observe_write(0x1E, 0x01, pc=0x69D43, instruction=1)
        self.assertEqual(panel.events, [])
        self.assertEqual(panel.latches, {})

    def test_status_names_every_latched_output_bit(self) -> None:
        panel = CourierPanel()
        panel.observe_write(0x14, 0xE5, pc=0x5E317, instruction=1)
        signals = panel.status()["signals"]
        self.assertFalse(signals["indicator-14-02"])
        self.assertTrue(signals["indicator-14-01"])
        self.assertTrue(signals["id-strap-drive-a"])


if __name__ == "__main__":
    unittest.main()
