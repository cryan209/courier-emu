from __future__ import annotations

import ctypes
import json
from pathlib import Path
import subprocess
import sys
from typing import Any

from .xmf import XmfImage


PROJECT_ROOT = Path(__file__).resolve().parent.parent
NATIVE_DIRECTORY = PROJECT_ROOT / "native"
BUILD_DIRECTORY = PROJECT_ROOT / ".build"
RUNNER = BUILD_DIRECTORY / "c5x_runner"
LIBRARY = BUILD_DIRECTORY / ("libcourier_c5x.dylib" if sys.platform == "darwin" else "libcourier_c5x.so")
SOURCES = (
    NATIVE_DIRECTORY / "c5x_core.cpp",
    NATIVE_DIRECTORY / "c5x_optable.cpp",
    NATIVE_DIRECTORY / "c5x_runner.cpp",
    NATIVE_DIRECTORY / "c5x_core.h",
    NATIVE_DIRECTORY / "c5x_ops.ipp",
)
LIBRARY_SOURCES = SOURCES[:2] + (NATIVE_DIRECTORY / "c5x_capi.cpp",) + SOURCES[3:]


def build_runner(*, force: bool = False) -> Path:
    if not force and RUNNER.exists():
        runner_time = RUNNER.stat().st_mtime_ns
        if all(source.stat().st_mtime_ns <= runner_time for source in SOURCES):
            return RUNNER
    BUILD_DIRECTORY.mkdir(parents=True, exist_ok=True)
    command = [
        "c++",
        "-std=c++17",
        "-O2",
        "-Wall",
        "-Wextra",
        "-Wpedantic",
        *(str(source) for source in SOURCES[:3]),
        "-o",
        str(RUNNER),
    ]
    process = subprocess.run(command, text=True, capture_output=True)
    if process.returncode:
        detail = process.stderr.strip() or process.stdout.strip()
        raise RuntimeError(f"failed to build the C5x runner: {detail}")
    return RUNNER


def build_library(*, force: bool = False) -> Path:
    if not force and LIBRARY.exists():
        library_time = LIBRARY.stat().st_mtime_ns
        if all(source.stat().st_mtime_ns <= library_time for source in LIBRARY_SOURCES):
            return LIBRARY
    BUILD_DIRECTORY.mkdir(parents=True, exist_ok=True)
    link_flags = ["-dynamiclib"] if sys.platform == "darwin" else ["-shared", "-fPIC"]
    command = [
        "c++", "-std=c++17", "-O2", "-Wall", "-Wextra", "-Wpedantic",
        *link_flags,
        *(str(source) for source in LIBRARY_SOURCES[:3]),
        "-o", str(LIBRARY),
    ]
    process = subprocess.run(command, text=True, capture_output=True)
    if process.returncode:
        detail = process.stderr.strip() or process.stdout.strip()
        raise RuntimeError(f"failed to build the C5x library: {detail}")
    return LIBRARY


# The C52's wait-state generator, from sections 9.4.1 to 9.4.3 of the C5x
# User's Guide. PDWSR gives each 16K block of program and data space a two-bit
# field; IOWSR gives each pair of I/O ports one, or each 8K block when CWSR's
# BIG bit is set. CWSR also chooses what the two-bit values mean.
PDWSR_FIELDS = (
    ("program", 0x0000, 0x3FFF, 0),
    ("program", 0x4000, 0x7FFF, 2),
    ("program", 0x8000, 0xBFFF, 4),
    ("program", 0xC000, 0xFFFF, 6),
    ("data", 0x0000, 0x3FFF, 8),
    ("data", 0x4000, 0x7FFF, 10),
    ("data", 0x8000, 0xBFFF, 12),
    ("data", 0xC000, 0xFFFF, 14),
)
# A field means its own value, unless the space's CWSR bit stretches the top
# two steps.
WAIT_STATE_STEPS = {0: (0, 1, 2, 3), 1: (0, 1, 3, 7)}
CWSR_BIG = 1 << 4
CWSR_SPACE_BIT = {"program": 0, "data": 1, "io-low": 2, "io-high": 3}


def decode_wait_states(pdwsr: int, iowsr: int, cwsr: int) -> dict[str, Any]:
    """Read the wait-state registers as the ranges they describe.

    Software wait states only apply to off-chip accesses, so a non-zero field
    is the firmware saying it expects external memory in that range.
    """

    def steps(space: str) -> tuple[int, ...]:
        return WAIT_STATE_STEPS[(cwsr >> CWSR_SPACE_BIT[space]) & 1]

    regions = []
    for space, first, last, shift in PDWSR_FIELDS:
        count = steps(space)[(pdwsr >> shift) & 3]
        regions.append(
            {"space": space, "first": first, "last": last, "wait_states": count}
        )
    big = bool(cwsr & CWSR_BIG)
    for block in range(8):
        count = steps("io-high" if block >= 4 else "io-low")[(iowsr >> (2 * block)) & 3]
        entry: dict[str, Any] = {"space": "io", "wait_states": count}
        if big:
            entry["first"], entry["last"] = block * 0x2000, block * 0x2000 + 0x1FFF
        else:
            entry["ports"] = f"every port pair {2 * block:x}/{2 * block + 1:x}"
        regions.append(entry)
    return {
        "io_mapping": "8K blocks" if big else "port pairs",
        "external": [region for region in regions if region["wait_states"]],
        "regions": regions,
    }


class NativeC5x:
    """Incrementally stepped C52 instance used by the dual-processor harness."""

    def __init__(self, image: XmfImage, *, rebuild: bool = False) -> None:
        self.library = ctypes.CDLL(str(build_library(force=rebuild)))
        self._configure_api()
        self.handle = self.library.courier_c5x_create()
        if not self.handle:
            raise RuntimeError("failed to create C5x core")
        try:
            for origin, segment in image.dsp_program_segments():
                storage = (ctypes.c_uint8 * len(segment)).from_buffer_copy(segment)
                error = ctypes.create_string_buffer(512)
                result = self.library.courier_c5x_load_program(
                    self.handle, origin, storage, len(segment), error, len(error)
                )
                if result:
                    raise RuntimeError(error.value.decode("utf-8", "replace"))
        except Exception:
            self.close()
            raise

    def _configure_api(self) -> None:
        lib = self.library
        lib.courier_c5x_create.restype = ctypes.c_void_p
        lib.courier_c5x_destroy.argtypes = [ctypes.c_void_p]
        lib.courier_c5x_load_program.argtypes = [
            ctypes.c_void_p, ctypes.c_uint16, ctypes.POINTER(ctypes.c_uint8),
            ctypes.c_size_t, ctypes.c_char_p, ctypes.c_size_t,
        ]
        lib.courier_c5x_step.argtypes = [
            ctypes.c_void_p, ctypes.c_uint64, ctypes.c_char_p, ctypes.c_size_t,
        ]
        lib.courier_c5x_load_rom.argtypes = [
            ctypes.c_void_p, ctypes.c_uint16, ctypes.POINTER(ctypes.c_uint8),
            ctypes.c_size_t, ctypes.c_char_p, ctypes.c_size_t,
        ]
        lib.courier_c5x_set_mpmc_pin.argtypes = [ctypes.c_void_p, ctypes.c_int]
        lib.courier_c5x_get_memory_map.argtypes = [
            ctypes.c_void_p, ctypes.POINTER(ctypes.c_uint64), ctypes.c_size_t
        ]
        lib.courier_c5x_set_io.argtypes = [ctypes.c_void_p, ctypes.c_uint16, ctypes.c_uint16]
        lib.courier_c5x_host_write.argtypes = [
            ctypes.c_void_p, ctypes.c_uint16, ctypes.c_uint16
        ]
        lib.courier_c5x_queue_serial_rx.argtypes = [
            ctypes.c_void_p, ctypes.POINTER(ctypes.c_uint16), ctypes.c_size_t
        ]
        lib.courier_c5x_queue_codec_rx.argtypes = [
            ctypes.c_void_p, ctypes.POINTER(ctypes.c_uint16), ctypes.c_size_t
        ]
        lib.courier_c5x_set_dtmf_digits.argtypes = [
            ctypes.c_void_p, ctypes.c_char_p, ctypes.c_size_t
        ]
        lib.courier_c5x_get_io.argtypes = [ctypes.c_void_p, ctypes.c_uint16]
        lib.courier_c5x_get_io.restype = ctypes.c_uint16
        lib.courier_c5x_get_data.argtypes = [ctypes.c_void_p, ctypes.c_uint16]
        lib.courier_c5x_get_data.restype = ctypes.c_uint16
        lib.courier_c5x_set_data.argtypes = [ctypes.c_void_p, ctypes.c_uint16, ctypes.c_uint16]
        lib.courier_c5x_interrupt.argtypes = [ctypes.c_void_p, ctypes.c_uint]
        lib.courier_c5x_get_state.argtypes = [
            ctypes.c_void_p, ctypes.POINTER(ctypes.c_uint64), ctypes.c_size_t
        ]
        lib.courier_c5x_get_serial_state.argtypes = [
            ctypes.c_void_p, ctypes.POINTER(ctypes.c_uint64), ctypes.c_size_t
        ]
        lib.courier_c5x_set_data_trace.argtypes = [ctypes.c_void_p, ctypes.c_int]
        lib.courier_c5x_clear_data_events.argtypes = [ctypes.c_void_p]
        lib.courier_c5x_get_data_event_count.argtypes = [ctypes.c_void_p]
        lib.courier_c5x_get_data_event_count.restype = ctypes.c_size_t
        lib.courier_c5x_get_data_event.argtypes = [
            ctypes.c_void_p, ctypes.c_size_t, ctypes.POINTER(ctypes.c_uint64), ctypes.c_size_t
        ]
        lib.courier_c5x_get_io_event_count.argtypes = [ctypes.c_void_p]
        lib.courier_c5x_get_io_event_count.restype = ctypes.c_size_t
        lib.courier_c5x_get_io_port_stats.argtypes = [
            ctypes.c_void_p, ctypes.c_uint16,
            ctypes.POINTER(ctypes.c_uint64), ctypes.c_size_t,
        ]
        lib.courier_c5x_get_io_event.argtypes = [
            ctypes.c_void_p, ctypes.c_size_t, ctypes.POINTER(ctypes.c_uint64), ctypes.c_size_t
        ]
        lib.courier_c5x_get_line_tx_sample.argtypes = [ctypes.c_void_p, ctypes.c_size_t]
        lib.courier_c5x_get_line_tx_sample.restype = ctypes.c_uint16

    def close(self) -> None:
        if getattr(self, "handle", None):
            self.library.courier_c5x_destroy(self.handle)
            self.handle = None

    def step(self, count: int) -> None:
        error = ctypes.create_string_buffer(512)
        result = self.library.courier_c5x_step(self.handle, count, error, len(error))
        if result:
            raise RuntimeError(error.value.decode("utf-8", "replace"))

    def set_io(self, port: int, value: int) -> None:
        self.library.courier_c5x_set_io(self.handle, port, value)

    def set_mpmc_pin(self, level: int) -> None:
        """Drive the pin that decides what the C52's program 0x0000 is."""
        self.library.courier_c5x_set_mpmc_pin(self.handle, int(level))

    def load_rom(self, image: bytes, origin: int = 0) -> None:
        """Supply the on-chip boot ROM, which no XMF carries."""
        storage = (ctypes.c_uint8 * len(image)).from_buffer_copy(image)
        error = ctypes.create_string_buffer(512)
        if self.library.courier_c5x_load_rom(
            self.handle, origin, storage, len(storage), error, len(error)
        ):
            raise RuntimeError(error.value.decode("utf-8", "replace"))

    def memory_map(self) -> dict[str, Any]:
        values = (ctypes.c_uint64 * 18)()
        self.library.courier_c5x_get_memory_map(self.handle, values, len(values))
        names = (
            "mpmc_pin", "mpmc", "ovly", "ram", "cnf", "iptr",
            "pdwsr", "iowsr", "cwsr", "rom_present",
            "program_rom", "program_daram", "program_external",
            "data_registers", "data_daram", "data_reserved", "data_external",
            "rom_holes",
        )
        state: dict[str, Any] = dict(zip(names, map(int, values), strict=True))
        state["rom_present"] = bool(state["rom_present"])
        state["wait_states"] = decode_wait_states(
            state["pdwsr"], state["iowsr"], state["cwsr"]
        )
        return state

    def host_write(self, address: int, value: int) -> None:
        self.library.courier_c5x_host_write(
            self.handle, address & 0xFFFF, value & 0xFFFF
        )

    def queue_serial_rx(self, samples: list[int] | tuple[int, ...]) -> None:
        if not samples:
            return
        storage = (ctypes.c_uint16 * len(samples))(*(sample & 0xFFFF for sample in samples))
        self.library.courier_c5x_queue_serial_rx(self.handle, storage, len(storage))

    def queue_codec_rx(self, samples: list[int] | tuple[int, ...]) -> None:
        if not samples:
            return
        storage = (ctypes.c_uint16 * len(samples))(*(sample & 0xFFFF for sample in samples))
        self.library.courier_c5x_queue_codec_rx(self.handle, storage, len(storage))

    def set_dtmf_digits(self, digits: str) -> None:
        encoded = digits.encode("ascii")
        self.library.courier_c5x_set_dtmf_digits(self.handle, encoded, len(encoded))

    def io(self, port: int) -> int:
        return int(self.library.courier_c5x_get_io(self.handle, port))

    def data(self, address: int) -> int:
        return int(self.library.courier_c5x_get_data(self.handle, address))

    def set_data(self, address: int, value: int) -> None:
        self.library.courier_c5x_set_data(self.handle, address, value)

    def interrupt(self, irq: int) -> None:
        self.library.courier_c5x_interrupt(self.handle, irq)

    def state(self) -> dict[str, int | bool]:
        values = (ctypes.c_uint64 * 20)()
        self.library.courier_c5x_get_state(self.handle, values, len(values))
        names = ("pc", "op", "acc", "accb", "preg", "dp", "arp", "flags",
                 "idle", "instructions", "cycles", "io_events",
                 "ar0", "ar1", "ar2", "ar3", "ar4", "ar5", "ar6", "ar7")
        state = dict(zip(names, map(int, values), strict=True))
        for name in ("acc", "accb", "preg"):
            if state[name] & 0x80000000:
                state[name] -= 0x100000000
        state["idle"] = bool(state["idle"])
        return state

    def serial_state(self) -> dict[str, int]:
        values = (ctypes.c_uint64 * 24)()
        self.library.courier_c5x_get_serial_state(self.handle, values, len(values))
        names = (
            "drr", "dxr", "spc", "drr_reads", "dxr_writes", "spc_writes",
            "rx_consumed", "rx_queued",
            "last_drr_pc", "last_dxr_pc", "last_spc_pc",
            "trcv", "tdxr", "tspc", "trcv_reads", "tdxr_writes", "tspc_writes",
            "last_trcv_pc", "last_tdxr_pc", "last_tspc_pc",
            "line_tx_writes", "line_tx_nonzero", "line_tx_last", "line_tx_last_pc",
        )
        return dict(zip(names, map(int, values), strict=True))

    def trace_data_writes(self, enabled: bool = True, *, clear: bool = True) -> None:
        if clear:
            self.library.courier_c5x_clear_data_events(self.handle)
        self.library.courier_c5x_set_data_trace(self.handle, int(enabled))

    def data_events(self) -> list[dict[str, int]]:
        count = int(self.library.courier_c5x_get_data_event_count(self.handle))
        result: list[dict[str, int]] = []
        for index in range(count):
            values = (ctypes.c_uint64 * 4)()
            self.library.courier_c5x_get_data_event(self.handle, index, values, len(values))
            result.append(dict(zip(
                ("address", "value", "pc", "instruction"), map(int, values), strict=True
            )))
        return result

    def io_events(self) -> list[dict[str, int | bool]]:
        count = int(self.library.courier_c5x_get_io_event_count(self.handle))
        result: list[dict[str, int | bool]] = []
        for index in range(count):
            values = (ctypes.c_uint64 * 5)()
            self.library.courier_c5x_get_io_event(self.handle, index, values, len(values))
            event: dict[str, int | bool] = dict(zip(
                ("write", "port", "value", "pc", "instruction"),
                map(int, values), strict=True
            ))
            event["write"] = bool(event["write"])
            result.append(event)
        return result

    def io_port_stats(self, ports: range = range(0x50, 0x60)) -> dict[str, dict[str, int]]:
        names = (
            "reads", "writes", "last_read", "last_write",
            "last_read_pc", "last_write_pc",
        )
        result: dict[str, dict[str, int]] = {}
        for port in ports:
            values = (ctypes.c_uint64 * len(names))()
            self.library.courier_c5x_get_io_port_stats(
                self.handle, port, values, len(values)
            )
            stats = dict(zip(names, map(int, values), strict=True))
            if stats["reads"] or stats["writes"]:
                result[f"0x{port:02x}"] = stats
        return result

    def line_tx_samples(self, start: int = 0) -> list[int]:
        count = self.serial_state()["line_tx_writes"]
        samples = [
            int(self.library.courier_c5x_get_line_tx_sample(self.handle, index))
            for index in range(max(0, start), count)
        ]
        return [sample - 0x10000 if sample & 0x8000 else sample for sample in samples]

    def __enter__(self) -> "NativeC5x":
        return self

    def __exit__(self, *_args: object) -> None:
        self.close()


def run_dsp(
    image: XmfImage,
    *,
    instructions: int = 1_000_000,
    trace: int = 0,
    trace_start: int = 0,
    ports: dict[int, int] | None = None,
    rebuild: bool = False,
) -> dict[str, object]:
    runner = build_runner(force=rebuild)
    command = [
        str(runner),
        str(image.path),
        "--instructions",
        str(instructions),
        "--trace",
        str(trace),
        "--trace-start",
        str(trace_start),
    ]
    for port, value in (ports or {}).items():
        command.extend(("--port", f"{port}={value}"))
    process = subprocess.run(command, text=True, capture_output=True)
    if trace and process.stderr:
        print(process.stderr, end="", file=sys.stderr)
    if process.returncode:
        detail = process.stderr.strip() or process.stdout.strip()
        raise RuntimeError(f"C5x runner failed: {detail}")
    return json.loads(process.stdout)
