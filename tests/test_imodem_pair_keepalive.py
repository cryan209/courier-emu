from copy import deepcopy

import pytest

from tools.probe_imodem_pair import check_keepalive, connect_result


def active_pair_side():
    return {
        'error': None,
        'serial_session': [],
        'bri': {'call_state': 'active', 'media': {'channel': 1}, 'events': []},
        'g711_peer': {'frames': 338, 'error': 'Broken pipe'},
        'mailbox': {
            'error': None,
            'pcm': {'rx_empty_frames': 0},
            'timeline': ['19.5405 cmd 0002:a000'],
            'overlay_writes': {'4': 6},
            'dsp_status': 0x0402,
        },
    }


def test_keepalive_accepts_final_strobe_and_peer_closing_at_instruction_limit():
    check_keepalive(active_pair_side())


@pytest.mark.parametrize('serial', ['DISCONNECT\r\n', '\r\nCONNECT 64000/ARQ/x2\r',
                                  'ATCONNECT\r\n'])
def test_connect_result_rejects_incomplete_or_embedded_results(serial):
    assert connect_result(serial) is None


def test_connect_result_retains_modulation_and_rate():
    assert connect_result('\r\nOK\r\n\r\nCONNECT 64000/ARQ/x2\r\n') == 'CONNECT 64000/ARQ/x2'


@pytest.mark.parametrize('failure', ['cleared', 'timeout', 'short', 'underrun', 'no-handoff'])
def test_keepalive_rejects_clear_or_incomplete_training_run(failure):
    result = deepcopy(active_pair_side())
    if failure == 'cleared':
        result['bri']['call_state'] = 'null'
        result['serial_session'] = [{'direction': 'received', 'text': '\r\nNO CARRIER\r\n'}]
    elif failure == 'timeout':
        result['mailbox']['timeline'].append('21.5331 cmd 0083:0083')
    elif failure == 'short':
        result['g711_peer']['frames'] = 220
    elif failure == 'underrun':
        result['mailbox']['pcm']['rx_empty_frames'] = 1
    else:
        result['mailbox']['timeline'] = []
    with pytest.raises(AssertionError):
        check_keepalive(result)
