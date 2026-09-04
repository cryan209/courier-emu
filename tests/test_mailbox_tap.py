"""The mailbox tap reconstructs messages from raw port writes.

The reconstruction is the part worth pinning: the supervisor sends a two-word
message as tag on `0x58`/`0x5a` then argument on `0x5c`/`0x5e`, and a one-word
message as `0x58`/`0x5a` alone, so the only way to tell them apart is to notice
a second header arriving with no argument in between. These tests drive that
state machine directly, and check the tone scoring against a synthesized DTMF
digit rather than a real run.
"""
from __future__ import annotations

import math

from courier_emu.mailbox_tap import (
    LINE_RATE,
    MailboxTap,
    goertzel,
)


class FakeCore:
    """Serves line-transmit samples from an absolute index, as the C52 core does."""

    def __init__(self, samples: list[int] | None = None) -> None:
        self.samples = samples or []

    def line_tx_samples(self, start: int) -> list[int]:
        return self.samples[start:]


class FakeBridge:
    def __init__(self, core: FakeCore | None = None, active: bool = True) -> None:
        self.core = core or FakeCore()
        self.active = active          # False while the ports are the loader window
        self.writes: list[tuple[int, int, int, int | None]] = []

    def write(self, port: int, size: int, value: int, pc: int | None = None) -> None:
        self.writes.append((port, size, value, pc))


def send_pair(bridge: FakeBridge, tag: int, argument: int, pc: int = 0xF531) -> None:
    bridge.write(0x58, 1, tag & 0xFF, pc)
    bridge.write(0x5A, 1, tag >> 8, pc)
    bridge.write(0x5C, 1, argument & 0xFF, pc)
    bridge.write(0x5E, 1, argument >> 8, pc)


def send_word(bridge: FakeBridge, word: int, pc: int = 0xFDE1) -> None:
    bridge.write(0x58, 1, word & 0xFF, pc)
    bridge.write(0x5A, 1, word >> 8, pc)


def test_two_word_message_is_reconstructed():
    bridge = FakeBridge()
    with MailboxTap(bridge) as tap:
        send_pair(bridge, 0x0030, 0x0001)
    (message,) = tap.messages
    assert (message.tag, message.argument) == (0x30, 0x0001)
    assert message.kind == "tag+arg"
    assert message.dispatchable


def test_one_word_send_is_distinguished_by_the_next_header():
    bridge = FakeBridge()
    with MailboxTap(bridge) as tap:
        send_word(bridge, 0x1616)
        send_pair(bridge, 0x0012, 0x2E38)
    kinds = [(m.tag, m.argument, m.kind) for m in tap.messages]
    assert kinds == [
        (0x1616, None, "one-word"),
        (0x0012, 0x2E38, "tag+arg"),
    ]


def test_trailing_one_word_send_is_flushed_on_exit():
    bridge = FakeBridge()
    with MailboxTap(bridge) as tap:
        send_pair(bridge, 0x0021, 0x0007)
        send_word(bridge, 0x00FF)
    assert [m.kind for m in tap.messages] == ["tag+arg", "one-word"]


def test_tag_above_7f_is_not_dispatchable():
    """The DSP dispatcher rejects any tag above 0x7f (`sub #7f ; retc gt`)."""
    bridge = FakeBridge()
    with MailboxTap(bridge) as tap:
        send_pair(bridge, 0x0080, 0x0000)
        send_pair(bridge, 0x007F, 0x0000)
    assert [m.dispatchable for m in tap.messages] == [False, True]


def test_the_tap_passes_every_write_through_unchanged():
    bridge = FakeBridge()
    with MailboxTap(bridge):
        send_pair(bridge, 0x0030, 0x0001)
        bridge.write(0x18, 1, 0x04, None)
    assert bridge.writes == [
        (0x58, 1, 0x30, 0xF531),
        (0x5A, 1, 0x00, 0xF531),
        (0x5C, 1, 0x01, 0xF531),
        (0x5E, 1, 0x00, 0xF531),
        (0x18, 1, 0x04, None),
    ]


def test_detach_stops_recording_and_leaves_no_shadowing_attribute():
    bridge = FakeBridge()
    tap = MailboxTap(bridge).attach()
    assert "write" in vars(bridge)          # ours is installed
    send_pair(bridge, 0x0030, 0x0001)
    tap.detach()
    assert "write" not in vars(bridge)      # class method is exposed again
    send_pair(bridge, 0x0031, 0x0002)       # no longer observed
    assert [m.tag for m in tap.messages] == [0x30]
    assert len(bridge.writes) == 8          # but the bridge still saw them all


def dtmf(digit_low: int, digit_high: int, count: int, amplitude: int = 8000) -> list[int]:
    return [
        int(
            amplitude / 2 * math.sin(2 * math.pi * digit_low * n / LINE_RATE)
            + amplitude / 2 * math.sin(2 * math.pi * digit_high * n / LINE_RATE)
        )
        for n in range(count)
    ]


def test_goertzel_finds_a_synthesized_tone():
    samples = dtmf(697, 1209, 512)
    assert goertzel(samples, 697) > 10 * goertzel(samples, 941)
    assert goertzel(samples, 1209) > 10 * goertzel(samples, 1633)


def test_a_message_followed_by_dtmf_is_attributed_that_digit():
    """A digit '1' (697+1209 Hz) placed after the message must be read back."""
    core = FakeCore()
    bridge = FakeBridge(core)
    with MailboxTap(bridge) as tap:
        core.samples = [0] * 64
        send_pair(bridge, 0x0021, 0x0031)
        core.samples = core.samples + dtmf(697, 1209, 1024)
    verdict = tap.verdict(tap.messages[0])
    assert verdict.dtmf == "1"
    assert verdict.rms > 100


def test_silence_after_a_message_reports_no_tone():
    core = FakeCore()
    bridge = FakeBridge(core)
    with MailboxTap(bridge) as tap:
        send_pair(bridge, 0x0030, 0x0000)
        core.samples = [0] * 1024
    verdict = tap.verdict(tap.messages[0])
    assert verdict.dtmf is None
    assert verdict.rms == 0.0


def test_report_and_rollup_mention_every_tag():
    core = FakeCore()
    bridge = FakeBridge(core)
    with MailboxTap(bridge) as tap:
        send_pair(bridge, 0x0030, 0x0001)
        core.samples = dtmf(770, 1336, 1024)
        send_pair(bridge, 0x0021, 0x0032)
        send_pair(bridge, 0x0021, 0x0033)
    summary = tap.tag_summary()
    assert summary["0x0021"]["count"] == 2
    assert summary["0x0021"]["arguments"] == ["0x0032", "0x0033"]
    text = tap.report()
    assert "0x0030" in text and "0x0021" in text and "per-tag rollup" in text


def test_writes_are_ignored_while_the_ports_are_the_loader_window():
    """0x58-0x5e carry the download until the bridge goes active.

    Without this gate the tap records the datapump program as mailbox traffic:
    an untapped ATDT run showed 3542 "messages" whose tags were C5x opcodes.
    """
    bridge = FakeBridge(active=False)
    with MailboxTap(bridge) as tap:
        send_pair(bridge, 0xBE42, 0xBF09)     # C5x opcodes, not a message
        send_pair(bridge, 0x7A80, 0x8138)
    assert tap.messages == []
    assert len(bridge.writes) == 8            # still passed through


def test_a_header_started_before_going_active_is_discarded():
    bridge = FakeBridge(active=False)
    with MailboxTap(bridge) as tap:
        bridge.write(0x58, 1, 0x42, None)     # loader byte
        bridge.active = True
        send_pair(bridge, 0x0021, 0x0031)
    assert [(m.tag, m.argument) for m in tap.messages] == [(0x21, 0x31)]
