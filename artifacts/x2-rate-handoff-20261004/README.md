# QF060003 PCM record and data handoff evidence

See [the detailed reconstruction](../../docs/x2-rate-and-data-handoff.md).

`verification.json` records the verified scope, rate-selection rule and forty
integrated profiles. `57333-trace.json` contains original instruction-boundary
snapshots for record acceptance, selected rate, bank construction, mapped
output and later payload-source activation. `handoff.asm` retains the original
instructions and raw callback triplets.

Reproduce with `.venv/bin/python tools/trace_x2_rate_handoff.py`. The tool
injects decoded input bits, local call state and source octets. It does not
seed the received working record, selected rate index or final banks. Tests
include CRC rejection and sparse local rate masks. No complete x2 call or
analogue client measurement/report producer is asserted.
