# The codec has three sample rates, and V.34's symbol rate picks them

`codec-rate-312.md` closes on a contradiction: the dial path runs at 7200 Hz,
the AC01's divider registers are written once at reset and never again, and the
unit nonetheless advertises modulations that 7200 Hz sampling cannot carry. The
second of those is false. There is a runtime rate change, it is table-driven,
and the table is indexed by V.34's symbol rate.

| index | V.34 symbol rate | codec word | B | sample rate |
|---:|---|---|---:|---|
| 0 | 2400 | `0214` | 20 | **7200 Hz** |
| 1 | 2743 | `0213` | 19 | **7578.95 Hz** |
| 2 | 2800 | `0213` | 19 | 7578.95 Hz |
| 3 | 3000 | `0213` | 19 | 7578.95 Hz |
| 4 | 3200 | `0212` | 18 | **8000 Hz** |
| 5 | 3429 | `0212` | 18 | 8000 Hz |

7200 Hz is the 2400-baud rate - V.32bis and below, and the dial, call-progress
and handshake tones the resident bank generates by hand. It was never the
board's one rate.

Program addresses are `IDSDL302.ROM` unless stated. The stock 7.3.14 image
matches it; the ID_SDL 4.03 / DSP 3.1.2 build sits `0x11` lower in this region,
so its selector is at `8140` and its table at `815a`.

## The mechanism, and why earlier scans missed it

The search behind "the dividers are written once at reset" was for
`lacc #0nnn ; call <sender>`. Every runtime write is made by a routine that
**inlines** the sender's handshake instead of calling it, and in the 3.1.2 build
the inlined copy sits immediately after the sender it duplicates:

```text
8149  samm @6c        ; the control-word sender: park the word,
814a  lacl #03        ; raise the secondary-frame request,
814b  samm @6b        ; and idle until the ISR has sent it
814c  idle
814d  lamm @6b
814e  bcnd 814c, neq
8150  ret

8151  sacl @7d        ; the rate selector: acc = index
8152  add  @7d, 2     ; index * 5
8153  add  #816b      ; + table base
8155  tblr @7d
8156  add  #01
8157  tblr @7e
8158  out  @7d, 0068  ; row words 0,1 -> ASIC ports 0x68/0x69
815a  out  @7e, 0069
815c  add  #01
815d  tblr @7d
815e  add  #01
815f  tblr @7e
8160  out  @7d, 006b  ; row words 2,3 -> ASIC ports 0x6b/0x6c
8162  out  @7e, 006c
8164  add  #01
8165  tblr @7f        ; row word 4: the codec control word
8166  lacl @7f
8167  samm @6c        ; ...sent through an inlined copy of 8149
8168  lacl #03
8169  samm @6b
816a  ret
```

A scan for calls to the sender returns the six reset writes plus one register-4
write, which is what `codec-rate-312.md` reports. It is true, and it is not the
whole story.

## The table

Six rows of five words at `816b`:

```text
row0: 000f 0002 0078 0901 0214
row1: 000d 1112 0082 0926 0213
row2: 000d 0c12 0085 0901 0213
row3: 000c 0f12 008e 0911 0213
row4: 000c 0202 0090 0901 0212
row5: 000b 0808 009a 0926 0212
```

Byte-identical across all three 20.16 MHz images - stock 7.3.14, ID_SDL 4.03 and
`IDSDL302.ROM`. Absent from `main211.xmf` and from the 2.x builds, which are
other boards.

## Why the index is V.34's symbol rate

**The same index drives three tables.** `@5b` on data page 7 selects the codec
divider row, the V.34 carrier and the V.34 symbol rate:

```text
84d9: lacl @5b ; add #860b ; tblr *+   ; carriers 1800 1829 1867 1875 1920 1959
852c: lacl @5b ; add #8611 ; tblr *+   ; bauds   2400 2743 2800 3000 3200 3429
9730: lacl @5b ; call 8151             ; the codec divider table
```

**Word 2 of each row is `360 x baud / Fs`.** Nothing is fitted here: the sample
rates come from the codec words, the symbol rates from V.34, and `360` is the
only free constant.

| index | baud | `360 x baud / Fs` | word 2 |
|---:|---|---:|---:|
| 0 | 2400 | 120.00 | `0078` = 120 |
| 1 | 2742.86 | 130.29 | `0082` = 130 |
| 2 | 2800 | 132.99 | `0085` = 133 |
| 3 | 3000 | 142.50 | `008e` = 142 |
| 4 | 3200 | 144.00 | `0090` = 144 |
| 5 | 3428.57 | 154.29 | `009a` = 154 |

All six agree to rounding. Read backwards it recovers the rate: row 2 gives
`360 x 2800 / 133 = 7578.9`, row 4 exactly 8000, row 0 exactly 7200.

**Each row clears its own spectrum by a uniform margin.** Pairing each carrier
with its symbol rate:

| index | carrier | baud | upper edge | min Fs | given | margin |
|---:|---:|---:|---:|---:|---:|---:|
| 0 | 1800 | 2400 | 3000.0 | 6000 | 7200.00 | 1.200 |
| 1 | 1829 | 2743 | 3200.5 | 6401 | 7578.95 | 1.184 |
| 2 | 1867 | 2800 | 3267.0 | 6534 | 7578.95 | 1.160 |
| 3 | 1875 | 3000 | 3375.0 | 6750 | 7578.95 | 1.123 |
| 4 | 1920 | 3200 | 3520.0 | 7040 | 8000.00 | 1.136 |
| 5 | 1959 | 3429 | 3673.5 | 7347 | 8000.00 | 1.089 |

1.09 to 1.20 throughout. The ladder is V.34's own bandwidth requirement and
nothing else - so `B = 18` is what 3200 and 3429 baud need, and 8000 Hz falls
out of the 2.88 MHz master clock rather than being provisioned for V.PCM.

## The arithmetic, and the absolute scale

Under `(register << 8) | data` all three words write **register 2** and nothing
else; register 1 keeps the `A = 10` it is given at reset. With any
`Fs = MCLK / (2 x A x B)` form the rates are in the ratio `1/20 : 1/19 : 1/18`,
so `Fs = 144000 / B` once the base is pinned, and `MCLK = 2.88 MHz`, which is
`40.32 MHz / 14` off the board's oscillator.

The base is pinned by what the resident bank generates at index 0, and by more
than one thing:

* the DTMF table at `86fd` - all sixteen pairs within 0.05% at 7200 Hz;
* `4aab` -> 2100.000 Hz, the answer tone;
* `4800` -> 2025.0 Hz, Bell 103 answer space;
* `3aab` -> 1650.0 Hz, V.21 channel 2 mark.

None of those is a standard frequency at 9600 Hz. `1555` is `Fs / 12` exactly
and so discriminates nothing.

The reset sequence writes `B = 20`, so the board comes up at 7200 Hz, and the
resident returns to it explicitly (`lacl #00 ; call 8151` at `a350` and `a356`,
`splk @5b, #0000` at `9499`).

## Two variables share the offset `@5b`

`@5b` is data-page relative and this firmware keeps **two** variables there.
Every claim in this document has been checked for its `ldp`.

| page | address | what it is |
|---:|---|---|
| DP 7 | `0x3db` | **the rate index** - carrier table, symbol-rate table, codec divider table, and our own capability array |
| DP 6 | `0x35b` | a second symbol-rate index, used for the outgoing INFO frame |

**DP 7** is written at `9299` (forced to 4), `9499` (0), `94bc` and `96cf`, and
by overlay 6 at `9d15` (5). It is read at `84d9`, `852c`, `9730`, `9735`, by
overlay 8 at `dc4a`, and by a further six-entry, two-word-per-entry table at
program `967a`.

**DP 6** is written by the argmax at `91f6`, at `90ba` (4) and by overlay 7 at
`b155` and `b4c7` (1). It is what the outgoing frame declares at `9211`.

## Where each index comes from

* **DP 7** is a 3-bit field read from the **received** frame at bit 12 and
  clamped to 5:

  ```text
  96c7: lacl #0c ; call 8785 ; and #0007 ; lacl #05 ; crlt ; sacl @5b
  ```

* **DP 6** is **our own** choice, the argmax at `91e1` over both directions'
  probe results.

So the codec follows a symbol rate the far end sent us, while our own selection
lives in the other variable.

## The INFO parser and builder

The frame carries a **six-entry block, one 9-bit field per V.34 symbol rate**.

**Builder** at `91a5`, into the outgoing buffer `ff1a`:

```text
91a5: lar ar0, #ff1a
91a7: calld 8774 ; splk @7f, #004c    ; one field at bit 76
91ab: splk @7f, #003f                 ; then start at bit 63
91ad: lar ar2, #ff20                  ; our array A, six entries
91af: lar ar3, #ff28                  ; our array B, six entries
91b1: lar ar4, #05                    ; six iterations
91b3: calld 8774 ; lacl *+, ar3 ; add *+, ar1, 5
                                      ; value = A[i] + (B[i] << 5)
91b7: lacl @7f ; sub #09 ; sacl @7f   ; step down 9 bits
91bb: banz 91b2, *-, ar1
```

**Parser** at `91c2`, out of the received buffer `ff08`:

```text
91c8: lar ar0, #ff08
91ca: lar ar2, #ff30                  ; their array, six entries
91cd: lacl #3a                        ; start at bit 58
91cf: call 8785 ; and #000f           ; read, keep 4 bits
91d4: sacl *+, ar3
91d5: lacl @7d ; sub #09              ; step down 9 bits
```

`8785` takes the bit offset in the accumulator and returns a raw window - the
caller sets the width by masking. `8774` takes the value in the accumulator and
the offset in `@7f`, set in the delayed call's slot.

### It is INFO1's per-symbol-rate probe result

The 9 bits split 5 + 4. The builder packs `A[i] + (B[i] << 5)`; the parser
starts 5 bits lower (58 against 63), steps by the same 9, and masks 4 bits. So
each entry is a 5-bit field followed by a 4-bit field, and only the 4-bit one is
read back.

That is the shape of V.34's INFO1 block: per symbol rate, a pre-emphasis
selection plus a flag, and a **projected maximum data rate** measured from the
line probe. It is why selection is `min(ours, theirs)` then argmax - the rate
whose worse direction is best, off probe results, as V.34 Phase 2 prescribes:

```text
91ed: lacl *-, ar2 ; sacb      ; theirs, from ff35 descending
91ef: lacl *-, ar3 ; crlt      ; min(ours, theirs)
91f1: lacl @7d     ; crgt      ; running best
91f4: xc 2, nc ; lamm @13 ; sacl @5b
```

### A rate is withdrawn by zeroing its entry

A projected data rate of zero is a symbol rate that carries nothing, so no
separate flag is needed. Two routines act on that:

* `92d2` normalises an array - maximum over the six, form `0x0f - max`, and add
  it back **only where the entry is non-zero** (`xc 1, neq ; add @7c`). Zeros
  stay zero.
* `9615` finds the argmax and zeroes everything past it (`rpt @7e ; sach *-`).

### The frame layout

Widths come from the caller's mask, so the layout reads off the call sites:

| buffer | bit offset | width | what |
|---|---:|---:|---|
| `ff08` received | 12 | 3 | symbol-rate index -> the DP 7 index |
| `ff08` | 58, 49, 40, 31, 22, 13 | 4 | far end's projected rate per symbol rate -> `ff30..ff35` |
| `ff08` | 70 | 7 | `9766` |
| `ff08` | 9 | 10 | `9703` |
| `ff1a` outgoing | 63, 54, 45, 36, 27, 18 | 9 | our per-rate block, `A + (B << 5)` |
| `ff1a` | 76 | - | `91a7` |
| `ff1a` | 24, 19, 15, 9 | - | the builder at `9204`: `*`, `@7c`, `9 * @5b`, `@70` |
| `ff1a` | 24, 15 | - | the builder at `9293`: `@3e`, `@5b + 0x30` |

Two outgoing builders write bit 15 with different encodings - `9 * @5b` at
`9211`, `@5b + 0x30` at `929e` - so these are two different frame formats.
`9293` is the one that forces the index first:

```text
9299: splk @5b, #0004         ; index 4 = 3200 baud, DP 7
929b: lacl @5b ; add #0030
929e: bd   8774  ; splk @7f, #000f
```

so on that path the modem *declares* 3200 rather than accepting a negotiated
rate.

## What the ladder implies for V.90

V.90 constrains the analogue modem: 3200 mandatory, 3000 and 3429 optional,
2400/2743/2800 prohibited.

| index | baud | V.90 status | codec rate | usable for V.PCM? |
|---:|---|---|---|---|
| 0 | 2400 | prohibited | 7200 | - |
| 1 | 2743 | prohibited | 7578.95 | - |
| 2 | 2800 | prohibited | 7578.95 | - |
| 3 | 3000 | **optional** | 7578.95 | **no** |
| 4 | 3200 | **mandatory** | 8000 | yes |
| 5 | 3429 | optional | 8000 | yes |

The prohibited rates are exactly the sub-8000 rows bar one, and that one is the
finding: **index 3 is permitted by V.90 and unusable on this hardware**, because
3000 baud puts the codec at 7578.95 Hz, which cannot align to a downstream 8 kHz
codeword stream. So this implementation can offer only `{3200, 3429}` and must
decline the optional 3000. That is a prediction about the product, and it falls
out of the divider table alone.

## Which overlay is which

Overlay 8 is the **V.90 layer**, not the whole PCM datapump. The Ja descriptor -
V.90's digital impairment learning, the `SP`/`TP` pair from
[vpcm-datapump.md](vpcm-datapump.md) - is at program `e599` in overlay 8 and in
**no other overlay**.

Its partner is overlay 6:

| | into overlay-6-only space (`9d00..b000`) | into overlay-7-only space (`c9f6..cd4b`) |
|---|---:|---:|
| overlay 8's branch targets | 8 | 0 |

| | into overlay 8's span |
|---|---:|
| overlay 6 | 29 |
| overlay 7 | 5 |

Overlays 6 and 7 overlap and are alternatives; overlay 8 overlaps neither and
can load beside either. The traffic says it runs beside 6. That fits **overlay 6
as the PCM datapump core and overlay 8 as the V.90 layer on top of it** -
overlay 6 sets the rate and carries no descriptor, overlay 8 carries the
descriptor and sets no rate. Overlay 8's own first act, at `dc24`, is a codec
write, and it is register 4 - `040a` or `0406` selected on a status bit, with
`@7b << 2` added conditionally, through a third inlined copy of the handshake.
Gain, not rate.

Caveat on the traffic counts: both windows are also resident space when the
overlay in question is not loaded, so a target there could be a resident
routine. The argument is the asymmetry, not the totals.

## The V.PCM rate

Overlay 8 never calls the rate selector and reads the rate index once, so it
cannot set its own rate. What surrounds it does:

* overlay 6 forces index 5 and programs the codec as its eighth instruction -
  `9d14: lacl #05 ; sacl @5b ; call 8151`;
* `9299` forces index 4 on DP 7 and declares it outward;
* the resident passes a literal 4 to the rate routine at `8e14`, `a361`,
  `a3b3`, `a3fc` and `a437`, in the accumulator, so no data page is involved.

All of those are `B = 18`. **The V.PCM sample rate on this firmware is 8000 Hz.**

## What is not established

* **How one `Fs` serves two directions.** V.34 negotiates transmit and receive
  symbol rates separately. Two indices exist and their sources are known - DP 7
  from the received frame, DP 6 from our own argmax - but which is transmit and
  which receive, and how they are reconciled, is open. `971c` takes the `max` of
  two 3-bit fields drawn from the call-mode and answer-mode buffers, which is
  the obvious reconciliation, but its result goes to `@7f`/`@7c` and has no
  shown path to either index.
* **Which rates this modem actually offers.** The advertised values live in data
  RAM at `ff20..ff25` and `ff28..ff2d`, computed at run time from the probe, so
  "3200 and 3429 enabled, the rest zeroed" is not something the ROM states. The
  mechanism for exactly that is present. Confirming it means finding what writes
  `ff20..ff25`, or watching those six words on hardware during Phase 2.
* **The four ASIC words in each table row.** Ports `0x68`/`0x69` and
  `0x6b`/`0x6c` take two pairs per row. Word 2 is the `360 x baud / Fs` figure,
  which looks like a timing-recovery or decimator increment. Words 0, 1 and 3
  (`000f..000b`, `0002/1112/0c12/0f12/0202/0808`, `0901/0926/0911`) are not
  decoded.
* **Whether overlay 6 is specifically x2** rather than a shared PCM core.
  Nothing here separates an x2 core from a V.90 one, the same limit
  [vpcm-datapump.md](vpcm-datapump.md) records for the descriptor.

## Corrections to earlier versions of this document

Kept as the record, since each was asserted here before being withdrawn.

* **"The index is a reduction over the transmit and receive symbol rates."**
  Argued from the argmax at `91e1`. That loop writes DP 6; the codec is
  programmed from DP 7. The loop *is* a genuine two-direction negotiation - that
  part stands - but the conclusion about the codec index does not.
* **"Overlay 7 selects index 1, 7578.95 Hz."** `b155` and `b4c7` write DP 6.
  Overlay 7 is not shown to select any rate.
* **"The path into overlay 8 forces the index at `90ba`."** `90ba` writes DP 6.
  The branch from `90ce` into overlay 8 is real; the rate forcing attributed to
  it is not.
* **"`B = 18` landing exactly on 8000 Hz shows the ladder was provisioned for
  V.PCM."** Backwards. The per-row Nyquist margins are uniform, so `B = 18` is
  what 3200 and 3429 baud need on their own, and 8000 Hz is a property of the
  2.88 MHz master clock.
