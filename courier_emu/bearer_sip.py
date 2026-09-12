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

What this module is *not* is a pacing solution.  The emulator runs on an
instruction budget and RTP runs on a clock, so the two disagree about how fast
a second is.  The bridge does not pretend otherwise: it hands back exactly as
many octets as it was given, fills what has not arrived with mu-law silence,
and counts every octet of that fill so a run says plainly how far out of step
it was.
"""
from __future__ import annotations

from typing import Any

# mu-law silence, and what an unconnected slot carries: the same octet the
# Am79C30's idle codeword is.
PCMU_SILENCE = 0xFF


class BearerSipLine:
    """A far end for `BriNetwork`'s B channel, made of a `SipSession`.

    It satisfies the same small contract `V120Link` does - `start`, `stop`, and
    `exchange(octets) -> octets` - so `BriNetwork` does not know which of them
    it is carrying.
    """

    def __init__(self, session: Any, *, target: str = "",
                 record: Any = None, silence: int = PCMU_SILENCE) -> None:
        self.session = session
        self.session.set_codewords(True)
        self.target = target
        self.dialled = ""
        self.record = record
        self.silence = silence
        self.started = False
        self.octets_in = 0
        self.octets_out = 0
        self.underrun = 0
        self.events: list[str] = []

    # -- what the call does to it ------------------------------------------

    def dial(self, number: str) -> None:
        """The digits the modem dialled, which are the ones to INVITE.

        A fixed --bri-sip-target still wins: a run that wants the call to go
        somewhere other than where the modem pointed it should get that.
        """
        self.dialled = number
        if not self.target:
            self.target = number

    def start(self) -> None:
        """The B channel is up: place the SIP call that is its far end."""
        if self.started:
            return
        self.started = True
        if self.target:
            self.session.start_call(self.target)
            self.events.append(f"INVITE to {self.target}")
        else:
            # No target means the session was handed over already in a call,
            # which is how an answered inbound leg arrives.
            self.events.append("using the session's existing call")

    def stop(self) -> None:
        if not self.started:
            return
        self.started = False
        self.session.hangup()
        self.events.append("the ISDN call cleared: hanging up the SIP leg")

    # -- the bearer --------------------------------------------------------

    def exchange(self, octets: bytes) -> bytes:
        """Modem-to-network octets out to RTP, network-to-modem back."""
        self.octets_in += len(octets)
        self.session.send_pcmu(octets)
        self.session.poll()
        received = self.session.receive_pcmu(len(octets))
        if self.record is not None and received:
            self.record.write(received)
        if len(received) < len(octets):
            # The far end has not sent this much yet. Silence is the honest
            # filler: it is what an idle timeslot carries, and it is counted.
            self.underrun += len(octets) - len(received)
            received += bytes((self.silence,)) * (len(octets) - len(received))
        self.octets_out += len(received)
        return received

    # -- reporting ---------------------------------------------------------

    def status(self) -> dict[str, Any]:
        return {
            "sip": self.session.status(),
            "dialled": self.dialled,
            "target": self.target,
            "octets": {"to_rtp": self.octets_in, "from_rtp": self.octets_out,
                       "silence_filled": self.underrun},
            "events": list(self.events),
        }
