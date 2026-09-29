from collections import deque

from courier_emu.am79c30 import Am79C30
from courier_emu.imodem_dsp import ImodemDsp
from courier_emu.isdn import IsdnMachine


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
    dsc.blocks[0x41] = bytes((0x13,))
    dsc.queue_bearer(1, bytes(range(32)))
    dsp = ImodemDsp(dsc)
    dsp.core = ClockedCore()

    # Exercise the runtime call path, where a single scheduler pass can owe
    # several serial frames of C51 execution.
    dsp.step_cycles(12_000)

    assert dsp.core.underruns == 0
    assert dsc.bearer_rx_heard[1] == bytes(range(6))
    assert dsp.core.rx == deque((5, 0xff))


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
    machine.rtos_service = False
    machine.serial_pump = None
    machine.channels = {}
    machine._advance_line = lambda: None
    machine.offhook_at = None
    machine.mailbox_service = False
    machine.pit = Pit()

    machine.poll_timers()

    assert calls == ['network', 'dsp']
