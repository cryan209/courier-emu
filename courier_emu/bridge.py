from __future__ import annotations

from collections import Counter, deque
from dataclasses import dataclass
from typing import Any

from .codec import CodecBringUp
from .daa import CourierDaa, DAA_FRAME_SAMPLES, RingSource
from .dsp import NativeC5x
from .line import LINE_FRAME_INSTRUCTIONS, LINE_FRAME_SAMPLES, LineFrame, LineLink
from .sip import RateConverter, SipSession
from .xmf import DSP_BOOT_SIZE, XmfImage


DSP_COMMAND_PORT = 0x1E
DSP_WINDOW_FIRST = 0x40
DSP_WINDOW_LAST = 0x4E
DSP_WINDOW_STRIDE = 2
DSP_RUNTIME_PORTS = (0x58, 0x5A, 0x5C, 0x5E)

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
    runtime_words_queued: int
    detector_replies: int
    error: str | None
    dsp: dict[str, int | bool]
    dsp_host_ports: dict[str, dict[str, int]]
    serial_port: dict[str, int]
    dial_digits: str
    daa: dict[str, str | int | bool] | None
    sip: dict[str, str | int | bool | list[str]] | None
    line: dict[str, Any] | None = None
    codec: dict[str, Any] | None = None


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
    ) -> None:
        self.image = image
        self.expected_bootstrap = image.dsp_program_segments()[0][1]
        self.core = NativeC5x(image)
        self.batch = batch
        self.window = bytearray(b"\xff" * 8)
        self.bootstrap = bytearray()
        self.active = False
        self.bootstrap_match: bool | None = None
        self.bootstraps = 0
        self.transfer_commands = 0
        self.mailbox_commands = 0
        self.mailbox_windows: Counter[str] = Counter()
        self.runtime_messages: deque[str] = deque(maxlen=64)
        self.runtime_words_queued = 0
        self.detector_replies = 0
        self._runtime_mode = False
        self._runtime_ready = False
        self._runtime_ready_delay = 0
        self._runtime_header = 0xFFFF
        self._runtime_data = 0xFFFF
        self._runtime_inbound: deque[tuple[int, int]] = deque()
        self._runtime_inbound_seen = False
        self._connected_event_queued = False
        self.error: str | None = None
        self._x86_ticks = 0
        self.rx_samples = list(rx_samples or [])
        self._rx_samples_queued = False
        self.dial_digits = ""
        self.daa = daa
        self.sip = sip
        self.line = line
        self.codec = codec
        self.ring = ring
        self._instructions = 0
        self._codec_instructions = 0
        self._line_instructions = 0
        self._line_tx_index = 0
        self._line_rx_samples: deque[int] = deque()
        self._sip_tx_index = 0
        self._sip_tx_rate = RateConverter(9_600, 8_000)
        self._sip_rx_rate = RateConverter(8_000, 9_600)
        self._sip_rx_samples: deque[int] = deque()

    def arm_dial_tones(self, command: bytes) -> None:
        text = command.decode("ascii", "ignore").upper()
        if text.startswith("A"):
            if self.daa is not None:
                self.daa.seize("answer")
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
        if (
            self.bootstraps >= 2
            and self.dial_digits
            and (self.daa is None or self.daa.operation == "dialing")
        ):
            self.core.set_dtmf_digits(self.dial_digits)

    def begin_dialing(self) -> None:
        if self.daa is not None:
            self.daa.begin_dialing()
        if self.active and self.dial_digits:
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

    def _queue_runtime_message(self, header: int, data: int) -> None:
        self._runtime_inbound.append((header & 0xFFFF, data & 0xFFFF))

    def _answer_runtime_request(self, header: int, _data: int) -> None:
        """Answer a poll the supervisor's countdown chain has just sent.

        Only the line detector is answered. Its request is the one the chain
        repeats while a line operation is open, and answering it lets the
        firmware count its own five hits instead of having the count written
        underneath it.
        """
        if header & 0xFF != DETECTOR_TAG or self.daa is None:
            return
        level = DETECTOR_PRESENT_LEVEL if self.daa.detector_present else 0
        self._queue_runtime_message(DETECTOR_TAG, level)
        self.detector_replies += 1

    @staticmethod
    def handles(port: int) -> bool:
        return port in (0x1C, DSP_COMMAND_PORT, *DSP_RUNTIME_PORTS) or (
            DSP_WINDOW_FIRST <= port <= DSP_WINDOW_LAST
            and (port - DSP_WINDOW_FIRST) % DSP_WINDOW_STRIDE == 0
        )

    def write(self, port: int, size: int, value: int) -> None:
        if port in DSP_RUNTIME_PORTS and size == 1:
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
                    self.runtime_messages.append(f"{words[0]:04x}:{words[1]:04x}")
                    self._answer_runtime_request(*words)
            return
        if port == 0x1C:
            if self._runtime_mode:
                if not (value & 1):
                    self._runtime_ready = False
                    self._runtime_ready_delay = self.batch
                if (
                    not (value & 2)
                    and self._runtime_inbound
                    and self._runtime_inbound_seen
                ):
                    self._runtime_inbound.popleft()
                    self._runtime_inbound_seen = False
            return
        if DSP_WINDOW_FIRST <= port <= DSP_WINDOW_LAST:
            lane = (port - DSP_WINDOW_FIRST) // DSP_WINDOW_STRIDE
            if 0 <= lane < len(self.window):
                self.window[lane] = value & 0xFF
            return
        if port != DSP_COMMAND_PORT or size != 1 or (value & 0xFF) != 1:
            return
        if self.active and bytes(self.window) == self.expected_bootstrap[:8]:
            # The supervisor re-enters its DSP download routine for a line
            # operation. Recognize the program's first transfer window; port
            # 0x1c also carries ordinary handshakes and is not a reset signal
            # by itself.
            self.core.close()
            self.core = NativeC5x(self.image)
            self.bootstrap = bytearray(self.window)
            self.bootstrap_match = None
            self.active = False
            self._runtime_mode = False
            self._runtime_ready = False
            self._runtime_ready_delay = 0
            self._x86_ticks = 0
            self._sip_tx_index = 0
            self.transfer_commands += 1
            return
        if not self.active:
            self.transfer_commands += 1
            self.bootstrap.extend(self.window)
            if len(self.bootstrap) >= DSP_BOOT_SIZE:
                self.bootstrap_match = self.bootstrap[:DSP_BOOT_SIZE] == self.expected_bootstrap
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
                if self.bootstraps >= 2:
                    # This board's active ISR accepts tags below 0x80. Its
                    # fallback receive table maps 0x02 and 0x03 to the two
                    # coprocessor-ready bits required by the call path.
                    self._queue_runtime_message(0x0002, 0x0000)
                    self._queue_runtime_message(0x0003, 0x0000)
                self._publish_window()
                # Feed a supplied ASIC line recording only after the
                # supervisor's second bootstrap, the dial/answer boundary.
                if self.bootstraps >= 2 and self.rx_samples and not self._rx_samples_queued:
                    self.core.queue_serial_rx(self.rx_samples)
                    self._rx_samples_queued = True
                if (
                    self.bootstraps >= 2
                    and self.dial_digits
                    and self.daa is not None
                    and self.daa.operation == "originate"
                    and self.daa.dial_tone_qualified
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
            # Bit 0 advertises one host-to-DSP transaction.  The host clears
            # it after writing address/value; the board reasserts it after the
            # C52 has had a scheduling quantum to observe the new cell.
            if not self._runtime_mode:
                return (1 << (size * 8)) - 1
            return int(self._runtime_ready) | (2 if self._runtime_inbound else 0)
        if port == DSP_COMMAND_PORT:
            return (1 << (size * 8)) - 1
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
        for index in range(0, len(self.window), 2):
            word = self.window[index] | (self.window[index + 1] << 8)
            self.core.set_io(0x50 + index // 2, word)

    def clock_x86(self) -> None:
        self._instructions += 1
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
                    self._queue_runtime_message(0x0009, 0x0000)
                    self._queue_runtime_message(0x004D, 0x0001)
                    self._connected_event_queued = True
                self._sip_rx_samples.extend(
                    self._sip_rx_rate.convert(self.sip.receive_audio())
                )
            if self.line is not None:
                self._service_line()
            if (
                self.daa is not None
                and self.daa.off_hook
                and not self.rx_samples
            ):
                serial = self.core.serial_state()
                queued = serial.get("rx_queued", 0) - serial.get("rx_consumed", 0)
                if queued < DAA_FRAME_SAMPLES:
                    count = DAA_FRAME_SAMPLES * 2
                    samples = self.daa.render(count)
                    if self._sip_rx_samples:
                        available = min(count, len(self._sip_rx_samples))
                        for index in range(available):
                            samples[index] = self._sip_rx_samples.popleft()
                    if self._line_rx_samples:
                        available = min(count, len(self._line_rx_samples))
                        for index in range(available):
                            samples[index] = self._line_rx_samples.popleft()
                    self.core.queue_serial_rx(samples)
                if (
                    self.bootstraps >= 2
                    and self.dial_digits
                    and self.daa.operation == "originate"
                    and self.daa.dial_tone_qualified
                ):
                    self.begin_dialing()
            self.core.step(dsp_steps)
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
        if self.ring is not None:
            # A 20 Hz ring fits both half cycles inside a 100 ms frame, so a
            # burst shows on both detectors and silence on neither. Resolving
            # RDTP from RDTN would need a frame shorter than the ring period.
            present = self.ring.present(self._instructions)
            part.set_ring(present, present)
        self.codec.service()

    def _service_line(self) -> None:
        """Hand one frame to the far end and take its frame off the line.

        The exchange runs on the instruction clock rather than on hook state,
        because a modem waiting on hook still has to keep the far end's run
        moving.
        """
        self._line_instructions += self.batch
        if self._line_instructions < LINE_FRAME_INSTRUCTIONS:
            return
        self._line_instructions = 0
        off_hook = self.daa is not None and self.daa.off_hook
        samples = self.core.line_tx_samples(self._line_tx_index)[:LINE_FRAME_SAMPLES]
        self._line_tx_index += len(samples)
        self.line.exchange(
            LineFrame(
                instructions=self.line.frames * LINE_FRAME_INSTRUCTIONS,
                off_hook=off_hook,
                ringing=False,
                samples=samples,
            )
        )
        self._line_rx_samples.extend(self.line.receive_audio())
        if self.daa is not None:
            # The far end going off hook is the whole of call setup on a
            # dedicated line: there is loop current or there is not.
            self.daa.line_state = "quiet" if self.line.peer_off_hook else "disconnected"

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
            runtime_words_queued=self.runtime_words_queued,
            detector_replies=self.detector_replies,
            error=self.error,
            dsp=self.core.state(),
            dsp_host_ports=(
                self.core.io_port_stats()
                if hasattr(self.core, "io_port_stats")
                else {}
            ),
            serial_port=self.core.serial_state(),
            dial_digits=self.dial_digits,
            daa=self.daa.status() if self.daa is not None else None,
            sip=self.sip.status() if self.sip is not None else None,
            line=self.line.status() if self.line is not None else None,
            codec=self.codec.status() if self.codec is not None else None,
        )

    def save_tx_pcm(self, path: str) -> int:
        samples = self.core.line_tx_samples()
        with open(path, "wb") as output:
            for sample in samples:
                output.write(int(sample).to_bytes(2, "little", signed=True))
        return len(samples)

    def close(self) -> None:
        if self.sip is not None:
            self.sip.close()
        if self.line is not None:
            self.line.close()
        self.core.close()
