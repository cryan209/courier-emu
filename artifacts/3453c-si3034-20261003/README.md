# Native Si3034 correction and pair retest

See [implementation notes](../../docs/3453c-si3034-emulation.md).

`boot-control-fixed.json` confirms firmware-generated ATI0 = 5608A after
enabling the native Si3034 serial codec and correcting mailbox output-latch
priority. The guest programs PLL registers 7–9 and reaches 7,200 Hz.
`boot-control.json` retains the intermediate mailbox-output diagnostic failure.

`v90-pair/` is the longer 150M analogue / 400M I-modem run after the serial
protocol and PLL correction. It clocks 244,305 primary codec frames and
executes 36 register writes. It still remains in dialing, with no incoming
call, no carrier and no delivered payload. Both PCM captures remain silent.
`v90-final-control/` repeats the same pre-training failure using the final
implementation, including external line status and gain/mute handling,
with 30M analogue / 150M I-modem instructions. Its native codec clocks
45,756 primary frames at 7,200 Hz. Neither run reports a CPU/DSP error.

Verification JSONs, complete machine reports, checkpoints and raw audio are
retained in both directories. The source hardware parameter flash is copied
to temporary storage for each run and is never modified or included here.

The final relevant regression suite passes 132 tests, including ten new
Si3034 cases, existing C5x instructions/interrupts, AC01 behavior, board
bootstrap, audio rates, ASIC registers and the pair probe. `git diff --check`
also passes.

Repeat with a fresh output directory:

```sh
.venv/bin/python -m tools.probe_imodem_analog_pair \
  --analog-board 3453c \
  --analog-parameter-flash artifacts/3453c-parameter-sector-20261003/f8000-fbfff.bin \
  --protocol v90 --instructions 150000000 --analog-instructions 30000000 \
  --analog-send '3453C-TO-IMODEM-12345' \
  --imodem-send 'IMODEM-TO-3453C-67890' \
  --output artifacts/3453c-si3034-repeat
```

This proves guest codec setup and PCM clock/queue servicing. It does not
prove complete Si3034 electrical behavior or modem interoperability; the
remaining 3453C call-control/ASIC path does not yet reach training.
