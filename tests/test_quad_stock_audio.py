from pathlib import Path

from courier_emu.quad_audio import (ANSWER_VARIANTS, DIGITS, COLUMNS, G711_ALAW_FLAG,
                                    G711_COMPRESS, G711_EXPAND, G711_FLAGS,
                                    G711_LAW_SELECT, ROWS, render,
                                    render_answer, render_answer_g711, render_g711,
                                    resident_from_ram, spectrum)


RAM = (Path(__file__).parents[1] /
       "artifacts/quad-identify-20260910/ram.bin").read_bytes()


def test_qf_resident_contains_its_own_dual_law_g711_codec():
    # resident_from_ram verifies the exact instruction sequences at these
    # addresses, including cmpl/bias for mu-law and xor 0x55 for A-law.
    assert resident_from_ram(RAM)
    assert G711_EXPAND == 0x8115
    assert G711_COMPRESS == 0x817F
    assert G711_LAW_SELECT == 0x8238
    assert (G711_FLAGS, G711_ALAW_FLAG) == (0x039F, 0x4000)


def test_stock_qf_dsp_generates_every_dtmf_pair_and_transmits_it():
    expected = {
        "1": (697, 1209), "2": (697, 1336), "3": (697, 1477), "A": (697, 1663),
        "4": (770, 1209), "5": (770, 1336), "6": (770, 1477), "B": (770, 1663),
        "7": (852, 1209), "8": (852, 1336), "9": (852, 1477), "C": (852, 1663),
        "*": (941, 1209), "0": (941, 1336), "#": (941, 1477), "D": (941, 1663),
    }
    assert set(expected) == set(DIGITS)
    for digit, pair in expected.items():
        samples, serial = render(RAM, digit, 720)
        measured = spectrum(samples)
        assert (measured["row"], measured["column"]) == pair
        assert serial["dxr_writes"] == 720
        assert serial["last_dxr_pc"] == 0x83EF
        assert max(map(abs, samples)) > 10_000
        assert measured["row"] in ROWS and measured["column"] in COLUMNS


def test_stock_qf_tone_runs_through_both_firmware_g711_branches_and_isr():
    for law in ("a", "mu"):
        codewords, decoded, serial = render_g711(RAM, "5", law=law, count=800)
        assert len(codewords) == 800
        assert len(set(codewords)) > 100
        measured = spectrum(decoded, rate=8_000)
        assert (measured["row"], measured["column"]) == (770, 1336)
        assert serial["dxr_writes"] == 800
        assert serial["last_dxr_pc"] == 0x83EF


def test_stock_qf_answer_tone_variants_are_armed_by_resident_callbacks():
    expected = {
        "ans": (0x8E60, 0x0898),
        "ans-reversals": (0x8E3B, 0x0898),
        "ansam": (0x8E14, 0x06CF),
        "ansam-reversals": (0x8E18, 0x06CF),
    }
    assert set(expected) == set(ANSWER_VARIANTS)
    for variant, (callback, amplitude) in expected.items():
        samples, armed = render_answer(RAM, variant, count=720)
        assert armed["callback"] == callback
        assert armed["increment"] == 0x4AAB
        assert armed["amplitude"] == amplitude
        assert max(map(abs, samples)) > 5_000


def test_stock_qf_ansam_reaches_both_g711_laws_and_dxr():
    for law in ("a", "mu"):
        codewords, decoded, state = render_answer_g711(
            RAM, "ansam", law=law, count=800)
        assert len(codewords) == 800
        assert len(set(codewords)) > 100
        assert max(map(abs, decoded)) > 5_000
        assert state["serial"]["dxr_writes"] == 800
        assert state["serial"]["last_dxr_pc"] == 0x83EF
