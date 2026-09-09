"""Execute the recovered receive path, including a CRC rejection control."""
from pathlib import Path

import pytest

from tools.probe_quad_receive import crc, probe


@pytest.mark.parametrize('corrupt,residue,accepted', [
    (False, '0xf0b8', 1), (True, '0xe131', 0),
])
def test_qf_boot_receives_finite_crc_frame(corrupt, residue, accepted):
    pytest.importorskip('unicorn')
    if not (Path(__file__).resolve().parents[1] / 'docs/x2/Qf060003.zip').exists():
        pytest.skip('QF060003 firmware archive is not available')
    result = probe(corrupt)
    assert result['error'] is None
    assert result['status'] == 'instruction-limit'
    assert result['residue'] == residue
    assert result['counts']['receive'] == 15
    assert result['counts']['header'] == 8
    assert result['counts']['body'] == 4
    assert result['counts'].get('crc_ok', 0) == accepted
    assert result['counts'].get('control_complete', 0) == accepted
    assert result['transitions'] == [
        '0000', '19f6', '1a01', '1a19', '1a44', '1afc', '19f6',
    ]
    assert result['state'] == 'f619'
    assert result['crc'] == int(residue, 16).to_bytes(2, 'little').hex()
    link = result['usart']
    assert link['data_reads'] == link['interrupt_reads'] == 15
    assert link['empty_reads'] == 0
    assert link['rx_fifo'] == link['rx_queued'] == 0
    assert not link['irq_pending']


def test_frame_crc_known_check_value():
    assert crc(b'123456789') ^ 0xffff == 0x906e
