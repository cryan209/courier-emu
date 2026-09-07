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
                  buffer_end: int = BUFFER_END) -> bytes:
    """The ISR image. One byte per port per tick, until the ring is full."""
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
    # Save everything. The supervisor is running underneath and is entitled to
    # find its registers untouched, flags included.
    c.emit("9c")            # pushf
    c.emit("60")            # pushaw
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
    # EOI exactly as the handler this replaces, then hand the machine back.
    c.emit("c706"); c.word(0xFF02); c.word(0x8000)
    c.emit("1f")            # pop ds
    c.emit("61")            # popaw
    c.emit("9d")            # popf
    c.emit("cf")            # iret
    return c.finish()


def build_image(ports: tuple[int, ...] = DEFAULT_PORTS) -> tuple[bytes, dict]:
    """The placement image and the numbers a caller needs to read it back."""
    code = build_sampler(ports)
    if ENTRY + len(code) > STATE:
        raise ValueError("sampler outgrew the gap before its state word")
    image = bytearray(BUFFER - ENTRY)
    image[0:len(code)] = code
    struct.pack_into("<H", image, STATE - ENTRY, BUFFER)   # the write pointer
    width = len(ports) or 1
    plan = {
        "entry": ENTRY, "state": STATE, "buffer": BUFFER, "buffer_end": BUFFER_END,
        "ports": [f"{p:#04x}" for p in ports],
        "bytes_per_tick": width,
        "capacity_samples": (BUFFER_END - BUFFER) // width,
        "seconds_at_5ms": round((BUFFER_END - BUFFER) / width * 0.005, 1),
        "code_bytes": len(code),
    }
    return bytes(image), plan


def arm_commands() -> list[str]:
    slot = TIMER0_VECTOR * 4
    return [f"ATGLK2={slot & ~0xFF:04X}",
            f"ATGLK2W{slot:04X},{ENTRY:04X}",
            f"ATGLK2W{slot + 2:04X},0000",
            "ATGLK2WFF36,A021"]          # T0CON: set INT, INH=0 leaves EN alone


def disarm_commands() -> list[str]:
    """Undo the arming. **This is not optional.**

    The takeover probes never needed a disarm because the watchdog reset the
    board and the firmware rebuilt the IVT. Nothing resets here - that is the
    entire point - so the hook stays live until it is removed, and it must be
    removed before the buffer is read or it keeps overwriting nothing while the
    firmware pays for the interrupt.
    """
    slot = TIMER0_VECTOR * 4
    segment, offset = ORIGINAL_VECTOR
    return ["ATGLK2WFF36,8021",                    # stop the interrupt first
            f"ATGLK2W{slot:04X},{offset:04X}",
            f"ATGLK2W{slot + 2:04X},{segment:04X}"]


def readout_commands() -> list[str]:
    return [f"ATGLK2={page:04X}" for page in range(STATE & ~0xFF, BUFFER_END, 0x100)]


def decode(pages: dict[int, int], ports: tuple[int, ...] = DEFAULT_PORTS) -> dict:
    """Turn read-back bytes into per-port sample columns."""
    written = pages.get(STATE, 0) | (pages.get(STATE + 1, 0) << 8)
    if not BUFFER <= written <= BUFFER_END:
        return {"error": f"write pointer {written:#06x} is outside the ring",
                "write_pointer": written}
    raw = [pages[a] for a in range(BUFFER, written) if a in pages]
    complete = len(raw) - len(raw) % len(ports)
    columns = {f"{p:#04x}": raw[i:complete:len(ports)] for i, p in enumerate(ports)}
    return {
        "write_pointer": written,
        "samples": complete // len(ports),
        "bytes_recovered": len(raw),
        "filled_ring": written >= BUFFER_END,
        "columns": columns,
        "distinct": {k: len(set(v)) for k, v in columns.items()},
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__,
                                     formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--ports",
                        type=lambda v: () if v in ("", "none") else tuple(int(p, 0) for p in v.split(",")),
                        default=DEFAULT_PORTS,
                        help="comma-separated ports to sample each tick (default "
                             "0x18,0x1a,0x1c,0x1e - the status and handshake group). "
                             "Widening this can consume data the firmware is waiting "
                             "for; see the module docstring")
    args = parser.parse_args()

    image, plan = build_image(args.ports)
    args.output.mkdir(parents=True, exist_ok=True)
    (args.output / "sampler-ram.bin").write_bytes(image)
    (args.output / "arm.txt").write_text("\n".join(arm_commands()) + "\n")
    (args.output / "disarm.txt").write_text("\n".join(disarm_commands()) + "\n")
    (args.output / "readout.txt").write_text("\n".join(readout_commands()) + "\n")
    (args.output / "plan.json").write_text(json.dumps(plan, indent=1) + "\n")
    print(json.dumps(plan, indent=1))
    print(f"  image {len(image)} bytes at {ENTRY:#06x}; place it with "
          f"tools/emit_ram_writes.py --base {ENTRY:#06x} --assume-zero")
    print("  arm.txt starts it; disarm.txt is NOT optional - nothing resets this board")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
