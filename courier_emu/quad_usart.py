"""The Quad x2 Modem NAC's chassis USART, as its supervisor drives it.

The engine reaches the Total Control backplane through a byte-wide device on
even addresses at 0x220-0x22a - a 16-bit bus with A0 unconnected, so register
*n* sits at 0x220 + 2n. What the firmware does with it, from `QF060003`:

    0x220   mode      written twice at init, 0x93 then 0x17
    0x222   status    bit 0 RxRdy, bit 2 TxRdy
    0x224   command   0x10,0x20,0x30,0x40,0x50 reset walk, then 0x80, 0x01
    0x226   data      read at 0x824ec after testing bit 0 of 0x222,
                      written at 0x825e1 after testing bit 2

The status-bit assignment is not guessed: the receive path at 0x824e4 tests
`al, 1` before reading 0x226, and the transmit path at 0x825d8 tests `al, 4`
before writing it. See docs/nmc-sdl-protocol.md for the frame the bytes carry.

Everything this does not model is deliberate rather than assumed: the mode and
command words are recorded and echoed back, not decoded, because nothing in the
recovered firmware branches on reading them back. Transmit always reports ready.
"""
from __future__ import annotations

from collections import deque
from dataclasses import dataclass, field

BASE = 0x220
MODE = 0x220
STATUS = 0x222
COMMAND = 0x224
DATA = 0x226
AUX_A = 0x228
AUX_B = 0x22A
PORTS = frozenset((MODE, STATUS, COMMAND, DATA, AUX_A, AUX_B))

RX_READY = 0x01
TX_READY = 0x04


@dataclass
class QuadUsart:
    """The register block plus a receive queue and a transmit log."""

    rx: deque[int] = field(default_factory=deque)
    tx: bytearray = field(default_factory=bytearray)
    mode_writes: list[int] = field(default_factory=list)
    command_writes: list[int] = field(default_factory=list)
    aux_writes: list[tuple[int, int]] = field(default_factory=list)
    reads: int = 0
    status_reads: int = 0

    def queue(self, data: bytes | bytearray | list[int]) -> None:
        """Present bytes as if the chassis had clocked them in."""
        self.rx.extend(int(b) & 0xFF for b in data)

    @property
    def pending(self) -> bool:
        return bool(self.rx)

    def status(self) -> int:
        # Transmit is always ready: nothing downstream of this model applies
        # back-pressure, and the firmware only ever spins waiting for the bit.
        value = TX_READY
        if self.rx:
            value |= RX_READY
        return value

    def read(self, port: int, size: int) -> int | None:
        if port not in PORTS:
            return None
        if port == STATUS:
            self.status_reads += 1
            return self.status()
        if port == DATA:
            self.reads += 1
            return self.rx.popleft() if self.rx else 0x00
        if port == MODE:
            return self.mode_writes[-1] if self.mode_writes else 0x00
        if port == COMMAND:
            return self.command_writes[-1] if self.command_writes else 0x00
        return 0x00

    def write(self, port: int, size: int, value: int) -> bool:
        if port not in PORTS:
            return False
        value &= 0xFF
        if port == DATA:
            self.tx.append(value)
        elif port == MODE:
            self.mode_writes.append(value)
        elif port == COMMAND:
            self.command_writes.append(value)
        else:
            self.aux_writes.append((port, value))
        return True

    def state(self) -> dict[str, object]:
        return {
            "rx_queued": len(self.rx),
            "data_reads": self.reads,
            "status_reads": self.status_reads,
            "tx": bytes(self.tx).hex(),
            "tx_len": len(self.tx),
            "mode_writes": [f"{v:#04x}" for v in self.mode_writes],
            "command_writes": [f"{v:#04x}" for v in self.command_writes],
            "aux_writes": [f"{p:#06x}={v:#04x}" for p, v in self.aux_writes],
        }
