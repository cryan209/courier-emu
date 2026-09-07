# ATA on 3.0.13: the datapump's answer voice, end to end

[answer-tone.md](answer-tone.md) established that DSP **3.1.2** carries a family
of oscillator callbacks - a plain 2100 Hz tone, one with 450 ms phase reversals,
and one with 15 Hz amplitude modulation - and rendered all three through the
firmware's own mixer and serial ISR. What it could not show was the supervisor
*deciding* to send one:

> **Not the supervisor's decision to send it.** `9f40` is reached from a state
> machine this harness does not run.

That gap is now closed on **3.0.13**, in the full emulator, with no component
harness and no fixtures. `ATA` on `IDSDL302.ROM` puts two tones on the line.

## What comes out

Captured with `--dsp-tx-pcm`, after the harness tone generator was deleted
(commit `797ed28`), so the C52 program is the only thing that can have produced
them. Saved in `artifacts/ata-answer-tone-302-01/`.

| burst | onset | length | measured | identification |
|---|---|---|---|---|
| 1 | 2.49 s | 3.29 s | 2100 Hz +/- 1.5, sidebands at +/-15.05 Hz near 10% | **V.8 ANSam** |
| 2 | 5.83 s | 1.49 s | 2250.00 Hz, no sidebands | consistent with **V.22/V.22bis unscrambled binary 1** |

The ANSam identification is firm. The carrier sits within 1.2 Hz of 2100, the
first-order sidebands are the 15.05 Hz modulation, and the second-order pair is
down at 1%. It agrees with the 3.1.2 answer tone rendered at component level in
`artifacts/answer-tone-01` (sidebands 0.101 / 0.100) - and that agreement is
worth something, because these are **different images with different code**.
None of 3.1.2's oscillator addresses hold the same words in 3.0.13, so this is
not the same routine measured twice.

The 2250 Hz burst is an identification against the standard, **not a firmware
attribution**. V.22's channel 2 carrier is 2400 Hz and unscrambled binary 1 is
150 Hz below it, which is exactly what was measured; but the 3.0.13 code that
arms it has not been located, and nothing here traces it.

## It is the ATA handler, not the scenario

The sequence reproduces across two different line models - `--exchange-hotline`
and `--ring` - at the same onsets, durations and levels. The 2250 Hz burst is
**byte-identical** between the two runs. So it belongs to the supervisor's
answer path rather than to either seizure.

## The harness cannot yet ring the exchange

Neither run is a true exchange-side answer, and this is a harness limitation
worth recording before someone reads `daa.operation` and concludes the firmware
originated.

`--ring` builds a `RingSource` that drives the ring detector bit at input port
`0x14` (`machine.py`, `RING_DETECT_PORT`). It does **not** put `LineExchange`
into `ringing`; the only caller of `exchange.ring()` is the SIP inbound path in
`ata.py`. `CourierDspBridge.set_line_hook` decides the seizure with

```python
answering = self.exchange is not None and self.exchange.state == "ringing"
```

so every CLI seizure is labelled `originate`, whatever the detector says. The
supervisor obeyed `ATA` and armed these tones regardless, which is why the
capture is still meaningful - but a genuine answer-side run needs `--line-link`
with a paired instance, or an exchange the CLI can ring directly.

## What this does not show

* **Not hardware.** The codec, ASIC transport and line are models. No board was
  measured.
* **Not a located generator.** The 3.0.13 oscillator, its arming site, and the
  supervisor state that reaches it are all unlocated. This documents what the
  line carries, not which instructions put it there.
* **Not a completed handshake.** Two tones went out. Nothing here shows a
  far end answering them or a carrier training.
