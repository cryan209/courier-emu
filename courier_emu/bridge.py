from __future__ import annotations

from collections import Counter, deque
from dataclasses import dataclass
import math
from typing import Any

from .codec import CodecBringUp
from .daa import CourierDaa, DAA_FRAME_SAMPLES, RingSource
from .dsp import NativeC5x
from .exchange import DTMF_COLUMN_FREQUENCIES, DTMF_KEYS, DTMF_ROW_FREQUENCIES, LineExchange
from .line import LINE_FRAME_INSTRUCTIONS, LINE_FRAME_SAMPLES, LineFrame, LineLink
from .sip import RateConverter, SipSession
from .xmf import DSP_BOOT_SIZE, XmfImage


DSP_COMMAND_PORT = 0x1E
DSP_WINDOW_FIRST = 0x40
DSP_WINDOW_LAST = 0x4E
DSP_WINDOW_STRIDE = 2
# The downloaded low bank contains the C52 TDM transmit ISR at 0x0228. Its
# branch vector itself is in unavailable customer mask ROM; match the ISR's
# opening words before supplying that one recovered vector.
C52_TDM_IRQ = 7
C52_TDM_ISR = 0x0228
C52_TDM_ISR_SIGNATURE = bytes.fromhex("ffbd5208b0bf030090bf")
# Call overlay 7 is stored at b9c0 with branches already linked for c418. The
# ASIC publishes that bank over c418..ce6f when it starts the datapump.
C52_CALL_OVERLAY_SOURCE = 0xB9C0
C52_CALL_OVERLAY_DESTINATION = 0xC418
C52_CALL_OVERLAY_WORDS = C52_CALL_OVERLAY_DESTINATION - C52_CALL_OVERLAY_SOURCE
# The overlay is linked independently in each supervisor build.  Its first
# instruction pair is stable, while the following branch displacement changes
# between firmware revisions.
C52_CALL_OVERLAY_SIGNATURE = bytes.fromhex("4a6908e3")
DSP_RUNTIME_PORTS = (0x58, 0x5A, 0x5C, 0x5E)

# A supervisor sends the C52 program through one of two transfer protocols,
# and they are not compatible enough to merge. An update payload's supervisor
# strobes eight bytes at a time from one window on port 0x1e. A flash ROM's
# downloader at e47b alternates two windows, strobing 0x40..0x4e with 1 and
# 0x50..0x5e with 2, both on port 0x18, and finishes by submitting its word
# checksum with 4.
#
# The collision that forces a profile rather than a union: 0x58..0x5e are the
# runtime mailbox registers in both protocols, but in the ROM's they are also
# the upper half of the second transfer window. Nothing in a single write
# distinguishes the two uses, so the download's own completion does - before
# the program is in, those ports are window lanes; after it, they are the
# mailbox. That is the order the hardware runs them in.
ROM_COMMAND_PORT = 0x18
ROM_CHECKSUM_STROBE = 4
# The value e3aa writes to 0x1c as it leaves, on both its paths.
ENTRY_REQUEST_COMPLETE = 2


@dataclass(frozen=True)
class TransferProfile:
    """How a supervisor moves program words into the DSP."""

    name: str
    command_port: int
    # Strobe value to the base port of the window it commits.
    windows: tuple[tuple[int, int], ...]
    checksum_strobe: int | None
    # Whether the runtime mailbox registers double as transfer window lanes.
    mailbox_shares_window: bool

    @property
    def first_strobe(self) -> int:
        return self.windows[0][0]

    def lanes(self) -> dict[int, tuple[int, int]]:
        """Map each window port to the strobe that commits it and its lane."""
        return {
            base + lane * DSP_WINDOW_STRIDE: (strobe, lane)
            for strobe, base in self.windows
            for lane in range(8)
        }


XMF_TRANSFER = TransferProfile(
    "xmf", DSP_COMMAND_PORT, ((1, DSP_WINDOW_FIRST),), None, False
)
ROM_TRANSFER = TransferProfile(
    "rom", ROM_COMMAND_PORT, ((1, 0x40), (2, 0x50)), ROM_CHECKSUM_STROBE, True
)

# The supervisor's receive table stores this tag's data word at [0x287], which
# is the DAA revision `ATI7` prints and which the product ID at 0x8369d
# branches on. Its three neighbours -- 0x7c, 0x7d, 0x7e -- fill [0x283]/[0x285],
# [0x27f] and [0x281] from the same handler and are still unidentified.
DAA_IDENTITY_TAG = 0x7B

# The line-detector poll the supervisor's countdown chain runs, and the tag
# its reply comes back under. One state of the chain armed at 0x5db6c writes
# 0x7c00 to the board and the state after it consumes the answer, which the
# receive handler stores at [0x285]/[0x283]. That word is banded
# zero / 1..0x60 / above 0x60, and the low band is what increments the
# five-hit detector byte at [0x649]. The request carries the same tag back.
DETECTOR_TAG = 0x7C
# Any reading inside the low band does the same thing; the middle of it is
# chosen so neither boundary is being relied on.
DETECTOR_PRESENT_LEVEL = 0x30

# How the supervisor's dialer asks for a tone. `0x6353c` folds a dial-string
# character down to its keypad index and sends it as this tag; the encoder
# emits `0x1600` first and again when the tone ends, so a digit is exactly a
# `0x13` between two `0x1600`s. Both tags are also register lanes in the
# call-start block, which is why the preceding message decides.
DIAL_TONE_TAG = 0x13
DIAL_SILENCE = (0x16, 0x0000)
# Level per component, matching what the exchange renders its own tones at.
DIAL_TONE_LEVEL = 4_000
# The keypad index the supervisor sends, decoded from its own encoder at
# 0x6353c: characters below '*' gain 6 and characters below '0' gain 0x11, so
# '#' lands on 0x0a and '*' on 0x0b; 'A'-'D' lose 5 to land on 0x0c-0x0f; and
# '0'-'9' pass through, leaving the low nibble equal to the digit. It is one
# nibble, because the encoder masks it to one before it sends.
DIAL_TONE_DIGITS = "0123456789#*ABCD"


@dataclass
class BridgeStatus:
    active: bool
    bootstrap_bytes: int
    bootstrap_match: bool | None
    bootstraps: int
    transfer_commands: int
    mailbox_commands: int
    mailbox_windows: dict[str, int]
    runtime_messages: list[str]
    runtime_message_counts: dict[str, int]
    runtime_inbound_delivered: dict[str, int]
    runtime_message_first_seen: dict[str, int]
    runtime_message_first_pc: dict[str, str]
    runtime_words_queued: int
    detector_replies: int
    error: str | None
    dsp: dict[str, int | bool]
    dsp_host_ports: dict[str, dict[str, int]]
    dsp_memory_map: dict[str, int | bool]
    asic: dict[str, Any]
    serial_port: dict[str, int]
    v8_io_events: list[dict[str, int | bool]]
    dsp_pc_trace: list[dict[str, int]]
    dsp_data_events: list[dict[str, int]]
    dial_digits: str
    daa: dict[str, str | int | bool] | None
    sip: dict[str, str | int | bool | list[str]] | None
    line: dict[str, Any] | None = None
    codec: dict[str, Any] | None = None
    exchange: dict[str, Any] | None = None


class CourierDspBridge:
    """Courier host-port window plus a batched 80186/C52 clock scheduler."""

    def __init__(
        self,
        image: XmfImage,
        *,
        batch: int = 256,
        rx_samples: list[int] | None = None,
        daa: CourierDaa | None = None,
        sip: SipSession | None = None,
        line: LineLink | None = None,
        codec: CodecBringUp | None = None,
        ring: RingSource | None = None,
        exchange: LineExchange | None = None,
    ) -> None:
        self.image = image
        self.expected_bootstrap = image.dsp_program_segments()[0][1]
        # A ROM locates its payload through its own download call site, which
        # an update payload has no need of; that is what tells the two
        # transfer protocols apart here.
        self.transfer = (
            ROM_TRANSFER if hasattr(image, "dsp_download") else XMF_TRANSFER
        )
        if self.transfer is ROM_TRANSFER:
            # A ROM's supervisor makes one download call covering the whole
            # payload, so the transfer is complete only once all of it has
            # arrived. There is no shorter resident bootstrap to recognize.
            self.bootstrap_target_size = len(self.expected_bootstrap)
        else:
            # The 2.3 supervisor downloads the shorter 0xcbc0-byte resident
            # bootstrap; the 2.1/2.2 supervisors transfer the full segment.
            self.bootstrap_target_size = (
                0xCBC0 if getattr(image, "supervisor_offset", 0) == 0x17BB0
                else DSP_BOOT_SIZE
            )
        self.core = NativeC5x(image)
        self._configure_frame_interrupt()
        self._call_overlay = self._find_call_overlay()
        self._call_overlay_active = False
        self._call_resume_pending = False
        self._call_resume_state: dict[str, int | bool] | None = None
        self.batch = batch
        self._lanes = self.transfer.lanes()
        self._windows = {
            strobe: bytearray(b"\xff" * 8) for strobe, _ in self.transfer.windows
        }
        # The first window keeps the old name; the bootstrap recognition and
        # the status report both read it.
        self.window = self._windows[self.transfer.first_strobe]
        self.checksum_submits = 0
        # The C52 program word the supervisor asks the boot ROM to enter.
        self.entry_word = image.dsp_program_segments()[0][0]
        self.launched = False
        self._last_state: dict[str, int | bool] | None = None
        self.bootstrap = bytearray()
        self.active = False
        self.bootstrap_match: bool | None = None
        self.bootstraps = 0
        self.transfer_commands = 0
        self.mailbox_commands = 0
        self.mailbox_windows: Counter[str] = Counter()
        self.runtime_messages: deque[str] = deque(maxlen=64)
        self.runtime_message_counts: Counter[str] = Counter()
        self.runtime_message_first_seen: dict[str, int] = {}
        self.runtime_message_first_pc: dict[str, str] = {}
        self.runtime_words_queued = 0
        self.asic_registers: dict[int, int] = {}
        self.asic_writes: Counter[int] = Counter()
        self._asic_call_engine_started = False
        self._asic_commit_edges = 0
        self._asic_dsp_register_commits = 0
        self._v8_armed = False
        self.detector_replies = 0
        self._runtime_mode = False
        self._runtime_ready = False
        self._runtime_ready_delay = 0
        self._runtime_header = 0xFFFF
        self._runtime_data = 0xFFFF
        self._runtime_inbound: deque[tuple[int, int]] = deque()
        self._runtime_inbound_delivered: Counter[str] = Counter()
        self._runtime_inbound_seen = False
        self._connected_event_queued = False
        self.error: str | None = None
        self._x86_ticks = 0
        self.rx_samples = list(rx_samples or [])
        self._rx_samples_queued = False
        self._rx_samples_codec_queued = False
        self.dial_digits = ""
        self.daa = daa
        self.sip = sip
        self.line = line
        self.codec = codec
        self.ring = ring
        self.exchange = exchange
        self._instructions = 0
        self._exchange_instructions = 0
        self._exchange_tx_index = 0
        self._exchange_rx_samples: deque[int] = deque()
        self._dial_tone_digit: str | None = None
        self._dial_tone_index = 0
        self._codec_instructions = 0
        self._line_instructions = 0
        self._line_tx_index = 0
        self._line_rx_samples: deque[int] = deque()
        self._line_rx_peak = 0
        self._codec_queue_peak = 0
        self._carrier_probe: deque[int] = deque()
        self._carrier_probe_frames = 0
        self._carrier_best_score = 0.0
        self._rate_trace_enabled = False
        self._sip_tx_index = 0
        self._sip_tx_rate = RateConverter(9_600, 8_000)
        self._sip_rx_rate = RateConverter(8_000, 9_600)
        self._sip_rx_samples: deque[int] = deque()
        self._completion_probe = False

    def _negotiation_audio_status(self) -> dict[str, int]:
        """Summarize the latest codec frame at the V.8 signaling frequencies."""
        written = self.core.serial_state().get("line_tx_writes", 0)
        samples = self.core.line_tx_samples(max(0, written - DAA_FRAME_SAMPLES))
        if not samples:
            return {"samples": 0, "rms": 0}
        status = {
            "samples": len(samples),
            "rms": round(math.sqrt(sum(sample * sample for sample in samples) / len(samples))),
        }
        for frequency in (980, 1180, 1300, 1875, 2100):
            cosine = sum(
                sample * math.cos(2 * math.pi * frequency * index / 9600)
                for index, sample in enumerate(samples)
            )
            sine = sum(
                sample * math.sin(2 * math.pi * frequency * index / 9600)
                for index, sample in enumerate(samples)
            )
            status[f"hz_{frequency}"] = round(math.hypot(cosine, sine) / len(samples))
        # CM and JM use the 300 bit/s V.21 low channel. A whole-frame DFT
        # cancels as the modem changes symbols, so score its 32-sample symbols
        # separately at the 980/1180 Hz mark and space frequencies.
        fsk_symbols = {980: 0, 1180: 0}
        fsk_strong = 0
        for first in range(0, len(samples) - 31, 32):
            symbol = samples[first : first + 32]
            scores = {}
            for frequency in fsk_symbols:
                cosine = sum(
                    sample * math.cos(2 * math.pi * frequency * index / 9600)
                    for index, sample in enumerate(symbol)
                )
                sine = sum(
                    sample * math.sin(2 * math.pi * frequency * index / 9600)
                    for index, sample in enumerate(symbol)
                )
                scores[frequency] = 2 * math.hypot(cosine, sine) / len(symbol)
            winner = max(scores, key=scores.get)  # type: ignore[arg-type]
            fsk_symbols[winner] += 1
            symbol_rms = math.sqrt(sum(sample * sample for sample in symbol) / len(symbol))
            if symbol_rms and scores[winner] >= symbol_rms:
                fsk_strong += 1
        status["v21_mark_symbols"] = fsk_symbols[980]
        status["v21_space_symbols"] = fsk_symbols[1180]
        status["v21_strong_symbols"] = fsk_strong
        return status

    def _observe_carrier_audio(self) -> None:
        """Detect the answer carrier in the real peer waveform.

        The resident C52 overlay supplies the line datapump, but the native
        core does not yet implement its carrier detector.  The recovered
        answer waveform is centred near 1.875 kHz at the 9.6 kHz codec rate;
        accept that component (and the nominal 2.1 kHz ANSam component) only
        after a full 100 ms frame and only on an originating call.
        """
        if (
            self._connected_event_queued
            or self._call_overlay_active is False
            or self.daa is None
            or self.daa.operation not in ("dialing", "answer")
        ):
            return
        while len(self._carrier_probe) >= DAA_FRAME_SAMPLES:
            samples = [self._carrier_probe.popleft() for _ in range(DAA_FRAME_SAMPLES)]
            self._carrier_probe_frames += 1
            energy = math.sqrt(sum(sample * sample for sample in samples) / len(samples))
            if energy < 500:
                continue
            scores: list[float] = []
            for frequency in (1300, 1875, 2100):
                cosine = sum(
                    sample * math.cos(2 * math.pi * frequency * index / 9600)
                    for index, sample in enumerate(samples)
                )
                sine = sum(
                    sample * math.sin(2 * math.pi * frequency * index / 9600)
                    for index, sample in enumerate(samples)
                )
                scores.append(math.hypot(cosine, sine) / len(samples))
            self._carrier_best_score = max(self._carrier_best_score, *scores)
            # The answer-side detector sees the peer's 1300 Hz calling
            # indicator after the codec/TDM path, where the measured score is
            # about 52 in this linked pair.  Keep the originator threshold
            # conservative, but accept the answer-side floor with margin.
            threshold = 180 if self.daa.operation == "dialing" else 45
            if max(scores) >= threshold:
                self._publish_connected_event()
                return

    def _find_call_overlay(self) -> bytes | None:
        matches: list[tuple[int, bytes]] = []
        for origin, segment in self.image.dsp_program_segments():
            # Later builds move the overlay entry a few words while retaining
            # the same destination bank.  Find the invariant prologue rather
            # than assuming main211's source address.
            first = 0
            while True:
                first = segment.find(C52_CALL_OVERLAY_SIGNATURE, first)
                if first < 0:
                    break
                if first % 2:
                    first += 2
                    continue
                source = origin + first // 2
                size = (C52_CALL_OVERLAY_DESTINATION - source) * 2
                if size > 0 and first + size <= len(segment):
                    matches.append((abs(source - C52_CALL_OVERLAY_SOURCE), segment[first : first + size]))
                first += 2
        if matches:
            return min(matches, key=lambda item: item[0])[1]
        return None

    def _activate_call_overlay(self, selector: int) -> None:
        if self._call_overlay_active or self._call_overlay is None:
            return
        if not hasattr(self.core, "load_program"):
            return
        if hasattr(self.core, "schedule_call_overlay"):
            self.core.schedule_call_overlay(
                self._call_overlay, C52_CALL_OVERLAY_DESTINATION,
                self._call_register_values(), selector,
            )
        else:
            self.core.load_program(self._call_overlay, C52_CALL_OVERLAY_DESTINATION)
            # The download window and running TDM latches share these pins.
            for port in range(0x50, 0x60):
                self.core.set_io(port, 0)
            if hasattr(self.core, "set_call_tdm_active"):
                self.core.set_call_tdm_active(True)
        self._call_overlay_active = True
        # main211 enters the call overlay after its only DSP bootstrap.  A
        # pre-recorded line therefore cannot rely on the bootstrap path to
        # publish its samples to the ASIC codec queue.
        if (
            self.rx_samples
            and hasattr(self.core, "queue_codec_rx")
            and not self._rx_samples_codec_queued
        ):
            self.core.queue_codec_rx(self.rx_samples)
            self._rx_samples_codec_queued = True

    @staticmethod
    def _c52_word(value: int) -> int:
        return ((value & 0xFF) << 8) | ((value >> 8) & 0xFF)

    def _call_register_values(self) -> list[int]:
        defaults = {
            0x13: 0x0100,
            0x15: 0x0000,
            0x16: 0x0000,
            0x19: 0x0D02,
            0x1A: 0x0030,
            0x1B: 0x080C,
            0x1F: 0x0080,
        }
        return [
            self._c52_word(self.asic_registers[register])
            if register in self.asic_registers
            else default
            for register, default in defaults.items()
        ]

    def _publish_call_registers(self) -> None:
        for register, value in zip(
            (0x13, 0x15, 0x16, 0x19, 0x1A, 0x1B, 0x1F),
            self._call_register_values(),
            strict=True,
        ):
            # The board's own dispatcher at DSP word 839b treats a tag as an
            # index into a 121-entry jump table, not as a destination address,
            # and discards anything above 7f. Hardware confirms it: see
            # docs/dsp-rom-probe.md, "A repeatable host write". This call is
            # therefore a convenience for seeding the modelled C52's call
            # registers, not a model of the board's write path.
            self.core.host_write(register, value)

    def _schedule_call_entry(self) -> None:
        if hasattr(self.core, "schedule_line_frame_entry"):
            self.core.schedule_line_frame_entry(0x2295)
        else:
            self.core.set_pc(0x2295)

    def _resume_armed_call(self) -> None:
        if not self._v8_armed:
            return
        self._call_resume_state = self.core.state()
        if hasattr(self.core, "trace_data_writes"):
            self.core.trace_data_writes(True)
            self._rate_trace_enabled = True
        answering = self.daa is not None and self.daa.operation == "answer"
        selector = 0x0000 if answering else 0x0002
        if answering and hasattr(self.core, "set_v8_answering"):
            self.core.set_v8_answering(True)
        elif not answering and hasattr(self.core, "set_v8_calling"):
            self.core.set_v8_calling(True)
        # Any line samples collected before the call overlay are call-progress
        # audio, not V.8. Do not let them precede the first peer frame in the
        # codec FIFO.
        self._line_rx_samples.clear()
        self._activate_call_overlay(selector)
        if answering:
            # The early answer indication can be consumed by the bootstrap
            # callback. Replay the connected/status edge once the overlay is
            # active so the resident supervisor sees it through its runtime
            # table, as the originating side does.
            if self._connected_event_queued:
                self._queue_runtime_message(0x0009, 0x0000)
                self._queue_runtime_message(0x0044, 0x0001)
                self._queue_runtime_message(0x004D, 0x0001)
                self._queue_runtime_message(0x001D, 0x0000)
            # Answer-side ready replies become visible only after the call
            # overlay owns the runtime callback; publishing them at answer
            # qualification is consumed by the bootstrap callback instead.
            self._queue_runtime_message(0x0002, 0x0000)
            self._queue_runtime_message(0x0003, 0x0000)
        if not hasattr(self.core, "schedule_call_overlay"):
            self._publish_call_registers()
            if hasattr(self.core, "set_data"):
                self.core.set_data(0x006F, selector)
        self._schedule_call_entry()
        self._call_resume_pending = False

    def _maybe_start_answer_engine(self) -> None:
        """Let the ASIC start the native datapump for a qualified answer.

        main211's supervisor emits the originate register block itself, but
        its incoming-ring consumer is in the missing ASIC/customer-ROM side
        of this board. The physical result of that transition is the same
        atomic call-register publication used by originate: the resident
        overlay is entered on the next frame boundary. This deliberately
        does not report a result code or carrier; those remain firmware-owned.
        """
        if (
            self._v8_armed
            or self._call_resume_pending
            or self._call_overlay_active
            or self.daa is None
            or self.daa.operation != "answer"
            or not self.daa.detector_qualified
        ):
            return
        self._v8_armed = True
        self._call_resume_pending = True
        self._asic_call_engine_started = True
        if self._call_overlay is not None and self.asic_registers.get(0x82) == 0x00A0:
            # Answer uses the same ASIC release edge as originate; the
            # supervisor leaves the line held while the detector qualifies.
            self.asic_registers[0x82] = 0x0060
        # The ASIC publishes call-up when the answer engine commits, before
        # the supervisor's command-mode carrier timeout expires.  In a linked
        # line, line.connected is the board-level evidence that this is a real
        # call rather than a bare ATA with no far end.
        if self.line is not None and self.line.connected:
            self._publish_connected_event()

    def _configure_frame_interrupt(self) -> None:
        if getattr(self.image, "supervisor_offset", 0) == 0x17BB0:
            if hasattr(self.core, "configure_line_frame_interrupt"):
                self.core.configure_line_frame_interrupt(5, 0x0206)
            return
        if (
            hasattr(self.core, "configure_line_frame_interrupt")
            and self.expected_bootstrap[
                C52_TDM_ISR * 2 : C52_TDM_ISR * 2 + len(C52_TDM_ISR_SIGNATURE)
            ] == C52_TDM_ISR_SIGNATURE
        ):
            self.core.configure_line_frame_interrupt(C52_TDM_IRQ, C52_TDM_ISR)

    def arm_dial_tones(self, command: bytes) -> None:
        if self.exchange is not None:
            # With a modeled line the command is the firmware's alone. It
            # parses the dial string, seizes the loop through its own hook
            # relay, qualifies dial tone from its own detector count and
            # sequences its own digits; reading the text here could only
            # duplicate or pre-empt that.
            return
        text = command.decode("ascii", "ignore").upper()
        # The supervisor's attention front-end strips the leading ``AT``
        # before calling us, so a real terminal supplies ``A`` here. Tests
        # and direct bridge users may still pass the complete ``ATA`` form.
        if text in ("A", "ATA"):
            if self.daa is not None:
                self.daa.seize("answer")
                if self.line is not None and self.line.connected:
                    # The connected line has already supplied the detector
                    # evidence by the time ATA is parsed.  Let the ASIC answer
                    # engine commit before the command parser's short
                    # carrier-timeout emits NO CARRIER.
                    self.daa.qualified_samples = 5 * DAA_FRAME_SAMPLES
                    self._publish_connected_event()
            return
        marker = text.find("D")
        if marker < 0:
            return
        dial = text[marker + 1 :]
        if dial.startswith(("T", "P")):
            dial = dial[1:]
        self.dial_digits = "".join(ch for ch in dial if ch in "0123456789*#ABCD")
        if self.daa is not None:
            self.daa.seize("originate")
            if self.line is not None and self.line.connected:
                # A dedicated line link represents an already-present loop;
                # the originating side hears central-office dial tone as soon
                # as its hook relay seizes it, before the first frame exchange.
                self.daa.line_state = "dial-tone"
            if self.dial_digits and self.daa.dial_tone_present:
                # The physical DAA continues sampling while the supervisor
                # parses ATD.  Make the five-frame detector window available
                # to the C52 before its short command-mode timeout expires.
                samples = self.daa.render(DAA_FRAME_SAMPLES * 5)
                if self._call_overlay_active and hasattr(self.core, "queue_codec_rx"):
                    self.core.queue_codec_rx(samples)
                else:
                    self.core.queue_serial_rx(samples)
        if (
            self.bootstraps >= 2
            and self.dial_digits
            and (self.daa is None or self.daa.operation == "dialing")
        ):
            self.core.set_dtmf_digits(self.dial_digits)

    def set_line_hook(self, off_hook: bool) -> None:
        """Follow the firmware's own hook relay.

        The supervisor drives the relay through board latch 0 bit 0x04, and
        `CourierPanel` decodes it. Taking the hook from there rather than from
        a parsed `ATD` is what makes the seizure the firmware's: nothing here
        decides when the line is taken, only what the line does about it.

        Which operation the seizure is depends on the line, not on this class:
        answering a ringing loop is an answer, and anything else originates.
        """
        if self.exchange is None:
            # Without a modeled line the seizure is still the stand-in's: the
            # DAA is driven from the parsed command, and following the relay
            # as well would have the two fight over the same hook.
            return
        if self.daa is None or self.daa.off_hook == off_hook:
            return
        if not off_hook:
            self.daa.release()
            if self.exchange is not None:
                self.exchange.service(False, [], 1)
            return
        answering = self.exchange is not None and self.exchange.state == "ringing"
        self.daa.seize("answer" if answering else "originate")

    def begin_dialing(self) -> None:
        if self.daa is not None:
            self.daa.begin_dialing()
        if self.active and self.dial_digits and not self._v8_armed:
            self.core.set_dtmf_digits(self.dial_digits)
        if self.sip is not None and self.dial_digits:
            self.sip.start_call(self.dial_digits)

    def float_runtime_bus(self) -> None:
        """Expose the all-ones reset state expected before a DSP reload."""
        self._runtime_mode = False
        self._runtime_ready = False
        self._runtime_ready_delay = 0
        # A staged monitor response may already be queued. It remains pending
        # while the bus floats and becomes visible when the host next writes
        # the runtime port block.

    def pending_runtime_message(self) -> tuple[int, int] | None:
        """Return the board-to-supervisor message currently on the bus."""
        return self._runtime_inbound[0] if self._runtime_inbound else None

    def set_completion_probe(self, active: bool) -> None:
        """Expose the floating ASIC status bus during the rate probe."""
        self._completion_probe = active

    @property
    def connected_event_queued(self) -> bool:
        """Whether the modeled ASIC has published the carrier-up edge."""
        return self._connected_event_queued

    def force_connected_event(self) -> None:
        """Publish completion for validating the DTE online contract only."""
        self._publish_connected_event()

    def _queue_runtime_message(self, header: int, data: int) -> None:
        self._runtime_inbound.append((header & 0xFFFF, data & 0xFFFF))

    def _maybe_start_asic_call_engine(self) -> None:
        """Acknowledge a held call start once the line detector is ready."""
        if (
            self.asic_registers.get(0x82) != 0x00A0
            or self._call_overlay is None
            or self.daa is None
            or not self.daa.detector_qualified
        ):
            return
        if (
            self.exchange is not None
            and self.daa.operation in ("originate", "dialing")
            and not self.exchange.connected
        ):
            # With a modeled line there is a call to wait for. The datapump
            # starts when the exchange has put the two ends through, not when
            # the line detector debounces - otherwise the modem answers its
            # own seizure with V.8 and never dials.
            return
        # The supervisor publishes 0xa0 (held and line-enabled).  The ASIC
        # owns the later release to 0x60; it can occur after the detector's
        # debounce rather than on the same host write.
        self.asic_registers[0x82] = 0x0060
        if not self._asic_call_engine_started:
            self._asic_call_engine_started = True
            self._v8_armed = True
            if hasattr(self.core, "trace_data_writes"):
                # Keep only writes to the suspected rate/status handoff.
                self.core.trace_data_writes(True)
                self._rate_trace_enabled = True
            self._call_resume_pending = True
            self._queue_runtime_message(0x0002, 0x0000)
            self._queue_runtime_message(0x0003, 0x0000)

    def _advance_asic_call_phase(self) -> None:
        """Release the ASIC from start-strobe into its running phase."""
        if (
            self._asic_call_engine_started
            and self._call_overlay_active
            and self.asic_registers.get(0x82) == 0x0060
        ):
            # Firmware analysis recovered 0x60 as the start-strobe and 0x20
            # as the enabled/running state.  The intermediate edge is owned
            # by the ASIC, not emitted by the 80186 supervisor.
            self.asic_registers[0x82] = 0x0020

    def _observe_asic_command(self, header: int, data: int) -> None:
        """Apply the recovered board-command register protocol.

        Registers 0x13..0x1f form the call-engine setup block. The firmware
        finishes each block by taking register 0x1f from zero to bit 15 set.
        Treat that edge as commit/start. The supervisor's receive table maps
        ASIC replies 0x02 and 0x03 to its two coprocessor-ready latches, so a
        real command engine reports both after accepting the first commit.
        """
        if not (0x13 <= header <= 0x1F or 0x7D <= header <= 0x84):
            return
        previous = self.asic_registers.get(header, 0)
        self.asic_registers[header] = data
        self.asic_writes[header] += 1
        self._observe_dial_tone(header, data)
        if (
            header == 0x82
            and data == 0x00A0
        ):
            self._maybe_start_asic_call_engine()
            return
        if header == 0x82 and data & 0x40 and not self._asic_call_engine_started:
            # The ASIC acknowledges the 0x82 start strobe before the
            # supervisor publishes the C52 register block.  The firmware
            # waits for these two ready latches between that strobe and the
            # 0x13..0x1f/BMAR transaction; delaying them until BMAR commit
            # deadlocks the real call sequence.
            self._asic_call_engine_started = True
            self._queue_runtime_message(0x0002, 0x0000)
            self._queue_runtime_message(0x0003, 0x0000)
        if header != 0x1F or previous != 0 or data == 0:
            return
        # main211 normally publishes BMAR as wire value 0x8000.  On the
        # command path exercised by this image, a board-status word can occupy
        # that final queue slot and the observed nonzero value is 0x443f.
        # The ASIC owns the publication boundary, so accept the first
        # nonzero BMAR word only when the complete preceding register block is
        # present; never treat an isolated status word as a call start.
        if not all(
            register in self.asic_registers
            for register in (0x13, 0x15, 0x16, 0x19, 0x1A, 0x1B)
        ):
            return
        self._asic_commit_edges += 1
        # These are C52 register lanes, but publishing them asynchronously
        # corrupts a running datapump. The deferred overlay commit snapshots
        # the complete block at the recovered ASIC service slot below.
        self._asic_dsp_register_commits += 1
        if not self._v8_armed and self.exchange is not None:
            # The firmware published this block itself, after dialing on its
            # own. The commit is the call boundary; there are no digits to
            # supply, because the digits already went out over the line.
            self._v8_armed = True
            self._call_resume_pending = True
        elif not self._v8_armed and self.dial_digits:
            self._v8_armed = True
            # The command commit is the real call boundary on main211; it does
            # not perform the second bootstrap older notes expected.
            self._call_resume_pending = True
            self.core.set_dtmf_digits(self.dial_digits)
        elif (
            not self._v8_armed
            and self.daa is not None
            and self.daa.operation == "answer"
        ):
            self._v8_armed = True
            self._call_resume_pending = True

    def _observe_dial_tone(self, header: int, data: int) -> None:
        """Play what the supervisor's dialer just asked the board to play.

        The ASIC owns the tone generator, and its firmware is not in this
        image, so the board half of the dial is modeled here. Everything
        before it is the supervisor's: the number came from the dial string it
        parsed, the digit from its own encoder, and the moment from its own
        tone and interdigit timers.

        Each digit goes out as a small block - `0x16:0000`, then the tone
        generator's three constant lanes, with `0x13` carrying the keypad
        index - and `0x16:0000` again when the tone ends. So the digit lane
        starts the tone and the silence lane stops it.

        The call-start block uses the same lanes with the same constants, and
        nothing in a single message separates the two uses. What separates
        them here is the line: a digit only means anything while the loop is
        seized and the call has not come up, which is exactly the window the
        dialer runs in.
        """
        if self.exchange is None or self.daa is None:
            return
        if (header, data) == DIAL_SILENCE:
            self._dial_tone_digit = None
            return
        if header != DIAL_TONE_TAG:
            return
        if not self.daa.off_hook or self.exchange.connected:
            return
        index = data & 0xFF
        if index < len(DIAL_TONE_DIGITS):
            self._dial_tone_digit = DIAL_TONE_DIGITS[index]
            self._dial_tone_index = 0

    def _dial_tone_samples(self, count: int) -> list[int]:
        """Render the held digit as line audio for one block."""
        key = DTMF_KEYS.index(self._dial_tone_digit or "1")
        row = DTMF_ROW_FREQUENCIES[key // len(DTMF_COLUMN_FREQUENCIES)]
        column = DTMF_COLUMN_FREQUENCIES[key % len(DTMF_COLUMN_FREQUENCIES)]
        rate = self.exchange.sample_rate
        start = self._dial_tone_index
        self._dial_tone_index += count
        return [
            round(
                DIAL_TONE_LEVEL * math.sin(2 * math.pi * row * index / rate)
                + DIAL_TONE_LEVEL * math.sin(2 * math.pi * column * index / rate)
            )
            for index in range(start, start + count)
        ]

    def _answer_runtime_request(self, header: int, _data: int) -> None:
        """Answer a poll the supervisor's countdown chain has just sent.

        Only the line detector is answered. Its request is the one the chain
        repeats while a line operation is open, and answering it lets the
        firmware count its own five hits instead of having the count written
        underneath it.
        """
        tag = header & 0xFF
        if tag == DETECTOR_TAG and self.daa is not None:
            level = DETECTOR_PRESENT_LEVEL if self.daa.detector_present else 0
            self._queue_runtime_message(DETECTOR_TAG, level)
            self.detector_replies += 1
        elif tag == 0x54 and self.active:
            # 0x6fddd/0x6fe2b poll the call-side ASIC with tag 0x54; the
            # receive callback consumes the reply by sampling ports 5e/5c.
            self._queue_runtime_message(0x0054, 0x0000)

    def _publish_connected_event(self) -> None:
        if self._connected_event_queued:
            return
        # The supervisor floats the runtime window during the call-time DSP
        # reload.  A real ASIC reasserts its ready latch when it publishes the
        # datapump-up event; make that edge visible before queuing the reply.
        self._runtime_mode = True
        self._runtime_ready = True
        # At the same completion boundary the working C52 exposes 5e=22 and
        # 5c=9e.  Publish that ASIC status latch for the answer-side firmware.
        # leaving it at reset zero makes the valid connected event fail.
        if hasattr(self.core, "set_io"):
            self.core.set_io(0x5E, 0x229E)
        self._queue_runtime_message(0x0009, 0x0000)
        # The active runtime table carries status completion under 0x44;
        # 0x4d is only present in the fallback table used during bring-up.
        self._queue_runtime_message(0x0044, 0x0001)
        # Keep the fallback status edge available as well: the resident
        # supervisor consumes it after the active table has latched 0x44.
        self._queue_runtime_message(0x004D, 0x0001)
        if self._call_overlay_active or self._call_resume_pending:
            self._queue_runtime_message(0x001D, 0x0000)
        self._connected_event_queued = True

    def handles(self, port: int) -> bool:
        return (
            port in (0x1C, self.transfer.command_port, *DSP_RUNTIME_PORTS)
            or port in self._lanes
        )

    def write(self, port: int, size: int, value: int, pc: int | None = None) -> None:
        if (
            port in DSP_RUNTIME_PORTS
            and size == 1
            # Under the ROM's protocol these ports carry the upper transfer
            # window until the program is in, and the mailbox only after.
            and not (self.transfer.mailbox_shares_window and not self.active)
        ):
            self._runtime_mode = True
            if port == 0x58:
                self._runtime_header = (self._runtime_header & 0xFF00) | (value & 0xFF)
            elif port == 0x5A:
                self._runtime_header = (self._runtime_header & 0x00FF) | ((value & 0xFF) << 8)
            elif port == 0x5C:
                self._runtime_data = (self._runtime_data & 0xFF00) | (value & 0xFF)
            else:
                self._runtime_data = (self._runtime_data & 0x00FF) | ((value & 0xFF) << 8)
                if self.active:
                    words = (self._runtime_header, self._runtime_data)
                    self.runtime_words_queued += len(words)
                    message = f"{words[0]:04x}:{words[1]:04x}"
                    self.runtime_messages.append(message)
                    self.runtime_message_counts[message] += 1
                    self.runtime_message_first_seen.setdefault(message, self._instructions)
                    self._observe_asic_command(*words)
                    if pc is not None:
                        self.runtime_message_first_pc.setdefault(message, f"{pc:05x}")
                    self._answer_runtime_request(*words)
            return
        if port == 0x1C:
            if (
                self.transfer.checksum_strobe is not None
                and not self.active
                and size == 1
                and (value & 0xFF) == ENTRY_REQUEST_COMPLETE
            ):
                # A ROM's supervisor sets its transfer window up before it
                # requests the entry, and that setup goes through the same
                # window and strobes as the program does - eight 0083 words on
                # the captured board. The entry request ends here, so whatever
                # the window carried before it was configuration, not program.
                self.bootstrap.clear()
            if self._runtime_mode:
                if not (value & 1):
                    self._runtime_ready = False
                    self._runtime_ready_delay = self.batch
                if (
                    not (value & 2)
                    and self._runtime_inbound
                    and self._runtime_inbound_seen
                ):
                    header, data = self._runtime_inbound.popleft()
                    self._runtime_inbound_delivered[f"{header:04x}:{data:04x}"] += 1
                    self._runtime_inbound_seen = False
            return
        placement = self._lanes.get(port)
        if placement is not None:
            strobe, lane = placement
            self._windows[strobe][lane] = value & 0xFF
            return
        if port != self.transfer.command_port or size != 1:
            return
        strobe = value & 0xFF
        if (
            self.transfer.checksum_strobe is not None
            and strobe == self.transfer.checksum_strobe
        ):
            # The ROM's downloader submits its 16-bit word sum here and polls
            # for acceptance. On the part, the DSP's boot ROM checks that sum
            # and jumps to the entry the supervisor requested; that mask ROM
            # is not available, so the jump is performed here instead. An
            # update payload needs no equivalent: it carries a boot block at
            # origin 0, so its reset address is program the core already has.
            self.checksum_submits += 1
            if self.active and not self.launched and hasattr(self.core, "set_pc"):
                self.core.set_pc(self.entry_word)
                self.launched = True
            return
        if strobe not in self._windows:
            return
        window = self._windows[strobe]
        if (
            strobe == self.transfer.first_strobe
            and self.active
            and bytes(window) == self.expected_bootstrap[:8]
        ):
            # The supervisor re-enters its DSP download routine for a line
            # operation. Recognize the program's first transfer window; port
            # 0x1c also carries ordinary handshakes and is not a reset signal
            # by itself.
            self.core.close()
            self.core = NativeC5x(self.image)
            self._configure_frame_interrupt()
            self._call_overlay_active = False
            self._call_resume_pending = self._v8_armed
            self.bootstrap = bytearray(window)
            self.bootstrap_match = None
            self.active = False
            # A fresh core starts at its reset address again, so the entry the
            # boot ROM would jump to has to be reapplied to this download.
            self.launched = False
            self._runtime_mode = False
            self._runtime_ready = False
            self._runtime_ready_delay = 0
            self._x86_ticks = 0
            self._sip_tx_index = 0
            self.transfer_commands += 1
            return
        if not self.active:
            self.transfer_commands += 1
            self.bootstrap.extend(window)
            if len(self.bootstrap) >= self.bootstrap_target_size:
                self.bootstrap_match = (
                    self.bootstrap[:self.bootstrap_target_size]
                    == self.expected_bootstrap[:self.bootstrap_target_size]
                )
                self.active = True
                self.bootstraps += 1
                # A modelled codec reports itself at power up, so the mailbox
                # has to carry traffic from the first download rather than
                # from the dial/answer boundary.
                self._runtime_mode = self.bootstraps >= 2 or self.codec is not None
                self._runtime_ready = self._runtime_mode
                if self.codec is not None and self.bootstraps == 1:
                    # The DAA identity is a power-up report, not a call event.
                    # Without it [0x287] stays zero, which is the value the
                    # firmware's own self-test calls invalid.
                    self._queue_runtime_message(
                        DAA_IDENTITY_TAG, self.codec.codec.revision
                    )
                if self.bootstraps >= 2 and not self._asic_call_engine_started:
                    # Compatibility for images that really do redownload at
                    # the call boundary. Normal main211 calls instead receive
                    # these ready reports when the 0x1f commit edge is seen.
                    self._queue_runtime_message(0x0002, 0x0000)
                    self._queue_runtime_message(0x0003, 0x0000)
                self._publish_window()
                # A line operation can request the datapump before the
                # supervisor performs its call-time redownload. Let the new
                # C52 execute its startup before reapplying that call.
                self._call_resume_pending = self._v8_armed
                # Feed a supplied ASIC line recording only after the
                # supervisor's second bootstrap, the dial/answer boundary.
                if self.bootstraps >= 2 and self.rx_samples and not self._rx_samples_queued:
                    self.core.queue_serial_rx(self.rx_samples)
                    if self._call_overlay_active and hasattr(self.core, "queue_codec_rx"):
                        self.core.queue_codec_rx(self.rx_samples)
                        self._rx_samples_codec_queued = True
                    self._rx_samples_queued = True
                if (
                    self.bootstraps >= 2
                    and self.dial_digits
                    and self.daa is not None
                    and self.daa.operation == "originate"
                    and self.daa.dial_tone_qualified
                    and (
                        self._asic_call_engine_started
                        or self._call_overlay is None
                    )
                ):
                    self.begin_dialing()
                if (
                    self.bootstraps >= 2
                    and self.dial_digits
                    and (self.daa is None or self.daa.operation == "dialing")
                ):
                    self.core.set_dtmf_digits(self.dial_digits)
        else:
            self.mailbox_commands += 1
            self.mailbox_windows[self.window.hex()] += 1
            self._publish_window()

    def read(self, port: int, size: int) -> int | None:
        if port == 0x1C:
            if self._completion_probe:
                return (1 << (size * 8)) - 1
            if getattr(self.image, "supervisor_offset", 0) == 0x17BB0:
                return (1 << (size * 8)) - 1
            # Bit 0 is the board's standing request for a host-to-DSP word.
            # The captured supervisor's mailbox interrupt at 0fda9 answers it
            # by writing the status back to 1c, and clears the bit first only
            # on the path that had nothing to send - so on hardware the commit
            # is the bit written back *set*, and an idle unit reads 1c as fd
            # forever because the request stands unanswered.  This model
            # commits on the 0x5e write instead and uses the bit only to pace
            # the C52's next quantum; the two agree on ordering, not polarity.
            if not self._runtime_mode:
                return (1 << (size * 8)) - 1
            return int(self._runtime_ready) | (2 if self._runtime_inbound else 0)
        if port == self.transfer.command_port:
            # The downloader polls this port for the boot ROM's ready and
            # acceptance bits between groups. They are synthesized, as the
            # boot ROM that drives them is not available.
            return (1 << (size * 8)) - 1
        if port in (0x5C, 0x5E) and self._runtime_inbound:
            # A queued board-to-supervisor message owns the data lanes while
            # it stands. The receive handler at 0x6ad6e reads the tag from
            # 0x58/0x5a and then the word from 0x5e/0x5c, so serving the C52
            # status latch here instead handed the detector consumer 0xffff
            # for a reply the bridge had already queued.
            _, data = self._runtime_inbound[0]
            return (data >> (8 if port == 0x5E else 0)) & 0xFF
        if port in (0x5C, 0x5E) and self.active and hasattr(self.core, "io"):
            # The ASIC exposes the C52's 16-bit status latch as high byte at
            # 5E and low byte at 5C. These are the ports read by the
            # supervisor's rate/status routine; they are not download-window
            # lanes once the call datapump owns the bus.
            word = self.core.io(0x5E)
            if self._connected_event_queued and word == 0:
                word = 0x229E
            return (word >> (8 if port == 0x5E else 0)) & 0xFF
        if port in DSP_RUNTIME_PORTS and self._runtime_inbound:
            header, data = self._runtime_inbound[0]
            word = header if port in (0x58, 0x5A) else data
            if port in (0x58, 0x5A):
                self._runtime_inbound_seen = True
            return (word >> (8 if port in (0x5A, 0x5E) else 0)) & 0xFF
        if not self.active or not self.handles(port):
            return None
        lane = (port - DSP_WINDOW_FIRST) // DSP_WINDOW_STRIDE
        word = self.core.io(0x50 + lane // 2)
        return (word >> (8 * (lane & 1))) & 0xFF

    def _publish_window(self) -> None:
        if self._call_overlay_active:
            return
        for index in range(0, len(self.window), 2):
            word = self.window[index] | (self.window[index + 1] << 8)
            self.core.set_io(0x50 + index // 2, word)

    def clock_x86(self) -> None:
        self._instructions += 1
        if self.exchange is not None:
            # The loop and the exchange behind it exist from board reset, the
            # same as the codec and before any DSP program is downloaded. A
            # line that only rings once the C52 is up is not a line.
            self._service_exchange()
        if self.codec is not None:
            # The codec is on the ASIC's own serial bus, not the DSP's, so its
            # bring-up runs from board reset rather than from the download that
            # starts the C52.
            self._service_codec()
        if not self.active or self.error:
            return
        if self._runtime_mode and not self._runtime_ready:
            if self._runtime_ready_delay > 0:
                self._runtime_ready_delay -= 1
            else:
                self._runtime_ready = True
        self._x86_ticks += 1
        if self._x86_ticks < self.batch:
            return
        # The Courier identifies its split as 20 MHz 80186 / 25 MHz C52.
        dsp_steps = self._x86_ticks * 5 // 4
        self._x86_ticks = 0
        try:
            if self.sip is not None:
                self.sip.poll()
                if self.daa is not None:
                    self.daa.set_call_progress(self.sip.state)
                if self.sip.state == "connected" and not self._connected_event_queued:
                    # The active receive table maps tag 0x09 to the datapump
                    # ready latch at 0x0682 and tag 0x4d to the successful
                    # call-up handler at physical 0x6f85d. A nonzero low data
                    # byte then records the line state, raises the call flag,
                    # and enters the firmware's online setup.
                    self._publish_connected_event()
                self._sip_rx_samples.extend(
                    self._sip_rx_rate.convert(self.sip.receive_audio())
                )
            if self.line is not None:
                self._service_line()
            self._maybe_start_asic_call_engine()
            self._advance_asic_call_phase()
            if (
                self.daa is not None
                and self.daa.off_hook
                and not self.rx_samples
            ):
                serial = self.core.serial_state()
                if self._call_overlay_active:
                    queued = serial.get("codec_rx_queued", 0) - serial.get(
                        "codec_rx_consumed", 0
                    )
                else:
                    queued = serial.get("rx_queued", 0) - serial.get("rx_consumed", 0)
                # The physical DAA continues filling its receive FIFO while
                # the supervisor is still bringing the datapump online. Keep
                # enough board-side audio queued for the five-frame detector
                # debounce; limiting this to one frame deadlocks alternate
                # supervisors whose DSP reports no RX consumption during
                # command parsing.
                queue_limit = (
                    DAA_FRAME_SAMPLES * 5
                    if not self.daa.detector_qualified
                    else DAA_FRAME_SAMPLES
                )
                if queued < queue_limit:
                    count = (
                        DAA_FRAME_SAMPLES if self.line is not None
                        else DAA_FRAME_SAMPLES * 2
                    )
                    samples = []
                    if self._sip_rx_samples:
                        samples = self.daa.render(count)
                        available = min(count, len(self._sip_rx_samples))
                        for index in range(available):
                            samples[index] = self._sip_rx_samples.popleft()
                    elif self._exchange_rx_samples:
                        # The exchange is the line: whatever it puts on the
                        # loop is what the codec hears, tone or far end.
                        available = min(count, len(self._exchange_rx_samples))
                        samples = [
                            self._exchange_rx_samples.popleft()
                            for _ in range(available)
                        ]
                        samples.extend([0] * (count - available))
                    elif self._line_rx_samples:
                        # Use the peer frame as the codec FIFO payload
                        # directly. Mutating a freshly rendered DAA frame
                        # obscured this handoff and left the DSP seeing the
                        # near-zero DAA fallback during V.8.
                        available = min(count, len(self._line_rx_samples))
                        samples = [
                            self._line_rx_samples.popleft()
                            for _ in range(available)
                        ]
                        samples.extend([0] * (count - available))
                    elif self.line is not None or self.exchange is not None:
                        # Do not build a FIFO of synthetic zeroes while the
                        # peer is still producing its first V.8 frame, and
                        # never let the behavioral DAA's tone stand in for a
                        # modeled line that has simply not filled yet.
                        samples = []
                    else:
                        samples = self.daa.render(count)
                    if samples:
                        self._codec_queue_peak = max(
                            self._codec_queue_peak, max(abs(sample) for sample in samples)
                        )
                    if (
                        (self._call_overlay_active or self._call_resume_pending)
                        and hasattr(self.core, "queue_codec_rx")
                    ):
                        # Hold the far-end waveform in the ASIC codec FIFO
                        # across the call-entry boundary. Sending it through
                        # the idle serial FIFO before the overlay is published
                        # discarded the CI/ANSam burst the caller needs.
                        self.core.queue_codec_rx(samples)
                    else:
                        self.core.queue_serial_rx(samples)
                if (
                    self.exchange is None
                    and self.dial_digits
                    and self.daa.operation == "originate"
                    and self.daa.dial_tone_qualified
                    and (
                        self._asic_call_engine_started
                        or self._call_overlay is None
                    )
                ):
                    self.begin_dialing()
            self._maybe_start_answer_engine()
            if self._call_resume_pending:
                self._resume_armed_call()
            self.core.step(dsp_steps)
            if (
                not self._call_overlay_active
                and hasattr(self.core, "call_tdm_active")
                and self.core.call_tdm_active()
            ):
                # The native scheduler has now crossed the recovered entry
                # ABI; only this edge publishes the overlay to bridge users.
                self._call_overlay_active = True
            if self.sip is not None:
                samples = self.core.line_tx_samples(self._sip_tx_index)
                self._sip_tx_index += len(samples)
                if samples:
                    self.sip.send_audio(self._sip_tx_rate.convert(samples))
        except RuntimeError as exc:
            self.error = str(exc)

    def _service_codec(self) -> None:
        """Advance the silicon DAA by one ASIC service frame.

        The frame is the same 100 ms the line link and the DAA already count,
        so the codec's settling and the line's audio share a time base.
        """
        self._codec_instructions += 1
        if self._codec_instructions < LINE_FRAME_INSTRUCTIONS:
            return
        self._codec_instructions = 0
        part = self.codec.codec
        if self.daa is not None:
            part.line_connected = self.daa.line_connected
            part.set_hook(self.daa.off_hook)
        if self.exchange is not None:
            # An attached exchange owns the ring cadence; the standalone ring
            # source is the model for a line with no exchange behind it.
            present = self.exchange.ringing
            part.set_ring(present, present)
        elif self.ring is not None:
            # A 20 Hz ring fits both half cycles inside a 100 ms frame, so a
            # burst shows on both detectors and silence on neither. Resolving
            # RDTP from RDTN would need a frame shorter than the ring period.
            present = self.ring.present(self._instructions)
            part.set_ring(present, present)
        self.codec.service()

    def _service_exchange(self) -> None:
        """Advance the modeled line by one ASIC frame.

        This is the digital ATA path: the exchange takes the hook state and
        the datapump's transmit block, and answers with what the loop carries
        back. Nothing here reads the dialed number out of the firmware - the
        exchange decodes it from the audio, so the DAA's line state follows a
        call the firmware actually placed.
        """
        self._exchange_instructions += 1
        if self._exchange_instructions < LINE_FRAME_INSTRUCTIONS:
            return
        self._exchange_instructions = 0
        off_hook = self.daa is not None and self.daa.off_hook
        samples = self.core.line_tx_samples(self._exchange_tx_index)[:LINE_FRAME_SAMPLES]
        self._exchange_tx_index += len(samples)
        if self._dial_tone_digit is not None:
            # A held dial tone is what the board is putting on the line, so it
            # replaces the datapump's block rather than mixing with it.
            samples = self._dial_tone_samples(LINE_FRAME_SAMPLES)
        elif len(samples) < LINE_FRAME_SAMPLES:
            # The codec clocks whether or not the datapump has a block ready,
            # and what it clocks out is silence. The exchange has to hear that
            # silence: it is the gap that separates two presses of one key.
            samples.extend([0] * (LINE_FRAME_SAMPLES - len(samples)))
        incoming = self.exchange.service(off_hook, samples, LINE_FRAME_SAMPLES)
        if incoming:
            self._line_rx_peak = max(self._line_rx_peak, max(abs(sample) for sample in incoming))
            if (
                (self._call_overlay_active or self._call_resume_pending)
                and hasattr(self.core, "queue_codec_rx")
            ):
                self.core.queue_codec_rx(incoming)
                self._codec_queue_peak = max(
                    self._codec_queue_peak, max(abs(sample) for sample in incoming)
                )
            else:
                self._exchange_rx_samples.extend(incoming)
        self._carrier_probe.extend(incoming)
        self._observe_carrier_audio()
        if self.daa is not None:
            # The DAA reports what the exchange is presenting rather than a
            # state the harness set for it. Dial tone therefore stays on the
            # line until the modem's own digits take it off.
            self.daa.line_state = self.exchange.line_state
            # The five-hit line detector debounces on samples that arrived,
            # and with an exchange attached they arrive from the exchange
            # instead of from the DAA's own generator.
            self.daa.observe(LINE_FRAME_SAMPLES)
            if self.exchange.dialed and self.daa.operation == "originate":
                # Digits on the line are what makes this a dialing seizure.
                self.daa.begin_dialing()
            # What the line heard is the only record of the number here; the
            # bridge no longer reads it out of the command text.
            self.dial_digits = self.exchange.dialed

    def _service_line(self) -> None:
        """Hand one frame to the far end and take its frame off the line.

        The exchange runs on the instruction clock rather than on hook state,
        because a modem waiting on hook still has to keep the far end's run
        moving.
        """
        self._line_instructions += self.batch
        if self._line_instructions < LINE_FRAME_INSTRUCTIONS:
            return
        off_hook = self.daa is not None and self.daa.off_hook
        available = len(self.core.line_tx_samples(self._line_tx_index))
        if (
            off_hook
            and available < LINE_FRAME_SAMPLES
            and not self._call_overlay_active
            and self.daa is not None
            and self.daa.operation == "originate"
        ):
            # Before the call overlay is active, pace seizure from the codec
            # stream rather than the much faster calibrated supervisor clock.
            # Once the real datapump is running, the ASIC frame clock must
            # continue even when its newest block is not complete yet.
            return
        self._line_instructions = 0
        samples = self.core.line_tx_samples(self._line_tx_index)[:LINE_FRAME_SAMPLES]
        self._line_tx_index += len(samples)
        if len(samples) < LINE_FRAME_SAMPLES:
            # Online mode must keep the peer's frame clock alive even while a
            # callback transition temporarily leaves the datapump without a
            # complete fresh block.
            samples.extend([0] * (LINE_FRAME_SAMPLES - len(samples)))
        self.line.exchange(
            LineFrame(
                instructions=self.line.frames * LINE_FRAME_INSTRUCTIONS,
                off_hook=off_hook,
                # A dialing seizure supplies the network-side ring cadence
                # to the far subscriber. This is call progress, not modem
                # carrier audio; the far DAA still has to qualify it.
                ringing=off_hook and self.daa is not None
                and self.daa.operation in ("dialing", "trying"),
                samples=samples,
            )
        )
        incoming = self.line.receive_audio()
        if incoming:
            self._line_rx_peak = max(self._line_rx_peak, max(abs(sample) for sample in incoming))
            if (
                (self._call_overlay_active or self._call_resume_pending)
                and hasattr(self.core, "queue_codec_rx")
            ):
                # Deliver the peer frame at the line exchange boundary. This
                # avoids losing the first CI/ANSam frames between the line
                # socket service and the batched DSP scheduler.
                self.core.queue_codec_rx(incoming)
                self._codec_queue_peak = max(
                    self._codec_queue_peak, max(abs(sample) for sample in incoming)
                )
            else:
                self._line_rx_samples.extend(incoming)
        self._carrier_probe.extend(incoming)
        self._observe_carrier_audio()
        if self.daa is not None:
            # The socket models the small exchange between the two DAAs. An
            # originating seizure hears dial tone until the firmware starts
            # dialing; after that, loop current follows the far-end hook.
            if self.daa.operation == "originate":
                self.daa.line_state = "dial-tone"
            else:
                if self.line.peer_ringing:
                    self.daa.line_state = "ringing"
                else:
                    self.daa.line_state = (
                        "quiet"
                        if self.line.peer_off_hook or self.line.connected
                        else "disconnected"
                    )

    def status(self) -> BridgeStatus:
        return BridgeStatus(
            active=self.active,
            bootstrap_bytes=len(self.bootstrap),
            bootstrap_match=self.bootstrap_match,
            bootstraps=self.bootstraps,
            transfer_commands=self.transfer_commands,
            mailbox_commands=self.mailbox_commands,
            mailbox_windows=dict(self.mailbox_windows.most_common()),
            runtime_messages=list(self.runtime_messages),
            runtime_message_counts=dict(self.runtime_message_counts.most_common()),
            runtime_inbound_delivered=dict(self._runtime_inbound_delivered),
            runtime_message_first_seen=dict(self.runtime_message_first_seen),
            runtime_message_first_pc=dict(self.runtime_message_first_pc),
            runtime_words_queued=self.runtime_words_queued,
            detector_replies=self.detector_replies,
            error=self.error,
            dsp=self._core_state(),
            dsp_host_ports=(
                self.core.io_port_stats()
                if hasattr(self.core, "io_port_stats")
                else {}
            ),
            dsp_memory_map=(
                self.core.memory_map() if hasattr(self.core, "memory_map") else {}
            ),
            asic={
                "registers": {
                    f"{register:02x}": value
                    for register, value in sorted(self.asic_registers.items())
                },
                "writes": {
                    f"{register:02x}": count
                    for register, count in sorted(self.asic_writes.items())
                },
                "call_engine_started": self._asic_call_engine_started,
                "v8_armed": self._v8_armed,
                "commit_edges": self._asic_commit_edges,
                "dsp_register_commits": self._asic_dsp_register_commits,
                "call_overlay_available": self._call_overlay is not None,
                "call_overlay_active": self._call_overlay_active,
                "call_resume_state": self._call_resume_state,
                "connected_event_queued": self._connected_event_queued,
                "carrier_probe_frames": self._carrier_probe_frames,
                "carrier_best_score": round(self._carrier_best_score),
                "negotiation_audio": self._negotiation_audio_status(),
                "dsp_registers": {
                    f"{register:02x}": ((value & 0xFF) << 8) | (value >> 8)
                    for register, value in sorted(self.asic_registers.items())
                    if 0x13 <= register <= 0x1F
                },
                "rate_writes": [
                    event for event in self.core.data_events()
                    if event["address"] in (0x0304, 0x0306, 0x0308, 0x030A, 0x030C)
                ][-32:] if self._rate_trace_enabled and hasattr(self.core, "data_events") else [],
                "call_cell_writes": {
                    f"{address:04x}": self.core.data_write_count(address)
                    for address in (0x0306, 0x039F, 0xA51B, 0xA517, 0xD2A8, 0xFFF8, 0xFFF9)
                } if hasattr(self.core, "data_write_count") else {},
                "call_cells": {
                    f"{address:04x}": self.core.data(address)
                    for address in (
                        0x006F, 0x0304, 0x0306, 0x035C, 0x039F, 0x03C8, 0x03CA, 0x03FE,
                        0x069C, 0x0B26, 0x0B49, 0xA51B, 0xD2A8,
                        0xFFF8, 0xFFF9, 0xFFFA,
                        0xFFFD, 0xFFFE, 0xFFFF,
                    )
                } if hasattr(self.core, "data") else {},
                "control_82": self.asic_registers.get(0x82, 0),
                "line_phase": {
                    0x00: "idle",
                    0x20: "enabled",
                    0x60: "start-strobe",
                    0xA0: "engine-held-enabled",
                }.get(self.asic_registers.get(0x82, 0) & 0xE0, "unknown"),
                # Names describe the sequencing recovered from the firmware.
                # C52 reset is controlled by a separate 0xff56/download path;
                # this hold belongs to the ASIC's line/call engine.
                "line_enable": bool(self.asic_registers.get(0x82, 0) & 0x20),
                "start_strobe": bool(self.asic_registers.get(0x82, 0) & 0x40),
                "engine_hold": bool(self.asic_registers.get(0x82, 0) & 0x80),
                "ring_indicate": bool(self.asic_registers.get(0x83, 0) & 1),
            },
            serial_port=self.core.serial_state(),
            v8_io_events=(
                [event for event in self.core.io_events()
                 if event["port"] in (0x50, 0x52, 0x54, 0x56, 0x58, 0x5A, 0x5C, 0x5E)][-64:]
                if hasattr(self.core, "io_events") else []
            ),
            dsp_pc_trace=(self.core.pc_trace() if hasattr(self.core, "pc_trace") else []),
            dsp_data_events=(
                [event for event in self.core.data_events()
                 if (event["address"] in (0x006f, 0x0304, 0x0306, 0x0308, 0x030a, 0x030c, 0x039f, 0x03c8, 0x03ca, 0x035c, 0x069c, 0x0b49)
                     or 0xa000 <= event["address"] <= 0xd2a8)][-128:]
                if hasattr(self.core, "data_events") else []
            ),
            dial_digits=self.dial_digits,
            daa=self.daa.status() if self.daa is not None else None,
            sip=self.sip.status() if self.sip is not None else None,
            line=(
                {**self.line.status(), "rx_peak": self._line_rx_peak,
                 "codec_queue_peak": self._codec_queue_peak}
                if self.line is not None else None
            ),
            codec=self.codec.status() if self.codec is not None else None,
            exchange=self.exchange.status() if self.exchange is not None else None,
        )

    def save_tx_pcm(self, path: str) -> int:
        samples = self.core.line_tx_samples()
        with open(path, "wb") as output:
            for sample in samples:
                output.write(int(sample).to_bytes(2, "little", signed=True))
        return len(samples)

    def _core_state(self) -> dict[str, int | bool]:
        """The C52's registers, from the last sample if the core is gone.

        A run's summary is built after the machine has closed the bridge, and
        a destroyed handle reports every register as zero. Reporting that as
        the processor's final state said a datapump that had just executed
        millions of instructions had never started.
        """
        if getattr(self.core, "handle", None) is None and self._last_state is not None:
            return self._last_state
        self._last_state = self.core.state()
        return self._last_state

    def close(self) -> None:
        if self.sip is not None:
            self.sip.close()
        if self.line is not None:
            self.line.close()
        # Sample before the handle goes, so a summary built afterwards still
        # reports where the C52 actually got to.
        self._last_state = self.core.state()
        self.core.close()
