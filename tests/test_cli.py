from __future__ import annotations

from contextlib import redirect_stdout
from io import StringIO
import json
from pathlib import Path
import tempfile
import unittest

from courier_emu.cli import main, ring_cadence
from courier_emu.parameters import FEATURE_BITS, ParameterSector, features_value


ROOT = Path(__file__).resolve().parents[1]


class CliTests(unittest.TestCase):
    def test_info(self) -> None:
        output = StringIO()
        with redirect_stdout(output):
            result = main(["info", str(ROOT / "main211.xmf")])
        self.assertEqual(result, 0)
        info = json.loads(output.getvalue())
        self.assertEqual(info["entry"], "5b5e:0410")
        self.assertEqual(info["error_blink_target"], 0x5C74A)
        self.assertEqual(
            [segment["origin"] for segment in info["dsp_program_segments"]],
            [0, 0xDE83, 0x8000],
        )

    def test_dsp_reaches_stable_service_loop(self) -> None:
        output = StringIO()
        with redirect_stdout(output):
            result = main(
                ["dsp-run", str(ROOT / "main211.xmf"), "--instructions", "20000"]
            )
        self.assertEqual(result, 0)
        run = json.loads(output.getvalue())
        self.assertEqual(run["status"], "stable-loop")
        self.assertEqual(run["error"], "")
        self.assertGreater(run["instructions"], 10_000)
        self.assertLessEqual(run["recent_unique_pcs"], 256)

    def _run_command(self, command: str, instructions: int) -> dict:
        output = StringIO()
        with redirect_stdout(output):
            result = main(
                [
                    "run",
                    str(ROOT / "main211.xmf"),
                    "--instructions",
                    str(instructions),
                    "--at",
                    command,
                    "--summary",
                ]
            )
        self.assertEqual(result, 0)
        return json.loads(output.getvalue())

    def test_identify_command_returns_the_product_code(self) -> None:
        # 0x82ea4 picks the product code from capability bit 0x08, the same
        # settings-EEPROM bit the NVRAM paths test: a board with an EEPROM
        # answers 3368, one without answers 3368A.
        run = self._run_command("ATI", 2_400_000)
        self.assertEqual(run["status"], "main-loop")
        self.assertEqual(run["serial_text"], "\r\n3368\r\n\r\nOK\r\n")

    def test_board_dependent_commands_return_ok(self) -> None:
        # 0x667cb maps a zero or 0xff capability byte straight to result code 4,
        # so with the identification straps floating these answered correctly
        # and then reported ERROR.
        for command in ("ATI2", "ATI3"):
            with self.subTest(command=command):
                run = self._run_command(command, 4_000_000)
                self.assertEqual(run["panel"]["board_capability"], 0x29)
                self.assertTrue(run["serial_text"].rstrip().endswith("OK"))

    def test_floating_straps_still_report_no_board(self) -> None:
        output = StringIO()
        with redirect_stdout(output):
            result = main(
                [
                    "run",
                    str(ROOT / "main211.xmf"),
                    "--instructions",
                    "4000000",
                    "--board-id",
                    "none",
                    "--at",
                    "ATI2",
                    "--summary",
                ]
            )
        self.assertEqual(result, 0)
        run = json.loads(output.getvalue())
        self.assertIsNone(run["panel"]["board_capability"])
        self.assertTrue(run["serial_text"].rstrip().endswith("ERROR"))

    def test_opening_the_result_code_switch_suppresses_them(self) -> None:
        # 0x63e2e only clears the quiet setting at [0x092f] when that switch
        # reads closed, so the open position is a genuinely silent modem.
        output = StringIO()
        with redirect_stdout(output):
            result = main(
                [
                    "run",
                    str(ROOT / "main211.xmf"),
                    "--instructions",
                    "4000000",
                    "--dip",
                    "none",
                    "--at",
                    "AT",
                    "--summary",
                ]
            )
        self.assertEqual(result, 0)
        run = json.loads(output.getvalue())
        self.assertEqual(run["status"], "main-loop")
        self.assertEqual(run["serial_text"], "")
        self.assertEqual(run["panel"]["dip_switches"]["result-codes"], "open")

    def test_ring_cadence_defaults_either_half(self) -> None:
        self.assertEqual(ring_cadence(None), (2_000, 4_000))
        self.assertEqual(ring_cadence("1500:3000"), (1_500, 3_000))
        self.assertEqual(ring_cadence(":3000"), (2_000, 3_000))
        with self.assertRaises(ValueError):
            ring_cadence("1500")

    def test_dedicated_line_preset_forces_carrier_detect_on(self) -> None:
        # 0x5e3cf reads that switch straight into the &C setting, so the
        # profile the firmware prints is the check on it.
        output = StringIO()
        with redirect_stdout(output):
            result = main(
                [
                    "run",
                    str(ROOT / "main211.xmf"),
                    "--instructions",
                    "12000000",
                    "--dip-preset",
                    "dedicated-line",
                    "--at",
                    "ATI4",
                    "--summary",
                ]
            )
        self.assertEqual(result, 0)
        run = json.loads(output.getvalue())
        self.assertIn("&C0", run["serial_text"])
        self.assertIn("S14=000", run["serial_text"])
        switches = run["panel"]["dip_switches"]
        self.assertEqual(switches["carrier-detect-override"], "closed")
        self.assertEqual(switches["dtr-override"], "closed")
        # Auto answer stays on: the switch that would disable it is open.
        self.assertEqual(switches["no-auto-answer"], "open")
        self.assertIn("S00=001", run["serial_text"])

    def test_the_ring_detector_follows_the_configured_cadence(self) -> None:
        # The answer machine at 0x70fb4 polls input port 0x14 bit 0x02 and
        # every state waits on an edge, so the run has to see whole bursts.
        output = StringIO()
        with redirect_stdout(output):
            result = main(
                [
                    "run",
                    str(ROOT / "main211.xmf"),
                    "--instructions",
                    "30000000",
                    "--ring",
                    "--ring-start",
                    "8000",
                    "--summary",
                ]
            )
        self.assertEqual(result, 0)
        run = json.loads(output.getvalue())
        self.assertEqual(run["ring"]["on_ms"], 2_000)
        self.assertEqual(run["ring"]["off_ms"], 4_000)
        self.assertGreaterEqual(run["ring"]["bursts_delivered"], 3)

    def test_synthesised_sector_reproduces_the_reported_dump(self) -> None:
        # A real parameter sector cannot be dumped, so this builds one carrying
        # the configuration an x2-enabled unit reports and checks the firmware
        # prints it back, along with the serial number and the x2 product code.
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "params.bin"
            ParameterSector(
                features=features_value(tuple(FEATURE_BITS)), serial="12345678"
            ).save(path)
            for command, expected in (
                ("ATY14", "000,000,030,007,031,000"),
                ("ATI", "5608"),
                ("ATI7", "12345678"),
            ):
                with self.subTest(command=command):
                    output = StringIO()
                    with redirect_stdout(output):
                        result = main(
                            [
                                "run",
                                str(ROOT / "main211.xmf"),
                                "--instructions",
                                "8000000",
                                "--parameter-sector",
                                str(path),
                                "--at",
                                command,
                                "--summary",
                            ]
                        )
                    self.assertEqual(result, 0)
                    run = json.loads(output.getvalue())
                    self.assertEqual(run["status"], "main-loop")
                    self.assertIn(expected, run["serial_text"])
                    self.assertTrue(run["serial_text"].rstrip().endswith("OK"))

    def test_settings_report_is_captured_once_per_byte(self) -> None:
        # The transmit routine re-enters itself while the integrated UART
        # reports busy. Capturing at the entry recorded one copy of the pending
        # byte per spin, which filled the 64 KiB cap with carriage returns.
        run = self._run_command("ATI4", 3_000_000)
        self.assertEqual(run["status"], "main-loop")
        self.assertFalse(run["serial_truncated"])
        text = run["serial_text"]
        self.assertIn("USRobotics Courier V.Everything Settings", text)
        self.assertIn("BAUD=9600", text)
        self.assertIn("S00=001", text)
        self.assertIn("S73=121", text)
        self.assertTrue(text.rstrip().endswith("OK"))
        # Bit 7 is the parity bit in this framing, not data.
        self.assertTrue(all(character < "\x80" for character in text))


if __name__ == "__main__":
    unittest.main()
