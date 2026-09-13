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
        self.regs = [0] * 14
        self.regs[UC_X86_REG_FLAGS] = 2
        self.hooks: list[_Hook] = []
        self._in_memory_hook = False
        self.running = False
        self.halted = False
        self.retired = 0

    def mem_map(self, address: int, size: int, perms: int = 7) -> None:
        if address & 0xFFF or size <= 0 or size & 0xFFF:
            raise UcError("invalid memory mapping (requires 4 KiB alignment)")
        if address < 0 or address + size > len(self.memory):
            raise UcError("invalid memory mapping outside 20-bit address space")
        self.mapped.append((address, address + size, perms))

    def _mapped(self, address: int, size: int, permission: int) -> bool:
        address &= self.address_mask
        return any(first <= address and address + size <= last and perms & permission
                   for first, last, perms in self.mapped)

    def mem_read(self, address: int, size: int) -> bytearray:
        address &= self.address_mask
        if not self._mapped(address, size, UC_PROT_READ):
            if not self._invalid(address, size, 0):
                raise UcError(f"unmapped read at {address:#x}")
        self._memory_hooks(UC_HOOK_MEM_READ, address, size, 0)
        return self.memory[address:address + size]

    def mem_write(self, address: int, data: bytes | bytearray) -> None:
        address &= self.address_mask
        payload = bytes(data)
        if not self._mapped(address, len(payload), UC_PROT_WRITE):
            if not self._invalid(address, len(payload), int.from_bytes(payload[:8], "little")):
                raise UcError(f"unmapped write at {address:#x}")
        value = int.from_bytes(payload[:8], "little")
        self._memory_hooks(UC_HOOK_MEM_WRITE, address, len(payload), value)
        self.memory[address:address + len(payload)] = payload

    def reg_read(self, register: int) -> int:
        return self.regs[register]

    def reg_write(self, register: int, value: int) -> None:
        self.regs[register] = value & (0xFFFFFFFF if self.profile == "386ex" and register < 8 else 0xFFFF)

    def hook_add(self, kind: int, callback: Callable[..., Any], user_data: Any = None,
                 begin: int = 1, end: int = 0, instruction: int | None = None) -> _Hook:
        hook = _Hook(kind, callback, user_data, begin, end, instruction)
        self.hooks.append(hook)
        return hook

    def emu_stop(self) -> None:
        self.running = False

    def _range(self, hook: _Hook, address: int) -> bool:
        return hook.end == 0 or hook.begin <= address <= hook.end

    def _memory_hooks(self, kind: int, address: int, size: int, value: int) -> None:
        if self._in_memory_hook:
            return
        self._in_memory_hook = True
        try:
            for hook in tuple(self.hooks):
                if hook.kind & kind and self._range(hook, address):
                    hook.callback(self, kind, address, size, value, hook.user)
        finally:
            self._in_memory_hook = False

    def _invalid(self, address: int, size: int, value: int) -> bool:
        handled = False
        for hook in tuple(self.hooks):
            if hook.kind & UC_HOOK_MEM_INVALID and self._range(hook, address):
                handled = bool(hook.callback(
                    self, UC_HOOK_MEM_INVALID, address, size, value, hook.user
                )) or handled
        return handled

    def _physical(self, segment: int, offset: int) -> int:
        return ((segment & 0xFFFF) * 16 + (offset & 0xFFFF)) & self.address_mask

    def _fetch8(self) -> int:
        address = self._physical(self.regs[UC_X86_REG_CS], self.regs[UC_X86_REG_IP])
        value = self.memory[address]
        self.regs[UC_X86_REG_IP] = (self.regs[UC_X86_REG_IP] + 1) & 0xFFFF
        return value

    def _fetch(self, size: int, signed: bool = False) -> int:
        value = 0
        for shift in range(0, size * 8, 8):
            value |= self._fetch8() << shift
        if signed and value & (1 << (size * 8 - 1)):
            value -= 1 << (size * 8)
        return value

    def _push(self, value: int, size: int = 2) -> None:
        sp = (self.regs[UC_X86_REG_SP] - size) & 0xFFFF
        self.regs[UC_X86_REG_SP] = sp
        self.mem_write(self._physical(self.regs[UC_X86_REG_SS], sp), value.to_bytes(size, "little"))

    def _pop(self, size: int = 2) -> int:
        sp = self.regs[UC_X86_REG_SP]
        value = int.from_bytes(self.mem_read(self._physical(self.regs[UC_X86_REG_SS], sp), size), "little")
        self.regs[UC_X86_REG_SP] = (sp + size) & 0xFFFF
        return value

    def _parity(self, value: int) -> bool:
        return (value & 0xFF).bit_count() % 2 == 0

    def _logic_flags(self, value: int, bits: int) -> None:
        mask, sign = (1 << bits) - 1, 1 << (bits - 1)
        flags = self.regs[UC_X86_REG_FLAGS] & ~(CF | PF | AF | ZF | SF | OF)
        value &= mask
        if value == 0: flags |= ZF
        if value & sign: flags |= SF
        if self._parity(value): flags |= PF
        self.regs[UC_X86_REG_FLAGS] = flags | 2

    def _alu(self, operation: int, left: int, right: int, bits: int) -> int:
        mask, sign = (1 << bits) - 1, 1 << (bits - 1)
        if operation in (0, 2, 3, 5, 7):
            carry = 1 if self.regs[UC_X86_REG_FLAGS] & CF else 0
            add = operation in (0, 2)
            adjusted = right + carry if operation in (2, 3) else right
            raw = left + adjusted if add else left - adjusted
            result = raw & mask
            self._logic_flags(result, bits)
            flags = self.regs[UC_X86_REG_FLAGS] & ~(CF | AF | OF)
            if add:
                if raw > mask: flags |= CF
                if (~(left ^ adjusted) & (left ^ result) & sign): flags |= OF
            else:
                if left < adjusted: flags |= CF
                if ((left ^ adjusted) & (left ^ result) & sign): flags |= OF
            if (left ^ adjusted ^ result) & 0x10: flags |= AF
            self.regs[UC_X86_REG_FLAGS] = flags | 2
            return result
        if operation == 1: result = left | right
        elif operation == 4: result = left & right
        elif operation == 6: result = left ^ right
        else: raise UcError(f"unsupported ALU operation /{operation}")
        self._logic_flags(result, bits)
        return result & mask

    def _reg8(self, index: int) -> int:
        register = index & 3
        return (self.regs[register] >> (8 if index & 4 else 0)) & 0xFF

    def _set_reg8(self, index: int, value: int) -> None:
        register, shift = index & 3, 8 if index & 4 else 0
        mask = 0xFF << shift
        self.regs[register] = (self.regs[register] & ~mask) | ((value & 0xFF) << shift)

    def _ea(self, mod: int, rm: int, segment_override: int | None) -> int:
        bx, bp, si, di = (self.regs[n] for n in (UC_X86_REG_BX, UC_X86_REG_BP, UC_X86_REG_SI, UC_X86_REG_DI))
        bases = (bx + si, bx + di, bp + si, bp + di, si, di, bp, bx)
        if mod == 0 and rm == 6:
            offset, uses_bp = self._fetch(2), False
        else:
            offset, uses_bp = bases[rm], rm in (2, 3, 6)
            if mod == 1: offset += self._fetch(1, signed=True)
            elif mod == 2: offset += self._fetch(2, signed=True)
        segment = segment_override if segment_override is not None else self.regs[UC_X86_REG_SS if uses_bp else UC_X86_REG_DS]
        return self._physical(segment, offset)

    def _operand(self, modrm: int, size: int, segment: int | None) -> tuple[Callable[[], int], Callable[[int], None]]:
        mod, rm = modrm >> 6, modrm & 7
        if mod == 3:
            if size == 1:
                return lambda: self._reg8(rm), lambda value: self._set_reg8(rm, value)
            return lambda: self.regs[rm] & 0xFFFF, lambda value: self.reg_write(rm, value)
        address = self._ea(mod, rm, segment)
        return (
            lambda: int.from_bytes(self.mem_read(address, size), "little"),
            lambda value: self.mem_write(address, (value & ((1 << (size * 8)) - 1)).to_bytes(size, "little")),
        )

    def _condition(self, code: int) -> bool:
        f = self.regs[UC_X86_REG_FLAGS]
        conditions = (
            bool(f & OF), not f & OF, bool(f & CF), not f & CF,
            bool(f & ZF), not f & ZF, bool(f & (CF | ZF)), not f & (CF | ZF),
            bool(f & SF), not f & SF, bool(f & PF), not f & PF,
            bool(f & SF) != bool(f & OF), bool(f & SF) == bool(f & OF),
            bool(f & ZF) or bool(f & SF) != bool(f & OF),
            not f & ZF and bool(f & SF) == bool(f & OF),
        )
        return bool(conditions[code])

    def _io(self, instruction: int, port: int, size: int, value: int = 0) -> int:
        result = 0
        for hook in tuple(self.hooks):
            if hook.kind & UC_HOOK_INSN and hook.instruction == instruction:
                answer = hook.callback(self, port, size, value, hook.user) if instruction == UC_X86_INS_OUT else hook.callback(self, port, size, hook.user)
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
        retired = 0
        while self.running and (not count or retired < count):
            physical = self._physical(self.regs[UC_X86_REG_CS], self.regs[UC_X86_REG_IP])
            start_ip = self.regs[UC_X86_REG_IP]
            for hook in tuple(self.hooks):
                if hook.kind & (UC_HOOK_CODE | UC_HOOK_BLOCK) and self._range(hook, physical):
                    hook.callback(self, physical, 1, hook.user)
            if not self.running:
                break
            if self._physical(
                self.regs[UC_X86_REG_CS], self.regs[UC_X86_REG_IP]
            ) != physical:
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
            opcode = self._fetch8()
            while opcode in (0x26, 0x2E, 0x36, 0x3E, 0x66, 0x67, 0xF0, 0xF2, 0xF3):
                if opcode in (0x26, 0x2E, 0x36, 0x3E):
                    segment_override = self.regs[{0x26: UC_X86_REG_ES, 0x2E: UC_X86_REG_CS, 0x36: UC_X86_REG_SS, 0x3E: UC_X86_REG_DS}[opcode]]
                elif opcode in (0x66, 0x67):
                    if self.profile != "386ex": raise UcError(f"386 prefix {opcode:02x} in 186eb profile at {physical:#x}")
                    if opcode == 0x66: operand_size = 4
                    else: raise UcError(f"32-bit addressing not implemented at {physical:#x}")
                elif opcode in (0xF2, 0xF3):
                    repeat = opcode
                opcode = self._fetch8()
            bits = operand_size * 8
            if 0xB0 <= opcode <= 0xB7: self._set_reg8(opcode - 0xB0, self._fetch(1))
            elif 0xB8 <= opcode <= 0xBF: self.reg_write(opcode - 0xB8, self._fetch(operand_size))
            elif (opcode & 0xC6) in (0x04, 0x05) and opcode < 0x40:
                operation = (opcode >> 3) & 7; size = 1 if not opcode & 1 else operand_size
                left = self._reg8(0) if size == 1 else self.regs[UC_X86_REG_AX]
                result = self._alu(operation, left, self._fetch(size), size * 8)
                if operation != 7:
                    self._set_reg8(0, result) if size == 1 else self.reg_write(UC_X86_REG_AX, result)
            elif 0x50 <= opcode <= 0x57: self._push(self.regs[opcode - 0x50], operand_size)
            elif 0x58 <= opcode <= 0x5F: self.reg_write(opcode - 0x58, self._pop(operand_size))
            elif opcode == 0x68: self._push(self._fetch(operand_size), operand_size)
            elif opcode == 0x6A: self._push(self._fetch(1, signed=True) & ((1 << bits) - 1), operand_size)
            elif opcode == 0x60:
                original_sp = self.regs[UC_X86_REG_SP]
                for register in (UC_X86_REG_AX, UC_X86_REG_CX, UC_X86_REG_DX, UC_X86_REG_BX): self._push(self.regs[register], operand_size)
                self._push(original_sp, operand_size)
                for register in (UC_X86_REG_BP, UC_X86_REG_SI, UC_X86_REG_DI): self._push(self.regs[register], operand_size)
            elif opcode == 0x61:
                for register in (UC_X86_REG_DI, UC_X86_REG_SI, UC_X86_REG_BP): self.reg_write(register, self._pop(operand_size))
                self._pop(operand_size)
                for register in (UC_X86_REG_BX, UC_X86_REG_DX, UC_X86_REG_CX, UC_X86_REG_AX): self.reg_write(register, self._pop(operand_size))
            elif opcode in (0x69, 0x6B):
                modrm = self._fetch8(); register = (modrm >> 3) & 7
                read, _ = self._operand(modrm, operand_size, segment_override)
                left = read(); left = left - (1 << bits) if left & (1 << (bits - 1)) else left
                immediate = self._fetch(1, signed=True) if opcode == 0x6B else self._fetch(operand_size, signed=True)
                product = left * immediate; result = product & ((1 << bits) - 1)
                self.reg_write(register, result)
                overflow = product != (result - (1 << bits) if result & (1 << (bits - 1)) else result)
                self.regs[UC_X86_REG_FLAGS] = self.regs[UC_X86_REG_FLAGS] & ~(CF | OF) | ((CF | OF) if overflow else 0)
            elif opcode in (0x06, 0x0E, 0x16, 0x1E):
                self._push(self.regs[{0x06: UC_X86_REG_ES, 0x0E: UC_X86_REG_CS, 0x16: UC_X86_REG_SS, 0x1E: UC_X86_REG_DS}[opcode]])
            elif opcode in (0x07, 0x17, 0x1F):
                self.reg_write({0x07: UC_X86_REG_ES, 0x17: UC_X86_REG_SS, 0x1F: UC_X86_REG_DS}[opcode], self._pop())
            elif 0x40 <= opcode <= 0x47:
                register = opcode - 0x40; old_cf = self.regs[UC_X86_REG_FLAGS] & CF
                self.reg_write(register, self._alu(0, self.regs[register], 1, bits)); self.regs[UC_X86_REG_FLAGS] = self.regs[UC_X86_REG_FLAGS] & ~CF | old_cf
            elif 0x48 <= opcode <= 0x4F:
                register = opcode - 0x48; old_cf = self.regs[UC_X86_REG_FLAGS] & CF
                self.reg_write(register, self._alu(5, self.regs[register], 1, bits)); self.regs[UC_X86_REG_FLAGS] = self.regs[UC_X86_REG_FLAGS] & ~CF | old_cf
            elif opcode in (0x88, 0x89, 0x8A, 0x8B):
                modrm = self._fetch8(); reg = (modrm >> 3) & 7; size = 1 if opcode in (0x88, 0x8A) else operand_size
                read, write = self._operand(modrm, size, segment_override)
                if opcode in (0x88, 0x89): write(self._reg8(reg) if size == 1 else self.regs[reg])
                elif size == 1: self._set_reg8(reg, read())
                else: self.reg_write(reg, read())
            elif opcode in (0xC6, 0xC7):
                modrm = self._fetch8(); size = 1 if opcode == 0xC6 else operand_size
                _, write = self._operand(modrm, size, segment_override); write(self._fetch(size))
            elif opcode == 0x8F:
                modrm = self._fetch8()
                if (modrm >> 3) & 7: raise UcError("unsupported 8F group")
                _, write = self._operand(modrm, operand_size, segment_override)
                write(self._pop(operand_size))
            elif opcode in (0x8C, 0x8E):
                modrm = self._fetch8(); seg = (modrm >> 3) & 3; read, write = self._operand(modrm, 2, segment_override)
                segment_reg = (UC_X86_REG_ES, UC_X86_REG_CS, UC_X86_REG_SS, UC_X86_REG_DS)[seg]
                if opcode == 0x8C: write(self.regs[segment_reg])
                else: self.reg_write(segment_reg, read())
            elif opcode in (0xC4, 0xC5):
                modrm = self._fetch8(); reg = (modrm >> 3) & 7
                if modrm >> 6 == 3: raise UcError("LES/LDS requires memory operand")
                address = self._ea(modrm >> 6, modrm & 7, segment_override)
                self.reg_write(reg, int.from_bytes(self.mem_read(address, operand_size), "little"))
                segment = int.from_bytes(self.mem_read(address + operand_size, 2), "little")
                self.reg_write(UC_X86_REG_ES if opcode == 0xC4 else UC_X86_REG_DS, segment)
            elif opcode == 0x8D:
                modrm = self._fetch8(); reg = (modrm >> 3) & 7
                if modrm >> 6 == 3: raise UcError("LEA requires memory operand")
                rm = modrm & 7
                segment = self.regs[UC_X86_REG_SS if rm in (2, 3, 6) and not (modrm >> 6 == 0 and rm == 6) else UC_X86_REG_DS]
                address = self._ea(modrm >> 6, rm, segment)
                self.reg_write(reg, (address - segment * 16) & 0xFFFF)
            elif opcode in (0x00,0x01,0x02,0x03,0x08,0x09,0x0A,0x0B,0x10,0x11,0x12,0x13,0x18,0x19,0x1A,0x1B,0x20,0x21,0x22,0x23,0x28,0x29,0x2A,0x2B,0x30,0x31,0x32,0x33,0x38,0x39,0x3A,0x3B):
                operation = (opcode >> 3) & 7; modrm = self._fetch8(); reg = (modrm >> 3) & 7; size = 1 if not opcode & 1 else operand_size
                read, write = self._operand(modrm, size, segment_override); source, dest = (self._reg8(reg) if size == 1 else self.regs[reg]), read()
                if opcode & 2: source, dest = dest, source
                result = self._alu(operation, dest, source, size * 8)
                if operation != 7:
                    if opcode & 2:
                        self._set_reg8(reg, result) if size == 1 else self.reg_write(reg, result)
                    else: write(result)
            elif opcode in (0x80, 0x81, 0x83):
                modrm = self._fetch8(); operation = (modrm >> 3) & 7; size = 1 if opcode == 0x80 else operand_size
                read, write = self._operand(modrm, size, segment_override)
                immediate = self._fetch(1, signed=opcode == 0x83) if opcode in (0x80,0x83) else self._fetch(size)
                result = self._alu(operation, read(), immediate & ((1 << (size*8))-1), size*8)
                if operation != 7: write(result)
            elif opcode in (0x84, 0x85):
                modrm = self._fetch8(); reg = (modrm >> 3) & 7
                size = 1 if opcode == 0x84 else operand_size
                read, _ = self._operand(modrm, size, segment_override)
                value = self._reg8(reg) if size == 1 else self.regs[reg]
                self._logic_flags(read() & value, size * 8)
            elif opcode in (0x86, 0x87):
                modrm = self._fetch8(); reg = (modrm >> 3) & 7
                size = 1 if opcode == 0x86 else operand_size
                read, write = self._operand(modrm, size, segment_override)
                memory_value = read()
                register_value = self._reg8(reg) if size == 1 else self.regs[reg]
                write(register_value)
                self._set_reg8(reg, memory_value) if size == 1 else self.reg_write(reg, memory_value)
            elif opcode in (0xF6, 0xF7):
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
            elif opcode == 0xFF:
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
            elif opcode == 0xFE:
                modrm = self._fetch8(); operation = (modrm >> 3) & 7
                if operation not in (0, 1): raise UcError(f"unsupported FE group /{operation}")
                read, write = self._operand(modrm, 1, segment_override)
                old_cf = self.regs[UC_X86_REG_FLAGS] & CF
                write(self._alu(0 if operation == 0 else 5, read(), 1, 8))
                self.regs[UC_X86_REG_FLAGS] = self.regs[UC_X86_REG_FLAGS] & ~CF | old_cf
            elif opcode in (0xD0, 0xD1, 0xD2, 0xD3, 0xC0, 0xC1):
                modrm = self._fetch8(); operation = (modrm >> 3) & 7
                size = 1 if opcode in (0xD0, 0xD2, 0xC0) else operand_size
                read, write = self._operand(modrm, size, segment_override)
                shift_count = (1 if opcode in (0xD0, 0xD1) else self._reg8(1) if opcode in (0xD2, 0xD3) else self._fetch8()) & 0x1F
                value, bits = read(), size * 8
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
                    write(result)
                    if operation >= 4:
                        self._logic_flags(result, bits)
                    self.regs[UC_X86_REG_FLAGS] = self.regs[UC_X86_REG_FLAGS] & ~CF | (CF if carry else 0)
            elif 0x70 <= opcode <= 0x7F:
                displacement = self._fetch(1, signed=True)
                if self._condition(opcode & 15): self.regs[UC_X86_REG_IP] = (self.regs[UC_X86_REG_IP] + displacement) & 0xFFFF
            elif 0xE0 <= opcode <= 0xE3:
                displacement = self._fetch(1, signed=True)
                if opcode == 0xE3:
                    take = self.regs[UC_X86_REG_CX] == 0
                else:
                    self.regs[UC_X86_REG_CX] = (self.regs[UC_X86_REG_CX] - 1) & 0xFFFF
                    take = self.regs[UC_X86_REG_CX] != 0
                    if opcode == 0xE0: take = take and not self.regs[UC_X86_REG_FLAGS] & ZF
                    elif opcode == 0xE1: take = take and bool(self.regs[UC_X86_REG_FLAGS] & ZF)
                if take: self.regs[UC_X86_REG_IP] = (self.regs[UC_X86_REG_IP] + displacement) & 0xFFFF
            elif 0x90 <= opcode <= 0x97:
                register = opcode - 0x90
                self.regs[UC_X86_REG_AX], self.regs[register] = self.regs[register], self.regs[UC_X86_REG_AX]
            elif opcode == 0x98:
                if operand_size == 2:
                    self.reg_write(UC_X86_REG_AX, self._reg8(0) | (0xFF00 if self._reg8(0) & 0x80 else 0))
                else:
                    ax = self.regs[UC_X86_REG_AX] & 0xFFFF
                    self.reg_write(UC_X86_REG_AX, ax | (0xFFFF0000 if ax & 0x8000 else 0))
            elif opcode == 0x99:
                sign = self.regs[UC_X86_REG_AX] & (1 << (bits - 1))
                self.reg_write(UC_X86_REG_DX, (1 << bits) - 1 if sign else 0)
            elif opcode == 0x27:
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
            elif opcode in (0xD4, 0xD5):
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
            elif opcode == 0x9C: self._push(self.regs[UC_X86_REG_FLAGS])
            elif opcode == 0x9D: self.reg_write(UC_X86_REG_FLAGS, self._pop() | 2)
            elif opcode in (0xA8, 0xA9):
                size = 1 if opcode == 0xA8 else operand_size
                value = self._reg8(0) if size == 1 else self.regs[UC_X86_REG_AX]
                self._logic_flags(value & self._fetch(size), size * 8)
            elif opcode in (0xA0, 0xA1, 0xA2, 0xA3):
                size = 1 if opcode in (0xA0, 0xA2) else operand_size
                segment = segment_override if segment_override is not None else self.regs[UC_X86_REG_DS]
                address = self._physical(segment, self._fetch(2))
                if opcode in (0xA0, 0xA1):
                    value = int.from_bytes(self.mem_read(address, size), "little")
                    self._set_reg8(0, value) if size == 1 else self.reg_write(UC_X86_REG_AX, value)
                else:
                    value = self._reg8(0) if size == 1 else self.regs[UC_X86_REG_AX]
                    self.mem_write(address, value.to_bytes(size, "little"))
            elif opcode == 0xD7:
                # XLAT replaces AL with the byte at DS:[BX + unsigned AL].
                # A segment override changes DS, while operand-size prefixes
                # do not affect the byte lookup.
                segment = segment_override if segment_override is not None else self.regs[UC_X86_REG_DS]
                address = self._physical(segment, self.regs[UC_X86_REG_BX] + self._reg8(0))
                self._set_reg8(0, self.mem_read(address, 1)[0])
            elif opcode in (0xA4, 0xA5, 0xAC, 0xAD, 0xAA, 0xAB):
                if not repeat or self.regs[UC_X86_REG_CX]:
                    size = 1 if opcode in (0xA4, 0xAC, 0xAA) else operand_size
                    step = -size if self.regs[UC_X86_REG_FLAGS] & DF else size
                    source_segment = segment_override if segment_override is not None else self.regs[UC_X86_REG_DS]
                    if opcode in (0xA4, 0xA5, 0xAC, 0xAD):
                        source = self._physical(source_segment, self.regs[UC_X86_REG_SI])
                        value = int.from_bytes(self.mem_read(source, size), "little")
                        self.regs[UC_X86_REG_SI] = (self.regs[UC_X86_REG_SI] + step) & 0xFFFF
                    else:
                        value = self._reg8(0) if size == 1 else self.regs[UC_X86_REG_AX]
                    if opcode in (0xA4, 0xA5, 0xAA, 0xAB):
                        destination = self._physical(self.regs[UC_X86_REG_ES], self.regs[UC_X86_REG_DI])
                        self.mem_write(destination, value.to_bytes(size, "little"))
                        self.regs[UC_X86_REG_DI] = (self.regs[UC_X86_REG_DI] + step) & 0xFFFF
                    else:
                        if size == 1: self._set_reg8(0, value)
                        else: self.reg_write(UC_X86_REG_AX, value)
                    if repeat:
                        self.regs[UC_X86_REG_CX] = (self.regs[UC_X86_REG_CX] - 1) & 0xFFFF
                        # Re-enter once with CX zero. This performs no memory
                        # operation but matches the boundary at which Unicorn
                        # retires a REP instruction and advances past it.
                        self.regs[UC_X86_REG_IP] = start_ip
            elif opcode == 0xFA: self.regs[UC_X86_REG_FLAGS] &= ~IF
            elif opcode == 0xFB: self.regs[UC_X86_REG_FLAGS] |= IF
            elif opcode == 0xF8: self.regs[UC_X86_REG_FLAGS] &= ~CF
            elif opcode == 0xF9: self.regs[UC_X86_REG_FLAGS] |= CF
            elif opcode == 0xF5: self.regs[UC_X86_REG_FLAGS] ^= CF
            elif opcode == 0xFC: self.regs[UC_X86_REG_FLAGS] &= ~DF
            elif opcode == 0xFD: self.regs[UC_X86_REG_FLAGS] |= DF
            elif opcode == 0xE8:
                displacement = self._fetch(operand_size, signed=True); self._push(self.regs[UC_X86_REG_IP], operand_size); self.regs[UC_X86_REG_IP] = (self.regs[UC_X86_REG_IP] + displacement) & 0xFFFF
            elif opcode == 0x9A:
                offset = self._fetch(operand_size)
                segment = self._fetch(2)
                self._push(self.regs[UC_X86_REG_CS])
                self._push(self.regs[UC_X86_REG_IP], operand_size)
                self.regs[UC_X86_REG_CS] = segment
                self.regs[UC_X86_REG_IP] = offset & 0xFFFF
            elif opcode == 0xEA:
                offset = self._fetch(operand_size)
                segment = self._fetch(2)
                self.regs[UC_X86_REG_CS] = segment
                self.regs[UC_X86_REG_IP] = offset & 0xFFFF
            elif opcode == 0xE9:
                displacement = self._fetch(operand_size, signed=True)
                self.regs[UC_X86_REG_IP] = (self.regs[UC_X86_REG_IP] + displacement) & 0xFFFF
            elif opcode == 0xEB:
                displacement = self._fetch(1, signed=True)
                self.regs[UC_X86_REG_IP] = (self.regs[UC_X86_REG_IP] + displacement) & 0xFFFF
            elif opcode in (0xC3, 0xC2):
                self.regs[UC_X86_REG_IP] = self._pop(operand_size)
                if opcode == 0xC2: self.regs[UC_X86_REG_SP] = (self.regs[UC_X86_REG_SP] + self._fetch(2)) & 0xFFFF
            elif opcode == 0xC9:
                self.regs[UC_X86_REG_SP] = self.regs[UC_X86_REG_BP] & 0xFFFF
                self.reg_write(UC_X86_REG_BP, self._pop(operand_size))
            elif opcode == 0xC8:
                allocation, nesting = self._fetch(2), self._fetch8() & 0x1F
                self._push(self.regs[UC_X86_REG_BP], operand_size)
                frame = self.regs[UC_X86_REG_SP]
                for _ in range(1, nesting):
                    self.regs[UC_X86_REG_BP] = (self.regs[UC_X86_REG_BP] - operand_size) & 0xFFFF
                    self._push(int.from_bytes(self.mem_read(self._physical(self.regs[UC_X86_REG_SS], self.regs[UC_X86_REG_BP]), operand_size), "little"), operand_size)
                if nesting: self._push(frame, operand_size)
                self.regs[UC_X86_REG_BP] = frame
                self.regs[UC_X86_REG_SP] = (self.regs[UC_X86_REG_SP] - allocation) & 0xFFFF
            elif opcode in (0xCB, 0xCA):
                self.regs[UC_X86_REG_IP] = self._pop(); self.regs[UC_X86_REG_CS] = self._pop()
                if opcode == 0xCA: self.regs[UC_X86_REG_SP] = (self.regs[UC_X86_REG_SP] + self._fetch(2)) & 0xFFFF
            elif opcode == 0xCD:
                number = self._fetch8()
                for hook in tuple(self.hooks):
                    if hook.kind & UC_HOOK_INTR: hook.callback(self, number, hook.user)
            elif opcode == 0xCF:
                self.regs[UC_X86_REG_IP] = self._pop(); self.regs[UC_X86_REG_CS] = self._pop(); self.regs[UC_X86_REG_FLAGS] = self._pop() | 2
            elif opcode in (0xE4,0xE5,0xEC,0xED):
                size = 1 if opcode in (0xE4,0xEC) else operand_size; port = self._fetch8() if opcode in (0xE4,0xE5) else self.regs[UC_X86_REG_DX]
                value = self._io(UC_X86_INS_IN, port, size)
                if size == 1: self._set_reg8(0, value)
                else: self.reg_write(UC_X86_REG_AX, value)
            elif opcode in (0xE6,0xE7,0xEE,0xEF):
                size = 1 if opcode in (0xE6,0xEE) else operand_size; port = self._fetch8() if opcode in (0xE6,0xE7) else self.regs[UC_X86_REG_DX]
                self._io(UC_X86_INS_OUT, port, size, self._reg8(0) if size == 1 else self.regs[UC_X86_REG_AX])
            elif opcode == 0xF4: self.halted = True; self.running = False
            else:
                self.regs[UC_X86_REG_IP] = start_ip
                raise UcError(f"unsupported opcode {opcode:02x} ({self.profile}) at {physical:#x}")
            retired += 1
            self.retired += 1
        self.last_batch_retired = retired
