"""Characterize the Courier ASIC's I/O port space from the live board.

The 80186's I/O space is almost entirely the ASIC: the CPU's own peripheral
control block lives in *memory* at `0xff00`-`0xffff`, and flash and SRAM are
memory too, so what answers an `IN` is the gate array. Modelling it starts with
knowing which ports exist, which of them carry state, and which of that state
moves when the modem does something.

This is a **read-only** experiment. It sends `ATGLK2I00<pp>`, which is the
monitor's port-read selector, plus `AT&T8` and `AT&T0` to put the board into
and out of analogue loopback. There is no port write here, no memory write, no
flash operation and no dial - `MonitorPort` refuses anything else outright.

`AT&T8` is what makes an active state observable at all. `&T1` loops the DTE
through the modem, so the serial port stops accepting commands for the duration
and nothing can be sampled while audio runs. `&T8` runs the same analogue
loopback against the modem's own test pattern generator and leaves the DTE in
command mode, so the monitor still answers with the datapump working. It needs
no phone line and never takes the loop off hook.

Two things this deliberately does not do:

Reading a port is not always free. The mailbox data registers at `0x5c`/`0x5e`
are how the supervisor collects a reply, and `0x1c` carries the status the
mailbox interrupt acknowledges, so sampling them may consume something the
firmware was about to read. `--skip-mailbox` leaves that whole group alone; the
default includes it, because the ports move under load and that is most of what
there is to see, but a run that matters should be repeated both ways.

And it never writes a port. Write-response is what separates a latch from a
read-only status register, and it is the obvious next experiment, but an
unknown ASIC register is not a safe write target: three ports on this board
drive the hook relay, the NVRAM strobe and the carrier-detect pair. That
belongs behind its own deliberate decision, not in a characterization sweep.
"""
from __future__ import annotations

import argparse
from collections import Counter
from datetime import datetime, timezone
import json
import os
from pathlib import Path
import re
import select
import time

from .flash_dump import SerialPort, TERMINAL, validate_identity

# The monitor's port-read selector, and the two self-test commands that move
# the board between the states sampled here. Nothing else is admitted.
READ = re.compile(r"ATGLK2I00([0-9A-F]{2})")
# `ATZ` reloads the stored profile and restarts the firmware. It reads NVRAM
# and never writes it - `AT&W` is the command that stores, and it is not here
# and not admitted - so a reset discards anything this probe put in RAM rather
# than persisting it.
ALLOWED = re.compile(r"AT(?:|I7|E0|Z|S18=\d{1,3}|&T[08])")
VALUE = re.compile(rb"\r\r?\n([0-9A-F]{2})\r\nOK\r\n")

# The ports a reset is expected to move: the DSP download window, which the
# supervisor strobes in thousands while the C52 is held in reset, and the
# mailbox the two processors then talk over.
RESET_WATCH = (0x40, 0x42, 0x44, 0x46, 0x48, 0x4A, 0x4C, 0x4E,
               0x50, 0x52, 0x54, 0x56, 0x58, 0x5A, 0x5C, 0x5E,
               0x60, 0x62, 0x18, 0x1A, 0x1C, 0x1E)

# The mailbox group. Reading these can consume state the firmware wanted, so
# `--skip-mailbox` drops them; see the module docstring.
MAILBOX_PORTS = (0x1C, 0x1E, 0x58, 0x5A, 0x5C, 0x5E, 0x60, 0x62)
# Board latches. Reading is harmless - these are refused for *writes*
# elsewhere - but they are called out in the report because a bit that moves
# here is a board-level signal rather than an ASIC-internal one.
LATCH_PORTS = (0x10, 0x12, 0x14)

DEFAULT_PASSES = 4
# `ATGLK2B` sweeps show everything at and above 0x80 reading back as its own
# address, which is an undriven bus rather than a device. Sampling into that
# region is what establishes where the decode stops.
DEFAULT_LAST = 0xFF


class MonitorPort(SerialPort):
    """Read-only monitor transport: port reads and the two self-test commands."""

    def write_raw(self, command: str) -> None:
        """Send a permitted command without waiting for its result code.

        `ATZ` is the reason this exists: its `OK` arrives only once the restart
        has finished, so waiting for it guarantees missing the outage.
        """
        if not (READ.fullmatch(command) or ALLOWED.fullmatch(command)):
            raise ValueError(f"{command} is not a permitted operation")
        data = (command + "\r").encode("ascii")
        deadline = time.monotonic() + 2.0
        while data:
            left = deadline - time.monotonic()
            if left <= 0 or not select.select([], [self.fd], [], left)[1]:
                raise TimeoutError("serial write timed out")
            data = data[os.write(self.fd, data):]

    def query(self, command: str, timeout: float = 3.0,
              expect: "re.Pattern[bytes]" = TERMINAL) -> bytes:
        if not (READ.fullmatch(command) or ALLOWED.fullmatch(command)):
            raise ValueError(f"{command} is not a permitted read operation")
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
            if len(response) > 16384:
                raise RuntimeError("response exceeds expected maximum length")
            if expect.search(response):
                break
        return bytes(response)


def read_port(port: MonitorPort, number: int, timeout: float = 3.0) -> int | None:
    """One port, or None if the board did not answer inside `timeout`."""
    match = VALUE.search(port.query(f"ATGLK2I00{number:02X}", timeout=timeout))
    return int(match[1], 16) if match else None


def sweep(port: MonitorPort, numbers) -> dict[int, int | None]:
    return {number: read_port(port, number) for number in numbers}


def classify(states: dict[str, list[dict[int, int | None]]],
             numbers) -> dict[int, dict]:
    """Say, for each port, what kind of thing it behaved like.

    `alias` is the undriven bus: a port that reads back its own address is not
    answering, it is the last thing on the bus. `volatile` moved within a
    single state, so it carries live signal. `state` held still within each
    state but differed between them, which is the useful class: those are the
    registers the modem's activity actually reaches.
    """
    result: dict[int, dict] = {}
    for number in numbers:
        per_state = {
            name: sorted({p[number] for p in passes if p[number] is not None})
            for name, passes in states.items()
        }
        seen = sorted({v for values in per_state.values() for v in values})
        if not seen:
            kind = "unreadable"
        elif seen == [number & 0xFF]:
            kind = "alias"
        elif any(len(values) > 1 for values in per_state.values()):
            kind = "volatile"
        elif len(seen) > 1:
            kind = "state"
        else:
            kind = "constant"
        changed = 0
        for values in per_state.values():
            for value in values:
                changed |= value ^ seen[0]
        result[number] = {
            "kind": kind,
            "values": {name: [f"{v:02X}" for v in values]
                       for name, values in per_state.items()},
            "bits_seen_changing": f"{changed:02X}",
            "group": ("mailbox" if number in MAILBOX_PORTS else
                      "latch" if number in LATCH_PORTS else ""),
        }
    return result


def run(port: MonitorPort, numbers, passes: int) -> dict:
    identity = port.query("ATI7", timeout=6.0)
    text, target = validate_identity(identity)
    states: dict[str, list[dict[int, int | None]]] = {}

    states["idle"] = [sweep(port, numbers) for _ in range(passes)]

    # S18=0 leaves the self-test running until it is stopped explicitly, so the
    # loopback covers however long the sweeps take rather than timing out.
    port.query("ATS18=0", timeout=4.0)
    port.query("AT&T8", timeout=6.0, expect=re.compile(rb"(?!)"))
    time.sleep(0.5)
    port.drain(0.1)
    try:
        states["loopback"] = [sweep(port, numbers) for _ in range(passes)]
    finally:
        # The error count, not OK, is what ends a self test.
        port.query("AT&T0", timeout=6.0, expect=re.compile(rb"\d\d\d\r\n"))
        port.drain(0.2)

    states["after"] = [sweep(port, numbers) for _ in range(passes)]

    ports = classify(states, numbers)
    kinds = Counter(entry["kind"] for entry in ports.values())
    decoded = [n for n, e in ports.items() if e["kind"] not in ("alias", "unreadable")]
    return {
        "captured": datetime.now(timezone.utc).isoformat(),
        "identity": text,
        "target": {"supervisor": target[0], "dsp": target[1]},
        "passes": passes,
        "states": list(states),
        "kinds": dict(kinds),
        "decoded_ports": [f"{n:02X}" for n in decoded],
        "decode_limit": f"{max(decoded):02X}" if decoded else None,
        "ports": {f"{n:02X}": entry for n, entry in ports.items()},
        "raw": {name: [{f"{n:02X}": (f"{v:02X}" if v is not None else None)
                        for n, v in one.items()} for one in passes_]
                for name, passes_ in states.items()},
        "assumptions": [
            "A sweep takes seconds, so a port carrying a 9.6 kHz signal reads "
            "as an arbitrary sample, not a waveform. `volatile` means the port "
            "moved between reads, not that it is audio.",
            "Ports are read one at a time and never simultaneously, so nothing "
            "here relates two ports' values at one instant.",
            "`constant` is only constant across the states sampled here; the "
            "modem was never off hook and never on a call.",
            "Reading a mailbox port may consume state the firmware was about "
            "to read, so its values are not purely observational.",
        ],
    }


def run_reset(port: MonitorPort, numbers, passes: int) -> dict:
    """Sweep either side of an `ATZ`, and race the modem back up.

    The monitor is part of the firmware, so nothing can be sampled *during* the
    reset: the board stops answering the moment it restarts and is only
    readable again once the supervisor is back at its command loop, by which
    time the DSP download has finished. What this can show is the settled state
    either side of it, how long the restart takes, and whether the download
    window is still moving when the board first answers - `RESET_WATCH` is
    swept as fast as the link allows for exactly that.
    """
    identity = port.query("ATI7", timeout=6.0)
    text, target = validate_identity(identity)

    before = [sweep(port, numbers) for _ in range(passes)]

    # Do not wait for ATZ's own OK: that arrives when the restart is already
    # complete, so waiting for it guarantees missing the outage. Write the
    # command and immediately race the board with single-port reads on a short
    # timeout. A read that fails is the firmware being down, and the first that
    # succeeds dates its return - which is the only way this transport can
    # bound the reset at all.
    start = time.monotonic()
    port.write_raw("ATZ")
    race: list[dict] = []
    watch = RESET_WATCH[:1][0]          # 0x40, the download window's first port
    while time.monotonic() - start < 8.0:
        at = time.monotonic() - start
        value = read_port(port, watch, timeout=0.45)
        race.append({"at": round(at, 4), "port": f"{watch:02X}",
                     "value": f"{value:02X}" if value is not None else None})
        if len(race) > 8 and all(r["value"] is not None for r in race[-6:]):
            break
    reset_seconds = time.monotonic() - start
    down = [r for r in race if r["value"] is None]
    answered = any(r["value"] is not None for r in race)
    port.drain(0.2)

    # Then the slower watched set, to see whether anything is still settling.
    settling = []
    settle_start = time.monotonic()
    while time.monotonic() - settle_start < 3.0:
        settling.append({
            "at": round(time.monotonic() - settle_start, 4),
            "ports": {f"{n:02X}": (f"{v:02X}" if v is not None else None)
                      for n, v in sweep(port, RESET_WATCH).items()},
        })

    after = [sweep(port, numbers) for _ in range(passes)]

    states = {"before": before, "after": after}
    ports = classify(states, numbers)
    moved = {name: entry for name, entry in
             ((f"{n:02X}", ports[n]) for n in numbers)
             if entry["kind"] in ("state", "volatile")}
    return {
        "captured": datetime.now(timezone.utc).isoformat(),
        "identity": text,
        "target": {"supervisor": target[0], "dsp": target[1]},
        "experiment": "reset",
        "passes": passes,

        "reset_answered_ok": answered,
        "reset_seconds": round(reset_seconds, 4),
        "race": race,
        "race_reads": len(race),
        "race_failed_reads": len(down),
        "outage_first_failure": down[0]["at"] if down else None,
        "outage_last_failure": down[-1]["at"] if down else None,
        "settling_sweeps": len(settling),
        "settling": settling,
        "moved_across_reset": moved,
        "ports": {f"{n:02X}": entry for n, entry in ports.items()},
        "raw": {name: [{f"{n:02X}": (f"{v:02X}" if v is not None else None)
                        for n, v in one.items()} for one in passes_]
                for name, passes_ in states.items()},
        "assumptions": [
            "Nothing is sampled during the reset: the monitor is firmware, so "
            "the board is unreadable until the supervisor is back, by which "
            "time the DSP download has already finished.",
            "`reset_seconds` is the ATZ round trip, so it includes one "
            "command's serial overhead as well as the restart.",
            "A port that reads the same before and after has not been shown to "
            "be untouched by the reset, only to settle to the same value.",
            "ATZ reloads the stored profile, so any RAM-only setting made "
            "earlier in the session is discarded here rather than persisted.",
        ],
    }


def main() -> int:
    parser = argparse.ArgumentParser(
        description="read-only characterization of the ASIC's I/O port space"
    )
    parser.add_argument("--device", required=True)
    parser.add_argument(
        "--baud", type=int, choices=(9600, 19200, 38400, 57600, 115200), default=115200
    )
    parser.add_argument("--output", type=Path, required=True,
                        help="new directory for the report")
    parser.add_argument("--first", type=lambda v: int(v, 0), default=0x00)
    parser.add_argument("--last", type=lambda v: int(v, 0), default=DEFAULT_LAST)
    parser.add_argument("--passes", type=int, default=DEFAULT_PASSES)
    parser.add_argument("--skip-mailbox", action="store_true",
                        help="leave 1c/1e/58-62 unread, since reading them can "
                        "consume state the supervisor was about to collect")
    parser.add_argument("--reset", action="store_true",
                        help="sweep either side of an ATZ instead of either "
                        "side of a loopback. ATZ reloads the stored profile "
                        "and writes no NVRAM; it discards RAM-only settings")
    args = parser.parse_args()

    numbers = [n for n in range(args.first, args.last + 1)
               if not (args.skip_mailbox and n in MAILBOX_PORTS)]
    args.output.mkdir(parents=True, exist_ok=False)

    with MonitorPort(args.device, args.baud) as port:
        port.drain()
        report = (run_reset if args.reset else run)(port, numbers, args.passes)
    report["skip_mailbox"] = args.skip_mailbox
    (args.output / "report.json").write_text(
        json.dumps(report, indent=2, sort_keys=True) + "\n"
    )

    print(f"board: {report['target']['supervisor']} / {report['target']['dsp']}")
    if args.reset:
        print(f"ATZ answered OK: {report['reset_answered_ok']} "
              f"in {report['reset_seconds']:.3f} s")
        print(f"settling sweeps in the first 3 s: {report['settling_sweeps']}")
        moved = report["moved_across_reset"]
        print(f"\nports that differ across the reset: {len(moved)}")
        for name, entry in moved.items():
            before = ",".join(entry["values"].get("before", []))
            after = ",".join(entry["values"].get("after", []))
            print(f"  {name}  {entry['kind']:>9}  before={before:<14}"
                  f" after={after:<14} bits={entry['bits_seen_changing']}")
        # Whether the watched set was still moving as the board came back.
        first = report["settling"][0]["ports"] if report["settling"] else {}
        unsettled = sorted(
            name for name in first
            if len({s["ports"].get(name) for s in report["settling"]}) > 1
        )
        print(f"\nwatched ports still moving while settling: "
              f"{', '.join(unsettled) if unsettled else 'none'}")
        return 0
    print(f"kinds: {report['kinds']}")
    print(f"decode stops after: {report['decode_limit']}\n")
    print(f"{'port':>5} {'kind':>9} {'idle':>14} {'loopback':>18} {'bits':>5}")
    for name, entry in report["ports"].items():
        if entry["kind"] in ("alias", "unreadable"):
            continue
        idle = ",".join(entry["values"].get("idle", []))
        active = ",".join(entry["values"].get("loopback", []))
        flag = f" {entry['group']}" if entry["group"] else ""
        print(f"{name:>5} {entry['kind']:>9} {idle:>14} {active:>18}"
              f" {entry['bits_seen_changing']:>5}{flag}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
