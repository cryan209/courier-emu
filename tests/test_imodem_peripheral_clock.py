from types import SimpleNamespace

from courier_emu.peripheral_clock import PeripheralClock
from courier_emu.pit import INSTRUCTIONS_PER_SECOND
from courier_emu.isdn import IsdnMachine
from courier_emu.nac import NacImage


def test_offline_time_ignores_wall_clock_and_live_time_survives_two_calls():
    clock = PeripheralClock(5_000_000)
    assert clock.read(5_000_000, False, now=100) == 5_000_000
    assert clock.read(10_000_000, False, now=1000) == 10_000_000
    assert clock.read(10_000_000, True, now=1000) == 10_000_000
    # A CPU running at one quarter speed must not slow peripheral timers.
    assert clock.read(11_250_000, True, now=1001) == 15_000_000
    assert clock.read(12_500_000, False, now=1002) == 20_000_000
    assert clock.read(13_500_000, False, now=9000) == 21_000_000
    assert clock.read(13_500_000, True, now=9000) == 21_000_000
    assert clock.read(14_750_000, True, now=9001) == 26_000_000


def test_live_timer_poll_and_pit_io_share_wall_clock(monkeypatch):
    now = [100.0]
    monkeypatch.setattr('courier_emu.peripheral_clock.time.monotonic', lambda: now[0])
    machine = IsdnMachine(NacImage.load('Ie030002.nac'))
    machine.with_dsp = True
    machine.bri = SimpleNamespace(
        media_peer=SimpleNamespace(realtime_clock=True), call_state='active',
        service=lambda *args: None)
    machine._advance_dsp = lambda: None
    # Counter 1 is the firmware's 100 Hz clock; load it through normal I/O.
    machine.write_port(0xf043, 0x74)
    machine.write_port(0xf041, 8928 & 255)
    machine.write_port(0xf041, 8928 >> 8)
    machine.poll_timers()
    for _ in range(100):
        now[0] += .01
        machine.instructions += INSTRUCTIONS_PER_SECOND // 400
        machine.poll_timers()
    assert machine.timer_ticks == 100
    assert machine._timer_coalesced_wraps[1] == 99  # Test CPU never acknowledges IRQ10.
    assert machine.pit.status(machine._peripheral_instructions())['counters'][1]['wraps'] == 100
    # Latching and reading the counter must use the same time as IRQ delivery.
    machine.write_port(0xf043, 0x40)
    expected = machine.pit.counters[1].count(machine.pit.ticks(machine._peripheral_instructions()))
    assert machine.read_port(0xf041) | (machine.read_port(0xf041) << 8) == expected
