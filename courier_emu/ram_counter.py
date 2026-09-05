"""A counter routine in the modem's RAM, hooked onto the firmware's own tick.

The smallest thing that proves the RAM-probe method end to end: place a routine
in RAM, get the firmware to execute it, and read the result back. It increments
a word and chains to the real handler. Nothing else.

## Why the hook is a single write

The tick is interrupt vector `0x0f` - `TICK_VECTOR` in `machine.py`, and the
board's own vector points at `8000:0a77`, which disassembles to a real handler
(`sti ; cld ; pushaw ; push es ; ... ; dec word [0x130]`, the supervisor's
countdown chain). Vector `08` is not a candidate: it points at `8000:108f`,
which decodes as data, so timer 0 is unused here.

A far vector is four bytes and the monitor writes at most two, so the obvious
approach - write the offset, then the segment - leaves the tick pointing
somewhere wrong for one command round trip, about 165 ms, which is 33 ticks. A
stub that returns without acknowledging the interrupt controller would very
likely wedge the tick, and the test would be inconclusive *and* need a reset.

There is no need for any of that. **Only the segment has to change.** If the
routine sits at `(segment << 4) + 0x0a77`, the offset word is already correct
and the hook is one atomic word write:

    8000:0a77   ->   0300:0a77
    physical 80a77   physical 3a77

`0x3a77` is in the large free block, and the modem is never left holding a
half-updated pointer - before the write it runs the firmware's handler, after
it runs ours, and there is no state in between. Unhooking is the same write in
reverse.

The 12 bytes at RAM `0x0a77` were the alternative and are not usable: the AT
command buffer starts at `0x0a83` - the fax parser's `mov [bx+0xa83], al` at
`0x9c22` writes it, and a live read shows this session's own command sitting
there - so a 19-byte routine at `0x0a77` would overwrite the monitor's input.

## What the routine may and may not do

It never touches ports `0x10`, `0x12` or `0x14`, which carry the hook relay,
the NVRAM strobe and the carrier-detect pair, and it issues no flash command.
Everything it writes is RAM, and the vector it changes is RAM, so a power cycle
restores the board completely whatever happens.
"""
from __future__ import annotations

# Interrupt vector 0x0f, and where its four bytes live in the table at zero.
TICK_VECTOR = 0x0F
VECTOR_OFFSET_CELL = TICK_VECTOR * 4          # 0x3c, holds 0x0a77
VECTOR_SEGMENT_CELL = TICK_VECTOR * 4 + 2     # 0x3e, holds 0x8000

ORIGINAL_SEGMENT = 0x8000
ORIGINAL_OFFSET = 0x0A77
# The one value the hook writes. 0x0300 << 4 keeps the offset valid at 0x3a77.
HOOK_SEGMENT = 0x0300

ROUTINE_BASE = (HOOK_SEGMENT << 4) + ORIGINAL_OFFSET   # 0x3a77
COUNTER = 0x3B00


def routine(counter: int = COUNTER) -> bytes:
    """The 19 bytes placed at `ROUTINE_BASE`.

    `DS` is forced to zero rather than assumed. The real handler does rely on
    the firmware's own invariant - it reads `[0x130]` with no segment setup -
    but this runs before it, in whatever context the interrupt landed in, so it
    establishes its own addressing and puts everything back.

    `pushf`/`popf` bracket the increment because `inc` writes flags. The
    interrupted code's flags are already safe on the stack, pushed by the CPU;
    this keeps the *handler* from being entered with flags it did not expect.
    """
    return bytes((
        0x50,                                   # push ax
        0x9C,                                   # pushf
        0x1E,                                   # push ds
        0x31, 0xC0,                             # xor ax, ax
        0x8E, 0xD8,                             # mov ds, ax
        0xFF, 0x06, counter & 0xFF, counter >> 8,   # inc word [counter]
        0x1F,                                   # pop ds
        0x9D,                                   # popf
        0x58,                                   # pop ax
        # Chain to the firmware's own handler, which does the real work and the
        # interrupt acknowledgement. The stack still holds the CPU's frame, so
        # it is entered exactly as if it had been reached directly.
        0xEA, ORIGINAL_OFFSET & 0xFF, ORIGINAL_OFFSET >> 8,
        ORIGINAL_SEGMENT & 0xFF, ORIGINAL_SEGMENT >> 8,   # jmp far 8000:0a77
    ))


def write_byte(address: int, value: int) -> str:
    """One byte. Two hex digits is what makes the monitor choose a byte store."""
    return f"ATGLK2W{address:X},{value:02X}"


def write_word(address: int, value: int) -> str:
    """One word. Four hex digits is what makes it choose a word store."""
    return f"ATGLK2W{address:X},{value:04X}"


def place_commands(counter: int = COUNTER) -> list[str]:
    """Every command that puts the routine and a zeroed counter in RAM."""
    code = routine(counter)
    commands = [write_byte(ROUTINE_BASE + i, b) for i, b in enumerate(code)]
    commands.append(write_word(counter, 0x0000))
    return commands


def arm_command() -> str:
    """The single atomic write that switches the tick onto the routine."""
    return write_word(VECTOR_SEGMENT_CELL, HOOK_SEGMENT)


def disarm_command() -> str:
    """The single atomic write that gives the tick back to the firmware."""
    return write_word(VECTOR_SEGMENT_CELL, ORIGINAL_SEGMENT)


def plan(counter: int = COUNTER) -> str:
    code = routine(counter)
    lines = [
        f"routine   {len(code)} bytes at {ROUTINE_BASE:05x}..{ROUTINE_BASE+len(code)-1:05x}",
        f"counter   word at {counter:05x}",
        f"hook      vector {TICK_VECTOR:02x} segment cell {VECTOR_SEGMENT_CELL:02x}: "
        f"{ORIGINAL_SEGMENT:04x} -> {HOOK_SEGMENT:04x}  (offset {ORIGINAL_OFFSET:04x} unchanged)",
        "",
        "  " + " ".join(f"{b:02X}" for b in code),
        "",
        "    push ax / pushf / push ds",
        "    xor ax,ax ; mov ds,ax",
        f"    inc word [{counter:04x}]",
        "    pop ds / popf / pop ax",
        f"    jmp far {ORIGINAL_SEGMENT:04x}:{ORIGINAL_OFFSET:04x}",
        "",
        f"arm       {arm_command()}",
        f"disarm    {disarm_command()}",
    ]
    return "\n".join(lines)


if __name__ == "__main__":
    print(plan())
