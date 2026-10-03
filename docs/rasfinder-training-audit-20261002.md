# Native I-modem call to RasFinder 3999

## Connected after digital-codec receive fix

A fresh native outgoing call to 3999 through account 2903 now connects.
The PBX routes this call to member 8423 (8416 is occupied by a separate
call). The I-modem reports `CONNECT 9600/ARQ` and receives the live
`MULTITECH SOFTWARE SYSTEMS`, `USA`, and `login:` banner. No login
credentials are submitted. The run ends deliberately at its 400-million
instruction limit.

Configuration: original Ie030002.nac, erased private runtime NVRAM,
`AT*V2=3`, `AT&W`, `AT&M5&K0S58=0&B0`, `ATDT3999`. The direct PCMU/RTP
path carries raw G.711 bytes; it does not use the offline SmartLink
reconstruction profile. This is a live endpoint connection after the native
digital path was isolated from analog-codec readback. The earlier failed
call analysis below remains historical.

- [Successful live call summary](../artifacts/imodem-rasfinder-3999-digital-codec-fixed-20261002/summary.json)
- [Full terminal, DSP and SIP result](../artifacts/imodem-rasfinder-3999-digital-codec-fixed-20261002/result.json)


The PBX hunt group answers on member 8416. Native I-modem calls through SIP
account 2903 reach V.8, request image 6, and cycle through phase-2 training
without Hayes CONNECT. This is earlier than the offline answering I-modem's
sequence-J wait; they must not be treated as the same failure.
The later sample-writer call does advance to native symbol-rate report
0034:0005 before retraining. Phase 2 is therefore not a permanent wall in
every call.

## Confirmed SIP transmit backlog and correction

`SipSession.send_pcmu` and `send_audio` formerly enqueued media while the
session was inviting, trying or ringing. `_flush_rtp` transmits only once
connected, starting its media clock at that point. A slow answer therefore
left stale pre-answer samples ahead of every subsequent DSP response. The
queues hold up to 16000 samples, so the resulting delay can reach two seconds.
The original call handed off 393840 bearer samples but sent only 368480 via
RTP before the capture limit. That difference includes queued and discarded
samples; it is not itself an exact measurement of queue latency.

Both transmit paths now discard pre-answer samples instead of retaining them
for later playback. The session reports that count and its transmit queue
length. A regression verifies that the first packet after answer contains
current audio, in both linear and unmodified-codeword modes.

The corrected native V.34-only call discarded 25488 pre-answer samples, sent
440640 via RTP and ended with seven samples queued. The bearer identity is
466135 = 25488 + 440640 + 7. This proves the stale transmit backlog is gone.
It does **not** establish modem carrier: the call still repeats training and
the receiver comparison below still fails.

## Receiver decision and independent arithmetic checks

Live completion checks verify image 6 at a000: all 13912 words match the
supervisor's transferred words, and the destination advances to d658. There
is no subsequent overlay request during the repeating state.

At 97cf the firmware compares accumulated spectral power with a minimum;
at 97d7 it compares that power with the reference at 03e8:03e9. In the first
receive audit, all 519 retained attempts reached the second comparison and
none reached its successful exit at 97d9. Disabling x2 and V.90 via native
S58=33 did not resolve it (454 attempts, zero successful exits).

Read-only PC captures record exact sample and transform buffers at the
comparison. In strong-tone windows, the native transform's selected-bin
power agrees with a direct Fourier calculation within about 0.11%. The
isolated original transform also correctly places known tones in their
expected bins. The reference-update routine 8d0f produces the expected
fixed-point square increment for positive and negative test inputs. In the
sample-history capture, each of 1280 recorded input subtractions matches
the new sample minus its stored predecessor. All 1699 adjacent retained
sample captures also advance the history index by exactly one. These checks rule out errors
in those particular calculations, rather than all DSP arithmetic or interrupts.

The reference accumulates squared differences between new samples and
samples from the 64-sample history buffer. Its high value at the failing
decision remains unexplained. Captured returned Tone A includes the expected
1800 Hz guard tone; that component is specified by V.34 and is not spurious
audio. The original receive capture aligns with received RTP at a nearly
constant offset after startup, so frequent sustained receive sample slips
are not supported by that recording.

The follow-up phase-timing call selected image 8 rather than image 6 after
V.8, so it did not exercise the configured V.34 capture point. It repeatedly
reported native timeout/retrain replies 000f:0000 and 0006:0000, without
CONNECT. It cannot establish V.34 phase-change timing.

## Consecutive receive capture and PCM scheduling correction

The consecutive history call retains 293558 samples. There are 274113
checks of the exact 64-frame predecessor and 292849 checks of the reference
increment, with zero mismatches in either. Periodic large sample excursions
raise the reference during some repeating detector windows. The later FIR
capture independently reconstructs all 135138 retained executions of receive
conversion 8234, with zero output mismatches. The native original mu-law
expander also matches all 256 codewords against G.711 decoded at one-quarter
scale. These are checks of particular routines, not proof that their input
sample scheduling is correct.

The optimized `advance_imodem` path ran its entire requested cycle budget
before returning PCM to the DSC MUX. The existing receive-pacing regression
exercised a fake core lacking this optimized method. A native reproducer
with one receive word and a 20000-cycle advance generates three PCM frames
and four empty receive octets before the host can supply the next word.

The native optimized advance now yields at each completed PCM frame; both
instruction-coupled and realtime schedulers exchange that frame before
continuing the remaining cycle budget. During realtime catch-up the BRI peer
also exchanges each completed DSC frame before the next MUX clock, rather
than waiting for the next outer CPU scheduler pass. Regressions exercise
the actual native path and a receive queue supplied one frame at a time.
Neither change patches modem training state or accepts a failed detector.

The uninstrumented fixed-pacing live call clocks 364173 PCM frames with
**zero DSP empty receive slots and zero DSC receive underruns**. Its receive
queues finish at exactly one word in the DSP and one octet in the DSC, rather
than retaining the hundreds of samples seen in earlier calls. Native firmware
reports 0034:0005 and later retrains; the DTE still does not report CONNECT.
The scheduling defect is therefore corrected, while carrier establishment
remains unresolved. See the [fixed call summary](../artifacts/imodem-rasfinder-pcm-frame-fix-20261002/summary.json).

## Evidence and validation

### Later training and RTP playout

The later-training capture identifies the exact retrain caller as `a90c`:
`a909` checks the signed high word of the training timeout at `031a`, then
shifts two received bits into the `0343:0342` history. It requires two equal
16-bit words whose value, with bit 5 masked, is `8990`. This is the V.34 J
sequence detector. The timeout capture occurs at DSP time 25.839289 seconds,
with coroutine `006d=a7b1` and receiver `088d=a2c2`; the overlay is executing.

A subsequent unmodified native call **does recognize J**, at DSP time
19.364888 seconds. Firmware then sets the expected `006f` flags, sends its
own training, and later retrains from `a198`, the S detector's timeout check.
Independent calculations match all 1691 consecutive captured descrambler
updates and all 1691 bit-history shifts. This demonstrates that J recognition
works intermittently, not that carrier or payload transfer works.

Packet-level observation also found 101 inserted silence samples after the
first 100 ms of RTP, despite otherwise continuous packets. The bearer consumed
each arriving packet immediately, so normal arrival jitter exhausted its queue
and spliced silence into the modem waveform. `BearerSipLine` now primes a
320-sample receive queue before playout and rebuilds that reserve after a real
outage. It preserves every received codeword in order, without resampling or
changing any training decision. Its initial reserve adds approximately 20 ms
of playout delay for normal 160-sample RTP packets.

One validation call encountered an actual incoming timestamp gap of 2560
samples and a 320 ms arrival gap, followed by a change of RTP SSRC. A small
buffer cannot conceal that source outage. The final buffered live call has
**zero inserted silence after the first 100 ms of RTP and zero DSC underruns**,
with 248 samples remaining in the receive queue. It still repeats phase 2 and
does not report CONNECT. Eliminating these waveform discontinuities is a
verified transport correction, not proof that the remaining DSP failure is
resolved.

- [Later retrain trace](../artifacts/imodem-rasfinder-late-training-20261002/retrain-trace.json)
- [Independent J bit checks](../artifacts/imodem-rasfinder-j-detection-20261002/bit-analysis.json)
- [Unbuffered packet timing](../artifacts/imodem-rasfinder-phase3-media-20261002/media-analysis.json)
- [Buffered live validation](../artifacts/imodem-rasfinder-rebuffered-media-20261002/media-analysis.json)

The full relevant suite passed 130 tests before the outage-recovery refinement;
all 10 affected bearer, SIP startup and native receive-pacing tests pass after
that refinement, including a new outage followed by jitter regression.

An additional bearer transparency regression uses guest instructions to write
DXR, clocks the native digital serial port and the programmed DSC MUX, and
checks all 256 G.711 codewords in both directions. Every octet is preserved,
the first slot carries B1, the unrouted second slot remains idle, and receive
latency is a constant one modeled frame. No sample is duplicated or dropped
and neither receive queue underruns. All nine pacing and playout tests pass
with that regression. This verifies the local frame path, not live RTP delivery
or full device timing equivalence.

### Independent outgoing RTP clock

The buffered call's outgoing RTP trace has a 62.23 ms maximum packet gap
followed by catch-up bursts. Its average rate is 8000.02 samples/s, so this
is scheduler jitter rather than sustained clock drift. Sending packets from
the emulator's per-frame callback makes network delivery depend on when the
host next runs that callback.

The BRI SIP peer now enables an independent RTP sender. It primes three
160-sample packets, sends at 20 ms monotonic deadlines, and keeps all G.711
codewords unchanged. The initial reserve adds approximately 40 ms of TX
latency. An actual production outage rebuilds that reserve; it does not invent
audio. Codeword queues no longer silently discard their oldest samples at a
two-second length limit. The clock thread stops when the session closes.
The analogue SIP sender retains its existing synchronous behavior.

The [clocked live trace](../artifacts/imodem-rasfinder-clocked-rtp-20261002/timing-analysis.json)
has 1225 outgoing packets, a **25.00 ms maximum gap**, 24.35 ms 99th-percentile
gap, and 8.94 ms maximum phase delay relative to a 20 ms packet schedule.
Its receive side again has zero inserted silence after RTP startup and zero
DSC underruns. Firmware still repeats phase 2 and does not report CONNECT.
This is a measured reduction in transport jitter, not a solved modem call.
All 134 relevant DSP, I-modem, bearer, RTP, bridge and resampler tests pass;
the sender tests verify continued packet delivery while the producer is paused,
codeword preservation, monotonic RTP timestamps and clean thread shutdown.

The assumed C51 machine-cycle frequency remains a separate timing uncertainty.
The oscillator can is 40.320 MHz, but the ASIC output frequency and C51 clock
mode pin levels have not been measured. TI's clock modes support different
relationships between input and machine clocks. Changing the assumption
without those facts would not establish device-equivalent instruction timing.

### Larger-buffer control

The [100 ms buffer call](../artifacts/imodem-rasfinder-large-buffer-20261002/timing-analysis.json)
uses 800 samples in each direction, compared with 320 RX / 480 TX in the
preceding call. It finishes with 697 RX samples buffered, zero inserted silence
after startup and zero DSC underruns. Outgoing packet gaps peak at 30.05 ms.
Firmware still repeats phase 2 and the DTE never reports CONNECT. This trial
does not show improved training from the larger reserve; it does not establish
that all buffer sizes or calls behave identically.

`isdn-run --bri-sip-buffer-ms 100` now selects that setting for both directions.
The existing defaults remain 40 ms RX and 60 ms TX. For normal 20 ms packets,
100 ms priming adds about 80 ms playout delay in each direction. Buffer sizes
below one 20 ms RTP packet are rejected. Small and large receive-buffer tests
verify codeword continuity through delayed packets.

### Fixed peripheral slots and remaining receiver failure

The DSC previously assigned peripheral slots from MUX register order, including
MAP/MPI ports, and mislabeled C4 as PPCR2 and C8 as PPCR3. AMD 09893H defines
Bd/Be/Bf as fixed peripheral channels 6/7/8. SBP sends those three octets in
order; IOM-2's first two octets are Bd/Be, and PPCR1 bit 3 selects the fifth or
sixth octet for Bf. PPCR2 is C8, PPCR3 is C9, and C4 is C/I channel 0 data.
The model now implements those slot positions and correct register addresses.
Tests exercise reversed MUX programming order, two independent B channels,
disabled/SBP/IOM-2 modes, and IC1/IC2 selection. Previous native pacing test
fixtures incorrectly used the MAP port as a peripheral slot; they now use Bd.

The [fixed-slot live call](../artifacts/imodem-rasfinder-fixed-pp-slots-20261002/summary.json)
reports physical slots [6,7], zero DSC underruns, and zero inserted silence
after RTP startup. It still does not connect. In this call MCR1 connects B1 to
Bd, so correcting the slot model does not change which slot carries its audio.

An isolated execution of the original `81fd` mu-law compressor matches the
standard reference for all 32768 even signed 16-bit input levels. Its wrapper
sets DP=7 and ARP=1, provides half-scale input as expected by the routine, and
extracts the returned codeword with SACH shift 4. This complements the earlier
all-256-codeword expander check.

The clean sample-timing trace retains 248337 receiver samples. Across its
64057 captures while coroutine `006d=97b2` is active, none has accumulated
tone power above the adaptive reference threshold. The original 9600-sample/s
receive callback cadence is maintained during contiguous detector windows.
This narrows the investigation to the received waveform and its DSP processing;
the trace alone does not distinguish a wrong transmitted handshake from a
receiver emulation defect.

A diagnostic [20.16 MHz C51 call](../artifacts/imodem-rasfinder-c51-half-clock-20261002/summary.json)
halves machine cycles per second while preserving the 8 kHz DS0 divider. It
also repeats phase 2 and does not connect, with zero DSC underruns. This does
not identify the device's actual clock pins; the default clock remains unchanged.
All 138 relevant DSP, I-modem, bearer, bridge and resampler tests pass.

Source: [original AMD Am79C30A/32A datasheet, tables 18 and peripheral-port registers](https://dtsheet.com/doc/268597/amd-am79c30ajc).

- [Original call](../artifacts/imodem-rasfinder-3999-20261002/result.json)
- [Live overlay audit](../artifacts/imodem-rasfinder-overlay-audit-20261002/overlay-verification.json)
- [Receive comparison trace](../artifacts/imodem-rasfinder-receive-audit-20261002/receive-traces.json)
- [Exact decision captures](../artifacts/imodem-rasfinder-decision-capture-20261002/decisions.json)
- [Independent Fourier comparison](../artifacts/imodem-rasfinder-decision-capture-20261002/decision-analysis.json)
- [Input history capture](../artifacts/imodem-rasfinder-history-capture-20261002/decisions.json)
- [Corrected live call](../artifacts/imodem-rasfinder-media-start-fix-20261002/result.json)
- [Consecutive history checks](../artifacts/imodem-rasfinder-contiguous-history-20261002/history-analysis.json)
- [Independent receive FIR check](../artifacts/imodem-rasfinder-receive-fir-20261002/fir-analysis.json)
- [Per-frame pacing live call](../artifacts/imodem-rasfinder-pcm-frame-fix-20261002/summary.json)
- [ITU-T V.34, section 10.1.2.1 and phase-2 procedures](https://www.itu.int/rec/dologin_pub.asp?id=T-REC-V.34-199610-S!!PDF-E&lang=e&type=items)

128 relevant C5x, I-modem, bridge, resampler and SIP regression tests pass.
The instruction-boundary capture feature is disabled unless explicitly
configured; it reads data and mapped registers without changing guest state.

## Direct 8416 and 8423 calls

The same native I-modem configuration is tested directly against both
extensions, sequentially, through SIP account 2903. The first 8416 attempt
receives SIP 486 Busy Here while a separate 2900 call occupies that endpoint.
The first direct 8423 call answers and trains, then receives a remote BYE
and reports NO CARRIER. These initial outcomes are retained.

Once both endpoints are free, the repeated direct calls each report
`CONNECT 9600/ARQ` and receive the MultiTech `USA` / `login:` banner. No
login credentials are submitted. Each run ends at its 400-million
instruction limit. This confirms direct carrier and received application
data at both endpoints; the unsuccessful first 8423 attempt also shows
live negotiation is not yet guaranteed on every call.

- [Both successful direct call summaries](../artifacts/imodem-direct-8416-8423-retry-20261002/summary.json)
- [8416 successful terminal and SIP state](../artifacts/imodem-direct-8416-8423-retry-20261002/8416/summary.json)
- [8423 successful terminal and SIP state](../artifacts/imodem-direct-8416-8423-retry-20261002/8423/summary.json)
- [Initial busy and NO CARRIER outcomes](../artifacts/imodem-direct-8416-8423-20261002/summary.json)

`tools/probe_imodem_sip.py` reproduces these calls using only the existing
2903 authentication stanza read over SSH; it never prints or saves that
account's password and does not change PBX routing or endpoint settings.
