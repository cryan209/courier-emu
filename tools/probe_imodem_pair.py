#!/usr/bin/env python3
"""Run two I-modem firmware instances back to back over a PCMU B channel."""

from __future__ import annotations

import argparse
import json
from pathlib import Path
import socket
import struct
import subprocess
import sys
import tempfile
import time
from typing import Any

from courier_emu.bri import BriNetwork, CAPABILITY_AUDIO_31KHZ, audio_bearer
from courier_emu.isdn import IsdnMachine
from courier_emu.isdn_console import scripted_pump
from courier_emu.nac import NacImage


ROOT = Path(__file__).resolve().parents[1]
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
        if self.handle is not None:
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
    parser.add_argument("--worker", choices=("originate", "answer"),
                        help=argparse.SUPPRESS)
    parser.add_argument("--socket", help=argparse.SUPPRESS)
    parser.add_argument("--result", type=Path, help=argparse.SUPPRESS)
    return parser.parse_args()


def run_side(args: argparse.Namespace) -> int:
    originate = args.worker == "originate"
    peer = G711Peer(args.socket, listen=originate)
    bri = BriNetwork(
        establish="terminal",
        call_at=None if originate else 20_000_000,
        call_to="7349195",
        bearer=audio_bearer(CAPABILITY_AUDIO_31KHZ),
        media_peer=peer,
    )
    commands = ["AT*V2=3", "ATD7349195"] if originate else ["ATA"]
    transcript: list[tuple[int, str, str]] = []
    machine = IsdnMachine(
        NacImage.load(args.image),
        with_dsp=True,
        profile=False,
        bri=bri,
        flash_nvram=None,
        serial_pump=scripted_pump(
            commands, after=30_000_000, every=0, transcript=transcript
        ),
    )
    try:
        result = machine.run(args.instructions).to_dict()
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
                "--result", str(output / f"{role}.json"),
            ]
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
        "originate": {
            "serial": serial_text(originate),
            "bri": originate.get("bri"),
            "g711_peer": originate["g711_peer"],
        },
        "answer": {
            "serial": serial_text(answer),
            "bri": answer.get("bri"),
            "g711_peer": answer["g711_peer"],
        },
    }
    (output / "summary.json").write_text(
        json.dumps(summary, indent=2, sort_keys=True) + "\n"
    )
    print(json.dumps(summary, indent=2, sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
