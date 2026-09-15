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

from .x86_interpreter import UC_X86_REG_CS, UC_X86_REG_IP

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
        done, reason = self.run(cpu.regs, cpu.memory, self.guard, count)
        self.batches += 1
        self.zero_batches += done == 0
        if self.profile and reason:
            pc = cpu._physical(cpu.regs[UC_X86_REG_CS], cpu.regs[UC_X86_REG_IP])
            names = ("budget", "unsupported", "boundary", "read-watch", "write-watch",
                     "wide-registers", "code-hook", "io-or-system")
            self.exits[(names[reason], hex(pc), hex(cpu.memory[pc]))] += 1
        self.retired += done
        return done
