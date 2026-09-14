from courier_emu import x86_interpreter as x86


def _cpu(code: bytes):
    cpu = x86.Uc(0, 0, profile="186eb")
    cpu.mem_map(0, 0x1000)
    cpu.mem_write(0, code)
    return cpu


def test_instruction_clock_calls_at_bounded_intervals():
    cpu = _cpu(b"\x90" * 12)
    calls = []
    cpu.instruction_clock_add(4, lambda _cpu, total, _user: calls.append(total))

    cpu.emu_start(0, 0, count=10)

    assert calls == [4, 8]
    assert cpu.retired == 10


def test_instruction_clock_can_stop_before_boundary_instruction():
    cpu = _cpu(b"\x90" * 12)

    def stop(cpu, _total, _user):
        cpu.emu_stop()

    cpu.instruction_clock_add(4, stop)
    cpu.emu_start(0, 0, count=10)

    assert cpu.retired == 3
    assert cpu.reg_read(x86.UC_X86_REG_IP) == 3
