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






















if __name__ == "__main__":
    unittest.main()
