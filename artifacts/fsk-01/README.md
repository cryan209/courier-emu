# The modulator alone

`v21-*` and `bell103-*` are the firmware's own modulator keyed from outside at
24 samples a bit, demodulated by this repository's own two-tone detector.
`harness_keying_rate` in each manifest is this harness's choice, not the
firmware's bit clock - see `docs/fsk-modulation.md`.

For the firmware demodulating its own transmitter, see `../fsk-loopback-01/`.
