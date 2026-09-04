"""Pin the supervisor's half of the CPU/DSP mailbox against the captured board.

The DSP-side read-and-report chain is established in `test_dsp_readback.py`:
an index written to DSP data `03e6` becomes a program word in `03d0`, and the
send site at `b4f5` pushes it to the host queue. Driving that chain from a
serial session needs the other half - what the *supervisor* does with those
ports - and a first hardware attempt (`artifacts/dsp-mailbox-write-01/`) wrote
the four data registers with no handshake and observed nothing.

Everything asserted here is read out of the captured image and out of the
captured RAM's interrupt vector table, so a different firmware fails these
tests rather than silently exercising nothing.
"""
from pathlib import Path
import struct

import pytest

CAPTURE = Path("artifacts/courier-board-21210-capture-01/courier-board.rom")
RAM = Path("artifacts/courier-board-21210-ram-01/ram-pass1.bin")

# The mailbox interrupt is vector 0x0c, and the captured RAM points it at
# 8f43:0000.  Every near offset the supervisor stores in the receive vector
# [0x298] is relative to that segment, which is this file offset.
MAILBOX_VECTOR = 0x0C
HANDLER_SEGMENT_OFFSET = 0x0F430

ISR = 0x0FDA9               # sti ; pushaw ; push es ; ...
ISR_STATUS_READ = 0x0FDB0   # in 1e -> ah, in 1c -> al, and ax,7, [0x285] := ax
ISR_NOTHING_TO_SEND = 0x0FDF5   # and word ptr [0x285], 0xfffe
ISR_SEND = 0x0FDDB          # out 58/5a/5c/5e
ISR_ACKNOWLEDGE = 0x0FE17   # mov ax,[0x285] ; out 1c,al ; out 1e,ah
ISR_RECEIVE = 0x0FD9C       # in 5a -> ah, in 58 -> al, clc, call [0x298]

DISPATCHER = 0x0F78A
COMMAND_MODE_INSTALL = 0x0F842   # mov word ptr [0x298], 0x443
COMMAND_MODE_HANDLER = 0x0F873   # ... which lands here
COMMAND_MODE_TABLE = 0x0F852
COMMAND_MODE_TAGS = 11
# The tag the DSP's resident report at b4f5 carries, after the sender at 83e8
# masks bit 15 off.  The dispatcher matches on this byte.
RESIDENT_REPORT_TAG = 0x8021 & 0x00FF

# The DSP side. flash 29080 is DSP program word 8000, little-endian.
DSP_LOAD_BASE, DSP_ENTRY = 0x29080, 0x8000
DSP_RECEIVE = 0x839B        # the host-command dispatcher
DISPATCH_TABLE = 0x8401     # program word 8401 + tag, tags 00..78
IGNORE_STUB = 0x8222

pytestmark = pytest.mark.skipif(
    not CAPTURE.exists(), reason="board ROM capture not present"
)


@pytest.fixture(scope="module")
def rom() -> bytes:
    return CAPTURE.read_bytes()


def at(rom: bytes, offset: int, hexed: str) -> None:
    expected = bytes.fromhex(hexed)
    assert rom[offset : offset + len(expected)] == expected, f"{offset:05x}"


def test_the_mailbox_interrupt_vector_fixes_the_handler_segment() -> None:
    """The receive vector holds near offsets; the IVT says what they are near."""
    if not RAM.exists():
        pytest.skip("board RAM capture not present")
    offset, segment = struct.unpack_from("<HH", RAM.read_bytes(), MAILBOX_VECTOR * 4)
    assert ((segment << 4) + offset) - 0x80000 == HANDLER_SEGMENT_OFFSET


def test_the_supervisor_reads_its_mailbox_status_from_1c_and_1e(rom: bytes) -> None:
    at(rom, ISR, "fb60068cd88ec0")                  # sti ; pushaw ; push es ...
    at(rom, ISR_STATUS_READ, "e41e8ae0e41c250700a38502")


def test_an_outbound_word_is_a_tag_on_58_5a_and_data_on_5c_5e(rom: bytes) -> None:
    """The four data registers carry one 16-bit tag and one 16-bit value.

    This is the format `artifacts/dsp-mailbox-write-01/` already used, and it
    is not where that attempt went wrong.
    """
    at(rom, ISR_SEND, "50"          # push ax
                      "8ac4"        # mov al, ah      -> tag byte
                      "25ff00"
                      "e658"        # out 0x58, al
                      "8ac4"
                      "e65a"        # out 0x5a, al    (zero: a one-byte tag)
                      "58"          # pop ax
                      "25ff00"
                      "e65c"        # out 0x5c, al    -> data byte
                      "86c4"
                      "e65e")       # out 0x5e, al    (zero)


def test_the_commit_is_bit_0_written_back_to_1c(rom: bytes) -> None:
    """Bit 0 of the status is a board request, cleared by acknowledging it.

    The interrupt ends by writing the status word it read back out to `1c`
    and `1e`.  On the path that had nothing to send, and only on that path,
    bit 0 is first cleared - so writing the bit back *set* is what says a word
    was placed in the window.  The idle unit reads `1c` as `fd` on every poll
    in `artifacts/dsp-mailbox-write-01/`, bit 0 permanently asserted, which is
    that request standing unanswered because the supervisor never has traffic.

    A host driving these ports over the serial monitor has to supply this
    edge itself; the earlier attempt wrote the four data registers and stopped.
    """
    at(rom, ISR_NOTHING_TO_SEND, "83268502fe")      # and word ptr [0x285], 0xfffe
    at(rom, ISR_ACKNOWLEDGE, "a18502"               # mov ax, word ptr [0x285]
                             "e61c"                 # out 0x1c, al
                             "8ac4"
                             "e61e")                # out 0x1e, ah


def test_an_inbound_word_is_read_back_from_the_same_registers(rom: bytes) -> None:
    at(rom, ISR_RECEIVE, "e45a8ae0e458"             # in 5a -> ah, in 58 -> al
                         "f8"                       # clc
                         "ff169802")                # call word ptr [0x298]


def test_the_receive_dispatcher_drops_a_tag_it_does_not_know(rom: bytes) -> None:
    """`repne scasb` over a tag list, and a miss returns without storing."""
    at(rom, DISPATCHER, "06"            # push es
                        "8cce8ec6"      # es := cs
                        "8bd742"        # dx := di + 1
                        "f2ae"          # repne scasb  (al is the inbound tag)
                        "7508"          # miss -> pop es ; clc ; ret
                        "2bfad1e7"      # index, scaled to words
                        "07"
                        "2eff21")       # jmp word ptr cs:[bx + di]


def test_command_mode_accepts_eleven_tags_and_the_report_tag_is_not_one(rom: bytes) -> None:
    """So the resident `8021` report is discarded before any handler sees it.

    The words still reach the ASIC's inbound registers, and the handlers that
    want a data word read `5c`/`5e` themselves rather than being handed one.
    A serial reader therefore polls those ports; it must not wait for the
    supervisor to file the answer in RAM, because for this tag it will not.
    """
    at(rom, COMMAND_MODE_INSTALL, "c70698024304")   # [0x298] := 0x443
    assert HANDLER_SEGMENT_OFFSET + 0x443 == COMMAND_MODE_HANDLER
    at(rom, COMMAND_MODE_HANDLER, "720c"            # carry selects the other path
                                  "bb2d04"          # bx := handler words
                                  "b90b00"          # cx := 11
                                  "bf2204"          # di := tag bytes
                                  "e909ff")         # jmp the shared dispatcher
    assert HANDLER_SEGMENT_OFFSET + 0x422 == COMMAND_MODE_TABLE
    assert COMMAND_MODE_TABLE + COMMAND_MODE_TAGS == HANDLER_SEGMENT_OFFSET + 0x42D

    tags = rom[COMMAND_MODE_TABLE : COMMAND_MODE_TABLE + COMMAND_MODE_TAGS]
    assert tags == bytes((0x76, 0x05, 0x06, 0x04, 0x12, 0x13,
                          0x88, 0x89, 0x0D, 0x0E, 0x83))
    assert RESIDENT_REPORT_TAG not in tags

    handlers = struct.unpack_from("<11H", rom, COMMAND_MODE_TABLE + COMMAND_MODE_TAGS)
    assert handlers == (0x0667, 0x0678, 0x0694, 0x08EF, 0x06E6, 0x070D,
                        0x0749, 0x0758, 0x0692, 0x0693, 0x0784)
    # Every one of them resolves inside the segment the vector table pins.
    for handler in handlers:
        assert rom[HANDLER_SEGMENT_OFFSET + handler] != 0xFF


def word(rom: bytes, address: int) -> int:
    """One DSP program word, out of the image the downloader sends verbatim."""
    offset = DSP_LOAD_BASE + 2 * (address - DSP_ENTRY)
    return struct.unpack_from("<H", rom, offset)[0]


def words(rom: bytes, address: int, count: int) -> tuple[int, ...]:
    return tuple(word(rom, address + step) for step in range(count))


def test_the_dsp_reads_host_messages_from_asic_cells_not_data_memory(rom: bytes) -> None:
    """`23f0` is below 8000, so the accessor is in the unrecovered mask ROM.

    The dispatcher polls status cell `ff57`, and only if its low bit is set
    does it fetch the tag from `ff5e` and the value from `ff5f`. Those are
    high data-space cells reached through a mask-ROM helper, not the ordinary
    data memory the native core's `host_write` pokes.
    """
    assert words(rom, DSP_RECEIVE, 10) == (
        0xBC00,                 # ldp   #000
        0xBE41,                 # setc  intm
        0x7E80, 0x23F0,         # calld 23f0
        0xBF09, 0xFF57,         # lar   ar1, #ff57   (delay slot)
        0xBE40,                 # clrc  intm
        0x907D,                 # sacl  @7d
        0x4F7D,                 # bit   15, @7d      (TI numbering: the low bit)
        0xEE00,                 # retc  ntc          -> nothing pending
    )
    assert words(rom, 0x83A8, 2) == (0xBF09, 0xFF5E)    # lar ar1, #ff5e - the tag
    assert words(rom, 0x83AF, 2) == (0xBF09, 0xFF5F)    # lar ar1, #ff5f - the value


def test_a_tag_is_a_command_index_bounded_at_7f(rom: bytes) -> None:
    """`sub #7f ; retc gt ; add #8480 ; tblr ; bacc` - a jump table, not an address.

    This is what refutes reading the tag as a destination in DSP data memory:
    anything above 7f is discarded before it reaches the table at all.
    """
    assert words(rom, 0x83B5, 8) == (
        0x697D,                 # lacl  @7d          (the tag)
        0xBA7F,                 # sub   #7f
        0xEF04,                 # retc  gt           -> tag > 7f is rejected
        0xBF90, 0x8480,         # add   #8480
        0xA67C,                 # tblr  @7c          program[tag + 8401]
        0x107C,                 # lacc  @7c
        0xBE20,                 # bacc
    )
    assert 0x8480 - 0x7F == DISPATCH_TABLE


def test_the_ignore_stub_is_a_bare_ret(rom: bytes) -> None:
    """So those tags are a null control: the board does nothing at all."""
    assert word(rom, IGNORE_STUB) == 0xEF00        # ret
    from courier_emu.dsp_mailbox import NO_OP_TAGS
    for tag in NO_OP_TAGS:
        assert word(rom, DISPATCH_TABLE + tag) == IGNORE_STUB


def test_tag_07_is_a_pure_query_that_reports_8031(rom: bytes) -> None:
    """Three instructions, no writes, no state, and a predictable reply tag.

    The sender at 83e8 masks bit 15 off before the tag reaches the wire, so
    what the CPU's inbound register must show is 31.
    """
    from courier_emu.dsp_mailbox import QUERY_TAG, QUERY_REPLY_TAG

    handler = word(rom, DISPATCH_TABLE + QUERY_TAG)
    assert handler == 0x84CB
    assert words(rom, handler, 6) == (
        0x7E80, 0x83C8,         # calld 83c8            enqueue ...
        0xBF80, 0x8031,         # lacc  #8031           ... this, in the delay slots
        0x7D80, 0x83C8,         # bd    83c8            tail-enqueue ...
    )
    assert words(rom, handler + 6, 2) == (0xBC10, 0x1018)   # ldp #010 ; lacc @18
    assert QUERY_REPLY_TAG == 0x0031
    # The masking that makes it 31 on the wire, in the sender.
    assert words(rom, 0x83E8, 2) == (0xBFB0, 0x7FFF)        # and #00007fff


def test_the_second_query_reports_8069(rom: bytes) -> None:
    from courier_emu.dsp_mailbox import SECOND_QUERY_TAG, SECOND_QUERY_REPLY_TAG
    assert word(rom, DISPATCH_TABLE + SECOND_QUERY_TAG) == 0xC4B4
    assert words(rom, 0xC504, 2) == (0xBF80, 0x8069)
    assert SECOND_QUERY_REPLY_TAG == 0x0069


def test_twelve_tags_are_unimplemented_and_would_branch_into_the_mask_rom(rom: bytes) -> None:
    """Nothing may send these: the table entry is zero, and `bacc` would take
    the DSP to program word 0000, inside the ROM this whole exercise is trying
    to read rather than execute."""
    empty = [tag for tag in range(0x79) if word(rom, DISPATCH_TABLE + tag) == 0]
    assert empty == [0x4C, 0x5B, 0x5C, 0x5D, 0x64, 0x65,
                     0x66, 0x67, 0x68, 0x69, 0x6A, 0x6B]


def test_the_host_write_map_matches_the_dispatch_table(rom: bytes) -> None:
    """Each listed tag's handler really does store `@7a` at the listed address.

    `@7a` is where the dispatcher at 83b2 leaves the host's data word, so a
    handler that stores it is the board's host-write primitive - and there are
    29 fixed destinations, not an arbitrary address.
    """
    from courier_emu.dsp_mailbox import HOST_WRITE_CELLS, SIMPLE_WRITE_TAG

    assert word(rom, 0x83B2) == 0x907A          # sacl @7a - the value word
    for tag, cell in HOST_WRITE_CELLS.items():
        handler = word(rom, DISPATCH_TABLE + tag)
        found = any(
            words(rom, handler + step, 2) == (0x097A, cell)     # smmr @7a, #cell
            for step in range(24)
        )
        assert found, f"tag {tag:02x} -> {handler:04x} does not store at {cell:04x}"

    # The simplest of them: store and return, no range check, no state change.
    assert words(rom, word(rom, DISPATCH_TABLE + SIMPLE_WRITE_TAG), 3) == (
        0x097A, 0x0346, 0xEF00)                 # smmr @7a, #0346 ; ret


def test_neither_read_chain_has_a_host_entry_point(rom: bytes) -> None:
    """The two index cells the document's read chains need are not writable.

    84d3 takes its index from data 03db and e735 from 03e6. Nothing in the
    dispatch table stores the host's word at either, so driving those chains
    from a serial session needs a route this table does not provide.
    """
    from courier_emu.dsp_mailbox import HOST_WRITE_CELLS

    assert 0x03DB not in HOST_WRITE_CELLS.values()
    assert 0x03E6 not in HOST_WRITE_CELLS.values()


def test_03dc_is_an_accumulator_not_an_index(rom: bytes) -> None:
    """Tag 40's destination is one word off the 84d3 reader's index, and useless.

    Two of its three readers bulk-zero a block starting there, and the third
    treats 03dc/03dd as the halves of a 32-bit accumulator. No table read is
    fed by it.
    """
    assert words(rom, 0xDAD9, 4) == (0xBF09, 0x03DC, 0xBB1B, 0x98A0)  # lar;rpt #1b;sach *+
    assert words(rom, 0xEB03, 4) == (0xBF09, 0x03DC, 0xBB0F, 0x98A0)  # lar;rpt #0f;sach *+
    assert words(rom, 0xACDA, 5) == (0xBF09, 0x03DC,
                                     0x6AA0,      # lacc16 *+   high half
                                     0x6290,      # adds   *-   low half
                                     0x6144)      # add16  @44


def test_only_032a_feeds_a_reader_and_it_is_clamped_to_six(rom: bytes) -> None:
    """The whole intersection of host-writable cells and table reads.

    `program[032a + c551]` is computed with no mask, so the bound is entirely
    in the writers - and both clamp. `lamm` zero-extends, so a large host value
    cannot go negative through the `sub`/`retc geq` test and escape the clamp.
    What the read fetches is a routine address out of a six-entry table, not
    data, and the result never travels back to the host.
    """
    from courier_emu.dsp_mailbox import HOST_WRITE_CELLS

    for site in (0xC54E, 0xC828):
        assert words(rom, site - 5, 5) == (0xBF09, 0x032A,   # lar ar1, #032a
                                           0x1080,           # lacc *
                                           0xBF90, 0xC551)   # add #c551
        assert word(rom, site) & 0xFF00 == 0xA600            # tblr

    # Tag 39 clamps to six, which is exactly the table's length.
    assert words(rom, word(rom, DISPATCH_TABLE + 0x39), 6) == (
        0x087A,             # lamm @7a
        0xBA06,             # sub  #06
        0xEF8C,             # retc geq
        0x097A, 0x032A,     # smmr @7a, #032a
        0xEF00)             # ret
    # Tag 41 clamps to thirteen against the same six-entry table, so indices
    # 6..12 fetch the following instruction words as routine addresses. Entry 6
    # is 7a80, which is inside the mask ROM. Nothing may send it.
    assert words(rom, word(rom, DISPATCH_TABLE + 0x41), 3) == (0x087A, 0xBA0D, 0xEF8C)
    assert words(rom, 0xC551, 6) == (0xCA5B, 0xCA68, 0xCA75, 0xCA82, 0xCA8F, 0xCA9C)
    assert word(rom, 0xC557) == 0x7A80 and 0x7A80 < DSP_ENTRY

    assert {0x39, 0x41} == {t for t, c in HOST_WRITE_CELLS.items() if c == 0x032A}


def test_the_60_62_window_is_produced_by_the_dsp(rom: bytes) -> None:
    """`out *, 0060` then status bit 2 - the bit the CPU chain answers.

    This is what identifies the window's producer, which the port map above
    had left open.
    """
    from courier_emu.dsp_mailbox import STREAM_TAG, STREAM_DATA

    assert words(rom, 0x84B7, 5) == (
        0x0C80, 0x0060,     # out  *, 0060
        0xFF00,             # retd
        0xB904,             # lacl #04      -> ASIC status bit 2
        0x8857)             # samm @57

    # And the DSP resumes the streamer when the host acknowledges that bit.
    assert words(rom, 0x847C, 8) == (
        0x7E80, 0x23F0,     # calld 23f0
        0xBF09, 0xFF57,     # lar   ar1, #ff57
        0xBE40, 0x907D,
        0x4D7D,             # bit   13, @7d   (TI numbering: bit 2)
        0xEE00)             # retc  ntc
    assert words(rom, 0x8484, 5) == (0xBF09, 0x039E,    # the resume vector
                                     0x1080, 0xEF88, 0xBE20)   # lacc *; retc eq; bacc

    # Tag 06 only arms it: store a resume address and return, emitting nothing.
    assert word(rom, DISPATCH_TABLE + STREAM_TAG) == 0x8489
    assert words(rom, 0x8489, 4) == (0xBC00 | 7, 0xFF00, 0xAE1E, 0x848D)
    # The supervisor's own trigger sends exactly this tag and data byte.
    assert rom[0x6D0E:0x6D12] == bytes((0xB0, STREAM_DATA, 0xB4, STREAM_TAG))


def test_the_streamer_takes_a_source_and_a_count_from_data_cells(rom: bytes) -> None:
    """`ffb8` is the source address and `ffb9` the count.

    Two entries load the source from `fff8` rather than an immediate, so a
    streamer whose address is data does exist. Neither cell is host-writable.
    """
    from courier_emu.dsp_mailbox import HOST_WRITE_CELLS

    assert words(rom, 0x8619, 8) == (
        0xBF09, 0xFFB8, 0xAE80, 0xFF80,     # [ffb8] := ff80   the source
        0xBF09, 0xFFB9, 0x7D80, 0x84B7)     # [ffb9] := ...    then send
    assert word(rom, 0x8621 + 1) == 0x0010                  # the count
    assert words(rom, 0x8669, 2) == (0xA880, 0xFFF8)        # bldd *, #fff8
    assert 0xFFF8 not in HOST_WRITE_CELLS.values()
    assert {0xFFF0, 0xFFF1, 0xFFF2, 0xFFF3} <= set(HOST_WRITE_CELLS.values())


def test_the_paired_table_reads_fetch_one_address_twice(rom: bytes) -> None:
    """`tblr *+` post-increments the auxiliary register, not the accumulator.

    So the four words tag 46 places at ff80..ff83 are two program addresses,
    six apart, each read twice - not four consecutive words. The hardware run
    in artifacts/dsp-window-pump-02 settled this: it returned 0708 0708 0960
    0960, which is program 860b and 8611, each twice.
    """
    from courier_emu.dsp_mailbox import PROGRAM_STREAM_OFFSETS

    assert words(rom, 0x84DC, 2) == (0xA6A0, 0xA6A0)        # tblr *+ ; tblr *+
    assert words(rom, 0x84DE, 2) == (0xBF90, 0x0006)        # add #06
    assert words(rom, 0x84E0, 2) == (0xA6A0, 0xA6A9)        # tblr *+ ; tblr *+, ar1
    assert PROGRAM_STREAM_OFFSETS == (0, 0, 6, 6)
    assert (word(rom, 0x860B), word(rom, 0x8611)) == (0x0708, 0x0960)


def test_the_streamer_armed_by_tag_46_carries_sixteen_words(rom: bytes) -> None:
    """Which is what the pump runs saw: bit 2 cleared on the seventeenth."""
    assert words(rom, 0x8621, 2) == (0xAE80, 0x0010)        # [ffb9] := 16


def test_tag_46_streams_program_words_but_cannot_choose_them(rom: bytes) -> None:
    """Every piece of a dump except control of the index.

    The address arithmetic is unmasked, so `03db` would reach any program word
    including the mask ROM, and the streamer armed alongside it carries the
    result to the host. But `03db`'s only writer takes its value from `ae12`,
    which bit-scans a status word and yields 0..5.
    """
    handler = word(rom, DISPATCH_TABLE + 0x46)
    assert handler == 0x84D3
    assert words(rom, 0x84D4, 2) == (0xAE1E, 0x8617)        # arm the streamer
    assert words(rom, 0x84D9, 4) == (0x695B,                # lacl @5b  (03db)
                                     0xBF90, 0x860B,        # add  #860b - no mask
                                     0xA6A0)                # tblr *+
    # The index writer, and the six-value source it takes its value from.
    assert words(rom, 0xAE98, 3) == (0xBF09, 0x03DB, 0x9080)    # lar; sacl *
    assert words(rom, 0xAE16, 2) == (0xB905, 0xED00)            # lacl #05; retc tc
    assert words(rom, 0xAE24, 2) == (0xB900, 0xEF00)            # lacl #00; ret


def test_the_index_source_is_a_six_way_priority_encoder(rom: bytes) -> None:
    """`ae12` cannot return anything but 0..5, whatever its input.

    This is what closes the 84d3 route for good. The index at 03db has one
    writer, `ae98`, and it stores `ae12`'s return. `ae12` tests five bits of a
    status word, highest first, and falls through to zero. So no control over
    its input can widen the range: the reader's address is confined to
    860b..8610 by the shape of the encoder, not by any clamp that might be
    bypassed.
    """
    from courier_emu.dsp_mailbox import MAX_INDEX

    assert words(rom, 0xAE12, 3) == (0x7A80, 0xADE8, 0x907D)    # call ade8 ; sacl @7d
    # bit N in TI numbering is bit 15-N, so these are bits 5,4,3,2,1.
    encoder = ((0x4A7D, 0xB905), (0x4B7D, 0xB904), (0x4C7D, 0xB903),
               (0x4D7D, 0xB902), (0x4E7D, 0xB901))
    for step, (test, load) in enumerate(encoder):
        assert words(rom, 0xAE15 + 3 * step, 3) == (test, load, 0xED00)  # ...; retc tc
    assert words(rom, 0xAE24, 2) == (0xB900, 0xEF00)            # lacl #00 ; ret
    assert len(encoder) + 1 == MAX_INDEX


def test_the_encoder_input_is_an_and_of_four_cells_one_host_writable(rom: bytes) -> None:
    """`ade8` returns [ffb0] & [ffb1] & [ffb2] & [ffb3].

    Tag 48 stores the host's word at ffb1 with no clamp, and ffb2 is itself
    derived from ffb1. But an AND only clears bits, and ffb0 and ffb3 are
    loaded with their nonzero values by a call-setup routine - so on an idle
    unit the whole term is zero and the index is zero no matter what the host
    writes. That is what artifacts/dsp-window-index-01 observed.
    """
    from courier_emu.dsp_mailbox import INDEX_MASK_TAG, INDEX_MASK_CELL, HOST_WRITE_CELLS

    assert words(rom, 0xADE8, 2) == (0xBF09, 0xFFB0)
    assert words(rom, 0xADEA, 5) == (0x10A0,                    # lacc *+   ffb0
                                     0x6EA0, 0x6EA0, 0x6EA0,    # and  *+   ffb1..ffb3
                                     0x9080)                    # sacl *    -> ffb4
    # The host's term, stored without any range test.
    assert HOST_WRITE_CELLS[INDEX_MASK_TAG] == INDEX_MASK_CELL
    assert words(rom, word(rom, DISPATCH_TABLE + INDEX_MASK_TAG), 3) == (
        0x097A, INDEX_MASK_CELL, 0xEF00)        # smmr @7a, #ffb1 ; ret
    # ffb2 is computed from ffb1, so two of the four terms move together.
    assert words(rom, 0xA58A, 4) == (0xAE7D, 0xFFFF, 0xBF09, INDEX_MASK_CELL)
    assert words(rom, 0xA540, 3) == (0xBF09, 0xFFB2, 0x9080)
    # The two terms a host cannot reach, and the call-setup routine that loads
    # them - it also fills ff90..ffaf, so it is not something an idle unit runs.
    assert words(rom, 0xADC7, 4) == (0xBF09, 0xFFB0, 0xAE80, 0x7D7F)
    assert words(rom, 0xADCB, 4) == (0xBF09, 0xFFB3, 0xAE80, 0xFFFF)
    assert words(rom, 0xADCF, 2) == (0xBF09, 0xFF90)


def test_the_23f0_accessor_is_installed_by_the_datapump_not_mask_rom(rom: bytes) -> None:
    """The host-message accessor the dispatcher calls is downloaded, not ROM.

    In the reset flow the datapump sets BMAR to 23f0 and block-loads three
    words from image offset 80f5 into program 23f0..23f2. They decode as the
    whole accessor - lacc * ; lamm * ; ret - so `1000..7fff` here is resident
    program memory the datapump writes, and `calld 23f0` is not a call into
    unrecovered mask ROM.
    """
    assert words(rom, 0x80A0, 7) == (
        0xBF80, 0x23F0,     # lacc #23f0
        0x881F,             # samm @1f      BMAR := 23f0
        0x8B89,             # mar  *, ar1
        0xBF09, 0x80F5,     # lar  ar1, #80f5
        0xBB02)             # rpt  #02      -> three words
    assert word(rom, 0x80A7) == 0x57A0                      # bldp *+
    assert words(rom, 0x80F5, 3) == (0x1080, 0x0880, 0xEF00)   # lacc * ; lamm * ; ret


def test_the_other_five_bldp_shaped_words_are_table_data(rom: bytes) -> None:
    """An exhaustive 57xx scan does not find five more program writers.

    Seven payload words have BLDP's 57xx opcode byte.  The reset installer at
    80a7 and the four-word hardware loader at 812b are instructions.  Each of
    the other five is inside a table whose base is explicitly consumed as
    data; decoding those words in isolation manufactures instructions out of
    coefficients.
    """
    payload_words = words(rom, DSP_ENTRY, (0x368FC - DSP_LOAD_BASE) // 2)
    shaped = {
        DSP_ENTRY + offset
        for offset, value in enumerate(payload_words)
        if value >> 8 == 0x57
    }
    assert shaped == {0x80A7, 0x812B, 0x9685, 0xA29B, 0xA83A, 0xC3E7, 0xDC51}

    # The five apparent sites belong to tables rooted at 967a, a29a, a82a,
    # c3a4 and dc50.  These are representative executable references which
    # pass the bases to table/constant consumers rather than branch to the
    # embedded 57xx words.
    assert words(rom, 0x94F7, 2) == (0xBF90, 0x967A)  # add  #967a
    assert words(rom, 0xA130, 4) == (0xBF80, 0xA29A, 0x7E80, 0x87A8)
    assert words(rom, 0xAB95, 2) == (0xAE7E, 0xA82A)  # splk @7e,#a82a
    assert words(rom, 0xC20E, 2) == (0xBF80, 0xC3A4)  # lacc #c3a4
    assert words(rom, 0xDB66, 2) == (0xBF80, 0xDC50)  # lacc #dc50

    # The only computed-destination BLDP loads BMAR from external ASIC cell
    # ff62, copies four words from ff58, advances BMAR, and publishes it back.
    assert words(rom, 0x811B, 30) == (
        0xBDFE, 0x6962, 0x881F, 0xBF09, 0xFF58, 0xBC00,
        0xAE09, 0x0003, 0xBEC6, 0x812F,
        0x7E80, 0x23F0, 0xBE41, 0x8B00, 0x8BA0, 0x907D,
        0x577D, 0x081F, 0xB801, 0x881F, 0xBE40,
        0xBDFE, 0xBF80, 0x0300, 0x8857, 0x7D80, 0x810B,
        0x081F, 0x9062, 0xBE71,
    )
