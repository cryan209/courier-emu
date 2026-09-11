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

# How far apart queued receive bytes are handed to the firmware, in CPU
# instructions. A real line delivers a character every ten bit times; this
# harness has no recovered board clock to convert that into instructions, so
# the figure is a harness choice, like MAILBOX_SERVICE_INSTRUCTIONS in
# courier_emu/isdn.py. It is not cosmetic: delivered back to back, a pasted
# command line reaches the parser as one burst of interrupts and is handled
# differently -- ATI0 answers only when the characters arrive spaced out.
RX_INSTRUCTIONS_PER_BYTE = 20000


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
        pace: int = RX_INSTRUCTIONS_PER_BYTE,
    ) -> None:
        self.base = base
        self.irq = irq
        self.max_bytes = max_bytes
        self.pace = pace
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
        if not self.staged:
            # An idle line does not bank up credit for a later burst.
            self._next_byte = instructions + self.pace
            return
        if self.pace <= 0:
            while self.staged:
                self._receive(self.staged.popleft())
            return
        while self.staged and instructions >= self._next_byte:
            self._next_byte += self.pace
            self._receive(self.staged.popleft())
        if instructions >= self._next_byte:
            self._next_byte = instructions + self.pace

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
            return LSR_TX_READY | (LSR_DATA_READY if self.rx else 0)
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
            elif len(self.tx) < self.max_bytes:
                self.tx.append(value)
                self.transmitted += 1
            else:
                self.overruns += 1
            self.thre = True
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
            "signals": self.signals,
            "queued": self.queued,
            "received": self.received,
            "transmitted": self.transmitted,
            "overruns": self.overruns,
        }
