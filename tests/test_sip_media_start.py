from collections import deque
from types import SimpleNamespace
import threading

import pytest

from courier_emu.sip import SipSession, linear_to_ulaw


@pytest.mark.parametrize('codewords', [True, False])
def test_answer_starts_with_current_audio_instead_of_ring_time_backlog(monkeypatch, codewords):
    packets = []
    session = object.__new__(SipSession)
    session._rtp_lock = threading.RLock()
    session._rtp_clock_thread = None
    session._rtp_clock_wake = threading.Event()
    session.state = 'ringing'
    session.codewords = codewords
    session._tx_codewords = deque(maxlen=16000)
    session._tx_audio = deque(maxlen=16000)
    session.remote_rtp = ('127.0.0.1', 5000)
    session.rtp_socket = SimpleNamespace(sendto=lambda data, peer: packets.append(data))
    session._rtp_sequence = 0
    session._rtp_timestamp = 0
    session._rtp_ssrc = 0
    session._next_rtp_at = 10.0
    session.rtp_packets_sent = session.rtp_octets_sent = 0
    session.preanswer_samples_discarded = 0
    monkeypatch.setattr('courier_emu.sip.time.monotonic', lambda: 10.0)
    send = session.send_pcmu if codewords else session.send_audio
    send(bytes([0xFF]) * 8000 if codewords else [0] * 8000)
    assert not packets
    session.state = 'connected'
    current = bytes([0x91]) * 160 if codewords else [1234] * 160
    send(current)
    expected = current if codewords else bytes([linear_to_ulaw(1234)]) * 160
    assert len(packets) == 1
    assert packets[0][12:] == expected
    assert session.preanswer_samples_discarded == 8000
    assert not session._tx_codewords and not session._tx_audio
