from __future__ import annotations

from collections import Counter, deque
from dataclasses import asdict, dataclass, field
from typing import Any

from .xmf import FLASH_PHYSICAL_BASE, XmfImage
from .bridge import CourierDspBridge
from .codec import CodecBringUp
from .console import SerialConsole
from .daa import INSTRUCTIONS_PER_MS, CourierDaa, RingSource
from .flash import FLASH_SIZE, SERVICE_ERASE, SERVICE_WRITE, ParameterFlash
from .line import LineLink
from .nvram import BIT_DATA, BIT_READY, CourierNvram
from .panel import (
    DEFAULT_BOARD_ID,
    DEFAULT_DIP_CLOSED,
    RING_DETECT_BIT,
    RING_DETECT_PORT,
    STRAP_SENSE_BIT,
    CourierPanel,
)
from .parameters import SECTOR_BASE, SECTOR_SIZE
from .sip import SipSession
from .timers import INT1_VECTOR, TIMER_POLL_INSTRUCTIONS, TimerBlock


ADDRESS_SPACE_SIZE = 0x100000
NVRAM_INPUT_BITS = BIT_DATA | BIT_READY
MAX_SERIAL_BYTES = 64 * 1024
MAX_SERIAL_TRACE_EVENTS = 256
TIMER_IRQ_INSTRUCTION_PERIOD = 4_096
# How long to wait before offering the next typed byte again while the
# command parser is busy with the line before it.
COMMAND_BUSY_COOLDOWN = 256
# The boot block's flash driver is reached here, with an ASCII service
# letter in BL. An update payload does not carry the handler.
FLASH_SERVICE_VECTOR = 0x0A
# The E setting, which the `no-echo` option switch leaves clear at 0x63e93.
ECHO_SETTING = 0x092D
# A command that has stopped making progress is waiting on its DTE - the
# help pager's "Strike a key when ready" spins on two addresses. Recent
# execution this narrow means only a keystroke will move it.
SPIN_UNIQUE_ADDRESSES = 4
# `test byte ptr [0x1cee], 0x20`: the keystroke flag the receive path sets
# at 0x662d7. Every screen that pauses spins on one of these, so they are
# recovered from the image rather than listed - main211 has nine.
KEY_WAIT_TEST = bytes.fromhex("f606ee1c20")
# The firmware's time base. Vector 0x0f - INT3 on the 80186 - enters at
# 5b5e:0b1a, which is a chain of countdowns the rest of the supervisor
# arms and waits on: [0x15b], [0x174], [0x738], [0x742], [0x84f] and
# [0x32d] among them. Nothing on the CPU side produces that edge, so
# without it every firmware timeout waits forever - ATI11 arms 20 ticks
# at 0x62d68 and spins at 0x62d6d because they never elapse.
TICK_VECTOR = 0x0F
# The period that makes the countdowns elapse at a plausible rate. It is
# not driven by default: supplying it changes call timing, and the linked
# pair answers OK where an undriven run reports NO CARRIER, so which of
# those is faithful is still open.
SUGGESTED_TICK_MS = 10
# The other candidate source, and the only one that leaves both of the
# firmware's mutual watchdogs quiet: pace the chain off the DSP frame
# interrupt instead of off a period. The two watchdogs bound the legal ratio
# to between 1/25 and 3 ticks per DSP interrupt, and 1:1 sits inside it. This
# is opt-in because the ratio is a choice within that band rather than a
# measurement, and because it delivers an edge the interrupt controller has
# masked - see "Pacing the chain from the DSP interrupt".
TICK_SOURCES = ("dsp",)


def attention_body(command: bytes) -> bytes | None:
    """Return the body accepted by the Courier DTE attention detector."""
    if len(command) >= 2 and command[:2] in (b"AT", b"at"):
        return command[2:]
    return None


@dataclass
class IoEvent:
    direction: str
    port: int
    size: int
    value: int
    pc: int


@dataclass
class MmioEvent:
    direction: str
    address: int
    size: int
    value: int
    pc: int


@dataclass
class RunResult:
    status: str
    instructions: int
    registers: dict[str, int]
    milestones: list[str] = field(default_factory=list)
    io_events: list[IoEvent] = field(default_factory=list)
    mmio_events: list[MmioEvent] = field(default_factory=list)
    dsp_queue_writes: list[MmioEvent] = field(default_factory=list)
    dsp_queue_write_counts: dict[str, int] = field(default_factory=dict)
    io_event_count: int = 0
    mmio_event_count: int = 0
    io_summary: dict[str, int] = field(default_factory=dict)
    output_latches: dict[str, int] = field(default_factory=dict)
    mmio_summary: dict[str, int] = field(default_factory=dict)
    hot_addresses: list[tuple[int, int]] = field(default_factory=list)
    last_addresses: list[int] = field(default_factory=list)
    serial_text: str = ""
    serial_truncated: bool = False
    serial_input_remaining: int = 0
    serial_interrupts: int = 0
    timer_interrupts: int = 0
    ticks: int = 0
    serial_trace: list[str] = field(default_factory=list)
    console: dict[str, int | bool] | None = None
    accelerated_delays: int = 0
    error: str | None = None
    dsp_bridge: dict[str, Any] | None = None
    panel: dict[str, Any] | None = None
    nvram: dict[str, Any] | None = None
    flash: dict[str, Any] | None = None
    ring: dict[str, int] | None = None
    timers: dict[str, Any] | None = None
    interrupt_vectors: dict[str, str] = field(default_factory=dict)

    def to_dict(self) -> dict[str, Any]:
        value = asdict(self)
        value["hot_addresses"] = [list(item) for item in self.hot_addresses]
        return value


class CourierMachine:
    """A 1 MiB 80186 execution harness with observable board I/O."""

    def __init__(
        self,
        image: XmfImage,
        *,
        port_values: dict[int, int] | None = None,
        runtime_port_values: dict[int, int] | None = None,
        uart_ports: set[int] | None = None,
        max_io_events: int = 128,
        fast_delays: bool = True,
        with_dsp: bool = False,
        dsp_rx_samples: list[int] | None = None,
        dsp_tx_pcm: str | None = None,
        serial_input: bytes = b"",
        daa: CourierDaa | None = None,
        ring: RingSource | None = None,
        codec: CodecBringUp | None = None,
        int1_after_ms: int | None = None,
        sip: SipSession | None = None,
        line: LineLink | None = None,
        nvram: CourierNvram | None = None,
        board_id: int | None = DEFAULT_BOARD_ID,
        dip_closed: frozenset[str] | None = None,
        parameter_sector: bytes | None = None,
        parameter_flash: ParameterFlash | None = None,
        tick_ms: int | None = None,
        tick_source: str | None = None,
        console: SerialConsole | None = None,
    ) -> None:
        self.image = image
        self.nvram = nvram
        self.ring = ring
        self.int1_after_ms = int1_after_ms
        self.int1_delivered = False
        # Measured from the unmask, not from reset: the handler reads the
        # stopwatch the firmware starts just before it unmasks INT1, so this
        # interval is what it calibrates the tick from.
        self._int1_armed_at: int | None = None
        self.parameter_sector = parameter_sector
        self.parameter_flash = parameter_flash
        self._service_resume = False
        self.tick_ms = tick_ms
        if tick_source is not None and tick_source not in TICK_SOURCES:
            choices = ", ".join(TICK_SOURCES)
            raise ValueError(f"invalid tick source {tick_source!r}; choose {choices}")
        self.tick_source = tick_source
        self.ticks = 0
        self._last_tick = 0
        self._tick_owed = False
        self.panel = CourierPanel(
            board_id=board_id,
            dip_closed=DEFAULT_DIP_CLOSED if dip_closed is None else dip_closed,
        )
        self.port_values = dict(port_values or {})
        self.runtime_port_values = dict(runtime_port_values or {})
        self.output_latches: dict[int, int] = {}
        self.uart_ports = set(uart_ports or set())
        self.max_io_events = max_io_events
        self.fast_delays = fast_delays
        self.io_events: list[IoEvent] = []
        self.mmio_events: list[MmioEvent] = []
        self.dsp_queue_writes: list[MmioEvent] = []
        self.dsp_queue_write_counts: Counter[str] = Counter()
        self.io_counts: Counter[tuple[str, int, int]] = Counter()
        self.mmio_counts: Counter[tuple[str, int, int]] = Counter()
        self.serial = bytearray()
        self.serial_truncated = False
        self.serial_rx: deque[int] = deque(serial_input)
        self.console = console
        self.stop_requested = False
        self.serial_interrupts = 0
        self.timer_interrupts = 0
        self.serial_trace: list[str] = []
        self._serial_started = False
        self._serial_irq_requested = False
        self._serial_in_handler = False
        self._serial_irq_mode: str | None = None
        self._serial_tx_pump = False
        self._serial_empty_probes = 0
        self._serial_cooldown = 0
        self._timer_irq_requested = False
        self._timer_in_handler = False
        self._timer_cooldown = TIMER_IRQ_INSTRUCTION_PERIOD
        self._daa_originate_event_posted = False
        # Both firmwares reach the peripheral timers as memory, because the
        # relocation register maps the control block to 0x0ff00.
        # A ROM enters at the reset vector and dispatches its own software
        # interrupts; an update payload is entered directly at the application.
        self.emulate_interrupts = getattr(image, "emulates_interrupts", False)
        self.timers = TimerBlock(fast=fast_delays, answers_reads=self.emulate_interrupts)
        self._timer_interrupt_pending: int | None = None
        self._external_interrupt_pending: int | None = None
        self._previous_address: int | None = None
        self.executed: Counter[int] = Counter()
        self.last_addresses: deque[int] = deque(maxlen=64)
        self.instructions = 0
        self.interrupt: int | None = None
        self.accelerated_delays = 0
        self.milestones: list[str] = []
        if with_dsp and not hasattr(image, "dsp_program_segments"):
            raise ValueError("the DSP bridge needs an XMF payload, not a flash ROM")
        self.dsp_bridge = (
            CourierDspBridge(
                image,
                rx_samples=dsp_rx_samples,
                daa=daa,
                sip=sip,
                line=line,
                codec=codec,
                ring=ring,
            )
            if with_dsp
            else None
        )
        self.dsp_tx_pcm = dsp_tx_pcm
        self._milestone_addresses = {
            0x5B9F0: "supervisor-entry",
            0x69D05: "dsp-transfer",
            0x7E133: "startup-crc",
            0x65512: "main-loop",
        }

    def _capture_serial(self, value: int) -> None:
        if len(self.serial) < MAX_SERIAL_BYTES:
            self.serial.append(value & 0xFF)
        else:
            self.serial_truncated = True
        if self.console is not None:
            self.console.write(value)

    @property
    def _terminal_attached(self) -> bool:
        """Whether the firmware should come up expecting terminal input.

        The board's UART callbacks are installed once, as the supervisor
        reaches its main loop. Queued input is known by then; a console's
        first byte may still be minutes away, so an attached console counts
        as input in its own right.
        """
        return bool(self.serial_rx) or self.console is not None

    def request_stop(self) -> None:
        """Ask the run to finish at the next instruction boundary."""
        self.stop_requested = True

    def _key_wait_tests(self) -> frozenset[int]:
        """Physical addresses of the firmware's keystroke-flag tests."""
        addresses = []
        index = self.image.data.find(KEY_WAIT_TEST)
        while index >= 0:
            addresses.append(self.image.load_base + index)
            index = self.image.data.find(KEY_WAIT_TEST, index + 1)
        return frozenset(addresses)

    def _trace_serial(self, event: str) -> None:
        if len(self.serial_trace) < MAX_SERIAL_TRACE_EVENTS:
            self.serial_trace.append(event)

    def run(self, instruction_limit: int = 250_000) -> RunResult:
        try:
            from unicorn import (
                UC_ARCH_X86,
                UC_HOOK_CODE,
                UC_HOOK_INSN,
                UC_HOOK_INTR,
                UC_HOOK_MEM_READ,
                UC_HOOK_MEM_WRITE,
                UC_MODE_16,
                Uc,
                UcError,
            )
            from unicorn.x86_const import (
                UC_X86_INS_IN,
                UC_X86_INS_OUT,
                UC_X86_REG_AX,
                UC_X86_REG_BP,
                UC_X86_REG_BX,
                UC_X86_REG_CS,
                UC_X86_REG_CX,
                UC_X86_REG_DI,
                UC_X86_REG_DS,
                UC_X86_REG_DX,
                UC_X86_REG_ES,
                UC_X86_REG_FLAGS,
                UC_X86_REG_IP,
                UC_X86_REG_SI,
                UC_X86_REG_SP,
                UC_X86_REG_SS,
            )
        except ImportError as exc:
            raise RuntimeError(
                "execution needs Unicorn: install with `python -m pip install '.[execute]'`"
            ) from exc

        uc = Uc(UC_ARCH_X86, UC_MODE_16)
        uc.mem_map(0, ADDRESS_SPACE_SIZE)
        uc.mem_write(self.image.load_base, self.image.data)
        if self.parameter_sector is not None:
            # The parameter flash is a separate device from the XMF payload;
            # 0x7e07c searches four sectors from 0xf8000 upward.
            uc.mem_write(SECTOR_BASE, self.parameter_sector[:SECTOR_SIZE])
        if self.parameter_flash is not None:
            # A whole part rather than one sector, so the firmware's own
            # writer can rotate between them. Its erased state is 0xff, which
            # is also what its blank check at 0x7e0e3 looks for.
            uc.mem_write(SECTOR_BASE, bytes(self.parameter_flash.data))

        uc.reg_write(UC_X86_REG_CS, self.image.entry_segment)
        uc.reg_write(UC_X86_REG_IP, self.image.entry_offset)
        uc.reg_write(UC_X86_REG_DS, 0)
        uc.reg_write(UC_X86_REG_ES, 0)
        uc.reg_write(UC_X86_REG_SS, 0)
        uc.reg_write(UC_X86_REG_SP, 0xFFFE)

        def current_pc() -> int:
            return ((uc.reg_read(UC_X86_REG_CS) << 4) + uc.reg_read(UC_X86_REG_IP)) & 0xFFFFF

        def reverse_byte(value: int) -> int:
            value = ((value & 0x55) << 1) | ((value >> 1) & 0x55)
            value = ((value & 0x33) << 2) | ((value >> 2) & 0x33)
            return ((value << 4) | (value >> 4)) & 0xFF

        def serial_wire_value(value: int) -> int:
            # Some Courier board revisions wire the UART data bus backwards.
            # The firmware records that variant in bit zero at 0000:067e and
            # reverses every byte in its ISR. Model the wire, while exposing
            # ordinary terminal byte order to callers.
            reversed_bus = bool(bytes(uc.mem_read(0x67E, 1))[0] & 1)
            return reverse_byte(value) if reversed_bus else value

        def inject_serial_interrupt() -> bool:
            vector = bytes(uc.mem_read(0x0E * 4, 4))
            offset = int.from_bytes(vector[:2], "little")
            segment = int.from_bytes(vector[2:], "little")
            if not (offset or segment):
                return False
            flags = uc.reg_read(UC_X86_REG_FLAGS)
            if not flags & 0x0200:
                return False
            ss = uc.reg_read(UC_X86_REG_SS)
            sp = uc.reg_read(UC_X86_REG_SP)
            return_cs = uc.reg_read(UC_X86_REG_CS)
            return_ip = uc.reg_read(UC_X86_REG_IP)

            def push(value: int) -> None:
                nonlocal sp
                sp = (sp - 2) & 0xFFFF
                address = ((ss << 4) + sp) & 0xFFFFF
                uc.mem_write(address, (value & 0xFFFF).to_bytes(2, "little"))

            # 80186 interrupt entry pushes FLAGS, CS, then IP; IRET pops the
            # inverse order. The interrupt controller's EOI remains handled by
            # the firmware at ff02.
            push(flags)
            push(return_cs)
            push(return_ip)
            uc.reg_write(UC_X86_REG_SP, sp)
            uc.reg_write(UC_X86_REG_FLAGS, flags & ~0x0300)
            uc.reg_write(UC_X86_REG_CS, segment)
            uc.reg_write(UC_X86_REG_IP, offset)
            self._serial_irq_mode = "rx" if self.serial_rx else "tx"
            self._serial_in_handler = True
            self._serial_irq_requested = False
            self.serial_interrupts += 1
            self.serial_trace.append(
                f"inject {self._serial_irq_mode} {segment:04x}:{offset:04x} "
                f"return={return_cs:04x}:{return_ip:04x}"
            )
            return True

        def inject_timer_interrupt() -> bool:
            vector = bytes(uc.mem_read(0x0C * 4, 4))
            offset = int.from_bytes(vector[:2], "little")
            segment = int.from_bytes(vector[2:], "little")
            if not (offset or segment):
                return False
            flags = uc.reg_read(UC_X86_REG_FLAGS)
            if not flags & 0x0200:
                return False
            ss = uc.reg_read(UC_X86_REG_SS)
            sp = uc.reg_read(UC_X86_REG_SP)
            return_cs = uc.reg_read(UC_X86_REG_CS)
            return_ip = uc.reg_read(UC_X86_REG_IP)

            # Match 80186 hardware interrupt entry: FLAGS, CS, then IP.
            for value in (flags, return_cs, return_ip):
                sp = (sp - 2) & 0xFFFF
                stack_address = ((ss << 4) + sp) & 0xFFFFF
                uc.mem_write(stack_address, (value & 0xFFFF).to_bytes(2, "little"))
            uc.reg_write(UC_X86_REG_SP, sp)
            uc.reg_write(UC_X86_REG_FLAGS, flags & ~0x0300)
            uc.reg_write(UC_X86_REG_CS, segment)
            uc.reg_write(UC_X86_REG_IP, offset)
            self._timer_irq_requested = False
            self._timer_in_handler = True
            self.timer_interrupts += 1
            return True

        def command_line_pending(_uc: Any) -> bool:
            """Whether the supervisor is still working through a command line.

            The command state machine publishes its state as the callback
            pointer at 0x02ac: a8d9 accepts a line a character at a time, and
            the terminator advances it to a910, which parses the line and
            emits the result. a910 accepts no new line - the firmware's own
            type-ahead flag at 0x1cf2 is what carries one across, and that is
            set by the DTE front-end this harness stands in for.

            Delivering the next line's bytes into that window is what loses
            them: the end-of-command path at a8b1 resets the state, so the
            line is assembled into a buffer nothing goes on to parse. Holding
            them until the state is ready again is what a terminal does, and
            it is the same path the first line of a session already takes.
            """
            return int.from_bytes(_uc.mem_read(0x2AC, 2), "little") == 0xA910

        def serial_frontend_missing(_uc: Any) -> bool:
            """Whether the RX callback has gone back to a board-less default.

            Only the two values board discovery leaves behind count: a null
            vector, or the empty-callback address the profile builder fills
            in. Anything else is a state the firmware chose, which the
            stand-in has no business overwriting.
            """
            if not self._terminal_attached:
                return False
            return int.from_bytes(_uc.mem_read(0x2A8, 2), "little") in (0x0000, 0x1FCE)

        def echo_command_byte(_uc: Any, value: int) -> None:
            """Echo a typed character, as the modem does in command mode.

            The echo setting lives at [0x092d]: `ATE1` sets it, `ATE0`
            clears it, and closing the `no-echo` option switch leaves it
            clear at 0x63e93, which is the switch position that suppresses
            offline command echo on the board. The echo itself belongs to
            the DTE front-end this harness stands in for, so it is emitted
            here, from the firmware's own setting.

            Only a session with a terminal on the other end has anywhere to
            echo to. Queued `--at` input is not typed by anyone, and echoing
            it would put the commands into the captured transcript of runs
            that never had a terminal.
            """
            if self.console is None:
                return
            if not bytes(_uc.mem_read(ECHO_SETTING, 1))[0]:
                return
            self._capture_serial(value)

        key_wait_tests = self._key_wait_tests()

        def waiting_for_keystroke(_uc: Any) -> bool:
            """Whether a running command has stopped for a key from the DTE.

            Transmitting spins just as narrowly as the pager does, so the
            wait has to be identified by what it is testing, not by the fact
            that it repeats: recent execution confined to one of the
            keystroke-flag tests, with the flag itself clear, which is the
            state the pager leaves after clearing it at 0x73810.
            """
            recent = self.last_addresses
            if len(recent) < recent.maxlen:
                return False
            addresses = set(recent)
            if len(addresses) > SPIN_UNIQUE_ADDRESSES:
                return False
            if not addresses & key_wait_tests:
                return False
            return not bytes(_uc.mem_read(0x1CEE, 1))[0] & 0x20

        def discard_line_without_attention(_uc: Any) -> None:
            """Drop a completed line the attention detector never armed on.

            The terminator advances the command state to a910 whatever was
            typed, because the state machine is downstream of the detector.
            On the board, a line that never began with the attention
            sequence is not handed over at all, so the modem answers
            nothing - typing `I3` alone is not `ATI3`. Putting the state
            back to command-line-ready leaves the parser uncalled and no
            result code emitted, which is what the DTE would see.

            `A/` and `A>` are the detector's own two-character forms and
            keep whatever handling they already have.
            """
            if not self._terminal_attached:
                return
            length = bytes(_uc.mem_read(0x1CF4, 1))[0]
            line = bytes(_uc.mem_read(0x1CF5, length)) if length else b""
            if attention_body(line) is not None or line[:2] in (
                b"A/",
                b"a/",
                b"A>",
                b"a>",
            ):
                return
            _uc.mem_write(0x2AC, (0xA8D9).to_bytes(2, "little"))
            _uc.mem_write(0x1CF4, b"\x00")
            self._trace_serial(f"discard {line!r}: no attention prefix")

        def begin_command_line(_uc: Any) -> None:
            """Arm the line collector for a line, as the main-loop hook does.

            The collect flag at 0x1cee bit 0x40 is what makes the receive
            path append to the command buffer at 0x1cf5. The end-of-command
            path clears the whole byte, and the board layer that would set it
            again for the next line is the one being stood in for here, so
            without this a second line is received but never assembled.

            It is also what tells the receive path which of its two jobs to
            do. At 0x662d0 the ISR tests this bit: armed, it appends the
            character to the command buffer; clear, it takes 0x662d7 instead
            and sets bit 0x20, the flag a running command waits on for a
            keystroke. So arm it only for a line the modem is ready to
            collect, and leave a keystroke to reach the command that asked
            for it.
            """
            flags = bytes(_uc.mem_read(0x1CEE, 1))[0]
            if flags & 0x40:
                return
            _uc.mem_write(0x1CEE, bytes((flags | 0x40,)))
            _uc.mem_write(0x1CF4, b"\x00")
            self._trace_serial("collect 1cee|=40")

        def on_code(_uc: Any, address: int, _size: int, _data: Any) -> None:
            if (
                address == 0x6AD6E
                and self.dsp_bridge is not None
                and self.dsp_bridge.pending_runtime_message() is not None
            ):
                header, data = self.dsp_bridge.pending_runtime_message() or (0, 0)
                callback = int.from_bytes(_uc.mem_read(0x2DA, 2), "little")
                self._trace_serial(
                    f"dsp-rx {header:04x}:{data:04x} callback={callback:04x}"
                )
            if self._serial_started and address == 0x65F03:
                # The physical DTE front-end recognizes the attention prefix
                # before handing a command body to this banked parser. Our
                # direct UART ISR path bypasses that small state machine, so
                # reproduce its observable contract here: the parser receives
                # the bytes after an all-upper or all-lower "AT" prefix.
                length = bytes(_uc.mem_read(0x1CF4, 1))[0]
                command = bytes(_uc.mem_read(0x1CF5, length))
                body = attention_body(command)
                if body is not None:
                    _uc.mem_write(0x1CF5, body + b"\x00\x00")
                    _uc.mem_write(0x1CF4, bytes((len(body),)))
                    self._trace_serial(f"attention body={body!r}")
                    if self.dsp_bridge is not None:
                        self.dsp_bridge.arm_dial_tones(body)
            # 5b5e:184b transmits AL through the 80186 integrated UART. Both of
            # its wait edges (5b5e:1874 and 5b5e:1884) branch back to the
            # routine's own entry, so a byte passes 0x5ce2b once per spin but
            # is only accepted at 0x5ce66, just before the parity transform and
            # the write to the transmit register. Capture there so each byte is
            # recorded exactly once.
            if self._serial_started and address == 0x5CE66:
                raw = _uc.reg_read(UC_X86_REG_AX) & 0xFF
                # The transform at 5b5e:1913 recomputes bit 7 as an even-parity
                # bit whenever [0x26c6] is zero, then applies the [0x0936]
                # framing. In those framings bit 7 carries no data, so report
                # the seven bits a receiving DTE would keep.
                parity_framing = bytes(_uc.mem_read(0x26C6, 1))[0] == 0
                terminal_value = raw & 0x7F if parity_framing else raw
                self._capture_serial(terminal_value)
                self._trace_serial(f"fifo {terminal_value:02x} pc={current_pc():05x}")
            if address == 0x5D5B0 and len(self.serial_trace) < 64:
                self.serial_trace.append("entered-uart-isr")
            if self._serial_in_handler and self._previous_address in (0x5D608, 0x5D640):
                self.serial_trace.append(f"iret {self._previous_address:05x}")
                callbacks = bytes(_uc.mem_read(0x2A8, 6))
                rx_callback = int.from_bytes(callbacks[:2], "little")
                tx_callback = int.from_bytes(callbacks[2:4], "little")
                command_callback = int.from_bytes(callbacks[4:6], "little")
                command_state = bytes(_uc.mem_read(0x1CEE, 7))
                self.serial_trace.append(
                    f"state rxcb={rx_callback:04x} txcb={tx_callback:04x} "
                    f"cmdcb={command_callback:04x} "
                    f"flags={command_state[0]:02x} len={command_state[6]:02x}"
                )
                if command_callback == 0xA910:
                    discard_line_without_attention(_uc)
                self._serial_in_handler = False
                self._serial_irq_mode = None
                self._serial_cooldown = 128 if self.serial_rx else 512
            if self._timer_in_handler and self._previous_address in (0x6ADF1, 0x6ADF8):
                self._timer_in_handler = False
                self._timer_cooldown = TIMER_IRQ_INSTRUCTION_PERIOD
                if self.tick_source == "dsp":
                    # One tick per DSP frame, taken after that handler's own
                    # iret so the two never nest.
                    self._tick_owed = True
            self.instructions += 1
            if self.console is not None and not self.instructions % self.console.poll_instructions:
                typed = self.console.poll()
                if typed:
                    self.serial_rx.extend(typed)
                    # Input that lands mid-cooldown would otherwise wait out a
                    # transmit-side pause of up to 4096 instructions.
                    self._serial_cooldown = min(self._serial_cooldown, 64)
                if self.console.closed:
                    self.stop_requested = True
            if self.stop_requested:
                _uc.emu_stop()
            self.executed[address] += 1
            self.last_addresses.append(address)
            if self.dsp_bridge is not None:
                self.dsp_bridge.clock_x86()
            milestone = self._milestone_addresses.get(address)
            if milestone is not None and milestone not in self.milestones:
                self.milestones.append(milestone)
                if milestone == "main-loop":
                    self.port_values.update(self.runtime_port_values)
            if milestone == "main-loop" and (
                not self._serial_started or serial_frontend_missing(_uc)
            ):
                # The selected UART board normally installs these near-call
                # vectors. With all unknown board-ID inputs reading high, the
                # firmware reaches its dispatcher without selecting a UART
                # variant, leaving null vectors that jump to the fatal entry.
                # Install the standard command-mode RX, empty-TX, and no-op
                # acknowledge callbacks only when board discovery left them
                # unset.
                #
                # A reset - ATZ, or a profile reload - rebuilds this table
                # from the same board-less defaults, so the stand-in has to
                # go back in every time the firmware returns to its main loop
                # without it. Installing it once left the DTE deaf for the
                # rest of the session after the first ATZ.
                serial_callbacks = ((0x2A8, 0xACDF), (0x2AA, 0x1FCE), (0x2AE, 0x2088))
                for pointer, fallback in serial_callbacks:
                    if pointer == 0x2A8 and self._terminal_attached:
                        _uc.mem_write(pointer, fallback.to_bytes(2, "little"))
                        self.serial_trace.append(f"callback {pointer:03x}={fallback:04x}")
                    elif bytes(_uc.mem_read(pointer, 2)) == b"\x00\x00":
                        _uc.mem_write(pointer, fallback.to_bytes(2, "little"))
                        self.serial_trace.append(f"callback {pointer:03x}={fallback:04x}")
                if self._terminal_attached:
                    command_flags = bytes(_uc.mem_read(0x1CEE, 1))[0] | 0x40
                    _uc.mem_write(0x1CEE, bytes((command_flags,)))
                    # a8d9 is the supervisor's command-line-ready state: RX
                    # event 8 (the configured terminator) advances it to a910,
                    # whose next dispatcher poll invokes the AT parser over
                    # the buffer at 1cf5.
                    _uc.mem_write(0x2AC, (0xA8D9).to_bytes(2, "little"))
                    self.serial_trace.append("callback 2ac=a8d9")
                self._serial_started = True
                self._serial_tx_pump = not self.serial_rx
                self._serial_empty_probes = 0
                self._serial_cooldown = 512
            # The fatal-error blinker uses a calibrated self-looping LOOP.
            if self.fast_delays and address == 0x5C772:
                _uc.reg_write(UC_X86_REG_CX, 1)
                self.accelerated_delays += 1
            # The 80186 peripheral block has just been relocated to ff00. The
            # startup waits for timer/status bit 0x20, which a CPU-only core
            # cannot produce.
            if self.fast_delays and address == 0x5BA29:
                value = int.from_bytes(_uc.mem_read(0xFF46, 2), "little")
                _uc.mem_write(0xFF46, (value | 0x20).to_bytes(2, "little"))
                self.accelerated_delays += 1
            # The coprocessor bootstrap resets its transfer interface and
            # waits here until both status words float to all ones. Dynamic
            # ATD/ATA traces reach this during startup only: calls manipulate
            # ASIC register 0x82 but do not perform a second C52 download.
            if address == 0x69C61 and self.dsp_bridge is not None:
                self.dsp_bridge.float_runtime_bus()
            # Firmware delay helpers either burn CX or wait for the timer ISR
            # to advance the tick at 0000:0152. Advance both without inventing
            # asynchronous interrupts in the CPU-only harness.
            if self.fast_delays and address == 0x5C0F3:
                _uc.reg_write(UC_X86_REG_CX, 1)
                self.accelerated_delays += 1
            if self.fast_delays and address == 0x5C0E3:
                ah = (_uc.reg_read(UC_X86_REG_AX) >> 8) & 0xFF
                _uc.mem_write(0x152, bytes((ah,)))
                self.accelerated_delays += 1
            if self.fast_delays and address in (0x5D6E5, 0x5D70E, 0x5D734):
                cl = _uc.reg_read(UC_X86_REG_CX) & 0xFF
                _uc.mem_write(0x14E, bytes((cl,)))
                self.accelerated_delays += 1
            # Command-mode initialization also waits directly on the 10 ms
            # timer countdown at 0000:0289 instead of using the delay helper.
            # With the countdown chain paced, the poller that feeds [0x649] is
            # running and the bridge answers it, so both the count and the
            # wait it runs inside are the firmware's own. Writing either one
            # here would only hide whether that path works.
            if (
                self.fast_delays
                and self.tick_source is None
                and address in (0x5DB9D, 0x5DBE7)
            ):
                daa = self.dsp_bridge.daa if self.dsp_bridge is not None else None
                if address == 0x5DBE7 and daa is not None and daa.detector_present:
                    if daa.detector_qualified:
                        # 0x0649 is the recovered five-hit line detector
                        # counter, consumed by the supervisor's originate loop
                        # and by the answer path that reaches the same wait.
                        _uc.mem_write(0x649, b"\x05")
                        self._trace_serial(
                            f"daa {daa.operation}-qualified 0649=05"
                        )
                        if daa.operation != "answer":
                            self.dsp_bridge.begin_dialing()
                else:
                    _uc.mem_write(0x289, b"\x00\x00")
                self.accelerated_delays += 1
            # After dial-tone qualification the dialer waits on the S6-style
            # pre-dial countdown at 0000:08d6, normally decremented by the
            # board timer ISR.
            if self.fast_delays and address == 0x828A6:
                _uc.mem_write(0x8D6, b"\x00\x00")
                self.accelerated_delays += 1
            # Successful completion of the originating dialer returns through
            # 0x828ae.  On hardware the board-side line event posts dispatcher
            # event 3 at 0x1cf1, whose target at 0x65c61 enters the supervisor's
            # online/originate path.  The CPU-only timer model has no producer
            # for that event, leaving ATD parked in command mode after the
            # digits.  Reproduce the recovered event edge once per seizure.
            if (
                address == 0x828AE
                and not self._daa_originate_event_posted
                and self.dsp_bridge is not None
                and self.dsp_bridge.daa is not None
                and self.dsp_bridge.daa.off_hook
                and self.dsp_bridge.daa.operation == "dialing"
            ):
                _uc.mem_write(0x1CF1, b"\x03")
                self._daa_originate_event_posted = True
                self._trace_serial("daa originate-event 1cf1=03")
            # Inter-digit cadence uses the timer word at 0000:0161.
            if self.fast_delays and address in (0x6355F, 0x822E0, 0x82342, 0x8235B):
                _uc.mem_write(0x161, b"\x00\x00")
                self.accelerated_delays += 1
            # The same initialization waits for an 80186 peripheral-ready
            # indication in the relocated interrupt-control block.
            # The integrated UART's transmit-holding register never drains in a
            # CPU-only core, so the ready poll at 5b5e:186e finds status bit
            # 0x08 clear and spins on the transmit routine forever. This is a
            # missing device rather than a calibrated delay, so the modeled DTE
            # reports itself ready regardless of --real-delays.
            if address == 0x5CE4E:
                value = int.from_bytes(_uc.mem_read(0xFF66, 2), "little")
                if not value & 0x08:
                    _uc.mem_write(0xFF66, (value | 0x08).to_bytes(2, "little"))
            if self.fast_delays and address == 0x5CE19:
                value = int.from_bytes(_uc.mem_read(0xFF66, 2), "little")
                _uc.mem_write(0xFF66, (value | 0x08).to_bytes(2, "little"))
                self.accelerated_delays += 1
            if self._serial_started and not self._serial_in_handler:
                if self._serial_cooldown:
                    self._serial_cooldown -= 1
                elif self.serial_rx:
                    if _uc.reg_read(UC_X86_REG_FLAGS) & 0x0200:
                        executing = command_line_pending(_uc)
                        if serial_frontend_missing(_uc):
                            # A reset tears the callback table down and
                            # rebuilds it on the way back to the main loop.
                            # A byte delivered in that window enters the ISR
                            # at 5d5b0, which dispatches through the nulled
                            # RX callback into the fatal entry at 5b5e:0000
                            # and blinks an error 0x0b for the rest of the
                            # session. Wait for the front-end instead.
                            self._serial_cooldown = COMMAND_BUSY_COOLDOWN
                        elif executing and not waiting_for_keystroke(_uc):
                            # A command is running and still getting on with
                            # it, so this is type-ahead: hold it for the
                            # command-line-ready state, the only one that
                            # collects a line.
                            self._serial_cooldown = COMMAND_BUSY_COOLDOWN
                        else:
                            # Either the modem is ready for a line, or a
                            # command has stopped on a keystroke it is
                            # waiting for - `AT$` and the other help pages
                            # end each screen that way.
                            if not executing:
                                begin_command_line(_uc)
                            self._serial_irq_requested = True
                            _uc.emu_stop()
                elif self._serial_tx_pump:
                    tx_callback = int.from_bytes(_uc.mem_read(0x2AA, 2), "little")
                    if tx_callback not in (0, 0x1FCE):
                        if _uc.reg_read(UC_X86_REG_FLAGS) & 0x0200:
                            self._serial_irq_requested = True
                            _uc.emu_stop()
            if (
                self._serial_started
                and not self._serial_in_handler
                and not self._timer_in_handler
                and not self._serial_irq_requested
                and (self.dsp_bridge is None or self.dsp_bridge.active)
            ):
                dsp_interrupt_pending = (
                    self.dsp_bridge is not None
                    and self.dsp_bridge.pending_runtime_message() is not None
                )
                if self._timer_cooldown and not dsp_interrupt_pending:
                    self._timer_cooldown -= 1
                elif _uc.reg_read(UC_X86_REG_FLAGS) & 0x0200:
                    self._timer_irq_requested = True
                    _uc.emu_stop()
            if self.emulate_interrupts and not self.instructions % TIMER_POLL_INSTRUCTIONS:
                self.timers.tick(self.instructions)
                interrupts_on = bool(_uc.reg_read(UC_X86_REG_FLAGS) & 0x0200)
                if (
                    not self.int1_delivered
                    and self.int1_after_ms is not None
                    and self.timers.controller.enabled("int1")
                    and self._int1_armed_at is None
                ):
                    self._int1_armed_at = self.instructions
                if (
                    not self.int1_delivered
                    and self._int1_armed_at is not None
                    and self.instructions - self._int1_armed_at
                    >= self.int1_after_ms * INSTRUCTIONS_PER_MS
                    and interrupts_on
                    and self.timers.controller.enabled("int1")
                    and self._external_interrupt_pending is None
                ):
                    self._external_interrupt_pending = INT1_VECTOR
                    self.int1_delivered = True
                    _uc.emu_stop()
                elif (
                    self._timer_interrupt_pending is None
                    and self.timers.pending_interrupt() is not None
                    and interrupts_on
                ):
                    self._timer_interrupt_pending = self.timers.take_interrupt()
                    _uc.emu_stop()
            if (
                self._serial_started
                and self.tick_ms
                and not self.emulate_interrupts
                and not self._serial_in_handler
                and not self._timer_in_handler
                and self._external_interrupt_pending is None
                and self.instructions - self._last_tick
                >= self.tick_ms * INSTRUCTIONS_PER_MS
                and _uc.reg_read(UC_X86_REG_FLAGS) & 0x0200
                # This firmware keeps int3 masked throughout, so nothing is
                # delivered here today. Honouring the mask is the point: an
                # edge the firmware has switched off is one the board cannot
                # take, and delivering it anyway is what turned the linked
                # pair's ATA from NO CARRIER into OK.
                and self.timers.controller.enabled("int3")
            ):
                # The board's periodic edge, which the supervisor's countdown
                # chain hangs off. A ROM run reaches its own time base from
                # the reset vector, so this stands in only for a payload run.
                self._last_tick = self.instructions
                self._external_interrupt_pending = TICK_VECTOR
                self.ticks += 1
                _uc.emu_stop()
            if (
                self._tick_owed
                and not self._serial_in_handler
                and not self._timer_in_handler
                and self._external_interrupt_pending is None
                and _uc.reg_read(UC_X86_REG_FLAGS) & 0x0200
            ):
                # The DSP-paced source deliberately does not consult the
                # int3 mask: what it models is a board that generates this
                # edge from the same source as the DSP frame rather than from
                # the 80186 pin the firmware masked.
                self._tick_owed = False
                self._last_tick = self.instructions
                self._external_interrupt_pending = TICK_VECTOR
                self.ticks += 1
                _uc.emu_stop()
            self._previous_address = address

        def on_in(_uc: Any, port: int, size: int, _data: Any) -> int:
            mask = (1 << (size * 8)) - 1
            if self._serial_started and port == 0 and size == 1:
                value = self.output_latches.get(0, 0) & ~0x08
                if self._serial_irq_mode == "rx" and self.serial_rx:
                    value |= 0x08
                if len(self.serial_trace) < 64:
                    self.serial_trace.append(
                        f"status {value:02x} mode={self._serial_irq_mode} pc={current_pc():05x}"
                    )
            elif (
                self._serial_started
                and port == 0x0A
                and size == 1
                and self._serial_irq_mode == "rx"
                and self.serial_rx
            ):
                terminal_value = self.serial_rx.popleft()
                value = serial_wire_value(terminal_value)
                terminator = bytes(_uc.mem_read(0x8E3, 1))[0]
                self.serial_trace.append(
                    f"rx terminal={terminal_value:02x} wire={value:02x} "
                    f"terminator={terminator:02x} pc={current_pc():05x}"
                )
                echo_command_byte(_uc, terminal_value)
                if not self.serial_rx:
                    self._serial_tx_pump = True
            else:
                bridged = self.dsp_bridge.read(port, size) if self.dsp_bridge is not None else None
                value = self.port_values.get(port, bridged if bridged is not None else mask)
                if port in (0x10, 0x12, 0x14) and size == 1:
                    # A closed option switch pulls its latch input bit low.
                    value &= ~self.panel.dip_input(port)
                if self.panel.board_id is not None and port == 0x14 and size == 1:
                    # The identification scan at 0x5bfc6 reads its sense line
                    # here while holding one drive line low.
                    if self.panel.strap_sense():
                        value |= STRAP_SENSE_BIT
                    else:
                        value &= ~STRAP_SENSE_BIT
                if port == RING_DETECT_PORT and size == 1:
                    # The answer machine polls the ring detector here with a
                    # direct `in al, 0x14` at 0x70fb4 and 0x70fc1. An idle
                    # subscriber line is not ringing, and leaving the bit
                    # floating high reads as a ring that never ends, which
                    # parks that state machine in its first state forever.
                    if self.ring is not None and self.ring.present(self.instructions):
                        value |= RING_DETECT_BIT
                    else:
                        value &= ~RING_DETECT_BIT
                if self.nvram is not None and port == 0x10 and size == 1:
                    # Board latch 0 reads back the settings EEPROM's ready and
                    # data-out pins; every other bit keeps its floating level.
                    value = (value & ~(NVRAM_INPUT_BITS)) | self.nvram.read_latch()
            value &= mask
            self._record_io("in", port, size, value, current_pc())
            return value

        def on_out(_uc: Any, port: int, size: int, value: int, _data: Any) -> None:
            mask = (1 << (size * 8)) - 1
            value &= mask
            self.output_latches[port] = value
            pc = current_pc()
            self._record_io("out", port, size, value, pc)
            if size == 1:
                self.panel.observe_write(port, value, pc, self.instructions)
                if self.nvram is not None and port == 0x10:
                    self.nvram.write_latch(value)
            if 0xFF00 <= port <= 0xFFFF:
                # The boot block programs the peripheral control block through
                # I/O space, before the relocation register moves it into
                # memory, so the same model has to see both.
                self.timers.write(port, size, value, self.instructions)
            if self.dsp_bridge is not None:
                self.dsp_bridge.write(port, size, value, pc)
            if port in self.uart_ports:
                self._capture_serial(value)
            if (
                self._serial_started
                and self._serial_irq_mode == "tx"
                and port == 0x0A
                and size == 1
            ):
                terminal_value = serial_wire_value(value & 0xFF)
                if terminal_value == 0xFF:
                    self.serial_trace.append(f"tx-idle pc={current_pc():05x}")
                    self._serial_empty_probes += 1
                    self._serial_tx_pump = self._serial_empty_probes < 3
                    self._serial_cooldown = 4096
                else:
                    self.serial_trace.append(f"tx {terminal_value:02x} pc={current_pc():05x}")
                    self._capture_serial(terminal_value)
                    self._serial_empty_probes = 0
                    self._serial_tx_pump = True

        def service_parameter_flash(_uc: Any) -> bool:
            """Answer the boot block's flash call, which an XMF lacks.

            BL carries the service letter and ES selects the sector. Only the
            two the parameter store uses are answered; anything else is left
            to stop the run, because a guessed answer to a firmware-update
            service would corrupt an image rather than fail visibly.
            """
            if self.parameter_flash is None:
                return False
            service = _uc.reg_read(UC_X86_REG_BX) & 0xFF
            if service not in (SERVICE_ERASE, SERVICE_WRITE):
                return False
            physical = (_uc.reg_read(UC_X86_REG_ES) << 4) & 0xFFFFF
            if not SECTOR_BASE <= physical < SECTOR_BASE + FLASH_SIZE:
                return False
            offset = physical - SECTOR_BASE
            if service == SERVICE_ERASE:
                start, size = self.parameter_flash.erase_sector(offset)
                _uc.mem_write(SECTOR_BASE + start, bytes([0xFF] * size))
                self._trace_serial(f"flash erase sector {start // SECTOR_SIZE}")
            else:
                target = offset + _uc.reg_read(UC_X86_REG_DI)
                if not 0 <= target < FLASH_SIZE - 1:
                    return False
                value = _uc.reg_read(UC_X86_REG_AX) & 0xFFFF
                programmed = self.parameter_flash.program_word(target, value)
                _uc.mem_write(
                    SECTOR_BASE + target, programmed.to_bytes(2, "little")
                )
                _uc.reg_write(UC_X86_REG_DI, (_uc.reg_read(UC_X86_REG_DI) + 2) & 0xFFFF)
            # Both report success by returning with carry clear; the writer
            # at 0x7dfb3 abandons the sector on carry.
            _uc.reg_write(
                UC_X86_REG_FLAGS, _uc.reg_read(UC_X86_REG_FLAGS) & ~0x0001
            )
            return True

        def on_interrupt(_uc: Any, number: int, _data: Any) -> None:
            if number == FLASH_SERVICE_VECTOR and service_parameter_flash(_uc):
                # The hook already reports IP past the `int`, so resuming
                # from here is resuming after the call the service answered.
                self._service_resume = True
                _uc.emu_stop()
                return
            self.interrupt = number
            _uc.emu_stop()

        def dispatch_interrupt(number: int, *, software: bool = True) -> int:
            """Take a real-mode software interrupt through the vector table.

            The ROM's boot block copies itself over the bottom of memory, so
            the first 0x400 bytes of that copy are the vector table it then
            enters through.
            """
            ip = uc.reg_read(UC_X86_REG_IP)
            cs = uc.reg_read(UC_X86_REG_CS)
            ss = uc.reg_read(UC_X86_REG_SS)
            sp = uc.reg_read(UC_X86_REG_SP)
            flags = uc.reg_read(UC_X86_REG_FLAGS) & 0xFFFF
            # `int n` is two bytes and resumes after itself; a hardware
            # interrupt resumes at the instruction it interrupted.
            resume = (ip + 2) & 0xFFFF if software else ip
            for value in (flags, cs, resume):
                sp = (sp - 2) & 0xFFFF
                uc.mem_write((ss * 16 + sp) & 0xFFFFF, value.to_bytes(2, "little"))
            uc.reg_write(UC_X86_REG_SP, sp)
            vector = bytes(uc.mem_read(number * 4, 4))
            offset = int.from_bytes(vector[:2], "little")
            segment = int.from_bytes(vector[2:], "little")
            if not software:
                uc.reg_write(UC_X86_REG_FLAGS, flags & ~0x0200)
            uc.reg_write(UC_X86_REG_CS, segment)
            uc.reg_write(UC_X86_REG_IP, offset)
            return (segment * 16 + offset) & 0xFFFFF

        def on_mmio_read(_uc: Any, _access: int, address: int, size: int, _value: int, _data: Any) -> None:
            self.mmio_counts[("read", address, size)] += 1
            # The hook runs before the read is satisfied, so a timer register
            # is answered by putting the modelled value where the read will
            # find it. Everything else in the control block stays plain memory.
            modelled = self.timers.read(address, size, self.instructions)
            if modelled is not None:
                _uc.mem_write(address, modelled.to_bytes(size, "little"))
            if len(self.mmio_events) < self.max_io_events:
                value = int.from_bytes(_uc.mem_read(address, size), "little")
                self.mmio_events.append(MmioEvent("read", address, size, value, current_pc()))

        def on_mmio_write(_uc: Any, _access: int, address: int, size: int, value: int, _data: Any) -> None:
            self.mmio_counts[("write", address, size)] += 1
            self.timers.write(address, size, value, self.instructions)
            if len(self.mmio_events) < self.max_io_events:
                self.mmio_events.append(MmioEvent("write", address, size, value, current_pc()))

        def on_dsp_queue_write(
            _uc: Any, _access: int, address: int, size: int, value: int, _data: Any
        ) -> None:
            # The board-command producer writes a pending word at 0x02ca or
            # entries in the 24-word ring at 0x02e0..0x030f. Keep this trace
            # separate from peripheral MMIO so the producer PCs survive long
            # runs whose ordinary I/O trace has already filled.
            pc = current_pc()
            source = ""
            if pc in (0x5D79E, 0x6B083):
                # These are the stores inside the pending-word and ring-queue
                # helpers. Their saved near return addresses identify the
                # actual command producers.
                sp = _uc.reg_read(UC_X86_REG_SP)
                ss = _uc.reg_read(UC_X86_REG_SS)
                stack_skip = 4 if pc == 0x5D79E else 6
                return_offset = int.from_bytes(
                    _uc.mem_read(((ss << 4) + sp + stack_skip) & 0xFFFFF, 2), "little"
                )
                cs = _uc.reg_read(UC_X86_REG_CS)
                caller = ((cs << 4) + return_offset) & 0xFFFFF
                source = f" caller={caller:05x}"
                if caller in (0x5D76A, 0x6B066):
                    outer_skip = stack_skip + 2
                    outer_offset = int.from_bytes(
                        _uc.mem_read(((ss << 4) + sp + outer_skip) & 0xFFFFF, 2),
                        "little",
                    )
                    outer_segment = cs
                    if caller == 0x5D76A:
                        outer_segment = int.from_bytes(
                            _uc.mem_read(
                                ((ss << 4) + sp + outer_skip + 2) & 0xFFFFF, 2
                            ),
                            "little",
                        )
                    source += (
                        f" producer={((outer_segment << 4) + outer_offset) & 0xFFFFF:05x}"
                    )
            self.dsp_queue_write_counts[
                f"pc={pc:05x}{source} address={address:04x} size={size} "
                f"value={value:0{size * 2}x}"
            ] += 1
            self.dsp_queue_writes.append(
                MmioEvent("write", address, size, value, pc)
            )
            if len(self.dsp_queue_writes) > self.max_io_events:
                del self.dsp_queue_writes[0]

        uc.hook_add(UC_HOOK_CODE, on_code)
        uc.hook_add(UC_HOOK_INSN, on_in, None, 1, 0, UC_X86_INS_IN)
        uc.hook_add(UC_HOOK_INSN, on_out, None, 1, 0, UC_X86_INS_OUT)
        uc.hook_add(UC_HOOK_INTR, on_interrupt)
        uc.hook_add(UC_HOOK_MEM_READ, on_mmio_read, None, 0xFF00, 0xFFFF)
        uc.hook_add(UC_HOOK_MEM_WRITE, on_mmio_write, None, 0xFF00, 0xFFFF)
        uc.hook_add(UC_HOOK_MEM_WRITE, on_dsp_queue_write, None, 0x02CA, 0x030F)

        status = "instruction-limit"
        error: str | None = None
        try:
            begin = self.image.entry_physical
            while self.instructions < instruction_limit and not self.stop_requested:
                # A real 80186 wraps segment:offset addresses at 20 bits.  In
                # particular this firmware reaches F800:8000 (linear 1 MiB)
                # during startup and continues at physical zero.  Passing 1
                # MiB as Unicorn's optional stop PC terminates the run at that
                # boundary before Unicorn can apply real-mode wrapping.
                uc.emu_start(begin, 0, count=instruction_limit - self.instructions)
                if self._service_resume:
                    # A flash service was answered in place of the boot
                    # block; resume at the instruction after its call.
                    self._service_resume = False
                    begin = current_pc()
                    continue
                if self.emulate_interrupts and self.interrupt is not None:
                    begin = dispatch_interrupt(self.interrupt)
                    self.interrupt = None
                    continue
                if self._external_interrupt_pending is not None:
                    begin = dispatch_interrupt(
                        self._external_interrupt_pending, software=False
                    )
                    self._external_interrupt_pending = None
                    continue
                if self._timer_interrupt_pending is not None:
                    begin = dispatch_interrupt(
                        self._timer_interrupt_pending, software=False
                    )
                    self._timer_interrupt_pending = None
                    self.timer_interrupts += 1
                    continue
                if not (self._serial_irq_requested or self._timer_irq_requested):
                    break
                if self._serial_irq_requested:
                    injected = inject_serial_interrupt()
                    if not injected:
                        self._serial_cooldown = 64
                        self._serial_irq_requested = False
                else:
                    injected = inject_timer_interrupt()
                    if not injected:
                        self._timer_cooldown = 64
                        self._timer_irq_requested = False
                begin = current_pc()
                if self._serial_in_handler:
                    self.serial_trace.append(f"resume {begin:05x}")
            if self.interrupt is not None:
                status = "software-interrupt"
            elif self.stop_requested:
                status = "stop-requested"
            elif self.instructions < instruction_limit:
                status = "stopped"
            elif "main-loop" in self.milestones:
                status = "main-loop"
        except UcError as exc:
            status = "emulation-error"
            error = str(exc)

        register_ids = {
            "ax": UC_X86_REG_AX,
            "bx": UC_X86_REG_BX,
            "cx": UC_X86_REG_CX,
            "dx": UC_X86_REG_DX,
            "si": UC_X86_REG_SI,
            "di": UC_X86_REG_DI,
            "bp": UC_X86_REG_BP,
            "sp": UC_X86_REG_SP,
            "cs": UC_X86_REG_CS,
            "ip": UC_X86_REG_IP,
            "ds": UC_X86_REG_DS,
            "es": UC_X86_REG_ES,
            "ss": UC_X86_REG_SS,
            "flags": UC_X86_REG_FLAGS,
        }
        registers = {name: uc.reg_read(reg) for name, reg in register_ids.items()}
        final_callbacks = bytes(uc.mem_read(0x2A8, 6))
        self.serial_trace.append(
            "final callbacks="
            + ",".join(
                f"{int.from_bytes(final_callbacks[index:index + 2], 'little'):04x}"
                for index in range(0, 6, 2)
            )
        )
        serial_settings = (0x652, 0x92E, 0x92F, 0x8ED, 0x1FEC, 0x1CF0)
        self.serial_trace.append(
            "final settings="
            + ",".join(f"{address:04x}:{bytes(uc.mem_read(address, 1))[0]:02x}" for address in serial_settings)
        )
        if self.interrupt is not None:
            error = f"software interrupt {self.interrupt:#x}"
        bridge_result = asdict(self.dsp_bridge.status()) if self.dsp_bridge is not None else None
        if self.dsp_bridge is not None and self.dsp_tx_pcm:
            self.dsp_bridge.save_tx_pcm(self.dsp_tx_pcm)
        vector_data = bytes(uc.mem_read(0, 0x400))
        interrupt_vectors: dict[str, str] = {}
        for vector in range(256):
            offset = int.from_bytes(vector_data[vector * 4 : vector * 4 + 2], "little")
            segment = int.from_bytes(vector_data[vector * 4 + 2 : vector * 4 + 4], "little")
            if offset or segment:
                interrupt_vectors[f"{vector:#04x}"] = f"{segment:04x}:{offset:04x}"
        if self.dsp_bridge is not None:
            self.dsp_bridge.close()
        nvram_result = None
        if self.nvram is not None:
            nvram_result = self.nvram.status()
            self.nvram.save()
        flash_result = None
        if self.parameter_flash is not None:
            flash_result = self.parameter_flash.status()
            self.parameter_flash.save()
        console_result = None
        serial_trace = self.serial_trace
        if self.console is not None:
            console_result = self.console.summary()
            self.console.close()
            # A console session traces for as long as someone keeps typing,
            # so report its tail rather than an unbounded transcript.
            serial_trace = serial_trace[-MAX_SERIAL_TRACE_EVENTS:]
        return RunResult(
            status=status,
            instructions=self.instructions,
            registers=registers,
            milestones=self.milestones,
            io_events=self.io_events,
            mmio_events=self.mmio_events,
            dsp_queue_writes=self.dsp_queue_writes,
            dsp_queue_write_counts=dict(self.dsp_queue_write_counts.most_common()),
            io_event_count=sum(self.io_counts.values()),
            mmio_event_count=sum(self.mmio_counts.values()),
            io_summary=self._summarize(self.io_counts),
            output_latches={
                f"{port:#06x}": value for port, value in sorted(self.output_latches.items())
            },
            mmio_summary=self._summarize(self.mmio_counts),
            hot_addresses=self.executed.most_common(20),
            last_addresses=list(self.last_addresses),
            serial_text=self.serial.decode("ascii", "backslashreplace"),
            serial_truncated=self.serial_truncated,
            serial_input_remaining=len(self.serial_rx),
            serial_interrupts=self.serial_interrupts,
            timer_interrupts=self.timer_interrupts,
            ticks=self.ticks,
            serial_trace=serial_trace,
            console=console_result,
            accelerated_delays=self.accelerated_delays,
            error=error,
            dsp_bridge=bridge_result,
            panel=self.panel.status(),
            nvram=nvram_result,
            flash=flash_result,
            ring=self.ring.status() if self.ring is not None else None,
            timers=self.timers.status(),
            interrupt_vectors=interrupt_vectors,
        )

    def _record_io(self, direction: str, port: int, size: int, value: int, pc: int) -> None:
        self.io_counts[(direction, port, size)] += 1
        if len(self.io_events) < self.max_io_events:
            self.io_events.append(IoEvent(direction, port, size, value, pc))

    @staticmethod
    def _summarize(counts: Counter[tuple[str, int, int]]) -> dict[str, int]:
        ordered = sorted(counts.items(), key=lambda item: (-item[1], item[0]))
        return {
            f"{direction} {address:#06x}/{size}": count
            for (direction, address, size), count in ordered
        }
