"""The isolated peer transport must not carry call-state shortcuts."""
import socket
import struct
import wave
from types import SimpleNamespace
from pathlib import Path

from courier_emu.bridge import CourierDspBridge
from courier_emu.cli import _link_side, _worker_command, build_parser
from courier_emu.daa import CourierDaa
from courier_emu.images import load_image
from courier_emu.line import LineFrame, LineLink

ROOT = Path(__file__).resolve().parents[1]
ROM = ROOT / 'artifacts/courier-board-21210-capture-403/courier-board.rom'


def test_audio_wire_contains_only_length_and_pcm(tmp_path):
    local, remote = socket.socketpair()
    link = LineLink('', audio_only=True, record_prefix=str(tmp_path / 'peer'))
    link._socket = local
    try:
        remote.sendall(struct.pack('<H3h', 3, -32768, 0, 32767))
        link.exchange(LineFrame(123456, True, True, [42, -42]))
        assert remote.recv(1024) == struct.pack('<H2h', 2, 42, -42)
        assert link.receive_audio() == [-32768, 0, 32767]
        assert not link.peer_off_hook
        assert not link.peer_ringing
        assert link.peer_instructions == 0
    finally:
        link.close()
        remote.close()
    for direction, expected in [('tx', [42, -42]), ('rx', [-32768, 0, 32767])]:
        with wave.open(str(tmp_path / f'peer-{direction}.wav'), 'rb') as recording:
            assert recording.getframerate() == 8000
            assert recording.getnchannels() == 1
            assert recording.getsampwidth() == 2
            assert recording.getnframes() == len(expected)
            assert recording.readframes(len(expected)) == struct.pack(
                '<' + 'h' * len(expected), *expected)


def test_audio_mode_reaches_both_workers():
    args = build_parser().parse_args(['link', str(ROM), '--line-audio-only'])
    for listen in (False, True):
        command = _link_side(args, ['ATA'], listen)
        run_args = build_parser().parse_args(command[3:])
        worker = _worker_command(run_args)
        assert '--line-audio-only' in worker


def test_audio_connection_cannot_synthesize_carrier_or_training():
    link = LineLink('', audio_only=True)
    daa = CourierDaa()
    bridge = CourierDspBridge(load_image(ROM), line=link, daa=daa)
    try:
        bridge.arm_dial_tones(b'ATA')
        assert not daa.off_hook  # Only the CPU's relay write may seize it.
        bridge.force_connected_event()
        bridge._observe_asic_command(0x82, 0xA0)
        bridge._observe_asic_command(0x1F, 0x8000)
        bridge._maybe_start_answer_engine()
        assert not bridge._connected_event_queued
        assert not bridge._call_resume_pending
        assert not bridge._asic_call_engine_started
        assert not bridge._runtime_inbound
    finally:
        bridge.core.close()


def test_silent_peer_advances_on_codec_time_and_tracks_rate_changes():
    # Neither CPU instruction counts nor DXR writes are needed to clock a
    # silent line. Two 100 ms codec intervals must produce two wire frames.
    bridge = object.__new__(CourierDspBridge)
    bridge._audio_only = True
    bridge._audio_codec_frames = 0
    bridge._audio_line_samples_due = 0.0
    state = {'frames_clocked': 0}
    bridge.core = SimpleNamespace(codec_state=lambda: state,
                                  codec_sample_rate=7200)
    sent = []
    bridge._service_audio_line = lambda: sent.append(True)
    for count in range(1, 721):
        state['frames_clocked'] = count
        bridge._service_line()
    assert len(sent) == 1
    bridge._service_line()
    assert len(sent) == 1
    bridge.core.codec_sample_rate = 8000
    state['frames_clocked'] += 800
    bridge._service_line()
    assert len(sent) == 2


def test_nonzero_dsp_audio_crosses_socket_and_reaches_codec(monkeypatch):
    local, remote = socket.socketpair()
    link = LineLink('', audio_only=True)
    link._socket = local
    daa = CourierDaa()
    daa.seize()
    bridge = CourierDspBridge(load_image(ROM), line=link, daa=daa)
    received = []
    monkeypatch.setattr(bridge, 'codec_sample_rate', lambda: 7200)
    monkeypatch.setattr(bridge.core, 'line_tx_samples',
                        lambda start=0: ([1000] * 720)[start:])
    monkeypatch.setattr(bridge.core, 'queue_codec_rx', received.extend)
    try:
        remote.sendall(struct.pack('<H800h', 800, *([-2000] * 800)))
        bridge._service_audio_line()
        packet = remote.recv(4096)
        assert len(packet) == 1602
        count, *samples = struct.unpack('<H800h', packet)
        assert count == 800
        assert sum(sample == 1000 for sample in samples) >= 798
        assert len(received) == 720
        assert max(map(abs, received)) == 2000
        trace = bridge._audio_line_trace[-1]
        assert trace['tx_wire_peak'] == 1000
        assert trace['rx_wire_peak'] == trace['rx_codec_input_peak'] == 2000

        daa.release()
        bridge._exchange_tx_index = 0
        remote.sendall(struct.pack('<H800h', 800, *([-2000] * 800)))
        bridge._service_audio_line()
        assert remote.recv(4096) == struct.pack('<H800h', 800, *([0] * 800))
        trace = bridge._audio_line_trace[-1]
        assert trace['tx_before_hook_peak'] == 1000
        assert trace['tx_wire_peak'] == trace['rx_codec_input_peak'] == 0
        assert trace['rx_wire_peak'] == 2000
    finally:
        bridge.core.close()
        link.close()
        remote.close()
