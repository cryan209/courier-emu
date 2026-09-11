"""The I-modem's AT interface, driven end to end through SIO0.

This is the whole path at once: VRTX startup, the command task, the serial
ISR at 0xb2aa2 reached over IRQ3, and the firmware's own banner coming back
out of the transmit holding register.
"""
from pathlib import Path

import pytest

from courier_emu.isdn import IsdnMachine
from courier_emu.isdn_console import scripted_pump
from courier_emu.nac import NacImage

IMAGE = Path("Ie030002.nac")
# ATI3 answers a little after 48M instructions when the line is typed at the
# default warm-up and spacing; the margin is for slower answers, not for a
# different result.
BANNER_INSTRUCTIONS = 52_000_000


@pytest.fixture(scope="module")
def session():
    if not IMAGE.exists():
        pytest.skip("local I-modem firmware not available")
    transcript: list[tuple[int, str, str]] = []
    # The firmware consumes the first line it is given without answering it,
    # so the session opens with a throwaway AT.
    pump = scripted_pump(["AT", "AT", "ATI3"], transcript=transcript)
    machine = IsdnMachine(NacImage.load(IMAGE), serial_pump=pump)
    result = machine.run(BANNER_INSTRUCTIONS)
    return machine, result, transcript


def received(transcript):
    return "".join(text for _, direction, text in transcript
                   if direction == "received")


def test_the_firmware_identifies_itself_over_the_at_interface(session):
    _, _, transcript = session
    assert "USRobotics Courier I-Modem with ISDN/V.34" in received(transcript)


def test_the_command_port_is_programmed_and_interrupt_driven(session):
    machine, result, _ = session
    channel = machine.channels[0xF8F8]
    # 8 data bits, no parity, one stop; receive, transmit and modem-status
    # interrupts all enabled by the firmware itself.
    assert channel.lcr == 0x03
    assert channel.ier == 0x0B
    assert channel.irq == 3, "vector 0x23 is the serial ISR at 0xb2aa2"
    assert channel.received == len("AT\rAT\rATI3\r")
    assert channel.transmitted > 0
    assert result.serial["a"]["overruns"] == 0


def test_the_banner_is_transmitted_with_bit_seven_set(session):
    machine, _, _ = session
    raw = bytes(machine.channels[0xF8F8].tx)
    assert b"USRobotics" not in raw, "the firmware marks the eighth bit"
    assert b"USRobotics" in bytes(byte & 0x7F for byte in raw)


def test_ati2_answers_ok_so_the_result_table_is_not_mis_indexed():
    """The reason a bare AT answers NO CARRIER is not a bad table index.

    Index 0 of the result table at 0xcef4b is reachable: ATI2 - the ROM
    checksum test - answers a plain OK. See docs/imodem-at-interface.md for
    what sends the other commands down the go-idle epilogue instead.
    """
    if not IMAGE.exists():
        pytest.skip("local I-modem firmware not available")
    transcript: list[tuple[int, str, str]] = []
    pump = scripted_pump(["AT", "AT", "ATI2"], transcript=transcript)
    machine = IsdnMachine(NacImage.load(IMAGE), serial_pump=pump)
    machine.run(BANNER_INSTRUCTIONS)
    typed = max(count for count, direction, _ in transcript
                if direction == "sent")
    answer = "".join(text for count, direction, text in transcript
                     if direction == "received" and count > typed)
    assert answer.strip() == "OK"
