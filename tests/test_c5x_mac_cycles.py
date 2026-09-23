import struct

from courier_emu.dsp import NativeC5x


def program(*words: int) -> bytes:
    return struct.pack(f"<{len(words)}H", *words)


def repeated_macd_cycles(taps: int) -> int:
    # lar ar1,#0300 ; mar *,ar1 ; rpt #(taps-1) ; macd 0x0000,*-
    # Coefficients come from program 0x0000 (the image itself); the delay line
    # is in B1 DARAM at 0x0300 - the phase-3 receiver's own placement
    # (rpt #51 / rpt #a1 macd over 0x04xx at 0x9ee5 and 0x9ef3).
    words = (0xBF09, 0x0300, 0x8B89, 0xBB00 | (taps - 1), 0xA390, 0x0000)
    with NativeC5x.from_program(0x8000, program(*words), rebuild=True) as core:
        core.set_pc(0x8000)
        core.step(3)
        before = core.state()["cycles"]
        core.step(1)
        return core.state()["cycles"] - before


def test_repeated_macd_over_daram_retires_a_tap_per_cycle():
    # SPRU056D 6-155: operand 2 in DARAM, repeated: n + 2.
    assert repeated_macd_cycles(82) == 84
    assert repeated_macd_cycles(162) == 164
