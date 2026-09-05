from __future__ import annotations

import argparse
from contextlib import redirect_stdout
from io import StringIO
import json
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest

from courier_emu.cli import _worker_command, build_parser, daa_codec_wanted, main, ring_cadence
from courier_emu.daa import RING_OFF_MS, RING_ON_MS
from courier_emu.parameters import FEATURE_BITS, ParameterSector, features_value


ROOT = Path(__file__).resolve().parents[1]


class CliTests(unittest.TestCase):
    def test_idsl302_nvram_fixture_is_forwarded_to_the_worker(self) -> None:
        args = build_parser().parse_args(
            ["run", str(ROOT / "IDSDL302.ROM"), "--nvram-fixture", "idsdl302"]
        )
        command = _worker_command(args)
        self.assertIn("--nvram-fixture", command)
        self.assertEqual(command[command.index("--nvram-fixture") + 1], "idsdl302")
        with self.assertRaises(SystemExit):
            build_parser().parse_args(
                [
                    "run",
                    str(ROOT / "IDSDL302.ROM"),
                    "--nvram-fixture",
                    "idsdl302",
                    "--nvram",
                    "settings.nv",
                ]
            )

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

    def test_a_second_command_line_is_answered(self) -> None:
        # The command state machine parses a line only from its ready state,
        # and the end-of-command path resets the collector. Offering the next
        # line while a8d9 is pending is what a terminal does, and both
        # answers here are the firmware's own.
        output = StringIO()
        with redirect_stdout(output):
            result = main(
                [
                    "run",
                    str(ROOT / "main211.xmf"),
                    "--instructions",
                    "6000000",
                    "--at",
                    "ATI3",
                    "--at",
                    "ATI1",
                    "--summary",
                ]
            )
        self.assertEqual(result, 0)
        run = json.loads(output.getvalue())
        self.assertEqual(
            run["serial_text"],
            "\r\nUSRobotics Courier V.Everything EXT\r\n\r\nOK\r\n\r\nCE8E\r\n\r\nOK\r\n",
        )

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

    def test_the_default_ring_cadence_is_north_american(self) -> None:
        self.assertEqual((RING_ON_MS, RING_OFF_MS), (2_000, 4_000))

    def test_the_ring_detector_follows_the_configured_cadence(self) -> None:
        # The answer machine at 0x70fb4 polls input port 0x14 bit 0x02 and
        # every state waits on an edge, so the run has to see whole bursts.
        #
        # Bursts are counted in line milliseconds, so the instruction budget a
        # given number of them needs scales with INSTRUCTIONS_PER_MS. Three at
        # the default 6 s cadence is 20 s of line time, which is 87M
        # instructions at 4,348 and too slow to run here. A short cadence tests
        # the same edge delivery in a quarter of the budget; the default
        # cadence itself is asserted above.
        output = StringIO()
        with redirect_stdout(output):
            result = main(
                [
                    "run",
                    str(ROOT / "main211.xmf"),
                    "--instructions",
                    "25000000",
                    "--ring",
                    "--ring-cadence",
                    "500:1000",
                    "--ring-start",
                    "1000",
                    "--summary",
                ]
            )
        self.assertEqual(result, 0)
        run = json.loads(output.getvalue())
        self.assertEqual(run["ring"]["on_ms"], 500)
        self.assertEqual(run["ring"]["off_ms"], 1_000)
        self.assertGreaterEqual(run["ring"]["bursts_delivered"], 3)

    def test_two_linked_instances_reach_connect(self) -> None:
        # One side originates and the other answers on the shared line. Both
        # qualify the detector and exchange the same number of frames before
        # the answer-side firmware emits its CONNECT result.
        output = StringIO()
        with tempfile.TemporaryDirectory(dir="/tmp") as directory:
            with redirect_stdout(output):
                result = main(
                    [
                        "link",
                        str(ROOT / "main211.xmf"),
                        "--instructions",
                        "4000000",
                        "--socket",
                        str(Path(directory) / "line.sock"),
                        "--a-at",
                        "ATD555",
                        "--b-at",
                        "ATA",
                        "--summary",
                    ]
                )
        self.assertEqual(result, 0)
        run = json.loads(output.getvalue())
        for side in ("a", "b"):
            with self.subTest(side=side):
                bridge = run[side]["dsp_bridge"]
                self.assertEqual(run[side]["status"], "main-loop")
                self.assertTrue(bridge["daa"]["off_hook"])
                self.assertTrue(bridge["daa"]["detector_qualified"])
                self.assertGreater(bridge["line"]["frames"], 0)
        self.assertEqual(
            run["a"]["dsp_bridge"]["line"]["frames"],
            run["b"]["dsp_bridge"]["line"]["frames"],
        )
        self.assertIn("CONNECT", run["b"]["serial_text"])
        # Both C52s enter the recovered call overlay and exchange current,
        # nonzero polyphase audio rather than replaying an idle-DAC backlog.
        for side in ("a", "b"):
            bridge = run[side]["dsp_bridge"]
            serial = bridge["serial_port"]
            self.assertTrue(bridge["asic"]["call_overlay_active"])
            self.assertGreater(serial["line_tx_nonzero"], 1_000)
            self.assertGreater(serial["codec_rx_consumed"], 1_000)

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




class ParameterFlashTests(unittest.TestCase):
    def _run(self, path: Path, *commands: str) -> dict:
        output = StringIO()
        arguments = [
            "run",
            str(ROOT / "main211.xmf"),
            "--instructions",
            "12000000",
            "--parameter-flash",
            str(path),
            "--summary",
        ]
        for command in commands:
            arguments.extend(("--at", command))
        with redirect_stdout(output):
            result = main(arguments)
        self.assertEqual(result, 0)
        return json.loads(output.getvalue())

    def test_a_stored_profile_survives_the_run_that_wrote_it(self) -> None:
        # AT&W assembles a sector in RAM and asks the boot block to erase and
        # program it. An update payload has no boot block, so the harness
        # answers those two services itself; the proof that it answers them
        # as the part would is that the firmware's own CRC over what it wrote
        # checks out, and that its own reader finds the value again.
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "parameter.flash"
            stored = self._run(path, "ATS0=7", "AT&W")
            self.assertEqual(stored["serial_text"], "\r\nOK\r\n\r\nOK\r\n")
            sector = stored["flash"]["sectors"][0]
            self.assertTrue(sector["checksum_valid"])
            self.assertFalse(sector["erased"])
            self.assertEqual(sector["version"], 1)
            # Programming into an unerased word would mean the model and the
            # firmware disagree about what an erase leaves behind.
            self.assertEqual(stored["flash"]["refused_bits"], 0)

            reopened = self._run(path, "ATS0?")
            self.assertEqual(reopened["serial_text"], "\r\n007\r\n\r\nOK\r\n")

    def test_a_second_store_moves_to_the_next_sector(self) -> None:
        # The search at 0x7e07c keeps the highest version of four sectors, so
        # the writer rotates rather than rewriting one in place.
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "parameter.flash"
            self._run(path, "ATS0=7", "AT&W")
            second = self._run(path, "ATS0=8", "AT&W")
            versions = [sector["version"] for sector in second["flash"]["sectors"][:2]]
            self.assertEqual(versions, [1, 2])
            self.assertTrue(
                all(sector["checksum_valid"] for sector in second["flash"]["sectors"][:2])
            )
            self.assertEqual(second["flash"]["erases"], 0)


class ConsoleTests(unittest.TestCase):
    def test_a_console_session_answers_while_it_runs(self) -> None:
        # stdin need not be a terminal: piping is the same live path, which
        # keeps this exercisable without a pty.
        process = subprocess.run(
            [
                sys.executable,
                "-m",
                "courier_emu",
                "run",
                str(ROOT / "main211.xmf"),
                "--console",
                "--instructions",
                "4000000",
                "--summary",
            ],
            input=b"ATI3\r",
            capture_output=True,
            cwd=ROOT,
            timeout=600,
        )
        self.assertEqual(process.returncode, 0)
        # stdout carries the modem, so a session can be redirected as itself.
        self.assertIn(b"USRobotics Courier V.Everything EXT", process.stdout)
        result = json.loads(process.stderr)
        self.assertEqual(result["console"]["received"], 5)
        self.assertEqual(result["console"]["dropped"], 0)
        self.assertGreater(result["console"]["sent"], 0)
        self.assertEqual(result["serial_input_remaining"], 0)


class DaaCodecDefaultTests(unittest.TestCase):
    """How the codec's three-state flag resolves against an image."""

    @staticmethod
    def _args(value: bool | None) -> argparse.Namespace:
        return argparse.Namespace(daa_codec=value, image="image.xmf")

    class _Payload:
        def dsp_program_segments(self) -> list[tuple[int, bytes]]:
            return [(0, b"")]

    class _Rom:
        pass

    def test_a_payload_gets_the_codec_without_being_asked(self) -> None:
        self.assertTrue(daa_codec_wanted(self._args(None), self._Payload()))
        self.assertTrue(daa_codec_wanted(self._args(True), self._Payload()))

    def test_the_opt_out_wins_everywhere(self) -> None:
        self.assertFalse(daa_codec_wanted(self._args(False), self._Payload()))
        self.assertFalse(daa_codec_wanted(self._args(False), self._Rom()))

    def test_a_rom_drops_the_default_but_refuses_the_request(self) -> None:
        # The default giving way keeps `run some.rom` working; an explicit
        # request for something the image cannot host is still an error.
        self.assertFalse(daa_codec_wanted(self._args(None), self._Rom()))
        with self.assertRaises(ValueError):
            daa_codec_wanted(self._args(True), self._Rom())


if __name__ == "__main__":
    unittest.main()
