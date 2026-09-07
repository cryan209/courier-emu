from __future__ import annotations

import math
import socket
import struct
import unittest
from unittest.mock import patch

from courier_emu.ata import SipLine
from courier_emu.bridge import LINE_RATE
from courier_emu.exchange import DtmfDecoder
from courier_emu.sip import (
    PCMU_RATE,
    PolyphaseResampler,
    RateConverter,
    SipConfig,
    SipSession,
    linear_to_ulaw,
    ulaw_to_linear,
)

from courier_emu.bridge import CourierDspBridge
from courier_emu.daa import CourierDaa
from courier_emu.exchange import LineExchange
from courier_emu.line import LINE_FRAME_INSTRUCTIONS, LINE_FRAME_SAMPLES

import test_bridge
from test_bridge import _Core, _Image
from test_sip import _response


# The dial path's rate. Every DTMF sample this file resamples comes out of it.
DIAL_RATE = 7_200
BLOCK = 144  # 20 ms, short enough for the exchange to resolve its transitions


def _dtmf(digit: str, samples: int, rate: int = DIAL_RATE, start: int = 0) -> list[int]:
    """One DTMF pair. `start` continues an earlier block's phase."""
    rows, columns = (697, 770, 852, 941), (1209, 1336, 1477, 1633)
    index = "123A456B789C*0#D".index(digit)
    row, column = rows[index // 4], columns[index % 4]
    return [
        round(8_000 * (math.sin(2 * math.pi * row * n / rate)
                       + math.sin(2 * math.pi * column * n / rate)))
        for n in range(start, start + samples)
    ]


def _bin_power(samples: list[int], frequency: int, rate: int) -> float:
    coefficient = 2 * math.cos(2 * math.pi * frequency / rate)
    first = second = 0.0
    for sample in samples:
        first, second = sample + coefficient * first - second, first
    return (first * first + second * second - coefficient * first * second) / len(samples) ** 2


class ResamplerTests(unittest.TestCase):
    def test_output_length_follows_the_rate_ratio(self) -> None:
        for source, destination in ((7_200, 8_000), (8_000, 7_200), (9_600, 8_000)):
            converter = PolyphaseResampler(source, destination)
            produced = len(converter.convert([0] * source))
            # One second in, one second out, to within the filter's own delay.
            self.assertLess(abs(produced - destination), converter.taps_per_phase + 1)

    def test_dtmf_survives_the_trip_to_g711_and_back(self) -> None:
        digits = "6245"
        line: list[int] = []
        for digit in digits:
            line.extend(_dtmf(digit, DIAL_RATE // 10))
            line.extend([0] * (DIAL_RATE // 20))
        network = PolyphaseResampler(DIAL_RATE, PCMU_RATE).convert(line)
        coded = [ulaw_to_linear(linear_to_ulaw(sample)) for sample in network]
        decoder = DtmfDecoder(sample_rate=PCMU_RATE)
        decoder.feed(coded)
        self.assertEqual(decoder.digits, digits)

    def test_the_filter_beats_the_hold_on_the_images_it_exists_for(self) -> None:
        # 1633 Hz at 7200 is the worst case: a zero-order hold puts its image
        # where a far-end receiver is listening.
        tone = _dtmf("A", DIAL_RATE // 4)
        held = RateConverter(DIAL_RATE, PCMU_RATE).convert(tone)
        filtered = PolyphaseResampler(DIAL_RATE, PCMU_RATE).convert(tone)

        def worst(samples: list[int]) -> float:
            peak = max(_bin_power(samples, f, PCMU_RATE) for f in (697, 1633))
            spur = max(
                _bin_power(samples, frequency, PCMU_RATE)
                for frequency in range(2_000, 4_000, 50)
            )
            return spur / peak

        self.assertLess(worst(filtered), worst(held) / 10)


class MockPbx:
    """The other end of the wire: 180, then 200 with SDP, then RTP."""

    def __init__(self) -> None:
        self.socket = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        self.socket.bind(("127.0.0.1", 0))
        self.socket.setblocking(False)
        self.rtp = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        self.rtp.bind(("127.0.0.1", 0))
        self.rtp.setblocking(False)
        self.requests: list[str] = []
        self.invite = b""
        self.peer: tuple[str, int] | None = None
        self.answered = False
        self.rtp_bytes_received = 0
        self._phase = 0

    @property
    def address(self) -> str:
        return "127.0.0.1:%d" % self.socket.getsockname()[1]

    def poll(self) -> None:
        while True:
            try:
                data, source = self.socket.recvfrom(4_096)
            except BlockingIOError:
                break
            line = data.split(b"\r\n")[0].decode()
            self.requests.append(line)
            if line.startswith("INVITE"):
                self.invite, self.peer = data, source
                self.socket.sendto(_response(data, "180 Ringing"), source)
        while True:
            try:
                packet, _ = self.rtp.recvfrom(2_048)
            except BlockingIOError:
                break
            self.rtp_bytes_received += len(packet) - 12

    def answer(self) -> None:
        body = (
            "v=0\r\no=- 1 1 IN IP4 127.0.0.1\r\ns=-\r\nc=IN IP4 127.0.0.1\r\nt=0 0\r\n"
            "m=audio %d RTP/AVP 0\r\na=rtpmap:0 PCMU/8000\r\n" % self.rtp.getsockname()[1]
        ).encode()
        assert self.peer is not None
        self.socket.sendto(
            _response(self.invite, "200 OK", extra="Content-Type: application/sdp\r\n", body=body),
            self.peer,
        )
        self.answered = True

    def send_tone(self, port: int, frequency: int = 1_000) -> None:
        payload = bytes(
            linear_to_ulaw(round(8_000 * math.sin(2 * math.pi * frequency * n / PCMU_RATE)))
            for n in range(self._phase, self._phase + 160)
        )
        self._phase += 160
        header = struct.pack("!BBHII", 0x80, 0, self._phase & 0xFFFF, self._phase, 0x1234)
        self.rtp.sendto(header + payload, ("127.0.0.1", port))

    def bye(self, session: SipSession) -> None:
        """The far end hangs up."""
        assert self.peer is not None
        self.socket.sendto(
            (
                "BYE sip:courier@127.0.0.1 SIP/2.0\r\n"
                "Via: SIP/2.0/UDP 127.0.0.1\r\n"
                "From: <sip:6245@127.0.0.1>;tag=mockpbx\r\n"
                "To: <sip:courier@127.0.0.1>\r\n"
                f"Call-ID: {session.call_id}\r\n"
                "CSeq: 1 BYE\r\nContent-Length: 0\r\n\r\n"
            ).encode(),
            self.peer,
        )

    def close(self) -> None:
        self.socket.close()
        self.rtp.close()


class SipLineTests(unittest.TestCase):
    """The loop in front of the instrument, end to end over real sockets."""

    def setUp(self) -> None:
        self.pbx = MockPbx()
        self.line = SipLine(
            sip=SipSession(SipConfig(server=self.pbx.address, username="courier")),
            line_rate=DIAL_RATE,
        )
        self.addCleanup(self.pbx.close)
        self.addCleanup(self.line.close)

    def _dial(self, number: str) -> list[str]:
        """Seize, dial `number` in-band, and run until the call is up."""
        pending: list[int] = []
        for digit in number:
            pending.extend(_dtmf(digit, DIAL_RATE // 10))
            pending.extend([0] * (DIAL_RATE // 20))
        states: list[str] = []
        received: list[int] = []
        cursor = 0
        for _ in range(1_500):
            self.pbx.poll()
            if self.pbx.invite and not self.pbx.answered and self.line.exchange.state == "ringback":
                self.pbx.answer()
            if self.pbx.answered and self.line.sip.state == "connected":
                self.pbx.send_tone(self.line.sip.rtp_port)
            transmitted = [0] * BLOCK
            if self.line.exchange.state in ("dial-tone", "collecting") and cursor < len(pending):
                transmitted = pending[cursor : cursor + BLOCK]
                transmitted += [0] * (BLOCK - len(transmitted))
                cursor += BLOCK
            out = self.line.service(True, transmitted, BLOCK)
            if self.line.sip.rtp_packets_received:
                received.extend(out)
            if not states or states[-1] != self.line.exchange.state:
                states.append(self.line.exchange.state)
            if len(received) > DIAL_RATE:
                break
        self.received = received
        return states

    def test_a_dialed_number_becomes_an_invite_and_the_audio_cuts_through(self) -> None:
        states = self._dial("6245")

        # The loop walked the states a subscriber would hear, and nothing read
        # the number out of anything but the tones on the line.
        self.assertEqual(states, ["dial-tone", "collecting", "routing", "ringback", "connected"])
        self.assertEqual(self.line.exchange.dialed, "6245")
        self.assertTrue(self.pbx.requests[0].startswith("INVITE sip:6245@"))
        self.assertIn("ACK", " ".join(self.pbx.requests))

        # The far end's 1000 Hz reached the loop, at the loop's own rate.
        tail = self.received[-DIAL_RATE:]
        self.assertGreater(
            _bin_power(tail, 1_000, DIAL_RATE), 100 * _bin_power(tail, 500, DIAL_RATE)
        )
        # And the loop's audio reached the far end as RTP.
        self.assertGreater(self.pbx.rtp_bytes_received, 0)

    def test_going_on_hook_takes_the_call_down(self) -> None:
        self._dial("6245")
        for _ in range(5):
            self.line.service(False, [0] * BLOCK, BLOCK)
            self.pbx.poll()
        self.assertEqual(self.line.exchange.state, "idle")
        self.assertEqual(self.line.sip.state, "idle")
        self.assertTrue(any(request.startswith("BYE") for request in self.pbx.requests))

    def test_a_rejected_number_gives_the_loop_busy_tone(self) -> None:
        pending = _dtmf("9", DIAL_RATE // 10) + [0] * (DIAL_RATE // 20)
        cursor = 0
        for _ in range(1_500):
            self.pbx.poll()
            if self.pbx.invite and not self.pbx.answered:
                self.pbx.socket.sendto(_response(self.pbx.invite, "486 Busy Here"), self.pbx.peer)
                self.pbx.answered = True
            transmitted = [0] * BLOCK
            if self.line.exchange.state in ("dial-tone", "collecting") and cursor < len(pending):
                transmitted = pending[cursor : cursor + BLOCK]
                transmitted += [0] * (BLOCK - len(transmitted))
                cursor += BLOCK
            self.line.service(True, transmitted, BLOCK)
            if self.line.exchange.state == "busy":
                break
        self.assertEqual(self.line.exchange.state, "busy")


if __name__ == "__main__":
    unittest.main()


class _TonedCore(_Core):
    """The mock core, plus the one thing it lacked: audio on the line.

    The tone generator is the ASIC's, and its firmware is not in the image -
    `bridge._play_dial_tone` says so and records the supervisor's request
    without playing it. This plays exactly that request, so the loop in front
    of the SIP instrument has something to decode.
    """

    def __init__(self) -> None:
        super().__init__()
        self.bridge: CourierDspBridge | None = None
        self.produced: list[int] = []
        self._clock = 0

    def _advance(self) -> None:
        """Produce line audio at the line's rate, on the 80186's clock.

        The bridge polls this every batch, which is far more often than a
        frame; producing a fixed block per poll would run the line sixteen
        times fast and make every tone on it unreadable.
        """
        self._clock += self.bridge.batch if self.bridge else 256
        want = self._clock * LINE_FRAME_SAMPLES // LINE_FRAME_INSTRUCTIONS
        count = want - len(self.produced)
        if count <= 0:
            return
        digit = getattr(self.bridge, "_dial_tone_digit", None)
        start = len(self.produced)
        if digit is None:
            self.produced.extend([0] * count)
        else:
            self.produced.extend(_dtmf(digit, count, LINE_RATE, start))

    def serial_state(self) -> dict[str, int]:
        self._advance()
        return {"line_tx_writes": len(self.produced)}

    def line_tx_samples(self, start: int = 0) -> list[int]:
        return self.produced[start:]


class BridgeDialTests(unittest.TestCase):
    """`ATDT6245` from the supervisor's own dialer, out to a SIP peer.

    Nothing here hands anyone the number. The supervisor's encoder sends one
    keypad index per digit, the board plays it, the loop decodes it off the
    line, and the ATA turns what it decoded into an INVITE.
    """

    def setUp(self) -> None:
        self.pbx = MockPbx()
        self.addCleanup(self.pbx.close)
        self.daa = CourierDaa("quiet")
        self.exchange = LineExchange(interdigit_ms=2_000)
        self.sip = SipSession(SipConfig(server=self.pbx.address, username="courier"))
        self.addCleanup(self.sip.close)
        image, core = _Image(), _TonedCore()
        with patch("courier_emu.bridge.NativeC5x", return_value=core):
            self.bridge = CourierDspBridge(  # type: ignore[arg-type]
                image, daa=self.daa, exchange=self.exchange, sip=self.sip
            )
            test_bridge.BridgeTests._bootstrap(self.bridge, image.program)
        core.bridge = self.bridge

    def _frames(self, count: int) -> None:
        # The PBX is polled per batch rather than per instruction: a syscall
        # every 80186 cycle is four hundred thousand of them per frame.
        clock = self.bridge.clock_x86
        for _ in range(count * LINE_FRAME_INSTRUCTIONS // 256):
            for _ in range(256):
                clock()
            self.pbx.poll()

    def _send(self, header: int, data: int) -> None:
        self.bridge.write(0x58, 1, header & 0xFF)
        self.bridge.write(0x5A, 1, (header >> 8) & 0xFF)
        self.bridge.write(0x5C, 1, data & 0xFF)
        self.bridge.write(0x5E, 1, (data >> 8) & 0xFF)

    def _dial(self, index: int) -> None:
        """One digit as the dialer sends it: 0x16, the index, hold, 0x16."""
        self._send(0x0016, 0x0000)
        self._send(0x0013, index)
        self._frames(1)
        self._send(0x0016, 0x0000)
        self._frames(1)

    def test_atdt6245_places_a_sip_call_from_the_tones_on_the_line(self) -> None:
        self.bridge.set_line_hook(True)
        self._frames(2)
        self.assertEqual(self.exchange.state, "dial-tone")

        for index in (6, 2, 4, 5):
            self._dial(index)

        # What the supervisor asked for, and what the line actually heard.
        self.assertEqual(self.bridge._dial_digits_commanded, "6245")
        self.assertEqual(self.exchange.dialed, "6245")

        # The interdigit timer routes the call, and the router is the ATA.
        self._frames(30)
        self.assertTrue(self.pbx.requests, "no SIP request reached the peer")
        self.assertTrue(self.pbx.requests[0].startswith("INVITE sip:6245@"))
        self.assertEqual(self.exchange.state, "ringback")

        # The peer answers; the loop goes through and the board is told.
        self.pbx.answer()
        self._frames(5)
        self.assertEqual(self.sip.state, "connected")
        self.assertEqual(self.exchange.state, "connected")
        self.assertTrue(self.bridge.connected_event_queued)

    def test_the_far_end_hanging_up_releases_the_loop(self) -> None:
        self.bridge.set_line_hook(True)
        self._frames(2)
        for index in (6, 2, 4, 5):
            self._dial(index)
        self._frames(30)
        self.pbx.answer()
        self._frames(5)
        self.assertEqual(self.exchange.state, "connected")

        self.pbx.bye(self.sip)
        self._frames(3)
        self.assertEqual(self.exchange.state, "released")
        self.assertEqual(self.daa.line_state, "disconnected")
