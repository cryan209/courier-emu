"""Real firmware regressions for native execution and scheduler boundaries."""
from pathlib import Path

import pytest

ROOT = Path(__file__).resolve().parents[1]


def firmware(name):
    path = ROOT / name
    if not path.exists():
        pytest.skip(f"optional local firmware {name} is unavailable")
    from courier_emu.images import load_image
    return load_image(path)


def test_isdn_clock_matches_instruction_hooks():
    from courier_emu.isdn import IsdnMachine
    machines = [IsdnMachine(firmware("Ie030002.nac"), profile=p) for p in (True, False)]
    results = [m.run(2_000_000) for m in machines]
    slow, fast = machines
    assert results[0].status == results[1].status == "instruction-limit"
    assert slow.uc.regs == fast.uc.regs
    assert slow.uc.memory == fast.uc.memory
    assert slow.hardware_interrupts == fast.hardware_interrupts > 0
    assert slow.software_interrupts == fast.software_interrupts
    assert slow.io_counts == fast.io_counts
    assert slow.flash.contents == fast.flash.contents
    assert slow.instructions == fast.instructions == 2_000_000
    assert fast.uc._native.retired > 1_800_000
    assert slow.uc._native is None


class Console:
    poll_instructions = 8192
    closed = False

    def __init__(self):
        self.polls = 0

    def poll(self, limit=4096):
        self.polls += 1
        self.closed = self.polls == 5
        return b"AT\r" if self.polls == 1 else b""

    def write(self, value):
        pass

    def summary(self):
        return {"polls": self.polls}

    def close(self):
        self.closed = True


def test_rom_console_polls_and_closes_without_global_hook():
    from courier_emu.machine import CourierMachine
    console = Console()
    machine = CourierMachine(firmware("IDSDL302.ROM"), console=console)
    assert not machine._needs_code_hook()
    machine.run(1_000_000)
    assert console.polls == 5
    assert machine.stop_requested
    assert machine.uc._native.retired > 0
    assert machine.instructions < 1_000_000


def test_payload_console_retains_required_history():
    from courier_emu.machine import CourierMachine
    machine = CourierMachine(firmware("main211.xmf"), console=Console())
    assert machine._needs_code_hook()
