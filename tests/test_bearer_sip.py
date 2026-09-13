"""The B channel as RTP: the octets have to survive the trip unchanged."""
import socket
import time
from collections import deque

from courier_emu.bearer_sip import BearerSipLine
from courier_emu.sip import RTP_PACKET_SAMPLES, linear_to_ulaw, ulaw_to_linear


class _RtpOnlySession:
    """A SipSession's RTP half, with the signalling left out.

    The point under test is the payload path, and giving it a real socket pair
    keeps it honest: these octets go through the kernel.
    """

    def __init__(self) -> None:
        self.state = "connected"
        self.codewords = False
        self._tx_codewords: deque = deque()
        self._rx_codewords: deque = deque()
        self.socket = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        self.socket.bind(("127.0.0.1", 0))
        self.socket.setblocking(False)
        self.rtp_port = self.socket.getsockname()[1]
        self.remote: tuple[str, int] | None = None
        self.sent = 0

    def set_codewords(self, enabled: bool = True) -> None:
        self.codewords = enabled

    def send_pcmu(self, octets: bytes) -> None:
        self._tx_codewords.extend(octets)
        while len(self._tx_codewords) >= RTP_PACKET_SAMPLES and self.remote:
            payload = bytes(self._tx_codewords.popleft()
                            for _ in range(RTP_PACKET_SAMPLES))
            self.socket.sendto(b"\x80\x00" + b"\x00" * 10 + payload, self.remote)
            self.sent += 1

    def receive_pcmu(self, count: int | None = None) -> bytes:
        if count is None:
            count = len(self._rx_codewords)
        return bytes(self._rx_codewords.popleft()
                     for _ in range(min(count, len(self._rx_codewords))))

    def poll(self) -> None:
        while True:
            try:
                packet, _ = self.socket.recvfrom(2_048)
            except BlockingIOError:
                return
            self._rx_codewords.extend(packet[12:])

    def start_call(self, number: str) -> None:
        pass

    def hangup(self) -> None:
        pass

    def status(self) -> dict:
        return {"state": self.state, "rtp_packets_sent": self.sent}


def test_every_codeword_survives_the_bearer_to_rtp_path():
    # All 256 of them, through a real socket, unchanged. A B channel and a
    # PCMU payload are both 8 kHz G.711, so nothing in between should be
    # converting anything.
    left, right = _RtpOnlySession(), _RtpOnlySession()
    left.remote = ("127.0.0.1", right.rtp_port)
    try:
        line = BearerSipLine(left)
        payload = bytes(range(256)) * 4
        for index in range(0, len(payload), RTP_PACKET_SAMPLES):
            line.exchange(payload[index:index + RTP_PACKET_SAMPLES])
        deadline = time.monotonic() + 2.0
        received = bytearray()
        while len(received) < 960 and time.monotonic() < deadline:
            right.poll()
            received += right.receive_pcmu()
        assert bytes(received) == payload[:len(received)]
        assert len(received) >= 960
    finally:
        left.socket.close()
        right.socket.close()


def test_the_linear_path_would_not_have_been_lossless():
    # Which is the whole reason the codeword path exists. Decoding to linear
    # and re-encoding is identity for 255 of the 256 codewords and not for
    # 0x7f - and a V.90 or x2 datapump is betting the connection on the exact
    # codeword, so one in 256 is not a rounding error, it is a defect.
    changed = [value for value in range(256)
               if linear_to_ulaw(ulaw_to_linear(value)) != value]
    assert changed == [0x7F]


def test_what_has_not_arrived_is_counted_rather_than_hidden():
    # Network jitter can still leave a live clock edge with no RTP payload.
    # The bridge fills that genuine underrun with silence and reports it.
    session = _RtpOnlySession()
    try:
        line = BearerSipLine(session)
        out = line.exchange(b"\x55" * 100)
        assert out == b"\xff" * 100
        assert line.status()["octets"]["silence_filled"] == 100
    finally:
        session.socket.close()


class _InboundSession:
    def __init__(self):
        self.direction = "inbound"
        self.state = "incoming"
        self.incoming_from = "8406"
        self.incoming_to = "7349195"
        self.codewords = False
        self.answered = 0
        self.rang = 0

    def set_codewords(self, enabled=True):
        self.codewords = enabled

    def poll(self):
        pass

    def ring_incoming(self):
        self.rang += 1
        self.state = "ringing"

    def answer_incoming(self):
        self.answered += 1
        self.state = "connected"

    def reject_incoming(self):
        self.state = "failed"

    def status(self):
        return {"state": self.state}


def test_inbound_bearer_maps_alerting_and_connect_to_sip():
    session = _InboundSession()
    line = BearerSipLine(session)
    assert line.incoming_call() == ("8406", "7349195")
    line.ring()
    assert session.rang == 1
    line.start()
    assert session.answered == 1
    assert session.state == "connected"
