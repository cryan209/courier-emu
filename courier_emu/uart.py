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

    @property
    def receive_enabled(self) -> bool:
        return bool(self.control & CONTROL_RECEIVE_ENABLE)

    def read(self, address: int, size: int) -> int | None:
        """The value a read of `address` should find, or None if not ours."""
        if address == S0STS:
            # Reading the status word is the acknowledge. Nothing is latched
            # in it that this models, so it reads clean every time.
            return 0
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
            self.pending.append(TRANSMIT_VECTOR)
            return value & 0xFF
        return None

    def deliver(self, byte: int) -> None:
        """Place a byte in the receive buffer and request its interrupt."""
        self.receive_holding = byte & 0xFF
        self.received += 1
        self.pending.append(RECEIVE_VECTOR)

    def status(self) -> dict[str, Any]:
        return {
            "control": f"{self.control:#06x}",
            "baud_compare": f"{self.baud_compare:#06x}",
            "receive_enabled": self.receive_enabled,
            "received": self.received,
            "transmitted": self.transmitted,
        }
