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

## The V.PCM rate: 8000 Hz, forced at both entries

Overlay 8 reads `@5b` zero times and calls the rate selector zero times, so on
its own it cannot say what rate it runs at. The entry paths can, and both of
them force 8000 Hz before the PCM code starts.

**Overlay 6 sets index 5 as its eighth instruction.** Its entry at `9d00` is
plainly an entry - state init, then:

```text
9d10: splk @4d, #adfe
9d12: opl  @1f, #0020
9d14: lacl #05
9d15: sacl @5b          ; index 5 = 3429 baud
9d16: call 8151         ; ...and program the codec: B = 18, 8000 Hz
```

**The path into overlay 8 sets index 4 and branches straight in.** At `90ba` the
resident forces the index, builds its state, and tail-branches to `dc24`, which
is `0x24` words into overlay 8's image:

```text
90ba: splk @5b, #0004   ; index 4 = 3200 baud -> B = 18, 8000 Hz
...
90ca: splk @4d, #ae11
90cc: call 9123
90ce: b    dc24         ; into overlay 8
```

`9299` does the same in the other direction: it forces `@5b = 4` and then writes
`@5b + 0x30` into the outgoing frame through the bit-field writer at `8774`, so
the modem *declares* symbol rate 3200 rather than accepting a negotiated one.

So V.PCM does not inherit a rate by luck. Every path that reaches it pins the
index to 4 or 5 - the only two rows that give 8000 Hz - and one of them pins the
negotiated symbol rate to match. **The V.PCM sample rate on this firmware is
8000 Hz.**

Overlay 8's own first act at `dc24` is a codec write, and it is register 4
again - `040a` or `0406`, selected on a status bit, with `@7b << 2` added
conditionally, through a third inlined copy of the secondary-frame handshake.
Gain, not rate.

## Which overlay is which

Overlay 8 is the **V.90 layer**, not the whole PCM datapump. The Ja descriptor -
V.90's digital impairment learning, the `SP`/`TP` pair from
[vpcm-datapump.md](vpcm-datapump.md) - is at program `e599` in overlay 8 and
appears in **no other overlay**.

Its partner is overlay 6, not overlay 7:

| | into overlay-6-only space (`9d00..b000`) | into overlay-7-only space (`c9f6..cd4b`) |
|---|---:|---:|
| overlay 8's branch targets | 8 | 0 |

| | into overlay 8's span |
|---|---:|
| overlay 6 | 29 |
| overlay 7 | 5 |

Overlays 6 and 7 overlap and are alternatives; overlay 8 overlaps neither and
can load beside either. The traffic says it runs beside 6. That fits the reading
that **overlay 6 is the PCM datapump core and overlay 8 the V.90 layer on top of
it** - overlay 6 sets the 8000 Hz rate and carries no descriptor, overlay 8
carries the descriptor and no rate.

Not established: that overlay 6 is specifically *x2* rather than a shared PCM
core. Nothing here separates an x2 core from a V.90 one, which is the same limit
[vpcm-datapump.md](vpcm-datapump.md) records for the descriptor itself.

Caveat on the traffic counts: both windows are also resident space when the
overlay in question is not loaded, so a target there could be a resident
routine. The argument is the asymmetry - if these were resident calls there is
no reason for 8 in one window and 0 in the other.

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
