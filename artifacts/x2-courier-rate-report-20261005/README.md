# Courier and I-modem reported-rate handoff

5 October 2026. See `../../docs/x2-courier-mp-fields.md` and x2 technical
specification Draft 0.33, clauses 21 and 22.

- `verification.json`: 46 original DSP threshold cases, 45 original DSP
  report contexts, 150 supervisor mailbox-to-result contexts and 15 original
  I-modem selector contexts, plus 210 original I-modem source-bit consumer
  contexts. Firmware hashes identify both profiles.
- `live-first-ceiling.json`: the first E2DD invocation in the paired call;
  metric 4220 becomes 3F20, selecting index twelve.
- `live-handoff.json`: DSP 031C writes, tag-6A reports and supervisor rate
  cell writes. The later disconnect reset explains the final peek of one.
- `live-imodem-selector.json`: original CFF4 execution in the paired call,
  working MP cells, index zero and allocation nineteen, with both terminal
  results.
- `dsp-report.asm`, `supervisor-report.asm`, `imodem-selector.asm`: original
  instruction listings for the relevant profiles.

Component reproduction:

```
.venv/bin/python tools/verify_courier_rate_report.py
```

Live reproduction uses the same paired-call settings as the MP audit:

```
COURIER_DSP_TRACE_LIMIT=10000 \
.venv/bin/python tools/probe_imodem_analog_pair.py \
  --analog-settings 'X1S27=1S54=0S58=48&A3&B1Q0&U26&N39' \
  --imodem-settings 'S54=0S58=48&A3&B1Q0' \
  --imodem-nvram artifacts/imodem-pair-x2-full-rate-routed-20261002/nvram-230400-switch2.sav \
  --instructions 300000000 --analog-instructions 220000000 \
  --analog-mem-watch 0a17:0a28 --analog-dsp-write-watch 031c \
  --analog-dsp-trace-range e2dd:e307 \
  --analog-dsp-peek 031c --analog-dsp-peek 0364 \
  --output /private/tmp/x2-rate-ceiling-call
```

For the I-modem selector run, use a separate output directory and replace
the analogue trace options with `--dsp-trace-range cff4:d01c`. The harness
saves the server data and program dumps. These are capped calls; later
disconnect/reset must not be mistaken for the connection-time rate state.
