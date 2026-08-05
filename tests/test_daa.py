from __future__ import annotations

import math
import unittest

from courier_emu.daa import (
    CourierDaa,
    DAA_FRAME_SAMPLES,
    DAA_SAMPLE_RATE,
    INSTRUCTIONS_PER_MS,
    RingSource,
)


class CourierDaaTests(unittest.TestCase):
    def test_dial_tone_qualifies_after_five_frames(self) -> None:
        daa = CourierDaa("dial-tone")
        daa.seize()
        samples = daa.render(5 * DAA_FRAME_SAMPLES)

        self.assertEqual(len(samples), 4_800)
        self.assertTrue(daa.dial_tone_present)
        self.assertTrue(daa.dial_tone_qualified)
        self.assertTrue(any(samples))

        def magnitude(frequency: int) -> float:
            real = sum(
                sample * math.cos(2 * math.pi * frequency * index / DAA_SAMPLE_RATE)
                for index, sample in enumerate(samples)
            )
            imag = sum(
                sample * math.sin(2 * math.pi * frequency * index / DAA_SAMPLE_RATE)
                for index, sample in enumerate(samples)
            )
            return math.hypot(real, imag)

        candidates = {frequency: magnitude(frequency) for frequency in (300, 350, 400, 440, 480)}
        peaks = sorted(candidates, key=candidates.get, reverse=True)[:2]  # type: ignore[arg-type]
        self.assertEqual(set(peaks), {350, 440})

    def test_quiet_line_stays_silent_and_unqualified(self) -> None:
        daa = CourierDaa("quiet")
        daa.seize()
        self.assertEqual(daa.render(DAA_FRAME_SAMPLES), [0] * DAA_FRAME_SAMPLES)
        self.assertFalse(daa.dial_tone_present)
        self.assertFalse(daa.dial_tone_qualified)

    def test_release_returns_on_hook(self) -> None:
        daa = CourierDaa("dial-tone")
        daa.seize()
        daa.render(5 * DAA_FRAME_SAMPLES)
        daa.release()
        self.assertFalse(daa.off_hook)
        self.assertEqual(daa.operation, "idle")
        self.assertFalse(daa.dial_tone_qualified)

    def test_dialing_removes_central_office_dial_tone(self) -> None:
        daa = CourierDaa("dial-tone")
        daa.seize()
        daa.render(5 * DAA_FRAME_SAMPLES)
        daa.begin_dialing()
        self.assertEqual(daa.operation, "dialing")
        self.assertFalse(daa.dial_tone_present)
        self.assertEqual(daa.render(DAA_FRAME_SAMPLES), [0] * DAA_FRAME_SAMPLES)

    def test_sip_progress_updates_off_hook_operation(self) -> None:
        daa = CourierDaa("dial-tone")
        daa.seize()
        for state in ("trying", "ringing", "connected"):
            daa.set_call_progress(state)
            self.assertEqual(daa.operation, state)


class AnsweringSeizureTests(unittest.TestCase):
    def test_a_connected_line_qualifies_an_answering_seizure(self) -> None:
        # ATA reaches the same 0x5dbe7 detector wait as ATD, and there is no
        # dial tone to find on an answering seizure.
        daa = CourierDaa("quiet")
        daa.seize("answer")
        self.assertTrue(daa.detector_present)
        self.assertFalse(daa.detector_qualified)
        self.assertEqual(daa.render(5 * DAA_FRAME_SAMPLES), [0] * 4_800)
        self.assertTrue(daa.detector_qualified)
        self.assertFalse(daa.dial_tone_present)
        self.assertFalse(daa.dial_tone_qualified)

    def test_a_disconnected_line_never_qualifies(self) -> None:
        daa = CourierDaa()
        daa.seize("answer")
        daa.render(10 * DAA_FRAME_SAMPLES)
        self.assertFalse(daa.detector_present)
        self.assertFalse(daa.detector_qualified)

    def test_an_originating_seizure_still_needs_dial_tone(self) -> None:
        daa = CourierDaa("quiet")
        daa.seize()
        daa.render(10 * DAA_FRAME_SAMPLES)
        self.assertFalse(daa.detector_present)
        self.assertFalse(daa.detector_qualified)


class RingSourceTests(unittest.TestCase):
    def test_the_line_is_quiet_before_the_first_burst(self) -> None:
        ring = RingSource(start_ms=1_000)
        self.assertFalse(ring.present(0))
        self.assertFalse(ring.present(999 * INSTRUCTIONS_PER_MS))
        self.assertTrue(ring.present(1_000 * INSTRUCTIONS_PER_MS))

    def test_the_cadence_alternates_on_and_off(self) -> None:
        ring = RingSource(on_ms=2_000, off_ms=4_000, start_ms=0)
        at = lambda ms: ring.present(ms * INSTRUCTIONS_PER_MS)  # noqa: E731
        self.assertTrue(at(0))
        self.assertTrue(at(1_999))
        self.assertFalse(at(2_000))
        self.assertFalse(at(5_999))
        self.assertTrue(at(6_000))
        self.assertFalse(at(8_000))

    def test_a_burst_limit_stops_the_cadence(self) -> None:
        ring = RingSource(on_ms=2_000, off_ms=4_000, start_ms=0, count=2)
        self.assertTrue(ring.present(0))
        self.assertTrue(ring.present(6_000 * INSTRUCTIONS_PER_MS))
        self.assertFalse(ring.present(12_000 * INSTRUCTIONS_PER_MS))
        self.assertEqual(ring.bursts, 2)

    def test_delivered_bursts_are_counted_once_each(self) -> None:
        ring = RingSource(on_ms=2_000, off_ms=4_000, start_ms=0)
        for ms in range(0, 7_000, 100):
            ring.present(ms * INSTRUCTIONS_PER_MS)
        self.assertEqual(ring.bursts, 2)
        self.assertEqual(ring.status()["bursts_delivered"], 2)

    def test_a_burst_is_long_enough_for_the_firmware_to_qualify(self) -> None:
        # The answer machine at 0x70fe0 accepts a burst once its 10 ms tick
        # counter reaches the 180 ticks the country table holds at [0x1f5c].
        ring = RingSource()
        self.assertGreaterEqual(ring.on_ms, 180 * 10)

    def test_a_zero_length_cadence_is_rejected(self) -> None:
        with self.assertRaises(ValueError):
            RingSource(on_ms=0)
        with self.assertRaises(ValueError):
            RingSource(off_ms=0)
        with self.assertRaises(ValueError):
            RingSource(count=-1)


if __name__ == "__main__":
    unittest.main()
