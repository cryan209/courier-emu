from __future__ import annotations

import argparse
import json
import os
from pathlib import Path
import signal
import subprocess
import sys

from .parameters import FEATURE_BITS, ParameterSector, features_value
from .daa import RING_OFF_MS, RING_ON_MS, RING_START_MS
from .line import MAX_SOCKET_PATH
from .panel import (
    BOARD_CAPABILITY,
    DEFAULT_BOARD_ID,
    DEFAULT_DIP_CLOSED,
    DIP_PRESETS,
    DIP_SWITCHES,
    USABLE_BOARD_IDS,
)
from .images import load_image
from .nac import NacFormatError, NacImage
from .rom import CourierRom, RomFormatError
from .xmf import XmfFormatError, XmfImage
from .xmp import XmpFormatError, XmpImage

DEFAULT_LINE_SOCKET = "/tmp/courier-line.sock"
DEFAULT_RUN_INSTRUCTIONS = 250_000
# A console session ends when its terminal detaches rather than at a count,
# so this only has to be further away than a session will reach: about four
# hours of emulated execution.
CONSOLE_INSTRUCTIONS = 10_000_000_000
from .dsp import run_dsp
from .terminal import run_console


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


def ring_cadence(value: str | None) -> tuple[int, int]:
    """Split an ON:OFF millisecond cadence, defaulting either half."""
    if not value:
        return RING_ON_MS, RING_OFF_MS
    on_text, separator, off_text = value.partition(":")
    if not separator:
        raise ValueError(f"ring cadence must be ON:OFF milliseconds, got {value!r}")
    return _number(on_text or str(RING_ON_MS)), _number(off_text or str(RING_OFF_MS))


def instruction_limit(args: argparse.Namespace) -> int:
    """Resolve --instructions, which defaults by how the run is driven."""
    if args.instructions is not None:
        return args.instructions
    if getattr(args, "console", False) or getattr(args, "serial_pty", False):
        return CONSOLE_INSTRUCTIONS
    return DEFAULT_RUN_INSTRUCTIONS


def _print_json(value: object) -> None:
    print(json.dumps(value, indent=2, sort_keys=True))


def _worker_command(args: argparse.Namespace) -> list[str]:
    image = load_image(args.image)
    if args.with_dsp and not hasattr(image, "dsp_program_segments"):
        raise ValueError(
            f"{Path(args.image).name} is a flash ROM, which carries no separable "
            "C52 payload for the DSP bridge to load"
        )
    command = [
        sys.executable,
        "-m",
        "courier_emu.worker",
        str(image.path),
        "--instructions",
        str(instruction_limit(args)),
    ]
    for assignment in args.port:
        command.extend(("--port", assignment))
    for assignment in args.runtime_port:
        command.extend(("--runtime-port", assignment))
    for port in args.uart_port:
        command.extend(("--uart-port", str(port)))
    if args.real_delays:
        command.append("--real-delays")
    if args.with_dsp or args.daa_line or args.sip_server or args.line_link or args.daa_codec:
        command.append("--with-dsp")
    if args.daa_codec:
        command.append("--daa-codec")
        command.extend(("--daa-codec-line", str(args.daa_codec_line)))
        command.extend(("--daa-codec-rate", str(args.daa_codec_rate)))
    if args.line_link:
        command.extend(("--line-link", str(args.line_link)))
        if args.line_listen:
            command.append("--line-listen")
    # A linked instance always needs a DAA: the link drives its line state
    # frame by frame, starting from a line with nothing on the far end.
    daa_line = args.daa_line or ("dial-tone" if args.sip_server else None)
    if daa_line is None and args.line_link:
        daa_line = "disconnected"
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
    if args.parameter_sector:
        command.extend(("--parameter-sector", str(Path(args.parameter_sector).resolve())))
    command.extend(("--board-id", args.board_id))
    if args.dip is not None and args.dip_preset:
        raise ValueError("use --dip or --dip-preset, not both")
    if args.dip is not None:
        closed = args.dip
    elif args.dip_preset:
        closed = sorted(DIP_PRESETS[args.dip_preset])
    else:
        closed = sorted(DEFAULT_DIP_CLOSED)
    for switch in closed:
        if switch != "none":
            command.extend(("--dip", switch))
    if args.int1_after is not None:
        command.extend(("--int1-after", str(args.int1_after)))
    if args.ring or args.ring_cadence:
        on_ms, off_ms = ring_cadence(args.ring_cadence)
        command.extend(("--ring-cadence", f"{on_ms}:{off_ms}"))
        command.extend(("--ring-start", str(args.ring_start)))
        command.extend(("--ring-count", str(args.ring_count)))
    if args.dsp_rx_pcm:
        command.extend(("--dsp-rx-pcm", str(Path(args.dsp_rx_pcm).resolve())))
    if args.dsp_tx_pcm:
        command.extend(("--dsp-tx-pcm", str(Path(args.dsp_tx_pcm).resolve())))
    serial_input = b"".join(value.encode("latin-1") for value in args.serial_input)
    serial_input += b"".join(value.encode("ascii") + b"\r" for value in args.at)
    if serial_input:
        command.extend(("--serial-input-hex", serial_input.hex()))
    return command


def _worker_environment(args: argparse.Namespace) -> dict[str, str]:
    environment = os.environ.copy()
    if args.libunicorn:
        environment["LIBUNICORN_PATH"] = str(Path(args.libunicorn).resolve())
    return environment


def _run_isolated(args: argparse.Namespace) -> int:
    command = _worker_command(args)
    environment = _worker_environment(args)
    if args.console or args.serial_pty:
        return run_console(args, command, environment)
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


def _link_side(args: argparse.Namespace, commands: list[str], listen: bool) -> list[str]:
    command = [
        sys.executable,
        "-m",
        "courier_emu",
        "run",
        str(Path(args.image).resolve()),
        "--instructions",
        str(args.instructions),
        "--line-link",
        args.socket,
        "--dip-preset",
        args.dip_preset,
        "--board-id",
        args.board_id,
    ]
    if listen:
        command.append("--line-listen")
    if args.summary:
        command.append("--summary")
    for text in commands or ["ATA"]:
        command.extend(("--at", text))
    return command


def _run_linked_pair(args: argparse.Namespace) -> int:
    """Run both sides of one line and report each side's result."""
    socket_path = Path(args.socket)
    if len(str(socket_path).encode()) > MAX_SOCKET_PATH:
        raise ValueError(
            f"line socket path is {len(str(socket_path))} characters; "
            f"a UNIX socket path fits {MAX_SOCKET_PATH}"
        )
    if socket_path.exists():
        socket_path.unlink()
    XmfImage.load(args.image)

    # Either side may reach the socket first; the connecting side retries
    # until the listening side has bound and listened.
    side_a = subprocess.Popen(
        _link_side(args, args.a_at, listen=True), text=True, stdout=subprocess.PIPE
    )
    side_b = subprocess.Popen(
        _link_side(args, args.b_at, listen=False), text=True, stdout=subprocess.PIPE
    )
    output_a, _ = side_a.communicate()
    output_b, _ = side_b.communicate()
    if side_a.returncode or side_b.returncode:
        print(
            f"linked run failed (a: {side_a.returncode}, b: {side_b.returncode})",
            file=sys.stderr,
        )
        return 2
    _print_json({"a": json.loads(output_a), "b": json.loads(output_b)})
    if socket_path.exists():
        socket_path.unlink()
    return 0


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(prog="courier-emu")
    subparsers = parser.add_subparsers(dest="command", required=True)

    info = subparsers.add_parser("info", help="validate and describe an XMF image")
    info.add_argument("image")

    rom_info = subparsers.add_parser(
        "rom-info",
        help="describe a complete flash ROM image and the map its reset stub sets up",
    )
    rom_info.add_argument("image")

    xmp_info = subparsers.add_parser(
        "xmp-info",
        help="validate and describe an obfuscated ISDN Courier XMP image",
    )
    xmp_info.add_argument("image")

    nac_info = subparsers.add_parser(
        "nac-info",
        help="validate and describe an ISDN Courier NAC record stream",
    )
    nac_info.add_argument("image")

    extract = subparsers.add_parser(
        "extract",
        help="split an XMF into header, DSP, and supervisor, or unpack an XMP or NAC",
    )
    extract.add_argument("image")
    extract.add_argument("directory")

    run = subparsers.add_parser("run", help="execute the 80186 application entry")
    run.add_argument("image")
    run.add_argument(
        "--instructions",
        type=_number,
        default=None,
        help=f"stop after this many instructions (default {DEFAULT_RUN_INSTRUCTIONS:,}, "
        "or effectively unbounded for a console session)",
    )
    run.add_argument(
        "--console",
        action="store_true",
        help="talk to the modem from this terminal while it runs: type AT "
        "commands, Ctrl-] to detach. Input may also be piped in",
    )
    run.add_argument(
        "--serial-pty",
        action="store_true",
        help="expose the DTE port as a pty device instead, for screen, "
        "minicom, or anything else that drives a serial modem",
    )
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
    run.add_argument(
        "--daa-codec",
        action="store_true",
        help="model the silicon DAA as a register file and run the datasheet's "
        "power-up procedure against it from the ASIC side",
    )
    run.add_argument(
        "--daa-codec-line",
        type=int,
        choices=(1, 2),
        default=1,
        help="which line the codec is strapped as, deciding its readiness code "
        "(default 1, which polls for 0x0f)",
    )
    run.add_argument(
        "--daa-codec-rate",
        type=_number,
        default=9_600,
        metavar="HZ",
        help="sample rate programmed into register 40h; unsupported rates are "
        "rounded to the nearest the PLL offers (default 9600)",
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
        "--parameter-sector",
        metavar="PATH",
        help="attach a 4 KiB parameter sector image at 0xf8000; build one with "
        "the `parameters` subcommand",
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
        "--int1-after",
        type=_number,
        metavar="MS",
        help="deliver the external INT1 edge a ROM calibrates its system tick "
        "from, this many milliseconds after reset (what drives it on hardware "
        "is not established; the default of 7 makes the calibrated tick 10 ms)",
    )
    run.add_argument(
        "--line-link",
        metavar="PATH",
        help="share a two-wire line with another instance over this UNIX socket; "
        "implies --with-dsp and supersedes --daa-line",
    )
    run.add_argument(
        "--line-listen",
        action="store_true",
        help="bind the --line-link socket instead of connecting to it",
    )
    run.add_argument(
        "--dip-preset",
        choices=sorted(DIP_PRESETS),
        metavar="NAME",
        help="close a named set of option switches: "
        + "; ".join(
            f"{name} ({', '.join(sorted(switches))})"
            for name, switches in sorted(DIP_PRESETS.items())
        ),
    )
    run.add_argument(
        "--ring",
        action="store_true",
        help="ring the line: drives the ring detector on input port 0x14 with a "
        f"{RING_ON_MS} ms on / {RING_OFF_MS} ms off cadence",
    )
    run.add_argument(
        "--ring-cadence",
        metavar="ON:OFF",
        help=f"ring burst and silence in milliseconds (default {RING_ON_MS}:{RING_OFF_MS})",
    )
    run.add_argument(
        "--ring-start",
        type=_number,
        default=RING_START_MS,
        metavar="MS",
        help=f"milliseconds to wait before the first ring (default {RING_START_MS})",
    )
    run.add_argument(
        "--ring-count",
        type=_number,
        default=0,
        metavar="N",
        help="stop after this many rings (default 0, ring until the run ends)",
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

    link = subparsers.add_parser(
        "link",
        help="run two instances sharing one line, as a dedicated-line pair",
    )
    link.add_argument("image")
    link.add_argument("--instructions", type=_number, default=40_000_000)
    link.add_argument(
        "--socket",
        default=DEFAULT_LINE_SOCKET,
        metavar="PATH",
        help=f"UNIX socket the two instances share (default {DEFAULT_LINE_SOCKET})",
    )
    link.add_argument(
        "--a-at",
        action="append",
        default=[],
        metavar="COMMAND",
        help="AT command for side A; repeatable (default ATA)",
    )
    link.add_argument(
        "--b-at",
        action="append",
        default=[],
        metavar="COMMAND",
        help="AT command for side B; repeatable (default ATA)",
    )
    link.add_argument(
        "--dip-preset",
        choices=sorted(DIP_PRESETS),
        default="dedicated-line",
        metavar="NAME",
        help="option switches for both sides (default dedicated-line)",
    )
    link.add_argument("--board-id", type=_board_id, default=str(DEFAULT_BOARD_ID))
    link.add_argument(
        "--summary",
        action="store_true",
        help="omit individual event records and the final address window",
    )

    parameters = subparsers.add_parser(
        "parameters", help="synthesise a parameter sector image"
    )
    parameters.add_argument("output", help="path to write the 4 KiB sector to")
    parameters.add_argument("--serial", default="", help="serial number, up to 12 characters")
    parameters.add_argument(
        "--feature",
        action="append",
        default=[],
        choices=sorted(FEATURE_BITS),
        metavar="NAME",
        help="enable an ATC8 feature bit; repeatable (" + ", ".join(sorted(FEATURE_BITS)) + ")",
    )
    parameters.add_argument("--country", type=_number, default=0)
    parameters.add_argument("--type1", type=_number, default=30)
    parameters.add_argument("--type2", type=_number, default=7)
    parameters.add_argument("--version", type=_number, default=1)

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
        if args.command == "rom-info":
            _print_json(CourierRom.load(args.image).describe())
            return 0
        if args.command == "xmp-info":
            _print_json(XmpImage.load(args.image).describe())
            return 0
        if args.command == "nac-info":
            _print_json(NacImage.load(args.image).describe())
            return 0
        if args.command == "extract":
            try:
                source: XmfImage | XmpImage | NacImage = XmfImage.load(args.image)
            except XmfFormatError:
                try:
                    source = XmpImage.load(args.image)
                except XmpFormatError:
                    source = NacImage.load(args.image)
            paths = source.extract(args.directory)
            _print_json({"files": [str(path.resolve()) for path in paths]})
            return 0
        if args.command == "run":
            return _run_isolated(args)
        if args.command == "link":
            return _run_linked_pair(args)
        if args.command == "parameters":
            sector = ParameterSector(
                country=args.country,
                features=features_value(args.feature),
                type1=args.type1,
                type2=args.type2,
                serial=args.serial,
                version=args.version,
            )
            sector.save(args.output)
            result = sector.status()
            result["path"] = str(Path(args.output).resolve())
            _print_json(result)
            return 0
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
    except (
        OSError,
        XmfFormatError,
        RomFormatError,
        XmpFormatError,
        NacFormatError,
        ValueError,
        json.JSONDecodeError,
    ) as exc:
        parser.error(str(exc))
    return 1
