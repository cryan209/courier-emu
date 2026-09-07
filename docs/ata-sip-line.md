# A loop in front of the SIP instrument

[answer-tone.md](answer-tone.md) and [fsk-modulation.md](fsk-modulation.md)
get the datapump to emit its own signals; [audio-312-path.md](audio-312-path.md)
gets it to dial. All of that lands in a sample buffer with nowhere to go. This
connects it to a real network: `courier_emu.ata.SipLine` puts the modelled
subscriber loop between the modem and a `SipSession`, so a number the firmware
dials in tones becomes an INVITE.

There are two parts, and the first is what makes the second work.

## Rate adaptation: the dial path is 7200 Hz and RTP is 8000

`sip.RateConverter` was a zero-order hold, written for the exact 6:5 of the
codec's 9600 against G.711's 8000. It repeats or drops samples, which leaves
the image of everything it passes. At 7200 that is not a detail: the hold's
images of the DTMF column tones land in the band a far-end receiver listens in.

`sip.PolyphaseResampler` is the textbook rational resampler instead - upsample
by L, low-pass at the lower of the two Nyquists with a Blackman-windowed sinc,
decimate by M, evaluating only the taps that meet a non-zero sample. Each
phase's taps are normalised to sum to one, so DC gain is exactly unity on every
phase and the phase rotation itself adds no ripple.

Measured on the firmware's own rendering of `6245`
(`artifacts/dtmf-emulator-302-01/`, rendered through `courier_emu.audio312`),
inside the first digit, worst out-of-band bin against the peak:

| 7200 -> 8000 | worst spurious |
|---|---|
| `RateConverter` (hold) | -11.7 dB |
| `PolyphaseResampler` | -27.0 dB |

The remaining -27 dB is the tone's own harmonic content, not the resampler.
`bridge.py`'s SIP path now uses it in both directions as well.

## The loop: what `LineExchange` was missing

`LineExchange` already models everything on the loop side - hook, dial tone,
in-band DTMF collection, ringback and busy cadences, and the audio path once a
call is up. Its docstring already called itself a digital ATA. What it did not
have was a far end: `directory` decided the outcome of a number before the call
was placed, and its ringback was a timer counting to `answer_after_rings`.

Three additions give it a real one, and they are additive - the directory still
works when no router is set:

* `router(number) -> str | None` supplies the outcome when collection ends.
  Returning `None` means *still setting up*: the exchange holds silently in
  `routing` rather than routing on a guess.
* `set_outcome(outcome)` resolves that hold later, from whatever was doing the
  real work.
* `answer()` is a far end picking up on its own authority rather than on a ring
  count.

`SipSession` gained `hangup()` to match: BYE for an established dialogue,
CANCEL for one still being set up - carrying the INVITE's own branch and CSeq,
which is the one request that must - leaving the session usable for the next
call instead of tearing down its sockets.

## What `SipLine` does with them

| loop side | network side |
|---|---|
| digits decoded off the line | `start_call(number)`, outcome pending |
| `ringback` | 180 Ringing |
| `connected` | 200 OK, `answer()` |
| `busy` | 486 or 600 |
| `reorder` | any other failure |
| on-hook | `hangup()` - BYE or CANCEL |
| `released` | far end's BYE |

Audio crosses at `peer_audio`, resampled both ways. The modem learns none of
it: it seizes a loop, hears dial tone, dials, and hears ringback.

## Verified

`tests/test_ata.py` runs the whole chain over real UDP sockets against a mock
PBX. Dialling `6245` in-band at 7200 Hz walks
`dial-tone -> collecting -> routing -> ringback -> connected`, produces
`INVITE sip:6245@...`, and puts the far end's 1000 Hz tone on the loop more
than 20 dB above its neighbouring bin while the loop's own audio arrives at the
PBX as RTP. On-hook sends BYE; a 486 gives the loop busy tone.

The one thing not shown here is the modem itself driving it. That needs the
board or the bridge in the loop, and the seam it would attach at -
`bridge.py`'s `exchange` - takes a `LineExchange`, which is exactly what
`SipLine` owns and configures.
