"""The ISDN B channel as a SIP call, codeword for codeword.

[imodem-audio-bearer.md](../docs/imodem-audio-bearer.md) ends with the I-modem
answering an audio call as a modem and putting ANSam on the bearer, and with
nothing at the other end of it.  This puts a SIP call there.

The join is unusually clean, and the reason is worth stating because it is the
whole argument for doing it this way.  A B channel carries 8000 octets a second
of G.711.  RTP's PCMU payload *is* 8000 octets a second of G.711.  They are the
same octets, so nothing between them needs to convert anything:

* no resampling - both sides are 8 kHz, unlike the analogue board's codec path
  that `ata.py` has to run a polyphase filter for;
* no companding conversion - mu-law in, mu-law out, and a datapump that bets a
  connection on the low bit of a codeword gets the codeword it was sent.

That matters more here than it would for speech.  V.90 and x2 are built on
exact codewords - the whole idea is that one end of the call is digital and
can place them on the wire itself - and this board is that end.

Live pacing is supplied by the I-modem DSP endpoint: while this bearer is
active it advances the recovered 20.16 MHz digital-PCM clock from monotonic
wall time instead of from emulated 386 throughput.  The bridge still hands
back exactly as many octets as it was given, fills a genuine RTP underrun with
mu-law silence, and counts every octet of that fill.
"""
from __future__ import annotations

from collections import deque
from typing import Any

from .sip import ulaw_to_linear

# mu-law silence, and what an unconnected slot carries: the same octet the
# Am79C30's idle codeword is.
PCMU_SILENCE = 0xFF


class BearerSipLine:
    """A far end for `BriNetwork`'s B channel, made of a `SipSession`.

    It satisfies the same small contract `V120Link` does - `start`, `stop`, and
    `exchange(octets) -> octets` - so `BriNetwork` does not know which of them
    it is carrying.
    """

    # Tells the coupled I-modem harness that this peer carries an externally
    # clocked, live bearer. Offline byte sources retain instruction pacing.
    realtime_clock = True
    # Receive data is handed over ahead of the modem's own octets, so the
    # native port model can run whole frames without coming back for each.
    feeds_ahead = True
    # How far ahead, in octets: 10 ms, out of the 40 ms the playout reserve
    # holds. Never more than is actually buffered, and never filler.
    RECEIVE_LEAD = 80

    def __init__(self, session: Any, *, target: str = "",
                 record: Any = None, silence: int = PCMU_SILENCE,
                 receive_buffer_samples: int = 320,
                 transmit_buffer_samples: int = 480,
                 receive_lead: int = RECEIVE_LEAD) -> None:
        self.session = session
        self.session.set_codewords(True)
        if hasattr(self.session, 'enable_media_clock'):
            self.session.enable_media_clock(buffer_samples=transmit_buffer_samples)
        self.target = target
        self.dialled = ""
        self.record = record
        self.silence = silence
        self.started = False
        self.invited = False
        self.alerted = False
        self._answer_pending = False
        self._answer_audio = bytearray()
        self.preanswer_octets = 0
        self.octets_in = 0
        self.octets_out = 0
        self.octets_from_rtp = 0
        self.underrun = 0
        self.events: list[str] = []
        # Two 20 ms packets establish a small playout reserve. Consuming the
        # first packet immediately lets ordinary arrival jitter insert silence
        # into a modem waveform, even when no RTP packet has been lost.
        self.receive_buffer_samples = max(0, receive_buffer_samples)
        self._receive_octets: deque[int] = deque()
        self._receive_started = False
        # Receive octets handed over beyond the transmit ones: the lead.
        self.receive_lead = max(0, receive_lead)
        self._lead = 0

    # -- what the call does to it ------------------------------------------

    def dial(self, number: str) -> None:
        """The digits the modem dialled, which are the ones to INVITE.

        A fixed --bri-sip-target still wins: a run that wants the call to go
        somewhere other than where the modem pointed it should get that.
        """
        self.dialled = number
        if not self.target:
            self.target = number
        # Ring the far end now. The switch holds the modem's CONNECT until it
        # answers (awaits_answer), as a real one does; connecting at once had
        # the modem's first frames - X.75's SABM - go out before Asterisk's
        # 200 OK, into a call that was not there yet.
        self._invite()

    @property
    def awaits_answer(self) -> bool:
        """A call the modem placed waits for the SIP answer before CONNECT."""
        return self.invited

    def far_end_answered(self) -> bool:
        return self.invited and self.session.state == "connected"

    def _invite(self) -> None:
        if self.invited or not self.target:
            return
        self.invited = True
        self.session.start_call(self.target)
        self.events.append(f"INVITE to {self.target}")

    def start(self) -> None:
        """The B channel is up: place the SIP call that is its far end, unless
        the modem's dial already did."""
        if self.started:
            return
        self.started = True
        if self.target:
            self._invite()
        else:
            # Q.931 CONNECT can precede the DSP answer waveform by seconds.
            # Keep SIP ringing until the bearer actually has audio to send.
            self._answer_pending = True
            self.events.append("the I-modem connected: waiting for DSP answer audio")

    def poll(self) -> None:
        """Service SIP signalling even while no B channel is active."""
        self.session.poll()

    def incoming_call(self) -> tuple[str, str] | None:
        if self.target or self.session.direction != "inbound":
            return None
        if self.session.state not in ("incoming", "ringing"):
            return None
        return self.session.incoming_from, self.session.incoming_to

    def remote_ended(self) -> bool:
        """Whether SIP CANCEL/BYE - or a refused INVITE - requires clearing
        the BRI call."""
        return (self.session.state == "closed"
                or (self.invited and self.session.state == "failed"))

    def ring(self) -> None:
        """Mirror Q.931 ALERTING to the SIP caller."""
        if self.alerted:
            return
        self.alerted = True
        self.session.ring_incoming()
        self.events.append("the I-modem is alerting: sending 180 Ringing")

    def stop(self) -> None:
        if not self.started or self._answer_pending:
            self.session.reject_incoming()
        self.started = False
        self.invited = False
        self.alerted = False
        self._answer_pending = False
        self._answer_audio.clear()
        self.session.hangup()
        self._receive_octets.clear()
        self._receive_started = False
        self._lead = 0
        self.events.append("the ISDN call cleared: hanging up the SIP leg")

    # -- the bearer --------------------------------------------------------

    def exchange(self, octets: bytes) -> bytes:
        """Modem-to-network octets out to RTP, network-to-modem back."""
        self.octets_in += len(octets)
        if self._answer_pending:
            self.preanswer_octets += len(octets)
            self._answer_audio.extend(
                octets if self._answer_audio else octets.lstrip(b"\xff\x7f"))
            # Require 20 ms of samples and 4 ms of appreciable signal so a
            # lone transient cannot accept the call. Retain the beginning of
            # the waveform and send it once SIP has accepted the INVITE.
            if (len(self._answer_audio) >= 160
                    and sum(abs(ulaw_to_linear(value)) >= 128
                            for value in self._answer_audio) >= 32):
                self.session.answer_incoming()
                self._answer_pending = False
                self.events.append("DSP answer audio ready: accepting the inbound INVITE")
                self.session.send_pcmu(bytes(self._answer_audio))
                self._answer_audio.clear()
            elif len(self._answer_audio) > 320:
                del self._answer_audio[:-320]
        else:
            self.session.send_pcmu(octets)
        self.session.poll()
        incoming = self.session.receive_pcmu()
        if not self._answer_pending:
            self._receive_octets.extend(incoming)
        if len(self._receive_octets) >= self.receive_buffer_samples:
            self._receive_started = True
        received = (bytes(self._receive_octets.popleft()
                          for _ in range(min(len(octets), len(self._receive_octets))))
                    if self._receive_started else b"")
        self.octets_from_rtp += len(received)
        if self.record is not None and received:
            self.record.write(received)
        if len(received) < len(octets):
            # After a real outage, rebuild the reserve before resuming. Without
            # this, every subsequent jitter peak causes another waveform gap.
            self._receive_started = False
            # The far end has not sent this much yet. Silence is the honest
            # filler: it is what an idle timeslot carries, and it is counted.
            self.underrun += len(octets) - len(received)
            received += bytes((self.silence,)) * (len(octets) - len(received))
        if self._receive_started and self._lead < self.receive_lead:
            extra = min(self.receive_lead - self._lead, len(self._receive_octets))
            if extra:
                ahead = bytes(self._receive_octets.popleft() for _ in range(extra))
                self._lead += extra
                self.octets_from_rtp += extra
                if self.record is not None:
                    self.record.write(ahead)
                received += ahead
        self.octets_out += len(received)
        return received

    # -- reporting ---------------------------------------------------------

    def status(self) -> dict[str, Any]:
        return {
            "sip": self.session.status(),
            "dialled": self.dialled,
            "target": self.target,
            "octets": {"to_rtp": self.octets_in, "from_rtp": self.octets_out,
                       "received_from_rtp": self.octets_from_rtp,
                       "silence_filled": self.underrun,
                       "receive_buffered": len(self._receive_octets),
                       "preanswer_octets": self.preanswer_octets,
                       "answer_pending": self._answer_pending,
                       "receive_buffer_samples": self.receive_buffer_samples},
            "events": list(self.events),
        }

    def close(self) -> None:
        self.session.close()
        if self.record is not None:
            self.record.close()
            self.record = None
