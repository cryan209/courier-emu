"""Exercise both clocks through guest ISR entry, EOI and IRET."""
from dataclasses import replace
from pathlib import Path

import pytest

from courier_emu.machine import CourierMachine
from courier_emu.xmf import XmfImage


@pytest.mark.parametrize("mask, ticks_enabled", [(0x6E, True), (0xEE, False)])
def test_3453c_eb_tick_mask_and_mailbox_isr_return(mask, ticks_enabled):
    image = XmfImage.load(Path(__file__).resolve().parents[1] / "2_3_33.XMF")
    data = bytearray(image.data)
    # Install mailbox vector 0c -> 6770:0000 and tick vector 0f -> 4000:0100.
    code = bytes.fromhex("fa c70630000000 c70632007067 c7063c000001 c7063e000040 c70608ff")
    code += mask.to_bytes(2, "little") + bytes.fromhex("fb ebfe")
    start = image.supervisor_offset + 0x10
    data[start:start + len(code)] = code
    # Increment independent counters. End the mailbox handler at the real
    # firmware's IRET address, so subsequent board ticks must be unblocked.
    mailbox = bytes.fromhex("fe060020 c70602ff0080 e9e400")
    data[0x27700:0x27700 + len(mailbox)] = mailbox
    data[0x277F1] = 0xCF
    tick = bytes.fromhex("fe060120 c70602ff0080 cf")
    data[0x100:0x100 + len(tick)] = tick
    machine = CourierMachine(replace(image, data=bytes(data), entry_offset_value=0x10),
                             tick_ms=1, pc_watch={0x40100: "tick"})
    machine._serial_started = True
    machine.run(50_000)
    assert machine.timer_interrupts > 2
    assert bytes(machine.uc.mem_read(0x2000, 1))[0] > 2
    if ticks_enabled:
        assert machine.ticks > 2
        assert bytes(machine.uc.mem_read(0x2001, 1))[0] > 2
    else:
        assert machine.ticks == 0
        assert bytes(machine.uc.mem_read(0x2001, 1)) == b"\x00"
