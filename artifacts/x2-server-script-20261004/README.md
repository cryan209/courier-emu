# The I-modem's downstream training script

`script.json` is `tools/decode_server_script.py` on the I-modem's DSP program dump
(`dsp-program.bin`, written by `tools/probe_imodem_analog_pair.py`). The state names
and the interpreter description come from reading the original instructions and from
data traces of `@48`, `@49` and `@22` in a 53333/x2 call (not kept: they are long run
lists); the measured stretch boundaries are those of
`artifacts/x2-server-training-20261004`. The script durations equal the measured
stretch lengths in symbols: 363 (20 of zero, then 352 + 11), 20004, 6000, 1152.
