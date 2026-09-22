from courier_emu.bridge import CourierDspBridge
from courier_emu.daa import CourierDaa, DAA_FRAME_SAMPLES


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


class LoopCore:
    def __init__(self, pc: int):
        self.pc = pc

    def state(self) -> dict[str, int]:
        return {"pc": self.pc}


def bridge_at(pc: int, started: bool = True):
    bridge = CourierDspBridge.__new__(CourierDspBridge)
    bridge.core = LoopCore(pc)
    bridge._loader_started = started
    return bridge


def test_rom_loader_armed_only_inside_the_mask_rom_download_loop():
    # 0x0642 and 0x064c are where real downloads acknowledge from.
    assert bridge_at(0x0642)._rom_loader_armed()
    assert bridge_at(0x064C)._rom_loader_armed()
    assert bridge_at(0x0638)._rom_loader_armed()
    # The supervisor's bit-walk on port 0x18 lands on 1, 2 and 4 while the
    # C51 is in resident code, or restarted at a mask-ROM vector.
    assert not bridge_at(0x810A)._rom_loader_armed()
    assert not bridge_at(0x0008)._rom_loader_armed()
    # The exit path has left the poll behind.
    assert not bridge_at(0x0653)._rom_loader_armed()
    # Nothing has synchronized the loader yet: the first commit does.
    assert bridge_at(0x0008, started=False)._rom_loader_armed()


class AnsweredLine:
    peer_off_hook = True


def bridge_for_originate(operation: str, *, commanded_role=None):
    bridge = CourierDspBridge.__new__(CourierDspBridge)
    bridge._audio_only = False
    bridge._v8_armed = False
    bridge._call_resume_pending = False
    bridge._call_overlay_active = False
    bridge.line = AnsweredLine()
    bridge.daa = CourierDaa(line_state="quiet")
    bridge.daa.seize(operation)
    bridge.daa.qualified_samples = 5 * DAA_FRAME_SAMPLES
    bridge.boot_rom_enabled = True
    bridge._asic_call_engine_started = False
    bridge._commanded_role = commanded_role
    queued = []
    bridge._queue_runtime_message = lambda tag, word: queued.append((tag, word))
    return bridge, queued


def test_answered_dial_leaves_the_overlay_request_to_the_resident():
    bridge, queued = bridge_for_originate("dialing", commanded_role="originate")

    bridge._maybe_start_originate_engine()

    # 0x47,6 is the resident's own report from its JM decoder (0x8e3e).
    assert queued == []
    assert bridge._v8_armed is True


def test_leased_originate_keeps_its_firmware_overlay_route():
    bridge, queued = bridge_for_originate("originate")

    bridge._maybe_start_originate_engine()

    assert queued == [(0x0002, 0), (0x0003, 0)]


def test_dial_seizure_waits_for_digits_before_requesting_overlay():
    bridge, queued = bridge_for_originate(
        "originate", commanded_role="originate"
    )

    bridge._maybe_start_originate_engine()

    assert queued == []
    assert bridge._v8_armed is False


class DoorbellCore:
    """Enough of the C5x surface for PA7 and the ASIC's interrupt pin."""

    def __init__(self) -> None:
        self.ports: dict[int, int] = {0x57: 0x0000}
        self.irqs: list[int] = []

    def io(self, port: int) -> int:
        return self.ports.get(port, 0)

    def set_io(self, port: int, value: int) -> None:
        self.ports[port] = value & 0xFFFF

    def interrupt(self, irq: int) -> None:
        self.irqs.append(irq)


def test_presenting_a_host_word_raises_pa7_and_rings_int2():
    # One event on the board: the ASIC latches the ready bit in PA7 and its
    # pin 109 - the DSP's INT2 - goes with it. Without the pin the resident
    # only notices on whatever else next ends its IDLE.
    bridge = CourierDspBridge.__new__(CourierDspBridge)
    bridge.core = DoorbellCore()

    bridge._present_to_dsp(0x0200)
    assert bridge.core.io(0x57) == 0x0200
    assert bridge.core.irqs == [1]

    # A second ready bit ORs in rather than replacing the latch, and rings
    # again: the resident's INT2 handler is a bare RETE, so a spurious edge
    # costs a push and a pop.
    bridge._present_to_dsp(0x0002)
    assert bridge.core.io(0x57) == 0x0202
    assert bridge.core.irqs == [1, 1]


def test_cpu_int1_pin_edges_and_reset():
    bridge = CourierDspBridge.__new__(CourierDspBridge)
    bridge.core = DoorbellCore()
    bridge._reset_asserted = False
    bridge.set_cpu_int1(False)
    bridge.set_cpu_int1(True)
    bridge.set_cpu_int1(True)
    assert bridge.core.irqs == [0]
    bridge.set_cpu_int1(False)
    bridge.set_cpu_int1(True)
    assert bridge.core.irqs == [0, 0]
    bridge._reset_asserted = True
    bridge.set_cpu_int1(False)
    bridge.set_cpu_int1(True)
    assert bridge.core.irqs == [0, 0]


def test_overlay_destination_acknowledges_a_same_value_dsp_write():
    import struct
    from courier_emu.dsp import NativeC5x
    from courier_emu.bridge import DSP_COMMAND_PORT
    from types import SimpleNamespace

    # LDP #1fe; SPLK @62,#b000: the guest writes data ff62.
    code = struct.pack('<3H', 0xBDFE, 0xAE62, 0xB000)
    with NativeC5x.from_program(0x6000, code) as core:
        core.set_data(0xFF62, 0xB000)
        core.set_pc(0x6000)
        bridge = CourierDspBridge.__new__(CourierDspBridge)
        bridge.core = core
        bridge.transfer = SimpleNamespace(command_port=0x18)
        bridge.active = True
        bridge._overlay_destination_pending = True
        bridge._overlay_destination_mark = core.data(0xFF62)
        bridge._overlay_destination_write_mark = core.data_write_count(0xFF62)
        bridge._overlay_status = 3
        bridge.overlay_destinations = []
        bridge.overlay_destination_waits = 0
        assert bridge.read(DSP_COMMAND_PORT, 1) == 3
        assert bridge._overlay_destination_pending
        core.step(2)
        assert core.data(0xFF62) == 0xB000
        assert bridge.read(DSP_COMMAND_PORT, 1) == 7
        assert not bridge._overlay_destination_pending
        assert bridge.overlay_destinations == ['b000']
