# Linked AC01 call trace: blocked before overlay 8

Measured 2026-09-21 against the current native C51 core, including the AC01
frame-sync INT3 latch and instruction-boundary interrupt recognition. This is
an incomplete routing investigation, not evidence that the caller qualifies
the answer signal.

## Reproduce with the settings EEPROM loaded

```sh
./courier link artifacts/courier-board-21210-capture-403/courier-board.rom \
  --with-dsp --nvram-fixture idsdl403 \
  --a-at ATX0 --a-at ATDT5551234 --b-at ATA \
  --line-frames 400 --instructions 400000000 \
  --dsp-write-watch 0xfffe --summary --socket /tmp/ac01-403.sock

./courier link IDSDL302.ROM \
  --with-dsp --nvram-fixture idsdl302 \
  --a-at ATX0 --a-at ATDT5551234 --b-at ATA \
  --line-frames 400 --instructions 400000000 \
  --dsp-write-watch 0xfffe --summary --socket /tmp/ac01-302.sock
```

`link` automatically holds the answering command until ring for this command
pair. Both runs use the same board model. They require different EEPROM
fixtures: the extended-register block moves five words between revisions.
The 403 fixture is the full captured settings part; the 302 fixture seeds
the recovered settings and extended-register defaults.

These commands leave `legacy_carrier_fallback` disabled. Do not substitute
`--line-audio-only` when reproducing this particular path: that option also
disables the existing ASIC call-start helpers, including the originating
overlay request, so it changes more than carrier-event publication.

| Image | Failure PC | Download destination / `ff62` | PA7 | IMR | IFR |
|---|---:|---:|---:|---:|---:|
| Captured 403 | `8c37` | `a104` | `0202` | `002a` | `0014` |
| 302 with its NVRAM fixture | `06dc` | `a164` | `0202` | `0000` | `003c` |

Both terminate with `C51 resident loader did not acknowledge overlay block`.
The 403 transfer target is overlay **6**, not 8. Reducing the scheduling batch
from 256 to 32 reproduces the same 403 destination and PC. A diagnostic increase
of the acknowledgement allowance from 20,000 to 2,000,000 DSP steps still
fails at destination `a104` (PC `8c2d`). Selecting board ID 7 also fails during
overlay 6, at `a0f8`/PC `8c3c`. None of those diagnostic changes was retained.

The 403 failure capture contains deferred host message `(0017,505d)`, so the
start command has **not** been released prematurely. The last host command is
`0002:9d00`, the download destination. PC `8c37` is in the resident FFT routine;
why the resident cannot acknowledge the next block remains unresolved.

## What actually reaches the serial ports

At the captured 403 failure:

| Observation | Count / last PC |
|---|---|
| DRR reads | 104,486 / `8182` |
| DXR writes | 104,515 / `818f` |
| TRCV reads | **0** |
| TDXR writes | 936 / `81b8` |

The resident's `8182` reads the primary-port DRR into its circular buffer;
`818f` writes DXR. Its secondary handler at `819e..81a5` writes the control
word from B2 cell `006c` to DXR and restores the primary handler. The separate
`81a6..81b9` routine packs two scaled values into TDXR. Its TDXR writes alone
do not identify a codec DAC stream.

In the current AC01 implementation, each primary frame consumes one ADC
sample and clocks one DAC output. A secondary frame delivers a requested
register readback or zero, consumes no ADC sample, and adds no DAC conversion.
Both frame kinds latch INT3; the port's own receive/transmit interrupt flags
remain governed by its reset bits. IMR `002a` masks INT3 in this resident.

`tests/test_c5x_interrupts.py` now checks both secondary register-read and
register-write frames: a fresh INT3 latch, the appropriate DRR word, unchanged
ADC consumption, and delivery of the next queued sample on the next primary.
This is a **frame-boundary regression**, not the requested linked-call
answer-qualification regression.

There is no executed overlay-8 evidence here for mapping TRCV/TDXR or
`fffe/fffd` to either kind of codec frame. The older low-address TDM slot
observations in `courier_firmware_analysis.md` must not be treated as a trace
of this ROM call. No serial-port alias or external-data-slot audio route has
been added on that assumption.

## Diagnostic control and saved evidence

A separate, temporary Python probe suppressed the bridge's originating
overlay request and delivered host tag `17` immediately. With the original
native core and 403 NVRAM, both ends completed 600 linked frames, heard nonzero
peer audio, and reported `connected_event_queued=False`. Neither loaded an
overlay, and neither read TRCV. This establishes that the ordinary resident
audio path runs without the forced download; it does **not** establish native
answer qualification or show that removing those helpers is the right fix.
The probe was not retained in production code.

Local evidence is in `artifacts/overlay8-ac01-trace-20260921/`: the complete
DSP program/data snapshot and bridge state at the 403 failure, plus compact
run summaries. Image SHA-256 values:

* 403: `f1c91621fbf14aad34547056feb4425e64fcf0b38ec5d57f86c9f432ca999db6`
* 302: `49f4182cc961aef983ff43468b7b7e55c03205c9dba80e9689fe20aa6ff2ccc5`

The next prerequisite is a completed native overlay transfer with the corrected
clock/interrupt model. Only then can the executing slot accesses identify a
faithful routing change and support a positive answer-qualification regression.
