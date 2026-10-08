#!/usr/bin/env python3
"""Put an emulated I-modem B channel directly on an analog Courier's line."""

from __future__ import annotations

import argparse
from contextlib import ExitStack
from hashlib import sha256
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import sys
import tempfile

# A 100 ms exchange plus a full receive reserve delays the analog caller's
# training response past the first x2 transition. Keep the general line
# default unchanged; select a lower transit delay for this paired CLI.
if __name__ == "__main__":
    os.environ.setdefault("COURIER_LINE_FRAME_MS", "20")

from courier_emu.bearer_line import BearerLineLink
from courier_emu.bri import BriNetwork
from courier_emu.isdn import IsdnMachine
from courier_emu.isdn_console import _on_the_wire, scripted_pump
from courier_emu.line import LineLink
from courier_emu.nac import NacImage
from courier_emu.timebase import ASIC_DSP_CLOCK_HZ


ROOT = Path(__file__).resolve().parents[1]
DEFAULT_IMODEM = ROOT / "Ie030002.nac"
DEFAULT_ANALOG = (
    ROOT / "artifacts/courier-board-21210-capture-403/courier-board.rom"
)
PROTOCOL_S58 = {"default": None, "x2": 32, "v90": 1, "v34": 33, "bell103": None}


class OverlayAudit:
    """Observe the CPU transport and read back before its completion strobe.

    The supervisor polls both half-block acknowledgements before completion,
    so the native BLDP writes must already be visible at this boundary.
    This observer never publishes program words or changes handshake state.
    """

    def __init__(self, endpoint):
        self.endpoint = endpoint
        self.original_write = endpoint.write
        self.payload = bytearray()
        self.origin = None
        self.records = []

    def write(self, port, value):
        endpoint = self.endpoint
        if port == 0x1e and endpoint.core and not endpoint.reset_status:
            strobe = value & 7
            if strobe in (1, 2):
                if not self.payload:
                    self.origin = endpoint.core.data(0x0bff)
                base = 0x40 if strobe == 1 else 0x48
                for offset in (0, 4):
                    self.payload.extend(endpoint._word(base + offset).to_bytes(2, "little"))
            elif strobe == 4 and self.payload:
                words = len(self.payload) // 2
                actual = b"".join(endpoint.core.program((self.origin + i) & 0xffff)
                                  .to_bytes(2, "little") for i in range(words))
                mismatches = [i for i in range(words)
                              if actual[2*i:2*i+2] != self.payload[2*i:2*i+2]]
                self.records.append({
                    "origin": self.origin, "words": words,
                    "destination_after": endpoint.core.data(0x0bff),
                    "expected_destination_after": (self.origin + words) & 0xffff,
                    "dsp_status": endpoint.core.io(0x57),
                    "dsp_pc": endpoint.core.state()["pc"],
                    "mismatched_words": len(mismatches),
                    "first_mismatch_addresses": [self.origin + i for i in mismatches[:16]],
                    "transport_sha256": sha256(self.payload).hexdigest(),
                    "program_sha256": sha256(actual).hexdigest(),
                })
                self.payload.clear()
                self.origin = None
        return self.original_write(port, value)


def stop_child(process: subprocess.Popen) -> None:
    """Retire our Courier worker if the I-modem or socket failed first."""
    if process.poll() is None:
        process.terminate()
        try:
            process.communicate(timeout=5)
        except subprocess.TimeoutExpired:
            process.kill()
            process.communicate()


def carrier_connected(serial: str, *, complete: bool = False) -> bool:
    ending = r"\r\n" if complete else r"(?:[\r\n]|$)"
    return re.search(
        r"(?:^|[\r\n])CONNECT(?: +[0-9]+)?(?:/[A-Z0-9./ -]+)?" + ending,
        serial,
        re.IGNORECASE,
    ) is not None


def analog_terminal_text(result: dict) -> str:
    # This ROM's DTE uses 7E1. In normal mode it preserves the remote
    # terminal's parity bit in received payload, unlike its Hayes formatter.
    # Keep the original wire bytes in result.serial_hex for inspection.
    return bytes(value & 0x7f for value in
                 bytes.fromhex(result["serial_hex"])).decode("ascii")


def connection_rate_bps(serial: str) -> int | None:
    """Read this terminal's native rate; bare CONNECT supplies no rate."""
    match = re.search(r"(?:^|[\r\n])CONNECT +([0-9]+)(?:/[^\r\n]*)?\r\n",
                      serial, re.IGNORECASE)
    return int(match.group(1)) if match else None


def parser() -> argparse.ArgumentParser:
    result = argparse.ArgumentParser(description=__doc__)
    result.add_argument("--imodem", type=Path, default=DEFAULT_IMODEM)
    result.add_argument("--imodem-nvram", type=Path,
                        help="boot the I-modem from a saved flash configuration")
    result.add_argument("--analog", type=Path,
                        help="firmware image (defaults to the selected analogue board)")
    result.add_argument("--analog-board", choices=("403", "3453c"), default="403",
                        help="select the analogue board's boot and peripheral configuration")
    result.add_argument("--analog-parameter-flash", type=Path,
                        help="3453C parameter capture; copied privately for this run")
    result.add_argument("--instructions", type=int, default=300_000_000)
    result.add_argument("--analog-instructions", type=int,
                        help="separate analogue CPU limit for inspecting training before timeout")
    result.add_argument("--analog-dsp-trace-range", metavar="FIRST:LAST",
                        help="trace an analogue C51 program range, hexadecimal")
    result.add_argument("--analog-trace-pc", action="append", default=[], metavar="ADDRESS",
                        help="observe an analogue supervisor instruction address, hexadecimal")
    result.add_argument("--analog-peek", action="append", default=[], metavar="ADDRESS",
                        help="report an analogue supervisor data word, hexadecimal")
    result.add_argument("--analog-mem-watch", metavar="FIRST:LAST",
                        help="record analogue supervisor memory writes in this hexadecimal range")
    result.add_argument("--analog-dsp-write-watch", metavar="ADDRESS",
                        help="record writes to one analogue C51 data cell, hexadecimal, "
                             "with the writing program counter (dsp_writes in the analogue result)")
    result.add_argument("--analog-dsp-peek", action="append", default=[], metavar="ADDRESS",
                        help="report an analogue C51 data cell, hexadecimal, repeatable")
    result.add_argument(
        "--speed-index", type=int, choices=range(17), default=0,
        help="Hayes &N fixed-speed index on both modems (0 auto, 1 300, 8 14400)",
    )
    result.add_argument(
        "--protocol", choices=tuple(PROTOCOL_S58), default="default",
        help="select PCM/V.34 protocols, or use the verified 300-bps Bell 103 settings",
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
    result.add_argument("--audit-overlays", action="store_true",
                        help="read back every I-modem overlay at its completion strobe")
    result.add_argument("--assist-overlay-command", action="store_true",
                        help="diagnostic: let the host acknowledge foreground overlay commands")
    result.add_argument(
        "--disable-v34", action="store_true",
        help="set S56=192 on both modems to disable V.34 and V.FC",
    )
    result.add_argument("--analog-settings", default="S27=1", help="extra Hayes settings before dialling")
    result.add_argument("--analog-result-mode", type=int, choices=range(5), default=1,
                        help="Hayes X result mode (1 reports speed without dial-tone detection; 0 bare CONNECT)")
    result.add_argument("--imodem-settings", default="", help="extra Hayes settings before answering")
    result.add_argument("--analog-send", default="", help="text to send from the analogue DTE after CONNECT")
    result.add_argument("--imodem-send", default="", help="text to send from the I-modem DTE after CONNECT")
    result.add_argument("--link-diagnostics", action="store_true",
                        help="query the I-modem's ATI6 after carrier and resume data mode")
    result.add_argument("--diagnostics-command", action="append", default=[], metavar="AT",
                        help="what --link-diagnostics asks, in order; repeatable (default ATI6)")
    result.add_argument(
        "--snapshot-every", type=int, default=25_000_000,
        help="write periodic DSP checkpoints when --output is set (0 disables)",
    )
    return result


def main() -> int:
    args = parser().parse_args()
    if args.analog is None:
        args.analog = ROOT / "2_3_33.XMF" if args.analog_board == "3453c" else DEFAULT_ANALOG
    if args.analog_parameter_flash and args.analog_board != "3453c":
        raise ValueError("--analog-parameter-flash requires --analog-board 3453c")
    if args.protocol == "bell103":
        args.speed_index = 1
        args.disable_v34 = True
        args.analog_settings += "S54=192B1&M0&B0"
        args.imodem_settings += "S54=192B1&M0&B0"
    output = args.output.resolve() if args.output else None
    if output:
        output.mkdir(parents=True, exist_ok=True)

    with tempfile.TemporaryDirectory(prefix="courier-imodem-analog-") as temporary, ExitStack() as cleanup:
        socket_path = str(Path(temporary) / "line.sock")
        analog_s58 = PROTOCOL_S58[args.protocol]
        # The line observer sees the body after AT is stripped. Start with X0
        # so a fixed-speed &N prefix is not mistaken for a standalone extended
        # command when it records which subscriber is originating the call.
        analog_dial = f"ATX{args.analog_result_mode}" + args.analog_settings
        if args.speed_index:
            analog_dial += f"&N{args.speed_index}"
        if analog_s58 is not None:
            analog_dial += f"S58={analog_s58}"
        if args.disable_v34:
            analog_dial += "S56=192"
        analog_dial += "DT5551234"
        analog_command = [
            sys.executable, "-m", "courier_emu", "run",
            str(args.analog.resolve()), "--instructions", str(args.analog_instructions or args.instructions),
            "--line-link", socket_path, "--line-listen",
            "--with-dsp", "--nvram-fixture", "idsdl403", "--board-id", "7",
            "--dip-preset", "default", "--tick-ms", "5",
            # Keep the dial-mode change and dial in one Hayes command.  Two
            # back-to-back batch commands can put the second command on the
            # modelled DTE while this ROM is still returning OK to the first.
            "--at", analog_dial,
            "--serial-input-after", "5000000", "--summary",
        ]
        if args.analog_board == "3453c":
            # The terminal-interface strap must decode to capability 0x22.
            # Code 0 boots, but leaves A32 unset and the firmware rejects AT
            # command completion (and cannot establish the terminal link).
            analog_command = [
                sys.executable, "-m", "courier_emu.worker", str(args.analog.resolve()),
                "--instructions", str(args.analog_instructions or args.instructions),
                "--line-link", socket_path, "--line-listen", "--with-dsp",
                "--board-id", "7", "--tick-ms", "5", "--daa-codec",
                "--daa-codec-revision", "19", "--daa-line", "disconnected",
                "--serial-input-hex", (analog_dial + "\r").encode("ascii").hex(),
            ]
            if args.analog_parameter_flash:
                private_flash = Path(temporary) / "parameters.sav"
                shutil.copyfile(args.analog_parameter_flash, private_flash)
                analog_command.extend(("--parameter-flash", str(private_flash)))
        if output:
            analog_command.extend(("--line-record", str(output / "analog")))
        if args.analog_dsp_trace_range:
            analog_command.extend(("--dsp-trace-range", args.analog_dsp_trace_range))
        if args.analog_dsp_write_watch:
            analog_command.extend(("--dsp-write-watch", args.analog_dsp_write_watch))
        for address in args.analog_trace_pc:
            analog_command.extend(("--trace-pc", address))
        if args.analog_mem_watch:
            analog_command.extend(("--mem-watch", args.analog_mem_watch))
        for address in args.analog_peek:
            analog_command.extend(("--peek", address))
        for address in args.analog_dsp_peek:
            analog_command.extend(("--dsp-peek", address))
        if args.analog_send:
            if args.analog_board == "3453c":
                analog_command.extend(("--serial-after-connect-hex", args.analog_send.encode("ascii").hex()))
            else:
                analog_command.extend(("--send-after-connect", args.analog_send))
        analog_environment = os.environ.copy()
        analog_environment["COURIER_LINE_DIGITAL"] = "1"
        analog = subprocess.Popen(
            analog_command, cwd=ROOT, text=True, stdout=subprocess.PIPE,
            stderr=(cleanup.enter_context((output / "analog-stderr.log").open("w"))
                    if output else subprocess.PIPE), env=analog_environment,
        )
        cleanup.callback(stop_child, analog)

        peer = BearerLineLink(LineLink(socket_path, digital=True),
                              codec="si3034" if args.analog_board == "3453c" else "ac01")
        peer.from_line *= 10 ** (args.analog_to_imodem_db / 20)
        peer.into_courier *= 10 ** (args.imodem_to_analog_db / 20)
        bri = BriNetwork(
            establish="terminal",
            call_to="7349195",
            media_peer=peer,
        )
        transcript: list[tuple[int, str, str]] = []
        if args.protocol != "default" or args.speed_index or args.disable_v34 or args.imodem_settings:
            # I-modem S58 uses disable polarity. Bit 0 disables x2; bit 5
            # disables V.90. Configure it before the ring, then answer at the
            # same point as the default run.
            config = "AT" + args.imodem_settings
            if args.speed_index:
                config += f"&N{args.speed_index}"
            if analog_s58 is not None:
                config += f"S58={analog_s58}"
            if args.disable_v34:
                config += "S56=192"
            commands = [config, "ATA"]
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
        snapshots = []
        next_snapshot = args.snapshot_every
        data_trace_address = (
            int(args.dsp_data_trace, 16) if args.dsp_data_trace else None
        )
        data_sent = False
        received_text = ""
        transcript_cursor = 0
        diagnostic_stage = "connecting"
        connected_at = 0
        diagnostic_cursor = 0
        queries = list(args.diagnostics_command or ["ATI6"])

        def send(current: IsdnMachine, value: str, direction: str = "sent") -> None:
            current.send_serial(_on_the_wire(value, current.dte_framing()))
            transcript.append((current.instructions, direction, value))

        def pump(current: IsdnMachine) -> None:
            nonlocal traced_core, next_snapshot, data_sent, received_text, transcript_cursor
            nonlocal diagnostic_stage, connected_at, diagnostic_cursor
            command_pump(current)
            if transcript_cursor != len(transcript):
                for _, direction, value in transcript[transcript_cursor:]:
                    if direction == "received":
                        received_text += value
                transcript_cursor = len(transcript)
            if (args.imodem_send and not data_sent
                    and carrier_connected(received_text, complete=True)):
                current.send_serial(_on_the_wire(args.imodem_send, current.dte_framing()))
                transcript.append((current.instructions, "sent_data", args.imodem_send))
                data_sent = True
            if args.link_diagnostics:
                if diagnostic_stage == "connecting" and carrier_connected(received_text, complete=True):
                    connected_at = current.instructions
                    diagnostic_stage = "guard"
                elif diagnostic_stage == "guard" and current.instructions >= connected_at + 20_000_000:
                    send(current, "+++")
                    diagnostic_stage, diagnostic_cursor = "escaping", len(received_text)
                elif (diagnostic_stage in ("escaping", "diagnostics") and queries
                        and "\r\nOK\r\n" in received_text[diagnostic_cursor:]):
                    send(current, queries.pop(0) + "\r")
                    diagnostic_stage, diagnostic_cursor = "diagnostics", len(received_text)
                elif diagnostic_stage == "diagnostics" and "\r\nOK\r\n" in received_text[diagnostic_cursor:]:
                    send(current, "ATO\r")
                    diagnostic_stage = "done"
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
            if output and args.snapshot_every > 0 and current.instructions >= next_snapshot:
                snapshots.append({
                    "instructions": current.instructions,
                    "serial": received_text,
                    "call_state": bri.call_state,
                    "line_frames": peer.line.frames,
                    "dsp": core.state() if core else None,
                    "stack": core.stack() if core else None,
                    "dsp_status": core.io(0x57) if core else None,
                    "cells": {f"{a:04x}": core.data(a) for a in
                              (0x0bff, 0x0bf0, 0x0bf1, 0x0061, 0x006f,
                               0x031a, 0x0337, 0x035b, 0x039f,
                               0x03c8, 0x03c9, 0x03ca, 0x03cb, 0x03cc, 0x03cd,
                               0x006d, 0x032c, 0x032d, 0x03b4, 0x03d0, 0x03d2)} if core else {},
                    "recent_commands": list(current.mailbox.commands)[-8:],
                    "recent_replies": list(current.mailbox.replies)[-8:],
                })
                (output / "checkpoints.json").write_text(json.dumps(snapshots, indent=2) + "\n")
                next_snapshot = current.instructions + args.snapshot_every

        def next_due(current: IsdnMachine) -> int | None:
            """When `pump` next has something to do (see IsdnMachine._update_elision)."""
            if args.link_diagnostics and diagnostic_stage != "done":
                return 0
            if args.imodem_send and not data_sent and carrier_connected(
                    received_text, complete=True):
                return 0
            core = getattr(current.mailbox, "core", None)
            if ((trace_range is not None or data_trace_address is not None)
                    and core is not None and core is not traced_core):
                return 0
            due = [command_pump.next_due(current)]
            if output and args.snapshot_every > 0:
                due.append(next_snapshot)
            due = [value for value in due if value is not None]
            return min(due) if due else None

        pump.next_due = next_due  # type: ignore[attr-defined]
        machine = IsdnMachine(
            NacImage.load(args.imodem),
            with_dsp=True,
            profile=False,
            bri=bri,
            flash_nvram=args.imodem_nvram.read_bytes() if args.imodem_nvram else None,
            # The continuously clocked analogue side reaches RING after about
            # 95M 386 instructions. ATA sent earlier is correctly ignored.
            serial_pump=pump,
        )
        overlay_audit = OverlayAudit(machine.mailbox) if args.audit_overlays else None
        machine.mailbox.foreground_overlay_assist = args.assist_overlay_command
        if overlay_audit:
            machine.mailbox.write = overlay_audit.write
        try:
            imodem_result = machine.run(args.instructions).to_dict()
            imodem_result["working_s_registers"] = {
                str(number): machine.uc.mem_read(0x26000 + 0xD17B + number, 1)[0]
                for number in (54, 56, 58)
            }
            if overlay_audit:
                imodem_result["overlay_audit"] = overlay_audit.records
            imodem_result["all_io_counts"] = {
                f"{direction} 0x{port:04x}": count
                for (direction, port), count in sorted(machine.io_counts.items())
            }
            if machine.mailbox.core is not None:
                imodem_result["dsp_host_io"] = {
                    f"{port:02x}": {
                        "input": machine.mailbox.core.io(port),
                        "output": machine.mailbox.core.io_output(port),
                    }
                    for port in range(0x50, 0x61)
                }
                imodem_result["dsp_host_io_stats"] = machine.mailbox.core.io_port_stats(
                    list(range(0x50, 0x80))
                )
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
                if machine.mailbox.core is not None:
                    (output / "dsp-program.bin").write_bytes(b"".join(
                        machine.mailbox.core.program(address).to_bytes(2, "little")
                        for address in range(0x10000)
                    ))
                    (output / "dsp-data.bin").write_bytes(b"".join(
                        machine.mailbox.core.data(address).to_bytes(2, "little")
                        for address in range(0x10000)
                    ))
        finally:
            peer.close()
            machine.mailbox.close()

        analog_stdout, analog_stderr = analog.communicate(timeout=60)
        if output:
            (output / "analog-result.json").write_text(analog_stdout)
        if analog.returncode:
            failure = (output / "analog-stderr.log").read_text() if output else (analog_stderr or "")
            raise RuntimeError(
                f"analog process exited {analog.returncode}: {failure.strip()}"
            )
        analog_result = json.loads(analog_stdout)

    result = {
        "analog_board": args.analog_board,
        "analog_image": str(args.analog.resolve()),
        "instruction_limits": {
            "imodem": args.instructions,
            "analog": args.analog_instructions or args.instructions,
        },
        "analog_dial_command": analog_dial,
        "protocol": args.protocol,
        "speed_index": args.speed_index,
        "disable_v34": args.disable_v34,
        "analog_settings": args.analog_settings,
        "analog_result_mode": args.analog_result_mode,
        "imodem_settings": args.imodem_settings,
        "imodem_nvram": str(args.imodem_nvram.resolve()) if args.imodem_nvram else None,
        "foreground_overlay_assist": args.assist_overlay_command,
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
        imodem_serial = "".join(text for _, direction, text in transcript
                               if direction == "received")
        analog_serial = analog_terminal_text(analog_result)
        summary = {
            "analog_board": args.analog_board,
            "analog_image": str(args.analog.resolve()),
            "protocol": args.protocol,
            "speed_index": args.speed_index,
            "disable_v34": args.disable_v34,
            "analog_settings": args.analog_settings,
            "analog_result_mode": args.analog_result_mode,
            "imodem_settings": args.imodem_settings,
            "foreground_overlay_assist": args.assist_overlay_command,
            "connected": carrier_connected(imodem_serial) and carrier_connected(analog_serial),
            "data_delivery": {
                "analog_to_imodem": args.analog_send in imodem_serial if args.analog_send else None,
                "imodem_to_analog": args.imodem_send in analog_serial if args.imodem_send else None,
            },
            "imodem": {
                "serial": imodem_serial,
                "connect_rate_bps": connection_rate_bps(imodem_serial),
                "carrier_connected": carrier_connected(imodem_serial),
                "isdn_call_state": imodem_result["bri"]["call_state"],
                "dsp": imodem_result["mailbox"]["core"],
                "recent_mailbox": imodem_result["mailbox"]["timeline"][-12:],
                "error": imodem_result["error"],
            },
            "analog": {
                "serial": analog_serial,
                "connect_rate_bps": connection_rate_bps(analog_serial),
                "carrier_connected": carrier_connected(analog_serial),
                "error": analog_result["error"],
            },
            "bridge": peer.status(),
        }
        (output / "summary.json").write_text(json.dumps(summary, indent=2) + "\n")
    print(json.dumps(result, indent=2, sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
