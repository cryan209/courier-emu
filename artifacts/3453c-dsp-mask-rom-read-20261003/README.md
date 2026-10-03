# Recovered 3453C DSP mask ROM

`dsp-mask-rom-0000-0fff.bin` contains **4,096 words / 8,192 bytes**, little-endian, at DSP program addresses **0000..0FFF**.

SHA256: `262e4baa49590bb6ca4a473dffb8a8aee67c9fae020ce92ac3f59e077314f1d6`.

Two independently requested 0000..1FFF mapped windows matched exactly. Their upper half, 1000..1FFF, matches the patched resident downloaded from flash, including the monitor dispatcher hook, establishing that this upper region remains external RAM. The lower 4K words differ from unmapped program RAM at 4,090 of 4,096 positions and contain a coherent vector table beginning with `B 0F46`. Boot code at 0F46 uses I/O 8057/8058, matching the 3453 board’s first-download protocol.

Live PMST was **18B8 before and after** each capture. The monitor returned D541 afterward. Each individual ROM read masked interrupts, temporarily cleared only PMST.MP/MC, read one word, and restored mapping and status before replying. The revision remains installed.

The observed image supports a 4K-word ROM compatible with the suspected C52-class part; this is not a broader confirmation of the exact die model. The older 302/403-board ROM is a different image.

`manifest.json`, `sample-verification.json`, and `window-verification.json` preserve provenance and checks. `boot-loader.asm` is the bootstrap excerpt; `mask-rom-linear.asm` is a linear decoding that also includes tables/constants.

The older Courier comparison in `rom-comparison.json` finds 157 same-address
word matches within the first 4K, with substantial relocated blocks (including
496 words at old 0250 / new 00D0). The layouts and bootstrap protocols differ;
this is not a code-similarity percentage. No Cisco MICA DSP ROM is available
for a binary comparison. Its MP/MC switching alone does not establish ROM
compatibility.

The acquisition and extraction scripts preserve the original procedure. They
reference the local diagnostic monitor, patched firmware and unmapped program
capture from the investigation; those prerequisites are recorded in the
manifest and are separate from this ROM evidence bundle.

## Content map, 0030–0F45 (2026-10-04)

Static analysis of the dump. Table identifications are numerical (frequency
response, decoded point pairs, phasor magnitudes). Routine names are
**inferred from disassembly** and have not been traced in execution.

### Tables, 0030–09ED

| Range | Contents |
|---|---|
| 0030–007F | 80-tap symmetric low-pass FIR, DC gain 8 (likely ×8 interpolator). Flat to 0.02·fs, −6.7 dB at 0.04·fs, ≤ −70 dB from 0.08·fs |
| 0080–00BF | V.34 line-probing signal, one 64-sample period: flat spectrum on bins 1–25 except 6, 8, 12, 16 (150–3750 Hz at 9600 Hz, omitting 900/1200/1800/2400) |
| 00C0–00FF | Packed signed-byte (x,y) points, ±16/±48 grid |
| 0100–01BF | 192 packed points, odd multiples of 8 to ±72; consistent with V.32/V.32bis cross constellations, unproven |
| 01C0–02BF | 256 packed points: full 16×16 odd-coordinate square, scaled ×4 |
| 02C0–055F | 672 packed points on a rotated lattice in groups of four, ordered by increasing energy (V.34-style ordering) |
| 0560–058F | Small index/bitmask tables |
| 0590–068F | Trellis-decoder squared-distance table, 16×16 words of byte pairs; see below |
| 0690–06AF | Side-bit map for the 0590 table (1 bit per cell, two 16×16 halves); see below |
| 06B0–06B7 | Fallback metrics for saturated 0590 cells; see below |
| 06C4–06DB | 12 unit-circle points at 30° steps, radius 11585 (0.707 in Q14) |
| 0700–099F | Four 168-word V.34 transmit-scale tables (0700, 07A8, 0850, 08F8); see below |
| 09A0–09ED | Unit-magnitude (16384) phasors: four full-period rotations with steps −68.57°, −72°, −80°, −90° (17/21, 4/5, 7/9, 3/4 cycle); assignment unknown |

### Code, 09EE–0F45

Only 0A4C, 0CC1, 0DAF and 0E5E are direct call targets within the ROM.

| Address | Inferred role |
|---|---|
| 09EE | sin/cos polynomial (constant 0x6488 = π·8192) |
| 0A21 | arctangent: quadrant fold, divide (0A4C), polynomial |
| 0A4C | signed division |
| 0A68 | 64-point radix-2 complex FFT (6 stages); twiddle table 0ABD–0B0C |
| 0B0D | interrupt handler: saturates two values, packs bytes into MMR `@31`, `rete` |
| 0B21–0BB6 | complex MAC / coefficient-update kernels; 0E13–0E70 wraps them for 64/32/16 taps, then jumps via `@48` |
| 0BB7 | table builder using binomial kernel 0C1E (8, −28, 56, −70, …); possibly V.34 shell-mapping tables |
| 0CEE–0DAE | possibly V.34 shell mapper (`mpyu` over data 5440/5470/54C0); 0DAF writes bits into a 128-bit ring at `@28` |
| 0DFF | transmit-scale table lookup (see below); firmware copy at 302 overlay 6 A7C0 |
| 0E71 | scrambler-like step, 4 bits per call |
| 0E86 | complex autocorrelation over three lags into `@68–@77` |
| 0C26 | V.34 precoder solve: three complex taps into data 4B60, zeroed on a stability-check failure. Firmware copy at 302 overlay 6 B64A writes data 0850 |
| 0ED5 | 3-tap precoding filter with modulo wrap (coefficients 4B66/4B69), quadrant table 0F24; likely V.34 precoder |
| 0F28 | clears external data buffers at FBCC and F8CC |

The downloaded firmware already carries byte-identical copies of the probe
signal, the 672-point constellation and the precoder (`2_3_33.XMF`, RAM
captures), and live PMST keeps MP/MC set. So the resident probably does not
call into this library at runtime; not exhaustively excluded.

### Transmit-scale tables, 0700–099F

Four tables of 168 words, each 28 rows × 6 columns. Columns are the V.34
symbol rates 2400–3429; rows are the 14 data rates 2400–33600, two rows per
rate. Zeros fall exactly on the rate/baud combinations V.34 disallows. All
non-zero values lie in 0x5A82–0x7FFF (1/√2 to 1.0), i.e. mantissas of a
scale whose exponent is held elsewhere.

The consumer is ROM 0DFF, identical to `IDSDL302.ROM` overlay 6 A7C0
(tables at A84E there, same order):

    index = base + 12·rate + baud + 6·[FF38 bit 10] + 168·[precoder on] + 336·[FF38 bit 14]

| Term | Meaning | Evidence |
|---|---|---|
| `@5b` | symbol-rate index 0–5 | same cell indexes the baud and carrier tables (`docs/codec-sample-rates.md`) |
| `@7c` | data-rate index 1–14 (base = table − 12) | caller A77B loops it over all 14 rates, writing a per-rate result to data 0836 |
| +168 | precoder taps non-zero | the six ORed words are data 0850–0855, which the precoder solve (B64A) fills or zeroes at B6F6 |
| FF38 bit 10 | auxiliary channel (MP bit 28) | A5C5 clears it locally unless the far end's MP (0340) has it |
| FF38 bit 14 | constellation shaping (MP bit 32); set = shaped tables 0850/08F8 | A74B, below |

### MP layout (302 overlay 6)

FF38–FF3F is the **outgoing** MP, built at A2F5: FF38 keeps bit 15, takes
bits 14/13/10 from local options (0345 << 10 & 6400), always sets bit 12,
and sets bit 0 (type 1) when it carries the local precoder taps 0850–0855
into FF3A–FF3F. FF39 is the data-rate mask from A35E. The A7C0 lookup
therefore follows what this modem sends.

The **received** MP is collected by the coroutine A4D8–A522: bits shift
LSB-first into FF48+ with a reflected CRC-16 (poly 0x8408, init FFFF); 0x30
bits, or 0x90 when bit 0 (type) is set; then 16 CRC bits compared at A521.
On a match A533–A552 copies FF48 → 0340, FF49 → 0341, and for type 1 the six
coefficient words to the remote precoder at 0856–085B.

Each buffer word is one 16-bit block after a start bit (MP bit 18 onward):

| Word 0 bit | MP bit | Field | Evidence |
|---|---|---|---|
| 0 | 18 | type (1 = precoding coefficients) | adds 96 bits = six coefficient words |
| 2–9 | 20–27 | max rates, 4 bits each direction | `and #03fc` at A560/A565 |
| 10 | 28 | auxiliary channel | both ends required (A5C5) |
| 11–12 | 29–30 | trellis encoder select | bit 12 always set on transmit |
| 13 | 31 | nonlinear encoder | |
| 14 | 32 | constellation shaping | |
| 15 | 33 | acknowledge | A554 waits for it |

Word 1 is MP bits 34–49: start bit, then the 15-bit data-rate mask (`& 7FFF`).

### Shaping polarity

A70E computes per-direction frame parameters (once for the local MP at 0344,
once for the remote at 0340). At A74B it tests MP bit 14 and reads a packed
byte pair from the table at A7EC: high byte when clear, low byte when set,
stored minus one as the shell mapper's ring count M.

| Index | 0 | 1–7 | 8 | 12 | 15 | 18 | 20 | 24 | 28 | 31 |
|---|---|---|---|---|---|---|---|---|---|---|
| bit 14 clear | 1 | 2 | 2 | 3 | 4 | 5 | 6 | 8 | 12 | 15 |
| bit 14 set | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 10 | 14 | 18 |

Set never gives fewer rings and gives up to ~1.2× more: the expanded
(shaped) constellation. So bit 14 = 1 is shaping on, selecting the +336
tables (0850 without precoder, 08F8 with). Consistent with the scale data:
both M values agree at low indices, where the shaped and unshaped tables are
identical, and where they differ the shaped scale is smaller. The low-rate
agreement is qualitative; the A7EC index was not recomputed per cell.

### Squared-distance table, 0590–068F

16 rows × 16 words; each word holds two bytes. Both bytes are a quantized
squared distance to the nearest lattice point, periodic in 16 steps on both
axes and saturating at 255:

* separable: `T[r][c] ≈ T[r][0] + T[0][c]` (e.g. 32 + 28 = 60 vs 61 at 3,3);
  each axis grows as ~3·n², with rows ~10% steeper than columns;
* the high byte is sampled on the step grid (0 at 0,0); the low byte is the
  same surface offset by half a step (1.5–2 at 0,0; 7.5–9 at 0.5,1.5),
  i.e. one extra bit of resolution.

The firmware copy is `IDSDL302.ROM` overlay 6 C3B8, read twice at BAC8–BB44,
once per 2D half of a 4D symbol (inputs `@4c/@4d` and `@4e/@4f`, data
034C–034F; outputs `@58`/`@59`):

* row = bits 10–13 of `x + y`, column = bits 10–13 of `x − y` (axes rotated
  45°, so the 2D subsets form a rectangular lattice);
* bit 9 of `x − y` (`bsar 7 ; and #4`) picks the byte, the half step below the 4-bit column index;
* a second term from C4B8 (+16 for the other byte) is added, and a total of
  0x1FE is replaced from C4D8.

This gives one Viterbi branch metric per 2D half, which fits the V.34 4D
trellis decoder. The roles of C4B8 and C4D8 were not traced. No routine in
the ROM code region was found reading this table.

### Side-bit map 0690 and fallback 06B0

Firmware copies: C4B8 and C4D8 (same overlay). Per 2D half, BAE4–BB02:

    d   = C3B8[16·row + col]             ; byte chosen by bit 9 of x − y
    b   = (C4B8[row + (16 if high byte)] >> col) & 1   ; satl, TREG1 (MMR 0Dh) = col
    m   = 2·d + b
    if m == 0x1FE: m = C4D8[2·(row & 3) + sign(x − y)]  ; rolb pulls the sign from ACCB

* **0690–06AF** is a 1-bit map: words 0–15 go with the low byte, 16–31 with
  the high byte; word = row, bit = column. Every saturated (255) cell has
  b = 0, so the sentinel is exactly 0x1FE.
* **06B0–06B7** = 194 191 19D 19C 1FF 1FF 197 196: finite replacements
  (metric ≈ C8–CE, two at FF) for saturated cells, keyed by row mod 4 and the
  sign of x − y. Their LSBs are side bits in the same format.
* b is **not** a rounding bit of d: it does not make the distance surface any
  smoother, in any arrangement of the map (rows/columns swapped, halves swapped).

Consumer, BB58–BB74: the metric stored at data 0250 + 2n is
`min(m >> @54, @55)` (`satl` with TREG1 = `@54`, then `crlt`). The bits that
shift drops (`m & ((1 << @54) − 1)`, b among them) are combined for both
halves (`@58` low bits + `@59 << @54`), shifted left 3 and ORed with a 3-bit
value from the C3A8 table into data 0260 + n. So b is carried with the
stored decision word, not the metric. It looks like a per-cell decision
(for example, which of two candidate points is nearest), but what it selects
was not traced; nor were the values of `@54`/`@55`.
