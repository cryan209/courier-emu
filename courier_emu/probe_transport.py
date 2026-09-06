"""RAM supervisor launcher, C5x mailbox sender and serial capture experiment.

The integrated test executes both processors. Only ASIC handshakes, DSP boot
ROM acceptance/launch and UART readiness are modeled. See docs/dsp-rom-probe.md.
"""
from __future__ import annotations

import argparse
from collections import Counter
from dataclasses import dataclass
from hashlib import sha256
import json
from pathlib import Path
import re
import struct

from .dsp_probe import (ROM_DUMP_WORDS, RomProbe, build_probe,
                        build_rom_dump_probe, build_boot_word_probe,
                        BOOT_WORD_ADDRESS, BOOT_WORD_SAMPLES, inspect_buffer)
from .rom import CourierRom

REFERENCE_DIGEST = "49f4182cc961aef983ff43468b7b7e55c03205c9dba80e9689fe20aa6ff2ccc5"
ENTRY = 0x2000
ROUTINES = 0x2400
KERNEL = 0x3000
RESULT = 0x4000
SUM = RESULT + 112
STATUS = SUM + 2
# The ROM dump needs 4096 bytes rather than 112, so it is put well clear of the
# monitor, the relocated routines and the kernel, and below the stack the
# monitor sets at 0xeff0.
ROM_DUMP_RESULT = 0x8000
# Where the ROM-dump build places itself. The default layout is not usable on
# the board: docs/ram-probe-delivery.md surveyed live RAM for pages that read
# as zero, and 0x2000-0x20ff and 0x2c00-0x2dff are not among them, so an image
# spanning 0x2000-0x306f would be written over RAM the firmware is using and
# could crash it before the hook is armed. This layout sits entirely inside the
# surveyed 20 KiB block at 0x2e00-0x7eff, with the result buffer in the 12 KiB
# block at 0x8000.
ROM_DUMP_ENTRY, ROM_DUMP_ROUTINES, ROM_DUMP_KERNEL = 0x3000, 0x3400, 0x4000
REFERENCE_START = 0xE370
REFERENCE_END = 0xE598
STATUS_NAMES = {0: "complete", 1: "reset-timeout", 2: "download-timeout",
                3: "mailbox-timeout", 4: "mailbox-tag-error", 5: "uart-timeout"}


class Code:
    """Emit the small 80188 program with checked 16-bit label relocations."""
    def __init__(self, origin: int = ENTRY):
        self.origin = origin
        self.data = bytearray()
        self.labels: dict[str, int] = {}
        self.fixups: list[tuple[int, str, bool]] = []

    def emit(self, value: str):
        self.data.extend(bytes.fromhex(value))

    def word(self, value: int):
        self.data.extend(struct.pack("<H", value))

    def label(self, name: str):
        if name in self.labels:
            raise ValueError(f"duplicate label {name}")
        self.labels[name] = self.origin + len(self.data)

    def absolute(self, opcode: str, target: str):
        self.emit(opcode)
        self.fixups.append((len(self.data), target, False))
        self.word(0)

    def jump(self, target: str, opcode: str = "e9"):
        self.emit(opcode)
        self.fixups.append((len(self.data), target, True))
        self.word(0)

    def branch(self, opcode: int, target: str):
        # 80188 conditional branches are short only: inverse condition skips
        # a three-byte near JMP. Never emit a 386-only 0F 8x branch.
        self.data.extend((opcode ^ 1, 3))
        self.jump(target)

    def call_address(self, address: int):
        self.emit("e8")
        self.word((address - (self.origin + len(self.data) + 2)) & 0xFFFF)

    def finish(self) -> bytes:
        for offset, name, relative in self.fixups:
            address = self.labels[name]
            if relative:
                address = (address - (self.origin + offset + 2)) & 0xFFFF
            struct.pack_into("<H", self.data, offset, address)
        return bytes(self.data)


@dataclass(frozen=True)
class Diagnostic:
    reference: CourierRom
    probe: RomProbe
    ram: bytes
    labels: dict[str, int]
    # Where this build put its result buffer and how many words it expects.
    # The ROM dump moves both, so nothing may assume the module constants.
    count: int = 0x38
    result_base: int = RESULT
    sum_at: int = SUM
    status_at: int = STATUS
    # Where this build loads. The ROM dump moves off the default layout to sit
    # in RAM the board survey found free.
    entry: int = ENTRY
    routines_at: int = ROUTINES
    kernel_at: int = KERNEL


def build_diagnostic(reference_path: str | Path, *, rom_dump: bool = False,
                     relocated_layout: bool = False,
                     rom_words: int = ROM_DUMP_WORDS,
                     rom_origin: int = 0,
                     boot_word: bool = False,
                     boot_word_address: int = BOOT_WORD_ADDRESS,
                     boot_word_samples: int = BOOT_WORD_SAMPLES) -> Diagnostic:
    """Build the RAM monitor and the DSP kernel it delivers.

    With `rom_dump` the DSP kernel is the full on-chip ROM reader rather than
    the 56-word sample probe: 2048 words instead of 56, which moves the result
    buffer and every count baked into the monitor. Everything else - the
    relocated launch and download routines, the mailbox collection, the
    serial frame - is the same path.
    """
    reference = CourierRom.load(reference_path)
    if reference.digest != REFERENCE_DIGEST:
        raise ValueError("unsupported reference ROM: exact IDSDL302 profile required")
    # The board's watchdog resets a halted monitor after about a second and a
    # half, and printing the whole 2048 words does not fit inside that: the run
    # that found this got 491 words out and was cut off mid-line. A window lets
    # the dump be taken in pieces that do fit.
    if rom_dump and boot_word:
        raise ValueError("choose one DSP kernel: the ROM dump or the boot word")
    if boot_word:
        # Sixteen words print well inside the watchdog window that truncated
        # the ROM dump, so this one needs no windowing.
        probe = build_boot_word_probe(boot_word_address, boot_word_samples)
        count = boot_word_samples
    elif rom_dump:
        probe = build_rom_dump_probe(rom_words, origin=rom_origin)
        count = rom_words
    else:
        probe = build_probe(mailbox=True)
        count = 0x38
    # The relocated layout is the one that fits the surveyed-free RAM on the
    # board; the default is kept only because existing artifacts record it.
    relocate = rom_dump or boot_word or relocated_layout
    compact = rom_dump or boot_word
    entry = ROM_DUMP_ENTRY if relocate else ENTRY
    routines_at = ROM_DUMP_ROUTINES if relocate else ROUTINES
    kernel_at = ROM_DUMP_KERNEL if relocate else KERNEL
    # The relocated kernel sits at 0x4000, which is the default result buffer,
    # so the buffer moves whenever the layout does - not only for the ROM dump.
    result_base = ROM_DUMP_RESULT if relocate else RESULT
    sum_at = result_base + 2 * count
    status_at = sum_at + 2
    routines = reference.data[REFERENCE_START:REFERENCE_END]
    if routines.count(bytes.fromhex("b808a9")) != 2:
        raise ValueError("reference source-segment relocation mismatch")
    # All near branches/calls stay within this contiguous block. Only two
    # source-segment immediates change, from the flash segment A908 to the one
    # holding the kernel - which is why the kernel has to sit on a paragraph
    # boundary, and why moving it means moving this constant with it.
    if kernel_at % 16:
        raise ValueError("kernel must be paragraph-aligned to be addressed as a segment")
    routines = routines.replace(
        bytes.fromhex("b808a9"),
        b"\xb8" + struct.pack("<H", kernel_at >> 4))
    relocated = lambda address: routines_at + address - REFERENCE_START
    c = Code(entry)
    c.label("entry")
    c.emit("fa fc 31c0 8ed8 8ec0 8ed0 bcf0ef")  # CLI; CLD; DS=ES=SS=0; SP=eff0
    c.emit("c606"); c.word(status_at); c.emit("ff")
    def puts(label):
        c.absolute("be", label); c.jump("puts", "e8")
    puts("start_text")
    c.call_address(relocated(0xE370))
    c.emit("b80080")
    c.call_address(relocated(0xE3AA))
    c.branch(0x72, "reset_error")
    c.emit("31c0 b9"); c.word(len(probe.payload))
    c.call_address(relocated(0xE447))
    c.emit("31c0 b9"); c.word(len(probe.payload))
    c.call_address(relocated(0xE47B))
    c.branch(0x72, "download_error")
    c.emit("bb0052 bf"); c.word(result_base)
    c.emit("b9"); c.word(count); c.emit("31d2")  # BX expected tag; DI buffer; CX count; DX checksum
    c.label("next_word")
    c.emit("bdffff")
    c.label("rx_wait")
    c.emit("e41c a802")
    c.branch(0x75, "rx_ready")
    c.emit("4d")
    c.branch(0x75, "rx_wait")
    c.jump("mailbox_error")
    c.label("rx_ready")
    c.emit("e45a 88c4 e458 39d8")  # header high/low; CMP AX,BX
    c.branch(0x75, "tag_error")
    c.emit("e45e 88c4 e45c ab 01c2")  # data high/low; STOSW; ADD DX,AX
    c.emit("b002 e61c 30c0 e61e 43 49")
    c.branch(0x75, "next_word")
    c.emit("8916"); c.word(sum_at)
    puts("data_text")
    c.emit("be"); c.word(result_base)
    c.emit("31db b9"); c.word(count)
    c.label("print_word")
    if compact:
        # `NNNN:VVVV\r\n` is eleven bytes a word, and 2048 of those take about
        # two seconds to clock out at 115200 - longer than the board's watchdog
        # allows a halted monitor to live. The run that found this printed 491
        # words and was reset mid-line. Four bytes a word fits; the tag
        # sequence already ordered the words during collection, and the
        # checksum still covers them.
        c.emit("ad"); c.jump("hex", "e8")
        c.emit("49"); c.branch(0x75, "print_word")
        c.jump("newline", "e8")
    else:
        c.emit("89d8"); c.jump("hex", "e8")
        c.emit("b03a"); c.jump("putc", "e8")
        c.emit("ad"); c.jump("hex", "e8")
        c.jump("newline", "e8")
        c.emit("43 49"); c.branch(0x75, "print_word")
    puts("sum_text")
    c.emit("a1"); c.word(sum_at); c.jump("hex", "e8")
    c.jump("newline", "e8")
    puts("done_text")
    c.emit("c606"); c.word(status_at); c.emit("00")
    c.jump("halt")
    for label, status, message in (("reset_error", 1, "reset_text"),
                                    ("download_error", 2, "download_text"),
                                    ("mailbox_error", 3, "mailbox_text"),
                                    ("tag_error", 4, "tag_text")):
        c.label(label); c.emit("c606"); c.word(status_at); c.data.append(status)
        puts(message); c.jump("halt")
    c.label("puts")
    c.emit("ac 84c0"); c.branch(0x74, "puts_end")
    c.jump("putc", "e8"); c.jump("puts")
    c.label("puts_end"); c.emit("c3")
    c.label("putc")
    c.emit("50 51 b9ffff")
    c.label("tx_wait")
    c.emit("f70666ff0800")
    c.branch(0x75, "tx_ready")
    c.emit("49"); c.branch(0x75, "tx_wait")
    c.emit("c606"); c.word(status_at); c.emit("05")
    c.jump("halt")
    c.label("tx_ready")
    c.emit("30e4 a36aff 59 58 c3")
    c.label("hex")
    c.emit("50 53 51 52 89c3 b90400")
    c.label("digit")
    c.emit("c1c304 88d8 240f 3c0a")
    c.branch(0x72, "decimal")
    c.emit("0437"); c.jump("digit_out")
    c.label("decimal"); c.emit("0430")
    c.label("digit_out"); c.jump("putc", "e8")
    c.emit("49"); c.branch(0x75, "digit")
    c.emit("5a 59 5b 58 c3")
    c.label("newline")
    c.emit("b00d"); c.jump("putc", "e8")
    c.emit("b00a"); c.jump("putc", "e8"); c.emit("c3")
    c.label("halt"); c.emit("fa f4"); c.jump("halt")
    for name, text in (("start_text", "CDRP1 START\r\n"),
                       ("data_text", f"CDRP1 DATA {count:04X}\r\n"), ("sum_text", "SUM:"),
                       ("done_text", "CDRP1 DONE\r\n"),
                       ("reset_text", "CDRP1 ERR RESET\r\n"),
                       ("download_text", "CDRP1 ERR DOWNLOAD\r\n"),
                       ("mailbox_text", "CDRP1 ERR MAILBOX\r\n"),
                       ("tag_text", "CDRP1 ERR TAG\r\n")):
        c.label(name); c.data.extend(text.encode() + b"\0")
    code = c.finish()
    if entry + len(code) > routines_at or routines_at + len(routines) > kernel_at:
        raise ValueError("diagnostic memory regions overlap")
    ram = bytearray(kernel_at + len(probe.payload) - entry)
    ram[:len(code)] = code
    ram[routines_at - entry:routines_at - entry + len(routines)] = routines
    ram[kernel_at - entry:] = probe.payload
    return Diagnostic(reference, probe, bytes(ram), c.labels,
                      count, result_base, sum_at, status_at,
                      entry, routines_at, kernel_at)


def parse_capture(data: bytes) -> dict:
    """Validate a complete serial capture; never promote it to proven ROM."""
    try:
        text = data.decode("ascii")
    except UnicodeDecodeError as exc:
        raise ValueError("capture is not ASCII") from exc
    lines = text.splitlines()
    # The frame declares its own length, so one parser serves the 56-word
    # sample probe and the 2048-word ROM dump.
    if len(lines) < 4 or lines[0] != "CDRP1 START" or lines[-1] != "CDRP1 DONE":
        raise ValueError("incomplete, repeated or failed diagnostic frame")
    header = re.fullmatch(r"CDRP1 DATA ([0-9A-F]{4})", lines[1])
    if not header:
        raise ValueError("missing or malformed data header")
    count = int(header[1], 16)
    joined = "".join(lines[2:-2])
    if re.fullmatch(r"[0-9A-F]+", joined or "x") and len(joined) == count * 4:
        # The compact form the ROM dump uses: four hex digits a word, no
        # position prefix, because the addressed form does not clock out inside
        # the board's watchdog window. Ordering was enforced by the tag
        # sequence during collection and the checksum still covers the words.
        words = [int(joined[i:i + 4], 16) for i in range(0, len(joined), 4)]
    else:
        if len(lines) != count + 4:
            raise ValueError("frame length does not match its declared word count")
        words = []
        for index, line in enumerate(lines[2:2 + count]):
            if not re.fullmatch(r"[0-9A-F]{4}:[0-9A-F]{4}", line):
                raise ValueError("invalid diagnostic word record")
            position, value = (int(v, 16) for v in line.split(":"))
            if position != index:
                raise ValueError("missing, duplicate or out-of-order word")
            words.append(value)
    if not re.fullmatch(r"SUM:[0-9A-F]{4}", lines[-2]) or int(lines[-2][4:], 16) != sum(words) & 0xFFFF:
        raise ValueError("diagnostic checksum mismatch")
    if len(words) != 0x38:
        # A ROM dump is raw program words with no header or controls, so there
        # is nothing to inspect - only the frame's own integrity, checked
        # above. Uniform or bus-like data is still not proof of a readable ROM.
        result = {"status": "rom-dump-captured", "word_count": count,
                  "words": words,
                  "rom_sha256": sha256(struct.pack(f"<{count}H", *words)).hexdigest(),
                  "distinct_values": len(set(words))}
    else:
        result = inspect_buffer(words)
        if result["status"] != "sample-captured":
            raise ValueError("probe controls or completion marker failed")
    result["capture_sha256"] = sha256(data).hexdigest()
    return result


class _EmptyDSP:
    def dsp_program_segments(self):
        return []


class TransportMachine:
    """Execute a RAM monitor and its downloaded DSP through a modeled mailbox.

    Result bytes must travel through DSP OUT/SAMM -> modeled latches -> CPU IN
    -> CPU UART store. No emulator data-buffer reads feed the serial output.
    """
    def __init__(self, diagnostic: Diagnostic, *, rom_mapped: bool = True,
                 fault: str | None = None):
        import unicorn as uc
        from unicorn import x86_const as r
        from .dsp import NativeC5x
        from .timers import TimerBlock
        if fault not in (None, "reset", "checksum", "no-dsp", "tag", "uart", "stale"):
            raise ValueError("unknown transport fault")
        self.diagnostic, self.fault, self.uc, self.r = diagnostic, fault, uc, r
        # The DSP's budget has to cover its send loop, which is per word, plus
        # the ROM dump's own `rpt`-driven block read. 10000 was sized for the
        # 56-word probe and is not enough for 2048.
        self.dsp_step_limit = 10_000 + 40 * diagnostic.count
        self.cpu = uc.Uc(uc.UC_ARCH_X86, uc.UC_MODE_16)
        self.cpu.mem_map(0, 0x10000)
        self.cpu.mem_map(0x80000, 0x80000, uc.UC_PROT_READ | uc.UC_PROT_EXEC)
        self.cpu.mem_write(0x80000, diagnostic.reference.data)
        self.cpu.mem_write(diagnostic.entry, diagnostic.ram)
        self.cpu.mem_write(0xFF56, b"\xdb\0")
        self.cpu.reg_write(r.UC_X86_REG_CS, 0)
        self.cpu.reg_write(r.UC_X86_REG_IP, diagnostic.entry)
        self.cpu.reg_write(r.UC_X86_REG_EFLAGS, 2)
        self.core = NativeC5x(_EmptyDSP())
        self.fixture = tuple((0x1234 + i * 0x193) & 0xFFFF for i in range(4096))
        self.external_fixture = tuple((0xA55A ^ i * 0x101) & 0xFFFF for i in range(32))
        self.core.load_rom(struct.pack("<4096H", *self.fixture))
        self.core.load_program(struct.pack("<32H", *self.external_fixture), 0)
        self.core.set_mpmc_pin(0 if rom_mapped else 1)
        self.core.set_io(0x57, 2)
        self.rom_mapped = rom_mapped
        # These polls test for failure, not a requested delay. Fast mode would
        # force MAX COUNT on the first read and turn every handshake into a
        # timeout before the firmware even reads the acknowledgement ports.
        self.timers = TimerBlock(fast=False)
        self.window = bytearray(16)
        self.gpio = 0xDB
        self.resetting = False
        self.origin = None
        self.boot_status = 3
        self.captured = bytearray()
        self.checksum_ok = False
        self.launched = False
        self.active = False
        self.pending: tuple[int, int] | None = None
        self.tag_latch = self.data_latch = 0
        self.dsp_cursor = 0
        self.dsp_steps = 0
        self.packets = self.acks = 0
        self.serial = bytearray()
        self.events: list[dict] = []
        self.read_counts: Counter[int] = Counter()
        self.instructions = self.pc = 0
        self.halted = False
        self.error = None
        self.started = False
        self.cpu.hook_add(uc.UC_HOOK_CODE, self._code)
        self.cpu.hook_add(uc.UC_HOOK_MEM_READ, self._read, begin=0xFF00, end=0xFFFF)
        self.cpu.hook_add(uc.UC_HOOK_MEM_WRITE, self._write, begin=0, end=0xFFFF)
        self.cpu.hook_add(uc.UC_HOOK_MEM_INVALID, self._invalid)
        self.cpu.hook_add(uc.UC_HOOK_INSN, self._input, None, 1, 0, r.UC_X86_INS_IN)
        self.cpu.hook_add(uc.UC_HOOK_INSN, self._output, None, 1, 0, r.UC_X86_INS_OUT)

    def _event(self, kind, **fields):
        self.events.append({"kind": kind, "pc": self.pc, "instruction": self.instructions, **fields})

    def _code(self, cpu, address, size, _):
        self.pc = address
        self.instructions += 1
        if bytes(cpu.mem_read(address, 1)) == b"\xf4":
            self.halted = True
            cpu.emu_stop()

    def _invalid(self, cpu, access, address, size, value, _):
        self.error = f"invalid memory access {access} at {address:#x}"
        self._event("invalid-memory", address=address, size=size, value=value)
        cpu.emu_stop()
        return False

    def _read(self, cpu, access, address, size, value, _):
        value = self.timers.read(address, size, self.instructions)
        if address == 0xFF66:
            value = 0 if self.fault == "uart" else 8
        if value is not None:
            cpu.mem_write(address, value.to_bytes(size, "little"))

    def _write(self, cpu, access, address, size, value, _):
        if address < 0xFF00:
            return
        self._event("mmio-write", address=address, size=size, value=value)
        self.timers.write(address, size, value, self.instructions)
        if address == 0xFF6A:
            self.serial.append(value & 0xFF)
        if address == 0xFF56:
            if self.gpio & 2 and not value & 2:
                self.origin = int.from_bytes(self.window[:2], "little")
                self.resetting = True
                self.active = False
                self.pending = None
                self.captured.clear()
                self.boot_status = 3
                self._event("dsp-reset", requested_origin=self.origin)
            self.gpio = value

    def _pump(self):
        if not self.active or self.pending is not None:
            return
        for _ in range(64):
            if self.core.state()["pc"] == self.diagnostic.probe.halt_address:
                self.active = False
                return
            if self.dsp_steps >= self.dsp_step_limit:
                self.error = "DSP instruction limit"
                self.active = False
                return
            self.core.step(1)
            self.dsp_steps += 1
            # Work only with actual peripheral writes. No core.data() readback.
            count = self.core.state()["io_events"]
            for index in range(self.dsp_cursor, count):
                import ctypes
                raw = (ctypes.c_uint64 * 5)()
                self.core.library.courier_c5x_get_io_event(self.core.handle, index, raw, 5)
                write, port, value, pc, instruction = map(int, raw)
                if not write:
                    continue
                self._event("dsp-io-write", dsp_pc=pc, port=port, value=value)
                if port == 0x5E:
                    self.tag_latch = value
                elif port == 0x5F:
                    self.data_latch = value
                elif port == 0x57 and value == 2:
                    tag = self.tag_latch
                    if self.fault == "tag" and self.packets == 8:
                        tag ^= 1
                    if self.fault == "stale" and self.packets == 1:
                        tag = 0x5200
                    self.pending = (tag, self.data_latch)
                    self.packets += 1
                    self.core.set_io(0x57, 0)
                    self._event("mailbox-publish", tag=tag, value=self.data_latch)
            self.dsp_cursor = count
            if self.pending is not None:
                return

    def _input(self, cpu, port, size, _):
        self.read_counts[port] += 1
        if self.resetting and port in (0x18, 0x1A, 0x1C, 0x1E):
            return 0 if self.fault == "reset" else 0xFF
        if port == 0x18:
            return self.boot_status
        if port in (0x1A, 0x1E):
            return 0
        if port == 0x1C:
            self._pump()
            return 2 if self.pending is not None else 0
        if 0x58 <= port <= 0x5E and port % 2 == 0:
            if self.pending is None:
                self.error = "CPU read empty mailbox"
                return 0xFF
            offset = port - 0x58
            word = self.pending[0 if offset < 4 else 1]
            return (word >> (8 if offset & 2 else 0)) & 0xFF
        return (1 << (size * 8)) - 1

    def _output(self, cpu, port, size, value, _):
        self._event("io-write", port=port, size=size, value=value)
        if 0x40 <= port <= 0x5E and port % 2 == 0:
            self.window[(port - 0x40) // 2] = value & 0xFF
        if self.resetting:
            if port == 0x1C and value == 2:
                self.resetting = False
                self._event("bootstrap-ready", requested_origin=self.origin)
            return
        if port == 0x18 and self.origin == 0x8000:
            if value in (1, 2):
                start = 0 if value == 1 else 8
                self.captured.extend(self.window[start:start + 8])
            elif value == 4:
                supplied = int.from_bytes(self.window[:2], "little")
                actual = sum(struct.unpack(f"<{len(self.captured) // 2}H", self.captured)) & 0xFFFF
                self.checksum_ok = supplied == actual and self.fault != "checksum"
                self._event("download-checksum", supplied=supplied, computed=actual,
                            accepted=self.checksum_ok, bytes=len(self.captured))
                self.boot_status = 4 if self.checksum_ok else 0
                if self.checksum_ok and self.fault != "no-dsp":
                    if bytes(self.captured) != self.diagnostic.probe.payload:
                        raise RuntimeError("downloaded bytes do not match the probe")
                    self.core.load_program(bytes(self.captured), self.origin)
                    self.core.set_pc(self.origin)
                    self.active = self.launched = True
                    self._event("modeled-dsp-launch", origin=self.origin,
                                assumption="boot ROM accepts checksum/end strobe and starts requested origin")
        if port == 0x1C and value == 2 and self.pending is not None:
            self._event("mailbox-ack", tag=self.pending[0])
            self.pending = None
            self.acks += 1
            self.core.set_io(0x57, 2)

    def run(self, instructions: int = 1_000_000) -> dict:
        if instructions <= 0 or self.started:
            raise ValueError("use a fresh machine with a positive instruction budget")
        self.started = True
        try:
            try:
                self.cpu.emu_start(ENTRY, 0x10000, count=instructions)
            except self.uc.UcError as exc:
                self.error = self.error or str(exc)
            status_byte = self.cpu.mem_read(self.diagnostic.status_at, 1)[0]
            status = STATUS_NAMES.get(status_byte, "unknown-status") if self.halted else "instruction-limit"
            if self.error:
                status = "execution-error"
            decoded = None
            capture_error = None
            if status == "complete":
                try:
                    decoded = parse_capture(bytes(self.serial))
                except ValueError as exc:
                    capture_error = str(exc)
                    status = "invalid-capture"
            expected = list(self.fixture[:32] if self.rom_mapped else self.external_fixture)
            return {"status": status, "error": self.error, "capture_error": capture_error,
                    "instructions": self.instructions, "dsp_steps": self.dsp_steps,
                    "hardware_tested": False, "uploadable_sdl_image": False,
                    "rom_mapped_fixture": self.rom_mapped, "fault": self.fault,
                    "serial_text": self.serial.decode("ascii", errors="backslashreplace"),
                    "capture": decoded,
                    "sample_matches_fixture": decoded is not None
                        and decoded.get("sample") == expected,
                    # The ROM dump has no sample/controls; what checks it here
                    # is the whole word list against the fixture this machine
                    # mapped as the on-chip ROM.
                    "rom_matches_fixture": decoded is not None
                        and "words" in decoded
                        and decoded["words"] == list(self.fixture[:decoded["word_count"]]),
                    "download_matches_kernel": bytes(self.captured) == self.diagnostic.probe.payload,
                    "download_checksum_matches": self.checksum_ok, "dsp_launched": self.launched,
                    "packets": self.packets, "acks": self.acks, "events": self.events,
                    "io_read_counts": {hex(p): n for p, n in sorted(self.read_counts.items())},
                    "source_file_unchanged": self.diagnostic.reference.path.read_bytes() == self.diagnostic.reference.data,
                    "flash_array_unchanged": bytes(self.cpu.mem_read(0x80000, 0x80000)) == self.diagnostic.reference.data,
                    "assumptions": [
                        "Entry is 0000:2000 with PCB already at ff00, initialized DTE UART, RAM and chip selects.",
                        "All result words travel through actual DSP mailbox instructions and actual supervisor IN/UART stores.",
                        "ASIC latch/status cross-wiring is inferred from paired firmware routines, not measured on hardware.",
                        "Boot-ROM reset acknowledgements, checksum acceptance and jump to the requested 8000 are modeled.",
                        "DSP scheduling is driven by supervisor polling; not cycle accurate. UART is immediately ready.",
                        "ROM contents are synthetic; optional C5x ROM protection is not modeled.",
                        "RAM loading mechanism and a compatible flashable SDL container are not implemented."]}
        finally:
            self.core.close()


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--reference", type=Path)
    parser.add_argument("--output", type=Path)
    parser.add_argument("--capture", type=Path, help="validate a saved CDRP1 serial frame")
    parser.add_argument("--external-fixture", action="store_true")
    parser.add_argument("--fault", choices=("reset", "checksum", "no-dsp", "tag", "uart", "stale"))
    parser.add_argument("--rom-words", type=lambda v: int(v, 0), default=ROM_DUMP_WORDS,
                        help="how many words this run reads (default 2048)")
    parser.add_argument("--rom-origin", type=lambda v: int(v, 0), default=0,
                        help="program address this run starts at (default 0)")
    parser.add_argument("--relocate", action="store_true",
                        help="load at 0x3000/0x3400/0x4000 instead of the default "
                             "0x2000/0x2400/0x3000, which straddles RAM the board "
                             "survey found in use (implied by --rom-dump)")
    parser.add_argument("--boot-word", action="store_true",
                        help="read the DSP's boot-mode word at data 0xffff "
                             "instead of dumping the ROM (docs/dsp-boot-transport.md)")
    parser.add_argument("--boot-word-address", type=lambda v: int(v, 0),
                        default=BOOT_WORD_ADDRESS)
    parser.add_argument("--boot-word-samples", type=lambda v: int(v, 0),
                        default=BOOT_WORD_SAMPLES)
    parser.add_argument("--rom-dump", action="store_true",
                        help="carry the full 2048-word on-chip ROM reader instead of "
                             "the 56-word sample probe")
    args = parser.parse_args()
    try:
        if args.capture:
            decoded = parse_capture(args.capture.read_bytes())
            words = decoded.pop("words", None)
            if words is not None:
                # A real capture of this kind is the object of the exercise:
                # write it out beside the capture rather than printing 2048
                # words of JSON.
                image = args.capture.with_suffix(".rom.bin")
                image.write_bytes(struct.pack(f"<{len(words)}H", *words))
                decoded["rom_image"] = str(image)
            print(json.dumps(decoded, indent=2))
            return 0
        if not args.reference or not args.output:
            parser.error("--reference and --output are required to build and verify")
        if args.output.exists():
            parser.error("output directory already exists")
        diagnostic = build_diagnostic(args.reference, rom_dump=args.rom_dump,
                                      boot_word=args.boot_word,
                                      boot_word_address=args.boot_word_address,
                                      boot_word_samples=args.boot_word_samples,
                                     relocated_layout=args.relocate,
                                     rom_words=args.rom_words,
                                     rom_origin=args.rom_origin)
        result = TransportMachine(diagnostic, rom_mapped=not args.external_fixture, fault=args.fault).run()
        args.output.mkdir(parents=True)
        (args.output / "diagnostic-ram.bin").write_bytes(diagnostic.ram)
        (args.output / "probe-c5x.bin").write_bytes(diagnostic.probe.payload)
        (args.output / "serial.txt").write_bytes(result["serial_text"].encode("ascii"))
        result["load_map"] = {"entry": f"0000:{diagnostic.entry:04x}", "ram_image_base": diagnostic.entry,
                              "ram_image_bytes": len(diagnostic.ram), "copied_routines": diagnostic.routines_at,
                              "kernel_source": diagnostic.kernel_at,
                              "result_buffer": diagnostic.result_base,
                              "status_byte": diagnostic.status_at,
                              "words_expected": diagnostic.count,
                              "labels": diagnostic.labels,
                              "reference_sha256": diagnostic.reference.digest,
                              "ram_image_sha256": sha256(diagnostic.ram).hexdigest()}
        (args.output / "manifest.json").write_text(json.dumps(result, indent=2) + "\n")
        print(json.dumps({"status": result["status"], "output": str(args.output.resolve()),
                          "packets": result["packets"], "acks": result["acks"],
                          "hardware_tested": False, "uploadable_sdl_image": False}))
        return 0 if result["status"] == "complete" else 1
    except (ValueError, RuntimeError, OSError) as exc:
        parser.error(str(exc))
    return 1


if __name__ == "__main__":
    raise SystemExit(main())
