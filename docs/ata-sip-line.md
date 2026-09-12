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

## In the bridge: ATDT6245 places the call

`CourierDspBridge` builds a `SipLine` whenever it is given both an exchange
and a SIP session, and the loop then owns the call. Four paths that used to
run beside the exchange are skipped while it does, because the loop already
carries them:

* `begin_dialing`'s `start_call`, which took the number from the parsed AT
  command rather than from the line.
* `set_call_progress`, which drove the DAA's operation from the SIP state and
  would move it off `dialing` before the ASIC call engine had started.
* the SIP-state `_publish_connected_event`; the exchange going through
  publishes it instead, on the same edge the board sees.
* the transmit tap, which took `line_tx_samples` at the codec's rate and sent
  it unresampled. The loop's copy is rate-corrected twice - codec to line, then
  line to 8 kHz.

So `--exchange` plus `--sip-server` is now a modem dialling a real peer:

```sh
python -m courier_emu run --exchange --sip-server pbx.example:5060 \
    --sip-username courier --daa quiet
```

`tests/test_ata.py::BridgeDialTests` runs it end to end against the mock PBX.
Nothing there hands anyone the number: the supervisor's encoder sends one
keypad index per digit as `0x16`/`0x13`/`0x16`, the board plays each tone, the
exchange decodes `6245` off the line, and the ATA turns that into
`INVITE sip:6245@...`. `_dial_digits_commanded` (what the supervisor asked
for) and `exchange.dialed` (what the line heard) are asserted separately, which
is the measurement. The peer's 200 OK then puts the loop through and the
board's connected event is published; its BYE releases the loop and the DAA
reports `disconnected`.

One bug came out of that last step. `SipSession._handle_request` answered an
inbound BYE with `sendto` on a socket that is `connect`ed to the server, which
raises EISCONN - so no inbound BYE had ever been answered. It uses `send` now.

## What is still not shown

The board itself. These runs use the bridge's mock core with a tone generator
attached, because the real one is the ASIC's and its firmware is not in the
image - which is the same reason `_play_dial_tone` records the supervisor's
request rather than playing it. Everything above the tone is the firmware's
own.

## Real-time physical-peer run

The complete 4.03d ROM now uses a native Unicorn basic-block clock instead of
crossing into Python for every guest instruction or basic block. SIP runs also
select a 4096-instruction C52 scheduling batch by default, while retaining the
timer poll's 1024-instruction CPU service interval. The same 150-million-
instruction call path advances 44.1 seconds of line time in 27.0 seconds when
no external clock is attached, leaving enough headroom to pace a live call.

`SipLine` wall-clock-paces each 100 ms line frame and polls SIP/RTP while it
waits. `SipSession` emits every due 20 ms packet from that block; the former
one-packet-per-block behavior reduced a 30%-real-time emulator to roughly 6%
audio at the peer.

A live call through `6000@asterisk.net.cryan.nz` to the physical ID_SDL 4.03d
Courier on extension `6245` advanced 47.1 seconds of line time in 50.2 seconds
wall clock and exchanged 1,338 outbound versus 1,330 inbound RTP packets. The
physical modem rang and heard full-rate audio. It still returned `NO CARRIER`:
the emulated side reports no call-engine start or call overlay, so real-time
transport is no longer the blocker and datapump activation remains one.
