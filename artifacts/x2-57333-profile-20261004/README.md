# QF060003 57333 PCM profile

The local rate-index-15 constructor supplies B=37. With MD=6 this
allocation consumes 43 bits per six samples, or 57333⅓ bit/s at the 8000/s
sample cadence. This is a seeded component reconstruction, not a captured
57333 connection or a recovered peer-negotiation record.

## Mapping

The source appender B2BA scrambles source bytes with the role-selected
GPC (1+x^-18+x^-23) or GPA (1+x^-5+x^-23) recurrence and appends them
LSB first to the 128-bit ring. C5DF consumes six sign bits and then a
37-bit amplitude integer X. In the default mode-zero, zero-record context,
the six emission-order radices are **82,70,70,70,70,70**.

For each position, digit=X modulo radix; X=floor(X/radix). The digit
selects an entry in that position's bank at E8F4+128*i. The low seven bits
uniquely identify the magnitude in the tested bank. The bank product is
137817400000, exceeding 2^37=137438953472. Only amplitude integers
0..2^37-1 are generated; surplus mixed-radix tuples are unused.

C642 converts the six independent sign bits into successive differential
parities and toggles codeword bit 7. With MD=6 there are no free signs for
disparity shaping. The continuous original C544 dispatcher emits the six
codewords and applies the selected output XOR. Exact-symbol reception
undoes that XOR, finds the bank digits, reconstructs the amplitude integer,
reverses differential parity, reassembles frame bits across byte boundaries
and descrambles them.

## Builder setup and variants

**The constructor must execute with SPM 1.** Its C72D/C74E/C761 scaling
uses MPY/PAC product transfers. Earlier SPM 0 probes produced duplicates
or failed to return; those results are superseded. The original overlay
also restores SPM 1 at C40C before returning to resident code. This is
supporting calling-convention evidence, not a captured index-15 call.

The scan seeds 0340=mode<<11, E8F2=0600, FFD9=flags, 039F=0040,
03FB=1. A nonzero position is a record nibble of two; active positions
are the first one or two. Zero positions trigger the builder's default
record behavior. FFD9 bit 12 and 039F bit 7 remain clear.

| Mode | FFD9 bit 2 | Active positions | Emission-order radices |
| --- | --- | --- | --- |
| 0 or 2 | 0 | 0 | 82,70,70,70,70,70 |
| 0 or 2 | 0 | 1 | 45,79,79,79,79,79 |
| 0 or 2 | 1 | 0 | 72,72,72,72,72,72 |
| 0 or 2 | 1 | 1 | 48,78,78,78,78,78 |
| 0 or 2 | 1 | 2 | 49,49,87,87,87,87 |
| 1 | 0 or 1 | 0 | 72,72,72,72,72,72 |
| 1 | 1 | 1 | 42,80,80,80,80,80 |
| 1 | 1 | 2 | 46,46,90,90,90,90 |

Both tested FFD9 bit-zero states pass for every valid row. Mode affects
scaling and actual bank contents, even where radices match. Full bank
snapshots are in profile-MODE-FLAGS-ACTIVE.json. Other forced combinations
in this scan lack sufficient capacity: not every descriptor row extends
to index 15. A successful seeded construction does not establish that
peers negotiate that combination.

## Reproduction and checks

Run with the repository Python environment:

```
.venv/bin/python tools/probe_x2_57333_profile.py
.venv/bin/python tools/recover_x2_payload.py
```

The dedicated scan validates 28 of 36 contexts. Each valid context has 64
original-DSP mapping/ideal-inverse comparisons, including all-zero and
maximal 43-bit groups, random ring offsets and differential parity states:
**1792 exact-symbol round trips**. search-spm1.json records all cases;
verification.json gives the scope; builder.asm preserves the disassembly.
search.json, search-override.json and mode1-builder-trace.json preserve
superseded SPM 0 investigation results for provenance.

The broader corrected harness builds all fifteen indices with SPM 1 and
checks 840 firmware-bank/inverse cases and 1260 continuous dispatcher
sample steps. Its 56 streams of 32 frames cover indices 10 and 15, MD=0..6,
both scrambler role flags and both output format states. It validates
10752 continuous samples and recovers 8400 source bytes. Index 15/MD=6
is included; other MD choices at index 15 are arithmetic component tests,
not additional established negotiated rates.

Still open: the actual peer rate/record selection, a full 57333 connection,
analogue receiver acquisition/equalization and symmetric lower-rate calls.
