"""The serial callback table is located in the image, not assumed."""
from pathlib import Path

import pytest

from courier_emu.machine import serial_callback_table

ROOT = Path(__file__).resolve().parent.parent

# Every XMF supervisor keeps the table at 02a8, which is the address the
# harness used to hardcode. IDSDL302 keeps it at 026a, and reading 02a8 there
# reported a working front end as `final callbacks=0000`.
KNOWN = {
    "main211.xmf": 0x02A8,
    "main2205.XMF": 0x02A8,
    "2_3_33.XMF": 0x02A8,
    "IDSDL302.ROM": 0x026A,
}


@pytest.mark.parametrize("name,base", sorted(KNOWN.items()))
def test_the_table_is_found_where_the_image_keeps_it(name, base):
    image = ROOT / name
    if not image.exists():
        pytest.skip(f"{name} not present")
    assert serial_callback_table(image.read_bytes()) == base


def test_the_rom_table_is_the_one_the_firmware_installs_into():
    # 026a holds 9a06 after a ROM run, and b013186 already gated on that pair.
    image = ROOT / "IDSDL302.ROM"
    if not image.exists():
        pytest.skip("IDSDL302.ROM not present")
    data = image.read_bytes()
    base = serial_callback_table(data)
    assert base != 0x02A8
    assert data.count(b"\xc7\x06" + base.to_bytes(2, "little")) > 10


def test_an_image_with_no_table_reports_none():
    assert serial_callback_table(b"\x00" * 4096) is None


def test_the_firmware_installs_its_own_receive_callback():
    """No stand-in: 2.1.1 reaches its own installer and writes acdf itself.

    The installer at 5c86e branches on [0652] bit 2, which 5e375 sets from the
    DTE DTR input - latch selector 3, mask 0x40, port 0x12. That input used to
    be modelled only for ROM images, so an XMF run sampled DTR de-asserted,
    took the no-terminal branch, and installed the empty callback 1fce; the
    harness then wrote acdf in over the top.
    """
    from courier_emu.images import load_image
    from courier_emu.machine import CourierMachine

    image = ROOT / "main211.xmf"
    if not image.exists():
        pytest.skip("main211.xmf not present")
    machine = CourierMachine(load_image(image), serial_input=b"ATI\r")
    result = machine.run(4_000_000)

    assert machine.executed.get(0x5C870) == 1   # mov [02a8], acdf
    assert not machine.executed.get(0x5C88A)    # mov [02a8], 1fce
    assert machine.executed.get(0x5E383) == 1   # and [0652], fb - a DTE is here
    assert not machine.executed.get(0x5E38F)    # or  [0652], 04 - none is
    assert not [line for line in result.serial_trace
                if line.startswith("callback 2a8=")]
    assert result.serial_text == "\r\n3368\r\n\r\nOK\r\n"
