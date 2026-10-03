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
| 0590–068F | 16×16 packed-byte table, symmetric, saturating to FF at centre; purpose unknown |
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
| FF38 bit 14 | constellation shaping (MP bit 32) | MP layout below; which polarity selects the shaped pair is not traced |

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
