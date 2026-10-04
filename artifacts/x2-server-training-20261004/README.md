# The I-modem's downstream training signal

`analysis.json` is `tools/analyze_server_training.py` on the octets the I-modem sent
to the analog Courier (`imodem-tx.g711`, written by `tools/probe_imodem_analog_pair.py`)
from 7.0 s to 12.2 s of the bearer capture, after the 7-bit marker. The tool splits the
stream where the set of codewords changes, gives each segment's levels and exact period,
and for two-level segments descrambles the sign bits. The `manual_notes` entries are
period and level counts measured separately on the same octets.

```
.venv/bin/python tools/analyze_server_training.py out/imodem-tx.g711 7.0 12.2
```

The command that produced the capture is in `artifacts/x2-courier-phase3-20261004/README.md`.
Needs numpy.
