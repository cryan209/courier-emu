"""Send an .XMD firmware image to the Courier's AT~X! updater over XMODEM.

Test mode is the default and the only mode this tool will enter without an
explicit override. At the prompt, 'T' sets bit 5 of the loader's flag byte
(fc00-resident `[0x124]`, set at file 0x27fa3) and nothing else; the block commit
at 0x28400 tests that bit and takes a path that accumulates the image CRC and
advances the destination address without reaching either the erase call at
0x27c2a or the program call at 0x2890c. 'Y' differs only in not setting it.

The transfer is otherwise identical to a real update, so a test run exercises the
header validation, the product and compatibility gates, the XOR chain and the
whole 4097-block transfer against real hardware.
"""
from __future__ import annotations

import argparse
from datetime import datetime, timezone
import fcntl
from hashlib import sha256
import json
import os
from pathlib import Path
import re
import select
import stat
import struct
import termios
import time

SOH, EOT, ACK, NAK, CAN, SUB = 0x01, 0x04, 0x06, 0x15, 0x18, 0x1A
CRC_REQUEST = 0x43  # 'C'
BLOCK = 128
PROMPT = re.compile(rb"\(Y\)es\s*\(N\)o\s*\(T\)est\s*>")
BEGIN = re.compile(rb"Begin Xmodem file transfer now\.")


def crc16(data: bytes) -> int:
    crc = 0
    for byte in data:
        crc ^= byte << 8
        for _ in range(8):
            crc = ((crc << 1) ^ 0x1021) & 0xFFFF if crc & 0x8000 else (crc << 1) & 0xFFFF
    return crc


def frame(number: int, payload: bytes, use_crc: bool) -> bytes:
    if len(payload) != BLOCK:
        raise ValueError("XMODEM blocks are 128 bytes")
    head = bytes((SOH, number & 0xFF, (~number) & 0xFF))
    tail = struct.pack(">H", crc16(payload)) if use_crc else bytes((sum(payload) & 0xFF,))
    return head + payload + tail


class Port:
    def __init__(self, device: str, baud: int):
        self.device, self.baud = device, baud
        self.fd = None
        self.original = None

    def __enter__(self):
        if not stat.S_ISCHR(os.stat(self.device).st_mode):
            raise ValueError("serial device must be a character device")
        self.fd = os.open(self.device, os.O_RDWR | os.O_NOCTTY | os.O_NONBLOCK)
        try:
            fcntl.flock(self.fd, fcntl.LOCK_EX | fcntl.LOCK_NB)
            fcntl.ioctl(self.fd, termios.TIOCEXCL)
            self.original = termios.tcgetattr(self.fd)
            settings = termios.tcgetattr(self.fd)
            settings[0] = settings[1] = settings[3] = 0
            settings[2] = termios.CS8 | termios.CREAD | termios.CLOCAL
            settings[4] = settings[5] = getattr(termios, f"B{self.baud}")
            settings[6][termios.VMIN] = 0
            settings[6][termios.VTIME] = 0
            termios.tcsetattr(self.fd, termios.TCSANOW, settings)
            fcntl.ioctl(self.fd, termios.TIOCMBIS,
                        struct.pack("I", termios.TIOCM_DTR | termios.TIOCM_RTS))
            return self
        except BaseException:
            self.__exit__(None, None, None)
            raise

    def __exit__(self, *_):
        if self.fd is not None:
            try:
                if self.original is not None:
                    restored = self.original.copy()
                    restored[2] &= ~termios.HUPCL
                    termios.tcsetattr(self.fd, termios.TCSANOW, restored)
            finally:
                try:
                    fcntl.ioctl(self.fd, termios.TIOCNXCL)
                finally:
                    os.close(self.fd)
                    self.fd = None

    def write(self, data: bytes, timeout: float = 30.0) -> None:
        deadline = time.monotonic() + timeout
        while data:
            left = deadline - time.monotonic()
            if left <= 0 or not select.select([], [self.fd], [], left)[1]:
                raise TimeoutError("serial write timed out")
            data = data[os.write(self.fd, data):]

    def byte(self, timeout: float) -> int | None:
        deadline = time.monotonic() + timeout
        while True:
            left = deadline - time.monotonic()
            if left <= 0 or not select.select([self.fd], [], [], left)[0]:
                return None
            chunk = os.read(self.fd, 1)
            if chunk:
                return chunk[0]

    def until(self, pattern: re.Pattern, timeout: float) -> bytes:
        deadline = time.monotonic() + timeout
        seen = bytearray()
        while time.monotonic() < deadline:
            left = max(0.0, deadline - time.monotonic())
            if not select.select([self.fd], [], [], min(0.3, left))[0]:
                continue
            chunk = os.read(self.fd, 4096)
            if chunk:
                seen.extend(chunk)
                if pattern.search(seen):
                    return bytes(seen)
        raise TimeoutError(f"no match for {pattern.pattern!r}; saw {bytes(seen)!r}")

    def drain(self, quiet: float = 0.4, limit: float = 8.0) -> bytes:
        seen = bytearray()
        deadline = time.monotonic() + limit
        while time.monotonic() < deadline and select.select([self.fd], [], [], quiet)[0]:
            chunk = os.read(self.fd, 4096)
            if not chunk:
                break
            seen.extend(chunk)
        return bytes(seen)


def send(port: Port, image: bytes, log: list, answer: bytes = b"T") -> dict:
    if len(image) % BLOCK:
        raise ValueError("image is not a whole number of XMODEM blocks")

    def note(step: str, **fields):
        log.append({"at": datetime.now(timezone.utc).isoformat(), "step": step, **fields})

    port.drain()
    port.write(b"AT\r")
    hello = port.until(re.compile(rb"OK"), timeout=5.0)
    note("hello", saw=hello.decode("latin1"))

    port.write(b"AT~X!\r")
    prompt = port.until(PROMPT, timeout=10.0)
    note("prompt", saw=prompt.decode("latin1"))

    port.write(answer)
    begin = port.until(BEGIN, timeout=10.0)
    note("answered", answer=answer.decode("latin1"), saw=begin.decode("latin1"))
    if answer in (b"T", b"t") and b"Test" not in begin and b"test" not in begin:
        raise RuntimeError("modem did not acknowledge test mode; aborting")

    handshake = port.byte(timeout=30.0)
    while handshake is not None and handshake not in (CRC_REQUEST, NAK):
        handshake = port.byte(timeout=30.0)
    if handshake is None:
        raise TimeoutError("no XMODEM handshake character")
    use_crc = handshake == CRC_REQUEST
    note("handshake", mode="crc" if use_crc else "checksum")

    total = len(image) // BLOCK
    retries = 0
    for index in range(total):
        packet = frame(index + 1, image[index * BLOCK:(index + 1) * BLOCK], use_crc)
        for attempt in range(10):
            port.write(packet)
            reply = port.byte(timeout=15.0)
            if reply == ACK:
                break
            if reply == CAN:
                raise RuntimeError(f"modem cancelled at block {index + 1}")
            retries += 1
            note("retry", block=index + 1, attempt=attempt, reply=reply)
        else:
            raise RuntimeError(f"block {index + 1} refused after 10 attempts")

    port.write(bytes((EOT,)))
    final = port.byte(timeout=30.0)
    note("eot", reply=final)
    # The modem prints its verdict only after computing the CRC over 512 KiB,
    # which takes far longer than an inter-character gap. Wait for the first
    # byte with a long timeout before falling back to quiet detection.
    tail = bytearray()
    lead = port.byte(timeout=180.0)
    if lead is not None:
        tail.append(lead)
        tail.extend(port.drain(quiet=3.0, limit=120.0))
    note("result", saw=tail.decode("latin1", "replace"))
    return {
        "blocks": total,
        "mode": "crc" if use_crc else "checksum",
        "retries": retries,
        "eot_reply": final,
        "result_text": tail.decode("latin1", "replace"),
        "crc_ok": bool(re.search(rb"Calculating CRC\.*\s*OK", bytes(tail))),
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("image", type=Path, help=".XMD image to send")
    parser.add_argument("--device", required=True)
    parser.add_argument("--baud", type=int,
                        choices=(9600, 19200, 38400, 57600, 115200), default=57600)
    parser.add_argument("--output", type=Path, required=True,
                        help="new directory for the transcript")
    parser.add_argument(
        "--program-flash",
        action="store_true",
        help="answer Y and actually erase and reprogram; omit for the safe test run",
    )
    args = parser.parse_args()

    image = args.image.read_bytes()
    args.output.mkdir(parents=True)
    log: list = []
    report = {
        "image": str(args.image),
        "image_sha256": sha256(image).hexdigest(),
        "image_bytes": len(image),
        "device": args.device,
        "baud": args.baud,
        "answer": "Y" if args.program_flash else "T",
        "started": datetime.now(timezone.utc).isoformat(),
    }
    try:
        with Port(args.device, args.baud) as port:
            report.update(send(port, image, log,
                              answer=b"Y" if args.program_flash else b"T"))
        report["status"] = "complete"
    except BaseException as exc:
        report["status"] = "failed"
        report["error"] = f"{type(exc).__name__}: {exc}"
        raise
    finally:
        report["transcript"] = log
        report["finished"] = datetime.now(timezone.utc).isoformat()
        (args.output / "report.json").write_text(json.dumps(report, indent=2) + "\n")
        print(json.dumps({k: v for k, v in report.items() if k != "transcript"}, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
