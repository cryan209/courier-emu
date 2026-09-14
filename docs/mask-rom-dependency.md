# The 3453B needs the C51 mask ROM; the 3453C unmaps it

Measured against `artifacts/dsp-onchip-rom-20mhz-8k/c5x-onchip-rom-8k.bin`,
the 8K ROM recovered from the 20.16 MHz board, 2026-09-15. Addresses are C5x
program words. Background: [the download architecture](c51-cpu-loader.md) and
[the origin correction](hardware-timebase-and-audio-path.md#3-corrected-the-xmf-payload-loads-at-8000-not-0000).

## Each family says so itself, in PMST

Both families' residents open with the same prologue - the same wait states,
the same `splk @7d, #27bd`, the same `apl @07, #07f8` - and diverge at the next
instruction, the `opl` that sets PMST:

| | `opl @07` | IPTR | interrupt vectors | MP/MC |
|---|---|---|---|---|
| 2.1.1, 2.2.05 | `00b0` | 0 | `0000` | **left at the pin** |
| 2.3.12, .15, .31, .33 | `18b8` | 3 | `1800` | **forced to 1** |

`apl #07f8` preserves bit 3, so the B series never writes `MP/MC` at all: on the
2806 board the pin reads 0, the ROM stays mapped, and with `IPTR` zero the
part's interrupt vectors *are* the ROM's table at `0000`. The C series sets bit
3 outright - no on-chip ROM anywhere in the program map - and moves the vectors
to `1800`, inside its own downloaded resident.

The shared prologue is literally shared: the ROM's own init at `0610..0619` is
byte-identical to the B resident's through `apl @07, #07f8`, and the first word
where the C resident stops matching is that `opl`.

## What the C series carries instead

The ROM's first 32 words are a dispatch table - `b 0670`, then `lamm @6x ;
bacc` pairs that vector through the mailbox cells. Every 2.3.x image carries
that table at program **`1802`**, and no 2.1/2.2 image carries it anywhere:

```
MAIN_2.3.12/15/31, 2_3_33    trampoline table at 1802
3453Bv2.1.1, main2205, main211   nowhere
```

16 of the first 20 slots are identical and in order, including the `setc intm
… clrc intm ; ret` pair. The head branch points at `0f46` instead of `0670`,
`TRNT`/`TXNT` become `rete`, and the copy stops after `@6a` where the ROM runs
on to `@7b`. Both families write handler addresses into the same cells
(`@64`, `@65`, `@6b..@77`, `@7a`), so the C series needs a dispatcher and, with
no ROM mapped, has to bring one.

## Nothing else came from the ROM

2.3.12's block at program `0000..0ff9` lands squarely on the ROM window and has
nothing to do with it: **11 words identical out of 4,090**, nine of them
`0000`, longest identical run **one word**. No 64-byte run of the ROM occurs
anywhere in any 2.3.x file. It is ordinary datapump code - the head of the
relocated table branches into it at `0f46`, which clears buffers, installs
handler addresses and calls `4235`/`4241` in the resident.

In particular the ROM's **service loader is not copied**. The `0000` block
contains no `BLDP` at all; the 80 in the resident are its own overlay loader,
at the same relative offset as the B series' (`1165` against `8168`). So what
performs the *first* download on a 3453C - the transfer that installs the
resident before any of this runs - is not answered by these images. The
supervisor drives the same ports (`40..5e`, `18`, `1c`) as a 302/403 one, which
implies a DSP-side loader is still listening; where it lives on a part that
then unmaps the ROM is untested here, and no 3453C board has been probed.

## It is not about V.92

V.92 is already in the B series: `3453Bv2.1.1` carries the `+PQC` quick-connect
command set and the `V.92` identity string, same as 2.3.33. `MOH_status`
appears from 2.2.05. And the C series' DSP payload is **smaller** - 48,199
words against 55,638, a 7,439-word reduction - so the move into low memory
bought no room and covered no added feature. On this evidence it is a
board/part change, not a firmware-size one.

## Reproducing

```sh
./courier info MAIN_2.3.12.XMF        # the four segments, from the supervisor's table
./courier dsp-run MAIN_2.3.12.XMF --instructions 100000
```

`dsp-run` reports `resident_origin` and boots from it; 2.3.x reads `1000`,
2.1/2.2 read `8000`.
