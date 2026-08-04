from __future__ import annotations

import math
from pathlib import Path
import unittest

from courier_emu.dsp import NativeC5x
from courier_emu.xmf import XmfImage


ROOT = Path(__file__).resolve().parent.parent


class DspAudioTests(unittest.TestCase):
    def test_dtmf_reaches_firmware_line_out_with_correct_pair(self) -> None:
        with NativeC5x(XmfImage.load(ROOT / "main211.xmf")) as core:
            while core.serial_state()["line_tx_writes"] < 1:
                core.step(1)
            start = core.serial_state()["line_tx_writes"]
            core.set_dtmf_digits("1")
            while core.serial_state()["line_tx_writes"] < start + 2_400:
                core.step(128)
            samples = core.line_tx_samples()[start : start + 2_400]

        self.assertTrue(all(sample == 0 for sample in samples[:960]))
        tone = samples[960:1_920]
        self.assertGreater(sum(sample != 0 for sample in tone), 900)

        def magnitude(frequency: int) -> float:
            real = sum(
                sample * math.cos(2 * math.pi * frequency * index / 9_600)
                for index, sample in enumerate(tone)
            )
            imag = sum(
                sample * math.sin(2 * math.pi * frequency * index / 9_600)
                for index, sample in enumerate(tone)
            )
            return math.hypot(real, imag)

        low = {frequency: magnitude(frequency) for frequency in (697, 770, 852, 941)}
        high = {frequency: magnitude(frequency) for frequency in (1209, 1336, 1477, 1633)}
        self.assertEqual(max(low, key=low.get), 697)  # type: ignore[arg-type]
        self.assertEqual(max(high, key=high.get), 1209)  # type: ignore[arg-type]


if __name__ == "__main__":
    unittest.main()
