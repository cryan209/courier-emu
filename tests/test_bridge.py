from __future__ import annotations

from unittest.mock import patch
import unittest

from courier_emu.bridge import CourierDspBridge
from courier_emu.daa import CourierDaa
from courier_emu.xmf import DSP_BOOT_SIZE


class _Image:
    def __init__(self) -> None:
        self.program = bytes(index & 0xFF for index in range(DSP_BOOT_SIZE))

    def dsp_program_segments(self) -> list[tuple[int, bytes]]:
        return [(0, self.program)]


class _Core:
    def __init__(self) -> None:
        self.queued: list[int] = []
        self.dtmf = ""

    def close(self) -> None:
        pass

    def set_io(self, _port: int, _value: int) -> None:
        pass

    def io(self, _port: int) -> int:
        return 0xFFFF

    def step(self, _count: int) -> None:
        pass

    def state(self) -> dict[str, int | bool]:
        return {}

    def serial_state(self) -> dict[str, int]:
        return {}

    def queue_serial_rx(self, samples: list[int]) -> None:
        self.queued.extend(samples)

    def set_dtmf_digits(self, digits: str) -> None:
        self.dtmf = digits

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


if __name__ == "__main__":
    unittest.main()
