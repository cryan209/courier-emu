from __future__ import annotations

import tempfile
import unittest
from pathlib import Path

from courier_emu.nvram import (
    BIT_CHIP_SELECT,
    IDSDL302_EXTENDED,
    IDSDL403_EXTENDED,
    IDSDL403_EXTENDED_BYTE,
    BIT_CLOCK,
    BIT_DATA,
    BIT_READY,
    NVRAM_BYTES,
    CourierNvram,
    encode_idsl302_record,
    encode_idsl302_settings,
)
from courier_emu.ram_dump import decode_settings


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

    def test_idsl302_record_encoder_reverses_all_three_decoders(self) -> None:
        for value in (0, 1, 7, 30, 0xFF):
            record = encode_idsl302_record(value)
            # Put the record at setting 2's physical position; the decoder's
            # pointer order then exposes all three independently decoded copies.
            records = decode_settings(record + encode_idsl302_record(0) * 5)
            decoded = records[1]
            self.assertEqual(decoded["decoded_copies"], [value] * 3)
            self.assertTrue(decoded["all_copies_agree"])

    def test_idsl302_fixture_programs_the_settings_and_the_extended_block(self) -> None:
        device = CourierNvram.idsl302_fixture()
        encoded = encode_idsl302_settings()
        self.assertEqual(encoded.hex(), "649603080b1a649603ef871def871def871d")
        self.assertEqual(device.data[94 * 2 : 103 * 2], encoded)
        self.assertEqual(device.data[:94 * 2], b"\xff" * (94 * 2))
        # The +S block starts on the high byte of word 0xc1 and ends on the low
        # byte of 0xf4; the bytes either side of it stay erased.
        self.assertEqual(device.data[103 * 2 : 0xC1 * 2 + 1], b"\xff" * (0xC1 * 2 + 1 - 103 * 2))
        self.assertEqual(device.data[0xF4 * 2 + 1 :], b"\xff" * (NVRAM_BYTES - 0xF4 * 2 - 1))
        self.assertEqual(device.word(0xC1) >> 8, 70)        # +S1
        self.assertEqual(device.word(0xCC), 525)            # +S22
        self.assertEqual(device.word(0xCD), 13000)          # +S24
        self.assertEqual(device.word(0xCE), 3080)           # +S26
        self.assertEqual(device.data[0xF2 * 2 + 1 : 0xF4 * 2 + 1], b"3.02")
        decoded = decode_settings(encoded)
        self.assertEqual([record["value"] for record in decoded], [0, 30, 7, 30, 0, 0])

    def test_idsl403_fixture_places_the_block_where_7_4_16_reads_it(self) -> None:
        device = CourierNvram.idsl403_fixture()
        # Five words later than 7.3.14: the high byte of 0xc6, not 0xc1.
        self.assertEqual(IDSDL403_EXTENDED_BYTE, 0xC6 * 2 + 1)
        self.assertEqual(len(IDSDL403_EXTENDED), len(IDSDL302_EXTENDED))
        start, end = IDSDL403_EXTENDED_BYTE, IDSDL403_EXTENDED_BYTE + len(IDSDL403_EXTENDED)
        self.assertEqual(device.data[start:end], IDSDL403_EXTENDED)
        # Nothing else is seeded: 7.4.16's boot settings are not 7.3.14's six
        # obfuscated records, so words 94..102 stay erased rather than carrying
        # a 302 shape.
        self.assertEqual(device.data[:start], b"\xff" * start)
        self.assertEqual(device.data[end:], b"\xff" * (NVRAM_BYTES - end))
        # The transmit levels the 403 datapump reads through 0cd9 and 0cdb.
        self.assertEqual(device.word(0xD1), 525)            # +S22
        self.assertEqual(device.word(0xD2), 13000)          # +S24, 0x32c8
        self.assertEqual(device.word(0xD3), 3080)           # +S26, 0x0c08
        # The block's own trailer names its firmware: 0x0193 is 403, where the
        # 302 block ends with the ASCII "3.02".
        self.assertEqual(IDSDL403_EXTENDED[-2:], bytes((0x93, 0x01)))

    def test_default_device_remains_blank(self) -> None:
        self.assertEqual(CourierNvram().data, b"\xff" * NVRAM_BYTES)


if __name__ == "__main__":
    unittest.main()
