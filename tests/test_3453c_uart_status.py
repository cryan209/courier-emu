"""The payload's synchronous DTE transmitter reports empty to every caller."""

from dataclasses import replace
from pathlib import Path

import pytest

from courier_emu.machine import CourierMachine
from courier_emu.xmf import XmfImage


@pytest.mark.parametrize("size", [1, 2])
@pytest.mark.parametrize("status", [0, 0xA501])
def test_uart_empty_status_at_arbitrary_guest_pc(size, status):
    image = XmfImage.load(Path(__file__).resolve().parents[1] / "2_3_33.XMF")
    # Run away from the printf and dialer polling addresses. Seed the status
    # register, read it through guest MMIO, and store the observed value in RAM.
    code = bytes.fromhex("fa c70666ff") + status.to_bytes(2, "little")
    code += bytes.fromhex("a066ff a20020" if size == 1 else "a166ff a30020")
    code += b"\xf4"
    start = image.supervisor_offset + 0x10
    data = bytearray(image.data)
    data[start:start + len(code)] = code
    machine = CourierMachine(
        replace(image, data=bytes(data), entry_offset_value=0x10),
        cpu_engine="interpreter",
    )
    machine.run(32)
    observed = int.from_bytes(machine.uc.mem_read(0x2000, size), "little")
    assert observed == (status | 8) & ((1 << (8 * size)) - 1)
