# I-modem versus Tower SmartLink, 2026-10-02

## Resolved: V.90 probe reconstruction

The V.90 stall is resolved in the SmartLink probe by reproducing Tower's
active downstream reconstruction path: a 257-tap, six-phase Hann-windowed
sinc through Sd/bar-Sd, then eight-point Lagrange interpolation from the
first TRN1d symbol. The old probe used its generic 128-tap Kaiser sinc
throughout the call. No guest firmware, supervisor command, DSP program,
DIL descriptor, or serial clock change was required for this resolution.

With the Tower profile, SmartLink recognizes Jd, sends S, and native DSP
capture records entry to DIL generator `ca57`. Both terminals report
`CONNECT 34667`; SmartLink identifies the negotiated datapump explicitly as
V.90 with downstream 34667 and upstream 31200 bit/s. The repeat 300-million
supervisor-instruction run exchanges 2242 blocks (44.84 seconds of audio),
with no retrain before probe shutdown. A subsequent data soak verifies bidirectional application transfer, with
an early upstream error as detailed below. SmartLink's training timing estimate converges near
zero instead of drifting by thousands of ppm.

The entire native 20004-symbol TRN1d also matches an independently generated
zero-initialized GPC scrambler driven by ones, after a constant polarity
reversal, with zero dropped/repeated/incorrect symbols. This and the valid
Jd frames separate correct raw DS0 generation from the failing reconstructed
SmartLink input. The evidence identifies the receiver-channel model as the
failed boundary; it does not establish a general CPU arithmetic defect.

`--smartlink-rx-reconstruction auto` now selects `tower` for V.90 and
`bandlimited` for V.34. Select `bandlimited` explicitly to reproduce the
original failure. The production generic resampler remains unchanged.
The following sections retain the earlier investigations and controls.

- [Sustained V.90 result](../artifacts/imodem-slmodemd-v90-reconstruction-fixed-20261002/result.json)
- [SmartLink V.90 data-mode log](../artifacts/imodem-slmodemd-v90-reconstruction-fixed-20261002/slmodemd.log)
- [DIL entry capture](../artifacts/imodem-slmodemd-v90-reconstruction-fixed-20261002/detector-captures.json)
- [Independent whole-TRN1d comparison](../artifacts/imodem-slmodemd-v90-jd-bits-20261002/trn1-reference-comparison.json)

```sh
.venv/bin/python -m tools.probe_imodem_slmodemd \
  --protocol v90 --instructions 300000000 --capture-pc ca57 \
  --output artifacts/slmodemd-v90-working-new
```


The direct SmartLink comparison identified an emulation bug: digital G.711
slot words were interpreted as AC01 analogue codec commands. Bypassing AC01
handling on the digital serial port fixes the receive corruption. With that
fix, **both the original I-modem firmware and SmartLink report CONNECT 33600**.
No modem state or qualification decisions were patched.

Tower's idle `d-modem` container supplies `/src/slmodemd/slmodemd -d9`.
`tools/probe_imodem_slmodemd.py` installs a temporary socket relay, configures
SmartLink as a V.34 caller, and answers with the original I-modem firmware.
Each exchange carries 160 G.711 samples at 8 kHz and 192 linear samples at
9.6 kHz. Streaming band-limited converters join the sample rates; SSH latency
does not advance either datapump. One 20 ms receive reserve prevents queue
underruns. The relay collects debug and terminal logs and retires the temporary
processes; Tower's existing container remains idle afterward.

## Peer observations before the fix

SmartLink detects ANSam, completes V.8, selects V.34, and accepts the I-modem's
INFO0. It then stays in `RX_PHASE1_CALL`, sending Tone B, until its training
timeout. The I-modem stays in coroutine `94ca`, transmit callback `9dbe`, and
receive callback `9bf6`; it eventually returns NO CARRIER.

The first unity-gain probe gave a misleading INFO0 CRC failure. The existing
d-modem backend scales incoming PCM by 0.25 during this handshake. Applying
that same scale lets SmartLink accept INFO0. Independently demodulating the
unity-gain I-modem output recovers 140 consecutive INFO0 frames at one symbol
phase, with body `21ff` and CRC `9bf1`. Therefore that CRC warning was a probe
gain error, not evidence that the I-modem generated incorrect CRCs.

The correctly scaled peer's INFO0 can also be decoded independently from the
G.711 samples delivered to the I-modem: body `21ff`, CRC `9bf1`, 1200 Hz
carrier and 600 symbols/s. The three original I-modem overlay transfers
complete with zero program-word mismatches and no host overlay assists.

## Continuous native receive evidence

At entry to `9bf6`, DP is 7 and direct cell `@0f` is data `038f`.
This is the input used by the native DPSK receive processing. The observer
records that value, the receive index at `0393`, and the native cycle count.
It drains the 64-entry capture ring every 10,000 supervisor instructions,
independently of the coarser state checkpoints.

The final capture has 23,367 entries. All 23,366 adjacent receive indices
advance by exactly one, including wraparound. The last 9,600 samples span
0.999875 seconds between their first and last samples. DSP empty receive
slots and DSC underruns are both zero. The sample stream is continuous;
the earlier sparse captures must not be used as continuous waveforms.

During the last steady-tone second:

| Measurement | Delivered G.711, decoded | Native detector input `038f` |
| --- | ---: | ---: |
| Rate | 8000 samples/s | 9600 samples/s |
| Minimum | -4092 | -21338 |
| Maximum | 4092 | 9268 |
| RMS | 2977.98 | 5497.78 |
| Dominant component | 1200 Hz | 1200 Hz plus large spurs |

The native waveform repeats exactly after 48 samples. Its RMS difference
after eight samples, the expected period of a 1200 Hz tone at 9600 samples/s,
is 7336.61; its difference after 48 samples is zero. It has strong 800, 1600,
2400 and 3200 Hz components and further components on a 200 Hz grid. The
delivered tone's largest non-fundamental component is its much smaller
3600 Hz G.711 harmonic. Different internal amplitude scales alone cannot
explain these added frequencies.

The separate INFO-bit capture shows `0394` repeatedly cycling through
signed values -151, +744 and -434 during steady Tone B. Native qualification
counter `03e1` never exceeds five in that capture, below the comparison
against 15 at `9d37`. Flag `03e2` does not obtain its tone-qualified bit 3.
Earlier arithmetic checks using the actual captured FIR operands did not
establish that their inputs were correct. Following the input back through
the native mu-law decoder revealed occasional zero codewords in place of
the clean bearer samples. The decoder itself matched every captured input;
corruption occurred at the serial register read, before conversion.

## Root cause and fix

`cpuregs_w(DXR)` unconditionally called `codec_transmit()`. That function
recognizes AC01 secondary-frame commands even when the ROM codec is disabled.
Ordinary digital words such as `ffff` followed by `25ff` consequently armed
a codec register read. On a later guest `cpuregs_r(DRR)`, the readback branch
substituted a codec register value for the digital word latched by the frame
clock. A zero register value became mu-law code `00`, a large negative sample,
and injected the observed periodic distortion. The firmware was processing
the corrupted inputs correctly.

Digital mode now bypasses `codec_transmit()` on DXR writes and returns the
frame-clock-latched DRR word directly on guest reads. Analogue codec handling
continues through the existing branches. A regression sends the two legal
digital words above, then executes a guest DRR read and verifies the received
`b1ff` word survives. Diagnostic register peeks alone did not exercise the
buggy guest-read branch.

The fixed 300-million-instruction call exchanged 2,242 audio blocks (44.84
seconds). I-modem serial output and SmartLink terminal output both contain
`CONNECT 33600`. SmartLink reports V.34 data mode at 33,600 bit/s in each
direction and stays there until the probe ends; its final NO CARRIER follows
the relay shutdown. The three firmware overlay transfers still have zero
word mismatches. This run verifies connection and sustained carrier, but
does not yet verify application payload transfer.

The native C5x, I-modem, bridge-rate and resampler regression selection passes
all 131 tests.

## x2 and V.90 follow-up

After the digital-port fix, the existing analog Courier pair probe was run
for 300 million instructions per endpoint separately with `--protocol x2`
(S58=32) and `--protocol v90` (S58=1), plus distinct bidirectional payload
markers and overlay auditing. Neither run reports Hayes CONNECT and neither
delivers its payload markers. All three I-modem overlay transfers in each
run have zero mismatches. The V.90 selection repeats training; the x2
selection reaches additional mailbox reports, but those reports alone do
not establish carrier. The analog peer clears its call before the run ends.

These are tests against another emulated endpoint. They establish that this
pair harness still fails; they do not isolate the remaining problem to the
I-modem. V.34 interoperability with Tower SmartLink is confirmed, while x2
and V.90 interoperability remains unverified. The firmware's documented
host-mode support is separate from an observed successful connection.

- [x2 pair verdict and payload checks](../artifacts/imodem-analog-pair-x2-digital-codec-fix-20261002/summary.json)
- [V.90 pair verdict and payload checks](../artifacts/imodem-analog-pair-v90-digital-codec-fix-20261002/summary.json)

### V.90 with SmartLink

The peer probe now accepts `--protocol v90`: SmartLink receives
`AT+MS=90,1,28000,56000`, and I-modem receives `ATS58=1&M0&B0`.
The fixed-gain 300-million-instruction run exchanges 2,242 blocks (44.84
seconds) without CONNECT on either terminal. SmartLink's log confirms
`V90=1`, remote V.90 capability, a digital connection and PCM indication.
It constructs the analog V.90 client, selects V.90 during training and
reaches its PCM demodulator and digital-impairment training. Three attempts
request retraining with `requested DP is 90`. This is a V.90 training
failure, rather than a run accidentally limited to V.34. The final
NO CARRIER is emitted when the instruction-limit probe terminates the peer.
The remaining failure mechanism has not been isolated.

An independent comparison against NAC source bytes confirms that each
transport hash, immediate loaded-program hash and firmware hash is identical
for images 10, 11 and 6, including the loader's paragraph padding. The final
resident image 5 (4,670 words) and complete call image 6 (13,909 words) also
match the firmware with zero mismatches after all three failed attempts.
Only one call-overlay command, `0002:a000` at 4.9079 seconds, occurs;
there are no overlay reloads during the subsequent retrains and zero host
overlay assists. This rules out missing or corrupted bytes in those loads.
Comparing image 10 in full after image 6 is misleading because their address
ranges overlap and the remaining high program memory is shared workspace.

Native snapshots enter transmit callback `c89d`, receive callback `c855`
and coroutine `c861`/`c86c` in each PCM attempt before returning to the
handshake callbacks `9dbe`/`9bf6`. Thus the next investigation belongs at
that training transition and the sample path, rather than repeating the
already verified overlay transfer checks.

- [I-modem state and V.90 probe parameters](../artifacts/imodem-slmodemd-v90-digital-codec-fix-20261002/result.json)
- [SmartLink V.90 training log](../artifacts/imodem-slmodemd-v90-digital-codec-fix-20261002/slmodemd.log)
- [Independent firmware and overlay verification](../artifacts/imodem-slmodemd-v90-digital-codec-fix-20261002/overlay-verification.json)

The follow-up `c861` capture follows the first PCM attempt. From bearer
seconds 12 through 19, every transmitted octet is either `31` or `b1`:
the two signs of one mu-law magnitude. There is no changing-amplitude DIL
ladder in this interval. The first two whole seconds descramble to a
constant bit using the GPC recurrence (allowing sign inversion), consistent
with TRN1d. Later sign patterns change, so the entire burst must not be
called unchanged TRN1d without decoding its later messages.

The native transmitter stage at `03c8` advances through `ca3e`, `ca44`,
then `cbd2`; it is not simply stuck before the timed TRN1 stage ends.
SmartLink logs its Ja transmit stage and TRN1 processing, then retrains.
The missing DIL is therefore a useful observed symptom. The preceding
downstream message/acknowledgement exchange still needs decoding before
attributing the failure to DIL generation itself.

- [First-attempt PCM wait and codeword measurements](../artifacts/imodem-slmodemd-v90-ja-wait-20261002/pcm-wait-analysis.json)

### Supervisor involvement and DIL dispatch

A 170-million-instruction follow-up filters writes to descriptor cell
`dcf5` and captures entry to `ca57`, the DSP DIL generator. The received
descriptor is stored by the DSP's block move at `a7d0` (write trace reports
its final instruction word `a7d1`): `dcf5 = 0090`, with `dcf6 = 7777`.
That is N=144 and packed segment lengths decoding to 120/120. The generator
reads those fields and the patterns beginning at `dcf7` directly from DSP
memory; it does not obtain the descriptor through a supervisor command.
There are zero captures at generator entry `ca57` in this run.

The supervisor supplies V.90 power through command `0072:0b76` before
training, and DSP cell `ffdf` retains `0b76`. No further supervisor command
is sent between the call overlay load and the failed PCM attempt. The
mailbox finishes with no pending reply and 118 acknowledgements. This does
not prove all supervisor behavior correct, but there is no observed pending
DIL request awaiting its acknowledgement. The current evidence points to
the DSP waiting for the peer's S signal before entering DIL. A subsequent
`a194` capture shows the S receive gate held by zero incoming energy while
SmartLink transmits silence. This is the normal gate specified by V.90
9.3.1.5, not evidence of a missing supervisor command.

- [DIL descriptor writer and generator-entry audit](../artifacts/imodem-slmodemd-v90-dil-dispatch-20261002/dil-dispatch-analysis.json)

```sh
.venv/bin/python -m tools.probe_imodem_slmodemd \
  --protocol v90 --instructions 300000000 \
  --output artifacts/slmodemd-v90-new
```

## Artifacts and reproduction

- [Fixed call, including I-modem CONNECT](../artifacts/imodem-slmodemd-fixed-training-20261002/result.json)
- [Fixed peer terminal CONNECT](../artifacts/imodem-slmodemd-fixed-training-20261002/tty.log)
- [Fixed peer training and data-mode log](../artifacts/imodem-slmodemd-fixed-training-20261002/slmodemd.log)
- [Complete peer timeout and I-modem states](../artifacts/imodem-slmodemd-v34-training-20261002/result.json)
- [Peer debug log](../artifacts/imodem-slmodemd-v34-training-20261002/slmodemd.log)
- [Independent outgoing INFO0 checks](../artifacts/imodem-slmodemd-info0-20261002/info0-demod.json)
- [Independent incoming INFO0 checks](../artifacts/imodem-slmodemd-quarter-scale-20261002/info0-rx-demod.json)
- [Native INFO decisions](../artifacts/imodem-slmodemd-info-bits-20261002/detector-captures.json)
- [Continuous waveform measurements](../artifacts/imodem-slmodemd-continuous-rx-20261002/waveform-analysis.json)
- [Continuous native samples](../artifacts/imodem-slmodemd-continuous-rx-20261002/detector-captures.json)

Capture rows begin with native DSP instruction count, native DSP cycle count,
accumulator, DP, and carry, followed by the cells in `capture-addresses.json`.

```sh
.venv/bin/python -m tools.probe_imodem_slmodemd \
  --instructions 300000000 --output artifacts/slmodemd-training-new

.venv/bin/python -m tools.probe_imodem_slmodemd \
  --instructions 115000000 --capture-pc 9bf6 \
  --output artifacts/slmodemd-native-receive-new
```

Use a fresh output directory. The probe defaults to SmartLink RX gain 0.25.

### Independent Jd decoding and polarity control

`tools/analyse_imodem_v90_signs.py` independently reads the raw mu-law sign
bits, removes differential encoding, and descrambles using delays 18 and 23.
The 15–18 second window in `imodem-slmodemd-v90-jd-bits-20261002` contains
334 consecutive valid 72-bit Jd frames, spaced exactly 72 samples apart.
Their data words are `ffff:f03f`; independently calculated CRC `c2e5` matches
every frame. The frame sync, start bits, reserved bits, and fill bits match
V.90 Table 13. The fields enable all downstream rates through 56 kbit/s,
16-point training/renegotiation constellations, and maximum lookahead 3.

The 12.5–13.5 second TRN1d window descrambles to 8,000 zeroes with the
recorded absolute polarity; reversing polarity makes these ones. A control
run with SmartLink receive gain `-0.25` still produces no DIL entry and
SmartLink requests retrain. Its receive timing estimate again drifts to
about -2,227 ppm. Polarity alone therefore does not explain the failure.
Valid Jd at the raw digital output does not prove SmartLink decodes the
resampled audio correctly. The remaining suspect boundary is its PCM
reconstruction/equalizer/timing path.

- [Independent sign and CRC results](../artifacts/imodem-slmodemd-v90-jd-bits-20261002/sign-decoding.json)
- [Opposite-polarity control](../artifacts/imodem-slmodemd-v90-inverted-polarity-20261002/result.json)
- [V.90 specification, Table 13 and clauses 9.3.1.5–9.3.2.9](https://www.itu.int/rec/dologin_pub.asp?id=T-REC-V.90-199809-I!!PDF-E&lang=e&type=items)

A second control changes only the resampler cutoff constant at runtime from
0.98 to 1.0, affecting both audio directions. It also reaches PCM training,
produces no DIL generator entries, and retrains. SmartLink's timing estimate
changes markedly, from approximately -2,227 ppm to +12,796 ppm. This is
evidence of filter-sensitive receive timing, not proof of a corrected
channel or a physical clock-rate error. Production filter settings remain
unchanged. New probe runs also save the exact 9.6 kHz PCM submitted to
SmartLink as `smartlink-rx.s16le`, so the receiver boundary can be audited
without reconstructing its input from the digital capture.

- [Full-Nyquist cutoff control](../artifacts/imodem-slmodemd-v90-full-nyquist-20261002/channel-experiment.json)

## Bidirectional data soak

The one-billion-supervisor-instruction V.90 run exchanges 9242 blocks
(184.84 seconds of audio), holding data mode for approximately 162.82
seconds after CONNECT. SmartLink reports V.90 rx34667/tx31200 and zero
retrain requests. The run ends at the instruction limit, so this establishes
a lower bound on hold time, not the maximum connection lifetime.

Each endpoint sends one numbered 86-byte ASCII packet per second, including
a deterministic SHA-256-derived body. Seven-bit terminal data are checked
byte-for-byte; the SmartLink upstream terminal strips the I-modem's 7E1
parity bit. This does not test arbitrary eight-bit binary data.

SmartLink-to-I-modem: all 162 packets match exactly, totaling 13932 payload
bytes. I-modem-to-SmartLink: 161 of 162 packets match exactly (13846 verified
bytes). Packet 1 has one `0` replaced by bytes `56 7f 19 7f`; a further two
bytes `7e 4e` appear between intact packets 3 and 4. All subsequent numbered
packets match, with no extra bytes between them. These early upstream
errors remain unresolved; CONNECT and sustained carrier do not establish
an error-free application stream. Error correction was disabled on both
ends (`&M0`, `AT\N0%C0`) for this raw datapump check.

- [Bidirectional payload verdict and hold time](../artifacts/imodem-slmodemd-v90-data-soak-20261002/payload-analysis.json)
- [I-modem received application bytes](../artifacts/imodem-slmodemd-v90-data-soak-20261002/payload-received.bin)
- [SmartLink received terminal bytes](../artifacts/imodem-slmodemd-v90-data-soak-20261002/tty.log)

```sh
.venv/bin/python -m tools.probe_imodem_slmodemd \
  --protocol v90 --payload-check --instructions 1000000000 --capture-pc ca57 \
  --output artifacts/slmodemd-v90-data-new
.venv/bin/python -m tools.analyse_slmodemd_payload artifacts/slmodemd-v90-data-new
```

## V.42/LAPM error-corrected data soak

Error correction is enabled using I-modem `&M5&K0` and SmartLink
`AT\N4%C0`, with compression disabled. SmartLink reaches `EC_ESTAB`, logs
`ec = 1 (1)`, and then reaches `MODEM_ONLINE`; this is an error-corrected
connection, rather than an AT setting alone. V.90 still negotiates
downstream 34667 and upstream 31200 bit/s.

The first one-billion-instruction trial receives all completed packets
exactly, without the raw-mode startup corruption. Its final upstream packet
is queued only 0.24 seconds before the instruction limit and is absent at
shutdown. To remove this timing ambiguity, the repeat limits traffic to
150 packets per direction and leaves approximately 12 seconds for drain.

The repeat holds data mode for approximately 162.24 seconds (2m42s), with
zero retrain requests, then ends deliberately at the instruction limit.
Both directions receive all 150 packets exactly once: 12900 bytes each way.
The entire application stream matches the concatenation of expected
packets in each direction, with no missing/corrupted/duplicate packets and
no extra bytes. This verifies the tested seven-bit ASCII application data,
not arbitrary eight-bit binary data or maximum throughput.

- [Error-corrected, fully drained payload verdict](../artifacts/imodem-slmodemd-v90-lapm-drained-soak-20261002/payload-analysis.json)
- [Negotiation, terminal transcript and state](../artifacts/imodem-slmodemd-v90-lapm-drained-soak-20261002/result.json)
- [SmartLink LAPM establishment and online state](../artifacts/imodem-slmodemd-v90-lapm-drained-soak-20261002/slmodemd.log)

```sh
.venv/bin/python -m tools.probe_imodem_slmodemd \
  --protocol v90 --error-correction --payload-check --payload-packets 150 \
  --instructions 1000000000 --capture-pc ca57 \
  --output artifacts/slmodemd-v90-lapm-new
.venv/bin/python -m tools.analyse_slmodemd_payload artifacts/slmodemd-v90-lapm-new
```

## Faster V.90 reconstruction profile

A controlled reconstruction sweep keeps the original firmware, LAPM, gain
0.25, serial clocks and initial Sd/bar-Sd sinc path unchanged. Only the
training-stage Lagrange interpolation length changes. Doubling the training
gain with eight points has no rate benefit.

| Interpolation points | Downstream | Upstream | Outcome |
| --- | --- | --- | --- |
| 8 | 34667 | 31200 | clean LAPM soak |
| 16 | 38667 | 31200 | clean short payload test |
| 32 | 44000 | 31200 | clean LAPM soak |
| 64 | no connection | — | 2 retrain requests |
| 128 | no connection | — | 3 retrain requests |

The 32-point profile improves negotiated downstream rate by approximately
26.9%. SmartLink selects a 39-level constellation rather than the original
12-level constellation. The 300-million-instruction check and the repeated
one-billion-instruction soak both connect at 44000/31200. The soak holds
data mode for 162.24 seconds, with zero retrains and zero reconstruction
clipping. Each complete application stream exactly matches all 150 expected
86-byte packets: 12900 bytes per direction, without corruption, missing
packets, duplicates, or extra bytes. This remains a seven-bit application
correctness test at light load, not a maximum-throughput benchmark.

The V.90 probe now defaults to 32 points; select
`--smartlink-interpolation-points 8` to reproduce the original Tower profile.
Longer is not uniformly better for SmartLink: the 64- and 128-point profiles
retrain before connecting despite zero clipping. This is an empirical
receiver-channel optimization, not evidence of a new DSP CPU bug.

- [Full 44000-bit/s payload verification](../artifacts/imodem-slmodemd-v90-44000-lapm-soak-20261002/payload-analysis.json)
- [Speed sweep and reconstruction settings](../artifacts/imodem-slmodemd-v90-44000-lapm-soak-20261002/speed-sweep-summary.json)
- [Faster connection state and clipping counters](../artifacts/imodem-slmodemd-v90-44000-lapm-soak-20261002/result.json)
