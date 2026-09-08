"""A timer-0 sampler that runs *alongside* the firmware instead of replacing it.

Every probe in `probe_transport` takes the machine over: it resets the DSP,
downloads a kernel, collects a frame and prints it, and about 1.6 seconds later
the `ADM707`'s watchdog resets the board. That bound is why the on-chip ROM had
to come off in two halves, and the reset is what clears RAM and restores the
IVT after every run - see docs/ram-probe-delivery.md.

This is the other shape. Timer 0's own handler on this board is two
instructions:

    108f  mov word ptr [0xff02], 0x8000   ; non-specific EOI
    1095  iret

so hooking vector 8 displaces a no-op. The sampler does a small, bounded slice
of work on each 5 ms tick, EOIs and returns, and the supervisor keeps running
underneath - which means it keeps feeding its own watchdog, and the run is not
bounded at all. Nothing here writes the watchdog, and nothing here needs to
know which pin `WDI` is on.

**What this can and cannot see.** It samples what the *80186* can reach: the
ASIC's ports and CPU RAM, at bus speed, while a call is up. It cannot read the
DSP's internal data memory - `0x0390` and the rest of the resident's state are
on the far side of the mailbox, and the resident's 121-entry dispatch table has
no handler that reads an address and mails it back. Sampling DSP-side cells
during a call needs a DSP-side mechanism this does not provide.

**The port set is the risky part**, and it is why the default is conservative.
Reading an ASIC port may not be free: the mailbox data pair and the DSP-to-host
stream at `0x60`/`0x62` are plausibly consumed by reading them, and a sampler
that steals words from the firmware would corrupt the call it is meant to
observe. The default set is the status/handshake group only. Widening it is a
deliberate act with a real chance of disturbing a live connection - recoverable
with a power cycle, since nothing here touches ports 0x10/0x12/0x14 or flash,
but a corrupted call all the same.
"""
from __future__ import annotations

import argparse
from dataclasses import dataclass
import json
from pathlib import Path
import struct

from .probe_transport import Code

# NOT the surveyed-free 0x2e00-0x7eff block. AT&T8 zeroes 0x3000-0x8000, so a
# co-resident probe placed there is erased mid-run under a live vector - see
# docs/ram-probe-delivery.md. Only 0x1600-0x2b00 and 0xd000 came through &T8
# intact, and 0x2c00 is written, so the ring stops short of it. There is live
# firmware data at 0x1aab, which is why the state word sits below it at 0x1a40
# rather than on the next page: the placement image must not span it.
ENTRY = 0x1A00
STATE = 0x1A40          # the write pointer
BUFFER = 0x1C00
BUFFER_END = 0x2B00
TIMER0_VECTOR = 8
ORIGINAL_VECTOR = (0x8000, 0x108F)

# The chained mode hooks an interrupt the firmware already takes and services,
# instead of injecting one it never enables. INT3 is the supervisor's tick: the
# IVT reads 8000:0a77 and I3CON (0xff1e) reads 0x0003 - unmasked, priority 3 -
# so it is already firing. The sampler runs on the way through and then jumps to
# the original handler, which does its own work, its own EOI and its own iret.
# Nothing new is enabled and no extra EOI is issued, which is what the timer-0
# version got wrong (artifacts/coop-loadonly-01).
CHAIN_VECTOR = 0x0F
CHAIN_ORIGINAL = (0x8000, 0x0A77)
# INT3 fires continuously, so its vector cannot be rewritten a word at a time:
# any intermediate state points somewhere arbitrary and the next tick runs it.
# Masking INT3 across the swap was tried and is not survivable - the firmware
# cannot lose its tick for the third of a second two commands take, and the
# board reset (artifacts/coop-chain-01).
#
# So change **one** word. Leaving the offset at 0x0a77 and writing only the
# segment makes the swap a single atomic command, with no intermediate state at
# all: 0300:0a77 is physical 0x3a77, which is where the handler is placed. The
# same one word put back disarms it.
#
# Where it lives matters more than any of that. **AT&T8 zeroes 0x3000-0x8000**,
# which is most of the surveyed-free block every takeover probe is placed in,
# and it writes 0x55 at 0x2c00, 0x9000 and 0xa000. Measured by writing markers
# across low RAM, running &T8 with nothing armed, and reading them back; only
# 0x1600-0x2b00 and 0x0d000 came through untouched. A takeover probe does not
# care, because it runs and dies inside 1.6 s. A co-resident one is destroyed
# mid-run: the handler is erased under the vector still pointing at it, and the
# next tick executes zeros. That, not the EOI and not interrupt latency, is
# what killed every earlier build under load.
CHAIN_SEGMENT = 0x0100
CHAIN_ENTRY = (CHAIN_SEGMENT << 4) + CHAIN_ORIGINAL[1]   # 0x1a77
CHAIN_PLACE_BASE = 0x1A00
# Live firmware data, identified by the region scan and then erased once by a
# placement that spanned it. Nothing this module emits may touch it.
FIRMWARE_DATA = (0x1AAB, 0x1AD6)
CHAIN_STATE = 0x1B00
# The wrap counter, one word above the pointer. Without it a filled ring says
# only "at least capacity", which on INT0's first hardware run was the whole
# result: 1920 entries, all idle, and no way to tell whether they covered the
# dial or ran out before it. wraps * capacity + (pointer - buffer) is the exact
# number of interrupts the run took, and the ring itself holds the newest ones.
WRAPS_OFFSET = 2
CHAIN_BUFFER = 0x1C00
CHAIN_BUFFER_END = 0x2B00      # 0x2c00 is written by &T8; stop short of it
I3CON = 0xFF1E

# INT0 is the mailbox's own interrupt, and it is the reason this mode exists.
# The 403 board vectors 0x0c at 8f46:0000, which is the whole DSP-to-CPU path:
#
#     in al,0x1e / mov ah,al / in al,0x1c / and ax,3
#     test 1 -> out 0x58,0x5a,0x5c,0x5e          ; host -> DSP send
#     test 2 -> in al,0x5a / in al,0x58 / call [0x192]   ; DSP -> CPU receive
#     mov ax,[0x17f] / out 0x1c,al / out 0x1c,ah ; ack, written back *set*
#
# Nothing in the image calls or jumps to that address - it is only ever entered
# through the vector - so every message either processor ever gets is one entry
# to this handler. The harness raises the same vector on a fixed instruction
# period instead (machine.py:1565), because nothing on the CPU side produces
# the edge. Counting the real ones is the measurement that replaces the guess.
#
# The chaining trick is the same one INT3 uses and is *cheaper* here: the
# original offset is zero, so the segment 0x01a0 places the stub at 0x1a00 -
# the bottom of the same &T8-surviving region, with the whole gap to 0x1aab
# free for it.
INT0_VECTOR = 0x0C
INT0_ORIGINAL = (0x8F46, 0x0000)
INT0_SEGMENT = 0x01A0
INT0_ENTRY = (INT0_SEGMENT << 4) + INT0_ORIGINAL[1]    # 0x1a00


@dataclass(frozen=True)
class Hook:
    """One way of getting the sampler onto the board's interrupt path."""
    name: str
    vector: int
    original: tuple[int, int]        # segment, offset, as the IVT holds it
    entry: int                       # where the sampler's code goes
    state: int
    buffer: int
    buffer_end: int
    chain: bool                      # fall through to the firmware's handler
    segment: int | None = None       # our segment, for the chained hooks
    default_ports: tuple[int, ...] = ()

    @property
    def place_base(self) -> int:
        return self.entry


# Status and handshake only. 0x1c/0x1e are the mailbox status pair and the
# busiest group in the image; 0x18/0x1a are the rest of that block. None of
# these is a data window, so reading them should not consume anything.
DEFAULT_PORTS = (0x18, 0x1A, 0x1C, 0x1E)

TIMER0 = Hook(
    name="timer 0, standalone",
    vector=TIMER0_VECTOR, original=ORIGINAL_VECTOR,
    entry=ENTRY, state=STATE, buffer=BUFFER, buffer_end=BUFFER_END,
    chain=False, default_ports=DEFAULT_PORTS,
)
INT3 = Hook(
    name="chained INT3",
    vector=CHAIN_VECTOR, original=CHAIN_ORIGINAL,
    entry=CHAIN_ENTRY, state=CHAIN_STATE, buffer=CHAIN_BUFFER,
    buffer_end=CHAIN_BUFFER_END, chain=True, segment=CHAIN_SEGMENT,
    default_ports=DEFAULT_PORTS,
)
# The order is the firmware's own: its handler reads 0x1e, then 0x1c, then
# masks to two bits. Sampling the pair the same way round makes the two columns
# directly comparable with the `and ax,3` the handler performs on them.
INT0 = Hook(
    name="chained INT0, the mailbox interrupt",
    vector=INT0_VECTOR, original=INT0_ORIGINAL,
    entry=INT0_ENTRY, state=CHAIN_STATE, buffer=CHAIN_BUFFER,
    buffer_end=CHAIN_BUFFER_END, chain=True, segment=INT0_SEGMENT,
    default_ports=(0x1E, 0x1C),
)
HOOKS = {"timer0": TIMER0, "int3": INT3, "int0": INT0}

# Never sampled, whatever is asked for: writing these is forbidden and reading
# a latch group whose semantics are write-one-to-clear is not worth the risk.
FORBIDDEN_PORTS = (0x10, 0x12, 0x14)
# Forbidden on INT0 specifically. Everywhere else, reading the mailbox data
# lanes only *might* race the firmware; on INT0 it certainly does, because the
# handler this stub runs in front of is about to read exactly these to take the
# message, and a byte read here is a byte it does not get. The pair is what the
# handler puts on the bus, so ask for it by reading the ring, not the port.
FORBIDDEN_ON_INT0 = (0x58, 0x5A, 0x5C, 0x5E, 0x60, 0x62)


def build_sampler(ports: tuple[int, ...] | None = None,
                  cells: tuple[int, ...] = (),
                  hook: Hook = TIMER0, wrap: bool = False) -> bytes:
    """The ISR image. One byte per port per entry, until the ring is full.

    On a chained hook the handler restores everything and jumps to the
    firmware's own handler rather than returning: the stack still carries the
    untouched interrupt frame, so the original runs exactly as if it had been
    entered directly, and it owns the EOI and the `iret`.
    """
    ports = hook.default_ports if ports is None else ports
    entry, state = hook.entry, hook.state
    buffer, buffer_end = hook.buffer, hook.buffer_end
    for port in ports:
        if port in FORBIDDEN_PORTS:
            raise ValueError(f"port {port:#04x} carries a board latch and is never sampled")
        if hook is INT0 and port in FORBIDDEN_ON_INT0:
            raise ValueError(
                f"port {port:#04x} is a mailbox lane, and this stub runs in "
                "front of the handler that is about to read it: sampling it "
                "here takes the byte the firmware needs")
        if not 0 <= port <= 0xFF:
            raise ValueError(f"port {port:#04x} is outside the 8-bit I/O space")
    # RAM cells are read with `mov al, [imm16]`, which takes its segment from
    # DS - already zero here for the write primitive - so these are segment-0
    # addresses and nothing else. A read cannot disturb a latch the way an
    # `in` can, so there is no forbidden list for them; the bound is only that
    # the operand is a word.
    for cell in cells:
        if not 0 <= cell <= 0xFFFF:
            raise ValueError(f"cell {cell:#06x} is outside segment 0")
    # An empty port set is the load-only control: the ISR still fires, saves,
    # bounds-checks and returns, but touches no ASIC port. It separates "the
    # interrupt load broke the firmware" from "reading those ports broke it".
    if buffer_end <= buffer or buffer_end > 0x8000:
        raise ValueError("buffer must be non-empty and stay below 0x8000")

    c = Code(entry)
    c.label("isr")
    # Save only what is used. The first version pushed flags and all eight
    # registers, and `pushaw`/`popaw` are expensive on a 186 - every cycle of
    # them is spent with interrupts still disabled from the interrupt entry,
    # which lengthens the latency every other handler on the board sees. That
    # is the leading suspect for why the earlier builds died under load, so
    # this one touches AX, BX and DS and saves exactly those.
    #
    # Flags need no saving: the interrupt frame already carries the caller's,
    # the chained handler starts `sti`/`cld` and cannot rely on inheriting any,
    # and the final `iret` restores them from the frame.
    c.emit("50")            # push ax
    c.emit("53")            # push bx
    c.emit("1e")            # push ds
    c.emit("31c0")          # xor ax, ax
    c.emit("8ed8")          # mov ds, ax          - the write primitive's DS
    c.emit("8b1e"); c.word(state)          # mov bx, [state]
    c.emit("81fb"); c.word(buffer_end)     # cmp bx, buffer_end
    if wrap:
        # Wrap to the start and count it, so the ring holds the newest entries
        # rather than the oldest. A stimulus that follows the arming is at the
        # end of the window, and stopping when full captures the wrong end of it.
        c.branch(0x72, "store")            # jb store
        c.emit("bb"); c.word(buffer)       # mov bx, buffer
        c.emit("ff06"); c.word(state + WRAPS_OFFSET)   # inc word [wraps]
        c.label("store")
    else:
        c.branch(0x73, "full")             # jae full
    for port in ports:
        c.emit(f"e4{port:02x}")            # in al, port
        c.emit("8807")                     # mov [bx], al
        c.emit("43")                       # inc bx
    for cell in cells:
        c.emit("a0"); c.word(cell)         # mov al, [cell]
        c.emit("8807")                     # mov [bx], al
        c.emit("43")                       # inc bx
    if not ports and not cells:
        c.emit("43")                       # inc bx - count ticks, sample nothing
    c.emit("891e"); c.word(state)          # mov [state], bx
    c.label("full")
    if hook.chain:
        # Restore and fall through to the real handler. No EOI here - the
        # original issues it, and issuing one from an interrupt the firmware
        # did not expect was the other suspect for the timer-0 failure.
        #
        # Nothing here executes `sti`. The interrupt entry cleared IF and the
        # firmware's own handler sets it back when it is ready to; raising it
        # early would let a second edge in on top of a half-saved stub.
        c.emit("1f")        # pop ds
        c.emit("5b")        # pop bx
        c.emit("58")        # pop ax
        segment, offset = hook.original
        c.emit("ea"); c.word(offset); c.word(segment)   # jmp far original
    else:
        # EOI exactly as the handler this replaces, then hand the machine back.
        c.emit("c706"); c.word(0xFF02); c.word(0x8000)
        c.emit("1f")        # pop ds
        c.emit("5b")        # pop bx
        c.emit("58")        # pop ax
        c.emit("cf")        # iret
    return c.finish()


def build_image(ports: tuple[int, ...] | None = None,
                cells: tuple[int, ...] = (),
                hook: Hook = TIMER0,
                wrap: bool = False) -> tuple[bytes, dict]:
    """The placement image and the numbers a caller needs to read it back.

    The image is the **code only**. An earlier version returned one block
    spanning the gap between the code and the write pointer, which is 256 bytes
    of mostly zeros - and at 0x1a00 that gap contains live firmware data at
    0x1aab-0x1ad6, which one non-`--assume-zero` placement duly erased
    (artifacts/coop-chain-04, "mistake worth recording"). The pointer is one
    word and gets its own command instead, so no placement can reach that data
    whether or not the caller remembers the flag.
    """
    ports = hook.default_ports if ports is None else ports
    code = build_sampler(ports, cells, hook=hook, wrap=wrap)
    if hook.entry + len(code) > hook.state:
        raise ValueError("sampler outgrew the gap before its state word")
    if hook.entry < FIRMWARE_DATA[0] < hook.entry + len(code):
        raise ValueError(
            f"the sampler at {hook.entry:#06x} would run into the live "
            f"firmware data at {FIRMWARE_DATA[0]:#06x}")
    width = (len(ports) + len(cells)) or 1
    capacity = (hook.buffer_end - hook.buffer) // width
    plan = {
        "hook": hook.name,
        "vector": hook.vector,
        "original_vector": "%04x:%04x" % hook.original,
        "entry": hook.entry, "place_base": hook.place_base, "state": hook.state,
        "buffer": hook.buffer, "buffer_end": hook.buffer_end,
        "ports": [f"{p:#04x}" for p in ports],
        "cells": [f"{c:#06x}" for c in cells],
        "bytes_per_entry": width,
        "capacity_samples": capacity,
        "code_bytes": len(code),
        # What the ring holds, in seconds, at rates that have actually been
        # measured on this board. INT0's own rate is the unknown this mode
        # exists to measure, so no figure is offered for it.
        "seconds_at_303hz": round(capacity / 303, 1),
        "state_write": f"ATGLK2W{hook.state:04X},{hook.buffer:04X}",
        "wraps_write": f"ATGLK2W{hook.state + WRAPS_OFFSET:04X},0000" if wrap else None,
        "wrap": wrap,
    }
    return code, plan


def arm_commands(hook: Hook = TIMER0) -> list[str]:
    slot = hook.vector * 4
    if not hook.chain:
        return [f"ATGLK2={slot & ~0xFF:04X}",
                f"ATGLK2W{slot:04X},{hook.entry:04X}",
                f"ATGLK2W{slot + 2:04X},0000",
                "ATGLK2WFF36,A021"]      # T0CON: set INT, INH=0 leaves EN alone
    # One word, atomic: only the segment changes, and the offset already points
    # where the handler was placed. The page read first is the check that the
    # vector really holds what this module believes - on INT0 that is
    # 8f46:0000, and arming a hook onto a vector that says something else would
    # send the firmware's own interrupt to an address nobody chose.
    return [f"ATGLK2={slot & ~0xFF:04X}",
            f"ATGLK2W{slot + 2:04X},{hook.segment:04X}"]


def disarm_commands(hook: Hook = TIMER0) -> list[str]:
    """Undo the arming. **This is not optional.**

    The takeover probes never needed a disarm because the watchdog reset the
    board and the firmware rebuilt the IVT. Nothing resets here - that is the
    entire point - so the hook stays live until it is removed, and it must be
    removed before the buffer is read or it keeps overwriting nothing while the
    firmware pays for the interrupt.
    """
    slot = hook.vector * 4
    segment, offset = hook.original
    if not hook.chain:
        return ["ATGLK2WFF36,8021",                # stop the interrupt first
                f"ATGLK2W{slot:04X},{offset:04X}",
                f"ATGLK2W{slot + 2:04X},{segment:04X}"]
    return [f"ATGLK2W{slot + 2:04X},{segment:04X}"]


def readout_commands(hook: Hook = TIMER0) -> list[str]:
    lo, hi = hook.state, hook.buffer_end
    return [f"ATGLK2={page:04X}" for page in range(lo & ~0xFF, hi, 0x100)]


def decode(pages: dict[int, int], ports: tuple[int, ...] | None = None,
           cells: tuple[int, ...] = (), hook: Hook = TIMER0,
           wrap: bool = False) -> dict:
    """Turn read-back bytes into per-port sample columns.

    On a wrapping capture the pointer is the *oldest* entry, not the newest, so
    the ring is rotated back into time order before it is split into columns.
    """
    ports = hook.default_ports if ports is None else ports
    written = pages.get(hook.state, 0) | (pages.get(hook.state + 1, 0) << 8)
    wraps = (pages.get(hook.state + WRAPS_OFFSET, 0)
             | (pages.get(hook.state + WRAPS_OFFSET + 1, 0) << 8)) if wrap else 0
    if not hook.buffer <= written <= hook.buffer_end:
        return {"error": f"write pointer {written:#06x} is outside the ring",
                "write_pointer": written}
    names = [f"{p:#04x}" for p in ports] + [f"[{c:04x}]" for c in cells]
    width = len(names) or 1
    if wraps:
        # Oldest first: everything from the pointer to the end, then the start
        # up to the pointer. The split has to land on an entry boundary or the
        # columns interleave, and it does because the pointer only ever advances
        # by one full entry.
        raw = ([pages[a] for a in range(written, hook.buffer_end) if a in pages]
               + [pages[a] for a in range(hook.buffer, written) if a in pages])
    else:
        raw = [pages[a] for a in range(hook.buffer, written) if a in pages]
    complete = len(raw) - len(raw) % width
    columns = {name: raw[i:complete:width] for i, name in enumerate(names)}
    capacity = (hook.buffer_end - hook.buffer) // width
    return {
        "write_pointer": written,
        "wraps": wraps,
        # What the ring holds, and what the run actually saw. They are the same
        # number only when nothing was lost.
        "samples": complete // width,
        "interrupts_total": wraps * capacity + (written - hook.buffer) // width,
        "bytes_recovered": len(raw),
        "filled_ring": bool(wraps) or written >= hook.buffer_end,
        "columns": columns,
        "distinct": {k: len(set(v)) for k, v in columns.items()},
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__,
                                     formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--hook", choices=sorted(HOOKS), default=None,
                        help="which interrupt to sample on. timer0 takes over "
                             "vector 8 and issues its own EOI; int3 chains the "
                             "supervisor's tick; int0 chains the mailbox "
                             "interrupt itself, so it records one entry per "
                             "real CPU-DSP event instead of one per tick")
    parser.add_argument("--chain", action="store_true",
                        help="deprecated spelling of --hook int3")
    parser.add_argument("--cell", action="append", default=[], metavar="ADDR",
                        help="segment-0 RAM byte to sample each entry, hex, "
                             "repeatable; read with `mov al,[imm16]`, which "
                             "cannot disturb a latch the way an `in` can")
    parser.add_argument("--ports",
                        type=lambda v: () if v in ("", "none") else tuple(int(p, 0) for p in v.split(",")),
                        default=None,
                        help="comma-separated ports to sample each entry "
                             "(default 0x18,0x1a,0x1c,0x1e - the status and "
                             "handshake group - or 0x1e,0x1c on int0). Widening "
                             "this can consume data the firmware is waiting "
                             "for; see the module docstring")
    parser.add_argument("--wrap", action="store_true",
                        help="keep the newest entries instead of stopping when "
                             "the ring is full, and count the wraps, so a "
                             "stimulus that follows the arming is captured and "
                             "the true interrupt rate is known")
    args = parser.parse_args()

    if args.hook and args.chain:
        parser.error("--chain is the old spelling of --hook int3; pass one")
    hook = HOOKS[args.hook] if args.hook else (INT3 if args.chain else TIMER0)
    ports = hook.default_ports if args.ports is None else args.ports
    cells = tuple(int(c, 16) for c in args.cell)

    image, plan = build_image(ports, cells, hook=hook, wrap=args.wrap)
    args.output.mkdir(parents=True, exist_ok=True)
    (args.output / "sampler-ram.bin").write_bytes(image)
    (args.output / "arm.txt").write_text("\n".join(arm_commands(hook)) + "\n")
    (args.output / "disarm.txt").write_text("\n".join(disarm_commands(hook)) + "\n")
    (args.output / "readout.txt").write_text("\n".join(readout_commands(hook)) + "\n")
    (args.output / "plan.json").write_text(json.dumps(plan, indent=1) + "\n")
    print(json.dumps(plan, indent=1))
    print(f"  image {len(image)} bytes at {hook.entry:#06x}; place it with "
          f"tools/emit_ram_writes.py --base {hook.entry:#06x} --assume-zero")
    print(f"  then set the write pointer:  {plan['state_write']}")
    if plan["wraps_write"]:
        print(f"  and zero the wrap counter:   {plan['wraps_write']}")
    print("  arm.txt starts it; disarm.txt is NOT optional - nothing resets this board")
    if hook.chain:
        print(f"  arm.txt reads the IVT page first: vector {hook.vector:#04x} must "
              "read %04x:%04x before the segment is changed" % hook.original)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
