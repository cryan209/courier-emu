# Nine I-modem builds, and when x2 arrived

`docs/x2` now holds eight more Courier I-modem releases beside `Ie030002`.
Every one is a NAC/XMP update payload of the same shape - `0xb8000` bytes based
at `0x40000` - so none of them carries a boot block or a 386 reset vector.  What
they do carry is the feature's arrival, release by release.

| release | dated | S58 block | DSP images |
|---|---|---|---:|
| `IE010203` | Sep 1996 | absent | table not located |
| `IM020009` | Oct 1996 | absent | 7 |
| `IM010501` | Feb 1997 | absent | table not located |
| `IE020104` / `IM020104` | Mar 1997 | **x2, server, symetric, A-law, -6dbm** | 7 |
| `IE020202` | Dec 1997 | as above, spelling fixed | 7 |
| `IE020405` / `IM020406` | Aug / Sep 1998 | **+ V.90** | 7 |
| `Ie030002` | 2000 | as above | 7 |

## x2 server and symmetric shipped together, in the first x2 build

The three 1996-and-early-1997 releases have no S58 x2 block at all.  It appears
whole in **2.01.04, March 1997** - one month after x2's launch - and it already
has both roles:

```
S58 x2 Mode and Remote Server Xmit
   1   x2
   2   server mode
   4   Force x2 A-law mode
   8   symetric mode          <- sic, through 2.01.04
  16   -6dbm constellation
```

`2.02.02` (December 1997) changes exactly one thing in that block: `symetric`
becomes `symmetric`.  `2.04.05` (August 1998) appends `32 V.90`.  So symmetric
mode was not a later addition to x2 on this product - it was there in the first
release that had x2 at all, and the only thing that changed for two years was a
typo.

## The seven images, across the series

The overlay table reads out the same way in every build from 2.00.09 on - a
row table at `cs:T`, a segment table at `cs:T+0x48`, indices 5 to 11:

| idx | 2.00.09 | 2.01.04 | 2.02.02 | 2.04.05 | 3.00.02 | what |
|---:|---:|---:|---:|---:|---:|---|
| 5 | 5,723 | 4,497 | 4,582 | 4,670 | 4,670 | resident |
| 6 | 9,477 | 12,106 | 12,223 | 13,842 | 13,909 | V.34 |
| 7 | 5,173 | 5,173 | 5,173 | 5,173 | 5,173 | V.FC - unchanged in four years |
| 8 | 2,426 | 2,436 | 2,436 | 2,436 | 2,436 | V.FC's companion |
| 9 | 3,215 | 3,215 | 3,215 | 3,215 | 3,215 | fax - also unchanged |
| 10 | 5,545 | 6,881 | 7,273 | 7,520 | 7,536 | the paired datapump, part 1 |
| 11 | 14,525 | 15,811 | 15,898 | 15,993 | 15,997 | part 2 |
| | 46,084 | 50,119 | 50,800 | 52,849 | 52,936 | total |

V.FC and fax are frozen from 1996 onward, to the word.  V.34 grows by 4,400
words.  The pair grows by 3,463: **+2,622 across the x2 release**, then +479
over the two builds that add V.90 and follow it.

## Correction: the pair is older than x2

[x2-symmetric-and-all-digital.md](x2-symmetric-and-all-digital.md) identifies
image 11 as the PCM image because it is the only one touching `fff1`, `fff3`,
`fff4`, `fff7` and `3fff` - the cells the x2 setup path writes.  That inference
does not survive this series: **`IM020009`, from October 1996 and with no x2
anywhere in it, already has 18 hits on those cells in image 11 and 4 in image
10.**  They are the datapump's general host parameter block, not an x2
fingerprint.

What survives is the content evidence, which is stronger anyway: image 6 is
V.34 by a 24.8% byte match against the analog overlay 6, image 7 is V.FC by
68% and a 1,039-byte run against overlay 7, image 9 is fax because every one of
its seven request sites sits in the Class 2 code.

## What the pair actually is: the resident bank, loaded

Asking *where* the shared bytes fall answers it.  Matched runs, binned by
decile of the analog segment they land in:

```
idx 6  vs analog ov6   24.8%   18 12  8 15  8 16 17  1  0  0
idx10  vs analog res   27.7%    0  0  0  1  0  2 48 40  2  4
idx11  vs analog res   47.6%    1  7 16 21 16 25  0  0  0 10
```

Image 6 is spread across the first seven tenths of the analog **V.34 overlay** -
a body, not a startup fragment, which is what settles it as V.34.  But images 10
and 11 do not match any overlay: they match the analog **resident bank**, in two
*adjacent and non-overlapping* regions - 11 covering its first six tenths, 10
covering the seventh and eighth.  Between them they reproduce most of it.

The arithmetic agrees.  The I-modem's resident plus the pair is
4,670 + 7,536 + 15,997 = **28,203 words**, against the analog resident's 27,710
- and it holds across the series: 25,793 in 2.00.09, 27,189 in 2.01.04, 27,753
in 2.02.02, 28,183 in 2.04.05.

So the I-modem does not have a big second datapump.  It has the **same resident
bank as the analog Courier, delivered as two loadable images** because its
actual resident is a 4,670-word loader and ISR stub rather than a 27,710-word
program.  That explains everything the earlier reading strained at: why the
pair predates x2 by six months (the resident always existed), why it carries the
`fff1`/`fff3`/`fff4`/`fff7` parameter cells (the host mailbox interface is
resident code), why it grew 2,622 words exactly when x2 server and symmetric
arrived (the PCM send path went into the resident-class image), and why it
matches the analog **PCM overlay** 0.0% (that overlay is the client receiver,
which this product does not have).
