"""An analogue terminal adapter: a subscriber loop in front of a SIP instrument.

`LineExchange` already models the loop - hook, dial tone, in-band DTMF
collection, ringback, busy, and the audio path once a call is up. What it does
not have is a far end: its `directory` decides the outcome of a number before
the call is placed, and its ringback is a timer.

This module gives it one. `SipLine` puts the exchange between the modem and a
`SipSession` and does the three things an ATA does that neither half does
alone:

* **Routing.** The number the exchange decoded off the line becomes an INVITE.
  Until the network says something the exchange holds in `routing`, and the
  SIP response then supplies the outcome - 180 is ringback, 200 is answer, 486
  is busy, anything else is reorder.
* **Rate adaptation.** The loop runs at whatever rate the board's codec path
  does; RTP carries G.711 at 8 kHz. Both directions go through the band-
  limited `PolyphaseResampler` rather than a hold, because the dial path's 7200 Hz
  images a 1633 Hz DTMF column tone straight back into the band a far-end
  receiver listens in.
* **Supervision.** The subscriber going on-hook cancels or clears the call;
  the far end's BYE releases the loop.

The modem never learns any of this. It seizes a loop, hears dial tone, dials,
and hears ringback or busy, exactly as it does against the bare exchange.
"""
from __future__ import annotations

from dataclasses import dataclass, field
import array
import os
import time
import wave
from typing import Any

from .daa import DAA_SAMPLE_RATE
from .exchange import LineExchange
from .sip import (PCMU_RATE, RTP_PACKET_SAMPLES, PolyphaseResampler,
                  SipConfig, SipSession)


# The SIP states that mean the call is still being set up, so the exchange
# should keep holding rather than route on what it has heard so far.
PENDING_STATES = ("inviting", "trying")

# Status codes that a switch would report as busy rather than as a failure.
BUSY_STATUSES = (486, 600)


@dataclass
class SipLine:
    """One FXS port: `exchange` faces the modem, `sip` faces the network."""

    sip: SipSession
    line_rate: int = DAA_SAMPLE_RATE
    exchange: LineExchange = field(default=None)  # type: ignore[assignment]
    # Rings the ATA offers an inbound call for before it gives up, and how
    # long it lets an outbound call ring unanswered. Both are the exchange's
    # own counters; they are here so a caller sets them in one place.
    inbound_rings: int = 12
    outbound_rings: int = 30

    def __post_init__(self) -> None:
        if self.exchange is None:
            self.exchange = LineExchange(sample_rate=self.line_rate)
        self.exchange.sample_rate = self.line_rate
        self.exchange.decoder.sample_rate = self.line_rate
        # The far end supplies its own answer tone over RTP; the exchange
        # generating one as well would put two 2100 Hz tones on the loop.
        self.exchange.answer_tone_ms = 0
        # Ringback ends when the network says it does, never on a ring count.
        self.exchange.answer_after_rings = 1 << 30
        self.exchange.no_answer_rings = self.outbound_rings
        self.exchange.incoming_rings = self.inbound_rings
        self.exchange.router = self._route
        self.exchange.peer_audio = self._peer_audio
        # Outbound RTP on its own 20 ms clock. Otherwise packets leave only
        # while `_pace` waits for the next frame: none while the emulator
        # works through one (about half of every 100 ms), then the backlog at
        # once - measured on 7900, 2172 of 3604 gaps were zero and 1243 over
        # 40 ms, jitter a relaying PBX hands straight to the far modem. The
        # buffer covers the producer's lateness; COURIER_SIP_TX_BUFFER_MS=0
        # turns the clock off.
        buffer_ms = int(os.environ.get("COURIER_SIP_TX_BUFFER_MS", "150"))
        if buffer_ms > 0 and hasattr(self.sip, "enable_media_clock"):
            self.sip.enable_media_clock(buffer_samples=max(
                RTP_PACKET_SAMPLES, PCMU_RATE * buffer_ms // 1000))
        self._to_network = PolyphaseResampler(self.line_rate, PCMU_RATE)
        self._from_network = PolyphaseResampler(PCMU_RATE, self.line_rate)
        self._pending: list[int] = []
        self._sip_state = self.sip.state
        self.placed = 0
        self.answered = 0
        self._next_frame_at: float | None = None
        self.paced_seconds = 0.0
        # Each frame's lateness, summed: the area under the lag curve, not the
        # lag. `peak_late_seconds` is the worst a frame started behind its
        # wall-clock slot, and `late_frames` how many started more than one
        # 20 ms RTP packet behind it - sleep overshoot makes nearly every
        # frame a fraction of a millisecond late.
        self.late_seconds = 0.0
        self.peak_late_seconds = 0.0
        self.frames = 0
        self.late_frames = 0
        self.late_spikes: list[tuple[int, float, str]] = []
        # Connected frames the far end's audio did not fill, the silence
        # padded in for them, and the deepest backlog of received samples.
        self.underrun_frames = 0
        self.underrun_samples = 0
        self.pending_peak = 0
        self.underrun_log: list[tuple[int, int]] = []
        # COURIER_SIP_RECORD=PREFIX writes the connected loop audio at the
        # line rate: PREFIX-tx.wav what the modem sent, PREFIX-rx.wav what
        # it was given back.
        self._recordings = None
        prefix = os.environ.get("COURIER_SIP_RECORD")
        if prefix:
            self._recordings = []
            for side in ("tx", "rx"):
                recording = wave.open(f"{prefix}-{side}.wav", "wb")
                recording.setnchannels(1)
                recording.setsampwidth(2)
                recording.setframerate(self.line_rate)
                self._recordings.append(recording)

    # -- the two faces ---------------------------------------------------

    def service(self, off_hook: bool, transmitted: list[int] | None = None,
                count: int | None = None) -> list[int]:
        """Advance the port by one block; the arguments are the exchange's."""
        if count is None:
            count = self.line_rate // 10
        self._pace(count)
        self.sip.poll()
        self._follow_sip()
        samples = self.exchange.service(off_hook, transmitted, count)
        self._follow_loop()
        return samples

    def _pace(self, count: int) -> None:
        """Keep the simulated subscriber loop on the RTP wall clock."""
        if not getattr(self.sip, "realtime", True):
            # A far end clocked by the emulators themselves (LinePeerSession):
            # there is no wall clock to keep.
            return
        now = time.monotonic()
        if self._next_frame_at is None:
            self._next_frame_at = now
        deadline = self._next_frame_at
        while now < deadline:
            # Poll while waiting so queued audio leaves in 20 ms RTP packets
            # and signalling or inbound media never waits for a 100 ms frame.
            self.sip.poll()
            delay = min(0.01, deadline - now)
            time.sleep(delay)
            self.paced_seconds += delay
            now = time.monotonic()
        late = max(0.0, now - deadline)
        self.late_seconds += late
        self.peak_late_seconds = max(self.peak_late_seconds, late)
        self.frames += 1
        if late > RTP_PACKET_SAMPLES / PCMU_RATE:
            self.late_frames += 1
            if len(self.late_spikes) < 64:
                self.late_spikes.append(
                    (self.frames, round(late * 1000, 1), self.exchange.state))
        self._next_frame_at = deadline + count / self.line_rate

    def _route(self, number: str) -> str | None:
        """The exchange has a number. Place the call and hold for the answer."""
        if not number:
            return "reorder"
        self.sip.start_call(number)
        self.placed += 1
        if self.sip.state == "failed":
            return "reorder"
        return None

    def _peer_audio(self, count: int, transmitted: list[int]) -> list[int]:
        """The connected path: loop transmit to RTP, RTP to loop receive."""
        samples = self._peer_samples(count, transmitted)
        if self._recordings is not None:
            sent = list(transmitted or ())[:count]
            sent += [0] * (count - len(sent))
            for recording, block in zip(self._recordings, (sent, samples)):
                clipped = (max(-32768, min(32767, int(x))) for x in block)
                recording.writeframes(array.array("h", clipped).tobytes())
        return samples

    def _peer_samples(self, count: int, transmitted: list[int]) -> list[int]:
        if transmitted:
            self.sip.send_audio(self._to_network.convert(transmitted))
        self._pending.extend(self._from_network.convert(self.sip.receive_audio()))
        self.pending_peak = max(self.pending_peak, len(self._pending))
        if len(self._pending) < count:
            # Nothing has arrived yet, or the far end is between packets. An
            # underrun is silence on the loop, which is what an ATA carries.
            short = count - len(self._pending)
            self.underrun_frames += 1
            self.underrun_samples += short
            if len(self.underrun_log) < 64:
                self.underrun_log.append((self.frames, short))
            samples = self._pending + [0] * short
            self._pending = []
            return samples
        samples = self._pending[:count]
        del self._pending[:count]
        return samples

    # -- supervision -----------------------------------------------------

    def _follow_sip(self) -> None:
        """Turn what the network did into what the loop should hear."""
        state = self.sip.state
        if state == "ringing":
            self.exchange.set_outcome("no-answer")
        elif state == "connected":
            if self._sip_state != "connected":
                self.answered += 1
                self._pending = []
                self._from_network = PolyphaseResampler(PCMU_RATE, self.line_rate)
                self._to_network = PolyphaseResampler(self.line_rate, PCMU_RATE)
            self.exchange.answer()
        elif state == "failed":
            self.exchange.set_outcome(
                "busy" if self.sip.last_status in BUSY_STATUSES else "reorder"
            )
        elif state == "closed" and self._sip_state == "connected":
            # The far end hung up. The loop hears the call go down.
            self.exchange.release()
        self._sip_state = state

    def _follow_loop(self) -> None:
        """Turn what the subscriber did into what the network should see."""
        if self.exchange.state == "idle" and self.sip.state not in ("idle", "closed"):
            # On-hook with a call still up or still being set up.
            self.sip.hangup()
            self._sip_state = self.sip.state

    def ring(self, number: str | None = None) -> None:
        """Offer an inbound call to the loop."""
        self.exchange.ring(number)

    def status(self) -> dict[str, Any]:
        return {
            "line_rate": self.line_rate,
            "state": self.exchange.state,
            "dialed": self.exchange.dialed,
            "outcome": self.exchange.outcome,
            "placed": self.placed,
            "answered": self.answered,
            "paced_ms": round(self.paced_seconds * 1000),
            "late_ms": round(self.late_seconds * 1000),
            "peak_late_ms": round(self.peak_late_seconds * 1000, 1),
            "frames": self.frames,
            "late_frames": self.late_frames,
            "late_spikes": self.late_spikes,
            "underrun_frames": self.underrun_frames,
            "underrun_samples": self.underrun_samples,
            "underrun_log": self.underrun_log,
            "pending_peak": self.pending_peak,
            "sip": self.sip.status(),
        }

    def close(self) -> None:
        if self._recordings is not None:
            for recording in self._recordings:
                recording.close()
            self._recordings = None
        self.sip.close()


def connect(config: SipConfig, line_rate: int = DAA_SAMPLE_RATE, **kwargs: Any) -> SipLine:
    """Open a SIP session and put a loop in front of it."""
    return SipLine(sip=SipSession(config), line_rate=line_rate, **kwargs)


class LinePeerSession:
    """A far end for `SipLine` made of a line link to another Courier.

    It stands where a `SipSession` stands, so the modem behind the exchange
    runs exactly the path a SIP call takes - `SipLine`, the exchange, the
    bridge's unclocked conversions - while the far end is an ordinary
    line-link Courier (`run --line-link PATH --line-listen`) that is rung and
    answers. The link is lockstep, so each `poll` is one line frame each way
    and nothing is paced to wall time.
    """

    realtime = False

    def __init__(self, path: str, *, listen: bool = False) -> None:
        from .line import LineLink
        self.link = LineLink(path=path, listen=listen)
        self.link.open()
        self.state = "idle"
        self.last_status = 0
        self.number = ""
        self.error = ""
        self.events: list[str] = []
        self._tx: list[int] = []
        self._rx: list[int] = []

    def start_call(self, number: str) -> None:
        self.number = number
        self.state = "ringing"
        self.last_status = 180
        self.events.append(f"ring {number}")

    def poll(self) -> None:
        from .line import (CALL_ANSWERED, CALL_IDLE, CALL_RINGING, LINE_FRAME_INSTRUCTIONS,
                           LINE_FRAME_SAMPLES, LineFrame)
        connected = self.state == "connected"
        samples = self._tx[:LINE_FRAME_SAMPLES] if connected else []
        del self._tx[:len(samples)]
        samples += [0] * (LINE_FRAME_SAMPLES - len(samples))
        self.link.exchange(LineFrame(
            instructions=self.link.frames * LINE_FRAME_INSTRUCTIONS,
            off_hook=self.state in ("ringing", "connected"),
            ringing=self.state == "ringing",
            samples=samples,
            call_state=(CALL_ANSWERED if connected
                        else CALL_RINGING if self.state == "ringing" else CALL_IDLE)))
        received = self.link.receive_audio()
        if self.state == "ringing" and self.link.peer_off_hook:
            self.state, self.last_status = "connected", 200
            self.events.append("answered")
        elif connected and not self.link.peer_off_hook:
            self.state = "closed"
            self.events.append("far end hung up")
        if self.state == "connected":
            self._rx.extend(received)

    def send_audio(self, samples: list[int]) -> None:
        if self.state == "connected":
            self._tx.extend(samples)

    def receive_audio(self) -> list[int]:
        samples, self._rx = self._rx, []
        return samples

    def hangup(self) -> None:
        if self.state in ("ringing", "connected"):
            self.events.append("hung up")
        self.state = "closed"

    def status(self) -> dict[str, Any]:
        return {"far_end": "line-link", "state": self.state, "number": self.number,
                "events": self.events[-16:], "link": self.link.status()}

    def close(self) -> None:
        self.link.close()
