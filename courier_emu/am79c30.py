"""The Am79C30A Digital Subscriber Controller, as the I-modem drives it.

The board reaches the chip through two ports: a command register that selects
which of the chip's registers is addressed, and a data register that streams
that register's bytes.  Every register is a *block* of a fixed width, and the
data port walks the block one byte per access - so the widths are part of the
protocol, not decoration.  They are also how the part was identified: the
firmware writes exactly seven bytes to `DLC_1_7` and exactly two to `DRCR`.
See docs/imodem-isdn-front-end.md.

Nothing here decides what the chip *does*; it holds what the firmware wrote and
reports back what a real part would return for the registers the firmware
reads.  Where a reported value is not recovered from the image it is named and
left configurable rather than guessed at silently.
"""
from __future__ import annotations

from collections import Counter
from dataclasses import dataclass, field


COMMAND_PORT = 0x0300
DATA_PORT = 0x0301

# Register block widths, in bytes. The names are the part's own; the widths
# are what the data port walks before it stops.
REGISTERS: dict[int, tuple[str, int]] = {
    0x20: ("INIT2", 1),
    0x21: ("INIT", 1),
    # The channel multiplexer: which of B1, B2 and the internal ports connect.
    0x41: ("MCR1", 1),
    0x42: ("MCR2", 1),
    0x43: ("MCR3", 1),
    0x44: ("MCR4", 1),
    0x45: ("MCR5", 1),
    # The main audio processor.
    0x61: ("MAP_X", 8),
    0x62: ("MAP_R", 8),
    0x63: ("MAP_GX", 2),
    0x64: ("MAP_GR", 2),
    0x65: ("MAP_GER", 2),
    0x66: ("MAP_STGR", 2),
    0x67: ("MAP_FTGR_1_2", 2),
    0x68: ("MAP_ATGR_1_2", 2),
    0x69: ("MAP_MMR1", 1),
    0x6A: ("MAP_MMR2", 1),
    0x6B: ("MAP_1_10", 46),
    0x6C: ("MAP_MMR3", 1),
    0x6D: ("MAP_STRA", 2),
    0x6E: ("MAP_STRF", 2),
    0x70: ("MAP_PEAKX", 2),
    0x71: ("MAP_PEAKR", 2),
    0x72: ("MAP_15_16", 2),
    # The D-channel HDLC controller.
    0x81: ("DLC_FRAR_1_2_3", 3),
    0x82: ("DLC_SRAR_1_2_3", 3),
    0x83: ("DLC_TAR", 1),
    0x84: ("DLC_DRLR", 6),
    0x85: ("DLC_DTCR", 2),
    0x86: ("DLC_DMR1", 1),
    0x87: ("DLC_DMR2", 1),
    0x88: ("DLC_1_7", 7),
    0x89: ("DLC_DRCR", 2),
    0x8A: ("DLC_RNGR1", 2),
    0x8B: ("DLC_RNGR2", 2),
    0x8C: ("DLC_FRAR4", 1),
    0x8D: ("DLC_SRAR4", 1),
    0x8E: ("DLC_DMR3", 1),
    0x8F: ("DLC_DMR4", 1),
    0x90: ("DLC_12_15", 4),
    0x91: ("DLC_ASR", 1),
    0x92: ("DLC_EFCR", 1),
    # The line interface unit: the S/T transceiver.
    0xA1: ("LIU_LSR", 1),
    0xA2: ("LIU_LPR", 1),
    0xA3: ("LIU_LMR1", 1),
    0xA4: ("LIU_LMR2", 1),
    0xA5: ("LIU_2_4", 3),
    0xA6: ("LIU_MF", 1),
    0xA7: ("LIU_MFSB", 1),
    0xA8: ("LIU_MFQB", 1),
    # The peripheral port.
    0xC0: ("PP_PPCR1", 1),
    0xC1: ("PP_PPSR", 1),
    0xC2: ("PP_PPIER", 1),
    0xC4: ("PP_PPCR2", 1),
    0xC8: ("PP_PPCR3", 1),
}

# Reads whose value is not held in a written block. The LIU's line state is the
# one the activation sequence turns on; it is left at reset until a caller says
# otherwise, so nothing here fakes a line that is not there.
DEFAULT_READS: dict[int, int] = {}


@dataclass
class Am79C30:
    """The register file behind the command/data pair."""

    reads: dict[int, int] = field(default_factory=lambda: dict(DEFAULT_READS))
    blocks: dict[int, bytearray] = field(default_factory=dict)
    selected: int | None = None
    cursor: int = 0
    read_counts: Counter = field(default_factory=Counter)
    write_counts: Counter = field(default_factory=Counter)
    unknown: Counter = field(default_factory=Counter)
    overruns: Counter = field(default_factory=Counter)

    def handles(self, port: int) -> bool:
        return port in (COMMAND_PORT, DATA_PORT)

    # -- the command port --------------------------------------------------

    def select(self, register: int) -> None:
        """Point the data port at a register and rewind to its first byte."""
        register &= 0xFF
        self.selected = register
        self.cursor = 0
        if register not in REGISTERS:
            self.unknown[register] += 1

    # -- the data port -----------------------------------------------------

    def _width(self, register: int) -> int:
        entry = REGISTERS.get(register)
        return entry[1] if entry else 1

    def write_data(self, value: int) -> None:
        register = self.selected
        if register is None:
            return
        width = self._width(register)
        block = self.blocks.setdefault(register, bytearray(width))
        if self.cursor >= width:
            # A real part ignores the extra; record it rather than grow, so a
            # width that is wrong here shows up instead of hiding.
            self.overruns[register] += 1
            return
        block[self.cursor] = value & 0xFF
        self.cursor += 1
        self.write_counts[register] += 1

    def read_data(self) -> int:
        register = self.selected
        if register is None:
            return 0
        self.read_counts[register] += 1
        if register in self.reads:
            return self.reads[register] & 0xFF
        block = self.blocks.get(register)
        width = self._width(register)
        if block is None or self.cursor >= width:
            return 0
        value = block[self.cursor]
        self.cursor += 1
        return value

    # -- the ports ---------------------------------------------------------

    def read(self, port: int) -> int:
        if port == DATA_PORT:
            return self.read_data()
        return self.selected or 0

    def write(self, port: int, value: int) -> None:
        if port == COMMAND_PORT:
            self.select(value)
        else:
            self.write_data(value)

    # -- reporting ---------------------------------------------------------

    def name(self, register: int) -> str:
        entry = REGISTERS.get(register)
        return entry[0] if entry else f"unknown_{register:02x}"

    def status(self) -> dict[str, object]:
        return {
            "written": {
                self.name(r): bytes(b).hex(" ")
                for r, b in sorted(self.blocks.items())
                if self.write_counts.get(r)
            },
            "read_counts": {
                self.name(r): c for r, c in self.read_counts.most_common()
            },
            "unknown_registers": {f"{r:#04x}": c for r, c in self.unknown.most_common()},
            "overruns": {self.name(r): c for r, c in self.overruns.most_common()},
        }
