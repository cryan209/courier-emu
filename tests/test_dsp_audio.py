from __future__ import annotations

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

    def test_codec_peak_and_v8_diagnostics_cross_the_native_api(self) -> None:
        with NativeC5x(XmfImage.load(ROOT / "main211.xmf")) as core:
            core.queue_codec_rx([-32_768, 12_345])
            state = core.serial_state()

        self.assertEqual(state["codec_rx_peak"], 32_768)
        self.assertEqual(state["v8_rx_state"], 0)
        self.assertEqual(state["v8_rx_peak"], 0)
        self.assertEqual(state["negotiation_loop_entries"], 0)
        self.assertEqual(state["negotiation_loop_pc"], 0)

