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
> rather than calling it. Overlay 6 selects 8000 Hz at its entry. Overlay 7 was
> briefly recorded here as selecting 7578.95 Hz; that was a data-page error and
> is withdrawn - overlay 7 is not shown to select any rate. See
> [codec-sample-rates.md](codec-sample-rates.md), which also identifies
> overlay 8 as the V.90 layer and overlay 6 as the PCM core it runs beside.

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

## The bridge now services a mid-call overlay transfer

Until 2026-09-09 the bridge dropped every overlay download on the floor, which
is why no run in this project ever produced a second `bootstrap`. Three
separate faults, each found by measuring what arrived rather than by reading:

**1. The wrong handshake port.** The strobe path only ever inspected
`self.transfer.command_port`, which for a board ROM is `ROM_COMMAND_PORT`
(`0x18`). The overlay loader acknowledges on `0x1e`, as the table at the top
of this document records. Writes to `0x1e` returned early, so the payload
windows were never committed and the firmware strobed correctly into a port
nothing was listening on. Fixing this alone took the answering side from 6
window strobes to 3,750.

**2 and 3. The wrong block size, and the wrong window for the second half.**
These were first inferred from arriving data - the opening window came in as
`06bc807a` + stale bytes against overlay 7's `06bc807a9fad807a` - and the
inference is unnecessary, because the loop is in the image. From `0x8e6c2`:

```text
8e6c2  in   al, 0x1e / test al,1 / je wait / test al,2 / je wait
8e6cc  lodsw ; out 0x40, al ; out 0x42, ah      ; word 1
8e6d4  lodsw ; out 0x44, al ; out 0x46, ah      ; word 2
8e6dc  mov  al, 1 ; out 0x1e, al                ; acknowledge the first half
8e6f1  in   al, 0x1e / test al, 2 / je wait
8e6f7  lodsw ; out 0x48, al ; out 0x4a, ah      ; word 3
8e6ff  lodsw ; out 0x4c, al ; out 0x4e, ah      ; word 4
8e707  mov  al, 2 ; out 0x1e, al                ; acknowledge the second half
8e70b  loop 8e6af
8e730  mov  al, 4 ; out 0x1e, al                ; end of transfer
```

So the real method, stated rather than fitted:

* a **block is four words**, low byte then high byte to `0x40`, `0x42`,
  `0x44`, `0x46`, then `0x48`, `0x4a`, `0x4c`, `0x4e`;
* the loader acknowledges **twice per block** - `1` after words 1-2, `2` after
  words 3-4 - so each acknowledgement covers **four bytes**;
* both halves are lanes of the **same** eight-port window; the resident
  downloader's strobe `2`, which selects `0x50`, has no counterpart here;
* it polls `0x1e` for bits 1 and 2 before each half, and for 1, 2 and 4 before
  the closing `out 0x1e, 4`;
* `CX` is the block count, `(end - start) / 2 / 4` rounded up, from the same
  table row; `ES` is the source segment chosen by comparing the id against 6,
  7 and 8 with the resident segment as fall-through.

`out 0x1e, 4` therefore marks **both** boundaries, at `0x8e631` to begin and
`0x8e730` to end, which is why the bridge treats that value as a transfer
reset rather than as data.

The empirical framing and the firmware agree exactly. That the reconstructed
14,996-byte image matches the ROM byte for byte is the same statement made a
third way.

### What it does now

`_accumulate_overlay` takes half-blocks, identifies the overlay by matching
its opening eight bytes against **this ROM's own overlay table**, verifies the
completed image against the ROM's copy, and publishes it with
`core.load_program(image, entry_word)` only on a match. Nothing about the
payload, its length or its load address is chosen by the bridge; an
unrecognised transfer is dropped rather than published.

Measured on a two-instance link, A originating and B answering:

| | side A | side B |
|---|---|---|
| `overlay_downloads` | 0 | **1** |
| `overlay_id` | - | **7** |
| `overlay_match` | - | **true** |
| `call_overlay_active` | false | **true** |

Overlay 7, 14,996 bytes, matching the ROM byte for byte, loaded at `b000` -
the address this document's table names. The answering side is where the
DSP requests it; see
[datapump-gate-403-addresses.md](datapump-gate-403-addresses.md) for the
chain from the request to `out 0x1e, 4`.

`tests/test_asic_ports.py`, `test_mailbox_protocol.py`,
`test_dsp_board_ndx.py` and `test_g_dsp_capture.py` pass unchanged.

This does not yet claim a completed call. It claims that the datapump image
now reaches the C52, which no run before it did.
