# Experimental 3453C DSP monitor patch

Built from the hardware-verified 2.3.33 XMF (DSP 2.1.41). This is a real patched
image with passing isolated handler tests, not a hardware-tested release.
No firmware was flashed while developing it.

## Implemented commands

The existing ATG tag/data transport is retained. ATGU now displays a monitor
reply cache as `DSPMON <tag> <value> <sequence>`; all fields are four hex digits.
The CPU intercepts monitor replies before ordinary DSP event dispatch and
snapshots the cache with interrupts masked before printing it.

| Input | Meaning | Response tag |
|---|---|---|
| `ATG00880000` | Identify monitor; returns D541 | 0070 |
| `ATG00890123` | Read DSP data word 0123 | 0071 |
| `ATG008A12C0` | Read DSP program word 12C0 | 0072 |
| out-of-range read | Returns error code 0001 | 0073 |
| `ATGU` | Display/initialize the cached reply | — |

DSP **word addresses** are used. Data reads are limited to 0100..03FF;
program reads accept 0000..7FFF. Program zero reflects the active program map,
not necessarily internal mask ROM. This patch does not change MP/MC or add writes.

After installation and boot, a manual identification sequence is:

```
ATGU
ATG00880000
ATGU
```

The final display should contain `DSPMON 0070 D541` and a sequence different
from the first display. Serial OK after ATG means queued, not DSP delivery.
The host tool checks the sequence and response tag and times out rather than
accepting a stale cached value:

```
.venv/bin/python tools/3453c_monitor.py identify
.venv/bin/python tools/3453c_monitor.py data 0123
.venv/bin/python tools/3453c_monitor.py program 12C0
```

Dump an inclusive range of DSP word addresses:

```
.venv/bin/python tools/3453c_monitor.py dump program 0000 7FFF --output dsp-program.bin
.venv/bin/python tools/3453c_monitor.py dump data 0100 03FF --output dsp-data.bin
```

The range command issues consecutive one-word requests using the existing
firmware patch; it does not require a new firmware build. It checks for a fresh
sequence and matching response tag for every word, reports progress, and saves
little-endian 16-bit words. `FILE.json` records the address range, byte order,
word count and SHA256. Both endpoints are included: the examples produce
65,536 and 1,536 bytes respectively.

On failure, completed words remain in `FILE.partial`, accompanied by
`FILE.partial.json` with `complete: false` and the error. A completed binary is
published only after every word arrives. Existing output/metadata/partial files
are refused rather than overwritten. These are sequential live reads, not an
atomic snapshot; DSP data may change while the dump runs. The range tool has
been tested with simulated replies, not installed hardware.

The tool first requires the DSPMON marker, so on stock firmware it stops before
sending a DSP request. These commands have not been sent to patched hardware.

## Layout changes

- Append 68 DSP words at program 75E0..7623. All known overlays end below 75E0.
- Redirect DSP dispatcher instructions at 12C0 to the monitor; unmatched tags
  replay the original comparison and return to the stock dispatcher.
- Relocate the stored bytes of overlay 6 from XMF CEB0 to XMF 50000
  (physical flash 90000); preserve its DSP destination and contents.
- Update all five resident download call sites and the resident table row,
  with extents aligned to the hardware's four-word transfer groups.
- Add CPU reply capture at physical flash 8A000 and ATGU display at 8A100.
- Reserve CPU RAM 3FF00..3FF07 for tag, value, sequence and signature.
- Recompute the boot payload CRC at XMF 0202; retain the header CRC at 0200.

Boot CRC is reflected CRC-16 polynomial 8408 with seed zero: the captured
boot code at FC00:1E50 checks 40000..401FF against [40200], and 40206..F7FFF
against [40202]. The builder reproduces both stock stored values before editing.

The assembler scan found no stock literal 8070/8072/8073 reply tags. The sole
8071 word is an SAR instruction at program 479A, not a reply constant. This
is static evidence, not a proof about every dynamically generated stock tag.

## Validation and outstanding work

`manifest.json` lists hashes, every edit and execution results. The builder
verifies the standard XMF loader metadata agrees with all four emitted segments.
12 DSP executions cover identification, data/program reads, range errors,
stock command fallback, full-queue rejection without a partial reply, and
survival after overlay loads. 10 CPU executions cover interception, stock
pass-through, ignored tags, register/stack preservation and cache display.
Pytest also checks relocated overlay byte identity and CRC corruption detection.

Before hardware installation, still establish ownership of the reserved CPU RAM,
validate the relocated flash source through the complete hardware loader path,
and exercise reset/recovery for this exact image. The current emulator lacks
the 3453C's first-download mask-ROM protocol, so these isolated tests cannot
substitute for full boot validation. No update command or flashing script is
included.

Rebuild and test:

```
.venv/bin/python tools/build_3453c_dsp_monitor.py
.venv/bin/python -m pytest -q tests/test_3453c_monitor_patch.py
```

`2_3_33-dsp-monitor.candidate.xmf` is the experimental output. Keep the captured
stock image as the recovery baseline.

## Guarded uploader

`tools/flash_3453c_monitor.py` defaults to offline preflight only: it checks the
candidate against its manifest, checks the captured stock backup, verifies
image identity and both boot CRCs, and does not open a serial port. Its simulated
receiver test covers the entire 5,888-block transfer and post-reset monitor check.
The actual updater write path has not been exercised on hardware.

The `--flash` flag enables ATXMODEM option 2 and requires a new `--log` file.
The write handler commits after receiving/validating the first 1K; it cannot
validate the complete image before erasing. A failed boot or interrupted
transfer can therefore require recovery with physical access to the modem.
The uploader preserves its acknowledgement/error log and does not force reset
following an incomplete transfer. The experimental-image limitations above
remain; preparing this uploader does not establish full-boot safety.

## First hardware installation

The candidate SHA256 598e1f1e506547d3e47b64ef3d72aa497bc304ee91c8d98dc7c22835e15c401b
was flashed after explicit user approval. All 5,888 blocks were acknowledged
without retries; the write path reported TRANSFER SUCCESSFUL (correct spelling,
unlike the read path). The modem reset and answered AT. Identification returned
D541. Live program dumps of 12C0..12C7 and 75E0..7623 match the candidate
byte for byte; a data dump of 012F..0132 also completed. See flash-log.json and
hardware-verification.json.

Hardware exposed an ATGU parser quirk: the display handler leaves U unconsumed,
so a valid DSPMON record is followed by ERROR. The host tool accepts this exact
response; other ERROR responses remain failures. This installed build still has
the quirk. No second firmware flash was performed. Call/overlay operation and
long-running RAM ownership remain untested.
