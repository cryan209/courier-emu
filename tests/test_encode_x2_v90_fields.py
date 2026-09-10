from tools.encode_x2_v90_fields import (
    INFO_FILL,
    INFO_SYNC,
    bits_value,
    info_frame,
    v90_info1a,
    x2_modulation_parameters,
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


def test_info_framing_lengths_and_fixed_bits() -> None:
    for body_length, frame_length in ((7, 39), (17, 49), (38, 70), (77, 109)):
        frame = info_frame([0] * body_length)
        assert len(frame) == frame_length
        assert frame[:4] == list(INFO_FILL)
        assert frame[4:12] == list(INFO_SYNC)
        assert frame[-4:] == list(INFO_FILL)
