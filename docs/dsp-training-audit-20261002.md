# DSP training audit, 2026-10-02

V.32/V.32bis and V.34 still do not establish native carrier in the
I-modem/analogue-Courier pair. The CPU corrections below are verified defects,
but neither is established as the cause of the connection failure.

## Corrected CPU behavior

Against the repository's `spru056d-c5x-users-guide.pdf`:

- `DMOV` and `LTD` now limit their delay-line copy to on-chip data RAM.
  External memory and memory-mapped registers are still read, and `LTD`
  still performs its multiply-accumulate and TREG loads. They no longer
  produce an extra write to the next external word (6-104 and 6-142).
- Taken `BANZD`, `BCNDD`, `CALAD`, `CALLD`, and `RETCD` now cost two cycles
  for the transfer itself, plus the separately executed delay-slot costs.
  They previously cost four plus the slots (6-56, 6-60, 6-82, 6-86, 6-205).
- Long-immediate `LACC`, `OR`, and `XOR` now cost two cycles rather than one.

The serial diagnostic includes `delay_move_ignored`, `delay_move_last_pc`,
and `delay_move_last_address`, reset with the DSP. Both ends report zero
ignored moves in the corrected V.32bis and V.34 pair runs. Therefore the
external-write defect is not exercised in those runs.

## Verification

The C5x, I-modem, bridge audio-rate, and resampler regression selection passes
117 tests, including the new instruction-cost and delay-line cases:

```sh
.venv/bin/python -m pytest -q tests/test_c5x*.py tests/test_imodem*.py \
  tests/test_bridge_audio_rates.py tests/test_resample_rate_changes.py
```

The Bell 103 control retains CONNECT and delivery of both distinct payloads:
[summary](../artifacts/imodem-analog-pair-bell103-cpu-audit-20261002/summary.json).

The corrected V.34 run reaches image 6, reports symbol-rate index 5 at
7.8246 seconds, reports `0006:0000` at 15.8402 seconds, then repeats the
symbol-rate/retrain sequence. Neither DTE reports CONNECT:
[summary](../artifacts/imodem-analog-pair-v34-cycle-fix-20261002/summary.json).

The V.32bis control fixes `&N8` (14400), disables V.34/V.FC with `S56=192`,
and disables PCM with `S58=33`. It reaches repeated `0020:0004` reports,
followed by `0006:0000` and `0038:0000`. Neither DTE reports CONNECT:
[summary](../artifacts/imodem-analog-pair-v32-cycle-fix-20261002/summary.json).

A separate plain V.32 control fixes `&N6` (9600), additionally disables V.8
with `S54=192`, and selects `&M0&B0` on both ends. Both return NO CARRIER:
[summary](../artifacts/imodem-analog-pair-v32-no-v8-20261002/summary.json).
The file name `v32` on the 14400-bps controls describes the family; those
specific runs are V.32bis controls, not plain V.32 carrier verification.

## Further native tracing

The V.34 image's `9316..931b` increments data `0337` and queues report tag
6 through the original sender at `85f5`. The
[retrain-producer trace](../artifacts/imodem-analog-pair-v34-retrain-caller-20261002/result.json)
observes this code executing. Tag 6 here must not be treated as CONNECT.

The
[condition trace](../artifacts/imodem-analog-pair-v34-retrain-condition-20261002/result.json)
captures the `96be..96c6` counter comparison and writes to data `031a`.
This routine compares the counter against `bb80`, then either returns or
pops and advances its caller's return address by two words. This is native
firmware control flow, not a supervisor-injected carrier indication. Naming
the complete failed training transition still requires tracing the receive
state changes and the path into `92e2`/`9316`.

The byte-exact overlay transfer and preserved Bell 103 payload path do not
prove the remaining DSP arithmetic, training waveforms, or phase transitions.

## Live overlay publication audit

`tools/probe_imodem_analog_pair.py --audit-overlays` now captures each CPU
two-word holding-register commit and reads the installed program words just
before the final completion strobe. The supervisor has already polled both
half-block acknowledgements at that boundary. This is an observer: it neither
installs code nor changes DSP registers or acknowledgements.

The 230M-instruction V.34 run verifies these I-modem transfers:

| Image | Destination | Transferred words | Mismatches |
|---|---|---:|---:|
| 10 | `d100` | 7536 | 0 |
| 11 | `9260` | 16000 | 0 |
| 6 | `a000` | 13912 | 0 |

The supervisor rounds images 11 and 6 up by three words. The transferred
bytes, including those extra words, match the corresponding flash source
spans in `Ie030002.nac`. The DSP destination advances by exactly the
transferred length. PA7 is `0002` at all three boundaries, with both pending
half-block bits clear, and the DSP PC is in the resident loader `82b1..82b7`.
The analogue side independently verifies 20,096 words across its images 6
and 8, at `9d00` and `dc00`, with no unreadable words.

The plain V.32 control verifies seven I-modem transfers: startup images
10/11, image 8 at `9260`, then two startup reload pairs. All have zero
program mismatches, exact destination advancement, clear pending bits and
flash-source matches. The analogue side requests no overlay in this control.
Neither protocol establishes carrier.

Evidence:

- [V.34 boundary checks](../artifacts/imodem-analog-pair-overlay-audit-20261002/overlay-verification.json)
- [V.32 boundary checks](../artifacts/imodem-analog-pair-v32-overlay-audit-20261002/overlay-verification.json)
- [V.34 native write trace](../artifacts/imodem-analog-pair-overlay-write-audit-20261002/result.json)

The final V.34 program dump differs from image 6 in 2,133 words beginning
at `ce00`; resident image 5 remains identical. The trace identifies the first
address's writer as the native `BLDD` at `b4ea` (reported PC `b4eb`, its
immediate word). At `b4e2` the firmware explicitly loads AR0 with `ce00`,
adds that base to a circular-buffer index, and copies a sample from data
`04b6` into that buffer. The observed values at `ce00` are `2000`/`e000`
(+8192/-8192). No PC events occur in `cdfe..ce10` during the traced run.
This explains the first changed address as firmware buffer use; it does
not establish the safety of every later write or every training phase.

Reproduce the V.34 boundary and write audit:

```sh
.venv/bin/python -m tools.probe_imodem_analog_pair --protocol v34 \
  --instructions 230000000 --audit-overlays --dsp-data-trace ce00 \
  --dsp-trace-range cdfe:ce10 --output artifacts/overlay-audit-new
```

The focused probe and overlay-handshake tests pass 11 cases, including
an observer check that detects a corrupted word without repairing it.

## Remove the foreground host bypass

The transfer checks above originally ran with a hidden host-side command-2
acknowledgement. That was a guest RAM/status patch, not a physical ASIC
handshake. `ImodemDsp` now defaults to `foreground_overlay_assist=False`;
the pair probe exposes the old bypass only via `--assist-overlay-command`.
The host publishes incoming command ports and a pending bit; native firmware
must consume the command, update its destination and acknowledge it.

The current unassisted core still completes all three V.34 transfers with
zero program mismatches, reaches symbol-rate selection, and later retrains.
Its endpoint records zero host assists. The older bypass is therefore not
needed with the current core. No bisection yet attributes that difference
to a particular intervening CPU correction.

The unassisted Bell 103 control connects and delivers both payloads:
[summary](../artifacts/imodem-analog-pair-bell103-unassisted-20261002/summary.json).
The longer unassisted V.34 evidence is
[here](../artifacts/imodem-analog-pair-v34-unassisted-training-20261002/result.json).
The acquisition/training failure persists after removing this host patch.

## Sustained scrambled-sounding training section

The finer checkpoints place the sustained output in native transmit state
`b391`, with sequence pointer `b2d9`, from line frames 338 through 378.
The short transmit countdown cycles through values 0..7, while data `031a`
counts down from 14565 through 11137, 7708, 4279 and 850 at one-second
intervals. At frame 388 the transmit state has changed to `9e49`, the
sequence pointer to `9e10`, and retrain count `0337` has increased to one.
This is a live training state with progressing counters, not a frozen DSP.

The native PC trace repeatedly executes `b391..b3ce`. Its call at `b3ca`
reaches the original scrambler `9053`; the data trace records 4096 retained
scrambler-state writes at `03d8`, from instructions `9069` and `9071`, with
511 different values. The captured five-second waveform has 50 distinct
100 ms blocks and 178 distinct mu-law codewords. Thus neither a held final
sample nor repeated 100 ms socket audio explains the sustained sound.

Evidence:

- [State/counter checkpoints](../artifacts/imodem-analog-pair-v34-sustained-training-20261002/sustained-state.json)
- [Native scrambler execution and state writes](../artifacts/imodem-analog-pair-v34-scrambler-progress-20261002/result.json)

The generator identifies this as sequence J: `b391` extracts two-bit groups
from `@49`, scrambles them through `9053`, and differentially encodes
them through `b533`. The word is `89b0` (not `8990`: the receivers compare with bit 5 masked,
which is where `8990` came from); its least-significant-bit-first representation is
`0000110110010001`, the **16-point** J pattern in ITU-T V.34 Table 18. The four-point pattern is
`0000100110010001`, `8990`. See `docs/x2-v90-protocol-selection.md` (J bit 5).
Section 11.3.1.2.4 says the answering modem sends J while awaiting the
caller's S and S-to-S-bar transition.

## What the sustained state is waiting for

The receive callback remains `a0f9`; its qualification helper `a194` checks
the signed timeout at `031a`, the holdoff at `032c`, a threshold on
`03d0:03d2`, then requires signed `03b4` to be negative. The holdoff is zero
and the threshold passes, but the final metric remains nonnegative. In the
last retained trace it is +2. The next expired timeout is -19 and takes
the native `92a9` recovery path, eventually reporting retrain.

The answering modem is therefore waiting for the caller's training response
to qualify. Naming that response S follows from the J generator and the
standard's sequence; the native metric's precise signal-processing meaning
still needs further tracing. In the clock-corrected capture the answering
modem's received PCM is entirely zero from 6.985375 through 13.505750 seconds.
Those samples match the analogue Courier's recorded transmit silence, so
the captured transport did not discard a response during that interval.
Why the calling Courier does not recognize/respond to J remains unresolved.

Evidence:

- [Receive qualification and timeout trace](../artifacts/imodem-analog-pair-v34-receive-wait-20261002/result.json)
- [ITU-T V.34 (1996), Table 18 and section 11.3.1.2.4](https://www.itu.int/rec/dologin_pub.asp?id=T-REC-V.34-199610-S!!PDF-E&lang=e&type=items)
