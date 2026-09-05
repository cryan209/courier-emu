# Where V.PCM lives, and why 7200 Hz was never the whole story

Overlay 8 is the V.90 datapump. It is identified by its own DIL descriptor, and
finding it also explains how a board whose codec is fixed at one rate runs a
modulation that needs another: there are two serial converters, not one.

## The identification

V.90's digital impairment learning has the analog modem send a Ja descriptor.
Its sign and training patterns are fixed by the standard, so they are a
signature. Both are in the flash, packed LSB-first, and both match bit for bit
across 66 bits:

```text
4234c  55 4b 2d b5 b4 d2 4a 2b 01   SP  101010101101001010110100101011010010110101001011010100101101010010
42356  00 21 84 10 22 84 10 42 00   TP  000000001000010000100001000010000100010000100001000010000100001000
42360  0a 0a 0a 0a 0a 0a 0a 0a      H1-8 = 10, 10, 10, 10, 10, 10, 10, 10
42368  00 00 00 00 00 00 00 00      REF all zero
```

The reference values are the user's own notes for the descriptor; the flash
contents above are what this image holds. H1-8 and REF follow immediately, in
the order the notes give them, which is what turns two pattern hits into a
descriptor block.

That block is inside **overlay 8**, at DSP program `e7d6`. The 3.0.13 board and
`IDSDL302.ROM` carry the same block in their own overlay 8, at `e599` - so x2
and V.90 were present in the older build too.

The training UCode sequence is not stored anywhere in any image, in bytes or in
either word order. It is generated rather than tabulated.

## The four images, and which ones do I/O

| image | loads at | span | serial-port access |
|---|---|---|---|
| resident | `8000` | `8000..eea7` | `DRR` read x1 (the ISR), `DXR` write x4, **`TSPC` setup x2** |
| overlay 6 | `9d00` | `9d00..ce32` | **`DRR` read x32, `TRCV` read x4** |
| overlay 7 | `b000` | `b000..cd4a` | none |
| overlay 8 | `dc00` | `dc00..f94a` | none |

Overlay 8 touches no converter at all. It is pure algorithm, and it does not
overlap overlay 6, so the two are loaded together: **6 moves the samples, 8 runs
V.PCM on them.** Overlay 7 sits inside overlay 6's range, so those two are
alternatives.

## Two converters, which is the answer

The resident bank programs `TSPC` - the TDM serial port's control register - at
`808a`, and overlay 6 reads `TRCV`, that port's receive register. So this board
takes samples on **both** C5x serial ports: the primary one, where the
TLC320AC01 sits, and the TDM port.

That dissolves the contradiction recorded in
[codec-rate-312.md](codec-rate-312.md). The AC01's divider registers are written
once at reset and never again, and the dial path's DTMF pins that rate at
7200 Hz - both still true. Neither constrains the datapump, because the
datapump's samples need not come through the AC01 at all.

It also corrects [board-parts.md](board-parts.md) a second time. That document
says the 20.16 MHz builds "instead of the AC0x path... configure `TSPC`". It is
not instead: this build does both, and the two paths are the two halves of the
answer.

## What is hypothesis, and what is not

Established: the descriptor block and its location; which images do which I/O;
that both serial ports are set up and read; that the AC01's rate never changes.

Not established: **which converter carries which direction, and at what rate.**
V.90 is asymmetric - a PCM downstream at 8000 symbols per second, a V.34-like
upstream - so an obvious reading is that the TDM port carries the
8000 Hz-aligned receive path while the AC01 carries the analog side at 7200. The
counts are suggestive of a split (overlay 6 reads `DRR` 32 times and `TRCV` four
times, and no overlay transmits at all - every `DXR` write is in the resident
bank) but they are static site counts, not traffic. What actually sits on the
TDM port is also unestablished; the ASIC is the obvious candidate and this does
not demonstrate it.
