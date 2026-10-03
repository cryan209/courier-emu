from courier_emu.bridge import CourierDspBridge, LINE_FRAME_SAMPLES, Resampler
from courier_emu.dsp import NativeC5x
from courier_emu.resample import BandLimitedResampler
import math


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
    bridge._line_service = {
        "tx_consumed": 0, "tx_index": 0, "tx_peak_codec": 0, "tx_peak_line": 0,
    }

    bridge._take_line_audio()

    assert bridge._exchange_tx_index == 720
    # 720 codec samples at 7.2 kHz are one 100 ms line frame. The converter
    # emits the instant that closes the block as well, so the first block is
    # one over; what matters is that it must not apply the datapump's separate
    # timing ratio and shrink this to roughly 667.
    assert len(bridge._exchange_line_buffer) == LINE_FRAME_SAMPLES + 1

    bridge.core.samples.extend(range(720))
    bridge._take_line_audio()
    # And from then on exactly one line frame per 720 codec samples.
    assert len(bridge._exchange_line_buffer) == 2 * LINE_FRAME_SAMPLES + 1


def test_transmit_retune_inside_undrained_batch_preserves_physical_tone():
    bridge = CourierDspBridge.__new__(CourierDspBridge)
    bridge.core = _Core(codec_rate=10266.6666667)
    bridge.core.samples = [round(10000 * math.sin(2 * math.pi * 3000 * k / 9600))
                           for k in range(960)]
    bridge.core.samples += [round(10000 * math.sin(2 * math.pi * 3000 *
                                                (0.1 + k / 10266.6666667)))
                            for k in range(1027)]
    bridge.core.line_tx_clock_events = lambda: [(0, 9600), (960, 10266.6666667)]
    bridge._exchange_tx_index = 0
    bridge._exchange_line_buffer = []
    bridge._codec_to_line = BandLimitedResampler()
    bridge._line_service = dict(tx_consumed=0, tx_index=0, tx_peak_codec=0, tx_peak_line=0)
    bridge._take_line_audio()
    actual = bridge._exchange_line_buffer
    # One continuous physical 3 kHz tone, without re-fitting phase after the
    # clock edge. The FIR initially delays output by 65/9600 seconds.
    signal = error = 0
    for k in range(200, len(actual)):
        expected = 10000 * math.sin(2 * math.pi * 3000 * (k / 8000 - 65 / 9600))
        signal += expected ** 2
        error += (actual[k] - expected) ** 2
    assert len(actual) > 1500  # 200 ms, less the FIR tail awaiting future input
    assert 10 * math.log10(signal / error) > 50
    assert bridge._line_service['tx_batches_crossing_retune'] == 1


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


def test_codec_history_records_clock_change_with_unchanged_dividers():
    class Core:
        closed = False
        state = {"registers": [0, 10, 18], "mclk_hz": 3_456_000,
                 "sample_rate": 9_600.0}

        def codec_state(self):
            return self.state

    bridge = CourierDspBridge.__new__(CourierDspBridge)
    bridge.core = Core()
    bridge.line = None
    bridge._instructions = 0
    bridge._codec_registers_seen = None
    bridge._codec_clock_seen = None
    bridge._codec_register_history = []
    bridge._note_codec_registers()
    bridge.core.state.update(mclk_hz=3_696_000, sample_rate=10_266.666)
    bridge._note_codec_registers()
    bridge._note_codec_registers()

    assert [entry["mclk_hz"] for entry in bridge._codec_register_history] == [
        3_456_000, 3_696_000,
    ]


def test_codec_gap_diagnostics_exclude_peer_shutdown():
    from courier_emu.line import CALL_ANSWERED

    class Core:
        closed = False
        state = {'registers': [], 'rx_empty_frames': 100, 'sample_rate': 9600}

        def codec_state(self):
            return self.state

    class Line:
        connected = True
        frames = 300

    bridge = CourierDspBridge.__new__(CourierDspBridge)
    bridge.core, bridge.line = Core(), Line()
    bridge._call_state = CALL_ANSWERED
    bridge._line_service = {}
    bridge._instructions = 0
    bridge._codec_registers_seen = None
    bridge._codec_clock_seen = None
    bridge._codec_register_history = []
    bridge._note_codec_registers()
    bridge.core.state['rx_empty_frames'] += 3
    bridge._note_codec_registers()
    assert bridge._line_service['rx_empty_connected'] == 3
    assert bridge._line_service['rx_gap_events'] == [
        {'line_frame': 300, 'samples': 3, 'codec_rate': 9600}]
    bridge.line.connected = False
    bridge.core.state['rx_empty_frames'] += 960
    bridge._note_codec_registers()
    assert bridge._line_service['rx_empty_connected'] == 3
