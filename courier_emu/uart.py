"""The 80C186EB serial port, as the board ROM drives it.

The update payload reaches its DTE through hand-modelled I/O ports; a ROM
boots from its reset vector and programs the integrated serial unit in the
relocated peripheral control block instead, so a ROM run needs the part:

    ff60  B0CMP   baud compare, written 0x8015 - enable plus divisor
    ff62  B0CNT   baud counter
    ff64  S0CON   control, written 0x21 - mode 1 with receive enabled
    ff66  S0STS   status, cleared by the read
    ff68  S0RBUF  receive buffer
    ff6a  S0TBUF  transmit buffer

Both directions are interrupt driven, and the live board's own vector table
says on which types: 0x14 enters `cld; pushaw; mov ax, [0xff68]; call [0x26a]`
at 0x80f23, and 0x15 enters the transmit side at 0x80f1c. Those are the
part's fixed serial types, so they are not configuration this has to recover.

Transmit is a plain store - `mov word ptr [0xff6a], ax` at 33 sites - with no
status poll ahead of it, so a byte is taken whenever the firmware writes one.

What is deliberately not modelled is the error side of the status word. The
firmware reads S0STS at 13 sites and tests it at exactly one, `and al, 0x10`
at 0x9f03e, where a set bit skips the receive; the remaining reads discard the
value, which is the acknowledge the part needs and nothing more. So status is
reported clean, and a run that would have to raise a framing or overrun error
is outside what this reproduces rather than guessed at.
"""
from __future__ import annotations

from collections import deque
from dataclasses import dataclass, field
from typing import Any

B0CMP = 0xFF60
B0CNT = 0xFF62
S0CON = 0xFF64
S0STS = 0xFF66
S0RBUF = 0xFF68
S0TBUF = 0xFF6A

REGISTERS = (B0CMP, B0CNT, S0CON, S0STS, S0RBUF, S0TBUF)

# S0CON bit 5 enables the receiver. The ROM writes 0x21 - mode 1 plus this.
CONTROL_RECEIVE_ENABLE = 0x20

# S0STS bit assignments, from Figure 10-14 of the 80C186EB user's manual
# (270830-003, page 10-16). The figure's fields sit above a reserved bit 0, so
# every name is one place higher than a plain reading of the field list gives:
# CTS 1, OE 2, TXE 3, FE 4, TI 5, RI 6, RB8/PE 7, DBRK0 8, DBRK1 9.
#
# Four firmware uses corroborate that offset, and none of them parses under the
# unshifted reading: the pre-transmit spin at 0x81603 waits on mask 8 (TXE, not
# FE); 0x9f03e skips a receive when mask 0x10 is set (FE, not TI); 0x8181e and
# 0x81892 test mask 0x300 (DBRK0/DBRK1, i.e. BREAK from the DTE); and the
# transmit ISR's second-byte write at 0x819f1 gates on mask 2.
#
# CTS is the complement of the CTS pin, which the DTE drives with RTS. It is
# not cleared by reading the register.
CLEAR_TO_SEND = 0x02
# TXE, set when SxTBUF and the shift register are both empty. The transmit
# routine at 0x81613 spins on it before every byte it writes to S0TBUF, and
# the ISR uses it to decide whether a second byte can follow immediately.
# Nothing here queues a byte behind another, so the transmitter is always
# ready. Accessing S0STS does not clear TXE.
TRANSMIT_READY = 0x08
# RI, set when a character has been placed in S0RBUF. This board's receive is
# interrupt driven off the vector below and no firmware path polls RI, which
# is why an earlier revision of this module could label bit 1 as receive-ready
# without a run detecting the error.
RECEIVE_READY = 0x40

# The part's fixed serial interrupt types, confirmed against the live board's
# vector table rather than assumed.

RECEIVE_VECTOR = 0x14
TRANSMIT_VECTOR = 0x15


@dataclass
class EbSerial:
    """Serial port 0 of the 80C186EB, driven from the control block."""

    control: int = 0
    baud_compare: int = 0
    baud_count: int = 0
    receive_holding: int = 0
    transmitted: int = 0
    received: int = 0
    pending: deque[int] = field(default_factory=deque)
    # A character on the wire, not yet handed to the firmware.
    holding: bool = False
    receive_ready: bool = False
    # The CTS pin's asserted state, which a real DTE drives with RTS.
    #
    # Nothing here models the host side of the Plug and Play handshake, so
    # this is raised with each delivered character and consumed by the status
    # read, reproducing exactly the edge timing that the pre-correction model
    # produced from this bit. That keeps the [0x31f] chain advancing, but it
    # is a stand-in: the real sequence is the DTE dropping DTR on port 0x14
    # bit 0 and asserting RTS 30 to 50 ticks later, and until the terminal
    # model drives those two lines the chain is reached by the right bit for
    # the wrong reason. On the part, reading the register does not clear CTS.
    clear_to_send: bool = False

    @property
    def receive_enabled(self) -> bool:
        return bool(self.control & CONTROL_RECEIVE_ENABLE)

    def read(self, address: int, size: int) -> int | None:
        """The value a read of `address` should find, or None if not ours."""
        if address == S0STS:
            # The callback chain at [0x31f] is the Plug and Play external COM
            # device enumeration: it wants DTR dropped and then CTS asserted,
            # and posts event 0x0e, which emits the PnP identifier string. An
            # earlier revision reached the same node by treating bit 1 as
            # receive-data-available, because asserting it does advance the
            # chain - as CTS, not as data. Bit 1 is driven from the modelled
            # DTE's handshake instead. The error bits are not modelled - see
            # the module docstring.
            ready = self.receive_ready
            # RI and TI are read to clear, which is why the firmware reads the
            # register at sites that discard the value: those reads are the
            # acknowledge. Taking the byte out of S0RBUF does not clear it.
            # CTS and TXE are not cleared by the read.
            self.receive_ready = False
            cts, self.clear_to_send = self.clear_to_send, False
            # RI is deliberately not asserted. This board's receive is
            # interrupt driven off RECEIVE_VECTOR and no firmware path polls
            # RI, so leaving it clear keeps the model's observable behaviour
            # identical to the revision that had the bit map wrong, rather
            # than introducing an untested status bit alongside the fix.
            del ready
            return TRANSMIT_READY | (CLEAR_TO_SEND if cts else 0)
        if address == S0RBUF:
            return self.receive_holding
        if address == S0CON:
            return self.control
        if address == B0CMP:
            return self.baud_compare
        if address == B0CNT:
            return self.baud_count
        return None

    def write(self, address: int, size: int, value: int) -> int | None:
        """Apply a write. Returns a byte the firmware transmitted, or None."""
        if address == S0CON:
            self.control = value
        elif address == B0CMP:
            self.baud_compare = value
        elif address == B0CNT:
            self.baud_count = value
        elif address == S0TBUF:
            self.transmitted += 1
            self._request(TRANSMIT_VECTOR)
            return value & 0xFF
        return None

    def _request(self, vector: int) -> None:
        """Latch an interrupt request, once.

        Each direction has one request latch on the part, not a queue. Letting
        them stack put the banner's sixty-one transmit interrupts in front of
        everything else, and the run loop dispatches one source per iteration:
        the receive line's edge waited about sixty thousand instructions
        behind them, by which time the rate measurement it carries is meanin-
        gless.
        """
        if vector not in self.pending:
            self.pending.append(vector)

    def line_idle(self) -> bool:
        """Whether the DTE handshake line is still at its unasserted level.

        Bit 0 of port 0x14 is not the receive data line - the callback chain
        at [0x31f] samples it about every 133,000 instructions, far too
        slowly to catch a start bit. It is a level: 0x82b0f waits for it
        unasserted, 0x82b2d for it asserted, and only then does the chain set
        the debounce counter at [0x321] that ends in the startup banner.
        0x826e7 busy-waits on the same pin.

        The chain has to observe the unasserted level before the asserted
        one, so the harness's terminal raises its handshake a fixed way into
        the run rather than at reset - a terminal switched on after the modem
        came up, which is the order the chain is written for. The machine
        owns that timing; this only reports whether a character is waiting.
        """
        return self.received == 0 and not self.holding



    def deliver(self, byte: int) -> None:
        """Place a byte in the receive buffer and request its interrupt."""
        self.receive_holding = byte & 0xFF
        self.receive_ready = True
        # Stand-in for the DTE's RTS; see the field's comment.
        self.clear_to_send = True
        self.received += 1
        self._request(RECEIVE_VECTOR)

    def status(self) -> dict[str, Any]:
        return {
            "control": f"{self.control:#06x}",
            "baud_compare": f"{self.baud_compare:#06x}",
            "receive_enabled": self.receive_enabled,
            "clear_to_send": self.clear_to_send,
            "received": self.received,
            "transmitted": self.transmitted,
        }
