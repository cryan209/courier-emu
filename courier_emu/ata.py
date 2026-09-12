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
import time
from typing import Any

from .daa import DAA_SAMPLE_RATE
from .exchange import LineExchange
from .sip import PCMU_RATE, PolyphaseResampler, SipConfig, SipSession


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
        self._to_network = PolyphaseResampler(self.line_rate, PCMU_RATE)
        self._from_network = PolyphaseResampler(PCMU_RATE, self.line_rate)
        self._pending: list[int] = []
        self._sip_state = self.sip.state
        self.placed = 0
        self.answered = 0
        self._next_frame_at: float | None = None
        self.paced_seconds = 0.0
        self.late_seconds = 0.0

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
        self.late_seconds += max(0.0, now - deadline)
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
        if transmitted:
            self.sip.send_audio(self._to_network.convert(transmitted))
        self._pending.extend(self._from_network.convert(self.sip.receive_audio()))
        if len(self._pending) < count:
            # Nothing has arrived yet, or the far end is between packets. An
            # underrun is silence on the loop, which is what an ATA carries.
            samples = self._pending + [0] * (count - len(self._pending))
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
            "sip": self.sip.status(),
        }

    def close(self) -> None:
        self.sip.close()


def connect(config: SipConfig, line_rate: int = DAA_SAMPLE_RATE, **kwargs: Any) -> SipLine:
    """Open a SIP session and put a loop in front of it."""
    return SipLine(sip=SipSession(config), line_rate=line_rate, **kwargs)
