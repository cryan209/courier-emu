"""Build and bind the non-JIT x86 interpreter's guarded execution loop."""
from __future__ import annotations
from collections import Counter
import importlib.util
import sysconfig
import os
from pathlib import Path
import subprocess
import sys
import tempfile

from .x86_interpreter import UC_X86_REG_AX, UC_X86_REG_CS, UC_X86_REG_IP

ROOT = Path(__file__).resolve().parent.parent
SOURCE = ROOT / "native" / "x86_interpreter.cpp"
LIBRARY = ROOT / ".build" / ("_x86_native" + sysconfig.get_config_var("EXT_SUFFIX"))


def build_library():
    if not LIBRARY.exists() or LIBRARY.stat().st_mtime_ns < SOURCE.stat().st_mtime_ns:
        LIBRARY.parent.mkdir(exist_ok=True)
        # Concurrent workers must never load a half-written shared library.
        fd, name = tempfile.mkstemp(dir=LIBRARY.parent, suffix=LIBRARY.suffix)
        os.close(fd)
        try:
            subprocess.run(["c++", "-std=c++17", "-O3", "-Wall", "-Wextra",
                            *(["-bundle", "-undefined", "dynamic_lookup"] if sys.platform == "darwin" else ["-shared", "-fPIC"]),
                            "-I", sysconfig.get_path("include"),
                            str(SOURCE), "-o", name], check=True, capture_output=True)
            os.replace(name, LIBRARY)
        finally:
            if os.path.exists(name):
                os.unlink(name)
    return LIBRARY


class NativeInterpreter:
    def __init__(self, cpu):
        spec = importlib.util.spec_from_file_location("_x86_native", build_library())
        module = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(module)
        self.run = module.run
        self.guard = bytearray(len(cpu.memory))
        self.signature = None
        self.retired = 0
        self.batches = 0
        self.zero_batches = 0
        self.profile = os.environ.get("COURIER_X86_PROFILE", "0") == "1"
        self.exits = Counter()
        self.handled_io = False
        self.fast_out = bytearray(65536)
        for port in cpu._native_fast_out_ports:
            self.fast_out[port] = 1
        self.io_events = bytearray(65536 * 4)
        self.out_batch_callback = cpu._native_out_batch_callback

    def statistics(self):
        return {"native_retired": self.retired, "batches": self.batches,
                "zero_batches": self.zero_batches,
                "instructions_per_batch": self.retired / max(1, self.batches),
                "exits": self.exits.most_common(20)}

    def execute(self, cpu, count):
        signature = (len(cpu.mapped), len(cpu.hooks))
        if signature != self.signature:
            self.guard[:] = bytes(len(self.guard))
            for first, last, perms in cpu.mapped:
                for bit in (1, 2):
                    if perms & bit:
                        self.guard[first:last] = self.guard[first:last].translate(bytes(v | bit for v in range(256)))
            for hooks, bit in ((cpu._code_hooks, 8), (cpu._read_hooks, 16), (cpu._write_hooks, 32)):
                for _, _, first, last in hooks:
                    if not last:
                        first, last = 0, len(self.guard) - 1
                    first, last = max(0, first), min(len(self.guard) - 1, last)
                    self.guard[first:last+1] = self.guard[first:last+1].translate(bytes(v | bit for v in range(256)))
            self.signature = signature
        done, reason, direction, port, size, value, event_count = self.run(
            cpu.regs, cpu.memory, self.guard, self.fast_out, self.io_events, count
        )
        self.handled_io = reason == 8
        self.batches += 1
        self.zero_batches += done == 0
        if self.profile and reason:
            pc = cpu._physical(cpu.regs[UC_X86_REG_CS], cpu.regs[UC_X86_REG_IP])
            names = ("budget", "unsupported", "boundary", "read-watch", "write-watch",
                     "wide-registers", "code-hook", "system", "io")
            self.exits[(names[reason], hex(pc), hex(cpu.memory[pc]))] += 1
        if event_count and self.out_batch_callback is not None:
            self.out_batch_callback(memoryview(self.io_events), event_count)
        if self.handled_io:
            # Publish the progress preceding this I/O instruction while its
            # callback runs. Device hooks use the retired count to synchronize
            # timers and the DSP at the exact instruction boundary.
            original_retired = cpu.retired
            cpu.retired += done
            try:
                if direction == 1:
                    answer = cpu._io(1, port, size)
                    if size == 1:
                        cpu.regs[UC_X86_REG_AX] = (
                            cpu.regs[UC_X86_REG_AX] & ~0xFF
                        ) | (answer & 0xFF)
                    else:
                        cpu.reg_write(UC_X86_REG_AX, answer)
                else:
                    cpu._io(2, port, size, value)
            finally:
                cpu.retired = original_retired
            done += 1
        self.retired += done
        return done
