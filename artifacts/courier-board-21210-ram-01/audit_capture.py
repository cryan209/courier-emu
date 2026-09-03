"""Recheck the RAM images against saved responses; no serial device is opened."""
from collections import Counter
from hashlib import sha256
import json
from pathlib import Path
import sys

root = Path(__file__).resolve().parent
sys.path.insert(0, str(root.parents[1]))
from courier_emu.flash_dump import parse_page
from courier_emu.ram_dump import decode_settings

manifest = json.loads((root / "manifest.json").read_text())
assert manifest["status"] == "complete" and manifest["anchors_rechecked"]
assert manifest["pages_captured"] == 510
records = [json.loads(s) for s in (root / "pages.jsonl").read_text().splitlines()]
assert [(r["pass"], r["physical_address"]) for r in records] == [
    (n, a) for n in (1, 2) for a in range(0, 0xFF00, 256)]
images = [(root / f"ram-pass{n}.bin").read_bytes() for n in (1, 2)]
for image, saved in zip(images, manifest["passes"]):
    assert len(image) == 0xFF00 and sha256(image).hexdigest() == saved["sha256"]
counts = Counter()
for record in records:
    address, number = record["physical_address"], record["pass"]
    data, terminal = parse_page((root / "responses" / record["response"]).read_bytes(),
                                address, allow_ram=True)
    assert data == images[number - 1][address:address + 256]
    assert data == (root / "blocks" / f"pass{number}-{address:05x}.bin").read_bytes()
    assert record["bytes"] == 256 and sha256(data).hexdigest() == record["sha256"]
    assert terminal == record["terminal"]
    counts[terminal] += 1
for address in (0x80000, 0xFFF00):
    copies = []
    for phase in ("before", "after"):
        data, terminal = parse_page((root / "responses" / f"anchor-{phase}-{address:05x}-a1.txt").read_bytes(), address)
        copies.append(data)
        counts[terminal] += 1
    assert copies[0] == copies[1]
assert not manifest["failed_attempts"]
assert dict(counts) == manifest["terminal_status_counts"]
assert len(list((root / "responses").glob("*.txt"))) == 514
differences = [i for i, (a, b) in enumerate(zip(*images)) if a != b]
assert json.loads((root / "differences.json").read_text())["physical_addresses"] == differences
assert len(differences) == manifest["changed_bytes"]
for n, image in enumerate(images, 1):
    cached = (root / f"settings-cache-pass{n}.bin").read_bytes()
    assert cached == image[0x752:0x764]
    assert decode_settings(cached) == manifest["settings_cache"]["passes"][n - 1]["records"]
assert images[0][0x752:0x764] == images[1][0x752:0x764]
report = {"audit": "both live RAM passes match all saved page responses, blocks and hashes",
          "bytes_per_pass": 0xFF00, "responses_verified": 514, "changed_bytes": len(differences),
          "sha256": [sha256(b).hexdigest() for b in images],
          "settings_cache_hex": images[0][0x752:0x764].hex(),
          "settings_match_between_passes": True,
          "decoded_settings": [r["value"] for r in decode_settings(images[0][0x752:0x764])],
          "excluded_physical_range": "0ff00..0ffff (peripheral registers)",
          "atomic_snapshot": False, "complete_eeprom_dump": False}
(root / "audit.json").write_text(json.dumps(report, indent=2) + "\n")
print(json.dumps(report, indent=2))
