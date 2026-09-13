#!/usr/bin/env python3
"""Put an emulated I-modem B channel directly on an analog Courier's line."""

from __future__ import annotations

import argparse
import json
from pathlib import Path
import subprocess
import tempfile
from typing import Any

from courier_emu.bri import BriNetwork, CAPABILITY_AUDIO_31KHZ, audio_bearer
from courier_emu.isdn import IsdnMachine
from courier_emu.isdn_console import scripted_pump
from courier_emu.line import LINE_FRAME_SAMPLES, LineFrame, LineLink
from courier_emu.nac import NacImage
from courier_emu.sip import linear_to_ulaw, ulaw_to_linear


ROOT = Path(__file__).resolve().parents[1]
DEFAULT_IMODEM = ROOT / "Ie030002.nac"
DEFAULT_ANALOG = (
    ROOT / "artifacts/courier-board-21210-capture-403/courier-board.rom"
)


class AnalogPcmPeer:
    """Adapt opaque PCMU B-channel octets to the analog PCM line socket."""

    def __init__(self, path: str) -> None:
        self.link = LineLink(path, audio_only=True)
        self.pending: list[int] = []
        self.started = False
        self.g711_from_imodem = 0
        self.g711_to_imodem = 0
        self.non_silence_from_imodem = 0
        self.non_silence_to_imodem = 0
        self.preroll_frames = 0

    def start(self) -> None:
        if not self.started:
            self.link.open()
            self.started = True

    def exchange(self, octets: bytes) -> bytes:
        self.g711_from_imodem += len(octets)
        self.non_silence_from_imodem += sum(value != 0xFF for value in octets)
        self.pending.extend(ulaw_to_linear(value) for value in octets)
        reply = bytearray()
        while len(self.pending) >= LINE_FRAME_SAMPLES:
            samples = self.pending[:LINE_FRAME_SAMPLES]
            del self.pending[:LINE_FRAME_SAMPLES]
            self.link.exchange(LineFrame(0, False, False, samples))
            incoming = self.link.receive_audio()
            encoded = bytes(linear_to_ulaw(sample) for sample in incoming)
            reply.extend(encoded)
            self.g711_to_imodem += len(encoded)
            self.non_silence_to_imodem += sum(value != 0xFF for value in encoded)
        return bytes(reply)

    def preroll(self, frames: int) -> None:
        """Clock the analog ROM to call setup before the ISDN bearer starts."""
        self.start()
        for _ in range(frames):
            self.link.exchange(
                LineFrame(0, False, False, [0] * LINE_FRAME_SAMPLES)
            )
            self.link.receive_audio()
            self.preroll_frames += 1

    def stop(self) -> None:
        self.link.close()

    def status(self) -> dict[str, Any]:
        return {
            **self.link.status(),
            "g711_from_imodem": self.g711_from_imodem,
            "g711_to_imodem": self.g711_to_imodem,
            "non_silence_from_imodem": self.non_silence_from_imodem,
            "non_silence_to_imodem": self.non_silence_to_imodem,
            "pending": len(self.pending),
            "preroll_frames": self.preroll_frames,
        }


def parser() -> argparse.ArgumentParser:
    result = argparse.ArgumentParser(description=__doc__)
    result.add_argument("--imodem", type=Path, default=DEFAULT_IMODEM)
    result.add_argument("--analog", type=Path, default=DEFAULT_ANALOG)
    result.add_argument("--instructions", type=int, default=150_000_000)
    result.add_argument("--analog-preroll-frames", type=int, default=100)
    result.add_argument("--output", type=Path)
    return result


def main() -> int:
    args = parser().parse_args()
    output = args.output.resolve() if args.output else None
    if output:
        output.mkdir(parents=True, exist_ok=True)

    with tempfile.TemporaryDirectory(prefix="courier-imodem-analog-") as temporary:
        socket_path = str(Path(temporary) / "line.sock")
        analog_command = [
            str(ROOT / ".venv/bin/python"), "-m", "courier_emu", "run",
            str(args.analog.resolve()), "--instructions", str(args.instructions),
            "--line-link", socket_path, "--line-audio-only", "--line-listen",
            "--with-dsp", "--nvram-fixture", "idsdl403", "--board-id", "7",
            "--dip-preset", "default", "--tick-ms", "5",
            "--at", "ATX0", "--at", "ATDT5551234", "--summary",
        ]
        if output:
            analog_command.extend(("--line-record", str(output / "analog")))
        analog = subprocess.Popen(
            analog_command, cwd=ROOT, text=True, stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
        )

        peer = AnalogPcmPeer(socket_path)
        peer.preroll(args.analog_preroll_frames)
        bri = BriNetwork(
            establish="terminal",
            call_at=20_000_000,
            call_to="7349195",
            bearer=audio_bearer(CAPABILITY_AUDIO_31KHZ),
            media_peer=peer,
        )
        transcript: list[tuple[int, str, str]] = []
        machine = IsdnMachine(
            NacImage.load(args.imodem),
            with_dsp=True,
            profile=False,
            bri=bri,
            flash_nvram=None,
            serial_pump=scripted_pump(
                ["ATA"], after=30_000_000, every=0, transcript=transcript
            ),
        )
        try:
            imodem_result = machine.run(args.instructions).to_dict()
        finally:
            peer.stop()
            machine.mailbox.close()

        analog_stdout, analog_stderr = analog.communicate(timeout=60)
        if analog.returncode:
            raise RuntimeError(
                f"analog process exited {analog.returncode}: {analog_stderr.strip()}"
            )
        analog_result = json.loads(analog_stdout)

    result = {
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
