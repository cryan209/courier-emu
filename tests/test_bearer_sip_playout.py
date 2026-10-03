from collections import deque
import pytest

from courier_emu.bearer_sip import BearerSipLine
from courier_emu.bri import BriNetwork


class IncomingSession:
    direction = 'inbound'
    state = 'ringing'

    def __init__(self):
        self.sent = bytearray()
        self.answers = 0
        self.rings = 0
        self.incoming_from = '8411'
        self.incoming_to = '2904'

    def set_codewords(self, enabled):
        assert enabled

    def poll(self):
        pass

    def receive_pcmu(self):
        return b''

    def answer_incoming(self):
        self.answers += 1
        self.state = 'connected'

    def ring_incoming(self):
        self.rings += 1
        self.state = 'ringing'

    def send_pcmu(self, octets):
        assert self.state == 'connected'
        self.sent.extend(octets)

    def reject_incoming(self):
        self.state = 'failed'

    def hangup(self):
        assert self.state != 'ringing'
        self.state = 'idle'


def test_inbound_sip_waits_for_answer_waveform_and_preserves_its_start():
    session = IncomingSession()
    bearer = BearerSipLine(session)
    bearer.start()
    for _ in range(200):
        bearer.start()
        bearer.exchange(b'\xff' * 160)
    assert session.answers == 0
    assert session.sent == b''
    waveform = bytes([0x91, 0x11]) * 160
    for octet in waveform[:159]:
        bearer.exchange(bytes([octet]))
    assert session.answers == 0
    bearer.exchange(waveform[159:])
    assert session.answers == 1
    assert session.sent == waveform
    bearer.exchange(b'\x92' * 160)
    assert session.answers == 1
    assert session.sent == waveform + b'\x92' * 160


def test_inbound_sip_does_not_accept_on_a_lone_transient():
    session = IncomingSession()
    bearer = BearerSipLine(session)
    bearer.start()
    bearer.exchange(b'\x91' + b'\xff' * 799)
    assert session.answers == 0
    assert session.sent == b''


def test_clear_before_dsp_ready_rejects_invite_and_resets_answer_buffer():
    session = IncomingSession()
    bearer = BearerSipLine(session)
    bearer.start()
    bearer.exchange(b'\x91' * 80)
    bearer.stop()
    assert session.state == 'idle'
    assert not bearer._answer_audio
    session.state = 'ringing'
    bearer.start()
    bearer.exchange(b'\xff' * 160)
    assert session.answers == 0


def test_second_incoming_call_rings_and_answers_without_restarting_bridge():
    session = IncomingSession()
    bearer = BearerSipLine(session)
    network = BriNetwork(media_peer=bearer, call_to='7349195')
    for attempt in range(2):
        session.state = 'incoming'
        network._timers()
        assert network.call_state == 'call-present'
        assert network.call_reference == 1
        bearer.ring()
        bearer.start()
        bearer.exchange(b'\x91' * 160)
        assert session.rings == attempt + 1
        assert session.answers == attempt + 1
        network._clear_call()
        assert network.call_state == 'null'
        assert session.state == 'idle'
    assert sum('inbound call from' in event for _, event in network.events) == 2


def test_scheduled_call_remains_one_shot_after_clear():
    network = BriNetwork(call_at=0)
    network._timers()
    assert network.call_state == 'call-present'
    network._clear_call()
    network._timers()
    assert network.call_state == 'null'


def test_cancelled_ringing_call_does_not_suppress_next_ring():
    session = IncomingSession()
    bearer = BearerSipLine(session)
    network = BriNetwork(media_peer=bearer)
    network._timers()
    bearer.ring()
    network._clear_call()
    session.state = 'incoming'
    network._timers()
    bearer.ring()
    assert network.call_state == 'call-present'
    assert session.rings == 2


class PacketSession:
    state = 'connected'

    def __init__(self):
        self.received = deque()

    def set_codewords(self, enabled):
        assert enabled

    def send_pcmu(self, octets):
        pass

    def poll(self):
        pass

    def receive_pcmu(self):
        value = bytes(self.received)
        self.received.clear()
        return value

    def hangup(self):
        pass


@pytest.mark.parametrize('reserve', [320, 800])
def test_packet_jitter_preserves_every_codeword_without_midstream_silence(reserve):
    session = PacketSession()
    bearer = BearerSipLine(session, receive_buffer_samples=reserve)
    source = bytes(i % 254 for i in range(1920))
    # The third packet is 10 ms late; the following one catches up. The DSP
    # still requires one octet every 125 us throughout the gap.
    arrivals = {packet * 160: packet for packet in range(12)}
    delayed = reserve // 160 + 1
    arrivals[delayed * 160 + 80] = arrivals.pop(delayed * 160)
    initial_delay = reserve - 160
    output = bytearray()
    for tick in range(len(source) + initial_delay):
        if tick in arrivals:
            packet = arrivals[tick]
            session.received.extend(source[packet * 160:(packet + 1) * 160])
        output.extend(bearer.exchange(b'\xff'))
    assert output[:initial_delay] == b'\xff' * initial_delay
    assert output[initial_delay:] == source
    assert bearer.underrun == initial_delay
    assert bearer.octets_from_rtp == len(source)


def test_new_call_primes_receive_buffer_again():
    session = PacketSession()
    bearer = BearerSipLine(session)
    bearer.started = True
    session.received.extend(b'\x11' * 320)
    assert bearer.exchange(b'\xff') == b'\x11'
    bearer.stop()
    session.received.extend(b'\x22' * 160)
    assert bearer.exchange(b'\xff') == b'\xff'
    assert list(bearer._receive_octets) == [0x22] * 160


def test_receive_outage_rebuilds_reserve_before_resuming_waveform():
    session = PacketSession()
    bearer = BearerSipLine(session)
    session.received.extend(b'\x11' * 320)
    output = bytearray()
    resumed = bytes(i % 254 for i in range(640))
    arrivals = {800: 0, 960: 1, 1200: 2, 1280: 3}
    for tick in range(1600):
        if tick in arrivals:
            packet = arrivals[tick]
            session.received.extend(resumed[packet * 160:(packet + 1) * 160])
        output.extend(bearer.exchange(b'\xff'))
    assert output[:320] == b'\x11' * 320
    assert output[320:960] == b'\xff' * 640
    assert output[960:] == resumed
    assert bearer.underrun == 640
