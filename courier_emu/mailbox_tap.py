"""Record host->DSP mailbox messages and correlate them with line audio.

The point of this tool is to identify, empirically, which mailbox tags make the
datapump emit which tones, without reverse-engineering the handlers first.

What the supervisor does (see `courier_firmware_analysis.md`, "How the DSP is
loaded and run"): a host->DSP message is built by the routine at file `0xf678`
in the 7.4.16 capture, which enqueues three words - `0xff00`, a tag, then an
argument - into a 24-word ring. The ring's consumer takes the `0xff00` as a
frame marker and never transmits it; it selects a two-word drainer that puts the
tag on ports `0x58`/`0x5a` and the argument on `0x5c`/`0x5e`. Traffic whose high
byte is not `0xff` is sent one word at a time through `0x58`/`0x5a` alone. The
tag is the DSP's dispatch index: its handler is `program[table + tag]`, and the
dispatcher rejects any tag above `0x7f`.

So a tap on those four ports sees the entire host->DSP control surface, and this
module reconstructs messages from raw port writes rather than trusting a pairing
rule - that is what lets it tell a one-word send from a two-word one.

The audio side is the C52's transmitted line waveform, `core.line_tx_samples`,
which is where the resident `OUT` at program `0x8c24` lands. For each message
the tap scores the samples that follow it against the DTMF and call-progress
frequencies, so a run of `ATDT123` should attribute three DTMF pairs to whatever
tags actually carried them.

Correlation is temporal, not causal: a tone that begins near a message is
evidence about that message, not proof. Tags that always precede the same tone
across several runs are the ones worth believing.
"""
from __future__ import annotations

from collections import deque
from dataclasses import dataclass, field
import json
import math
from pathlib import Path
from typing import Any, Callable, Iterable

# The mailbox windows the supervisor's queue consumer writes.
TAG_PORTS = (0x58, 0x5A)
VALUE_PORTS = (0x5C, 0x5E)
MAILBOX_PORTS = (*TAG_PORTS, *VALUE_PORTS)

# The DSP dispatcher's own bound: `sub #7f ; retc gt`.
MAX_TAG = 0x7F

# The codec rate the resident service slot runs at.
LINE_RATE = 9_600

# Enough samples to resolve a DTMF pair; a real digit is far longer.
DEFAULT_WINDOW = 512

DTMF_LOW = (697, 770, 852, 941)
DTMF_HIGH = (1209, 1336, 1477, 1633)
DTMF_DIGITS = (
    ("1", 697, 1209), ("2", 697, 1336), ("3", 697, 1477), ("A", 697, 1633),
    ("4", 770, 1209), ("5", 770, 1336), ("6", 770, 1477), ("B", 770, 1633),
    ("7", 852, 1209), ("8", 852, 1336), ("9", 852, 1477), ("C", 852, 1633),
    ("*", 941, 1209), ("0", 941, 1336), ("#", 941, 1477), ("D", 941, 1633),
)
# Call-progress and negotiation tones this firmware is known to care about.
PROGRESS = {
    350: "dial-tone-low", 440: "dial-tone-high/ringback-low",
    480: "ringback-high/busy-low", 620: "busy-high",
    980: "v21-mark", 1180: "v21-space",
    1300: "calling-tone", 1875: "answer-carrier", 2100: "ansam",
}
PROBE_FREQUENCIES = tuple(sorted({*DTMF_LOW, *DTMF_HIGH, *PROGRESS}))


def goertzel(samples: list[int], frequency: float, rate: int = LINE_RATE) -> float:
    """Return the magnitude of one frequency, normalized by sample count."""
    if not samples:
        return 0.0
    omega = 2 * math.pi * frequency / rate
    cosine, sine = math.cos(omega), math.sin(omega)
    coefficient = 2 * cosine
    first = second = 0.0
    for sample in samples:
        current = sample + coefficient * first - second
        second, first = first, current
    real = first - second * cosine
    imaginary = second * sine
    return math.hypot(real, imaginary) / len(samples)


def rms(samples: list[int]) -> float:
    if not samples:
        return 0.0
    return math.sqrt(sum(sample * sample for sample in samples) / len(samples))


@dataclass
class MailboxMessage:
    """One reconstructed host->DSP message."""

    sequence: int
    tag: int
    argument: int | None          # None for a one-word send
    pc: int | None                # supervisor PC that wrote the committing port
    sample_index: int             # line-audio sample count when it completed

    @property
    def kind(self) -> str:
        return "one-word" if self.argument is None else "tag+arg"

    @property
    def dispatchable(self) -> bool:
        """Whether the DSP dispatcher would accept this as a command tag."""
        return self.argument is not None and self.tag <= MAX_TAG

    def as_dict(self) -> dict[str, Any]:
        return {
            "sequence": self.sequence,
            "tag": f"{self.tag:#06x}",
            "argument": None if self.argument is None else f"{self.argument:#06x}",
            "kind": self.kind,
            "dispatchable": self.dispatchable,
            "pc": None if self.pc is None else f"{self.pc:05x}",
            "sample_index": self.sample_index,
        }


@dataclass
class ToneVerdict:
    """What the line was doing just after a message."""

    samples: int
    rms: float
    peaks: list[tuple[int, float]]
    dtmf: str | None
    progress: list[str]

    def as_dict(self) -> dict[str, Any]:
        return {
            "samples": self.samples,
            "rms": round(self.rms, 1),
            "peaks": [[hz, round(mag, 1)] for hz, mag in self.peaks],
            "dtmf": self.dtmf,
            "progress": self.progress,
        }


class MailboxTap:
    """Watch the mailbox ports on a `DspBridge` and keep the line audio beside it.

    Attaching wraps the bridge's `write`; it adds no behaviour, so a tapped run
    executes exactly the untapped one. Call `poll()` from the run loop (or rely
    on the drain each message performs) so the audio buffer keeps up with the
    core, which serves samples from an index rather than holding them forever.
    """

    def __init__(self, bridge: Any, *, keep_samples: int = 1 << 20) -> None:
        self.bridge = bridge
        self.messages: list[MailboxMessage] = []
        self._samples: deque[int] = deque(maxlen=keep_samples)
        self._samples_base = 0          # absolute index of _samples[0]
        self._next_sample = 0           # absolute count drained so far
        self._header: int | None = None
        self._header_pc: int | None = None
        self._value = 0
        self._original_write: Callable[..., None] | None = None
        # Whether `write` was an instance attribute before attaching. If it was
        # not, detaching must delete ours so lookup falls back to the class
        # rather than leaving a bound method shadowing it.
        self._write_was_own = False

    # -- attach / detach ------------------------------------------------

    def attach(self) -> "MailboxTap":
        if self._original_write is not None:
            return self
        original = self.bridge.write

        def write(port: int, size: int, value: int, pc: int | None = None) -> None:
            self._observe(port, size, value, pc)
            return original(port, size, value, pc)

        self._original_write = original
        self._write_was_own = "write" in vars(self.bridge)
        self.bridge.write = write  # type: ignore[method-assign]
        return self

    def detach(self) -> None:
        if self._original_write is None:
            return
        if self._write_was_own:
            self.bridge.write = self._original_write  # type: ignore[method-assign]
        else:
            del self.bridge.write  # type: ignore[attr-defined]
        self._original_write = None

    def __enter__(self) -> "MailboxTap":
        return self.attach()

    def __exit__(self, *exc: object) -> None:
        self.flush()
        self.detach()

    # -- audio ----------------------------------------------------------

    def poll(self) -> int:
        """Drain any new line-transmit samples. Returns how many were taken."""
        core = getattr(self.bridge, "core", None)
        if core is None or not hasattr(core, "line_tx_samples"):
            return 0
        try:
            fresh = core.line_tx_samples(self._next_sample)
        except (RuntimeError, ValueError):
            return 0
        if not fresh:
            return 0
        dropped = max(0, (len(self._samples) + len(fresh)) - (self._samples.maxlen or 0))
        self._samples.extend(fresh)
        self._samples_base += dropped
        self._next_sample += len(fresh)
        return len(fresh)

    def _window(self, start: int, length: int) -> list[int]:
        """Absolute sample range, clipped to what is still buffered."""
        first = max(0, start - self._samples_base)
        return list(self._samples)[first : first + length]

    # -- message reconstruction -----------------------------------------

    def _observe(self, port: int, size: int, value: int, pc: int | None) -> None:
        if port not in MAILBOX_PORTS or size != 1:
            return
        value &= 0xFF
        if port == 0x58:
            # A pending header with no argument was a one-word send.
            if self._header is not None:
                self._emit(self._header, None, self._header_pc)
            self._header = value
            self._header_pc = pc
        elif port == 0x5A:
            if self._header is None:
                self._header = 0
            self._header |= value << 8
            self._header_pc = pc
        elif port == 0x5C:
            self._value = value
        else:  # 0x5E commits the pair
            self._value |= value << 8
            if self._header is not None:
                self._emit(self._header, self._value, pc)
                self._header = None
            self._value = 0

    def _emit(self, tag: int, argument: int | None, pc: int | None) -> None:
        self.poll()
        self.messages.append(
            MailboxMessage(
                sequence=len(self.messages),
                tag=tag & 0xFFFF,
                argument=argument,
                pc=pc,
                sample_index=self._next_sample,
            )
        )
        self._header_pc = None

    def flush(self) -> None:
        """Emit a header left pending at the end of a run."""
        self.poll()
        if self._header is not None:
            self._emit(self._header, None, self._header_pc)
            self._header = None

    # -- analysis --------------------------------------------------------

    def verdict(self, message: MailboxMessage, window: int = DEFAULT_WINDOW) -> ToneVerdict:
        samples = self._window(message.sample_index, window)
        level = rms(samples)
        magnitudes = {hz: goertzel(samples, hz) for hz in PROBE_FREQUENCIES}
        peaks = sorted(magnitudes.items(), key=lambda item: -item[1])[:4]
        floor = max(level * 0.30, 1.0)
        strong = {hz for hz, magnitude in magnitudes.items() if magnitude >= floor}
        digit = next(
            (name for name, low, high in DTMF_DIGITS if low in strong and high in strong),
            None,
        )
        progress = [PROGRESS[hz] for hz in sorted(strong) if hz in PROGRESS]
        return ToneVerdict(len(samples), level, peaks, digit, progress)

    def correlate(self, window: int = DEFAULT_WINDOW) -> list[dict[str, Any]]:
        rows = []
        for message in self.messages:
            row = message.as_dict()
            row["audio"] = self.verdict(message, window).as_dict()
            rows.append(row)
        return rows

    def tag_summary(self, window: int = DEFAULT_WINDOW) -> dict[str, dict[str, Any]]:
        """Per-tag rollup: how often it appeared and what followed it."""
        summary: dict[str, dict[str, Any]] = {}
        for message in self.messages:
            verdict = self.verdict(message, window)
            key = f"{message.tag:#06x}"
            entry = summary.setdefault(
                key,
                {
                    "tag": key,
                    "kind": message.kind,
                    "dispatchable": message.dispatchable,
                    "count": 0,
                    "arguments": [],
                    "first_pc": None if message.pc is None else f"{message.pc:05x}",
                    "dtmf": [],
                    "progress": [],
                    "peak_rms": 0.0,
                },
            )
            entry["count"] += 1
            if message.argument is not None and len(entry["arguments"]) < 12:
                argument = f"{message.argument:#06x}"
                if argument not in entry["arguments"]:
                    entry["arguments"].append(argument)
            if verdict.dtmf and verdict.dtmf not in entry["dtmf"]:
                entry["dtmf"].append(verdict.dtmf)
            for name in verdict.progress:
                if name not in entry["progress"]:
                    entry["progress"].append(name)
            entry["peak_rms"] = round(max(entry["peak_rms"], verdict.rms), 1)
        return summary

    # -- reporting -------------------------------------------------------

    def report(self, window: int = DEFAULT_WINDOW) -> str:
        lines = [
            f"{len(self.messages)} mailbox messages, "
            f"{self._next_sample} line-transmit samples at {LINE_RATE} Hz",
            "",
            f"{'seq':>4} {'tag':>7} {'arg':>7} {'kind':>8} {'pc':>6} "
            f"{'sample':>8} {'rms':>7}  tone",
        ]
        for message in self.messages:
            verdict = self.verdict(message, window)
            tone = verdict.dtmf or ",".join(verdict.progress) or "-"
            if verdict.rms < 1.0:
                tone = "silent"
            lines.append(
                f"{message.sequence:>4} {message.tag:#07x} "
                f"{'-' if message.argument is None else f'{message.argument:#07x}':>7} "
                f"{message.kind:>8} {'-' if message.pc is None else f'{message.pc:05x}':>6} "
                f"{message.sample_index:>8} {verdict.rms:>7.1f}  {tone}"
            )
        summary = self.tag_summary(window)
        if summary:
            lines += ["", "per-tag rollup:"]
            for key in sorted(summary, key=lambda k: -summary[k]["count"]):
                entry = summary[key]
                tone = ",".join(entry["dtmf"] + entry["progress"]) or "-"
                lines.append(
                    f"  {entry['tag']:>7} x{entry['count']:<4d} "
                    f"{'dispatchable' if entry['dispatchable'] else 'raw-word':>12}  "
                    f"peak-rms {entry['peak_rms']:>7.1f}  args "
                    f"{','.join(entry['arguments']) or '-':<28s} {tone}"
                )
        return "\n".join(lines)

    def write_json(self, path: str | Path, window: int = DEFAULT_WINDOW) -> Path:
        target = Path(path)
        target.write_text(
            json.dumps(
                {
                    "line_rate": LINE_RATE,
                    "window": window,
                    "samples": self._next_sample,
                    "messages": self.correlate(window),
                    "tags": self.tag_summary(window),
                },
                indent=2,
            )
            + "\n"
        )
        return target
