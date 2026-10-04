#!/usr/bin/env python3
"""Verify read-only Ie030002 digital scrambler captures from a paired call."""
import argparse
import hashlib
import json
from pathlib import Path


def advance(value, history, width):
    output = 0
    for bit in range(width):
        scrambled = ((value >> bit) ^ (history >> 5) ^ history) & 1
        output |= scrambled << bit
        history = (history >> 1) | (scrambled << 22)
    return output, history


def verify(folder):
    summary = json.loads((folder / 'summary.json').read_text())
    assert all(summary['data_delivery'].values()), 'payload failed'
    report = {'firmware': 'Ie030002.nac', 'scrambler': '1 + x^-18 + x^-23',
              'bit_order': 'LSB first, then octet reversal', 'sides': {}}
    for side in ('originate', 'answer'):
        result = json.loads((folder / f'{side}.json').read_text())
        assert result['error'] is None and result['mailbox']['error'] is None
        assert summary[side]['connect_result'] == 'CONNECT 64000/ARQ/x2/LAPM'
        assert result['mailbox']['pcm']['rx_empty_frames'] == 0
        trace = result['digital_path_trace']
        resets = [c for g in trace['samples'] if g['phase'] == 'width_reset'
                  for c in g['captures']]
        assert len(resets) >= 2
        for c in resets:
            assert c[7] == 8 and c[6] == 255 and c[10] & 0x200
            assert c[8:10] == [0, 0] and c[11:13] == [0, 0]
        checked = captures = 0
        modes = set()
        for group in trace['samples']:
            if group['phase'] != 'transmit':
                continue
            stream = group['captures']
            for c in stream:
                captures += 1
                assert c[3] == 7 and c[6:8] == [255, 8]
                assert c[10] & 0x200 and c[13] & 0x8000
                assert c[14:18] == [0xe97e, 0xe992, 0xe97e, 0xe992]
                modes.add(c[10])
            for c, following in zip(stream, stream[1:]):
                assert following[0] > c[0]
                _, state = advance(c[5], (c[8] << 16) | c[9], c[7])
                assert state == (following[8] << 16) | following[9], 'GPC history mismatch'
                checked += 1
        assert checked > 1000
        assert resets[-1][14:16] == [0xe97e, 0xe992]
        report['sides'][side] = {
            'modes': [f'{m:04x}' for m in sorted(modes)],
            'width': 8, 'scrambling_enabled': True, 'octet_reversal_enabled': True,
            'tx_callback': 'e97e', 'rx_callback': 'e992', 'tx_gpc_entry': '9057',
            'rx_gpc_entry': '908e', 'width_initializer': 'e8e1',
            'reset_capture_pc': 'e908', 'zero_history_resets': len(resets),
            'reset_dsp_instructions': [c[0] for c in resets],
            'tx_captures': captures, 'consecutive_gpc_transitions_checked': checked,
            'last_reset': resets[-1], 'connect_result': summary[side]['connect_result'],
            'bidirectional_payload': True,
            'trace_sha256': hashlib.sha256((folder / f'{side}.json').read_bytes()).hexdigest(),
        }
    return report


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('folder', type=Path)
    args = parser.parse_args()
    report = verify(args.folder)
    (args.folder / 'verification.json').write_text(json.dumps(report, indent=2) + '\n')
    print(json.dumps(report, indent=2))
