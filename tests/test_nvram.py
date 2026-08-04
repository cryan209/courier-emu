from __future__ import annotations

import tempfile
import unittest
from pathlib import Path

from courier_emu.nvram import (
    BIT_CHIP_SELECT,
    BIT_CLOCK,
    BIT_DATA,
    BIT_READY,
    NVRAM_BYTES,
    CourierNvram,
)


class MicrowireBus:
    """Replays the recovered port 0x10 bit-bang sequence against the device.

    Every step mirrors the supervisor driver: 5b5e:17f0 raises chip select,
    5b5e:17b3 cycles it between commands, 5b5e:17c6 clocks a twelve-bit command
    frame, and 5b5e:17d2 clocks data bits most-significant first.
    """

    def __init__(self, device: CourierNvram) -> None:
        self.device = device
        self.level = 0x00

    def out(self, value: int) -> None:
        self.level = value
        self.device.write_latch(value)

    def read(self) -> int:
        return (0xFF & ~(BIT_DATA | BIT_READY)) | self.device.read_latch()

    def select(self) -> None:
        self.out((self.level & 0x87) | BIT_CHIP_SELECT)

    def cycle_select(self) -> None:
        self.out(self.level & ~BIT_CHIP_SELECT)
        self.out(self.level | BIT_CHIP_SELECT)

    def shift(self, bits: int, count: int) -> None:
        for index in range(count):
            level = self.level & ~BIT_DATA
            if (bits >> (15 - index)) & 1:
                level |= BIT_DATA
            self.out(level)
            self.out(level | BIT_CLOCK)
            self.out(level & ~BIT_CLOCK)

    def command(self, opcode: int, address: int) -> None:
        self.shift(((((opcode & 3) | 4) << 8 | address) << 4) & 0xFFFF, 12)

    def read_word(self, address: int) -> int:
        self.select()
        self.cycle_select()
        self.command(2, address)
        value = 0
        for _ in range(16):
            level = (self.level | BIT_CHIP_SELECT) & ~0x08
            self.out(level)
            self.out(level | BIT_CLOCK)
            self.out(level & ~BIT_CLOCK)
            value = ((value << 1) | (1 if self.read() & BIT_DATA else 0)) & 0xFFFF
        self.out(self.level & 0x8F)
        return value

    def write_word(self, address: int, data: int) -> None:
        self.select()
        self.cycle_select()
        self.command(0, 0xC0)  # EWEN
        self.cycle_select()
        self.command(1, address)
        self.shift(data, 16)
        self.cycle_select()
        self.select()
        self.command(0, 0x00)  # EWDS
        self.out(self.level & ~BIT_CHIP_SELECT)


class CourierNvramTest(unittest.TestCase):
    def test_blank_device_reads_all_ones(self) -> None:
        bus = MicrowireBus(CourierNvram())
        self.assertEqual(bus.read_word(0x00), 0xFFFF)
        self.assertEqual(bus.read_word(0xFF), 0xFFFF)

    def test_write_then_read_round_trips(self) -> None:
        device = CourierNvram()
        bus = MicrowireBus(device)
        bus.write_word(0x03, 0x1234)
        bus.write_word(0x2A, 0xBEEF)
        self.assertEqual(bus.read_word(0x03), 0x1234)
        self.assertEqual(bus.read_word(0x2A), 0xBEEF)
        self.assertEqual(device.writes, 2)
        self.assertEqual(device.reads, 2)

    def test_programming_needs_the_write_enable_command(self) -> None:
        device = CourierNvram()
        bus = MicrowireBus(device)
        bus.select()
        bus.cycle_select()
        bus.command(1, 0x05)
        bus.shift(0xA5A5, 16)
        bus.out(bus.level & ~BIT_CHIP_SELECT)
        self.assertEqual(device.word(0x05), 0xFFFF)
        self.assertEqual(device.writes, 0)

    def test_write_disable_closes_the_window_again(self) -> None:
        device = CourierNvram()
        bus = MicrowireBus(device)
        bus.write_word(0x07, 0x0042)
        self.assertFalse(device.write_enabled)
        bus.select()
        bus.cycle_select()
        bus.command(1, 0x07)
        bus.shift(0x0000, 16)
        bus.out(bus.level & ~BIT_CHIP_SELECT)
        self.assertEqual(device.word(0x07), 0x0042)

    def test_device_reports_ready_before_every_transfer(self) -> None:
        # 5b5e:1801 aborts the whole transfer unless input bit 0x08 reads high.
        device = CourierNvram()
        self.assertTrue(device.read_latch() & BIT_READY)

    def test_file_backing_persists_across_sessions(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "settings.nv"
            device = CourierNvram.load(path)
            MicrowireBus(device).write_word(0x11, 0xCAFE)
            device.save()
            self.assertEqual(path.stat().st_size, NVRAM_BYTES)
            self.assertEqual(CourierNvram.load(path).word(0x11), 0xCAFE)

    def test_load_rejects_a_wrongly_sized_image(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "short.nv"
            path.write_bytes(b"\xff" * 16)
            with self.assertRaises(ValueError):
                CourierNvram.load(path)


if __name__ == "__main__":
    unittest.main()
