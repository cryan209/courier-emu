from __future__ import annotations

from collections import Counter, deque
from dataclasses import asdict, dataclass, field
from typing import Any, Callable

from .nac import NacImage
from . import am79c30
from .am79c30 import Am79C30
from .flash_device import FLASH_BASE, FLASH_SIZE, FlashDevice
from .pic import InterruptControllers
from .pit import ProgrammableIntervalTimer
from .xmp import XmpImage
from .imodem_mailbox import ImodemMailbox
from .sio import (
    RX_INSTRUCTIONS_PER_BYTE,
    TERMINAL_PRESENT,
    UART_CLOCK_HIGH_RATES_HZ,
    UART_CLOCK_LOW_RATES_HZ,
    SerialChannel,
)


# The ISDN Courier's payload is an update image, not a whole flash part, so the
# 386 reset vector is not in it and the harness has to enter at a recovered
# initialiser, the same way the 80186 side enters main211.xmf.
#
# 4030:0000 is that initialiser. It clears 256 KiB of RAM a paragraph at a time,
# relocates 0x41c0 bytes from physical 0x98d50 down to 0x0ce00, and far-jumps to
# 7360:1ec0. The NAC type 03 record instead names 0ce0:0000, the data
# relocation destination (its bytes begin with text), not a verified code
# entry. See docs/imodem-payload-entry-points.md.
ENTRY_SEGMENT = 0x4030
ENTRY_OFFSET = 0x0000

# 16 MiB, so a 386 reaching above the first megabyte does not fault the harness.
ADDRESS_SPACE_SIZE = 0x1000000

# The board's own status and download path. Port 0x1e carries ready bits that
# two separate download loops poll -- bit 2 in one, bits 0 and 1 in the other --
# before streaming words out of 0x40..0x56. What device sits behind that is not
# established, so the harness answers the ready bits and records the stream
# rather than pretending to model the part.
BOARD_STATUS_PORT = 0x1E
BOARD_STATUS_READY = 0x07
DOWNLOAD_PORTS = range(0x40, 0x58)

# The DSP's block handshake. The loader writes 1 and spins until bit 0 reads
# back, then writes 2 and spins until bit 1 does - the DSP acknowledging each
# half. The DSP is not executed here, so the latch answers immediately: this
# models the acknowledgement, and nothing about what the DSP did with the
# block. Reading it back is how the firmware learns the block was taken.
DSP_HANDSHAKE_PORT = 0x18

# Two 16550s. UART A is the one the firmware writes to first, and it is the
# command interface: vector 0x23 -- IRQ3, which the firmware unmasks -- points
# at the serial ISR at 0xb2aa2, whose port variables at 2600:e83a read back
# f8fa / f8fd / f8fe / f8f8, this part's IIR, LSR, MSR and RBR. See
# courier_emu/sio.py for the decode that recovers.
#
# SIO1 has no interrupt line because the firmware never services it. The
# variable block at 2600:e83a runs to e84a and holds all nine registers of one
# part -- f8fa, f8fd, f8fe, f8f8, f8f8, f8f9, f8ff, f8fc, f8fb -- and there is
# no second block. Over a command session SIO1 is touched seven times, all of
# them in the init at 4030:010b that sets its LCR, divisor and IER and reads
# its MSR twice; after that nothing addresses 0xf4f8 again. So SIO1 is
# initialised and left idle by the firmware, and leaving it pollable and
# silent is what the firmware does with it, not a gap in the decode.
#
# The one interrupt-driven path that does exist beyond IRQ3 is IRQ12, whose
# handler at 0xc7c42 masks SIO0's IER through [e844], programmes the 386EX DMA
# registers at 0xf001/0xf00a/0xf00c/0xf010/0xf098, and restores IER -- a
# DMA-fed transmitter for SIO0, gated on [ca42] bit 1. None of those DMA
# registers is touched during a command session, so the AT interface does not
# use it and it is not modelled here.
UART_A_BASE = 0xF8F8
UART_B_BASE = 0xF4F8
UART_A_IRQ = 3
UART_B_IRQ = None

# The board latch the enclosure probe drives, and the sense line it reads back.
#
# The probe sets bits 0x08 and 0x80 here through the signal routines (their id
# low byte indexes a port table at a400:1f97, and 0x082a / 0x802a both land on
# this port), then reads bit 0x40 back from the same port and classifies by how
# the sense follows the drives. Answering 0, as the harness used to, makes it
# abandon at its first test and leave [d2c3] at 0 -- Undefined.
#
# Which drive the sense follows is the enclosure wiring, and it is what selects
# the product: following 0x08 the probe stores 0x22 (External), following 0x80
# it stores 0x28 (Internal). The bits themselves are established -- the ports,
# the drives and the sense are all read off the firmware -- but which physical
# strap a given enclosure uses is not, so it is exposed as a choice rather than
# asserted. Rackmount is not reachable through this probe at all.
BOARD_LATCH_PORT = 0x14
BOARD_LATCH_SENSE = 0x40
BOARD_LATCH_WIRING = {
    "external": 0x08,
    "internal": 0x80,
    "undefined": 0x00,
}

# The board's UART clock select. The rate setter at 0xc7ae7 reads this port,
# clears bit 1 for the four fastest rate codes and sets it for the rest, and
# writes it back -- and that boundary is exactly where the firmware's divisor
# table stops fitting one clock and starts fitting the other. See
# courier_emu/sio.py for the table and the two clocks it recovers.
UART_CLOCK_SELECT_PORT = 0xF836
UART_CLOCK_SELECT_BIT = 0x02

# The internal card's command port, and the line that services it.
#
# When the probe stores Internal the firmware repoints its whole serial
# variable block at 2600:e83a from the 386EX's SIO0 to 0x0082 0x0085 0x0086
# 0x0080 0x0080 0x0081 0x0082 0x0084 0x0083 -- a 16550 register file at base
# 0x80 in standard order -- masks IRQ3 and unmasks IRQ0 and IRQ5. IRQ5 is the
# ISA Plug and Play responder (see docs/imodem-at-interface.md), not the UART.
# IRQ0 is: the handler at 0xb2f1a polls this part's LSR at 0x85 and MSR at
# 0x86, transmits on THRE and dispatches receives through [e834].
#
# So on the internal card the command port is serviced from the timer tick on
# the PC-AT line, not from the UART's own interrupt. The external unit keeps
# SIO0 on IRQ3 and does not have this part at all, which is why it is only
# installed for the enclosure that has it.
INTERNAL_UART_BASE = 0x80
INTERNAL_UART_IRQ = 0
INTERNAL_TICK_IRQ = 0

# The Am79C30's interrupt line. Vector 0x2e is slave IRQ14 - the slave's ICW2
# is 0x28 - and it reads back 4030:02f8, a stub that far-calls 71d7:000f. That
# routine reads the DSC's IR at 0x300 and dispatches the line-state, transmit,
# receive and error paths off its bits, so IRQ14 is the part's own line and not
# a guess. See courier_emu/am79c30.py.
DSC_IRQ = 14

# Bringing the S interface up walks the I.430 states in order, because the
# firmware's layer-1 machine at 0x6296f dispatches on the state it is already
# in: handed F7 out of F1 it has no entry for the event and drops it, and the
# stored state never moves. Through F2 and F6 it does, and the state byte at
# ce0:a458 reaches 8 - the firmware's number for F7.
#
# The spacing is a harness choice, not an I.430 timing: it only has to be long
# enough for the interrupt service to read LSR once per state.
S_INTERFACE_WALK = (
    am79c30.F2_SENSING, am79c30.F6_SYNCHRONIZED, am79c30.F7_ACTIVATED,
)
S_INTERFACE_STEP_INSTRUCTIONS = 500_000

# The PS/2-style system control port, written once during init.
SYSTEM_CONTROL_PORT = 0xF092

# The 8254 is polled on this stride. It has to be short enough that no counter
# wrap is missed: the shortest period programmed is counter 0's 1860 input
# ticks, which at the harness ratio is a few thousand instructions.
TIMER_POLL_INSTRUCTIONS = 512

# INT 2d -> 4030:0316 -> [2600:c893] is the mailbox service path.
# This instruction cadence is a harness choice, not a recovered board clock.
MAILBOX_SERVICE_INSTRUCTIONS = 2048
# Scheduling ratio for the coupled harness; not a measured I-modem clock.
DSP_INSTRUCTIONS_PER_CPU_INSTRUCTION = 4

# Which 8254 counter drives which IRQ line.
#
# Counter 0 to IRQ0 is the PC-AT wiring, but this firmware leaves IRQ0 masked,
# so on this board the periodic tick arrives somewhere else. Sweeping every line
# the firmware does unmask -- master 3 and 6, slave 10 to 14 -- separates them
# cleanly: only IRQ10 lets the tick-delay routine at 0xa45df run to completion
# instead of spinning, and it reaches the most distinct code. IRQ3 stalls
# elsewhere and IRQ6 faults.
#
# What that establishes is that IRQ10 carries the system tick, not that an 8254
# counter is what raises it. The harness drives IRQ10 from counter 0 because
# that is the periodic source it has; which device is physically wired to that
# line is not recovered, and neither is the counter-to-line routing in general.
DEFAULT_COUNTER_IRQ = {0: 10}

MAX_SERIAL_BYTES = 64 * 1024
MAX_IO_EVENTS = 256

# The board probe stores its result in 2600:d2c3, and ATI7's formatter at
# c0be0 is what names the bits. It picks a string by testing bit 1, then bit 3,
# then bit 2, falling back to a fourth, and those four offsets -- 0x3d95,
# 0x3d9e, 0x3da7 and 0x3d8a -- point at consecutive strings whose lengths match
# the gaps exactly:
#
#     bit 1 (0x02)  "External"
#     bit 3 (0x08)  "Internal"
#     bit 2 (0x04)  "Rackmount"
#     no bit set    "Undefined "
#
# (and d2c4 bit 0 appends " MODEM"). Every entry in this table used to be one
# position out, so "external" wrote the Internal bit. The probe's own two
# outcomes read correctly against it: it stores 0x28 -- Internal -- when the
# sense line follows one drive, and 0x22 -- External -- when it follows the
# other. 0x22 is not Undefined, as an earlier note here claimed.
#
# This forcing is applied at PRODUCT_TYPE_PROBE_COMPLETE, which is inside the
# part of the probe that is only reached once the board latch at port 0x14
# answers. Until that is modelled the probe abandons, d2c3 stays 0, and this
# whole table is inert -- see docs/imodem-at-interface.md.
PRODUCT_TYPE_ADDRESS = 0x2600 * 16 + 0xD2C3
PRODUCT_TYPE_MODES = {
    "undefined": 0x00,
    "external": 0x02,
    "internal": 0x08,
    "rackmount": 0x04,
}
PRODUCT_MODEM_SUFFIX_ADDRESS = 0x2600 * 16 + 0xD2C4
PRODUCT_MODEM_SUFFIX = 0x01
PRODUCT_TYPE_PROBE_COMPLETE = 0xA4506

# 2600:e358 is the modulation-capability byte the record's [d2c7] feeds, through
# the five (test, set) pairs at a400:04ac -- d2c7 bits 0..4 setting e358 0x04,
# 0x08, 0x40, 0x80 and 0x20.
#
# The harness used to write ALL_OPTIONS here at the probe-complete hook. That
# was dead: the firmware writes e358 again at 0xa4446, after the hook, and
# leaves it 0x23. Sweeping the forced value over 0x00..0xe5 changes ATI7's
# Options line not at all -- it reads `V32bis,x2,V.90` every time. The write is
# gone rather than left looking effective; what actually drives that line has
# not been re-established.
OPTIONS_ADDRESS = 0x2600 * 16 + 0xE358

# The common command epilogue's result decision.
#
# There used to be a rewrite here: when the recorded disconnect cause was
# Keypress Abort with no call-state flags, the harness substituted a
# DTR-dropped cause so that a plain AT answered OK. It is gone, because it
# was not doing anything and it described the problem wrongly.
#
# What actually happens, swept over AT, ATZ, AT&F, ATE1, ATH, ATQ0, ATV1, ATX0
# and AT&V: **every** command emits result code 3, and code 0 is never emitted
# at all. The recorded cause is 0 -- no disconnect, not Keypress Abort -- so
# that rewrite's condition never matched. The decision at a8067 wants
# [d08b] == 1 (DTR dropped) and [d2a1] & 0x47, and both read 0.
#
# ATI2's "OK" is its own text, not a result code; the NO CARRIER that follows
# it is the result. The earlier reasoning that "index 0 is reachable, so the
# result table is not mis-indexed" rested on reading that OK as a result code,
# and does not hold. See docs/imodem-at-interface.md for where the trail
# currently stops.
RESULT_DECISION = 0xA8067
DISCONNECT_CAUSE_ADDRESS = 0x2600 * 16 + 0xD08B
COMMAND_STATE_ADDRESS = 0x2600 * 16 + 0xD2A1
KEYPRESS_ABORT = 0x17
DTR_DROPPED = 0x01


@dataclass
class IsdnRunResult:
    status: str
    instructions: int
    entry: str
    registers: dict[str, int]
    hardware_interrupts: int = 0
    software_interrupts: dict[str, int] = field(default_factory=dict)
    timer_ticks: int = 0
    serial_a: str = ""
    serial_b: str = ""
    download_bytes: int = 0
    io_summary: dict[str, int] = field(default_factory=dict)
    unmodelled_ports: list[str] = field(default_factory=list)
    hot_addresses: list[tuple[int, int]] = field(default_factory=list)
    last_addresses: list[str] = field(default_factory=list)
    pit: dict[str, Any] = field(default_factory=dict)
    pic: dict[str, Any] = field(default_factory=dict)
    dsc: dict[str, Any] = field(default_factory=dict)
    flash: dict[str, Any] = field(default_factory=dict)
    mailbox: dict[str, Any] = field(default_factory=dict)
    serial: dict[str, Any] = field(default_factory=dict)
    error: str | None = None

    def to_dict(self) -> dict[str, Any]:
        value = asdict(self)
        value["hot_addresses"] = [[hex(a), c] for a, c in self.hot_addresses]
        return value


class IsdnMachine:
    """A 386 real-mode harness for the ISDN Courier, with its PC-AT peripherals."""

    def __init__(
        self,
        image: NacImage | XmpImage,
        *,
        entry_segment: int = ENTRY_SEGMENT,
        entry_offset: int = ENTRY_OFFSET,
        board_status: int = BOARD_STATUS_READY,
        port_values: dict[int, int] | None = None,
        counter_irq: dict[int, int] | None = None,
        max_io_events: int = MAX_IO_EVENTS,
        profile: bool = True,
        mailbox_service: bool = True,
        mailbox: ImodemMailbox | None = None,
        with_dsp: bool = False,
        serial_signals: int = TERMINAL_PRESENT,
        serial_pace: int | None = None,
        serial_irq: int | None = UART_A_IRQ,
        serial_pump: "Callable[[IsdnMachine], None] | None" = None,
        line_activate: int | None = None,
        flash_overlay: tuple[int, bytes] | None = None,
        product_type: str = "external",
        product_modem: bool = False,
    ) -> None:
        self.image = image
        self.entry_segment = entry_segment
        self.entry_offset = entry_offset
        self.board_status = board_status
        self.port_values = dict(port_values or {})
        self.counter_irq = dict(DEFAULT_COUNTER_IRQ if counter_irq is None else counter_irq)
        self.max_io_events = max_io_events
        # Counting every executed address costs about a third of the run: it
        # is a dict update per instruction, inside a callback the emulator
        # already crosses into Python for. Worth it for a probe, pure overhead
        # for a terminal session that only wants the serial stream.
        self.profile = profile
        self.mailbox_service = mailbox_service
        if with_dsp and mailbox is not None:
            raise ValueError('with_dsp and an explicit mailbox are mutually exclusive')
        if with_dsp:
            from .imodem_dsp import ImodemDsp
            mailbox = ImodemDsp()
        self.with_dsp = with_dsp
        self._dsp_instructions = 0
        self.mailbox = mailbox if mailbox is not None else ImodemMailbox()
        self._next_mailbox_service = MAILBOX_SERVICE_INSTRUCTIONS

        # Content to lay over the flash window before the firmware runs, as
        # (physical address, bytes). The payload is an update image and stops
        # at 0xf8000, so the part's top sectors read erased - and one of them
        # is the configuration store. See docs/imodem-config-sector.md.
        self.flash_overlay = flash_overlay
        if product_type not in BOARD_LATCH_WIRING:
            raise ValueError(
                "product type must be one of "
                f"{sorted(BOARD_LATCH_WIRING)}; rackmount is not reachable "
                "through the board probe"
            )
        if product_type not in PRODUCT_TYPE_MODES:
            raise ValueError(
                f"product type must be one of {sorted(PRODUCT_TYPE_MODES)}"
            )
        self.product_type = product_type
        self.product_modem = product_modem
        self.line_activate = line_activate
        self._line_walk = list(S_INTERFACE_WALK) if line_activate is not None else []

        self.pit = ProgrammableIntervalTimer()
        self.pic = InterruptControllers()
        self.dsc = Am79C30()
        self.flash = FlashDevice()
        self.dsp_handshake = 0
        self.board_latch = 0
        # The init at 4030:010b writes 0x00 here in the same breath as it sets
        # both SIOs to divisor 2, so the board starts on the clock that serves
        # the fast rates -- and divisor 2 on 3.6864 MHz is 115200 exactly.
        self.uart_clock_select = 0

        self.instructions = 0
        self.timer_ticks = 0
        self.hardware_interrupts = 0
        self.software_interrupts: Counter[int] = Counter()
        self.io_counts: Counter[tuple[str, int]] = Counter()
        self.channels: dict[int, SerialChannel] = {
            UART_A_BASE: SerialChannel(
                UART_A_BASE, irq=serial_irq, signals=serial_signals,
                max_bytes=MAX_SERIAL_BYTES, pace=serial_pace,
                input_clock_hz=UART_CLOCK_HIGH_RATES_HZ,
            ),
            UART_B_BASE: SerialChannel(
                UART_B_BASE, irq=UART_B_IRQ, signals=serial_signals,
                max_bytes=MAX_SERIAL_BYTES, pace=serial_pace,
                input_clock_hz=UART_CLOCK_HIGH_RATES_HZ,
            ),
        }
        # Which channel the AT interface lives on for this enclosure. The
        # external unit and the probe-failed fallback both use SIO0; only the
        # internal card moves it.
        self.command_base = (
            INTERNAL_UART_BASE if product_type == "internal" else UART_A_BASE
        )
        if product_type == "internal":
            self.channels[INTERNAL_UART_BASE] = SerialChannel(
                INTERNAL_UART_BASE, irq=INTERNAL_UART_IRQ,
                signals=serial_signals, max_bytes=MAX_SERIAL_BYTES,
                pace=serial_pace, input_clock_hz=UART_CLOCK_HIGH_RATES_HZ,
            )
            if counter_irq is None:
                # The tick is what services this part, so it has to reach the
                # line the handler sits on.
                self.counter_irq = {0: INTERNAL_TICK_IRQ}
        self.serial_pump = serial_pump
        self.machine: Any = None
        self.download = bytearray()
        self.pc_counts: Counter[int] = Counter()
        self.recent: deque[int] = deque(maxlen=32)
        self.error: str | None = None
        self._stop_reason: str | None = None
        self._next_poll = TIMER_POLL_INSTRUCTIONS

    # -- image -------------------------------------------------------------

    def _flat_image(self) -> tuple[int, bytes]:
        if isinstance(self.image, NacImage):
            return self.image.flatten()
        return self.image.load_base, self.image.payload

    # -- I/O ---------------------------------------------------------------

    def _uart_of(self, port: int) -> int | None:
        for base, channel in self.channels.items():
            if channel.handles(port):
                return base
        return None

    @property
    def serial(self) -> dict[int, bytearray]:
        """The transmitted stream per channel, by base address."""
        return {base: channel.tx for base, channel in self.channels.items()}

    # -- host side ---------------------------------------------------------

    def send_serial(self, data: bytes | bytearray | str,
                    base: int | None = None) -> int:
        """Queue bytes on a channel as if a terminal had typed them."""
        return self.channels[base or self.command_base].feed(data)

    def take_serial(self, base: int | None = None) -> bytes:
        """Take what the firmware has transmitted since the last call."""
        return self.channels[base or self.command_base].take_output()

    def stop(self, reason: str) -> None:
        """End the run early -- what a console does when the user detaches."""
        self._stop_reason = reason
        if self.machine is not None:
            self.machine.emu_stop()

    def read_port(self, port: int) -> int:
        self._advance_dsp()
        self.io_counts[("in", port)] += 1
        if self.pit.handles(port):
            return self.pit.read(port, self.instructions)
        if self.pic.handles(port):
            return self.pic.read(port)
        if self.dsc.handles(port):
            return self.dsc.read(port)
        if self.with_dsp and port in (0x18, 0x1a, 0x1c, 0x1e, *self.mailbox.LANES):
            return self.mailbox.read(port)
        if port == DSP_HANDSHAKE_PORT:
            return self.dsp_handshake
        if port == BOARD_STATUS_PORT:
            return self.board_status
        if port == UART_CLOCK_SELECT_PORT:
            return self.uart_clock_select
        if port == BOARD_LATCH_PORT:
            drive = BOARD_LATCH_WIRING[self.product_type]
            if drive and self.board_latch & drive:
                return self.board_latch | BOARD_LATCH_SENSE
            return self.board_latch & ~BOARD_LATCH_SENSE
        if port in self.mailbox.PORTS:
            return self.port_values.get(port, self.mailbox.read(port))
        base = self._uart_of(port)
        if base is not None:
            return self.channels[base].read(port)
        return self.port_values.get(port, 0)

    def write_port(self, port: int, value: int) -> None:
        self._advance_dsp()
        self.io_counts[("out", port)] += 1
        if self.with_dsp and (port in (0x18, 0x1c, 0x1e) or 0x40 <= port <= 0x5e):
            self.mailbox.write(port, value)
            if port not in DOWNLOAD_PORTS:
                return
        if self.pit.handles(port):
            self.pit.write(port, value, self.instructions)
            return
        if self.pic.handles(port):
            self.pic.write(port, value)
            return
        if self.dsc.handles(port):
            self.dsc.write(port, value)
            return
        if port == DSP_HANDSHAKE_PORT:
            self.dsp_handshake = value & 0xFF
            return
        if port == BOARD_LATCH_PORT:
            self.board_latch = value & 0xFF
            return
        if port == UART_CLOCK_SELECT_PORT:
            self.uart_clock_select = value & 0xFF
            # Only SIO0's clock is traced to this bit: the rate setter writes
            # it as part of loading SIO0's divisor, and SIO1's divisor is never
            # set again after the init that left this register at 0x00. So
            # SIO1 keeps the fast-rate clock it was initialised on -- 115200 at
            # its divisor of 2 -- and whether the bit would have moved it too
            # is not separable from what the firmware does.
            self.channels[UART_A_BASE].input_clock_hz = (
                UART_CLOCK_LOW_RATES_HZ if value & UART_CLOCK_SELECT_BIT
                else UART_CLOCK_HIGH_RATES_HZ
            )
            return
        if port in self.mailbox.PORTS:
            self.mailbox.write(port, value)
            return
        if port in DOWNLOAD_PORTS:
            if len(self.download) < MAX_SERIAL_BYTES:
                self.download.append(value & 0xFF)
            return
        base = self._uart_of(port)
        if base is not None:
            self.channels[base].write(port, value)

    # -- timing ------------------------------------------------------------

    def _advance_dsp(self) -> None:
        if self.with_dsp:
            elapsed = self.instructions - self._dsp_instructions
            self._dsp_instructions = self.instructions
            if elapsed:
                self.mailbox.step(elapsed * DSP_INSTRUCTIONS_PER_CPU_INSTRUCTION)

    def poll_timers(self) -> None:
        """Advance the 8254 and hand any counter wraps to the 8259s."""
        self._advance_dsp()
        if self.serial_pump is not None:
            self.serial_pump(self)
        for channel in self.channels.values():
            channel.advance(self.instructions)
        for channel in self.channels.values():
            if channel.irq is not None and channel.interrupting():
                self.pic.raise_irq(channel.irq)
        self._advance_line()
        if self.dsc.interrupting():
            self.pic.raise_irq(DSC_IRQ)
        if self.mailbox_service and self.instructions >= self._next_mailbox_service:
            self._next_mailbox_service = self.instructions + MAILBOX_SERVICE_INSTRUCTIONS
            self.pic.raise_irq(13)
        for counter in self.pit.counters:
            irq = self.counter_irq.get(counter.index)
            wraps = counter.take_wraps(self.pit.ticks(self.instructions))
            if not wraps:
                continue
            self.timer_ticks += wraps
            if irq is not None:
                self.pic.raise_irq(irq)

    def _advance_line(self) -> None:
        """Walk the S interface up, one state per step, once the run reaches it."""
        if not self._line_walk:
            return
        due = self.line_activate + S_INTERFACE_STEP_INSTRUCTIONS * (
            len(S_INTERFACE_WALK) - len(self._line_walk)
        )
        if self.instructions >= due:
            self.dsc.set_liu_state(self._line_walk.pop(0))

    # -- execution ---------------------------------------------------------

    def run(self, instructions: int) -> IsdnRunResult:
        try:
            from unicorn import (
                UC_ARCH_X86,
                UC_HOOK_CODE,
                UC_HOOK_INSN,
                UC_HOOK_INTR,
                UC_HOOK_MEM_INVALID,
                UC_HOOK_MEM_WRITE,
                UC_MODE_16,
                Uc,
                UcError,
            )
            from unicorn.x86_const import (
                UC_X86_INS_IN,
                UC_X86_INS_OUT,
                UC_X86_REG_AX,
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
        except ImportError as exc:  # pragma: no cover - exercised by the CLI
            raise RuntimeError(
                "executing the ISDN image needs Unicorn; install with "
                "`pip install '.[execute]'`"
            ) from exc

        base, flat = self._flat_image()
        uc = Uc(UC_ARCH_X86, UC_MODE_16)
        # Kept so a caller can read memory back after a run; nothing else uses it.
        self.machine = uc
        uc.mem_map(0, ADDRESS_SPACE_SIZE)
        uc.mem_write(base, flat)

        self.flash.load(
            flat[FLASH_BASE - base : FLASH_BASE - base + FLASH_SIZE]
            if base <= FLASH_BASE
            else b""
        )
        if self.flash_overlay is not None:
            where, data = self.flash_overlay
            uc.mem_write(where, data)
            offset = where - FLASH_BASE
            if 0 <= offset < FLASH_SIZE:
                self.flash.contents[offset:offset + len(data)] = data

        flash_dirty = [False]

        def on_flash_write(_uc: Any, _access: int, address: int, size: int,
                           value: int, _data: Any) -> None:
            """A flash decodes command writes; it does not store them.

            The hook runs before the write lands, so what the window should
            read back is queued and applied on the next instruction boundary,
            where the CPU's own write cannot overwrite it again.
            """
            if not self.flash.contains(address):
                return
            self.flash.on_write(address, size, value)
            flash_dirty[0] = True

        def apply_flash() -> None:
            flash_dirty[0] = False
            for address, payload in self.flash.take_patches():
                uc.mem_write(address, payload)

        def push_far(vector: int) -> bool:
            """Take a real-mode interrupt through the vector table."""
            cs = uc.reg_read(UC_X86_REG_CS)
            ip = uc.reg_read(UC_X86_REG_IP)
            ss = uc.reg_read(UC_X86_REG_SS)
            sp = uc.reg_read(UC_X86_REG_SP)
            flags = uc.reg_read(UC_X86_REG_FLAGS) & 0xFFFF
            entry = bytes(uc.mem_read(vector * 4, 4))
            offset = int.from_bytes(entry[:2], "little")
            segment = int.from_bytes(entry[2:], "little")
            if segment == 0 and offset == 0:
                return False
            for value in (flags, cs, ip):
                sp = (sp - 2) & 0xFFFF
                uc.mem_write(ss * 16 + sp, value.to_bytes(2, "little"))
            uc.reg_write(UC_X86_REG_SP, sp)
            uc.reg_write(UC_X86_REG_FLAGS, flags & ~0x0200)
            uc.reg_write(UC_X86_REG_CS, segment)
            uc.reg_write(UC_X86_REG_IP, offset)
            return True

        profile = self.profile

        def on_code(_uc: Any, address: int, _size: int, _data: Any) -> None:
            self.instructions += 1
            if flash_dirty[0]:
                apply_flash()
            if address == PRODUCT_TYPE_PROBE_COMPLETE:
                # [d2c3] is the probe's own verdict now that the latch answers
                # it -- 0x22 External or 0x28 Internal -- so it is left alone.
                # Overwriting it here used to drop the probe's bit 5 as well,
                # which is what put the machine back on the wrong branch.
                suffix = uc.mem_read(PRODUCT_MODEM_SUFFIX_ADDRESS, 1)[0]
                suffix = (
                    suffix | PRODUCT_MODEM_SUFFIX
                    if self.product_modem
                    else suffix & ~PRODUCT_MODEM_SUFFIX
                )
                uc.mem_write(PRODUCT_MODEM_SUFFIX_ADDRESS, bytes((suffix,)))
            if profile:
                self.pc_counts[address] += 1
            self.recent.append(address)
            if self.instructions < self._next_poll:
                return
            self._next_poll = self.instructions + TIMER_POLL_INSTRUCTIONS
            self.poll_timers()
            if not uc.reg_read(UC_X86_REG_FLAGS) & 0x0200:
                return
            vector = self.pic.pending_vector()
            if vector is not None and push_far(vector):
                self.hardware_interrupts += 1

        def on_in(_uc: Any, port: int, size: int, _data: Any) -> int:
            return self.read_port(port) & ((1 << (8 * size)) - 1)

        def on_out(_uc: Any, port: int, _size: int, value: int, _data: Any) -> None:
            self.write_port(port, value)

        def on_interrupt(_uc: Any, number: int, _data: Any) -> None:
            # Unicorn retires the `int n` before this hook runs, so IP already
            # points at the next instruction and the opcode is two bytes back.
            cs = uc.reg_read(UC_X86_REG_CS)
            ip = uc.reg_read(UC_X86_REG_IP)
            opcode = bytes(uc.mem_read(cs * 16 + ip - 2, 2)) if ip >= 2 else b""
            software = len(opcode) == 2 and opcode[0] == 0xCD and opcode[1] == number
            if not software:
                self._stop_reason = f"cpu exception {number:#x} at {cs:04x}:{ip:04x}"
                uc.emu_stop()
                return
            self.software_interrupts[number] += 1
            if not push_far(number):
                self._stop_reason = f"int {number:#x} has a null vector"
                uc.emu_stop()

        def on_bad_mem(
            _uc: Any, access: int, address: int, size: int, _value: int, _data: Any
        ) -> bool:
            self._stop_reason = (
                f"unmapped memory access={access} address={address:#x} size={size}"
            )
            return False

        uc.hook_add(UC_HOOK_CODE, on_code)
        uc.hook_add(
            UC_HOOK_MEM_WRITE,
            on_flash_write,
            begin=FLASH_BASE,
            end=FLASH_BASE + FLASH_SIZE - 1,
        )
        uc.hook_add(UC_HOOK_INSN, on_in, None, 1, 0, UC_X86_INS_IN)
        uc.hook_add(UC_HOOK_INSN, on_out, None, 1, 0, UC_X86_INS_OUT)
        uc.hook_add(UC_HOOK_INTR, on_interrupt)
        uc.hook_add(UC_HOOK_MEM_INVALID, on_bad_mem)

        uc.reg_write(UC_X86_REG_CS, self.entry_segment)
        uc.reg_write(UC_X86_REG_IP, self.entry_offset)
        start = self.entry_segment * 16 + self.entry_offset

        status = "instruction-limit"
        try:
            uc.emu_start(start, ADDRESS_SPACE_SIZE, count=instructions)
        except UcError as exc:
            self.error = str(exc)
            status = "error"
        if self._stop_reason is not None:
            status = self._stop_reason

        registers = {
            name: uc.reg_read(reg)
            for name, reg in (
                ("ax", UC_X86_REG_AX),
                ("bx", UC_X86_REG_BX),
                ("cx", UC_X86_REG_CX),
                ("dx", UC_X86_REG_DX),
                ("si", UC_X86_REG_SI),
                ("di", UC_X86_REG_DI),
                ("sp", UC_X86_REG_SP),
                ("cs", UC_X86_REG_CS),
                ("ip", UC_X86_REG_IP),
                ("ds", UC_X86_REG_DS),
                ("es", UC_X86_REG_ES),
                ("ss", UC_X86_REG_SS),
            )
        }
        return self._result(status, registers)

    def _result(self, status: str, registers: dict[str, int]) -> IsdnRunResult:
        known = set()
        if self.with_dsp:
            known.add(0x1a)
        for port in (BOARD_STATUS_PORT, SYSTEM_CONTROL_PORT):
            known.add(port)
        unmodelled = sorted(
            {
                port
                for (_, port) in self.io_counts
                if not self.pit.handles(port)
                and not self.pic.handles(port)
                and port not in known
                and port not in DOWNLOAD_PORTS
                and not self.dsc.handles(port)
                and port != DSP_HANDSHAKE_PORT
                and port not in self.mailbox.PORTS
                and self._uart_of(port) is None
            }
        )
        return IsdnRunResult(
            status=status,
            instructions=self.instructions,
            entry=f"{self.entry_segment:04x}:{self.entry_offset:04x}",
            registers=registers,
            hardware_interrupts=self.hardware_interrupts,
            software_interrupts={
                f"{number:#04x}": count
                for number, count in sorted(self.software_interrupts.items())
            },
            timer_ticks=self.timer_ticks,
            serial_a=self.channels[UART_A_BASE].tx.decode("ascii", "replace"),
            serial_b=self.channels[UART_B_BASE].tx.decode("ascii", "replace"),
            serial={
                name: self.channels[base].status()
                for name, base in (("a", UART_A_BASE), ("b", UART_B_BASE),
                                   ("internal", INTERNAL_UART_BASE))
                if base in self.channels
            },
            download_bytes=len(self.download),
            io_summary={
                f"{direction} {port:#06x}": count
                for (direction, port), count in self.io_counts.most_common(16)
            },
            unmodelled_ports=[f"{port:#06x}" for port in unmodelled],
            hot_addresses=self.pc_counts.most_common(8),
            last_addresses=[f"{address:#07x}" for address in self.recent],
            pit=self.pit.status(self.instructions),
            pic=self.pic.status(),
            dsc=self.dsc.status(),
            flash=self.flash.status_report(),
            mailbox=self.mailbox.status(),
            error=self.error,
        )
