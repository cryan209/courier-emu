"""Small, deterministic real-mode x86 interpreter with Unicorn-like hooks.

The board harnesses historically expose Unicorn directly to their peripheral
callbacks.  This module deliberately implements that narrow API so the CPU can
be replaced without duplicating any 80186EB or 386EX device models.
"""

from __future__ import annotations

from dataclasses import dataclass
from typing import Any, Callable

UC_ARCH_X86 = 1
UC_MODE_16 = 2
UC_PROT_READ, UC_PROT_WRITE, UC_PROT_EXEC = 1, 2, 4
UC_HOOK_CODE, UC_HOOK_BLOCK = 1, 2
UC_HOOK_INSN, UC_HOOK_INTR = 4, 8
UC_HOOK_MEM_READ, UC_HOOK_MEM_WRITE, UC_HOOK_MEM_INVALID = 16, 32, 64
UC_X86_INS_IN, UC_X86_INS_OUT = 1, 2

(
    UC_X86_REG_AX, UC_X86_REG_CX, UC_X86_REG_DX, UC_X86_REG_BX,
    UC_X86_REG_SP, UC_X86_REG_BP, UC_X86_REG_SI, UC_X86_REG_DI,
    UC_X86_REG_ES, UC_X86_REG_CS, UC_X86_REG_SS, UC_X86_REG_DS,
    UC_X86_REG_IP, UC_X86_REG_FLAGS,
) = range(14)

CF, PF, AF, ZF, SF, TF, IF, DF, OF = (
    0x0001, 0x0004, 0x0010, 0x0040, 0x0080,
    0x0100, 0x0200, 0x0400, 0x0800,
)


# Prefix bytes, as a 256-entry lookup rather than a tuple membership test:
# the dispatch loop asks this of every instruction it decodes.
_PREFIXES = (0x26, 0x2E, 0x36, 0x3E, 0x66, 0x67, 0xF0, 0xF2, 0xF3)
_IS_PREFIX: tuple[bool, ...] = tuple(byte in _PREFIXES for byte in range(256))
# Even parity of the low byte, the only form the flag word wants it in.
_PARITY: tuple[bool, ...] = tuple(byte.bit_count() % 2 == 0 for byte in range(256))


# Dispatch groups. Walking a chain of opcode comparisons is the one thing
# every instruction does before it does anything useful, and the chain's
# later entries cost hundreds of nanoseconds to reach - more than most
# instruction bodies. Each opcode is mapped through this table to the small
# integer its body is labelled with instead, so the chain below compares
# integers, and the groups are numbered in descending order of how often a
# profiled boot reaches them. Group 0 is an unimplemented opcode.
_GROUP_OPCODES: tuple[tuple[int, ...], ...] = (
    (),
    (0xA4, 0xA5, 0xAA, 0xAB, 0xAC, 0xAD),  # 1: MOVS/STOS/LODS
    (0x88, 0x89, 0x8A, 0x8B),  # 2: MOV r/m,r and r,r/m
    (0xB0, 0xB1, 0xB2, 0xB3, 0xB4, 0xB5, 0xB6, 0xB7),  # 3: MOV r8,imm8
    (0x00, 0x01, 0x02, 0x03, 0x08, 0x09, 0x0A, 0x0B, 0x10, 0x11, 0x12, 0x13, 0x18, 0x19, 0x1A, 0x1B, 0x20, 0x21, 0x22, 0x23, 0x28, 0x29, 0x2A, 0x2B, 0x30, 0x31, 0x32, 0x33, 0x38, 0x39, 0x3A, 0x3B),  # 4: ALU r/m,r and r,r/m
    (0xC0, 0xC1, 0xD0, 0xD1, 0xD2, 0xD3),  # 5: shift/rotate r/m
    (0x86, 0x87),  # 6: XCHG r/m,r
    (0xE0, 0xE1, 0xE2, 0xE3),  # 7: LOOP/LOOPE/LOOPNE/JCXZ
    (0xB8, 0xB9, 0xBA, 0xBB, 0xBC, 0xBD, 0xBE, 0xBF),  # 8: MOV r16,imm
    (0x8C, 0x8E),  # 9: MOV to and from a segment register
    (0x40, 0x41, 0x42, 0x43, 0x44, 0x45, 0x46, 0x47),  # 10: INC r16
    (0x70, 0x71, 0x72, 0x73, 0x74, 0x75, 0x76, 0x77, 0x78, 0x79, 0x7A, 0x7B, 0x7C, 0x7D, 0x7E, 0x7F),  # 11: Jcc rel8
    (0x48, 0x49, 0x4A, 0x4B, 0x4C, 0x4D, 0x4E, 0x4F),  # 12: DEC r16
    (0x50, 0x51, 0x52, 0x53, 0x54, 0x55, 0x56, 0x57),  # 13: PUSH r16
    (0x58, 0x59, 0x5A, 0x5B, 0x5C, 0x5D, 0x5E, 0x5F),  # 14: POP r16
    (0xFC,),  # 15: CLD
    (0xF6, 0xF7),  # 16: group F6/F7: TEST/NOT/NEG/MUL/DIV
    (0x90, 0x91, 0x92, 0x93, 0x94, 0x95, 0x96, 0x97),  # 17: XCHG AX,r16 (0x90 is NOP)
    (0x80, 0x81, 0x83),  # 18: ALU r/m,imm
    (0xC2, 0xC3),  # 19: RET near
    (0xE8,),  # 20: CALL rel16
    (0xEB,),  # 21: JMP rel8
    (0xE9,),  # 22: JMP rel16
    (0xFF,),  # 23: group FF: INC/DEC/CALL/JMP/PUSH r/m
    (0xF8,),  # 24: CLC
    (0xE4, 0xE5, 0xEC, 0xED),  # 25: IN
    (0xE6, 0xE7, 0xEE, 0xEF),  # 26: OUT
    (0xCD,),  # 27: INT imm8
    (0xCF,),  # 28: IRET
    (0xFA,),  # 29: CLI
    (0xFB,),  # 30: STI
    (0xA0, 0xA1, 0xA2, 0xA3),  # 31: MOV accumulator to and from a direct address
    (0xC6, 0xC7),  # 32: MOV r/m,imm
    (0x04, 0x05, 0x0C, 0x0D, 0x14, 0x15, 0x1C, 0x1D, 0x24, 0x25, 0x2C, 0x2D, 0x34, 0x35, 0x3C, 0x3D),  # 33: ALU accumulator,imm
    (0x68,),  # 34: PUSH imm16
    (0x6A,),  # 35: PUSH imm8
    (0x60,),  # 36: PUSHA
    (0x61,),  # 37: POPA
    (0x69, 0x6B),  # 38: IMUL r,r/m,imm
    (0x06, 0x0E, 0x16, 0x1E),  # 39: PUSH segment register
    (0x07, 0x17, 0x1F),  # 40: POP segment register
    (0x8F,),  # 41: POP r/m
    (0xC4, 0xC5),  # 42: LES/LDS
    (0x8D,),  # 43: LEA
    (0x84, 0x85),  # 44: TEST r/m,r
    (0xFE,),  # 45: INC/DEC r/m8
    (0x98,),  # 46: CBW/CWDE
    (0x99,),  # 47: CWD
    (0x27,),  # 48: DAA
    (0xD4, 0xD5),  # 49: AAM/AAD
    (0x9C,),  # 50: PUSHF
    (0x9D,),  # 51: POPF
    (0xA8, 0xA9),  # 52: TEST accumulator,imm
    (0xD7,),  # 53: XLAT
    (0xA6, 0xA7),  # 54: CMPS
    (0xAE, 0xAF),  # 55: SCAS
    (0xF9,),  # 56: STC
    (0xF5,),  # 57: CMC
    (0xFD,),  # 58: STD
    (0x9A,),  # 59: CALL far
    (0xEA,),  # 60: JMP far
    (0xC9,),  # 61: LEAVE
    (0xC8,),  # 62: ENTER
    (0xCA, 0xCB),  # 63: RET far
    (0xF4,),  # 64: HLT
    (0x0F,),  # 65: the 386's two-byte opcode escape
)
_GROUP: tuple[int, ...] = tuple(
    next((group for group, opcodes in enumerate(_GROUP_OPCODES) if opcode in opcodes), 0)
    for opcode in range(256)
)


class UcError(RuntimeError):
    pass


@dataclass
class _Hook:
    kind: int
    callback: Callable[..., Any]
    user: Any
    begin: int
    end: int
    instruction: int | None = None


class Uc:
    """Real-mode interpreter implementing the harness's Unicorn subset."""

    def __init__(self, _arch: int, _mode: int, *, profile: str = "186eb"):
        if profile not in ("186eb", "386ex"):
            raise ValueError(f"unknown x86 interpreter profile {profile!r}")
        self.profile = profile
        self.memory = bytearray(0x1000000 if profile == "386ex" else 0x100000)
        self.address_mask = len(self.memory) - 1
        self.mapped: list[tuple[int, int, int]] = []
        self._last_region: tuple[int, int, int] = (0, 0, 0)
        self.regs = [0] * 14
        self.regs[UC_X86_REG_FLAGS] = 2
        self.hooks: list[_Hook] = []
        # Hooks bucketed by kind, as plain tuples of the fields the dispatch
        # loop reads. A run installs a dozen or so hooks and executes hundreds
        # of millions of instructions, so walking the whole list and calling a
        # range predicate per instruction - 32 calls per instruction on a
        # profiled ROM boot - costs more than the instructions themselves.
        # These are rebuilt on hook_add, which is the only mutation.
        self._code_hooks: tuple[tuple[Any, Any, int, int], ...] = ()
        self._read_hooks: tuple[tuple[Any, Any, int, int], ...] = ()
        self._write_hooks: tuple[tuple[Any, Any, int, int], ...] = ()
        self._invalid_hooks: tuple[tuple[Any, Any, int, int], ...] = ()
        self._global_code_hooks: tuple[tuple[Any, Any, int, int], ...] = ()
        self._ranged_code_hooks: tuple[tuple[Any, Any, int, int], ...] = ()
        self._ranged_code_addresses: frozenset[int] | None = frozenset()
        self._code_hook_span: tuple[int, int] = (1, 0)
        self._read_span: tuple[int, int] = (1, 0)
        self._write_span: tuple[int, int] = (1, 0)
        self._intr_hooks: tuple[tuple[Any, Any], ...] = ()
        self._insn_hooks: dict[int, tuple[tuple[Any, Any], ...]] = {}
        self._in_memory_hook = False
        # The board scheduler does not need a Python code-hook call for every
        # guest instruction.  Keep its deadline in the dispatch loop and cross
        # back into CourierMachine only at the requested interval.  The
        # callback sees the instruction about to retire, matching Unicorn's
        # code-hook timing and the old on_code_counting clock.
        self._clock_period = 0
        self._clock_next = 0
        self._clock_callback: Callable[[Any, int, Any], None] | None = None
        self._clock_user: Any = None
        self.running = False
        self.halted = False
        self.retired = 0

    def instruction_clock_add(
        self,
        period: int,
        callback: Callable[[Any, int, Any], None],
        user: Any = None,
    ) -> None:
        """Call ``callback`` at bounded instruction intervals.

        This is deliberately a small interpreter extension rather than a
        Unicorn compatibility API.  Device scheduling is periodic; code
        observation remains on ordinary hooks and stays opt-in.
        """
        if period <= 0:
            raise ValueError("instruction clock period must be positive")
        self._clock_period = period
        self._clock_next = self.retired + period
        self._clock_callback = callback
        self._clock_user = user

    def mem_map(self, address: int, size: int, perms: int = 7) -> None:
        if address & 0xFFF or size <= 0 or size & 0xFFF:
            raise UcError("invalid memory mapping (requires 4 KiB alignment)")
        if address < 0 or address + size > len(self.memory):
            raise UcError("invalid memory mapping outside 20-bit address space")
        self.mapped.append((address, address + size, perms))

    def _mapped(self, address: int, size: int, permission: int) -> bool:
        address &= self.address_mask
        # Accesses cluster in one region at a time, so remember the region that
        # answered last; the scan is a list walk on every read and write.
        first, last, perms = self._last_region
        if first <= address and address + size <= last and perms & permission:
            return True
        for region in self.mapped:
            first, last, perms = region
            if first <= address and address + size <= last and perms & permission:
                self._last_region = region
                return True
        return False

    def mem_read(self, address: int, size: int) -> bytearray:
        address &= self.address_mask
        if not self._mapped(address, size, UC_PROT_READ):
            if not self._invalid(address, size, 0):
                raise UcError(f"unmapped read at {address:#x}")
        low, high = self._read_span
        if low <= address <= high:
            self._memory_hooks(UC_HOOK_MEM_READ, address, size, 0)
        return self.memory[address:address + size]

    def mem_write(self, address: int, data: bytes | bytearray) -> None:
        address &= self.address_mask
        size = len(data)
        if not self._mapped(address, size, UC_PROT_WRITE):
            if not self._invalid(address, size, int.from_bytes(bytes(data[:8]), "little")):
                raise UcError(f"unmapped write at {address:#x}")
        # The value is only needed to hand to a hook, and converting it costs
        # more than the store itself.
        low, high = self._write_span
        if low <= address <= high:
            self._memory_hooks(
                UC_HOOK_MEM_WRITE, address, size, int.from_bytes(bytes(data[:8]), "little")
            )
        self.memory[address:address + size] = data

    def _load(self, address: int, size: int) -> int:
        """Read an integer operand, the form every instruction body wants.

        ``mem_read`` costs a slice, an ``int.from_bytes`` and a ``_mapped``
        call on top of its own; the interpreter takes this path millions of
        times a second, so the mapping check for the region that answered last
        is tested here and only a miss calls the scan.
        """
        first, last, perms = self._last_region
        if not (first <= address and address + size <= last and perms & UC_PROT_READ):
            if not self._mapped(address, size, UC_PROT_READ):
                if not self._invalid(address, size, 0):
                    raise UcError(f"unmapped read at {address:#x}")
        low, high = self._read_span
        if low <= address <= high:
            self._memory_hooks(UC_HOOK_MEM_READ, address, size, 0)
        memory = self.memory
        if size == 1:
            return memory[address]
        if size == 2:
            return memory[address] | memory[address + 1] << 8
        return int.from_bytes(memory[address:address + size], "little")

    def _store(self, address: int, size: int, value: int) -> None:
        """Write an integer operand of `size` bytes. The counterpart to _load."""
        value &= (1 << (size * 8)) - 1
        first, last, perms = self._last_region
        if not (first <= address and address + size <= last and perms & UC_PROT_WRITE):
            if not self._mapped(address, size, UC_PROT_WRITE):
                if not self._invalid(address, size, value):
                    raise UcError(f"unmapped write at {address:#x}")
        low, high = self._write_span
        if low <= address <= high:
            self._memory_hooks(UC_HOOK_MEM_WRITE, address, size, value)
        memory = self.memory
        if size == 1:
            memory[address] = value
        elif size == 2:
            memory[address] = value & 0xFF
            memory[address + 1] = value >> 8
        else:
            memory[address:address + size] = value.to_bytes(size, "little")

    def reg_read(self, register: int) -> int:
        return self.regs[register]

    def reg_write(self, register: int, value: int) -> None:
        self.regs[register] = value & (0xFFFFFFFF if self.profile == "386ex" and register < 8 else 0xFFFF)

    def hook_add(self, kind: int, callback: Callable[..., Any], user_data: Any = None,
                 begin: int = 1, end: int = 0, instruction: int | None = None) -> _Hook:
        hook = _Hook(kind, callback, user_data, begin, end, instruction)
        self.hooks.append(hook)
        self._rebuild_hook_cache()
        return hook

    def _rebuild_hook_cache(self) -> None:
        def bucket(kind: int) -> tuple[tuple[Any, Any, int, int], ...]:
            return tuple(
                (hook.callback, hook.user, hook.begin, hook.end)
                for hook in self.hooks
                if hook.kind & kind
            )

        def span(hooks: tuple[tuple[Any, Any, int, int], ...]) -> tuple[int, int]:
            # The union of a bucket's watched ranges. Device windows are small
            # and ordinary RAM traffic misses them, so _load and _store test
            # this before paying for the per-hook walk.
            if not hooks:
                return (1, 0)
            if any(end == 0 for _, _, _, end in hooks):
                return (0, len(self.memory))
            return (min(begin for _, _, begin, _ in hooks), max(end for _, _, _, end in hooks))

        self._code_hooks = bucket(UC_HOOK_CODE | UC_HOOK_BLOCK)
        # Code hooks split into the ones that watch every address and the ones
        # that watch a window. A harness can register dozens of windows - the
        # 80186 board names 31 hot routines - and walking them all per
        # instruction costs more than the instruction. The windows are small,
        # so the addresses they cover are collected into one set and the walk
        # only happens for an address in it.
        self._global_code_hooks = tuple(hook for hook in self._code_hooks if hook[3] == 0)
        self._ranged_code_hooks = tuple(hook for hook in self._code_hooks if hook[3] != 0)
        covered = sum(end - begin + 1 for _, _, begin, end in self._ranged_code_hooks)
        self._ranged_code_addresses = (
            frozenset(
                address
                for _, _, begin, end in self._ranged_code_hooks
                for address in range(begin, end + 1)
            )
            if covered <= 1 << 16 else None
        )
        self._code_hook_span = span(self._ranged_code_hooks)
        self._read_hooks = bucket(UC_HOOK_MEM_READ)
        self._write_hooks = bucket(UC_HOOK_MEM_WRITE)
        self._read_span = span(self._read_hooks)
        self._write_span = span(self._write_hooks)
        self._invalid_hooks = bucket(UC_HOOK_MEM_INVALID)
        self._intr_hooks = tuple(
            (hook.callback, hook.user) for hook in self.hooks if hook.kind & UC_HOOK_INTR
        )
        instructions: dict[int, list[tuple[Any, Any]]] = {}
        for hook in self.hooks:
            if hook.kind & UC_HOOK_INSN and hook.instruction is not None:
                instructions.setdefault(hook.instruction, []).append(
                    (hook.callback, hook.user)
                )
        self._insn_hooks = {key: tuple(value) for key, value in instructions.items()}

    def emu_stop(self) -> None:
        self.running = False

    def _range(self, hook: _Hook, address: int) -> bool:
        return hook.end == 0 or hook.begin <= address <= hook.end

    def _memory_hooks(self, kind: int, address: int, size: int, value: int) -> None:
        hooks = self._read_hooks if kind == UC_HOOK_MEM_READ else self._write_hooks
        if not hooks or self._in_memory_hook:
            return
        self._in_memory_hook = True
        try:
            for callback, user, begin, end in hooks:
                if end == 0 or begin <= address <= end:
                    callback(self, kind, address, size, value, user)
        finally:
            self._in_memory_hook = False

    def _invalid(self, address: int, size: int, value: int) -> bool:
        handled = False
        for callback, user, begin, end in self._invalid_hooks:
            if end == 0 or begin <= address <= end:
                handled = bool(callback(
                    self, UC_HOOK_MEM_INVALID, address, size, value, user
                )) or handled
        return handled

    def _physical(self, segment: int, offset: int) -> int:
        return ((segment & 0xFFFF) * 16 + (offset & 0xFFFF)) & self.address_mask

    def _fetch8(self) -> int:
        regs = self.regs
        ip = regs[UC_X86_REG_IP]
        value = self.memory[(regs[UC_X86_REG_CS] * 16 + ip) & self.address_mask]
        regs[UC_X86_REG_IP] = (ip + 1) & 0xFFFF
        return value

    def _fetch(self, size: int, signed: bool = False) -> int:
        """Read the immediate or displacement that follows the opcode.

        Every size but 1 and 2 belongs to the 386ex profile, so those two are
        written out rather than reached through the general loop: building a
        `range` per call cost more here than the reads did, and this is the
        most called helper the interpreter has.
        """
        regs = self.regs
        memory = self.memory
        mask = self.address_mask
        base = regs[UC_X86_REG_CS] * 16
        ip = regs[UC_X86_REG_IP]
        if size == 2:
            value = (memory[(base + ip) & mask]
                     | memory[(base + ((ip + 1) & 0xFFFF)) & mask] << 8)
            regs[UC_X86_REG_IP] = (ip + 2) & 0xFFFF
            if signed and value & 0x8000:
                value -= 0x10000
            return value
        if size == 1:
            value = memory[(base + ip) & mask]
            regs[UC_X86_REG_IP] = (ip + 1) & 0xFFFF
            if signed and value & 0x80:
                value -= 0x100
            return value
        value = 0
        for shift in range(0, size * 8, 8):
            value |= memory[(base + ip) & mask] << shift
            ip = (ip + 1) & 0xFFFF
        regs[UC_X86_REG_IP] = ip
        if signed and value & (1 << (size * 8 - 1)):
            value -= 1 << (size * 8)
        return value

    def _push(self, value: int, size: int = 2) -> None:
        sp = (self.regs[UC_X86_REG_SP] - size) & 0xFFFF
        self.regs[UC_X86_REG_SP] = sp
        self._store(((self.regs[UC_X86_REG_SS] & 0xFFFF) * 16 + sp) & self.address_mask, size, value)

    def _pop(self, size: int = 2) -> int:
        sp = self.regs[UC_X86_REG_SP]
        value = self._load(((self.regs[UC_X86_REG_SS] & 0xFFFF) * 16 + sp) & self.address_mask, size)
        self.regs[UC_X86_REG_SP] = (sp + size) & 0xFFFF
        return value

    def _parity(self, value: int) -> bool:
        return _PARITY[value & 0xFF]

    def _logic_flags(self, value: int, bits: int) -> None:
        flags = self.regs[UC_X86_REG_FLAGS] & ~(CF | PF | AF | ZF | SF | OF)
        value &= (1 << bits) - 1
        if value == 0: flags |= ZF
        if value & (1 << (bits - 1)): flags |= SF
        if _PARITY[value & 0xFF]: flags |= PF
        self.regs[UC_X86_REG_FLAGS] = flags | 2

    def _alu(self, operation: int, left: int, right: int, bits: int) -> int:
        """The eight /r ALU operations, flags included.

        The flag work is written out here rather than delegated to
        _logic_flags: an arithmetic operation would otherwise make a second
        call only to overwrite three of the flags it just computed, and this
        is the busiest routine the interpreter has.
        """
        mask, sign = (1 << bits) - 1, 1 << (bits - 1)
        flags = self.regs[UC_X86_REG_FLAGS] & ~(CF | PF | AF | ZF | SF | OF)
        if operation == 1: result = (left | right) & mask
        elif operation == 4: result = (left & right) & mask
        elif operation == 6: result = (left ^ right) & mask
        elif operation in (0, 2, 3, 5, 7):
            add = operation == 0 or operation == 2
            if operation == 2 or operation == 3:
                adjusted = right + (1 if self.regs[UC_X86_REG_FLAGS] & CF else 0)
            else:
                adjusted = right
            raw = left + adjusted if add else left - adjusted
            result = raw & mask
            if add:
                if raw > mask: flags |= CF
                if ~(left ^ adjusted) & (left ^ result) & sign: flags |= OF
            else:
                if left < adjusted: flags |= CF
                if (left ^ adjusted) & (left ^ result) & sign: flags |= OF
            if (left ^ adjusted ^ result) & 0x10: flags |= AF
        else: raise UcError(f"unsupported ALU operation /{operation}")
        if result == 0: flags |= ZF
        if result & sign: flags |= SF
        if _PARITY[result & 0xFF]: flags |= PF
        self.regs[UC_X86_REG_FLAGS] = flags | 2
        return result

    def _reg8(self, index: int) -> int:
        register = index & 3
        return (self.regs[register] >> (8 if index & 4 else 0)) & 0xFF

    def _set_reg8(self, index: int, value: int) -> None:
        register, shift = index & 3, 8 if index & 4 else 0
        mask = 0xFF << shift
        self.regs[register] = (self.regs[register] & ~mask) | ((value & 0xFF) << shift)

    def _ea(self, mod: int, rm: int, segment_override: int | None) -> int:
        regs = self.regs
        if mod == 0 and rm == 6:
            offset, uses_bp = self._fetch(2), False
        else:
            if rm == 0: offset = regs[UC_X86_REG_BX] + regs[UC_X86_REG_SI]
            elif rm == 1: offset = regs[UC_X86_REG_BX] + regs[UC_X86_REG_DI]
            elif rm == 2: offset = regs[UC_X86_REG_BP] + regs[UC_X86_REG_SI]
            elif rm == 3: offset = regs[UC_X86_REG_BP] + regs[UC_X86_REG_DI]
            elif rm == 4: offset = regs[UC_X86_REG_SI]
            elif rm == 5: offset = regs[UC_X86_REG_DI]
            elif rm == 6: offset = regs[UC_X86_REG_BP]
            else: offset = regs[UC_X86_REG_BX]
            uses_bp = rm in (2, 3, 6)
            if mod == 1: offset += self._fetch(1, signed=True)
            elif mod == 2: offset += self._fetch(2, signed=True)
        segment = segment_override if segment_override is not None else regs[UC_X86_REG_SS if uses_bp else UC_X86_REG_DS]
        return ((segment & 0xFFFF) * 16 + (offset & 0xFFFF)) & self.address_mask

    def _operand(self, modrm: int, size: int, segment: int | None) -> tuple[Callable[[], int], Callable[[int], None]]:
        mod, rm = modrm >> 6, modrm & 7
        if mod == 3:
            if size == 1:
                return lambda: self._reg8(rm), lambda value: self._set_reg8(rm, value)
            return lambda: self.regs[rm] & 0xFFFF, lambda value: self.reg_write(rm, value)
        address = self._ea(mod, rm, segment)
        return (
            lambda: self._load(address, size),
            lambda value: self._store(address, size, value),
        )

    def _condition(self, code: int) -> bool:
        # A conditional branch is about a fifth of everything this interpreter
        # executes, so the sixteen conditions are tested one at a time rather
        # than built into a tuple and indexed - the tuple evaluated all sixteen
        # on every branch.
        f = self.regs[UC_X86_REG_FLAGS]
        if code == 0: return bool(f & OF)
        if code == 1: return not f & OF
        if code == 2: return bool(f & CF)
        if code == 3: return not f & CF
        if code == 4: return bool(f & ZF)
        if code == 5: return not f & ZF
        if code == 6: return bool(f & (CF | ZF))
        if code == 7: return not f & (CF | ZF)
        if code == 8: return bool(f & SF)
        if code == 9: return not f & SF
        if code == 10: return bool(f & PF)
        if code == 11: return not f & PF
        if code == 12: return bool(f & SF) != bool(f & OF)
        if code == 13: return bool(f & SF) == bool(f & OF)
        if code == 14: return bool(f & ZF) or bool(f & SF) != bool(f & OF)
        return not f & ZF and bool(f & SF) == bool(f & OF)

    def _two_byte(self, operand_size: int, segment_override: int | None) -> None:
        """The 0x0f escape: the 386 two-byte opcodes this firmware is built from.

        These are what the compiler emits that an 8086 has no encoding for -
        near conditional branches, the condition-to-byte SETcc, the widening
        moves, the two-operand multiply, the double shifts, the bit tests and
        the bit scans. The system instructions behind the same escape are not
        implemented: this CPU never leaves real mode, so reaching one means the
        run has gone somewhere the harness does not model, and stopping says so.
        """
        if self.profile != "386ex":
            raise UcError("two-byte opcode 0f in 186eb profile")
        opcode = self._fetch8()
        bits = operand_size * 8
        mask = (1 << bits) - 1
        sign = 1 << (bits - 1)
        if 0x80 <= opcode <= 0x8F:
            # Jcc with a full displacement, rather than the 8086's rel8.
            displacement = self._fetch(operand_size, signed=True)
            if self._condition(opcode & 15):
                self.regs[UC_X86_REG_IP] = (
                    self.regs[UC_X86_REG_IP] + displacement
                ) & 0xFFFF
        elif 0x90 <= opcode <= 0x9F:
            # SETcc writes the condition itself as a byte, flags untouched.
            modrm = self._fetch8()
            _, write = self._operand(modrm, 1, segment_override)
            write(1 if self._condition(opcode & 15) else 0)
        elif opcode in (0xB6, 0xB7, 0xBE, 0xBF):
            # MOVZX/MOVSX. The source is a byte for the even opcodes and a
            # word for the odd ones; the destination is the operand size.
            modrm = self._fetch8()
            register = (modrm >> 3) & 7
            size = 1 if not opcode & 1 else 2
            read, _ = self._operand(modrm, size, segment_override)
            value = read()
            if opcode >= 0xBE and value & (1 << (size * 8 - 1)):
                value |= mask & ~((1 << (size * 8)) - 1)
            self.reg_write(register, value)
        elif opcode == 0xAF:
            # IMUL r,r/m keeps the low half. CF and OF say whether the product
            # needed the half that was dropped; the rest are undefined, and
            # left alone as the 0x69/0x6b form above does.
            modrm = self._fetch8()
            register = (modrm >> 3) & 7
            read, _ = self._operand(modrm, operand_size, segment_override)
            left = self.regs[register] & mask
            right = read()
            product = (
                (left - (1 << bits) if left & sign else left)
                * (right - (1 << bits) if right & sign else right)
            )
            result = product & mask
            self.reg_write(register, result)
            overflow = product != (result - (1 << bits) if result & sign else result)
            self.regs[UC_X86_REG_FLAGS] = (
                self.regs[UC_X86_REG_FLAGS] & ~(CF | OF) | ((CF | OF) if overflow else 0)
            )
        elif opcode in (0xA4, 0xA5, 0xAC, 0xAD):
            # SHLD/SHRD shift the destination and fill from the register, which
            # is what a compiler builds a wide shift out of. A zero count
            # leaves the flags alone; otherwise they read as the equivalent
            # single shift's, with CF the last bit shifted out.
            modrm = self._fetch8()
            register = (modrm >> 3) & 7
            read, write = self._operand(modrm, operand_size, segment_override)
            left = opcode < 0xAC
            count = (
                self._fetch8() if not opcode & 1 else self.regs[UC_X86_REG_CX] & 0xFF
            ) & 0x1F
            value = read()
            if count:
                # The pair of operands as one double-width value, rotated. For
                # a count within the operand size this is the plain shift the
                # manual defines; past it the manual calls the result
                # undefined, and what the part actually does - and what the
                # other engine does - is carry on funnelling the same pair.
                filler = self.regs[register] & mask
                pair = (value << bits) | filler if left else (filler << bits) | value
                width = bits * 2
                rotated = (
                    (pair << count) | (pair >> (width - count)) if left
                    else (pair >> count) | (pair << (width - count))
                ) & ((1 << width) - 1)
                result = (rotated >> bits) if left else (rotated & mask)
                carry = (pair >> (width - count)) & 1 if left else (pair >> (count - 1)) & 1
                write(result)
                self._logic_flags(result, bits)
                self.regs[UC_X86_REG_FLAGS] = (
                    self.regs[UC_X86_REG_FLAGS] & ~CF | (CF if carry else 0)
                )
        elif opcode in (0xA3, 0xAB, 0xB3, 0xBB, 0xBA):
            # The bit tests. CF takes the bit; BTS/BTR/BTC then set, clear or
            # complement it. Only one form walks: a register bit offset
            # against memory addresses a bit string, so it steps whole
            # operands away from the effective address and its offset is
            # signed. An immediate offset, and any offset against a register,
            # stays inside the operand and is taken modulo its width.
            modrm = self._fetch8()
            if opcode == 0xBA:
                operation = (modrm >> 3) & 7
                if operation < 4:
                    raise UcError(f"unsupported 0f ba group /{operation}")
                operation -= 4
            else:
                operation = (opcode >> 3) & 3
            mod, rm = modrm >> 6, modrm & 7
            if mod == 3:
                offset = self._fetch8() & 0x1F if opcode == 0xBA else self.regs[(modrm >> 3) & 7]
                index = offset % bits
                value = self.regs[rm] & mask
                taken = (value >> index) & 1
                if operation:
                    if operation == 1: value |= 1 << index
                    elif operation == 2: value &= ~(1 << index)
                    else: value ^= 1 << index
                    self.reg_write(rm, value)
            else:
                # The walk has to be done on the offset, not on the physical
                # address: a bit string runs inside its segment and wraps at
                # its end, the way every other 16-bit address does.
                segment = segment_override
                if segment is None:
                    uses_bp = rm in (2, 3) or (rm == 6 and mod != 0)
                    segment = self.regs[UC_X86_REG_SS if uses_bp else UC_X86_REG_DS]
                base = (segment & 0xFFFF) * 16
                offset = (self._ea(mod, rm, segment) - base) & 0xFFFF
                if opcode == 0xBA:
                    index = (self._fetch8() & 0x1F) % bits
                else:
                    bit = self.regs[(modrm >> 3) & 7] & mask
                    if bit & sign:
                        bit -= 1 << bits
                    offset = (offset + (bit // bits) * operand_size) & 0xFFFF
                    index = bit % bits
                address = (base + offset) & self.address_mask
                value = self._load(address, operand_size)
                taken = (value >> index) & 1
                if operation:
                    if operation == 1: value |= 1 << index
                    elif operation == 2: value &= ~(1 << index)
                    else: value ^= 1 << index
                    self._store(address, operand_size, value)
            self.regs[UC_X86_REG_FLAGS] = (
                self.regs[UC_X86_REG_FLAGS] & ~CF | (CF if taken else 0)
            )
        elif opcode in (0xBC, 0xBD):
            # BSF/BSR. ZF reports an all-zero source, and leaves the
            # destination as it was rather than inventing an index for it.
            modrm = self._fetch8()
            register = (modrm >> 3) & 7
            read, _ = self._operand(modrm, operand_size, segment_override)
            value = read() & mask
            # ZF reports an all-zero source, and the destination is then left
            # as it was rather than given an index that does not exist. The
            # other flags are undefined for this instruction; describing the
            # source the way a logical operation would is what the other
            # engine does, and it produces that ZF on the way.
            self._logic_flags(value, bits)
            if value:
                self.reg_write(
                    register,
                    (value & -value).bit_length() - 1 if opcode == 0xBC
                    else value.bit_length() - 1,
                )
        else:
            raise UcError(f"unsupported two-byte opcode 0f {opcode:02x} ({self.profile})")

    def _io(self, instruction: int, port: int, size: int, value: int = 0) -> int:
        result = 0
        for callback, user in self._insn_hooks.get(instruction, ()):
            answer = callback(self, port, size, value, user) if instruction == UC_X86_INS_OUT else callback(self, port, size, user)
            if answer is not None: result = int(answer)
        return result

    def emu_start(self, begin: int, _until: int, timeout: int = 0, count: int = 0) -> None:
        del timeout
        # The harness writes CS:IP before entry and interrupt dispatch. Unicorn's
        # ``begin`` selects the linear fetch address without canonicalising the
        # visible segment registers, so preserve that observable state here too.
        current = self._physical(self.regs[UC_X86_REG_CS], self.regs[UC_X86_REG_IP])
        if current != (begin & self.address_mask):
            self.regs[UC_X86_REG_IP] = (
                begin - self.regs[UC_X86_REG_CS] * 16
            ) & 0xFFFF
        self.running, self.halted = True, False
        # Loop-invariant state, read once. The dispatch loop runs tens of
        # millions of times per second of guest time, so an attribute lookup
        # inside it is not free; none of these three are ever rebound.
        # Named apart from the short local names the instruction bodies below
        # reuse (`mask`, `size`): a shift's `mask = (1 << bits) - 1` would
        # otherwise survive into the next instruction's address arithmetic.
        cpu_regs = self.regs
        cpu_memory = self.memory
        address_mask = self.address_mask
        # The general-register width, as reg_write applies it, and the IP index:
        # the hand-written operand decoding below reaches for both constantly.
        register_mask = 0xFFFFFFFF if self.profile == "386ex" else 0xFFFF
        REG_IP = UC_X86_REG_IP
        # The harness's instruction hook is usually the only one, and it
        # covers every address; calling it straight is worth more than it
        # looks when the alternative is unpacking a tuple of tuples per
        # instruction. Anything else falls back to the general walk.
        global_hooks = self._global_code_hooks
        ranged_hooks = self._ranged_code_hooks
        ranged_addresses = self._ranged_code_addresses
        ranged_low, ranged_high = self._code_hook_span
        if len(global_hooks) == 1 and not ranged_hooks:
            single_hook, single_user = global_hooks[0][0], global_hooks[0][1]
        else:
            single_hook = single_user = None
        clock_callback = self._clock_callback
        clock_user = self._clock_user
        clock_period = self._clock_period
        clock_next = self._clock_next
        retired = 0
        while self.running and (not count or retired < count):
            start_ip = cpu_regs[REG_IP]
            code_base = cpu_regs[UC_X86_REG_CS] * 16
            physical = (code_base + start_ip) & address_mask
            # Fire before the boundary instruction, like UC_HOOK_CODE.  The
            # callback may stop execution to dispatch an interrupt; in that
            # case this instruction remains pending for the next emu_start.
            total_about_to_retire = self.retired + 1
            if clock_callback is not None and total_about_to_retire >= clock_next:
                clock_callback(self, total_about_to_retire, clock_user)
                clock_next = total_about_to_retire + clock_period
                self._clock_next = clock_next
                if not self.running:
                    break
            if single_hook is not None:
                single_hook(self, physical, 1, single_user)
            else:
                for callback, user, _begin, _end in global_hooks:
                    callback(self, physical, 1, user)
                if (physical in ranged_addresses if ranged_addresses is not None
                        else ranged_low <= physical <= ranged_high):
                    for callback, user, begin, end in ranged_hooks:
                        if begin <= physical <= end:
                            callback(self, physical, 1, user)
            if not self.running:
                break
            if (cpu_regs[UC_X86_REG_CS] * 16 + cpu_regs[UC_X86_REG_IP]) & address_mask != physical:
                # A peripheral hook injected an interrupt or otherwise
                # redirected execution. Restart dispatch at the new CS:IP so
                # its first instruction receives its own hook/accounting edge.
                # Unicorn charges this dispatch edge against emu_start's
                # count even though the redirected instruction itself runs on
                # the following edge. Match that scheduling contract.
                retired += 1
                self.retired += 1
                continue
            segment_override = None
            operand_size = 2
            repeat = 0
            # The opcode fetch is inlined: it is the one memory read every
            # instruction makes, and it always reads mapped code through the
            # same CS:IP the loop just computed.
            opcode = cpu_memory[physical]
            cpu_regs[UC_X86_REG_IP] = (start_ip + 1) & 0xFFFF
            if _IS_PREFIX[opcode]:
                # A repeat prefix is re-read on every iteration of the string
                # instruction it governs, so this walk fetches its own bytes.
                while _IS_PREFIX[opcode]:
                    if opcode == 0xF3 or opcode == 0xF2:
                        repeat = opcode
                    elif opcode == 0x26: segment_override = cpu_regs[UC_X86_REG_ES]
                    elif opcode == 0x3E: segment_override = cpu_regs[UC_X86_REG_DS]
                    elif opcode == 0x2E: segment_override = cpu_regs[UC_X86_REG_CS]
                    elif opcode == 0x36: segment_override = cpu_regs[UC_X86_REG_SS]
                    elif opcode == 0x66 or opcode == 0x67:
                        if self.profile != "386ex": raise UcError(f"386 prefix {opcode:02x} in 186eb profile at {physical:#x}")
                        if opcode == 0x66: operand_size = 4
                        else: raise UcError(f"32-bit addressing not implemented at {physical:#x}")
                    ip = cpu_regs[REG_IP]
                    opcode = cpu_memory[(code_base + ip) & address_mask]
                    cpu_regs[REG_IP] = (ip + 1) & 0xFFFF
                bits = operand_size * 8
            else:
                bits = 16
            group = _GROUP[opcode]
            if group == 11:  # Jcc rel8
                ip = cpu_regs[REG_IP]; displacement = cpu_memory[(code_base + ip) & address_mask]; ip = (ip + 1) & 0xFFFF
                if self._condition(opcode & 15):
                    ip += displacement - 256 if displacement & 0x80 else displacement
                cpu_regs[REG_IP] = ip & 0xFFFF
            elif group == 18:  # ALU r/m,imm
                modrm = self._fetch8(); operation = (modrm >> 3) & 7; size = 1 if opcode == 0x80 else operand_size
                read, write = self._operand(modrm, size, segment_override)
                immediate = self._fetch(1, signed=opcode == 0x83) if opcode in (0x80,0x83) else self._fetch(size)
                result = self._alu(operation, read(), immediate & ((1 << (size*8))-1), size*8)
                if operation != 7: write(result)
            elif group == 19:  # RET near
                self.regs[UC_X86_REG_IP] = self._pop(operand_size)
                if opcode == 0xC2: self.regs[UC_X86_REG_SP] = (self.regs[UC_X86_REG_SP] + self._fetch(2)) & 0xFFFF
            elif group == 20:  # CALL rel16
                displacement = self._fetch(operand_size, signed=True); self._push(self.regs[UC_X86_REG_IP], operand_size); self.regs[UC_X86_REG_IP] = (self.regs[UC_X86_REG_IP] + displacement) & 0xFFFF
            elif group == 16:  # group F6/F7: TEST/NOT/NEG/MUL/DIV
                modrm = self._fetch8(); operation = (modrm >> 3) & 7
                size = 1 if opcode == 0xF6 else operand_size; bits = size * 8
                read, write = self._operand(modrm, size, segment_override)
                value, mask = read(), (1 << bits) - 1
                if operation in (0, 1): self._logic_flags(value & self._fetch(size), bits)
                elif operation == 2: write(~value & mask)
                elif operation == 3: write(self._alu(5, 0, value, bits))
                elif operation == 4:
                    product = (self._reg8(0) if size == 1 else self.regs[UC_X86_REG_AX]) * value
                    if size == 1:
                        self.reg_write(UC_X86_REG_AX, product)
                    else:
                        self.reg_write(UC_X86_REG_AX, product); self.reg_write(UC_X86_REG_DX, product >> bits)
                    high = product >> bits
                    self.regs[UC_X86_REG_FLAGS] = (self.regs[UC_X86_REG_FLAGS] & ~(CF | OF)) | ((CF | OF) if high else 0)
                elif operation == 5:
                    accumulator = self._reg8(0) if size == 1 else self.regs[UC_X86_REG_AX]
                    signed_acc = accumulator - (1 << bits) if accumulator & (1 << (bits - 1)) else accumulator
                    signed_value = value - (1 << bits) if value & (1 << (bits - 1)) else value
                    product = signed_acc * signed_value
                    if size == 1: self.reg_write(UC_X86_REG_AX, product)
                    else: self.reg_write(UC_X86_REG_AX, product); self.reg_write(UC_X86_REG_DX, product >> bits)
                    truncated = product & mask
                    fits = product == (truncated - (1 << bits) if truncated & (1 << (bits - 1)) else truncated)
                    self.regs[UC_X86_REG_FLAGS] = (self.regs[UC_X86_REG_FLAGS] & ~(CF | OF)) | (0 if fits else CF | OF)
                elif operation == 6:
                    dividend = self.regs[UC_X86_REG_AX] if size == 1 else (self.regs[UC_X86_REG_DX] << bits) | self.regs[UC_X86_REG_AX]
                    if value == 0: raise UcError("division by zero")
                    quotient, remainder = divmod(dividend, value)
                    if quotient > mask: raise UcError("division overflow")
                    if size == 1: self.reg_write(UC_X86_REG_AX, quotient | remainder << 8)
                    else: self.reg_write(UC_X86_REG_AX, quotient); self.reg_write(UC_X86_REG_DX, remainder)
                elif operation == 7:
                    raw_dividend = self.regs[UC_X86_REG_AX] if size == 1 else (self.regs[UC_X86_REG_DX] << bits) | self.regs[UC_X86_REG_AX]
                    dividend_bits = bits * 2
                    dividend = raw_dividend - (1 << dividend_bits) if raw_dividend & (1 << (dividend_bits - 1)) else raw_dividend
                    divisor = value - (1 << bits) if value & (1 << (bits - 1)) else value
                    if divisor == 0: raise UcError("division by zero")
                    quotient = abs(dividend) // abs(divisor)
                    if (dividend < 0) != (divisor < 0): quotient = -quotient
                    remainder = dividend - quotient * divisor
                    minimum, maximum = -(1 << (bits - 1)), (1 << (bits - 1)) - 1
                    if not minimum <= quotient <= maximum: raise UcError("division overflow")
                    if size == 1: self.reg_write(UC_X86_REG_AX, (quotient & 0xFF) | ((remainder & 0xFF) << 8))
                    else: self.reg_write(UC_X86_REG_AX, quotient); self.reg_write(UC_X86_REG_DX, remainder)
                else: raise UcError(f"unsupported F{6 if size == 1 else 7:x} group /{operation}")
            elif group == 24: self.regs[UC_X86_REG_FLAGS] &= ~CF
            elif group == 23:  # group FF: INC/DEC/CALL/JMP/PUSH r/m
                modrm = self._fetch8(); operation = (modrm >> 3) & 7
                if operation in (3, 5):
                    if modrm >> 6 == 3: raise UcError("far call/jump requires memory operand")
                    address = self._ea(modrm >> 6, modrm & 7, segment_override)
                    value = int.from_bytes(self.mem_read(address, operand_size), "little")
                    segment = int.from_bytes(self.mem_read(address + operand_size, 2), "little")
                    if operation == 3:
                        self._push(self.regs[UC_X86_REG_CS])
                        self._push(self.regs[UC_X86_REG_IP], operand_size)
                    self.regs[UC_X86_REG_CS], self.regs[UC_X86_REG_IP] = segment, value & 0xFFFF
                else:
                    read, write = self._operand(modrm, operand_size, segment_override)
                    value = read()
                    if operation in (0, 1):
                        old_cf = self.regs[UC_X86_REG_FLAGS] & CF
                        write(self._alu(0 if operation == 0 else 5, value, 1, bits))
                        self.regs[UC_X86_REG_FLAGS] = self.regs[UC_X86_REG_FLAGS] & ~CF | old_cf
                    elif operation == 2:
                        self._push(self.regs[UC_X86_REG_IP], operand_size)
                        self.regs[UC_X86_REG_IP] = value & 0xFFFF
                    elif operation == 4:
                        self.regs[UC_X86_REG_IP] = value & 0xFFFF
                    elif operation == 6:
                        self._push(value, operand_size)
                    else:
                        raise UcError(f"unsupported FF group /{operation}")
            elif group == 5:  # shift/rotate r/m
                ip = cpu_regs[REG_IP]; modrm = cpu_memory[(code_base + ip) & address_mask]; cpu_regs[REG_IP] = (ip + 1) & 0xFFFF
                operation = (modrm >> 3) & 7
                size = 1 if opcode in (0xD0, 0xD2, 0xC0) else operand_size
                target, address = modrm & 7, -1
                if modrm >= 0xC0:
                    value = (cpu_regs[target & 3] >> (8 if target & 4 else 0)) & 0xFF if size == 1 else cpu_regs[target]
                else:
                    address = self._ea(modrm >> 6, target, segment_override)
                    value = self._load(address, size)
                shift_count = (1 if opcode in (0xD0, 0xD1) else cpu_regs[UC_X86_REG_CX] & 0xFF if opcode in (0xD2, 0xD3) else self._fetch8()) & 0x1F
                bits = size * 8
                if shift_count:
                    mask = (1 << bits) - 1
                    if operation == 0:
                        amount = shift_count % bits
                        result = ((value << amount) | (value >> (bits - amount))) & mask
                        carry = result & 1
                    elif operation == 1:
                        amount = shift_count % bits
                        result = ((value >> amount) | (value << (bits - amount))) & mask
                        carry = (result >> (bits - 1)) & 1
                    elif operation == 2:
                        result = value
                        carry = 1 if self.regs[UC_X86_REG_FLAGS] & CF else 0
                        for _ in range(shift_count % (bits + 1)):
                            result, carry = ((result << 1) | carry) & mask, (result >> (bits - 1)) & 1
                    elif operation == 3:
                        result = value
                        carry = 1 if self.regs[UC_X86_REG_FLAGS] & CF else 0
                        for _ in range(shift_count % (bits + 1)):
                            result, carry = (result >> 1) | (carry << (bits - 1)), result & 1
                    elif operation in (4, 6):
                        carry = (value >> (bits - shift_count)) & 1 if shift_count <= bits else 0
                        result = value << shift_count
                    elif operation == 5:
                        carry = (value >> (shift_count - 1)) & 1 if shift_count <= bits else 0
                        result = value >> shift_count
                    elif operation == 7:
                        carry = (value >> (shift_count - 1)) & 1 if shift_count <= bits else 0
                        signed = value - (1 << bits) if value & (1 << (bits - 1)) else value
                        result = signed >> shift_count
                    else:
                        raise UcError(f"shift operation /{operation} not implemented")
                    if address >= 0: self._store(address, size, result)
                    elif size == 1:
                        index, shift = target & 3, 8 if target & 4 else 0
                        cpu_regs[index] = (cpu_regs[index] & ~(0xFF << shift)) | (result & 0xFF) << shift
                    else: cpu_regs[target] = result & register_mask
                    if operation >= 4:
                        self._logic_flags(result, bits)
                    cpu_regs[UC_X86_REG_FLAGS] = cpu_regs[UC_X86_REG_FLAGS] & ~CF | (CF if carry else 0)
            elif group == 3:  # MOV r8,imm8
                ip = cpu_regs[REG_IP]; value = cpu_memory[(code_base + ip) & address_mask]; cpu_regs[REG_IP] = (ip + 1) & 0xFFFF
                register = opcode - 0xB0; index, shift = register & 3, 8 if register & 4 else 0
                cpu_regs[index] = (cpu_regs[index] & ~(0xFF << shift)) | value << shift
            elif group == 17:  # XCHG AX,r16 (0x90 is NOP)
                register = opcode - 0x90
                self.regs[UC_X86_REG_AX], self.regs[register] = self.regs[register], self.regs[UC_X86_REG_AX]
            elif group == 4:  # ALU r/m,r and r,r/m
                operation = (opcode >> 3) & 7
                ip = cpu_regs[REG_IP]; modrm = cpu_memory[(code_base + ip) & address_mask]; cpu_regs[REG_IP] = (ip + 1) & 0xFFFF
                reg = (modrm >> 3) & 7; size = 1 if not opcode & 1 else operand_size
                rm, address = modrm & 7, -1
                if modrm >= 0xC0:
                    dest = (cpu_regs[rm & 3] >> (8 if rm & 4 else 0)) & 0xFF if size == 1 else cpu_regs[rm]
                else:
                    address = self._ea(modrm >> 6, rm, segment_override)
                    dest = self._load(address, size)
                source = (cpu_regs[reg & 3] >> (8 if reg & 4 else 0)) & 0xFF if size == 1 else cpu_regs[reg]
                if opcode & 2: source, dest = dest, source
                result = self._alu(operation, dest, source, size * 8)
                if operation != 7:
                    if opcode & 2: target = reg
                    elif address >= 0: target = -1
                    else: target = rm
                    if target < 0: self._store(address, size, result)
                    elif size == 1:
                        index, shift = target & 3, 8 if target & 4 else 0
                        cpu_regs[index] = (cpu_regs[index] & ~(0xFF << shift)) | (result & 0xFF) << shift
                    else: cpu_regs[target] = result & register_mask
            elif group == 6:  # XCHG r/m,r
                ip = cpu_regs[REG_IP]; modrm = cpu_memory[(code_base + ip) & address_mask]; cpu_regs[REG_IP] = (ip + 1) & 0xFFFF
                reg = (modrm >> 3) & 7
                size = 1 if opcode == 0x86 else operand_size
                rm, address = modrm & 7, -1
                register_value = (cpu_regs[reg & 3] >> (8 if reg & 4 else 0)) & 0xFF if size == 1 else cpu_regs[reg]
                if modrm >= 0xC0:
                    if size == 1:
                        other = (cpu_regs[rm & 3] >> (8 if rm & 4 else 0)) & 0xFF
                        index, shift = rm & 3, 8 if rm & 4 else 0
                        cpu_regs[index] = (cpu_regs[index] & ~(0xFF << shift)) | register_value << shift
                    else:
                        other = cpu_regs[rm]
                        cpu_regs[rm] = register_value & register_mask
                else:
                    address = self._ea(modrm >> 6, rm, segment_override)
                    other = self._load(address, size)
                    self._store(address, size, register_value)
                if size == 1:
                    index, shift = reg & 3, 8 if reg & 4 else 0
                    cpu_regs[index] = (cpu_regs[index] & ~(0xFF << shift)) | other << shift
                else: cpu_regs[reg] = other & register_mask
            elif group == 32:  # MOV r/m,imm
                modrm = self._fetch8(); size = 1 if opcode == 0xC6 else operand_size
                _, write = self._operand(modrm, size, segment_override); write(self._fetch(size))
            elif group == 14: self.reg_write(opcode - 0x58, self._pop(operand_size))
            elif group == 13: self._push(self.regs[opcode - 0x50], operand_size)
            elif group == 2:  # MOV r/m,r and r,r/m
                # This group and the ALU group below are most of what the
                # firmware executes, so their operands are
                # decoded here rather than through _operand, whose closure pair
                # costs more than either instruction does.
                ip = cpu_regs[REG_IP]; modrm = cpu_memory[(code_base + ip) & address_mask]; cpu_regs[REG_IP] = (ip + 1) & 0xFFFF
                reg = (modrm >> 3) & 7; size = 1 if opcode in (0x88, 0x8A) else operand_size
                to_register = opcode & 2
                if modrm >= 0xC0:
                    rm = modrm & 7
                    if size == 1:
                        source, destination = (rm, reg) if to_register else (reg, rm)
                        value = (cpu_regs[source & 3] >> (8 if source & 4 else 0)) & 0xFF
                        index, shift = destination & 3, 8 if destination & 4 else 0
                        cpu_regs[index] = (cpu_regs[index] & ~(0xFF << shift)) | value << shift
                    elif to_register: cpu_regs[reg] = cpu_regs[rm] & register_mask
                    else: cpu_regs[rm] = cpu_regs[reg] & register_mask
                else:
                    address = self._ea(modrm >> 6, modrm & 7, segment_override)
                    if not to_register:
                        self._store(address, size, (cpu_regs[reg & 3] >> (8 if reg & 4 else 0)) & 0xFF if size == 1 else cpu_regs[reg])
                    elif size == 1:
                        index, shift = reg & 3, 8 if reg & 4 else 0
                        cpu_regs[index] = (cpu_regs[index] & ~(0xFF << shift)) | self._load(address, 1) << shift
                    else: cpu_regs[reg] = self._load(address, size) & register_mask
            elif group == 1:  # MOVS/STOS/LODS
                # A repeated one of these is the single most executed
                # instruction of a boot - each iteration re-enters
                # dispatch, because that is the edge Unicorn retires and the
                # harness counts - so it reads its registers and memory
                # directly. Bits 3:1 of the opcode name the form: 2 moves
                # SI to DI, 5 stores the accumulator, 6 loads it.
                if not repeat or cpu_regs[UC_X86_REG_CX]:
                    form = (opcode >> 1) & 7
                    size = 1 if not opcode & 1 else operand_size
                    step = -size if cpu_regs[UC_X86_REG_FLAGS] & DF else size
                    if form != 5:
                        segment = segment_override if segment_override is not None else cpu_regs[UC_X86_REG_DS]
                        source = cpu_regs[UC_X86_REG_SI]
                        value = self._load(((segment & 0xFFFF) * 16 + source) & address_mask, size)
                        cpu_regs[UC_X86_REG_SI] = (source + step) & 0xFFFF
                    else:
                        value = cpu_regs[UC_X86_REG_AX] & 0xFF if size == 1 else cpu_regs[UC_X86_REG_AX]
                    if form != 6:
                        destination = cpu_regs[UC_X86_REG_DI]
                        self._store(((cpu_regs[UC_X86_REG_ES] & 0xFFFF) * 16 + destination) & address_mask, size, value)
                        cpu_regs[UC_X86_REG_DI] = (destination + step) & 0xFFFF
                    elif size == 1:
                        cpu_regs[UC_X86_REG_AX] = (cpu_regs[UC_X86_REG_AX] & ~0xFF) | value
                    else:
                        cpu_regs[UC_X86_REG_AX] = value & register_mask
                    if repeat:
                        cpu_regs[UC_X86_REG_CX] = (cpu_regs[UC_X86_REG_CX] - 1) & 0xFFFF
                        # Re-enter once with CX zero. This performs no memory
                        # operation but matches the boundary at which Unicorn
                        # retires a REP instruction and advances past it.
                        cpu_regs[REG_IP] = start_ip
            elif group == 39:  # PUSH segment register
                self._push(self.regs[{0x06: UC_X86_REG_ES, 0x0E: UC_X86_REG_CS, 0x16: UC_X86_REG_SS, 0x1E: UC_X86_REG_DS}[opcode]])
            elif group == 26:  # OUT
                size = 1 if opcode in (0xE6,0xEE) else operand_size; port = self._fetch8() if opcode in (0xE6,0xE7) else self.regs[UC_X86_REG_DX]
                self._io(UC_X86_INS_OUT, port, size, self._reg8(0) if size == 1 else self.regs[UC_X86_REG_AX])
            elif group == 63:  # RET far
                self.regs[UC_X86_REG_IP] = self._pop(); self.regs[UC_X86_REG_CS] = self._pop()
                if opcode == 0xCA: self.regs[UC_X86_REG_SP] = (self.regs[UC_X86_REG_SP] + self._fetch(2)) & 0xFFFF
            elif group == 33:  # ALU accumulator,imm
                operation = (opcode >> 3) & 7; size = 1 if not opcode & 1 else operand_size
                left = self._reg8(0) if size == 1 else self.regs[UC_X86_REG_AX]
                result = self._alu(operation, left, self._fetch(size), size * 8)
                if operation != 7:
                    self._set_reg8(0, result) if size == 1 else self.reg_write(UC_X86_REG_AX, result)
            elif group == 21:  # JMP rel8
                displacement = self._fetch(1, signed=True)
                self.regs[UC_X86_REG_IP] = (self.regs[UC_X86_REG_IP] + displacement) & 0xFFFF
            elif group == 9:  # MOV to and from a segment register
                ip = cpu_regs[REG_IP]; modrm = cpu_memory[(code_base + ip) & address_mask]; cpu_regs[REG_IP] = (ip + 1) & 0xFFFF
                segment_reg = (UC_X86_REG_ES, UC_X86_REG_CS, UC_X86_REG_SS, UC_X86_REG_DS)[(modrm >> 3) & 3]
                if modrm >= 0xC0:
                    rm = modrm & 7
                    if opcode == 0x8C: cpu_regs[rm] = cpu_regs[segment_reg] & register_mask
                    else: cpu_regs[segment_reg] = cpu_regs[rm] & 0xFFFF
                else:
                    address = self._ea(modrm >> 6, modrm & 7, segment_override)
                    if opcode == 0x8C: self._store(address, 2, cpu_regs[segment_reg])
                    else: cpu_regs[segment_reg] = self._load(address, 2)
            elif group == 40:  # POP segment register
                self.reg_write({0x07: UC_X86_REG_ES, 0x17: UC_X86_REG_SS, 0x1F: UC_X86_REG_DS}[opcode], self._pop())
            elif group == 8:  # MOV r16,imm
                if operand_size == 2:
                    ip = cpu_regs[REG_IP]
                    base = code_base + ip
                    cpu_regs[opcode - 0xB8] = cpu_memory[base & address_mask] | cpu_memory[(base + 1) & address_mask] << 8
                    cpu_regs[REG_IP] = (ip + 2) & 0xFFFF
                else: self.reg_write(opcode - 0xB8, self._fetch(operand_size))
            elif group == 7:  # LOOP/LOOPE/LOOPNE/JCXZ
                ip = cpu_regs[REG_IP]; displacement = cpu_memory[(code_base + ip) & address_mask]; ip = (ip + 1) & 0xFFFF
                if opcode == 0xE3:
                    take = cpu_regs[UC_X86_REG_CX] == 0
                else:
                    count_register = (cpu_regs[UC_X86_REG_CX] - 1) & 0xFFFF
                    cpu_regs[UC_X86_REG_CX] = count_register
                    take = count_register != 0
                    if opcode == 0xE0: take = take and not cpu_regs[UC_X86_REG_FLAGS] & ZF
                    elif opcode == 0xE1: take = take and bool(cpu_regs[UC_X86_REG_FLAGS] & ZF)
                if take: ip += displacement - 256 if displacement & 0x80 else displacement
                cpu_regs[REG_IP] = ip & 0xFFFF
            elif group == 50: self._push(self.regs[UC_X86_REG_FLAGS])
            elif group == 51: self.reg_write(UC_X86_REG_FLAGS, self._pop() | 2)
            elif group == 59:  # CALL far
                offset = self._fetch(operand_size)
                segment = self._fetch(2)
                self._push(self.regs[UC_X86_REG_CS])
                self._push(self.regs[UC_X86_REG_IP], operand_size)
                self.regs[UC_X86_REG_CS] = segment
                self.regs[UC_X86_REG_IP] = offset & 0xFFFF
            elif group == 25:  # IN
                size = 1 if opcode in (0xE4,0xEC) else operand_size; port = self._fetch8() if opcode in (0xE4,0xE5) else self.regs[UC_X86_REG_DX]
                value = self._io(UC_X86_INS_IN, port, size)
                if size == 1: self._set_reg8(0, value)
                else: self.reg_write(UC_X86_REG_AX, value)
            elif group == 29: self.regs[UC_X86_REG_FLAGS] &= ~IF
            elif group == 30: self.regs[UC_X86_REG_FLAGS] |= IF
            elif group == 31:  # MOV accumulator to and from a direct address
                size = 1 if opcode in (0xA0, 0xA2) else operand_size
                segment = segment_override if segment_override is not None else self.regs[UC_X86_REG_DS]
                address = self._physical(segment, self._fetch(2))
                if opcode in (0xA0, 0xA1):
                    value = int.from_bytes(self.mem_read(address, size), "little")
                    self._set_reg8(0, value) if size == 1 else self.reg_write(UC_X86_REG_AX, value)
                else:
                    value = self._reg8(0) if size == 1 else self.regs[UC_X86_REG_AX]
                    self.mem_write(address, value.to_bytes(size, "little"))
            elif group == 52:  # TEST accumulator,imm
                size = 1 if opcode == 0xA8 else operand_size
                value = self._reg8(0) if size == 1 else self.regs[UC_X86_REG_AX]
                self._logic_flags(value & self._fetch(size), size * 8)
            elif group == 44:  # TEST r/m,r
                modrm = self._fetch8(); reg = (modrm >> 3) & 7
                size = 1 if opcode == 0x84 else operand_size
                read, _ = self._operand(modrm, size, segment_override)
                value = self._reg8(reg) if size == 1 else self.regs[reg]
                self._logic_flags(read() & value, size * 8)
            elif group == 10:  # INC r16
                register = opcode - 0x40; old_cf = self.regs[UC_X86_REG_FLAGS] & CF
                self.reg_write(register, self._alu(0, self.regs[register], 1, bits)); self.regs[UC_X86_REG_FLAGS] = self.regs[UC_X86_REG_FLAGS] & ~CF | old_cf
            elif group == 12:  # DEC r16
                register = opcode - 0x48; old_cf = self.regs[UC_X86_REG_FLAGS] & CF
                self.reg_write(register, self._alu(5, self.regs[register], 1, bits)); self.regs[UC_X86_REG_FLAGS] = self.regs[UC_X86_REG_FLAGS] & ~CF | old_cf
            elif group == 56: self.regs[UC_X86_REG_FLAGS] |= CF
            elif group == 22:  # JMP rel16
                displacement = self._fetch(operand_size, signed=True)
                self.regs[UC_X86_REG_IP] = (self.regs[UC_X86_REG_IP] + displacement) & 0xFFFF
            elif group == 36:  # PUSHA
                original_sp = self.regs[UC_X86_REG_SP]
                for register in (UC_X86_REG_AX, UC_X86_REG_CX, UC_X86_REG_DX, UC_X86_REG_BX): self._push(self.regs[register], operand_size)
                self._push(original_sp, operand_size)
                for register in (UC_X86_REG_BP, UC_X86_REG_SI, UC_X86_REG_DI): self._push(self.regs[register], operand_size)
            elif group == 37:  # POPA
                for register in (UC_X86_REG_DI, UC_X86_REG_SI, UC_X86_REG_BP): self.reg_write(register, self._pop(operand_size))
                self._pop(operand_size)
                for register in (UC_X86_REG_BX, UC_X86_REG_DX, UC_X86_REG_CX, UC_X86_REG_AX): self.reg_write(register, self._pop(operand_size))
            elif group == 15: self.regs[UC_X86_REG_FLAGS] &= ~DF
            elif group == 28:  # IRET
                self.regs[UC_X86_REG_IP] = self._pop(); self.regs[UC_X86_REG_CS] = self._pop(); self.regs[UC_X86_REG_FLAGS] = self._pop() | 2
            elif group == 53:  # XLAT
                # XLAT replaces AL with the byte at DS:[BX + unsigned AL].
                # A segment override changes DS, while operand-size prefixes
                # do not affect the byte lookup.
                segment = segment_override if segment_override is not None else self.regs[UC_X86_REG_DS]
                address = self._physical(segment, self.regs[UC_X86_REG_BX] + self._reg8(0))
                self._set_reg8(0, self.mem_read(address, 1)[0])
            elif group == 27:  # INT imm8
                number = self._fetch8()
                for callback, user in self._intr_hooks:
                    callback(self, number, user)
            elif group == 34: self._push(self._fetch(operand_size), operand_size)
            elif group == 35: self._push(self._fetch(1, signed=True) & ((1 << bits) - 1), operand_size)
            elif group == 38:  # IMUL r,r/m,imm
                modrm = self._fetch8(); register = (modrm >> 3) & 7
                read, _ = self._operand(modrm, operand_size, segment_override)
                left = read(); left = left - (1 << bits) if left & (1 << (bits - 1)) else left
                immediate = self._fetch(1, signed=True) if opcode == 0x6B else self._fetch(operand_size, signed=True)
                product = left * immediate; result = product & ((1 << bits) - 1)
                self.reg_write(register, result)
                overflow = product != (result - (1 << bits) if result & (1 << (bits - 1)) else result)
                self.regs[UC_X86_REG_FLAGS] = self.regs[UC_X86_REG_FLAGS] & ~(CF | OF) | ((CF | OF) if overflow else 0)
            elif group == 41:  # POP r/m
                modrm = self._fetch8()
                if (modrm >> 3) & 7: raise UcError("unsupported 8F group")
                _, write = self._operand(modrm, operand_size, segment_override)
                write(self._pop(operand_size))
            elif group == 42:  # LES/LDS
                modrm = self._fetch8(); reg = (modrm >> 3) & 7
                if modrm >> 6 == 3: raise UcError("LES/LDS requires memory operand")
                address = self._ea(modrm >> 6, modrm & 7, segment_override)
                self.reg_write(reg, int.from_bytes(self.mem_read(address, operand_size), "little"))
                segment = int.from_bytes(self.mem_read(address + operand_size, 2), "little")
                self.reg_write(UC_X86_REG_ES if opcode == 0xC4 else UC_X86_REG_DS, segment)
            elif group == 43:  # LEA
                modrm = self._fetch8(); reg = (modrm >> 3) & 7
                if modrm >> 6 == 3: raise UcError("LEA requires memory operand")
                rm = modrm & 7
                segment = self.regs[UC_X86_REG_SS if rm in (2, 3, 6) and not (modrm >> 6 == 0 and rm == 6) else UC_X86_REG_DS]
                address = self._ea(modrm >> 6, rm, segment)
                self.reg_write(reg, (address - segment * 16) & 0xFFFF)
            elif group == 45:  # INC/DEC r/m8
                modrm = self._fetch8(); operation = (modrm >> 3) & 7
                if operation not in (0, 1): raise UcError(f"unsupported FE group /{operation}")
                read, write = self._operand(modrm, 1, segment_override)
                old_cf = self.regs[UC_X86_REG_FLAGS] & CF
                write(self._alu(0 if operation == 0 else 5, read(), 1, 8))
                self.regs[UC_X86_REG_FLAGS] = self.regs[UC_X86_REG_FLAGS] & ~CF | old_cf
            elif group == 46:  # CBW/CWDE
                if operand_size == 2:
                    self.reg_write(UC_X86_REG_AX, self._reg8(0) | (0xFF00 if self._reg8(0) & 0x80 else 0))
                else:
                    ax = self.regs[UC_X86_REG_AX] & 0xFFFF
                    self.reg_write(UC_X86_REG_AX, ax | (0xFFFF0000 if ax & 0x8000 else 0))
            elif group == 47:  # CWD
                sign = self.regs[UC_X86_REG_AX] & (1 << (bits - 1))
                self.reg_write(UC_X86_REG_DX, (1 << bits) - 1 if sign else 0)
            elif group == 48:  # DAA
                # DAA adjusts the result of an earlier packed-BCD addition.
                # Both correction decisions use the original AL/CF, while AF
                # reflects the low-digit correction and SZP describe new AL.
                old_al = self._reg8(0)
                old_cf = bool(self.regs[UC_X86_REG_FLAGS] & CF)
                al = old_al
                adjust_low = (al & 0x0F) > 9 or bool(self.regs[UC_X86_REG_FLAGS] & AF)
                if adjust_low:
                    al = (al + 0x06) & 0xFF
                adjust_high = old_al > 0x99 or old_cf
                if adjust_high:
                    al = (al + 0x60) & 0xFF
                self._set_reg8(0, al)
                flags = self.regs[UC_X86_REG_FLAGS] & ~(CF | PF | AF | ZF | SF)
                if adjust_high: flags |= CF
                if adjust_low: flags |= AF
                if al == 0: flags |= ZF
                if al & 0x80: flags |= SF
                if self._parity(al): flags |= PF
                self.regs[UC_X86_REG_FLAGS] = flags | 2
            elif group == 49:  # AAM/AAD
                # AAM/AAD carry an explicit radix byte (normally ten).  Their
                # defined flags are SZP from the resulting AL; leave the
                # architecturally undefined arithmetic flags untouched.
                base = self._fetch8()
                al, ah = self._reg8(0), self._reg8(4)
                if opcode == 0xD4:
                    if base == 0:
                        raise UcError("AAM division by zero")
                    self.reg_write(UC_X86_REG_AX, (al // base) << 8 | (al % base))
                else:
                    self.reg_write(UC_X86_REG_AX, (al + ah * base) & 0xFF)
                al = self._reg8(0)
                flags = self.regs[UC_X86_REG_FLAGS] & ~(PF | ZF | SF)
                if al == 0: flags |= ZF
                if al & 0x80: flags |= SF
                if self._parity(al): flags |= PF
                self.regs[UC_X86_REG_FLAGS] = flags | 2
            elif group == 54:  # CMPS
                if not repeat or self.regs[UC_X86_REG_CX]:
                    size = 1 if opcode == 0xA6 else operand_size
                    step = -size if self.regs[UC_X86_REG_FLAGS] & DF else size
                    source_segment = segment_override if segment_override is not None else self.regs[UC_X86_REG_DS]
                    source = self._physical(source_segment, self.regs[UC_X86_REG_SI])
                    destination = self._physical(self.regs[UC_X86_REG_ES], self.regs[UC_X86_REG_DI])
                    left = int.from_bytes(self.mem_read(source, size), "little")
                    right = int.from_bytes(self.mem_read(destination, size), "little")
                    self._alu(7, left, right, size * 8)
                    self.regs[UC_X86_REG_SI] = (self.regs[UC_X86_REG_SI] + step) & 0xFFFF
                    self.regs[UC_X86_REG_DI] = (self.regs[UC_X86_REG_DI] + step) & 0xFFFF
                    if repeat:
                        self.regs[UC_X86_REG_CX] = (self.regs[UC_X86_REG_CX] - 1) & 0xFFFF
                        equal = bool(self.regs[UC_X86_REG_FLAGS] & ZF)
                        if self.regs[UC_X86_REG_CX] and (
                            repeat == 0xF3 and equal or repeat == 0xF2 and not equal
                        ):
                            self.regs[UC_X86_REG_IP] = start_ip
            elif group == 55:  # SCAS
                # SCAS compares AL/AX with ES:[DI]. Segment overrides do not
                # affect the destination of a string instruction.
                if not repeat or self.regs[UC_X86_REG_CX]:
                    size = 1 if opcode == 0xAE else operand_size
                    step = -size if self.regs[UC_X86_REG_FLAGS] & DF else size
                    destination = self._physical(
                        self.regs[UC_X86_REG_ES], self.regs[UC_X86_REG_DI]
                    )
                    left = self._reg8(0) if size == 1 else self.regs[UC_X86_REG_AX]
                    right = int.from_bytes(self.mem_read(destination, size), "little")
                    self._alu(7, left, right, size * 8)
                    self.regs[UC_X86_REG_DI] = (
                        self.regs[UC_X86_REG_DI] + step
                    ) & 0xFFFF
                    if repeat:
                        self.regs[UC_X86_REG_CX] = (
                            self.regs[UC_X86_REG_CX] - 1
                        ) & 0xFFFF
                        equal = bool(self.regs[UC_X86_REG_FLAGS] & ZF)
                        if self.regs[UC_X86_REG_CX] and (
                            repeat == 0xF3 and equal
                            or repeat == 0xF2 and not equal
                        ):
                            self.regs[UC_X86_REG_IP] = start_ip
            elif group == 57: self.regs[UC_X86_REG_FLAGS] ^= CF
            elif group == 58: self.regs[UC_X86_REG_FLAGS] |= DF
            elif group == 60:  # JMP far
                offset = self._fetch(operand_size)
                segment = self._fetch(2)
                self.regs[UC_X86_REG_CS] = segment
                self.regs[UC_X86_REG_IP] = offset & 0xFFFF
            elif group == 61:  # LEAVE
                self.regs[UC_X86_REG_SP] = self.regs[UC_X86_REG_BP] & 0xFFFF
                self.reg_write(UC_X86_REG_BP, self._pop(operand_size))
            elif group == 62:  # ENTER
                allocation, nesting = self._fetch(2), self._fetch8() & 0x1F
                self._push(self.regs[UC_X86_REG_BP], operand_size)
                frame = self.regs[UC_X86_REG_SP]
                for _ in range(1, nesting):
                    self.regs[UC_X86_REG_BP] = (self.regs[UC_X86_REG_BP] - operand_size) & 0xFFFF
                    self._push(int.from_bytes(self.mem_read(self._physical(self.regs[UC_X86_REG_SS], self.regs[UC_X86_REG_BP]), operand_size), "little"), operand_size)
                if nesting: self._push(frame, operand_size)
                self.regs[UC_X86_REG_BP] = frame
                self.regs[UC_X86_REG_SP] = (self.regs[UC_X86_REG_SP] - allocation) & 0xFFFF
            elif group == 64: self.halted = True; self.running = False
            elif group == 65:  # the 386's two-byte opcode escape
                self._two_byte(operand_size, segment_override)
            else:
                self.regs[UC_X86_REG_IP] = start_ip
                raise UcError(f"unsupported opcode {opcode:02x} ({self.profile}) at {physical:#x}")
            retired += 1
            self.retired += 1
        self.last_batch_retired = retired
