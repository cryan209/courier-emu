from __future__ import annotations

from dataclasses import dataclass, field
from pathlib import Path
import socket
import struct
import time
import wave
from typing import Any

from .daa import DAA_FRAME_SAMPLES, DAA_SAMPLE_RATE, INSTRUCTIONS_PER_MS


# One exchange carries one 100 ms ASIC frame, which is the same unit the DAA
# renders into the C52 receive queue.
LINE_FRAME_SAMPLES = DAA_FRAME_SAMPLES
LINE_FRAME_MS = LINE_FRAME_SAMPLES * 1_000 // DAA_SAMPLE_RATE
LINE_FRAME_INSTRUCTIONS = LINE_FRAME_MS * INSTRUCTIONS_PER_MS

# Each side blocks until the far end delivers its frame, which is what keeps
# two independently executing instances on the same emulated clock. The timeout
# only exists so a peer that stops early ends the call instead of the run.
LINE_TIMEOUT_SECONDS = 30.0

# Shortest limit across the platforms this runs on (macOS is 104 with the
# terminator, Linux 108).
MAX_SOCKET_PATH = 100

_HEADER = struct.Struct("<IBBBH")
_AUDIO_HEADER = struct.Struct("<H")


# The switched call has one state, and it lives on the line rather than in
# either subscriber. Each end advertises the furthest point it knows the call
# has reached and adopts the later of its own view and the peer's, so both
# arrive at the same value within one frame. Every transition has exactly one
# end that can make it - only the calling end can seize and only the called
# end can answer - which is why this converges instead of oscillating.
CALL_IDLE = 0
CALL_SEIZED = 1      # the calling end has the loop; the switch is collecting
CALL_RINGING = 2     # the switch has the number and is ringing the called end
CALL_ANSWERED = 3    # the called end went off hook: the path is through
CALL_CLEARED = 4     # one end hung up

CALL_STATE_NAMES = {
    CALL_IDLE: "idle",
    CALL_SEIZED: "seized",
    CALL_RINGING: "ringing",
    CALL_ANSWERED: "answered",
    CALL_CLEARED: "cleared",
}


@dataclass
class LineFrame:
    instructions: int
    off_hook: bool
    ringing: bool
    samples: list[int]
    call_state: int = CALL_IDLE

    def encode(self) -> bytes:
        body = b"".join(
            int(sample).to_bytes(2, "little", signed=True) for sample in self.samples
        )
        header = _HEADER.pack(
            self.instructions & 0xFFFFFFFF,
            int(self.off_hook),
            int(self.ringing),
            int(self.call_state),
            len(self.samples),
        )
        return header + body

    @classmethod
    def decode(cls, header: bytes, body: bytes) -> "LineFrame":
        instructions, off_hook, ringing, call_state, count = _HEADER.unpack(header)
        samples = [
            int.from_bytes(body[index : index + 2], "little", signed=True)
            for index in range(0, 2 * count, 2)
        ]
        return cls(instructions, bool(off_hook), bool(ringing), samples,
                   int(call_state))


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
    audio_only: bool = False
    record_prefix: str | None = None
    frames: int = 0
    peer_off_hook: bool = False
    peer_ringing: bool = False
    # The shared state above, as the far end last advertised it.
    peer_call_state: int = CALL_IDLE
    peer_instructions: int = 0
    closed: bool = False
    error: str | None = None
    received_samples: int = 0
    sent_samples: int = 0
    _socket: Any = field(default=None, repr=False)
    _server: Any = field(default=None, repr=False)
    _inbound: list[int] = field(default_factory=list, repr=False)
    _tx_record: Any = field(default=None, repr=False)
    _rx_record: Any = field(default=None, repr=False)

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
        if self.record_prefix and self._tx_record is None:
            Path(self.record_prefix).parent.mkdir(parents=True, exist_ok=True)
            self._tx_record = wave.open(self.record_prefix + '-tx.wav', 'wb')
            self._rx_record = wave.open(self.record_prefix + '-rx.wav', 'wb')
            for recording in (self._tx_record, self._rx_record):
                recording.setparams((1, 2, DAA_SAMPLE_RATE, 0, 'NONE', 'not compressed'))
        encoded = frame.encode()
        try:
            if self.audio_only:
                # Fixed line sample rate, signed little-endian PCM16. Only
                # the sample count crosses the wire alongside the waveform.
                self._socket.sendall(_AUDIO_HEADER.pack(len(frame.samples))
                                     + encoded[_HEADER.size:])
                if self._tx_record is not None:
                    self._tx_record.writeframesraw(encoded[_HEADER.size:])
                count, = _AUDIO_HEADER.unpack(self._receive(_AUDIO_HEADER.size))
                # An audio-only peer carries no supervision. Both ends are
                # simply connected, which is the answered state.
                instructions, off_hook, ringing = 0, False, False
                call_state = CALL_ANSWERED
                header = _HEADER.pack(0, 0, 0, call_state, count)
            else:
                self._socket.sendall(encoded)
                if self._tx_record is not None:
                    self._tx_record.writeframesraw(encoded[_HEADER.size:])
                header = self._receive(_HEADER.size)
                instructions, off_hook, ringing, call_state, count = (
                    _HEADER.unpack(header))
            body = self._receive(2 * count)
            if self._rx_record is not None:
                self._rx_record.writeframesraw(body)
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
        self.peer_call_state = int(call_state)
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
        for recording in (self._tx_record, self._rx_record):
            if recording is not None:
                recording.close()
        self._tx_record = self._rx_record = None
        self.closed = True
        self.peer_off_hook = False
        self.peer_ringing = False
        self.peer_call_state = CALL_CLEARED
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
            "audio_only": self.audio_only,
            "sample_rate": DAA_SAMPLE_RATE,
            "record_prefix": self.record_prefix,
            "frames": self.frames,
            "connected": self.connected,
            "peer_off_hook": self.peer_off_hook,
            "peer_call_state": CALL_STATE_NAMES.get(
                self.peer_call_state, self.peer_call_state),
            "peer_instructions": self.peer_instructions,
            "samples_sent": self.sent_samples,
            "samples_received": self.received_samples,
            "error": self.error,
        }
