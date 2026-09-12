from __future__ import annotations

from pathlib import Path
import unittest

from courier_emu.rom import (
    LCS_START,
    RESET_VECTOR,
    ROM_SIZE,
    UCS_START,
    CourierRom,
    RomFormatError,
)


ROOT = Path(__file__).resolve().parents[1]
IMAGE = ROOT / "IDSDL302.ROM"


@unittest.skipUnless(IMAGE.exists(), "no Courier ROM image available")
class CourierRomTests(unittest.TestCase):
    def setUp(self) -> None:
        self.rom = CourierRom.load(IMAGE)

    def test_the_reset_stub_places_the_rom(self) -> None:
        # An XMF carries only an update payload, so its address is a modelling
        # choice. A ROM ends with the 80186 reset vector, and the stub there
        # programs the chip select that decodes the ROM before it jumps, so the
        # image says where it lives.
        self.assertEqual(self.rom.base, 0x80000)
        self.assertEqual(self.rom.base + ROM_SIZE, 0x100000)
        self.assertEqual(self.rom.reset.chip_select_register, UCS_START)
        self.assertEqual(self.rom.reset.boot_physical, 0xFDA21)









@unittest.skipUnless(IMAGE.exists(), "no Courier ROM image available")
class RomBootTests(unittest.TestCase):

    def test_rom_at_input_and_dsp_tick_do_not_require_a_global_code_hook(self) -> None:
        """The ROM has dedicated UART and interrupt-controller models.

        Payload-only images need the per-instruction history to recognize the
        exits from their synthetic ISR injection.  A complete ROM does not;
        enabling the hook there makes every instruction cross into Python and
        prevents the live audio path from keeping up with a physical peer.
        """
        from courier_emu.machine import CourierMachine

        machine = CourierMachine(
            CourierRom.load(IMAGE),
            serial_input=b"AT\r",
            tick_source="dsp",
        )
        self.assertFalse(machine._needs_code_hook())


    def test_a_rom_yields_the_c50_payload_its_supervisor_downloads(self) -> None:
        """A ROM does carry a separable payload; it just is not laid out.

        This replaces a test that asserted the bridge is refused for a ROM.
        That was true only while the payload's location was unknown: the
        download call site names it, so the extraction is derived rather than
        assumed, and the values below are the ones the call site yields for
        this image.
        """
        from courier_emu.machine import CourierMachine

        rom = CourierRom.load(IMAGE)
        download = rom.dsp_download
        self.assertIsNotNone(download)
        self.assertEqual(download.entry_word, 0x8000)
        self.assertEqual(download.source_segment, 0xA908)
        self.assertEqual((download.offset, download.end), (0x29080, 0x368FC))
        self.assertEqual(download.length // 2, 27710)

        (origin, segment), = rom.dsp_program_segments()
        self.assertEqual(origin, 0x8000)
        self.assertEqual(segment, rom.data[0x29080:0x368FC])
        # The C52 reset code the load base was pinned against.
        self.assertEqual(segment[:6], bytes.fromhex("00bc57aeffff"))

        machine = CourierMachine(rom, with_dsp=True)
        self.assertIsNotNone(machine.dsp_bridge)

    def test_the_supervisor_downloads_the_payload_through_the_bridge(self) -> None:
        """The ROM's own download reaches the DSP, byte for byte.

        Every word travels through the modelled ports: e3aa's reset and entry
        request, then e47b alternating its two windows on port 0x18. Nothing
        here hands the payload to the bridge directly.
        """
        from courier_emu.machine import CourierMachine

        rom = CourierRom.load(IMAGE)
        machine = CourierMachine(rom, with_dsp=True)
        machine.run(20_000_000)
        bridge = machine.dsp_bridge
        self.assertTrue(bridge.active)
        self.assertEqual(bridge.bootstraps, 1)
        self.assertIs(bridge.bootstrap_match, True)
        # 27,710 words in eight-byte groups, and the checksum strobes after.
        # There are two, from different sites: 8e55f at 5,336,455 instructions
        # and 8e5ac at 5,668,749. This asked for one until the timer block's
        # instructions-per-second was corrected - it had the timers running
        # three times fast, and the ROM never got past the first strobe. The
        # first one still lands on the same instruction it always did.
        self.assertEqual(bridge.checksum_submits, 2)
        received = bytes(bridge.bootstrap[:bridge.bootstrap_target_size])
        self.assertEqual(received, rom.data[0x29080:0x368FC])




if __name__ == "__main__":
    unittest.main()

