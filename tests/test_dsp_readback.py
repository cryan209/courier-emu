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
cell rather than an immediate.

Getting a host-chosen index into that cell is the open problem. The mailbox
does not do it: hardware and `test_mailbox_protocol.py` establish that a tag is
a command index into a jump table, and none of the 27 handlers that store the
host's word targets an index cell either reader uses.

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

# The e732 loop, the second of the two readers. Its index and result cells both
# sit at data page 7 in ordinary RAM, and its program address is unscaled.
LOOP_READER = 0xE732
LOOP_BASE = 0xE870
LOOP_PAGE = 7
LOOP_INDEX_CELL = LOOP_PAGE * 128 + 0x66   # 03e6
LOOP_RESULT_CELL = LOOP_PAGE * 128 + 0x50  # 03d0


@pytest.mark.skipif(not CAPTURE_ROM.exists(), reason="board ROM capture not present")
def test_the_loop_reader_has_the_expected_shape() -> None:
    words = payload_words(CourierRom.load(CAPTURE_ROM))
    base = 0x8000
    assert words[LOOP_READER - base] == 0x6966          # lacl @66
    assert words[LOOP_READER + 1 - base] == 0xBF90      # add  #long
    assert words[LOOP_READER + 2 - base] == LOOP_BASE   #      e870
    assert words[LOOP_READER + 3 - base] == 0xA650      # tblr @50


@pytest.mark.skipif(not CAPTURE_ROM.exists(), reason="board ROM capture not present")
@pytest.mark.parametrize("target", (0x0000, 0x0100, 0x0800, 0x0EEE, 0x0FFF))
def test_the_loop_reader_fetches_a_chosen_program_word(target: int) -> None:
    """One entry of the loop reads the address its index cell selects.

    The loop is entered at the read itself rather than at the initialiser
    above it, which is what a host write to the index cell would have to
    achieve: the initialiser sets the index to zero and each iteration
    increments it, so a supplied value only survives for one read. That
    timing is the open question this cannot settle - what it settles is that
    the address is the cell's to choose, across the bank and unscaled.
    """
    from courier_emu.dsp import NativeC5x

    rom = CourierRom.load(CAPTURE_ROM)
    core = NativeC5x(rom)
    try:
        fixture = [(address ^ 0x5A5A) & 0xFFFF for address in range(ROM_WORDS)]
        # ldp #7 ; b e732
        fixture[:3] = [0xBC00 | LOOP_PAGE, 0x7980, LOOP_READER]
        core.load_rom(b"".join(struct.pack("<H", word) for word in fixture), 0)
        core.set_mpmc_pin(0)

        core.set_data(LOOP_INDEX_CELL, (target - LOOP_BASE) & 0xFFFF)
        core.set_pc(0)
        core.step(6)

        assert core.data(LOOP_RESULT_CELL) == fixture[target]
    finally:
        core.close()

SEND_SITE = 0xB4F5          # lacc #8021 ; call 83c8 ; lacl @50 ; call 83c8
SEND_TAG = 0x8021
QUEUE = 0x0BD0              # the sixteen-word ring, the base 83ca loads into ar0
QUEUE_POINTER = 0x78        # its write pointer, at data page 0


def test_the_core_round_trips_a_status_word() -> None:
    """`sst st0` then `lst st0` must restore the data page it saved.

    The core holds the page pre-shifted, as LDP stores it and the address
    decode uses it, so packing it into the status word needs a shift back out
    and unpacking needs one in. Neither was applied, and the two errors did
    not cancel: saving page 7 restored page 3. Every firmware path through a
    routine that preserves its caller's status - the mailbox enqueue at 83c8
    among them - was silently landing on the wrong data page afterwards.
    """
    from courier_emu.dsp import NativeC5x

    rom = CourierRom.load(CAPTURE_ROM)
    core = NativeC5x(rom)
    try:
        page = 7
        # ldp #7 ; sst st0, @7d ; ldp #0 ; lst st0, @7d ; b self
        program = [0xBC00 | page, 0x8E7D, 0xBC00, 0x0E7D, 0x7980, 0x0004]
        image = [0] * ROM_WORDS
        image[: len(program)] = program
        core.load_rom(b"".join(struct.pack("<H", word) for word in image), 0)
        core.set_mpmc_pin(0)
        core.set_pc(0)
        core.step(2)
        saved = core.state()["dp"]
        assert saved == page * 128
        core.step(3)
        assert core.state()["dp"] == saved
    finally:
        core.close()


@pytest.mark.skipif(not CAPTURE_ROM.exists(), reason="board ROM capture not present")
@pytest.mark.parametrize("target", (0x0100, 0x0800, 0x0ABC))
def test_a_read_word_reaches_the_mailbox_queue(target: int) -> None:
    """The whole resident path: index in, program word out through the queue.

    Both halves are the firmware's own. The stub only selects the data page
    and calls the send site, which is what reaching it in normal flow would
    do; it supplies no value and copies nothing.
    """
    from courier_emu.dsp import NativeC5x

    rom = CourierRom.load(CAPTURE_ROM)
    core = NativeC5x(rom)
    try:
        fixture = [(address ^ 0x5A5A) & 0xFFFF for address in range(ROM_WORDS)]
        core.set_mpmc_pin(0)

        # ldp #7 ; b e732
        fixture[:3] = [0xBC00 | LOOP_PAGE, 0x7980, LOOP_READER]
        core.load_rom(b"".join(struct.pack("<H", w) for w in fixture), 0)
        core.set_data(LOOP_INDEX_CELL, (target - LOOP_BASE) & 0xFFFF)
        core.set_pc(0)
        core.step(6)
        assert core.data(LOOP_RESULT_CELL) == fixture[target]

        # ldp #7 ; mar *, ar1 ; call b4f5 ; b self
        fixture[:6] = [0xBC00 | LOOP_PAGE, 0x8B89, 0x7A80, SEND_SITE, 0x7980, 0x0005]
        core.load_rom(b"".join(struct.pack("<H", w) for w in fixture), 0)
        for cell in range(QUEUE, QUEUE + 16):
            core.set_data(cell, 0)
        core.set_data(QUEUE_POINTER, QUEUE)
        core.set_pc(0)
        core.step(120)

        assert core.data(QUEUE) == SEND_TAG
        assert core.data(QUEUE + 1) == fixture[target]
    finally:
        core.close()
