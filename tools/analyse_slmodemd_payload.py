"""Check the probe's known seven-bit application packets in both directions."""
import argparse
import json
import re
from pathlib import Path


def direction(expected, received):
    packets = [bytes.fromhex(row['hex']) for row in expected]
    matches = [received.count(packet) for packet in packets]
    gaps = []
    for index, (a, b) in enumerate(zip(packets, packets[1:])):
        start, end = received.find(a), received.find(b)
        if start >= 0 and end >= start + len(a):
            extra = received[start + len(a):end]
            if extra:
                gaps.append({'after_packet': index, 'hex': extra.hex()})
    return {'packets_sent': len(packets),
            'packets_received_exactly_once': matches.count(1),
            'missing_or_corrupted_packets': [i for i, count in enumerate(matches) if count == 0],
            'duplicate_packets': [i for i, count in enumerate(matches) if count > 1],
            'unexpected_bytes_between_intact_packets': gaps,
            'verified_payload_bytes': sum(len(packet) for packet, count in zip(packets, matches) if count == 1),
            'application_stream_matches_exactly': bool(packets) and received == b''.join(packets),
            'all_packets_match': bool(packets) and all(count == 1 for count in matches)}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('directory', type=Path)
    args = parser.parse_args()
    root = args.directory
    result = json.loads((root / 'result.json').read_text())
    upstream = json.loads((root / 'payload-sent.json').read_text())
    downstream = [json.loads(line) for line in (root / 'payload-sent.jsonl').read_text().splitlines()]
    tty = (root / 'tty.log').read_bytes()
    # SmartLink's raw PTY retains parity bits for a seven-bit DTE. Preserve
    # all eight data bits when the I-modem actually runs in 8N1.
    framing = result.get('dte_framing', '7E1')
    terminal_data = tty if framing == '8N1' else bytes(value & 0x7f for value in tty)
    connect = re.search(rb'CONNECT[^\r\n]*\r\n', terminal_data)
    upstream_data = terminal_data[connect.end():] if connect else terminal_data
    log = (root / 'slmodemd.log').read_text()
    blocks = result['peer']['blocks']
    connect_block = min(upstream[0]['block'], downstream[0]['block']) - 50 if upstream and downstream else None
    report = {'framing': framing,
              'audio_duration_seconds': blocks / 50,
              'data_hold_seconds_approximately': (blocks - connect_block) / 50 if connect_block is not None else None,
              'imodem_to_smartlink': direction(upstream, upstream_data),
              'smartlink_to_imodem': direction(downstream, (root / 'payload-received.bin').read_bytes()),
              'negotiated_links': re.findall(r'Link: DP is ([^\r\n]+)', log),
              'retrain_requests': log.count('retrain requested !!'),
              'smartlink_error_correction_active': bool(re.search(r'\bec = 1 \(1\)', log)),
              'probe_status': result['status']}
    (root / 'payload-analysis.json').write_text(json.dumps(report, indent=2) + '\n')
    print(json.dumps(report, indent=2))


if __name__ == '__main__':
    main()
