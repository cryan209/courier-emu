from __future__ import annotations

from dataclasses import dataclass, field


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


@dataclass
class Pic8259:
    """One 8259, tracking the request, service, and mask registers."""

    name: str
    vector_base: int = 0
    mask: int = 0xFF
    irr: int = 0
    isr: int = 0
    auto_eoi: bool = False
    read_isr: bool = False
    # Remaining ICW words expected: 0 means the chip is initialised.
    init_words: int = 0
    expect_icw4: bool = False
    single: bool = False

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

    def pending(self) -> int | None:
        """Highest-priority unmasked request not already being serviced."""
        ready = self.irr & ~self.mask
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
    delivered: int = 0

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
