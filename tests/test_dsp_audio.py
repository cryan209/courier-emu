from __future__ import annotations

import math
from pathlib import Path
import unittest

from courier_emu.dsp import NativeC5x
from courier_emu.xmf import XmfImage


ROOT = Path(__file__).resolve().parent.parent


class DspAudioTests(unittest.TestCase):
    def test_software_interrupt_uses_selected_vector_and_reti_returns_masked(self) -> None:
        # INTR 3 at word 0 vectors to word 6; RETI there returns to word 1.
        program = bytearray(14)
        program[0:2] = (0xBE63).to_bytes(2, "little")
        program[12:14] = (0xBE38).to_bytes(2, "little")

        class ProgramImage:
            def dsp_program_segments(self) -> tuple[tuple[int, bytes], ...]:
                return ((0, bytes(program)),)

        with NativeC5x(ProgramImage()) as core:  # type: ignore[arg-type]
            core.step(1)
            interrupted = core.state()
            core.step(1)
            returned = core.state()

        self.assertEqual(interrupted["pc"], 6)
        self.assertTrue(interrupted["flags"] & 0x80)
        self.assertEqual(returned["pc"], 1)
        self.assertTrue(returned["flags"] & 0x80)

    def test_cpl_dbmr_compares_without_modifying_the_operand(self) -> None:
        class ProgramImage:
            def dsp_program_segments(self) -> tuple[tuple[int, bytes], ...]:
                return ((0, (0x5B60).to_bytes(2, "little")),)

        with NativeC5x(ProgramImage()) as core:  # type: ignore[arg-type]
            core.host_write(0x0F, 0x1234)  # DBMR
            core.set_data(0x60, 0x1234)
            core.step(1)
            state = core.state()
            operand = core.data(0x60)

        self.assertTrue(state["flags"] & 0x04)
        self.assertEqual(operand, 0x1234)

    def test_recovered_tdm_vector_runs_downloaded_frame_isr(self) -> None:
        with NativeC5x(XmfImage.load(ROOT / "main211.xmf")) as core:
            core.configure_line_frame_interrupt(7, 0x0228)
            core.trace_data_writes()
            core.step(30_000)
            serial = core.serial_state()
            isr_writes = [
                event for event in core.data_events()
                if 0x0228 <= event["pc"] <= 0x024C
            ]

        self.assertGreater(serial["line_frame_interrupts"], 100)
        self.assertGreater(len(isr_writes), 100)
        # Low-bank port 0x006a traffic is a control slot, not PCM.
        self.assertGreater(serial["line_tx_writes"], 10)
        self.assertEqual(serial["line_tx_last_pc"], 0x8C25)

    def test_call_engine_entry_executes_block_load_and_returns_to_service(self) -> None:
        with NativeC5x(XmfImage.load(ROOT / "main211.xmf")) as core:
            core.step(10_000)
            for address, value in (
                (0x13, 0x0100),
                (0x15, 0x0000),
                (0x16, 0x0000),
                (0x19, 0x0D02),
                (0x1A, 0x0030),
                (0x1B, 0x080C),
                (0x1F, 0x0080),
            ):
                core.host_write(address, value)
            core.set_pc(0x2295)
            core.step(5_000)
            state = core.state()

        self.assertGreater(state["instructions"], 10_000)
        self.assertNotEqual(state["pc"], 0x2295)

    def test_dtmf_reaches_firmware_line_out_with_correct_pair(self) -> None:
        with NativeC5x(XmfImage.load(ROOT / "main211.xmf")) as core:
            core.configure_line_frame_interrupt(7, 0x0228)
            while core.serial_state()["line_tx_writes"] < 1:
                core.step(1)
            start = core.serial_state()["line_tx_writes"]
            core.set_dtmf_digits("1")
            while core.serial_state()["line_tx_writes"] < start + 2_400:
                core.step(4_096)
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

    def test_v8_calling_indicator_follows_dial_digits(self) -> None:
        with NativeC5x(XmfImage.load(ROOT / "main211.xmf")) as core:
            core.configure_line_frame_interrupt(7, 0x0228)
            while core.serial_state()["line_tx_writes"] < 1:
                core.step(1)
            start = core.serial_state()["line_tx_writes"]
            core.set_dtmf_digits("1")
            core.set_v8_calling(True)
            while core.serial_state()["line_tx_writes"] < start + 5_000:
                core.step(4_096)
            samples = core.line_tx_samples()[start + 3_360 : start + 4_320]

        def magnitude(frequency: int) -> float:
            return abs(
                sum(
                    sample
                    * complex(
                        math.cos(-2 * math.pi * frequency * index / 9_600),
                        math.sin(-2 * math.pi * frequency * index / 9_600),
                    )
                    for index, sample in enumerate(samples)
                )
            )

        self.assertGreater(magnitude(1_300), 20 * magnitude(1_200))
        self.assertGreater(magnitude(1_300), 20 * magnitude(1_400))

    def test_v8_answer_tone_is_ansam(self) -> None:
        with NativeC5x(XmfImage.load(ROOT / "main211.xmf")) as core:
            core.configure_line_frame_interrupt(7, 0x0228)
            while core.serial_state()["line_tx_writes"] < 1:
                core.step(1)
            start = core.serial_state()["line_tx_writes"]
            core.set_v8_answering(True)
            while core.serial_state()["line_tx_writes"] < start + 3_000:
                core.step(4_096)
            samples = core.line_tx_samples()[start + 1_200 : start + 2_160]

        def magnitude(frequency: int) -> float:
            return abs(
                sum(
                    sample
                    * complex(
                        math.cos(-2 * math.pi * frequency * index / 9_600),
                        math.sin(-2 * math.pi * frequency * index / 9_600),
                    )
                    for index, sample in enumerate(samples)
                )
            )

        self.assertGreater(magnitude(2_100), 20 * magnitude(2_000))
        self.assertGreater(magnitude(2_100), 20 * magnitude(2_200))
        self.assertGreater(max(samples), 7_000)
        self.assertLess(min(samples), -7_000)


if __name__ == "__main__":
    unittest.main()
