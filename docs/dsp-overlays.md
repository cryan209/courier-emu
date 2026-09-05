# The DSP takes four images, not one

The supervisor downloads a resident C52 bank at boot. It can also send three
further images, and the resident bank is simply one row of the same table that
names them. This records the mechanism, the map, and what it does and does not
explain.

## Two transfer routines, one set of ports

Both push words through the same eight data ports, `0x40`-`0x4e`, four words per
block. They differ in the handshake and in where the source comes from.

| | resident downloader | overlay loader |
|---|---|---|
| handshake port | `0x18`, one acknowledgement per block | `0x1e`, one per half-block, `1` then `2` |
| source segment | hard-coded `mov ax, a914` | selected by index |
| entry | `mov ax, 8000` at the call site | the table's third word |

That hard-coded segment is why a second payload could not have come through the
first routine: it can only ever send the resident bank.

## The table

The loader masks a four-bit code, multiplies by six and adds a table base -
`mov bl, 6 ; mul bl ; mov bx, <table>` - then picks the source segment by
comparing the same code against 6, 7 and 8, falling through to the resident
segment. Each row is three words: start offset, end offset, and the C52 program
address to load at.

`courier_emu.rom.CourierRom.dsp_overlays` reads it. The table's length is not
marked and rows past its end still look like plausible ranges, so a row is kept
only if the loader has a segment for its index or it is the resident row - and
the whole result is discarded unless one row reproduces what the download call
site independently says. That is the check that identifies the table rather than
assuming it.

For the 3.1.2 board:

| id | flash | words | loads at |
|---:|---|---:|---|
| 5 | `29140..36e8e` | 28,327 | `8000` (resident) |
| 6 | `36e90..3d0f4` | 12,594 | `9d00` |
| 7 | `3d100..40b94` | 7,498 | `b000` |
| 8 | `40ba0..44634` | 7,498 | `dc00` |

All three 512 KiB images agree on those four entry addresses - stock 7.3.14,
ID_SDL 4.03 and the flat `IDSDL302.ROM` - with only the lengths differing.

Two things follow from the map. Overlays 6 and 7 **overlap in program space**,
so they are alternatives loaded one at a time, not three pieces of one program.
And every overlay lands *inside* the resident bank's own range, which runs to
`eea7` here: loading one overwrites resident code rather than extending it.

## What the overlays contain

Nothing that talks to the outside world. Across all three:

| | `out *, 0060` | `samm @21` (DXR) | codec writes |
|---|---:|---:|---:|
| resident | 1 | 4 | 6 |
| overlay 6 | 0 | 0 | 0 |
| overlay 7 | 0 | 0 | 0 |
| overlay 8 | 0 | 0 | 1 |

No host sender and no serial transmit anywhere in them - algorithm code, fed by
the resident bank's ISR.

Overlay 8's single codec write is **register 4 again**: it loads `0409`, adjusts
the low byte conditionally by four and then by one, and calls the resident
sender. So with the overlays included, the picture in
[codec-rate-312.md](codec-rate-312.md) does not change. Every codec write this
firmware makes after reset - three from the supervisor by tag `2c`, one from
overlay 8 - targets register 4.

> **Corrected.** The last sentence used to read "the divider registers are
> written once, at reset, and never again". That is false. The rate selector at
> `8140` writes register 2 from a six-row table, and the overlays reach it: the
> `call <sender>` counts above miss it because it inlines the sender's handshake
> rather than calling it. Overlay 6 selects 8000 Hz at its entry and overlay 7
> selects 7578.95 Hz. See [codec-sample-rates.md](codec-sample-rates.md).

## A correction to driving-the-tones.md

That document's third blocker says tag `0x19`'s entry at `0xdaaf` "falls in the
gap between the resident bank ending at `0xd9ef` and the overlay starting at
`0xde83`, so it reads as zeros".

Against the payload as `dsp_download` extracts it now, none of that holds. The
3.0.13 resident bank runs `8000..ec3e`, not to `d9ef`; the overlays load at
`9d00`, `b000` and `dc00`, not `de83`; `0xdaaf` is inside the resident bank and
holds instructions, not zeros; and the payload contains no zero run longer than
32 words anywhere. So the premise behind that either/or needs re-checking. The
table above is the measured replacement for its resident/overlay boundary.
