"""The 386EX SIO channel model, against the decode its firmware ISR implies."""
import pytest

from courier_emu.sio import (
    IER_MSR,
    IER_RX,
    IER_THRE,
    IIR_MODEM,
    IIR_NONE,
    IIR_RX,
    IIR_THRE,
    LSR_DATA_READY,
    LSR_TX_READY,
    MCR_DTR,
    MCR_LOOPBACK,
    MCR_RTS,
    MSR_CTS,
    MSR_DCD,
    MSR_DELTA_CTS,
    MSR_DSR,
    SerialChannel,
)

BASE = 0xF8F8


@pytest.fixture
def channel():
    return SerialChannel(BASE, irq=3, pace=100)


def deliver(channel, data, start=0):
    """Feed and release, the way poll_timers does."""
    channel.feed(data)
    for step in range(len(data) + 1):
        channel.advance(start + step * channel.pace)


def test_received_bytes_reach_the_firmware_through_rbr_and_lsr(channel):
    deliver(channel, b"AT\r")
    for expected in b"AT\r":
        assert channel.read(BASE + 5) & LSR_DATA_READY
        assert channel.read(BASE) == expected
    assert not channel.read(BASE + 5) & LSR_DATA_READY
    assert channel.read(BASE + 5) & LSR_TX_READY


def test_the_line_rate_spaces_the_bytes_out(channel):
    channel.feed(b"AT")
    channel.advance(0)
    assert channel.read(BASE + 5) & LSR_DATA_READY
    channel.read(BASE)
    # The second byte is still in flight until a character time has passed.
    assert not channel.read(BASE + 5) & LSR_DATA_READY
    channel.advance(channel.pace)
    assert channel.read(BASE + 5) & LSR_DATA_READY


def test_an_idle_line_does_not_bank_up_credit_for_a_burst(channel):
    channel.advance(1_000_000)
    channel.feed(b"ATI3\r")
    channel.advance(1_000_000)
    assert not channel.rx, "the first byte still takes a character time"
    channel.advance(1_000_000 + channel.pace)
    assert len(channel.rx) == 1, "and the rest are not already behind it"


def test_iir_reports_the_ier_enabled_sources_in_priority_order(channel):
    assert channel.read(BASE + 2) == IIR_NONE
    deliver(channel, b"A")
    assert channel.read(BASE + 2) == IIR_NONE, "a masked source is not pending"
    channel.write(BASE + 1, IER_RX | IER_THRE | IER_MSR)
    assert channel.read(BASE + 2) == IIR_RX
    channel.read(BASE)
    # Enabling the transmit interrupt on an idle holding register arms it.
    assert channel.read(BASE + 2) == IIR_THRE
    assert channel.read(BASE + 2) == IIR_MODEM, "reading IIR clears THRE"
    channel.read(BASE + 6)
    assert channel.read(BASE + 2) == IIR_NONE


def test_the_channel_interrupts_only_while_a_source_is_pending(channel):
    channel.write(BASE + 1, IER_RX)
    channel.read(BASE + 6)
    assert not channel.interrupting()
    deliver(channel, b"A")
    assert channel.interrupting()
    channel.read(BASE)
    assert not channel.interrupting()


def test_modem_status_shows_a_ready_terminal_and_latches_its_changes(channel):
    first = channel.read(BASE + 6)
    assert first & (MSR_CTS | MSR_DSR | MSR_DCD) == MSR_CTS | MSR_DSR | MSR_DCD
    assert first & MSR_DELTA_CTS, "a cold read reports the lines as changed"
    assert not channel.read(BASE + 6) & 0x0F, "the deltas are read-once"
    channel.set_signals(MSR_DSR | MSR_DCD)
    assert channel.read(BASE + 6) & MSR_DELTA_CTS


def test_dlab_routes_the_first_two_registers_to_the_divisor(channel):
    channel.write(BASE + 3, 0x83)
    channel.write(BASE, 0x50)
    channel.write(BASE + 1, 0x00)
    assert channel.divisor == 0x0050
    assert channel.tx == b"", "a divisor write is not a transmitted byte"
    channel.write(BASE + 3, 0x03)
    channel.write(BASE, ord("O"))
    assert channel.tx == b"", "the byte is still in THR"
    channel.advance(0)
    assert channel.tx == b"", "the byte is still crossing the serial line"
    channel.advance(channel.pace)
    assert channel.tx == b"O"


def test_the_programmed_divisor_sets_the_character_time():
    channel = SerialChannel(BASE, irq=3)
    channel.write(BASE + 3, 0x83)
    channel.write(BASE, 80)
    channel.write(BASE + 1, 0)
    channel.write(BASE + 3, 0x03)  # 8 data, no parity, one stop
    assert channel.character_instructions == 17_362


def test_loopback_folds_the_outputs_back_onto_the_status_inputs(channel):
    channel.write(BASE + 4, MCR_LOOPBACK | MCR_RTS | MCR_DTR)
    assert channel.read(BASE + 6) & (MSR_CTS | MSR_DSR) == MSR_CTS | MSR_DSR
    assert not channel.read(BASE + 6) & MSR_DCD
    channel.write(BASE, ord("A"))
    assert channel.read(BASE) == ord("A")
    assert channel.tx == b"", "a looped byte does not reach the wire"
