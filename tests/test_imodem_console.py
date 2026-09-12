"""The I-modem's AT interface, driven end to end through SIO0.

This is the whole path at once: VRTX startup, the command task, the serial
ISR at 0xb2aa2 reached over IRQ3, and the firmware's own banner coming back
out of the transmit holding register.
"""
from pathlib import Path

import pytest

from courier_emu.isdn import (
    IsdnMachine,
    PRODUCT_TYPE_MODES,
)
from courier_emu.isdn_console import scripted_pump
from courier_emu.nac import NacImage

IMAGE = Path("Ie030002.nac")
# A command answers well inside one default command interval.
BANNER_INSTRUCTIONS = 25_000_000


@pytest.fixture(scope="module")
def session():
    if not IMAGE.exists():
        pytest.skip("local I-modem firmware not available")
    transcript: list[tuple[int, str, str]] = []
    pump = scripted_pump(["ATI3"], transcript=transcript)
    machine = IsdnMachine(NacImage.load(IMAGE), serial_pump=pump)
    result = machine.run(BANNER_INSTRUCTIONS)
    return machine, result, transcript


def received(transcript):
    return "".join(text for _, direction, text in transcript
                   if direction == "received")


class PumpMachine:
    """The small host-side interface scripted_pump needs."""

    def __init__(self):
        self.instructions = 0
        self.output = bytearray()
        self.sent = []

    def send_serial(self, data):
        self.sent.append(bytes(byte & 0x7f for byte in data))

    def take_serial(self):
        data = bytes(self.output)
        self.output.clear()
        return data


def test_scripted_commands_wait_for_the_previous_final_result_code():
    machine = PumpMachine()
    pump = scripted_pump(["AT&W", "ATI12"], after=100, every=20)

    machine.instructions = 100
    pump(machine)
    assert machine.sent == [b"AT&W\r"]

    # Passing the old absolute deadline is not enough while AT&W is busy.
    machine.instructions = 1_000
    machine.output.extend(b"\r\nwriting flash...")
    pump(machine)
    assert machine.sent == [b"AT&W\r"]

    # Fragmented output is normal: only a complete final result-code line
    # releases the next command.
    machine.output.extend(b"\r\nO")
    pump(machine)
    assert machine.sent == [b"AT&W\r"]
    machine.output.extend(b"K\r")
    pump(machine)
    assert machine.sent == [b"AT&W\r"]
    machine.output.extend(b"\n")
    pump(machine)
    assert machine.sent == [b"AT&W\r", b"ATI12\r"]


def test_scripted_commands_still_honour_the_minimum_interval():
    machine = PumpMachine()
    pump = scripted_pump(["AT", "ATI3"], after=100, every=50)
    machine.instructions = 100
    pump(machine)
    machine.instructions = 120
    machine.output.extend(b"\r\nOK\r\n")
    pump(machine)
    assert machine.sent == [b"AT\r"]
    machine.instructions = 150
    pump(machine)
    assert machine.sent == [b"AT\r", b"ATI3\r"]


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
    assert channel.received == len("ATI3\r")
    assert channel.transmitted > 0
    assert result.serial["a"]["overruns"] == 0


def test_the_banner_is_transmitted_with_bit_seven_set(session):
    machine, _, _ = session
    raw = bytes(machine.channels[0xF8F8].tx)
    assert b"USRobotics" not in raw, "the firmware marks the eighth bit"
    assert b"USRobotics" in bytes(byte & 0x7F for byte in raw)


def test_ati2_text_and_final_result_both_answer_ok():
    if not IMAGE.exists():
        pytest.skip("local I-modem firmware not available")
    transcript: list[tuple[int, str, str]] = []
    pump = scripted_pump(["ATI2"], transcript=transcript)
    machine = IsdnMachine(NacImage.load(IMAGE), serial_pump=pump)
    machine.run(BANNER_INSTRUCTIONS)
    typed = max(count for count, direction, _ in transcript
                if direction == "sent")
    answer = "".join(text for count, direction, text in transcript
                     if direction == "received" and count > typed)
    # ATI2 prints its own checksum-test OK, then the ordinary command
    # epilogue emits a second OK result code.
    assert answer == "\r\nOK\r\n\r\nOK\r\n"


def test_consecutive_commands_do_not_replay_stale_responses():
    if not IMAGE.exists():
        pytest.skip("local I-modem firmware not available")
    transcript: list[tuple[int, str, str]] = []
    pump = scripted_pump(["ATI3", "ATI4"], transcript=transcript)
    machine = IsdnMachine(NacImage.load(IMAGE), serial_pump=pump)
    machine.run(65_000_000)

    answer = received(transcript)
    # ATI3 is the first banner; ATI4 includes the same product heading before
    # its settings.  A third copy would be the stale firmware replay.
    assert answer.count("USRobotics Courier I-Modem with ISDN/V.34") == 2
    assert "USRobotics Courier I-Modem with ISDN/V.34 Settings..." in answer
    assert "S00=000" in answer
    assert [text for _, direction, text in transcript if direction == "sent"] == [
        "ATI3\r", "ATI4\r",
    ]


def test_attention_prefix_resets_each_new_external_command():
    if not IMAGE.exists():
        pytest.skip("local I-modem firmware not available")
    transcript: list[tuple[int, str, str]] = []
    commands = ["AT", "ATI", "ATI6", "ATY11", "AT"]
    pump = scripted_pump(commands, transcript=transcript)
    machine = IsdnMachine(NacImage.load(IMAGE), serial_pump=pump, profile=False)
    machine.run(105_000_000)

    answer = received(transcript)
    assert answer.count("\r\nOK\r\n") == len(commands)
    assert answer.count("USR009F") == 1
    assert answer.count("Link Diagnostics") == 1
    assert answer.count("Freq") == 1
    assert "NO CARRIER" not in answer
    assert [text for _, direction, text in transcript if direction == "sent"] == [
        command + "\r" for command in commands
    ]


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


def test_the_capability_record_maps_d2c7_onto_the_options_byte():
    """The five (test, set) pairs at a400:04ac, read out of the firmware.

    a4476 walks this table with `lodsw`, testing [d2c7] with the low byte and
    OR-ing the high byte into the options byte at e358. Replaced a test that
    asserted a constant the harness used to force and which the firmware
    overwrites anyway.
    """
    if not IMAGE.exists():
        pytest.skip("local I-modem firmware not available")
    machine = IsdnMachine(NacImage.load(IMAGE), with_dsp=True)
    try:
        machine.run(6_000_000)
        table = bytes(machine.machine.mem_read(0xA44AC, 10))
    finally:
        machine.mailbox.close()
    pairs = [(table[i], table[i + 1]) for i in range(0, 10, 2)]
    assert pairs == [(0x01, 0x04), (0x02, 0x08), (0x04, 0x40),
                     (0x08, 0x80), (0x10, 0x20)]


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


def test_the_firmware_accepts_a_capability_record_this_repo_builds():
    """The firmware's own loader is the check, not our CRC arithmetic.

    A record built by tools/imodem_capability_record.py has to validate at
    0xc53fd, be preferred at 0xc5387, keep the blank path at 0xc5312 from
    running, and land its bytes at 2600:d2c6 -- where d2c9 is copied on to
    d2c5. Without a record that whole 4 KiB reads 0xff and d2c5 stays 0, which
    is the chain behind every command answering NO CARRIER.
    """
    if not IMAGE.exists():
        pytest.skip("local I-modem firmware not available")
    import importlib.util

    spec = importlib.util.spec_from_file_location(
        "imodem_capability_record",
        Path(__file__).resolve().parent.parent / "tools"
        / "imodem_capability_record.py",
    )
    builder = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(builder)

    # d2c6 bit 2 clear is what lets d2c9 through; 0x5a is just a value no
    # other path would leave lying there.
    sector = builder.build({0x000: 0xFB, 0x003: 0x5A}, version=0x1234)

    SEG = 0x2600 * 16
    results = {}
    for label, overlay in (("absent", None), ("present", (0xF8000, sector))):
        machine = IsdnMachine(NacImage.load(IMAGE), with_dsp=True,
                              flash_overlay=overlay)
        try:
            machine.run(20_000_000)
            results[label] = (
                machine.machine.mem_read(SEG + 0xD2C6, 1)[0],
                machine.machine.mem_read(SEG + 0xD2C9, 1)[0],
                machine.machine.mem_read(SEG + 0xD2C5, 1)[0],
                machine.pc_counts.get(0xC5312, 0),   # the blank path
            )
        finally:
            machine.mailbox.close()

    d2c6, d2c9, d2c5, blanked = results["absent"]
    assert (d2c6, d2c9, d2c5) == (0xFF, 0xFF, 0x00), "no record: the shadow is erased"
    assert blanked > 0, "no record: the blank path runs"

    d2c6, d2c9, d2c5, blanked = results["present"]
    assert d2c6 == 0xFB, "the record's own bytes reached the shadow"
    assert d2c9 == 0x5A
    assert d2c5 == 0x5A, "d2c9 is copied on to d2c5 once bit 2 of d2c6 is clear"
    assert blanked == 0, "a valid record means the blank path never runs"
