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
import json
from pathlib import Path
import struct

from .probe_transport import Code

# The surveyed-free 20 KiB block is 0x2e00-0x7eff (docs/ram-probe-delivery.md).
# Code sits at the bottom of it and the ring above, so both stay inside.
ENTRY = 0x3000
STATE = 0x3200          # write pointer, then the saved vector
BUFFER = 0x3400
BUFFER_END = 0x7E00     # 18 KiB of samples
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
CHAIN_STATE = 0x1B00
CHAIN_BUFFER = 0x1C00
CHAIN_BUFFER_END = 0x2B00      # 0x2c00 is written by &T8; stop short of it
I3CON = 0xFF1E

# Status and handshake only. 0x1c/0x1e are the mailbox status pair and the
# busiest group in the image; 0x18/0x1a are the rest of that block. None of
# these is a data window, so reading them should not consume anything.
DEFAULT_PORTS = (0x18, 0x1A, 0x1C, 0x1E)
# Never sampled, whatever is asked for: writing these is forbidden and reading
# a latch group whose semantics are write-one-to-clear is not worth the risk.
FORBIDDEN_PORTS = (0x10, 0x12, 0x14)


def build_sampler(ports: tuple[int, ...] = DEFAULT_PORTS,
                  entry: int = ENTRY,
                  state: int = STATE,
                  buffer: int = BUFFER,
                  buffer_end: int = BUFFER_END,
                  chain: bool = False) -> bytes:
    """The ISR image. One byte per port per tick, until the ring is full.

    With `chain`, the handler restores everything and jumps to the firmware's
    own INT3 handler rather than returning: the stack still carries the
    untouched interrupt frame, so the original runs exactly as if it had been
    entered directly, and it owns the EOI and the `iret`.
    """
    for port in ports:
        if port in FORBIDDEN_PORTS:
            raise ValueError(f"port {port:#04x} carries a board latch and is never sampled")
        if not 0 <= port <= 0xFF:
            raise ValueError(f"port {port:#04x} is outside the 8-bit I/O space")
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
    c.branch(0x73, "full")                 # jae full
    for port in ports:
        c.emit(f"e4{port:02x}")            # in al, port
        c.emit("8807")                     # mov [bx], al
        c.emit("43")                       # inc bx
    if not ports:
        c.emit("43")                       # inc bx - count ticks, sample nothing
    c.emit("891e"); c.word(state)          # mov [state], bx
    c.label("full")
    if chain:
        # Restore and fall through to the real handler. No EOI here - the
        # original issues it, and issuing one from an interrupt the firmware
        # did not expect was the other suspect for the timer-0 failure.
        c.emit("1f")        # pop ds
        c.emit("5b")        # pop bx
        c.emit("58")        # pop ax
        segment, offset = CHAIN_ORIGINAL
        c.emit("ea"); c.word(offset); c.word(segment)   # jmp far original
    else:
        # EOI exactly as the handler this replaces, then hand the machine back.
        c.emit("c706"); c.word(0xFF02); c.word(0x8000)
        c.emit("1f")        # pop ds
        c.emit("5b")        # pop bx
        c.emit("58")        # pop ax
        c.emit("cf")        # iret
    return c.finish()


def build_image(ports: tuple[int, ...] = DEFAULT_PORTS,
                chain: bool = False) -> tuple[bytes, dict]:
    """The placement image and the numbers a caller needs to read it back."""
    entry, state, buffer, base, end = (
        (CHAIN_ENTRY, CHAIN_STATE, CHAIN_BUFFER, CHAIN_PLACE_BASE, CHAIN_BUFFER_END)
        if chain else (ENTRY, STATE, BUFFER, ENTRY, BUFFER_END))
    code = build_sampler(ports, entry=entry, state=state,
                         buffer=buffer, buffer_end=end, chain=chain)
    if entry + len(code) > state:
        raise ValueError("sampler outgrew the gap before its state word")
    image = bytearray(buffer - base)
    image[entry - base:entry - base + len(code)] = code
    struct.pack_into("<H", image, state - base, buffer)    # the write pointer
    width = len(ports) or 1
    plan = {
        "entry": entry, "place_base": base, "state": state,
        "buffer": buffer, "buffer_end": end,
        "ports": [f"{p:#04x}" for p in ports],
        "bytes_per_tick": width,
        "capacity_samples": (end - buffer) // width,
        "seconds_at_303hz": round((end - buffer) / width / 303, 1),
        "code_bytes": len(code),
        "mode": "chained INT3" if chain else "timer 0, standalone",
    }
    return bytes(image), plan


def arm_commands(chain: bool = False) -> list[str]:
    if not chain:
        slot = TIMER0_VECTOR * 4
        return [f"ATGLK2={slot & ~0xFF:04X}",
                f"ATGLK2W{slot:04X},{ENTRY:04X}",
                f"ATGLK2W{slot + 2:04X},0000",
                "ATGLK2WFF36,A021"]      # T0CON: set INT, INH=0 leaves EN alone
    # One word, atomic: only the segment changes, and the offset already points
    # where the handler was placed.
    slot = CHAIN_VECTOR * 4
    return [f"ATGLK2={slot & ~0xFF:04X}",
            f"ATGLK2W{slot + 2:04X},{CHAIN_SEGMENT:04X}"]


def disarm_commands(chain: bool = False) -> list[str]:
    """Undo the arming. **This is not optional.**

    The takeover probes never needed a disarm because the watchdog reset the
    board and the firmware rebuilt the IVT. Nothing resets here - that is the
    entire point - so the hook stays live until it is removed, and it must be
    removed before the buffer is read or it keeps overwriting nothing while the
    firmware pays for the interrupt.
    """
    if not chain:
        slot = TIMER0_VECTOR * 4
        segment, offset = ORIGINAL_VECTOR
        return ["ATGLK2WFF36,8021",                # stop the interrupt first
                f"ATGLK2W{slot:04X},{offset:04X}",
                f"ATGLK2W{slot + 2:04X},{segment:04X}"]
    slot = CHAIN_VECTOR * 4
    return [f"ATGLK2W{slot + 2:04X},{CHAIN_ORIGINAL[0]:04X}"]


def readout_commands(chain: bool = False) -> list[str]:
    lo, hi = ((CHAIN_STATE, CHAIN_BUFFER_END) if chain else (STATE, BUFFER_END))
    return [f"ATGLK2={page:04X}" for page in range(lo & ~0xFF, hi, 0x100)]


def decode(pages: dict[int, int], ports: tuple[int, ...] = DEFAULT_PORTS,
           chain: bool = False) -> dict:
    """Turn read-back bytes into per-port sample columns."""
    STATE_, BUFFER_, END_ = ((CHAIN_STATE, CHAIN_BUFFER, CHAIN_BUFFER_END) if chain
                             else (STATE, BUFFER, BUFFER_END))
    written = pages.get(STATE_, 0) | (pages.get(STATE_ + 1, 0) << 8)
    if not BUFFER_ <= written <= END_:
        return {"error": f"write pointer {written:#06x} is outside the ring",
                "write_pointer": written}
    raw = [pages[a] for a in range(BUFFER_, written) if a in pages]
    complete = len(raw) - len(raw) % len(ports)
    columns = {f"{p:#04x}": raw[i:complete:len(ports)] for i, p in enumerate(ports)}
    return {
        "write_pointer": written,
        "samples": complete // len(ports),
        "bytes_recovered": len(raw),
        "filled_ring": written >= END_,
        "columns": columns,
        "distinct": {k: len(set(v)) for k, v in columns.items()},
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__,
                                     formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--chain", action="store_true",
                        help="hook INT3, the tick the firmware already services, and "
                             "chain to its handler instead of injecting a timer-0 "
                             "interrupt and issuing an EOI of our own")
    parser.add_argument("--ports",
                        type=lambda v: () if v in ("", "none") else tuple(int(p, 0) for p in v.split(",")),
                        default=DEFAULT_PORTS,
                        help="comma-separated ports to sample each tick (default "
                             "0x18,0x1a,0x1c,0x1e - the status and handshake group). "
                             "Widening this can consume data the firmware is waiting "
                             "for; see the module docstring")
    args = parser.parse_args()

    image, plan = build_image(args.ports, chain=args.chain)
    args.output.mkdir(parents=True, exist_ok=True)
    (args.output / "sampler-ram.bin").write_bytes(image)
    (args.output / "arm.txt").write_text("\n".join(arm_commands(args.chain)) + "\n")
    (args.output / "disarm.txt").write_text("\n".join(disarm_commands(args.chain)) + "\n")
    (args.output / "readout.txt").write_text("\n".join(readout_commands(args.chain)) + "\n")
    (args.output / "plan.json").write_text(json.dumps(plan, indent=1) + "\n")
    print(json.dumps(plan, indent=1))
    print(f"  image {len(image)} bytes at {ENTRY:#06x}; place it with "
          f"tools/emit_ram_writes.py --base {ENTRY:#06x} --assume-zero")
    print("  arm.txt starts it; disarm.txt is NOT optional - nothing resets this board")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
