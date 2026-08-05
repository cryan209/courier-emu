from __future__ import annotations

import unittest

from courier_emu.pic import (
    MASTER_COMMAND,
    MASTER_DATA,
    SLAVE_COMMAND,
    SLAVE_DATA,
    InterruptControllers,
)


def initialise(pic: InterruptControllers) -> None:
    """Replay the ICW sequence the ISDN firmware writes."""
    for port, value in (
        (MASTER_COMMAND, 0x11),
        (MASTER_DATA, 0x20),
        (MASTER_DATA, 0x04),
        (MASTER_DATA, 0x11),
        (MASTER_DATA, 0xFF),
        (SLAVE_COMMAND, 0x11),
        (SLAVE_DATA, 0x28),
        (SLAVE_DATA, 0x02),
        (SLAVE_DATA, 0x01),
        (SLAVE_DATA, 0xFF),
    ):
        pic.write(port, value)


class InitialisationTests(unittest.TestCase):
    def setUp(self) -> None:
        self.pic = InterruptControllers()
        initialise(self.pic)

    def test_the_firmwares_icw_sequence_sets_the_pc_at_vector_map(self) -> None:
        self.assertEqual(self.pic.master.vector_base, 0x20)
        self.assertEqual(self.pic.slave.vector_base, 0x28)

    def test_icw4_bit_one_selects_auto_eoi(self) -> None:
        # The firmware writes ICW4 0x11 to the master and 0x01 to the slave, so
        # neither is in auto-EOI; both need an explicit end-of-interrupt.
        self.assertFalse(self.pic.master.auto_eoi)
        self.assertFalse(self.pic.slave.auto_eoi)

    def test_initialisation_leaves_everything_masked(self) -> None:
        self.assertEqual(self.pic.master.mask, 0xFF)
        self.assertEqual(self.pic.slave.mask, 0xFF)
        self.pic.raise_irq(0)
        self.assertIsNone(self.pic.pending_vector())

    def test_a_later_data_write_is_the_mask(self) -> None:
        self.pic.write(MASTER_DATA, 0xFB)
        self.assertEqual(self.pic.master.mask, 0xFB)
        self.assertEqual(self.pic.read(MASTER_DATA), 0xFB)


class DeliveryTests(unittest.TestCase):
    def setUp(self) -> None:
        self.pic = InterruptControllers()
        initialise(self.pic)
        self.pic.write(MASTER_DATA, 0x00)
        self.pic.write(SLAVE_DATA, 0x00)

    def test_a_master_line_resolves_to_its_vector(self) -> None:
        self.pic.raise_irq(3)
        self.assertEqual(self.pic.pending_vector(), 0x23)

    def test_a_slave_line_resolves_through_the_cascade(self) -> None:
        self.pic.raise_irq(10)
        self.assertEqual(self.pic.pending_vector(), 0x2A)
        # Both halves go in service: the slave line and the master's cascade.
        self.assertEqual(self.pic.slave.isr, 1 << 2)
        self.assertEqual(self.pic.master.isr, 1 << 2)

    def test_a_masked_line_is_not_delivered(self) -> None:
        self.pic.write(MASTER_DATA, 0xFF)
        self.pic.raise_irq(3)
        self.assertIsNone(self.pic.pending_vector())

    def test_in_service_blocks_a_second_delivery_until_eoi(self) -> None:
        self.pic.raise_irq(3)
        self.assertEqual(self.pic.pending_vector(), 0x23)
        self.pic.raise_irq(3)
        self.assertIsNone(self.pic.pending_vector())
        self.pic.write(MASTER_COMMAND, 0x20)  # non-specific EOI
        self.assertEqual(self.pic.pending_vector(), 0x23)

    def test_specific_eoi_clears_the_named_line(self) -> None:
        self.pic.raise_irq(3)
        self.pic.pending_vector()
        self.assertEqual(self.pic.master.isr, 1 << 3)
        self.pic.write(MASTER_COMMAND, 0x60 | 3)
        self.assertEqual(self.pic.master.isr, 0)

    def test_lower_number_wins(self) -> None:
        self.pic.raise_irq(6)
        self.pic.raise_irq(3)
        self.assertEqual(self.pic.pending_vector(), 0x23)

    def test_a_dangling_cascade_is_dropped(self) -> None:
        # Master IR2 asserted with nothing behind it must not wedge the model.
        self.pic.master.raise_line(2)
        self.assertIsNone(self.pic.pending_vector())
        self.assertEqual(self.pic.master.irr & (1 << 2), 0)

    def test_nothing_pending_returns_none(self) -> None:
        self.assertIsNone(self.pic.pending_vector())
        self.assertEqual(self.pic.delivered, 0)


class ReadbackTests(unittest.TestCase):
    def setUp(self) -> None:
        self.pic = InterruptControllers()
        initialise(self.pic)
        self.pic.write(MASTER_DATA, 0x00)

    def test_ocw3_selects_irr_or_isr(self) -> None:
        self.pic.raise_irq(3)
        self.pic.write(MASTER_COMMAND, 0x0A)  # read IRR
        self.assertEqual(self.pic.read(MASTER_COMMAND), 1 << 3)
        self.pic.pending_vector()
        self.pic.write(MASTER_COMMAND, 0x0B)  # read ISR
        self.assertEqual(self.pic.read(MASTER_COMMAND), 1 << 3)

    def test_status_reports_both_halves(self) -> None:
        status = self.pic.status()
        self.assertEqual(status["master"]["vector_base"], 0x20)
        self.assertEqual(status["slave"]["vector_base"], 0x28)
