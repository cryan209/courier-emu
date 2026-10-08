# x2 received-tone Phase 2 evidence — 5 October 2026

Fresh feedback calls use the original analog Courier 403 and Ie030002 I-modem
against `v90_engine_peer`. The engine consumes live native samples before
producing each reply, paced at 8000 samples/s. No captured response or forced
native protocol state is used. `call.json` records firmware/AT commands,
engine SHA-256, environment, sample counts, and transport calibration.
`results.json` summarizes the engine stages, accepted marker, MP, and media
hashes. Engine PAYLOAD means its local transmit script progressed; it does
not mean the native modem connected or accepted user data.

| Run | Change | Live result |
| --- | --- | --- |
| analog-event-driven | Received B drives both A reversals; no probe | No marker |
| analog-probe | Add 160 ms multitone probe | 4d; MP 0344/03fe/0000/0500; no upstream E/CONNECT |
| analog-recovery | Also recover repeated unacknowledged INFO0 | Same successful marker/MP; no upstream E/CONNECT |
| analog-marker-regression | Final code with --require-marker | Assertion passes; 4d and same MP; no upstream E/CONNECT |
| imodem-event-driven / imodem-probe | Before repeated-INFO0 recovery | Repeated INFO0; no marker |
| imodem-recovery | INFO0 recovery plus tone handshake/probe | Both reversals and probe; no marker |
| native-imodem-asymmetric-control | Original caller S58=58, original answerer S58=48 | Neither native endpoint connects |

The successful analog runs are separate process launches with identical
media hashes, expected for this deterministic emulator. The I-modem control's
parent summary lists common settings S58=48; its wrapper explicitly selects
S58=58 for the originating worker and S58=48 for the answering worker.
Each side's working S-register report is the authoritative actual setting.
The control does not disprove other native asymmetric configurations.

## Reproduction

From courier-emu, after building `make v90_engine_peer` in sibling v90modem:

```sh
.venv/bin/python tools/probe_v90modem_closed_loop.py analog --output /tmp/x2-analog-phase2 --instructions 200000000 --require-marker
.venv/bin/python tools/probe_v90modem_closed_loop.py imodem --output /tmp/x2-imodem-phase2 --instructions 160000000
.venv/bin/python artifacts/x2-phase2-20261005/native-imodem-asymmetric-control/probe.py --help
```

Native control wrapper `probe.py` uses the existing probe_imodem_pair arguments
and substitutes per-worker settings without changing native DSP protocol state.
Its classifier captures watch FFD9 and PC DE14; the inherited introductory
comment mentioning amplitude writes describes the original wrapper, not this
control's selected watch.

## Timing and recovered probe

V.34 (10/1996) §11.2.1.2.3–.5 specifies first A reversal after received B
and at least 50 ms A, second A reversal 40±1 ms after received B reversal,
then 10 ms A before probing. §11.2.2.2.1 specifies INFO0 recovery;
§10.1.2.4/Table 17 supplies the multitone frequencies and signs. The local
source is `v90modem/ITU Docs/T-REC-V.34-199610-S!!PDF-E-1.pdf`.

The successful original native I-modem-to-analog capture
`artifacts/imodem-analog-x2-53333-production-20261003/imodem-tx.g711`
contains a multitone probe at approximately 5.01–5.17 s, RMS about 2450,
not silence. The Table 17 waveform fitted to samples 40240:41040 gives
89.8356% normalized fit, best offset 35/160, amplitude 718.0457. This supports
the tone family and duration, not byte-for-byte waveform identity. The software
uses amplitude 750 per component and preserves raw 8 kHz PCMU output.

## Native path qualification

`analog-recovery/analog-dsp-first-exec.bin` retains all 65536 little-endian
uint64 first-execution CPU instruction counts. Zero means never executed.
`native-path-coverage.json` records selected PCs and its SHA-256. Fast marker
builder 9083 executes; fallback 909B does not. AE83, AF2E/AF38 and
B1A1/B1B4/B1C2 never execute, although AEA5 and later AF63 do. This establishes
that the remaining upstream failure precedes native E/B1 transmission; it
is not merely software failure to recognize a transmitted B1.

## Validation

Production engine/peer builds pass. x2_session_test checks received-tone timing
and INFO0 recovery with 1/17/160-sample chunks, plus the recorded MP/E session.
x2_b1_test acquires the preserved upstream recording at 99.9% with expanded
shaping and the 64-state trellis at 17/160 samples and rejects silence.
v34_data_test passes all 402 cases. Live E/B1, CONNECT and bidirectional
V.42/LAPM data remain unverified. The next analog investigation is the native
training/MP-to-E handoff; the working native I-modem symmetric mode needs its
own software session.
