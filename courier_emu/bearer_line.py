"""The I-modem's B channel on a `link` line socket.

`link` runs two analogue Couriers on one socket line (`line.LineLink`): hook
state, ring and call state in a header, and 100 ms of 8 kHz linear audio per
frame, each side blocking for the other's frame so the two runs share one
clock.  This puts the I-modem on the far end of that line instead.  An
analogue Courier dials; the switch this stands in for offers the call to the
I-modem as a 3.1 kHz mu-law SETUP on B1; the I-modem answers, and its own
datapump talks to the analogue one through G.711.

That is the network a real I-modem-to-Courier call crosses: the analogue end
on a loop into a codec at the exchange, the ISDN end digital all the way.  The
only conversion is the exchange's mu-law codec, one sample for one octet at
the same 8 kHz - no resampling.

The frame clock is the I-modem's own PCM highway, 8000 octets a second of its
C51's cycles.  Before the DSP is clocking it - boot, or a reload - 386 time
stands in so the far end is never left waiting for a frame.
"""
from __future__ import annotations

from typing import Any

from .line import (
    AC01_FULL_SCALE_DBM,
    DAA_RX_LOSS_DB,
    DAA_TX_LOSS_DB,
    CALL_ANSWERED,
    CALL_CLEARED,
    CALL_IDLE,
    CALL_RINGING,
    CALL_STATE_NAMES,
    LINE_FRAME_SAMPLES,
    LineFrame,
    LineLink,
)
from .daa import RING_OFF_MS, RING_ON_MS
from .pit import INSTRUCTIONS_PER_SECOND
from .sip import linear_to_ulaw, ulaw_to_linear

LINE_SAMPLE_RATE = 8_000
CPU_INSTRUCTIONS_PER_SAMPLE = INSTRUCTIONS_PER_SECOND // LINE_SAMPLE_RATE
# How long the highway may stand still before 386 time takes over as the
# clock: one frame, so a far end blocked on this one waits no longer than that.
HIGHWAY_STALL_SAMPLES = LINE_FRAME_SAMPLES
PCMU_SILENCE = 0xFF

# Where each end's full scale sits, so a sample crosses at its real level:
# the Courier's figures in line.py, the same ones MicaEmu's courier_line_peer
# uses, so the 403 hears an I-modem at the levels it hears MICA. G.711 mu-law
# full scale is +3.17 dBm0; decoded to 32124 as sip.py does, the same PCM16
# sine is +3.21 dBm0. The mu-law side is taken to be at the Courier's line
# terminals: no loop loss beyond the DAA's.
ULAW_FULL_SCALE_DBM0 = 3.21
# Courier codec -> mu-law, and mu-law -> Courier codec.
TO_ULAW_DB = AC01_FULL_SCALE_DBM - ULAW_FULL_SCALE_DBM0 - DAA_TX_LOSS_DB
FROM_ULAW_DB = ULAW_FULL_SCALE_DBM0 - AC01_FULL_SCALE_DBM - DAA_RX_LOSS_DB
LINE_FRAME_MS = LINE_FRAME_SAMPLES * 1_000 // LINE_SAMPLE_RATE


class BearerLineLink:
    """A far end for `BriNetwork`'s B channel, made of a socket line.

    It takes the bearer whole through `clock`, idle or not, because the line
    it sits on has to keep exchanging frames whether a call is up or not.
    """

    realtime_clock = False
    # When the I-modem dials, the analogue end has to be rung and answer
    # before the switch connects the call.
    awaits_answer = True

    def __init__(self, line: LineLink) -> None:
        # The line carries the Courier's codec samples untouched, so the
        # Courier must run its end digital too (COURIER_LINE_DIGITAL=1): this
        # end sets both directions' levels.
        if not line.digital:
            raise ValueError("BearerLineLink sets the levels itself; the "
                             "line must be digital")
        self.line = line
        self.from_line = 10 ** (TO_ULAW_DB / 20)       # Courier -> mu-law
        self.into_courier = 10 ** (FROM_ULAW_DB / 20)  # mu-law -> Courier
        self.answered = False
        self.cleared = False
        self._offered = False
        self.dialled = ""
        self._ring_from: int | None = None
        self._call_state = CALL_IDLE
        self._octets_seen = 0
        self._instructions_seen: int | None = None
        self._stalled_samples = 0
        self._pending = bytearray()
        self._primed = False
        self.octets_to_line = 0
        self.octets_from_line = 0
        self.silence_frames = 0
        self.events: list[str] = []

    # -- the call, as BriNetwork drives it ---------------------------------

    def poll(self) -> None:
        if not self.line.connected and not self.line.closed:
            self.line.open()

    def incoming_call(self) -> tuple[str, str] | None:
        """The analogue end dialled and the switch is ringing this one."""
        if self._offered or self.answered or self.dialled:
            return None
        if self.line.peer_ringing or self.line.peer_call_state == CALL_RINGING:
            self._offered = True
            self.events.append(
                f"the line is ringing us at frame {self.line.frames}: "
                "offering the I-modem a 3.1 kHz call")
            # The analogue end's digits stay on its own side of the socket;
            # --bri-call-to names the directory number the SETUP carries.
            return "", ""
        return None

    def dial(self, number: str) -> None:
        """The I-modem placed a call: ring the analogue end."""
        self.dialled = number
        self._ring_from = self.line.frames
        self.events.append(
            f"the I-modem dialled {number} at frame {self.line.frames}: "
            "ringing the line")

    def far_end_answered(self) -> bool:
        return bool(self.dialled) and self._call_state == CALL_ANSWERED

    def start(self) -> None:
        if not self.answered:
            self.answered = True
            self.events.append(
                f"the I-modem answered at frame {self.line.frames}: off hook")

    def stop(self) -> None:
        if self.answered and not self.cleared:
            self.cleared = True
            self.events.append(
                f"the ISDN call cleared at frame {self.line.frames}: on hook")

    def remote_ended(self) -> bool:
        return self.answered and (
            self.line.peer_call_state == CALL_CLEARED
            or not self.line.connected)

    def exchange(self, octets: bytes) -> bytes:
        # `clock` carries the bearer; BriNetwork only calls this for peers
        # without one.
        raise NotImplementedError("BearerLineLink is clocked, not exchanged")

    # -- the bearer ----------------------------------------------------------

    def clock(self, dsc: Any, channel: int | None, instructions: int) -> None:
        """Carry whatever the highway clocked since the last pass onto the line."""
        self.poll()
        if not self.line.connected:
            return
        if self._instructions_seen is None:
            self._instructions_seen = instructions
        elapsed = instructions - self._instructions_seen
        produced = len(dsc.bearer_tx[1])
        fresh = produced - self._octets_seen
        if fresh > 0:
            source = dsc.bearer_tx[channel] if channel in (1, 2) else None
            if source is not None and self.answered and not self.cleared:
                self._pending.extend(source[self._octets_seen:produced])
            else:
                self._pending.extend(bytes((PCMU_SILENCE,)) * fresh)
            self._octets_seen = produced
            self._instructions_seen = instructions
            self._stalled_samples = 0
        else:
            # The highway is not running. 386 time keeps the line's clock
            # until it is, so the far end is not left blocked on this one.
            self._stalled_samples += elapsed // CPU_INSTRUCTIONS_PER_SAMPLE
            self._instructions_seen += (
                elapsed - elapsed % CPU_INSTRUCTIONS_PER_SAMPLE)
            if self._stalled_samples >= HIGHWAY_STALL_SAMPLES:
                self._pending.extend(
                    bytes((PCMU_SILENCE,)) * self._stalled_samples)
                self._stalled_samples = 0
        while len(self._pending) >= LINE_FRAME_SAMPLES and self.line.connected:
            octets = bytes(self._pending[:LINE_FRAME_SAMPLES])
            del self._pending[:LINE_FRAME_SAMPLES]
            self._exchange(dsc, channel, octets)

    def _exchange(self, dsc: Any, channel: int | None, octets: bytes) -> None:
        calling = bool(self.dialled)
        off_hook = (self.answered or calling) and not self.cleared
        state = max(self._call_state, self.line.peer_call_state)
        ringing = False
        if calling and state < CALL_ANSWERED:
            # This end is the switch the I-modem dialled into: it rings the
            # analogue subscriber, and that end going off hook is the answer.
            state = max(state, CALL_RINGING)
            if self.line.peer_off_hook:
                state = CALL_ANSWERED
                self.events.append(
                    f"the line answered at frame {self.line.frames}")
            else:
                elapsed_ms = (self.line.frames - self._ring_from) * LINE_FRAME_MS
                ringing = elapsed_ms % (RING_ON_MS + RING_OFF_MS) < RING_ON_MS
        elif off_hook and state == CALL_RINGING:
            # The called end going off hook against a ringing line is the
            # answer, as on the analogue side of `link`.
            state = CALL_ANSWERED
        if self.cleared or (state == CALL_ANSWERED
                            and not (off_hook and self.line.peer_off_hook)):
            state = CALL_CLEARED
        self._call_state = state
        through = state == CALL_ANSWERED
        self.line.exchange(LineFrame(
            instructions=self.line.frames * LINE_FRAME_SAMPLES
            * CPU_INSTRUCTIONS_PER_SAMPLE,
            off_hook=off_hook,
            ringing=ringing,
            samples=([self._clip(ulaw_to_linear(value) * self.into_courier)
                      for value in octets] if through
                     else [0] * len(octets)),
            call_state=state,
        ))
        if through:
            self.octets_to_line += len(octets)
        else:
            self.silence_frames += 1
        incoming = self.line.receive_audio()
        if through and channel in (1, 2) and not self._primed:
            # A frame is handed over at the instant the I-modem has consumed
            # the last one, and every octet it clocks in that same pass finds
            # the queue empty: about 18 idle codewords were spliced into each
            # 100 ms of the far end, which V.21 shrugs off and INFO0's DPSK
            # does not. One frame of transit delay, as any network has, keeps
            # the queue from running dry.
            dsc.queue_bearer(channel, bytes((PCMU_SILENCE,)) * LINE_FRAME_SAMPLES)
            self._primed = True
        if through and channel in (1, 2) and incoming:
            dsc.queue_bearer(channel, bytes(
                linear_to_ulaw(self._clip(sample * self.from_line))
                for sample in incoming))
            self.octets_from_line += len(incoming)

    @staticmethod
    def _clip(sample: float) -> int:
        return max(-32_768, min(32_767, int(sample)))

    def close(self) -> None:
        self.line.close()

    def status(self) -> dict[str, Any]:
        return {
            "line": self.line.status(),
            "call_state": CALL_STATE_NAMES.get(self._call_state,
                                               self._call_state),
            "answered": self.answered,
            "dialled": self.dialled,
            "cleared": self.cleared,
            "octets": {"to_line": self.octets_to_line,
                       "from_line": self.octets_from_line,
                       "pending": len(self._pending)},
            "silence_frames": self.silence_frames,
            "events": list(self.events),
        }
