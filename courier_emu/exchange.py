from __future__ import annotations

from dataclasses import dataclass, field
import math
from typing import Any, Callable

from .daa import DAA_SAMPLE_RATE


# The exchange runs on the codec sample clock rather than on the 80186
# instruction count. Every interval below is therefore a real duration, and
# converting one costs no calibration constant: `_samples(ms)`.
EXCHANGE_SAMPLE_RATE = DAA_SAMPLE_RATE

# North American precise tone plan. Each entry is the pair of frequencies and
# the cadence in milliseconds; a zero on-time means the tone is continuous.
DIAL_TONE = (350, 440)
RINGBACK_TONE = (440, 480)
CONGESTION_TONE = (480, 620)
# V.25 answer tone. The answering modem, not the exchange, owns anything past
# this: the exchange stops at handing the connection to `peer_audio`.
ANSWER_TONE = 2_100

RINGBACK_ON_MS = 2_000
RINGBACK_OFF_MS = 4_000
BUSY_ON_MS = 500
BUSY_OFF_MS = 500
REORDER_ON_MS = 250
REORDER_OFF_MS = 250

# Each component of a two-frequency tone, matching the level the behavioral
# DAA renders dial tone at.
TONE_LEVEL = 4_000

DTMF_ROW_FREQUENCIES = (697, 770, 852, 941)
DTMF_COLUMN_FREQUENCIES = (1_209, 1_336, 1_477, 1_633)
DTMF_KEYS = "123A456B789C*0#D"

# 10 ms of the 9.6 kHz codec stream. Three agreeing blocks accept a digit,
# which is 30 ms - inside the 40 ms minimum duration a receiver must accept
# and well under the 70 ms the Courier's own S11 default emits.
DTMF_BLOCK_SAMPLES = 96
# The exchange's own timer granularity, in samples. A caller may hand over any
# block length; internally it is walked in steps this size so a long block
# still crosses the states inside it in order.
EXCHANGE_STEP_SAMPLES = DTMF_BLOCK_SAMPLES
DTMF_ACCEPT_BLOCKS = 3
# A pure two-tone block puts a quarter of its energy in each of the two bins.
# Accept half of that per bin so a band-limited or slightly detuned pair still
# decodes, and require the pair together to hold most of what is there.
DTMF_BIN_FLOOR = 0.10
DTMF_PAIR_FLOOR = 0.25
# High-to-low amplitude ratio. The spec allows 8 dB of forward twist and 4 dB
# reverse; this is deliberately looser, because what arrives here has been
# through the DSP transmit path rather than off a wire.
DTMF_MAX_TWIST = 8.0
# Below this RMS a block is silence, not a digit.
DTMF_SILENCE_LEVEL = 200

# Loop-break classification for pulse dialing. A break is only visible at the
# granularity the caller services the exchange at; see `LineExchange.service`.
PULSE_BREAK_MIN_MS = 20
PULSE_BREAK_MAX_MS = 95
FLASH_MAX_MS = 1_200
PULSE_DIGIT_GAP_MS = 300

EXCHANGE_OUTCOMES = ("answer", "busy", "reorder", "no-answer")

EXCHANGE_STATES = (
    "idle",
    "dial-tone",
    "collecting",
    "routing",
    "ringback",
    "busy",
    "reorder",
    "answer-tone",
    "connected",
    "ringing",
    "released",
)


def _goertzel(samples: list[int], frequency: int, rate: int) -> float:
    """Return the squared magnitude of one frequency bin over one block."""
    coefficient = 2 * math.cos(2 * math.pi * frequency / rate)
    first = second = 0.0
    for sample in samples:
        current = sample + coefficient * first - second
        second, first = first, current
    return first * first + second * second - coefficient * first * second


@dataclass
class DtmfDecoder:
    """Block Goertzel DTMF receiver for the modem's transmit stream.

    The exchange has to learn the dialed number the same way a central office
    does - by listening to what the subscriber puts on the line - because the
    point of the model is that nothing reads the digits out of the firmware.
    """

    sample_rate: int = EXCHANGE_SAMPLE_RATE
    block_samples: int = DTMF_BLOCK_SAMPLES
    accept_blocks: int = DTMF_ACCEPT_BLOCKS
    digits: str = ""
    blocks: int = 0
    _pending: list[int] = field(default_factory=list, repr=False)
    _candidate: str | None = field(default=None, repr=False)
    _run: int = field(default=0, repr=False)
    _held: str | None = field(default=None, repr=False)

    def feed(self, samples: list[int]) -> str:
        """Take transmit samples and return the digits completed by them."""
        found = ""
        self._pending.extend(samples)
        while len(self._pending) >= self.block_samples:
            block = self._pending[: self.block_samples]
            del self._pending[: self.block_samples]
            self.blocks += 1
            key = self._classify(block)
            if key is None:
                self._candidate = None
                self._run = 0
                # A gap is what separates two presses of the same key.
                self._held = None
                continue
            if key != self._candidate:
                self._candidate = key
                self._run = 1
            else:
                self._run += 1
            if self._run == self.accept_blocks and key != self._held:
                self._held = key
                self.digits += key
                found += key
        return found

    def _classify(self, block: list[int]) -> str | None:
        total = sum(float(sample) * sample for sample in block)
        if total <= 0:
            return None
        if math.sqrt(total / len(block)) < DTMF_SILENCE_LEVEL:
            return None
        scale = len(block) * total
        rows = [
            _goertzel(block, frequency, self.sample_rate) / scale
            for frequency in DTMF_ROW_FREQUENCIES
        ]
        columns = [
            _goertzel(block, frequency, self.sample_rate) / scale
            for frequency in DTMF_COLUMN_FREQUENCIES
        ]
        row = max(range(len(rows)), key=lambda index: rows[index])
        column = max(range(len(columns)), key=lambda index: columns[index])
        if rows[row] < DTMF_BIN_FLOOR or columns[column] < DTMF_BIN_FLOOR:
            return None
        if rows[row] + columns[column] < DTMF_PAIR_FLOOR:
            return None
        # Powers are squared magnitudes, so the amplitude twist is the square
        # root of their ratio.
        twist = math.sqrt(max(rows[row], columns[column]) / min(rows[row], columns[column]))
        if twist > DTMF_MAX_TWIST:
            return None
        return DTMF_KEYS[row * len(DTMF_COLUMN_FREQUENCIES) + column]


@dataclass
class LineExchange:
    """A digital ATA: the network side of one subscriber loop, in samples.

    This is the counterpart to `LineLink`, which connects two Couriers to each
    other over a dedicated pair with no exchange between them. Here there is no
    far modem at all by default - there is a central office. It watches the
    hook, plays the tones the loop would carry, decodes the number the modem
    dials into the line, and routes the call, so the firmware's own dial
    sequencer sees the transitions it waits on instead of a model that supplies
    the outcome around it.

    It is digital in the sense that it lives entirely in the codec sample
    stream: no loop current, no balance network, no hybrid. Hook state comes in
    as a boolean, audio comes in and goes out as signed 16-bit samples at the
    codec rate, and every timer is counted in those samples.
    """

    sample_rate: int = EXCHANGE_SAMPLE_RATE
    # Dialed number to outcome. Anything not listed takes `default_outcome`.
    directory: dict[str, str] = field(default_factory=dict)
    default_outcome: str = "answer"
    # Rings the far end waits through before it picks up, and how long the
    # exchange keeps ringing a number that never answers.
    answer_after_rings: int = 2
    no_answer_rings: int = 8
    answer_tone_ms: int = 3_000
    # Routing waits this long after the last digit for one more.
    interdigit_ms: int = 4_000
    # Silence between dial tone ending and the first progress tone, which is
    # what a real switch spends setting the call up.
    routing_ms: int = 500
    # An off-hook loop that never dials ends in reorder, as a real line does.
    first_digit_ms: int = 16_000
    # Cadence the exchange rings this subscriber with on an incoming call.
    ring_on_ms: int = RINGBACK_ON_MS
    ring_off_ms: int = RINGBACK_OFF_MS
    incoming_rings: int = 12
    pulse_dialing: bool = True
    # A hotline (private ringdown) route: the switch has a number for this
    # loop already and starts the call on seizure, with no dial tone and no
    # digits. It is a real service, and it is the one way to bring a call up
    # without the subscriber dialing - which is what makes it useful when the
    # question under test is what the modem does after the call is up.
    hotline: bool = False
    # Once the call is up the exchange stops generating and asks this for the
    # far end's audio: `peer_audio(count, transmitted) -> samples`. Without one
    # a connected call is silent, which is a bare loop with nobody on it.
    peer_audio: Callable[[int, list[int]], list[int]] | None = None

    state: str = "idle"
    off_hook: bool = False
    dialed: str = ""
    outcome: str | None = None
    rings_delivered: int = 0
    flashes: int = 0
    elapsed: int = 0
    tx_samples: int = 0
    rx_samples: int = 0
    calls: int = 0
    inbound_number: str | None = None
    decoder: DtmfDecoder = field(default_factory=DtmfDecoder)
    _state_at: int = field(default=0, repr=False)
    _tone_index: int = field(default=0, repr=False)
    _hook_at: int = field(default=0, repr=False)
    _pulses: int = field(default=0, repr=False)
    _last_digit_at: int = field(default=0, repr=False)

    def __post_init__(self) -> None:
        if self.default_outcome not in EXCHANGE_OUTCOMES:
            choices = ", ".join(EXCHANGE_OUTCOMES)
            raise ValueError(
                f"invalid exchange outcome {self.default_outcome!r}; choose {choices}"
            )
        for number, outcome in self.directory.items():
            if outcome not in EXCHANGE_OUTCOMES:
                choices = ", ".join(EXCHANGE_OUTCOMES)
                raise ValueError(
                    f"invalid outcome {outcome!r} for {number!r}; choose {choices}"
                )
        self.decoder.sample_rate = self.sample_rate

    # -- properties the board side reads ---------------------------------

    @property
    def ringing(self) -> bool:
        """Whether ring voltage is on this subscriber's loop right now."""
        if self.state != "ringing":
            return False
        phase = self._in_state() % self._samples(self.ring_on_ms + self.ring_off_ms)
        return phase < self._samples(self.ring_on_ms)

    @property
    def tone_present(self) -> bool:
        """Whether the exchange is putting audible tone on the loop."""
        return bool(self._current_tone())

    @property
    def dial_tone_present(self) -> bool:
        return self.state == "dial-tone"

    @property
    def connected(self) -> bool:
        return self.state in ("answer-tone", "connected")

    @property
    def line_state(self) -> str:
        """The behavioral DAA line state this exchange is presenting.

        The DAA's four states are what the rest of the harness already speaks,
        so the exchange reports itself in them rather than making every caller
        learn its own.
        """
        if self.state == "released":
            return "disconnected"
        if self.state == "ringing":
            return "ringing"
        if self.state == "dial-tone":
            return "dial-tone"
        return "quiet"

    # -- the loop --------------------------------------------------------

    def service(self, off_hook: bool, transmitted: list[int] | None = None,
                count: int | None = None) -> list[int]:
        """Advance the line by one block and return what the loop carries back.

        `transmitted` is what the modem put on the line over this block; the
        return is the same number of samples going the other way. `count`
        covers a caller that has no transmit samples yet but still has to let
        time pass.

        The block length is the exchange's whole time resolution. Tones and
        digit timing are indifferent to it, but a loop break is only seen as
        one block, so pulse dialing needs blocks well under the 60 ms break -
        20 ms or shorter. At the 100 ms frame the line link runs on, the tone
        and DTMF paths are exact and pulse digits are not resolvable.
        """
        transmitted = list(transmitted or [])
        if count is None:
            count = len(transmitted)
        if count <= 0:
            return []
        self.tx_samples += len(transmitted)
        self._observe_hook(off_hook)
        # Run the block in steps so a caller handing over a whole 100 ms frame
        # still gets its transitions where they belong inside it, rather than
        # one state change per call.
        samples: list[int] = []
        first = 0
        while first < count:
            step = min(EXCHANGE_STEP_SAMPLES, count - first)
            chunk = transmitted[first : first + step]
            if self.state in ("dial-tone", "collecting") and chunk:
                for digit in self.decoder.feed(chunk):
                    self._accept_digit(digit)
            self._advance()
            samples.extend(self._render(step, chunk))
            self.elapsed += step
            first += step
        self.rx_samples += len(samples)
        return samples

    def ring(self, number: str | None = None) -> None:
        """Offer an incoming call to this subscriber."""
        if self.off_hook or self.state not in ("idle", "released"):
            return
        self.inbound_number = number
        self.rings_delivered = 0
        self._enter("ringing")

    def release(self) -> None:
        """Take the call down from the far end."""
        if self.state in ("idle", "ringing"):
            return
        self._enter("released")

    # -- internals -------------------------------------------------------

    def _samples(self, milliseconds: int) -> int:
        return max(1, milliseconds * self.sample_rate // 1_000)

    def _in_state(self) -> int:
        return self.elapsed - self._state_at

    def _enter(self, state: str) -> None:
        if state not in EXCHANGE_STATES:
            raise ValueError(f"unknown exchange state {state!r}")
        self.state = state
        self._state_at = self.elapsed
        self._tone_index = 0

    def _observe_hook(self, off_hook: bool) -> None:
        if off_hook == self.off_hook:
            return
        held = self.elapsed - self._hook_at
        self.off_hook = off_hook
        self._hook_at = self.elapsed
        if off_hook:
            self._on_seizure(held)
        else:
            self._on_release()

    def _on_seizure(self, on_hook_for: int) -> None:
        """The subscriber closed the loop."""
        if self.state == "ringing":
            # Answering an incoming call: the exchange stops ringing and the
            # two ends are through to each other.
            self.calls += 1
            self._enter("connected")
            return
        if self.state in ("dial-tone", "collecting") and self.pulse_dialing:
            # This was the make side of a dial pulse or the end of a flash.
            milliseconds = on_hook_for * 1_000 // self.sample_rate
            if PULSE_BREAK_MIN_MS <= milliseconds <= PULSE_BREAK_MAX_MS:
                self._pulses += 1
                self._last_digit_at = self.elapsed
                if self.state == "dial-tone":
                    self._enter("collecting")
                return
            if milliseconds <= FLASH_MAX_MS:
                self.flashes += 1
                return
        if self.state in ("idle", "released"):
            self.calls += 1
            self.dialed = ""
            self.outcome = None
            self._pulses = 0
            self.decoder = DtmfDecoder(sample_rate=self.sample_rate)
            self._last_digit_at = self.elapsed
            if self.hotline:
                self._route()
            else:
                self._enter("dial-tone")

    def _on_release(self) -> None:
        """The subscriber opened the loop."""
        if self.state in ("dial-tone", "collecting") and self.pulse_dialing:
            # Could be a pulse break; the make side decides. Leave the state
            # alone until then.
            return
        if self.state == "ringing":
            return
        self._enter("idle")
        self.dialed = ""
        self.outcome = None

    def _accept_digit(self, digit: str) -> None:
        if self.state == "dial-tone":
            # Dial tone stops on the first digit. Nothing else does that, so
            # it is the transition a dial sequencer can key on.
            self._enter("collecting")
        self.dialed += digit
        self._last_digit_at = self.elapsed
        self._pulses = 0
        if digit == "#" or self.dialed in self.directory:
            self._route()

    def _flush_pulses(self) -> None:
        if not self._pulses:
            return
        # Ten pulses is zero; the rest are their own count.
        self.dialed += str(self._pulses % 10)
        self._pulses = 0
        self._last_digit_at = self.elapsed
        if self.dialed in self.directory:
            self._route()

    def _route(self) -> None:
        self.outcome = self.directory.get(self.dialed, self.default_outcome)
        self.rings_delivered = 0
        self._enter("routing")

    def _advance(self) -> None:
        """Run the timers that move the call along without a new event."""
        if not self.off_hook and self.state in ("dial-tone", "collecting"):
            # A break this long during dialing is no longer a dial pulse or a
            # flash; the subscriber has hung up mid-number.
            if self.elapsed - self._hook_at >= self._samples(FLASH_MAX_MS):
                self._enter("idle")
                self.dialed = ""
                self.outcome = None
                self._pulses = 0
            return
        if self.state == "dial-tone":
            if self._in_state() >= self._samples(self.first_digit_ms):
                # Nothing dialed: the switch gives up on the loop.
                self.outcome = "reorder"
                self._enter("reorder")
            return
        if self.state == "collecting":
            if (
                self._pulses
                and self.elapsed - self._last_digit_at >= self._samples(PULSE_DIGIT_GAP_MS)
            ):
                self._flush_pulses()
            if (
                self.state == "collecting"
                and self.dialed
                and not self._pulses
                and self.elapsed - self._last_digit_at >= self._samples(self.interdigit_ms)
            ):
                self._route()
            return
        if self.state == "routing":
            if self._in_state() < self._samples(self.routing_ms):
                return
            if self.outcome == "busy":
                self._enter("busy")
            elif self.outcome == "reorder":
                self._enter("reorder")
            else:
                self._enter("ringback")
            return
        if self.state == "ringback":
            cycle = self._samples(RINGBACK_ON_MS + RINGBACK_OFF_MS)
            self.rings_delivered = self._in_state() // cycle
            if self.outcome == "answer" and self.rings_delivered >= self.answer_after_rings:
                self.calls += 1
                self._enter("answer-tone" if self.answer_tone_ms else "connected")
            elif self.outcome == "no-answer" and self.rings_delivered >= self.no_answer_rings:
                self._enter("released")
            return
        if self.state == "answer-tone":
            if self._in_state() >= self._samples(self.answer_tone_ms):
                self._enter("connected")
            return
        if self.state == "ringing":
            cycle = self._samples(self.ring_on_ms + self.ring_off_ms)
            self.rings_delivered = self._in_state() // cycle
            if self.incoming_rings and self.rings_delivered >= self.incoming_rings:
                self.inbound_number = None
                self._enter("idle")
            return

    def _current_tone(self) -> tuple[tuple[int, ...], int, int]:
        """Return the tone for this state as (frequencies, on_ms, off_ms)."""
        if not self.off_hook:
            return ((), 0, 0)
        if self.state == "dial-tone":
            return (DIAL_TONE, 0, 0)
        if self.state == "ringback":
            return (RINGBACK_TONE, RINGBACK_ON_MS, RINGBACK_OFF_MS)
        if self.state == "busy":
            return (CONGESTION_TONE, BUSY_ON_MS, BUSY_OFF_MS)
        if self.state in ("reorder", "released"):
            return (CONGESTION_TONE, REORDER_ON_MS, REORDER_OFF_MS)
        if self.state == "answer-tone":
            return ((ANSWER_TONE,), 0, 0)
        return ((), 0, 0)

    def _render(self, count: int, transmitted: list[int]) -> list[int]:
        if self.state == "connected":
            if self.peer_audio is None:
                return [0] * count
            samples = list(self.peer_audio(count, transmitted))[:count]
            samples.extend([0] * (count - len(samples)))
            return samples
        frequencies, on_ms, off_ms = self._current_tone()
        if not frequencies:
            self._tone_index += count
            return [0] * count
        period = self._samples(on_ms + off_ms) if on_ms else 0
        on_samples = self._samples(on_ms) if on_ms else 0
        result: list[int] = []
        for offset in range(count):
            index = self._tone_index + offset
            if period and index % period >= on_samples:
                result.append(0)
                continue
            value = sum(
                TONE_LEVEL * math.sin(2 * math.pi * frequency * index / self.sample_rate)
                for frequency in frequencies
            )
            result.append(max(-32_768, min(32_767, round(value))))
        self._tone_index += count
        return result

    def status(self) -> dict[str, Any]:
        return {
            "state": self.state,
            "line_state": self.line_state,
            "off_hook": self.off_hook,
            "dialed": self.dialed,
            "outcome": self.outcome,
            "ringing": self.ringing,
            "tone_present": self.tone_present,
            "connected": self.connected,
            "rings_delivered": self.rings_delivered,
            "flashes": self.flashes,
            "calls": self.calls,
            "digits_decoded": self.decoder.digits,
            "dtmf_blocks": self.decoder.blocks,
            "elapsed_ms": self.elapsed * 1_000 // self.sample_rate,
            "samples_received": self.tx_samples,
            "samples_sent": self.rx_samples,
        }
