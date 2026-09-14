"""The CPU's own faults, and the line between a fault and a gap in the model.

The 80C186EB manual is explicit that executing an undefined opcode traps
(Type 6, Invalid Opcode) and that ESC either faults to Type 7 or goes out to
an 80C187 depending on RELREG's ET bit. Both are hardware responses with
firmware handlers behind them, so they are modelled. An opcode this
interpreter has simply not got yet is a different thing and has to stay loud.
"""
import pytest

from courier_emu import x86_interpreter as x86


def _cpu(code: bytes, profile: str = "186eb") -> x86.Uc:
    cpu = x86.Uc(0, 0, profile=profile)
    cpu.mem_map(0, 0x2000, 7)
    cpu.mem_write(0x100, code)
    cpu.reg_write(x86.UC_X86_REG_CS, 0)
    cpu.reg_write(x86.UC_X86_REG_IP, 0x100)
    cpu.reg_write(x86.UC_X86_REG_SS, 0)
    cpu.reg_write(x86.UC_X86_REG_SP, 0x800)
    return cpu


def _first_vector(cpu: x86.Uc) -> tuple[int, int]:
    seen: list[tuple[int, int]] = []

    def hook(uc, number, _user):
        seen.append((number, uc.regs[x86.UC_X86_REG_IP]))
        uc.emu_stop()

    cpu.hook_add(x86.UC_HOOK_INTR, hook)
    cpu.emu_start(0x100, 0, count=8)
    return seen[0] if seen else (-1, -1)


# 0f is the two-byte escape from the 286, 63 is ARPL, 64-67 are the 386's
# segment and size prefixes, and d6 and f1 are undocumented throughout.
@pytest.mark.parametrize("opcode", (0x0F, 0x63, 0x64, 0x65, 0x66, 0x67, 0xD6, 0xF1))
def test_undefined_opcode_takes_the_type_6_trap(opcode):
    cpu = _cpu(b"\x90" + bytes([opcode]) + b"\x90")
    vector, ip = _first_vector(cpu)
    assert vector == x86.INVALID_OPCODE_VECTOR
    # A trap restarts the faulting instruction, so it reports the opcode's own
    # address rather than the one after it.
    assert ip == 0x101


def test_the_386_profile_keeps_its_prefixes_and_escape():
    for opcode in (0x0F, 0x64, 0x65, 0x66):
        assert opcode not in x86._UNDEFINED_OPCODES["386ex"]


def test_escape_runs_its_operand_cycle_when_the_trap_bit_is_clear():
    # ET resets to zero, so ESC goes to the coprocessor. There is no 80C187
    # on this board, so the operand cycle happens and execution carries on.
    cpu = _cpu(b"\xdb\x06\x50\x00\x90")  # esc 3,[0x0050] ; nop
    reads = []
    cpu.hook_add(x86.UC_HOOK_MEM_READ,
                 lambda _u, _a, address, _s, _v, _d: reads.append(address))
    cpu.emu_start(0x100, 0, count=2)
    assert reads[:1] == [0x0050]
    assert cpu.regs[x86.UC_X86_REG_IP] == 0x105


def test_escape_faults_to_type_7_when_the_trap_bit_is_set():
    cpu = _cpu(b"\xdb\x06\x50\x00")
    cpu.escape_trap = True
    vector, ip = _first_vector(cpu)
    assert vector == x86.ESCAPE_OPCODE_VECTOR
    assert ip == 0x100


# BOUND and the string I/O instructions are 80186 additions the interpreter
# has not got yet. They must raise rather than be swallowed by the trap: a
# gap in the model is not a fault in the guest.
@pytest.mark.parametrize("opcode", (0x62, 0x6C, 0x6D, 0x6E, 0x6F))
def test_a_missing_but_defined_instruction_still_raises(opcode):
    cpu = _cpu(bytes([opcode, 0x00, 0x00]))
    with pytest.raises(x86.UcError, match=f"unsupported opcode {opcode:02x}"):
        cpu.emu_start(0x100, 0, count=1)


def test_sahf_and_lahf_round_trip():
    cpu = _cpu(b"\x9e")
    cpu.reg_write(x86.UC_X86_REG_AX, 0xD700)
    cpu.emu_start(0x100, 0, count=1)
    mask = x86.CF | x86.PF | x86.AF | x86.ZF | x86.SF
    assert cpu.regs[x86.UC_X86_REG_FLAGS] & 0xFF == (0xD7 & mask) | 2

    cpu = _cpu(b"\x9f")
    cpu.regs[x86.UC_X86_REG_FLAGS] = 0x00C5
    cpu.emu_start(0x100, 0, count=1)
    assert (cpu.regs[x86.UC_X86_REG_AX] >> 8) & 0xFF == 0xC7


def test_82_is_the_documented_alias_of_80():
    cpu = _cpu(b"\x82\xc3\x05")  # add bl,5
    cpu.reg_write(x86.UC_X86_REG_BX, 0x0010)
    cpu.emu_start(0x100, 0, count=1)
    assert cpu.regs[x86.UC_X86_REG_BX] == 0x0015


def test_unpacked_and_packed_bcd_adjusts():
    cpu = _cpu(b"\x37")  # AAA
    cpu.reg_write(x86.UC_X86_REG_AX, 0x000F)
    cpu.emu_start(0x100, 0, count=1)
    assert cpu.regs[x86.UC_X86_REG_AX] == 0x0105

    cpu = _cpu(b"\x3f")  # AAS
    cpu.reg_write(x86.UC_X86_REG_AX, 0x000F)
    cpu.emu_start(0x100, 0, count=1)
    assert cpu.regs[x86.UC_X86_REG_AX] == 0xFF09

    cpu = _cpu(b"\x2f")  # DAS
    cpu.reg_write(x86.UC_X86_REG_AX, 0x00FF)
    cpu.emu_start(0x100, 0, count=1)
    assert cpu.regs[x86.UC_X86_REG_AX] & 0xFF == 0x99


def test_int3_and_into():
    assert _first_vector(_cpu(b"\xcc"))[0] == 3

    cpu = _cpu(b"\xce")
    cpu.regs[x86.UC_X86_REG_FLAGS] |= x86.OF
    assert _first_vector(cpu)[0] == 4

    # With OF clear INTO falls through without vectoring.
    assert _first_vector(_cpu(b"\xce\x90"))[0] == -1


def test_wait_retires_with_no_coprocessor_attached():
    cpu = _cpu(b"\x9b\x90")
    cpu.emu_start(0x100, 0, count=2)
    assert cpu.regs[x86.UC_X86_REG_IP] == 0x102
