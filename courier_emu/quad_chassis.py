"""Run the Quad's controller and one modem channel by taking turns.

The two processors share the channel's memory. The controller reaches it
through the aperture `QuadBoard` maps at `0x40000`; the modem sees the same
bytes at `0x00000`. Measurement of the controller's aperture traffic
(docs/quad-bringup-blockers.md) found the only targeted write to be a slot
identity at offset `0xbae1`, which the card reads at `0xf64ec` and reports back
as parameter `0x00f3` - a request/response exchange, not two processors needing
to run at the same instant.

So this is turn-taking rather than lock-step: run one side, move the channel
memory, run the other, move it back. Each machine yields by snapshotting its
processor state and resumes into a freshly built Uc from that snapshot, so
interrupt delivery and the modem's STI/HLT scheduler keep working across a turn
- which driving `emu_start` directly would break.

What this does not do is model arbitration. Nothing here decides who may touch
the channel when; the schedule is fixed by the caller. On the board both parts
address that memory whenever they like, and the chip selects at `0xff88`/`0xff94`
are what resolve it. Runs where both sides write the same bytes in one turn are
therefore not modelled faithfully, and this harness cannot be used to argue
about races.
"""
from __future__ import annotations

from dataclasses import dataclass, field
from pathlib import Path
from typing import Any

from .machine import CourierMachine
from .quad_board import WINDOW_BASE, WINDOW_SIZE, QuadBoard
from .quad_image import QuadImage

CHANNEL_MEMORY = WINDOW_SIZE


@dataclass
class QuadChassis:
    """A controller and one modem channel, sharing that channel's memory."""

    archive: Path
    channel: int = 0
    controller_slice: int = 250_000
    modem_slice: int = 250_000

    board: QuadBoard = field(default_factory=QuadBoard)
    controller: CourierMachine | None = None
    modem: CourierMachine | None = None
    turns: int = 0
    controller_instructions: int = 0
    modem_instructions: int = 0
    _controller_state: dict[str, Any] | None = None
    _modem_state: dict[str, Any] | None = None
    _channel: bytes = b""
    _modem_flash: bytes = b""

    # -- the shared surface ----------------------------------------------
    def _take_channel_from_controller(self) -> None:
        """The controller's aperture is the channel's memory; keep a copy."""
        self.board.flush()
        self._channel = bytes(self.board.ram[self.channel])

    def _give_channel_to_modem(self) -> bytes:
        return self._channel

    def _take_channel_from_modem(self) -> None:
        self._channel = bytes(self.modem.uc.mem_read(0, CHANNEL_MEMORY))

    def _give_channel_to_controller(self) -> None:
        self.board.ram[self.channel][:] = self._channel
        # Force the aperture to be repainted from the bank on the next select.
        self.board._mapped = None

    # -- turns -------------------------------------------------------------
    def run_controller(self) -> str:
        if self.controller is None:
            self.controller = CourierMachine(
                QuadImage.controller(self.archive), quad_board=self.board)
        else:
            self._give_channel_to_controller()
            self.controller.resume_from(self._controller_state)
        limit = self.controller.instructions + self.controller_slice
        result = self.controller.run(limit)
        self._controller_state = self.controller.snapshot()
        self.controller_instructions = self.controller.instructions
        self._take_channel_from_controller()
        if not self._modem_flash:
            self._modem_flash = bytes(self.board.flash[self.channel])
        return result.status

    def run_modem(self, **kwargs: Any) -> str:
        if not self._modem_flash:
            raise RuntimeError("run the controller first; it loads the channel")
        image = QuadImage.modem(self._modem_flash, self._give_channel_to_modem())
        if self.modem is None:
            self.modem = CourierMachine(image, **kwargs)
        else:
            # A fresh image carries the channel memory the controller just
            # handed back; the processor state comes from the snapshot.
            self.modem.image = image
            self.modem.resume_from(self._modem_state)
        limit = self.modem.instructions + self.modem_slice
        result = self.modem.run(limit)
        self._modem_state = self.modem.snapshot()
        self.modem_instructions = self.modem.instructions
        self._take_channel_from_modem()
        return result.status

    def turn(self, **modem_kwargs: Any) -> tuple[str, str]:
        controller = self.run_controller()
        modem = self.run_modem(**modem_kwargs)
        self.turns += 1
        return controller, modem

    def channel_byte(self, offset: int) -> int:
        """One byte of the channel memory as it stands between turns."""
        return self._channel[offset] if self._channel else 0

    def status(self) -> dict[str, Any]:
        return {
            "turns": self.turns,
            "controller_instructions": self.controller_instructions,
            "modem_instructions": self.modem_instructions,
            "channel": self.channel,
            "selection": self.board.selection,
            "window_changes": self.board.window_changes,
            "slot_identity_0xbae1": self.channel_byte(0xBAE1),
        }
