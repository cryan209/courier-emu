from courier_emu.bridge import CourierDspBridge


class DataCore:
    def __init__(self, flags: int = 0x4042):
        self.flags = flags
        self.writes: list[tuple[int, int]] = []

    def data(self, address: int) -> int:
        assert address == 0x006F
        return self.flags

    def set_data(self, address: int, value: int) -> None:
        self.writes.append((address, value))
        self.flags = value


def bridge_for_assist(*, enabled: bool = True, t1: bool = True):
    bridge = CourierDspBridge.__new__(CourierDspBridge)
    bridge.core = DataCore()
    bridge.rx_acquisition_assist = enabled
    bridge._t1_requested = t1
    bridge._rx_acquisition_assisted = False
    return bridge


def proven_loop() -> dict[str, int]:
    return {
        "line_tx_nonzero": 64,
        "hybrid_frames": 64,
        "drr_reads": 1_000,
        "codec_rx_peak": 0x1000,
    }


def test_t1_acquisition_assist_opens_decision_gate_once():
    bridge = bridge_for_assist()

    bridge._maybe_assist_t1_acquisition(proven_loop())
    bridge._maybe_assist_t1_acquisition(proven_loop())

    assert bridge.core.writes == [(0x006F, 0x404A)]
    assert bridge._rx_acquisition_assisted is True


def test_t1_acquisition_assist_requires_opt_in_and_proven_return():
    disabled = bridge_for_assist(enabled=False)
    disabled._maybe_assist_t1_acquisition(proven_loop())
    assert disabled.core.writes == []

    weak = bridge_for_assist()
    serial = proven_loop()
    serial["codec_rx_peak"] = 0x0FFF
    weak._maybe_assist_t1_acquisition(serial)
    assert weak.core.writes == []
