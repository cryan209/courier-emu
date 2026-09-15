from courier_emu.bridge import CourierDspBridge, LINE_FRAME_SAMPLES, Resampler
from courier_emu.dsp import NativeC5x


class _Core:
    def __init__(self, *, codec_rate=8_000.0):
        self.codec_sample_rate = codec_rate
        self.line_tx_writes = 0
        self.samples = []

    def line_tx_samples(self, start=0):
        return self.samples[start:]

    def serial_state(self):
        return {"line_tx_writes": self.line_tx_writes}


def test_transmit_audio_is_converted_once_from_codec_to_line_rate():
    bridge = CourierDspBridge.__new__(CourierDspBridge)
    bridge.core = _Core(codec_rate=7_200)
    bridge.core.samples = list(range(720))
    bridge._exchange_tx_index = 0
    bridge._exchange_line_buffer = []
    bridge._codec_to_line = Resampler()

    bridge._take_line_audio()

    assert bridge._exchange_tx_index == 720
    # The streaming interpolator holds one startup sample until it has a
    # neighbour across the first block boundary.  It must not apply the
    # datapump's separate timing ratio and shrink this to roughly 667.
    assert len(bridge._exchange_line_buffer) == LINE_FRAME_SAMPLES - 1

    bridge.core.samples.extend(range(720))
    bridge._take_line_audio()
    assert len(bridge._exchange_line_buffer) == 2 * LINE_FRAME_SAMPLES - 1


def test_audio_line_frames_are_paced_at_codec_rate():
    bridge = CourierDspBridge.__new__(CourierDspBridge)
    bridge._audio_only = True
    bridge.core = _Core(codec_rate=7_200)
    bridge._audio_codec_frames = 0
    bridge._audio_line_samples_due = 0.0
    serviced = []
    bridge._service_audio_line = lambda: serviced.append(True)

    # A 100 ms wire frame is 720 codec samples in the 7.2 kHz mode.  Internal
    # datapump timing must not change this codec/line boundary.
    bridge.core.line_tx_writes = 720
    bridge._service_line()
    assert serviced == [True]
    assert bridge._audio_line_samples_due == 0


def test_asic_timing_row_scales_codec_clock_from_board_source():
    core = NativeC5x.from_program(0, b"\x00\x00")
    try:
        core.configure_rom_codec()
        core.set_io(0x6B, 0x0090)

        assert core.codec_state()["mclk_hz"] == 3_456_000
    finally:
        core.close()
