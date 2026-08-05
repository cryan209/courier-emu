"""A live byte channel between the modelled DTE and an attached terminal.

The batch `--at` and `--serial-input` options queue every byte before the
firmware boots. A console instead carries bytes in both directions while the
run continues, which is what lets a terminal - or any program that speaks to a
modem - hold a real command-mode conversation with the firmware.

The machine owns one of these and touches it in two places: it writes each
captured transmit byte out, and it polls for input every few thousand
instructions and appends what arrives to the receive queue.
"""

from __future__ import annotations

import errno
import os

# The firmware runs at roughly a million instructions a second, so this polls
# the terminal about a hundred times a second: far below the cost of the
# instruction hook itself, and far above what a typist can notice.
DEFAULT_POLL_INSTRUCTIONS = 8192

# A terminal that stops reading must not stall the emulation or grow without
# bound; past this the console drops the oldest unsent output.
MAX_PENDING_OUTPUT = 64 * 1024


class SerialConsole:
    """Non-blocking byte transport over an inherited file descriptor."""

    def __init__(self, fd: int, *, poll_instructions: int = DEFAULT_POLL_INSTRUCTIONS) -> None:
        self.fd = fd
        self.poll_instructions = poll_instructions
        self.received = 0
        self.sent = 0
        self.dropped = 0
        self.closed = False
        self._pending = bytearray()
        os.set_blocking(fd, False)

    def poll(self) -> bytes:
        """Return whatever the terminal has typed since the last call."""
        self._drain()
        if self.closed:
            return b""
        try:
            data = os.read(self.fd, 4096)
        except BlockingIOError:
            return b""
        except OSError as exc:
            # A pty master reports the far end closing as EIO rather than EOF.
            if exc.errno in (errno.EIO, errno.EBADF):
                self.closed = True
                return b""
            raise
        if not data:
            self.closed = True
            return b""
        self.received += len(data)
        return data

    def write(self, value: int) -> None:
        """Queue one transmitted byte for the terminal."""
        self._pending.append(value & 0xFF)
        if len(self._pending) > MAX_PENDING_OUTPUT:
            excess = len(self._pending) - MAX_PENDING_OUTPUT
            del self._pending[:excess]
            self.dropped += excess
        self._drain()

    def _drain(self) -> None:
        while self._pending and not self.closed:
            try:
                written = os.write(self.fd, self._pending)
            except BlockingIOError:
                return
            except OSError as exc:
                if exc.errno in (errno.EIO, errno.EPIPE, errno.EBADF):
                    self.closed = True
                    return
                raise
            if not written:
                return
            del self._pending[:written]
            self.sent += written

    def close(self) -> None:
        self._drain()
        self.closed = True
        try:
            os.close(self.fd)
        except OSError:
            pass

    def summary(self) -> dict[str, int | bool]:
        return {
            "received": self.received,
            "sent": self.sent,
            "dropped": self.dropped,
            "pending": len(self._pending),
            "closed": self.closed,
        }
