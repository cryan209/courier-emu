# FSK renders, and one failed loopback

`v21-*` and `bell103-*` are the firmware's own modulator keyed from outside at
24 samples a bit. `harness_keying_rate` in each manifest is this harness's
choice, not the firmware's bit clock - see `docs/fsk-modulation.md`.

`loopback-attempt.py` replays dispatch entry `d7fc`'s own bring-up and feeds
each transmitted sample back as the next received one. It runs 1152 samples
inside the firmware and recovers nothing: `DXR` reads zero from the second
sample and the demodulator's soft decision at `@6a` never changes sign. It is
kept because it is the exact point the work stopped, not because it works.
