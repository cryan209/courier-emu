from __future__ import annotations

import math
import unittest

from courier_emu.daa import CourierDaa, DAA_FRAME_SAMPLES, DAA_SAMPLE_RATE


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


if __name__ == "__main__":
    unittest.main()
