# x2 symmetric startup source impairment

`tools/x2_source_impairment.py` flips a bit in one of every six octets of the
symmetric startup source as it crosses the PCMU bearer (the source is not
transformed on the wire). Enable it with `COURIER_X2_SOURCE_IMPAIR=phase[,phase...][:mask]`
for `tools/probe_imodem_pair.py`:

```
COURIER_X2_SOURCE_IMPAIR=2 .venv/bin/python tools/probe_imodem_pair.py --protocol x2 --settings S54=0S58=48 --nvram artifacts/imodem-pair-x2-full-rate-routed-20261002/nvram-230400-switch2.sav --instructions 250000000 --originate-send CALLER-X2 --answer-send ANSWER-X2 --output out
```

Results (`verification.json`): unimpaired 64000/x2 with host report `006a:1010`;
LSB flips on phase 2 or phase 5 give 56000/x2 with `006a:0e0e` and both payloads
delivered; a flip of bit 1 on phase 2 loses x2 (V.34 at 24000/31200).

Sweep of all six phases (LSB): every phase gives 56000/x2 with `006a:0e0e`, and
the frame word `w2` (`((map << 1) & 7e) | 1`) each end sends is a distinct
single-bit map: phase 0 `41`, 1 `03`, 2 `05`, 3 `09`, 4 `11`, 5 `21`. Phases are
counted from the seventh `7e` of the run.

Multi-phase LSB errors (`COURIER_X2_SOURCE_IMPAIR=0,3` and so on): `{0,3}`,
`{1,2}`, `{0,2,4}` and all six phases all connect at 56000/x2 with
`006a:0e0e`, and the map word is the bitwise OR of the single-phase words
(`49`, `07`, `55`, `7f`).
