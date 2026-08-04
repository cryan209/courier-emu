from __future__ import annotations

import ctypes
import json
from pathlib import Path
import subprocess
import sys

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
