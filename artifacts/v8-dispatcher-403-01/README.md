# V.8 dispatcher, 403 linked pair

```sh
./courier link artifacts/courier-board-21210-capture-403/courier-board.rom \
  --with-dsp --nvram-fixture idsdl403 --board-id 7 --dip-preset default --tick-ms 5 \
  --a-at ATX0 --a-at ATDT5551234 --b-at ATA \
  --instructions 85000000 --summary
```

`run-baseline.json` is the same command with `_find_call_overlay`'s pre-linked
test forced true, i.e. the behaviour before this change. Every V.8 number is
identical in the two; only `call_overlay_available` differs.

## Audio capture

`run-audio.json` and `audio/` are the same command with `--audio-dir`.

| wav | frames | peak | nonzero | first | last |
|---|---:|---:|---:|---:|---:|
| `a-tx` | 127,200 | **0** | **0** | - | - |
| `b-rx` | 126,400 | **0** | **0** | - | - |
| `b-tx` | 126,400 | 17,188 | 23,841 | 96,273 | 120,113 |
| `a-rx` | 126,400 | 17,188 | 23,841 | 96,273 | 120,113 |

B to A is sample-exact. A transmits silence for the whole run.
