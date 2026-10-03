"""Summarize packet continuity and supervisor/DSP time in a live-call trace."""
import argparse
from collections import defaultdict
import json
from pathlib import Path
import statistics
import struct


def packet_fields(packet):
    if len(packet) < 12 or packet[0] >> 6 != 2:
        return None
    header = 12 + 4 * (packet[0] & 15)
    if packet[0] & 16:
        if len(packet) < header + 4:
            return None
        header += 4 + 4 * int.from_bytes(packet[header + 2:header + 4], 'big')
    end = len(packet) - (packet[-1] if packet[0] & 32 else 0)
    if header > end:
        return None
    return (int.from_bytes(packet[2:4], 'big'),
            int.from_bytes(packet[4:8], 'big'),
            int.from_bytes(packet[8:12], 'big'), packet[1] & 127,
            end - header)


def summarize_stream(rows):
    seen = {}
    high = None
    duplicates = reordered = 0
    times = []
    for row, fields in rows:
        seq, timestamp, _, _, count = fields
        extended = seq if high is None else high + ((seq - high + 32768) % 65536 - 32768)
        if extended in seen:
            duplicates += 1
        else:
            if high is not None and extended < high:
                reordered += 1
            seen[extended] = (timestamp, count)
        high = extended if high is None else max(high, extended)
        times.append(row['seconds'])
    ordered = sorted(seen)
    missing = ordered[-1] - ordered[0] + 1 - len(ordered)
    discontinuities = []
    for first, second in zip(ordered, ordered[1:]):
        if second != first + 1:
            continue
        timestamp, count = seen[first]
        delta = (seen[second][0] - timestamp) & 0xffffffff
        if delta != count:
            discontinuities.append({'after_sequence': first, 'timestamp_step': delta,
                                    'payload_samples': count})
    gaps = sorted(max(0, b - a) * 1000 for a, b in zip(times, times[1:]))
    return {
        'packets': len(rows), 'unique_packets': len(seen),
        'missing_within_observed_range': missing,
        'duplicate_packets': duplicates, 'out_of_order_packets': reordered,
        'timestamp_discontinuities': discontinuities,
        'payload_sample_counts': sorted(set(count for _, count in seen.values())),
        'duration_seconds': times[-1] - times[0],
        'max_observed_packet_gap_ms': max(gaps, default=0),
        'median_observed_packet_gap_ms': statistics.median(gaps) if gaps else 0,
        'observed_gaps_over_40ms': sum(gap > 40 for gap in gaps),
    }


def analyse(path):
    streams = defaultdict(list)
    calls = defaultdict(list)
    serial = []
    with path.open() as source:
        for line in source:
            if not line.endswith('\n'):
                continue  # A live writer may still be emitting its last row.
            row = json.loads(line)
            if row['kind'] == 'rtp':
                fields = packet_fields(bytes.fromhex(row['packet_hex']))
                if fields and fields[3] == 0:
                    streams[(row['call_id'], row['direction'], fields[2])].append((row, fields))
            elif row['kind'] == 'dsp' and row['call_id']:
                calls[row['call_id']].append(row)
            elif row['kind'] == 'serial_rx':
                serial.append({'seconds': row['seconds'],
                               'text': bytes.fromhex(row['hex']).decode('ascii', 'replace')})
    clock = []
    for call_id, rows in calls.items():
        active = [row for row in rows if row['call_state'] == 'active']
        if len(active) < 2:
            continue
        first, last = active[0], active[-1]
        wall = last['seconds'] - first['seconds']
        clock.append({
            'call_id': call_id, 'active_observed_seconds': wall,
            'cpu_seconds': (last['instructions'] - first['instructions']) / 5_000_000,
            'peripheral_seconds': (last['peripheral_instructions'] - first['peripheral_instructions']) / 5_000_000,
            'dsp_seconds': (last['core']['cycles'] - first['core']['cycles']) / 40_320_000,
            'bearer_seconds': (last['bearer_tx'] - first['bearer_tx']) / 8000,
            'receive_fill_samples': last['receive_fill'] - first['receive_fill'],
            'preanswer_samples': last['preanswer_samples'] - first['preanswer_samples'],
        })
    return {
        'timing_note': 'RTP times are application socket observations, not kernel arrival timestamps; receive gaps may include delayed polling.',
        'streams': [dict(call_id=key[0], direction=key[1], ssrc=key[2],
                         **summarize_stream(rows)) for key, rows in streams.items()],
        'clocks': clock, 'serial': serial,
    }


def analyse_pcap(path, local_port, call_lookup=None):
    """Read classic tcpdump PCAP with Ethernet or Linux cooked headers."""
    streams = defaultdict(list)
    with path.open('rb') as source:
        header = source.read(24)
        if len(header) < 24:
            return []
        formats = {b'\xd4\xc3\xb2\xa1': ('<', 1e6),
                   b'\xa1\xb2\xc3\xd4': ('>', 1e6),
                   b'\x4d\x3c\xb2\xa1': ('<', 1e9),
                   b'\xa1\xb2\x3c\x4d': ('>', 1e9)}
        if header[:4] not in formats:
            raise ValueError('Unsupported capture format; classic PCAP required')
        endian, resolution = formats[header[:4]]
        link = struct.unpack(endian + 'I', header[20:24])[0]
        offsets = {1: 14, 113: 16, 276: 20}
        if link not in offsets:
            raise ValueError(f'Unsupported PCAP link type {link}')
        while True:
            record = source.read(16)
            if len(record) < 16:
                break
            seconds, fraction, size, _ = struct.unpack(endian + 'IIII', record)
            frame = source.read(size)
            if len(frame) != size:
                break
            ip = frame[offsets[link]:]
            if len(ip) < 20 or ip[0] >> 4 != 4 or ip[9] != 17:
                continue
            if int.from_bytes(ip[6:8], 'big') & 0x3fff:
                continue  # Fragmented UDP cannot be parsed as one packet.
            udp = ip[4 * (ip[0] & 15):]
            if len(udp) < 8:
                continue
            source_port, destination_port, length = struct.unpack('>HHH', udp[:6])
            if local_port not in (source_port, destination_port):
                continue
            fields = packet_fields(udp[8:length])
            if fields is None or fields[3] != 0:
                continue
            direction = 'tx' if source_port == local_port else 'rx'
            call_id = (call_lookup.get((direction, fields[2], fields[0], fields[1]))
                       if call_lookup is not None else None)
            if call_lookup is not None and call_id is None:
                continue
            streams[(call_id, direction, fields[2])].append(
                ({'seconds': seconds + fraction / resolution}, fields))
    return [dict(call_id=key[0], direction=key[1], ssrc=key[2], **summarize_stream(rows))
            for key, rows in streams.items()]


def packet_call_lookup(path):
    lookup = {}
    with path.open() as source:
        for line in source:
            if not line.endswith('\n'):
                continue
            row = json.loads(line)
            if row['kind'] != 'rtp':
                continue
            fields = packet_fields(bytes.fromhex(row['packet_hex']))
            if fields:
                lookup[(row['direction'], fields[2], fields[0], fields[1])] = row['call_id']
    return lookup


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('timeline', type=Path)
    parser.add_argument('--output', type=Path)
    parser.add_argument('--pcap', type=Path)
    parser.add_argument('--local-rtp-port', type=int)
    args = parser.parse_args()
    result = analyse(args.timeline)
    if args.pcap:
        if args.local_rtp_port is None:
            parser.error('--pcap requires --local-rtp-port')
        result['asterisk_wire_streams'] = analyse_pcap(
            args.pcap, args.local_rtp_port, packet_call_lookup(args.timeline))
    result = json.dumps(result, indent=2)
    if args.output:
        args.output.write_text(result + '\n')
    else:
        print(result)


if __name__ == '__main__':
    main()
