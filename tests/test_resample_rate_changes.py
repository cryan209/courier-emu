import math

import pytest

from courier_emu.resample import BandLimitedResampler, HALF_TAPS


@pytest.mark.parametrize('middle_rate', [10266.666, 8000])
def test_codec_receive_clock_retune_preserves_the_continuous_line_waveform(middle_rate):
    converter = BandLimitedResampler()
    input_count = 0
    # The FIR's initial zero history delays the waveform by 65 line samples.
    next_time = -(HALF_TAPS + 1) / 8000
    for count, codec_rate in [(803, 9600), (800, middle_rate), (800, 9600)]:
        samples = [round(10000 * math.sin(2 * math.pi * 3000 *
                                        (input_count + k) / 8000))
                   for k in range(count)]
        actual = converter.convert(samples, 8000, codec_rate)
        expected = [10000 * math.sin(2 * math.pi * 3000 *
                                    (next_time + k / codec_rate))
                    for k in range(len(actual))]
        # Skip FIR startup only. After each retune, every sample is compared
        # to the continuous physical tone, without fitting a new phase.
        first = 150 if input_count == 0 else 0
        rms = math.sqrt(sum((a - b) ** 2 for a, b in
                            zip(actual[first:], expected[first:])) /
                        (len(actual) - first))
        assert rms < 10, (codec_rate, rms)
        input_count += count
        next_time += len(actual) / codec_rate


@pytest.mark.parametrize('frequency', [1000, 3000, 3700])
def test_codec_transmit_retune_keeps_history_on_its_original_time_grid(frequency):
    converter = BandLimitedResampler()
    input_time, output_count = 0.0, 0
    for count, codec_rate in [(963, 9600), (1027, 10266.666), (963, 9600)]:
        samples = [round(10000 * math.sin(2 * math.pi * frequency *
                                        (input_time + k / codec_rate)))
                   for k in range(count)]
        actual = converter.convert(samples, codec_rate, 8000)
        expected = [10000 * math.sin(2 * math.pi * frequency *
                                    (-(HALF_TAPS + 1) / 9600 +
                                     (output_count + k) / 8000))
                    for k in range(len(actual))]
        first = 150 if output_count == 0 else 0
        error = sum((a - b) ** 2 for a, b in
                    zip(actual[first:], expected[first:]))
        signal = sum(b ** 2 for b in expected[first:])
        # Includes the entire rate boundary, with no phase refit. The old
        # converter shifted the retained history and fails by thousands of
        # PCM units; the new stream preserves at least 50 dB SNR in band.
        assert 10 * math.log10(signal / error) > 50
        input_time += count / codec_rate
        output_count += len(actual)


def test_transmit_retune_is_independent_of_scheduler_chunk_size():
    segments = [(963, 9600), (1027, 10266.666), (963, 9600)]
    outputs = []
    for chunk_size in [2048, 37]:
        converter = BandLimitedResampler()
        time = 0.0
        output = []
        for count, rate in segments:
            samples = [round(10000 * math.sin(2 * math.pi * 3000 *
                                            (time + k / rate)))
                       for k in range(count)]
            for first in range(0, count, chunk_size):
                output.extend(converter.convert(samples[first:first + chunk_size], rate, 8000))
            time += count / rate
        outputs.append(output)
    assert outputs[0] == outputs[1]
