# Full C51 ROM content analysis

Direct analysis of the 20.16 MHz and 2806 full dumps, 2026-09-13.
Addresses below are DSP word addresses. Each file is 8192 16-bit words
(16384 bytes), rather than 8192 bytes.

## Newly identified contents

* `0040–0240`: **513-entry quarter-wave cosine table**, exactly equal at every
  entry to `round(16384*cos(pi*i/1024))`, i = 0..512. Q14 amplitude, from
  `4000` down to zero. This is a mathematical identification, not a visual guess.
* `05b0–05cc`: trigonometric lookup helper. It folds an input phase, reads the
  table using bases `0240` and `0040`, and adjusts signs. Consistent with
  generating a sine/cosine pair; the precise calling convention needs tracing.
* `0244–044f`: structured packed byte pairs, consistent with constellation
  coordinates. `0450–05af` contains small-index mapping/decision tables.
  Their specific modulation standards are not established by this pass.
* `05cd–060f`: arithmetic helpers, including an iterative division-like loop
  at `05f4` and a polynomial computation before it. An angle calculation is
  plausible, but not yet established.
* `0610`: another download/service path, polling `@56`, moving four-word
  blocks from `@58` onward into program memory, and transferring control
  through `@7d`. Reset at `0670` installs `0610` in `@6a`, whose ROM vector
  is at `0024`.
* `1f9d–1ffa`: **likely diagnostic/manufacturing test code**, rather than
  merely a mailbox handshake. It accumulates ROM data (`1fb7`), writes and
  sums data RAM (`1fbf–1fc9`), fills program `2000–23ff` (`1fca–1fd2`),
  exercises arithmetic/logical operations, copies results to external
  addresses `7000` and `9028`, toggles XF, and loops to `1fa2`.
  The factory-test interpretation is inference from these operations; no
  manufacturer identification of this routine has been found. Do not invoke
  it as a harmless query: it overwrites RAM.

## Comparison and limits

The two files differ in precisely 96 words, all in `0f9d–0ffc`. The 2806
image repeats the top block there; the 20.16 MHz image has the regular array
pattern instead. Their low tables/code and top block are identical.
This does **not** distinguish a decode alias from a mask revision or another
silicon difference. Existing notes claiming the duplicate cannot be mask
content are stronger than the evidence supports.

The capture READMEs identify both compared boards as analog V.Everything
units. The user's physical observation that the ISDN unit has matching C51
markings is additional hardware evidence, but these files alone are not an
analog-versus-ISDN ROM comparison.

The ROM is mostly repetitive fill, but the populated low region includes
useful DSP mathematics and probable modulation tables, not just boot code.
Most modem functionality still comes from downloaded firmware; no complete
V.34/V.90 implementation has been identified in this mask ROM.

## Correction to older vector notes

Direct decoding gives `0008: 0868 be20`, i.e. `lamm @68; bacc`, **not @63**.
`@63` is used by the vector at `0012`. This contradicts the timer-vector
example in `docs/dsp-onchip-rom.md`; the binary should be authoritative.
No emulator changes were made in this analysis.

## Does the flash payload use it?

Checked the 4.03 capture's DSP 3.1.2 resident and all three overlays.
The resident at `8030–8033` copies eleven handler addresses from program
`812d` into data `0060–006a`. These are the pointers used by the mask ROM
interrupt trampolines. Together with the established ROM boot path, this is
positive evidence of a real dependency on the ROM.

No convincing direct calls to the ROM math helpers were found in this static
pass. Scanning every word produces conditional-branch false positives inside
numeric data, which must not be counted as calls. This is not an exhaustive
exclusion of indirect calls or computed table reads.

Instead, downloaded firmware has its own sine computation at `8b6a–8b83`,
using a polynomial rather than the mask's cosine lookup. It also contains
byte-identical portions of the ROM arithmetic helper: ROM `05cd–05de` occurs
at resident `8b84`, and ROM `05f4–05fe` at resident `8baf`. This indicates
shared implementation ancestry, not execution of those routines in ROM.

The loader's general scheme agrees with TI SPRU056D section 8.9 (reset into
ROM, selection word at data FFFF). That establishes TI-style boot support,
not byte-for-byte identity of this entire mask with a standard TI image.
The origin of the mathematics/constellation content remains unproven.

## ISDN I-Modem comparison

Also checked `firmware/legacy-usrobotics/2332-x302/Ie030002.xmp`, decoded by
`XmpImage`, using all seven image descriptors (5–11) at payload `71682` and
segment table `716ca`.

* Resident `805f–8062` installs eleven interrupt pointers from program
  `82e0` into data `0060–006a`. In particular `0068 = 838e`, so the captured
  ROM timer trampoline would dispatch to downloaded code at `838e`.
* Resident `9112–912a` contains its own polynomial sine helper, closely
  resembling the analog helper but with slightly different coefficients.
* ROM `05cd–05de` has an exact copy at `912b`; ROM `05f4–05fe` at `9156`.
* No ordinary immediate CALL/CALLD/B/BD into ROM `0040–077f` was found in
  any of the seven images. Apparent BLPD reads from `0100` in image 6 are
  entries in a pointer/count table at `a487`, not established instructions.
  Conditional and indirect transfers and computed reads remain a limitation.

Thus the ISDN code also explicitly expects ROM interrupt infrastructure and
supplies downloaded maths helpers. This static result does not independently
prove that its physical mask ROM is identical to the analog dump.
