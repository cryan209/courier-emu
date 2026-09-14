"""Declarative hardware and firmware maps for the Courier emulator.

The emulator used to keep recovered addresses beside the code that happened to
use them.  That made the normal execution path double as a discovery harness.
This module is the canonical description of the machine instead: hardware
ranges are stable, while ROM-specific facts live in guarded firmware profiles.
"""
from __future__ import annotations

from dataclasses import dataclass
from typing import Any


@dataclass(frozen=True)
class AddressRange:
    name: str
    first: int
    last: int
    device: str

    def __post_init__(self) -> None:
        if self.first < 0 or self.last < self.first:
            raise ValueError(f"invalid address range {self.name!r}")

    def contains(self, address: int) -> bool:
        return self.first <= address <= self.last


@dataclass(frozen=True)
class FirmwareProfile:
    """Facts which are true only for one byte-identical ROM image."""

    name: str
    sha256: str
    supervisor: str
    dsp: str
    product: str
    clock_mhz: str
    boot_entry: int


@dataclass(frozen=True)
class CourierMachineMap:
    address_bits: int
    memory: tuple[AddressRange, ...]
    mmio: AddressRange
    dsp_queue: AddressRange
    serial_callback: AddressRange
    dsp_reset_port: int
    flash_service_vector: int
    tick_vector: int
    firmware: FirmwareProfile | None = None

    @property
    def address_space_size(self) -> int:
        return 1 << self.address_bits

    def region_at(self, address: int) -> AddressRange | None:
        # More specific ranges intentionally win over their RAM container.
        matches = (region for region in self.memory if region.contains(address))
        return min(matches, key=lambda region: region.last - region.first, default=None)

    def describe(self) -> dict[str, Any]:
        return {
            "address_bits": self.address_bits,
            "firmware": self.firmware.name if self.firmware else "unknown-rom",
            "regions": [
                {"name": r.name, "first": r.first, "last": r.last,
                 "device": r.device}
                for r in self.memory
            ],
        }


# Exact digests make profile selection evidence, not a revision-string guess.
FIRMWARE_PROFILES = {
    profile.sha256: profile
    for profile in (
        FirmwareProfile(
            name="australia-061-7.4.16-3.0.13",
            sha256="85665f6db32b06b256dd70d631be3e0e0a120890b31b04c0f571f72497a22bcb",
            supervisor="061-7.4.16", dsp="3.0.13",
            product="Australia External", clock_mhz="20.16",
            boot_entry=0x0FCFE7,
        ),
        FirmwareProfile(
            name="australia-061-7.6.7-3.1.2",
            sha256="d68f6fd8c1a2fcc047f88d05ec9f581b2186d660b93e3bb3866f433820c1cc7e",
            supervisor="061-7.6.7", dsp="3.1.2",
            product="Australia External", clock_mhz="20.16",
            boot_entry=0x0FCFE7,
        ),
    )
}


def courier_machine_map(image: Any) -> CourierMachineMap:
    """Build the canonical board map and select an exact ROM profile."""
    profile = FIRMWARE_PROFILES.get(getattr(image, "digest", ""))
    reset = getattr(image, "reset", None)
    if profile is not None and reset is not None and reset.boot_physical != profile.boot_entry:
        raise ValueError(
            f"{profile.name} reset entry is {reset.boot_physical:#x}, "
            f"expected {profile.boot_entry:#x}"
        )
    mmio = AddressRange("80186-peripheral-control", 0xFF00, 0xFFFF, "80186-eb")
    dsp_queue = AddressRange("dsp-host-queue", 0x02CA, 0x030F, "courier-asic")
    serial_callback = AddressRange("serial-tx-callback", 0x02AA, 0x02AB, "ram")
    return CourierMachineMap(
        address_bits=20,
        memory=(
            AddressRange("ram", 0x00000, 0x7FFFF, "ram"),
            AddressRange("flash", 0x80000, 0xFFFFF, "flash"),
            serial_callback,
            dsp_queue,
            mmio,
        ),
        mmio=mmio,
        dsp_queue=dsp_queue,
        serial_callback=serial_callback,
        dsp_reset_port=0xFF56,
        flash_service_vector=0x0A,
        tick_vector=0x0F,
        firmware=profile,
    )
