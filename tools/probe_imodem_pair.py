#!/usr/bin/env python3
"""Run two I-modem firmware instances back to back over a PCMU B channel."""

from __future__ import annotations

import argparse
import json
from pathlib import Path
import re
import socket
import struct
import subprocess
import sys
import tempfile
import time
from typing import Any

from courier_emu.bri import BriNetwork, CAPABILITY_AUDIO_31KHZ, audio_bearer
from courier_emu.isdn import IsdnMachine
from courier_emu.isdn_console import _on_the_wire, scripted_pump
from courier_emu.nac import NacImage


ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))
from tools.x2_source_impairment import BearerLog, SourceImpairment
_IMPAIRMENT = SourceImpairment.from_environment()
_WIRELOG = BearerLog.from_environment()
DEFAULT_IMAGE = ROOT / "Ie030002.nac"
FRAME_OCTETS = 800
HEADER = struct.Struct("<H")
SOCKET_TIMEOUT = 180


class G711Peer:
    """A synchronous, byte-exact 100 ms B-channel socket."""

    def __init__(self, path: str, *, listen: bool) -> None:
        self.path = path
        self.listen = listen
        self.handle: socket.socket | None = None
        self.server: socket.socket | None = None
        self.pending = bytearray()
        self.frames = 0
        self.sent = 0
        self.received = 0
        self.sent_non_ff = 0
        self.received_non_ff = 0
        self.error: str | None = None

    def start(self) -> None:
        if self.handle is not None or self.error is not None:
            return
        if self.listen:
            self.server = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
            self.server.bind(self.path)
            self.server.listen(1)
            self.server.settimeout(SOCKET_TIMEOUT)
            self.handle, _ = self.server.accept()
        else:
            deadline = time.monotonic() + SOCKET_TIMEOUT
            while True:
                candidate = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
                try:
                    candidate.connect(self.path)
                    self.handle = candidate
                    break
                except (FileNotFoundError, ConnectionRefusedError):
                    candidate.close()
                    if time.monotonic() >= deadline:
                        raise
                    time.sleep(0.01)
        self.handle.settimeout(SOCKET_TIMEOUT)

    def _read(self, count: int) -> bytes:
        assert self.handle is not None
        result = bytearray()
        while len(result) < count:
            chunk = self.handle.recv(count - len(result))
            if not chunk:
                raise ConnectionError("the far I-modem closed the B channel")
            result.extend(chunk)
        return bytes(result)

    def exchange(self, octets: bytes) -> bytes:
        # Once the far emulator reaches its instruction limit the bearer is
        # permanently closed. BriNetwork continues polling until this side
        # reaches its own limit, so retain the terminal error instead of
        # trying to reopen (and, for the listener, re-bind) the same socket.
        if self.error is not None or self.handle is None:
            return b""
        self.pending.extend(octets)
        reply = bytearray()
        while len(self.pending) >= FRAME_OCTETS:
            frame = bytes(self.pending[:FRAME_OCTETS])
            del self.pending[:FRAME_OCTETS]
            try:
                assert self.handle is not None
                self.handle.sendall(HEADER.pack(len(frame)) + frame)
                size, = HEADER.unpack(self._read(HEADER.size))
                incoming = self._read(size)
            except (OSError, ConnectionError) as exc:
                self.error = str(exc)
                self.stop()
                break
            if _WIRELOG is not None:
                _WIRELOG.write(incoming)
            if _IMPAIRMENT is not None:
                incoming = _IMPAIRMENT.filter(incoming)
            reply.extend(incoming)
            self.frames += 1
            self.sent += len(frame)
            self.received += len(incoming)
            self.sent_non_ff += sum(value != 0xFF for value in frame)
            self.received_non_ff += sum(value != 0xFF for value in incoming)
        return bytes(reply)

    def stop(self) -> None:
        for handle in (self.handle, self.server):
            if handle is not None:
                try:
                    handle.close()
                except OSError:
                    pass
        self.handle = self.server = None

    def status(self) -> dict[str, Any]:
        return {
            "listen": self.listen,
            "frames": self.frames,
            "octets_sent": self.sent,
            "octets_received": self.received,
            "sent_non_ff": self.sent_non_ff,
            "received_non_ff": self.received_non_ff,
            "pending": len(self.pending),
            "error": self.error,
        }


def arguments() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--image", type=Path, default=DEFAULT_IMAGE)
    parser.add_argument("--instructions", type=int, default=150_000_000)
    parser.add_argument("--output", type=Path)
    parser.add_argument("--profile", action="store_true")
    parser.add_argument("--protocol", choices=("default", "x2"), default="default",
                        help="use default negotiation or disable V.90 for an x2 symmetric call")
    parser.add_argument("--check-connect", action="store_true",
                        help="fail unless both firmware instances return a modem CONNECT result")
    parser.add_argument("--check-x2", action="store_true",
                        help="fail unless both CONNECT results identify x2 modulation")
    parser.add_argument("--link-diagnostics", action="store_true",
                        help="escape after CONNECT, query ATI6, then resume with ATO")
    parser.add_argument("--originate-send", default="", help="caller payload after CONNECT")
    parser.add_argument("--answer-send", default="", help="answerer payload after CONNECT")
    parser.add_argument("--settings", default="",
                        help="additional AT settings on both ends before dial/answer")
    parser.add_argument("--trace-negotiation", action="store_true",
                        help="capture x2 eligibility fields when DSP parameters are sent")
    parser.add_argument("--product-type", choices=("external", "internal"), default="external",
                        help="select the external DTE or the internal card's host UART")
    parser.add_argument("--internal-baud", choices=(57600, 115200), type=int, default=57600,
                        help="host UART speed for the internal card")
    parser.add_argument("--nvram", type=Path,
                        help="boot both instances from a saved configuration without modifying it")
    parser.add_argument("--establish", choices=("terminal", "network"), default="terminal",
                        help="which end initiates the ISDN data link")
    parser.add_argument("--prime-originate", action="store_true",
                        help="offer an initial ring, then hang up before dialing to establish the caller's data link")
    parser.add_argument("--check-keepalive", action="store_true",
                        help="fail unless both calls survive the V.8 overlay handoff and old clearing window")
    parser.add_argument("--worker", choices=("originate", "answer"),
                        help=argparse.SUPPRESS)
    parser.add_argument("--socket", help=argparse.SUPPRESS)
    parser.add_argument("--result", type=Path, help=argparse.SUPPRESS)
    return parser.parse_args()


def run_side(args: argparse.Namespace) -> int:
    originate = args.worker == "originate"
    peer = G711Peer(args.socket, listen=originate)
    bri = BriNetwork(
        establish=args.establish,
        call_at=None if originate and not args.prime_originate else 20_000_000,
        call_to="7349195",
        bearer=audio_bearer(CAPABILITY_AUDIO_31KHZ),
        media_peer=peer,
    )
    commands = ["AT*V2=3", "ATD7349195"] if originate else ["ATA"]
    if args.protocol == "x2":
        # S58 bits disable x2 (1), server (2), symmetric (8), and V.90
        # (32). Keep both x2 roles enabled across the digital bearer.
        commands = ["AT*V2=3S58=32&A3&B0", "ATD7349195" if originate else "ATA"]
    if args.settings:
        commands.insert(-1, "AT" + args.settings)
    if originate and args.prime_originate:
        commands.insert(-1, "ATH")
    transcript: list[tuple[int, str, str]] = []
    command_pump = scripted_pump(commands, after=30_000_000, every=0,
                                 transcript=transcript)
    payload = args.originate_send if originate else args.answer_send
    stage = "connecting"
    connected_at = 0
    received_text = ""
    cursor = 0
    host_rate_set = False

    def send(current: IsdnMachine, value: str, direction: str = "sent") -> None:
        current.send_serial(_on_the_wire(value, current.dte_framing()))
        transcript.append((current.instructions, direction, value))

    def pump(current: IsdnMachine) -> None:
        nonlocal stage, connected_at, received_text, cursor, host_rate_set
        command_pump(current)
        if (args.product_type == "internal" and not host_rate_set
                and any(direction == "sent" for _, direction, _ in transcript)):
            # send_serial opens the host UART before queueing the first AT.
            # Set the requested driver speed before those staged bytes clock
            # into the guest; its attention receiver reads the actual divisor.
            current.channels[current.command_base].host_open(115200 // args.internal_baud, 3)
            host_rate_set = True
        received_text += "".join(value for _, direction, value in transcript[cursor:]
                                 if direction == "received")
        cursor = len(transcript)
        if stage == "connecting" and connect_result(received_text) is not None:
            connected_at = current.instructions
            if payload:
                send(current, payload, "sent_data")
            stage = "guard" if args.link_diagnostics else "done"
            received_text = ""
        elif stage == "guard" and current.instructions >= connected_at + 20_000_000:
            send(current, "+++")
            stage, received_text = "escaping", ""
        elif stage == "escaping" and "\r\nOK\r\n" in received_text:
            send(current, "ATI6\r")
            stage, received_text = "diagnostics", ""
        elif stage == "diagnostics" and "\r\nOK\r\n" in received_text:
            send(current, "ATO\r")
            stage = "done"

    machine = IsdnMachine(
        NacImage.load(args.image),
        with_dsp=True,
        profile=args.profile,
        bri=bri,
        flash_nvram=args.nvram.read_bytes() if args.nvram else None,
        serial_pump=pump,
        product_type=args.product_type,
    )
    negotiation = []
    if args.trace_negotiation:
        original_command = machine.mailbox.on_command

        def observe_command(tag: int, value: int) -> None:
            if tag in (0x42, 0x49, 0x53, 0x70, 0x71, 0x72, 0x04):
                negotiation.append({
                    "instructions": machine.instructions,
                    "tag": f"{tag:04x}", "value": f"{value:04x}",
                    "cpu_fields": {f"{offset:04x}": machine.uc.mem_read(0x26000 + offset, 1)[0]
                                   for offset in (0xD1EA, 0xD1B5, 0xD1D7, 0xD1DB, 0xE496)},
                })
            if original_command is not None:
                original_command(tag, value)

        machine.mailbox.on_command = observe_command
    try:
        result = machine.run(args.instructions).to_dict()
        if args.trace_negotiation:
            result["negotiation_trace"] = negotiation
        # The live S-register file, rather than ATSn?'s saved-profile view.
        result["working_s_registers"] = {
            str(number): machine.uc.mem_read(0x26000 + 0xD17B + number, 1)[0]
            for number in (54, 56, 58)
        }
    finally:
        peer.stop()
        machine.mailbox.close()
    result["serial_session"] = [
        {"instructions": count, "direction": direction, "text": text}
        for count, direction, text in transcript
    ]
    result["g711_peer"] = peer.status()
    args.result.write_text(json.dumps(result, indent=2, sort_keys=True) + "\n")
    return 0


def serial_text(result: dict[str, Any]) -> str:
    return "".join(
        event["text"] for event in result["serial_session"]
        if event["direction"] == "received"
    )


def connect_result(serial: str) -> str | None:
    match = re.search(r"(?:^|[\r\n])(CONNECT[^\r\n]*)\r\n", serial)
    return match.group(1) if match else None


def check_keepalive(result: dict[str, Any]) -> None:
    """Assert call survival, independently of eventual modem carrier training.

    The connect-fix control cleared after 220 media frames, following the
    two-second image-6 loader timeout. Require at least 250 exchanged frames
    and a completed overlay handshake so a short/idle run cannot pass.
    Socket errors at worker shutdown are deliberately checked through call
    state and guest events, since one worker necessarily finishes first.
    """
    assert result["error"] is None, result["error"]
    assert result["bri"]["call_state"] == "active", "ISDN call cleared"
    assert result["bri"]["media"]["channel"] == 1, "B1 disconnected"
    assert result["g711_peer"]["frames"] >= 250, "run did not cross the old clearing window"
    assert "NO CARRIER" not in serial_text(result), "supervisor lost carrier"
    assert not any("DISCONNECT call reference 1" in event["event"]
                   for event in result["bri"]["events"]), "guest requested clearing"
    mailbox = result["mailbox"]
    assert mailbox["error"] is None, mailbox["error"]
    assert mailbox["pcm"]["rx_empty_frames"] == 0, "PCM receive underrun"
    assert any("cmd 0002:a000" in event for event in mailbox["timeline"]), "no V.8 handoff"
    assert not any("cmd 0083:0083" in event for event in mailbox["timeline"]), "DSP loader timed out"
    assert mailbox["overlay_writes"]["4"] >= 3, "call overlay never finished"
    # The final completion strobe may remain set while the datapump owns
    # foreground execution; clearing it here would hide the native signal.
    assert mailbox["dsp_status"] & 1 == 0, "overlay command still pending"


def main() -> int:
    args = arguments()
    if args.worker:
        return run_side(args)

    output = (args.output or ROOT / "artifacts/imodem-pair").resolve()
    output.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory(prefix="courier-imodem-pair-") as temporary:
        path = str(Path(temporary) / "bearer.sock")
        processes = []
        for role in ("originate", "answer"):
            command = [
                sys.executable, str(Path(__file__).resolve()),
                "--worker", role, "--socket", path,
                "--image", str(args.image.resolve()),
                "--instructions", str(args.instructions),
                "--protocol", args.protocol,
                "--result", str(output / f"{role}.json"),
            ]
            if args.profile:
                command.append("--profile")
            if args.link_diagnostics:
                command.append("--link-diagnostics")
            if args.trace_negotiation:
                command.append("--trace-negotiation")
            if args.nvram:
                command.extend(["--nvram", str(args.nvram.resolve())])
            if args.prime_originate:
                command.append("--prime-originate")
            command.extend(["--originate-send", args.originate_send,
                            "--answer-send", args.answer_send,
                            "--settings", args.settings,
                            "--product-type", args.product_type,
                            "--internal-baud", str(args.internal_baud),
                            "--establish", args.establish])
            processes.append((role, subprocess.Popen(command, cwd=ROOT)))
        failures = []
        for role, process in processes:
            code = process.wait()
            if code:
                failures.append(f"{role} exited {code}")
        if failures:
            raise RuntimeError(", ".join(failures))

    originate = json.loads((output / "originate.json").read_text())
    answer = json.loads((output / "answer.json").read_text())
    summary = {
        "protocol": args.protocol,
        "settings": args.settings,
        "product_type": args.product_type,
        "internal_baud": args.internal_baud if args.product_type == "internal" else None,
        "nvram": str(args.nvram.resolve()) if args.nvram else None,
        "establish": args.establish,
        "prime_originate": args.prime_originate,
        "originate": {
            "serial": serial_text(originate),
            "modem_connected": connect_result(serial_text(originate)) is not None,
            "connect_result": connect_result(serial_text(originate)),
            "working_s_registers": originate["working_s_registers"],
            "bri": originate.get("bri"),
            "g711_peer": originate["g711_peer"],
        },
        "answer": {
            "serial": serial_text(answer),
            "modem_connected": connect_result(serial_text(answer)) is not None,
            "connect_result": connect_result(serial_text(answer)),
            "working_s_registers": answer["working_s_registers"],
            "bri": answer.get("bri"),
            "g711_peer": answer["g711_peer"],
        },
    }
    summary["data_delivery"] = {
        "originate_to_answer": bool(args.originate_send and args.originate_send in serial_text(answer)),
        "answer_to_originate": bool(args.answer_send and args.answer_send in serial_text(originate)),
    }
    for role in ("originate", "answer"):
        summary[role]["x2_connected"] = bool(
            re.search(r"/x2(?:/|$)", summary[role]["connect_result"] or "", re.IGNORECASE)
        )
    (output / "summary.json").write_text(
        json.dumps(summary, indent=2, sort_keys=True) + "\n"
    )
    print(json.dumps(summary, indent=2, sort_keys=True))
    if args.check_keepalive:
        for result in (originate, answer):
            check_keepalive(result)
    if args.check_connect:
        for role in ("originate", "answer"):
            if not summary[role]["modem_connected"]:
                raise RuntimeError(f"{role} did not establish modem carrier")
    if args.check_x2:
        for role in ("originate", "answer"):
            if not summary[role]["x2_connected"]:
                raise RuntimeError(f"{role} did not establish x2: {summary[role]['connect_result']}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
