from __future__ import annotations

from dataclasses import dataclass, field
import socket
import struct
import time
from typing import Any

from .daa import DAA_FRAME_SAMPLES, INSTRUCTIONS_PER_MS


# One exchange carries one 100 ms ASIC frame, which is the same unit the DAA
# renders into the C52 receive queue.
LINE_FRAME_SAMPLES = DAA_FRAME_SAMPLES
LINE_FRAME_MS = LINE_FRAME_SAMPLES * 1_000 // 9_600
LINE_FRAME_INSTRUCTIONS = LINE_FRAME_MS * INSTRUCTIONS_PER_MS

# Each side blocks until the far end delivers its frame, which is what keeps
# two independently executing instances on the same emulated clock. The timeout
# only exists so a peer that stops early ends the call instead of the run.
LINE_TIMEOUT_SECONDS = 30.0

# Shortest limit across the platforms this runs on (macOS is 104 with the
# terminator, Linux 108).
MAX_SOCKET_PATH = 100

_HEADER = struct.Struct("<IBBH")


@dataclass
class LineFrame:
    instructions: int
    off_hook: bool
    ringing: bool
    samples: list[int]

    def encode(self) -> bytes:
        body = b"".join(
            int(sample).to_bytes(2, "little", signed=True) for sample in self.samples
        )
        header = _HEADER.pack(
            self.instructions & 0xFFFFFFFF,
            int(self.off_hook),
            int(self.ringing),
            len(self.samples),
        )
        return header + body

    @classmethod
    def decode(cls, header: bytes, body: bytes) -> "LineFrame":
        instructions, off_hook, ringing, count = _HEADER.unpack(header)
        samples = [
            int.from_bytes(body[index : index + 2], "little", signed=True)
            for index in range(0, 2 * count, 2)
        ]
        return cls(instructions, bool(off_hook), bool(ringing), samples)


@dataclass
class LineLink:
    """A two-wire line shared by two Courier instances.

    Each side hands over one frame of what it is putting on the line and blocks
    for the far end's frame, so the two runs advance together in emulated time
    without either needing to know how fast the other executes.

    This is the subscriber loop only: hook state, ring, and audio. It carries no
    call setup, because a dedicated line has none - both ends are simply
    connected, and each sees the other go off hook.
    """

    path: str
    listen: bool = False
    frames: int = 0
    peer_off_hook: bool = False
    peer_ringing: bool = False
    peer_instructions: int = 0
    closed: bool = False
    error: str | None = None
    received_samples: int = 0
    sent_samples: int = 0
    _socket: Any = field(default=None, repr=False)
    _server: Any = field(default=None, repr=False)
    _inbound: list[int] = field(default_factory=list, repr=False)

    def open(self) -> None:
        """Bind or connect the socket. The listening side binds first."""
        # A UNIX socket path is a fixed-size field in the kernel, and the
        # failure it produces otherwise says nothing about which path was
        # too long.
        if len(self.path.encode()) > MAX_SOCKET_PATH:
            raise ValueError(
                f"line socket path is {len(self.path)} characters; "
                f"a UNIX socket path fits {MAX_SOCKET_PATH}"
            )
        if self.listen:
            self._server = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
            self._server.bind(self.path)
            self._server.listen(1)
            self._server.settimeout(LINE_TIMEOUT_SECONDS)
            self._socket, _ = self._server.accept()
        else:
            self._socket = self._connect()
        self._socket.settimeout(LINE_TIMEOUT_SECONDS)

    def _connect(self) -> Any:
        """Connect, waiting for the far end to finish binding.

        The socket file appears at bind, before the listen that makes it
        accept, so a connect that wins that race is refused rather than
        queued. Retrying until the timeout also lets the two sides start in
        either order.
        """
        deadline = time.monotonic() + LINE_TIMEOUT_SECONDS
        while True:
            handle = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
            try:
                handle.connect(self.path)
                return handle
            except (FileNotFoundError, ConnectionRefusedError):
                handle.close()
                if time.monotonic() >= deadline:
                    raise
                time.sleep(0.01)

    @property
    def connected(self) -> bool:
        return self._socket is not None and not self.closed

    def exchange(self, frame: LineFrame) -> None:
        """Put one frame on the line and take the far end's frame off it."""
        if not self.connected:
            return
        try:
            self._socket.sendall(frame.encode())
            header = self._receive(_HEADER.size)
            instructions, off_hook, ringing, count = _HEADER.unpack(header)
            body = self._receive(2 * count)
        except (OSError, ConnectionError) as exc:
            # A peer that stops early leaves the line dead rather than hanging
            # this side for the rest of its instruction budget.
            self.error = str(exc)
            self._release()
            return
        self.frames += 1
        self.sent_samples += len(frame.samples)
        self.peer_instructions = instructions
        self.peer_off_hook = bool(off_hook)
        self.peer_ringing = bool(ringing)
        peer = LineFrame.decode(header, body)
        self._inbound.extend(peer.samples)
        self.received_samples += len(peer.samples)

    def receive_audio(self, count: int | None = None) -> list[int]:
        """Take samples the far end has put on the line."""
        if count is None or count >= len(self._inbound):
            samples, self._inbound = self._inbound, []
            return samples
        samples, self._inbound = self._inbound[:count], self._inbound[count:]
        return samples

    def _receive(self, count: int) -> bytes:
        chunks = bytearray()
        while len(chunks) < count:
            chunk = self._socket.recv(count - len(chunks))
            if not chunk:
                raise ConnectionError("the far end closed the line")
            chunks.extend(chunk)
        return bytes(chunks)

    def _release(self) -> None:
        self.closed = True
        self.peer_off_hook = False
        self.peer_ringing = False
        for handle in (self._socket, self._server):
            if handle is not None:
                try:
                    handle.close()
                except OSError:
                    pass
        self._socket = None
        self._server = None

    def close(self) -> None:
        if self._socket is not None or self._server is not None:
            self._release()

    def status(self) -> dict[str, Any]:
        return {
            "path": self.path,
            "listen": self.listen,
            "frames": self.frames,
            "connected": self.connected,
            "peer_off_hook": self.peer_off_hook,
            "peer_instructions": self.peer_instructions,
            "samples_sent": self.sent_samples,
            "samples_received": self.received_samples,
            "error": self.error,
        }
