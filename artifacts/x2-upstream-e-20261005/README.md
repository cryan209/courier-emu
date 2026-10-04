# x2 upstream E continuation

5 October 2026. See `../../docs/x2-courier-mp-fields.md`.

- `receiver.asm`, `transmitter.asm`: original Ie030002/Courier 403 E paths.
  AE83 is script data, a triplet AF2E/0/5; the generic listing treats its
  words as instructions. AF2E/AF38 supplies four ones per symbol in this call.
- `verification.json`: nine original A881/AABF execution contexts, after
  accepted MP. Twenty uninterrupted ones enter A891; shorter or interrupted
  prefixes do not. An interruption returns to the record receiver.
- `courier-upstream.g711`, `capture.json`: preserved PCMU peer recording,
  provenance/hash and E detector timestamps at three block sizes.
- `session-tests.log`: firmware-vector mapper checks, MP/E regressions and
  full-capture E detection at all three block sizes.
- `default-replay.log`: receive E and downstream PAYLOAD, remaining TRAINING.
- `acquisition-replay.log`: opt-in existing V.34 B1 acquisition probe, which
  fails to acquire and never releases CONNECT.

Reproduction:

```
.venv/bin/python tools/verify_x2_upstream_e.py
../v90modem/x2_session_test artifacts/x2-upstream-e-20261005/courier-upstream.g711
ME_MODE=x2 ME_X2_UPSTREAM_ACQUIRE=1 ../v90modem/v90_engine_replay artifacts/x2-upstream-e-20261005/courier-upstream.g711 ulaw --fast --from 0
```

The standalone E sample is 100074, including detector filter latency.
Engine MP receiver time is relative to its TRAIN_C initialization and must
not be read as the absolute bearer clock. Acquisition is diagnostic and off
by default. Next compare Courier AF99/AFC9/B006 initialization and mapping
against the receiver's B1 reference; no carrier or payload lock is asserted.

The failed acquisition above is the initial minimum-shaping probe. It is
superseded by `../x2-upstream-b1-20261005`: expanded/64-state B1 now acquires
at 99.9% fit by default. Upstream payload/CONNECT remain unverified.
