# I-modem analogue-pair audio clock audit, 2026-10-02

The audio path contained confirmed clock-transition faults. Fixing the
overlay loader kept the ISDN call alive but did not establish V.34 carrier.
This audit follows waveform samples through the analogue codec boundary.

## Later audit: transmit batches crossing clock changes

`_take_line_audio` previously drained all pending DAC samples and assigned
the codec's final sample rate to the entire batch. Native DSP execution can
change the rate inside that batch. Retaining FIR history alone cannot fix
the resulting incorrect timestamps: earlier samples were supplied to the
resampler as though they had been generated at the later rate.

The native core now records each DAC clock change with its first sample
index and period in DSP cycles. The bridge splits a drained batch at those
indices and converts each segment at its original clock. This also uses
the actual modeled frame period instead of the nominal divider rate when
integer DSP-cycle rounding makes them differ. These events only describe
hardware output; they do not alter firmware state or generate modem signals.

The corrected 230M-instruction V.34 replay exercises **seven batches that
cross retunes**, keeps the host overlay-assist count at zero, and records no
live analogue receive gaps. It reaches `0034:0005` at 7.1651 seconds, then
`0006:0000` at 13.0126 seconds. **There is still no modem CONNECT.**

The [transport comparison](../artifacts/imodem-analog-pair-v34-tx-clock-20261002/transport-verification.json)
checks the independently saved line WAVs and bearer codewords:

- Analogue to I-modem: all 166,061 captured receive codewords match the
  line's recorded transmit samples after the specified gain and mu-law
  encoding, with zero mismatches at one fixed setup offset.
- I-modem to analogue: 149,868 samples after the initial 16,000 bearer
  samples match the recorded analogue receive line after mu-law decoding
  and the specified gain, with zero mismatches at one fixed setup offset.

This verifies socket delivery and conversion at the recorded boundaries,
not the DSP's complete analogue ADC/filter response. The offsets include
pre-call recording time; they are not end-to-end latency measurements.

The new independent continuous-tone regression checks a 3 kHz waveform
across a mixed 9.6/10.2667 kHz transmit batch, including the boundary without
phase refitting. A native regression verifies the indexed DAC clock changes
and clears them on reset. The broader C5x, I-modem, bridge and resampler
selection passes 122 tests.

The [Bell 103 control](../artifacts/imodem-analog-pair-bell103-tx-clock-20261002/summary.json)
still connects and delivers both distinct payloads.

Reproduce the corrected V.34 run:

```sh
.venv/bin/python -m tools.probe_imodem_analog_pair --protocol v34 \
  --instructions 230000000 --audit-overlays \
  --output artifacts/tx-clock-audit-new
```

## Confirmed faults and corrections

The Python resampler reset its fractional input position whenever the
output rate changed. For a continuous 8 kHz source this inserts a phase
step into the codec's receive waveform. On transmit, a change of input rate
also reinterpreted the retained history at the new sample spacing. The
resampler now preserves fractional position for an output-clock change and
retains physical timestamps across an input-clock change. Uniform windows
use the cached polyphase kernel; windows crossing a clock edge use sinc
weights at the actual sample times.

The independent 3 kHz tone comparison in
[tone-continuity.json](../artifacts/imodem-audio-clock-audit-20261002/tone-continuity.json)
compares against one continuous phase reference, without fitting a new
phase after a retune. Receive RMS error fell from 5,411/9,097 PCM units
after the two rate changes to 4.75/4.46. Transmit error fell from
5,938/13,829 to 9.10/11.64. These are waveform-continuity measurements,
not estimates of a modem channel's noise floor or achievable data rate.
Regressions include 1, 3, and 3.7 kHz, scheduler chunk independence, and
passing through an equal-rate state without dropping the established FIR delay.

The native DAC clock also returned zero after a frame without a new DSP
write, despite the model's intended sample-hold behavior. It now retains
the latest primary DAC word until it is replaced. A native regression
checks consecutive primary edges and replacement by a new word.

More significantly, the analogue receive FIFO held an entire frame already
converted at the codec's previous rate. At a 7.2-to-9.6 kHz clock change,
the ADC consumed that waveform faster than its original time grid. The
[instrumented pre-fix run](../artifacts/imodem-analog-pair-v34-live-gaps-20261002/result.json)
records **148 missing samples at line frame 299**, during the connected
call. The I-modem's zero-underrun counter did not cover this analogue FIFO.

The socket receive path now queues its original 8 kHz samples and performs
band-limited conversion at each native ADC edge. The FIFO keeps its line
time grid across codec retunes, and a receive cushion is inserted only when
that input stream starts. Native regressions compare the actual ADC words
to continuous tones across 7.2, 9.6, and 10.2667 kHz settings, with greater
than 60 dB SNR against the fixed-phase reference, and check that FIFO
consumption depends on elapsed line time rather than ADC sample count.
Explicit codec-rate inputs and other legacy paths retain `queue_codec_rx`.

## Firmware verification and remaining failure

The [validation report](../artifacts/imodem-audio-clock-audit-20261002/validation.json)
records the paired runs and all 159 passing tests. Reproduce the V.34 check:

```sh
.venv/bin/python tools/probe_imodem_analog_pair.py \
  --protocol v34 --instructions 300000000 \
  --analog-to-imodem-db -3 --imodem-to-analog-db -3 \
  --output artifacts/imodem-analog-pair-v34-audio-new
```

The corrected 300M-instruction run keeps the ISDN call active and records
zero live analogue receive gaps and zero I-modem receive underruns.
**Neither firmware reports V.34 modem CONNECT.** Its mailbox ends at the
V.8 image-6 request and `0002:a000`. It does not reproduce the later
symbol-rate reports seen in the receive-phase-only experiment; removing
waveform discontinuities changes training behavior but does not yet make
the V.34 path succeed. Further DSP/training-state investigation remains
necessary; this audit does not establish that every aspect of audio or DSP
execution is now faithful.

The Bell 103 control with these same audio changes reports Hayes CONNECT
on both sides, an active ISDN call, delivery of both distinct terminal
markers, and zero live receive gaps. The analogue NO CARRIER at the end
of that control follows the I-modem worker closing its socket at the
instruction limit.

`codec_rx_empty_frames` in the codec history includes empty conversions
before call setup. `line_service.rx_empty_connected` and `rx_gap_events`
count gaps only while the call is answered and its socket is connected;
they exclude expected worker shutdown and record the frame of each live gap.
