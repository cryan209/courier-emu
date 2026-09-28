#!/usr/bin/env python3
"""Put an emulated I-modem B channel directly on an analog Courier's line."""

from __future__ import annotations

import argparse
import json
import os
from pathlib import Path
import subprocess
import tempfile

from courier_emu.bearer_line import BearerLineLink
from courier_emu.bri import BriNetwork
from courier_emu.isdn import IsdnMachine
from courier_emu.isdn_console import scripted_pump
from courier_emu.line import LineLink
from courier_emu.nac import NacImage
from courier_emu.timebase import ASIC_DSP_CLOCK_HZ


ROOT = Path(__file__).resolve().parents[1]
DEFAULT_IMODEM = ROOT / "Ie030002.nac"
DEFAULT_ANALOG = (
    ROOT / "artifacts/courier-board-21210-capture-403/courier-board.rom"
)


def parser() -> argparse.ArgumentParser:
    result = argparse.ArgumentParser(description=__doc__)
    result.add_argument("--imodem", type=Path, default=DEFAULT_IMODEM)
    result.add_argument("--analog", type=Path, default=DEFAULT_ANALOG)
    result.add_argument("--instructions", type=int, default=300_000_000)
    result.add_argument(
        "--protocol", choices=("default", "x2", "v90"), default="default",
        help="leave both PCM protocols enabled or force one PCM protocol",
    )
    result.add_argument(
        "--dsp-trace-range", metavar="FIRST:LAST",
        help="retain the C51's last instructions in this hexadecimal range",
    )
    result.add_argument(
        "--dsp-data-trace", metavar="ADDRESS",
        help="retain writes to one hexadecimal C51 data-memory address",
    )
    result.add_argument(
        "--analog-to-imodem-db", type=float, default=0.0,
        help="additional gain on analogue Courier audio entering the I-modem",
    )
    result.add_argument(
        "--imodem-to-analog-db", type=float, default=0.0,
        help="additional gain on I-modem audio entering the analogue Courier",
    )
    result.add_argument("--output", type=Path)
    return result


def main() -> int:
    args = parser().parse_args()
    output = args.output.resolve() if args.output else None
    if output:
        output.mkdir(parents=True, exist_ok=True)

    with tempfile.TemporaryDirectory(prefix="courier-imodem-analog-") as temporary:
        socket_path = str(Path(temporary) / "line.sock")
        analog_s58 = {"default": "", "x2": "1", "v90": "32"}[args.protocol]
        analog_dial = (
            f"ATS58={analog_s58}X0DT5551234"
            if analog_s58 else "ATX0DT5551234"
        )
        analog_command = [
            str(ROOT / ".venv/bin/python"), "-m", "courier_emu", "run",
            str(args.analog.resolve()), "--instructions", str(args.instructions),
            "--line-link", socket_path, "--line-listen",
            "--with-dsp", "--nvram-fixture", "idsdl403", "--board-id", "7",
            "--dip-preset", "default", "--tick-ms", "5",
            # Keep the dial-mode change and dial in one Hayes command.  Two
            # back-to-back batch commands can put the second command on the
            # modelled DTE while this ROM is still returning OK to the first.
            "--at", analog_dial,
            "--serial-input-after", "5000000", "--summary",
        ]
        if output:
            analog_command.extend(("--line-record", str(output / "analog")))
        analog_environment = os.environ.copy()
        analog_environment["COURIER_LINE_DIGITAL"] = "1"
        analog = subprocess.Popen(
            analog_command, cwd=ROOT, text=True, stdout=subprocess.PIPE,
            stderr=subprocess.PIPE, env=analog_environment,
        )

        peer = BearerLineLink(LineLink(socket_path, digital=True))
        peer.from_line *= 10 ** (args.analog_to_imodem_db / 20)
        peer.into_courier *= 10 ** (args.imodem_to_analog_db / 20)
        bri = BriNetwork(
            establish="terminal",
            call_to="7349195",
            media_peer=peer,
        )
        transcript: list[tuple[int, str, str]] = []
        if args.protocol != "default":
            # I-modem S58 uses disable polarity. Bit 0 disables x2; bit 5
            # disables V.90. Configure it before the ring, then answer at the
            # same point as the default run.
            imodem_s58 = 1 if args.protocol == "v90" else 32
            commands = [f"ATS58={imodem_s58}", "ATA"]
            first_command, spacing = 30_000_000, 75_000_000
        else:
            commands, first_command, spacing = ["ATA"], 105_000_000, 0
        command_pump = scripted_pump(
            commands, after=first_command, every=spacing, transcript=transcript
        )
        trace_range = None
        if args.dsp_trace_range:
            first, separator, last = args.dsp_trace_range.partition(":")
            if not separator:
                raise ValueError("--dsp-trace-range must be FIRST:LAST")
            trace_range = (int(first, 16), int(last, 16))
        traced_core = None
        data_trace_address = (
            int(args.dsp_data_trace, 16) if args.dsp_data_trace else None
        )

        def pump(current: IsdnMachine) -> None:
            nonlocal traced_core
            command_pump(current)
            core = getattr(current.mailbox, "core", None)
            # The mask-ROM bootstrap creates a fresh core, so object identity
            # rather than a one-shot flag decides whether tracing is armed.
            fresh_core = core is not None and core is not traced_core
            if trace_range is not None and fresh_core:
                core.set_pc_trace_range(*trace_range)
            if data_trace_address is not None and fresh_core:
                core.set_data_trace_filter(data_trace_address)
                core.trace_data_writes()
            if core is not None:
                traced_core = core

        machine = IsdnMachine(
            NacImage.load(args.imodem),
            with_dsp=True,
            profile=False,
            bri=bri,
            flash_nvram=None,
            # The continuously clocked analogue side reaches RING after about
            # 95M 386 instructions. ATA sent earlier is correctly ignored.
            serial_pump=pump,
        )
        try:
            imodem_result = machine.run(args.instructions).to_dict()
            if trace_range is not None and machine.mailbox.core is not None:
                imodem_result["dsp_pc_trace"] = machine.mailbox.core.pc_trace()
            if (
                data_trace_address is not None
                and machine.mailbox.core is not None
            ):
                imodem_result["dsp_data_trace"] = machine.mailbox.core.data_events()
            if output:
                (output / "imodem-tx.g711").write_bytes(bytes(bri.media_tx))
                (output / "imodem-rx.g711").write_bytes(
                    bytes(machine.dsc.bearer_rx_heard[1])
                )
        finally:
            peer.close()
            machine.mailbox.close()

        analog_stdout, analog_stderr = analog.communicate(timeout=60)
        if analog.returncode:
            raise RuntimeError(
                f"analog process exited {analog.returncode}: {analog_stderr.strip()}"
            )
        analog_result = json.loads(analog_stdout)

    result = {
        "protocol": args.protocol,
        "dsp_clock_hz": ASIC_DSP_CLOCK_HZ,
        "audio_gain_db": {
            "analog_to_imodem": args.analog_to_imodem_db,
            "imodem_to_analog": args.imodem_to_analog_db,
        },
        "imodem": imodem_result,
        "imodem_serial_session": [
            {"instructions": count, "direction": direction, "text": text}
            for count, direction, text in transcript
        ],
        "analog": analog_result,
        "bridge": peer.status(),
    }
    if output:
        (output / "result.json").write_text(
            json.dumps(result, indent=2, sort_keys=True) + "\n"
        )
    print(json.dumps(result, indent=2, sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
