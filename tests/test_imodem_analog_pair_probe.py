from tools.probe_imodem_analog_pair import PROTOCOL_S58, analog_terminal_text, carrier_connected


def test_pcm_protocol_selection_disables_the_other_protocol_on_both_sides():
    assert PROTOCOL_S58["x2"] == 32
    assert PROTOCOL_S58["v90"] == 1
    assert PROTOCOL_S58["v34"] == 33
    assert PROTOCOL_S58["default"] is None


def test_carrier_detection_accepts_verbose_speed_result_but_not_isdn_events():
    assert carrier_connected("\r\nCONNECT 14400/ARQ\r\n")
    assert carrier_connected("\r\nCONNECT\r\n")
    assert not carrier_connected("BCH_ENABLED Detected\r\n")
    assert not carrier_connected("CONNECT call reference 1")
    assert not carrier_connected("\r\nNO CARRIER\r\n")


def test_payload_waits_for_connect_result_terminating_lf():
    assert not carrier_connected("\r\nCONNECT", complete=True)
    assert not carrier_connected("\r\nCONNECT\r", complete=True)
    assert carrier_connected("\r\nCONNECT\r\n", complete=True)
    assert carrier_connected("\r\nCONNECT 300\r\n", complete=True)


def test_normal_mode_payload_is_decoded_as_the_terminal_7e1_frame():
    wire = bytes.fromhex("c94dcf44c54d2d36b7b83930")
    assert all(byte.bit_count() % 2 == 0 for byte in wire)
    assert analog_terminal_text({"serial_hex": wire.hex()}) == "IMODEM-67890"
