"""Corrupt chosen symbol phases of the x2 symmetric startup source on the bearer.

The symmetric startup source (1747 words 007e, seven zeros, then 128 pairs
(i, 255-i)) crosses the PCMU bearer untransformed.  This filter waits for seven
consecutive 7e octets, then XORs ``mask`` into every sixth octet at
each listed phase, and stops at the double 81 start word of the capability frame.
Mask 1 is a low-bit error that the firmware's receiver tolerates and records.

Enable it with COURIER_X2_SOURCE_IMPAIR="phase[,phase...][:mask]" for tools that import it.
"""
from __future__ import annotations

import os


class SourceImpairment:
    def __init__(self, phases, mask: int = 1):
        if isinstance(phases, int):
            phases = (phases,)
        self.phases, self.mask = frozenset(p % 6 for p in phases), mask & 0xff
        self.run = self.count = self.flipped = 0
        self.active = self.done = False
        self.previous = -1

    @classmethod
    def from_environment(cls):
        value = os.environ.get("COURIER_X2_SOURCE_IMPAIR")
        if not value:
            return None
        phases, _, mask = value.partition(":")
        return cls([int(p, 0) for p in phases.split(",")], int(mask, 0) if mask else 1)

    def filter(self, octets: bytes) -> bytes:
        result = bytearray()
        for original in octets:
            value = original
            if not self.done:
                if not self.active:
                    self.run = self.run + 1 if original == 0x7e else 0
                    if self.run >= 7:
                        self.active, self.count = True, 0
                if self.active:
                    if self.previous == 0x81 and original == 0x81:
                        self.done = True
                    elif self.count % 6 in self.phases:
                        value ^= self.mask
                        self.flipped += 1
                    self.count += 1
            self.previous = original
            result.append(value)
        return bytes(result)
