from __future__ import annotations

from collections import Counter, deque
import re
from dataclasses import asdict, dataclass, field
from typing import Any

from .xmf import FLASH_PHYSICAL_BASE, XmfImage
from .bridge import CourierDspBridge
from .codec import CodecBringUp
from .console import SerialConsole
from .daa import INSTRUCTIONS_PER_MS, CourierDaa, RingSource
from .flash import FLASH_SIZE, SERVICE_ERASE, SERVICE_WRITE, ParameterFlash
from .exchange import LineExchange
from .line import LineLink
from .nvram import BIT_CHIP_SELECT, BIT_CLOCK, BIT_DATA, BIT_READY, CourierNvram
from .quad_usart import QuadUsart
from .quad_board import QuadBoard
from .quad_c50 import QuadC50Endpoint
from .quad_terminal import QuadTerminal
from .timers import EbInterruptController
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
from .timers import (
    INSTRUCTIONS_PER_SECOND, INT0_VECTOR, INT1_VECTOR,
    TIMER_POLL_INSTRUCTIONS, TimerBlock,
)
from .uart import EbSerial
from .rom_serial import locate_rom_serial
from .x86_clock import NativeX86Clock

try:  # only needed to size a basic block; there is a slower path without it
    import capstone as _capstone
except ImportError:  # pragma: no cover - exercised by the fallback hook
    _capstone = None


ADDRESS_SPACE_SIZE = 0x100000
NVRAM_INPUT_BITS = BIT_DATA | BIT_READY
MAX_SERIAL_BYTES = 64 * 1024
MAX_SERIAL_TRACE_EVENTS = 256
TIMER_IRQ_INSTRUCTION_PERIOD = 4_096
# The C52's reset line, in the relocated peripheral control block. Driving it
# low holds the coprocessor in reset; the ROM pulses it at 8e3c1/8e406 and the
# payload at 69c08/69c4d, and `probe_transport` recovered the same bit.
DSP_RESET_PORT = 0xFF56
DSP_RESET_BIT = 0x0002
# How often the board's periodic service runs. Everything it does is an edge
# the hardware samples rather than something the 80186 produces, so a period
# models it better than a test after every instruction - a real 80186 does not
# take an interrupt the moment IF goes high either. 64 instructions is about
# 15 us at 20.16 MHz, and it divides the periods that hang off it.
SERVICE_INSTRUCTIONS = 64
# The native ROM clock yields at the peripheral timer's polling granularity.
# The ROM's receive state machine and the DSP/CPU mailbox both need this
# resolution; widening it after off-hook changes the DTMF stream. Payload runs
# retain the 64-instruction Python service interval because their synthetic
# UART bit edge is finer again.
NATIVE_ROM_SERVICE_INSTRUCTIONS = TIMER_POLL_INSTRUCTIONS

# The processor state carried across a turn-taking yield. Segment registers and
# flags matter as much as the general set: the machine is resumed mid-routine.
_RESUME_REGISTER_NAMES = (
    "AX", "BX", "CX", "DX", "SI", "DI", "BP", "SP",
    "CS", "DS", "ES", "SS", "FLAGS",
)
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
# The board ROM needs a second edge beside the tick. Both of its tick handlers
# install on vector 0x3c - 0x80a70's countdown chain and 0x80ad9, which is what
# increments the tick cell at [0x12a] - so TICK_VECTOR is its time base as it
# always was. INT1 is a separate source: the serial state machine at 0x9eb73
# installs INT1 handlers at vector 0x34 and unmasks INT1 at 0x9eb79 and
# 0x9ebc4, on either side of arming timer 1. Without that edge the machine
# stays in the one state that vectors timer 1 at the wrapper at 0x9f19d, whose
# near call into the body at 0x9eb73 meets that body's far return and leaves
# for uninitialised RAM at 0x3591.
# The period that makes the countdowns elapse at a plausible rate. It is
# not driven by default: supplying it changes call timing, and the linked
# pair answers OK where an undriven run reports NO CARRIER, so which of
# those is faithful is still open.
SUGGESTED_TICK_MS = 5
# The board's frame edge is the coprocessor's, far faster than the tick, and it
# is now measured rather than stood in for. `artifacts/coop-int0-02` counted
# 15,868 INT0 in 6.61 s on the live 403 board - 2,401 Hz - by chaining the
# firmware's own mailbox handler and counting the ring's wraps. The edge does
# free-run there, as the harness always assumed; what the harness had wrong was
# the rate, and by more than a factor of six the *slow* way: 11,110 instructions
# is 391 Hz at this time base.
#
# Derived from INSTRUCTIONS_PER_SECOND rather than written out, so the two stay
# consistent if the calibration moves - and note that ratio is crystal-free, so
# one figure serves both boards even though only the 20.16 MHz one was measured.
# The rate is the board's own, measured: `artifacts/coop-int0-02` counted 15,868
# INT0 in 6.61 s on the live 403 unit by chaining the firmware's own mailbox
# handler and counting the ring's wraps.
#
# The harness could not run at it until the DSP/CPU instruction ratio was fixed
# (bridge.DSP_STEPS_PER_X86). While that ratio was six times too small the C52
# could not fill the intervals the supervisor was timing, so the supervisor's
# dial ran 4.46x slower than the audio it produced, and this constant had to
# absorb the difference - it stood at 391, then 536, both of them that one error
# wearing a rate's clothing. With the ratio right, the measured rate produces a
# digit period of 146.3 ms against the board's 140.05, and a tone and gap that
# match each other as the board's do.
FRAME_HZ = 2_401
FRAME_INSTRUCTIONS = INSTRUCTIONS_PER_SECOND // FRAME_HZ
# How long a character sits on the wire before the receiver takes it. Long
# enough that the frame service sees the line low at least once.
START_BIT_INSTRUCTIONS = 32_768
RX_BIT_INSTRUCTIONS = 150
# When the harness's terminal raises its handshake. Long enough after reset
# that the ROM's callback chain has already sampled the line unasserted.
# How far past the later of a ROM's DSP reset and download entries those
# routines run. Both and their handshake waits sit inside the resulting span;
# e3aa..e67b in the captured board image, whose block ends at e597.
ROM_DOWNLOADER_SPAN = 0x200
DTE_READY_INSTRUCTIONS = 30_000_000
# And when it starts sending. The chain wants the handshake asserted, then a
# quiet spell, then a character: [0x321] counts thirty of its own polls down
# to zero before it will take one, and [0x322] gives up after fifty. At the
# frame rate above that window is roughly four to six and a half million
# instructions after the handshake, so the first character lands inside it.
DTE_TYPING_INSTRUCTIONS = DTE_READY_INSTRUCTIONS + 5_000_000
# The other candidate source, and the only one that leaves both of the
# firmware's mutual watchdogs quiet: pace the chain off the DSP frame
# interrupt instead of off a period. The two watchdogs bound the legal ratio
# to between 1/25 and 3 ticks per DSP interrupt, and 1:1 sits inside it. This
# is opt-in because the ratio is a choice within that band rather than a
# measurement, and because it delivers an edge the interrupt controller has
# masked - see "Pacing the chain from the DSP interrupt".
PC_WATCH_SAMPLES = 64
MEM_WATCH_EVENTS = 96

TICK_SOURCES = ("dsp",)

# The ROM builds' port 0 control latch. 0x40 is the speaker (pulsed by
# 0x81703); 0x08 is the second serial port's receive-pending input, tested at
# 0x81d45 with the byte itself read from port 0x0a.
PORT0_SPEAKER = 0x40
PORT0_RX_PENDING = 0x08
# The four bits 0x81703 carries across its read-modify-write are inputs, not
# latch storage: answering them from the latch instead of their strapped level
# costs ATI7 its Terbo, VFC and V34+ options, so the firmware reads capability
# from them. They stay at the undriven high level the open bus used to give.
PORT0_INPUTS = 0x33
PORT0_OUTPUTS = 0xC4


# Every literal address `on_hot_code` tests, and nothing else. One set lookup
# replaces the chain of comparisons that used to run on every instruction, and
# `_HOT_HOOK_RANGES` narrows the hook to them.
#
# The set has to stay exactly the addresses that block tests. A block keyed on
# anything else - the *previous* instruction, say - cannot live behind it and
# belongs in `on_code`; putting one here silently disables it, which is what
# happened to the serial ISR-exit block between 8a6067e and its repair.
_HOT_ADDRESSES = frozenset({
    0x57FF9,
    0x5867C,
    0x5868C,
    0x59435,
    0x59CD9,
    0x59D02,
    0x59D28,
    0x5BA29,
    0x5BA49,
    0x5C0C4,
    0x5C0D4,
    0x5C0E3,
    0x5C0F3,
    0x5C772,
    0x5CE19,
    0x5CE4E,
    0x5CE66,
    0x5CE6A,
    0x5D5B0,
    0x5D6E5,
    0x5D6FB,
    0x5D70E,
    0x5D724,
    0x5D734,
    0x5D74A,
    0x5DB9D,
    0x5DBE7,
    0x62350,
    0x6355F,
    0x654EE,
    0x65560,
    0x6593F,
    0x6594D,
    0x65958,
    0x6595B,
    0x65D42,
    0x65F03,
    0x66638,
    0x666E0,
    0x66720,
    0x6675B,
    0x66788,
    0x667B0,
    0x667BA,
    0x668C2,
    0x69F16,
    0x6A035,
    0x6A062,
    0x6A08A,
    0x6A0CF,
    0x6AD6E,
    0x6F8D1,
    0x6F903,
    0x70F70,
    0x70F83,
    0x70F8D,
    0x822E0,
    0x82342,
    0x8235B,
    0x828A6,
})


# `_HOT_ADDRESSES` as Unicorn hook ranges, so the code hook is registered over
# these rather than the whole address space and QEMU emits no callback for an
# instruction outside them. Addresses within 64 bytes of each other share a
# range: that is tight enough that the ranges still cover only 0.6% of the
# instructions a run executes, and few enough registrations that the
# per-translation check stays cheap. Both halves of that trade get worse if
# this gap grows - at 1 KiB the ranges take 28% of the run.
_HOT_RANGE_GAP = 64


def _hot_hook_ranges(addresses: frozenset[int], gap: int) -> tuple[tuple[int, int], ...]:
    ordered = sorted(addresses)
    ranges = [[ordered[0], ordered[0]]]
    for address in ordered[1:]:
        if address - ranges[-1][1] <= gap:
            ranges[-1][1] = address
        else:
            ranges.append([address, address])
    return tuple((low, high) for low, high in ranges)


_HOT_HOOK_RANGES = _hot_hook_ranges(_HOT_ADDRESSES, _HOT_RANGE_GAP)

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
    # Rising edges of port 0 bit 0x40 on the ROM builds: one per speaker click.
    speaker_pulses: int = 0
    mmio_summary: dict[str, int] = field(default_factory=dict)
    hot_addresses: list[tuple[int, int]] = field(default_factory=list)
    pc_watch: list[dict[str, Any]] = field(default_factory=list)
    peek: dict[str, str] = field(default_factory=dict)
    mem_watch: list[dict[str, Any]] = field(default_factory=list)
    pc_watch_counts: dict[str, int] = field(default_factory=dict)
    last_addresses: list[int] = field(default_factory=list)
    serial_text: str = ""
    data_rx_bytes: int = 0
    data_tx_bytes: int = 0
    online_mode: bool = False
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
    supervisor_call_cells: dict[str, int] = field(default_factory=dict)
    panel: dict[str, Any] | None = None
    nvram: dict[str, Any] | None = None
    flash: dict[str, Any] | None = None
    ring: dict[str, int] | None = None
    timers: dict[str, Any] | None = None
    interrupt_vectors: dict[str, str] = field(default_factory=dict)

    def to_dict(self) -> dict[str, Any]:
        value = asdict(self)
        value["hot_addresses"] = [list(item) for item in self.hot_addresses]
        value["pc_watch"] = list(self.pc_watch)
        value["peek"] = dict(self.peek)
        value["mem_watch"] = list(self.mem_watch)
        value["pc_watch_counts"] = dict(self.pc_watch_counts)
        return value



# The serial callback table, located in the image rather than transcribed.
#
# The supervisor keeps three near vectors side by side - the RX callback, the
# TX callback, and the command-state callback - and both installs them with
# `mov word [addr], imm16` and enters them with `call word ptr [addr]`. So the
# table is three consecutive words that are each an indirect-call target and
# each the destination of many different immediate stores.
#
# That predicate alone leaves three candidates in an XMF (the serial table and
# two neighbouring dispatch tables), which their call counts separate: the
# serial table's base is entered about five times against the others' twelve
# or thirteen. Taking the least-entered candidate picks 02a8 in every XMF
# supervisor - 2.1.1, 2.2.05, 2.3.33 and 3453B alike, where 02a8 is already
# known - and 026a in IDSDL302.ROM, whose table is nowhere near 02a8.
#
# This exists because the traces used to read 02a8 for every image, so a ROM
# whose callbacks were installed and working reported `final callbacks=0000`.
SERIAL_CALLBACK_STORE = re.compile(rb"\xc7\x06(..)(..)", re.S)
SERIAL_CALLBACK_CALL = re.compile(rb"\xff\x16(..)", re.S)
SERIAL_CALLBACK_SEARCH = range(0x100, 0x2000, 2)
SERIAL_CALLBACK_STORES = 10


def serial_callback_table(data: bytes) -> int | None:
    """Return the base of the image's three-word serial callback table."""
    calls: Counter[int] = Counter()
    stores: dict[int, set[int]] = {}
    for match in SERIAL_CALLBACK_CALL.finditer(data):
        calls[int.from_bytes(match.group(1), "little")] += 1
    for match in SERIAL_CALLBACK_STORE.finditer(data):
        target = int.from_bytes(match.group(1), "little")
        stores.setdefault(target, set()).add(
            int.from_bytes(match.group(2), "little")
        )
    slots = (0, 2, 4)
    candidates = [
        base
        for base in SERIAL_CALLBACK_SEARCH
        if all(calls.get(base + slot) for slot in slots)
        and all(len(stores.get(base + slot, ())) >= SERIAL_CALLBACK_STORES
                for slot in slots)
    ]
    if not candidates:
        return None
    return min(candidates, key=lambda base: calls[base])

class CourierMachine:
    """A 1 MiB 80186 execution harness with observable board I/O."""

    def __init__(
        self,
        image: XmfImage,
        *,
        port_values: dict[int, int] | None = None,
        runtime_port_values: dict[int, int] | None = None,
        quad_usart: QuadUsart | None = None,
        quad_board: QuadBoard | None = None,
        quad_c50: QuadC50Endpoint | None = None,
        quad_terminal: bool = False,
        uart_ports: set[int] | None = None,
        max_io_events: int = 128,
        fast_delays: bool = True,
        track_executed: bool = False,
        with_dsp: bool = False,
        dsp_rx_samples: list[int] | None = None,
        dsp_tx_pcm: str | None = None,
        serial_input: bytes = b"",
        daa: CourierDaa | None = None,
        ring: RingSource | None = None,
        codec: CodecBringUp | None = None,
        exchange: LineExchange | None = None,
        int1_after_ms: int | None = None,
        sip: SipSession | None = None,
        line: LineLink | None = None,
        nvram: CourierNvram | None = None,
        board_id: int | None = DEFAULT_BOARD_ID,
        dip_closed: frozenset[str] | None = None,
        code_observer: Any = None,
        parameter_sector: bytes | None = None,
        parameter_flash: ParameterFlash | None = None,
        tick_ms: int | None = None,
        frame_hz: int | None = None,
        tick_source: str | None = None,
        console: SerialConsole | None = None,
        force_online: bool = False,
        dsp_batch: int = 256,
        pc_watch: dict[int, str] | None = None,
        peek: dict[int, str] | None = None,
        dsp_trace_range: tuple[int, int] | None = None,
        dsp_peek: dict[int, str] | None = None,
        dsp_write_watch: int | None = None,
        mem_watch: tuple[int, int] | None = None,
    ) -> None:
        self.image = image
        self.quad_terminal = QuadTerminal() if quad_terminal else None
        if self.quad_terminal is not None:
            self.quad_terminal.validate(image)
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
        # The INT0 period, in instructions. The default is the board's measured
        # rate; `--frame-hz` is for comparing against it, not for tuning.
        self.frame_instructions = (INSTRUCTIONS_PER_SECOND // frame_hz
                                   if frame_hz else FRAME_INSTRUCTIONS)
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
        # The Quad NAC's chassis link. Absent for every other image, so an
        # unset value leaves those ports exactly as they were.
        if quad_board is not None and quad_usart is not None and quad_board.usart is not quad_usart:
            raise ValueError("quad_board and quad_usart must share the same device")
        self.quad_board = quad_board
        self.quad_c50 = quad_c50
        self.quad_usart = quad_board.usart if quad_board is not None else quad_usart
        self._quad_profile = self.quad_usart is not None or getattr(image, "quad_profile", False)
        self.output_latches: dict[int, int] = {}
        # The ROM builds' port 0 control latch, and the speaker hanging off
        # bit 0x40 of it. Powers up clear; the firmware read-modify-writes it.
        self.port0_latch = 0
        self.speaker_pulses = 0
        self.uart_ports = set(uart_ports or set())
        # Physical 80186 addresses to record register state at. `hot_addresses`
        # is a top-20 profile and cannot answer "was this branch taken, and
        # with what in AX" - the queue drain at 8f521 demonstrably runs and
        # never appears in it. This does, for addresses named up front.
        self.pc_watch = dict(pc_watch or {})
        # Byte cells to report at the end of a run. The board's own ATGLK2
        # reads the same addresses off hardware, so the two can be compared
        # directly instead of inferred from behaviour.
        self.peek = dict(peek or {})
        self.dsp_trace_range = dsp_trace_range
        # An 80186 memory-write window. The ring the mailbox drain reads from
        # is at 0290..02ce, which the dsp_queue_write hook only clips the tail
        # of, and nothing else records who fills it.
        self.mem_watch = mem_watch
        self.mem_watch_events: list[dict[str, Any]] = []
        self.pc_watch_events: list[dict[str, Any]] = []
        self.pc_watch_counts: Counter[str] = Counter()
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
        self.data_rx_bytes = 0
        self.data_tx_bytes = 0
        self.online_mode = False
        self.force_online = force_online
        self.serial_rx: deque[int] = deque(serial_input)
        self._alternate_line = bytearray()
        self.console = console
        self.stop_requested = False
        self._resume_state: dict[str, Any] | None = None
        self.serial_interrupts = 0
        self.timer_interrupts = 0
        self.serial_trace: list[str] = []
        # An optional per-instruction address sink. Diffing the addresses two
        # runs reach is how a command's own handler is separated from the idle
        # loop that dominates any profile.
        self._code_observer = code_observer
        self._completion_dispatch_trace_count = 0
        self._originate_connect_published = False
        self._serial_started = False
        self._serial_irq_requested = False
        self._serial_in_handler = False
        self._serial_irq_mode: str | None = None
        self._serial_tx_pump = False
        # The transmit callback word at 0x02aa, cached. The pump below
        # tests it on every instruction it is armed for, and reading it
        # through the emulator cost a guest memory read per instruction -
        # around a quarter of all of them on a payload run. None means
        # unknown; a guest write to the word puts it back.
        self._serial_tx_callback: int | None = None
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
        supervisor_offset = getattr(image, "supervisor_offset", None)
        self.emulate_interrupts = (
            getattr(image, "emulates_interrupts", False)
            or supervisor_offset == 0x1B600
        )
        # A ROM's countdown chain hangs off TICK_VECTOR, and its own boot table
        # masks that source, so nothing the modelled timers produce ever reaches
        # it: the run parks in the delay at 0x8000:0a52 forever and never prints.
        # Supplying the edge is opt-in through --tick-ms, for the same reason the
        # payload stand-in is - it stands in for a board source that is not
        # recovered, so a default run is left exactly as it was.
        self._quad_modem_tick = getattr(image, "quad_role", None) == "modem"
        self._rom_tick = (supervisor_offset is None and self.emulate_interrupts
                          and not self._quad_profile)
        # The ROM reaches the settings EEPROM over port pins rather than
        # through board latch 0, so it needs its own front end onto the same
        # 93C66 model. This holds the data pin the driver at 0x1401 last drove.
        self._eeprom_data_in = False
        self.timers = TimerBlock(fast=fast_delays, answers_reads=self.emulate_interrupts)
        if self._quad_profile:
            self.timers.controller = EbInterruptController()
        self._quad_irq_in_service = False
        self._quad_interrupt_stack: list[int] = []
        self._timer_interrupt_pending: int | None = None
        self._external_interrupt_pending: int | None = None
        # A ROM reaches its DTE through the integrated serial unit in the
        # control block rather than the payload's hand-modelled ports.
        self.uart = EbSerial() if supervisor_offset is None else None
        # The ROM's serial engine runs off INT1 while the tick runs off INT3,
        # so the two cannot share one pending slot.
        self._int1_pending: int | None = None
        # INT0 is the board's frame edge. The live board vectors it at
        # 8f43:0000, the head of the service that reads the coprocessor ports
        # at 0x58..0x5e and then drives the countdown callback at [0x31f] -
        # the chain that eventually posts the startup banner's event. Nothing
        # on the CPU side produces that edge, so a ROM run has to stand in for
        # it the way it already stands in for the tick.
        self._int0_pending: int | None = None
        self._last_frame = 0
        self._rx_started_at = 0
        self._rx_edge_at = 0
        self._rom_rx_bit = 0
        self._rom_dte_opened = False
        self._previous_address: int | None = None
        # The C52 comes out of board reset held, the same as the part does.
        self._dsp_in_reset = True
        # The service's own clocks, counted down by the instructions elapsed
        # rather than tested against a multiple: the instruction count now
        # advances a basic block at a time and steps over any given multiple.
        self._next_service = SERVICE_INSTRUCTIONS
        self._last_service = 0
        self._console_owed = 0
        self._timer_poll_owed = TIMER_POLL_INSTRUCTIONS
        # The per-address execution histogram behind `hot_addresses`. It is
        # a diagnostic, and counting it costs a dict update on every emulated
        # instruction, so it is off unless asked for.
        self.track_executed = track_executed
        self.executed: Counter[int] = Counter()
        self.last_addresses: deque[int] = deque(maxlen=64)
        self.instructions = 0
        self.interrupt: int | None = None
        self.accelerated_delays = 0
        self.milestones: list[str] = []
        if with_dsp and not hasattr(image, "dsp_program_segments"):
            raise ValueError(
                "the DSP bridge needs an image that carries a C52 payload"
            )
        self.dsp_bridge = (
            CourierDspBridge(
                image,
                rx_samples=dsp_rx_samples,
                daa=daa,
                sip=sip,
                line=line,
                codec=codec,
                ring=ring,
                exchange=exchange,
                batch=dsp_batch,
                dsp_trace_range=dsp_trace_range,
                dsp_peek=dsp_peek,
                dsp_write_watch=dsp_write_watch,
            )
            if with_dsp
            else None
        )
        self.dsp_tx_pcm = dsp_tx_pcm
        # The physical span of a ROM's DSP reset and download routines, from
        # the call site that names both rather than from a constant. Inside it,
        # timer 2's max-count bit is a handshake timeout rather than a delay's
        # completion, so the model must not grant it - see the read hook.
        download = getattr(image, "dsp_download", None)
        self._rom_transfer_span = (
            (
                image.base + min(download.reset, download.downloader),
                image.base + max(download.reset, download.downloader)
                + ROM_DOWNLOADER_SPAN,
            )
            if download is not None
            else None
        )
        # Every address constant below belongs to the update payload's map.
        # A full board ROM loads at its own base and runs a different
        # supervisor, so those constants land on unrelated code: left enabled
        # they fabricate serial bytes and milestones, and the callback
        # stand-in overwrites the ROM's own copied low-memory table.
        self._payload_hooks = supervisor_offset is not None
        self._milestone_addresses = {} if not self._payload_hooks else {
            0x5B9F0: "supervisor-entry",
            0x69D05: "dsp-transfer",
            0x7E133: "startup-crc",
            0x65512: "main-loop",
        }
        # Located in this image, not assumed: an image whose table is
        # elsewhere used to report its callbacks as zero.
        self._serial_callbacks = (
            serial_callback_table(getattr(image, "data", b"")) or 0x02A8
        )
        self._rom_serial = (
            locate_rom_serial(image.data, self._serial_callbacks)
            if self.uart is not None else None
        )
        self._terminal_connected = bool(serial_input) or console is not None
        self._alternate_supervisor = supervisor_offset == 0x1B600
        self._supervisor_23 = supervisor_offset == 0x17BB0
        # main2205 keeps the same supervisor ABI but relocates several
        # dispatcher routines.  These are the corresponding entry points
        # recovered from its own call-table and transfer code.
        if supervisor_offset == 0x1B600:
            self._milestone_addresses.update({
                0x5BA10: "supervisor-entry",
                0x69FBA: "dsp-transfer",
                0x69FD8: "dsp-transfer",
                0x656A5: "main-loop",
                0x656AD: "main-loop",
            })
        elif supervisor_offset == 0x17BB0:
            self._milestone_addresses.update({
                0x61CE2: "main-loop",
                0x61D19: "main-loop",
            })

    def _dte_asserted(self) -> bool:
        """Whether the harness's terminal has raised its handshake yet.

        The ROM will not take a character until its callback chain has seen
        this line unasserted and then asserted, so a terminal that is already
        present at reset is one the chain never notices. The wait is measured
        from reset rather than recovered from the board.
        """
        return (
            self.instructions >= DTE_READY_INSTRUCTIONS
            and (bool(self.serial_rx) or self.uart is not None and self.uart.received > 0)
        )

    def _int0_vector_installed(self, uc: Any) -> bool:
        """Whether the firmware has put a handler behind the frame edge.

        Delivering INT0 before the firmware has vectored it would enter
        whatever the boot table left at type 0x0c, so the stand-in waits for
        the firmware to claim it.
        """
        if not self._rom_tick:
            return False
        vector = bytes(uc.mem_read(INT0_VECTOR * 4, 4))
        return any(vector)

    def _capture_serial(self, value: int) -> None:
        value &= 0xFF
        if len(self.serial) < MAX_SERIAL_BYTES:
            self.serial.append(value)
        else:
            self.serial_truncated = True
        # CONNECT is the DTE boundary: subsequent bytes are payload, not AT
        # commands. The firmware still owns the transition unless forced.
        if not self.online_mode and b"CONNECT" in bytes(self.serial[-10:]).upper():
            self.online_mode = True
            self.serial_trace.append("entered-data-mode")
        if self.console is not None:
            self.console.write(value)

    @property
    def _terminal_attached(self) -> bool:
        """Whether the firmware should come up expecting terminal input.

        The board's UART callbacks are installed once, as the supervisor
        reaches its main loop. Queued input is known by then; a console's
        first byte may still be minutes away, so an attached console counts
        as input in its own right. Draining a command queue does not detach
        that terminal or lower DTR while its result is being generated.
        """
        self._terminal_connected |= bool(self.serial_rx) or self.console is not None
        return self._terminal_connected

    def _needs_code_hook(self) -> bool:
        """Whether anything in this run reads per-instruction state.

        The hook that maintains it costs a Python call on every emulated
        instruction, which is most of a run's time, so it is registered only
        when something will read what it records:

        `executed` and `pc_watch` are diagnostics, off unless asked for.
        `last_addresses` is the window the keystroke-spin test looks at, and
        that test is only reached with a byte waiting for the DTE. And
        `_previous_address` is read by the payload harness's ISR-exit blocks,
        which need the instruction that ran immediately before - the serial
        one while input is being delivered, the timer one only when the DSP
        paces the tick.  A complete ROM uses its modelled EB UART and interrupt
        controller instead; neither of those paths reads `_previous_address`.
        Keeping the hook merely because a ROM has queued AT input or a
        DSP-paced line costs one Python callback per guest instruction for no
        observable effect.
        """
        return bool(
            self.pc_watch
            or self._code_observer is not None
            or self.track_executed
            or self.console is not None
            or (
                self._payload_hooks
                and (bool(self.serial_rx) or self.tick_source == "dsp")
            )
        )

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

    def _peek_values(self) -> dict[str, str]:
        """Read the watched byte cells out of the machine's memory.

        The board's own ATGLK2 reads the same addresses off hardware, so a
        run and the hardware can be compared cell by cell rather than
        inferred from behaviour.
        """
        values: dict[str, str] = {}
        for address, name in self.peek.items():
            try:
                values[name] = f"{bytes(self.uc.mem_read(address, 1))[0]:02x}"
            except Exception:
                values[name] = "??"
        return values

    def snapshot(self) -> dict[str, Any]:
        """CPU state at a yield, for handing this machine's turn back later.

        Memory is deliberately not included: in the chassis harness the channel
        memory is the shared surface and its owner moves it between machines.
        """
        from unicorn import x86_const as _x86
        registers = {name: self.uc.reg_read(getattr(_x86, f"UC_X86_REG_{name}"))
                     for name in _RESUME_REGISTER_NAMES}
        return {"registers": registers, "instructions": self.instructions,
                "pc": self.uc.reg_read(_x86.UC_X86_REG_CS) * 16
                      + self.uc.reg_read(_x86.UC_X86_REG_IP)}

    def resume_from(self, state: dict[str, Any]) -> None:
        """Continue from a snapshot on the next run() instead of from reset."""
        self._resume_state = state

    def run(self, instruction_limit: int = 250_000) -> RunResult:
        try:
            from unicorn import (
                UC_ARCH_X86,
                UC_HOOK_BLOCK,
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
        # Diagnostics that need to read emulated RAM (a console script sampling
        # a firmware variable, for example) have no other handle on the engine.
        self.uc = uc
        uc.mem_map(0, ADDRESS_SPACE_SIZE)
        uc.mem_write(self.image.load_base, self.image.data)
        for address, payload in getattr(self.image, "initial_memory", ()):
            uc.mem_write(address, payload)
        if self.quad_board is not None:
            self.quad_board.attach(uc)
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
            length_address = 0x1D1C if self._alternate_supervisor else 0x1CF4
            buffer_address = 0x1D1D if self._alternate_supervisor else 0x1CF5
            length = bytes(_uc.mem_read(length_address, 1))[0]
            line = bytes(_uc.mem_read(buffer_address, length)) if length else b""
            if attention_body(line) is not None or line[:2] in (
                b"A/",
                b"a/",
                b"A>",
                b"a>",
            ):
                return
            ready_callback = 0x90D8 if self._alternate_supervisor else 0xA8D9
            _uc.mem_write(0x2AC, ready_callback.to_bytes(2, "little"))
            _uc.mem_write(length_address, b"\x00")
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
            length_address = 0x1D1C if self._alternate_supervisor else 0x1CF4
            _uc.mem_write(length_address, b"\x00")
            self._trace_serial("collect 1cee|=40")

        def on_hot_code(_uc: Any, address: int, _size: int, _data: Any) -> None:
            """The blocks that only ever fire at one of `_HOT_ADDRESSES`.

            Registered over `_HOT_HOOK_RANGES` rather than the whole address
            space, so Unicorn emits no callback at all for the 99.4% of
            executed instructions that land outside them. The ranges are a
            superset of the addresses, so the membership test still decides.
            """
            hot = address in _HOT_ADDRESSES
            if not hot:
                return
            if hot and (
                address == 0x65560
                and self.dsp_bridge is not None
                and self.dsp_bridge.connected_event_queued
                and self._completion_dispatch_trace_count < 8
            ):
                self._completion_dispatch_trace_count += 1
                self._trace_serial(
                    f"completion-dispatch op="
                    f"{self.dsp_bridge.daa.operation if self.dsp_bridge.daa else 'none'} "
                    f"cs={_uc.reg_read(UC_X86_REG_CS):04x} "
                    f"callback={int.from_bytes(_uc.mem_read(0x02ac, 2), 'little'):04x} "
                    f"0158={int.from_bytes(_uc.mem_read(0x0158, 2), 'little'):04x} "
                    f"1cf1={bytes(_uc.mem_read(0x1cf1, 1))[0]:02x}"
                )
            if hot and (
                address == 0x667BA
                and self.dsp_bridge is not None
                and self.dsp_bridge.connected_event_queued
                and self.dsp_bridge.daa is not None
                and self.dsp_bridge.daa.operation == "dialing"
            ):
                # 667ba is the common result-code emitter. The originate
                # state callback reaches it with selector 0/OK; once the ASIC
                # completion edge is present, the caller needs selector 1.
                _uc.reg_write(UC_X86_REG_AX, 1)
                self._trace_serial("originate result-selector=1")
            if hot and (
                address == 0x654EE
                and self.dsp_bridge is not None
                and self.dsp_bridge.connected_event_queued
                and int.from_bytes(_uc.mem_read(0x02AC, 2), 'little') == 0xA35F
            ):
                self._trace_serial(
                    f"completion-callback op="
                    f"{self.dsp_bridge.daa.operation if self.dsp_bridge.daa else 'none'} "
                    f"0158={int.from_bytes(_uc.mem_read(0x0158, 2), 'little'):04x} "
                    f"1cf1={bytes(_uc.mem_read(0x1cf1, 1))[0]:02x}"
                )
            if hot and (
                address == 0x668C2
                and self.dsp_bridge is not None
                and self.dsp_bridge.connected_event_queued
            ):
                self._trace_serial(
                    f"result-select si={_uc.reg_read(UC_X86_REG_SI)} "
                    f"op={self.dsp_bridge.daa.operation if self.dsp_bridge.daa else 'none'} "
                    f"ax={_uc.reg_read(UC_X86_REG_AX):04x} "
                    f"0158={int.from_bytes(_uc.mem_read(0x0158, 2), 'little'):04x}"
                )
            if hot and (
                address == 0x668C2
                and self.dsp_bridge is not None
                and self.dsp_bridge.daa is not None
                and self.dsp_bridge.daa.operation == "answer"
                and _uc.reg_read(UC_X86_REG_SI) == 3
            ):
                # 668be calls the answer result producer, then 668c2 indexes
                # the firmware result table.  The producer returns selector
                # 3 (NO CARRIER) before the ASIC call-up edge reaches it;
                # selector 1 is the adjacent CONNECT entry in that table.
                _uc.reg_write(UC_X86_REG_SI, 1)
            if hot and self._payload_hooks and address in (
                0x6F8D1, 0x6F903, 0x6593F, 0x6594D, 0x65958,
                0x6595B, 0x70F70, 0x70F83, 0x70F8D,
            ):
                if self.dsp_bridge is not None and address == 0x6593F:
                    if self.dsp_bridge.connected_event_queued:
                        _uc.mem_write(0x027B, (0x0002).to_bytes(2, "little"))
                    self.dsp_bridge.set_completion_probe(True)
                    latch = bytes(_uc.mem_read(0x0913, 1))[0]
                    _uc.mem_write(0x0913, bytes((latch | 0x01,)))
                elif self.dsp_bridge is not None and address == 0x65958:
                    self.dsp_bridge.set_completion_probe(False)
                if (
                    address == 0x6595B
                    and self.dsp_bridge is not None
                    and self.dsp_bridge.connected_event_queued
                ):
                    _uc.mem_write(0x027C, (0x0006).to_bytes(2, "little"))
                if len(self.serial_trace) < 2048:
                    cells = bytes(_uc.mem_read(0x027B, 2)).hex()
                    self.serial_trace.append(
                        f"call-gate {address:05x} cells={cells} "
                        f"flags={_uc.reg_read(UC_X86_REG_FLAGS) & 0xffff:04x} "
                        f"ff46={int.from_bytes(_uc.mem_read(0xff46, 2), 'little'):04x} "
                        f"ff56={int.from_bytes(_uc.mem_read(0xff56, 2), 'little'):04x}"
                    )
            if hot and (
                address == 0x65560
                and self.dsp_bridge is not None
                and self.dsp_bridge.connected_event_queued
                and not self._daa_originate_event_posted
            ):
                # 70f40's firmware-owned completion service is explicitly
                # gated by S14/[094e].  A dedicated line has no DTE edge to
                # set that latch; the ASIC's connected publication is the
                # corresponding board-side edge.
                _uc.mem_write(0x094E, b"\x01")
                if (
                    bytes(_uc.mem_read(0x0681, 1))[0] != 0
                    and int.from_bytes(_uc.mem_read(0x0158, 2), "little") == 0
                ):
                    status = bytes(_uc.mem_read(0x09E4, 1))[0] & 0x0F
                    cs = _uc.reg_read(UC_X86_REG_CS)
                    table = ((cs << 4) + 0x2DA1) & 0xFFFFF
                    value = int.from_bytes(
                        _uc.mem_read(table + status * 2, 2), "little"
                    )
                    _uc.mem_write(0x0158, value.to_bytes(2, "little"))
                    self._trace_serial(f"daa status-table 0158={value:04x}")
                if (
                    int.from_bytes(_uc.mem_read(0x0158, 2), "little") == 0
                ):
                    # Nothing further in this hook applies without a result
                    # word. The harness clock and the board service no longer
                    # live here, so this leaves only the rest of the hot
                    # blocks unrun, which is what it always meant to do.
                    return
                # The originate callback normally leaves the carrier state at
                # 1 after consuming the ASIC completion word. A connected
                # datapump must take the same state-2/result path used by the
                # answer callback; publish that state at the callback boundary
                # rather than rewriting 0158 (which is a service result word).
                if (
                    self.dsp_bridge.daa is not None
                    and self.dsp_bridge.daa.operation == "dialing"
                ):
                    # The supervisor's diagnostic path derives its rate bucket
                    # from C52 data 0304. Publish that DSP-owned handoff before
                    # entering the originating result callback; otherwise the
                    # firmware can only produce bare CONNECT.
                    if hasattr(self.dsp_bridge.core, "data"):
                        rate_word = self.dsp_bridge.core.data(0x0304)
                        _uc.mem_write(0x0304, rate_word.to_bytes(2, "little"))
                        rate_bucket = 6 - ((rate_word >> 10) & 7)
                        _uc.mem_write(0x0B26, bytes((rate_bucket & 0xFF,)))
                    _uc.mem_write(0x0681, b"\x02")
                    _uc.mem_write(0x0683, b"\x02")
                    _uc.mem_write(0x09E4, b"\x0e")
                    self._trace_serial("originate state=2 result=e")
                    if not self._originate_connect_published:
                        self.online_mode = True
                        # This is a diagnostic completion, not a negotiated
                        # modem result. Never invent a rate here; CONNECT
                        # remains plain until the datapump reports one.
                        for byte in b"\r\nCONNECT\r\n":
                            self._capture_serial(byte)
                        self._originate_connect_published = True
                        self._trace_serial("originate CONNECT")
                # The auxiliary event table at 65832 maps event 3 to 658a7,
                # which installs the A35F rate/completion callback in 02AC.
                # Publish that callback before the main loop executes CALL
                # [02AC]; writing 1CF1 here would select the unrelated main
                # event table at 65c09.
                _uc.mem_write(0x02AC, (0xA35F).to_bytes(2, "little"))
                self._daa_originate_event_posted = True
                self._trace_serial("daa callback 02ac=a35f")
            if hot and (self._supervisor_23 and address == 0x62350):
                length = bytes(_uc.mem_read(0x1D2C, 1))[0]
                payload = bytes(_uc.mem_read(0x1D2D, min(length, 0x3C)))
                body = attention_body(payload)
                if body is not None:
                    _uc.mem_write(0x1D2D, body + b"\x00\x00")
                    _uc.mem_write(0x1D2C, bytes((len(body),)))
                    if self.dsp_bridge is not None:
                        self.dsp_bridge.arm_dial_tones(body)
            if hot and (
                address == 0x6AD6E
                and self.dsp_bridge is not None
            ):
                callback = int.from_bytes(_uc.mem_read(0x2DA, 2), "little")
                pending = self.dsp_bridge.pending_runtime_message()
                if pending is not None:
                    header, data = pending
                    self._trace_serial(
                        f"dsp-rx {header:04x}:{data:04x} callback={callback:04x}"
                    )
            if hot and (self._serial_started and address in (0x65F03, 0x65D42)):
                # The physical DTE front-end recognizes the attention prefix
                # before handing a command body to this banked parser. Our
                # direct UART ISR path bypasses that small state machine, so
                # reproduce its observable contract here: the parser receives
                # the bytes after an all-upper or all-lower "AT" prefix.
                length_address = 0x1D1C if self._alternate_supervisor else 0x1CF4
                buffer_address = 0x1D1D if self._alternate_supervisor else 0x1CF5
                length = bytes(_uc.mem_read(length_address, 1))[0]
                command = bytes(_uc.mem_read(buffer_address, length))
                body = attention_body(command)
                if body is not None:
                    _uc.mem_write(buffer_address, body + b"\x00\x00")
                    _uc.mem_write(length_address, bytes((len(body),)))
                    self._trace_serial(f"attention body={body!r}")
                    if self.dsp_bridge is not None:
                        self.dsp_bridge.arm_dial_tones(body)
            # 5b5e:184b transmits AL through the 80186 integrated UART. Both of
            # its wait edges (5b5e:1874 and 5b5e:1884) branch back to the
            # routine's own entry, so a byte passes 0x5ce2b once per spin but
            # is only accepted at 0x5ce66, just before the parity transform and
            # the write to the transmit register. Capture there so each byte is
            # recorded exactly once.
            if hot and (self._serial_started and address in (0x5CE66, 0x5CE6A)):
                raw = _uc.reg_read(UC_X86_REG_AX) & 0xFF
                # The transform at 5b5e:1913 recomputes bit 7 as an even-parity
                # bit whenever [0x26c6] is zero, then applies the [0x0936]
                # framing. In those framings bit 7 carries no data, so report
                # the seven bits a receiving DTE would keep.
                parity_framing = bytes(_uc.mem_read(0x26C6, 1))[0] == 0
                terminal_value = raw & 0x7F if parity_framing else raw
                self._capture_serial(terminal_value)
                self._trace_serial(f"fifo {terminal_value:02x} pc={current_pc():05x}")
            if hot and (
                self._payload_hooks
                and address == 0x5D5B0
                and len(self.serial_trace) < 64
            ):
                self.serial_trace.append("entered-uart-isr")
            # The fatal-error blinker uses a calibrated self-looping LOOP.
            if hot and (self.fast_delays and address == 0x5C772):
                _uc.reg_write(UC_X86_REG_CX, 1)
                self.accelerated_delays += 1
            # The 80186 peripheral block has just been relocated to ff00. The
            # startup waits for timer/status bit 0x20, which a CPU-only core
            # cannot produce.
            if hot and self.fast_delays and address in (
                0x5BA29, 0x5BA49, 0x69F16,
                0x6A035, 0x6A062, 0x6A08A, 0x6A0CF,
                0x57FF9,
            ):
                value = int.from_bytes(_uc.mem_read(0xFF46, 2), "little")
                _uc.mem_write(0xFF46, (value | 0x20).to_bytes(2, "little"))
                self.accelerated_delays += 1
            # The 2.3 supervisor reuses bit 0x20 as a transfer-failure
            # indication: its download loop aborts when the bit is set. The
            # startup wait above needs the bit asserted once, but the
            # subsequent status polls need the peripheral's ready state.
            if hot and self.fast_delays and self._supervisor_23 and address in (
                0x66638, 0x666E0, 0x66720, 0x6675B, 0x66788, 0x667B0,
            ):
                value = int.from_bytes(_uc.mem_read(0xFF46, 2), "little")
                _uc.mem_write(0xFF46, (value & ~0x20).to_bytes(2, "little"))
            # Firmware delay helpers either burn CX or wait for the timer ISR
            # to advance the tick at 0000:0152. Advance both without inventing
            # asynchronous interrupts in the CPU-only harness.
            if hot and (self.fast_delays and address in (0x5C0F3, 0x5C0D4, 0x5868C)):
                _uc.reg_write(UC_X86_REG_CX, 1)
                self.accelerated_delays += 1
            if hot and (self.fast_delays and address in (0x5C0E3, 0x5C0C4, 0x5867C)):
                ah = (_uc.reg_read(UC_X86_REG_AX) >> 8) & 0xFF
                _uc.mem_write(0x152, bytes((ah,)))
                self.accelerated_delays += 1
            if hot and (self.fast_delays and self._supervisor_23 and address in (0x59CD9, 0x59D02, 0x59D28)):
                cx = _uc.reg_read(UC_X86_REG_CX)
                _uc.mem_write(0x14E, bytes((cx & 0xFF,)))
                self.accelerated_delays += 1
            if hot and self.fast_delays and address in (
                0x5D6E5, 0x5D70E, 0x5D734, 0x5D6FB, 0x5D724, 0x5D74A
            ):
                cl = _uc.reg_read(UC_X86_REG_CX) & 0xFF
                _uc.mem_write(0x14E, bytes((cl,)))
                self.accelerated_delays += 1
            # Command-mode initialization also waits directly on the 10 ms
            # timer countdown at 0000:0289 instead of using the delay helper.
            # With the countdown chain paced, the poller that feeds [0x649] is
            # running and the bridge answers it, so both the count and the
            # wait it runs inside are the firmware's own. Writing either one
            # here would only hide whether that path works.
            if hot and (
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
            if hot and (self.fast_delays and self.tick_source is None and address == 0x828A6):
                _uc.mem_write(0x8D6, b"\x00\x00")
                self.accelerated_delays += 1
            # Successful completion of the originating dialer returns through
            # 0x828ae.  On hardware the board-side line event posts dispatcher
            # event 3 at 0x1cf1, whose target at 0x65c61 enters the supervisor's
            # online/originate path.  The CPU-only timer model has no producer
            # for that event, leaving ATD parked in command mode after the
            # digits.  Reproduce the recovered event edge once per seizure.
            # Inter-digit cadence uses the timer word at 0000:0161.
            if hot and (
                self.fast_delays
                and self.tick_source is None
                and address in (0x6355F, 0x822E0, 0x82342, 0x8235B)
            ):
                # With the chain paced these are the dialer's own tone and
                # interdigit timers. Zeroing them makes the dialer outrun the
                # supervisor's 24-word send ring, which then drops every digit
                # after the first.
                _uc.mem_write(0x161, b"\x00\x00")
                self.accelerated_delays += 1
            # The same initialization waits for an 80186 peripheral-ready
            # indication in the relocated interrupt-control block.
            # The integrated UART's transmit-holding register never drains in a
            # CPU-only core, so the ready poll at 5b5e:186e finds status bit
            # 0x08 clear and spins on the transmit routine forever. This is a
            # missing device rather than a calibrated delay, so the modeled DTE
            # reports itself ready regardless of --real-delays.
            if hot and (address == 0x5CE4E):
                value = int.from_bytes(_uc.mem_read(0xFF66, 2), "little")
                if not value & 0x08:
                    _uc.mem_write(0xFF66, (value | 0x08).to_bytes(2, "little"))
            if hot and (self._supervisor_23 and address == 0x59435):
                value = int.from_bytes(_uc.mem_read(0xFF66, 2), "little")
                if not value & 0x08:
                    _uc.mem_write(0xFF66, (value | 0x08).to_bytes(2, "little"))
            if hot and (self.fast_delays and address == 0x5CE19):
                value = int.from_bytes(_uc.mem_read(0xFF66, 2), "little")
                _uc.mem_write(0xFF66, (value | 0x08).to_bytes(2, "little"))
                self.accelerated_delays += 1

        def service_chunk(_uc: Any, elapsed: int) -> None:
            """The board's periodic service, `elapsed` instructions on.

            Everything here used to run inside the per-instruction code
            hook. None of it is per-instruction work: the DSP clock is
            frame-paced, the console poll has its own period, and the
            interrupt sources are all edges the board samples rather than
            things the 80186 does. Servicing them every
            SERVICE_INSTRUCTIONS models the sampling the hardware actually
            does more honestly than testing them after every instruction,
            and it is what lets the code hook go away.
            """
            if self.quad_c50 is not None:
                self.quad_c50.service(elapsed)
            if self.quad_terminal is not None:
                self.quad_terminal.service(
                    self, bool(_uc.reg_read(UC_X86_REG_FLAGS) & 0x0200))
            if self.console is not None:
                self._console_owed -= elapsed
                if self._console_owed <= 0:
                    self._console_owed += self.console.poll_instructions
                    typed = self.console.poll()
                    if typed:
                        self.serial_rx.extend(typed)
                        # Input that lands mid-cooldown would otherwise wait
                        # out a transmit-side pause of up to 4096
                        # instructions.
                        self._serial_cooldown = min(self._serial_cooldown, 64)
                    if self.console.closed:
                        self.stop_requested = True
            if self.stop_requested:
                _uc.emu_stop()
            if self.dsp_bridge is not None and not self.stop_requested:
                self.dsp_bridge.clock_x86(elapsed)
            if self._serial_started and not self._serial_in_handler:
                if self._serial_cooldown:
                    self._serial_cooldown = max(0, self._serial_cooldown - elapsed)
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
                    tx_callback = self._serial_tx_callback
                    if tx_callback is None:
                        tx_callback = int.from_bytes(
                            _uc.mem_read(0x2AA, 2), "little"
                        )
                        self._serial_tx_callback = tx_callback
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
                    self._timer_cooldown = max(0, self._timer_cooldown - elapsed)
                elif _uc.reg_read(UC_X86_REG_FLAGS) & 0x0200:
                    self._timer_irq_requested = True
                    _uc.emu_stop()
            if (
                self.uart is not None
                and self.uart.holding
                and self._int1_pending is None
                and self.instructions >= self._rx_edge_at
                and self.timers.controller.enabled("int1")
                and _uc.reg_read(UC_X86_REG_FLAGS) & 0x0200
            ):
                self._rx_edge_at = self.instructions + RX_BIT_INSTRUCTIONS
                self._int1_pending = INT1_VECTOR
                _uc.emu_stop()
            if self.emulate_interrupts:
                self._timer_poll_owed -= elapsed
            if self.emulate_interrupts and self._timer_poll_owed <= 0:
                self._timer_poll_owed += TIMER_POLL_INSTRUCTIONS
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
                    self.uart is not None
                    and not self.uart.pending
                    and self.quad_terminal is None
                    # The ROM deliberately disables the integrated receiver
                    # while its timer/INT1 autobaud front end watches the raw
                    # pin. A physical DTE can still put a character on that
                    # pin; payload runs continue to require the UART enable.
                    and (self.uart.receive_enabled or self._rom_tick)
                    and self.serial_rx
                    and interrupts_on
                    and self.instructions >= DTE_TYPING_INSTRUCTIONS
                    and (
                        not self._rom_dte_opened
                        or self.uart.holding
                        # Let the parser finish its command/result before
                        # starting the next queued byte. Its busy RX handler
                        # deliberately discards input during this interval.
                        or int.from_bytes(_uc.mem_read(self._serial_callbacks + 4, 2), "little")
                        in (self._rom_serial.command_idle, self._rom_serial.command_collecting)
                    )
                    and (
                        not self._rom_tick
                        # The ROM must have a receive callback installed
                        # before a character means anything to it. Requiring
                        # one specific pointer value here was reading a
                        # constant out of the IDSDL302 reference build: the
                        # captured 7.4.16 board holds zero in this cell for
                        # the whole run, so no ROM but that one could ever
                        # take input. What the callback has to be is present.
                        or self._rom_dte_opened
                        or int.from_bytes(_uc.mem_read(self._serial_callbacks, 2), "little") != 0
                    )
                ):
                    if self._rom_serial is not None and not self._rom_dte_opened:
                        # CPU-only DTE adapter: enter the ROM's byte-oriented
                        # attention detector after boot. This substitutes for
                        # raw-pin autobaud, not for AT parsing or UART output.
                        layout = self._rom_serial
                        _uc.mem_write(layout.mode, b"\x02")
                        _uc.mem_write(layout.callbacks, layout.attention.to_bytes(2, "little"))
                        _uc.mem_write(layout.callbacks + 4, layout.command_idle.to_bytes(2, "little"))
                        flags = _uc.mem_read(layout.output_flags, 1)[0]
                        _uc.mem_write(layout.output_flags, bytes((flags & ~1,)))
                        self._rom_dte_opened = True
                        self._trace_serial("rom-dte: firmware attention adapter")
                    elif self._rom_dte_opened and not self.uart.holding:
                        layout = self._rom_serial
                        command = int.from_bytes(_uc.mem_read(layout.callbacks + 4, 2), "little")
                        if command == layout.command_idle:
                            # Firmware has finished the previous command and
                            # requested attention/autobaud again. Retain its
                            # command state; route the next byte through its
                            # A/T detector instead of the raw-pin sampler.
                            _uc.mem_write(layout.callbacks, layout.attention.to_bytes(2, "little"))
                    # Put the character on the wire before handing it over.
                    # The ROM's callback chain watches the raw line for the
                    # idle-then-start transition, so a byte that appeared in
                    # the buffer with the line never having gone low is one
                    # the chain cannot see.
                    if not self.uart.holding:
                        self.uart.holding = True
                        self._rx_started_at = self.instructions
                        self._rx_edge_at = self.instructions + RX_BIT_INSTRUCTIONS
                        self._rom_rx_bit = 0
                    elif self.instructions - self._rx_started_at >= START_BIT_INSTRUCTIONS:
                        self.uart.holding = False
                        if self._rom_dte_opened:
                            # Temporary autobaud handlers reuse type 0x14.
                            # The byte-oriented adapter delivers through this
                            # image's integrated-UART ISR.
                            vector = self._rom_serial.receive_isr.to_bytes(2, "little")
                            _uc.mem_write(0x0050, vector + b"\x00\x80")
                            self.uart.control = 0x21
                        byte = self.serial_rx.popleft()
                        self._trace_serial(
                            f"rom-rx {byte:02x} callbacks="
                            + bytes(_uc.mem_read(self._serial_callbacks, 6)).hex()
                        )
                        self.uart.deliver(byte)
                        _uc.emu_stop()
                if self.quad_usart is not None:
                    # The DUART drives Quad INT0 (type 0x0c). Its ISR starts
                    # with STI, so IF alone cannot prevent recursive entry:
                    # retain in-service until the firmware's PCB EOI write.
                    self.quad_usart.advance()
                    if (interrupts_on and self.quad_usart.irq_pending
                            and self.timers.controller.enabled("int0")
                            and not self._quad_irq_in_service
                            and self._int0_pending is None):
                        self._int0_pending = INT0_VECTOR
                # The modem's C50 timer pulses XF (8467..847f). Route those
                # edges to its INT0, separately from the controller's DUART.
                # Retain in-service through EOI: the modem ISR also uses STI.
                if (self.quad_c50 is not None and self.quad_c50.irq_pending
                        and interrupts_on and self.timers.controller.enabled("int0")
                        and not self._quad_irq_in_service and self._int0_pending is None):
                    self._int0_pending = INT0_VECTOR
                    self.quad_c50.irq_pending = False
                if (
                    not self._quad_profile
                    and self._int0_pending is None
                    and interrupts_on
                    and self.instructions - self._last_frame >= self.frame_instructions
                    and self._int0_vector_installed(_uc)
                ):
                    # Advance the phase by exactly one period, the way the
                    # bridge's own counters do, instead of restarting it here.
                    # Resetting it to `now` absorbed every polling delay
                    # permanently: the check only runs at the service loop's
                    # granularity, so each edge landed a little late and the
                    # next was measured from the late one. It cost 4.8% - 510.5
                    # Hz delivered against 536 nominal - and it cost it
                    # unevenly, because the granularity depends on what the CPU
                    # is running, which is how a constant offset appeared
                    # between two countdowns that should have matched.
                    #
                    # A debt of more than one period is dropped rather than
                    # burst, which is what the hardware does: the controller
                    # latches one pending edge, and `_int0_pending` is that one
                    # slot. Interrupts being off for a while loses edges on the
                    # board too; it does not bank them.
                    self._last_frame += self.frame_instructions
                    if self.instructions - self._last_frame >= self.frame_instructions:
                        self._last_frame = self.instructions - self.frame_instructions
                    self._int0_pending = INT0_VECTOR
                if interrupts_on and (
                    self._int0_pending is not None
                    or self.uart is not None and self.uart.pending
                    or self._external_interrupt_pending is not None
                    or self._int1_pending is not None
                    or self._timer_interrupt_pending is not None
                ):
                    # A source is queued but the run loop only dispatches when
                    # emulation stops, and every branch that stops it is gated
                    # on nothing being queued. One source left over from an
                    # iteration that dispatched a different one therefore
                    # wedged the run: no stop, so no dispatch, so no further
                    # stop. Stop again while anything is outstanding. The
                    # dispatch clears IF, so a handler still runs to its IRET
                    # before the next source is delivered.
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
                (self._rom_tick or self._quad_modem_tick)
                and self.tick_ms
                and (not self._quad_modem_tick or self.timers.controller.enabled("int3"))
                and not self._serial_in_handler
                and not self._timer_in_handler
                and self._external_interrupt_pending is None
                and self._timer_interrupt_pending is None
                and self.instructions - self._last_tick
                >= self.tick_ms * INSTRUCTIONS_PER_MS
                and _uc.reg_read(UC_X86_REG_FLAGS) & 0x0200
            ):
                # The tick keeps the vector the ROM's own handlers install.
                # INT1 rides alongside it whenever the firmware has that
                # source unmasked - it is gated on the mask rather than
                # bypassing it, unlike the tick.
                self._last_tick = self.instructions
                self._external_interrupt_pending = TICK_VECTOR
                if (
                    self._rom_tick
                    and self._int1_pending is None
                    and self.timers.controller.enabled("int1")
                ):
                    self._int1_pending = INT1_VECTOR

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

        def on_milestone_code(_uc: Any, address: int, _size: int, _data: Any) -> None:
            """The four addresses that name a stage of the boot.

            Bounded to those addresses rather than tested on every
            instruction; `_milestone_addresses` still decides.
            """
            milestone = self._milestone_addresses.get(address)
            if milestone is not None and milestone not in self.milestones:
                self.milestones.append(milestone)
                if milestone == "main-loop":
                    self.port_values.update(self.runtime_port_values)
                    if (
                        self.force_online
                        and self.dsp_bridge is not None
                        and not self.online_mode
                    ):
                        self.dsp_bridge.force_connected_event()
                        self.online_mode = True
                        # The firmware result path is precisely what is being
                        # bypassed here, so provide the DTE-visible boundary
                        # explicitly rather than making --force-online silent.
                        for byte in b"\r\nCONNECT\r\n":
                            self._capture_serial(byte)
                        self.serial_trace.append("forced-data-mode")
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
                serial_callbacks = (
                    ((0x2A8, 0xAE9B), (0x2AA, 0x1FB2), (0x2AE, 0xA420))
                    if self._alternate_supervisor
                    else (
                        ((0x2A8, 0xAEED), (0x2AA, 0x18F5), (0x2AE, 0x9138))
                        if self._supervisor_23
                        else ((0x2A8, 0xACDF), (0x2AA, 0x1FCE), (0x2AE, 0x2088))
                    )
                )
                for pointer, fallback in serial_callbacks:
                    if bytes(_uc.mem_read(pointer, 2)) == b"\x00\x00":
                        _uc.mem_write(pointer, fallback.to_bytes(2, "little"))
                        if pointer == 0x2AA:
                            self._serial_tx_callback = fallback
                        self.serial_trace.append(f"callback {pointer:03x}={fallback:04x}")
                if self._terminal_attached:
                    if self._alternate_supervisor:
                        # 2.2.05 moved the command collector one byte block:
                        # its RX callback tests [0x1d16].6 and compares the
                        # terminator against [0x0903].
                        _uc.mem_write(0x0903, b"\x0d")
                        collector_state = bytes(_uc.mem_read(0x1D16, 1))[0]
                        _uc.mem_write(0x1D16, bytes((collector_state | 0x40,)))
                    if self._supervisor_23:
                        # 2.3's RX callback compares the received byte with
                        # this firmware-owned command terminator before it
                        # dispatches the line parser. The board setup normally
                        # supplies CR; the XMF lacks that EEPROM/peripheral
                        # initialization path.
                        _uc.mem_write(0x0905, b"\x0d")
                        command_state = bytes(_uc.mem_read(0x1D26, 1))[0]
                        _uc.mem_write(0x1D26, bytes((command_state | 0x40,)))
                    command_flags = bytes(_uc.mem_read(0x1CEE, 1))[0] | 0x40
                    _uc.mem_write(0x1CEE, bytes((command_flags,)))
                    # The 2.3 image enters its parser through the resident
                    # command entry at A7A0; older supervisors use A8D9.
                    ready_callback = (
                        0xA420 if self._alternate_supervisor
                        else 0xA7A0 if self._supervisor_23
                        else 0xA8D9
                    )
                    _uc.mem_write(0x2AC, ready_callback.to_bytes(2, "little"))
                    self.serial_trace.append(f"callback 2ac={ready_callback:04x}")
                self._serial_started = self._payload_hooks
                self._serial_tx_pump = not self.serial_rx
                self._serial_empty_probes = 0
                self._serial_cooldown = 512

        def on_code(_uc: Any, address: int, _size: int, _data: Any) -> None:
            """Per-instruction work, registered only when something needs it.

            The diagnostics are opt-in, and the address ring and the
            previous-address record are only read by paths that a run
            without serial input or a DSP-paced tick never takes. See
            `_needs_code_hook`.
            """
            # These two are keyed on the instruction that ran *before* this
            # one, so they have to see every instruction. An ISR's iret lands
            # on its return target, which is an ordinary address nowhere near
            # _HOT_ADDRESSES - so they cannot live in on_hot_code, whose
            # ranged registration and `if not hot: return` only ever let a hot
            # address through. They did live there between 8a6067e and this
            # commit, which left the DTE deaf: the serial ISR never finished,
            # so no command was ever parsed.
            if self._serial_in_handler and (
                address in (0x5D613, 0x5D650, 0x5D656)
                or (self._supervisor_23 and address in (0x59BF2, 0x59C35))
                or self._previous_address in (
                    0x5D608, 0x5D613, 0x5D640, 0x5D650, 0x5D656,
                )
                or (
                    self._supervisor_23
                    and self._previous_address in (0x59BEB, 0x59BF2, 0x59C2F, 0x59C35)
                )
            ):
                self.serial_trace.append(f"iret {self._previous_address:05x}")
                callbacks = bytes(_uc.mem_read(self._serial_callbacks, 6))
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
            if self._code_observer is not None:
                self._code_observer(address)
            if self.pc_watch and address in self.pc_watch:
                name = self.pc_watch[address]
                self.pc_watch_counts[name] += 1
                # Every hit is counted; only the first few of each carry the
                # registers, which is what keeps a hot address from filling
                # the report with its own repetition.
                if self.pc_watch_counts[name] <= PC_WATCH_SAMPLES:
                    ax = _uc.reg_read(UC_X86_REG_AX)
                    si = _uc.reg_read(UC_X86_REG_SI)
                    ds = _uc.reg_read(UC_X86_REG_DS)
                    record = {
                        "name": name,
                        "pc": f"{address:05x}",
                        "instructions": self.instructions,
                        "ax": f"{ax:04x}",
                        "al": f"{ax & 0xFF:02x}",
                        "bx": f"{_uc.reg_read(UC_X86_REG_BX):04x}",
                        "cx": f"{_uc.reg_read(UC_X86_REG_CX):04x}",
                        "dx": f"{_uc.reg_read(UC_X86_REG_DX):04x}",
                        "si": f"{si:04x}",
                        "flags": f"{_uc.reg_read(UC_X86_REG_FLAGS):04x}",
                        "cs": f"{_uc.reg_read(UC_X86_REG_CS):04x}",
                    }
                    # At a routine's entry the top of stack is its return
                    # address, which is what names the caller. Both a near
                    # offset and the segment above it are recorded; which of
                    # the two applies depends on how the routine was called.
                    try:
                        stack = (_uc.reg_read(UC_X86_REG_SS) << 4) + _uc.reg_read(UC_X86_REG_SP)
                        raw = bytes(_uc.mem_read(stack, 4))
                        record["ret_off"] = f"{int.from_bytes(raw[0:2], 'little'):04x}"
                        record["ret_seg"] = f"{int.from_bytes(raw[2:4], 'little'):04x}"
                    except Exception:
                        pass
                    # A string the routine is about to parse is the argument
                    # that decides the dispatch, so capture a little of it.
                    try:
                        text = bytes(_uc.mem_read((ds << 4) + si, 12))
                        record["at_si"] = text.decode("latin-1")
                    except Exception:
                        pass
                    self.pc_watch_events.append(record)
            if self.track_executed:
                self.executed[address] += 1
            self.last_addresses.append(address)
            self._previous_address = address


        def on_in(_uc: Any, port: int, size: int, _data: Any) -> int:
            if self.quad_c50 is not None:
                answered = self.quad_c50.read(port, size)
                if answered is not None:
                    self._record_io("in", port, size, answered, current_pc())
                    return answered
            if self.quad_board is not None:
                answered = self.port_values.get(port)
                if answered is None:
                    answered = self.quad_board.read(port, size)
                if answered is not None:
                    self._record_io("in", port, size, answered, current_pc())
                    return answered
            if self.quad_usart is not None:
                answered = self.quad_usart.read(port, size)
                if answered is not None:
                    self._record_io("in", port, size, answered, current_pc())
                    return answered
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
                if self.online_mode:
                    self.data_rx_bytes += 1
                    if len(self.serial_trace) < MAX_SERIAL_TRACE_EVENTS:
                        self.serial_trace.append(f"data-rx {terminal_value:02x}")
                value = serial_wire_value(terminal_value)
                if self._alternate_supervisor or self._supervisor_23:
                    if terminal_value in (10, 13):
                        line = bytes(self._alternate_line)
                        if self._alternate_supervisor:
                            # The 2.2.05 supervisor retains the legacy
                            # command parser's buffer even though its flash
                            # boundary moved.  Keep both observed aliases in
                            # sync until the callback table selects the
                            # parser; the firmware still owns parsing/results.
                            bounded = line[:0x3C]
                            parsed = attention_body(bounded)
                            if parsed is not None:
                                bounded = parsed
                            _uc.mem_write(0x1CF5, bounded + b"\x00\x00")
                            _uc.mem_write(0x1CF4, bytes((len(bounded),)))
                            _uc.mem_write(0x1D1D, bounded + b"\x00\x00")
                            _uc.mem_write(0x1D1C, bytes((len(bounded),)))
                            # The attention detector marks the completed
                            # line for the relocated command parser here.
                            _uc.mem_write(0x1D1A, b"\x01")
                            _uc.mem_write(0x2AC, (0xAAB2).to_bytes(2, "little"))
                        if self._supervisor_23:
                            _uc.mem_write(0x1D2D, line + b"\x00\x00")
                            _uc.mem_write(0x1D2C, bytes((min(len(line), 0x3C),)))
                            # The 2.3 RX callback gates its terminator path
                            # on bit 6 of the command-state byte. The normal
                            # board front-end sets this while handing a line
                            # to the supervisor; the XMF path has no such
                            # front-end, so preserve the firmware contract
                            # explicitly before the callback runs.
                            state = bytes(_uc.mem_read(0x1D26, 1))[0]
                            _uc.mem_write(0x1D26, bytes((state | 0x40,)))
                        body = attention_body(line)
                        if body is not None and self.dsp_bridge is not None:
                            self.dsp_bridge.arm_dial_tones(body)
                            self._trace_serial(f"alternate attention body={body!r}")
                        self._alternate_line.clear()
                    else:
                        self._alternate_line.append(terminal_value)
                terminator = bytes(_uc.mem_read(0x8E3, 1))[0]
                self.serial_trace.append(
                    f"rx terminal={terminal_value:02x} wire={value:02x} "
                    f"terminator={terminator:02x} pc={current_pc():05x}"
                )
                echo_command_byte(_uc, terminal_value)
                if not self.serial_rx:
                    self._serial_tx_pump = True
            elif self.uart is not None and port == 0 and size == 1:
                # Port 0 is a read/write control latch on the ROM builds, and
                # the firmware treats it as one: 0x81703 does `in al,0 / and
                # al,33 / or al,40 / out 0,al`, keeping four bits of what it
                # read. Answering the open-bus 0xff forced 0x01, 0x02, 0x10
                # and 0x20 set on every such cycle, and left bit 0x08 - the
                # second serial port's receive-pending flag, tested at
                # 0x81d45 - reading as "a byte is waiting" forever.
                #
                # So: the output bits read back from the latch, the four
                # capability inputs keep the undriven high level, and 0x08
                # stays clear while nothing is attached to that port - the
                # byte it guards is read with `in al,0x0a` at 0x81d4f.
                value = (
                    PORT0_INPUTS
                    | (self.port0_latch & PORT0_OUTPUTS)
                ) & ~PORT0_RX_PENDING
            else:
                bridged = self.dsp_bridge.read(port, size) if self.dsp_bridge is not None else None
                value = self.port_values.get(port, bridged if bridged is not None else mask)
                if port in (0x10, 0x12, 0x14) and size == 1:
                    # A closed option switch pulls its latch input bit low.
                    value &= ~self.panel.dip_input(port, rom=self._rom_serial is not None)
                if port == 0x12 and size == 1:
                    # The ROM's latch table maps input selector 3 to port
                    # 0x12. Bit 6 is the active-low DTE DTR input: an
                    # attached terminal pulls it low, which opens the normal
                    # receive path instead of installing the discard callback.
                    if self._terminal_attached:
                        value &= ~0x40
                    else:
                        value |= 0x40
                if self.panel.board_id is not None and port == 0x14 and size == 1:
                    # The identification scan at 0x5bfc6 reads its sense line
                    # here while holding one drive line low.
                    if self.panel.strap_sense():
                        value |= STRAP_SENSE_BIT
                    else:
                        value &= ~STRAP_SENSE_BIT
                if port == 0x14 and size == 1:
                    # DTR is high while an ordinary terminal remains
                    # attached. The serial-PnP state machine deliberately
                    # looks for a high-to-low strobe followed by RX-ready in
                    # a narrow counter window; do not manufacture that Win95
                    # enumeration sequence for plain queued AT input.
                    if self._terminal_attached:
                        value |= 0x01
                    else:
                        value &= ~0x01
                if port == RING_DETECT_PORT and size == 1:
                    # The answer machine polls the ring detector here with a
                    # direct `in al, 0x14` at 0x70fb4 and 0x70fc1. An idle
                    # subscriber line is not ringing, and leaving the bit
                    # floating high reads as a ring that never ends, which
                    # parks that state machine in its first state forever.
                    peer_ringing = bool(
                        self.dsp_bridge is not None
                        and self.dsp_bridge.line is not None
                        and self.dsp_bridge.line.peer_ringing
                    )
                    exchange_ringing = bool(
                        self.dsp_bridge is not None
                        and self.dsp_bridge.exchange is not None
                        and self.dsp_bridge.exchange.ringing
                    )
                    if (
                        peer_ringing
                        or exchange_ringing
                        or (self.ring is not None and self.ring.present(self.instructions))
                    ):
                        value |= RING_DETECT_BIT
                    else:
                        value &= ~RING_DETECT_BIT
                if self.nvram is not None and port == 0x10 and size == 1:
                    # Board latch 0 reads back the settings EEPROM's ready and
                    # data-out pins; every other bit keeps its floating level.
                    value = (value & ~(NVRAM_INPUT_BITS)) | self.nvram.read_latch()
            value &= mask
            if (
                self.dsp_bridge is not None
                and getattr(self.dsp_bridge, "_completion_probe", False)
                and port in (0x20, 0x1C, 0x1E)
                and len(self.serial_trace) < 2048
            ):
                self.serial_trace.append(
                    f"call-gate in{port:02x}={value:04x} pc={current_pc():05x}"
                )
            self._record_io("in", port, size, value, current_pc())
            if port in (0x5C, 0x5E) and self.dsp_bridge is not None and len(self.serial_trace) < 2048:
                self.serial_trace.append(f"status-in {port:02x}={value:02x} pc={current_pc():05x}")
            return value

        def on_out(_uc: Any, port: int, size: int, value: int, _data: Any) -> None:
            if self.quad_c50 is not None:
                self.quad_c50.write(port, size, value)
            if self.quad_board is not None and self.quad_board.write(port, size, value):
                self._record_io("out", port, size, value, current_pc())
                return
            if self.quad_usart is not None and self.quad_usart.write(port, size, value):
                self._record_io("out", port, size, value, current_pc())
                return
            mask = (1 << (size * 8)) - 1
            value &= mask
            self.output_latches[port] = value
            if self.uart is not None and port == 0 and size == 1:
                # Bit 0x40 is the speaker: 0x81703 raises it and drops it again
                # in the next instruction pair, which is one click. Count the
                # rising edges so a run can show what the board would sound.
                if value & PORT0_SPEAKER and not self.port0_latch & PORT0_SPEAKER:
                    self.speaker_pulses += 1
                self.port0_latch = value
            pc = current_pc()
            self._record_io("out", port, size, value, pc)
            if size == 1:
                previous_hook = self.panel.off_hook
                self.panel.observe_write(port, value, pc, self.instructions)
                if (
                    self.dsp_bridge is not None
                    and self.panel.off_hook != previous_hook
                ):
                    # The hook relay is a board output like any other, so the
                    # line hears the seizure the firmware actually performed.
                    self.dsp_bridge.set_line_hook(self.panel.off_hook)
                    self._trace_serial(
                        f"hook {'off' if self.panel.off_hook else 'on'} pc={pc:05x}"
                    )
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
                    if self.online_mode:
                        self.data_tx_bytes += 1
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
                if self._quad_profile:
                    self._quad_interrupt_stack.append(number)
                uc.reg_write(UC_X86_REG_FLAGS, flags & ~0x0200)
            uc.reg_write(UC_X86_REG_CS, segment)
            uc.reg_write(UC_X86_REG_IP, offset)
            return (segment * 16 + offset) & 0xFFFFF

        def on_mmio_read(_uc: Any, _access: int, address: int, size: int, _value: int, _data: Any) -> None:
            self.mmio_counts[("read", address, size)] += 1
            # The hook runs before the read is satisfied, so a timer register
            # is answered by putting the modelled value where the read will
            # find it. Everything else in the control block stays plain memory.
            # Both of a ROM's DSP transfer routines escape every handshake
            # wait on timer 2's max count, so the acceleration that hands that
            # bit to a calibrated delay at its first poll would report a
            # transfer failure instead. The XMF supervisor's download loop has
            # the same collision, handled by address above.
            span = self._rom_transfer_span
            grant = span is None or not span[0] <= current_pc() < span[1]
            modelled = self.timers.read(
                address, size, self.instructions, grant=grant
            )
            if modelled is None and self.uart is not None:
                modelled = self.uart.read(address, size)
            if modelled is not None:
                _uc.mem_write(address, modelled.to_bytes(size, "little"))
            elif (
                address == 0xFF5A
                and size == 1
                and self.dsp_bridge is not None
                and self.dsp_bridge.connected_event_queued
                and hasattr(self.dsp_bridge.core, "data")
                and self.dsp_bridge.core.data(0x039F) & 0x0100
            ):
                # The supervisor's 7a59:1e7c completion wait samples ASIC
                # latch ff5a. The C52 customer-ROM scheduler exposes the same
                # completion edge as ready bit 8 in data cell 039f.
                value = bytes(_uc.mem_read(address, size))[0] | 0x20
                _uc.mem_write(address, bytes((value,)))
                if len(self.serial_trace) < 2048:
                    self.serial_trace.append("call-gate ff5a=20")
            if address == 0xFF5A and self.nvram is not None:
                # Present the chip's DO on the same pin 7 the driver samples.
                sampled = bytes(_uc.mem_read(address, size))
                bit = 0x80 if self.nvram.read_latch() & BIT_DATA else 0x00
                _uc.mem_write(address, bytes(((sampled[0] & 0x7F) | bit,)) + sampled[1:])
            if address == 0xFF5A and self.uart is not None:
                # Port 2 pin 5 is the physical serial receive line sampled by
                # the ROM's timer ISR during autobaud. It idles at mark/high;
                # presenting the reset value (low) fabricates an endless
                # start bit, after which the ROM disables its receiver.
                sampled = bytes(_uc.mem_read(address, size))
                bit = 0x00 if self.uart.holding else 0x20
                if (
                    self.uart.holding
                    and self.serial_rx
                    and current_pc() in (0x9EDF9, 0x9EE35)
                ):
                    # Before enabling the 80C186 receiver, this ROM measures
                    # and assembles the first character through timer 2. Feed
                    # those eight sampling reads from the same queued byte,
                    # least-significant bit first, exactly as its RCR loop
                    # expects. Later characters arrive through S0RBUF.
                    terminal_value = self.serial_rx[0]
                    bit = ((terminal_value >> self._rom_rx_bit) & 1) << 5
                    self._rom_rx_bit += 1
                    if self._rom_rx_bit == 8:
                        self.serial_rx.popleft()
                        self.uart.holding = False
                        self.uart.received += 1
                        self._rom_rx_bit = 0
                _uc.mem_write(address, bytes(((sampled[0] & 0xDF) | bit,)) + sampled[1:])
            if (
                self.dsp_bridge is not None
                and getattr(self.dsp_bridge, "_completion_probe", False)
                and len(self.serial_trace) < 2048
            ):
                value = int.from_bytes(_uc.mem_read(address, size), "little")
                self.serial_trace.append(
                    f"call-gate mmio {address:04x}={value:04x} pc={current_pc():05x}"
                )
            if len(self.mmio_events) < self.max_io_events:
                value = int.from_bytes(_uc.mem_read(address, size), "little")
                self.mmio_events.append(MmioEvent("read", address, size, value, current_pc()))

        def on_mmio_write(_uc: Any, _access: int, address: int, size: int, value: int, _data: Any) -> None:
            self.mmio_counts[("write", address, size)] += 1
            if self.quad_board is not None:
                self.quad_board.write_register(address, size, value)
            self.timers.write(address, size, value, self.instructions)
            if address == 0xFF02 and self._quad_interrupt_stack:
                if value & 0x8000:
                    completed = self._quad_interrupt_stack.pop()
                else:
                    completed = value & 0x1f
                    if completed in self._quad_interrupt_stack:
                        self._quad_interrupt_stack.remove(completed)
                if completed == INT0_VECTOR:
                    self._quad_irq_in_service = False
            if address == DSP_RESET_PORT and self.dsp_bridge is not None:
                # The board holds the C52 in reset through this bit, and a part
                # in reset drives nothing: its transfer interface reads back as
                # all ones. Both firmwares reset the coprocessor by pulsing the
                # bit low and then wait for that all-ones state - the ROM at
                # 8e3aa, the payload at 69c61 - so the bus floats on the edge
                # the board actually produces rather than at either of those
                # addresses. probe_transport models the same edge.
                #
                # This net is shared: DSP `RS` (pin 127) also reaches the
                # codec's RESET pin, so on the board every one of these pulses
                # resets the codec too and returns its registers to defaults.
                # Nothing below models that - see docs/asic-pinout.md.
                asserted = not value & DSP_RESET_BIT
                if asserted and not self._dsp_in_reset:
                    self.dsp_bridge.float_runtime_bus()
                self._dsp_in_reset = asserted
            if self.uart is not None:
                sent = self.uart.write(address, size, value)
                if sent is not None:
                    self._capture_serial(sent)
            if self.nvram is not None:
                # The ROM's EEPROM driver shares one data line on port 2 pin 7:
                # it drives the latch at ff5e while the direction bit in ff58 is
                # clear, then sets that bit and samples the same pin at ff5a.
                # Chip select and clock are ff56 bits 0x20 and 0x04. Translate
                # those into the latch encoding the 93C66 model already speaks.
                if address == 0xFF5E:
                    self._eeprom_data_in = bool(value & 0x80)
                elif address == 0xFF56:
                    latch = 0
                    if value & 0x20:
                        latch |= BIT_CHIP_SELECT
                    if value & 0x04:
                        latch |= BIT_CLOCK
                    if self._eeprom_data_in:
                        latch |= BIT_DATA
                    self.nvram.write_latch(latch)
            if len(self.mmio_events) < self.max_io_events:
                self.mmio_events.append(MmioEvent("write", address, size, value, current_pc()))

        def on_mem_watch(
            _uc: Any, _access: int, address: int, size: int, value: int, _data: Any
        ) -> None:
            if len(self.mem_watch_events) >= MEM_WATCH_EVENTS:
                self.mem_watch_events.pop(0)
            self.mem_watch_events.append({
                "address": f"{address:04x}",
                "size": size,
                "value": f"{value & 0xFFFF:04x}",
                "pc": f"{current_pc():05x}",
                "instructions": self.instructions,
            })

        def on_serial_tx_callback_write(
            _uc: Any, _access: int, _address: int, _size: int, _value: int, _data: Any
        ) -> None:
            # The firmware has rewritten the transmit callback - a board
            # discovery, a reset, or the front end taking it down. Drop the
            # cached word so the pump reads the new one.
            self._serial_tx_callback = None

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


        # The harness clock. Unicorn will say how big a basic block is but not
        # how many instructions are in it, so each distinct block is
        # disassembled once and counted; there are a few hundred in a run. The
        # block hook fires about once per three instructions instead of once
        # per instruction, and carries the periodic service with it.
        block_instructions: dict[tuple[int, int], int] = {}
        disassembler = None
        if _capstone is not None:
            disassembler = _capstone.Cs(_capstone.CS_ARCH_X86, _capstone.CS_MODE_16)

        def count_block(address: int, size: int) -> int:
            try:
                data = bytes(uc.mem_read(address, size))
            except Exception:
                return 1
            return max(1, sum(1 for _ in disassembler.disasm(data, address)))

        def on_block(_uc: Any, address: int, size: int, _data: Any) -> None:
            key = (address, size)
            count = block_instructions.get(key)
            if count is None:
                count = count_block(address, size)
                block_instructions[key] = count
            self.instructions += count
            if self.instructions >= self._next_service:
                elapsed = self.instructions - self._last_service
                self._last_service = self.instructions
                self._next_service = self.instructions + SERVICE_INSTRUCTIONS
                service_chunk(_uc, elapsed)

        def on_code_counting(_uc: Any, address: int, _size: int, _data: Any) -> None:
            """The clock and the service, one instruction at a time.

            The fallback for a build with no capstone to size a basic block
            with. Correct, and about four times slower.
            """
            self.instructions += 1
            if self.instructions >= self._next_service:
                elapsed = self.instructions - self._last_service
                self._last_service = self.instructions
                self._next_service = self.instructions + SERVICE_INSTRUCTIONS
                service_chunk(_uc, elapsed)

        for _low, _high in _HOT_HOOK_RANGES:
            uc.hook_add(UC_HOOK_CODE, on_hot_code, None, _low, _high)
        if self._milestone_addresses:
            for _address in self._milestone_addresses:
                uc.hook_add(UC_HOOK_CODE, on_milestone_code, None, _address, _address)
        if self._needs_code_hook():
            uc.hook_add(UC_HOOK_CODE, on_code)
        # Complete ROM runs have hardware-facing UART and interrupt models and
        # normally need no per-instruction diagnostic state. Count their basic
        # blocks in a native hook: the equivalent Python callback crosses the
        # FFI boundary for almost every two guest instructions and is slower
        # than the emulation itself. Payload and diagnostic runs retain the
        # Python hook because their traces consume its per-block state.
        fast_rom_clock = bool(
            self._rom_tick and disassembler is not None and not self._needs_code_hook()
        )
        def native_service(total: int, elapsed: int) -> None:
            self.instructions = total
            self._last_service = total
            service_chunk(uc, elapsed)
            self._next_service = total + NATIVE_ROM_SERVICE_INSTRUCTIONS

        native_clock = (
            NativeX86Clock(
                uc, self.instructions,
                NATIVE_ROM_SERVICE_INSTRUCTIONS,
                native_service,
            )
            if fast_rom_clock else None
        )
        if disassembler is not None and not fast_rom_clock:
            uc.hook_add(UC_HOOK_BLOCK, on_block)
        elif disassembler is None:
            uc.hook_add(UC_HOOK_CODE, on_code_counting)
        uc.hook_add(UC_HOOK_INSN, on_in, None, 1, 0, UC_X86_INS_IN)
        uc.hook_add(UC_HOOK_INSN, on_out, None, 1, 0, UC_X86_INS_OUT)
        uc.hook_add(UC_HOOK_INTR, on_interrupt)
        uc.hook_add(UC_HOOK_MEM_READ, on_mmio_read, None, 0xFF00, 0xFFFF)
        uc.hook_add(UC_HOOK_MEM_WRITE, on_mmio_write, None, 0xFF00, 0xFFFF)
        uc.hook_add(UC_HOOK_MEM_WRITE, on_dsp_queue_write, None, 0x02CA, 0x030F)
        uc.hook_add(
            UC_HOOK_MEM_WRITE, on_serial_tx_callback_write, None, 0x02AA, 0x02AB
        )
        if self.mem_watch is not None:
            uc.hook_add(
                UC_HOOK_MEM_WRITE, on_mem_watch, None, self.mem_watch[0], self.mem_watch[1]
            )
        status = "instruction-limit"
        error: str | None = None
        try:
            begin = self.image.entry_physical
            if self._resume_state is not None:
                # Turn-taking: this machine ran before, yielded, and is being
                # handed back. run() always builds a fresh Uc, so the previous
                # CPU state is written back into it and execution continues from
                # where it stopped instead of from the reset vector. Memory is
                # restored by the caller, which owns the channel it is shared
                # with; only the processor state belongs here.
                state = self._resume_state
                self._resume_state = None
                from unicorn import x86_const as _x86
                for name, value in state["registers"].items():
                    uc.reg_write(getattr(_x86, f"UC_X86_REG_{name}"), value)
                self.instructions = state["instructions"]
                begin = state["pc"]
            while self.instructions < instruction_limit and not self.stop_requested:
                # A real 80186 wraps segment:offset addresses at 20 bits.  In
                # particular this firmware reaches F800:8000 (linear 1 MiB)
                # during startup and continues at physical zero.  Passing 1
                # MiB as Unicorn's optional stop PC terminates the run at that
                # boundary before Unicorn can apply real-mode wrapping.
                uc.emu_start(begin, 0, count=instruction_limit - self.instructions)
                if native_clock is not None:
                    self.instructions = native_clock.instructions
                # Unicorn returns after HLT. The Quad modem's scheduler uses
                # STI/HLT between events; clocks and peripherals continue while
                # its CPU sleeps. Advance the same bounded simulation clock,
                # then deliver the interrupt at the instruction after HLT.
                if (self._quad_profile
                        and bytes(uc.mem_read((current_pc() - 1) & 0xfffff, 1)) == b"\xf4"
                        and uc.reg_read(UC_X86_REG_FLAGS) & 0x0200):
                    while self.instructions < instruction_limit and not self.stop_requested:
                        if (self._external_interrupt_pending is not None
                                or self._int0_pending is not None
                                or self._int1_pending is not None
                                or self._timer_interrupt_pending is not None
                                or self.uart is not None and self.uart.pending):
                            break
                        elapsed = min(SERVICE_INSTRUCTIONS, instruction_limit - self.instructions)
                        self.instructions += elapsed
                        service_chunk(uc, elapsed)
                        self._last_service = self.instructions
                        self._next_service = self.instructions + SERVICE_INSTRUCTIONS
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
                if self._int0_pending is not None:
                    if self.quad_usart is not None or self.quad_c50 is not None:
                        self._quad_irq_in_service = True
                    begin = dispatch_interrupt(self._int0_pending, software=False)
                    self._int0_pending = None
                    continue
                if self.uart is not None and self.uart.pending:
                    begin = dispatch_interrupt(
                        self.uart.pending.popleft(), software=False
                    )
                    continue
                if self._int1_pending is not None:
                    begin = dispatch_interrupt(self._int1_pending, software=False)
                    self._int1_pending = None
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
        final_callbacks = bytes(uc.mem_read(self._serial_callbacks, 6))
        self.serial_trace.append(
            f"final callbacks[{self._serial_callbacks:03x}]="
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
        if native_clock is not None:
            native_clock.close()
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
            speaker_pulses=self.speaker_pulses,
            output_latches={
                f"{port:#06x}": value for port, value in sorted(self.output_latches.items())
            },
            mmio_summary=self._summarize(self.mmio_counts),
            hot_addresses=self.executed.most_common(20),
            pc_watch=self.pc_watch_events,
            peek=self._peek_values(),
            mem_watch=self.mem_watch_events,
            pc_watch_counts=dict(self.pc_watch_counts),
            last_addresses=list(self.last_addresses),
            serial_text=self.serial.decode("ascii", "backslashreplace"),
            data_rx_bytes=self.data_rx_bytes,
            data_tx_bytes=self.data_tx_bytes,
            online_mode=self.online_mode,
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
            supervisor_call_cells={
                f"{address:04x}": int.from_bytes(uc.mem_read(address, 2), "little")
                for address in (0x0158, 0x027B, 0x027C, 0x0941, 0x094E, 0x094F, 0x0950,
                                0x1CF0, 0x1CF1, 0x0681, 0x0682, 0x0683,
                                0x1C77, 0x0283, 0x0285, 0x026A, 0x0313,
                                0x031A, 0x0607, 0x0695, 0x0EA7, 0x0B7C,
                                0x0B7E, 0x0B88, 0x0A96, 0x033E, 0x3424,
                                0x3CA4, 0x0298, 0x026E, 0x0B8E)
            },
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
