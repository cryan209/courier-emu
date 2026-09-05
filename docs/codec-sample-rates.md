# The codec has three sample rates, and the V.34 symbol rate picks them

`codec-rate-312.md` closes on a contradiction: the dial path runs at 7200 Hz,
the AC01's divider registers are written once at reset and never again, and the
unit nonetheless does V.34 at 3429 baud and V.PCM at 8000 baud - which 7200 Hz
sampling cannot carry. The second of those is wrong. There is a runtime rate
change, it is table-driven, and the table is indexed by **V.34's symbol-rate
field**.

| index | V.34 symbol rate | codec word | B | sample rate |
|---:|---|---|---:|---|
| 0 | 2400 | `0214` | 20 | **7200 Hz** |
| 1 | 2743 | `0213` | 19 | **7578.95 Hz** |
| 2 | 2800 | `0213` | 19 | 7578.95 Hz |
| 3 | 3000 | `0213` | 19 | 7578.95 Hz |
| 4 | 3200 | `0212` | 18 | **8000 Hz** |
| 5 | 3429 | `0212` | 18 | 8000 Hz |

So 7200 Hz is the 2400-baud rate - V.32bis and everything below it, and the
dial, call-progress and answer-tone paths that live in the resident bank. It was
never the board's one rate.

## Why the earlier scans missed it

The search that produced "the dividers are written once at reset" was for
`lacc #0nnn ; call <sender>` - and every runtime write is made by a routine that
**inlines** the sender's handshake instead of calling it. In the 3.1.2 build the
inlined copy sits immediately after the sender it duplicates:

```text
8138  samm @6c        ; the control-word sender: park the word,
8139  lacl #03        ; raise the secondary-frame request,
813a  samm @6b        ; and idle until the ISR has sent it
813b  idle
813c  lamm @6b
813d  bcnd 813b, neq
813f  ret

8140  sacl @7d        ; the rate selector: acc = index
8141  add  @7d, 2     ; index * 5
8142  add  #815a      ; + table base
8144  tblr @7d
8145  add  #01
8146  tblr @7e
8147  out  @7d, 0068  ; row words 0,1 -> ASIC ports 0x68/0x69
8149  out  @7e, 0069
814b  add  #01
814c  tblr @7d
814d  add  #01
814e  tblr @7e
814f  out  @7d, 006b  ; row words 2,3 -> ASIC ports 0x6b/0x6c
8151  out  @7e, 006c
8153  add  #01
8154  tblr @7f        ; row word 4: the codec control word
8155  lacl @7f
8156  samm @6c        ; ...sent through an inlined copy of 8138
8157  lacl #03
8158  samm @6b
8159  ret
```

A scan for calls to `8138` returns exactly the six reset writes plus one
register-4 write, as `codec-rate-312.md` reports. It is true and it is not the
whole story: `8140` writes the codec without ever calling `8138`.

## The table

Six rows of five words, at program `815a` in the 3.1.2 build (`816b` in
`IDSDL302.ROM` and in stock 7.3.14, which differ only by the shift in addresses):

```text
row0: 000f 0002 0078 0901 0214
row1: 000d 1112 0082 0926 0213
row2: 000d 0c12 0085 0901 0213
row3: 000c 0f12 008e 0911 0213
row4: 000c 0202 0090 0901 0212
row5: 000b 0808 009a 0926 0212
```

Byte-identical in all three 20.16 MHz images - stock 7.3.14, ID_SDL 4.03, and
the flat `IDSDL302.ROM`. It is absent from `main211.xmf` and from the 2.x builds,
which are other boards.

## Why the index is V.34's symbol rate, and not something else

Three independent things say so.

**The selector is a 3-bit received field clamped to 5.** At `96c7` the resident
reads a 12-bit field out of a received frame with the bit extractor at `8785`,
masks it to three bits, clamps it to 5, and stores it as the table index:

```text
96c7: lacl #0c ; call 8785   ; read 12 bits
96ca: and  #0007             ; keep 3
96cd: lacl #05 ; crlt        ; clamp to 0..5
96cf: sacl @5b               ; the rate index
```

Three bits with six legal values, arriving in a negotiated frame, is V.34's
symbol-rate field.

**Word 2 of each row is `360 x baud / Fs`.** This is the check that makes the
mapping arithmetic rather than suggestive. Taking the six V.34 symbol rates in
order and the three sample rates above:

| index | baud | `360 x baud / Fs` | word 2 |
|---:|---|---:|---:|
| 0 | 2400 | 120.00 | `0078` = 120 |
| 1 | 2742.86 | 130.29 | `0082` = 130 |
| 2 | 2800 | 132.99 | `0085` = 133 |
| 3 | 3000 | 142.50 | `008e` = 142 |
| 4 | 3200 | 144.00 | `0090` = 144 |
| 5 | 3428.57 | 154.29 | `009a` = 154 |

All six agree to rounding. Nothing was fitted: the sample rates come from the
codec words, the symbol rates from V.34, and 360 is the only free constant.
Read backwards, word 2 recovers the sample rate - row 2 gives
`360 x 2800 / 133 = 7578.9`, row 4 gives exactly 8000, row 0 exactly 7200.

**Each rate is the smallest of the three that clears its own spectrum.** V.34's
widest signal, 3429 baud on the 1959 Hz carrier, reaches 3673 Hz; 7578.95 Hz
sampling gives 3789 Hz of Nyquist and 7200 Hz gives 3600, which is not enough.
Row by row the margin over Nyquist is 1.09-1.20 - see the table below. The
ladder is V.34's own bandwidth requirement and nothing else.

## The arithmetic behind the codec words

Under the `(register << 8) | data` reading, all three words write **register 2**
and nothing else; register 1 keeps the `A = 10` it was given at reset. With any
`Fs = MCLK / (2 x A x B)` form the rates are then in the ratio `1/20 : 1/19 : 1/18`,
and the dial path's DTMF pins the first to 7200 Hz, so:

```text
Fs(B=20) = 7200      Hz   (DTMF, independently measured)
Fs(B=19) = 7578.947  Hz
Fs(B=18) = 8000      Hz   exactly
```

`B = 18` landing exactly on 8000 Hz is a property of the 2.88 MHz MCLK, not
evidence that the ladder was designed for V.PCM - see below. What it does
answer is the question `codec-rate-312.md` poses at the end: a second mode's register values give the ratio between the rates directly,
and with `A = 10` fixed they give `MCLK = 2.88 MHz`, which is `40.32 MHz / 14`
off the board's oscillator.

## What still selects index 0

The reset sequence writes `B = 20`, so the board comes up at 7200 Hz, and the
resident bank returns to it explicitly (`lacl #00 ; call 8140` at `a32b` and
`a331`, and `splk @5b, #0000` at `9499`). The DTMF table at `86fd` and the tone
increments at `86dc` are 7200 Hz values throughout - digit 1 gives 696.97 and
1209.05 Hz, and `0x4aab` gives 2100.000 Hz, the answer tone - so everything the
resident bank generates by hand belongs to index 0.

## Which overlay asks for which rate

| loader | index | rate |
|---|---:|---|
| overlay 6, at its entry (`9d14`) | 5 | 8000 Hz |
| overlay 7 (`b155`, `b4c7`) | 1 | 7578.95 Hz |
| resident, high-speed paths (`8e0d`, `a33c`, `a38e`, `a3d7`, `a412`) | 4 | 8000 Hz |
| resident, back to base (`a32b`, `a331`) | 0 | 7200 Hz |
| resident, from the negotiated field (`970c`) | 0-5 | all three |

Overlays 6 and 7 overlap in program space and are alternatives; overlay 8, the
V.PCM datapump, loads alongside either.

## One index, two directions

V.34 negotiates transmit and receive symbol rates independently, and the AC01
has a single `Fs` for both converters. So the six-row index cannot simply be
"the symbol rate" - it has to be a reduction of two. It is, and the reduction
is visible twice.

**The selector is an argmax over six rates of the per-direction minimum.**
`91e1` walks two six-entry arrays in parallel - `ff28..ff2d` and `ff30..ff35`,
one per direction - takes the smaller of the pair at each rate, and keeps the
index of the best:

```text
91e7: lar  ar2, #ff2d       ; direction A, six entries
91e5: lar  ar1, #ff35       ; direction B, six entries
91e9: lar  ar3, #05         ; six iterations
91eb: sacl @5b              ; best index so far = 0
91ed: lacl *-, ar2          ; B[i]
91ee: sacb
91ef: lacl *-, ar3          ; A[i]
91f0: crlt                  ; min(A[i], B[i])
91f1: lacl @7d              ; best so far
91f2: crgt                  ; max(best, min(A[i], B[i]))
91f3: sacl @7d
91f4: xc   2, nc
91f5: lamm @13
91f6: sacl @5b              ; ...and record the index if it improved
91f7: banz 91ed, *-, ar1
```

**And `971c` reduces two 3-bit fields by `max`.** `@7d` and `@7e` are filled by
the bit extractor from two different frame buffers, `ff08` and `ff1a`, with the
two swapped between the blocks at `96b9` and `96d3` - which is call mode against
answer mode:

```text
971c: lacl #07 ; and @7d ; sacb    ; direction A's 3-bit rate field
971f: lacl #07 ; and @7e ; sacl @7c ; direction B's
9722: crgt                          ; the greater of the two
9723: lacl #38 ; and @7e ; bsar 3   ; a second 3-bit field
9727: add  @7c
9728: crlt                          ; capped
```

`CRGT` and `CRLT` leave the greater and the lesser of `ACC`/`ACCB` in `ACC`, so
these are `max` and `min`. `971c`'s result goes to `@7f`/`@7c` rather than to
`@5b`, so it is not itself the codec selector - but between the two, the
firmware plainly carries the directions separately and collapses them to one
number before the codec sees it.

The consequence matters for the ladder above: the codec rate is bounded by the
**wider** of the two directions, not by either one alone. A connection
transmitting at 2400 baud while receiving at 3429 still runs the codec at
8000 Hz. So the per-row Nyquist margins in the table are a worst case, and the
asymmetric case your reading of the table might suggest - one direction's rate
starving the other - cannot arise.

## What this does not establish: the V.PCM rate

The ladder above is **V.34's**, and only V.34's. Overlay 8 reads `@5b` zero
times and writes no codec register, so it runs at whatever rate the V.34 index
last selected. The rate it gets is therefore 8000 Hz only when the index -
`max` over the two directions, per the section above - is 4 or 5; at 2400-3000
baud the codec is at 7200 or 7578.95 Hz, which cannot align to a downstream
8 kHz codeword stream without resampling in software.

The `max` helps here rather than hurting: V.PCM only constrains the *receive*
direction, so the downstream symbol rate alone can pull the codec to 8000 while
the V.34 upstream runs slower. What it does not cover is symbol rate 3000,
which maps to index 3 and 7578.95 Hz. If V.PCM admits 3000, that case still
needs an explanation.

An earlier version of this document argued that `B = 18` landing exactly on
8000 Hz showed the ladder was provisioned for V.PCM. It does not. Checking each
row against its own carrier and symbol rate, the margin over Nyquist is
1.09-1.20 throughout:

| index | carrier | baud | upper edge | min Fs | given | margin |
|---:|---:|---:|---:|---:|---:|---:|
| 0 | 1800 | 2400 | 3000.0 | 6000 | 7200.00 | 1.200 |
| 1 | 1829 | 2743 | 3200.5 | 6401 | 7578.95 | 1.184 |
| 2 | 1867 | 2800 | 3267.0 | 6534 | 7578.95 | 1.160 |
| 3 | 1875 | 3000 | 3375.0 | 6750 | 7578.95 | 1.123 |
| 4 | 1920 | 3200 | 3520.0 | 7040 | 8000.00 | 1.136 |
| 5 | 1959 | 3429 | 3673.5 | 7347 | 8000.00 | 1.089 |

That is a uniform oversampling margin over V.34's own bandwidth. Nothing in the
ladder is provisioned for V.PCM; `144000 / 18` is 8000 because `B = 18` is what
3200 and 3429 baud need, and the exactness is a property of the 2.88 MHz MCLK.

So the V.PCM sample rate is **not established here**. Three possibilities, none
of them ruled out:

* The firmware constrains V.PCM to symbol rates 3200/3429, so the codec is at
  8000 whenever PCM runs. Several resident paths do force index 4 by literal
  (`8e0d`, `a33c`, `a38e`, `a3d7`, `a412`, and `splk @5b, #0004` at `90ba` and
  `9299`), which is what that constraint would look like - but none of them is
  identified as the V.PCM path.
* Overlay 8 resamples from 7578.95 to 8000 internally.
* There is a rate mechanism for V.PCM that this search has not found.

What would settle it: identify which of the forced index-4 sites is on the
V.PCM path, or find the overlay-selection logic in the supervisor that pairs
overlay 8 with overlay 6 (which defaults to index 5) rather than overlay 7
(which defaults to index 1).

## What this closes and what it does not

The contradiction in `codec-rate-312.md` is resolved: fact 2 - "registers 1 and
2 are set once at reset and never changed" - is false, and every other fact in
that document stands. The AC01 is the only converter, the resident ISR moves one
sample per interrupt, there is no second sample path, and no resampling: the
codec is simply retuned before each modulation runs.

Not established here: what the four ASIC words in each row do. Ports
`0x68`/`0x69` and `0x6b`/`0x6c` take two pairs per row, and word 2 is the
`360 x baud / Fs` figure above, which looks like a timing-recovery or decimator
increment. Words 0, 1 and 3 (`000f..000b`, `0002/1112/0c12/0f12/0202/0808`,
`0901/0926/0911`) are not decoded.
