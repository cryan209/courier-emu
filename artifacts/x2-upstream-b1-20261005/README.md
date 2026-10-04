# Courier x2 upstream B1, 5 October 2026

B1 acquisition is fixed in v90modem. The original capture is
`../x2-upstream-e-20261005/courier-upstream.g711` (278249 PCMU samples;
SHA256 b01953a0b55f5784692c53b13dd4f1f7a115a6aa38b01a1d74ff379b9bfcbefe).

- `live-b1-setup-trace.json`: fresh paired original-firmware call, B1A1..B1C2.
  B1B4 carries N=10 (24000 upstream bit/s) into the mapper builder.
- `analog-dsp-{program,data}.bin`: retained original DSP snapshot from the
  preceding MP call, supplying program and lookup tables to controlled execution.
- `native-verification.json`, `mapper.asm`, `native-symbols.json`: original
  B1A1 setup followed by AF99/mapper execution for 480 Q9.7 symbols. The
  received word, direction and mask are seeded explicitly, not inferred from
  a complete replay. Each symbol decrements the outer scheduler's 03CA counter.
- `reference.c`, `reference-*.json`, `reference-comparison.json`: SpanDSP
  all-one mapper comparison. Expanded shaping matches all 480 amplitude norms;
  expanded/64-state matches 475 complex symbols, versus 49 for minimum/16-state.
  The five remaining rotations are not resolved by this acquisition fix.
- `default-replay.log`: full engine, default settings, 99.9% B1 fit; separate
  256-symbol check has lattice distance 0.252, power 147.2 against 147.7.
  Winning settings are GPA/expanded/64-state. The decoder receives the winning
  trellis too. End state remains TRAINING; decoded upstream payload is unverified.
- `disabled-replay.log`: ME_X2_UPSTREAM_ACQUIRE=0 disables acquisition.
- `acquisition-tests.log`: capture at block sizes 17 and 160 acquires above
  95%, selects expanded/64-state in template and decoder; silence is rejected.
- `v34-data-tests.log`: all 402 V.34 data decoder cases pass.

Reproduce:

```
.venv/bin/python tools/verify_x2_upstream_b1.py
cc -I/opt/homebrew/opt/libtiff/include -I../v90modem/spandsp-master/src artifacts/x2-upstream-b1-20261005/reference.c ../v90modem/spandsp-master/src/.libs/libspandsp.a -lm -o /private/tmp/x2-b1-reference
/private/tmp/x2-b1-reference 24000 4 6 0 1 2
make -C ../v90modem x2-b1-test v90_engine_replay
ME_MODE=x2 ../v90modem/v90_engine_replay artifacts/x2-upstream-e-20261005/courier-upstream.g711 ulaw --fast --from 0
```

B1's logged sample 8309 is relative to the prepared 9600-Hz T/3 ring, not
an absolute PCMU bearer sample. No G.711 gain adjustment or resampling was
introduced in the engine input path. The internal V.34 receiver still uses
its existing T/3 processing.
