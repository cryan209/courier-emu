"""State the harness's poll shares in place with the native port model.

The interrupt controllers, the 8254's wrap bookkeeping and a few counters live
in one ctypes structure whose layout mirrors `PollState` in c5x_capi.cpp. The
Python classes (`Pic8259`, `Counter`, `IsdnMachine`) read and write their
fields as ordinary attributes; the native model, which runs the poll itself
while a call is up, uses the same memory, so neither side ever copies.
"""
from __future__ import annotations

import ctypes

U8, U32, U64 = ctypes.c_uint8, ctypes.c_uint32, ctypes.c_uint64
INFINITE = (1 << 64) - 1          # PitSlot.next_due: no wrap is due
MAX_ASSERTED = 8


class PicChip(ctypes.Structure):
    _fields_ = [
        ("vector_base", U8), ("mask", U8), ("irr", U8), ("isr", U8),
        ("auto_eoi", U8), ("read_isr", U8), ("expect_icw4", U8), ("single", U8),
        ("init_words", U8),
    ]


class PitSlot(ctypes.Structure):
    _fields_ = [
        ("next_due", U64), ("origin", U64), ("reported", U64),
        ("initial", U32), ("programmed", U8),
    ]


class PollState(ctypes.Structure):
    _fields_ = [
        ("pic", PicChip * 2),
        ("delivered", U64),
        ("pit", PitSlot * 3),
        ("timer_ticks", U64),
        ("coalesced", U64 * 3),
        # The lines each counter raises on a wrap, -1 ending the list.
        ("counter_irq", ctypes.c_int8 * 12),
        ("pit_clock_hz", U64), ("ips", U64),
        # The peripheral clock reads (instruction count - clock_origin).
        ("clock_origin", ctypes.c_int64),
        ("next_rtos", U64), ("next_mailbox", U64),
        ("rtos_interval", U64), ("mailbox_interval", U64),
        ("rtos_on", U8), ("mailbox_on", U8),
        # Interrupt sources every poll raises again while they stay asserted.
        ("asserted_count", U8), ("asserted", U8 * MAX_ASSERTED),
        ("hardware_interrupts", U64),
        ("last_poll", U64),          # the instruction count of the last native poll
        ("pic_in", U64 * 4), ("pic_out", U64 * 4),
        # IRQ13 follows the DSP's timer output (IsdnMachine.poll_timers).
        ("tout_on", U8), ("tout_seen", U64),
    ]

    def __init__(self) -> None:
        super().__init__()
        for slot in self.pit:
            slot.next_due = INFINITE
        for index in range(len(self.counter_irq)):
            self.counter_irq[index] = -1


def shared_field(name: str, kind=int):
    """A property over one field of `self._s` (the shared structure it is bound to)."""
    def get(self):
        return kind(getattr(self._s, name))

    def put(self, value):
        setattr(self._s, name, int(value))

    return property(get, put)
