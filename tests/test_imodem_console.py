"""The I-modem's AT interface, driven end to end through SIO0.

This is the whole path at once: VRTX startup, the command task, the serial
ISR at 0xb2aa2 reached over IRQ3, and the firmware's own banner coming back
out of the transmit holding register.
"""
from pathlib import Path

import pytest

from courier_emu.isdn import (
    ALL_OPTIONS,
    IsdnMachine,
    PRODUCT_TYPE_MODES,
    idle_result_state,
)
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


def test_the_emulated_product_type_is_explicit_and_validated():
    # The bit values themselves are checked against ATI7's own string table in
    # test_ati7_names_the_product_type_bits_the_way_the_table_maps_them; this
    # one only covers the constructor's validation. It used to assert the
    # mapping inline, which is how a wrong one - every entry shifted by a
    # position - stayed pinned and looking verified.
    image = NacImage.load(IMAGE) if IMAGE.exists() else object()
    assert set(PRODUCT_TYPE_MODES) == {
        "undefined", "external", "internal", "rackmount",
    }
    # Rackmount is a bit the formatter can name but the board probe has no
    # verdict for, so it is not a machine the harness can be asked to be.
    with pytest.raises(ValueError):
        IsdnMachine(image, product_type="rackmount")
    assert IsdnMachine(image).product_type == "external"
    assert IsdnMachine(image, product_type="internal").product_type == "internal"
    assert IsdnMachine(image, product_type="undefined").product_type == "undefined"
    assert IsdnMachine(image, product_type="undefined").product_type == "undefined"
    assert IsdnMachine(image, product_modem=True).product_modem is True
    with pytest.raises(ValueError, match="product type"):
        IsdnMachine(image, product_type="desktop")


def test_all_ati7_modulation_options_are_enabled_by_default():
    # Bits 0/2 select HST and V32bis; 6/7 walk through Terbo, V.FC and V34+;
    # bit 5 adds x2. V.90 is unconditional in this firmware.
    assert ALL_OPTIONS == 0x01 | 0x04 | 0x20 | 0x40 | 0x80


def test_an_idle_keypress_does_not_report_a_spurious_disconnect():
    assert idle_result_state(0x17, 0) == (1, 1)
    assert idle_result_state(0x17, 0x40) == (0x17, 0x40)
    assert idle_result_state(3, 0) == (3, 0)


def test_the_firmwares_own_divisor_table_fits_the_two_recovered_clocks():
    """Read the baud table out of the booted firmware, not out of sio.py.

    This is the evidence the two clocks rest on, so it has to come from the
    image. The table is at c774:04db and is only there once the payload has
    relocated itself, so the machine has to boot to reach it. Rate codes run
    fastest-first: the setter stores 0x0c - code at [d1db], and the setup menu
    at c0570 labels those display indices (5 is "4800 bps", 6 "9600", ...).
    """
    from courier_emu.isdn import IsdnMachine
    from courier_emu.nac import NacImage
    from courier_emu.sio import (
        UART_CLOCK_HIGH_RATES_HZ,
        UART_CLOCK_LOW_RATES_HZ,
    )

    machine = IsdnMachine(NacImage.load("Ie030002.nac"), with_dsp=True)
    try:
        machine.run(6_000_000)
        raw = bytes(machine.machine.mem_read(0xC774 * 16 + 0x4DB, 11 * 2))
    finally:
        machine.mailbox.close()

    divisors = [int.from_bytes(raw[i:i + 2], "little") for i in range(0, len(raw), 2)]
    # code -> the rate its menu index names, fastest first.
    rates = [230400, 115200, 57600, 38400, 19200, 9600, 4800, 2400, 1200, 600, 300]
    clocks = [UART_CLOCK_HIGH_RATES_HZ] * 4 + [UART_CLOCK_LOW_RATES_HZ] * 7

    for rate, clock, divisor in zip(rates, clocks, divisors):
        assert round(clock / (16 * rate)) == divisor, (
            f"{rate} baud: the firmware holds divisor {divisor}, but "
            f"{clock} Hz wants {clock / (16 * rate):.4f}"
        )
    # And the two groups are genuinely distinct: neither clock explains both.
    assert round(UART_CLOCK_HIGH_RATES_HZ / (16 * 9600)) != divisors[5]
    assert round(UART_CLOCK_LOW_RATES_HZ / (16 * 38400)) != divisors[3]


def test_ati7_names_the_product_type_bits_the_way_the_table_maps_them():
    """Check PRODUCT_TYPE_MODES against ATI7's own string table.

    The formatter at c0be0 selects a string offset by testing [d2c3] bit 1,
    then bit 3, then bit 2, with a fallback. Those offsets point into a run of
    consecutive NUL-terminated strings, so reading them back names each bit
    from the firmware rather than from a comment.
    """
    from courier_emu.isdn import PRODUCT_TYPE_MODES
    from courier_emu.isdn import IsdnMachine
    from courier_emu.nac import NacImage

    machine = IsdnMachine(NacImage.load("Ie030002.nac"), with_dsp=True)
    try:
        machine.run(6_000_000)
        # The fallback offset 0x3d8a points at the first of the strings.
        base = 0xC0C2A - 0x3D8A
        read = lambda off: bytes(
            machine.machine.mem_read(base + off, 16)
        ).split(b"\x00")[0].decode("ascii")
    finally:
        machine.mailbox.close()

    assert read(0x3D95) == "External"
    assert read(0x3D9E) == "Internal"
    assert read(0x3DA7) == "Rackmount"
    assert read(0x3D8A).strip() == "Undefined"

    assert PRODUCT_TYPE_MODES["external"] == 0x02
    assert PRODUCT_TYPE_MODES["internal"] == 0x08
    assert PRODUCT_TYPE_MODES["rackmount"] == 0x04
    assert PRODUCT_TYPE_MODES["undefined"] == 0x00
