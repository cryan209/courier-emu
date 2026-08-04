from __future__ import annotations

from collections.abc import Callable
import socket
import time
import unittest

from courier_emu.sip import (
    RateConverter,
    SipConfig,
    SipSession,
    linear_to_ulaw,
    ulaw_to_linear,
)


def _headers(message: bytes) -> dict[str, str]:
    lines = message.decode("latin-1").split("\r\n")
    result: dict[str, str] = {}
    for line in lines[1:]:
        name, separator, value = line.partition(":")
        if separator:
            result[name.lower()] = value.strip()
    return result


def _response(request: bytes, status: str, extra: str = "", body: bytes = b"") -> bytes:
    headers = _headers(request)
    text = (
        f"SIP/2.0 {status}\r\n"
        f"Via: {headers['via']}\r\n"
        f"From: {headers['from']}\r\n"
        f"To: {headers['to']};tag=mockpbx\r\n"
        f"Call-ID: {headers['call-id']}\r\n"
        f"CSeq: {headers['cseq']}\r\n"
        f"{extra}"
        f"Content-Length: {len(body)}\r\n\r\n"
    )
    return text.encode("ascii") + body


def _poll_until(session: SipSession, predicate: Callable[[], bool]) -> None:
    deadline = time.monotonic() + 1
    while time.monotonic() < deadline:
        session.poll()
        if predicate():
            return
        time.sleep(0.005)
    raise AssertionError("SIP session did not reach the expected state")


class CodecTests(unittest.TestCase):
    def test_ulaw_known_silence_and_round_trip(self) -> None:
        self.assertEqual(linear_to_ulaw(0), 0xFF)
        self.assertEqual(ulaw_to_linear(0xFF), 0)
        for sample in (-20_000, -1_000, 1_000, 20_000):
            decoded = ulaw_to_linear(linear_to_ulaw(sample))
            self.assertEqual(decoded < 0, sample < 0)
            self.assertLess(abs(decoded - sample), 1_500)

    def test_exact_modem_rtp_rate_ratios(self) -> None:
        self.assertEqual(len(RateConverter(9_600, 8_000).convert([0] * 960)), 800)
        self.assertEqual(len(RateConverter(8_000, 9_600).convert([0] * 800)), 960)


class SipSessionTests(unittest.TestCase):
    def test_digest_invite_and_bidirectional_pcmu(self) -> None:
        server = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        try:
            server.bind(("127.0.0.1", 0))
        except PermissionError:
            server.close()
            self.skipTest("loopback UDP sockets are disabled by the sandbox")
        server.settimeout(1)
        rtp = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        rtp.bind(("127.0.0.1", 0))
        rtp.settimeout(1)
        session = SipSession(
            SipConfig(
                server=f"127.0.0.1:{server.getsockname()[1]}",
                username="6001",
                password="secret",
            )
        )
        try:
            session.start_call("123")
            invite, client = server.recvfrom(65_535)
            self.assertTrue(invite.startswith(b"INVITE sip:123@127.0.0.1 SIP/2.0"))

            challenge = _response(
                invite,
                "407 Proxy Authentication Required",
                'Proxy-Authenticate: Digest realm="mock", nonce="abc", '
                'algorithm=MD5, qop="auth"\r\n',
            )
            server.sendto(challenge, client)
            _poll_until(session, lambda: session._auth_attempted)
            first, _ = server.recvfrom(65_535)
            second, _ = server.recvfrom(65_535)
            authenticated = first if first.startswith(b"INVITE ") else second
            self.assertIn(b"Proxy-Authorization: Digest", authenticated)

            body = (
                "v=0\r\n"
                "o=- 1 1 IN IP4 127.0.0.1\r\n"
                "s=mock\r\n"
                "c=IN IP4 127.0.0.1\r\n"
                "t=0 0\r\n"
                f"m=audio {rtp.getsockname()[1]} RTP/AVP 0\r\n"
                "a=rtpmap:0 PCMU/8000\r\n"
            ).encode("ascii")
            server.sendto(_response(authenticated, "200 OK", body=body), client)
            _poll_until(session, lambda: session.state == "connected")
            ack, _ = server.recvfrom(65_535)
            self.assertTrue(ack.startswith(b"ACK "))
            self.assertEqual(session.state, "connected")

            session.send_audio([0] * 160)
            packet, _ = rtp.recvfrom(2_048)
            self.assertEqual(len(packet), 172)
            self.assertEqual(packet[12:], b"\xff" * 160)

            inbound = bytes((0x80, 0x00)) + b"\x00\x01" + b"\x00" * 8 + b"\xff" * 160
            rtp.sendto(inbound, ("127.0.0.1", session.rtp_port))
            _poll_until(session, lambda: session.rtp_packets_received == 1)
            self.assertEqual(session.receive_audio(), [0] * 160)
            self.assertEqual(session.rtp_packets_received, 1)
        finally:
            session.close()
            server.close()
            rtp.close()


if __name__ == "__main__":
    unittest.main()
