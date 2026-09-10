from tools.encode_x2_v90_fields import (
    INFO_FILL,
    INFO_SYNC,
    bits_value,
    info_frame,
    v90_info1a,
    v34_mp_rate_word,
    X2_RATE_CODE_TO_BPS,
    x2_modulation_parameters,
    x2_pcm_rate,
    x2_rate_code,
    x2_rate_code_from_measurement,
)


def test_recovered_x2_marker_codes() -> None:
    assert x2_modulation_parameters(1, 6, 4) == 0x4D
    assert x2_modulation_parameters(1, 4, 6) == 0x69
    assert x2_modulation_parameters(0, 4, 4) == 0x48
    assert x2_modulation_parameters(1, 4, 4) == 0x49


def test_v90_selector_is_info1a_bits_37_through_39() -> None:
    body = v90_info1a(uinfo=0x55, upstream_rate=4, selector=6)
    assert len(body) == 38
    assert bits_value(body[25 - 12 : 32 - 12]) == 0x55
    assert bits_value(body[34 - 12 : 37 - 12]) == 4
    assert body[37 - 12 : 40 - 12] == [0, 1, 1]


def test_x2_pcm_rate_index_ladder() -> None:
    assert x2_pcm_rate(10) == (32, 42666)
    assert x2_pcm_rate(11) == (33, 44000)
    assert x2_pcm_rate(21) == (43, 57333)


def test_v34_mp_directional_rate_fields_are_reversed_into_word_zero() -> None:
    # Wire field 0001 (numeric 1, LSB transmitted first) occupies the high bit
    # of each four-bit slice in the DSP's receive word.
    assert v34_mp_rate_word(1, 0) == 1 << 9
    assert v34_mp_rate_word(0, 1) == 1 << 5
    assert v34_mp_rate_word(0xF, 0xF) == 0x03FC


def test_x2_four_bit_rate_code_covers_the_complete_ladder() -> None:
    assert len(X2_RATE_CODE_TO_BPS) == 16
    assert x2_rate_code(33333) == 0
    assert x2_rate_code_from_measurement(10) == x2_rate_code(42666) == 3
    assert x2_rate_code_from_measurement(21) == x2_rate_code(57333) == 14
    assert x2_rate_code(64000) == 15


def test_info_framing_lengths_and_fixed_bits() -> None:
    for body_length, frame_length in ((7, 39), (17, 49), (38, 70), (77, 109)):
        frame = info_frame([0] * body_length)
        assert len(frame) == frame_length
        assert frame[:4] == list(INFO_FILL)
        assert frame[4:12] == list(INFO_SYNC)
        assert frame[-4:] == list(INFO_FILL)
