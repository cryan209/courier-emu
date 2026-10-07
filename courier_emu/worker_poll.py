"""The analog worker's service, run by the x86 engine itself.

Mirrors `WorkerPollState` in native/c5x_capi.cpp, whose `courier_worker_poll`
does the work of `Machine.run`'s interpreter_service and fast_service and of
`DspBridge.clock_x86_fast` for the services in which only the DSP, the clocks
and the DSP's frame edge move. The harness arms it after a service of its own
(`Machine.run`'s arm_worker_poll), and takes the fields back whenever the
engine hands control to Python (`take_back`); while it is armed the copies
here, not the Python attributes, are the live ones.
"""
from __future__ import annotations

import ctypes

from .dsp import load_library

I64, U64, F64 = ctypes.c_int64, ctypes.c_uint64, ctypes.c_double
STACK_SLOTS = 64
NO_LATCH = 256


class WorkerPollState(ctypes.Structure):
    _fields_ = [
        ("core", ctypes.c_void_p),
        ("armed", U64), ("dirty", U64), ("polls", U64),
        ("instruction_base", I64),
        ("elide_until", U64), ("last_service", U64),
        ("timer_poll_owed", I64), ("timer_poll_period", U64),
        ("last_frame", I64),
        ("frame_instructions", U64), ("int0_ok", U64), ("int0_in_service", U64),
        ("stack_depth", U64), ("stack", ctypes.c_uint8 * STACK_SLOTS),
        ("bridge_instructions", I64), ("probe_last", I64),
        ("codec_present", U64),
        ("codec_instructions", I64), ("line_frame_instructions", I64),
        ("x86_ticks", I64), ("batch", I64),
        ("debt", F64), ("cpi", F64), ("cycles_per_x86", F64),
        ("line_codec_last", I64), ("line_skipped", I64),
        ("line_min_samples", I64), ("line_max_skip", I64),
        ("boot_rom", U64), ("mailbox_writes", U64), ("overlay_active", U64),
        ("host_port", U64),
        ("loader_in_loop", U64), ("loader_first", U64), ("loader_end", U64),
        ("panel_latch", U64),
        ("io_cursor", U64), ("mmio_cursor", U64),
        ("resume_elapsed", I64),
        ("step_writes", U64), ("step_tdm", U64),
        ("error", ctypes.c_char * 512),
    ]


class WorkerPoll:
    """The structure and the engine's handle on the native poll."""

    def __init__(self) -> None:
        library = load_library()
        layout = (ctypes.c_uint64 * 4)()
        library.courier_worker_poll_layout(layout)
        expected = (ctypes.sizeof(WorkerPollState), WorkerPollState.debt.offset,
                    WorkerPollState.panel_latch.offset, WorkerPollState.error.offset)
        if tuple(layout) != expected:
            raise RuntimeError(f"WorkerPollState layout {tuple(layout)} != {expected}")
        self.state = WorkerPollState()
        self.function = ctypes.cast(library.courier_worker_poll, ctypes.c_void_p).value
        self.context = ctypes.addressof(self.state)
