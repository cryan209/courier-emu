from __future__ import annotations

import argparse
import contextlib
from concurrent.futures import ThreadPoolExecutor
import json
import os
from pathlib import Path
import signal
import subprocess
import sys

from .parameters import FEATURE_BITS, ParameterSector, features_value
from .codec import DAA_REVISION
from .daa import RING_OFF_MS, RING_ON_MS, RING_START_MS
from .exchange import EXCHANGE_OUTCOMES
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
from . import imodem_config
from .isdn import IsdnMachine
from .bri import (
    ACTIVATE_AT_INSTRUCTIONS, BEARER_UNRESTRICTED_64K,
    CAPABILITY_AUDIO_31KHZ, CAPABILITY_SPEECH, LAW_A, LAW_MU,
    BriNetwork, audio_bearer,
)
from .bearer_sip import BearerSipLine
from .sip import SipConfig, SipSession
from .v120 import LLI_DEFAULT, V120Link
from .isdn_console import (
    SERIAL_LINE_INSTRUCTIONS,
    SERIAL_WARMUP_INSTRUCTIONS,
    interactive_pump,
    raw_terminal,
    scripted_pump,
)
from .sio import (
    CPU_INSTRUCTIONS_PER_SECOND,
    RX_INSTRUCTIONS_PER_BYTE,
    TERMINAL_PRESENT,
    UART_CLOCK_LOW_RATES_HZ,
)

# Only for the help text: one ten-bit frame at the rate the firmware
# starts in, so the default the user reads matches what they will get.
DERIVED_9600_INSTRUCTIONS = (
    CPU_INSTRUCTIONS_PER_SECOND * 16 * 80 * 10 + UART_CLOCK_LOW_RATES_HZ - 1
) // UART_CLOCK_LOW_RATES_HZ
from .nac import NacFormatError, NacImage
from .rom import CourierRom, RomFormatError
from .xmf import XmfFormatError, XmfImage
from .xmp import XmpFormatError, XmpImage

DEFAULT_LINE_SOCKET = "/tmp/courier-line.sock"
DEFAULT_RUN_INSTRUCTIONS = 250_000
DEFAULT_ISDN_INSTRUCTIONS = 20_000_000
# A console session ends when its terminal detaches rather than at a count,
# so this only has to be further away than a session will reach: about four
# hours of emulated execution.
CONSOLE_INSTRUCTIONS = 10_000_000_000
from .dsp import run_dsp
from .machine import SUGGESTED_TICK_MS, TICK_SOURCES
from .terminal import run_console


@contextlib.contextmanager
def _nothing():
    yield


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


def daa_codec_wanted(args: argparse.Namespace, image: object) -> bool:
    """Resolve the codec's three-state flag against what the image can host.

    The board has a DAA, so modelling it is the default. It rides on the DSP
    bridge, though, and a flash ROM carries no separable C52 payload, so the
    default gives way there rather than turning a plain `run` into an error.
    An explicit `--daa-codec` still asks for the impossible and still says so.
    """
    if args.daa_codec is False:
        return False
    if hasattr(image, "dsp_program_segments"):
        return True
    if args.daa_codec:
        raise ValueError(
            f"{Path(args.image).name} carries no separable C52 payload for the "
            "DSP bridge the codec rides on"
        )
    return False


def _worker_command(args: argparse.Namespace) -> list[str]:
    if args.line_audio_only:
        if not args.line_link:
            raise ValueError("--line-audio-only requires --line-link")
        if args.exchange or args.sip_server or args.force_online:
            raise ValueError("--line-audio-only cannot use exchange, SIP, or forced online mode")
    image = load_image(args.image)
    if args.with_dsp and not hasattr(image, "dsp_program_segments"):
        raise ValueError(
            f"{Path(args.image).name} carries no separable C52 payload for the "
            "DSP bridge to load"
        )
    daa_codec = daa_codec_wanted(args, image)
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
    for entry in args.trace_pc:
        command.extend(("--trace-pc", entry))
    for entry in args.peek:
        command.extend(("--peek", entry))
    if args.dsp_trace_range:
        command.extend(("--dsp-trace-range", args.dsp_trace_range))
    for entry in args.dsp_peek:
        command.extend(("--dsp-peek", entry))
    if args.dsp_write_watch:
        command.extend(("--dsp-write-watch", args.dsp_write_watch))
    if args.mem_watch:
        command.extend(("--mem-watch", args.mem_watch))
    if args.real_delays:
        command.append("--real-delays")
    if args.track_executed:
        command.append("--track-executed")
    if (
        args.with_dsp
        or args.daa_line
        or args.sip_server
        or args.line_link
        or args.exchange
        or daa_codec
        or args.force_online
    ):
        command.append("--with-dsp")
    if args.force_online:
        command.append("--force-online")
    if args.dsp_batch != 256:
        command.extend(("--dsp-batch", str(args.dsp_batch)))
    if daa_codec:
        command.append("--daa-codec")
        command.extend(("--daa-codec-line", str(args.daa_codec_line)))
        command.extend(("--daa-codec-rate", str(args.daa_codec_rate)))
        command.extend(("--daa-codec-revision", str(args.daa_codec_revision)))
    if args.line_link:
        command.extend(("--line-link", str(args.line_link)))
        if args.line_audio_only:
            command.append("--line-audio-only")
        if args.line_record:
            command.extend(("--line-record", str(Path(args.line_record).resolve())))
        if args.line_listen:
            command.append("--line-listen")
    # A linked instance always needs a DAA: the link drives its line state
    # frame by frame, starting from a line with nothing on the far end.
    daa_line = args.daa_line or ("dial-tone" if args.sip_server else None)
    if daa_line is None and args.line_link:
        daa_line = "disconnected"
    # An exchange needs a DAA too, and starts it from a line with nothing on
    # it: what the loop carries is the exchange's to decide from there.
    if daa_line is None and args.exchange:
        daa_line = "quiet"
    if daa_line:
        command.extend(("--daa-line", daa_line))
    if args.exchange:
        command.append("--exchange")
        if not args.tick_source:
            # A modeled line hands the call back to the firmware, and the
            # firmware's dial-tone wait, digit duration and interdigit gap all
            # count on the supervisor's countdown chain. Unpaced, the harness
            # has to stand in for every one of them, which is the arrangement
            # the exchange exists to replace.
            command.extend(("--tick-source", "dsp"))
        for entry in args.exchange_number:
            command.extend(("--exchange-number", entry))
        command.extend(("--exchange-outcome", args.exchange_outcome))
        command.extend(("--exchange-answer-after", str(args.exchange_answer_after)))
        command.extend(("--exchange-answer-tone", str(args.exchange_answer_tone)))
        command.extend(("--exchange-dial-tone", args.exchange_dial_tone))
        if args.exchange_hotline:
            command.append("--exchange-hotline")
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
    if args.nvram_fixture:
        command.extend(("--nvram-fixture", args.nvram_fixture))
    if args.parameter_sector:
        command.extend(("--parameter-sector", str(Path(args.parameter_sector).resolve())))
    if args.parameter_flash:
        command.extend(("--parameter-flash", str(Path(args.parameter_flash).resolve())))
    if args.tick_ms is not None:
        command.extend(("--tick-ms", str(args.tick_ms)))
    if args.frame_hz is not None:
        command.extend(("--frame-hz", str(args.frame_hz)))
    if args.tick_source:
        command.extend(("--tick-source", args.tick_source))
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
    if args.line_audio_only:
        command.append("--line-audio-only")
    if args.audio_dir:
        prefix = Path(args.audio_dir).resolve() / ("a" if listen else "b")
        command.extend(("--line-record", str(prefix)))
    if args.tick_ms is not None:
        command.extend(("--tick-ms", str(args.tick_ms)))
    if args.tick_source:
        command.extend(("--tick-source", args.tick_source))
    if args.dsp_batch != 256:
        command.extend(("--dsp-batch", str(args.dsp_batch)))
    if args.nvram_fixture:
        # 403 reads its transmit levels out of the settings EEPROM; without
        # the fixture both sides dial into silence.
        command.extend(("--nvram-fixture", args.nvram_fixture))
    if args.with_dsp:
        command.append("--with-dsp")
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
    # load_image, not XmfImage.load: the pair is worth running on the ROM
    # images most of all, and XmfImage.load refuses them.
    load_image(args.image)

    # Either side may reach the socket first; the connecting side retries
    # until the listening side has bound and listened.
    side_a = subprocess.Popen(
        _link_side(args, args.a_at, listen=True), text=True, stdout=subprocess.PIPE
    )
    side_b = subprocess.Popen(
        _link_side(args, args.b_at, listen=False), text=True, stdout=subprocess.PIPE
    )
    # Drain both stdout pipes concurrently.  Waiting for A before reading B
    # can deadlock once B's JSON report fills its pipe while A is blocked on
    # the shared line socket.
    with ThreadPoolExecutor(max_workers=2) as pool:
        result_a = pool.submit(side_a.communicate)
        result_b = pool.submit(side_b.communicate)
        output_a, _ = result_a.result()
        output_b, _ = result_b.result()
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

    recovery = subparsers.add_parser(
        "recovery-run", help="trace the read-only SV25 80188 recovery loader to its SDL prompt"
    )
    recovery.add_argument("image")
    recovery.add_argument("--instructions", type=_number, default=6_000_000)
    recovery.add_argument("--no-serial-stimulus", action="store_true",
                          help="stop at the command wait without supplying emulated AT~X! input")
    recovery.add_argument("--libunicorn", help="directory containing a custom libunicorn library")

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

    isdn_run = subparsers.add_parser(
        "isdn-run",
        help="execute the ISDN Courier 386 payload with its PC-AT peripherals",
    )
    isdn_run.add_argument("image")
    isdn_run.add_argument(
        "--instructions",
        type=_number,
        default=None,
        help=f"stop after this many instructions (default "
             f"{DEFAULT_ISDN_INSTRUCTIONS:,}, or run until Ctrl-] in terminal mode)",
    )
    isdn_run.add_argument("--with-dsp", action="store_true",
                          help="execute the downloaded DSP with the native C5x core")
    isdn_run.add_argument(
        "--entry",
        default=None,
        metavar="SEGMENT:OFFSET",
        help="override the recovered initialiser at 4030:0000",
    )
    isdn_run.add_argument(
        "--tick-irq",
        type=_number,
        default=None,
        help="IRQ line the 8254's counter 0 drives; the sweep points at 10",
    )
    isdn_run.add_argument(
        "--port",
        action="append",
        default=[],
        metavar="PORT=VALUE",
        help="seed an input port value; numbers accept 0x notation",
    )
    isdn_run.add_argument(
        "--send",
        action="append",
        default=[],
        metavar="TEXT",
        help="type TEXT on SIO0 once the firmware is up; repeat for more "
             "lines. A trailing carriage return is added unless the text "
             "already ends in one; \\r, \\n and \\\\ are recognised",
    )
    isdn_run.add_argument(
        "--send-after",
        type=_number,
        default=SERIAL_WARMUP_INSTRUCTIONS,
        help="instructions to run before the first --send line is typed",
    )
    isdn_run.add_argument(
        "--send-every",
        type=_number,
        default=SERIAL_LINE_INSTRUCTIONS,
        help="instructions between one --send line and the next",
    )
    isdn_run.add_argument(
        "--serial-pace",
        type=_number,
        default=None,
        help="override the instructions per serial character. By default the "
             "interval is derived from the divisor the firmware programmes "
             "and the clock it selects at 0xf836, which at its own 9600 8-bit "
             f"default is about {DERIVED_9600_INSTRUCTIONS:,} instructions. "
             f"{RX_INSTRUCTIONS_PER_BYTE} is the value the harness used "
             "before that clock was recovered; use 0 for an immediate burst",
    )
    isdn_run.add_argument(
        "--serial-signals",
        type=_number,
        default=TERMINAL_PRESENT,
        help="modem-status inputs the firmware sees: CTS 0x10, DSR 0x20, "
             "RI 0x40, DCD 0x80",
    )
    isdn_run.add_argument(
        "--product-type",
        choices=("external", "internal", "undefined"),
        default="external",
        help="which enclosure the board probe finds, by how the sense line at "
             "port 0x14 is strapped: external and internal make the firmware's "
             "own probe store 0x22 and 0x28, and undefined leaves the sense "
             "dead so the probe abandons, as it did before it was modelled. "
             "Rackmount is a bit ATI7 can name but the probe has no verdict "
             "for. Note the internal card moves the AT port to the 16550 at "
             "0x80 on IRQ0 (default: external)",
    )
    isdn_run.add_argument(
        "--product-modem",
        action=argparse.BooleanOptionalAction,
        default=False,
        help="append ' MODEM' to ATI7's product type (default: disabled)",
    )
    isdn_run.add_argument(
        "--line-activate",
        type=_number,
        metavar="INSTRUCTIONS",
        help="bring the S interface up at this point in the run, walking the "
             "I.430 states the way the network does. Without it the line "
             "stays in F1 and the firmware reports Physical Interface "
             "Inactive, which is what ATI12 says today",
    )
    isdn_run.add_argument(
        "--dipswitch",
        action="append",
        default=[],
        metavar="N=on|off",
        help="set one of the board's DIP switches, e.g. 1=off. The firmware "
             "reads two of them, both bits of port 0x12, through the signal "
             "id table its own DIPSWITCH display uses; both default to on, "
             "which is what the port read as before it was modelled. Switch 1 "
             "off stops the modem answering the AT interface at all",
    )
    isdn_run.add_argument(
        "--offhook-at",
        type=_number,
        metavar="INSTRUCTIONS",
        help="lift the handset on the analogue port at this point. The "
             "Am79C30's LSR carries the hook switch in bits 7:6 - a change "
             "indication and the state - and the firmware's own trace log "
             "prints STAT_OFFHOOK when it sees it. Without this the handset "
             "rests on hook, which is what the part reported before the bits "
             "were modelled",
    )
    isdn_run.add_argument(
        "--bri-network",
        action="store_true",
        help="put an NT and a switch on the far side of the S interface: "
             "Q.921 and Q.931, driven only through the Am79C30A's receive "
             "and transmit buffers. Without it the D channel has nobody on "
             "it, and a point-to-point terminal waiting for the network to "
             "establish the data link waits forever",
    )
    isdn_run.add_argument(
        "--bri-establish",
        choices=("network", "terminal"),
        default="network",
        help="which end establishes the data link. A point-to-point line "
             "has the network send SABME to the terminal's fixed TEI; a "
             "multipoint one has the terminal establish once it has been "
             "assigned a TEI, and the peer waits for it (default: network)",
    )
    isdn_run.add_argument(
        "--bri-tei",
        type=_number,
        default=0,
        help="the TEI the network addresses on a point-to-point line "
             "(default: 0, the fixed value a point-to-point terminal uses)",
    )
    isdn_run.add_argument(
        "--bri-call-at",
        type=_number,
        metavar="INSTRUCTIONS",
        help="place a call at the modem at this point in the run, once the "
             "data link is up: a Q.931 SETUP carrying a calling party number",
    )
    isdn_run.add_argument(
        "--bri-activate",
        action=argparse.BooleanOptionalAction,
        default=True,
        help="let the NT terminate the S bus and bring it up, walking the "
             "terminal through F2, F6 and F7 the way INFO2 and INFO4 do "
             f"(default: at {ACTIVATE_AT_INSTRUCTIONS:,} instructions, or "
             "wherever --line-activate names). --no-bri-activate leaves the "
             "line to whoever else is driving it",
    )
    isdn_run.add_argument(
        "--bri-deactivate-at",
        type=_number,
        metavar="INSTRUCTIONS",
        help="have the NT drop the line at this point, back to F3, so a run "
             "can see what the firmware does when the network goes away",
    )
    isdn_run.add_argument(
        "--bri-law",
        choices=("mu", "a"),
        default="mu",
        help="the G.711 companding law an audio or speech call offers in its "
             "bearer capability. The I-modem takes mu-law and clears an "
             "A-law call with cause 88 (default: mu)",
    )
    isdn_run.add_argument(
        "--bri-bearer",
        choices=("data", "audio", "speech"),
        default="data",
        help="the bearer capability --bri-call-at offers. 'data' is "
             "unrestricted 64 kbit/s, the digital call V.120 and friends run "
             "on; 'audio' is 3.1 kHz audio and 'speech' is speech, both "
             "companded G.711, which is what a modem answers as a modem - the "
             "B channel as a 64 kbit/s audio bearer with the datapump on it"
    )
    isdn_run.add_argument(
        "--bri-call-to",
        default="",
        help="the called party number --bri-call-at presents, if any",
    )
    isdn_run.add_argument(
        "--bri-call-from",
        default="5551000",
        help="the calling party number --bri-call-at presents "
             "(default: 5551000)",
    )
    isdn_run.add_argument(
        "--bri-sip",
        metavar="HOST[:PORT]",
        help="put a SIP call at the far end of the B channel. The bearer is "
             "G.711 at 8 kHz and so is RTP's PCMU payload, so the octets pass "
             "through untouched - no resampling and no companding conversion, "
             "which is what a V.90 or x2 datapump needs",
    )
    isdn_run.add_argument("--bri-sip-username", default="courier")
    isdn_run.add_argument(
        "--bri-sip-password-env",
        default="COURIER_SIP_PASSWORD",
        metavar="NAME",
        help="environment variable holding the SIP password, which is never "
             "taken on the command line (default: COURIER_SIP_PASSWORD)",
    )
    isdn_run.add_argument(
        "--bri-sip-target",
        metavar="NUMBER",
        help="the number to INVITE once the ISDN call is up",
    )
    isdn_run.add_argument("--bri-sip-local-port", type=_number, default=0)
    isdn_run.add_argument(
        "--bri-v120",
        action="store_true",
        help="speak V.120 rate adaption on the B channel once the call is "
             "active, instead of leaving the bearer opaque: HDLC framing, the "
             "logical link identifier, and the Q.921 procedures the modem "
             "answers a call expecting",
    )
    isdn_run.add_argument(
        "--bri-v120-lli",
        type=_number,
        default=None,
        metavar="N",
        help="the logical link identifier to establish (default: 256, the "
             "default link)",
    )
    isdn_run.add_argument(
        "--bri-v120-establish",
        choices=("network", "terminal"),
        default="network",
        help="which end sends SABME on the B channel (default: network, the "
             "end that placed the call)",
    )
    isdn_run.add_argument(
        "--bri-v120-header",
        default=None,
        metavar="HEX",
        help="the terminal adaption header octets an I frame carries, as hex "
             "(default: 83). The firmware logs its own verdict on them as "
             "'V120 parse failed, ret_code=', which is what this is for",
    )
    isdn_run.add_argument(
        "--bri-v120-llc",
        default=None,
        metavar="HEX",
        help="offer the V.120 rate adaption in the SETUP's low layer "
             "compatibility element, as the hex of octets 5a and 5b (try "
             "1080). The modem parses this and clears the call rather than "
             "answering it, so it is a probe, not a setting; without it the "
             "SETUP names only the bearer",
    )
    isdn_run.add_argument(
        "--bri-v120-msb-first",
        action="store_true",
        help="put each octet on the B channel most significant bit first. "
             "HDLC says least, and the flag is a palindrome either way, but "
             "the modem's receive handler reverses octets on a configuration "
             "bit, so the peer can be asked to do it the other way round",
    )
    isdn_run.add_argument(
        "--bri-v120-send",
        action="append",
        default=None,
        metavar="TEXT",
        help="send TEXT to the modem as V.120 user data once the link is up; "
             "repeat for more frames",
    )
    isdn_run.add_argument(
        "--bri-rx-g711",
        metavar="FILE",
        help="queue an opaque 8 kHz B-channel octet stream from the virtual "
             "switch to the modem once the call is active",
    )
    isdn_run.add_argument(
        "--bri-tx-g711",
        metavar="FILE",
        help="save the B-channel octets emitted by the modem while the "
             "virtual-switch call is active",
    )
    isdn_run.add_argument(
        "--flash-overlay",
        metavar="ADDR=FILE",
        help="lay a file over the flash window before the run, e.g. "
             "0xf8000=config.bin. The update payload stops at 0xf8000, so "
             "the part's top sectors read erased without this - and one of "
             "them is where the modem keeps its configuration",
    )
    isdn_run.add_argument(
        "--flash-nvram",
        metavar="FILE",
        default=imodem_config.DEFAULT_NVRAM_FILE,
        help="the part's non-volatile store: the 32 KiB above the update "
             f"payload, CPU {imodem_config.NVRAM_BASE:#x}-0xfffff, which is "
             "where the firmware keeps its configuration record. Loaded over "
             "the flash window before the run if the file exists, and written "
             "back after it, so AT&W survives to the next boot (default: "
             f"{imodem_config.DEFAULT_NVRAM_FILE}). --no-flash-nvram runs "
             "against an erased store and keeps nothing",
    )
    isdn_run.add_argument(
        "--no-flash-nvram",
        dest="flash_nvram",
        action="store_const",
        const=None,
        help=argparse.SUPPRESS,
    )
    isdn_run.add_argument(
        "--flash-save",
        metavar="FILE",
        help="write the flash window out after the run, so a session that "
             "changes settings can be booted again with them in place",
    )
    isdn_run.add_argument(
        "--terminal",
        action="store_true",
        help="attach this terminal to SIO0: keystrokes go to the firmware "
             "and its output is printed as it arrives. Ctrl-] detaches",
    )
    isdn_run.add_argument(
        "--local-echo",
        action=argparse.BooleanOptionalAction,
        default=True,
        help="echo what you type in --terminal mode. The modem does not: its "
             "only character echo is in the serial ISR and is gated on the "
             "Internal enclosure bit, so an external unit never echoes, and "
             "raw mode has already turned the terminal's own echo off. "
             "--no-local-echo shows the literal stream instead",
    )
    isdn_run.add_argument(
        "--report",
        action="store_true",
        help="print the diagnostic JSON report after a terminal session",
    )

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
        "--trace-pc",
        action="append",
        default=[],
        metavar="ADDR[=NAME]",
        help="record 80186 registers each time this physical address executes, "
        "hex, repeatable. hot_addresses is a top-20 profile and cannot say "
        "whether a given branch ran at all",
    )
    run.add_argument(
        "--peek",
        action="append",
        default=[],
        metavar="ADDR[=NAME]",
        help="report this byte cell's final value, hex, repeatable. The board's "
        "own ATGLK2 reads the same addresses, so the two compare directly",
    )
    run.add_argument(
        "--dsp-trace-range",
        default="",
        metavar="FIRST:LAST",
        help="also trace C52 program addresses in this range, hex. Two windows "
        "are compiled in; this is a third, for a handler neither covers",
    )
    run.add_argument(
        "--dsp-peek",
        action="append",
        default=[],
        metavar="ADDR[=NAME]",
        help="report this C52 data cell at the end of the run, hex, repeatable",
    )
    run.add_argument(
        "--dsp-write-watch",
        default="",
        metavar="ADDR",
        help="record every write to this C52 data cell, hex, with the program "
        "address that made it. Unfiltered the trace fills in milliseconds",
    )
    run.add_argument(
        "--mem-watch",
        default="",
        metavar="FIRST:LAST",
        help="record 80186 memory writes in this physical range, hex, with the "
        "program address that made each",
    )
    run.add_argument(
        "--frame-hz",
        type=_number,
        default=None,
        metavar="HZ",
        help="rate to raise the board's INT0 frame edge at. The board was "
        "measured at 2401 (artifacts/coop-int0-02); the default is the 391 the "
        "rest of the harness is consistent with, and the difference between "
        "them is an open fault, not a preference",
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
        "--track-executed",
        action="store_true",
        help="count how often each address runs, for the hot_addresses report",
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
        "--force-online",
        action="store_true",
        help="diagnostic only: publish CONNECT and enter DTE data mode at main-loop",
    )
    run.add_argument(
        "--dsp-batch",
        type=_number,
        default=256,
        metavar="N",
        help="80186 instructions per native C52 scheduling batch (diagnostic; default 256)",
    )
    run.add_argument(
        "--daa-line",
        choices=("disconnected", "quiet", "dial-tone", "ringing"),
        help="attach a behavioral DAA line source (use dial-tone for an originating call)",
    )
    run.add_argument(
        "--daa-codec",
        action=argparse.BooleanOptionalAction,
        default=None,
        help="model the silicon DAA as a register file and run the datasheet's "
        "power-up procedure against it from the ASIC side. On by default for "
        "images the DSP bridge can host, since the board has a DAA and ATI7 "
        "reports a failure without one; --no-daa-codec turns it off",
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
    run.add_argument(
        "--daa-codec-revision",
        type=_number,
        default=DAA_REVISION,
        metavar="WORD",
        help="revision the codec reports at power up, which ATI7 prints as "
        f"'DAA rev' (default {DAA_REVISION}; zero is what the firmware calls "
        "a DAA failure)",
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
        "--tick-ms",
        type=_number,
        metavar="MS",
        help="drive the board's periodic edge on vector 0x0f with this period "
        "in milliseconds. The supervisor's countdown chain hangs off it, so "
        "without it every firmware timeout waits forever and ATI10 and ATI11 "
        f"never finish; {SUGGESTED_TICK_MS} makes them answer. Off by default "
        "because it also changes call timing",
    )
    run.add_argument(
        "--tick-source",
        choices=TICK_SOURCES,
        help="pace that same edge off the DSP frame interrupt instead of off "
        "a period. This is the one arrangement that leaves both of the "
        "firmware's mutual watchdogs quiet, and it runs the countdown chain "
        "the line-detector poller lives on. Off by default: the 1:1 ratio is "
        "a choice inside the band the watchdogs allow, not a measurement",
    )
    run.add_argument(
        "--parameter-flash",
        metavar="PATH",
        help="attach the 16 KiB parameter flash the update image does not "
        "carry, and answer the boot block's erase and program services with "
        "it, so AT&W stores a profile that survives the run (created erased "
        "if absent)",
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
        "--exchange",
        action="store_true",
        help="put a modeled central office on the line instead of a fixed DAA "
        "state: it plays dial tone, decodes the digits the modem dials into "
        "the line, and returns ringback, busy or answer tone. Implies "
        "--with-dsp",
    )
    run.add_argument(
        "--exchange-number",
        action="append",
        default=[],
        metavar="NUMBER=OUTCOME",
        help="route one dialed number to " + ", ".join(EXCHANGE_OUTCOMES)
        + "; repeatable",
    )
    run.add_argument(
        "--exchange-outcome",
        choices=EXCHANGE_OUTCOMES,
        default="answer",
        help="what the exchange does with a number it has no route for "
        "(default answer)",
    )
    run.add_argument(
        "--exchange-answer-after",
        type=_number,
        default=2,
        metavar="RINGS",
        help="ringback cycles before the far end picks up (default 2)",
    )
    run.add_argument(
        "--exchange-answer-tone",
        type=_number,
        default=3_000,
        metavar="MS",
        help="how long the answered call carries 2100 Hz answer tone before "
        "the exchange hands it to the far end (default 3000; 0 skips it)",
    )
    run.add_argument(
        "--exchange-dial-tone",
        choices=("auto", "us", "nz", "uk", "eu"),
        default="auto",
        help="what the loop carries as dial tone: us 350+440 (North American "
        "precise), nz 400, uk 350+450, eu 425. A detector tuned for one does "
        "not answer another, and the ID_SDL builds retuned theirs - auto, the "
        "default, gives each image the tone its own DSP answers",
    )
    run.add_argument(
        "--exchange-hotline",
        action="store_true",
        help="answer on seizure with no dial tone and no digits, the way a "
        "private-ringdown circuit does. Use it to reach the online state "
        "without the modem having to dial",
    )
    run.add_argument(
        "--line-listen",
        action="store_true",
        help="bind the --line-link socket instead of connecting to it",
    )
    run.add_argument("--line-audio-only", action="store_true",
                     help="PCM-only socket; disable synthetic training and carrier events (both ends must use it)")
    run.add_argument("--line-record", metavar="PREFIX",
                     help="record socket audio as PREFIX-tx.wav and PREFIX-rx.wav")
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
    nvram_source = run.add_mutually_exclusive_group()
    nvram_source.add_argument(
        "--nvram",
        metavar="PATH",
        help="attach the 512-byte board settings EEPROM image (created if absent)",
    )
    nvram_source.add_argument(
        "--nvram-fixture",
        choices=("idsdl302", "idsdl403"),
        metavar="NAME",
        help="attach a deterministic, in-memory settings EEPROM fixture; "
        "idsdl302 seeds words 94 through 102 from the recovered six records "
        "and the +S register block AT+SF loads, leaving the rest erased. "
        "idsdl403 seeds the board's own +S block at the offset 7.4.16 reads "
        "it from, and nothing else",
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
    link.add_argument("--line-audio-only", action="store_true",
                      help="connect both instances using PCM only, without synthetic training or carrier events")
    link.add_argument("--audio-dir", metavar="DIR",
                      help="record both sides' socket audio as a/b-tx/rx.wav in this directory")
    link.add_argument("--instructions", type=_number, default=40_000_000)
    link.add_argument(
        "--nvram-fixture",
        choices=("idsdl302", "idsdl403"),
        metavar="NAME",
        help="settings EEPROM fixture for both sides; idsdl403 carries the "
        "transmit levels 7.4.16 reads",
    )
    link.add_argument(
        "--with-dsp",
        action="store_true",
        help="run the C52 on both sides",
    )
    link.add_argument("--dsp-batch", type=_number, default=256, metavar="N")
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
    link.add_argument("--tick-ms", type=_number, default=None, metavar="MS")
    link.add_argument(
        "--tick-source",
        choices=TICK_SOURCES,
        help="pace the supervisor's countdown chain off the DSP frame "
        "interrupt on both sides",
    )
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
    parameters.add_argument(
        "--flags",
        type=_number,
        default=0x08,
        help="the gate byte at sector offset 0. Each field is applied "
        "when its bit is clear: bit 0 feature decode, 1 country, 2 type2, "
        "3 type1. Clearing bit 3 puts type1 in [0x0a03], whose bit 0x04 is "
        "what makes ATY15 print the switch page (default 0x08)",
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
        if args.command == "recovery-run":
            if args.instructions <= 0:
                raise ValueError("instruction limit must be positive")
            command = [sys.executable, "-m", "courier_emu.recovery", args.image,
                       "--instructions", str(args.instructions)]
            if args.no_serial_stimulus:
                command.append("--no-serial-stimulus")
            environment = os.environ.copy()
            if args.libunicorn:
                environment["LIBUNICORN_PATH"] = str(Path(args.libunicorn).resolve())
            # Keep native execution behind the same process boundary as run.
            completed = subprocess.run(command, env=environment)
            if completed.returncode < 0:
                _print_json({"status": "native-error", "error":
                             f"recovery worker terminated by signal {-completed.returncode}"})
                return 1
            return completed.returncode
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
        if args.command == "isdn-run":
            instructions = args.instructions
            if instructions is None:
                instructions = (
                    CONSOLE_INSTRUCTIONS if args.terminal
                    else DEFAULT_ISDN_INSTRUCTIONS
                )
            if instructions <= 0:
                raise ValueError("instruction limit must be positive")
            try:
                source: NacImage | XmpImage = NacImage.load(args.image)
            except NacFormatError:
                source = XmpImage.load(args.image)
            ports: dict[int, int] = {}
            for assignment in args.port:
                key, separator, value = assignment.partition("=")
                if not separator:
                    raise ValueError(f"invalid port assignment: {assignment!r}")
                ports[_number(key)] = _number(value)
            entry = {}
            if args.entry:
                segment, separator, offset = args.entry.partition(":")
                if not separator:
                    raise ValueError(f"invalid entry point: {args.entry!r}")
                entry = {
                    "entry_segment": int(segment, 16),
                    "entry_offset": int(offset, 16),
                }
            counter_irq = None if args.tick_irq is None else {0: args.tick_irq}
            overlay = None
            if args.flash_overlay:
                where, separator, overlay_path = args.flash_overlay.partition("=")
                if not separator:
                    raise ValueError(
                        f"invalid flash overlay: {args.flash_overlay!r}, "
                        "expected ADDR=FILE"
                    )
                overlay = (_number(where), Path(overlay_path).read_bytes())
            nvram = (
                imodem_config.load_nvram(args.flash_nvram)
                if args.flash_nvram else None
            )
            dipswitches: dict[int, bool] = {}
            for setting in args.dipswitch:
                number, separator, state = setting.partition("=")
                if not separator or state not in ("on", "off"):
                    raise ValueError(
                        f"invalid dipswitch: {setting!r}, expected N=on|off"
                    )
                dipswitches[_number(number)] = state == "on"
            bri = None
            if args.bri_network:
                bri = BriNetwork(
                    establish=args.bri_establish, tei=args.bri_tei,
                    call_at=args.bri_call_at, call_from=args.bri_call_from,
                    call_to=args.bri_call_to,
                    bearer=(
                        BEARER_UNRESTRICTED_64K if args.bri_bearer == "data"
                        else audio_bearer(
                            CAPABILITY_SPEECH if args.bri_bearer == "speech"
                            else CAPABILITY_AUDIO_31KHZ,
                            LAW_A if args.bri_law == "a" else LAW_MU,
                        )
                    ),
                    # --line-activate names when the line comes up whether or
                    # not a peer is driving it, so it stays the control: with
                    # a peer it is the NT's activation point rather than a
                    # scripted walk. --no-bri-activate leaves the line alone.
                    activate_at=(ACTIVATE_AT_INSTRUCTIONS
                                 if args.line_activate is None
                                 else args.line_activate)
                    if args.bri_activate else None,
                    deactivate_at=args.bri_deactivate_at,
                )
                if args.bri_sip:
                    if args.bri_v120:
                        raise ValueError(
                            "--bri-sip and --bri-v120 are two different far "
                            "ends for one B channel; use one"
                        )
                    bri.media_peer = BearerSipLine(
                        SipSession(SipConfig(
                            server=args.bri_sip,
                            username=args.bri_sip_username,
                            password=os.environ.get(
                                args.bri_sip_password_env, ""),
                            local_port=args.bri_sip_local_port,
                        )),
                        target=args.bri_sip_target or "",
                    )
                if args.bri_v120:
                    bri.v120 = V120Link(
                        lli=(LLI_DEFAULT if args.bri_v120_lli is None
                             else args.bri_v120_lli),
                        establish=args.bri_v120_establish == "network",
                        header=(b"\x83" if args.bri_v120_header is None
                                else bytes.fromhex(args.bri_v120_header)),
                        llc=(None if args.bri_v120_llc is None
                             else bytes.fromhex(args.bri_v120_llc)),
                        lsb_first=not args.bri_v120_msb_first,
                        note=bri._note,
                    )
                    for text in args.bri_v120_send or ():
                        bri.v120.send(text.encode())
                elif args.bri_v120_send:
                    raise ValueError("--bri-v120-send requires --bri-v120")
                if args.bri_rx_g711:
                    bri.queue_media(Path(args.bri_rx_g711).read_bytes())
            elif args.bri_rx_g711 or args.bri_tx_g711:
                raise ValueError("--bri-rx-g711/--bri-tx-g711 require --bri-network")
            if args.terminal and args.send:
                raise ValueError("use --terminal or --send, not both")
            transcript: list[tuple[int, str, str]] = []
            pump = None
            if args.send:
                pump = scripted_pump(
                    args.send, after=args.send_after, every=args.send_every,
                    transcript=transcript,
                )
            elif args.terminal:
                pump = interactive_pump(
                    after=args.send_after,
                    local_echo=args.local_echo,
                    ready_notice=sys.stderr,
                )
            machine = IsdnMachine(
                source, port_values=ports, counter_irq=counter_irq,
                with_dsp=args.with_dsp, serial_pump=pump,
                serial_pace=args.serial_pace,
                serial_signals=args.serial_signals,
                product_type=args.product_type,
                # A terminal session wants responsiveness, not a profile --
                # unless one was asked for, since hot_addresses comes from it.
                profile=not args.terminal or args.report,
                product_modem=args.product_modem,
                line_activate=args.line_activate,
                flash_overlay=overlay,
                flash_nvram=nvram,
                bri=bri,
                dipswitches=dipswitches,
                offhook_at=args.offhook_at,
                **entry
            )
            try:
                with raw_terminal() if args.terminal else _nothing():
                    result = machine.run(instructions).to_dict()
            finally:
                if args.with_dsp:
                    machine.mailbox.close()
            if args.flash_save:
                Path(args.flash_save).write_bytes(bytes(machine.flash.contents))
            if args.bri_tx_g711:
                Path(args.bri_tx_g711).write_bytes(bytes(bri.media_tx))
            if args.flash_nvram:
                # After the run, not during: the firmware erases the sector
                # before it rewrites it, so a store written mid-erase would
                # be the blank the part passes through rather than a record.
                imodem_config.save_nvram(args.flash_nvram,
                                         bytes(machine.flash.contents))
            if transcript:
                result["serial_session"] = [
                    {"instructions": count, "direction": direction, "text": text}
                    for count, direction, text in transcript
                ]
            if args.terminal and args.report:
                # stdout is the serial stream in this mode, so an explicitly
                # requested report goes beside it rather than into it.
                print(json.dumps(result, indent=2, sort_keys=True),
                      file=sys.stderr)
            elif not args.terminal:
                _print_json(result)
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
                flags=args.flags,
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
