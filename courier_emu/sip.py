from __future__ import annotations

from collections import deque
from dataclasses import asdict, dataclass
from hashlib import md5
import math
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


class PolyphaseResampler:
    """Band-limited rational resampling between any two integer rates.

    `RateConverter` above is a zero-order hold: it repeats or drops samples.
    That is adequate for speech at the 6:5 ratio it was written for, but it
    leaves the images of every tone it passes, and the dial path's 7200 Hz is
    the rate that makes those images land in band - a 1633 Hz column tone held
    to 8 kHz images at 6367 Hz, which folds back where a far-end DTMF receiver
    is looking. This filters instead.

    The design is the textbook polyphase one: upsample by L, low-pass at the
    lower of the two Nyquists, decimate by M, with only the taps that meet a
    non-zero sample ever evaluated. Each phase's taps are normalised to sum to
    one, so the passband gain is exactly unity at DC on every phase and the
    output carries no ripple from the phase rotation itself.
    """

    # Taps per phase. Sixteen puts the transition band well inside the guard
    # below and costs 16 multiplies per output sample.
    taps_per_phase = 16
    # Fraction of the lower Nyquist the passband is allowed to reach. The rest
    # is transition band. 0.92 of 3600 Hz leaves 3312 Hz, above V.34's 3429 Hz
    # upper edge only marginally, and well clear of DTMF's 1633 Hz.
    guard = 0.92

    def __init__(self, input_rate: int, output_rate: int) -> None:
        if input_rate <= 0 or output_rate <= 0:
            raise ValueError("sample rates must be positive")
        self.input_rate = input_rate
        self.output_rate = output_rate
        common = math.gcd(input_rate, output_rate)
        self.up = output_rate // common
        self.down = input_rate // common
        self._taps = self._design()
        self._half = (self.taps_per_phase - 1) // 2
        # Absolute input index of `_buffer[0]`, and the next output index.
        self._buffer: list[float] = [0.0] * self.taps_per_phase
        self._origin = -self.taps_per_phase
        self._output = 0

    def _design(self) -> list[list[float]]:
        """Return the filter as `up` phases of `taps_per_phase` taps each."""
        length = self.up * self.taps_per_phase
        # Cutoff as a fraction of the intermediate rate, which is
        # input_rate * up == output_rate * down.
        intermediate = self.input_rate * self.up
        cutoff = self.guard * min(self.input_rate, self.output_rate) / 2 / intermediate
        centre = (length - 1) / 2
        window: list[float] = []
        for index in range(length):
            offset = index - centre
            if offset == 0:
                value = 2 * cutoff
            else:
                value = math.sin(2 * math.pi * cutoff * offset) / (math.pi * offset)
            # Blackman: -74 dB sidelobes, which is below 16-bit anyway.
            ratio = index / (length - 1)
            value *= (
                0.42
                - 0.5 * math.cos(2 * math.pi * ratio)
                + 0.08 * math.cos(4 * math.pi * ratio)
            )
            window.append(value)
        phases = []
        for phase in range(self.up):
            taps = window[phase :: self.up]
            total = sum(taps)
            # A phase whose taps cancel to nothing cannot be normalised; the
            # Blackman window makes that impossible in practice, but division
            # by it would be silent corruption rather than an error.
            if abs(total) < 1e-9:
                raise ValueError("degenerate resampler phase")
            phases.append([tap / total for tap in taps])
        return phases

    def convert(self, samples) -> list[int]:
        """Take input samples and return every output sample now determined."""
        if self.up == self.down == 1:
            # Equal rates: the filter would be a 16-tap low-pass at 0.92 of
            # Nyquist and a group delay, applied to audio that is already at
            # the rate asked for. Now that the line and the SIP leg are both
            # 8 kHz this is the common case, and a conversion nobody asked for
            # is a filter the tone detectors see through.
            return [int(sample) for sample in samples]
        self._buffer.extend(float(sample) for sample in samples)
        result: list[int] = []
        newest = self._origin + len(self._buffer) - 1
        while True:
            position = self._output * self.down
            base = position // self.up
            if base + self._half > newest:
                break
            taps = self._taps[position % self.up]
            total = 0.0
            for index, tap in enumerate(taps):
                sample = base + self._half - index - self._origin
                if 0 <= sample < len(self._buffer):
                    total += tap * self._buffer[sample]
            result.append(max(-32_768, min(32_767, int(round(total)))))
            self._output += 1
        # Drop everything the next output can no longer reach back to.
        oldest = (self._output * self.down) // self.up + self._half - self.taps_per_phase + 1
        drop = oldest - self._origin
        if drop > 0:
            del self._buffer[:drop]
            self._origin += drop
        return result

    def flush(self) -> list[int]:
        """Return the tail, by feeding in the filter's own group delay."""
        return self.convert([0] * (self.taps_per_phase + self.down))


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
        self.remote_target = ""
        self.direction = ""
        self.incoming_from = ""
        self.incoming_to = ""
        self._incoming_headers: dict[str, str] = {}
        self._incoming_response = b""
        self._incoming_ringing = False
        self.state = "idle"
        self.last_status = 0
        self.error = ""
        self.events: deque[str] = deque(maxlen=64)
        self._invite = b""
        self._invite_branch = ""
        self._invite_cseq = 0
        self._invite_sent_at = 0.0
        self._retransmit_after = 0.5
        self._auth_attempted = False
        self.registered = False
        self._register_call_id = f"{random.getrandbits(64):016x}@{self.local_ip}"
        self._register_cseq = 0
        self._register_auth_attempted = False
        self._tx_audio: deque[int] = deque(maxlen=PCMU_RATE * 2)
        # Codeword mode: the B channel's own G.711 octets, in and out, with no
        # conversion at either end. set_codewords() turns it on.
        self.codewords = False
        self._tx_codewords: deque[int] = deque(maxlen=PCMU_RATE * 2)
        self._rx_codewords: deque[int] = deque(maxlen=PCMU_RATE * 2)
        self._rx_audio: deque[int] = deque()
        self._rtp_sequence = random.getrandbits(16)
        self._rtp_timestamp = random.getrandbits(32)
        self._rtp_ssrc = random.getrandbits(32)
        self._next_rtp_at = 0.0
        self.rtp_packets_sent = 0
        self.rtp_packets_received = 0
        self.rtp_octets_sent = 0
        self.rtp_octets_received = 0
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
        # Each call is its own dialogue; reusing the identifiers of the last
        # one makes the second INVITE look like a retransmission of the first.
        self.call_id = f"{random.getrandbits(64):016x}@{self.local_ip}"
        self.from_tag = f"{random.getrandbits(32):08x}"
        self.number = number
        self.direction = "outbound"
        self.incoming_from = ""
        self.incoming_to = ""
        self._incoming_headers = {}
        self._incoming_response = b""
        self._incoming_ringing = False
        self.remote_target = ""
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
        branch: str = "",
        cseq: int | None = None,
    ) -> bytes:
        # CANCEL is the one request that must carry the branch and sequence
        # number of the INVITE it cancels rather than its own.
        self.branch = branch or f"z9hG4bK{random.getrandbits(48):012x}"
        if cseq is None:
            cseq = self.cseq
        if self.direction == "inbound":
            from_header = self.to_header
            to_header = self._incoming_headers.get("from", "")
        else:
            from_header = (
                f'"{self.config.display_name}" '
                f'<sip:{self.config.username}@{self.server_host}>;tag={self.from_tag}'
            )
            to_header = self.to_header
        headers = [
            f"Via: SIP/2.0/UDP {self.local_ip}:{self.local_port};branch={self.branch};rport",
            "Max-Forwards: 70",
            f"From: {from_header}",
            f"To: {to_header}",
            f"Call-ID: {self.call_id}",
            f"CSeq: {cseq} {method}",
            f"Contact: <sip:{self.config.username}@{self.local_ip}:{self.local_port}>",
            "User-Agent: courier-emu/0.1",
        ]
        if authorization:
            headers.append(f"{authorization[0]}: {authorization[1]}")
        if body:
            headers.append("Content-Type: application/sdp")
        headers.append(f"Content-Length: {len(body)}")
        # In-dialog requests are addressed to the remote target the 2xx gave.
        uri = self.remote_target if (self.remote_target and method in ("ACK", "BYE")) else self.target_uri
        text = f"{method} {uri} SIP/2.0\r\n" + "\r\n".join(headers)
        return text.encode("ascii") + b"\r\n\r\n" + body

    def _send_invite(self, authorization: tuple[str, str] | None = None) -> None:
        self.cseq += 1
        self._invite = self._request("INVITE", authorization=authorization, body=self._sdp())
        self._invite_branch = self.branch
        self._invite_cseq = self.cseq
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

    def _authorization(
        self, challenge: str, method: str = "INVITE", uri: str | None = None
    ) -> str:
        values = _digest_parameters(challenge)
        realm = values.get("realm", "")
        nonce = values.get("nonce", "")
        algorithm = values.get("algorithm", "MD5").upper()
        if algorithm != "MD5" or not realm or not nonce:
            raise ValueError("unsupported or incomplete SIP Digest challenge")
        username = self.config.username
        ha1 = md5(f"{username}:{realm}:{self.config.password}".encode()).hexdigest()
        digest_uri = uri or self.target_uri
        ha2 = md5(f"{method}:{digest_uri}".encode()).hexdigest()
        qop = "auth" if "auth" in values.get("qop", "").lower().split(",") else ""
        parts = [
            f'username="{username}"',
            f'realm="{realm}"',
            f'nonce="{nonce}"',
            f'uri="{digest_uri}"',
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

    def register(self, authorization: str = "") -> None:
        """Register this UDP contact with the configured SIP server."""
        self._register_cseq += 1
        uri = f"sip:{self.server_host}"
        branch = f"z9hG4bK{random.getrandbits(48):012x}"
        identity = f"<sip:{self.config.username}@{self.server_host}>"
        lines = [
            f"REGISTER {uri} SIP/2.0",
            f"Via: SIP/2.0/UDP {self.local_ip}:{self.local_port};branch={branch};rport",
            "Max-Forwards: 70",
            f"From: {identity};tag={self.from_tag}",
            f"To: {identity}",
            f"Call-ID: {self._register_call_id}",
            f"CSeq: {self._register_cseq} REGISTER",
            f"Contact: <sip:{self.config.username}@{self.local_ip}:{self.local_port}>",
            "Expires: 300",
            "User-Agent: courier-emu/0.1",
        ]
        if authorization:
            lines.append(f"Authorization: {authorization}")
        lines.append("Content-Length: 0")
        self.socket.send(("\r\n".join(lines) + "\r\n\r\n").encode("ascii"))
        self.events.append(f"tx REGISTER cseq={self._register_cseq}")

    def _handle_register_response(
        self, status: int, headers: dict[str, str]
    ) -> None:
        self.events.append(f"rx REGISTER {status}")
        if status == 401 and not self._register_auth_attempted:
            try:
                authorization = self._authorization(
                    headers.get("www-authenticate", ""),
                    method="REGISTER",
                    uri=f"sip:{self.server_host}",
                )
            except ValueError as exc:
                self.error = str(exc)
                return
            self._register_auth_attempted = True
            self.register(authorization)
            return
        if 200 <= status < 300:
            self.registered = True
            return
        if status >= 300:
            self.error = f"REGISTER failed with SIP {status}"

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
        else:
            raise ValueError("SIP peer did not offer an audio RTP port")

    @staticmethod
    def _header_user(value: str) -> str:
        match = re.search(r"sips?:([^@;>]+)", value, re.IGNORECASE)
        return match.group(1) if match else ""

    def _response(
        self,
        status: int,
        reason: str,
        headers: dict[str, str],
        *,
        body: bytes = b"",
        tagged: bool = True,
    ) -> bytes:
        to_header = headers.get("to", "")
        if tagged and not re.search(r"(?:^|;)\s*tag=", to_header, re.IGNORECASE):
            to_header += f";tag={self.from_tag}"
        lines = [
            f"SIP/2.0 {status} {reason}",
            f"Via: {headers.get('via', '')}",
            f"From: {headers.get('from', '')}",
            f"To: {to_header}",
            f"Call-ID: {headers.get('call-id', '')}",
            f"CSeq: {headers.get('cseq', '')}",
        ]
        if status >= 180:
            lines.append(
                f"Contact: <sip:{self.config.username}@{self.local_ip}:{self.local_port}>"
            )
        if body:
            lines.append("Content-Type: application/sdp")
        lines.append(f"Content-Length: {len(body)}")
        return ("\r\n".join(lines) + "\r\n\r\n").encode("ascii", "replace") + body

    def _send_response(self, response: bytes, event: str) -> None:
        try:
            self.socket.send(response)
        except OSError:
            return
        if event:
            self.events.append(event)

    def ring_incoming(self) -> None:
        """Tell an inbound caller that the ISDN terminal is alerting."""
        if self.direction != "inbound" or self.state != "incoming":
            return
        response = self._response(180, "Ringing", self._incoming_headers)
        self._incoming_response = response
        self._incoming_ringing = True
        self.state = "ringing"
        self._send_response(response, "tx 180")

    def answer_incoming(self) -> None:
        """Accept an inbound call once the ISDN terminal has connected it."""
        if self.direction != "inbound" or self.state not in ("incoming", "ringing"):
            return
        response = self._response(
            200, "OK", self._incoming_headers, body=self._sdp()
        )
        self._incoming_response = response
        self.state = "connected"
        self._next_rtp_at = time.monotonic()
        self._send_response(response, "tx 200")

    def reject_incoming(
        self, status: int = 480, reason: str = "Temporarily Unavailable"
    ) -> None:
        if self.direction != "inbound" or self.state not in ("incoming", "ringing"):
            return
        response = self._response(status, reason, self._incoming_headers)
        self._incoming_response = response
        self.state = "failed"
        self.last_status = status
        self.error = f"SIP/2.0 {status} {reason}"
        self._send_response(response, f"tx {status}")

    def _handle_response(self, data: bytes, source: tuple[str, int]) -> None:
        head, _, body = data.partition(b"\r\n\r\n")
        lines = head.decode("latin-1", "replace").split("\r\n")
        fields = lines[0].split(None, 2)
        if len(fields) < 2 or not fields[1].isdigit():
            return
        status = int(fields[1])
        headers = _header_map(lines[1:])
        cseq = headers.get("cseq", "").split()
        if len(cseq) > 1 and cseq[1].upper() == "REGISTER":
            self._handle_register_response(status, headers)
            return
        if len(cseq) > 1 and cseq[1].upper() in ("BYE", "CANCEL"):
            self.events.append(f"rx {status} {cseq[1].upper()}")
            return
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
            # RFC 3261 13.2.2.4: the ACK for a 2xx goes to the Contact of the
            # response, not to the URI the INVITE was addressed to. Asterisk
            # dropped an ACK addressed to sip:<number>@<host>, retransmitted
            # its 200, and tore the call down about a second in.
            contact = headers.get("contact", "")
            match = re.search(r"<([^>]+)>", contact) or re.search(r"(sips?:\S+)", contact)
            if match:
                self.remote_target = match.group(1).split(";")[0]
            self._send_ack(headers)
            self.state = "connected"
            self._next_rtp_at = time.monotonic()
            return
        self._send_ack(headers)
        self.state = "failed"
        self.error = lines[0]

    def _handle_request(self, data: bytes, source: tuple[str, int]) -> None:
        head, _, body = data.partition(b"\r\n\r\n")
        lines = head.decode("latin-1", "replace").split("\r\n")
        fields = lines[0].split()
        if not fields:
            return
        method = fields[0].upper()
        headers = _header_map(lines[1:])

        if method in ("OPTIONS", "NOTIFY"):
            # Asterisk qualifies registered contacts with OPTIONS and sends an
            # unsolicited message-summary NOTIFY immediately after REGISTER.
            # Ignoring either makes it retransmit; ignoring OPTIONS also marks
            # the contact unavailable, so subsequent calls never get INVITEd.
            self._send_response(self._response(200, "OK", headers), "")
            return

        if method == "INVITE":
            # UDP retransmissions of the same server transaction get the last
            # response again. They must not create a second BRI call or a new
            # To tag.
            if (
                self.direction == "inbound"
                and headers.get("call-id") == self.call_id
                and headers.get("cseq") == self._incoming_headers.get("cseq")
            ):
                if self._incoming_response:
                    self._send_response(self._incoming_response, "tx response retransmit")
                return
            if self.state not in ("idle", "closed", "failed"):
                self._send_response(
                    self._response(486, "Busy Here", headers), "tx 486"
                )
                return
            try:
                self._parse_sdp(body, source[0])
            except (ValueError, OSError):
                self._send_response(
                    self._response(488, "Not Acceptable Here", headers), "tx 488"
                )
                return
            self.direction = "inbound"
            self.from_tag = f"{random.getrandbits(32):08x}"
            self.call_id = headers.get("call-id", self.call_id)
            self._incoming_headers = headers
            self.incoming_from = self._header_user(headers.get("from", ""))
            self.incoming_to = self._header_user(headers.get("to", ""))
            self.number = self.incoming_from
            self.target_uri = fields[1] if len(fields) > 1 else ""
            self.to_header = headers.get("to", "")
            if not re.search(r"(?:^|;)\s*tag=", self.to_header, re.IGNORECASE):
                self.to_header += f";tag={self.from_tag}"
            contact = headers.get("contact", "")
            match = re.search(r"<([^>]+)>", contact) or re.search(
                r"(sips?:\S+)", contact
            )
            self.remote_target = (
                match.group(1).split(";")[0] if match else
                f"sip:{self.incoming_from or self.config.username}"
                f"@{source[0]}:{source[1]}"
            )
            # The two dialog directions have independent CSeq spaces. The
            # remote INVITE's value stays in its headers; our first in-dialog
            # request starts the local sequence at one.
            self.cseq = 0
            self.state = "incoming"
            self.error = ""
            trying = self._response(100, "Trying", headers, tagged=False)
            self._incoming_response = trying
            self._incoming_ringing = False
            self.events.append(
                f"rx INVITE from {self.incoming_from or '(unknown)'}"
            )
            self._send_response(trying, "tx 100")
            return

        if method == "ACK":
            if (
                self.direction == "inbound"
                and headers.get("call-id") == self.call_id
                and self.state == "connected"
            ):
                self.events.append("rx ACK")
            return

        if method == "CANCEL":
            self._send_response(self._response(200, "OK", headers), "tx 200 CANCEL")
            if self.direction == "inbound" and self.state in ("incoming", "ringing"):
                self._send_response(
                    self._response(487, "Request Terminated", self._incoming_headers),
                    "tx 487 INVITE",
                )
                self.state = "closed"
                self.events.append("rx CANCEL")
            return

        if method != "BYE":
            return
        if headers.get("call-id") != self.call_id:
            self._send_response(
                self._response(481, "Call/Transaction Does Not Exist", headers),
                "tx 481",
            )
            return
        response = (
            "SIP/2.0 200 OK\r\n"
            f"Via: {headers.get('via', '')}\r\n"
            f"From: {headers.get('from', '')}\r\n"
            f"To: {headers.get('to', '')}\r\n"
            f"Call-ID: {headers.get('call-id', '')}\r\n"
            f"CSeq: {headers.get('cseq', '')}\r\n"
            "Content-Length: 0\r\n\r\n"
        ).encode("ascii", "replace")
        # The signalling socket is connected to the server, so a reply goes
        # back with send. sendto raises EISCONN on a connected UDP socket,
        # which left every inbound BYE unanswered.
        try:
            self.socket.send(response)
        except OSError:
            pass
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
            if self.codewords:
                self._rx_codewords.extend(packet[12:])
            else:
                self._rx_audio.extend(ulaw_to_linear(value)
                                      for value in packet[12:])
            self.rtp_packets_received += 1
            self.rtp_octets_received += len(packet) - 12
        now = time.monotonic()
        # Only an INVITE that has drawn no response at all is retransmitted.
        # RFC 3261 stops timer A on the first provisional, and retransmitting
        # through a long ringback sent the proxy one INVITE a second.
        if self.state == "inviting" and self._invite:
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

    # -- codewords ---------------------------------------------------------
    #
    # An ISDN B channel already carries what RTP's PCMU payload carries: G.711
    # at 8 kHz, one octet per sample. Decoding those octets to linear and
    # re-encoding them on the way out would be two conversions that cancel on
    # a good day, and a datapump betting a connection on the low bit of a
    # codeword does not want a good day - V.90 and x2 are built on the
    # codewords themselves. So in codeword mode the payload is passed through
    # untouched, and the linear paths above are left alone for the analogue
    # side, which really does have to resample.

    def set_codewords(self, enabled: bool = True) -> None:
        self.codewords = enabled

    def send_pcmu(self, octets: bytes) -> None:
        if self.state in ("inviting", "trying", "ringing", "connected"):
            self._tx_codewords.extend(octets)
        self._flush_rtp(time.monotonic())

    def receive_pcmu(self, count: int | None = None) -> bytes:
        if count is None:
            count = len(self._rx_codewords)
        taken = bytes(self._rx_codewords.popleft()
                      for _ in range(min(count, len(self._rx_codewords))))
        return taken

    def _flush_rtp(self, now: float) -> None:
        source = self._tx_codewords if self.codewords else self._tx_audio
        # The analogue bridge hands us 100 ms blocks while RTP packetizes
        # 20 ms. Send every packet whose playout time has arrived, not merely
        # one packet per bridge call. The old one-shot form turned an otherwise
        # 30%-real-time emulator into a 6%-rate transmitter.
        while (
            self.state == "connected"
            and self.remote_rtp is not None
            and len(source) >= RTP_PACKET_SAMPLES
            and now >= self._next_rtp_at
        ):
            payload = (
                bytes(self._tx_codewords.popleft() for _ in range(RTP_PACKET_SAMPLES))
                if self.codewords else
                bytes(linear_to_ulaw(self._tx_audio.popleft())
                      for _ in range(RTP_PACKET_SAMPLES))
            )
            header = bytes((0x80, 0x00))
            header += self._rtp_sequence.to_bytes(2, "big")
            header += self._rtp_timestamp.to_bytes(4, "big")
            header += self._rtp_ssrc.to_bytes(4, "big")
            self.rtp_socket.sendto(header + payload, self.remote_rtp)
            self._rtp_sequence = (self._rtp_sequence + 1) & 0xFFFF
            self._rtp_timestamp = (
                self._rtp_timestamp + RTP_PACKET_SAMPLES
            ) & 0xFFFFFFFF
            self._next_rtp_at += RTP_PACKET_SAMPLES / PCMU_RATE
            self.rtp_packets_sent += 1
            self.rtp_octets_sent += len(payload)

    def receive_audio(self) -> list[int]:
        result = list(self._rx_audio)
        self._rx_audio.clear()
        return result

    def status(self) -> dict[str, str | int | bool | list[str]]:
        value: dict[str, str | int | bool | list[str]] = asdict(self.config)
        value.pop("password", None)
        value.update(
            state=self.state,
            direction=self.direction,
            registered=self.registered,
            number=self.number,
            incoming_from=self.incoming_from,
            incoming_to=self.incoming_to,
            target=self.target_uri,
            last_status=self.last_status,
            error=self.error,
            local_port=self.local_port,
            rtp_port=self.rtp_port,
            remote_rtp=(f"{self.remote_rtp[0]}:{self.remote_rtp[1]}" if self.remote_rtp else ""),
            rtp_packets_sent=self.rtp_packets_sent,
            rtp_packets_received=self.rtp_packets_received,
            rtp_octets_sent=self.rtp_octets_sent,
            rtp_octets_received=self.rtp_octets_received,
            events=list(self.events),
        )
        return value

    def hangup(self) -> None:
        """End the call in progress, keeping the session usable for another.

        `close` is the end of the session and its sockets. This is the end of
        one call: BYE for an established dialogue, CANCEL for one still being
        set up. Either way the state returns to idle so the next seizure of
        the loop can dial again.
        """
        if self.closed:
            return
        try:
            if self.state == "connected":
                self.cseq += 1
                self.socket.send(self._request("BYE"))
                self.events.append(f"tx BYE cseq={self.cseq}")
            elif self.state in ("inviting", "trying", "ringing"):
                self.socket.send(
                    self._request(
                        "CANCEL", branch=self._invite_branch, cseq=self._invite_cseq
                    )
                )
                self.events.append(f"tx CANCEL cseq={self._invite_cseq}")
        except OSError:
            pass
        self.state = "idle"
        self.direction = ""
        self.remote_target = ""
        self.remote_rtp = None
        self._incoming_headers = {}
        self._incoming_response = b""
        self._incoming_ringing = False
        self._tx_audio.clear()
        self._rx_audio.clear()
        self._tx_codewords.clear()
        self._rx_codewords.clear()

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
