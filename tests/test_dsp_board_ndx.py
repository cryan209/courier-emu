"""Replay exact RAM probes captured from the Courier DSP 3.1.2 board."""
import json
from pathlib import Path

import pytest

from courier_emu.dsp import NativeC5x

ROOT = Path(__file__).resolve().parents[1]


class EmptyImage:
    def dsp_program_segments(self):
        return []


@pytest.mark.parametrize('name', ['ndx-addressing-02', 'dsp-status-03',
                                 'ndx-long-1234-20260909'])
def test_instruction_probe_matches_board(name):
    folder = ROOT / 'artifacts' / name
    labels = json.loads((folder / 'labels.json').read_text())
    observed = json.loads((folder / 'hardware.json').read_text())['words']
    with NativeC5x(EmptyImage()) as core:
        core.set_mpmc_pin(0)
        core.configure_rom_codec()
        core.set_io(0x57, 2)
        core.load_program((folder / 'probe-c5x.bin').read_bytes(), 0x8000)
        core.set_pc(0x8000)
        core.step(2000)
        for i, (label, expected) in enumerate(zip(labels, observed, strict=True)):
            if label == 'ndx0.other_lar.ar0':
                # This field samples the bootloader's incoming AR0, before
                # the probe sets it. No defined reset/loader value is claimed.
                continue
            actual = core.data(0x1000 + i)
            if label.endswith('.pmst'):
                # AVIS is the one measured reset-state difference outside
                # this probe's instruction/handshake assertions.
                actual &= ~0x80
                expected &= ~0x80
            assert actual == expected, (label, hex(actual), hex(expected))


def test_exact_long_immediate_probe_preserves_existing_model():
    from courier_emu.dsp_probe import build_ndx_long_probe, NDX_LONG_LABELS

    probe = build_ndx_long_probe()
    assert probe.payload == (ROOT / 'artifacts/ndx-long-1234-20260909/'
                             'probe-c5x.bin').read_bytes()
    with NativeC5x(EmptyImage()) as core:
        core.set_mpmc_pin(0)
        core.configure_rom_codec()
        core.set_io(0x57, 2)
        core.load_program(probe.payload, 0x8000)
        core.set_pc(0x8000)
        core.step(2000)
        samples = dict(zip(NDX_LONG_LABELS,
                           (core.data(0x1000 + i) for i in range(9)), strict=True))
    assert samples['run_marker'] == 0x9209
    for ndx in (0, 1):
        assert samples[f'ndx{ndx}.pmst'] & 4 == ndx * 4
        assert samples[f'ndx{ndx}.ar0'] == 0x1234
    assert (samples['ndx0.arcr'], samples['ndx0.indx']) == (0x1234, 0x1234)
    assert (samples['ndx1.arcr'], samples['ndx1.indx']) == (0xEEEE, 0xDDDD)


def test_long_probe_capture_integrity():
    from courier_emu.probe_transport import parse_capture

    folder = ROOT / 'artifacts/ndx-long-1234-20260909'
    raw = (folder / 'frame.txt').read_bytes()
    parsed = parse_capture(raw[raw.index(b'CDRP1 START'):])
    assert parsed['word_count'] == 9
    assert parsed['words'] == json.loads((folder / 'hardware.json').read_text())['words']
    assert (folder / 'readback.bin').read_bytes() == (folder / 'diagnostic-ram.bin').read_bytes()


def test_pa7_acknowledgement_does_not_create_download_ready():
    # Resident init writes FFFF, and download completion writes 0300.
    # Neither may manufacture a new incoming block on PA7 bit 9.
    import struct
    with NativeC5x(EmptyImage()) as core:
        core.configure_rom_codec()
        core.set_io(0x57, 0x0207)
        core.load_program(struct.pack('<6H', 0xBF80, 0x0300, 0x8857,
                                      0xBF80, 0xFFFF, 0x8857), 0x8000)
        core.set_pc(0x8000)
        core.step(2)
        assert core.io(0x57) == 7
        core.step(2)
        assert core.io(0x57) == 0


def test_booted_firmware_roundtrip_and_independent_holding_registers():
    from courier_emu.bridge import CourierDspBridge
    from courier_emu.images import load_image

    bridge = CourierDspBridge(load_image(
        ROOT / 'artifacts/courier-board-21210-capture-403/courier-board.rom'))
    try:
        payload = bridge.expected_bootstrap
        for offset in range(0, len(payload), 8):
            strobe, ports = bridge.transfer.windows[(offset // 8) % 2]
            for port, byte in zip(range(ports, ports + 16, 2),
                                  payload[offset:offset + 8].ljust(8, b'\xff')):
                bridge.write(port, 1, byte)
            bridge.write(bridge.transfer.command_port, 1, strobe)
        bridge.write(bridge.transfer.command_port, 1, bridge.transfer.checksum_strobe)
        bridge.core.step(1_500_000)
        bridge._runtime_mode = True
        bridge.write(0x1C, 1, 6)  # CPU frees the two DSP outbound windows.
        for tag in (7, 0x2D, 7):
            assert bridge.read(0x1C, 1) & 1
            for port, value in zip((0x58, 0x5A, 0x5C, 0x5E), (tag, 0, 0, 0)):
                bridge.write(port, 1, value)
            assert not bridge.core.io(0x57) & 1  # staging is not commit
            bridge.write(0x1C, 1, 1)
            assert bridge.core.io(0x57) & 1
            assert not bridge.read(0x1C, 1) & 1
            bridge.core.step(100_000)
            bridge._collect_dsp_messages()
            assert not bridge._runtime_inbound
            assert not bridge.core.io(0x57) & 1  # real DSP dispatcher ack
            assert bool(bridge.read(0x1C, 1) & 2) == (tag == 7)
            # Stage another CPU word before reading the standing DSP reply.
            # Neither staging nor CPU acknowledgement changes its data.
            bridge.write(0x58, 1, 0x2D)
            bridge.write(0x5C, 1, 0xAA)
            bridge.write(0x5E, 1, 0x55)
            assert [bridge.read(p, 1) for p in (0x58, 0x5A, 0x5C, 0x5E)] == [0x31, 0, 0, 0]
            bridge.write(0x1C, 1, 2)
            assert not bridge.read(0x1C, 1) & 2
            assert bridge.core.io(0x57) & 2
            assert bridge.read(0x58, 1) == 0x31
        assert bridge._runtime_inbound_delivered['0031:0000'] == 2
        # A repeated CPU acknowledgement with no new DSP reply is not a
        # second delivery, even though the output register still holds 0031.
        bridge.write(0x1C, 1, 2)
        assert bridge._runtime_inbound_delivered['0031:0000'] == 2
    finally:
        bridge.core.close()
