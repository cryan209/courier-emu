from __future__ import annotations

import ctypes
from dataclasses import dataclass, field

from .poll_state import PicChip, PollState, shared_field


# A cascaded pair of Intel 8259s, as the ISDN Courier programs them:
#
#   master  0xf020/0xf021  ICW1 0x11  ICW2 0x20  ICW3 0x04  ICW4 0x11
#   slave   0xf0a0/0xf0a1  ICW1 0x11  ICW2 0x28  ICW3 0x02  ICW4 0x01
#
# So the slave hangs off master IR2 and the vector map is the PC-AT one:
# IRQ0..7 at INT 0x20..0x27 and IRQ8..15 at INT 0x28..0x2f. VRTX sits above
# that at INT 0x30 and 0x31.
MASTER_COMMAND = 0xF020
MASTER_DATA = 0xF021
SLAVE_COMMAND = 0xF0A0
SLAVE_DATA = 0xF0A1
PORTS = (MASTER_COMMAND, MASTER_DATA, SLAVE_COMMAND, SLAVE_DATA)

CASCADE_LINE = 2

# ICW1 selects the initialisation sequence; OCW3 selects what a command-port
# read returns; OCW2 carries the end-of-interrupt forms.
ICW1_INIT = 0x10
ICW1_NEEDS_ICW4 = 0x01
ICW1_SINGLE = 0x02
OCW3_SELECT = 0x08
OCW3_READ_IRR = 0x0A
OCW3_READ_ISR = 0x0B
OCW2_EOI = 0x20
OCW2_SPECIFIC = 0x40
ICW4_AUTO_EOI = 0x02


class Pic8259:
    """One 8259, tracking the request, service, and mask registers.

    The registers live in a `PicChip` (poll_state.py), so the native port model
    can run the same logic on the same memory; `bind` moves a chip onto the
    harness's shared copy.
    """

    vector_base = shared_field("vector_base")
    mask = shared_field("mask")
    irr = shared_field("irr")
    isr = shared_field("isr")
    auto_eoi = shared_field("auto_eoi", bool)
    read_isr = shared_field("read_isr", bool)
    # Remaining ICW words expected: 0 means the chip is initialised.
    init_words = shared_field("init_words")
    expect_icw4 = shared_field("expect_icw4", bool)
    single = shared_field("single", bool)

    def __init__(self, name: str, vector_base: int = 0, mask: int = 0xFF,
                 irr: int = 0, isr: int = 0, auto_eoi: bool = False,
                 read_isr: bool = False, init_words: int = 0,
                 expect_icw4: bool = False, single: bool = False) -> None:
        self.name = name
        self._s = PicChip()
        self.vector_base, self.mask, self.irr, self.isr = vector_base, mask, irr, isr
        self.auto_eoi, self.read_isr, self.init_words = auto_eoi, read_isr, init_words
        self.expect_icw4, self.single = expect_icw4, single

    def bind(self, chip: PicChip) -> None:
        """Carry on in `chip`, which takes over this one's registers."""
        ctypes.memmove(ctypes.addressof(chip), ctypes.addressof(self._s),
                       ctypes.sizeof(PicChip))
        self._s = chip

    def command(self, value: int) -> None:
        if value & ICW1_INIT:
            # ICW1 restarts initialisation and clears the mask on real parts.
            self.expect_icw4 = bool(value & ICW1_NEEDS_ICW4)
            self.single = bool(value & ICW1_SINGLE)
            self.init_words = 1  # ICW2 next
            self.isr = 0
            self.irr = 0
            return
        if value & OCW3_SELECT:
            if value == OCW3_READ_ISR:
                self.read_isr = True
            elif value == OCW3_READ_IRR:
                self.read_isr = False
            return
        if value & OCW2_EOI:
            if value & OCW2_SPECIFIC:
                self.isr &= ~(1 << (value & 0x07))
            else:
                self._clear_highest_in_service()

    def _clear_highest_in_service(self) -> None:
        for line in range(8):
            if self.isr & (1 << line):
                self.isr &= ~(1 << line)
                return

    def data(self, value: int) -> None:
        if self.init_words == 1:  # ICW2, the vector base
            self.vector_base = value & 0xF8
            if not self.single:
                self.init_words = 2
            else:
                self.init_words = 3 if self.expect_icw4 else 0
            return
        if self.init_words == 2:  # ICW3, the cascade wiring
            self.init_words = 3 if self.expect_icw4 else 0
            return
        if self.init_words == 3:  # ICW4
            self.auto_eoi = bool(value & ICW4_AUTO_EOI)
            self.init_words = 0
            return
        self.mask = value & 0xFF

    def read_command(self) -> int:
        return self.isr if self.read_isr else self.irr

    def read_data(self) -> int:
        return self.mask

    def raise_line(self, line: int) -> None:
        self.irr |= 1 << line

    def pending(self, irr: int | None = None) -> int | None:
        """Highest-priority unmasked request not already being serviced."""
        ready = (self.irr if irr is None else irr) & ~self.mask
        if not ready:
            return None
        for line in range(8):
            bit = 1 << line
            if self.isr & bit:
                # A lower-priority request waits behind one in service.
                return None
            if ready & bit:
                return line
        return None

    def acknowledge(self, line: int) -> None:
        self.irr &= ~(1 << line)
        if not self.auto_eoi:
            self.isr |= 1 << line


@dataclass
class InterruptControllers:
    """The cascaded pair, resolving a request down to a CPU vector."""

    master: Pic8259 = field(default_factory=lambda: Pic8259("master"))
    slave: Pic8259 = field(default_factory=lambda: Pic8259("slave"))
    _delivered: int = 0
    _state: PollState | None = None

    @property
    def delivered(self) -> int:
        return self._state.delivered if self._state is not None else self._delivered

    @delivered.setter
    def delivered(self, value: int) -> None:
        if self._state is not None:
            self._state.delivered = value
        else:
            self._delivered = value

    def bind(self, state: PollState) -> None:
        """Keep the controllers' registers in the harness's shared state."""
        state.delivered = self._delivered
        self.master.bind(state.pic[0])
        self.slave.bind(state.pic[1])
        self._state = state

    def handles(self, port: int) -> bool:
        return port in PORTS

    def write(self, port: int, value: int) -> None:
        value &= 0xFF
        if port == MASTER_COMMAND:
            self.master.command(value)
        elif port == MASTER_DATA:
            self.master.data(value)
        elif port == SLAVE_COMMAND:
            self.slave.command(value)
        elif port == SLAVE_DATA:
            self.slave.data(value)

    def read(self, port: int) -> int:
        if port == MASTER_COMMAND:
            return self.master.read_command()
        if port == MASTER_DATA:
            return self.master.read_data()
        if port == SLAVE_COMMAND:
            return self.slave.read_command()
        if port == SLAVE_DATA:
            return self.slave.read_data()
        return 0

    def raise_irq(self, irq: int) -> None:
        """Assert IRQ0..15; 8..15 arrive through the slave's cascade line."""
        if irq < 8:
            self.master.raise_line(irq)
        else:
            self.slave.raise_line(irq - 8)
            self.master.raise_line(CASCADE_LINE)

    def would_deliver(self, lines) -> bool:
        """Whether `pending_vector` would hand back a vector once `lines` are asserted.

        Nothing is changed: a cascade request with nothing behind it, which
        `pending_vector` only tidies away, does not count.
        """
        master_irr, slave_irr = self.master.irr, self.slave.irr
        for irq in lines:
            if irq < 8:
                master_irr |= 1 << irq
            else:
                slave_irr |= 1 << (irq - 8)
                master_irr |= 1 << CASCADE_LINE
        line = self.master.pending(master_irr)
        if line is None:
            return False
        if line == CASCADE_LINE:
            return self.slave.pending(slave_irr) is not None
        return True

    def pending_vector(self) -> int | None:
        """Resolve the next vector to deliver, or None if nothing is ready."""
        line = self.master.pending()
        if line is None:
            return None
        if line == CASCADE_LINE:
            slave_line = self.slave.pending()
            if slave_line is None:
                # The cascade is asserted with nothing behind it; drop it so the
                # master does not spin on a request that cannot resolve.
                self.master.irr &= ~(1 << CASCADE_LINE)
                return None
            self.master.acknowledge(CASCADE_LINE)
            self.slave.acknowledge(slave_line)
            self.delivered += 1
            return self.slave.vector_base + slave_line
        self.master.acknowledge(line)
        self.delivered += 1
        return self.master.vector_base + line

    def status(self) -> dict[str, object]:
        return {
            "delivered": self.delivered,
            "master": {
                "vector_base": self.master.vector_base,
                "mask": self.master.mask,
                "irr": self.master.irr,
                "isr": self.master.isr,
                "auto_eoi": self.master.auto_eoi,
            },
            "slave": {
                "vector_base": self.slave.vector_base,
                "mask": self.slave.mask,
                "irr": self.slave.irr,
                "isr": self.slave.isr,
                "auto_eoi": self.slave.auto_eoi,
            },
        }
