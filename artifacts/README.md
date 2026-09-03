# Capture artifacts

Primary evidence from the physical Couriers and from the offline probes. Each
capture directory keeps its own `manifest.json` recording acquisition details,
hashes and assumptions; treat that file as the authority for what a capture is.

| Directory | Contents |
|---|---|
| `courier-board-21210-capture-01/` | Full 512 KiB CPU flash window read from the 20.16 MHz board, plus its audit and the recovered-handler check |
| `courier-board-21210-ram-01/` | Two live passes over physical `00000..0feff` |
| `courier-board-21210-upper-ram-01/` | Two live passes over the `10000..1ffff` window |
| `atg-monitor/` | The first two hand-run `ATGLK2=` page reads and their comparisons |
| `io-port-map/` | `ATGLK2B` port-space sweeps from two units, and the static IN/OUT scan output |
| `dsp-rom-probe-v1/`, `dsp-rom-transport-v*/` | Offline probe and transport builds; no hardware involved |

## What is not tracked

Two per-page intermediate directories are excluded by `.gitignore`:

- `responses/` — one raw serial reply per page request
- `blocks/` — the verified 256-byte pages

Together they are roughly 32 MB across 8,200 files, and everything in them is
reconstructible from the assembled images and `pages.jsonl`, which are tracked.

The consequence is that **`audit_capture.py` cannot run from a fresh clone**: it
re-parses `responses/` and compares them against `blocks/`. It only works in a
working tree that still holds the original capture output. The assembled images,
per-page hashes in `pages.jsonl`, and the final hashes in `manifest.json` and
`audit.json` are tracked, so the images themselves remain independently
verifiable without those directories.
