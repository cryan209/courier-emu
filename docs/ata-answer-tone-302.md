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

Both are now located in the firmware. See
[the generators](#the-generators-and-what-arms-them) below.

## The generators, and what arms them

3.0.13 relocates 3.1.2's oscillator family but **keeps the same data cells**,
which is why the two agree even though `dsp-map-302.md` warns that the mailbox
cells differ. The mixer at `80e0`/`80e4` calls whatever sits in `@1a`/`@1b`
(`0x39a`/`0x39b` at DP 7), exactly as 3.1.2's does.

| role | 3.1.2 | 3.0.13 |
|---|---|---|
| arm routine | `86d1` | `86dc` |
| one oscillator | `874f` | `875a` |
| pair oscillator | `8743` | `874e` |
| phase reversals | `8739` | `8744` |
| ANSam (15.05 Hz AM) | `8712` / `8716` / `8718` | `871d` / `8721` / `8723` |

Cells, identical in both: increment `0x3f2`, amplitude `0x3f3`, phase `0x3c0`,
output `0x3c7`.

### ANSam, at `0x9f62`

The direct analogue of 3.1.2's `9f40`, with the same constants:

```text
9f64: lacc #4aab          ; 2100.04 Hz at 7200
9f66: call 86dc
9f6a: splk @75, #0ca7     ; 3239 samples = 449.9 ms reversal
9f70: splk @1a, #8744     ; reversals
9f77: splk @1a, #8721     ; ANSam
9f7a: splk @1a, #871d     ; ANSam
9f7c: splk @73, #06cf
```

`8723` loads increment `0x0089` - 15.05 Hz - and multiplies the carrier by it.
At runtime `0x3c0` advances by `0x4aab` per sample and `0x3f4` by `0x0089`.

### The 2250 Hz tone, at `0xd354`, reached from `0x9ffc`

```text
9ffa: splk @2b, #0096     ; state timer
9ffc: call d354
      d354: lacc #5000    ; 0x5000/65536*7200 = 2250.00 Hz exactly
      d356: b    86dc     ; a tail-call - see below
```

`86dc` then stores the increment at `0x3f2`, installs the **plain** oscillator
`875a` in the callback slot, sets the amplitude to its own literal `0x0898`,
and clears the phase.

Two things are worth recording. First, `d354` ends in `b 86dc`, not
`call 86dc`; a search for calls to the arm routine finds the five literal
callers (375, 600, 1650, 2025 and 2100 Hz) and **misses this one entirely**.
Searching for every word equal to `86dc` is what found it.

Second, this corrects an earlier guess in this repository's history. A cell at
`0x3ef` was seen advancing by `0x5555` and read as a 2400 Hz carrier, which
suggested the tone was V.22's carrier rotated 90 degrees per symbol. That was
wrong: `0x3ee:0x3ef` is a *32-bit* accumulator (`d901`) advanced by
`0x01555555`, and `0x5555` is merely its low half's delta. The tone is a plain
oscillator, generated directly.

So the *signal* is what V.22 unscrambled binary 1 looks like on the line -
2400 Hz less 150 Hz, which is 90 degrees per symbol at 600 baud - but the
*implementation* is a single tone, not a running modulator.

### Confirmed at runtime

Mid-burst the emulator shows `0x3f2 = 0x5000`, `0x3f3 = 0x0898` and
`0x39a = 0x875a`: the increment, the arm routine's own amplitude literal, and
the plain oscillator. Static and dynamic agree.

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
* **Not a located caller for every path.** The oscillators and their arming
  sites are located above; what reaches `0x9ffc` and `0x9f62` in this image is
  followed only as far as the state timer. The equivalent walk *has* been done
  on 3.1.2 - see [the path to `9f40`](answer-tone.md#the-path-to-9f40), which
  finds the same one-shot scheduler (`@6d` the state vector, `@6e` the
  countdown) that 3.0.13 runs at `8767`.
* **Not a completed handshake.** Two tones went out. Nothing here shows a
  far end answering them or a carrier training.
