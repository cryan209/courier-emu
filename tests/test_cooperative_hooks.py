"""The parts of the co-resident sampler that must not be wrong on hardware.

Nothing here talks to a board. What it checks is the arithmetic that decides
where bytes land and which addresses may be written at all - the two things
that, when they were done by hand, erased live firmware data at 0x1aab and left
a hook armed.
"""
from pathlib import Path

import pytest

from courier_emu.cooperative_probe import (
    FIRMWARE_DATA, HOOKS, INT0, INT3, arm_commands, build_image, decode,
    disarm_commands,
)
from courier_emu.cooperative_run import writable_addresses
from courier_emu.dial_timing import DIAL, SETUP, fit

ROOT = Path(__file__).resolve().parents[1]


def test_int0_chains_the_mailbox_vector():
    """Vector 0x0c, 8f46:0000, and the segment that lands the stub at 0x1a00."""
    assert INT0.vector == 0x0C
    assert INT0.original == (0x8F46, 0x0000)
    assert (INT0.segment << 4) + INT0.original[1] == INT0.entry == 0x1A00
    # One word arms it and the same word disarms it: the offset half is never
    # written, which is what makes the swap atomic under a live interrupt.
    assert arm_commands(INT0)[-1] == "ATGLK2W0032,01A0"
    assert disarm_commands(INT0) == ["ATGLK2W0032,8F46"]


def test_the_stub_stops_short_of_the_live_firmware_data():
    image, plan = build_image(hook=INT0)
    assert INT0.entry + len(image) <= FIRMWARE_DATA[0]
    # And the placement is the code alone - the write pointer travels as its
    # own command rather than as 200-odd bytes of zeros across 0x1aab.
    assert plan["state_write"] == "ATGLK2W1B00,1C00"
    assert len(image) == plan["code_bytes"]


def test_the_stub_ends_in_the_far_jump_to_the_real_handler():
    image, _ = build_image(hook=INT0)
    assert image.endswith(bytes.fromhex("ea0000468f"))      # jmp far 8f46:0000
    # It begins by saving AX rather than by raising IF. The interrupt entry
    # cleared it and the firmware's handler sets it back when it is ready to;
    # an `sti` here would let a second edge land on a half-saved stub.
    assert image[0] == 0x50                                 # push ax


def test_int3_is_byte_identical_to_what_was_run_on_the_board():
    """coop-chain-04's sampler, which held across an armed run on hardware."""
    image, _ = build_image(hook=INT3)
    expected = (ROOT / "artifacts/coop-chain-04/sampler-ram.bin").read_bytes()
    offset = INT3.entry - 0x1A00
    assert image == expected[offset:offset + len(image)]


def test_the_mailbox_lanes_are_refused_on_int0():
    for port in (0x58, 0x5A, 0x5C, 0x5E, 0x60, 0x62):
        with pytest.raises(ValueError, match="mailbox lane"):
            build_image((0x1C, port), hook=INT0)
    # The same ports are allowed elsewhere: outside INT0 they only might race
    # the firmware, and that judgement belongs to the caller.
    build_image((0x1C, 0x5C), hook=INT3)


@pytest.mark.parametrize("hook", [INT0, INT3])
def test_nothing_writable_reaches_the_firmware_data(hook):
    image, _ = build_image(hook=hook)
    allowed = writable_addresses(hook, image)
    assert not allowed & set(range(*FIRMWARE_DATA))
    assert hook.state in allowed
    assert hook.vector * 4 + 2 in allowed
    # The IVT offset half is not writable, and neither is anything in the ring:
    # the sampler fills that itself, and a run has no business writing it.
    assert hook.vector * 4 not in allowed
    assert hook.buffer not in allowed


def test_decode_reads_the_ring_back_in_the_handlers_own_order():
    """0x1e first, then 0x1c - the order the firmware's handler reads them."""
    pages = {INT0.state: 0x04, INT0.state + 1: 0x1C}      # pointer at 0x1c04
    pages.update({0x1C00: 0xFF, 0x1C01: 0xFD, 0x1C02: 0xFB, 0x1C03: 0xFF})
    ring = decode(pages, INT0.default_ports, hook=INT0)
    assert ring["samples"] == 2
    assert ring["columns"]["0x1e"] == [0xFF, 0xFB]
    assert ring["columns"]["0x1c"] == [0xFD, 0xFF]


def test_a_pointer_outside_the_ring_is_an_error_not_a_capture():
    assert "error" in decode({INT0.state: 0x00, INT0.state + 1: 0x99},
                             INT0.default_ports, hook=INT0)


def test_the_dial_timer_sends_digits_and_nothing_else():
    """ATDT is the only command here that can reach the outside world."""
    for command in ("ATDT1234", "ATDT" + "1" * 64, "ATX0", "ATS11=70",
                    "ATS7=1", "ATH", "ATH0", "ATZ", "ATE0"):
        assert DIAL.fullmatch(command) or SETUP.fullmatch(command), command
    # No dial modifiers, no pulse dialling, no second command smuggled onto the
    # end, and nothing that writes stored settings.
    for command in ("ATDT", "ATDT1,2", "ATDT12W3", "ATDT123;", "ATDP123",
                    "ATD@5", "AT&W", "ATS11=1234", "ATDT1234&W"):
        assert not (DIAL.fullmatch(command) or SETUP.fullmatch(command)), command


def test_the_fit_recovers_a_known_slope():
    """Seconds against digit count: the slope is the per-digit time."""
    slope, intercept = fit([(4, 1.3), (12, 2.1), (24, 3.3), (40, 4.9)])
    assert round(slope, 4) == 0.1          # 100 ms a digit
    assert round(intercept, 4) == 0.9      # everything constant in n
    with pytest.raises(ValueError, match="no slope"):
        fit([(8, 1.0), (8, 1.2)])


def test_every_hook_names_a_vector_and_an_original():
    for name, hook in HOOKS.items():
        assert 0 <= hook.vector <= 0xFF, name
        assert hook.buffer < hook.buffer_end <= 0x2B00, name
        assert hook.entry + 8 <= hook.state, name
