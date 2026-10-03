# I-modem against the emulated 3453C, 2026-10-03

The pair does not establish a call. The final V.90-selected run executes
150 million 3453C supervisor instructions and 400 million I-modem instructions,
exchanging 66.6 seconds of line samples. The 3453C consumes its complete
`ATX1S27=1S58=1DT5551234` command and goes off hook, but remains in `dialing`.
No incoming call is offered to the I-modem; it returns OK to configuration
and never reports CONNECT. Neither queued payload marker is delivered.

Both captured analogue directions are entirely zero (532,800 samples each).
The native codec reports no register writes, no programmed sample rate and
sample_rate 0. The separate behavioral codec reports successful bring-up;
that does not establish native datapump audio operation. These observations
identify a failure before training, not a V.90 interoperability failure or
a measured data-corruption result. No CPU/DSP error is reported in the final run.

The recovered mask ROM downloads a matching resident, and 4,096 overlay words
are verified. An independent initial-input ATI0 control returns 5608A with
no queued bytes remaining (`ati0-control.json`). The parameter flash is copied
to a temporary private file for every run; the source capture is not modified.

Final evidence: `v90-full/result.json`, `v90-full/summary.json`,
`v90-full/verification.json`, checkpoints, and WAV/G.711 captures.
The 30-million-instruction initial-input control is in `v90-boot-command/`.
The earlier scheduled-input control (`v90-local-socket/`) leaves all 24 dial
bytes queued and therefore is not a valid negotiation test. `v90/` and
`v90-retry/` record sandbox socket startup failures. The parameterless dial
preflight fails during overlay acknowledgement and is not the final test.

The pair probe now supports `--analog-board 3453c`, selecting stock 2_3_33.XMF,
the recovered-ROM worker boot configuration, and optional private parameter flash.
No carrier, rate, training waveform or received payload is injected.
The 3453C boot/monitor and pair-probe regressions pass: 37 tests.

Repeat with a fresh output directory:

```sh
.venv/bin/python -m tools.probe_imodem_analog_pair \
  --analog-board 3453c \
  --analog-parameter-flash artifacts/3453c-parameter-sector-20261003/f8000-fbfff.bin \
  --protocol v90 --instructions 400000000 --analog-instructions 150000000 \
  --analog-send '3453C-TO-IMODEM-12345' \
  --imodem-send 'IMODEM-TO-3453C-67890' \
  --output artifacts/imodem-3453c-pair-repeat
```

The next investigation is the 3453C runtime Si3034/serial audio and call
control path. Increasing protocol coverage cannot establish interoperability
while the originating call remains in dialing with silent output.
