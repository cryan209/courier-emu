# Where V.PCM lives, and why 7200 Hz was never the whole story

Overlay 8 is the V.PCM datapump - x2 first, with V.90 layered onto it. It is identified by its own DIL descriptor, and
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
`IDSDL302.ROM` carry the same block in their own overlay 8, at `e599`.

The descriptor is stable across every image here. The assembler's signature -
`splk *+, #00c5` then `splk *+, #4141`, so N = 197 and LSP = LTP = 66 - appears
in all four, including `main211` from 2003, and the SP and TP patterns are
identical with it. So this descriptor did not change between the oldest build in
this repository and the newest.

**An earlier version of this document read more into that than it supports.** It
argued that because the 3.0.13 DSP is stamped `03/13/98`, about six months before
V.90 was approved, the descriptor must be x2's with V.90 layered on. Two things
undermine that:

* The `ATI7` date is a stamp in the image. What it actually records - when the
  code was written, built, or released to users - is not established here, and
  the argument needs it to mean the first of those.
* x2 and V.90 have a great deal in common, and USR's own work fed the
  recommendation. If the two use the same descriptor, then "x2's or V.90's" is
  not a question this image can answer, because there would be nothing to tell
  apart.

What the images do support is narrower and still useful: **one page carries the
V.PCM datapump, its descriptor has not changed across five years of builds, and
nothing here separates an x2 descriptor from a V.90 one.** Whether x2 and
K56flex had an equivalent impairment-learning phase is a question about those
specifications, not about this ROM, and this document does not answer it.

The training UCode sequence is not stored anywhere in any image, in bytes or in
either word order. It is generated rather than tabulated - and running the
generator confirms it, below.

## The assembler, and the descriptor it produced on the wire

Immediately after the field block, at program `e7e8`, is the code that builds
the descriptor:

```text
e7e8: ldp  #006
e7e9: lar  ar1, #0940      ; the build buffer
e7eb: splk *+, #00c5       ; N = 197
e7ed: splk *+, #4141       ; LSP-1 = 65 and LTP-1 = 65, packed as two bytes
e7f0: blpd *+, #e7d6       ; 5 words of SP
e7f3: blpd *+, #e7db       ; 5 words of TP
e7f6: blpd *+, #e7e0       ; 4 words of H1-8
```

So `N = 197`, `LSP = 66`, `LTP = 66`, and the patterns come straight out of the
block above.

That can be checked against the wire rather than left as a reading. The user's
V.90 DIL lab carries `COURIER_JA_HEX`, a 2058-bit Ja recovered from a capture of
this modem transmitting, with a valid CRC. Parsing it with that tool's own field
framing and comparing every field against this image:

| field | transmitted Ja | overlay 8 | |
|---|---|---|---|
| N / LSP / LTP | 197 / 66 / 66 | 197 / 66 / 66 | match |
| SP | 66 bits | `e7d6` | match |
| TP | 66 bits | `e7db` | match |
| H1-8 | 10 x8 | `e7e0` | match |
| REF | 0 x8 | `e7e4` | match |

Every field, from the ROM to the signal.

The raw recovered hex does **not** appear anywhere in the flash, and that is the
expected result rather than a contradiction: the wire format is framed, with a
zero bit ahead of each chunk of up to 16 payload bits and the H and REF entries
carried as 7-bit values between framing bits, while the ROM stores the patterns
unframed and LSB-packed. The framing, the training Ucodes and the CRC are all
added when the descriptor is assembled - which is what the CRC below is for.

## The four images, and which ones do I/O

| image | loads at | span | serial-port access |
|---|---|---|---|
| resident | `8000` | `8000..eea7` | `TSPC` setup x2, `DXR` write x4, `DRR` read x1 (the ISR) |
| overlay 6 | `9d00` | `9d00..ce32` | **none** |
| overlay 7 | `b000` | `b000..cd4a` | none |
| overlay 8 | `dc00` | `dc00..f94a` | none |

Overlay 8 touches no converter. It is pure algorithm, and it does not overlap
overlay 6, so the two are loaded together: 6 is the datapump, 8 runs V.PCM on
what it produces. Overlay 7 sits inside overlay 6's range, so those two are
alternatives.

## Retracted: there is no second converter here

> An earlier version of this document said the board takes samples on both C5x
> serial ports, and used that to dissolve the 7200 Hz problem in
> [codec-rate-312.md](codec-rate-312.md). **That was wrong.** It rested on
> overlay 6 appearing to read `DRR` 32 times and `TRCV` four times. Every one of
> those 36 sites is inside a data table that disassembles into plausible
> instructions - they cluster in two contiguous blobs at `c019..c207` and
> `ca64..cbf2`, and not one has a single control-flow target within 48 words,
> while every site in the resident bank does. `tools/c5x_disasm.anchored` now
> makes that test cheap, and `tests/test_c5x_anchoring.py` pins these exact
> addresses so the mistake cannot come back quietly.
>
> What survives is only this: the resident bank sets up `TSPC`, the TDM serial
> port's control register, at `808a`. **Nothing in any of the four images ever
> reads `TRCV`.** So the port is configured and then not used, which is a much
> weaker fact than "both converters are in use" and does not resolve anything.
>
> The 7200 Hz contradiction is therefore **open again**, and harder than before:
> the only sample path in evidence anywhere is the AC01 on the primary port.

## The far end sent exactly the ladder this ROM generated

`artifacts/dil-alaw-01/` is a DIL a digital modem sent downstream in answer to
this Courier's own Ja. It is 13,002 bytes of G.711 A-law, which is `197 x 66` -
N segments of LSP symbols, both numbers out of the descriptor - so the capture's
length alone confirms the request it answers. Checked against the ROM:

| | result |
|---|---|
| signs | all 13,002 follow the descriptor's `SP` |
| `TP` = 0 slots | every one carries Ucode 0's level, magnitude 8 |
| `TP` = 1 slots | each segment holds one level across its twelve |
| that level | is the level of the Ucode this firmware generates for that segment |
| overall | 117 distinct Ucodes to 117 distinct levels, one to one, no exceptions |

So the generated ladder is not merely plausible - the far end answered it
symbol for symbol. `tests/test_vpcm.py` pins all four.

The levels also settle the law. A Ucode is a G.711 chord decomposition, and the
two laws differ by mu-law's 132 bias and by A-law's first chord: Ucode 100 is
10496 in A-law and 10364 in mu-law. Every segment matches the A-law form
exactly, which is what the capture's name says was requested.
`vpcm.ucode_level` carries both, with A-law verified here and mu-law only the
standard's arithmetic.

## Scoring an impaired one

`artifacts/dil-ulaw-impaired-01/` is the same DIL with impairments deliberately
applied, and in mu-law where the clean one is A-law. `vpcm.score_dil` compares
either against the ladder:

| | clean (A-law) | impaired (mu-law) |
|---|---|---|
| signs wrong | 0 | 0 |
| training symbols exact | 2364 / 2364 | 66 / 2364 |
| gain | 1.0000, 0.00 dB | 0.4986, **-6.04 dB** |
| reference slots disturbed | 0 / 10638 | 5139 / 10638, worst 244 |

Three readings, and what separates them:

* **A 6 dB digital pad.** The gain is flat across all six data-frame intervals,
  -6.05 to -6.08 dB, and the modal Ucode error is **-16** - one mu-law chord,
  and one chord is 6 dB.
* **Additive noise on top.** A pad scales, so it leaves a silent slot silent.
  Nearly half the reference slots are not, which a pad cannot explain; the
  residual after removing the pad has a standard deviation of about 79. After
  accounting for the pad, a quarter of the training symbols land on the exact
  Ucode and the rest spread one to three either side, which is that noise.
* **Not robbed-bit signalling.** RBS lands on particular data-frame intervals.
  This is flat across all six, so whatever else it is, it is not that. That the
  signs are all still correct says the same thing from another direction: the
  impairment is amplitude only.

This is the comparison a DIL exists to make, and it is the comparison the
datapump's own matcher makes. Running it here does not locate that routine -
see below - but it does establish that the ladder the firmware generates is
enough to characterise a channel, which is the claim the descriptor rests on.

## The matcher itself has not been found

Scoring a DIL means comparing what arrives against the level each training
Ucode should have produced, and the levels are linear: chord `u >> 4`, step
`u & 15`, magnitude `(2 * step + 33) << chord`, which puts Ucode 100 at 10496
in a 16-bit sample. `vpcm.ucode_level` writes that out for comparison against a
capture. It is the standard's arithmetic, not a recovered routine.

The routine that does it is **not located**. What is established is narrower,
and worth keeping separate from the expectation:

* There is **no companding table** in any of the four images - not the mu-law
  chord ladder (33, 99, 231, 495, 1023, 2079, 4191) in either direction, and no
  monotonic run of levels anywhere. So the conversion is computed. That is
  consistent with the Courier working in linear levels, and with V.90 needing
  both A-law and mu-law, neither of which is worth a table if the chord
  arithmetic is a few instructions.
* **Overlay 8 cannot be receiving the DIL.** It has no serial-port access at
  all; the samples exist only in overlay 6. The two are co-resident, so a
  matcher spans them - which is why searching overlay 8 alone would not find it.

Two searches that failed, recorded so they are not repeated. Tracing readers of
the descriptor buffer at `0940` is dominated by false leads, because overlay 8
reuses that address as a bit-field (`bit 8, *`, `opl *, #1000`). And the
variable-shift instructions that would implement a chord expansion - `lact`,
`addt`, `subt` - are not a usable filter: overlay 6's apparent cluster is a data
table read as code, and overlay 8's real one at `ea91` is a mask generator,
`samm @0d` then `lact @7b` then `sub #01`, which is `2^n - 1`.

### What the last search turned up instead

Overlay 6 at `a650` is a variable-width bit-field extractor over the same `0940`
buffer: it normalises to find a bit position (`rpt #0e ; norm *-`), builds a mask
of that width, and pulls fields of 2 and 6 bits, switching between `0340`/`0341`
and `0940`/`0941` on a flag. That is descriptor framing rather than DIL scoring.
Its mask generator is the same shape as overlay 8's at `ea91` - `samm @0d`, then
`lact`, then `sub #01` - so the two pages share that helper.

Finding the matcher wants a dynamic trace rather than cross-references: run the datapump
in the core and watch which addresses are read back after the descriptor is
assembled. `vpcm.assemble` already sets up a working entry, including the ARP
detail above; what is missing is a plausible state to enter the receive path in.
