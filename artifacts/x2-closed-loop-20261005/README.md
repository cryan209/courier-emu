# Original Courier peers against the v90modem x2 engine

These are fresh feedback calls, not recorded-audio replay. The original
403 analog ROM and Ie030002 I-modem execute their native DSP paths. The
engine receives fresh peer samples before generating its next reply. No DSP
register is forced and no CONNECT is injected. I-modem PCMU is byte-exact;
the analog endpoint uses the existing BearerLineLink codec calibration
(`from_line=0.509330871`, `into_courier=0.528445252`). Media is paced at 8 kHz.

Final default-build results:

| Peer | Samples exchanged each way | Media duration | Result |
|---|---:|---:|---|
| analog Courier 403 | 213120 | 26.64 s | INFO0 / Tone A / marker wait / timeout |
| I-modem asymmetric diagnostic, S58=58 | 199955 | 24.99 s | INFO0 / Tone A / marker wait / timeout |

**Neither call reaches the accepted x2 marker, B1, CONNECT, or data.** The
recorded B1 regression still passes; that is a separate acquisition test.
`results.json` lists all runs and SHA-256 hashes of their raw PCMU streams.
Per-run `call.json` records sample counts, pacing, commands/settings and
codec parameters. `engine.log` records live state changes. Final call files
also identify the built engine hash. `native-control.json` is read-only DSP
observation; `native-program.bin` identifies the executed Ie030002 code.

Reproduce after `make -C ../v90modem v90_engine_peer` (use fresh output paths):

```
.venv/bin/python tools/probe_v90modem_closed_loop.py analog --output /private/tmp/x2-analog-new --instructions 160000000
.venv/bin/python tools/probe_v90modem_closed_loop.py imodem --output /private/tmp/x2-imodem-new --instructions 160000000
```

The wrapper binary lives at `../v90modem/v90_engine_peer`. Its stdin framing
is a little-endian 16-bit sample count followed by that many PCMU octets;
stdout contains exactly that many generated octets. Logs go to stderr.
The I-modem harness clocks its actual fresh media chunks, often one octet;
the analog exchange uses 160-sample frames. Do not use `--fast` to interpret
wall-time negotiation timeouts.

## What the experiments isolated

* `analog`, `imodem`: initial B1-fixed build, before these handshake fixes.
  Both complete V.8 but native x2 eligibility remains off.
* `*-tone-end`: stopping Tone A in MARKER_WAIT alone does not solve it.
* `*-recovery`: recognizing 17-bit acknowledged INFO0 after initial INFO0
  causes a real retransmission but still does not unlock native x2.
* `imodem-gate-instructions`: only `9596,9597,9598,9599` execute. The native
  gate returns on clear `039f` bit 10 (`0400`).
* `*-digital-access`: adds V.8 JM PSTN-access octet `8d`; eligibility stays
  off. `*-ansam` tests ANSam without periodic phase reversal; same outcome.
* `imodem-classifier`: at `de14`, `ffd9=8000` permits x2 but the classifier
  ACC is **−131230**; `de15` does not set `039f` bits `1400`.
* `imodem-phase-reversal`: reversing the V.21 carrier between JM messages
  changes ACC to **+210811** and executes `de15`. `039f` becomes `1442`, then
  `1462`, and the native V.8 report becomes `0071:0007`. With S58=48 the
  I-modem subsequently offers INFO0 `3dff`, so this is a digital server /
  symmetric-capable offer, not the desired analog-client offer.
* `native-classifier-control`: unmodified Ie030002 pair, S58=48, both native
  endpoints report x2 CONNECT. Classifier captures give **+133769/+135107**.
  `03e3` carrier-amplitude writes alternate `0012/ffee` at `dd64` between
  messages and at `dd76` during CJ. No user payload was requested in this
  control. Reproduce with `tools/probe_imodem_v8_classifier.py` using the
  same arguments as `probe_imodem_pair.py`.
* `analog-phase-gate`: analog native signature flags become `4040/4060`,
  then the fallback builder clears them to `0020` at `909b`. Its 7-bit
  CRC-valid frame is `13`: ordinary rate index 1 with high carrier. The
  successful fast x2 path would use `9083..908a` to construct `4d` instead.
* `imodem-client-phase-reversal`: S58=50 removes server capability, but
  INFO0 `2dff` still has symmetric capability. `imodem-asymmetric-client`
  uses S58=58 and offers `25ff`. It enters native `95c4..95ef`, then
  `92e2..92ef` clears x2 because `ffd9` bit 1 is clear. No marker follows.
* `analog-final`, `imodem-final`: repeat on the final default x2 build with
  the phase signature enabled through an explicit per-session V.8 API.
  Both retain the later Phase-2 failure. `ME_V8_X2_PHASE_REVERSAL=0` opts out
  for comparison; other modem modes do not enable it by default.

The concrete remaining work is the native fast Phase-2 negotiation that
keeps x2 active and produces `4d`, including received-tone-driven timing and
INFO0 recovery. The current Tone-A waits are hypotheses. Digital I-modem
symmetric x2 is also a distinct session the engine does not implement.
Do not force native flags or accept the fallback `13` as the desired marker.

## Regression checks on the final code

Production `sip_v90_modem` and `v90_engine_peer` build. Recorded session
tests pass, including ACK recovery, MP/E, upstream-E detection with blocks
1/17/160, and capture marker `4d`. B1 acquires the retained Courier recording
at 99.9% with expanded shaping / 64-state trellis at blocks 17/160 and rejects
silence. All 402 V.34 data cases pass. Python harnesses compile.
