"""`would_deliver` predicts `pending_vector` without touching the controller."""
from courier_emu.pic import InterruptControllers


def controllers():
    pic = InterruptControllers()
    pic.master.vector_base = 0x08
    pic.slave.vector_base = 0x70
    return pic


def test_nothing_asserted_delivers_nothing():
    pic = controllers()
    assert not pic.would_deliver([])
    assert pic.pending_vector() is None


def test_an_unmasked_line_delivers_and_a_masked_one_does_not():
    pic = controllers()
    pic.master.mask = 0xFF
    assert not pic.would_deliver([3])
    pic.master.mask = ~(1 << 3) & 0xFF
    assert pic.would_deliver([3])
    # Nothing was changed by asking.
    assert pic.master.irr == 0
    pic.raise_irq(3)
    assert pic.pending_vector() == 0x08 + 3


def test_a_cascade_with_a_masked_slave_line_is_only_tidied_away():
    pic = controllers()
    pic.master.mask = 0
    pic.slave.mask = 0xFF
    assert not pic.would_deliver([12])
    pic.slave.mask = ~(1 << 4) & 0xFF
    assert pic.would_deliver([12])
    pic.raise_irq(12)
    assert pic.pending_vector() == 0x70 + 4


def test_a_line_in_service_blocks_lower_priority_ones():
    pic = controllers()
    pic.master.mask = 0
    pic.raise_irq(1)
    assert pic.pending_vector() == 0x08 + 1
    assert not pic.would_deliver([5])


def test_a_slave_request_behind_one_in_service_is_delivered_after_its_eoi():
    # IRQ11 and IRQ13 together: IRQ11 is taken first, and acknowledging the
    # cascade must not strand IRQ13 once IRQ11's handler sends its EOIs.
    pics = InterruptControllers()
    for port, value in ((0xF020, 0x11), (0xF021, 0x20), (0xF021, 0x04), (0xF021, 0x11),
                        (0xF021, 0x00), (0xF0A0, 0x11), (0xF0A1, 0x28), (0xF0A1, 0x02),
                        (0xF0A1, 0x01), (0xF0A1, 0x00)):
        pics.write(port, value)
    pics.raise_irq(11)
    pics.raise_irq(13)
    assert pics.pending_vector() == 0x2B
    assert pics.pending_vector() is None      # IRQ13 waits behind IRQ11
    pics.write(0xF0A0, 0x20)                  # slave EOI
    pics.write(0xF020, 0x20)                  # master EOI
    assert pics.pending_vector() == 0x2D
