# The 25 MHz board's DSP carries the same mask, and the ROM is 8K

Taken after the 2806 was reflashed from stock 7.3.14/3.0.13 to ID_SDL v4.03d
(`artifacts/xmodem-program-id25-403`), which is what put `ATGLK2W` on this board
and made the probe deliverable at all. The board then matches the 20.16 MHz unit
in supervisor and DSP revision, so the two differ only in clock.

## The answer to the question this was run for

`0x0000`-`0x07FF` off this board is **byte-identical** to
`artifacts/dsp-onchip-rom-01`, taken off the 20.16 MHz unit -
`sha256 3e30fb31ac87fc9d0b8a85da245511ef3caa4e83249f56b5852d9d0829e93f67` on
both. Same mask, both generations. Nothing about the DSP boot path needs to be
modelled twice.

## The C50/C51 test in probing.md is invalid as written

That test says: read `0x0800` twice, and on a 'C50 the two reads should
**differ**, because `0x0800` is the 9K SARAM holding the firmware's live
scratch. Run here, twice, the two reads are byte-identical - which the test
would score as 'C51.

It is not a 'C51 result, it is a broken test. The probe *resets the DSP* and
takes it over, so the firmware whose scratch the test wanted to watch is not
running by the time the first word is read. Neither part can produce a moving
read under this probe, so identical reads mean nothing either way.

> An earlier revision of this file blamed `PMST` coming up at its reset
> defaults. That was wrong, and `artifacts/dsp-memory-test-2806` shows why:
> `PMST` reads `00b0` on this board, `RAM` and `OVLY` **already set**, before
> the `opl @07, #0030` every kernel here executes. The reset-defaults story was
> read off the manual instead of the part.

The test that does work is a write-readback, and it is in
[artifacts/dsp-memory-test-2806](../dsp-memory-test-2806/README.md). **The part
is a 'C51: 8K of on-chip ROM at `0x0000`-`0x1FFF`.** So this directory's
`0x0000`-`0x07FF` capture was indeed a quarter of the ROM, and the rest is now
here too.

## The whole 8K, and it is mostly unprogrammed

`c5x-onchip-rom-8k.bin`, 8192 words, `sha256 70db9861…`, assembled from the six
1K windows in this directory. Only three regions hold anything:

| | words | |
|---|---|---|
| `0000`-`077F` | 1920 | the vector table, the boot loaders, ending `077a: b 0779` |
| `0F80`-`0FFF` | 128 | a mailbox handshake block |
| `1F80`-`1FFF` | 128 | **byte-identical to the `0F80` block** |

Everything else - 6016 words - is a **32-word period of 16 x `FFFF` then 16 x
`0000`**, which is what unprogrammed mask cells read as here. The same pattern
runs from `0x0780` through `0x07FF`, which is why the 2K capture looked like it
ended in padding: those last 128 words are unprogrammed ROM, not a boundary.

The two 128-word blocks being identical, one per 4K half, with the code in both
branching to `1fa2` - an address only the upper copy occupies - says the block
is placed at the end of each 4K page by the mask, and the upper one is the live
copy.

## Is it really unprogrammed, or is protection hiding it?

TI's program-memory protection blocks instructions fetched from **off-chip
memory** from reading on-chip program memory, and does not name SARAM. Every
read above ran from a kernel at program `0x8000`, which is off-chip - exactly
the configuration protection suppresses. So the empty regions had to be re-read
from code executing on-chip before "unprogrammed" could be claimed.

`--via-saram` stages the read loop into SARAM with `bldp` and calls it there.
That path existed already and was recorded as having "returned nothing", but its
gadget address was `0x0900`, chosen when the part was believed to be a 'C50 with
9K of SARAM from `0x0800`. On the real part `0x0900` is **on-chip ROM**, so the
gadget was never written and the call ran ROM. `ROM_DUMP_GADGET` is now `0x2000`,
which is where the sweep found the SARAM.

| window | read from SARAM vs. read from `0x8000` |
|---|---|
| `0x0000`-`0x03FF` | **identical** - 975 distinct values, the vector table |
| `0x0C00`-`0x0FFF` | **identical** - the array pattern, and the `0x0F80` block |

The `0x0000` window is the positive control: it proves the staged loop really
executed and really read, because a gadget that failed to land would have hung
on garbage rather than returning the vector table. The `0x0C00` window is the
question, and protection is not hiding anything there.

**And the empty span is mapped, not absent.** If `0x0800`-`0x1FFF` were simply
undecoded, nothing would answer anywhere in it - but `0x0F80` and `0x1F80` return
stable, coherent code. The ROM decodes across the whole 8K and is sparsely
programmed.

## The memory map, measured

From `artifacts/dsp-memory-test-2806/sweep`, 21 addresses:

| program | |
|---|---|
| `0000`-`1FFF` | 8K on-chip ROM. Writes through data space never appear. `0x0400` reads `3cc4`, real ROM content, as the control |
| `2000`-`23FF` | **1K SARAM** - a write to data `0x0800` comes back from program `0x2000`, and data `0x0A00` from program `0x2200` |
| `2400`- | external RAM, the same memory in both spaces |

Data space: SARAM at `0x0800`-`0x0BFF`, external above. Note the buffer at data
`0x1000` is external data memory, a different memory from program `0x1000`, which
is why reading program `0x1000`-`0x13FF` never collided with it.

## Reproducing

```sh
python -m courier_emu.probe_transport --reference IDSDL302.ROM --rom-dump \
    --rom-origin 0 --rom-words 0x400 --output artifacts/dsp-onchip-rom-2806/half0
python artifacts/dsp-onchip-rom-2806/run-board.py \
    artifacts/dsp-onchip-rom-2806/half0 /dev/cu.usbserial-FT4TQOFT
```

`--reference IDSDL302.ROM` is not a claim about what is flashed. It is where the
monitor's copy of the DSP launch and download routines is lifted from, and only
`IDSDL302` carries them in the form `probe_transport` recognises; the 20.16 MHz
capture was taken the same way while that board ran 4.03d.

Every run here restored the board: `AT` answered afterwards and the watchdog put
the timer-0 vector back, checked each time.
