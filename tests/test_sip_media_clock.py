from collections import deque
import threading
import time
from types import SimpleNamespace

from courier_emu.sip import SipSession


def clocked_session():
    session = object.__new__(SipSession)
    session.state = 'connected'
    session.closed = False
    session.error = ''
    session.codewords = True
    session._tx_codewords = deque()
    session._tx_audio = deque()
    session._rtp_sequence = 0
    session._rtp_timestamp = 0
    session._rtp_ssrc = 1
    session._next_rtp_at = 0
    session._rtp_lock = threading.RLock()
    session._rtp_clock_thread = None
    session._rtp_clock_stop = threading.Event()
    session._rtp_clock_wake = threading.Event()
    session._rtp_tx_primed = False
    session._rtp_tx_buffer_samples = 480
    session.remote_rtp = ('127.0.0.1', 5000)
    session.rtp_packets_sent = session.rtp_octets_sent = 0
    session.preanswer_samples_discarded = 0
    return session


def test_media_clock_sends_continuous_codewords_while_producer_is_paused():
    session = clocked_session()
    packets = []
    complete = threading.Event()

    def send(packet, peer):
        packets.append((time.monotonic(), packet))
        if len(packets) == 4:
            complete.set()

    session.rtp_socket = SimpleNamespace(sendto=send, close=lambda: None)
    session.socket = SimpleNamespace(close=lambda: None)
    source = bytes(i % 256 for i in range(640))
    session.enable_media_clock()
    try:
        # Only one producer call. The sender must continue independently and
        # must not flush the queued packets as one scheduler catch-up burst.
        session.send_pcmu(source)
        assert complete.wait(2)
        assert b''.join(packet[12:] for _, packet in packets) == source
        assert [int.from_bytes(packet[4:8], 'big') for _, packet in packets] == [0, 160, 320, 480]
        assert packets[-1][0] - packets[0][0] >= 0.05
    finally:
        session.state = 'idle'
        session.close()
    assert not session._rtp_clock_thread.is_alive()


def test_media_clock_primes_before_starting_and_keeps_every_queued_octet():
    session = clocked_session()
    # Run the clock decision synchronously to check startup without wall-clock
    # sleeps. A marker enables its playout buffering branch.
    session._rtp_clock_thread = object()
    packets = []
    session.rtp_socket = SimpleNamespace(sendto=lambda packet, peer: packets.append(packet))
    session._tx_codewords.extend(b'\x12' * 160)
    session._flush_rtp_locked(10)
    assert packets == []
    session._tx_codewords.extend(b'\x34' * 320)
    session._flush_rtp_locked(11)
    assert [packet[12:] for packet in packets] == [b'\x12' * 160]
    assert bytes(session._tx_codewords) == b'\x34' * 320
