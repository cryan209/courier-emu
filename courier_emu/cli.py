from __future__ import annotations

import argparse
import json
import os
from pathlib import Path
import signal
import subprocess
import sys

from .panel import (
    BOARD_CAPABILITY,
    DEFAULT_BOARD_ID,
    DEFAULT_DIP_CLOSED,
    DIP_SWITCHES,
    USABLE_BOARD_IDS,
)
from .xmf import XmfFormatError, XmfImage
from .dsp import run_dsp


def _number(value: str) -> int:
    return int(value, 0)


def _board_id(value: str) -> str:
    """Validate a board identification strap code, or 'none' for floating."""
    if value == "none":
        return value
    try:
        code = int(value, 0)
    except ValueError:
        raise argparse.ArgumentTypeError(f"{value!r} is not a strap code or 'none'") from None
    if not 0 <= code <= 15:
        raise argparse.ArgumentTypeError(f"{code} is outside the four-bit strap range")
    if code not in USABLE_BOARD_IDS:
        capability = BOARD_CAPABILITY[code]
        reason = "no board fitted" if not capability else "a fatal board fault"
        usable = ", ".join(str(item) for item in USABLE_BOARD_IDS)
        raise argparse.ArgumentTypeError(
            f"code {code} maps to capability {capability:#04x}, which the firmware reads "
            f"as {reason}; usable codes are {usable}"
        )
    return value


def _print_json(value: object) -> None:
    print(json.dumps(value, indent=2, sort_keys=True))


def _run_isolated(args: argparse.Namespace) -> int:
    image = XmfImage.load(args.image)
    command = [
        sys.executable,
        "-m",
        "courier_emu.worker",
        str(image.path),
        "--instructions",
        str(args.instructions),
    ]
    for assignment in args.port:
        command.extend(("--port", assignment))
    for assignment in args.runtime_port:
        command.extend(("--runtime-port", assignment))
    for port in args.uart_port:
        command.extend(("--uart-port", str(port)))
    if args.real_delays:
        command.append("--real-delays")
    if args.with_dsp or args.daa_line or args.sip_server:
        command.append("--with-dsp")
    daa_line = args.daa_line or ("dial-tone" if args.sip_server else None)
    if daa_line:
        command.extend(("--daa-line", daa_line))
    if args.sip_server:
        command.extend(("--sip-server", args.sip_server))
        command.extend(("--sip-username", args.sip_username))
        command.extend(("--sip-password-env", args.sip_password_env))
        command.extend(("--sip-local-port", str(args.sip_local_port)))
        command.extend(("--rtp-local-port", str(args.rtp_local_port)))
        if args.sip_target:
            command.extend(("--sip-target", args.sip_target))
    if args.nvram:
        command.extend(("--nvram", str(Path(args.nvram).resolve())))
    command.extend(("--board-id", args.board_id))
    closed = sorted(DEFAULT_DIP_CLOSED) if args.dip is None else args.dip
    for switch in closed:
        if switch != "none":
            command.extend(("--dip", switch))
    if args.dsp_rx_pcm:
        command.extend(("--dsp-rx-pcm", str(Path(args.dsp_rx_pcm).resolve())))
    if args.dsp_tx_pcm:
        command.extend(("--dsp-tx-pcm", str(Path(args.dsp_tx_pcm).resolve())))
    serial_input = b"".join(value.encode("latin-1") for value in args.serial_input)
    serial_input += b"".join(value.encode("ascii") + b"\r" for value in args.at)
    if serial_input:
        command.extend(("--serial-input-hex", serial_input.hex()))

    environment = os.environ.copy()
    if args.libunicorn:
        environment["LIBUNICORN_PATH"] = str(Path(args.libunicorn).resolve())
    process = subprocess.run(command, text=True, capture_output=True, env=environment)
    if process.returncode != 0:
        if process.returncode < 0:
            reason = signal.Signals(-process.returncode).name
        elif process.returncode >= 128:
            try:
                reason = signal.Signals(process.returncode - 128).name
            except ValueError:
                reason = f"exit {process.returncode}"
        else:
            reason = f"exit {process.returncode}"
        detail = process.stderr.strip() or process.stdout.strip()
        print(f"execution worker failed ({reason})", file=sys.stderr)
        if detail:
            print(detail, file=sys.stderr)
        return 2
    result = json.loads(process.stdout)
    if args.summary:
        result.pop("io_events", None)
        result.pop("mmio_events", None)
        result.pop("last_addresses", None)
    _print_json(result)
    return 0


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(prog="courier-emu")
    subparsers = parser.add_subparsers(dest="command", required=True)

    info = subparsers.add_parser("info", help="validate and describe an XMF image")
    info.add_argument("image")

    extract = subparsers.add_parser("extract", help="split the header, DSP, and supervisor")
    extract.add_argument("image")
    extract.add_argument("directory")

    run = subparsers.add_parser("run", help="execute the 80186 application entry")
    run.add_argument("image")
    run.add_argument("--instructions", type=_number, default=250_000)
    run.add_argument(
        "--port",
        action="append",
        default=[],
        metavar="PORT=VALUE",
        help="seed an I/O port value; numbers accept 0x notation",
    )
    run.add_argument(
        "--runtime-port",
        action="append",
        default=[],
        metavar="PORT=VALUE",
        help="seed an input port only after the firmware reaches its main loop",
    )
    run.add_argument(
        "--uart-port",
        action="append",
        type=_number,
        default=[],
        help="capture bytes written to this port as serial output",
    )
    run.add_argument(
        "--libunicorn",
        help="directory containing a custom libunicorn shared library",
    )
    run.add_argument(
        "--real-delays",
        action="store_true",
        help="execute the bootstrap's calibrated delay loops without acceleration",
    )
    run.add_argument(
        "--summary",
        action="store_true",
        help="omit individual event records and the final address window",
    )
    run.add_argument(
        "--with-dsp",
        action="store_true",
        help="lock-step the native TMS320C52 core through the Courier host-port bridge",
    )
    run.add_argument(
        "--daa-line",
        choices=("disconnected", "quiet", "dial-tone", "ringing"),
        help="attach a behavioral DAA line source (use dial-tone for an originating call)",
    )
    run.add_argument("--sip-server", metavar="HOST[:PORT]", help="send ATD calls via UDP SIP")
    run.add_argument(
        "--sip-target",
        default="",
        metavar="URI",
        help="destination URI template; {number} and {server} are replaced",
    )
    run.add_argument("--sip-username", default="courier")
    run.add_argument(
        "--sip-password-env",
        default="COURIER_SIP_PASSWORD",
        metavar="NAME",
        help="environment variable containing the SIP password",
    )
    run.add_argument("--sip-local-port", type=_number, default=0)
    run.add_argument("--rtp-local-port", type=_number, default=0)
    run.add_argument(
        "--board-id",
        type=_board_id,
        default=str(DEFAULT_BOARD_ID),
        metavar="CODE",
        help="drive the four board identification straps with this 0-15 code, "
        f"or 'none' to leave them floating (default: {DEFAULT_BOARD_ID})",
    )
    run.add_argument(
        "--dip",
        action="append",
        choices=sorted(DIP_SWITCHES) + ["none"],
        metavar="SWITCH",
        help="close this board option switch; repeatable, and the first use "
        "replaces the default set. Use 'none' to leave every switch open. "
        "Default: " + ", ".join(sorted(DEFAULT_DIP_CLOSED)),
    )
    run.add_argument(
        "--nvram",
        metavar="PATH",
        help="attach the 512-byte board settings EEPROM image (created if absent)",
    )
    run.add_argument(
        "--dsp-rx-pcm",
        metavar="PATH",
        help="feed raw signed 16-bit little-endian samples to the Courier ASIC line input",
    )
    run.add_argument(
        "--dsp-tx-pcm",
        metavar="PATH",
        help="capture raw signed 16-bit little-endian C52 line output samples",
    )
    run.add_argument(
        "--at",
        action="append",
        default=[],
        metavar="COMMAND",
        help="send an AT command after boot (a carriage return is appended)",
    )
    run.add_argument(
        "--serial-input",
        action="append",
        default=[],
        metavar="TEXT",
        help="queue literal Latin-1 terminal input after boot",
    )

    dsp_run = subparsers.add_parser("dsp-run", help="execute the TMS320C52 firmware")
    dsp_run.add_argument("image")
    dsp_run.add_argument("--instructions", type=_number, default=1_000_000)
    dsp_run.add_argument("--trace", type=_number, default=0, help="trace this many instructions")
    dsp_run.add_argument("--trace-start", type=_number, default=0)
    dsp_run.add_argument(
        "--port",
        action="append",
        default=[],
        metavar="PORT=VALUE",
        help="seed a 16-bit DSP I/O port (unseeded ports read as 0xffff)",
    )
    dsp_run.add_argument("--rebuild", action="store_true", help="rebuild the native C5x runner")
    return parser


def main(argv: list[str] | None = None) -> int:
    parser = build_parser()
    args = parser.parse_args(argv)
    try:
        if args.command == "info":
            image = XmfImage.load(args.image)
            _print_json(image.describe())
            return 0
        if args.command == "extract":
            image = XmfImage.load(args.image)
            paths = image.extract(args.directory)
            _print_json({"files": [str(path.resolve()) for path in paths]})
            return 0
        if args.command == "run":
            return _run_isolated(args)
        if args.command == "dsp-run":
            image = XmfImage.load(args.image)
            ports: dict[int, int] = {}
            for assignment in args.port:
                key, separator, value = assignment.partition("=")
                if not separator:
                    raise ValueError(f"invalid port assignment: {assignment!r}")
                ports[_number(key)] = _number(value)
            _print_json(
                run_dsp(
                    image,
                    instructions=args.instructions,
                    trace=args.trace,
                    trace_start=args.trace_start,
                    ports=ports,
                    rebuild=args.rebuild,
                )
            )
            return 0
    except (OSError, XmfFormatError, ValueError, json.JSONDecodeError) as exc:
        parser.error(str(exc))
    return 1
