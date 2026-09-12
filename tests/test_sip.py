from collections import deque

from courier_emu.sip import PCMU_RATE, RTP_PACKET_SAMPLES, SipSession


class PacketSink:
    def __init__(self):
        self.packets = []

    def sendto(self, packet, target):
        self.packets.append((packet, target))


def test_flush_sends_every_due_twenty_ms_packet():
    session = object.__new__(SipSession)
    session.state = "connected"
    session.remote_rtp = ("127.0.0.1", 9000)
    session.codewords = False
    session._tx_audio = deque([1000] * (RTP_PACKET_SAMPLES * 5))
    session._tx_codewords = deque()
    session._next_rtp_at = 10.0
    session._rtp_sequence = 1
    session._rtp_timestamp = 2
    session._rtp_ssrc = 3
    session.rtp_packets_sent = 0
    session.rtp_socket = PacketSink()

    session._flush_rtp(10.099)

    assert session.rtp_packets_sent == 5
    assert len(session.rtp_socket.packets) == 5
    assert session._rtp_timestamp == 2 + 5 * RTP_PACKET_SAMPLES
    assert abs(session._next_rtp_at - 10.1) < 1e-9
    assert all(len(packet) == 12 + RTP_PACKET_SAMPLES
               for packet, _ in session.rtp_socket.packets)
