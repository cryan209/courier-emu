"""Recheck saved serial evidence and compare the capture with IDSDL302.ROM.

Run from the repository root. No serial device is opened and no input is changed.
"""
from collections import Counter
from hashlib import sha256
import json
from pathlib import Path
import sys

repository = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(repository))

from courier_emu.flash_dump import BASE, LENGTH, PAGE, parse_page
from courier_emu.rom import CourierRom

root = Path(__file__).resolve().parent
manifest = json.loads((root / "manifest.json").read_text())
assert manifest["status"] == "complete"
assert manifest["pages_verified"] == LENGTH // PAGE
assert manifest["anchors_rechecked"]
rom = CourierRom.load(root / manifest["image"])
assert rom.digest == manifest["sha256"]
records = [json.loads(line) for line in (root / "pages.jsonl").read_text().splitlines()]
assert [r["physical_address"] for r in records] == list(range(BASE, BASE + LENGTH, PAGE))
raw_count = 0
statuses = Counter()
for record in records:
    address = record["physical_address"]
    block = (root / "blocks" / f"{address:05x}.bin").read_bytes()
    assert block == rom.at(address, PAGE)
    assert sha256(block).hexdigest() == record["sha256"]
    assert record["bytes"] == PAGE and record["matching_copies"] == 2
    for visit in (1, 2) if address in (BASE, BASE + LENGTH - PAGE) else (1,):
        for copy in (1, 2):
            # This capture is expected to have no retries; retain a strict audit.
            raw = root / "responses" / f"{address:05x}-v{visit}-a1-copy{copy}.txt"
            decoded, terminal = parse_page(raw.read_bytes(), address)
            assert decoded == block
            raw_count += 1
            statuses[terminal] += 1
assert not manifest["failed_attempts"]
assert dict(statuses) == manifest["terminal_status_counts"]
assert raw_count == len(list((root / "responses").glob("*.txt")))

reference = (repository / "IDSDL302.ROM").read_bytes()
assert sha256(reference).hexdigest() == "49f4182cc961aef983ff43468b7b7e55c03205c9dba80e9689fe20aa6ff2ccc5"
different = [i for i, (a, b) in enumerate(zip(rom.data, reference)) if a != b]
ranges = []
for offset in different:
    if ranges and ranges[-1][1] == offset:
        ranges[-1][1] += 1
    else:
        ranges.append([offset, offset + 1])
regions = [("DSP reset/download routines", 0xE370, 0xE598),
           ("CPU byte/word memory readers", 0x26E20, 0x26EEC),
           ("DSP startup and resident sender", 0x29080, 0x29880)]
report = {
    "audit": "all saved raw copies, page records, blocks and final image agree",
    "bytes": len(rom.data), "sha256": rom.digest,
    "raw_responses_verified": raw_count, "terminal_status_counts": dict(statuses),
    "flash_base": hex(rom.base), "reset_entry": f"{rom.reset.boot_segment:04x}:{rom.reset.boot_offset:04x}",
    "reference_sha256": sha256(reference).hexdigest(),
    "differing_bytes_from_reference": len(different),
    "different_ranges_flash_offsets_end_exclusive": [[hex(s), hex(e)] for s, e in ranges],
    "regions": [{"name": name, "start": hex(start), "end_exclusive": hex(end),
                 "matches_reference": rom.data[start:end] == reference[start:end]}
                for name, start, end in regions],
    "banks": [{"physical_start": hex(BASE + start),
               "sha256": sha256(rom.data[start:start + 0x10000]).hexdigest(),
               "erased_ff_bytes": rom.data[start:start + 0x10000].count(255),
               "differences_from_reference": sum(a != b for a, b in zip(
                   rom.data[start:start + 0x10000], reference[start:start + 0x10000]))}
              for start in range(0, LENGTH, 0x10000)],
    "limitations": manifest["assumptions"],
}
(root / "audit.json").write_text(json.dumps(report, indent=2) + "\n")
print(json.dumps({k: v for k, v in report.items()
                  if k != "different_ranges_flash_offsets_end_exclusive"}, indent=2))
