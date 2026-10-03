from collections import deque
import struct

import pytest

from courier_emu.am79c30 import Am79C30
from courier_emu.imodem_dsp import ImodemDsp
from courier_emu.isdn import IsdnMachine
from courier_emu.dsp import NativeC5x


class ClockedCore:
    """Serial frames consume RX inside step, before their TX reaches Python."""

    def __init__(self):
        self.cycles = 0
        self.instructions = 0
        self.rx = deque((0xff, 0xff))
        self.tx = bytearray()
        self.underruns = 0

    def step(self, count):
        for _ in range(count):
            self.instructions += 1
            self.cycles += 1
            if self.cycles % 2000 == 0:
                for _ in range(2):
                    if self.rx:
                        self.rx.popleft()
                    else:
                        self.underruns += 1
                self.tx.extend((0xff, 0xff))

    def state(self):
        return {'cycles': self.cycles, 'instructions': self.instructions}

    def io(self, port):
        return 3

    def g711_tx(self, start):
        return bytes(self.tx[start:])

    def queue_g711_rx(self, octets):
        self.rx.extend(octets)


def test_clocked_b1_receive_is_returned_before_next_serial_frame():
    dsc = Am79C30()
    dsc.activate()
    dsc.blocks[0x41] = bytes((0x16,))
    dsc.queue_bearer(1, bytes(range(32)))
    dsp = ImodemDsp(dsc)
    dsp.core = ClockedCore()

    # Exercise the runtime call path, where a single scheduler pass can owe
    # several serial frames of C51 execution.
    dsp.step_cycles(12_000)

    assert dsp.core.underruns == 0
    assert dsc.bearer_rx_heard[1] == bytes(range(6))
    assert dsp.core.rx == deque((5, 0xff))


@pytest.mark.parametrize('realtime', [False, True])
def test_native_fast_path_returns_receive_word_between_pcm_frames(realtime):
    dsc = Am79C30()
    dsc.activate()
    dsc.blocks[0x41] = bytes((0x16,))
    dsc.queue_bearer(1, bytes(range(32)))
    dsp = ImodemDsp(dsc)
    with NativeC5x.from_program(0x8000, struct.pack('<H', 0xBE22),
                                rebuild=True) as core:
        dsp.core = core
        core.set_pc(0x8000)
        core.configure_digital_pcm(clock_hz=40_320_000)
        core.configure_line_frame_interrupt(5, 0xFFFF)
        core.queue_g711_rx(bytes((0xff, 0xff)))
        if realtime:
            dsp.pace_realtime(True, now=0)
            dsp.pace_realtime(True, now=20_000 / 40_320_000)
        else:
            dsp.step_cycles(20_000)
        assert core.g711_rx_underruns() == 0
        assert dsc.bearer_rx_heard[1] == bytes(range(3))
        assert core.g711_rx_pending() == 2
        assert core.state()['cycles'] >= 20_000


def test_realtime_catchup_services_network_between_mux_frames():
    dsc = Am79C30()
    dsc.activate()
    dsc.blocks[0x41] = bytes((0x16,))
    dsc.queue_bearer(1, b'\x00')
    dsp = ImodemDsp(dsc)
    received = iter(range(1, 32))
    services = []

    def service_frame():
        services.append(dsc.bearer_frames)
        dsc.queue_bearer(1, bytes((next(received),)))

    dsp.pcm_frame_service = service_frame
    with NativeC5x.from_program(0x8000, struct.pack('<H', 0xBE22)) as core:
        dsp.core = core
        core.set_pc(0x8000)
        core.configure_digital_pcm(clock_hz=40_320_000)
        core.configure_line_frame_interrupt(5, 0xFFFF)
        core.queue_g711_rx(bytes((0xff, 0xff)))
        dsp.pace_realtime(True, now=0)
        dsp.pace_realtime(True, now=20_000 / 40_320_000)
        assert services == [1, 2, 3]
        assert dsc.bearer_rx_heard[1] == bytes(range(3))
        assert dsc.bearer_underruns[1] == 0
        assert core.g711_rx_underruns() == 0


def test_digital_pcm_words_do_not_request_analogue_codec_readback():
    # These are legal G.711 slot words. On an AC01, FFFF requests a secondary
    # frame and 25FF reads register 5. The I-modem has no AC01 on this port.
    guest = struct.pack('<7H', 0xAE21, 0xFFFF, 0xAE21, 0x25FF,
                        0x0820, 0x8B00, 0x8B00)
    with NativeC5x.from_program(0x8000, guest, rebuild=True) as core:
        core.configure_digital_pcm(clock_hz=40_320_000)
        core.configure_line_frame_interrupt(5, 0xFFFF)
        core.queue_g711_rx(b'\xb1\xff')
        dsp = ImodemDsp()
        dsp.core = core
        dsp.step_cycles(5040)
        assert core.register(0x20) == 0xB1FF
        core.set_pc(0x8000)
        core.step(2)  # Write the two control-looking digital words.
        assert core.register(0x20) == 0xB1FF
        core.step(1)  # Guest LAMM @DRR, rather than a diagnostic register peek.
        assert core.state()['acc'] == 0xB1FF
        assert core.register(0x20) == 0xB1FF


def test_timer_pass_delivers_network_octets_before_dsp_clock():
    machine = IsdnMachine.__new__(IsdnMachine)
    calls = []

    class Peer:
        def service(self, dsc, instructions):
            calls.append('network')

    class Chip:
        def interrupting(self):
            return False

    class Pit:
        counters = ()

    machine.bri = Peer()
    machine.dsc = Chip()
    machine.instructions = 512
    machine._advance_dsp = lambda: calls.append('dsp')
    machine._peripheral_instructions = lambda: machine.instructions
    machine.rtos_service = False
    machine.serial_pump = None
    machine.channels = {}
    machine._advance_line = lambda: None
    machine.offhook_at = None
    machine.mailbox_service = False
    machine.pit = Pit()

    machine.poll_timers()

    assert calls == ['network', 'dsp']


def test_live_dsp_catchup_yields_to_supervisor_without_discarding_cycles(monkeypatch):
    wall = [0.0]

    class SlowCore:
        cycles = 0

        def state(self):
            return {'cycles': self.cycles}

        def step_cycles(self, count):
            raise AssertionError('optimized PCM path must be used')

        def advance_imodem(self, count, cursor):
            self.cycles += 5040
            wall[0] += .002
            return (1, 5040, 2, 0, 0, 0, b'')

    monkeypatch.setattr('courier_emu.imodem_dsp.time.monotonic', lambda: wall[0])
    dsp = ImodemDsp()
    dsp.core = SlowCore()
    dsp.pace_realtime(True, now=0)
    dsp.pace_realtime(True, now=.001, max_wall_seconds=.001)
    assert dsp.core.cycles == 5040  # Supervisor gets control before full catch-up.
    dsp.pace_realtime(True, now=.001, max_wall_seconds=.001)
    assert dsp.core.cycles == 10080
    # The remaining original target can still be reached; no time was erased.
    dsp.pace_realtime(True, now=.001)
    assert dsp.core.cycles >= 40320
    assert dsp.realtime_cycles == dsp.core.cycles


@pytest.mark.parametrize('realtime', [False, True])
def test_native_bri_bearer_preserves_all_g711_codewords_and_slot_order(realtime):
    dsc = Am79C30()
    dsc.activate()
    dsc.blocks[0x41] = bytes((0x16,))  # B1 <-> Bd, first peripheral slot.
    received = bytes(range(256)) + b'\xff'
    dsc.queue_bearer(1, received)
    dsp = ImodemDsp(dsc)
    # Guest instructions load DXR directly; this exercises the serial port,
    # native frame clock and programmed DSC MUX, without a modem algorithm.
    guest = struct.pack('<3H', 0x1060, 0x8821, 0xBE22)
    with NativeC5x.from_program(0x8000, guest) as core:
        dsp.core = core
        core.configure_digital_pcm(clock_hz=40_320_000)
        core.configure_line_frame_interrupt(5, 0xFFFF)
        core.queue_g711_rx(b'\xff\xff')
        if realtime:
            dsp.pace_realtime(True, now=0)
        observed = bytearray()
        for frame in range(257):
            core.set_data(0x60, ((frame & 255) << 8) | 0x5A)
            core.set_pc(0x8000)
            core.step(3)
            boundary = core.codec_state()['line_frame_next_cycle']
            if realtime:
                # Observe just after the edge: representing an exact cycle
                # as floating-point seconds can round below that cycle.
                dsp.pace_realtime(True, now=(boundary + 0.5) / 40_320_000)
            else:
                dsp.step_cycles(boundary - core.state()['cycles'])
            word = core.register(0x20)
            observed.append(word >> 8)
            assert word & 255 == 0xFF  # Unrouted second slot stays idle.
        assert observed == b'\xff' + bytes(range(256))
        assert dsc.bearer_tx[1] == bytes(range(256)) + b'\x00'
        assert dsc.bearer_rx_heard[1] == received
        assert core.g711_rx_underruns() == 0
        assert dsc.bearer_underruns[1] == 0
