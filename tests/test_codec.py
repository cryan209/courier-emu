from __future__ import annotations

import unittest

from courier_emu.codec import (
    CHIP_ID,
    EXTENDED_ID,
    GPIO_CONFIGURATION,
    LEVEL,
    LINE_CONFIGURATION_1,
    LINE_STATUS,
    POWER_CONTROL,
    POWER_DOWN_ADC1,
    POWER_DOWN_DAC1,
    READY_CODE,
    SAMPLE_RATE,
    STATUS_FRAME_DETECT,
    STATUS_LINK_ERROR,
    STATUS_RING_NEGATIVE,
    STATUS_RING_POSITIVE,
    CodecBringUp,
    SiliconDaa,
    nearest_sample_rate,
)


def brought_up(line: int = 1, rate: int = 9_600) -> SiliconDaa:
    codec = SiliconDaa(line)
    sequence = CodecBringUp(codec, rate=rate)
    assert sequence.run()
    return codec


class ResetTests(unittest.TestCase):
    def test_reset_leaves_the_line_side_powered_down(self) -> None:
        codec = SiliconDaa()

        # The whole point of the reset condition: no possibility of loading the
        # loop, so nothing the line side owns can be up.
        self.assertEqual(codec.registers[POWER_CONTROL], 0xFF00)
        self.assertFalse(codec.powered)
        self.assertFalse(codec.link_up)
        self.assertFalse(codec.ready)
        self.assertEqual(codec.readiness, 0)

    def test_any_write_to_3ch_is_a_register_reset(self) -> None:
        codec = brought_up()
        codec.write(LINE_CONFIGURATION_1, 0x0010)
        self.assertEqual(codec.registers[LINE_CONFIGURATION_1], 0x0010)

        codec.write(EXTENDED_ID, 0xBEEF)

        self.assertEqual(codec.resets, 3)  # construction, bring-up, this one
        self.assertEqual(codec.registers[LINE_CONFIGURATION_1], 0xF010)
        self.assertEqual(codec.registers[POWER_CONTROL], 0xFF00)
        self.assertFalse(codec.link_up)

    def test_the_id_and_chip_registers_read_their_straps(self) -> None:
        self.assertEqual(SiliconDaa(1).read(EXTENDED_ID), 0x4001)
        self.assertEqual(SiliconDaa(2).read(EXTENDED_ID), 0x8002)
        self.assertEqual(SiliconDaa().read(CHIP_ID), 0x0011)

    def test_a_line_two_part_reverses_its_per_line_defaults(self) -> None:
        codec = SiliconDaa(2)
        self.assertEqual(codec.registers[LEVEL[0]], 0x0000)
        self.assertEqual(codec.registers[LEVEL[1]], 0x8080)
        self.assertEqual(codec.registers[GPIO_CONFIGURATION], 0xFC00)

    def test_only_line_one_or_two_exists(self) -> None:
        with self.assertRaises(ValueError):
            SiliconDaa(0)
        with self.assertRaises(ValueError):
            SiliconDaa(3)


class SampleRateTests(unittest.TestCase):
    def test_the_courier_rate_is_supported_and_echoes_back(self) -> None:
        codec = SiliconDaa()
        codec.write(SAMPLE_RATE[0], 9_600)
        # 9600 is 0x2580 in the datasheet's table, and the register value is
        # the rate itself.
        self.assertEqual(codec.read(SAMPLE_RATE[0]), 0x2580)

    def test_an_unsupported_rate_returns_the_closest_one(self) -> None:
        self.assertEqual(nearest_sample_rate(9_600), 9_600)
        self.assertEqual(nearest_sample_rate(11_025), 10_285)
        self.assertEqual(nearest_sample_rate(44_100), 13_714)
        codec = SiliconDaa()
        codec.write(SAMPLE_RATE[0], 11_025)
        self.assertEqual(codec.read(SAMPLE_RATE[0]), 10_285)

    def test_zero_disables_the_pll(self) -> None:
        codec = SiliconDaa()
        codec.write(SAMPLE_RATE[0], 0)
        self.assertFalse(codec.pll_programmed)


class PowerUpTests(unittest.TestCase):
    def test_readiness_needs_the_pll_however_long_the_poll_runs(self) -> None:
        codec = SiliconDaa()
        codec.write(POWER_CONTROL, 0x0000)
        codec.elapse(100)

        # Step 2 comes before step 3 for a reason: with the PLL disabled there
        # is no line-side communication, so the reference never arrives.
        self.assertFalse(codec.ready)
        self.assertFalse(codec.link_up)
        self.assertEqual(codec.readiness & ~1, 0)

    def test_the_reference_comes_up_before_the_converters(self) -> None:
        codec = SiliconDaa()
        codec.write(SAMPLE_RATE[0], 9_600)
        codec.write(POWER_CONTROL, 0x0000)

        self.assertEqual(codec.readiness, 0x00)
        codec.elapse()
        self.assertEqual(codec.readiness, 0x03)  # MREF and GPIO
        codec.elapse()
        self.assertEqual(codec.readiness, 0x0F)  # plus ADC1 and DAC1
        self.assertTrue(codec.ready)

    def test_each_line_polls_for_its_own_readiness_code(self) -> None:
        self.assertEqual(brought_up(line=1).readiness, READY_CODE[1])
        self.assertEqual(brought_up(line=2).readiness, READY_CODE[2])
        self.assertEqual(READY_CODE[1], 0x0F)
        self.assertEqual(READY_CODE[2], 0x33)

    def test_a_converter_left_down_never_reaches_the_ready_code(self) -> None:
        codec = SiliconDaa()
        codec.write(SAMPLE_RATE[0], 9_600)
        codec.write(POWER_CONTROL, POWER_DOWN_DAC1)
        codec.elapse(10)

        self.assertEqual(codec.readiness, 0x07)  # ADC1, MREF, GPIO; no DAC1
        self.assertFalse(codec.ready)

    def test_powering_a_converter_back_down_restarts_settling(self) -> None:
        codec = brought_up()
        codec.write(POWER_CONTROL, POWER_DOWN_ADC1 | POWER_DOWN_DAC1)

        self.assertEqual(codec.readiness, 0x00)
        self.assertFalse(codec.link_up)

    def test_the_power_bits_read_back_above_the_readiness_byte(self) -> None:
        codec = SiliconDaa()
        codec.write(SAMPLE_RATE[0], 9_600)
        codec.write(POWER_CONTROL, POWER_DOWN_DAC1)
        codec.elapse(10)

        # Bits 15:14 are reserved and read as ones; PRD stays where it was
        # written and the readiness byte is recomputed under it.
        self.assertEqual(codec.read(POWER_CONTROL), 0xC800 | 0x07)


class BringUpTests(unittest.TestCase):
    def test_the_datasheet_procedure_runs_in_order(self) -> None:
        sequence = CodecBringUp(SiliconDaa())
        self.assertTrue(sequence.run())

        self.assertEqual(
            sequence.steps,
            [
                "register-reset",
                "sample-rate",
                "power-up",
                "ready",
                "gpio",
                "levels",
                "line-interface",
            ],
        )

    def test_step_four_actually_waits(self) -> None:
        sequence = CodecBringUp(SiliconDaa())
        sequence.service()  # reset, rate, power up, then the first poll fails

        self.assertFalse(sequence.complete)
        self.assertEqual(sequence.steps, ["register-reset", "sample-rate", "power-up"])
        self.assertGreaterEqual(sequence.polls, 1)

        self.assertTrue(sequence.run())
        # Two settling frames means the poll is entered three times: twice
        # short, once satisfied.
        self.assertEqual(sequence.polls, 3)

    def test_bring_up_leaves_a_north_american_fcc_line(self) -> None:
        codec = brought_up()

        self.assertTrue(codec.link_up)
        # DCT[1:0] = 10 is FCC mode, and the call progress mutes the reset
        # value holds at 11/11 are lifted.
        self.assertEqual(codec.read(LINE_CONFIGURATION_1), 0x0010)
        self.assertEqual(codec.registers[SAMPLE_RATE[0]], 9_600)

    def test_bring_up_at_another_rate_programs_that_rate(self) -> None:
        codec = brought_up(rate=8_000)
        self.assertEqual(codec.registers[SAMPLE_RATE[0]], 8_000)


class LineSideTests(unittest.TestCase):
    def test_a_dead_barrier_latches_a_communications_error(self) -> None:
        codec = SiliconDaa()

        codec.write(LINE_CONFIGURATION_1, 0x0010)

        # The write went nowhere and left CLE behind, which is what an
        # out-of-order bring-up looks like from the controller's side.
        self.assertEqual(codec.registers[LINE_CONFIGURATION_1], 0xF010)
        self.assertTrue(codec.line_status & STATUS_LINK_ERROR)

    def test_the_error_bit_clears_by_writing_a_zero_over_it(self) -> None:
        codec = brought_up()
        codec.write(POWER_CONTROL, POWER_DOWN_ADC1 | POWER_DOWN_DAC1)
        codec.read(LINE_STATUS)
        self.assertTrue(codec.line_status & STATUS_LINK_ERROR)

        codec.write(POWER_CONTROL, 0x0000)
        codec.elapse(2)
        # The bit stays put once the barrier is back: it is latched, not live.
        self.assertTrue(codec.line_status & STATUS_LINK_ERROR)

        codec.write(LINE_STATUS, 0x0000)
        self.assertFalse(codec.line_status & STATUS_LINK_ERROR)

    def test_a_register_reset_clears_a_latched_error(self) -> None:
        codec = SiliconDaa()
        codec.read(LINE_STATUS)
        self.assertTrue(codec.line_status & STATUS_LINK_ERROR)

        codec.reset()

        self.assertFalse(codec.line_status & STATUS_LINK_ERROR)

    def test_frame_lock_appears_only_once_the_link_is_up(self) -> None:
        codec = SiliconDaa()
        self.assertFalse(codec.line_status & STATUS_FRAME_DETECT)
        self.assertTrue(brought_up().line_status & STATUS_FRAME_DETECT)

    def test_seizing_a_connected_loop_reads_back_as_loop_current(self) -> None:
        codec = brought_up()
        codec.line_connected = True

        self.assertEqual(codec.loop_current_sense, 0)
        codec.set_hook(True)
        # 25 mA in 6 mA steps.
        self.assertEqual(codec.loop_current_sense, 4)
        self.assertEqual((codec.line_status >> 2) & 0x0F, 4)

        codec.set_hook(False)
        self.assertEqual(codec.loop_current_sense, 0)

    def test_a_disconnected_loop_draws_nothing_when_seized(self) -> None:
        codec = brought_up()
        codec.line_connected = False
        codec.set_hook(True)

        self.assertTrue(codec.off_hook)
        self.assertEqual(codec.loop_current_sense, 0)

    def test_loop_current_saturates_at_the_top_step(self) -> None:
        codec = brought_up()
        codec.line_connected = True
        codec.set_hook(True)
        codec.loop_current_ma = 200

        self.assertEqual(codec.loop_current_sense, 0x0F)

    def test_ring_half_cycles_report_separately(self) -> None:
        codec = brought_up()

        codec.set_ring(True, False)
        self.assertTrue(codec.line_status & STATUS_RING_POSITIVE)
        self.assertFalse(codec.line_status & STATUS_RING_NEGATIVE)

        codec.set_ring(False, True)
        self.assertFalse(codec.line_status & STATUS_RING_POSITIVE)
        self.assertTrue(codec.line_status & STATUS_RING_NEGATIVE)

    def test_a_powered_down_part_reports_no_line_state_at_all(self) -> None:
        codec = brought_up()
        codec.line_connected = True
        codec.set_hook(True)
        codec.set_ring(True, False)
        self.assertTrue(codec.line_status & STATUS_FRAME_DETECT)

        codec.write(POWER_CONTROL, POWER_DOWN_ADC1 | POWER_DOWN_DAC1)

        self.assertEqual(codec.line_status & ~STATUS_LINK_ERROR, 0)

    def test_status_reporting_does_not_disturb_the_part(self) -> None:
        codec = SiliconDaa()
        codec.status()
        self.assertFalse(codec.line_status & STATUS_LINK_ERROR)


if __name__ == "__main__":
    unittest.main()
