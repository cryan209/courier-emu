"""Quad AT responses must come from its recovered firmware parser."""
from pathlib import Path
from types import SimpleNamespace

import pytest

from courier_emu.quad_terminal import QuadTerminal
from tools.probe_quad_at import probe


def test_byte_adapter_refuses_unknown_firmware():
    with pytest.raises(ValueError, match='QF060003'):
        QuadTerminal.validate(SimpleNamespace(
            quad_role='modem', load_base=0xc0000, data=bytes(0x40000)))


def test_quad_at_ok_error_and_recovery_from_fresh_controller_boot():
    pytest.importorskip('unicorn')
    if not (Path(__file__).resolve().parents[1] / 'docs/x2/Qf060003.zip').exists():
        pytest.skip('QF060003 firmware archive is not available')
    result = probe()
    assert result['error'] is None
    assert result['input_remaining'] == 0
    assert result['bytes_received'] == 28
    assert result['watch_counts']['serial_receive'] == 28
    assert result['watch_counts']['attention'] == 4
    assert result['watch_counts']['command_dispatch'] == 4
    assert result['commands_opened'] == 4
    assert result['final_command_state'] == 'e691'
    assert result['terminal_text'] == '\r\nOK\r\n\r\nOK\r\n\r\nERROR\r\n\r\nOK\r\n'
    # Keep the parity-bearing hardware output distinct from terminal decoding.
    assert bytes.fromhex(result['serial_raw_hex']).startswith(b'\x55\xaa\x00')
