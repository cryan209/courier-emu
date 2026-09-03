"""Read-only SV25 recovery-loader experiment; see docs/sv25-recovery.md.

Unicorn supplies 16-bit x86 execution, not an 80188 peripheral or bus model.
This module deliberately owns its small board model instead of inheriting the
application harness's flash programming, DSP, or parameter-store services.
"""
from __future__ import annotations

import argparse
from collections import Counter, deque
from dataclasses import dataclass
from hashlib import sha256
import json
from pathlib import Path
from typing import Any

HEADER_SIZE = 0x80
FLASH_SIZE = 0x80000
FLASH_BASE = 0x80000
BANK_OFFSET = 0x7C000
BANK_PHYSICAL = FLASH_BASE + BANK_OFFSET
ENTRY_OFFSET = 0x1BC0
ENTRY_PHYSICAL = BANK_PHYSICAL + ENTRY_OFFSET
COPY_SIZE = 0x1B14
PROMPT = b"SDL Xmodem file transfer - (Y)es (N)o (T)est >"
BOOTSTRAP = bytes.fromhex("33c08ed88ec08ed0bcf800c706a8ffff00be141bb92400")
DEFAULT_INSTRUCTIONS = 6_000_000

ASSUMPTIONS = [
    "XMD payload: 128-byte XOR blocks, initial key 0x55; next key is the last decoded byte.",
    "Decoded flash maps at 0x80000..0xfffff; CS=fc00, IP=1bc0; DF/IF initially clear.",
    "RAM is zero-filled at 0..0x1ffff, following LCS setup; PCB occupies 0xff00..0xffff.",
    "Chip-select, relocation and board-latch writes are recorded; no speculative bank switch is applied.",
    "IN 0x10 returns 0x08 (ready, EEPROM data zero); IN 0x12 returns 0x40 (recovery straps). Other inputs return all ones.",
    "Serial TX status 0xff66 returns 0x08; TX data at 0xff6a is captured. No host serial device is opened.",
    "At the command wait, one INT1 edge reports timer-1 count 0x50, followed by RX interrupts carrying AT~X!\\r.",
    "Flash identification supplies Intel 0x0089/0x4470 after command 0x90; 0xff restores array reads. All other flash writes stop execution.",
    "Timers, IRQ timing and the 80188 bus are not cycle accurate; only the prompt path is modeled.",
]


def decode_payload(raw: bytes) -> tuple[bytes, tuple[int, ...]]:
    """Decode the chained block view without altering the source bytes."""
    if len(raw) != FLASH_SIZE:
        raise ValueError(f"expected {FLASH_SIZE:#x} payload bytes, got {len(raw):#x}")
    decoded = bytearray()
    keys = []
    key = 0x55
    for start in range(0, len(raw), HEADER_SIZE):
        keys.append(key)
        block = bytes(value ^ key for value in raw[start:start + HEADER_SIZE])
        decoded.extend(block)
        key = block[-1]
    return bytes(decoded), tuple(keys)


@dataclass(frozen=True)
class RecoveryImage:
    path: Path
    source: bytes
    payload: bytes
    block_keys: tuple[int, ...]

    @classmethod
    def load(cls, path: str | Path) -> RecoveryImage:
        path = Path(path).resolve()
        source = path.read_bytes()
        if len(source) != HEADER_SIZE + FLASH_SIZE:
            raise ValueError("SV25.XMD must contain a 128-byte header and 512 KiB payload")
        if source[:5] != bytes.fromhex("b7f0b2fdd8"):
            raise ValueError("missing SV25 SDL header signature")
        payload, keys = decode_payload(source[HEADER_SIZE:])
        if payload[BANK_OFFSET + ENTRY_OFFSET:][:len(BOOTSTRAP)] != BOOTSTRAP:
            raise ValueError("decoded image does not match the SV25 recovery bootstrap")
        # Independent anchors prevent a plausible instruction island from being
        # mistaken for a correct decode or a supported different firmware build.
        if payload[-16:-3] != bytes.fromhex("fabaa4ffb80080efeabf1b00fc"):
            raise ValueError("decoded SV25 reset stub does not confirm the flash map")
        bank = payload[BANK_OFFSET:]
        if bank[0x1BFF:0x1C07] != bytes.fromhex("f3a533c08ed8cd13"):
            raise ValueError("decoded recovery relocation sequence does not match SV25")
        if bank[0x1DB:0x20B].replace(b"\0", b"") != PROMPT:
            raise ValueError("decoded SV25 prompt anchor does not match")
        return cls(path, source, payload, keys)

    def describe(self) -> dict[str, Any]:
        return {
            "path": str(self.path), "source_sha256": sha256(self.source).hexdigest(),
            "decoded_sha256": sha256(self.payload).hexdigest(),
            "source_bytes": len(self.source), "header_bytes": HEADER_SIZE,
            "flash_base": FLASH_BASE, "bootstrap_flash_offset": BANK_OFFSET + ENTRY_OFFSET,
            "bootstrap_file_offset": HEADER_SIZE + BANK_OFFSET + ENTRY_OFFSET,
            "entry": "fc00:1bc0", "entry_physical": ENTRY_PHYSICAL,
            "decode": {"block_bytes": HEADER_SIZE, "initial_key": 0x55,
                       "key_rule": "last byte of preceding decoded block",
                       "recovery_block_keys": [
                           {"flash_offset": n, "key": self.block_keys[n // HEADER_SIZE]}
                           for n in range(BANK_OFFSET, 0x7DC80, HEADER_SIZE)]},
        }


class RecoveryMachine:
    """Execute the bootstrap, relocation, CRC and serial parser up to PROMPT."""

    def __init__(self, image: RecoveryImage, *, serial_stimulus: bool = True):
        try:
            import unicorn as uc
            from unicorn import x86_const as reg
        except ImportError as exc:
            raise RuntimeError("recovery execution requires pip install '.[execute]'") from exc
        self.image, self.uc, self.reg = image, uc, reg
        self.cpu = uc.Uc(uc.UC_ARCH_X86, uc.UC_MODE_16)
        self.cpu.mem_map(0, 0x20000)
        self.cpu.mem_map(FLASH_BASE, FLASH_SIZE, uc.UC_PROT_READ | uc.UC_PROT_EXEC)
        self.cpu.mem_write(FLASH_BASE, image.payload)
        self.cpu.reg_write(reg.UC_X86_REG_CS, 0xFC00)
        self.cpu.reg_write(reg.UC_X86_REG_IP, ENTRY_OFFSET)
        self.cpu.reg_write(reg.UC_X86_REG_EFLAGS, 2)
        self.serial_stimulus = serial_stimulus
        self.rx = deque(b"AT~X!\r" if serial_stimulus else b"")
        self.serial = bytearray()
        self.events: list[dict[str, Any]] = []
        self.write_counts: Counter[int] = Counter()
        self.hot: Counter[int] = Counter()
        self.last: deque[int] = deque(maxlen=24)
        self.instructions = 0
        self.pc, self.instruction_size = ENTRY_PHYSICAL, 0
        self.status, self.error = "ready", None
        self.edge_sent = False
        self.relocation_verified = False
        self.last_cs = 0xFC00
        self.restart = False
        self.flash_command: int | None = None
        self.flash_mode = "array"
        self.ran = False
        self.cpu.hook_add(uc.UC_HOOK_CODE, self._code)
        self.cpu.hook_add(uc.UC_HOOK_INTR, self._interrupt)
        self.cpu.hook_add(uc.UC_HOOK_MEM_WRITE, self._write, begin=0, end=0x1FFFF)
        self.cpu.hook_add(uc.UC_HOOK_MEM_READ, self._read, begin=0xFF00, end=0xFFFF)
        self.cpu.hook_add(uc.UC_HOOK_MEM_WRITE_PROT, self._flash_write)
        self.cpu.hook_add(uc.UC_HOOK_MEM_UNMAPPED, self._unmapped)
        self.cpu.hook_add(uc.UC_HOOK_INSN, self._input, None, 1, 0, reg.UC_X86_INS_IN)
        self.cpu.hook_add(uc.UC_HOOK_INSN, self._output, None, 1, 0, reg.UC_X86_INS_OUT)

    def _get(self, name: str) -> int:
        return self.cpu.reg_read(getattr(self.reg, "UC_X86_REG_" + name.upper()))

    def _set(self, name: str, value: int) -> None:
        self.cpu.reg_write(getattr(self.reg, "UC_X86_REG_" + name.upper()), value)

    def _word(self, address: int) -> int:
        return int.from_bytes(self.cpu.mem_read(address, 2), "little")

    def _event(self, kind: str, **fields: Any) -> None:
        self.events.append({"kind": kind, "instruction": self.instructions,
                            "pc": self.pc, "cs": self._get("cs"),
                            "ip": self._get("ip"), **fields})

    def _stop(self, status: str, error: str | None = None) -> None:
        self.status, self.error = status, error
        self.cpu.emu_stop()

    def _irq(self, vector: int, source: str) -> None:
        offset, segment = self._word(vector * 4), self._word(vector * 4 + 2)
        self._event("interrupt", vector=vector, source=source,
                    target_segment=segment, target_offset=offset)
        sp = self._get("sp")
        for name in ("eflags", "cs", "ip"):
            sp = (sp - 2) & 0xFFFF
            self.cpu.mem_write(self._get("ss") * 16 + sp,
                               (self._get(name) & 0xFFFF).to_bytes(2, "little"))
        self._set("sp", sp)
        self._set("eflags", self._get("eflags") & ~0x300)
        self._set("cs", segment)
        self._set("ip", offset)

    def _interrupt(self, cpu: Any, vector: int, _: Any) -> None:
        if vector != 0x13 or self.pc != BANK_PHYSICAL + 0x1C05:
            self._stop("unexpected-interrupt", f"unexpected software interrupt {vector:#x}")
            return
        copied = bytes(cpu.mem_read(0, COPY_SIZE))
        self.relocation_verified = copied == self.image.payload[BANK_OFFSET:BANK_OFFSET + COPY_SIZE]
        self._event("ram-relocation", flash_offset=BANK_OFFSET, source=BANK_PHYSICAL,
                    destination=0, size=COPY_SIZE, verified=self.relocation_verified)
        if not self.relocation_verified:
            self._stop("relocation-mismatch")
            return
        self._irq(vector, "firmware INT 13h")

    def _code(self, cpu: Any, address: int, size: int, _: Any) -> None:
        self.pc, self.instruction_size = address, size
        self.instructions += 1
        self.hot[address] += 1
        self.last.append(address)
        cs = self._get("cs")
        if cs != self.last_cs:
            self._event("code-segment-change", previous_cs=self.last_cs,
                        flash_offset=address - FLASH_BASE if address >= FLASH_BASE else None)
            self.last_cs = cs
        if address == 0xF7FF5:
            self._stop("application-entry", "recovery path exited to the application")
        if address == 0x10A3:
            computed = self._get("ax")
            stored = self._word(self._get("es") * 16 + self._get("si"))
            self._event("application-crc", computed=computed, stored=stored,
                        matches=computed == stored, flash_start=0x40000, flash_end=0x77FFE)
        # Deliver stimuli only at the actual foreground command wait, after
        # firmware installs and unmasks its handlers. ISR code consumes every
        # byte and recognizes AT and ~X!; no parser flags or buffers are seeded.
        if address == 0x875 and self._get("eflags") & 0x200:
            if not self.serial_stimulus:
                self._stop("serial-input-wait")
            elif not self.edge_sent:
                if self._word(0x34) != 0x167C or self._word(0xFF1A) & 8:
                    self._stop("unexpected-autobaud-state")
                    return
                cpu.mem_write(0xFF38, b"\x50\0")
                self._event("autobaud-edge", timer1_count=0x50)
                self._irq(0x0D, "synthetic INT1 edge")
                self.edge_sent = True
                self.restart = True
                cpu.emu_stop()
            elif self.rx and not self._word(0xFF14) & 8:
                value = self.rx.popleft()
                cpu.mem_write(0xFF68, bytes([value, 0]))
                self._event("serial-rx", value=value)
                self._irq(0x14, "synthetic serial RX")
                self.restart = True
                cpu.emu_stop()

    def _write(self, cpu: Any, access: int, address: int, size: int, value: int, _: Any) -> None:
        self.write_counts[address] += 1
        if 0xFF00 <= address < 0x10000:
            self._event("mmio-write", address=address, size=size, value=value)
            self._mapping_write(address, value)
            if address == 0xFF6A:
                self.serial.append(value & 0xFF)
                self._event("serial-tx", value=value & 0xFF)
                if self.serial.endswith(PROMPT):
                    self._stop("sdl-xmodem-prompt")
        elif address < 0x80 and self.relocation_verified:
            self._event("vector-write", address=address, size=size, value=value)

    def _read(self, cpu: Any, access: int, address: int, size: int, value: int, _: Any) -> None:
        if address == 0xFF66:
            cpu.mem_write(address, (8).to_bytes(size, "little"))

    def _mapping_write(self, address: int, value: int) -> None:
        names = {0xFFA0: "LCS start", 0xFFA2: "LCS stop", 0xFFA4: "UCS start",
                 0xFFA6: "UCS stop", 0xFF90: "CS1 start", 0xFF92: "CS1 stop",
                 0xFFA8: "PCB relocation"}
        if address in names:
            fields = {"register": address, "name": names[address], "value": value}
            if address == 0xFFA8:
                fields.update(base=(value & 0xFFF) << 8, memory_mapped=bool(value & 0x1000))
            else:
                fields["decoded_address"] = (value & 0xFFC0) << 4
            self._event("mapping-register", **fields)

    def _input(self, cpu: Any, port: int, size: int, _: Any) -> int:
        value = {0x10: 0x08, 0x12: 0x40}.get(port, (1 << (size * 8)) - 1)
        self._event("io-read", port=port, size=size, value=value)
        return value

    def _output(self, cpu: Any, port: int, size: int, value: int, _: Any) -> None:
        self._event("io-write", port=port, size=size, value=value,
                    setup=self.pc in (BANK_PHYSICAL + 0x1BDC, BANK_PHYSICAL + 0x1BEA))
        self._mapping_write(port, value)
        if port >= 0xFF00:
            # The initial PCB memory alias and the I/O alias share registers.
            cpu.mem_write(port, value.to_bytes(size, "little"))
        else:
            self._event("board-latch", port=port, size=size, value=value,
                        mapping_effect="none assumed")

    def _flash_write(self, cpu: Any, access: int, address: int, size: int, value: int, _: Any) -> bool:
        # Only emulate the two non-programming commands issued by this build's
        # ID probe. Skip the faulting MOV outside the callback; never make the
        # array writable, and never treat arbitrary stores as harmless commands.
        allowed = size == 2 and address == 0xFFFF0 and (
            (self.pc == 0x733 and value == 0x90 and self.flash_mode == "array") or
            (self.pc == 0x743 and value == 0xFF and self.flash_mode == "identifier"))
        allowed = allowed and bytes(cpu.mem_read(self.pc, self.instruction_size)) == (
            b"\x26\xc7\x06\0\0" + value.to_bytes(2, "little")
        )
        self._event("flash-command" if allowed else "blocked-flash-write",
                    address=address, size=size, value=value)
        if allowed:
            self.flash_command = value
            cpu.emu_stop()
        else:
            self._stop("blocked-flash-write", "flash programming/erase is not implemented")
        return False

    def _unmapped(self, cpu: Any, access: int, address: int, size: int, value: int, _: Any) -> bool:
        self._event("unmapped-access", access=access, address=address, size=size, value=value)
        self._stop("unmapped-access", f"unmodeled memory at {address:#x}")
        return False

    def run(self, instructions: int = DEFAULT_INSTRUCTIONS) -> dict[str, Any]:
        if instructions <= 0:
            raise ValueError("instruction limit must be positive")
        if self.ran:
            raise ValueError("create a fresh recovery machine for each run")
        self.ran = True
        self.status = "instruction-limit"
        while self.instructions < instructions:
            self.restart = False
            try:
                self.cpu.emu_start(self._get("cs") * 16 + self._get("ip"), 0x100000,
                                   count=instructions - self.instructions)
            except self.uc.UcError as exc:
                if self.flash_command is None and self.status == "instruction-limit":
                    self._stop("execution-error", str(exc))
            if self.flash_command is not None:
                command, self.flash_command = self.flash_command, None
                self.flash_mode = "identifier" if command == 0x90 else "array"
                # Host-side writes change the device read view, not the immutable
                # payload. CPU writes remain protected even in identifier mode.
                view = b"\x89\0\x70\x44" if command == 0x90 else self.image.payload[-16:-12]
                self.cpu.mem_write(0xFFFF0, view)
                self._set("ip", (self._get("ip") + self.instruction_size) & 0xFFFF)
                continue
            if not self.restart:
                if self.status == "instruction-limit" and self.instructions < instructions:
                    self._stop("execution-stopped", "CPU stopped before the instruction budget")
                break
        # Restore even if an instruction budget ended during the ID probe.
        self.cpu.mem_write(0xFFFF0, self.image.payload[-16:-12])
        array_unchanged = bytes(self.cpu.mem_read(FLASH_BASE, FLASH_SIZE)) == self.image.payload
        return {
            "status": self.status, "error": self.error, "instructions": self.instructions,
            "image": self.image.describe(), "assumptions": ASSUMPTIONS,
            "serial_stimulus": self.serial_stimulus,
            "serial_text": self.serial.decode("ascii", errors="backslashreplace"),
            "serial_input_remaining": bytes(self.rx).decode("ascii"),
            "registers": {name: self._get(name) for name in
                          ("cs", "ip", "ds", "es", "ss", "sp", "ax", "bx", "cx", "dx", "si", "di", "eflags")},
            "relocation_verified": self.relocation_verified,
            "flash_array_unchanged": array_unchanged,
            "source_file_unchanged": self.image.path.read_bytes() == self.image.source,
            "setup_word_writes": sum(e["kind"] == "io-write" and e.get("setup", False)
                                     and e["size"] == 2 for e in self.events),
            "setup_byte_writes": sum(e["kind"] == "io-write" and e.get("setup", False)
                                     and e["size"] == 1 for e in self.events),
            "events": self.events,
            "memory_write_counts": {f"{address:#07x}": count for address, count in sorted(self.write_counts.items())},
            "hot_addresses": self.hot.most_common(16), "last_addresses": list(self.last),
        }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("image")
    parser.add_argument("--instructions", type=int, default=DEFAULT_INSTRUCTIONS)
    parser.add_argument("--no-serial-stimulus", action="store_true")
    args = parser.parse_args()
    try:
        result = RecoveryMachine(RecoveryImage.load(args.image),
                                 serial_stimulus=not args.no_serial_stimulus).run(args.instructions)
    except (OSError, ValueError, RuntimeError) as exc:
        print(json.dumps({"status": "error", "error": str(exc)}))
        return 1
    print(json.dumps(result, indent=2))
    return 0 if result["status"] == "sdl-xmodem-prompt" else 1


if __name__ == "__main__":
    raise SystemExit(main())
