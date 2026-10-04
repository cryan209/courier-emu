# Symmetric x2 call on the bearer, before the gate

`analysis.json` is `tools/analyze_bearer_handshake.py` run on the octets each
I-modem received in the recorded symmetric call (`S54=0S58=48`, Ie030002,
`nvram-230400-switch2.sav`). Capture with `COURIER_PAIR_WIRELOG=<prefix>` on
`tools/probe_imodem_pair.py`; the raw logs (about 300 kB each) are not kept.

```
COURIER_PAIR_WIRELOG=/tmp/gatewire .venv/bin/python tools/probe_imodem_pair.py --protocol x2 --settings S54=0S58=48 --nvram artifacts/imodem-pair-x2-full-rate-routed-20261002/nvram-230400-switch2.sav --instructions 250000000 --originate-send CALLER-X2 --answer-send ANSWER-X2 --output out
.venv/bin/python tools/analyze_bearer_handshake.py /tmp/gatewire.<pid>
```

The tool needs numpy. A `V.21 ch1` event that coincides with tone B is the FSK
detector responding to the 1200 Hz tone, not a message. V.8 octets are listed
raw: the recommendation text is not in the repository.
