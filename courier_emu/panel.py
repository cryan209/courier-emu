from __future__ import annotations

from dataclasses import dataclass, field
from typing import Any


# The supervisor drives every board output through one read-modify-write latch
# driver, recovered at physical 0x5e2b0 (set), 0x5e2e5 (clear), 0x5e335 (read an
# input port), and 0x5e294 (read the shadow). Callers pass AX = mask << 8 | index,
# where the low byte carries a latch index in bits 0..1 and a validity flag in
# bit 3.
#
# The index-to-port table is at physical 0x5e31c and the matching shadow bytes
# are the five bytes cleared at 0x5e26c:
#
#   index 0 -> port 0x10, shadow 0x064d
#   index 1 -> port 0x12, shadow 0x064e
#   index 2 -> port 0x14, shadow 0x064f
#   index 3 -> port 0x12, shadow 0x0650
#   index 4 -> port 0x14 (read path only)
#
# 0x5e26c seeds the shadows to 0xff, then forces 0x064d = 0xfe and 0x064e = 0xbf.
LATCH_PORTS = (0x10, 0x12, 0x14, 0x12, 0x14)
LATCH_SHADOWS = (0x064D, 0x064E, 0x064F, 0x0650)
PANEL_PORTS = (0x0E, 0x10, 0x12, 0x14)

MAX_PANEL_EVENTS = 512


# Bit names are only claimed where the firmware itself shows what the line does.
# Everything else is reported by its driver-wrapper address so the caller can see
# an unidentified indicator changing rather than a silently discarded write.
OUTPUT_BITS: dict[int, dict[int, str]] = {
    0x10: {
        0x01: "off-hook-aux",
        0x02: "board-02",
        0x04: "hook-relay",
        0x08: "nvram-strobe",
        0x10: "nvram-data-in",
        0x20: "nvram-chip-select",
        0x40: "nvram-clock",
        0x80: "board-80",
    },
    0x12: {
        0x01: "indicator-12-01",
        0x02: "id-strap-drive-b",  # driven low at 0x5c001 during the 0x5bfc6 strap scan
        0x04: "indicator-12-04",
        # The fatal blinker at 0x5c77d/0x5c78f toggles this bit in shadow 0x064e,
        # though it emits the shadow on port 0x40 rather than through this latch.
        0x08: "blink-code-bit",
        0x10: "indicator-12-10",
        0x20: "indicator-12-20",
        0x40: "indicator-12-40",
        0x80: "indicator-12-80",
    },
    0x14: {
        0x01: "indicator-14-01",
        0x02: "indicator-14-02",
        0x04: "indicator-14-04",
        0x08: "indicator-14-08",
        0x10: "id-strap-drive-c",  # driven low at 0x5c015
        0x20: "id-strap-drive-d",  # driven low at 0x5c03d
        0x40: "id-strap-drive-a",  # driven low at 0x5bfed
        0x80: "indicator-14-80",
    },
}

# Both latch entry points special-case AX == 0x0408 and AX == [0x065c]: the set
# path at 0x5e2b4 jumps into the clear body for them and the clear path at
# 0x5e2e9 jumps into the set body. Signal 0x0408 is board latch 0 bit 0x04, so
# the hook line is asserted by driving its latch bit low. Bit 0x01 is raised for
# exactly the same window (0x5db4e on seizure, 0x5e197 on release), so it is
# reported as the paired off-hook indication rather than a second relay.
ACTIVE_LOW: frozenset[tuple[int, int]] = frozenset({(0x10, 0x04)})

INPUT_BITS: dict[int, dict[int, str]] = {
    0x10: {
        0x08: "nvram-ready",  # polled at 0x5cde1 before every NVRAM transfer
        0x10: "nvram-data-out",
        0x80: "board-option-80",  # sampled at 0x5c029 into flag byte 0x017a
    },
    0x14: {
        0x02: "ring-detect",  # sampled at 0x70fb4 and 0x70fc1 by the answer machine
        0x08: "id-strap-sense",  # common return of the 0x5bfc6 strap scan
    },
}


# The board identifies itself at 0x5bfc6 by driving four latch lines low one at
# a time and sampling a common sense line, shifting each sample into a four-bit
# code with `rcl bx,1`. The order below is the order the scan shifts them in.
STRAP_DRIVE_LINES: tuple[tuple[int, int, int], ...] = (
    (0x14, 0x40, 3),  # cleared at 0x5bfed
    (0x12, 0x02, 2),  # cleared at 0x5c001
    (0x14, 0x10, 1),  # cleared at 0x5c015
    (0x14, 0x20, 0),  # cleared at 0x5c03d
)
STRAP_SENSE_PORT = 0x14
STRAP_SENSE_BIT = 0x08

# 0x5c051 indexes the table at 0x5c06b with that code and 0x5c05c stores the
# result as the board capability byte at 0x0a02. A zero entry means "no board":
# 0x5c064 stores zero and the scan reports failure.
BOARD_CAPABILITY: tuple[int, ...] = (
    0x00, 0x00, 0x29, 0x00, 0x00, 0x14, 0x00, 0x22,
    0x00, 0x28, 0x00, 0x42, 0x28, 0x22, 0x48, 0x00,
)

# Capability bit 0x40 sends 0x5bb0f straight to the fatal blinker, so codes 11
# and 14 describe a board this firmware refuses to run on.
USABLE_BOARD_IDS: tuple[int, ...] = tuple(
    code
    for code, capability in enumerate(BOARD_CAPABILITY)
    if capability and not capability & 0x40
)

# Bit 0x08 is the "settings EEPROM fitted" bit every NVRAM path tests, which
# narrows a Courier with NVRAM to codes 2, 9, and 12. Which of those a given
# board revision actually straps is not established from the image alone, so
# the lowest is the default and `--board-id` selects another.
NVRAM_BOARD_IDS: tuple[int, ...] = tuple(
    code for code in USABLE_BOARD_IDS if BOARD_CAPABILITY[code] & 0x08
)
DEFAULT_BOARD_ID = NVRAM_BOARD_IDS[0]


def _names(port: int, value: int, table: dict[int, dict[int, str]]) -> list[str]:
    bits = table.get(port, {})
    return [name for mask, name in sorted(bits.items()) if value & mask]


def _asserted(port: int, mask: int, value: int) -> bool:
    level = bool(value & mask)
    return not level if (port, mask) in ACTIVE_LOW else level


@dataclass
class PanelEvent:
    instruction: int
    port: int
    value: int
    changed: int
    pc: int
    initial: bool = False

    def describe(self) -> str:
        if self.initial:
            return (
                f"i={self.instruction} port={self.port:#04x} value={self.value:#04x} "
                f"pc={self.pc:#07x} initial"
            )
        # Report the assertion of each signal, not the raw latch level, so the
        # inverted hook line reads the same way as every other line.
        bits = OUTPUT_BITS.get(self.port, {})
        parts = [
            ("+" if _asserted(self.port, mask, self.value) else "-") + name
            for mask, name in sorted(bits.items())
            if self.changed & mask
        ]
        return (
            f"i={self.instruction} port={self.port:#04x} value={self.value:#04x} "
            f"pc={self.pc:#07x} {' '.join(parts)}".rstrip()
        )


@dataclass
class CourierPanel:
    """Observable state of the board control latches and front-panel drivers."""

    latches: dict[int, int] = field(default_factory=dict)
    writes: dict[int, int] = field(default_factory=dict)
    events: list[PanelEvent] = field(default_factory=list)
    truncated: bool = False
    board_id: int | None = None

    def __post_init__(self) -> None:
        if self.board_id is not None and not 0 <= self.board_id <= 15:
            raise ValueError(f"board id {self.board_id} is outside the four-bit strap range")

    @property
    def board_capability(self) -> int | None:
        """The byte 0x5c05c would store at 0x0a02 for the configured straps."""
        if self.board_id is None:
            return None
        return BOARD_CAPABILITY[self.board_id]

    def strap_sense(self) -> bool:
        """Return the level the identification sense line presents right now.

        The scan holds every drive line high and pulls exactly one low, so the
        line reports that strap's bit. With no line pulled low it idles high,
        which is also what 0x5bfe8 requires before the scan will proceed.
        """
        if self.board_id is None:
            return True
        for port, mask, index in STRAP_DRIVE_LINES:
            if not self.latches.get(port, 0xFF) & mask:
                return bool((self.board_id >> index) & 1)
        return True

    def observe_write(self, port: int, value: int, pc: int, instruction: int) -> None:
        if port not in PANEL_PORTS:
            return
        value &= 0xFF
        previous = self.latches.get(port)
        self.latches[port] = value
        self.writes[port] = self.writes.get(port, 0) + 1
        changed = 0xFF if previous is None else previous ^ value
        if not changed:
            return
        if len(self.events) < MAX_PANEL_EVENTS:
            self.events.append(
                PanelEvent(instruction, port, value, changed, pc, initial=previous is None)
            )
        else:
            self.truncated = True

    def signals(self) -> dict[str, bool]:
        """Return the asserted state of every named output line."""
        state: dict[str, bool] = {}
        for port, bits in OUTPUT_BITS.items():
            value = self.latches.get(port)
            if value is None:
                continue
            for mask, name in sorted(bits.items()):
                level = bool(value & mask)
                state[name] = not level if (port, mask) in ACTIVE_LOW else level
        return state

    @property
    def off_hook(self) -> bool:
        return self.signals().get("hook-relay", False)

    def status(self) -> dict[str, Any]:
        return {
            "latches": {f"{port:#04x}": value for port, value in sorted(self.latches.items())},
            "writes": {f"{port:#04x}": count for port, count in sorted(self.writes.items())},
            "signals": self.signals(),
            "off_hook": self.off_hook,
            "board_id": self.board_id,
            "board_capability": self.board_capability,
            "events": [event.describe() for event in self.events],
            "events_truncated": self.truncated,
        }
