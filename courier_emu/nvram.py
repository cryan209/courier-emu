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

# IDSDL302 copies EEPROM words 94..102 into RAM 0752..0763.  Its six
# settings records are three redundant, differently obfuscated bytes, stored
# in the physical order 2, 3, 4, 5, 6, 1.  These values were recovered from a
# running 20.16 MHz Courier; setting 3 is the bit field that permits the ROM
# to open its DTE output.
IDSDL302_SETTINGS_WORD = 94
IDSDL302_SETTINGS = (0, 30, 7, 30, 0, 0)
IDSDL302_RECORD_ORDER = (1, 2, 3, 4, 5, 0)

# ID_SDL's extended (+S) register block. AT+SF loads it from the defaults
# table at CPU 0xc8891 and AT&W stores it as a byte stream from the high byte
# of EEPROM word 0xc1 through the low byte of 0xf4 - measured in the emulator
# by running AT+SF then AT&W on the 302 image, and byte-identical to the ROM
# table. Words 0xcc..0xce carry +S22 = 525, +S24 = 13000 and +S26 = 3080; the
# dial path sends those three on mailbox tags 0x19, 0x1a and 0x1b as the
# DTMF detector sensitivity and the two transmit levels. Left erased, the
# lanes carry 0xffff and the DSP dials silently, which is the fault the board
# had (docs/idsdl-extended-registers.md).
IDSDL302_EXTENDED_BYTE = 0xC1 * 2 + 1
IDSDL302_EXTENDED = bytes.fromhex(
    "460000000a2304ff097d4b000d02000040941100400d02c832080c581b18b400"
    "0400000000000000000000000000000000000000000000000000001404010514"
    "0800000000000000000000000000000000000000000001000000000000000000"
    "0000332e3032"
)


# 7.4.16 keeps the same 102-byte block five words further into the EEPROM: the
# high byte of word 0xc6 rather than 0xc1. Measured, not guessed - an emulated
# 403 run with the 302 fixture lands block offset 10 at RAM 0x071b where the
# board lands offset 0, and ten bytes is exactly five words.
#
# The content is the board's own provisioning, read out of the read-only RAM
# capture in artifacts/courier-board-21210-ram-403/ at 0x071b, identical across
# both passes. Its last word is the giveaway that the alignment is right: 302
# ends the block with the ASCII "3.02" and this ends with 0x0193 - 403.
#
# It carries the transmit levels the 403 datapump needs. Words at block offset
# 23 and 25 are 0x32c8 and 0x0c08, which the dial path sends on mailbox tags
# 0x1a and 0x1b; with the 302 fixture those lanes read zero and the DSP dials
# silently (docs/datapump-dispatch-gate.md).
# The board's whole settings part, lifted from the read-only RAM capture in
# artifacts/courier-board-21210-ram-403/. The boot block copies the 512-byte
# part to RAM 0x058e..0x078d before checksumming it there, so that window is
# the part's contents; it is identical across both passes of the capture, its
# stored checksum byte validates against `settings_checksum`, and it carries
# IDSDL403_EXTENDED at exactly IDSDL403_EXTENDED_BYTE - three independent
# checks that this is the store and that the offsets above are right.
#
# This is a real provisioned part rather than a synthesised one, which matters:
# a fixture that is merely checksum-valid over erased bytes is worse than no
# fixture, because the firmware then trusts the erased profile and configures
# its DTE from it.
IDSDL403_NVRAM = bytes.fromhex(
    "715088ca210402110100060000000000000000012b0d0a08023c02060e463200"
    "00001e0a111396050130081400060000000000000000007ec80f0000400000e0"
    "4000000000000000000000000000000000000000000000000000000000000000"
    "0000000000000000000000000000000000000000000000000000000000000000"
    "0000000000000000000000000000000000000000000000000000000000000000"
    "00000000000030332f31332f3938000954303034268322111affffff68170208"
    "0b1a649603ef871def871def871d0000000000000000000000000000000000ff"
    "ffffffffffffffffffffffffffffffffffffffffffffffffffffffffff000000"
    "0000000000000000000000000000000000000000000000000000000000000000"
    "0000000000000000000000000000000000000000000000000000000000000000"
    "0000000000000000000000000000000000000000000000000000000000000000"
    "0000000000000000000000000000000000000000000000000000000000000000"
    "00000000000000000000000000460000000a2304ff097d4b000d020006060201"
    "01000d02c832080c681018b400040000030a0a0a000000000000000000000000"
    "000000000000000a1e04050f000a00061040640a07000f060000000000000000"
    "00000000000000000000000000000000009301ffff000000000000ffffffffbd"
)

IDSDL403_EXTENDED_BYTE = 0xC6 * 2 + 1
IDSDL403_EXTENDED = bytes.fromhex(
    "460000000a2304ff097d4b000d02000606020101000d02c832080c681018b400"
    "040000030a0a0a000000000000000000000000000000000000000a1e04050f00"
    "0a00061040640a07000f06000000000000000000000000000000000000000000"
    "000000009301"
)


# The boot block copies the whole 512-byte part into RAM 0x058e..0x078d and
# checks it at 0x81412:
#
#   mov si,058e ; mov cx,078d ; sub cx,si   ; 511 bytes, 0x058e..0x078c
#   xor dl,dl ; lodsb ; add dl,al ; loop
#   sub dl,al                               ; back out the last one
#   cmp dl,[078d]                           ; the stored byte
#
# so the sum runs over EEPROM bytes 0..509, byte 510 is loaded and subtracted
# back out again, and byte 511 holds the result. A part that fails this is what
# makes the power-on self test print NVRAM CHECKSUM FAILURE, and it is why a
# fixture without it renders every setting at its erased value.
CHECKSUM_BYTE = NVRAM_BYTES - 1
CHECKSUM_SPAN = NVRAM_BYTES - 2


def settings_checksum(data: bytes | bytearray) -> int:
    """The byte the boot block's check at 0x81412 expects at byte 511."""
    return sum(data[:CHECKSUM_SPAN]) & 0xFF


def encode_idsl302_record(value: int) -> bytes:
    """Reverse the three byte transformations in IDSDL302's e237 decoder."""
    if not 0 <= value <= 0xFF:
        raise ValueError(f"an IDSDL302 setting must be one byte, got {value}")

    # Decoder copies: ror(a, 2) + 5, rol(b, 1) - 0x0f, c xor 0x1d.
    first = (value - 5) & 0xFF
    first = ((first << 2) | (first >> 6)) & 0xFF
    second = (value + 0x0F) & 0xFF
    second = ((second >> 1) | (second << 7)) & 0xFF
    return bytes((first, second, value ^ 0x1D))


def encode_idsl302_settings(values: tuple[int, ...] = IDSDL302_SETTINGS) -> bytes:
    """Encode the six records in their nine-word EEPROM storage order."""
    if len(values) != 6:
        raise ValueError(f"IDSDL302 needs six settings, got {len(values)}")
    return b"".join(encode_idsl302_record(values[index]) for index in IDSDL302_RECORD_ORDER)


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

    @classmethod
    def idsl403_fixture(cls) -> CourierNvram:
        """Return the board's own settings part, as captured from it.

        Nothing here is synthesised. Earlier revisions seeded only the +S
        block into an otherwise erased part, which failed the boot block's
        checksum and left every setting reading at its erased value.
        """
        return cls(data=bytearray(IDSDL403_NVRAM))

    @classmethod
    def idsl302_fixture(cls) -> CourierNvram:
        """Return an erased EEPROM seeded with the recovered boot settings and
        the +S register defaults; every other word stays erased."""
        device = cls()
        start = IDSDL302_SETTINGS_WORD * 2
        encoded = encode_idsl302_settings()
        device.data[start : start + len(encoded)] = encoded
        device.data[IDSDL302_EXTENDED_BYTE : IDSDL302_EXTENDED_BYTE + len(IDSDL302_EXTENDED)] = IDSDL302_EXTENDED
        device.data[CHECKSUM_BYTE] = settings_checksum(device.data)
        return device

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
