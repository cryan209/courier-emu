"""The firmware's own ISDN trace log, and how to read it back.

The I-modem's ISDN stack is instrumented.  Not with numbers - with **English**:
there is a printer at `0x77fc2` that the stack calls with a string, and the
strings are symbolic to the point of naming the developers' own primitives.

    l4_SETUP : modem primitive
    l4_DISCONN : modem primitive
    LINE_ACTIVE Detected
    N202 Cnt Exceeded - no TEI assigned!!!
    TEI ASSIGN msg received with TEI that had already been assigned

465 of them sit in the block the initialiser relocates from image `0x98d50`
down to `0x0ce00` - which is why every other address in this stack is quoted
against segment `ce0`.

## The ring

`0x77fc2` packs the characters two to a word into a ring at `ds:0xa79a`, with
the count of words used at `ds:0xb79a`, `ds` being that same `ce0`.  It is a
fill-once log, not a wrap-around one: the guards at `0x78039` and `0x78051`
compare the index against `0x7fd` and `0x7ef` and stop appending, which is why
a long run's log simply ends rather than losing its beginning.  Capacity is
`(0xb79a - 0xa79a) / 2` = 2048 words, and each entry is terminated with a
CRLF the printer appends itself.

Because the characters are packed low byte first, the ring read as raw bytes
*is* the text - no unpacking needed.  A trailing odd character is padded with
a space, from the `or ax, 0x2000` at `0x77ff6`.

## Why this matters

Everything else in this repository about the ISDN stack was recovered by
disassembly and inference.  This is the firmware describing its own behaviour
in the words the people who wrote it chose, and it costs two memory reads at
the end of a run.  `ATD` answering `NO CARRIER` stops being a mystery the
moment you read it:

    LINE_ACTIVE Detected
    l4_DISCONN : modem primitive

- the dial did reach layer 3, and arrived there as a *disconnect*.
"""
from __future__ import annotations

from typing import Any


# The relocated data segment every address in this stack is quoted against.
TRACE_SEGMENT = 0x0CE0
# The ring, and the count of words written into it.
TRACE_RING = 0xA79A
TRACE_INDEX = 0xB79A
TRACE_WORDS = (TRACE_INDEX - TRACE_RING) // 2


def ring_address(segment: int = TRACE_SEGMENT) -> int:
    return segment * 16 + TRACE_RING


def index_address(segment: int = TRACE_SEGMENT) -> int:
    return segment * 16 + TRACE_INDEX


def decode(raw: bytes) -> list[str]:
    """Split the ring's text into the lines the printer terminated."""
    text = raw.decode("ascii", "replace")
    return [line.rstrip() for line in text.replace("\r\n", "\n").split("\n")
            if line.strip()]


def read(machine: Any, segment: int = TRACE_SEGMENT) -> list[str]:
    """Read the log out of a run that has finished.

    Returns an empty list when the ring holds nothing, or when the index is
    outside the ring - which is the honest answer if the segment is wrong,
    rather than decoding whatever happens to be at that address.
    """
    uc = getattr(machine, "machine", None)
    if uc is None:
        return []
    try:
        used = int.from_bytes(uc.mem_read(index_address(segment), 2), "little")
    except Exception:
        return []
    if not 0 < used <= TRACE_WORDS:
        return []
    raw = bytes(uc.mem_read(ring_address(segment), used * 2))
    return decode(raw)
