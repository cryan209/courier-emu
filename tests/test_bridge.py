from __future__ import annotations

from pathlib import Path
from unittest.mock import patch
import unittest

from courier_emu.bridge import DAA_IDENTITY_TAG, CourierDspBridge
from courier_emu.codec import DAA_REVISION, CodecBringUp, SiliconDaa
from courier_emu.daa import CourierDaa, RingSource
from courier_emu.line import LINE_FRAME_INSTRUCTIONS
from courier_emu.xmf import DSP_BOOT_SIZE, XmfImage


ROOT = Path(__file__).resolve().parent.parent


class _Image:
    def __init__(self) -> None:
        self.program = bytes(index & 0xFF for index in range(DSP_BOOT_SIZE))

    def dsp_program_segments(self) -> list[tuple[int, bytes]]:
        return [(0, self.program)]


class _Core:
    def __init__(self) -> None:
        self.queued: list[int] = []
        self.host_writes: list[tuple[int, int]] = []
        self.dtmf = ""
        self.v8_calling = False
        self.v8_answering = False
        self.pc: int | None = None

    def close(self) -> None:
        pass

    def set_io(self, _port: int, _value: int) -> None:
        pass

    def io(self, _port: int) -> int:
        return 0xFFFF

    def step(self, _count: int) -> None:
        pass

    def set_pc(self, address: int) -> None:
        self.pc = address

    def host_write(self, address: int, value: int) -> None:
        self.host_writes.append((address, value))

    def state(self) -> dict[str, int | bool]:
        return {}

    def serial_state(self) -> dict[str, int]:
        return {}

    def queue_serial_rx(self, samples: list[int]) -> None:
        self.queued.extend(samples)

    def set_dtmf_digits(self, digits: str) -> None:
        self.dtmf = digits

    def set_v8_calling(self, enabled: bool) -> None:
        self.v8_calling = enabled

    def set_v8_answering(self, enabled: bool) -> None:
        self.v8_answering = enabled

    def line_tx_samples(self, _start: int = 0) -> list[int]:
        return []


class _ConnectedSip:
    state = "connected"

    def poll(self) -> None:
        pass

    def receive_audio(self) -> list[int]:
        return []

    def send_audio(self, _samples: list[int]) -> None:
        pass

    def close(self) -> None:
        pass

    def status(self) -> dict[str, str]:
        return {"state": self.state}


class BridgeTests(unittest.TestCase):
    def test_deferred_call_overlay_enters_on_the_asic_service_slot(self) -> None:
        daa = CourierDaa("quiet")
        daa.seize("answer")
        bridge = CourierDspBridge(
            XmfImage.load(ROOT / "main211.xmf"), batch=1, daa=daa
        )
        try:
            bridge.active = True
            bridge.arm_dial_tones(b"ATA")
            bridge.clock_x86()
            bridge.core.step(100_000)
            serial = bridge.core.serial_state()
        finally:
            bridge.close()

        self.assertEqual(serial["imr"] & 0x80, 0x80)
        self.assertGreater(serial["line_frame_interrupts"], 20)
        self.assertGreater(serial["line_tx_nonzero"], 50)
        self.assertEqual(serial["line_tx_last_pc"], 0x0238)

    def test_supplied_audio_reaches_the_call_overlay_after_activation(self) -> None:
        daa = CourierDaa("quiet")
        daa.seize("answer")
        bridge = CourierDspBridge(
            XmfImage.load(ROOT / "main211.xmf"),
            batch=1,
            daa=daa,
            rx_samples=[1200, -1200] * 960,
        )
        try:
            bridge.active = True
            bridge.arm_dial_tones(b"ATA")
            bridge.clock_x86()
            bridge.core.step(100_000)
            serial = bridge.core.serial_state()
        finally:
            bridge.close()

        self.assertGreater(serial["codec_rx_consumed"], 0)

    @staticmethod
    def _bootstrap(bridge: CourierDspBridge, program: bytes) -> None:
        for offset in range(0, len(program), 8):
            for lane, value in enumerate(program[offset : offset + 8]):
                bridge.write(0x40 + lane * 2, 1, value)
            bridge.write(0x1E, 1, 1)

    def test_program_signature_starts_a_second_bootstrap(self) -> None:
        image = _Image()
        cores: list[_Core] = []

        def make_core(_image: object) -> _Core:
            core = _Core()
            cores.append(core)
            return core

        with patch("courier_emu.bridge.NativeC5x", side_effect=make_core):
            bridge = CourierDspBridge(image, rx_samples=[0x1234, -2])  # type: ignore[arg-type]
            bridge.arm_dial_tones(b"X0DT12#")
            self._bootstrap(bridge, image.program)
            self._bootstrap(bridge, image.program)
            bridge.write(0x1E, 1, 1)

        status = bridge.status()
        self.assertTrue(status.active)
        self.assertTrue(status.bootstrap_match)
        self.assertEqual(status.bootstraps, 2)
        self.assertEqual(status.transfer_commands, 2 * ((DSP_BOOT_SIZE + 7) // 8))
        self.assertEqual(status.mailbox_commands, 1)
        self.assertEqual(len(cores), 2)
        self.assertEqual(cores[-1].queued, [0x1234, -2])
        self.assertEqual(cores[-1].dtmf, "12#")

    def test_daa_qualification_starts_dialing_on_active_core(self) -> None:
        image = _Image()
        core = _Core()
        daa = CourierDaa("dial-tone")
        with patch("courier_emu.bridge.NativeC5x", return_value=core):
            bridge = CourierDspBridge(image, daa=daa)  # type: ignore[arg-type]
            bridge.arm_dial_tones(b"DT1")
            self._bootstrap(bridge, image.program)
            bridge.begin_dialing()

        self.assertEqual(daa.operation, "dialing")
        self.assertEqual(core.dtmf, "1")

    def test_second_bootstrap_enters_originate_dialing_phase(self) -> None:
        image = _Image()
        cores: list[_Core] = []

        def make_core(_image: object) -> _Core:
            core = _Core()
            cores.append(core)
            return core

        daa = CourierDaa("dial-tone")
        with patch("courier_emu.bridge.NativeC5x", side_effect=make_core):
            bridge = CourierDspBridge(image, daa=daa)  # type: ignore[arg-type]
            bridge.arm_dial_tones(b"DT12")
            daa.render(4_800)
            self._bootstrap(bridge, image.program)
            self._bootstrap(bridge, image.program)

        self.assertEqual(daa.operation, "dialing")
        self.assertEqual(cores[-1].dtmf, "12")
        self.assertEqual(bridge.read(0x1C, 1), 3)
        self.assertEqual(bridge.read(0x58, 1), 0x02)
        self.assertEqual(bridge.read(0x5A, 1), 0x00)

    def test_quiet_daa_does_not_dial_after_failure_bootstrap(self) -> None:
        image = _Image()
        cores: list[_Core] = []

        def make_core(_image: object) -> _Core:
            core = _Core()
            cores.append(core)
            return core

        with patch("courier_emu.bridge.NativeC5x", side_effect=make_core):
            bridge = CourierDspBridge(  # type: ignore[arg-type]
                image, daa=CourierDaa("quiet")
            )
            bridge.arm_dial_tones(b"DT1")
            self._bootstrap(bridge, image.program)
            self._bootstrap(bridge, image.program)

        self.assertEqual(cores[-1].dtmf, "")

    def test_runtime_mailbox_records_words_and_reset_floats_bus(self) -> None:
        image = _Image()
        core = _Core()
        with patch("courier_emu.bridge.NativeC5x", return_value=core):
            bridge = CourierDspBridge(image)  # type: ignore[arg-type]
            self._bootstrap(bridge, image.program)
            for port, value in ((0x58, 0x84), (0x5A, 0x00), (0x5C, 0x68), (0x5E, 0x14)):
                bridge.write(port, 1, value)

        self.assertEqual(bridge.read(0x1C, 1), 0)
        bridge.write(0x1C, 1, 0)
        self.assertEqual(bridge.read(0x1C, 1), 0)
        bridge.float_runtime_bus()
        self.assertEqual(bridge.read(0x1C, 1), 0xFF)
        self.assertEqual(bridge.status().runtime_messages, ["0084:1468"])

    def test_asic_commit_edge_reports_both_coprocessors_ready_once(self) -> None:
        image = _Image()
        core = _Core()
        with patch("courier_emu.bridge.NativeC5x", return_value=core):
            bridge = CourierDspBridge(image)  # type: ignore[arg-type]
            self._bootstrap(bridge, image.program)
            for data in (0x0000, 0x8000, 0x0000, 0x8000):
                for port, value in (
                    (0x58, 0x1F),
                    (0x5A, 0x00),
                    (0x5C, data & 0xFF),
                    (0x5E, data >> 8),
                ):
                    bridge.write(port, 1, value)

        self.assertEqual(
            list(bridge._runtime_inbound),
            [(0x0002, 0x0000), (0x0003, 0x0000)],
        )
        self.assertTrue(bridge.status().asic["call_engine_started"])
        self.assertEqual(bridge.status().asic["commit_edges"], 2)
        self.assertEqual(core.host_writes, [])

    def test_connected_sip_queues_firmware_call_up_event_once(self) -> None:
        image = _Image()
        cores: list[_Core] = []

        def make_core(_image: object) -> _Core:
            core = _Core()
            cores.append(core)
            return core

        with patch("courier_emu.bridge.NativeC5x", side_effect=make_core):
            bridge = CourierDspBridge(  # type: ignore[arg-type]
                image, batch=1, sip=_ConnectedSip()  # type: ignore[arg-type]
            )
            self._bootstrap(bridge, image.program)
            self._bootstrap(bridge, image.program)
            bridge.clock_x86()

        self.assertEqual(
            list(bridge._runtime_inbound),
            [
                (0x0002, 0x0000),
                (0x0003, 0x0000),
                (0x0009, 0x0000),
                (0x004D, 0x0001),
            ],
        )
        bridge.clock_x86()
        self.assertEqual(len(bridge._runtime_inbound), 4)


class CodecTests(unittest.TestCase):
    @staticmethod
    def _make(**arguments: object) -> CourierDspBridge:
        with patch("courier_emu.bridge.NativeC5x", return_value=_Core()):
            return CourierDspBridge(  # type: ignore[arg-type]
                _Image(), codec=CodecBringUp(SiliconDaa()), **arguments  # type: ignore[arg-type]
            )

    @staticmethod
    def _frames(bridge: CourierDspBridge, count: int) -> None:
        for _ in range(count * LINE_FRAME_INSTRUCTIONS):
            bridge.clock_x86()

    def test_bring_up_runs_without_the_dsp_being_downloaded(self) -> None:
        # The codec hangs off the ASIC's serial bus, not the C52's, so it comes
        # up from board reset rather than waiting on the DSP download.
        bridge = self._make()
        self.assertFalse(bridge.active)

        self._frames(bridge, 3)

        self.assertTrue(bridge.codec.complete)
        self.assertTrue(bridge.codec.codec.ready)
        self.assertTrue(bridge.codec.codec.link_up)

    def test_a_seized_connected_line_reads_back_as_loop_current(self) -> None:
        daa = CourierDaa("dial-tone")
        bridge = self._make(daa=daa)
        self._frames(bridge, 3)
        self.assertEqual(bridge.codec.codec.loop_current_sense, 0)

        daa.seize("answer")
        self._frames(bridge, 1)

        self.assertTrue(bridge.codec.codec.off_hook)
        self.assertEqual(bridge.codec.codec.loop_current_sense, 4)

        daa.release()
        self._frames(bridge, 1)
        self.assertEqual(bridge.codec.codec.loop_current_sense, 0)

    def test_a_ring_burst_reaches_both_detectors(self) -> None:
        ring = RingSource(on_ms=400, off_ms=400, start_ms=0)
        bridge = self._make(ring=ring)
        self._frames(bridge, 3)

        # 100 ms frames against a 400 ms burst: the first three land inside the
        # burst, and two more reach the silence after it.
        self.assertTrue(bridge.codec.codec.ring_positive)
        self.assertTrue(bridge.codec.codec.ring_negative)

        self._frames(bridge, 2)
        self.assertFalse(bridge.codec.codec.ring_positive)
        self.assertFalse(bridge.codec.codec.ring_negative)

    def test_the_codec_reports_its_revision_on_the_first_bootstrap(self) -> None:
        # [0x287] is filled from tag 0x7b and is what ATI7 prints as "DAA rev";
        # a real part reports it at power up, not at the dial/answer boundary,
        # so one download has to be enough.
        image = _Image()
        with patch("courier_emu.bridge.NativeC5x", return_value=_Core()):
            bridge = CourierDspBridge(  # type: ignore[arg-type]
                image, codec=CodecBringUp(SiliconDaa())
            )
            BridgeTests._bootstrap(bridge, image.program)

        self.assertEqual(bridge.bootstraps, 1)
        self.assertEqual(
            list(bridge._runtime_inbound), [(DAA_IDENTITY_TAG, DAA_REVISION)]
        )
        # The coprocessor-ready pair still belongs to the second download.
        self.assertEqual(bridge.read(0x1C, 1), 3)

    def test_the_reported_revision_follows_the_part(self) -> None:
        image = _Image()
        with patch("courier_emu.bridge.NativeC5x", return_value=_Core()):
            bridge = CourierDspBridge(  # type: ignore[arg-type]
                image, codec=CodecBringUp(SiliconDaa(revision=0))
            )
            BridgeTests._bootstrap(bridge, image.program)

        # Zero is the value the firmware's own self-test calls invalid, and the
        # model has to be able to present it.
        self.assertEqual(list(bridge._runtime_inbound), [(DAA_IDENTITY_TAG, 0)])

    def test_without_a_codec_the_mailbox_waits_for_the_second_download(self) -> None:
        image = _Image()
        with patch("courier_emu.bridge.NativeC5x", return_value=_Core()):
            bridge = CourierDspBridge(_Image())  # type: ignore[arg-type]
            BridgeTests._bootstrap(bridge, image.program)

        self.assertEqual(list(bridge._runtime_inbound), [])
        self.assertFalse(bridge._runtime_mode)

    def test_a_bridge_without_a_codec_reports_none(self) -> None:
        with patch("courier_emu.bridge.NativeC5x", return_value=_Core()):
            bridge = CourierDspBridge(_Image())  # type: ignore[arg-type]
        bridge.clock_x86()
        self.assertIsNone(bridge.status().codec)


if __name__ == "__main__":
    unittest.main()
