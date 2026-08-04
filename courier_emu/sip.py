from __future__ import annotations

from collections import deque
from dataclasses import asdict, dataclass
from hashlib import md5
import random
import re
import socket
import time


SIP_PORT = 5060
PCMU_RATE = 8_000
RTP_PACKET_SAMPLES = 160
_ULAW_BIAS = 0x84
_ULAW_CLIP = 32_635


def linear_to_ulaw(sample: int) -> int:
    sample = max(-32_768, min(32_767, int(sample)))
    sign = 0x80 if sample < 0 else 0
    if sign:
        sample = -sample
    sample = min(sample, _ULAW_CLIP) + _ULAW_BIAS
    exponent = 7
    mask = 0x4000
    while exponent and not sample & mask:
        exponent -= 1
        mask >>= 1
    mantissa = (sample >> (exponent + 3)) & 0x0F
    return ~(sign | (exponent << 4) | mantissa) & 0xFF


def ulaw_to_linear(value: int) -> int:
    value = ~value & 0xFF
    sample = ((value & 0x0F) << 3) + _ULAW_BIAS
    sample <<= (value & 0x70) >> 4
    sample -= _ULAW_BIAS
    return -sample if value & 0x80 else sample


class RateConverter:
    """Streaming zero-order rate conversion for the exact 9.6/8 kHz ratio."""

    def __init__(self, input_rate: int, output_rate: int) -> None:
        self.input_rate = input_rate
        self.output_rate = output_rate
        self.phase = 0

    def convert(self, samples: list[int]) -> list[int]:
        result: list[int] = []
        for sample in samples:
            self.phase += self.output_rate
            while self.phase >= self.input_rate:
                result.append(sample)
                self.phase -= self.input_rate
        return result


def _split_server(value: str) -> tuple[str, int]:
    if value.startswith("["):
        host, separator, port = value[1:].partition("]")
        if not separator:
            raise ValueError(f"invalid SIP server: {value!r}")
        return host, int(port[1:]) if port.startswith(":") else SIP_PORT
    if value.count(":") == 1:
        host, port = value.rsplit(":", 1)
        return host, int(port)
    return value, SIP_PORT


def _header_map(lines: list[str]) -> dict[str, str]:
    result: dict[str, str] = {}
    for line in lines:
        name, separator, value = line.partition(":")
        if separator:
            result[name.strip().lower()] = value.strip()
    return result


def _digest_parameters(value: str) -> dict[str, str]:
    value = value.strip()
    if value.lower().startswith("digest "):
        value = value[7:]
    return {
        match.group(1).lower(): match.group(2) or match.group(3) or ""
        for match in re.finditer(r'(\w+)=(?:"([^"]*)"|([^,\s]+))', value)
    }


@dataclass
class SipConfig:
    server: str
    username: str = "courier"
    password: str = ""
    target: str = ""
    local_port: int = 0
    rtp_port: int = 0
    display_name: str = "Courier Emulator"


class SipSession:
    """Minimal UDP SIP client with Digest INVITE and PCMU RTP."""

    def __init__(self, config: SipConfig) -> None:
        self.config = config
        self.server_host, self.server_port = _split_server(config.server)
        addresses = socket.getaddrinfo(
            self.server_host, self.server_port, socket.AF_INET, socket.SOCK_DGRAM
        )
        self.server_address = addresses[0][4]
        self.socket = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        self.socket.bind(("0.0.0.0", config.local_port))
        self.socket.connect(self.server_address)
        self.socket.setblocking(False)
        self.local_ip, self.local_port = self.socket.getsockname()
        if self.local_ip == "0.0.0.0":
            probe = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
            try:
                probe.connect(self.server_address)
                self.local_ip = probe.getsockname()[0]
            finally:
                probe.close()

        self.rtp_socket = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        self.rtp_socket.bind(("0.0.0.0", config.rtp_port))
        self.rtp_socket.setblocking(False)
        self.rtp_port = self.rtp_socket.getsockname()[1]
        self.remote_rtp: tuple[str, int] | None = None

        token = random.getrandbits(64)
        self.call_id = f"{token:016x}@{self.local_ip}"
        self.from_tag = f"{random.getrandbits(32):08x}"
        self.branch = ""
        self.cseq = 0
        self.number = ""
        self.target_uri = ""
        self.to_header = ""
        self.state = "idle"
        self.last_status = 0
        self.error = ""
        self.events: deque[str] = deque(maxlen=64)
        self._invite = b""
        self._invite_sent_at = 0.0
        self._retransmit_after = 0.5
        self._auth_attempted = False
        self._tx_audio: deque[int] = deque(maxlen=PCMU_RATE * 2)
        self._rx_audio: deque[int] = deque()
        self._rtp_sequence = random.getrandbits(16)
        self._rtp_timestamp = random.getrandbits(32)
        self._rtp_ssrc = random.getrandbits(32)
        self._next_rtp_at = 0.0
        self.rtp_packets_sent = 0
        self.rtp_packets_received = 0
        self.closed = False

    def _target(self, number: str) -> str:
        if self.config.target:
            return self.config.target.replace("{number}", number).replace(
                "{server}", self.server_host
            )
        return f"sip:{number}@{self.server_host}"

    def start_call(self, number: str) -> None:
        if self.state not in ("idle", "closed", "failed"):
            return
        self.number = number
        self.target_uri = self._target(number)
        if not self.target_uri.lower().startswith("sip:"):
            self.target_uri = "sip:" + self.target_uri
        self.to_header = f"<{self.target_uri}>"
        self.state = "inviting"
        self.error = ""
        self._auth_attempted = False
        self._send_invite()

    def _sdp(self) -> bytes:
        session_id = random.getrandbits(31)
        lines = (
            "v=0",
            f"o=- {session_id} {session_id} IN IP4 {self.local_ip}",
            "s=Courier Emulator",
            f"c=IN IP4 {self.local_ip}",
            "t=0 0",
            f"m=audio {self.rtp_port} RTP/AVP 0",
            "a=rtpmap:0 PCMU/8000",
            "a=sendrecv",
            "",
        )
        return "\r\n".join(lines).encode("ascii")

    def _request(
        self,
        method: str,
        *,
        authorization: tuple[str, str] | None = None,
        body: bytes = b"",
    ) -> bytes:
        self.branch = f"z9hG4bK{random.getrandbits(48):012x}"
        headers = [
            f"Via: SIP/2.0/UDP {self.local_ip}:{self.local_port};branch={self.branch};rport",
            "Max-Forwards: 70",
            f"From: \"{self.config.display_name}\" <sip:{self.config.username}@{self.server_host}>;tag={self.from_tag}",
            f"To: {self.to_header}",
            f"Call-ID: {self.call_id}",
            f"CSeq: {self.cseq} {method}",
            f"Contact: <sip:{self.config.username}@{self.local_ip}:{self.local_port}>",
            "User-Agent: courier-emu/0.1",
        ]
        if authorization:
            headers.append(f"{authorization[0]}: {authorization[1]}")
        if body:
            headers.append("Content-Type: application/sdp")
        headers.append(f"Content-Length: {len(body)}")
        text = f"{method} {self.target_uri} SIP/2.0\r\n" + "\r\n".join(headers)
        return text.encode("ascii") + b"\r\n\r\n" + body

    def _send_invite(self, authorization: tuple[str, str] | None = None) -> None:
        self.cseq += 1
        self._invite = self._request("INVITE", authorization=authorization, body=self._sdp())
        self.socket.send(self._invite)
        self._invite_sent_at = time.monotonic()
        self._retransmit_after = 0.5
        self.events.append(f"tx INVITE cseq={self.cseq}")

    def _send_ack(self, response_headers: dict[str, str]) -> None:
        to_value = response_headers.get("to", self.to_header)
        previous = self.to_header
        self.to_header = to_value
        message = self._request("ACK")
        self.to_header = previous
        self.socket.send(message)
        self.events.append(f"tx ACK cseq={self.cseq}")

    def _authorization(self, challenge: str, method: str = "INVITE") -> str:
        values = _digest_parameters(challenge)
        realm = values.get("realm", "")
        nonce = values.get("nonce", "")
        algorithm = values.get("algorithm", "MD5").upper()
        if algorithm != "MD5" or not realm or not nonce:
            raise ValueError("unsupported or incomplete SIP Digest challenge")
        username = self.config.username
        ha1 = md5(f"{username}:{realm}:{self.config.password}".encode()).hexdigest()
        ha2 = md5(f"{method}:{self.target_uri}".encode()).hexdigest()
        qop = "auth" if "auth" in values.get("qop", "").lower().split(",") else ""
        parts = [
            f'username="{username}"',
            f'realm="{realm}"',
            f'nonce="{nonce}"',
            f'uri="{self.target_uri}"',
        ]
        if qop:
            nc = "00000001"
            cnonce = f"{random.getrandbits(64):016x}"
            response = md5(f"{ha1}:{nonce}:{nc}:{cnonce}:{qop}:{ha2}".encode()).hexdigest()
            parts.extend((f"qop={qop}", f"nc={nc}", f'cnonce="{cnonce}"'))
        else:
            response = md5(f"{ha1}:{nonce}:{ha2}".encode()).hexdigest()
        parts.extend((f'response="{response}"', "algorithm=MD5"))
        return "Digest " + ", ".join(parts)

    def _parse_sdp(self, body: bytes, source_host: str) -> None:
        host = source_host
        port = 0
        payloads: list[str] = []
        for raw in body.decode("ascii", "ignore").splitlines():
            line = raw.strip()
            if line.startswith("c=IN IP4 "):
                host = line.split()[-1]
            elif line.startswith("m=audio "):
                fields = line.split()
                port = int(fields[1])
                payloads = fields[3:]
        if port and "0" in payloads:
            self.remote_rtp = (host, port)
        elif port:
            raise ValueError("SIP peer did not accept PCMU payload 0")

    def _handle_response(self, data: bytes, source: tuple[str, int]) -> None:
        head, _, body = data.partition(b"\r\n\r\n")
        lines = head.decode("latin-1", "replace").split("\r\n")
        fields = lines[0].split(None, 2)
        if len(fields) < 2 or not fields[1].isdigit():
            return
        status = int(fields[1])
        headers = _header_map(lines[1:])
        self.last_status = status
        self.events.append(f"rx {status}")
        if status < 200:
            if body:
                try:
                    self._parse_sdp(body, source[0])
                except (ValueError, OSError):
                    pass
            self.state = "ringing" if status == 180 else "trying"
            return
        if status in (401, 407) and not self._auth_attempted:
            self._send_ack(headers)
            challenge_name = "proxy-authenticate" if status == 407 else "www-authenticate"
            header_name = "Proxy-Authorization" if status == 407 else "Authorization"
            try:
                authorization = self._authorization(headers.get(challenge_name, ""))
            except ValueError as exc:
                self.state = "failed"
                self.error = str(exc)
                return
            self._auth_attempted = True
            self._send_invite((header_name, authorization))
            self.state = "inviting"
            return
        if 200 <= status < 300:
            try:
                self._parse_sdp(body, source[0])
            except (ValueError, OSError) as exc:
                self.state = "failed"
                self.error = str(exc)
                return
            self.to_header = headers.get("to", self.to_header)
            self._send_ack(headers)
            self.state = "connected"
            self._next_rtp_at = time.monotonic()
            return
        self._send_ack(headers)
        self.state = "failed"
        self.error = lines[0]

    def _handle_request(self, data: bytes, source: tuple[str, int]) -> None:
        head, _, _body = data.partition(b"\r\n\r\n")
        lines = head.decode("latin-1", "replace").split("\r\n")
        fields = lines[0].split()
        if not fields:
            return
        method = fields[0].upper()
        if method != "BYE":
            return
        headers = _header_map(lines[1:])
        response = (
            "SIP/2.0 200 OK\r\n"
            f"Via: {headers.get('via', '')}\r\n"
            f"From: {headers.get('from', '')}\r\n"
            f"To: {headers.get('to', '')}\r\n"
            f"Call-ID: {headers.get('call-id', '')}\r\n"
            f"CSeq: {headers.get('cseq', '')}\r\n"
            "Content-Length: 0\r\n\r\n"
        ).encode("ascii", "replace")
        self.socket.sendto(response, source)
        self.state = "closed"
        self.events.append("rx BYE")

    def poll(self) -> None:
        if self.closed:
            return
        while True:
            try:
                data, source = self.socket.recvfrom(65_535)
            except BlockingIOError:
                break
            if data.startswith(b"SIP/2.0 "):
                self._handle_response(data, source)
            else:
                self._handle_request(data, source)
        while True:
            try:
                packet, _source = self.rtp_socket.recvfrom(2_048)
            except BlockingIOError:
                break
            if len(packet) < 12 or packet[1] & 0x7F != 0:
                continue
            self._rx_audio.extend(ulaw_to_linear(value) for value in packet[12:])
            self.rtp_packets_received += 1
        now = time.monotonic()
        if self.state in ("inviting", "trying", "ringing") and self._invite:
            if now - self._invite_sent_at >= self._retransmit_after:
                self.socket.send(self._invite)
                self._invite_sent_at = now
                self._retransmit_after = min(self._retransmit_after * 2, 4.0)
                self.events.append("tx INVITE retransmit")
        self._flush_rtp(now)

    def send_audio(self, samples: list[int]) -> None:
        if self.state in ("inviting", "trying", "ringing", "connected"):
            self._tx_audio.extend(samples)
        self._flush_rtp(time.monotonic())

    def _flush_rtp(self, now: float) -> None:
        if (
            self.state != "connected"
            or self.remote_rtp is None
            or len(self._tx_audio) < RTP_PACKET_SAMPLES
            or now < self._next_rtp_at
        ):
            return
        payload = bytes(linear_to_ulaw(self._tx_audio.popleft()) for _ in range(160))
        header = bytes((0x80, 0x00))
        header += self._rtp_sequence.to_bytes(2, "big")
        header += self._rtp_timestamp.to_bytes(4, "big")
        header += self._rtp_ssrc.to_bytes(4, "big")
        self.rtp_socket.sendto(header + payload, self.remote_rtp)
        self._rtp_sequence = (self._rtp_sequence + 1) & 0xFFFF
        self._rtp_timestamp = (self._rtp_timestamp + RTP_PACKET_SAMPLES) & 0xFFFFFFFF
        self._next_rtp_at = max(self._next_rtp_at + 0.020, now)
        self.rtp_packets_sent += 1

    def receive_audio(self) -> list[int]:
        result = list(self._rx_audio)
        self._rx_audio.clear()
        return result

    def status(self) -> dict[str, str | int | bool | list[str]]:
        value: dict[str, str | int | bool | list[str]] = asdict(self.config)
        value.pop("password", None)
        value.update(
            state=self.state,
            number=self.number,
            target=self.target_uri,
            last_status=self.last_status,
            error=self.error,
            local_port=self.local_port,
            rtp_port=self.rtp_port,
            remote_rtp=(f"{self.remote_rtp[0]}:{self.remote_rtp[1]}" if self.remote_rtp else ""),
            rtp_packets_sent=self.rtp_packets_sent,
            rtp_packets_received=self.rtp_packets_received,
            events=list(self.events),
        )
        return value

    def close(self) -> None:
        if self.closed:
            return
        if self.state == "connected":
            self.cseq += 1
            try:
                self.socket.send(self._request("BYE"))
                self.events.append(f"tx BYE cseq={self.cseq}")
            except OSError:
                pass
        self.closed = True
        self.socket.close()
        self.rtp_socket.close()
