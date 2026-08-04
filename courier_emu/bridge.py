from __future__ import annotations

from collections import Counter
from dataclasses import dataclass

from .dsp import NativeC5x
from .xmf import DSP_BOOT_SIZE, XmfImage


DSP_COMMAND_PORT = 0x1E
DSP_WINDOW_FIRST = 0x40
DSP_WINDOW_LAST = 0x4E
DSP_WINDOW_STRIDE = 2


@dataclass
class BridgeStatus:
    active: bool
    bootstrap_bytes: int
    bootstrap_match: bool | None
    bootstraps: int
    transfer_commands: int
    mailbox_commands: int
    mailbox_windows: dict[str, int]
    error: str | None
    dsp: dict[str, int | bool]
    serial_port: dict[str, int]
    dial_digits: str


class CourierDspBridge:
    """Courier host-port window plus a batched 80186/C52 clock scheduler."""

    def __init__(
        self,
        image: XmfImage,
        *,
        batch: int = 256,
        rx_samples: list[int] | None = None,
    ) -> None:
        self.image = image
        self.expected_bootstrap = image.dsp_program_segments()[0][1]
        self.core = NativeC5x(image)
        self.batch = batch
        self.window = bytearray(b"\xff" * 8)
        self.bootstrap = bytearray()
        self.active = False
        self.bootstrap_match: bool | None = None
        self.bootstraps = 0
        self.transfer_commands = 0
        self.mailbox_commands = 0
        self.mailbox_windows: Counter[str] = Counter()
        self.error: str | None = None
        self._x86_ticks = 0
        self.rx_samples = list(rx_samples or [])
        self._rx_samples_queued = False
        self.dial_digits = ""

    def arm_dial_tones(self, command: bytes) -> None:
        text = command.decode("ascii", "ignore").upper()
        marker = text.find("D")
        if marker < 0:
            return
        dial = text[marker + 1 :]
        if dial.startswith(("T", "P")):
            dial = dial[1:]
        self.dial_digits = "".join(ch for ch in dial if ch in "0123456789*#ABCD")
        if self.bootstraps >= 2 and self.dial_digits:
            self.core.set_dtmf_digits(self.dial_digits)

    @staticmethod
    def handles(port: int) -> bool:
        return port == DSP_COMMAND_PORT or (
            DSP_WINDOW_FIRST <= port <= DSP_WINDOW_LAST
            and (port - DSP_WINDOW_FIRST) % DSP_WINDOW_STRIDE == 0
        )

    def write(self, port: int, size: int, value: int) -> None:
        if DSP_WINDOW_FIRST <= port <= DSP_WINDOW_LAST:
            lane = (port - DSP_WINDOW_FIRST) // DSP_WINDOW_STRIDE
            if 0 <= lane < len(self.window):
                self.window[lane] = value & 0xFF
            return
        if port != DSP_COMMAND_PORT or size != 1 or (value & 0xFF) != 1:
            return
        if self.active and bytes(self.window) == self.expected_bootstrap[:8]:
            # The supervisor re-enters its DSP download routine for a line
            # operation. Recognize the program's first transfer window; port
            # 0x1c also carries ordinary handshakes and is not a reset signal
            # by itself.
            self.core.close()
            self.core = NativeC5x(self.image)
            self.bootstrap = bytearray(self.window)
            self.bootstrap_match = None
            self.active = False
            self._x86_ticks = 0
            self.transfer_commands += 1
            return
        if not self.active:
            self.transfer_commands += 1
            self.bootstrap.extend(self.window)
            if len(self.bootstrap) >= DSP_BOOT_SIZE:
                self.bootstrap_match = self.bootstrap[:DSP_BOOT_SIZE] == self.expected_bootstrap
                self.active = True
                self.bootstraps += 1
                self._publish_window()
                # Feed a supplied ASIC line recording only after the
                # supervisor's second bootstrap, the dial/answer boundary.
                if self.bootstraps >= 2 and self.rx_samples and not self._rx_samples_queued:
                    self.core.queue_serial_rx(self.rx_samples)
                    self._rx_samples_queued = True
                if self.bootstraps >= 2 and self.dial_digits:
                    self.core.set_dtmf_digits(self.dial_digits)
        else:
            self.mailbox_commands += 1
            self.mailbox_windows[self.window.hex()] += 1
            self._publish_window()

    def read(self, port: int, size: int) -> int | None:
        if port == DSP_COMMAND_PORT:
            return (1 << (size * 8)) - 1
        if not self.active or not self.handles(port):
            return None
        lane = (port - DSP_WINDOW_FIRST) // DSP_WINDOW_STRIDE
        word = self.core.io(0x50 + lane // 2)
        return (word >> (8 * (lane & 1))) & 0xFF

    def _publish_window(self) -> None:
        for index in range(0, len(self.window), 2):
            word = self.window[index] | (self.window[index + 1] << 8)
            self.core.set_io(0x50 + index // 2, word)

    def clock_x86(self) -> None:
        if not self.active or self.error:
            return
        self._x86_ticks += 1
        if self._x86_ticks < self.batch:
            return
        # The Courier identifies its split as 20 MHz 80186 / 25 MHz C52.
        dsp_steps = self._x86_ticks * 5 // 4
        self._x86_ticks = 0
        try:
            self.core.step(dsp_steps)
        except RuntimeError as exc:
            self.error = str(exc)

    def status(self) -> BridgeStatus:
        return BridgeStatus(
            active=self.active,
            bootstrap_bytes=len(self.bootstrap),
            bootstrap_match=self.bootstrap_match,
            bootstraps=self.bootstraps,
            transfer_commands=self.transfer_commands,
            mailbox_commands=self.mailbox_commands,
            mailbox_windows=dict(self.mailbox_windows.most_common()),
            error=self.error,
            dsp=self.core.state(),
            serial_port=self.core.serial_state(),
            dial_digits=self.dial_digits,
        )

    def save_tx_pcm(self, path: str) -> int:
        samples = self.core.line_tx_samples()
        with open(path, "wb") as output:
            for sample in samples:
                output.write(int(sample).to_bytes(2, "little", signed=True))
        return len(samples)

    def close(self) -> None:
        self.core.close()
