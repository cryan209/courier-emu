"""Five places the core departed from SPRU056D, found auditing it for MICA."""
import struct

from courier_emu.dsp import NativeC5x

OVM, OV, C = 1 << 6, 1 << 5, 1 << 3

# Pieces used below (SPRU056D chapter 6 opcodes).
CLRC_SXM, SETC_SXM, SETC_C, SETC_OVM = 0xBE46, 0xBE47, 0xBE4F, 0xBE43
SFL, SACB = 0xBE09, 0xBE1E
ACC_80000000 = (CLRC_SXM, 0xBF8F, 0x8000, SFL)   # lacc #8000, 15 ; sfl


def program(*words: int) -> bytes:
    return struct.pack(f"<{len(words)}H", *words)


def run(*words: int, steps: int, ports=()) -> tuple[dict, list[int]]:
    with NativeC5x.from_program(0, program(*words), rebuild=True) as core:
        core.step(steps)
        return core.state(), [core.io_output(port) for port in ports]


def test_subc_sets_ov_without_saturating():
    # 80000000h - (1 << 15) overflows to positive: OV is set, OVM is not
    # consulted, and C is set because the unsigned subtraction does not borrow.
    state, _ = run(0xAE60, 0x0001, *ACC_80000000, SETC_OVM, 0x0A60, steps=7)
    assert state["acc"] & 0xFFFFFFFF == 0xFFFF0001
    assert state["flags"] & OV
    assert state["flags"] & C


def test_sbbb_affects_c_only():
    # 80000000h - 1 - 0: no OV and no saturation even under OVM.
    state, _ = run(0xB901, SACB, *ACC_80000000, SETC_C, SETC_OVM, 0xBE19, steps=9)
    assert state["acc"] & 0xFFFFFFFF == 0x7FFFFFFF
    assert not state["flags"] & OV
    assert state["flags"] & C


def test_adcb_keeps_the_carry_when_accb_is_all_ones():
    # 5 + FFFFFFFFh + 1 = 5 with a carry out; folding C into ACCB first
    # wrapped it to 0 and lost the carry.
    state, _ = run(SETC_SXM, 0xBF80, 0xFFFF, SACB, 0xB905, SETC_C, 0xBE11, steps=6)
    assert state["acc"] & 0xFFFFFFFF == 5
    assert state["flags"] & C
    assert not state["flags"] & OV


def test_mac_loads_treg1_when_trm_is_clear():
    # TRM is clear out of reset. MAC is a 'C2x instruction, so its data
    # operand reaches TREG1 too, and SATL then shifts by it.
    state, _ = run(0xAE60, 0x0004, 0xA260, 0x0000, 0xB980, 0xBE5B, steps=4)
    assert state["acc"] & 0xFFFFFFFF == 0x08


def test_repeated_out_writes_consecutive_ports():
    state, ports = run(0xAE60, 0x1234, 0xBB02, 0x0C60, 0x0200, steps=3,
                       ports=(0x200, 0x201, 0x202))
    assert ports == [0x1234, 0x1234, 0x1234]
