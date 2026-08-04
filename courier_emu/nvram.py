from __future__ import annotations

from dataclasses import dataclass, field
from pathlib import Path
from typing import Any


# The Courier settings store is a Microwire serial EEPROM bit-banged through
# board latch 0 (I/O port 0x10). The recovered driver lives at physical
# 0x5ccc0..0x5cdf9:
#
#   5b5e:16e0  far read  word  [0x8d2] = address, result in [0x8d3]
#   5b5e:1746  far write word  [0x8cf] = address, [0x8d0] = data
#   5b5e:17d2  shift 12 command bits then N data bits, MSB first
#   5b5e:1801  presence/ready poll: input port 0x10 bit 0x08 must read high
#
# The command frame at 5b5e:17c6 builds bx = ((opcode & 3) | 4) << 8 | address
# and rotates it left by four before clocking twelve bits out. That produces one
# leading pad bit, the start bit, two opcode bits, and an eight-bit address,
# which is the 256 x 16 member of the 93C46 family (93C66).
NVRAM_WORDS = 256
NVRAM_BYTES = NVRAM_WORDS * 2

BIT_DATA = 0x10  # DI when written to port 0x10, DO when read back
BIT_CHIP_SELECT = 0x20
BIT_CLOCK = 0x40
BIT_READY = 0x08  # input-only presence indication polled at 5b5e:1801

OPCODE_EXTENDED = 0
OPCODE_WRITE = 1
OPCODE_READ = 2
OPCODE_ERASE = 3

MAX_TRACE_EVENTS = 256


@dataclass
class CourierNvram:
    """The board's 93C66-class Microwire settings EEPROM."""

    data: bytearray = field(default_factory=lambda: bytearray(b"\xff" * NVRAM_BYTES))
    path: Path | None = None
    reads: int = 0
    writes: int = 0
    erases: int = 0
    write_enabled: bool = False
    trace: list[str] = field(default_factory=list)

    # Transfer state. `shift_in` accumulates clocked-in bits until a start bit
    # and its twelve-bit command frame are complete; `shift_out` holds the word
    # being returned to the supervisor.
    _clock: bool = False
    _selected: bool = False
    _bits: int = 0
    _count: int = 0
    _started: bool = False
    _opcode: int | None = None
    _address: int = 0
    _pending: int = 0
    _pending_count: int = 0
    _shift_out: int | None = None
    _data_out: bool = True

    def __post_init__(self) -> None:
        if len(self.data) != NVRAM_BYTES:
            raise ValueError(f"NVRAM image must be {NVRAM_BYTES} bytes, got {len(self.data)}")

    @classmethod
    def load(cls, path: str | Path) -> CourierNvram:
        """Attach a file-backed device, creating a blank image when absent."""
        location = Path(path)
        if location.exists():
            content = bytearray(location.read_bytes())
            if len(content) != NVRAM_BYTES:
                raise ValueError(
                    f"{location} is {len(content)} bytes; the Courier NVRAM is {NVRAM_BYTES}"
                )
        else:
            content = bytearray(b"\xff" * NVRAM_BYTES)
        return cls(data=content, path=location)

    def save(self) -> None:
        if self.path is not None:
            self.path.write_bytes(bytes(self.data))

    def word(self, address: int) -> int:
        index = (address % NVRAM_WORDS) * 2
        return int.from_bytes(self.data[index : index + 2], "little")

    def set_word(self, address: int, value: int) -> None:
        index = (address % NVRAM_WORDS) * 2
        self.data[index : index + 2] = (value & 0xFFFF).to_bytes(2, "little")

    def _trace(self, event: str) -> None:
        if len(self.trace) < MAX_TRACE_EVENTS:
            self.trace.append(event)

    def write_latch(self, value: int) -> None:
        """Apply one board-latch write to the chip-select, clock, and data pins."""
        selected = bool(value & BIT_CHIP_SELECT)
        clock = bool(value & BIT_CLOCK)
        if not selected:
            if self._selected:
                self._end_transfer()
            self._selected = False
            self._clock = clock
            return
        if not self._selected:
            self._begin_transfer()
        self._selected = True
        if clock and not self._clock:
            self._rising_edge(bool(value & BIT_DATA))
        self._clock = clock

    def read_latch(self) -> int:
        """Return the input-port bits this device drives on port 0x10."""
        value = BIT_READY
        if self._data_out:
            value |= BIT_DATA
        return value

    def _begin_transfer(self) -> None:
        self._bits = 0
        self._count = 0
        self._started = False
        self._opcode = None
        self._address = 0
        self._pending = 0
        self._pending_count = 0
        self._shift_out = None
        # A programmed device holds DO high (ready) while idle; the driver's
        # busy poll at 5b5e:1783 waits for exactly that.
        self._data_out = True

    def _end_transfer(self) -> None:
        if self._opcode == OPCODE_WRITE and self._pending_count == 16:
            self._commit_write(self._address, self._pending)
        self._opcode = None
        self._shift_out = None
        self._data_out = True

    def _rising_edge(self, data_in: bool) -> None:
        if self._shift_out is not None:
            # READ streams the selected word MSB first, one bit per clock.
            self._data_out = bool(self._shift_out & 0x8000)
            self._shift_out = (self._shift_out << 1) & 0xFFFF
            return
        if not self._started:
            # Leading zeros are padding; the frame begins at the first one bit.
            if not data_in:
                return
            self._started = True
            self._bits = 0
            self._count = 0
            return
        self._bits = ((self._bits << 1) | int(data_in)) & 0xFFFFFFFF
        self._count += 1
        if self._opcode is None:
            if self._count == 10:
                self._opcode = (self._bits >> 8) & 3
                self._address = self._bits & 0xFF
                self._begin_command()
            return
        self._pending = ((self._pending << 1) | int(data_in)) & 0xFFFF
        self._pending_count += 1

    def _begin_command(self) -> None:
        opcode = self._opcode
        address = self._address
        if opcode == OPCODE_READ:
            value = self.word(address)
            self.reads += 1
            # Real parts emit a leading dummy zero before the data word.
            self._data_out = False
            self._shift_out = value
            self._trace(f"read {address:#04x}={value:#06x}")
        elif opcode == OPCODE_WRITE:
            self._pending = 0
            self._pending_count = 0
        elif opcode == OPCODE_ERASE:
            if self.write_enabled:
                self.set_word(address, 0xFFFF)
            self.erases += 1
            self._trace(f"erase {address:#04x}")
        else:
            # Extended opcode 00: the top two address bits select the mode.
            mode = (address >> 6) & 3
            if mode == 3:
                self.write_enabled = True
                self._trace("write-enable")
            elif mode == 0:
                self.write_enabled = False
                self._trace("write-disable")
            elif mode == 2:
                if self.write_enabled:
                    self.data[:] = b"\xff" * NVRAM_BYTES
                self.erases += 1
                self._trace("erase-all")
            # mode 1 is write-all; the recovered driver never issues it.

    def _commit_write(self, address: int, value: int) -> None:
        if not self.write_enabled:
            self._trace(f"write {address:#04x}={value:#06x} refused")
            return
        self.set_word(address, value)
        self.writes += 1
        self._trace(f"write {address:#04x}={value:#06x}")

    def status(self) -> dict[str, Any]:
        used = [
            f"{index:#04x}={self.word(index):#06x}"
            for index in range(NVRAM_WORDS)
            if self.word(index) != 0xFFFF
        ]
        return {
            "device": "93c66-microwire",
            "words": NVRAM_WORDS,
            "path": str(self.path) if self.path else None,
            "reads": self.reads,
            "writes": self.writes,
            "erases": self.erases,
            "write_enabled": self.write_enabled,
            "programmed_words": used[:64],
            "trace": self.trace,
        }
