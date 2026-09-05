"""Measure one firmware second on the physical Courier.

The harness carries two clocks that disagree by about four times. The DAA's
`INSTRUCTIONS_PER_MS` says 1,111 80186 instructions to the millisecond, derived
from the assumption that one 2 s ring burst is what takes the answer machine's
tick counter to the country minimum of 180. The C5x model, through its cycle
counts and the 5:4 scheduling ratio, implies 4,348. Neither is verified, and
every line-side timing in the harness rests on one of them.

The board settles it, because the quantity that matters is a ratio, and only
half of it is a model. The emulator can count instructions per firmware timer;
hardware can time the same timer in seconds. `instructions per millisecond` is
one divided by the other.

The timer used here is the self-test pair: `S18` sets a duration in seconds and
`&T1` runs local analogue loopback for exactly that long. It is entirely inside
the modem - the loopback is the modem's own transmitter into its own receiver -
so it needs no phone line, never takes the loop off hook, and dials nothing.

One thing the pairing requires, and it is easy to get wrong: **both halves have
to be the same firmware.** The board here reports supervisor 7.3.14; the image
the DSP bridge runs is `main211.xmf`, 2.1.1. They are not the same code, and
the difference is not cosmetic - main211's dial-tone wait is a fixed 9,600-tick
countdown written as `mov word [0x289], 0x2580`, and that instruction does not
appear anywhere in the captured 7.3.14 ROM. So a duration measured here pairs
with an instruction count taken from the *same* ROM, through the recovery
harness, not with one taken from main211.

Nothing here writes NVRAM. `S18` lives in RAM until an explicit `&W`, which
this module cannot send: the transport's allowlist has no `&W` in it. The
original `S18` is read first and restored at the end regardless of outcome.
"""
from __future__ import annotations

import argparse
import json
from pathlib import Path
import re
import statistics
import time

from .flash_dump import CALL_TERMINAL, SerialPort, validate_identity


# Durations to time, in seconds of S18. Two points would give a slope; these
# give a slope and a residual, which is what says whether the relationship is
# actually linear rather than merely fitted.
DEFAULT_SECONDS = (2, 4, 8, 12)
# Repeats per duration. The quantity is a firmware timer, so the spread across
# repeats is the measurement error, and it belongs in the report.
DEFAULT_REPEATS = 3
# A test of n seconds cannot take longer than this to answer.
TIMEOUT_MARGIN = 8.0

S18_VALUE = re.compile(rb"[\r\n](\d{1,3})[\r\n]")

# S6 settings for the dial-tone wait. The emulator runs this same wait - the
# supervisor loads its countdown and spins until either the line detector
# qualifies or the count expires - so it is the one timer both halves can
# measure, which is the whole point of the exercise.
DEFAULT_DIAL_SECONDS = (2, 6, 10)


def _elapsed(port: SerialPort, command: str, timeout: float) -> tuple[float, bytes]:
    """Send one command and return how long the modem took to finish it."""
    start = time.monotonic()
    reply = port.query(command, timeout=timeout)
    return time.monotonic() - start, reply


def measure(port: SerialPort, seconds: tuple[int, ...], repeats: int) -> dict:
    """Time `&T1` at each `S18` setting, with the command overhead removed."""
    identity = port.query("ATI7", timeout=6.0)
    text, target = validate_identity(identity)

    # What a command costs when the modem does no work, so the loopback figures
    # measure the timer rather than the serial round trip.
    overheads = [_elapsed(port, "AT", 4.0)[0] for _ in range(5)]
    overhead = statistics.median(overheads)

    original = port.query("ATS18?", timeout=4.0)
    match = S18_VALUE.search(original)
    restore = int(match[1]) if match else None

    runs: list[dict] = []
    try:
        for value in seconds:
            port.query(f"ATS18={value}", timeout=4.0)
            for attempt in range(repeats):
                duration, reply = _elapsed(
                    port, "AT&T1", timeout=value + TIMEOUT_MARGIN
                )
                runs.append({
                    "s18": value,
                    "attempt": attempt,
                    "seconds": round(duration - overhead, 6),
                    "raw_seconds": round(duration, 6),
                    "reply": reply.decode("ascii", "replace"),
                })
    finally:
        # The loopback is stopped explicitly whatever happened, and S18 goes
        # back to what the board had.
        port.query("AT&T0", timeout=4.0)
        if restore is not None:
            port.query(f"ATS18={restore}", timeout=4.0)

    return {
        "identity": text,
        "target": {"supervisor": target[0], "dsp": target[1]},
        "command_overhead_seconds": round(overhead, 6),
        "s18_restored_to": restore,
        "runs": runs,
        "fit": _fit(runs),
    }


def _fit(runs: list[dict]) -> dict:
    """Least-squares seconds per S18 unit, plus the residual that tests it."""
    points = [(run["s18"], run["seconds"]) for run in runs]
    if len(points) < 2:
        return {}
    mean_x = statistics.fmean(x for x, _ in points)
    mean_y = statistics.fmean(y for _, y in points)
    variance = sum((x - mean_x) ** 2 for x, _ in points)
    if not variance:
        return {}
    slope = sum((x - mean_x) * (y - mean_y) for x, y in points) / variance
    intercept = mean_y - slope * mean_x
    residuals = [y - (slope * x + intercept) for x, y in points]
    return {
        "seconds_per_s18_unit": round(slope, 6),
        "intercept_seconds": round(intercept, 6),
        "worst_residual_seconds": round(max(abs(r) for r in residuals), 6),
        "samples": len(points),
    }


def measure_dial_wait(port: SerialPort, seconds: tuple[int, ...],
                      repeats: int) -> dict:
    """Time the dial-tone wait, which is the timer the emulator also runs.

    A bare `ATD` seizes the loop and dials nothing. With no dial tone present
    the supervisor waits out its S6 countdown and answers `NO DIAL TONE`, and
    the time between the command and that result is the countdown in seconds.

    This takes the loop off hook. With the line unplugged that is a relay and
    nothing else; with a line attached it is a brief seizure that dials no
    digits.
    """
    original = port.query("ATS6?", timeout=4.0)
    match = S18_VALUE.search(original)
    restore = int(match[1]) if match else None
    # X4 so the modem reports NO DIAL TONE rather than dialling blind.
    port.query("ATX4", timeout=4.0)

    runs: list[dict] = []
    try:
        for value in seconds:
            port.query(f"ATS6={value}", timeout=4.0)
            for attempt in range(repeats):
                start = time.monotonic()
                reply = port.query("ATD", timeout=value + TIMEOUT_MARGIN * 2,
                                   expect=CALL_TERMINAL)
                duration = time.monotonic() - start
                port.query("ATH0", timeout=4.0)
                runs.append({
                    "s6": value,
                    "attempt": attempt,
                    "seconds": round(duration, 6),
                    "reply": reply.decode("ascii", "replace"),
                })
    finally:
        port.query("ATH0", timeout=4.0)
        if restore is not None:
            port.query(f"ATS6={restore}", timeout=4.0)

    points = [(run["s6"], run["seconds"]) for run in runs]
    return {"runs": runs, "s6_restored_to": restore,
            "fit": _fit([{"s18": x, "seconds": y} for x, y in points])}


def main() -> int:
    parser = argparse.ArgumentParser(
        description="time a firmware second on the board, with no phone line"
    )
    parser.add_argument("--device", required=True)
    parser.add_argument(
        "--baud", type=int, choices=(9600, 19200, 38400, 57600, 115200), default=115200
    )
    parser.add_argument("--output", type=Path, required=True,
                        help="new directory for the raw replies and the report")
    parser.add_argument("--seconds", type=int, nargs="+", default=list(DEFAULT_SECONDS),
                        help="S18 settings to time (1..255)")
    parser.add_argument("--repeats", type=int, default=DEFAULT_REPEATS)
    parser.add_argument(
        "--dial-wait", action="store_true",
        help="also time the dial-tone wait, which is the timer the emulator "
        "runs too. Takes the loop off hook and dials no digits; run it with "
        "the phone line unplugged",
    )
    parser.add_argument("--dial-seconds", type=int, nargs="+",
                        default=list(DEFAULT_DIAL_SECONDS))
    args = parser.parse_args()

    if any(not 1 <= value <= 255 for value in args.seconds):
        raise SystemExit("S18 settings are 1..255")
    args.output.mkdir(parents=True, exist_ok=False)

    with SerialPort(args.device, args.baud, allow_timing=True,
                    allow_off_hook=args.dial_wait) as port:
        port.drain()
        report = measure(port, tuple(args.seconds), args.repeats)
        if args.dial_wait:
            report["dial_wait"] = measure_dial_wait(
                port, tuple(args.dial_seconds), args.repeats
            )

    (args.output / "report.json").write_text(
        json.dumps(report, indent=2, sort_keys=True) + "\n"
    )
    fit = report.get("fit", {})
    print(f"board: {report['target']['supervisor']} / {report['target']['dsp']}")
    print(f"command overhead: {report['command_overhead_seconds'] * 1000:.1f} ms")
    for run in report["runs"]:
        print(f"  S18={run['s18']:>3}  {run['seconds']:7.3f} s")
    if fit:
        print(f"\nseconds per S18 unit: {fit['seconds_per_s18_unit']:.4f}"
              f"  (intercept {fit['intercept_seconds']:+.3f} s,"
              f" worst residual {fit['worst_residual_seconds']:.3f} s)")
    dial = report.get("dial_wait")
    if dial:
        print("\ndial-tone wait:")
        for run in dial["runs"]:
            print(f"  S6={run['s6']:>3}  {run['seconds']:7.3f} s"
                  f"  {run['reply'].strip().splitlines()[-1:]}")
        dial_fit = dial.get("fit", {})
        if dial_fit:
            print(f"  seconds per S6 unit: {dial_fit['seconds_per_s18_unit']:.4f}"
                  f"  (intercept {dial_fit['intercept_seconds']:+.3f} s)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
