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
| `dsp-port-sample-01/` | Repeated reads of DSP reader ports and the `0x64`-`0x7e` block from the 20.16 MHz unit |
| `dsp-mailbox-write-01/` | First host-to-DSP mailbox write attempt. It wrote the four data registers with no commit on `0x1c` and observed nothing; kept as the negative result the protocol work explains |
| `dsp-mailbox-queue-01/`, `dsp-mailbox-queue-02/` | Host-to-DSP ring seeding with the commit edge, and the discriminators in `queue-01/followups/` that keep its one observed change unattributed |
| `dsp-mailbox-command-01/`, `dsp-mailbox-command-02/` | The repeatable host write: null-control and query tags, every inbound-register prediction fixed from the disassembly beforehand and held |
| `dsp-window-pump-01/` | Tag `06` armed and pumped; the channel responds, but its sources are empty on an idle unit |
| `dsp-window-pump-02/`, `dsp-window-pump-03/` | Tag `46` pumped: sixteen words, the first four DSP **program** memory matching the flash image at addresses predicted beforehand |
| `dsp-window-index-01/` | Tag `48` writing `ffb1` all-ones before arming tag `46`: the index stays `0`, since the other AND terms are call-setup state |
| `dsp-window-stream-01/` | The `0x60`/`0x62` chain's live state, and tag `06` shown to arm the DSP streamer without emitting |
| `io-latch-bit2-01/` | Port `0x14` bit 2 probe |
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
