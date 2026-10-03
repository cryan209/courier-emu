import math
import struct

import pytest

from courier_emu.dsp import NativeC5x


def test_dac_clock_metadata_retains_rates_for_undrained_samples():
    with NativeC5x.from_program(0, struct.pack('<H', 0xbe22)) as core:
        core.configure_rom_codec()
        core.configure_line_frame_interrupt(5, 0xffff)
        for word in [3, 0x010a, 3, 0x0214]:
            core.host_write(0x21, word)
        for mclk in (2880000, 3840000):
            core.set_codec_mclk(mclk)
            for _ in range(20):
                state = core.codec_state()
                core.step_cycles(state['line_frame_next_cycle'] - state['cycles'])
        assert core.line_tx_clock_events() == [(0, 7200), (20, 9600)]
        assert len(core.line_tx_samples()) == 40
        core.reset()
        assert core.line_tx_clock_events() == []


@pytest.mark.parametrize('frequency', [1000, 3000])
def test_queued_line_waveform_survives_codec_retunes_at_adc_edges(frequency):
    with NativeC5x.from_program(0, struct.pack('<H', 0xbe22)) as core:
        core.configure_rom_codec()
        core.configure_line_frame_interrupt(5, 0xffff)
        for word in [3, 0x010a, 3, 0x0214]:
            core.host_write(0x21, word)  # A=10, B=20, initial 7.2 kHz
        core.queue_line_rx([round(10000 * math.sin(2 * math.pi * frequency * k / 8000))
                            for k in range(2400)])
        input_time, error, signal = 0.0, 0.0, 0.0
        for mclk, divider in [(2880000, 20), (3456000, 18), (3696000, 18)]:
            core.host_write(0x21, 3)
            core.host_write(0x21, 0x0200 | divider)
            core.set_codec_mclk(mclk)
            for _ in range(300):
                state = core.codec_state()
                # Rate changes do not rewind an already scheduled frame.
                core.step_cycles(state['line_frame_next_cycle'] - state['cycles'])
                actual = core.register(0x20)
                if actual >= 32768:
                    actual -= 65536
                # Fixed 32-line-sample cushion plus 65-sample FIR delay;
                # retuning the codec must not shift or accelerate either.
                expected = 10000 * math.sin(2 * math.pi * frequency *
                                           (input_time - 97 / 8000))
                if input_time > 0.02:
                    error += (actual - expected) ** 2
                    signal += expected ** 2
                input_time += state['frame_period'] / 40320000
            assert core.codec_state()['rx_empty_frames'] == 0
        assert 10 * math.log10(signal / error) > 60


def test_line_fifo_occupancy_is_measured_at_line_rate_after_adc_retune():
    with NativeC5x.from_program(0, struct.pack('<H', 0xbe22)) as core:
        core.configure_rom_codec()
        core.configure_line_frame_interrupt(5, 0xffff)
        for word in [3, 0x010a, 3, 0x0214]:
            core.host_write(0x21, word)
        core.queue_line_rx([1234] * 2400)
        for mclk in [2880000, 3840000]:  # 7.2 then 9.6 kHz, same FIFO
            core.set_codec_mclk(mclk)
            for _ in range(round(core.codec_sample_rate / 10)):
                state = core.codec_state()
                core.step_cycles(state['line_frame_next_cycle'] - state['cycles'])
        # Two 100 ms periods consume ~1600 line samples whatever the ADC's
        # rate. The old preconverted FIFO consumed the second block too fast.
        assert abs(core.codec_state()['codec_rx_size'] - 832) <= 2
        assert core.codec_state()['rx_empty_frames'] == 0


def test_ideal_exchange_reconstruction_preserves_upper_pcm_band():
    frequency = 3800
    with NativeC5x.from_program(0, struct.pack('<H', 0xbe22)) as core:
        core.configure_rom_codec()
        core.configure_line_frame_interrupt(5, 0xffff)
        for word in (3, 0x010a, 3, 0x0212):
            core.host_write(0x21, word)
        core.set_codec_mclk(3456000)  # 9.6-kHz client ADC, 8-kHz exchange
        core.queue_line_rx([
            round(10000 * math.sin(2 * math.pi * frequency * k / 8000))
            for k in range(2400)
        ])
        input_time = signal = error = 0.0
        for k in range(1500):
            state = core.codec_state()
            core.step_cycles(state['line_frame_next_cycle'] - state['cycles'])
            actual = core.register(0x20)
            if actual >= 32768:
                actual -= 65536
            expected = 10000 * math.sin(
                2 * math.pi * frequency * (input_time - 97 / 8000)
            )
            if k > 300:
                signal += expected ** 2
                error += (actual - expected) ** 2
            input_time += state['frame_period'] / 40320000
        assert core.codec_state()['rx_empty_frames'] == 0
        # Includes amplitude and phase error without fitting either away.
        # The previous 0.49 cutoff produced only 39.4 dB here.
        assert 10 * math.log10(signal / error) > 60
