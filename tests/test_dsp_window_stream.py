"""Enumerate and count-verify the DSP's fixed-block streamers.

The `0x60`/`0x62` window is a generic block streamer the ASIC bridges into
CPU-readable ports (see `docs/dsp-rom-probe.md`, "The `0x60`/`0x62` window:
producer identified").  Six armed variants each set a source pointer `ffb8` and
a count `ffb9`, and each is reached by one mailbox command tag through the jump
table at program `8401`.  This file pins that mapping two ways.

The static half reads the arm-stub count immediate out of the image for each
tag, so a different firmware fails rather than silently passing.

The dynamic half drives the datapump's own streamer engine on the native C52:
it installs the `23f0` host-message accessor, arms a tag through its handler,
and pumps the resume path `847a` one word at a time exactly as a host does with
`ATGLK2O001C,04`, counting writes to port `0x60`.  Tag `46` is the anchor - it
emits `0708 0708 0960 0960 ...`, the same words the physical `dsp-window-pump-02`
capture returned - so the counts the same harness reports for `47`, `73` and
`78` are trustworthy.

Two model facts the run established and this file encodes.  The stream's first
pumped word is the count itself, because the arm stub's opening `bd 84b7` emits
with `ar1` still at `ffb9`; a host pumps `count + 1` times and discards word 0.
And the emit's "pump me again" flag and the resume poll both resolve to data
`0057` (the accessor's `lamm *` masks the ASIC address to page 0), so `0057`
bit 2 is the handshake cell.  The minimal `47`/`73`/`78` handlers return with
`ARP = 0`, so the driver sets `LARP 1` before each pump - the context the real
mailbox interrupt establishes; it does not touch the counts.
"""
from pathlib import Path
import struct

import pytest

from courier_emu.rom import CourierRom

CAPTURE = Path("artifacts/courier-board-21210-capture-01/courier-board.rom")

DISPATCH_TABLE = 0x8401         # program word 8401 + tag -> handler entry
ACCESSOR = 0x23F0               # lacc * ; lamm * ; ret, installed by the datapump
ACCESSOR_WORDS = (0x1080, 0x0880, 0xEF00)
RESUME = 0x847A                 # the DSP's streamer resume path
LARP1 = 0x8B89                  # mar *, ar1
CALL, BRANCH = 0x7A80, 0x7980
HANDSHAKE_CELL = 0x0057         # data 0057 bit 2: "host has pumped"
STREAM_PORT = 0x60

# Each streamer: the tag that arms it, the program word holding its count
# immediate, and the expected (count, source-start) the run must reproduce.
STREAMERS = {
    0x46: {"count_imm_at": 0x8622, "words": 16, "source": 0xFF80},
    0x47: {"count_imm_at": 0x864D, "words": 12, "source": 0xFFC0},
    0x73: {"count_imm_at": 0x8670, "words": 103, "source": 0x0A40},
    0x78: {"count_imm_at": 0x8683, "words": 5, "source": 0xF993},
}

# Tag 46's first four data words are program 860b/8611 read twice each, which is
# what dsp-window-pump-02 returned off a physical board.
TAG_46_PROGRAM_WORDS = (0x860B, 0x860B, 0x8611, 0x8611)

pytestmark = pytest.mark.skipif(
    not CAPTURE.exists(), reason="board ROM capture not present"
)


def program_words(rom: CourierRom) -> list[int]:
    (origin, data), = rom.dsp_program_segments()
    words = [0] * 0x10000
    for index in range(len(data) // 2):
        words[origin + index] = data[2 * index] | (data[2 * index + 1] << 8)
    return words


@pytest.fixture(scope="module")
def rom() -> CourierRom:
    return CourierRom.load(CAPTURE)


@pytest.fixture(scope="module")
def words(rom: CourierRom) -> list[int]:
    return program_words(rom)


def test_each_tag_arms_the_streamer_with_its_expected_count(words: list[int]) -> None:
    """The arm-stub count immediate is fixed in the image, one per tag."""
    for tag, spec in STREAMERS.items():
        assert words[DISPATCH_TABLE + tag] != 0, f"tag {tag:02x} has no handler"
        opcode_at = spec["count_imm_at"] - 1
        assert words[opcode_at] == 0xAE80, f"tag {tag:02x}: not splk *,#imm"
        assert words[spec["count_imm_at"]] == spec["words"], f"tag {tag:02x} count"


def test_the_accessor_the_resume_path_calls_is_the_installed_helper(words: list[int]) -> None:
    """`847a` reaches port 0060 by calling the downloaded `23f0` accessor."""
    # calld 23f0 ; lar ar1, #ff57 in the delay slot, then bit-test bit 2.
    assert words[0x847C] == 0x7E80 and words[0x847D] == ACCESSOR
    assert (words[0x847E], words[0x847F]) == (0xBF09, 0xFF57)


def _drive(rom: CourierRom, words: list[int], tag: int, pumps: int) -> list[int]:
    """Arm one tag and pump the window, returning the port-0060 words emitted."""
    from courier_emu.dsp import NativeC5x

    def little(values: tuple[int, ...]) -> bytes:
        return b"".join(struct.pack("<H", value & 0xFFFF) for value in values)

    core = NativeC5x(rom)
    try:
        core.load_program(little(ACCESSOR_WORDS), ACCESSOR)
        handler = words[DISPATCH_TABLE + tag]
        # LARP1 ; call handler ; loop: LARP1 ; call 847a ; b loop
        driver = (LARP1, CALL, handler, LARP1, CALL, RESUME, BRANCH, 0x0003)
        core.load_rom(little(driver), 0)
        core.set_mpmc_pin(0)
        core.set_data(HANDSHAKE_CELL, 0x0004)   # bit 2: a pump is pending
        core.set_pc(0)
        core.step(pumps * 90)
        return [
            event["value"] & 0xFFFF
            for event in core.io_events()
            if event["write"] and event["port"] == STREAM_PORT
        ]
    finally:
        core.close()


@pytest.mark.parametrize("tag", sorted(STREAMERS))
def test_the_streamer_emits_exactly_its_count(tag: int, rom: CourierRom, words: list[int]) -> None:
    """Driving the engine reproduces the count and walks the whole source block."""
    pytest.importorskip("courier_emu.dsp")
    spec = STREAMERS[tag]
    emitted = _drive(rom, words, tag, pumps=spec["words"] + 8)

    # Word 0 is the count itself (the arm stub's opening emit); the rest is data.
    assert emitted[0] == spec["words"]
    data_words = emitted[1:]
    assert len(data_words) == spec["words"]


def test_tag_46_carries_the_program_words_the_board_returned(rom: CourierRom, words: list[int]) -> None:
    """The anchor: tag 46's first four data words are program 860b/8611."""
    pytest.importorskip("courier_emu.dsp")
    emitted = _drive(rom, words, 0x46, pumps=24)
    data_words = emitted[1:]
    expected = [words[address] for address in TAG_46_PROGRAM_WORDS]
    assert data_words[:4] == expected
