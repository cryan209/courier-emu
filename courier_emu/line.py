from __future__ import annotations

from dataclasses import dataclass, field
from pathlib import Path
import os
import socket
import struct
import time
import wave
from typing import Any

from .daa import DAA_SAMPLE_RATE, INSTRUCTIONS_PER_MS


# Default to the DAA's 100 ms batch. Both socket peers can select smaller
# exchanges to model a lower transit delay without changing sample clocks.
LINE_FRAME_MS = int(os.environ.get("COURIER_LINE_FRAME_MS", "100"))
if not 1 <= LINE_FRAME_MS <= 100:
    raise ValueError("COURIER_LINE_FRAME_MS must be between 1 and 100")
LINE_FRAME_SAMPLES = DAA_SAMPLE_RATE * LINE_FRAME_MS // 1_000
LINE_FRAME_MS = LINE_FRAME_SAMPLES * 1_000 // DAA_SAMPLE_RATE
LINE_FRAME_INSTRUCTIONS = LINE_FRAME_MS * INSTRUCTIONS_PER_MS

# Frames each side may have in flight before it must wait for the far end's.
# One is the original swap: send a frame, block for the peer's frame of the
# same index. N lets a side run N-1 frames ahead of the other, which is the
# same as N-1 frames of extra transit delay on the line (the first N-1
# exchanges receive silence). Pair it with a smaller COURIER_LINE_FRAME_MS to
# keep the end-to-end delay where it was: 5 ms frames and a window of 4 are
# the 20 ms the training scripts were tuned against.
LINE_WINDOW_FRAMES = int(os.environ.get("COURIER_LINE_WINDOW", "1"))
if not 1 <= LINE_WINDOW_FRAMES <= 64:
    raise ValueError("COURIER_LINE_WINDOW must be between 1 and 64")

# Each side blocks until the far end delivers its frame, which is what keeps
# two independently executing instances on the same emulated clock. The timeout
# only exists so a peer that stops early ends the call instead of the run.
LINE_TIMEOUT_SECONDS = 30.0

# Shortest limit across the platforms this runs on (macOS is 104 with the
# terminator, Linux 108).
MAX_SOCKET_PATH = 100

# The Courier's line levels, shared by every far end so a sample crosses at
# its real level:
#   - AC01 data manual: a full-scale digital sine is 6 V peak to peak
#     differential into 600 ohms at 0 dB gain - 2.121 V rms, +8.75 dBm - in
#     both directions, so two AC01s share one full scale.
#   - The Courier's DAA loses 11.4 dB on transmit: the manual gives
#     "Transmit level: -9 dBm maximum" (docs/1154-00.pdf), and the 4.03
#     datapump writes its V.8 CM 6.38 dB under the DAC's full-scale sine at
#     0 dB output gain, +2.37 dBm at the AC01's pins. Its receive loss is
#     taken as none.
# The AC01's register 4 gains are not here - the core applies them, and the
# firmware changes them mid-call.
AC01_FULL_SCALE_DBM = 8.75
DAA_TX_LOSS_DB = 11.4
DAA_RX_LOSS_DB = 0.0
# Between two Couriers' line terminals. A STAND-IN, not a measurement: the
# bottom of the 3-6 dB a switched call loses end to end.
COURIER_PAIR_LOOP_LOSS_DB = 3.0
# One Courier's codec to the other's: its DAA, the loop, the far DAA.
COURIER_PAIR_LOSS_DB = DAA_TX_LOSS_DB + COURIER_PAIR_LOOP_LOSS_DB + DAA_RX_LOSS_DB

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
        body = struct.pack(f"<{len(self.samples)}h", *map(int, self.samples))
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
        if len(body) >= 2 * count:
            samples = list(struct.unpack_from(f"<{count}h", body))
        else:
            samples = [
                int.from_bytes(body[index : index + 2], "little", signed=True)
                for index in range(0, 2 * count, 2)
            ]
        return cls(instructions, bool(off_hook), bool(ringing), samples,
                   int(call_state))


def _presend_failure(code: int) -> OSError:
    """The exception a socket call that failed with `code` raised (1000: timeout)."""
    if code == 1000:
        return TimeoutError("timed out")
    return OSError(code, os.strerror(code))


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
    # Amplitude the far Courier's codec samples keep on the way to this one's:
    # COURIER_PAIR_LOSS_DB. Each end sends its codec's samples untouched, so
    # the receiver applies both DAAs and the loop. Unity cannot be right - it
    # drops the DAA's transmit loss, lands the far end's CM near full scale,
    # the answerer's V.21 receiver assembles garbage (fec8/fec9 = 2d ae where
    # e0 c1 belongs), and V.8 never completes. The -rx recording is the far
    # end's transmit as it left, before this loss.
    loss_gain: float = 10 ** (-COURIER_PAIR_LOSS_DB / 20)
    # A far end that sets the line's levels itself (MicaEmu's
    # courier_line_peer, or bearer_line's I-modem): the socket carries the
    # codec's samples untouched both ways, and the bridge opens the hybrid.
    # COURIER_LINE_DIGITAL=1 selects it for `run`. Not for a Courier pair:
    # neither end would apply the DAAs, and each would hear the other 14 dB
    # hot.
    digital: bool = False
    frames: int = 0
    frames_received: int = 0
    peer_off_hook: bool = False
    peer_ringing: bool = False
    # The shared state above, as the far end last advertised it.
    peer_call_state: int = CALL_IDLE
    peer_instructions: int = 0
    closed: bool = False
    error: str | None = None
    received_samples: int = 0
    sent_samples: int = 0
    _sent_frames: int = field(default=0, repr=False)
    _socket: Any = field(default=None, repr=False)
    _server: Any = field(default=None, repr=False)
    _inbound: list[int] = field(default_factory=list, repr=False)
    _tx_record: Any = field(default=None, repr=False)
    _rx_record: Any = field(default=None, repr=False)
    # A frame the worker's native line service already sent and then took
    # back (see courier_worker_poll): 1, it went out and its reply did not
    # come (the far end closed the line); 2000 + errno or 3000, receiving
    # failed or timed out; 4000 + errno or 5000, sending did. The next
    # exchange is that frame again, and meets the same failure without
    # sending it twice.
    _presend: int = field(default=0, repr=False)
    _g711 = None   # see __post_init__; not a dataclass field
    _skew = None

    def __post_init__(self) -> None:
        if self.digital:
            self.loss_gain = 1.0
        # COURIER_LINE_G711=alaw|ulaw puts a digital network leg between the
        # pair: what arrives is quantised through that law after the loop
        # loss, as a call carried over G.711 would be. Python's exchange
        # only; set COURIER_NATIVE_FRAMES=0 with it.
        law = os.environ.get("COURIER_LINE_G711", "")
        self._g711 = None
        if law:
            from .sip import CODECS
            _, _, encode, decode = CODECS["pcma" if law == "alaw" else "pcmu"]
            self._g711 = [decode(encode(level - 32768)) for level in range(65536)]
        # COURIER_LINE_SKEW_PPM=N: the far end's sample clock runs N ppm fast
        # (negative, slow) against this end's - what any real far end has and
        # a pair of emulators never does. Inbound audio is resampled by linear
        # interpolation. Python's exchange only, like the G.711 leg.
        skew = float(os.environ.get("COURIER_LINE_SKEW_PPM", "0") or 0)
        if skew:
            # [step, phase, previous sample]
            self._skew = [1.0 - skew * 1e-6, 0.0, 0]

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
        self._sent_frames += 1
        # Frames still owed from the far end before this exchange may return.
        owed = max(0, self._sent_frames - LINE_WINDOW_FRAMES + 1 - self.frames_received)
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
                presend, self._presend = self._presend, 0
                if presend >= 4000:
                    raise _presend_failure(presend - 4000)
                if not presend:
                    self._socket.sendall(encoded)
                if self._tx_record is not None:
                    self._tx_record.writeframesraw(encoded[_HEADER.size:])
                if owed == 0:
                    # Still inside the transit delay: nothing has arrived yet.
                    self.frames += 1
                    self.sent_samples += len(frame.samples)
                    return
                if presend >= 2000:
                    raise _presend_failure(presend - 2000)
                header = self._receive(_HEADER.size)
                instructions, off_hook, ringing, call_state, count = (
                    _HEADER.unpack(header))
            body = self._receive(2 * count)
            self.frames_received += 1
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
        if self._skew is not None:
            step, phase, previous = self._skew
            resampled = []
            for sample in peer.samples:
                while phase < 1.0:
                    resampled.append(int(previous + (sample - previous) * phase))
                    phase += step
                phase -= 1.0
                previous = sample
            self._skew[1], self._skew[2] = phase, previous
            peer.samples = resampled
        if self._g711 is not None:
            table = self._g711
            self._inbound.extend(
                table[max(-32768, min(32767, int(sample * self.loss_gain))) + 32768]
                for sample in peer.samples)
        elif self.loss_gain == 1.0:
            self._inbound.extend(peer.samples)
        else:
            self._inbound.extend(int(sample * self.loss_gain) for sample in peer.samples)
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
            "digital": self.digital,
            "sample_rate": DAA_SAMPLE_RATE,
            "frame_samples": LINE_FRAME_SAMPLES,
            "frame_ms": LINE_FRAME_MS,
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
