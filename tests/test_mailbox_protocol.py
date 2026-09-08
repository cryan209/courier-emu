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








def word(rom: bytes, address: int) -> int:
    """One DSP program word, out of the image the downloader sends verbatim."""
    offset = DSP_LOAD_BASE + 2 * (address - DSP_ENTRY)
    return struct.unpack_from("<H", rom, offset)[0]


def words(rom: bytes, address: int, count: int) -> tuple[int, ...]:
    return tuple(word(rom, address + step) for step in range(count))


def test_the_dsp_reads_host_messages_from_asic_cells_not_data_memory(rom: bytes) -> None:
    """`23f0` is installed program RAM, not part of the C52 ROM window.

    The dispatcher polls status cell `ff57`, and only if its low bit is set
    does it fetch the tag from `ff5e` and the value from `ff5f`. Those are
    high data-space cells reached through the installed helper, not the ordinary
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




































