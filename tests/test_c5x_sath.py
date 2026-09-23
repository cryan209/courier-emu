import struct

from courier_emu.dsp import NativeC5x


def program(*words: int) -> bytes:
    return struct.pack(f"<{len(words)}H", *words)


def run(*words: int, steps: int) -> dict:
    with NativeC5x.from_program(0, program(*words), rebuild=True) as core:
        core.step(steps)
        return core.state()


def test_sath_satl_pick_a_nibble_the_way_the_v34_sequencer_does():
    # Overlay 6's phase-3 transmit sequencer at 0xb0c5 takes its next state as
    # nibble[state] of 0x00102540. State 3 must become 2. With SATH shifting
    # left and saturating it became 0x7fffffff >> 12 & f = 15, a state the
    # answerer's control code (0x9d5d, waiting for 5) can never leave.
    state = run(
        0xB90C,          # lacl #0c         4 x state 3
        0x880D,          # samm @0d         -> TREG1
        0xBF8F, 0x0020,  # lacc #0020, 15   = 0x00100000
        0xBF90, 0x2540,  # add  #2540
        0xBE5A,          # sath             TREG1 bit 4 clear: unchanged
        0xBE5B,          # satl             >> 12
        steps=6,
    )
    assert state["acc"] & 0xFFFFFFFF == 0x102


def test_sath_shifts_right_sixteen_only_when_treg1_bit4_is_set():
    # SPRU056D 6-229/6-230, examples 1 and 2 in spirit: bit 4 moves the
    # accumulator right by 16, and SXM decides the fill.
    positive = run(0xB910, 0x880D, 0xBF8F, 0x0020, 0xBE5A, steps=4)
    assert positive["acc"] & 0xFFFFFFFF == 0x0010

    signed = run(0xBE47, 0xB910, 0x880D, 0xBF8F, 0x8000, 0xBE5A, steps=5)
    assert signed["acc"] & 0xFFFFFFFF == 0xFFFFC000

    unsigned = run(0xBE46, 0xB910, 0x880D, 0xBF8F, 0x8000, 0xBE5A, steps=5)
    assert unsigned["acc"] & 0xFFFFFFFF == 0x00004000
