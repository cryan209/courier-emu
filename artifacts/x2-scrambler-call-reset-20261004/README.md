# Live symmetric x2 GPC scrambling

Original Ie030002.nac SHA-256:
`3f9a7aa8033323c28eebfee950b53267a67b7ad9141ebf30271918d0babbe358`.

Both endpoints connect at 64000/ARQ/x2/LAPM and deliver distinct markers.
Eight-bit words are GPC scrambled (`1 + x^-18 + x^-23`, LSB first), then
bit-reversed into bearer octets. Both histories reset to zero at initial
setup and when the data callbacks are selected before CONNECT.

Reproduce from the repository root (requires permission for a local Unix
socket; no external network or hardware):

```sh
PYTHONPATH=. .venv/bin/python tools/probe_imodem_pair.py \
  --protocol x2 --settings S54=0S58=48 \
  --nvram artifacts/imodem-pair-x2-full-rate-routed-20261002/nvram-230400-switch2.sav \
  --trace-negotiation --trace-digital-path --instructions 180000000 \
  --originate-send CALLER-X2-SCRAMBLER --answer-send ANSWER-X2-SCRAMBLER \
  --check-connect --check-x2 --output artifacts/x2-scrambler-call-reset-20261004
.venv/bin/python tools/verify_x2_scrambler_trace.py \
  artifacts/x2-scrambler-call-reset-20261004
```

`digital_path_trace` in each worker result records mode-cell writes plus
instruction-boundary snapshots. Captures are read-only: no DSP registers,
firmware instructions, mode flags, payloads or results are forced.
The tracer samples every million supervisor instructions and retains up to
64 most recent hits per window. It starts at PC e908 (after TX/RX history
clears), then switches to e984 (before the TX scramble test) at CONNECT.
Each capture begins with DSP instruction count, cycles, ACC, DP and carry,
then cells in `capture_addresses` order. History checks use consecutive
captures only within a window; gaps between windows are not checked.

`verification.json` asserts both connections, payload delivery, clean CPU/DSP
results, zero underruns, active flags, widths, callbacks, zero initialization
histories and all 12033 sampled consecutive GPC history transitions.
`focused.asm` is a static listing of the relevant original instructions.
The earlier `artifacts/x2-scrambler-call-20261004` trace sampled TX throughout
setup too, checking 13104 transitions; the reset trace adds direct reset
captures and samples TX after CONNECT.

Seven-bit calls, lower-rate mappings and retrain/fallback resets remain
separate work. 64000 describes bearer information capacity; the test does
not measure sustained terminal throughput or remove LAPM framing overhead.
