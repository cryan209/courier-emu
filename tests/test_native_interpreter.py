"""Differential checks against the Python CPU, including native exit edges."""
import random

import pytest
from courier_emu import x86_interpreter as x86


def pair(profile="186eb"):
    cpus = [x86.Uc(0, 0, profile=profile), x86.Uc(0, 0, profile=profile)]
    for cpu, enabled in zip(cpus, (False, True)):
        cpu.native_enabled = enabled
        cpu.mem_map(0, len(cpu.memory))
    return cpus


@pytest.mark.parametrize("profile", ["186eb", "386ex"])
def test_native_randomized_instruction_equivalence(profile):
    rng = random.Random(403)
    slow, fast = pair(profile)
    initial_memory = rng.randbytes(len(slow.memory))
    for cpu in (slow, fast):
        cpu.memory[:] = initial_memory
    opcodes = [op for op in range(0x40) if op & 7 < 6]
    opcodes += list(range(0x40, 0x60)) + list(range(0x70, 0x82))
    opcodes += list(range(0x83, 0x90)) + list(range(0x90, 0xa0))
    opcodes += list(range(0xa0, 0xa6)) + list(range(0xa8, 0xae)) + list(range(0xb0, 0xc2))
    opcodes += [0x60, 0x61, 0x9a, 0xc4, 0xc5, 0xc3, 0xc6, 0xc7, 0xc9, 0xd0, 0xd1, 0xd2, 0xd3,
                0xe0, 0xe1, 0xe2, 0xe3, 0xe8, 0xe9, 0xea, 0xeb,
                0xf6, 0xf7, 0xa6, 0xa7, 0xae, 0xaf, 0xcf, 0xcb,
                0xf5, 0xf8, 0xf9, 0xfa, 0xfb, 0xfc, 0xfd, 0xfe, 0xff]
    for i in range(4000):
        op = rng.choice(opcodes)
        code = bytes([op]) + rng.randbytes(12)
        if i % 7 == 0:
            code = bytes([rng.choice([0x26, 0x2e, 0x36, 0x3e, 0xf2, 0xf3])]) + code
        regs = [rng.randrange(65536) for _ in range(14)]
        regs[x86.UC_X86_REG_CS] = 0
        regs[x86.UC_X86_REG_IP] = 0x1000
        regs[x86.UC_X86_REG_FLAGS] |= 2
        # Memory is shared between iterations, compared in full after each.
        errors = []
        for cpu in (slow, fast):
            cpu.regs[:] = regs
            cpu.memory[0x1000:0x1000+len(code)] = code
            try:
                cpu.emu_start(0x1000, 0, count=1)
                errors.append(None)
            except x86.UcError as exc:
                errors.append(str(exc))
        assert errors[0] == errors[1], code.hex()
        assert slow.regs == fast.regs, (code.hex(), regs, slow.regs, fast.regs)
        assert slow.memory == fast.memory, code.hex()
    assert fast._native.retired > 3000  # exercise the native implementation


@pytest.mark.parametrize("profile", ["186eb", "386ex"])
def test_native_setcc_matches_the_reference(profile):
    # 386 only: the 80186 has no 0x0f escape, and both engines refuse it.
    rng = random.Random(9)
    slow, fast = pair(profile)
    initial_memory = rng.randbytes(len(slow.memory))
    for cpu in (slow, fast):
        cpu.memory[:] = initial_memory
    for i in range(1500):
        code = bytes([0x0F, 0x90 + rng.randrange(16)]) + rng.randbytes(10)
        if i % 5 == 0:
            code = bytes([rng.choice([0x26, 0x2e, 0x36, 0x3e])]) + code
        regs = [rng.randrange(65536) for _ in range(14)]
        regs[x86.UC_X86_REG_CS] = 0
        regs[x86.UC_X86_REG_IP] = 0x1000
        regs[x86.UC_X86_REG_FLAGS] |= 2
        errors = []
        for cpu in (slow, fast):
            cpu.regs[:] = regs
            cpu.memory[0x1000:0x1000+len(code)] = code
            try:
                cpu.emu_start(0x1000, 0, count=1)
                errors.append(None)
            except x86.UcError as exc:
                errors.append(str(exc))
        assert errors[0] == errors[1], code.hex()
        assert slow.regs == fast.regs, (code.hex(), regs, slow.regs, fast.regs)
        assert slow.memory == fast.memory, code.hex()
    if profile == "386ex":
        assert fast._native.retired > 1000


@pytest.mark.parametrize("profile", ["186eb", "386ex"])
def test_native_retires_port_io_before_device_callback(profile):
    slow, fast = pair(profile)
    logs = [[], []]
    code = bytes.fromhex(
        "ba 34 12 b8 cd ab e6 20 e7 21 ee ef e4 22 e5 23 ec ed"
    )
    for cpu, log in zip((slow, fast), logs):
        cpu.memory[0x100:0x100 + len(code)] = code

        def on_out(_cpu, port, size, value, events):
            events.append(("out", port, size, value))

        def on_in(_cpu, port, size, events):
            events.append(("in", port, size))
            return (port ^ 0x5A5A) & ((1 << (size * 8)) - 1)

        cpu.hook_add(x86.UC_HOOK_INSN, on_out, log, 1, 0, x86.UC_X86_INS_OUT)
        cpu.hook_add(x86.UC_HOOK_INSN, on_in, log, 1, 0, x86.UC_X86_INS_IN)
        cpu.emu_start(0x100, 0, count=10)

    assert logs[0] == logs[1]
    assert slow.regs == fast.regs
    assert fast._native.retired == 10


def test_native_batches_timing_inert_output_ports_in_order():
    slow, fast = pair("386ex")
    logs = [[], []]
    code = bytes.fromhex("b0 7a e6 40 e6 42 e6 44 e6 20")
    for cpu, log in zip((slow, fast), logs):
        cpu.memory[0x100:0x100 + len(code)] = code

        def flush(events, count, output=log):
            for offset in range(0, count * 4, 4):
                output.append((
                    events[offset] | events[offset + 1] << 8,
                    events[offset + 2] | events[offset + 3] << 8,
                ))

        def on_out(_cpu, port, _size, value, output):
            output.append((port, value))

        if cpu.native_enabled:
            cpu.native_out_batch_add((0x40, 0x42, 0x44), flush)
        cpu.hook_add(x86.UC_HOOK_INSN, on_out, log, 1, 0, x86.UC_X86_INS_OUT)
        cpu.emu_start(0x100, 0, count=5)

    assert logs[0] == logs[1] == [
        (0x40, 0x7A), (0x42, 0x7A), (0x44, 0x7A), (0x20, 0x7A)
    ]
    assert fast._native.retired == 5


def test_native_interrupt_entry_pushes_real_mode_frame():
    from courier_emu.x86_native import NativeInterpreter

    cpu = x86.Uc(0, 0, profile="386ex")
    cpu.mem_map(0, len(cpu.memory))
    cpu.regs[x86.UC_X86_REG_CS] = 0x1234
    cpu.regs[x86.UC_X86_REG_IP] = 0x5678
    cpu.regs[x86.UC_X86_REG_SS] = 0x0200
    cpu.regs[x86.UC_X86_REG_SP] = 0x0100
    cpu.regs[x86.UC_X86_REG_FLAGS] = 0x0302
    cpu.memory[0x84:0x88] = bytes.fromhex("bc 9a f0 de")

    native = NativeInterpreter(cpu)
    assert native.inject_interrupt(cpu, 0x21)

    assert cpu.regs[x86.UC_X86_REG_CS] == 0xDEF0
    assert cpu.regs[x86.UC_X86_REG_IP] == 0x9ABC
    assert cpu.regs[x86.UC_X86_REG_SP] == 0x00FA
    assert not cpu.regs[x86.UC_X86_REG_FLAGS] & 0x0300
    stack = cpu.memory[0x2000 + 0xFA:0x2000 + 0x100]
    assert stack == bytes.fromhex("78 56 34 12 02 03")


def test_native_interrupt_rejects_an_undersized_vector_table():
    from courier_emu.x86_native import NativeInterpreter

    cpu = x86.Uc(0, 0, profile="386ex")
    cpu.memory = bytearray(32)
    native = NativeInterpreter(cpu)

    with pytest.raises(ValueError, match="invalid native interrupt state"):
        native.inject_interrupt(cpu, 0x21)


@pytest.mark.parametrize("kind", [x86.UC_HOOK_MEM_READ, x86.UC_HOOK_MEM_WRITE])
def test_watched_string_instruction_falls_back_without_partial_effects(kind):
    slow, fast = pair()
    events = [[], []]
    for cpu, log in zip((slow, fast), events):
        cpu.memory[0x100:0x103] = b"\xf3\xa5\x90"
        cpu.memory[0x300:0x308] = b"abcdefgh"
        cpu.regs[x86.UC_X86_REG_SI] = 0x300
        cpu.regs[x86.UC_X86_REG_DI] = 0x400
        cpu.regs[x86.UC_X86_REG_CX] = 4
        address = 0x304 if kind == x86.UC_HOOK_MEM_READ else 0x404
        cpu.hook_add(kind, lambda u, k, a, s, v, data: data.append((a, s, v, u.regs.copy())), log, address, address)
        cpu.emu_start(0x100, 0, count=6)
    assert events[0] == events[1]
    assert slow.regs == fast.regs
    assert slow.memory == fast.memory


def test_native_stops_at_hook_and_clock_and_observes_code_writes():
    slow, fast = pair()
    logs = [[], []]
    for cpu, log in zip((slow, fast), logs):
        cpu.memory[0x100:0x109] = b"\xb0\x40\xa2\x08\x01\x90\x90\x90\x90"
        cpu.hook_add(x86.UC_HOOK_CODE, lambda u, a, s, d: d.append((a, u.retired)), log, 0x106, 0x106)
        cpu.instruction_clock_add(4, lambda u, n, d: d.append(("clock", n)), log)
        cpu.emu_start(0x100, 0, count=6)
    assert logs[0] == logs[1]
    assert slow.regs == fast.regs
    assert fast.regs[x86.UC_X86_REG_AX] == 0x41
    assert slow.retired == fast.retired == 6


def test_mapping_fault_restores_native_state_before_python_fallback():
    for enabled in (False, True):
        cpu = x86.Uc(0, 0)
        cpu.native_enabled = enabled
        cpu.mem_map(0, 4096)
        cpu.memory[0x100:0x104] = b"\x50\x90\x90\x90"
        cpu.regs[x86.UC_X86_REG_SP] = 0x2000
        with pytest.raises(x86.UcError, match="unmapped write"):
            cpu.emu_start(0x100, 0, count=1)
        # Exactly one failed PUSH, whose pre-store SP update is observable.
        assert cpu.regs[x86.UC_X86_REG_SP] == 0x1ffe
        assert cpu.retired == 0


@pytest.mark.parametrize("code", [
    "66 b8 78 56 34 12 66 89 c3 66 89 1e 00 04 66 8b 16 00 04",
    "66 b8 78 56 34 12 b9 03 00 bf 00 04 f3 66 ab",
    "66 b8 78 56 34 12 b0 ff 89 c3 31 c0",
    "b8 00 80 b1 01 d3 e0 31 c0",
])
def test_386_extended_registers_and_operand_prefixes(code):
    slow, fast = pair("386ex")
    for cpu in (slow, fast):
        payload = bytes.fromhex(code)
        cpu.memory[0x100:0x100+len(payload)] = payload
        # Compare one retirement at a time, including every REP iteration.
    for _ in range(12):
        for cpu in (slow, fast):
            pc = cpu._physical(cpu.regs[x86.UC_X86_REG_CS], cpu.regs[x86.UC_X86_REG_IP])
            cpu.emu_start(0x100 if cpu.retired == 0 else pc, 0, count=1)
        assert slow.regs == fast.regs
        assert slow.memory == fast.memory
    assert fast._native.retired > 0


def test_386_native_fetch_above_one_megabyte():
    slow, fast = pair("386ex")
    for cpu in (slow, fast):
        cpu.regs[x86.UC_X86_REG_CS] = 0xffff
        cpu.regs[x86.UC_X86_REG_IP] = 0x30
        cpu.memory[0x100020:0x100024] = bytes.fromhex("b8 34 12 90")
        cpu.emu_start(0x100020, 0, count=2)
    assert slow.regs == fast.regs
    assert fast.regs[x86.UC_X86_REG_AX] == 0x1234
    assert fast._native.retired == 2


def test_deferred_write_is_applied_before_next_native_instruction():
    slow, fast = pair("386ex")
    for cpu in (slow, fast):
        cpu.memory[0x100:0x10a] = bytes.fromhex("c6 06 00 04 90 a0 00 04 90 90")
        def write_hook(uc, *_):
            uc._after_instruction = lambda: uc.memory.__setitem__(0x400, 0x42)
        cpu.hook_add(x86.UC_HOOK_MEM_WRITE, write_hook, None, 0x400, 0x400)
        cpu.emu_start(0x100, 0, count=2)
    assert slow.regs == fast.regs
    assert fast.regs[x86.UC_X86_REG_AX] == 0x42
    assert fast._native.retired == 1


@pytest.mark.parametrize("profile", ["186eb", "386ex"])
def test_pusha_watchpoint_rolls_back_all_native_stores(profile):
    slow, fast = pair(profile)
    logs = [[], []]
    for cpu, log in zip((slow, fast), logs):
        cpu.regs[:8] = [1, 2, 3, 4, 0x800, 6, 7, 8]
        cpu.memory[0x100] = 0x60
        cpu.hook_add(x86.UC_HOOK_MEM_WRITE,
                     lambda u, k, a, s, v, d: d.append((a, v, u.regs.copy(), bytes(u.memory[0x7f0:0x800]))),
                     log, 0x7f4, 0x7f4)
        cpu.emu_start(0x100, 0, count=1)
    assert logs[0] == logs[1]
    assert slow.regs == fast.regs
    assert slow.memory == fast.memory


def _enter_vector(cpu, number):
    """What the harness's INT hook does for a populated vector (isdn.push_far)."""
    entry = cpu.memory[number * 4:number * 4 + 4]
    offset, segment = entry[0] | entry[1] << 8, entry[2] | entry[3] << 8
    if not offset and not segment:
        return False
    regs = cpu.regs
    flags = regs[x86.UC_X86_REG_FLAGS] & 0xFFFF
    for value in (flags, regs[x86.UC_X86_REG_CS], regs[x86.UC_X86_REG_IP]):
        regs[x86.UC_X86_REG_SP] = (regs[x86.UC_X86_REG_SP] - 2) & 0xFFFF
        address = regs[x86.UC_X86_REG_SS] * 16 + regs[x86.UC_X86_REG_SP]
        cpu.memory[address:address + 2] = value.to_bytes(2, "little")
    regs[x86.UC_X86_REG_FLAGS] = flags & ~0x0300
    regs[x86.UC_X86_REG_CS], regs[x86.UC_X86_REG_IP] = segment, offset
    return True


@pytest.mark.parametrize("profile", ["186eb", "386ex"])
def test_native_software_interrupt_matches_the_harness_hook(profile):
    slow, fast = pair(profile)
    seen = [[], []]
    # int 30h twice through a populated vector, then int 31h through a null
    # one, which the native engine must leave to the hook.
    program = bytes.fromhex("b8 05 00 cd 30 cd 30 fb cd 31 90")
    handler = bytes.fromhex("40 cf")  # inc ax; iret
    for cpu, log in zip((slow, fast), seen):
        cpu.memory[0x100:0x100 + len(program)] = program
        cpu.memory[0x2000:0x2000 + len(handler)] = handler
        cpu.memory[0x30 * 4:0x30 * 4 + 4] = (0x0000).to_bytes(2, "little") + (0x200).to_bytes(2, "little")
        cpu.regs[x86.UC_X86_REG_CS] = 0
        cpu.regs[x86.UC_X86_REG_SS] = 0
        cpu.regs[x86.UC_X86_REG_SP] = 0x8000
        cpu.regs[x86.UC_X86_REG_IP] = 0x100
        cpu.regs[x86.UC_X86_REG_FLAGS] = 0x202

        def on_interrupt(uc, number, log):
            log.append(number)
            if not _enter_vector(uc, number):
                uc.emu_stop()

        cpu.hook_add(x86.UC_HOOK_INTR, on_interrupt, log)
    fast.native_int_mode = bytearray(b"\x03" * 256)
    for cpu in (slow, fast):
        cpu.emu_start(0x100, 0, count=40)
    assert slow.regs == fast.regs
    assert slow.memory == fast.memory
    # Only the null vector reaches the hook on the native engine.
    assert seen[0] == [0x30, 0x30, 0x31]
    assert seen[1] == [0x31]
    assert fast._native.take_interrupt_counts() == {0x30: 2}
    assert fast._native.take_interrupt_counts() == {}
