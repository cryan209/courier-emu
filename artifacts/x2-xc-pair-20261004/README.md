# Symmetric x2 regression after XC condition timing correction

Both Ie030002 endpoints report CONNECT 64000/ARQ/x2/LAPM and deliver
CALLER-X2-XC / ANSWER-X2-XC in the opposite direction. verification.json
checks 12033 consecutive GPC state transitions and two zero-history resets
at each endpoint. The source width is eight with mask FF and octet reversal.

Reproduction requires local socket access:

```
.venv/bin/python tools/probe_imodem_pair.py --protocol x2 --settings S54=0S58=48 --nvram artifacts/imodem-pair-x2-full-rate-routed-20261002/nvram-230400-switch2.sav --trace-negotiation --trace-digital-path --instructions 180000000 --originate-send CALLER-X2-XC --answer-send ANSWER-X2-XC --check-connect --check-x2 --output artifacts/x2-xc-pair-20261004
.venv/bin/python tools/verify_x2_scrambler_trace.py artifacts/x2-xc-pair-20261004
```

The worker's socket close can produce a peer broken-pipe message during
shutdown after successful transfer. The saved call results and verification
establish the successful carrier and bidirectional payload.
