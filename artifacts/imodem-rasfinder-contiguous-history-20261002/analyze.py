import json, math
from pathlib import Path
p = Path(__file__).resolve().parent
addresses = json.loads((p / "capture-addresses.json").read_text())
rows = json.loads((p / "decisions.json").read_text())
def signed(v):
    return (v & 65535) - (65536 if v & 32768 else 0)
prev = None
history = {}
counts = dict(rows=len(rows), adjacent=0, gaps=0, index_errors=0, history_checks=0, history_errors=0, reference_checks=0, reference_errors=0, resets=0)
errors = []
blocks = []
block = []
for row in rows:
    d = dict(zip(addresses, row[5:]))
    ref = d[0x3e8] * 65536 + d[0x3e9]
    state = d[0x6d]
    diff = signed(row[2])
    ix = d[0x393]
    val = signed(d[0x38f])
    adjacent = prev and row[1] - prev[0][1] < 8000 and ((ix - prev[1][0x393]) & 65535) == 1
    if adjacent:
        counts["adjacent"] += 1
        old = history.get((ix - 64) & 65535)
        if old is not None:
            counts["history_checks"] += 1
            if diff != signed(val-old):
                counts["history_errors"] += 1
        pr, pd, pref = prev
        increment = (signed(pr[2]) ** 2 * pd[0x3d4]) // 16384
        expected = (pref + increment) & 0xffffffff
        if ref == expected:
            counts["reference_checks"] += 1
        elif ref < expected and state == 0x97b2 and pd[0x6d] == state:
            counts["resets"] += 1
        elif state == pd[0x6d]:
            counts["reference_errors"] += 1
            if len(errors) < 20: errors.append([row[1], state, ref, expected, pd[0x3d4], increment])
    else:
        if prev: counts["gaps"] += 1
        history.clear()
        if block: blocks.append(block)
        block = []
    history[ix] = val
    # Keep only a short buffer while preserving the exact 64-frame predecessor.
    history.pop((ix - 128) & 65535, None)
    block.append([row[1], state, diff, val, ref, d[0x3e4]*65536+d[0x3e5], d[0x6e], d[0x3d4]])
    prev = row, d, ref
if block: blocks.append(block)
report = {"counts":counts, "reference_error_examples": errors, "contiguous_blocks": [len(b) for b in blocks]}
(p / "history-analysis.json").write_text(json.dumps(report, indent=2))
print(json.dumps(report, indent=2))
