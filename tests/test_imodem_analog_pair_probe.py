from tools.probe_imodem_analog_pair import PROTOCOL_S58, analog_terminal_text, carrier_connected
from tools.probe_imodem_analog_pair import OverlayAudit, connection_rate_bps
from courier_emu.dsp import NativeC5x
from courier_emu.imodem_dsp import ImodemDsp
import pytest
import struct


def test_pcm_protocol_selection_disables_the_other_protocol_on_both_sides():
    assert PROTOCOL_S58["x2"] == 32
    assert PROTOCOL_S58["v90"] == 1
    assert PROTOCOL_S58["v34"] == 33
    assert PROTOCOL_S58["default"] is None


def test_carrier_detection_accepts_verbose_speed_result_but_not_isdn_events():
    assert carrier_connected("\r\nCONNECT 14400/ARQ\r\n")
    assert carrier_connected("\r\nCONNECT\r\n")
    assert carrier_connected("\r\nCONNECT 44000/ARQ/x2/LAPM\r\n", complete=True)
    assert not carrier_connected("BCH_ENABLED Detected\r\n")
    assert not carrier_connected("CONNECT call reference 1")
    assert not carrier_connected("\r\nNO CARRIER\r\n")


def test_payload_waits_for_connect_result_terminating_lf():
    assert not carrier_connected("\r\nCONNECT", complete=True)
    assert not carrier_connected("\r\nCONNECT\r", complete=True)
    assert carrier_connected("\r\nCONNECT\r\n", complete=True)
    assert carrier_connected("\r\nCONNECT 300\r\n", complete=True)


def test_rate_requires_a_complete_native_result_on_that_terminal():
    assert connection_rate_bps("\r\nCONNECT 37333/ARQ/x2/LAPM\r\n") == 37333
    assert connection_rate_bps("\r\nCONNECT 33333/ARQ/x2/LAPM\r\n") == 33333
    assert connection_rate_bps("\r\nCONNECT/ARQ\r\n") is None
    assert connection_rate_bps("\r\nCONNECT 44000") is None
    assert connection_rate_bps("payload CONNECT 64000\r\n") is None


def test_normal_mode_payload_is_decoded_as_the_terminal_7e1_frame():
    wire = bytes.fromhex("c94dcf44c54d2d36b7b83930")
    assert all(byte.bit_count() % 2 == 0 for byte in wire)
    assert analog_terminal_text({"serial_hex": wire.hex()}) == "IMODEM-67890"


@pytest.mark.parametrize('corrupt', [False, True])
def test_overlay_audit_detects_program_corruption_without_repairing_it(corrupt):
    endpoint = ImodemDsp()
    endpoint.core = NativeC5x.from_program(0xa000, struct.pack('<4H', 11, 22, 33, 44))
    endpoint.reset_status = False
    try:
        audit = OverlayAudit(endpoint)
        endpoint.core.set_data(0x0bff, 0xa000)
        for port, value in zip((0x40, 0x44, 0x48, 0x4c), (11, 22, 33, 44)):
            endpoint.write(port, value)
            endpoint.write(port + 2, 0)
        audit.write(0x1e, 1)
        audit.write(0x1e, 2)
        # Simulate the loader's acknowledged pointer and a subsequent bad write.
        endpoint.core.set_io(0x57, 2)
        endpoint.core.set_data(0x0bff, 0xa004)
        if corrupt:
            endpoint.core.set_data(0xa002, 0xdead)
        audit.write(0x1e, 4)
        record, = audit.records
        assert record['mismatched_words'] == int(corrupt)
        assert record['first_mismatch_addresses'] == ([0xa002] if corrupt else [])
        assert record['destination_after'] == record['expected_destination_after'] == 0xa004
        assert endpoint.core.program(0xa002) == (0xdead if corrupt else 33)
        assert endpoint.core.io(0x57) == 0x0402  # original completion write still runs
    finally:
        endpoint.close()
