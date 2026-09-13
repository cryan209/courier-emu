"""Native mailbox tests using the unmodified I-modem resident and synthetic input."""
from pathlib import Path
import struct

import pytest

from courier_emu.imodem_dsp import ImodemDsp
from courier_emu.xmp import XmpImage


@pytest.fixture
def dsp():
    path = Path('Ie030002.xmp')
    if not path.exists():
        pytest.skip('local I-modem firmware not available')
    image = XmpImage.load(path)
    resident = image.payload[0xa8690:0xaab0c]
    endpoint = ImodemDsp()
    # Exercise both alternating bootstrap windows and the checksum strobe.
    endpoint.write(0x40, 0)
    endpoint.write(0x42, 0x80)
    endpoint.write(0x18, 0xff)
    resident += bytes((-len(resident)) % 16)
    for index in range(0, len(resident), 8):
        group = (index // 8) % 2
        base = 0x40 + 16*group
        for lane, value in enumerate(resident[index:index+8]):
            endpoint.write(base + 2*lane, value)
        endpoint.write(0x18, 1 << group)
        assert endpoint.read(0x18) & 3 == 3
    endpoint.write(0x18, 4)
    assert endpoint.read(0x1c) == 0xff
    endpoint.write(0x1c, 2)
    try:
        yield endpoint
    finally:
        endpoint.close()


def test_real_dispatcher_consumes_host_word_and_applies_command(dsp):
    assert dsp.bootstrap_words == 4672
    assert dsp.read(0x1c) & 1
    # Command 19h is the resident's SMMR @7a, #03ad; RET handler.
    for port, value in zip(dsp.LANES, (0x19, 0, 0x34, 0x12)):
        dsp.write(port, value)
    dsp.write(0x1c, 1)
    assert not dsp.read(0x1c) & 1
    for _ in range(100):
        dsp.step(256)
        if dsp.consumed:
            break
    assert dsp.consumed == 1
    assert dsp.core.data(0x3ad) == 0x1234
    assert dsp.read(0x1c) & 1
    stats = dsp.core.io_port_stats([0x5e, 0x5f])
    assert stats['0x5e']['last_read_pc'] == 0x85ca
    assert stats['0x5f']['last_read_pc'] == 0x85cc


def test_real_sender_holds_reply_until_cpu_acknowledges(dsp):
    # Seed the resident's outgoing ring, not the endpoint's output latches.
    # The original sender must emit this synthetic test message itself.
    core = dsp.core
    pointer = core.data(0x79)
    core.set_data(pointer, 0x8031)
    core.set_data(pointer + 1, 0xbeef)
    core.set_data(0x78, pointer + 2)
    for _ in range(100):
        dsp.step(256)
        if dsp.rx is not None:
            break
    assert dsp.rx == (0x31, 0xbeef)
    assert dsp.read(0x1c) & 2
    assert [dsp.read(port) for port in dsp.LANES] == [0x31, 0, 0xef, 0xbe]
    assert not core.io(0x57) & 2
    dsp.step(1024)
    assert dsp.rx == (0x31, 0xbeef)
    dsp.write(0x1c, 2)
    assert core.io(0x57) & 2
    assert dsp.rx is None
    assert dsp.replies_acked == 1
    dsp.step(1024)
    assert not dsp.read(0x1c) & 2


def test_mailbox_output_view_is_independent_without_analog_codec():
    from courier_emu.dsp import NativeC5x
    # SPLK @7d,#1234; OUT @7d,005e; IDLE. No proprietary image needed.
    program = struct.pack('<5H', 0xae7d, 0x1234, 0x0c7d, 0x005e, 0xbe22)
    with NativeC5x.from_program(0x8000, program) as core:
        core.configure_host_mailbox()
        core.set_io(0x5e, 0xabcd)
        core.set_pc(0x8000)
        core.step(3)
        assert core.io(0x5e) == 0xabcd
        assert core.io_output(0x5e) == 0x1234


def test_live_digital_pcm_is_paced_from_wall_clock():
    from courier_emu.dsp import NativeC5x

    # IDLE is enough: the digital PCM peripheral is an external clock master
    # and emits the current DXR word at every frame even with its IRQ masked.
    program = struct.pack('<H', 0xbe22)
    endpoint = ImodemDsp()
    endpoint.core = NativeC5x.from_program(0x8000, program)
    try:
        endpoint.core.configure_host_mailbox()
        endpoint.core.configure_digital_pcm(idle_codeword=0xff)
        endpoint.core.configure_line_frame_interrupt(5, 0xffff)
        endpoint.core.set_pc(0x8000)

        endpoint.pace_realtime(True, now=10.0)
        endpoint.pace_realtime(True, now=10.1)
        frames = len(endpoint.core.g711_tx()) // 2

        assert 799 <= frames <= 801
        assert endpoint.realtime_cycles >= 2_015_000

        # Repeating a timestamp must not invent another block of bearer time.
        endpoint.pace_realtime(True, now=10.1)
        assert len(endpoint.core.g711_tx()) // 2 == frames

        # Leaving and re-entering a call establishes a fresh epoch rather than
        # catching up time spent with no live bearer.
        endpoint.pace_realtime(False, now=20.0)
        endpoint.pace_realtime(True, now=30.0)
        assert len(endpoint.core.g711_tx()) // 2 == frames
    finally:
        endpoint.close()
