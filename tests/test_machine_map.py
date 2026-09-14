from pathlib import Path

from courier_emu.machine_map import FIRMWARE_PROFILES, courier_machine_map
from courier_emu.rom import CourierRom


ROOT = Path(__file__).resolve().parents[1]


def test_canonical_regions_prefer_mapped_device_over_ram():
    image = CourierRom.load(ROOT / "IDSDL302.ROM")
    memory = courier_machine_map(image)

    assert memory.address_space_size == 0x100000
    assert memory.region_at(0x02CA).name == "dsp-host-queue"
    assert memory.region_at(0xFF56).name == "80186-peripheral-control"
    assert memory.region_at(0x80000).device == "flash"


def test_australian_roms_select_exact_firmware_profiles():
    cases = (
        ("courier-board-11430-flash-20260914-02", "061-7.4.16", "3.0.13"),
        ("courier-board-11430-flash-20260914-unit2-02", "061-7.6.7", "3.1.2"),
    )
    for directory, supervisor, dsp in cases:
        image = CourierRom.load(ROOT / "artifacts" / directory / "courier-board.rom")
        profile = courier_machine_map(image).firmware
        assert profile is FIRMWARE_PROFILES[image.digest]
        assert profile.supervisor == supervisor
        assert profile.dsp == dsp
        assert profile.product == "Australia External"
        assert profile.boot_entry == image.reset.boot_physical
