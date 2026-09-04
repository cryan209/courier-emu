"""Read the DSP's program space through the datapump's own table reader.

The C52's mask ROM below word 8000 is the one part of this modem still
unrecovered, and the routes to it all needed something the hardware does not
offer: the ATGLK2 monitor cannot write memory, so a probe kernel cannot be
placed, and the DSP's reset line is a CPU port pin rather than an I/O port.

The datapump already in the DSP contains a reader that needs none of that.
At word 8151 it takes an index in the accumulator, computes a program address
as `8151_TABLE + 5 * index`, table-reads five consecutive program words, and
sends four of them out to I/O ports 68, 69, 6b and 6c. Because 5 is invertible
modulo 65536, some index reaches every address in the 16-bit program space -
including the mask ROM. One of its nine callers loads that index from a data
cell rather than an immediate, and the runtime mailbox writes data memory.

What this proves is the arithmetic and the reader: against a known fixture in
the on-chip ROM, an address chosen by a data cell comes back on the ports.
What it does not prove is any of the hardware questions - that the mailbox
really writes data memory on a board, that the CPU can read those DSP ports,
that the call site is reachable with a controlled data page, or that the C5x
ROM protection option permits a table read of on-chip ROM by code executing
from external memory. The stub below stands in for the reachability question
by entering the reader with a data page whose cell this test can write.
"""
from pathlib import Path
import struct

import pytest

from courier_emu.rom import CourierRom

CAPTURE_ROM = Path("artifacts/courier-board-21210-capture-01/courier-board.rom")
pytest.importorskip("courier_emu.dsp")

READER = 0x8151
# 5 * 52429 == 1 (mod 65536), so an index exists for every program address.
STRIDE, STRIDE_INVERSE = 5, 52429
ROM_WORDS = 0x1000
# The data page the stub selects, chosen so the reader's own scratch at 7d..7f
# and the index cell at 5b all land in on-chip data RAM rather than the
# memory-mapped registers that occupy data addresses below 0x60.
PAGE = 2
INDEX_CELL = PAGE * 128 + 0x5B
PORTS = (0x68, 0x69, 0x6B, 0x6C)


def payload_words(rom: CourierRom) -> list[int]:
    download = rom.dsp_download
    body = rom.data[download.offset : download.end]
    return list(struct.unpack("<%dH" % (len(body) // 2), body))


@pytest.mark.skipif(not CAPTURE_ROM.exists(), reason="board ROM capture not present")
def test_the_datapump_reader_has_the_expected_shape() -> None:
    """The reader is identified by its instructions, not by its address alone."""
    words = payload_words(CourierRom.load(CAPTURE_ROM))
    base = 0x8000
    assert words[READER - base] == 0x907D            # sacl  @7d
    assert words[READER + 1 - base] == 0x227D        # add   @7d, 2   -> index * 5
    assert words[READER + 2 - base] == 0xBF90        # add   #table
    assert words[READER + 4 - base] == 0xA67D        # tblr  @7d
    assert words[READER + 6 - base] == 0xA67E        # tblr  @7e
    # The four sends that carry the words back out.
    for offset, opcode, port in (
        (7, 0x0C7D, 0x68),   # out @7d, 0068
        (9, 0x0C7E, 0x69),   # out @7e, 0069
        (15, 0x0C7D, 0x6B),  # out @7d, 006b
        (17, 0x0C7E, 0x6C),  # out @7e, 006c
    ):
        assert words[READER + offset - base] == opcode
        assert words[READER + offset + 1 - base] == port


@pytest.mark.skipif(not CAPTURE_ROM.exists(), reason="board ROM capture not present")
@pytest.mark.parametrize("target", (0x0000, 0x0100, 0x0400, 0x0ABC, 0x0FFB))
def test_an_arbitrary_program_address_reads_back_through_the_ports(target: int) -> None:
    from courier_emu.dsp import NativeC5x

    rom = CourierRom.load(CAPTURE_ROM)
    table = payload_words(rom)[READER + 3 - 0x8000]

    core = NativeC5x(rom)
    try:
        fixture = [(address ^ 0x5A5A) & 0xFFFF for address in range(ROM_WORDS)]
        # ldp #page; lacl @5b; call reader; b self
        stub = [0xBC00 | PAGE, 0x6900 | 0x5B, 0x7A80, READER, 0x7980, 0x0004]
        fixture[: len(stub)] = stub
        core.load_rom(b"".join(struct.pack("<H", word) for word in fixture), 0)
        core.set_mpmc_pin(0)

        index = ((target - table) * STRIDE_INVERSE) & 0xFFFF
        assert (table + STRIDE * index) & 0xFFFF == target
        core.set_data(INDEX_CELL, index)
        core.set_pc(0)
        core.step(60)

        assert [core.io(port) for port in PORTS] == fixture[target : target + 4]
    finally:
        core.close()
