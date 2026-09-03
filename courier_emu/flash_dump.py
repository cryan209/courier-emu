"""Read the 20.16 MHz Courier's 512 KiB flash through ATGLK2, without uploading.

Only AT, ATI7 and ATGLK2=<segment>:<offset> are sent. No reset, configuration,
memory-write, flash-programming, dial or download commands are implemented.
"""
from __future__ import annotations

import argparse
from collections import Counter
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

BASE, LENGTH, PAGE = 0x80000, 0x80000, 0x100
FIRST = bytes.fromhex("BD 0B 00 E9 7C 0F 0D 0A")
RESET = bytes.fromhex("FA BA A4 FF B8 00 80 EF EA E9 11 00 FC 06 00 00")
TERMINAL = re.compile(rb"(?:^|[\r\n])(OK|ERROR)[\r\n]+$")
ROW = re.compile(r"([0-9A-F]{4}):([0-9A-F]{4})\s+((?:[0-9A-F]{2}\s+){15}[0-9A-F]{2})", re.I)


def command_for(address: int, *, allow_ram: bool = False, allow_upper_ram: bool = False) -> str:
    in_flash = BASE <= address < BASE + LENGTH
    # The relocated peripheral control block occupies ff00..ffff. Reading it
    # as RAM could consume UART data or acknowledge device status.
    in_ram = allow_ram and 0 <= address < 0xFF00
    in_upper_ram = allow_upper_ram and 0x10000 <= address < 0x20000
    if not (in_flash or in_ram or in_upper_ram) or address % PAGE:
        raise ValueError("address is outside the allowed aligned flash/RAM pages")
    segment = (address & 0xF0000) >> 4
    return f"ATGLK2={segment:04X}:{address & 0xFFFF:04X}"


def parse_page(raw: bytes, address: int, *, allow_ram: bool = False,
               allow_upper_ram: bool = False) -> tuple[bytes, str]:
    command = command_for(address, allow_ram=allow_ram, allow_upper_ram=allow_upper_ram)
    try:
        lines = [line.strip() for line in raw.decode("ascii").splitlines() if line.strip()]
    except UnicodeDecodeError as exc:
        raise ValueError("non-ASCII response") from exc
    if lines and lines[0].upper() == command:
        lines.pop(0)
    if len(lines) != 17 or lines[-1] not in ("OK", "ERROR"):
        raise ValueError("expected exactly 16 rows followed by OK or ERROR")
    segment = (address & 0xF0000) >> 4
    offset = address & 0xFFFF
    data = bytearray()
    for index, line in enumerate(lines[:-1]):
        match = ROW.fullmatch(line)
        if match is None:
            raise ValueError(f"malformed row {index}")
        if (int(match[1], 16), int(match[2], 16)) != (segment, offset + 16 * index):
            raise ValueError(f"wrong, duplicate or out-of-order address in row {index}")
        data.extend(bytes.fromhex(match[3]))
    return bytes(data), lines[-1]


class SerialPort:
    """Small POSIX serial transport; preserves the host's original settings."""

    def __init__(self, device: str, baud: int, *, allow_ram: bool = False,
                 allow_upper_ram: bool = False):
        self.device, self.baud = device, baud
        self.allow_ram = allow_ram
        self.allow_upper_ram = allow_upper_ram
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
            settings[0] = 0  # raw input, including no XON/XOFF consumption
            settings[1] = 0
            settings[2] = termios.CS8 | termios.CREAD | termios.CLOCAL
            settings[3] = 0
            settings[4] = settings[5] = getattr(termios, f"B{self.baud}")
            settings[6][termios.VMIN] = 0
            settings[6][termios.VTIME] = 0
            termios.tcsetattr(self.fd, termios.TCSANOW, settings)
            # Keep the host ready to receive; do not deliberately drop DTR.
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

    def drain(self, quiet: float = 0.2) -> bytes:
        result = bytearray()
        deadline = time.monotonic() + 2
        while time.monotonic() < deadline and select.select([self.fd], [], [], quiet)[0]:
            chunk = os.read(self.fd, 4096)
            if not chunk:
                break
            result.extend(chunk)
            if len(result) > 16384:
                raise RuntimeError("continuous unsolicited input; stop before issuing commands")
        return bytes(result)

    def query(self, command: str, timeout: float = 4.0) -> bytes:
        if command not in ("AT", "ATI7"):
            match = re.fullmatch(r"ATGLK2=([0-9A-F]{4}):([0-9A-F]{4})", command)
            if not match:
                raise ValueError("command is not an allowed read operation")
            address = int(match[1], 16) * 16 + int(match[2], 16)
            if command_for(address, allow_ram=self.allow_ram,
                           allow_upper_ram=self.allow_upper_ram) != command:
                raise ValueError("noncanonical memory address")
        data = (command + "\r").encode("ascii")
        deadline = time.monotonic() + timeout
        while data:
            left = deadline - time.monotonic()
            if left <= 0 or not select.select([], [self.fd], [], left)[1]:
                raise TimeoutError("serial write timed out")
            data = data[os.write(self.fd, data):]
        response = bytearray()
        while time.monotonic() < deadline:
            left = max(0, deadline - time.monotonic())
            if not select.select([self.fd], [], [], min(0.2, left))[0]:
                continue
            chunk = os.read(self.fd, 4096)
            if not chunk:
                continue
            response.extend(chunk)
            if len(response) > 16384:
                raise RuntimeError("response exceeds expected maximum length")
            if TERMINAL.search(response):
                break
        return bytes(response)


def validate_identity(raw: bytes) -> str:
    text = raw.decode("ascii")
    expected = (r"Courier", r"Clock Freq\s+20\.16Mhz", r"Flash ROM\s+512k",
                r"Supervisor rev\s+7\.3\.14", r"DSP rev\s+3\.0\.13")
    if not all(re.search(pattern, text, re.I) for pattern in expected):
        raise ValueError("ATI7 does not match the requested 20.16 MHz / 512k / 7.3.14 / 3.0.13 target")
    if not TERMINAL.search(raw) or TERMINAL.search(raw)[1] != b"OK":
        raise ValueError("incomplete or failed ATI7 response")
    return text


def collect(port, output: Path) -> dict:
    """Fresh captures only. Partial block files survive any interrupted run."""
    output.mkdir(parents=True, exist_ok=False)
    (output / "responses").mkdir()
    (output / "blocks").mkdir()
    started = time.monotonic()
    report = {
        "status": "running", "device": port.device, "baud": port.baud,
        "started_utc": datetime.now(timezone.utc).isoformat(),
        "physical_start": BASE, "length": LENGTH, "page_bytes": PAGE,
        "copies_required_per_page": 2, "pages_verified": 0,
        "terminal_status_counts": {}, "failed_attempts": [],
        "firmware_writes": False, "firmware_upload": False,
        "assumptions": ["CPU addresses 80000..fffff expose the 512 KiB flash at runtime.",
                        "Identical repeated reads establish capture consistency, not the absence of bank aliases.",
                        "DSP internal ROM is outside the scope of this CPU-memory capture."],
    }
    counts = Counter()
    visits = Counter()

    def checkpoint():
        report["elapsed_seconds"] = round(time.monotonic() - started, 2)
        report["terminal_status_counts"] = dict(counts)
        temporary = output / "manifest.json.tmp"
        temporary.write_text(json.dumps(report, indent=2) + "\n")
        temporary.replace(output / "manifest.json")

    def page(address):
        visits[address] += 1
        visit = visits[address]
        for attempt in range(1, 4):
            pair = []
            try:
                for copy in range(1, 3):
                    raw = port.query(command_for(address))
                    name = f"{address:05x}-v{visit}-a{attempt}-copy{copy}.txt"
                    (output / "responses" / name).write_bytes(raw)
                    block, terminal = parse_page(raw, address)
                    counts[terminal] += 1
                    pair.append(block)
                if pair[0] != pair[1]:
                    raise ValueError("two reads of the same flash page disagree")
                return pair[0]
            except (ValueError, TimeoutError) as exc:
                report["failed_attempts"].append({"address": address, "attempt": attempt, "error": str(exc)})
                (output / "responses" / f"{address:05x}-v{visit}-a{attempt}-resync.bin").write_bytes(port.drain())
                checkpoint()
        raise RuntimeError(f"could not verify flash page {address:05x}; partial capture preserved")

    checkpoint()
    try:
        (output / "startup.bin").write_bytes(port.drain())
        attention = port.query("AT")
        (output / "attention.txt").write_bytes(attention)
        if not TERMINAL.search(attention) or TERMINAL.search(attention)[1] != b"OK":
            raise RuntimeError("modem did not answer AT with OK at the selected baud")
        identity = port.query("ATI7")
        (output / "ati7.txt").write_bytes(identity)
        report["identity"] = validate_identity(identity)
        print(json.dumps({"event": "identity-confirmed", "device": port.device}), flush=True)
        # Check the two pages the user already demonstrated before bulk reads.
        anchors = {BASE: page(BASE), BASE + LENGTH - PAGE: page(BASE + LENGTH - PAGE)}
        if not anchors[BASE].startswith(FIRST) or anchors[BASE + LENGTH - PAGE][-16:] != RESET:
            raise RuntimeError("flash anchors differ from the user's confirmed hardware captures")
        print(json.dumps({"event": "anchors-confirmed", "reset_entry": "fc00:11e9"}), flush=True)
        image = bytearray()
        with (output / "pages.jsonl").open("x") as log:
            for address in range(BASE, BASE + LENGTH, PAGE):
                block = anchors[address] if address in anchors else page(address)
                (output / "blocks" / f"{address:05x}.bin").write_bytes(block)
                image.extend(block)
                log.write(json.dumps({"physical_address": address, "bytes": len(block),
                                      "sha256": sha256(block).hexdigest(), "matching_copies": 2}) + "\n")
                log.flush()
                report["pages_verified"] += 1
                if report["pages_verified"] % 64 == 0:
                    checkpoint()
                    print(json.dumps({"event": "progress", "pages": report["pages_verified"],
                                      "total": LENGTH // PAGE, "elapsed_seconds": report["elapsed_seconds"]}), flush=True)
        if len(image) != LENGTH:
            raise RuntimeError("assembled image has the wrong length")
        # Revisit anchors after the sweep to detect a changed target/mapping.
        for address, block in anchors.items():
            final = page(address)
            if final != block:
                raise RuntimeError("flash anchor changed during capture")
        target = output / "courier-board.rom"
        with target.open("xb") as stream:
            stream.write(image)
            stream.flush()
            os.fsync(stream.fileno())
        report.update(status="complete", image=target.name, sha256=sha256(image).hexdigest(),
                      anchors_rechecked=True, finished_utc=datetime.now(timezone.utc).isoformat())
        return report
    except BaseException as exc:
        report.update(status="incomplete", error=f"{type(exc).__name__}: {exc}")
        raise
    finally:
        checkpoint()


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--device", required=True)
    parser.add_argument("--baud", type=int, choices=(9600, 19200, 38400, 57600, 115200), default=115200)
    parser.add_argument("--output", type=Path, required=True, help="new directory for raw replies, blocks and image")
    args = parser.parse_args()
    if args.output.exists():
        parser.error("output directory already exists; use a new directory")
    try:
        with SerialPort(args.device, args.baud) as port:
            result = collect(port, args.output)
        print(json.dumps(result, indent=2))
        return 0
    except (OSError, ValueError, RuntimeError) as exc:
        print(json.dumps({"status": "failed", "error": str(exc), "output": str(args.output)}), flush=True)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
