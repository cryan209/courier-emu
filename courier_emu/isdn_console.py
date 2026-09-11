"""Typing at the I-modem's command interface.

SIO0 is the AT port (see courier_emu/sio.py).  Both drivers here are the same
shape: a callback the harness invokes from `poll_timers`, which queues
whatever the host has to say and takes whatever the firmware has said back.

Two things about the timing are worth knowing before reading a transcript.
The firmware needs a warm-up - the command task is created late in the VRTX
startup, and anything typed before it exists is discarded.  And characters
have to arrive spaced out: delivered as one burst, a line reaches the parser
differently and some commands do not answer at all.

The firmware does *not* swallow the first line it is given.  A session whose
only command is `ATI3` gets the banner, and one that opens with `AT` gets an
answer to that `AT` as well; what made it look otherwise is that a bare `AT`
answers `NO CARRIER` rather than `OK`, which reads like a lost line when the
transcript starts with a throwaway.  See docs/imodem-at-interface.md.

The link is 7E1, and the firmware generates the parity bit itself rather than
asking the part for it - see `even_parity` in courier_emu/sio.py for why a
transmitter programmed 8N1 emits exactly that frame.  So a terminal on the
other end is a 7E1 terminal, and `_on_the_wire` makes this one behave like
one.

The firmware masks the parity bit on receive rather than checking it, so what
this sends in is not load-bearing: a line sent with parity and a line sent
without it produce identical answers.  It is here because it is what the DTE
at the other end puts on the wire, not because anything depends on it.
"""

from __future__ import annotations

import os
import select
import sys
import time
from typing import Any, Callable, Iterable

from .pit import INSTRUCTIONS_PER_SECOND
from .sio import even_parity

# Long enough for the kernel to create and first-run the command task; the
# nine-task startup completes a little before 3M instructions.
SERIAL_WARMUP_INSTRUCTIONS = 5_000_000
# Long enough for a command to be parsed and its result code transmitted.
SERIAL_LINE_INSTRUCTIONS = 20_000_000

# Ctrl-], as in telnet.
DETACH_BYTE = 0x1D

_ESCAPES = {"r": "\r", "n": "\n", "t": "\t", "0": "\0", "\\": "\\"}


def unescape(text: str) -> str:
    """Expand the backslash escapes a shell would otherwise eat."""
    out: list[str] = []
    index = 0
    while index < len(text):
        character = text[index]
        if character == "\\" and index + 1 < len(text):
            replacement = _ESCAPES.get(text[index + 1])
            if replacement is not None:
                out.append(replacement)
                index += 2
                continue
        out.append(character)
        index += 1
    return "".join(out)


def command_line(text: str) -> str:
    """A line as the parser wants it: escapes expanded, terminated by CR."""
    expanded = unescape(text)
    if expanded.endswith(("\r", "\n")):
        return expanded
    return expanded + "\r"


def scripted_pump(
    lines: Iterable[str],
    *,
    after: int = SERIAL_WARMUP_INSTRUCTIONS,
    every: int = SERIAL_LINE_INSTRUCTIONS,
    transcript: list[tuple[int, str, str]] | None = None,
) -> Callable[[Any], None]:
    """Type `lines` on SIO0, one every `every` instructions.

    `transcript` collects `(instructions, "sent"|"received", text)` in order,
    so a run's report can show the session rather than just the final stream.
    """
    schedule = [
        (after + index * every, command_line(line))
        for index, line in enumerate(lines)
    ]
    schedule.reverse()
    log = transcript if transcript is not None else []

    def pump(machine: Any) -> None:
        while schedule and machine.instructions >= schedule[-1][0]:
            _, line = schedule.pop()
            machine.send_serial(_on_the_wire(line))
            log.append((machine.instructions, "sent", line))
        received = machine.take_serial()
        if received:
            log.append((machine.instructions, "received", _readable(received)))

    return pump


def _readable(data: bytes) -> str:
    """Drop the parity bit before decoding.

    Bit 7 of what the firmware transmits is even parity over the low seven,
    computed in software on a part it has programmed for eight data bits and
    none: over a full banner-and-result-code stream, 73 bytes of 73 agree, and
    ATI4 describes the link the same way - ``PARITY=E WORDLEN=7``. A terminal
    set the matching way never sees it.
    """
    return bytes(byte & 0x7F for byte in data).decode("ascii", "replace")


def _on_the_wire(text: str | bytes) -> bytes:
    """What a 7E1 terminal puts on the line for this text."""
    data = text.encode("ascii", "replace") if isinstance(text, str) else bytes(text)
    return bytes(even_parity(byte) for byte in data)


def interactive_pump(
    *,
    after: int = SERIAL_WARMUP_INSTRUCTIONS,
    input_stream: Any = None,
    output_stream: Any = None,
) -> Callable[[Any], None]:
    """Hand this terminal to SIO0 until Ctrl-] is typed.

    Raw mode is the caller's business (`raw_terminal` below); this only moves
    bytes, so it works just as well against a pipe.  Input is left unread
    until `after`, which is what makes a piped script behave the same as a
    person: everything typed before the command task exists is discarded by
    the firmware, and a pipe delivers its whole script in the first
    millisecond.
    """
    source = input_stream if input_stream is not None else sys.stdin
    sink = output_stream if output_stream is not None else sys.stdout
    detached = [False]
    clock_origin: list[tuple[int, float] | None] = [None]
    next_clock_sync = [after]

    def pump(machine: Any) -> None:
        received = machine.take_serial()
        if received:
            sink.write(_readable(received))
            sink.flush()
        if detached[0] or machine.instructions < after:
            return
        if clock_origin[0] is None:
            clock_origin[0] = (machine.instructions, time.monotonic())
        if machine.instructions >= next_clock_sync[0]:
            guest_start, wall_start = clock_origin[0]
            guest_seconds = (
                machine.instructions - guest_start
            ) / INSTRUCTIONS_PER_SECOND
            delay = wall_start + guest_seconds - time.monotonic()
            if delay > 0:
                time.sleep(delay)
            next_clock_sync[0] = machine.instructions + INSTRUCTIONS_PER_SECOND // 100
        try:
            ready, _, _ = select.select([source], [], [], 0)
        except (OSError, ValueError):  # pragma: no cover - closed stream
            detached[0] = True
            return
        if not ready:
            return
        data = os.read(source.fileno(), 256)
        if not data:
            detached[0] = True
            return
        if DETACH_BYTE in data:
            data = data[: data.index(DETACH_BYTE)]
            detached[0] = True
        if data:
            # A terminal sends CR for Return; the parser wants exactly that.
            data = data.replace(b"\n", b"\r")
            machine.send_serial(_on_the_wire(data))
        if detached[0]:
            machine.stop("detached")

    return pump


class raw_terminal:
    """Put the controlling terminal in raw mode for the length of a session.

    A no-op when stdin is not a tty, so piping a script in still works.
    """

    def __init__(self, stream: Any = None) -> None:
        self.stream = stream if stream is not None else sys.stdin
        self.saved: Any = None

    def __enter__(self) -> "raw_terminal":
        try:
            import termios
            import tty
        except ImportError:  # pragma: no cover - not a POSIX host
            return self
        if not self.stream.isatty():
            return self
        self.saved = termios.tcgetattr(self.stream)
        tty.setraw(self.stream.fileno())
        return self

    def __exit__(self, *_exception: Any) -> None:
        if self.saved is None:
            return
        import termios

        termios.tcsetattr(self.stream, termios.TCSADRAIN, self.saved)
