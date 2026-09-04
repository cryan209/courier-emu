from __future__ import annotations

import math
import unittest

from courier_emu.exchange import (
    DTMF_COLUMN_FREQUENCIES,
    DTMF_KEYS,
    DTMF_ROW_FREQUENCIES,
    EXCHANGE_SAMPLE_RATE,
    DtmfDecoder,
    LineExchange,
)


def dtmf(digit: str, milliseconds: int, rate: int = EXCHANGE_SAMPLE_RATE,
         level: int = 6_000) -> list[int]:
    index = DTMF_KEYS.index(digit)
    row = DTMF_ROW_FREQUENCIES[index // len(DTMF_COLUMN_FREQUENCIES)]
    column = DTMF_COLUMN_FREQUENCIES[index % len(DTMF_COLUMN_FREQUENCIES)]
    count = milliseconds * rate // 1_000
    return [
        round(
            level * math.sin(2 * math.pi * row * sample / rate)
            + level * math.sin(2 * math.pi * column * sample / rate)
        )
        for sample in range(count)
    ]


def silence(milliseconds: int, rate: int = EXCHANGE_SAMPLE_RATE) -> list[int]:
    return [0] * (milliseconds * rate // 1_000)


def dial(number: str, on_ms: int = 70, off_ms: int = 70) -> list[int]:
    samples: list[int] = []
    for digit in number:
        samples.extend(dtmf(digit, on_ms))
        samples.extend(silence(off_ms))
    return samples


def magnitude(samples: list[int], frequency: int,
              rate: int = EXCHANGE_SAMPLE_RATE) -> float:
    real = sum(
        sample * math.cos(2 * math.pi * frequency * index / rate)
        for index, sample in enumerate(samples)
    )
    imaginary = sum(
        sample * math.sin(2 * math.pi * frequency * index / rate)
        for index, sample in enumerate(samples)
    )
    return math.hypot(real, imaginary) / max(1, len(samples))


def peaks(samples: list[int], candidates: tuple[int, ...], count: int = 2) -> set[int]:
    scores = {frequency: magnitude(samples, frequency) for frequency in candidates}
    return set(sorted(scores, key=scores.get, reverse=True)[:count])  # type: ignore[arg-type]


TONE_CANDIDATES = (350, 440, 480, 620, 1_000, 2_100)


class DtmfDecoderTests(unittest.TestCase):
    def test_decodes_every_key(self) -> None:
        decoder = DtmfDecoder()
        found = "".join(
            decoder.feed(dtmf(key, 70) + silence(70)) for key in DTMF_KEYS
        )
        self.assertEqual(found, DTMF_KEYS)

    def test_repeated_digit_needs_a_gap(self) -> None:
        decoder = DtmfDecoder()
        self.assertEqual(decoder.feed(dtmf("5", 200)), "5")
        self.assertEqual(decoder.feed(dtmf("5", 200)), "")
        decoder.feed(silence(70))
        self.assertEqual(decoder.feed(dtmf("5", 70)), "5")

    def test_silence_and_single_tones_decode_to_nothing(self) -> None:
        decoder = DtmfDecoder()
        self.assertEqual(decoder.feed(silence(500)), "")
        single = [
            round(6_000 * math.sin(2 * math.pi * 697 * index / EXCHANGE_SAMPLE_RATE))
            for index in range(EXCHANGE_SAMPLE_RATE // 2)
        ]
        self.assertEqual(decoder.feed(single), "")

    def test_dial_tone_is_not_a_digit(self) -> None:
        # 350+440 Hz is two tones in the DTMF band shape but neither is a
        # row or column frequency; a receiver that keyed on "two tones"
        # would take it for a digit.
        decoder = DtmfDecoder()
        tone = [
            round(
                4_000 * math.sin(2 * math.pi * 350 * index / EXCHANGE_SAMPLE_RATE)
                + 4_000 * math.sin(2 * math.pi * 440 * index / EXCHANGE_SAMPLE_RATE)
            )
            for index in range(EXCHANGE_SAMPLE_RATE)
        ]
        self.assertEqual(decoder.feed(tone), "")


class LineExchangeTests(unittest.TestCase):
    def block(self, exchange: LineExchange, off_hook: bool,
              transmitted: list[int] | None = None,
              milliseconds: int | None = None) -> list[int]:
        count = None
        if milliseconds is not None:
            count = milliseconds * exchange.sample_rate // 1_000
        return exchange.service(off_hook, transmitted, count)

    def test_seizure_gives_precise_dial_tone(self) -> None:
        exchange = LineExchange()
        self.assertEqual(exchange.state, "idle")
        samples = self.block(exchange, True, milliseconds=200)

        self.assertEqual(exchange.state, "dial-tone")
        self.assertTrue(exchange.dial_tone_present)
        self.assertEqual(len(samples), 1_920)
        self.assertEqual(peaks(samples, TONE_CANDIDATES), {350, 440})

    def test_on_hook_line_is_silent(self) -> None:
        exchange = LineExchange()
        self.assertEqual(self.block(exchange, False, milliseconds=100), [0] * 960)
        self.assertEqual(exchange.state, "idle")

    def test_first_digit_removes_dial_tone(self) -> None:
        exchange = LineExchange()
        self.block(exchange, True, milliseconds=100)
        self.block(exchange, True, dtmf("5", 70))

        self.assertEqual(exchange.state, "collecting")
        self.assertEqual(exchange.dialed, "5")
        # Dial tone is gone the moment the first digit lands, which is the
        # transition the supervisor's dial callback is waiting on.
        self.assertFalse(exchange.dial_tone_present)
        self.assertEqual(self.block(exchange, True, silence(100)), [0] * 960)

    def test_dialed_number_is_decoded_from_the_line(self) -> None:
        exchange = LineExchange()
        self.block(exchange, True, milliseconds=100)
        self.block(exchange, True, dial("5551234"))

        self.assertEqual(exchange.dialed, "5551234")
        self.assertEqual(exchange.state, "collecting")

    def test_interdigit_timeout_routes_to_ringback_then_answer(self) -> None:
        exchange = LineExchange(answer_after_rings=1, answer_tone_ms=0)
        self.block(exchange, True, milliseconds=100)
        self.block(exchange, True, dial("123"))
        self.block(exchange, True, silence(4_000))

        self.assertEqual(exchange.outcome, "answer")
        self.assertIn(exchange.state, ("routing", "ringback"))
        self.block(exchange, True, milliseconds=1_000)
        self.assertEqual(exchange.state, "ringback")
        ring = self.block(exchange, True, milliseconds=500)
        self.assertEqual(peaks(ring, TONE_CANDIDATES), {440, 480})

        self.block(exchange, True, milliseconds=6_000)
        self.assertEqual(exchange.state, "connected")

    def test_directory_match_routes_without_waiting(self) -> None:
        exchange = LineExchange(directory={"5551212": "busy"})
        self.block(exchange, True, milliseconds=100)
        self.block(exchange, True, dial("5551212"))

        self.assertEqual(exchange.outcome, "busy")
        self.block(exchange, True, milliseconds=600)
        self.assertEqual(exchange.state, "busy")
        tone = self.block(exchange, True, milliseconds=250)
        self.assertEqual(peaks(tone, TONE_CANDIDATES), {480, 620})

    def test_answer_tone_precedes_the_connection(self) -> None:
        exchange = LineExchange(answer_after_rings=1, answer_tone_ms=1_000)
        self.block(exchange, True, milliseconds=100)
        self.block(exchange, True, dial("1#"))
        self.block(exchange, True, milliseconds=1_000)
        self.assertEqual(exchange.state, "ringback")
        self.block(exchange, True, milliseconds=6_100)
        self.assertEqual(exchange.state, "answer-tone")

        tone = self.block(exchange, True, milliseconds=200)
        self.assertEqual(
            max(TONE_CANDIDATES, key=lambda hz: magnitude(tone, hz)), 2_100
        )
        self.block(exchange, True, milliseconds=1_000)
        self.assertEqual(exchange.state, "connected")
        self.assertTrue(exchange.connected)

    def test_connected_call_carries_the_far_end(self) -> None:
        far = [1_234] * 960

        def peer(count: int, transmitted: list[int]) -> list[int]:
            return far[:count]

        exchange = LineExchange(
            answer_after_rings=1, answer_tone_ms=0, peer_audio=peer
        )
        self.block(exchange, True, milliseconds=100)
        self.block(exchange, True, dial("1#"))
        self.block(exchange, True, milliseconds=7_000)
        self.assertEqual(exchange.state, "connected")
        self.assertEqual(self.block(exchange, True, milliseconds=100), far)

    def test_hangup_returns_to_idle_and_a_new_seizure_starts_over(self) -> None:
        exchange = LineExchange()
        self.block(exchange, True, milliseconds=100)
        self.block(exchange, True, dial("911"))
        self.assertEqual(exchange.dialed, "911")

        # A break long enough to be neither a dial pulse nor a flash.
        self.block(exchange, False, milliseconds=2_000)
        self.assertEqual(exchange.state, "idle")
        self.assertEqual(exchange.dialed, "")

        self.block(exchange, True, milliseconds=100)
        self.assertEqual(exchange.state, "dial-tone")
        self.assertEqual(exchange.calls, 2)

    def test_permanent_off_hook_ends_in_reorder(self) -> None:
        exchange = LineExchange(first_digit_ms=1_000)
        self.block(exchange, True, milliseconds=100)
        self.block(exchange, True, milliseconds=1_100)

        self.assertEqual(exchange.state, "reorder")
        tone = self.block(exchange, True, milliseconds=125)
        self.assertEqual(peaks(tone, TONE_CANDIDATES), {480, 620})

    def test_incoming_call_rings_until_the_modem_answers(self) -> None:
        exchange = LineExchange(ring_on_ms=200, ring_off_ms=400)
        exchange.ring("5551000")
        self.assertEqual(exchange.state, "ringing")

        self.block(exchange, False, milliseconds=100)
        self.assertTrue(exchange.ringing)
        self.block(exchange, False, milliseconds=200)
        self.assertFalse(exchange.ringing)

        self.block(exchange, True, milliseconds=100)
        self.assertEqual(exchange.state, "connected")
        self.assertFalse(exchange.ringing)

    def test_pulse_dialing_at_a_resolving_block_size(self) -> None:
        exchange = LineExchange()
        self.block(exchange, True, milliseconds=200)

        def pulse(count: int) -> None:
            for _ in range(count):
                self.block(exchange, False, milliseconds=60)
                self.block(exchange, True, milliseconds=40)

        pulse(3)
        self.block(exchange, True, milliseconds=400)
        pulse(10)
        self.block(exchange, True, milliseconds=400)

        self.assertEqual(exchange.dialed, "30")
        self.assertEqual(exchange.state, "collecting")

    def test_line_state_tracks_the_daa_vocabulary(self) -> None:
        exchange = LineExchange()
        self.assertEqual(exchange.line_state, "quiet")
        self.block(exchange, True, milliseconds=100)
        self.assertEqual(exchange.line_state, "dial-tone")
        self.block(exchange, True, dial("1#"))
        self.assertEqual(exchange.line_state, "quiet")

    def test_status_reports_the_call(self) -> None:
        exchange = LineExchange(directory={"1": "reorder"})
        self.block(exchange, True, milliseconds=100)
        self.block(exchange, True, dial("1"))
        status = exchange.status()

        self.assertEqual(status["dialed"], "1")
        self.assertEqual(status["outcome"], "reorder")
        self.assertEqual(status["digits_decoded"], "1")
        self.assertTrue(status["off_hook"])
        self.assertGreater(status["samples_sent"], 0)

    def test_invalid_outcome_is_rejected(self) -> None:
        with self.assertRaises(ValueError):
            LineExchange(default_outcome="ring")
        with self.assertRaises(ValueError):
            LineExchange(directory={"1": "answered"})


if __name__ == "__main__":
    unittest.main()
