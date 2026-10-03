import struct
from tools.analyse_imodem_rtp_trace import analyse_pcap, packet_fields, summarize_stream


def row(sequence, timestamp, at):
    packet = b'\x80\x00' + sequence.to_bytes(2, 'big') + timestamp.to_bytes(4, 'big')
    packet += b'\x00\x00\x00\x01' + b'\xff' * 160
    return ({'seconds': at}, packet_fields(packet))


def test_continuity_handles_sequence_and_timestamp_wrap():
    start = 0xffffff60
    result = summarize_stream([row(65535, start, 0), row(0, 0, .02), row(1, 160, .04)])
    assert result['missing_within_observed_range'] == 0
    assert result['timestamp_discontinuities'] == []
    assert result['out_of_order_packets'] == 0


def test_missing_reordered_and_duplicate_packets_are_distinct():
    result = summarize_stream([row(10, 0, 0), row(13, 480, .06),
                               row(12, 320, .061), row(13, 480, .062)])
    assert result['missing_within_observed_range'] == 1
    assert result['out_of_order_packets'] == 1
    assert result['duplicate_packets'] == 1
    assert result['timestamp_discontinuities'] == []


def test_timestamp_slip_with_contiguous_sequence_is_detected():
    result = summarize_stream([row(1, 0, 0), row(2, 161, .02)])
    assert result['timestamp_discontinuities'][0]['timestamp_step'] == 161


def test_linux_cooked_pcap_uses_kernel_packet_times_and_ignores_partial_tail(tmp_path):
    path = tmp_path / 'capture.pcap'
    contents = struct.pack('<IHHIIII', 0xa1b2c3d4, 2, 4, 0, 0, 65535, 276)
    for sequence, microseconds in [(1, 0), (2, 20000)]:
        rtp = b'\x80\x00' + struct.pack('>HII', sequence, (sequence - 1) * 160, 1) + b'\xff' * 160
        udp = struct.pack('>HHHH', 62324, 1234, len(rtp) + 8, 0) + rtp
        ip = bytearray(20)
        ip[0], ip[9] = 0x45, 17
        frame = bytes(20) + bytes(ip) + udp
        contents += struct.pack('<IIII', 100, microseconds, len(frame), len(frame)) + frame
    path.write_bytes(contents + b'partial')
    result = analyse_pcap(path, 62324)[0]
    assert result['direction'] == 'tx'
    assert result['packets'] == 2
    assert abs(result['max_observed_packet_gap_ms'] - 20) < .001
    # The emulator reuses its SSRC across calls. Do not report the idle gap
    # between calls as a media outage.
    lookup = {('tx', 1, 1, 0): 'first', ('tx', 1, 2, 160): 'second'}
    calls = analyse_pcap(path, 62324, lookup)
    assert [call['call_id'] for call in calls] == ['first', 'second']
    assert all(call['max_observed_packet_gap_ms'] == 0 for call in calls)
