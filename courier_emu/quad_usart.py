"""Quad chassis link: the observed 2681-family DUART channel A registers.

Port 0x222 is SR on reads and CSR on writes; 0x22a is ISR/IMR.
SR ready bits (0, 2) differ from ISR ready bits (1, 0). The receive queue
represents a remote sender, paced into the three-byte hardware FIFO by advance.
Only enabled, unmasked device events assert irq_pending. No serial clock or
channel B is implemented yet; CTS is an explicit input, asserted by default.
"""
from __future__ import annotations

from collections import deque
from dataclasses import dataclass, field

BASE = MODE = 0x220
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
    rx: deque[int] = field(default_factory=deque)
    fifo: deque[int] = field(default_factory=deque)
    tx: bytearray = field(default_factory=bytearray)
    mode_writes: list[int] = field(default_factory=list)
    command_writes: list[int] = field(default_factory=list)
    aux_writes: list[tuple[int, int]] = field(default_factory=list)
    modes: list[int] = field(default_factory=lambda: [0, 0])
    mode_pointer: int = 0
    receiver_enabled: bool = False
    transmitter_enabled: bool = False
    cts: bool = True
    interrupt_mask: int = 0
    clock_select: int = 0
    auxiliary_control: int = 0
    reads: int = 0
    empty_reads: int = 0
    status_reads: int = 0
    interrupt_reads: int = 0

    def queue(self, data: bytes | bytearray | list[int]) -> None:
        """Schedule bytes from a remote sender (not a preloaded RX FIFO)."""
        self.rx.extend(int(b) & 0xff for b in data)

    def advance(self) -> None:
        if self.receiver_enabled and self.rx and len(self.fifo) < 3:
            self.fifo.append(self.rx.popleft())

    @property
    def pending(self) -> bool:
        return bool(self.rx or self.fifo)

    @property
    def tx_ready(self) -> bool:
        return self.transmitter_enabled and (self.cts or not self.modes[1] & 0x10)

    def status(self) -> int:
        return ((0x0c if self.tx_ready else 0)
                | (RX_READY if self.fifo else 0)
                | (2 if len(self.fifo) == 3 else 0))

    def interrupt_status(self) -> int:
        rx_ready = len(self.fifo) == 3 if self.modes[0] & 0x40 else bool(self.fifo)
        return (1 if self.tx_ready else 0) | (2 if self.receiver_enabled and rx_ready else 0)

    @property
    def irq_pending(self) -> bool:
        return bool(self.interrupt_status() & self.interrupt_mask)

    def read(self, port: int, size: int) -> int | None:
        if port not in PORTS:
            return None
        if port == STATUS:
            self.status_reads += 1
            return self.status()
        if port == AUX_B:
            self.interrupt_reads += 1
            return self.interrupt_status()
        if port == DATA:
            self.reads += 1
            if self.fifo:
                return self.fifo.popleft()
            self.empty_reads += 1
            return 0
        if port == MODE:
            value = self.modes[self.mode_pointer]
            self.mode_pointer = 1
            return value
        return 0

    def write(self, port: int, size: int, value: int) -> bool:
        if port not in PORTS:
            return False
        value &= 0xff
        if port == DATA:
            if self.tx_ready:
                self.tx.append(value)
        elif port == MODE:
            self.mode_writes.append(value)
            self.modes[self.mode_pointer] = value
            self.mode_pointer = 1
        elif port == COMMAND:
            self.command_writes.append(value)
            command = (value >> 4) & 7
            if command == 1:
                self.mode_pointer = 0
            elif command == 2:
                self.receiver_enabled = False
                self.fifo.clear()
            elif command == 3:
                self.transmitter_enabled = False
            if value & 2:
                self.receiver_enabled = False
            elif value & 1:
                self.receiver_enabled = True
            if value & 8:
                self.transmitter_enabled = False
            elif value & 4:
                self.transmitter_enabled = True
        else:
            self.aux_writes.append((port, value))
            if port == STATUS:
                self.clock_select = value
            elif port == AUX_A:
                self.auxiliary_control = value
            elif port == AUX_B:
                self.interrupt_mask = value
        return True

    def state(self) -> dict[str, object]:
        return {
            "rx_queued": len(self.rx), "rx_fifo": len(self.fifo),
            "data_reads": self.reads, "empty_reads": self.empty_reads,
            "status_reads": self.status_reads, "interrupt_reads": self.interrupt_reads,
            "interrupt_mask": self.interrupt_mask, "irq_pending": self.irq_pending,
            "receiver_enabled": self.receiver_enabled,
            "transmitter_enabled": self.transmitter_enabled,
            "tx": bytes(self.tx).hex(), "tx_len": len(self.tx),
            "mode_writes": [f"{v:#04x}" for v in self.mode_writes],
            "command_writes": [f"{v:#04x}" for v in self.command_writes],
            "aux_writes": [f"{p:#06x}={v:#04x}" for p, v in self.aux_writes],
        }
