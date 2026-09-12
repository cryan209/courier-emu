"""Native basic-block clock for real-time complete-ROM execution."""
from __future__ import annotations

import ctypes
from pathlib import Path
import subprocess
import sys


PROJECT_ROOT = Path(__file__).resolve().parent.parent
SOURCE = PROJECT_ROOT / "native" / "x86_clock.cpp"
BUILD_DIRECTORY = PROJECT_ROOT / ".build"
LIBRARY = BUILD_DIRECTORY / (
    "libcourier_x86_clock.dylib" if sys.platform == "darwin" else "libcourier_x86_clock.so"
)


def build_library(*, force: bool = False) -> Path:
    if not force and LIBRARY.exists() and SOURCE.stat().st_mtime_ns <= LIBRARY.stat().st_mtime_ns:
        return LIBRARY
    import capstone
    import unicorn

    capstone_root = Path(capstone.__file__).resolve().parent
    unicorn_root = Path(unicorn.__file__).resolve().parent
    capstone_library = next((capstone_root / "lib").glob("libcapstone.*"))
    unicorn_library = next((unicorn_root / "lib").glob("libunicorn.*"))
    BUILD_DIRECTORY.mkdir(parents=True, exist_ok=True)
    link_flags = ["-dynamiclib"] if sys.platform == "darwin" else ["-shared", "-fPIC"]
    command = [
        "c++", "-std=c++17", "-O3", "-Wall", "-Wextra", "-Wpedantic",
        *link_flags,
        "-I", str(capstone_root / "include"),
        "-I", str(unicorn_root / "include"),
        str(SOURCE), str(capstone_library), str(unicorn_library),
        "-o", str(LIBRARY),
    ]
    process = subprocess.run(command, text=True, capture_output=True)
    if process.returncode:
        detail = process.stderr.strip() or process.stdout.strip()
        raise RuntimeError(f"failed to build native x86 clock: {detail}")
    return LIBRARY


class NativeX86Clock:
    CALLBACK = ctypes.CFUNCTYPE(None, ctypes.c_uint64, ctypes.c_uint64, ctypes.c_void_p)

    def __init__(self, uc, initial: int, quantum: int, service) -> None:
        self.library = ctypes.CDLL(str(build_library()))
        self._callback = self.CALLBACK(
            lambda total, elapsed, _data: service(int(total), int(elapsed))
        )
        self.library.courier_x86_clock_create.argtypes = [
            ctypes.c_void_p, ctypes.c_uint64, ctypes.c_uint64,
            self.CALLBACK, ctypes.c_void_p,
            ctypes.c_char_p, ctypes.c_size_t,
        ]
        self.library.courier_x86_clock_create.restype = ctypes.c_void_p
        self.library.courier_x86_clock_instructions.argtypes = [ctypes.c_void_p]
        self.library.courier_x86_clock_instructions.restype = ctypes.c_uint64
        self.library.courier_x86_clock_destroy.argtypes = [ctypes.c_void_p]
        error = ctypes.create_string_buffer(512)
        self._handle = self.library.courier_x86_clock_create(
            uc._uch, initial, quantum, self._callback, None, error, len(error)
        )
        if not self._handle:
            raise RuntimeError(error.value.decode("utf-8", "replace"))

    @property
    def instructions(self) -> int:
        return int(self.library.courier_x86_clock_instructions(self._handle))

    def close(self) -> None:
        if self._handle:
            self.library.courier_x86_clock_destroy(self._handle)
            self._handle = None
