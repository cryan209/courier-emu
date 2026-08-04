from __future__ import annotations

from contextlib import redirect_stdout
from io import StringIO
import json
from pathlib import Path
import unittest

from courier_emu.cli import main


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


if __name__ == "__main__":
    unittest.main()
