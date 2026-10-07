from __future__ import annotations

import ctypes
import json
import os
from pathlib import Path
import subprocess
import sys
from typing import Any

from .xmf import XmfImage
from .timebase import ASIC_DSP_CLOCK_HZ


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
LIBRARY_SOURCES = (SOURCES[:2] + (NATIVE_DIRECTORY / "c5x_capi.cpp",) + SOURCES[3:]
                   + (NATIVE_DIRECTORY / "bearer.hpp",))
_LIBRARY_HANDLE = None
_SIZE_T_MAX = ctypes.c_size_t(-1).value


def build_runner(*, force: bool = False) -> Path:
    if not force and RUNNER.exists():
        runner_time = RUNNER.stat().st_mtime_ns
        if all(source.stat().st_mtime_ns <= runner_time for source in SOURCES):
            return RUNNER
    BUILD_DIRECTORY.mkdir(parents=True, exist_ok=True)
    command = [
        "c++",
        "-std=c++17",
        "-O3",
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
    # A prebuilt library can be named outright, which is how builds are
    # compared against each other.
    override = os.environ.get("COURIER_C5X_LIBRARY")
    if override:
        return Path(override)
    if not force and LIBRARY.exists():
        library_time = LIBRARY.stat().st_mtime_ns
        if all(source.stat().st_mtime_ns <= library_time for source in LIBRARY_SOURCES):
            return LIBRARY
    BUILD_DIRECTORY.mkdir(parents=True, exist_ok=True)
    link_flags = ["-dynamiclib"] if sys.platform == "darwin" else ["-shared", "-fPIC"]
    command = [
        "c++", "-std=c++17", "-O3", "-Wall", "-Wextra", "-Wpedantic",
        # Calls inside the library must not go through the PLT (and so can be
        # inlined): the core's accessors run several times per DSP instruction.
        "-fno-semantic-interposition",
        *link_flags,
        *(str(source) for source in LIBRARY_SOURCES[:3]),
        "-o", str(LIBRARY),
    ]
    process = subprocess.run(command, text=True, capture_output=True)
    if process.returncode:
        detail = process.stderr.strip() or process.stdout.strip()
        raise RuntimeError(f"failed to build the C5x library: {detail}")
    return LIBRARY


def load_library(*, rebuild: bool = False):
    """Reuse the production native-core handle; keep forced rebuilds explicit."""
    global _LIBRARY_HANDLE
    path = build_library(force=rebuild)
    if rebuild:
        return ctypes.CDLL(str(path))
    if _LIBRARY_HANDLE is None:
        _LIBRARY_HANDLE = ctypes.CDLL(str(path))
    return _LIBRARY_HANDLE


# The C5x's wait-state generator, from sections 9.4.1 to 9.4.3 of the C5x
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


# Mirrors C5X_SHARED_FIRST / C5X_SHARED_LAST in native/c5x_core.h.
SHARED_WINDOW = (0x8000, 0xFEFF)


class NativeC5x:
    """Incrementally stepped C5x instance used by the dual-processor harness."""

    def __init__(self, image: XmfImage, *, rebuild: bool = False, model: str = "c51",
                 separate_global_memory: bool = False) -> None:
        self.library = load_library(rebuild=rebuild)
        self._configure_api()
        self.model = model.lower()
        if self.model not in ("c51", "c52", "c53"):
            raise ValueError(f"unsupported DSP model: {model}")
        self._handle = self.library.courier_c5x_create_model(int(self.model[1:]))
        if not self._handle:
            raise RuntimeError("failed to create C5x core")
        self.library.courier_c5x_set_separate_global_memory(self.handle, separate_global_memory)
        # The per-instruction diagnostic probes (V.8 dispatch capture, the
        # negotiation loop snapshot, the 0x0200-0x02ff ISR trace) cost a few
        # percent of every run and nothing reads them back unless asked.
        self.library.courier_c5x_set_step_probes(
            self.handle, bool(os.environ.get("COURIER_DSP_PROBES")))
        try:
            origins = [origin for origin, _ in image.dsp_program_segments()]
            # The board's external RAM answers both spaces at 0x8000-0xfeff,
            # but that is only usable for an image whose program is actually
            # linked there. The 2.1/2.2 XMFs are: their supervisor's table puts
            # every image in 8000..ffff. The 2.3 XMFs put theirs in 0000..7fff,
            # so for those the window is switched off rather than mislaid.
            if origins and min(origins) < SHARED_WINDOW[0]:
                self.library.courier_c5x_set_shared_window(self.handle, 0xFFFF, 0x0000)
            # Only the resident is present at reset. The supervisor downloads
            # it and nothing else; the overlays land later, over the top of it,
            # through the loader the ASIC bridge drives. Preloading them here
            # would overwrite resident code the part is still executing.
            for origin, segment in image.dsp_program_segments()[:1]:
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

    @classmethod
    def from_program(cls, origin: int, program: bytes, *, rebuild: bool = False,
                     model: str = "c51", separate_global_memory: bool = False) -> "NativeC5x":
        """A core holding one raw program image, with no XMF container.

        The Quad streams its datapump code word by word over the CPU link, so
        what the emulator has is a program image and an origin, not a file.
        """
        self = cls.__new__(cls)
        self.library = load_library(rebuild=rebuild)
        self._configure_api()
        self.model = model.lower()
        if self.model not in ("c51", "c52", "c53"):
            raise ValueError(f"unsupported DSP model: {model}")
        self._handle = self.library.courier_c5x_create_model(int(self.model[1:]))
        if not self._handle:
            raise RuntimeError("failed to create C5x core")
        self.library.courier_c5x_set_separate_global_memory(self.handle, separate_global_memory)
        # The per-instruction diagnostic probes (V.8 dispatch capture, the
        # negotiation loop snapshot, the 0x0200-0x02ff ISR trace) cost a few
        # percent of every run and nothing reads them back unless asked.
        self.library.courier_c5x_set_step_probes(
            self.handle, bool(os.environ.get("COURIER_DSP_PROBES")))
        try:
            self.load_program(program, origin)
        except Exception:
            self.close()
            raise
        return self

    def _configure_api(self) -> None:
        lib = self.library
        lib.courier_c5x_create.restype = ctypes.c_void_p
        lib.courier_c5x_create_model.argtypes = [ctypes.c_int]
        lib.courier_c5x_create_model.restype = ctypes.c_void_p
        lib.courier_c5x_set_separate_global_memory.argtypes = [ctypes.c_void_p, ctypes.c_int]
        lib.courier_c5x_destroy.argtypes = [ctypes.c_void_p]
        lib.courier_c5x_reset.argtypes = [ctypes.c_void_p]
        lib.courier_c5x_load_program.argtypes = [
            ctypes.c_void_p, ctypes.c_uint16, ctypes.POINTER(ctypes.c_uint8),
            ctypes.c_size_t, ctypes.c_char_p, ctypes.c_size_t,
        ]
        lib.courier_c5x_schedule_call_overlay.argtypes = [
            ctypes.c_void_p, ctypes.c_uint16, ctypes.POINTER(ctypes.c_uint8),
            ctypes.c_size_t, ctypes.c_uint16, ctypes.POINTER(ctypes.c_uint16),
            ctypes.c_uint16, ctypes.c_char_p, ctypes.c_size_t,
        ]
        lib.courier_c5x_step.argtypes = [
            ctypes.c_void_p, ctypes.c_uint64, ctypes.c_char_p, ctypes.c_size_t,
        ]
        lib.courier_c5x_step_cycles.argtypes = [
            ctypes.c_void_p, ctypes.c_uint64,
            ctypes.POINTER(ctypes.c_uint64), ctypes.POINTER(ctypes.c_uint64),
            ctypes.c_char_p, ctypes.c_size_t,
        ]
        lib.courier_c5x_advance_imodem.argtypes = [
            ctypes.c_void_p, ctypes.c_uint64, ctypes.c_size_t,
            ctypes.POINTER(ctypes.c_uint8), ctypes.c_size_t,
            ctypes.POINTER(ctypes.c_uint64), ctypes.c_size_t,
            ctypes.c_char_p, ctypes.c_size_t,
        ]
        lib.courier_c5x_advance_imodem.restype = ctypes.c_size_t
        lib.courier_c5x_load_rom.argtypes = [
            ctypes.c_void_p, ctypes.c_uint16, ctypes.POINTER(ctypes.c_uint8),
            ctypes.c_size_t, ctypes.c_char_p, ctypes.c_size_t,
        ]
        lib.courier_c5x_set_host_io_base.argtypes = [ctypes.c_void_p, ctypes.c_uint16]
        lib.courier_c5x_set_mpmc_pin.argtypes = [ctypes.c_void_p, ctypes.c_int]
        lib.courier_c5x_set_shared_window.argtypes = [
            ctypes.c_void_p, ctypes.c_uint16, ctypes.c_uint16
        ]
        lib.courier_c5x_get_memory_map.argtypes = [
            ctypes.c_void_p, ctypes.POINTER(ctypes.c_uint64), ctypes.c_size_t
        ]
        lib.courier_c5x_configure_rom_codec.argtypes = [ctypes.c_void_p, ctypes.c_int]
        lib.courier_c5x_configure_si3034_codec.argtypes = [ctypes.c_void_p]
        lib.courier_c5x_set_si3034_line.argtypes = [ctypes.c_void_p, ctypes.c_int, ctypes.c_int, ctypes.c_int]
        lib.courier_c5x_get_codec_registers.argtypes = [ctypes.c_void_p, ctypes.POINTER(ctypes.c_uint16), ctypes.c_size_t]
        lib.courier_c5x_set_codec_mclk.argtypes = [ctypes.c_void_p, ctypes.c_uint32]
        lib.courier_c5x_get_codec_state.argtypes = [
            ctypes.c_void_p, ctypes.POINTER(ctypes.c_uint64), ctypes.c_size_t
        ]
        lib.courier_c5x_get_io_output.argtypes = [ctypes.c_void_p, ctypes.c_uint16]
        lib.courier_c5x_get_io_output.restype = ctypes.c_uint16
        lib.courier_c5x_set_io.argtypes = [ctypes.c_void_p, ctypes.c_uint16, ctypes.c_uint16]
        lib.courier_c5x_queue_io_rx.argtypes = [
            ctypes.c_void_p, ctypes.c_uint16,
            ctypes.POINTER(ctypes.c_uint16), ctypes.c_size_t,
        ]
        lib.courier_c5x_configure_host_mailbox.argtypes = [ctypes.c_void_p, ctypes.c_int]
        lib.courier_c5x_get_xf_falling_edges.argtypes = [ctypes.c_void_p]
        lib.courier_c5x_get_xf_falling_edges.restype = ctypes.c_uint64
        lib.courier_c5x_host_write.argtypes = [
            ctypes.c_void_p, ctypes.c_uint16, ctypes.c_uint16
        ]
        lib.courier_c5x_queue_serial_rx.argtypes = [
            ctypes.c_void_p, ctypes.POINTER(ctypes.c_uint16), ctypes.c_size_t
        ]
        lib.courier_c5x_queue_codec_rx.argtypes = [
            ctypes.c_void_p, ctypes.POINTER(ctypes.c_uint16), ctypes.c_size_t
        ]
        lib.courier_c5x_queue_line_rx.argtypes = [
            ctypes.c_void_p, ctypes.POINTER(ctypes.c_uint16), ctypes.c_size_t
        ]
        lib.courier_c5x_set_hybrid_return.argtypes = [
            ctypes.c_void_p, ctypes.c_uint32, ctypes.c_uint32
        ]
        lib.courier_c5x_configure_digital_pcm.argtypes = [
            ctypes.c_void_p, ctypes.c_int, ctypes.c_uint16, ctypes.c_uint32
        ]
        lib.courier_c5x_get_g711_rx_underruns.argtypes = [ctypes.c_void_p]
        lib.courier_c5x_get_g711_rx_underruns.restype = ctypes.c_uint64
        lib.courier_c5x_get_g711_rx_pending.argtypes = [ctypes.c_void_p]
        lib.courier_c5x_get_g711_rx_pending.restype = ctypes.c_size_t
        lib.courier_c5x_queue_g711_rx.argtypes = [
            ctypes.c_void_p, ctypes.POINTER(ctypes.c_uint8), ctypes.c_size_t
        ]
        lib.courier_c5x_get_g711_tx.argtypes = [
            ctypes.c_void_p, ctypes.POINTER(ctypes.c_uint8), ctypes.c_size_t
        ]
        lib.courier_c5x_get_g711_tx.restype = ctypes.c_size_t
        lib.courier_c5x_get_g711_tx_since.argtypes = [
            ctypes.c_void_p, ctypes.c_size_t, ctypes.POINTER(ctypes.c_uint8),
            ctypes.c_size_t,
        ]
        lib.courier_c5x_get_g711_tx_since.restype = ctypes.c_size_t
        lib.courier_c5x_queue_codec_boot.argtypes = [
            ctypes.c_void_p, ctypes.POINTER(ctypes.c_uint16), ctypes.c_size_t
        ]
        lib.courier_c5x_set_v8_dispatch_pcs.argtypes = [
            ctypes.c_void_p, ctypes.POINTER(ctypes.c_uint16), ctypes.c_size_t]
        lib.courier_c5x_set_v8_calling.argtypes = [ctypes.c_void_p, ctypes.c_int]
        lib.courier_c5x_set_v8_answering.argtypes = [ctypes.c_void_p, ctypes.c_int]
        lib.courier_c5x_set_bio_low.argtypes = [ctypes.c_void_p, ctypes.c_int]
        lib.courier_c5x_set_line_dac_slot.argtypes = [ctypes.c_void_p, ctypes.c_uint16]
        lib.courier_c5x_get_line_phase_samples.argtypes = [
            ctypes.c_void_p, ctypes.c_uint, ctypes.POINTER(ctypes.c_uint16), ctypes.c_size_t
        ]
        lib.courier_c5x_get_line_phase_samples.restype = ctypes.c_size_t
        lib.courier_c5x_get_io.argtypes = [ctypes.c_void_p, ctypes.c_uint16]
        lib.courier_c5x_get_io.restype = ctypes.c_uint16
        lib.courier_c5x_get_program.argtypes = [ctypes.c_void_p, ctypes.c_uint16]
        lib.courier_c5x_get_program.restype = ctypes.c_uint16
        lib.courier_c5x_get_stack.argtypes = [ctypes.c_void_p, ctypes.c_uint]
        lib.courier_c5x_get_stack.restype = ctypes.c_uint16
        lib.courier_c5x_get_register.argtypes = [ctypes.c_void_p, ctypes.c_uint16]
        lib.courier_c5x_get_register.restype = ctypes.c_uint16
        lib.courier_c5x_get_data.argtypes = [ctypes.c_void_p, ctypes.c_uint16]
        lib.courier_c5x_set_data_trace_filter.argtypes = [ctypes.c_void_p, ctypes.c_uint, ctypes.c_int]
        lib.courier_c5x_set_data_trace_filter.restype = None
        lib.courier_c5x_set_data_event_limit.argtypes = [ctypes.c_void_p, ctypes.c_size_t]
        lib.courier_c5x_set_data_event_limit.restype = None
        lib.courier_c5x_set_data_trace_range.argtypes = [ctypes.c_void_p, ctypes.c_uint, ctypes.c_uint, ctypes.c_int]
        lib.courier_c5x_set_data_trace_range.restype = None
        lib.courier_c5x_set_step_probes.argtypes = [ctypes.c_void_p, ctypes.c_int]
        lib.courier_c5x_set_step_probes.restype = None
        lib.courier_c5x_set_coverage.argtypes = [ctypes.c_void_p, ctypes.c_int]
        lib.courier_c5x_set_coverage.restype = None
        lib.courier_c5x_get_first_exec.argtypes = [ctypes.c_void_p, ctypes.c_uint]
        lib.courier_c5x_get_first_exec.restype = ctypes.c_uint64
        lib.courier_c5x_set_pc_trace_range.argtypes = [ctypes.c_void_p, ctypes.c_uint, ctypes.c_uint]
        lib.courier_c5x_set_pc_trace_range.restype = None
        lib.courier_c5x_clear_pc_trace.argtypes = [ctypes.c_void_p]
        lib.courier_c5x_clear_pc_trace.restype = None
        lib.courier_c5x_get_pc_trace_count.argtypes = [ctypes.c_void_p]
        lib.courier_c5x_get_pc_trace_count.restype = ctypes.c_size_t
        lib.courier_c5x_get_pc_trace.argtypes = [ctypes.c_void_p, ctypes.c_size_t, ctypes.POINTER(ctypes.c_uint64), ctypes.c_size_t]
        lib.courier_c5x_get_data.restype = ctypes.c_uint16
        lib.courier_c5x_set_data.argtypes = [ctypes.c_void_p, ctypes.c_uint16, ctypes.c_uint16]
        lib.courier_c5x_get_data_write_count.argtypes = [ctypes.c_void_p, ctypes.c_uint16]
        lib.courier_c5x_get_data_write_count.restype = ctypes.c_uint64
        lib.courier_c5x_interrupt.argtypes = [ctypes.c_void_p, ctypes.c_uint]
        lib.courier_c5x_nmi.argtypes = [ctypes.c_void_p]
        lib.courier_c5x_nmi.restype = None
        lib.courier_c5x_configure_line_frame_interrupt.argtypes = [
            ctypes.c_void_p, ctypes.c_uint, ctypes.c_uint16
        ]
        lib.courier_c5x_set_call_tdm_active.argtypes = [ctypes.c_void_p, ctypes.c_int]
        lib.courier_c5x_call_tdm_active.argtypes = [ctypes.c_void_p]
        lib.courier_c5x_call_tdm_active.restype = ctypes.c_int
        lib.courier_c5x_schedule_line_frame_entry.argtypes = [
            ctypes.c_void_p, ctypes.c_uint16
        ]
        lib.courier_c5x_set_pc.argtypes = [ctypes.c_void_p, ctypes.c_uint16]
        lib.courier_c5x_get_state.argtypes = [
            ctypes.c_void_p, ctypes.POINTER(ctypes.c_uint64), ctypes.c_size_t
        ]
        lib.courier_c5x_get_serial_state.argtypes = [
            ctypes.c_void_p, ctypes.POINTER(ctypes.c_uint64), ctypes.c_size_t
        ]
        lib.courier_c5x_get_delay_move_state.argtypes = [
            ctypes.c_void_p, ctypes.POINTER(ctypes.c_uint64)
        ]
        lib.courier_c5x_get_delay_move_state.restype = None
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
        lib.courier_c5x_get_mailbox_event_count.argtypes = [ctypes.c_void_p]
        lib.courier_c5x_get_mailbox_event_count.restype = ctypes.c_size_t
        lib.courier_c5x_get_mailbox_event.argtypes = [
            ctypes.c_void_p, ctypes.c_size_t, ctypes.POINTER(ctypes.c_uint64), ctypes.c_size_t
        ]
        lib.courier_c5x_get_line_tx_sample.argtypes = [ctypes.c_void_p, ctypes.c_size_t]
        lib.courier_c5x_get_line_tx_sample.restype = ctypes.c_uint16
        lib.courier_c5x_drop_g711_rx_tail.argtypes = [
            ctypes.c_void_p, ctypes.c_size_t]
        lib.courier_c5x_drop_g711_rx_tail.restype = ctypes.c_size_t
        lib.courier_c5x_get_io_port_writes.argtypes = [
            ctypes.c_void_p, ctypes.c_uint16]
        lib.courier_c5x_get_io_port_writes.restype = ctypes.c_uint64
        lib.courier_c5x_get_pc.argtypes = [ctypes.c_void_p]
        lib.courier_c5x_get_pc.restype = ctypes.c_uint16
        lib.courier_c5x_get_line_tx_writes.argtypes = [ctypes.c_void_p]
        lib.courier_c5x_get_line_tx_writes.restype = ctypes.c_uint64
        lib.courier_c5x_get_line_tx_samples.argtypes = [
            ctypes.c_void_p, ctypes.c_size_t, ctypes.POINTER(ctypes.c_uint16),
            ctypes.c_size_t]
        lib.courier_c5x_get_line_tx_samples.restype = ctypes.c_size_t
        lib.courier_c5x_get_line_tx_clock_events.argtypes = [
            ctypes.c_void_p, ctypes.POINTER(ctypes.c_uint64), ctypes.c_size_t]
        lib.courier_c5x_get_line_tx_clock_events.restype = ctypes.c_size_t

    @property
    def handle(self) -> int:
        """The native core pointer, or a loud failure once it is gone.

        The C entry points all guard against a null handle and return zero, so
        a read taken after `close()` used to answer `0 instructions`, an empty
        pc trace and `line_tx_writes 0` - indistinguishable from a core that
        ran and did nothing. `CourierMachine.run` closes the bridge before it
        returns, so *every* end-of-run diagnostic read hit that path and came
        back plausibly empty. Raising here turns a silent wrong answer into an
        error at the call site.
        """
        handle = self._handle
        if not handle:
            raise RuntimeError(
                "the C5x core is closed; sample diagnostics during the run, "
                "not after CourierMachine.run() returns"
            )
        return handle

    @property
    def closed(self) -> bool:
        return not self._handle

    def close(self) -> None:
        if getattr(self, "_handle", None):
            self.library.courier_c5x_destroy(self._handle)
            self._handle = None

    def reset(self) -> None:
        """Assert the C5x reset input without replacing its attached memory."""
        self.library.courier_c5x_reset(self.handle)

    def step(self, count: int) -> None:
        error = self._error_buffer
        result = self.library.courier_c5x_step(self.handle, count, error, len(error))
        if result:
            raise RuntimeError(error.value.decode("utf-8", "replace"))

    def step_cycles(self, count: int) -> tuple[int, int]:
        """Run until at least ``count`` additional clock cycles have elapsed."""
        # Called every service chunk: the output cells and error buffer are
        # allocated once per core rather than once per call.
        cells = self.__dict__.get("_step_cycles_cells")
        if cells is None:
            instructions, cycles = ctypes.c_uint64(), ctypes.c_uint64()
            cells = self._step_cycles_cells = (
                instructions, cycles, ctypes.byref(instructions),
                ctypes.byref(cycles), self._error_buffer)
        instructions, cycles, instructions_ref, cycles_ref, error = cells
        result = self.library.courier_c5x_step_cycles(
            self.handle, count, instructions_ref, cycles_ref, error, len(error),
        )
        if result:
            raise RuntimeError(error.value.decode("utf-8", "replace"))
        return instructions.value, cycles.value

    @property
    def _error_buffer(self):
        buffer = self.__dict__.get("_shared_error_buffer")
        if buffer is None:
            buffer = self._shared_error_buffer = ctypes.create_string_buffer(512)
        return buffer

    def advance_imodem(
        self, count: int, tx_start: int
    ) -> tuple[int, int, int, int, int, int, bytes]:
        """Advance up to the cycle budget or next completed PCM frame.

        The caller exchanges that frame before running the remaining cycles.
        """
        buffers = self.__dict__.get("_imodem_advance_buffers")
        if buffers is None:
            capacity = 64
            output = (ctypes.c_uint8 * capacity)()
            values = (ctypes.c_uint64 * 6)()
            buffers = self._imodem_advance_buffers = (
                output, values, ctypes.create_string_buffer(512), capacity,
                ctypes.addressof(output))
        output, values, error, capacity, output_address = buffers
        available = self.library.courier_c5x_advance_imodem(
            self.handle, count, tx_start, output, capacity,
            values, 6, error, 512,
        )
        if available == _SIZE_T_MAX:
            raise RuntimeError(error.value.decode("utf-8", "replace"))
        if available > capacity:
            octets = self.g711_tx(tx_start)
        elif available:
            octets = ctypes.string_at(output_address, available)
        else:
            octets = b""
        # Indexing a ctypes array already yields Python ints.
        return (values[0], values[1], values[2], values[3], values[4],
                values[5], octets)

    def configure_rom_codec(self, enabled: bool = True) -> None:
        self.library.courier_c5x_configure_rom_codec(self.handle, int(enabled))
        self._si3034_codec = False

    def configure_si3034_codec(self) -> None:
        self.library.courier_c5x_configure_si3034_codec(self.handle)
        self._si3034_codec = True

    def set_si3034_line(self, connected: bool, off_hook: bool, ringing: bool) -> None:
        self.library.courier_c5x_set_si3034_line(self.handle, connected, off_hook, ringing)

    def set_io(self, port: int, value: int) -> None:
        self.library.courier_c5x_set_io(self.handle, port, value)

    def queue_io_rx(self, port: int, words: list[int] | tuple[int, ...]) -> None:
        if not words:
            return
        storage = (ctypes.c_uint16 * len(words))(
            *(word & 0xFFFF for word in words)
        )
        self.library.courier_c5x_queue_io_rx(
            self.handle, port & 0xFFFF, storage, len(words)
        )

    def set_host_io_base(self, base: int) -> None:
        self.library.courier_c5x_set_host_io_base(self.handle, base)

    def set_mpmc_pin(self, level: int) -> None:
        """Drive the pin that decides what the C5x's program 0x0000 is."""
        self.library.courier_c5x_set_mpmc_pin(self.handle, int(level))

    def load_program(self, image: bytes, origin: int) -> None:
        """Publish a runtime DSP overlay into program space."""
        storage = (ctypes.c_uint8 * len(image)).from_buffer_copy(image)
        error = ctypes.create_string_buffer(512)
        if self.library.courier_c5x_load_program(
            self.handle, origin, storage, len(storage), error, len(error)
        ):
            raise RuntimeError(error.value.decode("utf-8", "replace"))

    def schedule_call_overlay(
        self, image: bytes, origin: int, registers: list[int], selector: int,
        entry: int = 0x2295,
    ) -> None:
        """Publish and enter a call overlay at the recovered idle-frame ABI."""
        storage = (ctypes.c_uint8 * len(image)).from_buffer_copy(image)
        if len(registers) != 7:
            raise ValueError("call overlay requires seven C5x registers")
        register_words = (ctypes.c_uint16 * 7)(*registers)
        error = ctypes.create_string_buffer(512)
        if self.library.courier_c5x_schedule_call_overlay(
            self.handle, origin, storage, len(storage), entry, register_words,
            selector, error, len(error)
        ):
            raise RuntimeError(error.value.decode("utf-8", "replace"))

    def load_rom(self, image: bytes, origin: int = 0) -> None:
        """Supply the on-chip boot ROM, which no XMF carries."""
        storage = (ctypes.c_uint8 * len(image)).from_buffer_copy(image)
        error = ctypes.create_string_buffer(512)
        if self.library.courier_c5x_load_rom(
            self.handle, origin, storage, len(storage), error, len(error)
        ):
            raise RuntimeError(error.value.decode("utf-8", "replace"))

    def memory_map(self) -> dict[str, Any]:
        values = (ctypes.c_uint64 * 21)()
        self.library.courier_c5x_get_memory_map(self.handle, values, len(values))
        names = (
            "mpmc_pin", "mpmc", "ovly", "ram", "cnf", "iptr",
            "pdwsr", "iowsr", "cwsr", "rom_present",
            "program_rom", "program_daram", "program_saram", "program_external",
            "data_registers", "data_daram", "data_saram", "data_reserved",
            "data_shared", "data_external", "rom_holes",
        )
        state: dict[str, Any] = dict(zip(names, map(int, values), strict=True))
        state["model"] = self.model
        state["rom_present"] = bool(state["rom_present"])
        state["wait_states"] = decode_wait_states(
            state["pdwsr"], state["iowsr"], state["cwsr"]
        )
        return state

    def host_write(self, address: int, value: int) -> None:
        self.library.courier_c5x_host_write(
            self.handle, address & 0xFFFF, value & 0xFFFF
        )

    def configure_host_mailbox(self) -> None:
        """Use separate holding registers and write-one acknowledgements."""
        self.library.courier_c5x_configure_host_mailbox(self.handle, 1)

    def xf_falling_edges(self) -> int:
        return int(self.library.courier_c5x_get_xf_falling_edges(self.handle))

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

    def queue_line_rx(self, samples: list[int] | tuple[int, ...]) -> None:
        """Queue 8 kHz line audio for conversion at actual ADC clock edges."""
        if not samples:
            return
        storage = (ctypes.c_uint16 * len(samples))(*(s & 0xffff for s in samples))
        self.library.courier_c5x_queue_line_rx(self.handle, storage, len(storage))

    def set_hybrid_return(self, return_scale: int, delay: int = 0) -> None:
        """Close the codec's analog output back onto its own analog input.

        `return_scale` is in 1/256ths, so 256 is unity and 0 opens the loop;
        `delay` is in codec frames. This is the hybrid, not a codec function:
        the AC01's own loopback bit is never set by this firmware, and AT&T1
        sends no command that would distinguish it from a call (the mailbox
        traffic for &T1 and &T8 is identical), so the return is a property of
        how the analog front end is terminated.
        """
        if not 0 <= return_scale <= 1024:
            raise ValueError("hybrid return scale is in 1/256ths, 0..1024")
        if not 0 <= delay <= 4096:
            raise ValueError("hybrid delay is in codec frames, 0..4096")
        self.library.courier_c5x_set_hybrid_return(
            self.handle, return_scale, delay)

    def configure_digital_pcm(self, enabled: bool = True, *,
                              idle_codeword: int = 0xff,
                              clock_hz: int) -> None:
        """Clock the C50 serial port as one 8-bit, 8 kHz DS0 timeslot."""
        if not 0 <= idle_codeword <= 0xff:
            raise ValueError("G.711 idle codeword must be an octet")
        if clock_hz < 8_000:
            raise ValueError("digital PCM clock must be at least 8 kHz")
        self.library.courier_c5x_configure_digital_pcm(
            self.handle, int(enabled), idle_codeword, clock_hz)

    def g711_rx_underruns(self) -> int:
        """Serial frames that found the network receive queue empty."""
        return int(self.library.courier_c5x_get_g711_rx_underruns(self.handle))

    def g711_rx_pending(self) -> int:
        return int(self.library.courier_c5x_get_g711_rx_pending(self.handle))

    def queue_g711_rx(self, codewords: bytes) -> None:
        """Queue opaque G.711 octets; companding is the call's concern."""
        if not codewords:
            return
        storage = (ctypes.c_uint8 * len(codewords)).from_buffer_copy(codewords)
        self.library.courier_c5x_queue_g711_rx(self.handle, storage, len(storage))

    def imodem_collect(self, start: int, waiting: int) -> tuple[int, int, int, int, bytes]:
        """(status, reply tag, reply value, reply strobe writes, transmitted octets).

        One call for what `IsdnMachine` service passes ask the core for: see
        courier_c5x_imodem_collect in the native library.
        """
        buffers = self.__dict__.get("_collect_buffers")
        if buffers is None:
            output = (ctypes.c_uint8 * 4096)()
            buffers = self._collect_buffers = (
                output, (ctypes.c_uint64 * 4)(), ctypes.addressof(output))
            lib = self.library
            lib.courier_c5x_imodem_collect.argtypes = [
                ctypes.c_void_p, ctypes.c_size_t, ctypes.c_size_t,
                ctypes.c_void_p, ctypes.c_size_t, ctypes.c_void_p]
            lib.courier_c5x_imodem_collect.restype = ctypes.c_size_t
        output, values, address = buffers
        count = self.library.courier_c5x_imodem_collect(
            self.handle, start, waiting, address, 4096, ctypes.addressof(values))
        if count == _SIZE_T_MAX:
            octets = self.g711_tx(start)
        else:
            octets = ctypes.string_at(address, count)
        return values[0], values[1], values[2], values[3], octets

    def g711_tx_exact(self, start: int, count: int) -> bytes:
        """`count` transmitted octets from `start`, when the caller knows how many."""
        storage = (ctypes.c_uint8 * count)()
        got = int(self.library.courier_c5x_get_g711_tx_since(
            self.handle, start, storage, count))
        return bytes(storage[:min(got, count)])

    def g711_tx(self, start: int = 0) -> bytes:
        start = max(0, start)
        count = int(self.library.courier_c5x_get_g711_tx_since(
            self.handle, start, None, 0))
        if not count:
            return b""
        storage = (ctypes.c_uint8 * count)()
        self.library.courier_c5x_get_g711_tx_since(self.handle, start, storage, count)
        return bytes(storage)

    def queue_codec_boot(self, words: list[int] | tuple[int, ...]) -> None:
        """Boot-table words the ASIC clocks into the serial port.

        Kept apart from the sample stream because a frame sync must not consume
        them: the ROM loader polls DRR for them before the codec is programmed.
        """
        if not words:
            return
        storage = (ctypes.c_uint16 * len(words))(*(word & 0xFFFF for word in words))
        self.library.courier_c5x_queue_codec_boot(self.handle, storage, len(storage))

    def set_v8_dispatch_pcs(self, addresses) -> None:
        words = tuple(int(address) & 0xFFFF for address in addresses)
        if not words:
            return
        storage = (ctypes.c_uint16 * len(words))(*words)
        self.library.courier_c5x_set_v8_dispatch_pcs(self.handle, storage, len(storage))

    def set_v8_calling(self, enabled: bool) -> None:
        self.library.courier_c5x_set_v8_calling(self.handle, int(enabled))

    def set_v8_answering(self, enabled: bool) -> None:
        self.library.courier_c5x_set_v8_answering(self.handle, int(enabled))

    def set_bio_low(self, enabled: bool) -> None:
        self.library.courier_c5x_set_bio_low(self.handle, int(enabled))

    def set_line_dac_slot(self, slot: int) -> None:
        """Choose which ASIC slot the datapump's output word is taken from."""
        self.library.courier_c5x_set_line_dac_slot(self.handle, slot)

    def io(self, port: int) -> int:
        return int(self.library.courier_c5x_get_io(self.handle, port))

    def io_output(self, port: int) -> int:
        return int(self.library.courier_c5x_get_io_output(self.handle, port))

    def program(self, address: int) -> int:
        """One word of program memory, as the core would fetch it.

        Downloaded overlays exist only inside the core - nothing on the host
        side keeps a second copy - so reading them back is the only way to
        disassemble what the DSP is actually running.
        """
        return int(self.library.courier_c5x_get_program(self.handle, address))

    def data(self, address: int) -> int:
        return int(self.library.courier_c5x_get_data(self.handle, address))

    def set_data(self, address: int, value: int) -> None:
        self.library.courier_c5x_set_data(self.handle, address, value)

    def stack(self) -> tuple[int, ...]:
        """The 8-deep hardware stack, newest first."""
        return tuple(int(self.library.courier_c5x_get_stack(self.handle, n))
                     for n in range(8))

    def register(self, offset: int) -> int:
        """A memory-mapped register, read without disturbing it.

        `data()` answers from the raw backing store, which for an address below
        0x60 is a cell no register keeps up to date: PMST, CBCR and TDXR all
        read zero through it however the firmware has set them. Reading them
        needs this instead.
        """
        return int(self.library.courier_c5x_get_register(self.handle, offset))

    def interrupt(self, irq: int) -> None:
        self.library.courier_c5x_interrupt(self.handle, irq)

    def nmi(self) -> None:
        self.library.courier_c5x_nmi(self.handle)

    def configure_line_frame_interrupt(self, irq: int, vector: int) -> None:
        self.library.courier_c5x_configure_line_frame_interrupt(
            self.handle, irq, vector
        )

    def set_call_tdm_active(self, active: bool) -> None:
        self.library.courier_c5x_set_call_tdm_active(self.handle, int(active))

    def call_tdm_active(self) -> bool:
        return bool(self.library.courier_c5x_call_tdm_active(self.handle))

    def schedule_line_frame_entry(self, address: int) -> None:
        self.library.courier_c5x_schedule_line_frame_entry(self.handle, address)

    def advance_to_frame_boundary(self, limit: int = 8_192) -> bool:
        for _ in range(limit):
            if self.state()["pc"] == 0xB2F6 and not self.io(0x52) & 3:
                return True
            self.step(1)
        return self.state()["pc"] == 0xB2F6 and not self.io(0x52) & 3

    def set_pc(self, address: int) -> None:
        self.library.courier_c5x_set_pc(self.handle, address)

    def state(self) -> dict[str, int | bool]:
        values = (ctypes.c_uint64 * 22)()
        self.library.courier_c5x_get_state(self.handle, values, len(values))
        names = ("pc", "op", "acc", "accb", "preg", "dp", "arp", "flags",
                 "idle", "instructions", "cycles", "io_events",
                 "ar0", "ar1", "ar2", "ar3", "ar4", "ar5", "ar6", "ar7",
                 "arcr", "indx")
        state = dict(zip(names, map(int, values), strict=True))
        for name in ("acc", "accb", "preg"):
            if state[name] & 0x80000000:
                state[name] -= 0x100000000
        state["idle"] = bool(state["idle"])
        return state

    def drop_g711_rx_tail(self, count: int) -> int:
        """Un-queue the last `count` receive octets; returns how many went."""
        return self.library.courier_c5x_drop_g711_rx_tail(self.handle, count)

    def io_port_writes(self, port: int) -> int:
        """How many times the DSP has written one I/O port."""
        return self.library.courier_c5x_get_io_port_writes(self.handle, port)

    def pc(self) -> int:
        return self.library.courier_c5x_get_pc(self.handle)

    def serial_state(self) -> dict[str, int]:
        values = (ctypes.c_uint64 * 65)()
        self.library.courier_c5x_get_serial_state(self.handle, values, len(values))
        names = (
            "drr", "dxr", "spc", "drr_reads", "dxr_writes", "spc_writes",
            "rx_consumed", "rx_queued",
            "codec_rx_consumed", "codec_rx_queued",
            "last_drr_pc", "last_dxr_pc", "last_spc_pc",
            "trcv", "tdxr", "tspc", "trcv_reads", "tdxr_writes", "tspc_writes",
            "last_trcv_pc", "last_tdxr_pc", "last_tspc_pc",
            "line_tx_writes", "line_tx_nonzero", "line_frame_interrupts",
            "serial_frame_suppressed", "shadow_dp",
            "last_dp_pc", "last_dp_value", "last_dp_source",
            "stray_cala_pc", "stray_cala_target", "stray_cala_dp",
            "line_dac_writes", "line_dac_frames",
            "line_tx_last", "line_tx_last_pc", "imr", "v8_rx_state", "v8_rx_peak", "codec_rx_peak",
            "negotiation_loop_entries", "negotiation_loop_pc", "negotiation_source", "negotiation_pair", "negotiation_source_value",
            "negotiation_pair_value", "negotiation_acc", "v8_dispatches",
            "v8_record", "v8_handler", "v8_countdown", "v8_flags",
            "v8_dispatch_pc", "v8_dispatch_dp",
            "negotiation_d76", "negotiation_d77", "negotiation_d78", "negotiation_d79",
            "negotiation_d26", "negotiation_indx", "negotiation_arp", "negotiation_pm",
            "hybrid_frames", "hybrid_peak",
        )
        state = dict(zip(names, map(int, values), strict=True))
        if state["negotiation_acc"] & 0x80000000:
            state["negotiation_acc"] -= 0x100000000
        moves = (ctypes.c_uint64 * 3)()
        self.library.courier_c5x_get_delay_move_state(self.handle, moves)
        state.update(zip(('delay_move_ignored', 'delay_move_last_pc',
                          'delay_move_last_address'), map(int, moves)))
        return state

    # Names follow docs/ac01-codec-protocol.md; `registers` is indexed by the
    # datasheet's own numbering, so registers[0] is the no-op pseudo-register.
    _CODEC_FIELDS = (
        "mclk_hz", "sample_rate_millihz", "frame_period",
        "secondary_frames", "register_writes", "register_reads",
        "phase_shifts", "primary_frames", "frames_clocked", "last_control_word",
        "rate_programmed", "secondary_pending", "force_secondary",
        "free_run", "high_pass_enabled", "loopback", "sixteen_bit",
        "input_gain", "output_gain", "monitor_gain", "input_select",
        "codec_rx_size", "line_frame_next_cycle", "cycles", "line_frame_irq",
        "rx_empty_frames",
    )
    _CODEC_FLAGS = frozenset({
        "rate_programmed", "secondary_pending", "force_secondary",
        "free_run", "high_pass_enabled", "loopback", "sixteen_bit",
    })
    # Register 4's two-bit gain codes, datasheet section 2.20.5.
    INPUT_GAIN_DB = (None, 0, 6, 12)
    OUTPUT_GAIN_DB = (None, 0, -6, -12)

    def codec_state(self) -> dict[str, Any]:
        values = (ctypes.c_uint64 * 36)()
        self.library.courier_c5x_get_codec_state(self.handle, values, len(values))
        state: dict[str, Any] = {"registers": [int(values[i]) for i in range(9)]}
        for offset, name in enumerate(self._CODEC_FIELDS, start=9):
            value = int(values[offset])
            state[name] = bool(value) if name in self._CODEC_FLAGS else value
        state["sample_rate"] = state["sample_rate_millihz"] / 1000.0
        if getattr(self, "_si3034_codec", False):
            registers = (ctypes.c_uint16 * 32)()
            self.library.courier_c5x_get_codec_registers(self.handle, registers, len(registers))
            state["model"] = "si3034"
            state["registers"] = list(registers)
            state["sixteen_bit"] = bool(registers[1] & 1)
            state["force_secondary"] = False
            state["free_run"] = False
            state["loopback"] = bool(registers[1] & 2 or registers[2] & 8)
            state["input_select"] = None
            state["input_gain_db"] = 6 if registers[13] & 2 else 3 * min(4, registers[15] & 7)
            state["output_gain_db"] = -3 if registers[13] & 1 else -3 * min(4, (registers[15] >> 4) & 7)
            for name in ("input_gain", "output_gain", "monitor_gain", "high_pass_enabled"):
                state.pop(name)
        return state

    @property
    def codec_sample_rate(self) -> float:
        """Conversion rate the codec's own A and B registers currently select.

        Zero until the firmware has programmed them, which is the caller's cue
        that there is nothing to resample to yet.
        """
        values = self.__dict__.get("_codec_rate_cells")
        if values is None:
            values = self._codec_rate_cells = (ctypes.c_uint64 * 36)()
        self.library.courier_c5x_get_codec_state(self.handle, values, len(values))
        return values[10] / 1000.0

    def set_codec_mclk(self, hz: int) -> None:
        self.library.courier_c5x_set_codec_mclk(self.handle, int(hz))

    def data_write_count(self, address: int) -> int:
        return int(self.library.courier_c5x_get_data_write_count(self.handle, address))

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

    def set_data_trace_filter(self, address: int, enabled: bool = True) -> None:
        """Restrict the write trace to one data cell."""
        self.library.courier_c5x_set_data_trace_filter(self.handle, address, int(enabled))

    def set_data_trace_range(self, first: int, last: int, enabled: bool = True) -> None:
        self.library.courier_c5x_set_data_trace_range(self.handle, first, last, int(enabled))

    def set_data_event_limit(self, limit: int) -> None:
        self.library.courier_c5x_set_data_event_limit(self.handle, limit)

    def set_coverage(self, enabled: bool = True) -> None:
        """Record, per program address, the instruction count of its first execution."""
        self.library.courier_c5x_set_coverage(self.handle, int(enabled))

    def first_exec(self, pc: int) -> int:
        return int(self.library.courier_c5x_get_first_exec(self.handle, pc))

    def set_pc_trace_range(self, first: int, last: int) -> None:
        """Also trace program addresses in [first, last].

        Two windows are compiled into the core. This is the third, for a
        handler neither covers - 3.1.2's tag 0x13 enters ee20.
        """
        self.library.courier_c5x_set_pc_trace_range(self.handle, first, last)

    def clear_pc_trace(self) -> None:
        """Empty the trace window, so each drain sees an entry once."""
        self.library.courier_c5x_clear_pc_trace(self.handle)

    def pc_trace(self) -> list[dict[str, int]]:
        count = int(self.library.courier_c5x_get_pc_trace_count(self.handle))
        result = []
        for index in range(count):
            values = (ctypes.c_uint64 * 3)()
            self.library.courier_c5x_get_pc_trace(self.handle, index, values, 3)
            result.append({"pc": int(values[0]), "op": int(values[1]), "acc": int(values[2])})
        return result

    def set_pc_capture(self, pc: int, addresses: list[int]) -> None:
        if len(addresses) > 256:
            raise ValueError("PC capture accepts at most 256 data addresses")
        lib = self.library
        lib.courier_c5x_set_pc_capture.argtypes = [ctypes.c_void_p, ctypes.c_uint16,
                                                  ctypes.POINTER(ctypes.c_uint16), ctypes.c_size_t]
        lib.courier_c5x_set_pc_capture.restype = None
        storage = (ctypes.c_uint16 * len(addresses))(*addresses)
        lib.courier_c5x_set_pc_capture(self.handle, pc, storage, len(addresses))
        self._capture_words = 5 + len(addresses)

    def pc_captures(self) -> list[list[int]]:
        lib = self.library
        lib.courier_c5x_get_pc_capture_count.argtypes = [ctypes.c_void_p]
        lib.courier_c5x_get_pc_capture_count.restype = ctypes.c_size_t
        lib.courier_c5x_get_pc_capture.argtypes = [ctypes.c_void_p, ctypes.c_size_t,
                                                ctypes.POINTER(ctypes.c_uint64), ctypes.c_size_t]
        lib.courier_c5x_get_pc_capture.restype = ctypes.c_size_t
        result = []
        for i in range(lib.courier_c5x_get_pc_capture_count(self.handle)):
            values = (ctypes.c_uint64 * self._capture_words)()
            n = lib.courier_c5x_get_pc_capture(self.handle, i, values, len(values))
            result.append(list(values[:n]))
        return result

    def clear_pc_captures(self) -> None:
        self.library.courier_c5x_clear_pc_captures.argtypes = [ctypes.c_void_p]
        self.library.courier_c5x_clear_pc_captures.restype = None
        self.library.courier_c5x_clear_pc_captures(self.handle)

    def mailbox_events(self) -> list[dict[str, int]]:
        """Every DSP write to the tag, word and stream ports, in order.

        `io_events` cannot answer this: it is unfiltered, and the datapump's
        transmit writes flush it long before anyone reads it. Polling the
        port stats instead samples an asynchronous stream, which tears
        message boundaries and pairs one message's tag with another's word.
        """
        count = int(self.library.courier_c5x_get_mailbox_event_count(self.handle))
        result: list[dict[str, int]] = []
        for index in range(count):
            values = (ctypes.c_uint64 * 5)()
            self.library.courier_c5x_get_mailbox_event(
                self.handle, index, values, len(values))
            result.append({
                "port": int(values[1]), "value": int(values[2]),
                "pc": int(values[3]), "instruction": int(values[4]),
            })
        return result

    def io_events(self, *, limit: int | None = None,
                  ports: tuple[int, ...] | None = None) -> list[dict[str, int | bool]]:
        count = int(self.library.courier_c5x_get_io_event_count(self.handle))
        result: list[dict[str, int | bool]] = []
        indices = range(count) if limit is None else range(count - 1, -1, -1)
        if limit is not None and limit <= 0:
            return result
        for index in indices:
            values = (ctypes.c_uint64 * 5)()
            self.library.courier_c5x_get_io_event(self.handle, index, values, len(values))
            if ports is not None and values[1] not in ports:
                continue
            event: dict[str, int | bool] = dict(zip(
                ("write", "port", "value", "pc", "instruction"),
                map(int, values), strict=True
            ))
            event["write"] = bool(event["write"])
            result.append(event)
            if limit is not None and len(result) >= limit:
                break
        if limit is not None:
            result.reverse()
        return result

    def io_port_stats(self, ports: range = range(0x50, 0x60)) -> dict[str, dict[str, int]]:
        names = (
            "reads", "writes", "last_read", "last_write",
            "last_read_pc", "last_write_pc",
        )
        result: dict[str, dict[str, int]] = {}
        values = self.__dict__.get("_port_stat_cells")
        if values is None:
            values = self._port_stat_cells = (ctypes.c_uint64 * len(names))()
        for port in ports:
            self.library.courier_c5x_get_io_port_stats(
                self.handle, port, values, len(values)
            )
            stats = dict(zip(names, map(int, values), strict=True))
            if stats["reads"] or stats["writes"]:
                result[f"0x{port:02x}"] = stats
        return result

    def line_phase_samples(self, phase: int) -> list[int]:
        """Return the DAC-slot writes made in one TDM phase.

        The ASIC bus carries about ten slots per codec sample. If the line
        channel is one of them its samples are in a single phase, and the
        average across all of them - which is what the line_tx stream is - is
        not a waveform.
        """
        count = int(self.library.courier_c5x_get_line_phase_samples(
            self.handle, phase, None, 0))
        if not count:
            return []
        buffer = (ctypes.c_uint16 * count)()
        self.library.courier_c5x_get_line_phase_samples(
            self.handle, phase, buffer, count)
        return [value - 0x10000 if value & 0x8000 else value for value in buffer]

    def line_tx_writes(self) -> int:
        return self.library.courier_c5x_get_line_tx_writes(self.handle)

    def line_tx_samples(self, start: int = 0) -> list[int]:
        first = max(0, start)
        count = self.line_tx_writes() - first
        if count <= 0:
            return []
        buffer = (ctypes.c_uint16 * count)()
        got = self.library.courier_c5x_get_line_tx_samples(
            self.handle, first, buffer, count)
        return [value - 0x10000 if value & 0x8000 else value for value in buffer[:got]]

    def line_tx_clock_events(self) -> list[tuple[int, float]]:
        count = self.library.courier_c5x_get_line_tx_clock_events(self.handle, None, 0)
        values = (ctypes.c_uint64 * (2 * count))()
        self.library.courier_c5x_get_line_tx_clock_events(self.handle, values, count)
        return [(int(values[2*i]), ASIC_DSP_CLOCK_HZ / values[2*i+1])
                for i in range(count)]

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
    model: str = "c51",
) -> dict[str, object]:
    runner = build_runner(force=rebuild)
    command = [
        str(runner),
        str(image.path),
        "--model", model,
        # The resident alone, as at reset. An overlay only reaches the DSP
        # once the running resident asks the supervisor for it.
        *[
            argument
            for segment in image.dsp_segments()[:1]
            for argument in (
                "--segment",
                f"{segment.file_offset}:{segment.size}:{segment.origin}",
            )
        ],
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


class LaneHostIo:
    """The analogue board's live data lanes, answered inside the x86 engine.

    Wraps the native context in libcourier_c5x. `function` and `context` are
    the addresses the x86 engine calls; everything else is configuration the
    harness refreshes as the board's state changes.
    """

    def __init__(self) -> None:
        self.library = load_library()
        lib = self.library
        lib.courier_laneio_create.restype = ctypes.c_void_p
        lib.courier_laneio_destroy.argtypes = [ctypes.c_void_p]
        lib.courier_laneio_configure.argtypes = [
            ctypes.c_void_p, ctypes.c_void_p, ctypes.c_int, ctypes.c_uint16,
            ctypes.c_uint16, ctypes.c_uint16, ctypes.c_uint16, ctypes.c_uint16,
            ctypes.c_uint16]
        lib.courier_laneio_configure_mailbox.argtypes = [
            ctypes.c_void_p, ctypes.c_int, ctypes.c_int, ctypes.c_int,
            ctypes.c_int, ctypes.c_uint, ctypes.c_int, ctypes.c_uint]
        lib.courier_laneio_set_lane.argtypes = [
            ctypes.c_void_p, ctypes.c_uint, ctypes.c_void_p]
        lib.courier_laneio_clear_seen.argtypes = [
            ctypes.c_void_p, ctypes.c_uint16]
        lib.courier_laneio_take_counts.argtypes = [
            ctypes.c_void_p, ctypes.c_void_p, ctypes.c_void_p, ctypes.c_void_p,
            ctypes.c_void_p]
        self.context = lib.courier_laneio_create()
        self.function = ctypes.cast(
            lib.courier_laneio_access, ctypes.c_void_p).value
        self._counts = (
            (ctypes.c_uint32 * 256)(), (ctypes.c_uint32 * 256)(),
            (ctypes.c_uint16 * 256)(), (ctypes.c_uint8 * 256)())
        self._anchors: list[Any] = []

    def close(self) -> None:
        if self.context:
            self.library.courier_laneio_destroy(self.context)
            self.context = None

    def __del__(self) -> None:  # pragma: no cover - interpreter shutdown order
        try:
            self.close()
        except Exception:
            pass

    def set_lane(self, index: int, window: bytearray, lane: int) -> None:
        """Point lane `index` at one byte of a window the harness also uses."""
        anchor = (ctypes.c_char * len(window)).from_buffer(window)
        self._anchors.append(anchor)
        self.library.courier_laneio_set_lane(
            self.context, index, ctypes.addressof(anchor) + lane)

    def configure(self, core_handle: int | None, live: bool, *,
                  command_port: int, ack_port: int, lane_first: int, banks: int,
                  dsp_first: int, dsp_status: int) -> None:
        self.library.courier_laneio_configure(
            self.context, core_handle, int(live), command_port, ack_port,
            lane_first, banks, dsp_first, dsp_status)

    def configure_mailbox(self, *, runtime: bool, pending: bool, inbound: bool,
                          overlay: bool, overlay_status: int, zero_ok: bool,
                          status_cell: int) -> None:
        """Publish the bridge flags the 0x1c/0x1e model cannot read off the DSP."""
        self.library.courier_laneio_configure_mailbox(
            self.context, int(runtime), int(pending), int(inbound),
            int(overlay), overlay_status & 0xFF, int(zero_ok), status_cell)

    def clear_seen(self, port: int) -> None:
        self.library.courier_laneio_clear_seen(self.context, port)

    def take_counts(self) -> tuple[list[int], list[int], list[int], list[int]]:
        """(in counts, out counts, last value written, written-at-all) by port."""
        cells = self._counts
        self.library.courier_laneio_take_counts(
            self.context, *(ctypes.addressof(cell) for cell in cells))
        return tuple(list(cell) for cell in cells)  # type: ignore[return-value]


class ImodemShared(ctypes.Structure):
    """State the I-modem endpoint shares, in place, with its native port model.

    The layout mirrors `ImodemShared` in c5x_capi.cpp. Python reads and writes
    the fields as ordinary attributes; the native model uses the same memory.
    """

    _fields_ = [
        ("dsp_instructions", ctypes.c_uint64),
        ("cycle_debt", ctypes.c_double),
        ("pcm_cursor", ctypes.c_uint64),
        ("consumed", ctypes.c_uint64),
        ("reply_writes", ctypes.c_uint64),
        ("latch_writes", ctypes.c_uint64),
        ("lane_writes", ctypes.c_uint64),
        ("host_pending", ctypes.c_uint8),
        ("tx_ready", ctypes.c_uint8),
        ("rx_present", ctypes.c_uint8),
        ("needs_service", ctypes.c_uint8),
        ("flush_octets", ctypes.c_uint32),
        ("lanes", ctypes.c_uint8 * 0x60),
        ("tx_pending", ctypes.c_uint32),
        ("rx_pending", ctypes.c_uint32),
        ("ov_len", ctypes.c_uint32),
        ("ov_log", ctypes.c_uint8 * 8192),
        ("elide_until", ctypes.c_uint64),
        ("clock_seen", ctypes.c_uint64),
        ("clock_pending", ctypes.c_uint64),
        ("clock_frame", ctypes.c_uint32),
        ("poll_dirty", ctypes.c_uint8),
        ("elide_on", ctypes.c_uint8),
        ("polls_native", ctypes.c_uint64),
        ("polls_resumed", ctypes.c_uint64),
        ("elided_if", ctypes.c_uint8),
        ("elided_any", ctypes.c_uint8),
        ("poll_why", ctypes.c_uint64 * 8),
    ]


class ImodemHostIo:
    """The I-modem's live data lanes and DSP advance, served inside the x86 engine."""

    def __init__(self, shared: ImodemShared, *, cycles_per_instruction: float,
                 read_quantum: int) -> None:
        self.library = load_library()
        lib = self.library
        lib.courier_imodemio_create.restype = ctypes.c_void_p
        lib.courier_imodemio_destroy.argtypes = [ctypes.c_void_p]
        lib.courier_imodemio_configure.argtypes = [
            ctypes.c_void_p, ctypes.c_void_p, ctypes.c_void_p, ctypes.c_int,
            ctypes.c_double, ctypes.c_uint]
        lib.courier_imodemio_advance.argtypes = [
            ctypes.c_void_p, ctypes.c_uint64, ctypes.c_uint]
        lib.courier_imodemio_advance.restype = ctypes.c_int
        lib.courier_imodemio_take_counts.argtypes = [
            ctypes.c_void_p, ctypes.c_void_p, ctypes.c_void_p]
        lib.courier_imodemio_set_bearer.argtypes = [ctypes.c_void_p, ctypes.c_void_p]
        lib.courier_imodemio_set_poll_state.argtypes = [ctypes.c_void_p, ctypes.c_void_p]
        self.poll_function = ctypes.cast(
            lib.courier_imodemio_poll, ctypes.c_void_p).value
        self.shared = shared
        self.cycles_per_instruction = cycles_per_instruction
        self.read_quantum = read_quantum
        self.context = lib.courier_imodemio_create()
        self.function = ctypes.cast(
            lib.courier_imodemio_access, ctypes.c_void_p).value
        self._counts = ((ctypes.c_uint32 * 256)(), (ctypes.c_uint32 * 256)())
        self._advance = lib.courier_imodemio_advance
        self._applied: tuple | None = None
        self.configure(None, False)

    def configure(self, core_handle: int | None, live: bool) -> None:
        state = (core_handle, live)
        if state == self._applied:
            return
        self._applied = state
        self.library.courier_imodemio_configure(
            self.context, ctypes.addressof(self.shared), core_handle, int(live),
            self.cycles_per_instruction, self.read_quantum)

    def set_poll_state(self, state) -> None:
        """Serve the interrupt controllers' ports from the harness's shared state."""
        self.library.courier_imodemio_set_poll_state(
            self.context, ctypes.addressof(state) if state is not None else None)

    def set_bearer(self, bearer) -> None:
        """Let the engine's poll hook settle PCM frames in this bearer's memory."""
        self.library.courier_imodemio_set_bearer(
            self.context, bearer.handle if bearer is not None else None)

    @property
    def live(self) -> bool:
        return bool(self._applied and self._applied[1])

    def advance(self, now: int, quantum: int = 0) -> bool:
        """Run the C5x to `now` (see IsdnMachine._advance_dsp); False: service."""
        return bool(self._advance(self.context, now, quantum))

    def close(self) -> None:
        if self.context:
            self.library.courier_imodemio_destroy(self.context)
            self.context = None

    def __del__(self) -> None:  # pragma: no cover - interpreter shutdown order
        try:
            self.close()
        except Exception:
            pass

    def take_counts(self) -> tuple[list[int], list[int]]:
        """(IN counts, OUT counts) by port for accesses served natively."""
        reads, writes = self._counts
        self.library.courier_imodemio_take_counts(
            self.context, ctypes.addressof(reads), ctypes.addressof(writes))
        return list(reads), list(writes)
