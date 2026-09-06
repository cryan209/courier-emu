"""The TLC320AC01 protocol, as docs/ac01-codec-protocol.md decodes it."""
from pathlib import Path

import math
import pytest

from courier_emu.bridge import CourierDspBridge, LineToCodec
from courier_emu.images import load_image

ROOT = Path(__file__).resolve().parents[1]

# The six control words the 20.16 MHz firmware sends at reset, and what each
# one means. Register 0 is the datasheet's no-op pseudo-register.
RESET_REGISTERS = [0x00, 0x0A, 0x14, 0x00, 0x09, 0x05, 0x20, 0x00, 0x01]


def _boot(path):
    bridge = CourierDspBridge(load_image(ROOT / path))
    payload = bridge.expected_bootstrap
    for offset in range(0, len(payload), 8):
        strobe, ports = bridge.transfer.windows[(offset // 8) % 2]
        chunk = payload[offset:offset + 8].ljust(8, b'\xff')
        for port, byte in zip(range(ports, ports + 16, 2), chunk):
            bridge.write(port, 1, byte)
        bridge.write(bridge.transfer.command_port, 1, strobe)
    bridge.write(bridge.transfer.command_port, 1, bridge.transfer.checksum_strobe)
    return bridge


@pytest.mark.parametrize('path', [
    'IDSDL302.ROM',
    'artifacts/courier-board-21210-capture-403/courier-board.rom',
])
def test_reset_programs_six_registers_through_secondary_frames(path):
    bridge = _boot(path)
    try:
        bridge.core.step(1_500_000)
        codec = bridge.core.codec_state()
        assert codec['registers'] == RESET_REGISTERS
        # Six secondary frames, one per register, none of them a read.
        assert codec['secondary_frames'] == 6
        assert codec['register_writes'] == 6
        assert codec['register_reads'] == 0
        # The two priming DXR writes at reset carry control bits 01, which is
        # a phase-shift request rather than a secondary-frame request.
        assert codec['phase_shifts'] == 2
        assert codec['primary_frames'] > 100
    finally:
        bridge.core.close()


def test_rate_is_derived_from_the_b_register_not_a_constant():
    bridge = _boot('IDSDL302.ROM')
    try:
        bridge.core.step(1_500_000)
        codec = bridge.core.codec_state()
        # A = 10 and B = 20 off a 2.880 MHz MCLK is the 2400-baud rate.
        assert codec['mclk_hz'] == 2_880_000
        assert codec['sample_rate'] == 7200.0
        assert codec['frame_period'] == 3472  # 25 MHz / 7200, as before
        assert codec['rate_programmed']
        # Free run: the codec clocks its own converters off A and B, and the
        # external frame sync only moves data.
        assert codec['free_run']
        # Register 5 bit 2 takes the high-pass filter out of the path.
        assert not codec['high_pass_enabled']
        assert not codec['loopback']
    finally:
        bridge.core.close()


def test_v34_rates_follow_the_b_register():
    """The three rates codec-sample-rates.md derives, driven through the part."""
    from courier_emu.dsp import NativeC5x

    class Image:
        def dsp_program_segments(self):
            return [(0, b'')]

    core = NativeC5x(Image())
    try:
        core.configure_rom_codec()
        for word, rate, period in (
            (0x0214, 7200.0, 3472),
            (0x0213, 7578.947, 3298),
            (0x0212, 8000.0, 3125),
        ):
            core.host_write(0x21, 0x0003)          # request a secondary frame
            core.host_write(0x21, 0x010A)          # A = 10
            core.host_write(0x21, 0x0003)
            core.host_write(0x21, word)            # B = 20 / 19 / 18
            codec = core.codec_state()
            assert codec['registers'][2] == word & 0xFF
            assert round(codec['sample_rate'], 3) == rate
            assert codec['frame_period'] == period
    finally:
        core.close()


def test_secondary_word_addresses_and_readback():
    from courier_emu.dsp import NativeC5x

    class Image:
        def dsp_program_segments(self):
            # A loop of LAMM @20, so every instruction reads DRR.
            return [(0, bytes.fromhex('2008') * 2048)]

    core = NativeC5x(Image())
    try:
        core.configure_rom_codec()
        core.configure_line_frame_interrupt(5, 0xFFFF)
        # Write register 4, then ask for it back: DS13 set puts the part in
        # read mode, which programs nothing and returns the register on DOUT
        # during the secondary frame.
        core.host_write(0x21, 0x0003)
        core.host_write(0x21, 0x0409)
        assert core.codec_state()['registers'][4] == 0x09
        core.host_write(0x21, 0x0003)
        core.host_write(0x21, 0x2400)  # DS13 | address 4
        assert core.codec_state()['register_reads'] == 1
        # The value arrives when the secondary frame sync does, half a frame
        # period later - not on whatever instruction happens to read DRR.
        for _ in range(4000):
            core.step(1)
            if core.state()['acc'] == 0x09:
                break
        else:
            raise AssertionError('the secondary frame never delivered the register')
        # A no-op secondary (register 0) programs nothing.
        writes = core.codec_state()['register_writes']
        core.host_write(0x21, 0x0003)
        core.host_write(0x21, 0x0055)
        assert core.codec_state()['register_writes'] == writes
    finally:
        core.close()


def test_every_primary_frame_clocks_one_adc_word():
    """The ADC converts whether or not the DSP is listening.

    Before this, DRR was filled lazily when the firmware happened to read it,
    so a run whose queue was empty saw the same stale word every frame.
    """
    from courier_emu.dsp import NativeC5x

    class Image:
        def dsp_program_segments(self):
            return [(0, bytes.fromhex('8beb') * 2048)]  # NOP

    core = NativeC5x(Image())
    try:
        core.configure_rom_codec()
        core.configure_line_frame_interrupt(5, 0xFFFF)
        core.queue_codec_rx([1000] * 500)
        core.step(20_000)
        codec = core.codec_state()
        serial = core.serial_state()
        # One word per frame, and the DSP never read DRR at all.
        assert codec['frames_clocked'] > 0
        assert serial['codec_rx_consumed'] == codec['frames_clocked']
        assert serial['drr_reads'] == 0
        assert serial['drr'] == 1000
    finally:
        core.close()


def test_boot_words_are_not_consumed_by_a_frame_sync():
    """The ROM loader's table shares the port but is not the sample stream."""
    from courier_emu.dsp import NativeC5x

    class Image:
        def dsp_program_segments(self):
            return [(0, bytes.fromhex('8beb') * 2048)]

    core = NativeC5x(Image())
    try:
        core.configure_rom_codec()
        core.configure_line_frame_interrupt(5, 0xFFFF)
        core.queue_codec_boot([0x1234] * 8)
        core.step(20_000)  # many frame syncs pass
        # The boot words are still there for the loader to poll.
        assert core.codec_state()['frames_clocked'] > 4
        assert core.serial_state()['codec_rx_consumed'] == 0
    finally:
        core.close()


def test_line_audio_keeps_its_frequency_across_the_rate_change():
    """A 2100 Hz answer tone must still be 2100 Hz after the codec sees it."""
    def frequency(samples, rate):
        signs = [1 if value > 0 else 0 for value in samples]
        crossings = sum(1 for a, b in zip(signs, signs[1:]) if a != b)
        return crossings / 2 * rate / len(samples)

    line = [int(8000 * math.sin(2 * math.pi * 2100 * n / 9600)) for n in range(9600)]
    converter = LineToCodec(9600)
    converted: list[int] = []
    for offset in range(0, len(line), 960):  # batched, to exercise the seam
        converted.extend(converter.convert(line[offset:offset + 960], 7200.0))

    assert len(converted) == 7200
    assert round(frequency(converted, 7200)) == 2100
    # Which is the point: handed over unresampled it would read as 1575 Hz.
    assert round(frequency(line[:7200], 7200)) == 1575


def test_unprogrammed_codec_passes_line_audio_through():
    converter = LineToCodec(9600)
    samples = list(range(100))
    assert converter.convert(samples, 0.0) == samples
