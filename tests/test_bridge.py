from __future__ import annotations

from unittest.mock import patch
import unittest

from courier_emu.bridge import CourierDspBridge
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


if __name__ == "__main__":
    unittest.main()
