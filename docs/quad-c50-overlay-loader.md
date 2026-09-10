# How the Quad loads C50 code

[`docs/x2/README.md`](x2/README.md) recorded that each Quad image has exactly
one call to its 80186-to-C50 downloader, no Courier-style x86 overlay table,
and no source-segment reference to the tail of the DSP payload — so the overlay
selection mechanism was "not yet decoded". This document decodes it. Addresses
are `QF060003`; `QR060103` is the same shape at shifted offsets.

## The supervisor loads the resident, and nothing else

The download transport is two 80186 I/O port pairs:

| Ports | Role |
| --- | --- |
| `0xc0` / `0xc2` | download data, one 16-bit word split low byte then high byte |
| `0x98` / `0x9a` | handshake — write `1`, poll bit 0; write `2`, poll bit 1 |

`0x93864` sets a destination word address (`AX` out to `0xc0`/`0xc2`, then a
`0xff56` PCB bit and a `0x98` sequence). `0x93904` is the downloader proper,
taking a source offset in `AX` and a byte length in `CX`, chunking eight words
at a time against `in al, 0x98` / `test al, 1`.

There is **exactly one** call to the downloader in the image, at `0x93810`:

```
93804  mov ax, 0x8000     ; destination program address
93807  call 0x93864
9380a  mov ax, 0           ; source offset
9380d  mov cx, 0xf450      ; byte length -- the resident, and only the resident
93810  call 0x93904
```

preceded at `0x9382a` by a preamble that sends eight words of `0x0083` to
destination `0xfff8`. So the supervisor pushes the resident bank to program
`0x8000` at boot and never pushes anything else. The overlay store at
`0xd3e00..0xdf910` is not sent this way.

## The resident plants its own fetch stub

At cold boot, sixteen words into its entry path, the resident builds three
words of code in low program memory:

```
8067  lacc  #23f0
8069  samm  @1f          ; BMAR = 0x23f0   (BMAR is MMR 0x1f, spru056d)
806a  lar   ar1, #82d6   ; source
806c  rpt   #02
806d  bldp  *+           ; program[BMAR++] = data[ar1++], three times
```

`BLDP` is "block move from data to program memory with destination address in
BMAR" (spru056d). The board's external RAM answers both program and data space
at `0x8000..0xfeff` — the window `courier_emu/dsp.py` already models — so the
source at data `0x82d6` is the resident's own image. The three words are:

```
23f0  1080  lacc  *
23f1  0880  lamm  *
23f2  ef00  ret
```

That is the host-word fetch, and it explains the `calld 23f0` that the main
loop makes to an address below the `0x8000` load origin: nothing is missing,
the resident writes that code itself before using it.

## The host link is the DSP I/O window, not data memory

The stub is called with `ar1` set in the caller's delay slot — `0xff57` in the
idle path, `0xff58` in the transfer loop. `lamm *` addresses a memory-mapped
register by the low seven bits of the auxiliary register, so those are **MMR
`0x57` and `0x58`**, inside the `0x50..0x5f` I/O window that
`native/c5x_core.cpp` already maps to board I/O.

This **corrects** a claim in [quad-dsp-pcm-path.md](quad-dsp-pcm-path.md): the
Quad's CPU-to-DSP link is not global data memory. It is the same DSP I/O window
the analog Courier's ASIC mailbox uses — ports `0x5e`/`0x5f` there
([dsp-cpu-interconnect.md](dsp-cpu-interconnect.md)), `0x57`/`0x58` here. That
is also why poking data address `0xff57` had no effect: the value never came
from data memory.

## The loader

With the stub planted, the overlay load at `0x82fc` is straightforward:

```
82fc  ldp   #1fe
82fd  lacl  @63          ; 0xff63 -- destination program address
82fe  samm  @1f          ; BMAR = it
82ff  lar   ar1, #ff58   ; the word-fetch port
8303  ldp   #000
8304  rptb  #8310
8306  calld 23f0, *      ; fetch one word from I/O 0x58
830b  sacl  @7d
830c  bldp  @7d          ; program[BMAR] = it
830d  lamm  @1f
830e  add   #01
830f  samm  @1f          ; BMAR += 1
```

So the destination is host-supplied per transfer and the words are pulled one
at a time through an I/O port. There is no static overlay table on either side
to find, which is exactly why looking for one failed.

The resident has 19 anchored `samm @1f` sites and six anchored `bldp` sites, so
this is a general facility used for several loads, not one special case.

## Confirmed by execution

Running the resident under `courier_emu.dsp.NativeC5x` and seeding DSP I/O:

| Seed | final `pc` | `SPC` writes |
| --- | --- | --- |
| none | `0x83aa` | 72 |
| `0x57 = 0x0200` | `0x83aa` | 72 |
| `0x57 = 0xffff` | `0x83aa` | 72 |
| `0x57 = 0x0200`, `0x58 = 0x0000` | `0x83aa` | 72 |
| `0x57 = 0x0200`, `0x58 = 0xef00` | **`0x0485`** | **8** |

Feeding `0xef00` (`ret`) on port `0x58` changes the run: execution reaches
`0x0485`, in the low program memory the loader writes to, and the port
initialisation settles in 8 writes instead of 72. Words taken from I/O `0x58`
are planted in program memory and executed. The mechanism works.

That is a demonstration, not a real overlay — a constant `ret` is not the
firmware's code. But it establishes the transport end to end.

## The supervisor's load table

An eight-row table at `0x93ba2..0x93be1` in `QF060003`. Each row is four words:

```
source paragraph (32-bit, low word then 0x0000) | length in bytes | destination program address
```

It is identifiable because one row is the downloader call's own arguments —
length `0xf450`, destination `0x8000`, the `mov cx, 0xf450` / `mov ax, 0x8000`
at `0x93804`. That row is the resident.

In flash order:

| Source para | Byte | Length | Words | Destination | Flat address |
| --- | --- | --- | ---: | --- | --- |
| `0x2000` | `0x20000` | `0xf450` | 31,272 | `0x8000` (resident) | `0xc49b0` |
| `0x2f45` | `0x2f450` | `0x42e0` | 8,560 | `0xa180` | `0xd3e00` |
| `0x3373` | `0x33730` | `0x252c` | 4,758 | `0xb400` | `0xd80e0` |
| `0x35c6` | `0x35c60` | `0x0f18` | 1,932 | `0xd900` | `0xda610` |
| `0x36b8` | `0x36b80` | `0x0cb6` | 1,627 | `0xc300` | `0xdb530` |
| `0x3784` | `0x37840` | `0x15d6` | 2,795 | `0xc300` | `0xdc1f0` |
| `0x38e2` | `0x38e20` | `0x08f2` | 1,145 | `0xc800` | `0xdd7d0` |
| `0x3972` | `0x39720` | `0x1808` | 3,076 | `0x9440` | `0xde0d0` |

**The chain closes exactly.** Every row's source paragraph times 16, plus its
length, rounds up to the next row's source paragraph, with no gaps:
`0x20000 + 0xf450 = 0x2f450`, `0x2f450 + 0x42e0 = 0x33730`, and so on to
`0x3af28`. The eight images are contiguous in flash. Paragraph `0x2000` maps to
flat `0xc49b0`, the start of the DSP payload; paragraph `0x2f45` maps to
`0xd3e00`, the start of the overlay store, exactly.

Lengths total `0x1aefa` (110,330 bytes) against a DSP payload of `0x1af60`
(110,432). The chain ends at flat `0xdf8d8`; the 48-byte span the NAC paints
separately at `0xdf8e0..0xdf910` is the remainder. The table is followed
immediately by the `6.0.3` version and `09/22/98` date strings, which is where
it ends.

Every overlay destination lies **inside** the resident's own span of
`0x8000..0xfa28`, so these are overlays in the strict sense: they replace
regions of the already-loaded resident. Two rows share `0xc300`, so those are
alternates for one slot.

That answers the original question. Selection is a table of
(source, length, destination) rows on the supervisor side; delivery is the
DSP-side `BLDP` pull described above. Searching for a Courier-style table
reachable from a second downloader call found nothing because there is no
second call, and this table is not adjacent to the one that exists.

## Matching the Quad's images against the documented 302 overlays

[dsp-overlays.md](dsp-overlays.md) maps the analog Courier's four C5x images.
Read out of `IDSDL302.ROM` by `CourierRom.dsp_overlays`: id 5 resident at
`0x8000` (55,420 B), id 6 at `0x9d00` (23,020 B), id 7 at `0xb000` (14,998 B),
id 8 at `0xdc00` (14,700 B). That document identifies **id 8 as the V.90 layer
and id 6 as the PCM core it runs beside** (citing
[codec-sample-rates.md](codec-sample-rates.md)).

With the Quad's sources known, each of its eight images compares individually,
by 32-byte block hashing. Figures are the percentage of the *Quad* image's
blocks found in that 302 image:

| Quad dest | Words | 302 id5 | 302 id6 | 302 id7 | 302 id8 |
| --- | ---: | ---: | ---: | ---: | ---: |
| `0x8000` resident | 31,272 | **18.7%** | 0.1% | 0.1% | 0.0% |
| `0xa180` | 8,560 | 0.2% | **50.8%** | 4.5% | 0.2% |
| `0xb400` | 4,758 | 7.1% | 4.1% | **35.2%** | 0.0% |
| `0x9440` | 3,076 | 0.7% | 11.2% | **41.9%** | 0.0% |
| `0xc300` | 2,795 | 0.1% | **36.4%** | 0.1% | 0.0% |
| `0xd900` | 1,932 | **26.9%** | 0.2% | 0.2% | 0.0% |
| `0xc300` | 1,627 | 0.0% | **17.2%** | 9.3% | 0.0% |
| `0xc800` | 1,145 | 0.0% | 0.0% | 0.0% | 0.0% |

**Resident matches resident.** The Quad's `0x8000` image matches only the 302
resident. The only other strong match to that resident is the Quad's `0xd900`
overlay, so code that is resident on the analog Courier is partly an overlay on
the Quad — reasonable for a resident that already has four channels to host.

**The PCM core carries over.** The Quad's largest overlay, `0xa180`, is a 50.8%
match to 302 id 6, the PCM core; the `0xc300` pair lands there too.

**302 id 7 is split in two.** The Quad's `0xb400` and `0x9440` match id 7 at
35.2% and 41.9% and match little else, so one 302 overlay corresponds to two
Quad overlays.

**Nothing matches 302 id 8, the V.90 layer.** That column is 0.0-0.2% across
all eight Quad images. The Quad does V.90 — its supervisor string tables are
full of `48000/ARQ/V90` and the rest — but not with this DSP code. And the
Quad's `0xc800` image (1,145 words) matches *nothing* in the 302, which makes
it the first candidate for where the Quad's own V.90 or DS0-side work lives.

### Limits

These are 32-byte block-hash overlaps: at 35-51% these are revisions of common
sources, not identical images. Percentages are of the Quad side, so a low figure
against a much larger 302 image is not on its own evidence of absence — but the
id 8 column is 0.0% across all eight Quad images, which is.

### Corrections

An earlier version of this document read the rows as
`(length, destination, third, 0x0000)` with an unidentified third field, and
found only five. The row boundary was two words off. The third field is the
source paragraph address, the table has eight rows, and the earlier note that
the lengths covered only a third of the overlay store was an artifact of the
same misalignment — they cover all of it. The equal-size coincidence noted
there between 302 id 7 and those five rows (both 14,998 bytes) was likewise an
artifact and is withdrawn.

## What remains

- ~~The request and acknowledge protocol on ports `0x57`/`0x58`~~ — **recovered
  2026-09-10 by running the resident**, see "The host link is a five-word
  window" below.
- ~~The supervisor code that walks this table and streams a row on request.~~
  Recovered at physical `0xcee5f`: it indexes the table at `0xcefa8`, writes 4
  to CPU port `0x9e`, then streams four words through lanes
  `0xc0/c4/c8/cc`, strobing `0x9e` with 2 after each burst.
- Which overlay is selected when — the table says what the eight images are and
  where they go, not which one a given call needs.
- `QR060103` has the same downloader shape; its table has not been located.

## The host link is a five-word window

Running the captured resident on `NativeC5x` with no CPU attached settles the
handshake. Over 200,000 steps it produces 10,637 I/O events, and the steady
state is one cycle repeated 1,768 times:

```
WRITE 0x57 = 0x0300    pc 0x8313
read  0x57             pc 0x23f1
read  0x58             pc 0x23f1
read  0x59             pc 0x23f1
read  0x5a             pc 0x23f1
read  0x5b             pc 0x23f1
```

**Every read is at the same address.** `0x23f1` is the fetch stub's `lamm *`
with `ar1` auto-incrementing, so this is not five instructions polling five
registers - it is one instruction walking a **five-word window from `0x57`**: a
status word followed by **four** data words at `0x58`..`0x5b`. The stub always
reads all five, which is why seeding `0x57` alone never advanced the loop.
There was not more handshake than one bit so much as more *window* than one
port.

Four data words per request is exactly the CPU's burst size. The supervisor
writes four words into lanes `0xc0`, `0xc4`, `0xc8`, `0xcc` (or the `0xd0`
group), strobes `0x98` and waits; the DSP takes four words from `0x58`..`0x5b`
and writes `0x0300` back to `0x57`. So the lanes correspond one for one:

| CPU lane | DSP MMR |
|---|---|
| `0xc0`/`0xc2` | `0x58` |
| `0xc4`/`0xc6` | `0x59` |
| `0xc8`/`0xca` | `0x5a` |
| `0xcc`/`0xce` | `0x5b` |

Only one window appears, at `0x58`..`0x5b`; `0x5c`..`0x5f` are never touched.
The CPU's second lane group at `0xd0` therefore addresses a second device with
its own I/O space rather than a second window in this one.

Start-up, before the cycle begins, is `0x57 = 0xffff` at `0x8002`, then
`0x56 = 0xffff` and `0x57 = 0xfffc` at `0x8031`/`0x8033`, then five peripheral
writes at `0x8058`..`0x8066`: `0x68 = 0x000f`, `0x69 = 0x0002`, `0x6a = 0x0000`,
`0x6b = 0x0078`, `0x6c = 0x0901`. Six reads of `0x55` occur at `0xbc0`/`0xbf4`.

Reproduce with `PYTHONPATH=. .venv/bin/python tools/probe_quad_c50_resident.py`;
results in `artifacts/quad-c50-resident-20260910/results.json`.

The CPU-side routine settles the status bits too. After writing 4 to `0x9e` it
waits on bit 2 (`0x04`); after every four-word strobe it waits on bit 1
(`0x02`). `QuadC50Endpoint` models those as separate link-ready and
burst-acknowledge states. A focused test runs the captured resident, withholds
bit 1 while a burst is pending, and observes the resident read all four words
and write `0x0300` to `0x57` before bit 1 rises.

## Why 302 id 8 has no counterpart: V90A against V90D

V.90 is asymmetric and the two ends run different code. The analog client
(V90A) **receives** PCM codewords and **transmits** V.34. The digital server
(V90D) **transmits** codewords straight onto its timeslot and **receives**
V.34. So the analog Courier and a chassis modem NAC do not share a V.90 layer
at all, however much else they share.

The Quad's own configuration says which end it is. Its `S81` help block reads:

```
S81  V.90 Configuration
  1   TX power level applied before digital pads
  2   (reserved)
  32  V.90 server mode
S82  V.90 Transmit Power Level (-dBm)
```

There is **no client-mode bit**, and both V.90 settings are transmit level —
"before digital pads" being a digital-network concern, where the server
pre-compensates for pads downstream. The Quad is V90D only. (Its `S76` x2
block does carry client, server and symmetric modes, so the absence on the
V.90 side is a real distinction, not a missing string.)

That explains the whole match pattern:

| | needs it | Quad has it |
| --- | --- | --- |
| V.34 datapump and PCM core (302 id 6, id 7) | both ends | yes — 35-51% across four images |
| V90A receive layer (302 id 8) | client only | **no** — 0.0% across all eight |
| V90D transmit mapping | server only | no 302 counterpart exists to match |

It also connects to the serial-port finding in
[quad-dsp-pcm-path.md](quad-dsp-pcm-path.md). The Quad runs `SPC` with `FO = 1`,
8-bit bytes MSB first, where the 302 runs `FO = 0`, 16-bit words. For a V90D
transmitter that *is* the transmit path: it does not synthesise a waveform, it
writes codewords to a byte-formatted timeslot. The analog client needs 16-bit
linear samples for its codec because it has to recover codewords from an
audio waveform.

### The `0xc800` image: a mode slot, contents unidentified

`0xc800` is the only Quad image with no 302 ancestry. It is **not** therefore
the V90D layer — that was too quick. What the structure actually shows is that
it is one of three alternatives for a single slot.

Program spans, from destination and length:

| Destination | Words | Span | Matches |
| --- | ---: | --- | --- |
| `0x9440` | 3,076 | `0x9440..0xa044` | 302 id 7, 41.9% |
| `0xa180` | 8,560 | `0xa180..0xc2f0` | 302 id 6, 50.8% |
| `0xb400` | 4,758 | `0xb400..0xc696` | 302 id 7, 35.2% |
| `0xc300` | 1,627 | `0xc300..0xc95b` | 302 id 6, 17.2% |
| `0xc300` | 2,795 | `0xc300..0xcdeb` | 302 id 6, 36.4% |
| `0xc800` | 1,145 | `0xc800..0xcc79` | **nothing** |
| `0xd900` | 1,932 | `0xd900..0xe08c` | 302 resident, 26.9% |

The last three overlap each other, so `0xc300`/1,627, `0xc300`/2,795 and
`0xc800`/1,145 are mutually exclusive: one slot, three alternatives. That is a
**mode slot**, and `0xc800` is the mode with no analog-Courier counterpart.

Cross-comparing the Quad's images against each other, `0xc800` shares **0.0%**
with every one of them, so it is not a variant of either sibling either. (The
1,627-word `0xc300` image does share 16.7% with `0x9440`, so those two are
related.)

Reading its head: it branches to `0xa98d`, inside the `0xa180` PCM core's span,
and calls `0xc85b` inside its own — a mode layer sitting on the shared core,
which is what all three alternatives should look like.

### What it might be

Candidates, none settled:

- **V90D downstream mapping.** The card is V90D-only per `S81` above, and
  server-side codeword transmission has no analog-Courier counterpart, which
  fits "matches nothing".
- **x2 server downstream mapping.** These are `x2` NACs; x2 predates V.90 and
  is the same shape of scheme. Server-side x2 and V.90 mapping may well share
  one image, which would explain why only *one* image is unmatched rather than
  two.
- **Another G.711 or PCM mode** for the DS0 side.

Against **clear channel / unrestricted 64k**: that needs essentially no DSP,
and this image branches into the PCM core and does real arithmetic, so a
straight passthrough does not fit.

Against **V.91**: tested directly, and absent. Table 5/V.91 gives the default
DIL parameters — `N = 125`, `L_SP = L_TP = 12`, `SP = 0x0FC0`, `TP = 0x0FFF`,
and a 125-symbol training sequence interleaving downward and upward counts
(`124, 0, 123, 1, 122, 2, ... 63, 61, 62`).

Searching `QF060003`, `QR060103`, `IDSDL302.ROM` and `Ie030002` for that
training sequence as bytes, as reversed pairs, and as 16-bit words in both
endiannesses finds **no match in any image**, not even the first sixteen
entries. The `SP`/`TP` pair never appears adjacent in any of them. `QF060003`
contains exactly one `0x0FC0`, at flat `0xc78dc` — inside the *resident*, not
the `0xc800` image, and as the immediate of an `add` (`ldp #006; lacl @2b;
add #0fc0; sacl @1a`) rather than a stored parameter.

Two caveats. The training sequence is trivially generatable in code, so its
absence as a literal table is evidence rather than proof. And the same search
finds nothing in the analog Courier either, which is expected — none of these
images should contain V.91.

The build stamp says the same thing independently: `QF060003` carries an
embedded `6.0.3` / `09/22/98`, so anything standardised later is excluded on
date. Between the two, V.91 is out.

### A usable method

That search is the shape of the test that would settle `0xc800` positively.
Constants from a specification — parameter values, training or probing
sequences, scrambler taps, constellation tables — searched across the images
and localised to a span, would name the mode. It worked as an exclusion for
V.91; the same run against x2 or V.90 downstream constants would work as a
confirmation.

What the measurements support is only the shape: 1,145 words, multiply density
25.3 per thousand against 46-54 for the PCM cores, `rpt` density 11.4 against
55-67, no large lookup table (entropy is a flat ~6.0-6.7 across every 128-word
block), and a branch into the shared core. That is a small decision-and-mapping
layer. Which mapping it implements needs the code read, not measured.

### The V.PCM datapump is absent from the Quad

[vpcm-datapump.md](vpcm-datapump.md) already identifies 302 overlay 8 as **the
V.PCM datapump — x2 first, with V.90 layered onto it** — and locates its DIL
descriptor by the fixed SP and TP training patterns, packed LSB-first, 66 bits
each. Verified here against `IDSDL302.ROM`, the block sits at file offsets:

| Field | Offset | Bytes |
| --- | --- | --- |
| SP pattern | `0x410c2` | `55 4b 2d b5 b4 d2 4a 2b 01` |
| TP pattern | `0x410cc` | `00 21 84 10 22 84 10 42 00` |
| H1-H8 | `0x410d6` | `0a` x 8 |
| assembler `splk *+,#00c5` / `#4141` | `0x410ec` | N = 197, LSP = LTP = 66 |

All four are consecutive and all four fall inside overlay 8's flash range
(`0x3fdd0..0x435bc`), as that document says.

**None of them appears in `QF060003` or `QR060103`** — searched as-is, word
swapped, and bit-shifted by 1-7 in both directions. Not the SP pattern, not the
TP pattern, not the H block, not the assembler's `N`/`L` signature.

That converges with the block-hash result above, which found 302 id 8 matching
0.0-0.2% of every Quad image and a longest common run of 10 bytes. Two
independent methods, same answer: **the Quad does not carry the analog
Courier's V.PCM datapump at all.**

Because [vpcm-datapump.md](vpcm-datapump.md) is careful that nothing in these
images separates an x2 descriptor from a V.90 one, the correct statement is the
broader one: what is missing from the Quad is the whole V.PCM page, covering
both. That is consistent with the Quad being the *server* end of both schemes
while the Courier is the client end, and it does not depend on attributing
overlay 8 specifically to V.90.

It also explains an earlier failure here. Scanning id 8 for a permutation-like
training table found nothing, which looked like a limitation of the scan; that
document records the reason — **the training UCode sequence is not stored in
any image, in bytes or either word order. It is generated rather than
tabulated.** The null result was correct.

### The packed Ja blobs: why searching for them could not work

The USR DIL and the V.91 default are also available as packed Ja blobs (258 and
164 bytes). Searched across all eight Quad images, the whole `QR060103` payload,
302 id 8 and the whole `IDSDL302.ROM`, as-is, word-swapped and bit-shifted 1-7
each way, the best match anywhere is **10 bytes**, and every hit lands on the run
of zero bytes at pattern offset `0x24` (USR) or `0x13` (V.91). Artifacts.

That includes 302 id 8, where the descriptor demonstrably *is*. The blobs are
the wire form: the Ja carries a CRC, not all of its bits are covered by it, and
USR builds the CRC as it transmits, so those exact bytes need never be stored.
The stored form is the SP/TP/H/REF field block above, which is what to search
for — and which does find it.

Nor could the blobs be decoded here: no fixed-width 7- or 8-bit unpacking of the
V.91 blob reproduces its Table 5 training sequence in either bit order, either
value order, at any start offset to 320 bits, and `SP`/`TP` never appear as
adjacent 12-bit fields.

### Status of `0xc800`

Still unidentified, but better bounded. It is one of three alternatives for a
single mode slot; it shares 0.0% with every other Quad image and with 302
overlay 8; and the Quad carries no V.PCM datapump for it to be a revision of.
So it is Quad-original code rather than a descendant of anything in this tree,
which is what a server-side downstream mapping would be. Naming it still needs
the code read.

### PCM mapping helpers in the larger `0xc300` image

The larger `0xc300` alternative contains an executable, law-sensitive mapping
family. Routine `0xc7ae` reads flag word `0xffd9` bit 0 and installs its four
mapping constants. With the bit clear, data `0x03a3/0x03eb/0x03ec/0x03ea`
becomes `0/0/0x0108/0x007f`; with it set, those words become
`0x002a/0x0042/0/0x007f`. Routine `0xc789` expands the selected program table
into eight working levels.

Routine `0xc9c0` is a directly executable codeword-table constructor. It takes
the destination address in ACC and, using `0xffd9` bit 2, copies nine values
from `0xc9ce` or `0xc9d7` with `rpt #8 / tblr *+`. Its outputs are
`c1 a5 a7 ad af b7 bd c5 cf` and `e5 95 97 9d 9f a7 ad b5 bf` respectively.
The adjacent routines `0xc995`, `0xc9a6`, and `0xc9b7` select further
program-space tables from bit 2 and submode word `0x03e4`. In particular,
`0xc9b7` returns table base `0xcc2b` when clear and `0xcb00` when set; these
addresses are data tables, not executable kernels. The executable consumers
are in the preceding `0xc8xx..0xc9xx` block. The component runner
`tools/probe_quad_pcm_codewords.py` executes these helpers and records their
outputs without invoking compressor `0x817f`.
