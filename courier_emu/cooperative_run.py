"""Drive a co-resident sampler on the live board, disarm included.

`cooperative_probe` emits the stub and four text files; getting them onto the
board has until now been a matter of pasting commands into a terminal in the
right order. That is how the placement at `0x1a00` came to span the live
firmware data at `0x1aab` and erase it (artifacts/coop-chain-04, "mistake worth
recording"), and it is why the disarm - the one step that is *not* optional,
because nothing resets this board on its own - depends on whoever is at the
keyboard remembering it.

This module does the whole sequence and puts the disarm in a `finally`, so an
exception, a `Ctrl-C` or a failed readout all still take the hook back out.

**What it is allowed to write.** `flash_dump.SerialPort` refuses everything but
reads, deliberately, and that stays true: writes go through `WritablePort`,
which is constructed with an explicit set of addresses and refuses any command
that is not a word write to one of them. The set is derived from the hook and
the image - the code's own bytes, the write pointer, and the one IVT segment
word that arms it - so a bug in the sequencing cannot put a write anywhere else,
and in particular cannot reach `0x1aab`.

**The order matters and is enforced.** Identity, then the vector reads back what
the hook expects, then place, then verify the placement byte for byte, and only
then arm. Any of those failing stops the run before the vector is touched: a
segment swap onto a vector that does not hold what this module believes would
send a live interrupt to an address nobody chose.

    .venv/bin/python -m courier_emu.cooperative_run \\
        --device /dev/cu.usbserial-11420 --hook int0 \\
        --output artifacts/coop-int0-01

It arms, waits for you to place the call, and disarms when you press Enter (or
after `--seconds`). Nothing here dials: the modem is yours to drive from another
terminal, or from the front panel, while the sampler runs underneath.
"""
from __future__ import annotations

import argparse
from datetime import datetime, timezone
import json
import os
from pathlib import Path
import re
import select
import sys
import time

from .cooperative_probe import (
    FIRMWARE_DATA, HOOKS, WRAPS_OFFSET, Hook, build_image, decode,
)
from .flash_dump import (
    CALL_TERMINAL, PAGE, TERMINAL, SerialPort, command_for, parse_page,
    validate_identity,
)

# The board this module's hooks were read off. Every vector, every original
# handler address and the &T8 survivor map come from this pair; on anything else
# the arming words would be fiction.
SUPPORTED = ("7.4.16", "3.1.2")
WRITE = re.compile(r"ATGLK2W([0-9A-F]{4}),([0-9A-F]{4})")


class WritablePort(SerialPort):
    """A `SerialPort` that may also write words, to named addresses only."""

    def __init__(self, *args, writable: frozenset[int] = frozenset(), **kwargs):
        super().__init__(*args, **kwargs)
        self.writable = writable
        self.writes: list[str] = []

    def write_word(self, address: int, value: int, timeout: float = 4.0) -> bytes:
        if address % 2:
            raise ValueError("the write primitive places words at even addresses")
        # Both bytes, because a word write covers two addresses and the caller
        # may have reasoned about only one of them.
        if address not in self.writable or address + 1 not in self.writable:
            raise ValueError(
                f"{address:#06x} is not in this run's writable set; the set is "
                "the sampler's own bytes, its write pointer and the one IVT "
                "word that arms it, and nothing else may be written")
        command = f"ATGLK2W{address:04X},{value & 0xFFFF:04X}"
        self.writes.append(command)
        return self._send(command, timeout)

    def write_raw(self, data: bytes) -> None:
        """Bytes that are not a command: the dial, and the CR that aborts it.

        Only ever reached with `allow_off_hook`, which is the flag the caller
        had to pass to take the loop off hook in the first place.
        """
        if not self.allow_off_hook:
            raise ValueError("raw writes are part of the off-hook path")
        while data:
            if not select.select([], [self.fd], [], 4.0)[1]:
                raise TimeoutError("serial write timed out")
            data = data[os.write(self.fd, data):]

    def abort_dial(self, timeout: float = 8.0) -> bytes:
        """End a dial early. Any character does it; a bare CR is the tidiest."""
        self.write_raw(b"\r")
        deadline = time.monotonic() + timeout
        response = bytearray()
        while time.monotonic() < deadline:
            left = max(0, deadline - time.monotonic())
            if not select.select([self.fd], [], [], min(0.2, left))[0]:
                continue
            chunk = os.read(self.fd, 4096)
            if not chunk:
                continue
            response.extend(chunk)
            if CALL_TERMINAL.search(response):
                break
        return bytes(response)

    def _send(self, command: str, timeout: float) -> bytes:
        if not WRITE.fullmatch(command):
            raise ValueError("not a word write")
        data = (command + "\r").encode("ascii")
        deadline = time.monotonic() + timeout
        while data:
            left = deadline - time.monotonic()
            if left <= 0 or not select.select([], [self.fd], [], left)[1]:
                raise TimeoutError("serial write timed out")
            data = data[os.write(self.fd, data):]
        response = bytearray()
        while time.monotonic() < deadline:
            left = max(0, deadline - time.monotonic())
            if not select.select([self.fd], [], [], min(0.2, left))[0]:
                continue
            chunk = os.read(self.fd, 4096)
            if not chunk:
                continue
            response.extend(chunk)
            if len(response) > 4096:
                raise RuntimeError("response exceeds expected maximum length")
            if TERMINAL.search(response):
                break
        if not TERMINAL.search(response):
            raise TimeoutError(f"no terminal status for {command}")
        if TERMINAL.search(response)[1] != b"OK":
            raise RuntimeError(f"{command} answered ERROR")
        return bytes(response)


def writable_addresses(hook: Hook, image: bytes) -> frozenset[int]:
    """Every address this run may write, and no others.

    The code, its write pointer, and the segment half of the hook's IVT slot.
    The offset half is deliberately absent: the chained hooks change one word,
    which is what makes the swap atomic, and a run that wrote the offset too
    would have an intermediate state where the vector points nowhere.
    """
    allowed = set(range(hook.entry, hook.entry + len(image) + len(image) % 2))
    allowed.update((hook.state, hook.state + 1))
    allowed.update((hook.state + WRAPS_OFFSET, hook.state + WRAPS_OFFSET + 1))
    if hook.chain:
        slot = hook.vector * 4
        allowed.update((slot + 2, slot + 3))
    else:
        allowed.update(range(hook.vector * 4, hook.vector * 4 + 4))
    overlap = allowed & set(range(FIRMWARE_DATA[0], FIRMWARE_DATA[1] + 1))
    if overlap:
        raise ValueError(
            f"this placement would write live firmware data at "
            f"{min(overlap):#06x}; refusing to build the write set")
    return frozenset(allowed)


def read_pages(port: SerialPort, first: int, last: int,
               responses: Path | None = None) -> dict[int, int]:
    """Byte-addressed contents of the pages covering `first`..`last`."""
    out: dict[int, int] = {}
    for page in range(first & ~0xFF, last, PAGE):
        raw = port.query(command_for(page, allow_ram=True))
        if responses is not None:
            (responses / f"{page:04x}.txt").write_bytes(raw)
        data, status = parse_page(raw, page, allow_ram=True)
        if status != "OK":
            raise RuntimeError(f"page {page:#06x} answered {status}")
        out.update({page + index: value for index, value in enumerate(data)})
    return out


def vector_words(pages: dict[int, int], vector: int) -> tuple[int, int]:
    """The (segment, offset) an IVT slot holds, as `validate` compares them."""
    slot = vector * 4
    offset = pages[slot] | (pages[slot + 1] << 8)
    segment = pages[slot + 2] | (pages[slot + 3] << 8)
    return segment, offset


def seize_the_loop(port: SerialPort, seconds: float) -> dict:
    """A bare `ATD`: off hook, wait for dial tone, dial nothing.

    This is the stimulus the measurement wants. The harness's failing case is
    `ATDT6245` answering `NO DIAL TONE`, and what fails in it is the dial-tone
    wait, not the digits - so a bare `ATD` reproduces the part in question and
    cannot place a call, whatever is plugged into the jack. `flash_dump` already
    gates it behind `allow_off_hook` for exactly this reason.

    It still takes the loop off hook. The dial is aborted after `seconds` with a
    bare CR - the standard any-character abort - rather than left to run out
    `S7`, because the ring holds only so many entries and every one after it
    fills is lost. `ATH` follows regardless, so the loop is released even if the
    abort was not what ended the dial.
    """
    started = time.monotonic()
    record: dict = {"command": "ATD", "held_seconds": seconds}
    port.write_raw(b"ATD\r")
    time.sleep(seconds)
    record["result"] = port.abort_dial().decode("ascii", "replace").strip()
    record["hung_up"] = port.query("ATH", timeout=8.0).decode(
        "ascii", "replace").strip()
    record["waited_seconds"] = round(time.monotonic() - started, 2)
    return record


def wait_for_operator(seconds: float | None) -> dict:
    """Hold the hook armed while the board is driven from somewhere else."""
    started = time.monotonic()
    if seconds is not None:
        print(f"  armed. sampling for {seconds:g} s - place the call now", flush=True)
        time.sleep(seconds)
        return {"waited_seconds": round(time.monotonic() - started, 2),
                "ended_by": "timer"}
    print("  armed. place the call now, then press Enter to disarm", flush=True)
    ended = "operator"
    try:
        sys.stdin.readline()
    except KeyboardInterrupt:
        ended = "interrupt"
    return {"waited_seconds": round(time.monotonic() - started, 2),
            "ended_by": ended}


def run(port: WritablePort, hook: Hook, image: bytes, plan: dict,
        ports: tuple[int, ...], cells: tuple[int, ...],
        output: Path, seconds: float | None, dial: float | None = None,
        wrap: bool = False) -> dict:
    started = time.monotonic()
    responses = output / "responses"
    responses.mkdir(parents=True, exist_ok=True)
    report: dict = {
        "status": "running",
        "device": port.device, "baud": port.baud,
        "started_utc": datetime.now(timezone.utc).isoformat(),
        "plan": plan,
        "armed": False, "disarmed": False,
        "writes": port.writes,
        "assumptions": [
            "The IVT slot read before arming is the one the firmware will use "
            "for the whole run; nothing here detects it being rewritten under us.",
            "A verified placement is not proof the stub is reached - only the "
            "ring filling is that.",
            "Sampling is one entry per interrupt, so a rate is a lower bound on "
            "board activity, never an upper one.",
            "A bare ATD seizes the loop and waits for dial tone. What that "
            "produces depends on what is plugged into the jack, which this "
            "module cannot see and does not record.",
        ],
    }

    def checkpoint():
        report["writes"] = port.writes
        temporary = output / "manifest.json.tmp"
        temporary.write_text(json.dumps(report, indent=1) + "\n")
        temporary.replace(output / "manifest.json")

    # 1. Identity. The hooks are addresses off one specific firmware pair.
    port.drain()
    # 8 s, not the 4 s default: ATI7 prints twenty lines and the other probes
    # on this board already allow 6. A short read used to reach
    # validate_identity as a truncated response and be reported as the wrong
    # board, which is a bad way to learn that a timeout is too tight.
    raw = port.query("ATI7", timeout=8.0)
    (responses / "ati7.txt").write_bytes(raw)
    if not TERMINAL.search(raw):
        raise TimeoutError(
            "ATI7 did not finish; the board answered "
            f"{len(raw)} bytes with no terminal status")
    _, target = validate_identity(raw)
    report["identity"] = {"supervisor": target[0], "dsp": target[1]}
    if target != SUPPORTED:
        raise RuntimeError(
            f"this module's hooks were read off {SUPPORTED[0]}/{SUPPORTED[1]}; "
            f"the board reports {target[0]}/{target[1]}")
    checkpoint()

    # 2. The vector must hold what the hook expects, before anything is placed.
    ivt = read_pages(port, 0, PAGE, responses)
    found = vector_words(ivt, hook.vector)
    report["vector_before"] = "%04x:%04x" % found
    if found != hook.original:
        raise RuntimeError(
            f"vector {hook.vector:#04x} reads %04x:%04x, not the expected "
            "%04x:%04x; not arming" % (*found, *hook.original))
    checkpoint()

    # 3. Place, skipping words that already match, then verify byte for byte.
    before = read_pages(port, hook.entry, hook.state + 2, responses)
    report["firmware_data_before"] = bytes(
        before[a] for a in range(*FIRMWARE_DATA)).hex()
    padded = image + (b"\0" if len(image) % 2 else b"")
    for offset in range(0, len(padded), 2):
        address = hook.entry + offset
        word = int.from_bytes(padded[offset:offset + 2], "little")
        if (before.get(address), before.get(address + 1)) != (word & 0xFF, word >> 8):
            port.write_word(address, word)
    port.write_word(hook.state, hook.buffer)
    if wrap:
        port.write_word(hook.state + WRAPS_OFFSET, 0)
    checkpoint()

    placed = read_pages(port, hook.entry, hook.state + 2, responses)
    actual = bytes(placed[hook.entry + index] for index in range(len(image)))
    report["placement_verified"] = actual == image
    if actual != image:
        raise RuntimeError("placement read back differently from the image; not arming")
    if bytes(placed[a] for a in range(*FIRMWARE_DATA)) != bytes(
            before[a] for a in range(*FIRMWARE_DATA)):
        raise RuntimeError(f"the firmware data at {FIRMWARE_DATA[0]:#06x} changed "
                           "during placement; not arming")
    checkpoint()

    # 4. Arm, hold, and disarm whatever happens.
    try:
        port.write_word(hook.vector * 4 + 2, hook.segment if hook.chain else 0)
        report["armed"] = True
        checkpoint()
        report["wait"] = (seize_the_loop(port, dial) if dial
                          else wait_for_operator(seconds))
    finally:
        # The one step that is not optional. It runs on the exception path, on
        # Ctrl-C, and after a wait that ended any other way.
        segment, offset = hook.original
        try:
            port.write_word(hook.vector * 4 + 2, segment)
            report["disarmed"] = True
        except BaseException as exc:          # noqa: BLE001 - reported, not raised
            report["disarm_error"] = repr(exc)
            report["status"] = "HOOK MAY STILL BE LIVE - POWER CYCLE THE BOARD"
        checkpoint()

    ivt = read_pages(port, 0, PAGE, responses)
    report["vector_after"] = "%04x:%04x" % vector_words(ivt, hook.vector)
    if vector_words(ivt, hook.vector) != hook.original:
        report["status"] = "HOOK MAY STILL BE LIVE - POWER CYCLE THE BOARD"
        checkpoint()
        raise RuntimeError("the vector did not read back as the original after disarm")
    checkpoint()

    # 5. Read the ring out, with the hook already gone.
    pages = read_pages(port, hook.state, hook.buffer_end, responses)
    ring = decode(pages, ports, cells, hook=hook, wrap=wrap)
    (output / "ring.json").write_text(json.dumps(ring, indent=1) + "\n")
    report["ring"] = {k: v for k, v in ring.items() if k != "columns"}
    if ring.get("samples"):
        report["ring"]["first_16"] = {
            name: [f"{v:02x}" for v in column[:16]]
            for name, column in ring["columns"].items()}
        elapsed = report["wait"].get("waited_seconds")
        if elapsed:
            # The interrupt rate, which is the point of the wrapping mode: a
            # ring that stopped when full only says "at least capacity".
            seen = ring.get("interrupts_total", ring["samples"])
            report["ring"]["interrupts_per_second"] = round(seen / elapsed, 1)
            report["ring"]["complete"] = not ring["filled_ring"]
    report["firmware_data_after"] = bytes(
        pages[a] for a in range(*FIRMWARE_DATA) if a in pages).hex() or None
    report["status"] = "complete"
    report["elapsed_seconds"] = round(time.monotonic() - started, 2)
    checkpoint()
    return report


def main() -> int:
    parser = argparse.ArgumentParser(
        description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--device", required=True)
    parser.add_argument("--baud", type=int, default=115200)
    parser.add_argument("--hook", choices=sorted(HOOKS), default="int0")
    parser.add_argument("--output", type=Path, required=True,
                        help="a new directory; an existing one is refused so a "
                             "capture cannot be written over another")
    parser.add_argument("--seconds", type=float, default=None,
                        help="disarm automatically after this long instead of "
                             "waiting for Enter")
    parser.add_argument("--dial", type=float, nargs="?", const=6.0, default=None,
                        metavar="SECONDS",
                        help="drive the stimulus from here instead of waiting: "
                             "a bare ATD, held this long (default 6, about what "
                             "the ring holds), then aborted and ATH. It dials no "
                             "digits and cannot place a call, but it does take "
                             "the loop off hook")
    parser.add_argument("--wrap", action="store_true", default=True,
                        help="keep the newest entries and count the wraps "
                             "(default): a stimulus follows the arming, so a "
                             "ring that stops when full captures the wrong end "
                             "of the window")
    parser.add_argument("--no-wrap", dest="wrap", action="store_false",
                        help="stop when the ring is full, keeping the oldest "
                             "entries")
    parser.add_argument("--cell", action="append", default=[], metavar="ADDR",
                        help="segment-0 RAM byte to sample each entry, hex")
    parser.add_argument("--ports", default=None,
                        type=lambda v: () if v in ("", "none") else tuple(
                            int(p, 0) for p in v.split(",")),
                        help="ports to sample each entry; the hook's own default "
                             "otherwise")
    args = parser.parse_args()

    hook = HOOKS[args.hook]
    if not hook.chain:
        # Arming timer 0 also writes T0CON at 0xff36, which is in the relocated
        # peripheral control block and outside anything this runner is willing
        # to write. Its command files are still emitted by cooperative_probe.
        parser.error("only the chained hooks are driven here; timer0 arms "
                     "through T0CON, which this runner does not write")
    ports = hook.default_ports if args.ports is None else args.ports
    cells = tuple(int(c, 16) for c in args.cell)
    image, plan = build_image(ports, cells, hook=hook, wrap=args.wrap)
    try:
        args.output.mkdir(parents=True, exist_ok=False)
    except FileExistsError:
        parser.error(f"{args.output} exists; each capture gets a new directory "
                     "so one cannot be written over another")
    (args.output / "sampler-ram.bin").write_bytes(image)
    (args.output / "plan.json").write_text(json.dumps(plan, indent=1) + "\n")

    print(f"  {plan['hook']}: {len(image)} bytes at {hook.entry:#06x}, "
          f"ring {hook.buffer:#06x}..{hook.buffer_end:#06x}")
    if args.dial and args.seconds:
        parser.error("--dial drives the stimulus itself; --seconds is the "
                     "unattended form of waiting for someone else to")
    with WritablePort(args.device, args.baud, allow_ram=True,
                      allow_off_hook=args.dial is not None,
                      writable=writable_addresses(hook, image)) as port:
        try:
            report = run(port, hook, image, plan, ports, cells,
                         args.output, args.seconds, args.dial, args.wrap)
        except BaseException as exc:          # noqa: BLE001 - reported, then raised
            print(f"  failed: {exc!r}", file=sys.stderr)
            raise
    print(json.dumps({k: v for k, v in report.items()
                      if k in ("status", "armed", "disarmed", "vector_after",
                               "placement_verified", "wait", "ring")}, indent=1))
    return 0 if report["status"] == "complete" else 1


if __name__ == "__main__":
    raise SystemExit(main())
