"""Time a DTMF digit on the board, by differencing dials of different lengths.

The harness says a digit is 36.6 INT0 periods plus 2.9 ms, and that `S11`
buys 0.523 periods per unit
(docs/hardware-timebase-and-audio-path.md). With the interrupt measured at
2,401 Hz, those constants only produce a legal digit if something divides the
interrupt by about 4.4 before the digit counter sees it. That factor rests
entirely on `S11` being milliseconds of tone, which is an assumption. Timing a
real digit replaces it with a measurement.

**The method needs no probe and no line.** Blind-dial (`ATX0`) a string of `n`
digits and time from the command to the result code. That interval is

    dial setup + n * (tone + gap) + S7 carrier wait + reporting

and every term except the middle one is constant in `n`, so a straight line
through two or more digit counts has the per-digit time as its slope and all the
fixed overhead in its intercept. Nothing has to be known about the overhead, and
nothing has to be subtracted by hand.

`S11` is then swept the same way: if a digit really is `S11` milliseconds of
tone, the slope moves one millisecond per unit. Whatever it does move by is the
number the divider argument actually needs.

**On the line.** `ATX0` dials without waiting for dial tone, so this works with
the cord out - and out is how it should be run. The firmware generates the tones
either way; it does not know what is on the other side of the relay. Running it
with a line connected would dial the digit strings for real, which is why
`--allow-connected-line` exists and is not the default.

    .venv/bin/python -m courier_emu.dial_timing \\
        --device /dev/cu.usbserial-11420 --output artifacts/dial-timing-01

Nothing here writes NVRAM: `&W` is not in the allowlist, the settings it changes
are the volatile copies, and `ATZ` at the end restores them from what was
stored.
"""
from __future__ import annotations

import argparse
from datetime import datetime, timezone
import json
import os
from pathlib import Path
import re
import select
import statistics
import time

from .flash_dump import CALL_TERMINAL, SerialPort, validate_identity

# Everything this module may send, and nothing else. ATDT carries digits, which
# is the whole point and also the only command here that can reach the outside
# world, so it is bounded to plain digits - no commas, no W, no @, no #, and
# nothing that could be read as a second command.
DIAL = re.compile(r"ATDT[0-9]{1,64}")
SETUP = re.compile(r"AT(?:X[0-4]|S(?:7|11)=[0-9]{1,3}|E[01]|V1|Q0|H0?|Z)")
# Digit counts to dial. Spread wide: the slope's error falls with the spread,
# and the shortest is there to catch a non-linear first digit rather than to
# carry weight in the fit.
DIGIT_COUNTS = (4, 12, 24, 40)
S11_VALUES = (50, 70, 95)


class DialPort(SerialPort):
    """A `SerialPort` that may also dial, and only in the shapes above."""

    def __init__(self, *args, **kwargs):
        super().__init__(*args, allow_timing=True, **kwargs)

    def send(self, command: str, timeout: float = 90.0) -> tuple[bytes, float]:
        """Send one command and return its answer and how long it took.

        The clock starts after the last byte is written, so the command's own
        transmission - which grows with the digit count at about 87 us a
        character - is outside the interval being differenced.
        """
        if not (DIAL.fullmatch(command) or SETUP.fullmatch(command)):
            raise ValueError(f"{command!r} is not one of this module's commands")
        data = (command + "\r").encode("ascii")
        while data:
            data = data[self._write(data):]
        started = time.monotonic()
        response = self._read_until(CALL_TERMINAL, timeout)
        return response, time.monotonic() - started

    def reopen(self) -> None:
        """Close and reopen the device, then restore the volatile settings.

        Only the settings this module set: echo off, verbose result codes, X0
        and the short carrier wait. `S11` is not restored here - the caller owns
        it, and re-sending it would hide a reopen that happened mid-sweep.
        """
        try:
            self.__exit__(None, None, None)
        except OSError:
            self.fd = None
        time.sleep(1.0)
        self.__enter__()
        self.drain()
        for command in ("ATE0", "ATV1", "ATQ0", "ATX0", "ATS7=1"):
            self.send(command, timeout=10.0)

    def _write(self, data: bytes) -> int:
        if not select.select([], [self.fd], [], 4.0)[1]:
            raise TimeoutError("serial write timed out")
        return os.write(self.fd, data)

    def _read_until(self, pattern, timeout: float) -> bytes:
        deadline = time.monotonic() + timeout
        response = bytearray()
        while time.monotonic() < deadline:
            left = max(0, deadline - time.monotonic())
            if not select.select([self.fd], [], [], min(0.1, left))[0]:
                continue
            chunk = os.read(self.fd, 4096)
            if not chunk:
                continue
            response.extend(chunk)
            if len(response) > 16384:
                raise RuntimeError("response exceeds expected maximum length")
            if pattern.search(response):
                return bytes(response)
        raise TimeoutError(f"no result code within {timeout:g} s")


def fit(points: list[tuple[int, float]]) -> tuple[float, float]:
    """Least squares slope and intercept of seconds against digit count."""
    n = len(points)
    mx = statistics.fmean(x for x, _ in points)
    my = statistics.fmean(y for _, y in points)
    denominator = sum((x - mx) ** 2 for x, _ in points)
    if not denominator:
        raise ValueError("every dial used the same digit count; no slope")
    slope = sum((x - mx) * (y - my) for x, y in points) / denominator
    return slope, my - slope * mx


def measure(port: DialPort, s11: int, counts: tuple[int, ...],
            repeats: int, log: list) -> dict:
    port.send(f"ATS11={s11}", timeout=10.0)
    points: list[tuple[int, float]] = []
    for digits in counts:
        for attempt in range(repeats):
            command = "ATDT" + "".join(str((i % 9) + 1) for i in range(digits))
            try:
                answer, elapsed = port.send(command)
            except OSError as exc:
                # The USB serial device drops mid-run on this bench - one dial
                # in on the first attempt, with the node still present and the
                # modem answering AT immediately afterwards. Reopening and
                # retrying costs one dial; the alternative is losing the run.
                # A dial that fails twice is recorded and skipped rather than
                # ending the sweep, because the fit only needs a spread of
                # digit counts, not every one of them.
                log.append({"s11": s11, "digits": digits, "attempt": attempt + 1,
                            "error": repr(exc), "recovered": False})
                try:
                    port.reopen()
                    log[-1]["recovered"] = True
                    answer, elapsed = port.send(command)
                except OSError:
                    continue
            text = answer.decode("ascii", "replace").strip().splitlines()[-1]
            log.append({"s11": s11, "digits": digits, "attempt": attempt + 1,
                        "seconds": round(elapsed, 4), "result": text})
            points.append((digits, elapsed))
            try:
                port.send("ATH", timeout=10.0)
            except OSError:
                port.reopen()
            time.sleep(0.3)
    if len({x for x, _ in points}) < 2:
        return {"s11": s11, "points": len(points),
                "error": "fewer than two digit counts survived; no slope"}
    slope, intercept = fit(points)
    return {"s11": s11, "points": len(points),
            "ms_per_digit": round(slope * 1000, 2),
            "fixed_ms": round(intercept * 1000, 1)}


def run(port: DialPort, counts: tuple[int, ...], s11_values: tuple[int, ...],
        repeats: int, output: Path) -> dict:
    report: dict = {
        "status": "running",
        "device": port.device, "baud": port.baud,
        "started_utc": datetime.now(timezone.utc).isoformat(),
        "method": "blind-dial ATX0, time to result code, regress on digit count",
        "digit_counts": list(counts), "s11_values": list(s11_values),
        "repeats": repeats, "dials": [],
        "assumptions": [
            "Every term but n*(tone+gap) is constant in n, so the slope is the "
            "per-digit time and the intercept absorbs setup, S7 and reporting.",
            "The host clock times the serial result code, so the figure includes "
            "the modem's own reporting latency in the intercept, not the slope.",
            "S11 changes only the tone, not the interdigit gap, is NOT assumed: "
            "the slope is tone plus gap and the sweep measures their sum.",
        ],
    }

    def checkpoint():
        temporary = output / "manifest.json.tmp"
        temporary.write_text(json.dumps(report, indent=1) + "\n")
        temporary.replace(output / "manifest.json")

    port.drain()
    raw = port.query("ATI7", timeout=8.0)
    (output / "ati7.txt").write_bytes(raw)
    _, target = validate_identity(raw)
    report["identity"] = {"supervisor": target[0], "dsp": target[1]}
    checkpoint()

    try:
        # X0 dials without waiting for dial tone, and reports only CONNECT or
        # NO CARRIER - so the run does not depend on a line being there, and
        # the result code set stays small. S7 as short as the firmware allows
        # keeps each dial's tail down; it lands in the intercept either way.
        for command in ("ATE0", "ATV1", "ATQ0", "ATX0", "ATS7=1"):
            port.send(command, timeout=10.0)
        report["fits"] = [measure(port, s11, counts, repeats, report["dials"])
                          for s11 in s11_values]
        checkpoint()
    finally:
        # Back to stored settings whatever happened, and on hook first.
        try:
            port.send("ATH", timeout=10.0)
            port.send("ATZ", timeout=10.0)
            report["restored"] = True
        except BaseException as exc:          # noqa: BLE001 - reported, not raised
            report["restore_error"] = repr(exc)
        checkpoint()

    fits = report.get("fits") or []
    if len(fits) >= 2:
        span = fits[-1]["s11"] - fits[0]["s11"]
        report["ms_per_s11_unit"] = round(
            (fits[-1]["ms_per_digit"] - fits[0]["ms_per_digit"]) / span, 3)
    report["status"] = "complete"
    checkpoint()
    return report


def main() -> int:
    parser = argparse.ArgumentParser(
        description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--device", required=True)
    parser.add_argument("--baud", type=int, default=115200)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--repeats", type=int, default=2)
    parser.add_argument("--digits", default=",".join(str(c) for c in DIGIT_COUNTS),
                        type=lambda v: tuple(int(p) for p in v.split(",")))
    parser.add_argument("--s11", default=",".join(str(v) for v in S11_VALUES),
                        type=lambda v: tuple(int(p) for p in v.split(",")))
    parser.add_argument("--allow-connected-line", action="store_true",
                        help="acknowledge that the phone cord is in. This dials "
                             "its digit strings for real; with the cord out the "
                             "measurement is identical, because ATX0 does not "
                             "wait for dial tone and the firmware generates the "
                             "tones either way")
    args = parser.parse_args()

    if not args.allow_connected_line:
        print("  unplug the phone cord before running this: it dials digit "
              "strings, and with the cord out the measurement is the same.\n"
              "  pass --allow-connected-line once it is out, or if you have "
              "decided to dial for real.")
        return 2
    if any(c < 1 or c > 64 for c in args.digits):
        parser.error("digit counts must be between 1 and 64")

    args.output.mkdir(parents=True, exist_ok=False)
    with DialPort(args.device, args.baud, allow_off_hook=True) as port:
        report = run(port, args.digits, args.s11, args.repeats, args.output)
    print(json.dumps({k: report[k] for k in
                      ("status", "identity", "fits", "ms_per_s11_unit",
                       "restored") if k in report}, indent=1))
    return 0 if report["status"] == "complete" else 1


if __name__ == "__main__":
    raise SystemExit(main())
