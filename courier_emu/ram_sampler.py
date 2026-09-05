"""Sample ASIC ports at the tick rate from inside the modem.

The serial monitor cannot sample fast. Every port read is a command round trip
and the board's reply latency is about 165 ms, so a sweep of the interesting
ports takes seconds and any event shorter than that is invisible - which is why
the reset sweep in [asic-port-map.md] saw nothing at all.

This runs on the 80186 instead. It reuses the counter routine's hook exactly:
the tick vector's *segment* word is the only thing written, so the offset stays
`0x0a77`, the routine lives at `0x3a77`, and the board never holds a
half-updated far pointer. Each tick it reads a fixed list of ports, appends
them to a ring buffer in RAM, and chains to the firmware's handler. At 200 ticks
a second that is a sample every 5 ms.

## The ports it may read

Unlike the counter, this routine contains `IN` opcodes, so the property that
made that one trivially safe - no port access at all - no longer holds. The
replacement is an explicit allowlist: `0x10`, `0x12` and `0x14` are refused,
because they carry the hook relay, the NVRAM strobe and the carrier-detect
pair. Reading a latch is not what damages anything, but the routine has no
business near them and the check is cheap.

Reads are not always free even so. The mailbox data registers at `0x5c`/`0x5e`
are how the supervisor collects a reply, so sampling them 200 times a second
will race the firmware for its own messages. `0x1c` and `0x1e` are the status
pair, and reading status is what the supervisor's interrupt does anyway. Sample
the data registers only deliberately.
"""
from __future__ import annotations

from .ram_counter import (ORIGINAL_OFFSET, ORIGINAL_SEGMENT, HOOK_SEGMENT,
                          ROUTINE_BASE, VECTOR_SEGMENT_CELL, TICK_VECTOR,
                          arm_command, disarm_command, write_byte, write_word)

# Not sampled by default: hook relay, NVRAM strobe, carrier-detect pair.
# Reading a latch is what the firmware's own panel code does, so it is not
# itself dangerous; `allow_latches` exists so that including them is a
# deliberate choice rather than an oversight.
FORBIDDEN_PORTS = (0x10, 0x12, 0x14)
# Every even port in the decoded space. The odd halves read zero - the ASIC
# presents 16-bit registers and `IN AL` reads a byte - so they carry nothing.
EVEN_PORTS = tuple(range(0x00, 0x80, 2))

# The cursor sits just below the buffer so a long routine cannot grow into it:
# at five bytes a port a 64-port sampler is over 350 bytes, which would have run
# straight through the old 0x3af0.
INDEX = 0x3FF0
BUFFER = 0x4000
# A call leaves RAM alone - unlike `AT&T8`, which clears all of it - so the ring
# can be far larger than the first 4 KiB. 32 KiB is 512 ticks of a 64-port
# sampler, or ten seconds of a six-port one.
BUFFER_SIZE = 0x8000

# The four ports that moved between idle and analogue loopback. 1c/1e are the
# mailbox status pair; 18 also varied within the active state.
DEFAULT_PORTS = (0x18, 0x1A, 0x1C, 0x1E)


def routine(ports=DEFAULT_PORTS, index: int = INDEX,
            buffer: int = BUFFER, size: int = BUFFER_SIZE,
            allow_latches: bool = False) -> bytes:
    """The sampler placed at `ROUTINE_BASE`.

    `DI` carries the write cursor between ticks through `index`, so the buffer
    fills continuously rather than restarting. The wrap is a compare against
    the end and a reload, which costs nothing when it does not fire.
    """
    for port in ports:
        if port in FORBIDDEN_PORTS and not allow_latches:
            raise ValueError(
                f"port {port:02x} drives a board latch; pass allow_latches to read it"
            )
        if not 0 <= port <= 0xFF:
            raise ValueError(f"port {port:#x} is outside the byte-immediate form")
    end = buffer + size
    code = bytearray((
        0x50,                      # push ax
        0x9C,                      # pushf
        0x1E,                      # push ds
        0x57,                      # push di
        0x31, 0xC0,                # xor ax, ax
        0x8E, 0xD8,                # mov ds, ax
        0x8B, 0x3E, index & 0xFF, index >> 8,      # mov di, [index]
    ))
    for port in ports:
        code += bytes((0xE4, port,  # in al, port
                       0x88, 0x05,  # mov [di], al
                       0x47))       # inc di
    code += bytes((
        0x81, 0xFF, end & 0xFF, end >> 8,          # cmp di, end
        0x72, 0x03,                                # jb +3, over the reload
        0xBF, buffer & 0xFF, buffer >> 8,          # mov di, buffer
        0x89, 0x3E, index & 0xFF, index >> 8,      # mov [index], di
        0x5F,                      # pop di
        0x1F,                      # pop ds
        0x9D,                      # popf
        0x58,                      # pop ax
        0xEA, ORIGINAL_OFFSET & 0xFF, ORIGINAL_OFFSET >> 8,
        ORIGINAL_SEGMENT & 0xFF, ORIGINAL_SEGMENT >> 8,   # jmp far 8000:0a77
    ))
    return bytes(code)


def place_commands(ports=DEFAULT_PORTS, index: int = INDEX,
                   buffer: int = BUFFER, size: int = BUFFER_SIZE,
                   allow_latches: bool = False) -> list[str]:
    """Place the routine and point the write cursor at the buffer start.

    Bytes go two at a time. Each command is a serial round trip of about
    165 ms and a 64-port sampler is over 350 bytes, so pairing them is the
    difference between a minute of placement and two. The monitor picks the
    store width from the digit count, so four digits is what makes it a word.
    """
    code = routine(ports, index, buffer, size, allow_latches)
    commands = []
    for i in range(0, len(code) - 1, 2):
        commands.append(write_word(ROUTINE_BASE + i, code[i] | (code[i + 1] << 8)))
    if len(code) % 2:
        commands.append(write_byte(ROUTINE_BASE + len(code) - 1, code[-1]))
    commands.append(write_word(index, buffer))
    return commands


def decode(ring: bytes, cursor: int, ports=DEFAULT_PORTS,
           buffer: int = BUFFER, wrapped: bool | None = None) -> list[dict]:
    """Turn the ring into one record per tick, oldest first.

    `cursor` is the routine's live write index, so it is both where the next
    sample would go and where the oldest one currently sits.

    The ring wraps, and getting this wrong is easy: at six ports and 200 Hz a
    4 KiB buffer laps in 3.4 s, and treating `cursor - buffer` as a length then
    silently returns whatever fraction of a lap the cursor happens to be into.
    Pass `wrapped=False` for a run known to be shorter than one lap, in which
    case only the bytes up to the cursor are data; otherwise the whole ring is
    data and it is unrolled starting at the cursor.
    """
    stride = len(ports)
    offset = (cursor - buffer) % len(ring)
    if wrapped is False:
        data = ring[:offset]
    else:
        data = ring[offset:] + ring[:offset]
    data = data[:len(data) - len(data) % stride]
    return [
        {"tick": n, **{f"{port:02X}": data[n * stride + i]
                       for i, port in enumerate(ports)}}
        for n in range(len(data) // stride)
    ]


def plan(ports=DEFAULT_PORTS) -> str:
    code = routine(ports)
    seconds = BUFFER_SIZE / len(ports) / 200
    return "\n".join((
        f"routine  {len(code)} bytes at {ROUTINE_BASE:05x}..{ROUTINE_BASE + len(code) - 1:05x}",
        f"ports    {' '.join(f'{p:02X}' for p in ports)}  ({len(ports)} bytes per tick)",
        f"index    word at {INDEX:05x}",
        f"buffer   {BUFFER:05x}..{BUFFER + BUFFER_SIZE - 1:05x}"
        f"  ({BUFFER_SIZE} bytes = {seconds:.1f} s at 200 Hz)",
        f"hook     vector {TICK_VECTOR:02x} segment cell {VECTOR_SEGMENT_CELL:02x}: "
        f"{ORIGINAL_SEGMENT:04x} -> {HOOK_SEGMENT:04x}",
        "",
        "  " + " ".join(f"{b:02X}" for b in code),
        "",
        f"arm      {arm_command()}",
        f"disarm   {disarm_command()}",
    ))


if __name__ == "__main__":
    print(plan())
