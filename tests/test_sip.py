from collections import deque

from courier_emu.sip import PCMU_RATE, RTP_PACKET_SAMPLES, SipConfig, SipSession


class PacketSink:
    def __init__(self):
        self.packets = []

    def sendto(self, packet, target):
        self.packets.append((packet, target))


class SignallingSink:
    def __init__(self):
        self.packets = []

    def send(self, packet):
        self.packets.append(packet)


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
    session.rtp_octets_sent = 0
    session.rtp_socket = PacketSink()

    session._flush_rtp(10.099)

    assert session.rtp_packets_sent == 5
    assert len(session.rtp_socket.packets) == 5
    assert session._rtp_timestamp == 2 + 5 * RTP_PACKET_SAMPLES
    assert abs(session._next_rtp_at - 10.1) < 1e-9
    assert all(len(packet) == 12 + RTP_PACKET_SAMPLES
               for packet, _ in session.rtp_socket.packets)


def _message(method, uri, headers, body=b""):
    values = [f"{method} {uri} SIP/2.0"]
    values.extend(f"{name}: {value}" for name, value in headers.items())
    if body:
        values.append("Content-Type: application/sdp")
    values.append(f"Content-Length: {len(body)}")
    return ("\r\n".join(values) + "\r\n\r\n").encode() + body


def _inbound_session():
    session = object.__new__(SipSession)
    session.config = SipConfig(server="pbx.example")
    session.server_host = "pbx.example"
    session.local_ip = "192.0.2.20"
    session.local_port = 5060
    session.rtp_port = 49152
    session.socket = SignallingSink()
    session.from_tag = "local-tag"
    session.call_id = "initial@example.test"
    session.cseq = 0
    session.number = ""
    session.target_uri = ""
    session.to_header = ""
    session.remote_target = ""
    session.remote_rtp = None
    session.direction = ""
    session.incoming_from = ""
    session.incoming_to = ""
    session._incoming_headers = {}
    session._incoming_response = b""
    session._incoming_ringing = False
    session.state = "idle"
    session.last_status = 0
    session.error = ""
    session.events = deque(maxlen=64)
    session._next_rtp_at = 0.0
    session.registered = False
    session._register_call_id = "register@example.test"
    session._register_cseq = 0
    session._register_auth_attempted = False
    return session


def test_inbound_invite_follows_bri_supervision_and_handles_ack_bye():
    session = _inbound_session()
    headers = {
        "Via": "SIP/2.0/UDP 127.0.0.1:5060;branch=z9hG4bK-inbound",
        "From": '"Courier" <sip:8406@example.test>;tag=caller',
        "To": "<sip:7349195@example.test>",
        "Call-ID": "inbound-1@example.test",
        "CSeq": "42 INVITE",
        "Contact": "<sip:8406@127.0.0.1:5060>",
    }
    sdp = (
        "v=0\r\no=- 1 1 IN IP4 127.0.0.1\r\ns=-\r\n"
        "c=IN IP4 127.0.0.1\r\nt=0 0\r\n"
        "m=audio 40000 RTP/AVP 0\r\n"
        "a=rtpmap:0 PCMU/8000\r\n"
    ).encode()
    session._handle_request(
        _message("INVITE", "sip:7349195@127.0.0.1", headers, sdp),
        ("198.51.100.10", 5060),
    )
    trying = session.socket.packets.pop(0)
    assert trying.startswith(b"SIP/2.0 100 Trying\r\n")
    assert session.state == "incoming"
    assert session.direction == "inbound"
    assert session.incoming_from == "8406"
    assert session.incoming_to == "7349195"
    assert session.remote_rtp == ("127.0.0.1", 40000)

    session.ring_incoming()
    ringing = session.socket.packets.pop(0)
    assert ringing.startswith(b"SIP/2.0 180 Ringing\r\n")
    assert b";tag=" in ringing

    session.answer_incoming()
    answer = session.socket.packets.pop(0)
    assert answer.startswith(b"SIP/2.0 200 OK\r\n")
    assert f"m=audio {session.rtp_port} RTP/AVP 0".encode() in answer
    assert session.state == "connected"

    dialog = dict(headers)
    dialog["To"] = session.to_header
    dialog["CSeq"] = "42 ACK"
    session._handle_request(
        _message("ACK", "sip:7349195@127.0.0.1", dialog),
        ("198.51.100.10", 5060),
    )
    assert "rx ACK" in session.events

    # A lost 200 on UDP makes the PBX retransmit the INVITE. The accepted
    # transaction must repeat the identical final response, not create a
    # second call or a second dialog tag.
    session._handle_request(
        _message("INVITE", "sip:7349195@127.0.0.1", headers, sdp),
        ("198.51.100.10", 5060),
    )
    assert session.socket.packets.pop(0) == answer
    assert session.state == "connected"

    dialog["CSeq"] = "43 BYE"
    session._handle_request(
        _message("BYE", "sip:7349195@127.0.0.1", dialog),
        ("198.51.100.10", 5060),
    )
    bye_answer = session.socket.packets.pop(0)
    assert bye_answer.startswith(b"SIP/2.0 200 OK\r\n")
    assert session.state == "closed"
    assert "rx BYE" in session.events


def test_inbound_invite_without_pcmu_is_rejected():
    session = _inbound_session()
    headers = {
        "Via": "SIP/2.0/UDP 127.0.0.1:5060;branch=z9hG4bK-bad",
        "From": "<sip:caller@example.test>;tag=caller",
        "To": "<sip:courier@example.test>",
        "Call-ID": "bad-codec@example.test",
        "CSeq": "1 INVITE",
    }
    sdp = b"v=0\r\nc=IN IP4 127.0.0.1\r\nm=audio 9000 RTP/AVP 8\r\n"
    session._handle_request(
        _message("INVITE", "sip:courier@127.0.0.1", headers, sdp),
        ("198.51.100.10", 5060),
    )
    assert session.socket.packets.pop(0).startswith(
        b"SIP/2.0 488 Not Acceptable Here\r\n"
    )
    assert session.state == "idle"
    assert session.remote_rtp is None


def test_outbound_requests_keep_the_original_dialog_orientation():
    session = _inbound_session()
    session.direction = "outbound"
    session.target_uri = "sip:8406@pbx.example"
    session.to_header = "<sip:8406@pbx.example>;tag=remote"
    session.remote_target = "sip:8406@198.51.100.10:5060"
    session.call_id = "outbound@example.test"
    session.cseq = 7
    request = session._request("BYE")
    assert request.startswith(b"BYE sip:8406@198.51.100.10:5060 SIP/2.0\r\n")
    assert (
        b'From: "Courier Emulator" <sip:courier@pbx.example>;tag=local-tag\r\n'
        in request
    )
    assert b"To: <sip:8406@pbx.example>;tag=remote\r\n" in request


def test_register_retries_one_digest_challenge_and_records_success():
    session = _inbound_session()
    session.config.password = "secret"
    session.register()
    first = session.socket.packets.pop(0)
    assert first.startswith(b"REGISTER sip:pbx.example SIP/2.0\r\n")
    assert b"Authorization:" not in first

    challenged = (
        "SIP/2.0 401 Unauthorized\r\n"
        "Via: SIP/2.0/UDP 192.0.2.20:5060\r\n"
        "From: <sip:courier@pbx.example>;tag=local-tag\r\n"
        "To: <sip:courier@pbx.example>;tag=server\r\n"
        "Call-ID: register@example.test\r\n"
        "CSeq: 1 REGISTER\r\n"
        'WWW-Authenticate: Digest realm="test", nonce="abc"\r\n'
        "Content-Length: 0\r\n\r\n"
    ).encode()
    session._handle_response(challenged, ("198.51.100.10", 5060))
    authenticated = session.socket.packets.pop(0)
    assert b"CSeq: 2 REGISTER\r\n" in authenticated
    assert b'Authorization: Digest username="courier"' in authenticated
    assert b'uri="sip:pbx.example"' in authenticated

    accepted = (
        "SIP/2.0 200 OK\r\n"
        "Call-ID: register@example.test\r\n"
        "CSeq: 2 REGISTER\r\n"
        "Content-Length: 0\r\n\r\n"
    ).encode()
    session._handle_response(accepted, ("198.51.100.10", 5060))
    assert session.registered
    assert session.state == "idle"


def test_asterisk_options_and_notify_are_answered_without_changing_call_state():
    session = _inbound_session()
    headers = {
        "Via": "SIP/2.0/UDP pbx.example;branch=z9hG4bK-qualify",
        "From": "<sip:courier@pbx.example>;tag=server",
        "To": "<sip:courier@192.0.2.20>",
        "Call-ID": "qualify@example.test",
        "CSeq": "1 OPTIONS",
    }
    session._handle_request(
        _message("OPTIONS", "sip:courier@192.0.2.20", headers),
        ("198.51.100.10", 5060),
    )
    assert session.socket.packets.pop(0).startswith(b"SIP/2.0 200 OK\r\n")
    assert session.state == "idle"

    headers["CSeq"] = "2 NOTIFY"
    session._handle_request(
        _message("NOTIFY", "sip:courier@192.0.2.20", headers),
        ("198.51.100.10", 5060),
    )
    assert session.socket.packets.pop(0).startswith(b"SIP/2.0 200 OK\r\n")
    assert session.state == "idle"


def test_bye_response_is_not_parsed_as_an_invite_answer():
    session = _inbound_session()
    session.state = "idle"
    response = (
        "SIP/2.0 200 OK\r\n"
        "Call-ID: dialog@example.test\r\n"
        "CSeq: 1 BYE\r\n"
        "Content-Length: 0\r\n\r\n"
    ).encode()
    session._handle_response(response, ("198.51.100.10", 5060))
    assert session.state == "idle"
    assert session.error == ""
    assert "rx 200 BYE" in session.events
