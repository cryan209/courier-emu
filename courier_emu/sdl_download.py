"""Host side of the Courier boot-block flash loader, as used by FreeLSD/SDL.EXE.

This drives the downloader that lives in the top 16 KiB flash block, recovered
from ``artifacts/courier-board-21210-capture-01/courier-board.rom``. It is a
different mechanism from the application's ``AT~X!`` XMODEM updater and takes a
raw 512 KiB flash image rather than an ``.XMD`` container.

The modem only runs this loader after a reset that either fails the flash CRC or
matches the bootstrap DIP-switch combination (1, 5 and 10 on, 8 off on external
units). Nothing here can put a running modem into that state.

Building and checking a stream is offline and side-effect free. Programming is
opt-in: ``--device`` alone still only reports, and ``--program`` is required
before a single byte is sent to hardware.
"""
from __future__ import annotations

import argparse
from datetime import datetime, timezone
import fcntl
from hashlib import sha256
import json
import os
from pathlib import Path
import select
import stat
import struct
import termios
import time

IMAGE_LENGTH = 0x80000
FLASH_BASE = 0x80000

# fc00:0de6 and fc00:0f61 sample the receive line as P2PIN bit 6 under timer
# control, assemble one character and require (byte & 0x5f) == 'A'. The captured
# timer value then becomes B0CMP, so the host sets the rate by sending 'A'.
AUTOBAUD = b"A"
# B0CMP values this loader installs, and the rates they give on a 20.16 MHz part.
BAUD_CMP = {57600: 0x802A, 19200: 0x8082, 9600: 0x8102}
# fc00:0992 drops to 19200 to read the host's 'Q' and to 9600 to echo it, then
# restores whatever autobaud chose. A host has to follow both switches.
HANDSHAKE_BAUD = (19200, 9600)

# fc00:0d0c compares eight received bytes against the constant at RAM 0x141
# before it will talk to a host at all; '!' as the first byte boots instead.
KNOCK = bytes.fromhex("02 45 07 48 6D 58 09 08".replace(" ", ""))
BOOT_APPLICATION = 0x21

# Blocks of the 4-Mbit top-boot part, from the table at fc00:0393.
BLOCKS = (
    (0x80000, 0x20000),
    (0xA0000, 0x20000),
    (0xC0000, 0x20000),
    (0xE0000, 0x18000),
    (0xF8000, 0x2000),
    (0xFA000, 0x2000),
    (0xFC000, 0x4000),
)
# fc00:0441 never erases these two, so their contents survive a download and a
# record that targets them would program into un-erased flash.
PROTECTED_BLOCKS = (4, 5)
# fc00:0956 computes the image CRC and programs it here itself, in download
# mode. The stream must leave the word alone.
CRC_WORD = 0xF7FFE

# Modem replies. fc00:0888 sends the raw failure code from the record loop.
REPLY = {
    0x14: "complete",
    0x15: "erasing",
    0x16: "erase complete, send records",
    0x17: "record stream ended",
    0x18: "record checksum error",
    0x19: "image CRC mismatch",
    0x1A: "program timeout",
    0x1B: "erase failed",
    0x1D: "block erase error",
}


def flash_crc_step(crc: int, byte: int) -> int:
    """One byte of the table-less CRC-16 at fc00:026f."""
    dx = crc
    al = (byte ^ (dx & 0xFF)) & 0xFF
    dx = (dx & 0xFF00) | al
    ax = (al << 4) & 0xFFFF
    dx ^= ax
    ax = (ax >> 1) & 0xFFFF
    dx = ((dx & 0xFF) << 8) | ((dx >> 8) & 0xFF)
    dx ^= ax
    ax = (ax << 4) & 0xFFFF
    ax = (ax & 0x00FF) | (((ax >> 8) & 0x07) << 8)
    dx ^= ax
    ax = (ax << 1) & 0xFFFF
    return (dx & 0xFF00) | ((dx & 0xFF) ^ ((ax >> 8) & 0xFF))


def crc_spans(image_type: int) -> tuple[tuple[int, int], ...]:
    """Physical spans the loader walks at fc00:08a3, in order.

    Type 2 covers c0000..f7ffd once. Type 4 reaches that code by falling through
    a first pass over c0000..fffff, so four blocks are summed twice and the
    parameter blocks and boot block are included. That is what the ROM does, not
    a transcription slip: both loops start at segment c000.
    """
    tail = ((0xC0000, 0x10000), (0xD0000, 0x10000), (0xE0000, 0x10000), (0xF0000, 0x7FFE))
    if image_type == 2:
        return tail
    return ((0xC0000, 0x10000), (0xD0000, 0x10000), (0xE0000, 0x10000), (0xF0000, 0x10000)) + tail


def flash_crc(resident: bytes, image_type: int = 2) -> int:
    """CRC of a 512 KiB flash image, as the modem will compute it after writing."""
    if len(resident) != IMAGE_LENGTH:
        raise ValueError("expected a 512 KiB flash image")
    crc = 0xFFFF
    for start, length in crc_spans(image_type):
        base = start - FLASH_BASE
        for offset in range(base, base + length):
            crc = flash_crc_step(crc, resident[offset])
    return crc


def erased_spans(image_type: int) -> tuple[tuple[int, int], ...]:
    """Physical spans the loader erases, from fc00:043d.

    A 256 KiB image on a 512 KiB part starts at block 2; every image skips the
    two parameter blocks. The boot block is always in the range, so a download
    always replaces the loader and the reset vector.
    """
    first = 2 if image_type == 2 else 0
    return tuple(
        BLOCKS[index]
        for index in range(first, len(BLOCKS))
        if index not in PROTECTED_BLOCKS
    )


def resident_image(image: bytes, preserved: bytes, image_type: int = 2) -> bytes:
    """The flash contents after this download: new where erased, old elsewhere."""
    if len(image) != IMAGE_LENGTH or len(preserved) != IMAGE_LENGTH:
        raise ValueError("expected 512 KiB images")
    out = bytearray(preserved)
    for start, length in erased_spans(image_type):
        base = start - FLASH_BASE
        out[base:base + length] = image[base:base + length]
    # The loader programs the CRC word itself, over erased flash.
    out[CRC_WORD - FLASH_BASE:CRC_WORD - FLASH_BASE + 2] = b"\xff\xff"
    return bytes(out)


def payload_spans(image_type: int = 2) -> tuple[tuple[int, int], ...]:
    """Erased spans minus the CRC word the loader writes for itself."""
    spans = []
    for start, length in erased_spans(image_type):
        if start <= CRC_WORD < start + length:
            head = CRC_WORD - start
            if head:
                spans.append((start, head))
            tail_start = CRC_WORD + 2
            if tail_start < start + length:
                spans.append((tail_start, start + length - tail_start))
        else:
            spans.append((start, length))
    return tuple(spans)


def record(offset: int, kind: int, data: bytes) -> bytes:
    """One loader record: [len][off_hi][off_lo][type][data...][checksum].

    The state machine at fc00:0b65 sums every byte including the checksum and
    requires zero. Data records land as little-endian words at ES:offset.
    """
    if not 0 <= offset <= 0xFFFF or not 0 <= kind <= 0xFF or len(data) > 0xFF:
        raise ValueError("record field out of range")
    body = bytes((len(data), (offset >> 8) & 0xFF, offset & 0xFF, kind)) + data
    return body + bytes((-sum(body) & 0xFF,))


def build_records(image: bytes, image_type: int = 2, chunk: int = 128) -> bytes:
    """Segment and data records covering everything this download erases."""
    if len(image) != IMAGE_LENGTH:
        raise ValueError("expected a 512 KiB flash image")
    if chunk % 2 or not 2 <= chunk <= 0xFE:
        raise ValueError("chunk must be an even record length the loader can hold")
    stream = bytearray()
    segment = None
    for start, length in payload_spans(image_type):
        for address in range(start, start + length, chunk):
            size = min(chunk, start + length - address)
            want = (address & 0xF0000) >> 4
            if want != segment:
                stream += record(0, 2, struct.pack(">H", want))
                segment = want
            base = address - FLASH_BASE
            stream += record(address & 0xFFFF, 0, image[base:base + size])
    # Any type that is neither 0 nor 2 ends the stream; fc00:0b9d returns 0x17.
    stream += record(0, 1, b"")
    return bytes(stream)


class LoaderModel:
    """The modem's record state machine, from fc00:0b65 through fc00:0c66.

    Programming models NOR flash: a word may only be driven from 0xffff, so a
    record aimed at an un-erased address is reported rather than silently
    accepted, exactly as the device status poll at fc00:0c67 would.
    """

    def __init__(self, erased: tuple[tuple[int, int], ...]):
        self.memory = bytearray(b"\xff" * IMAGE_LENGTH)
        self.written = bytearray(IMAGE_LENGTH)
        self.erased = erased
        self.segment = 0
        self.result: int | None = None

    def _erased_at(self, address: int) -> bool:
        return any(start <= address < start + length for start, length in self.erased)

    def feed(self, stream: bytes) -> int:
        index = 0
        while index < len(stream):
            length, offset_hi, offset_lo, kind = stream[index:index + 4]
            offset = (offset_hi << 8) | offset_lo
            body = stream[index + 4:index + 4 + length]
            checksum = stream[index + 4 + length]
            if (length + offset_hi + offset_lo + kind + sum(body) + checksum) & 0xFF:
                self.result = 0x18
                return self.result
            index += 5 + length
            if kind == 2:
                self.segment = struct.unpack(">H", body)[0]
                continue
            if kind != 0:
                self.result = 0x17
                return self.result
            address = (self.segment << 4) + offset
            padded = body + b"\xff" * (len(body) % 2)
            for step in range(0, len(padded), 2):
                target = address + step
                if not self._erased_at(target):
                    raise AssertionError(f"record programs un-erased {target:#07x}")
                base = target - FLASH_BASE
                self.memory[base:base + 2] = padded[step:step + 2]
                self.written[base:base + 2] = b"\x01\x01"
        self.result = 0x1A
        return self.result


class Port:
    """Raw serial access, with the rate changes the handshake needs."""

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
            self.set_baud(self.baud)
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

    def set_baud(self, baud: int) -> None:
        settings = termios.tcgetattr(self.fd)
        settings[0] = settings[1] = settings[3] = 0
        settings[2] = termios.CS8 | termios.CREAD | termios.CLOCAL
        settings[4] = settings[5] = getattr(termios, f"B{baud}")
        settings[6][termios.VMIN] = 0
        settings[6][termios.VTIME] = 0
        termios.tcdrain(self.fd)
        termios.tcsetattr(self.fd, termios.TCSANOW, settings)

    def write(self, data: bytes, timeout: float = 30.0) -> None:
        deadline = time.monotonic() + timeout
        while data:
            left = deadline - time.monotonic()
            if left <= 0 or not select.select([], [self.fd], [], left)[1]:
                raise TimeoutError("serial write timed out")
            data = data[os.write(self.fd, data):]

    def read(self, count: int, timeout: float) -> bytes:
        deadline = time.monotonic() + timeout
        out = bytearray()
        while len(out) < count:
            left = deadline - time.monotonic()
            if left <= 0 or not select.select([self.fd], [], [], left)[0]:
                raise TimeoutError(f"expected {count} bytes, received {bytes(out)!r}")
            chunk = os.read(self.fd, count - len(out))
            if chunk:
                out.extend(chunk)
        return bytes(out)


class Session:
    """The download exchange, transcribed from the boot block.

    fc00:0d38 arms the software autobaud, fc00:0d0c gates on the eight-byte
    knock, fc00:0992 runs the identify handshake, and fc00:0842 sends 0x15, then
    0x16 once the erase completes, before the record stream. None of this has
    been exercised against hardware or an emulated loader; every byte is logged
    so a failed attempt can be read back.
    """

    def __init__(self, port: Port, log: list):
        self.port, self.log = port, log

    def _note(self, direction: str, data: bytes, **fields) -> None:
        self.log.append({
            "at": datetime.now(timezone.utc).isoformat(),
            "direction": direction, "bytes": data.hex(), **fields,
        })

    def knock(self, attempts: int = 8) -> bytes:
        """Autobaud, then present the knock until the loader answers 0xe3."""
        for attempt in range(attempts):
            self.port.write(AUTOBAUD * 4 + KNOCK)
            self._note("out", AUTOBAUD * 4 + KNOCK, step="autobaud+knock", attempt=attempt)
            try:
                reply = self.port.read(1, timeout=2.0)
            except TimeoutError:
                continue
            self._note("in", reply, step="knock reply")
            if reply == b"\xe3":
                return reply
            # A mismatched knock prints the corrupted-firmware banner and rearms.
            raise RuntimeError(f"loader answered {reply!r}, not 0xe3")
        raise TimeoutError("no 0xe3 from the loader; is it in bootstrap mode?")

    def identify(self) -> bytes:
        self.port.set_baud(HANDSHAKE_BAUD[0])
        self.port.write(b"Q")
        self._note("out", b"Q", step="identify", baud=HANDSHAKE_BAUD[0])
        self.port.set_baud(HANDSHAKE_BAUD[1])
        echo = self.port.read(1, timeout=5.0)
        self._note("in", echo, step="identify echo", baud=HANDSHAKE_BAUD[1])
        if echo != b"Q":
            raise RuntimeError(f"expected 'Q' echo, received {echo!r}")
        self.port.set_baud(self.port.baud)
        identity = self.port.read(4, timeout=5.0)
        self._note("in", identity, step="identity bytes")
        return identity

    def program(self, stream: bytes, image_type: int, crc: int,
                erase_timeout: float = 120.0) -> int:
        header = bytes((image_type, (crc >> 8) & 0xFF, crc & 0xFF))
        self.port.write(header)
        self._note("out", header, step="type and expected CRC")
        nak = self.port.read(1, timeout=10.0)
        self._note("in", nak, step="erase started")
        if nak != b"\x15":
            raise RuntimeError(f"expected 0x15 before erase, received {nak!r}")
        syn = self.port.read(1, timeout=erase_timeout)
        self._note("in", syn, step="erase complete")
        if syn != b"\x16":
            raise RuntimeError(f"erase reported {syn!r}")
        # From here the flash is erased; stopping leaves the modem in the loader.
        self.port.write(stream, timeout=600.0)
        self._note("out", b"", step="records sent", length=len(stream))
        result = self.port.read(1, timeout=120.0)
        self._note("in", result, step="result", meaning=REPLY.get(result[0], "unknown"))
        return result[0]


def describe(image: bytes, preserved: bytes, image_type: int, chunk: int) -> dict:
    stream = build_records(image, image_type, chunk)
    resident = resident_image(image, preserved, image_type)
    model = LoaderModel(erased_spans(image_type))
    result = model.feed(stream)
    covered = sum(length for _, length in payload_spans(image_type))
    mismatch = [
        FLASH_BASE + index
        for index in range(IMAGE_LENGTH)
        if model.written[index] and model.memory[index] != image[index]
    ]
    return {
        "image_sha256": sha256(image).hexdigest(),
        "preserved_sha256": sha256(preserved).hexdigest(),
        "image_type": image_type,
        "record_chunk": chunk,
        "stream_bytes": len(stream),
        "payload_bytes": covered,
        "erased_spans": [[start, length] for start, length in erased_spans(image_type)],
        "protected_spans": [[BLOCKS[i][0], BLOCKS[i][1]] for i in PROTECTED_BLOCKS],
        "expected_crc": flash_crc(resident, image_type),
        "stored_crc_in_image": struct.unpack_from("<H", image, CRC_WORD - FLASH_BASE)[0],
        "model_result": result,
        "model_result_text": REPLY.get(result, "unknown"),
        "model_bytes_written": sum(model.written),
        "model_mismatches": len(mismatch),
        "handshake": {
            "knock": KNOCK.hex(),
            "host_sends_after_id": ["image_type", "crc_high", "crc_low"],
        },
        "generated": datetime.now(timezone.utc).isoformat(),
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("image", type=Path, help="512 KiB raw flash image to send")
    parser.add_argument(
        "--preserved",
        type=Path,
        required=True,
        help="current flash capture; supplies the blocks this download will not erase",
    )
    parser.add_argument("--image-type", type=int, choices=(2, 4), default=4)
    parser.add_argument("--chunk", type=int, default=128)
    parser.add_argument("--output", type=Path, help="new directory for the stream and report")
    parser.add_argument("--device", help="serial device the modem's loader is listening on")
    parser.add_argument("--baud", type=int, choices=tuple(BAUD_CMP), default=57600)
    parser.add_argument(
        "--program",
        action="store_true",
        help="erase and reprogram the modem's flash; without it --device only identifies",
    )
    args = parser.parse_args()

    image = args.image.read_bytes()
    preserved = args.preserved.read_bytes()
    report = describe(image, preserved, args.image_type, args.chunk)
    if report["model_mismatches"]:
        print(json.dumps(report, indent=2))
        return 1

    if args.device is not None:
        if args.output is None:
            raise SystemExit("--device requires --output for the transcript")
        stream = build_records(image, args.image_type, args.chunk)
        transcript: list = []
        with Port(args.device, args.baud) as port:
            session = Session(port, transcript)
            session.knock()
            report["identity"] = session.identify().hex()
            if args.program:
                report["result"] = session.program(
                    stream, args.image_type, report["expected_crc"]
                )
                report["result_text"] = REPLY.get(report["result"], "unknown")
            else:
                report["result_text"] = "identified only; --program not given"
        report["transcript"] = transcript

    print(json.dumps(report, indent=2))
    if args.output is not None:
        args.output.mkdir(parents=True)
        (args.output / "records.bin").write_bytes(
            build_records(image, args.image_type, args.chunk)
        )
        (args.output / "report.json").write_text(json.dumps(report, indent=2) + "\n")
    return 0 if report.get("result", 0x14) == 0x14 else 1


if __name__ == "__main__":
    raise SystemExit(main())
