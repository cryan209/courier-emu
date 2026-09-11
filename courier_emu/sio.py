"""The 386EX SIO channels, with a receive path.

The I-modem's command interface is SIO0 at ``0xf8f8``, driven entirely by
interrupt.  The firmware's own ISR is the evidence for every register decode
here.  Vector 0x23 -- IRQ3 on the master 8259, which the firmware unmasks --
points at ``0xb2aa2``, and that routine reads a port held in ``2600:e83a``,
tests bit 0 for "no interrupt pending", and dispatches on the remaining value
through a four-entry table at ``2600:e830``:

    iir 0 -> b2ac8   reads [e83e], tests 0x01/0x10/0x02   modem status
    iir 2 -> b2c84   clears a transmit-busy flag          holding register empty
    iir 4 -> b2c8d   reads [e840], optionally echoes it   received data
    iir 6 -> b2aec   reads [e83c], tests 0x10/0x08        line status

The four port variables are filled in at init and read back from a live run as
``fa f8 / fd f8 / fe f8 / f8 f8`` -- base+2, base+5, base+6, base+0 of a 16550
at ``0xf8f8``.  So the identification is the part's, not an assumption: IIR,
LSR, MSR, RBR/THR in their standard places.

The modem-status inputs are wired DCE-side.  The signal query at ``0xa5e0e``
selects MSR masks by logical signal: 0x0424 reads 0x80 or 0x20 depending on a
mode flag at ``[d2c3]``, and 0x8024 reads 0x10 -- that is DCD-or-DSR for "the
terminal is there" and CTS for flow control, i.e. the DTE's DTR and RTS
arriving on this part's inputs.  Asserting all three is what a connected,
ready terminal looks like; which of DCD and DSR a given board strap uses is
the flag's business, not ours, so both are asserted.
"""

from __future__ import annotations

from collections import deque
from typing import Any

# Register offsets from the channel base, with DLAB clear.
RBR = 0
THR = 0
IER = 1
IIR = 2
LCR = 3
MCR = 4
LSR = 5
MSR = 6
SCR = 7

LSR_DATA_READY = 0x01
LSR_TX_READY = 0x60  # holding register empty | shift register empty

IER_RX = 0x01
IER_THRE = 0x02
IER_LINE = 0x04
IER_MSR = 0x08

IIR_MODEM = 0x00
IIR_NONE = 0x01
IIR_THRE = 0x02
IIR_RX = 0x04

MSR_DELTA_CTS = 0x01
MSR_DELTA_DSR = 0x02
MSR_TERI = 0x04
MSR_DELTA_DCD = 0x08
MSR_CTS = 0x10
MSR_DSR = 0x20
MSR_RI = 0x40
MSR_DCD = 0x80

# The DTE's RTS and DTR as this part sees them, plus carrier. A terminal that
# is plugged in and ready.
TERMINAL_PRESENT = MSR_CTS | MSR_DSR | MSR_DCD

LCR_DLAB = 0x80

MCR_DTR = 0x01
MCR_RTS = 0x02
MCR_OUT2 = 0x08
MCR_LOOPBACK = 0x10

MAX_SERIAL_BYTES = 64 * 1024

# Compatibility value for callers that explicitly request a fixed receive
# pacing. The default derives a complete character time from the divisor the
# guest programmes and the clock the board feeds the part.
RX_INSTRUCTIONS_PER_BYTE = 20000

# The board's two UART input clocks, and the rate ranges each one serves.
#
# Both are recovered from the firmware's own baud-rate table rather than
# assumed. The rate setter at 0xc7ae7 takes a rate code 1..12, indexes a
# twelve-word table at c774:04db, and writes that word into the divisor latch:
#
#     1 2 4 6 40 80 161 322 643 1286 2572 1782
#
# It also records 0x0c - code at [d1db], and the setup menu at 0xc0570 labels
# those display indices -- 5 is "4800 bps", 6 "9600", 7 "19200", 8 "38400",
# 9 "57600", 10 "115200". So code 1 is 230400 and code 11 is 300, and every
# divisor in the table is then exact:
#
#     code 1..4    230400 115200 57600 38400   ->  1 2 4 6         3.6864 MHz
#     code 5..11    19200 9600 4800 2400 1200 600 300
#                                  -> 40 80 161 322 643 1286 2572  12.3456 MHz
#
# Each group is exact to the rounding a divisor needs -- 12.3456 MHz over
# 16*4800 is 160.75 and the table holds 161, over 16*2400 is 321.5 and the
# table holds 322 -- and neither group fits the other's clock. Code 12's 1782
# has no menu entry and is not interpreted here.
#
# The setter picks between them itself: after loading the divisor it reads
# 0xf836, clears bit 1 for codes 1..4 and sets it for codes 5..12, and writes
# it back. That boundary is exactly the boundary between the two clocks, so
# bit 1 of 0xf836 is the board's UART clock select. (It is where the 386EX
# puts its serial configuration register, which is consistent, but the split
# is established by the table, not by the part number.)
UART_CLOCK_HIGH_RATES_HZ = 3_686_400   # 38400..230400, clock-select bit clear
UART_CLOCK_LOW_RATES_HZ = 12_345_600   # 300..19200, clock-select bit set

# The instruction clock, from the firmware's own description of its board:
# ATI7 prints "Clock Freq 20.16Mhz". At roughly one instruction per clock this
# puts a 9600-baud character at about 21,000 instructions, which is within 5%
# of the 20,000 that was verified empirically against this firmware long
# before the clock was recovered -- two independent routes to the same number.
#
# Note that pit.INSTRUCTIONS_PER_SECOND still carries the older 2,500,000
# assumption for the 8254 ratio. That figure is documented there as a stated
# assumption rather than a measurement; reconciling the two is a separate
# change with a much wider blast radius, and is not made here.
CPU_INSTRUCTIONS_PER_SECOND = 20_160_000

def even_parity(value: int) -> int:
    """The parity bit the firmware generates in software.

    The link is 7E1: start, seven data bits, even parity, stop. The firmware
    produces that frame from a transmitter it has programmed 8N1
    (``LCR = 0x03``), which works because the two frames are the same bits in
    the same order -- an 8N1 frame's eighth data bit sits exactly where a 7E1
    frame's parity bit sits, and both are ten bits long. Computing parity into
    the top bit and letting the part shift out eight "data" bits therefore
    puts a real 7E1 frame on the wire, which a 7E1 receiver parses correctly.
    Doing parity in software rather than in the LCR is what lets the firmware
    offer every parity setting, and pass eight-bit data, without touching the
    line format.

    The evidence is both halves agreeing: over a full banner-and-result-code
    stream 73 bytes of 73 carry correct even parity, and ATI4 states the link
    in words -- "BAUD=9600 PARITY=E WORDLEN=7".

    The receive direction is the same technique in reverse: the firmware takes
    eight bits and masks the top one off, so the parity a terminal sends is
    accepted and discarded rather than checked.
    """
    value &= 0x7F
    return value | (0x80 if bin(value).count("1") % 2 else 0)


class SerialChannel:
    """One 16550 channel: a transmit sink, a receive queue, and its interrupt.

    ``irq`` is the 8259 line this channel's INT pin reaches, or ``None`` when
    the wiring is not recovered -- in which case the channel still works by
    polling and simply never raises anything.
    """

    def __init__(
        self,
        base: int,
        *,
        irq: int | None = None,
        signals: int = TERMINAL_PRESENT,
        max_bytes: int = MAX_SERIAL_BYTES,
        pace: int | None = None,
        input_clock_hz: int = UART_CLOCK_LOW_RATES_HZ,
    ) -> None:
        self.base = base
        self.irq = irq
        self.max_bytes = max_bytes
        self.pace = pace
        # Which of the board's two clocks reaches this part. The firmware
        # selects it through 0xf836 as part of setting the rate; the default
        # is the one that serves 9600, which is where it starts.
        self.input_clock_hz = input_clock_hz
        self.staged: deque[int] = deque()
        self._next_byte = 0
        self.rx: deque[int] = deque()
        self.tx = bytearray()
        self.ier = 0
        self.lcr = 0
        self.mcr = 0
        self.scratch = 0
        self.divisor = 0
        self.signals = signals & 0xF0
        # A cold read should tell the firmware the lines just changed, the way
        # a part powering up beside an already-cabled terminal would.
        self.deltas = self._deltas_for(self.signals)
        self.thre = False
        self.tx_holding: int | None = None
        self.tx_shift: int | None = None
        self._tx_complete = 0
        self.overruns = 0
        self.received = 0
        self.transmitted = 0
        self._sent = 0

    # -- host side ---------------------------------------------------------

    def feed(self, data: bytes | bytearray | str) -> int:
        """Queue bytes as if a terminal had typed them. Returns the count."""
        if isinstance(data, str):
            data = data.encode("ascii", "replace")
        self.staged.extend(data)
        return len(data)

    def advance(self, instructions: int) -> None:
        """Release staged bytes onto the wire at the modelled line rate."""
        character_time = self.character_instructions
        if not self.staged:
            # An idle line does not bank up credit for a later burst.
            self._next_byte = instructions + character_time
        elif character_time <= 0:
            while self.staged:
                self._receive(self.staged.popleft())
        else:
            while self.staged and instructions >= self._next_byte:
                self._next_byte += character_time
                self._receive(self.staged.popleft())
            if instructions >= self._next_byte:
                self._next_byte = instructions + character_time

        # THR and the shift register are distinct. A write fills THR; on the
        # next clock advance it transfers to an idle shifter and only then
        # raises THRE. The byte reaches the host after a complete frame.
        while self.tx_shift is not None and instructions >= self._tx_complete:
            if len(self.tx) < self.max_bytes:
                self.tx.append(self.tx_shift)
                self.transmitted += 1
            else:
                self.overruns += 1
            self.tx_shift = None
        if self.tx_shift is None and self.tx_holding is not None:
            self.tx_shift = self.tx_holding
            self.tx_holding = None
            self._tx_complete = instructions + max(1, character_time)
            self.thre = True

    @property
    def baud(self) -> int:
        """The line rate this channel is running at, as the part derives it."""
        return self.input_clock_hz // (16 * max(1, self.divisor))

    @property
    def character_instructions(self) -> int:
        """One serial frame at the divisor, clock and format the guest set."""
        if self.pace is not None:
            return self.pace
        divisor = max(1, self.divisor)
        data_bits = 5 + (self.lcr & 0x03)
        stop_bits = 2 if self.lcr & 0x04 else 1
        parity_bits = 1 if self.lcr & 0x08 else 0
        frame_bits = 1 + data_bits + parity_bits + stop_bits
        numerator = CPU_INSTRUCTIONS_PER_SECOND * 16 * divisor * frame_bits
        return max(1, (numerator + self.input_clock_hz - 1) // self.input_clock_hz)

    def _receive(self, value: int) -> None:
        self.rx.append(value)
        self.received += 1

    @property
    def queued(self) -> int:
        return len(self.rx) + len(self.staged)

    def take_output(self) -> bytes:
        """What the firmware has transmitted since the last call.

        ``tx`` itself is kept whole so a run's report can still show the
        complete stream; this only advances a cursor over it.
        """
        sent = bytes(self.tx[self._sent :])
        self._sent = len(self.tx)
        return sent

    def set_signals(self, signals: int) -> None:
        signals &= 0xF0
        changed = signals ^ self.signals
        self.signals = signals
        self.deltas |= self._deltas_for(changed)

    @staticmethod
    def _deltas_for(changed: int) -> int:
        delta = 0
        if changed & MSR_CTS:
            delta |= MSR_DELTA_CTS
        if changed & MSR_DSR:
            delta |= MSR_DELTA_DSR
        if changed & MSR_DCD:
            delta |= MSR_DELTA_DCD
        if changed & MSR_RI:
            delta |= MSR_TERI
        return delta

    # -- interrupts --------------------------------------------------------

    def pending(self) -> int:
        """The IIR value, highest priority first, without side effects."""
        if self.ier & IER_RX and self.rx:
            return IIR_RX
        if self.ier & IER_THRE and self.thre:
            return IIR_THRE
        if self.ier & IER_MSR and self.deltas:
            return IIR_MODEM
        return IIR_NONE

    def interrupting(self) -> bool:
        return self.pending() != IIR_NONE

    # -- register file -----------------------------------------------------

    def handles(self, port: int) -> bool:
        return self.base <= port < self.base + 8

    def read(self, port: int) -> int:
        offset = port - self.base
        dlab = bool(self.lcr & LCR_DLAB)
        if offset == RBR:
            if dlab:
                return self.divisor & 0xFF
            return self.rx.popleft() if self.rx else 0
        if offset == IER:
            if dlab:
                return (self.divisor >> 8) & 0xFF
            return self.ier
        if offset == IIR:
            value = self.pending()
            if value == IIR_THRE:
                # Reading IIR is what clears a transmit-empty interrupt.
                self.thre = False
            return value
        if offset == LCR:
            return self.lcr
        if offset == MCR:
            return self.mcr
        if offset == LSR:
            tx_status = 0
            if self.tx_holding is None:
                tx_status |= 0x20
            if self.tx_holding is None and self.tx_shift is None:
                tx_status |= 0x40
            return tx_status | (LSR_DATA_READY if self.rx else 0)
        if offset == MSR:
            if self.mcr & MCR_LOOPBACK:
                value = self._loopback_status()
            else:
                value = self.signals | self.deltas
            self.deltas = 0
            return value
        return self.scratch

    def write(self, port: int, value: int) -> None:
        offset = port - self.base
        value &= 0xFF
        dlab = bool(self.lcr & LCR_DLAB)
        if offset == THR:
            if dlab:
                self.divisor = (self.divisor & 0xFF00) | value
                return
            if self.mcr & MCR_LOOPBACK:
                self.rx.append(value)
            else:
                # Firmware must wait for THRE before replacing this byte. Keep
                # the latest write if it violates that contract, matching a
                # one-byte holding register rather than an unbounded sink.
                self.tx_holding = value
            self.thre = False
            return
        if offset == IER:
            if dlab:
                self.divisor = (self.divisor & 0x00FF) | (value << 8)
                return
            enabled = value & ~self.ier
            self.ier = value
            # Arming the transmit interrupt on an idle holding register is
            # itself an interrupt; a driver that primes its output this way
            # would otherwise never get its first callback.
            if enabled & IER_THRE:
                self.thre = True
            return
        if offset == LCR:
            self.lcr = value
            return
        if offset == MCR:
            self.mcr = value
            return
        if offset == SCR:
            self.scratch = value
            return
        # FCR and LSR writes change nothing this model represents.

    def _loopback_status(self) -> int:
        """MCR outputs folded back onto the status inputs, as the part does."""
        value = 0
        if self.mcr & MCR_RTS:
            value |= MSR_CTS
        if self.mcr & MCR_DTR:
            value |= MSR_DSR
        if self.mcr & MCR_OUT2:
            value |= MSR_DCD
        return value

    # -- reporting ---------------------------------------------------------

    def status(self) -> dict[str, Any]:
        return {
            "base": f"{self.base:#06x}",
            "irq": self.irq,
            "ier": self.ier,
            "lcr": self.lcr,
            "mcr": self.mcr,
            "divisor": self.divisor,
            "input_clock_hz": self.input_clock_hz,
            "baud": self.baud,
            "character_instructions": self.character_instructions,
            "signals": self.signals,
            "queued": self.queued,
            "received": self.received,
            "transmitted": self.transmitted,
            "overruns": self.overruns,
        }
