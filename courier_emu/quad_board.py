"""Quad controller's selected modem memory aperture.

QF 0x80730 selects each modem through port 0x280 and programs GCS5 to
copy its flash, then GCS2 to copy RAM/DSP data. The controller aperture is
0x40000..0x7ffff. The flash's own reset stub establishes the modem view at
0xc0000..0xfffff. RAM is a distinct bank; its CPU-side mapping is not emulated
by this controller model. Targets do not execute concurrently yet.
"""
from __future__ import annotations

from dataclasses import dataclass, field
from typing import Any

from .quad_usart import QuadUsart

WINDOW_BASE = 0x40000
WINDOW_SIZE = 0x40000
CHANNEL_MASKS = (0x80, 0x40, 0x20, 0x10)


@dataclass
class QuadBoard:
    identity: int = 0
    usart: QuadUsart = field(default_factory=QuadUsart)
    flash: list[bytearray] = field(default_factory=lambda: [bytearray(b'\xff') * WINDOW_SIZE for _ in range(4)])
    ram: list[bytearray] = field(default_factory=lambda: [bytearray(WINDOW_SIZE) for _ in range(4)])
    registers: dict[int, int] = field(default_factory=dict)
    selection: int = 0
    window_changes: int = 0
    _mapped: tuple[str, int] | None = None
    _uc: Any = field(default=None, repr=False)

    def __post_init__(self) -> None:
        if not 0 <= self.identity <= 0xff:
            raise ValueError('Quad identity must be an eight-bit port 0x260 value')

    def attach(self, uc: Any) -> None:
        self._uc = uc
        self._mapped = None
        uc.mem_write(WINDOW_BASE, b'\xff' * WINDOW_SIZE)

    def flush(self) -> None:
        if self._mapped is not None:
            bank, index = self._mapped
            getattr(self, bank)[index][:] = self._uc.mem_read(WINDOW_BASE, WINDOW_SIZE)

    def _target(self) -> tuple[str, int] | None:
        # No assumptions about simultaneous chip enables or broadcast reads.
        if self.selection not in CHANNEL_MASKS:
            return None
        index = CHANNEL_MASKS.index(self.selection)
        active = []
        for bank, start in [('ram', 0xff88), ('flash', 0xff94)]:
            if (self.registers.get(start, 0) == 0x4000
                    and self.registers.get(start + 2, 0) & 0xffc0 == 0x8000):
                active.append(bank)
        return (active[0], index) if len(active) == 1 else None

    def _remap(self) -> None:
        target = self._target()
        if target == self._mapped or self._uc is None:
            return
        self.flush()
        self._mapped = target
        payload = (getattr(self, target[0])[target[1]] if target is not None
                   else b'\xff' * WINDOW_SIZE)
        self._uc.mem_write(WINDOW_BASE, bytes(payload))
        self.window_changes += 1

    def write_register(self, address: int, size: int, value: int) -> None:
        if address in (0xff88, 0xff8a, 0xff94, 0xff96) and size == 2:
            self.registers[address] = value
            self._remap()

    def read(self, port: int, size: int) -> int | None:
        if port == 0x260:
            return self.identity
        if port == 0:
            # Bit 5 is the selected-target grant sampled by 0x813b4.
            # Bit 3 idles high on the unconnected serial identification input.
            return 0x08 | (0x20 if self.selection in CHANNEL_MASKS else 0)
        return None

    def write(self, port: int, size: int, value: int) -> bool:
        if port == 0x280:
            self.selection = value & 0xf0
            self._remap()
            return True
        return False
