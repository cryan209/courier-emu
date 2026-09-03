"""Audit upper-window capture and compare it with the prior low RAM snapshot."""
from collections import Counter
from hashlib import sha256
import json
from pathlib import Path
import sys

root = Path(__file__).resolve().parent
sys.path.insert(0, str(root.parents[1]))
from courier_emu.flash_dump import parse_page

manifest = json.loads((root / "manifest.json").read_text())
assert manifest["status"] == "complete" and manifest["anchors_rechecked"]
assert not manifest["failed_attempts"]
records = [json.loads(s) for s in (root / "pages.jsonl").read_text().splitlines()]
assert [(r["pass"], r["physical_address"]) for r in records] == [
    (n, a) for n in (1, 2) for a in range(0x10000, 0x20000, 256)]
images = [(root / f"ram-pass{n}.bin").read_bytes() for n in (1, 2)]
for image, saved in zip(images, manifest["passes"]):
    assert len(image) == 65536 and sha256(image).hexdigest() == saved["sha256"]
counts = Counter()

def response(name, address):
    data, terminal = parse_page((root / "responses" / name).read_bytes(), address,
                                allow_ram=True, allow_upper_ram=True)
    counts[terminal] += 1
    return data

for record in records:
    address, number = record["physical_address"], record["pass"]
    data = response(record["response"], address)
    offset = address - 0x10000
    assert data == images[number - 1][offset:offset + 256]
    assert data == (root / "blocks" / f"pass{number}-{address:05x}.bin").read_bytes()
    assert record["bytes"] == 256 and sha256(data).hexdigest() == record["sha256"]
for address in (0x80000, 0xFFF00):
    assert response(f"anchor-before-{address:05x}-a1.txt", address) == response(f"anchor-after-{address:05x}-a1.txt", address)
alias = []
for row in manifest["alias_samples"]:
    low, high = row["lower_address"], row["upper_address"]
    before = response(f"alias-low-before-{low:05x}-a1.txt", low)
    upper = response(f"alias-upper-{high:05x}-a1.txt", high)
    after = response(f"alias-low-after-{low:05x}-a1.txt", low)
    stable = [i for i in range(256) if before[i] == after[i]]
    assert row["lower_stable_bytes"] == len(stable)
    assert row["upper_matches_stable_lower_bytes"] == sum(upper[i] == before[i] for i in stable)
    assert row["matches_lower_before"] == (upper == before)
    assert row["matches_lower_after"] == (upper == after)
    alias.append(row)
assert sum(counts.values()) == 534
assert len(list((root / "responses").glob("*.txt"))) == 534
assert dict(counts) == manifest["terminal_status_counts"]
differences = [0x10000 + i for i, (a, b) in enumerate(zip(*images)) if a != b]
assert json.loads((root / "differences.json").read_text())["physical_addresses"] == differences
assert len(differences) == manifest["changed_bytes"]
low_path = root.parent / "courier-board-21210-ram-01" / "ram-pass2.bin"
low = low_path.read_bytes()
assert len(low) == 0xFF00
assert sha256(low).hexdigest() == "e3889db731f9f897473f31c2cd94348f7f981dbec9d1db39f9633398bef0533a"
comparisons = []
for n, high in enumerate(images, 1):
    different = [i for i, (a, b) in enumerate(zip(low, high)) if a != b]
    comparisons.append({"pass": n, "compared_bytes": len(low), "different_bytes": len(different),
                        "equal_pages": sum(high[a:a+256] == low[a:a+256] for a in range(0, len(low), 256)),
                        "different_offsets": different,
                        "settings_cache_matches": high[0x752:0x764] == low[0x752:0x764]})
report = {"audit": "all upper-window replies, blocks, hashes, differences and bracketed comparisons agree",
          "responses_verified": sum(counts.values()), "sha256": [sha256(b).hexdigest() for b in images],
          "physical_range": "10000..1ffff", "bytes_per_pass": 65536,
          "changed_bytes_between_upper_passes": len(differences),
          "fresh_alias_samples": alias, "prior_lower_comparisons": comparisons,
          "upper_last_page": {"physical_start": "1ff00", "sha256": sha256(images[0][-256:]).hexdigest(),
                              "matches_between_passes": images[0][-256:] == images[1][-256:]},
          "limitations": ["No write-based alias test was performed.",
                          "Identical read data supports mirroring but does not prove shared physical cells.",
                          "Data in this CPU window is not established to be DSP RAM."]}
(root / "audit.json").write_text(json.dumps(report, indent=2) + "\n")
for comparison in comparisons:
    del comparison["different_offsets"]
print(json.dumps(report, indent=2))
