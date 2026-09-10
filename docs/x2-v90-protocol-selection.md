# x2 versus V.90 protocol selection

This is deliberately separate from `codec-sample-rates.md`.  That document
describes the six-row V.34 rate machinery; it must not be used to identify the
V.90 protocol selector.  Addresses below are for
`artifacts/courier-board-21210-capture-403/courier-board.rom`; the bundled
update ROMs retain x2/V.90 result vocabulary but relocate their executable
code, so an absolute-address match is not a cross-version test.

> **Superseded.**  The section below reads `splk @7f, #0025` as writing
> INFO1a *bits* 37:39.  It does not: the firmware's offsets run opposite to
> V.34's bit numbering, so offset 37 is bits 12:14.  The V.90 `37:39 = 6`
> selector is *read* at `8fbc`, at offset 12.  See "Against the ITU
> Recommendations" at the end of this document; the section is kept here
> because the surrounding reasoning about `9267` still holds.

## Confirmed V.90 INFO1a writer (superseded - see the ITU section)

In DSP 3.1.2, the code at program `9185` calls `9267`, then writes its returned
value into the outgoing INFO buffer at bit offset `0x25`:

```text
9185  call   9267
9187  lar    ar0, #ff1a
9189  calld  8769             ; bit-field writer
918b  splk   @7f, #0025       ; INFO1a bit offset 37
```

`8769` inserts its accumulator argument at the bit offset in `@7f`; `ff1a` is
the outgoing INFO buffer.  Therefore this is the writer for **INFO1a bits
37:39**, not merely a nearby V.34 symbol-rate calculation.  It is also the
only `splk @7f,#0025` site in the downloaded DSP program, so there is no
second, x2-specific writer for that field hidden elsewhere in this image.

Under Table 10/V.90, `37:39 = 6` is the V.90 request: it selects the 8000
symbol/s digital-modem direction.  The value is computed by `9267`, which
first checks call-state flags and otherwise derives a three-bit value from
live DSP state (`ff26`, `0345`, and `0066`).  Tracing the producer of that
state is the next step needed to prove the exact condition which yields 6.

## The similarly shaped V.34 path is distinct

The parser at `9695` reads `ff1a` at bit 76 and received `ff08` at bit 37;
the nearby code at `96a3` reads **received bit 12**, masks it to three bits,
and clamps the resulting value to 5:

```text
96a3  lacl   #0c
96a4  call   877a             ; extract received `ff08` field
96a6  and    #0007
96a9  lacl   #05
96aa  crlt                     ; min(value, 5)
```

That makes it a V.34-form `INFO1a` rate-index consumer (values 0..5), not the
V.90 Table-10 `37:39 = 6` selector.  Treating those as the same field was
incorrect.

## x2 versus V.90 differences already established

| Layer | x2 | V.90 |
|---|---|---|
| Local S58 gate | bit `0x01` | bit `0x20` |
| Supervisor DSP setup | sends tag `0x70` | no scheme-specific tag here |
| DSP parameter cell | tag `0x70` dispatches to `8d29` and stores `fff1` | no corresponding direct write |
| Wire-level selector | not recovered | INFO1a `37:39 = 6` |
| PCM result ladder | 16 rate entries | 28 rate entries |

An exhaustive scan of direct `test byte [S58],mask` instructions yields only
seven sites: `0x01` at `8ea1`/`8f39` (x2 gate/setup), `0x20` at `8e60`/`8f06`
(V.90 gate/setup), `0x04` at `8f47` and `0x10` at `8f56` (the x2 capability
edits), and `0x02` at `8dba` (BLER monitoring). Thus no additional direct S58
bit selects a hidden x2 or V.90 DSP image in this firmware.

## What x2 puts in the DSP that V.90 does not

The x2 setup is more than its S58 eligibility bit.  At supervisor `8f43`, it
starts with a capability word returned by `8a1f`, applies these edits, and
sends the result in host command `70`:

| Edit | Condition |
|---|---|
| clear capability bit 9 | always, then set it again |
| set capability bit 9 | S58 bit `0x04` is set |
| set capability bit 10 | initially |
| clear capability bit 10 | S58 bit `0x10` is set |
| clear bits 11, 12, 14, and 15 | always |

Equivalently, the x2 routine clears `0xd800` unconditionally, forces bit 10
unless S58 `0x10` suppresses it, and takes bit 9 from S58 `0x04`.  The labels
for those two S58 option bits have not been recovered from the firmware help,
but the bit-level effect is direct.  The DSP tag-`70` handler stores the word
in `fff1` after masking it with `0x3fff`, sets `fff4 |= 0x8000`, and sets
`fff7 |= 0x0001`.  Those latter two writes are part of the x2-only tag-`70`
handler at `8d29..8d39`; they do not establish that any individual downstream
overlay test is an x2 test.

The analogous V.90 branch at supervisor `8edb` does the shared reset but then
returns without emitting a scheme-specific host tag.  Its protocol declaration
is instead visible at the INFO1a writer described above.

### Where the x2 base capability word comes from

The `call 8a1f` immediately before the x2 edits is a banked call, not an
unknown arithmetic stub. It enters `C800:0060` (flash `48060`), whose jump
vector reaches `49db4`. That routine builds `BX` from:

* S54 (`4c4`): its enabled symbol-rate bits are inverted and mapped through
  the five-byte table at banked `1e41`. S54's labels are 2400, 2743, 2800,
  3000, 3200, and 3429 symbols/s plus the V.8 flags.
* S56 (`4c6`): nonlinear coding, TX-level deviation, preemphasis, precoding,
  shaping, V.34+/V.34, and V.FC options contribute/clear capability bits.
* channel capability byte `73d`: it removes low-byte choices or enables bits
  9, 10, and 12 according to the detected channel.

Thus the x2 tag-`70` payload is a **generic modem/channel capability mask with
x2-specific constraints applied**, rather than a bare x2 mode number. V.90
does not send this word at all in this image.

## Observable result and diagnostic differences

These distinctions are in the supervisor/result-code layer, so they are not
part of the DSP negotiation decision, but they confirm the two paths survive
through reporting rather than merely sharing a generic "PCM" result.

* x2 has 16 downstream result-rate entries, from 33333 through 57333 plus
  64000.  V.90 has 28, from 28000 through 62666 plus 64000.  V.90 fills the
  1333 1/3-bit/s steps that x2 omits below and within its range.
* The x2 result-code block begins at supervisor result code 182 and has four
  strings per rate (`plain`, `/ARQ`, `/x2`, `/ARQ/x2`).  The V.90 block begins
  at 258.  At overlapping rates it needs only the two V.90-suffixed strings,
  because the plain and `/ARQ` strings are shared with the x2 block.
* The capture has distinct formatter entry points headed `x2 Status` at flash
  `0x1bff0` and `V.90 Status` at `0x1c0a0`.  The latter decodes bitfields from
  its V.90 status word; the former reads its separate x2 link state.  The
  nearby x2 failure enum includes "Remote modem is not x2", "Remote modem is
  not a Server", "Multiple CODECs in channel", "Incompatible versions", and
  the local/remote 3200-baud restrictions.  Those are proprietary x2
  negotiation outcomes, not V.90 INFO1a values.

## Things that are deliberately *not* x2-versus-V.90 changes

The shared rate-mask command `71 -> fff3`, overlay-8 receiver-family fork,
and `&X` clock-source commands do vary DSP behavior, but static tracing shows
they are shared PCM/timing machinery.  In particular, `&X` controls sample
clocking and bit 8 of `@1f`; the overlay fork reads bit 7.  Neither identifies
x2 or V.90, and neither belongs in the scheme-selection model.

## The `fff1` message selector is separate state

At resident `8e4a`, the DSP tests bit 6 of `@1f`: set selects `fff1`, clear
selects `fff2`, and the chosen 16-bit word is packed into `ff18` at bit offset
16. This is not the overlay-8 family fork (which tests bit 7), and **tag 70
does not set bit 6**. Its complete handler is only:

```text
8d29  smmr  @7a, #fff1       ; host argument -> fff1
8d2b  lar   ar1, #fff1
8d2d  apl   *, #3fff
8d31  lar   ar1, #fff4
8d33  splk  *, #8000
```

The host command that replaces `@1f` is tag `1d`, whose handler at `9b94`
calculates `(@7a << 2) + @7a` before storing the low word in `@1f`. The
supervisor sends it at `bcb5`, with `BX = zero_extend([4ab])`; therefore the
selector receives **five times** the transferred configuration value, not the
raw byte. `4ab` is S29 (`48e + 29`), whereas x2 and V.90 are S58 bits. S29 is
labelled **"V21 Handshake"** by the firmware's own help and acts as a V.21
fallback-timing control. Therefore it establishes only a shared sequencing
dependency for the `fff1`/`fff2` selection; it does **not** establish the
on-wire frame, or prove that a particular bit is the remote-x2/server
discriminator.

The static image establishes the local half (`x2 setup -> fff1 ->
ff18[16..31]`) and proves that it is not V.90 `INFO1a[37:39]`. It does not yet
establish the reciprocal receive buffer or the individual proprietary bit
assignments. Those require a trace of a successful x2 call or an x2 protocol
specification.

The code-side selection audit is complete for this image: the S58 gates,
x2-only capability construction/transfer, V.90 INFO1a writer, result ladders,
and status paths are all distinct and accounted for above. What remains
unparsed is the **external meaning and framing** of the x2-conditioned
capability payload after the DSP packs it into `ff18`. It is not a second
`INFO1a[37:39]` selector. Resolving its named on-wire fields would need a
protocol trace or an x2 specification, rather than another supervisor
S-register branch.

## x2 status: the DSP sends a bitmap, not the diagnostic string number

The DSP's outbound queue routine uses tag `0x75` for x2 status. Its report
sequence queues `0x8075` and then the current `fff7` word. It occurs in
overlay 6 at `a5ab`, and in overlay 8 at `e201` and `e29e`.

`fff7` is a condition bitmap. Its writers OR the ten masks `0001`, `0002`,
`0004`, `0008`, `0010`, `0020`, `0040`, `0080`, `0100`, and `0200`; tag `70`
initializes `0001`. It is therefore not the host's compact diagnostic enum.
The adjacent host strings (remote-not-x2, remote-not-server, incompatible
versions, and so on) are selected by a later host-side bitmap decoder, which
the next section recovers.

## How the x2 diagnostic enum is built

It is not an enum the DSP sends. The host builds it from the condition
bitmap, one string per bit, and the ten bits are exactly the ten `fff7`
masks.

### The host's copy of the bitmap

The store is explicit, and it names the tag:

```text
4a9cb  3c 75            cmp  al, 75
4a9cd  75 0b            jne  4a9da
4a9cf  50               push ax
4a9d0  e4 5e            in   al, 5e
4a9d2  8a e0            mov  ah, al
4a9d4  e4 5c            in   al, 5c
4a9d6  a3 1d 0a         mov  [0a1d], ax
```

That is in the same dispatcher that handles tags `34` and `20`. The DSP's
report queues `8075` and then `fff7` unaltered (`a5af`, `e205`, `e2a2` all
`lar ar1,#fff7 / lacc * / call 83b1`), so `0a1d` is `fff7` verbatim, not a
derived code. Firmware 2.3.31 keeps the same word at `1ca7`.

Do not confuse it with `0a23`, which a different receive stub at `13c42`
fills and which the `x2 Status` line formats; 2.3.31's equivalent is `1cb4`.
Those are the modulation/version fields, not the condition bitmap.

### The image names all ten bits itself

The capture ROM contains a second, *un*patched decoder for the same word, in
the `V90 Status:` report at flash `4a03e`. It walks the bitmap one bit at a
time and prints a line per set bit:

```text
4a04c  cmp  byte [0238], 0
4a051  jne  4a064
4a053  call print "Is absent \r"
4a064  mov  cx, 000a          ; ten bits
4a067  mov  dx, [0a1d]
4a06b  xor  bx, bx
4a06d  ror  dx, 1             ; CF = next bit, from bit 0 upwards
4a06f  jnc  4a07c
4a071  mov  si, cs:[bx+2085]  ; table of ten near pointers
4a076  call print
4a079  call newline
4a07c  inc  bx / inc bx
4a07e  loop 4a06d
```

`ror` shifts bit 0 into the carry first and `bx` advances by two every
iteration whether or not the bit was set, so entry *n* of the table is bit
*n*, with no room for interpretation. Resolved against segment base `48000`:

| bit | pointer | file | string |
|---:|---|---|---|
| 0 | `2099` | `4a099` | x2 enabled on local modem |
| 1 | `20b3` | `4a0b3` | V.90 enabled on local modem |
| 2 | `20cf` | `4a0cf` | V.8 negotiation completed |
| 3 | `20e9` | `4a0e9` | V.90 Server/client pair established |
| 4 | `210d` | `4a10d` | Remote modem supports x2 |
| 5 | `2126` | `4a126` | Channel supports x2/V.90 |
| 6 | `213f` | `4a13f` | High frequency rolloff is normal |
| 7 | `2160` | `4a160` | High frequency rolloff is marginal |
| 8 | `2183` | `4a183` | Retrained before x2/V.90 connection |
| 9 | `21a7` | `4a1a7` | Remote modem is an x2 server |

Bit 0 being "x2 enabled on local modem" is exactly right for a bit the x2
setup command sets unconditionally, and firmware 2.3.31's list is the same
one with bit 0 dropped. This is the bit dictionary; everything below is read
against it.

### The string table and its consumer

Flash `1c21d` holds nine near pointers, resolved against segment base
`0x16fc0`:

| index | pointer | file | string |
|---|---|---|---|
| 0 | `526f` | `1c22f` | Unspecified impairment |
| 1 | `5286` | `1c246` | x2 disabled on local modem |
| 2 | `52a1` | `1c261` | 3200 baud disabled on local modem |
| 3 | `52c3` | `1c283` | Remote modem is not x2 |
| 4 | `52da` | `1c29a` | Multiple CODECs in channel |
| 5 | `52f5` | `1c2b5` | Remote modem is not a Server |
| 6 | `5312` | `1c2d2` | Incompatible versions |
| 7 | `5328` | `1c2e8` | Channel will not support 3200 baud |
| 8 | `534b` | `1c30b` | Channel is x2-capable but feature not installed |

The consumer is a plain indexed fetch and print:

```text
522f  a1 1d 0a         mov  ax, [0a1d]
5232  90 90 90         (three bytes replaced by NOPs)
5235  25 ff 02         and  ax, 02ff
5238  9a a1 9d 00 80   lcall 8000:9da1     ; four-digit hex printer
523d  eb 15            jmp  5254           ; ...and skip the string
523f  90 90 90         (three bytes replaced by NOPs)
5242  75 03            jne  5247
5244  b8 08 00         mov  ax, 8
5247  d1 e0            shl  ax, 1
5249  05 5d 52         add  ax, 525d       ; the table above
524c  8b f0            mov  si, ax
524e  2e 8b 34         mov  si, cs:[si]
5251  e8 4d e4         call 36a1            ; print string at si
```

What survives says this much: the input is the condition bitmap, the mask
`02ff` keeps bits `0..7` and bit `9` and drops bit `8` alone, index `8` is
the answer when whatever the removed code scanned came up empty, and the
result is one string out of nine. The ten bytes at `5238..5241` and the three
at `5232` that computed the index are gone - this build calls the four-hex-
digit printer instead and jumps over the lookup entirely.

**The index is not the bit number.** An earlier revision of this document
inferred that from the nine-strings-for-nine-bits fit; the ten-entry table
above refutes it. Bit 0 is "x2 enabled on local modem", whose failure is
entry **1**, "x2 disabled on local modem"; bit 4 is "Remote modem supports
x2", whose failure is entry **3**. No single shift reconciles the two lists.

### The arithmetic, from the unpatched builds

`IDSDL302.ROM` and the stock capture `courier-board-21210-capture-01` are
byte-identical over this routine, and neither has been overwritten. The whole
of it:

```text
50bb  80 3e 3f 03 00   cmp   byte [033f], 0
50c0  74 27            je    50e9
50c2  eb 25            jmp   50e9            ; unconditional - see below
50c4  a1 2f 0b         mov   ax, [0b2f]
50c7  c1 e8 08         shr   ax, 8
50ca  25 07 00         and   ax, 7
50cd  3d 01 00         cmp   ax, 1
50d0  75 0a            jne   50dc
50d2  f6 06 9d 08 20   test  byte [089d], 20
50d7  75 03            jne   50dc
50d9  b8 08 00         mov   ax, 8
50dc  d1 e0            shl   ax, 1
50de  05 f2 50         add   ax, 50f2        ; the nine-pointer table
50e1  8b f0            mov   si, ax
50e3  2e 8b 34         mov   si, cs:[si]
50e6  e8 38 e4         call  print
50e9  e8 23 e4         call  print "\r\n"
```

So the index is

```text
index = ([0b2f] >> 8) & 7
if index == 1 and ([089d] & 0x20) == 0:
    index = 8
```

- **A three-bit code field, not a bit scan.** `[0b2f]` bits `10:8` are read as
  a number `0..7`, which indexes entries 0 through 7 directly.
- **Entry 8 is an override, not a ninth code.** "Channel is x2-capable but
  feature not installed" replaces entry 1 ("x2 disabled on local modem")
  when the option byte `089d` bit `20` is clear. That byte is the feature
  mask - the same bit gates the whole `x2 Status` display at `1c044`, and
  `08f7..091b` builds it from a source word bit by bit - so the override
  reads "x2 is off locally, and the reason is that the feature is not
  installed". There is no code value 8.
- **`[0b2f]` is the x2 status word, not the condition bitmap.** Its only
  writer is the mailbox receive stub at `13c50` (`13c46` in the 4.03 image,
  storing to `0a23`), and its other readers are the `x2 Status` line, which
  formats bits `15:14` and `7:6` of the same word.

### What that makes of the 4.03 image

The patched routine in the capture ROM is this routine, edit for edit - the
byte counts line up exactly:

| stock | 4.03 |
|---|---|
| `a1 2f 0b` `mov ax,[0b2f]` | `a1 1d 0a` `mov ax,[0a1d]` |
| `c1 e8 08` `shr ax,8` | `90 90 90` |
| `25 07 00` `and ax,7` | `25 ff 02` `and ax,02ff` |
| `3d 01 00` `cmp ax,1` + `75 0a` `jne` | `9a a1 9d 00 80` `lcall` hex printer |
| `f6 06 9d 08 20` `test [089d],20` | `eb 15` `jmp` + `90 90 90` |

So 4.03 is a debug build: it added the tag-`75` handler that captures raw
`fff7` into `0a1d`, then rewired this routine to hex-dump that word instead
of naming a code. The `and ax,02ff` is a **display mask for the debug dump**,
not part of the original logic - which retires the earlier argument that the
mask told us anything about the table.

### Both builds skip it anyway

`50c2 eb 25` jumps to the same place as the `je` two instructions above it,
so the string is never printed in either firmware. The routine prints its
heading and a newline and nothing between. The nine strings, the table and
the arithmetic are all intact and all unreachable - the compact enum is a
disabled feature, and the ten-line bit report at `4a03e` is what these builds
actually show.

### What still is not known

Which DSP code produces the three-bit field. Resident `90cd` packs
`fff7 & 7` into bits `10:8` of the only word the DSP sends under tag `6b`,
and also sets bit `14`, which the `x2 Status` line prints - the positions
match. But the nine strings do not read as a function of `fff7` bits `0..2`:
code 1 would be "bit 0 set alone", and bit 0 is "x2 enabled on local modem",
whose entry-1 string says the opposite. Either the field is not `fff7 & 7`
in this firmware, or the 4.03 bit names do not apply to the stock DSP.
Settling that needs the tag-`6b` routing traced through the host's stub
dispatcher, which this image has not yielded.

## Which DSP test sets each `fff7` bit

Every bit is set by exactly one `opl` site, and all ten are in the resident
bank. Scanning the four downloaded images for the immediate `fff7` separates
the address uses (`lar ar1,#fff7` followed by an `opl`/`lacc`) from the sites
where `fff7` is merely a mask constant (`apl @6f,#fff7` and friends, which
are unrelated). What remains is one writer per mask, four readers, and one
clear:

| bit | mask | writer | guard | tests |
|---:|---|---|---|---|
| 0 | `0001` | `8d37` | none | host tag `70` - the x2 setup command itself |
| 1 | `0002` | `d5a4` | `retc neq` at `d5a0` | `(@7a & 0x00ff) >> 4 == 2` |
| 2 | `0004` | `d571` | `retc ntc` at `d56e` | `@70` bit 2 (`bit 13`, a bit code), after `call d876` |
| 3 | `0008` | `d62c` | branches at `d613`..`d624` | field `0d` of `fea1` and of `fedd` both present, `fedd`'s bit 7 set (`bit 8`, a bit code), and `(value & 0x60) == 0x60` |
| 4 | `0010` | `d763` | `xc 2, gt` | a summed-difference measurement over the `02a4` buffer, scaled by `2d00`, is positive |
| 5 | `0020` | `9028` | `retc lt` at `9025` | the first nonzero entry scanning `ff2d` downwards is at least four words above `ff27` |
| 6 | `0040` | `9683` | `xc 2, lt` | `[da15] - [da18]` is below `1d3c` (below `1542` when `@63` is nonzero) |
| 7 | `0080` | `8dae` | branches at `8da2`/`8da8` | `@1f` bit 14 set **and** `fff4` bit 1 clear (bit codes 1 and 14) |
| 8 | `0100` | `968f` | `xc 2, lt` | the same measurement as bit 6, against a threshold `0e9e` lower |
| 9 | `0200` | `9052` | branches at `904a`/`904e` | `ff18` bit 5 set (`bit 10`, a bit code) **and** `[ff00] & 0x0c00` nonzero |

`fff7` is cleared once, at reset: `8074 lar ar1,#fff7 / 8076 sach *` in the
initialisation run that also clears `fff3`, `fff4` and `fff8`. Nothing clears
it again, so the bits are cumulative for the life of a call - which is what a
progress bitmap has to be for "the first condition not reached" to mean
anything.

The four readers are the report path and one internal use: overlay 6 `a5af`
and overlay 8 `e205`/`e2a2` load the word and queue it behind tag `0x75`
(this is the transfer the previous section describes), and resident `90cd`
folds `fff7`'s bits `0..2` into a different status word alongside `ff00`.

### Two observations that fall out of the addresses

**The overlays cannot reach these tests.** Overlay 6 occupies `9d00..ce32`,
overlay 7 `b000..cd4a` and overlay 8 `dc00..f94a`. Every one of the ten
writers is at `8d37..968f` or `d571..d763`, so none of them is in space any
overlay overwrites. The condition bitmap is built entirely by resident code
and merely *reported* by whichever overlay is loaded, which is why the same
three report sites appear in two different overlays.

**Bit 0's writer matches its name exactly.** Bit 0 is the only
unconditional one, set by the tag-`70` handler - the x2 setup command itself
- and the image's own name for it is "x2 enabled on local modem". That is the
one place where the DSP side and the string side confirm each other outright.

### One writer and its name do not line up

Bits 6 and 8 are set 12 words apart from the *same* value, against two
thresholds `0e9e` apart, at `9683` and `968f`, and the first `retc lt` makes
them mutually exclusive: below the first threshold sets bit 6, the band above
it sets bit 8. That is a two-grade measurement.

The names pair a two-grade measurement too - but at bits **6 and 7**: "High
frequency rolloff is normal" and "...is marginal". Bit 7's only writer is
`8dae`, whose guard is `@1f` bit 14 set and `fff4` bit 1 clear - a pair of
state flags, not a measurement - and bit 8's name is "Retrained before
x2/V.90 connection", which is not a threshold either.

The writer scan is exhaustive: sweeping every `opl *,#0040 / #0080 / #0100`
in all four images and resolving the `ar1` each one loads finds no second
writer for any of these bits. So one of two things is true - either the graded
measurement is not the rolloff the names describe, or the string table and
the bit assignments drifted apart in this build. This document does not
resolve it, and the pairing for bits 6, 7 and 8 should be treated as open.

### What this does and does not name

The bit-to-string pairing is the ten-entry table's, which is mechanical and
not in doubt. The tests are what the code does - a field comparison, a buffer
scan length, a scaled sum against a threshold. What is *not* established is
that those two descriptions agree: nothing here demonstrates that
`[da15] - [da18]` measures high-frequency rolloff, that the `ff2d` scan
counts CODECs, or that `(@7a & 0xff) >> 4 == 2` is a V.90-enabled test.
Confirming any of that needs a trace with known line conditions or the x2
specification. The claim is narrower and complete: which test sets which bit,
and what this firmware calls that bit.

## The bits do not reach the result code

`0a1d` has exactly three references in the whole 512 KiB image:

* `4a9d6` - the tag-`75` store that fills it,
* `4a067` - the ten-line `V90 Status:` report,
* `1c1ef` - the compact nine-string enum, which this build has patched out.

Nothing else reads it. The condition bitmap is a diagnostic terminus: it
feeds two printers and no decision. In particular it does not choose between
the x2 result block at supervisor result code 182 and the V.90 block at 258,
does not pick a rate within either ladder, and does not gate the `/x2` or
`/V90` suffix on a `CONNECT` string. Those come from the rate-and-scheme path
described earlier in this document - the S58 gates, the tag-`70` capability
transfer, and the PCM rate ladders - which never consults `fff7`.

So the answer to "which result code does a given bit produce" is: none. A
call that fails every x2 precondition and one that passes all of them reach
the result-code layer by the same route; the bitmap only explains, after the
fact, which precondition was missing. The two vocabularies are for two
different audiences - `ATI` diagnostics versus the `CONNECT` line - and this
firmware keeps them completely separate.

## Where the code comes from, and why 6 never appears

The stock DSP builds the field. In `IDSDL302.ROM` (and the identical stock
capture) the tag-`6b` word is assembled at resident `9106`:

```text
9106  bf80 806b      lacc  #806b          ; the tag
9108  bf09 fff6      lar   ar1, #fff6
910a  1880           lacc  *, 8
910b  bfb8 0007      and   #0700          ; fff6 bits 2:0 -> word bits 10:8
910d  907d           sacl  @7d
...
9117  bfce 0001      or    #4000
```

- the field the host reads as `([0b2f] >> 8) & 7` is **`fff6 & 7`**,
- `fff6`'s only writer anywhere in the four images is `bldd @7d, #fff6`
  (`9049`, `90d0`, `90fc`, `d77a`) - it is always a copy of `@7d`,
- and the 4.03 image reads `fff7` here instead. This paragraph is about the
  stock DSP, which is the one whose host-side arithmetic survives.

### The code generator

Resident `9018..9049` is a run of "assume this failure, then test": each
`splk @7d,#N` is immediately followed by a conditional branch to the commit
at `9049`.

| code | set at | test that commits it | string |
|---:|---|---|---|
| 7 | `9027` | the `ff2d` downward scan stops less than four words above `ff27` | Channel will not support 3200 baud |
| 4 | `9032` | `[da15] - [da18]` exceeds `1fe4` | Multiple CODECs in channel |
| 1 | `9036` | fallthrough - nothing else matched | x2 disabled on local modem |
| 3 | `9076` | `039f` bit 6 clear (`bit 9`, a bit code) | Remote modem is not x2 |
| 2 | `9081` | `ff18` bit 5 clear (`bit 10`, a bit code) | 3200 baud disabled on local modem |
| 5 | `9087` | `[ff00] & 0c00` is zero | Remote modem is not a Server |

That the codes and the strings belong together is not an assumption. Code 5's
test is the exact complement of the condition that sets the "Remote modem is
an x2 server" bit (`ff18` bit 5 **and** `[ff00] & 0c00` nonzero, tested at
`9049` and set at `9052` in the 4.03 resident): same two operands, opposite
outcome. Code 3 turns on `039f` bit 9, code 2 on `ff18` bit 5, and code 1 is
the default - each
matching its string's sense. Six independent agreements, on a table nobody
chose to line up.

### 6 has no producer

Sweeping all four downloaded images of the stock ROM for `splk @7d,#0006`, and
for any `splk`/`opl` of `0006` into `fff6`, finds nothing. The generator emits
1, 2, 3, 4, 5 and 7; `d777` sets `@7d` to 8, which the three-bit field
truncates to 0; and no path produces 6.

So **nothing sets "Incompatible versions"**. It is a string in the table with
no code that selects it. The most likely reading is a retired test - the entry
sits between "Remote modem is not a Server" and "Channel will not support
3200 baud", exactly where a version-compatibility check between two x2 modems
would belong, and the generator has a hole at that value rather than a
compacted list. But this image holds no evidence of what that test was.

It is moot in these builds regardless: the `eb 25` at `50c2` jumps over the
whole lookup, so none of the nine strings is ever printed. `4.03` went
further and deleted the code generator - its resident has no `splk @7d,#N`
assignments in this range at all, and the same word position now carries
`fff7 & 7`.

### One loose end this tightens

The measurement at `da15`, which sets `fff7` bit 6 in the 4.03 resident
against a threshold of `1d3c`, is the same array and the same difference the
stock generator tests against `1fe4` to report **"Multiple CODECs in
channel"**. That is a lead on the bits 6/7/8 tension recorded above - it
suggests `da15` is a channel-impairment measure rather than the
high-frequency rolloff the 4.03 string list names - but the two builds
disagree about which word and which bit it drives, so it settles nothing on
its own.

## What the "Multiple CODECs" test actually measures

"Multiple CODECs in channel" means more than one analogue/digital conversion
in the path - a tandem codec, typically a digital PBX or a second carrier hop
ahead of the one x2 expects. x2 needs exactly one D/A in the downstream
direction, because it decodes the PCM codeword levels directly; a second
conversion re-quantises them and there is nothing left to decode. The far end
never announces this, so the modem has to detect it from the line itself.

That is what `da15` is for. The array it indexes is a spectral vector, and
the firmware's own use of it says so:

* `93c7` builds the array by summing a double-word accumulator pair per entry
  out of `d982`, so `d982` is a bank of accumulators and `da00` their totals.
* `9467` rescales every entry (`mpy #0c0b`, `spac`, `bsar 5`) into `ffc0`.
* `9475` sums a span and divides by **23** for a mean; `9483` takes the
  maximum across the same span with `crgt`; `948c` and `9495` then store the
  peak-relative deviation of the bottom entry in `@5e` and of a top entry in
  `@5f`.

A mean, a peak, and both band-edge deviations is band-shape extraction over a
per-tone magnitude estimate. Against that, `[da15] - [da18] > 1fe4` is a
slope across the top of the band - which is how you detect a tandem
conversion without any cooperation from the far end, since an extra codec
band-limits and reshapes the channel in a way a single-conversion path does
not.

This also dissolves the bits 6/7/8 disagreement recorded above, without
either side being wrong. The stock build names the same measurement by its
**cause** ("Multiple CODECs in channel"); 4.03 names it by its **symptom**
("High frequency rolloff is normal / marginal"), and grades it in two bands
rather than one. Same array, same difference, two vocabularies - so the
earlier note that the two builds "disagree about which word and which bit it
drives" stands as a fact about the encoding, but is not evidence that the
measurement is two different things.

### `da18` is the top bin of that vector

An earlier reading of this called `da18` "one past the array". That was an
off-by-one in the loop counts, and the firmware's own divisor catches it.

`BANZ` tests the auxiliary register *before* the `*-` decrement, so
`lar arN,#count` followed by a `banz` body runs **count + 1** times. Applying
that:

| site | init | span | entries |
|---|---|---|---:|
| `93c7` fill | `lar ar5,#18` | `da00..da18` | 25 |
| `9467` rescale | `lar ar3,#18` | `da00..da18` | 25 |
| `9475` mean | `lar ar2,#16` from `da01` | `da01..da17` | 23 |
| `9483` peak | `lar ar2,#16` from `da01` | `da01..da17` | 23 |

The mean loop then divides by `#0017` - **23** - which is exactly the number
of entries it just summed. That divisor is the check: the counts are
count + 1, the vector is `da00..da18`, 25 entries, and the statistics
deliberately skip the extreme bin at each end.

So `da18` holds the **topmost bin of the probe magnitude vector**, and `da00`
the bottommost; those two are the guard bins the mean and peak exclude.
`[da15] - [da18]` is therefore bin 21 against bin 24 - the drop across the
last three bins, which is high-frequency rolloff read literally.

Two other sites agree. `940a` clears `da14..da18` with
`lar ar1,#da14 / rptz #0004 / sach *+` - exactly five words, ending on
`da18` - when the comparison at `9401..9408` fails, which is a
"the top of the band is unusable, zero those bins" action and only makes
sense if `da18` is the last bin. And `94c8` is a three-tap interpolator
(`lacl *+ / mar *+ / adds *- / add #01 / sfr / sacl *+`) that fills an entry
from its two neighbours, called four times from `945b` onwards - the probe
measures alternate bins and the odd ones are filled in.

This makes 4.03's naming the literal one. The quantity really is a
high-frequency rolloff slope; the stock build simply reports the diagnosis it
draws from that slope - a second codec in the path - rather than the
measurement.

## What separates the two rolloff grades

One number, two thresholds. The grading is at 4.03 resident `9674..9691`,
called from `93c4` inside the probe-analysis routine that fills the array:

```text
9674  lar   ar0, #03
9675  lar   ar1, #da15
9677  lacl  *0+            ; S = [da15]
9678  sub   *              ;   - [da18]
9679  cpl   @63, #0000     ; TC = (@63 == 0)
967b  sub   #1d3c
967d  xc    2, tc
967e  add   #07fa          ; ...so the bar is 1542 when TC, else 1d3c
9680  lar   ar1, #fff7
9682  xc    2, lt
9683  opl   *, #0040       ; "normal"
9685  retc  lt             ; and stop
9686  lar   ar1, #fff4
9688  sub   #0e9e
968a  opl   *, #1000       ; not-normal flag, unconditional
968c  lar   ar1, #fff7
968e  xc    2, lt
968f  opl   *, #0100       ; "marginal"
9691  retc  lt
```

With `S` the top-of-band slope and `T` the first bar:

| outcome | condition |
|---|---|
| normal | `S < T` |
| marginal | `T <= S < T + 0e9e` |
| neither | `S >= T + 0e9e` |

So the two grades are told apart by **a single extra margin of `0e9e`**. That
margin is the entire width of the "marginal" band; it sits immediately above
the "normal" limit, and there is no second measurement, no hysteresis and no
other input. `T` is `1d3c`, shifted down to `1542` when `@63` is zero, which
moves both boundaries together and does not change the width.

There is also a **third, unnamed outcome**. A slope past `T + 0e9e` sets
neither bit, so the report simply prints no rolloff line at all - "not even
marginal" is expressed by absence, not by a string. And `fff4` bit 12 is set
unconditionally on the way past the first test, so that flag means precisely
"graded worse than normal", covering both of the remaining cases.

### The grades straddle the stock build's single limit

The stock firmware does not grade: `96b3` and `902c..9034` both test the same
slope against one threshold, `1fe4`. Lining the three up:

```text
1542 / 1d3c   4.03 "normal" limit  (with / without the @63 shift)
1fe4          stock pass/fail limit
23e0 / 2bda   4.03 "marginal" limit
```

The stock boundary falls inside 4.03's marginal band in both variants. So
4.03 did not move the decision - it split the stock build's single pass/fail
line into a band around itself and named the two halves, which is what you
would do to report a borderline channel rather than only reject it.

`@63` is not identified. It is a page-0 scratch location written from many
places; the nearest candidate is the training sequencer's counter, set to 3
at `9317` and `9367` and decremented at `9326`, but nothing here proves that
is the same variable this test reads.

## `@63` is `03e3`, and it carries the x2-setup flag

### Fixing the page

`@63` is direct-addressed, so it means "offset `63` on the current data
page", not an address. The page is pinned by `@1f`, which this module uses
constantly:

* `8da0 ldp #007` is immediately followed by `8da1 bit 1, @1f`,
* and other code reaches the same flags word indirectly - `lar ar1,#039f`
  at `9040`, `opl *,#4081` at `d628`, `opl *,#4040` at `d75e`.

Page 7 offset `1f` is `380 + 1f` = `039f`. They are the same word, so this
module runs on **DP 7**, and there is no `ldp` between `92b4` and `972a` to
change it across the probe code. Therefore `@63` is `380 + 63` = **`03e3`**.

That turns an ambiguous scratch reference into a searchable address, and the
writers that matter address it indirectly, with no page dependence at all.

### The writer that decides the threshold

```text
d45b  lar   ar1, #fff4
d45d  bit   15, *             ; encoded bit code 0 = fff4 bit 15
d45e  lar   ar1, #03e3
d460  bcndd d468, ntc         ; two delay slots...
d462  splk  *, #0012          ; ...so this always runs
d464  call  d952
d466  b     d46a
d468  call  d94e              ; d94e: lar ar1,#03e3 / splk *,#0000
```

`03e3` is set to `0012` unconditionally in the branch's delay slots, and then
zeroed by `d94e` when the tested bit is **clear**. It is a two-valued flag:
`0012` or `0`. So `cpl @63, #0000` in the rolloff test is asking whether that
`fff4` bit was clear, and the answer is what moves both grade boundaries down
by `07fa`.

### The other users of the same word, and why they are not it

`03e3` is reused across phases - it is state, not a named variable:

* `9317`/`9367` `splk @63,#0003`, decremented at `9326`, with
  `cc 9367, eq` reloading it to 3 the moment it reaches zero. It is a
  divide-by-three inside the 21-pass probe loop at `931a..932c`, making the
  sequencer do extra work every third pass.
* `d358` uses `#03e3` as the base of a three-tap `mads` window.
* `d6aa`/`d6be` negate it and negate it back.

None of these can produce the zero the rolloff test looks for. The counter
reloads to 3 in the same instruction that observes zero, and 21 decrements
from 3 land back on 3 at loop exit, so it is never zero when read from
outside. Negating `0012` leaves it non-zero either way. Only `d94e` writes a
zero.

## Bit codes: a correction that moves several bits

The C5x `BIT` instruction takes a **bit code**, and the bit it tests is
`15 - code` - the convention [pcm-x2-v90.md](pcm-x2-v90.md) already records
("bit code 8, which is bit 7"). Masks in `opl`/`apl`/`and` are literal and
unaffected, so everything in this document derived from a mask - the ten
`fff7` bits, the `02ff` display mask, the three-bit code field, the `da15`
thresholds, `03e3` - stands unchanged. Everything derived from a `bit`
instruction was off, and the tables above are now corrected.

The one that matters most is the `fff4` bit-15 test.  In the 4.03 capture it
is at **`903d`** and **`d45d`**, and the disassembler prints it as `bit 15, *`
(encoded bit code 0).  The addresses `9070`, `d47f` and `d76f` given here
before are not `fff4` bit tests in that image - they are `sacl *`, `ldp #007`
and `xor @41` - so they belong to a different build.

## What those three sites actually test: the x2 setup flag

`fff4` bit 15 has one writer, and it is the x2 setup command itself:

```text
8d3a  lar   ar1, #fff4
8d3c  splk  *, #8000        ; stock; 4.03 at 8d31-8d33
```

That is the tag-`70` handler - the x2-only host command this document's
opening sections identify - and `splk` writes the whole word, so tag `70`
both sets bit 15 and clears the rest. `fff4` is otherwise cleared only at
reset (`8071`).

So all three consumers are asking one question: **has the host set x2 up?**

* `9070` in the stock code generator: clear takes the `fff6` bit 3 route to
  "Remote modem is not x2"; set takes the `039f` bit 6 route, which goes on to
  compare `ff18` bit 5 and `[ff00] & 0c00`. Without the x2 setup there is no
  negotiated state to consult, so it falls back to the single inferred bit.
* `d47f`: with x2 set up, `03e3` becomes `0012` and the rolloff bars relax by
  `07fa`; without it, the tighter pair applies.
* `d76f`: `opl 039f,#4040` is conditional on it, so those flags are only
  maintained on an x2 call.

That is a much plainer reading than the "source-of-truth selector" this
document gave before the bit codes were checked, and it is consistent with
`fff7` bit 0 - also set by tag `70` - being named "x2 enabled on local modem"
by the firmware's own string table.

## So what is `ff00` bit 7

Two answers, because the question inherits the numbering error.

**`ff00` is the high half of the received INFO0 pair.** At `9554` the
firmware reads `ff00` and `ff01` as one 32-bit quantity
(`lacc16 *+` then `or *-`), and immediately does the same to `ff18`/`ff19`,
comparing fields of the two. 4.03's debug report prints exactly two such
pairs from the host side - `083a`/`083c` under **"Remote X2/V90 INFO0 is:"**
and `085a`/`085c` under **"Main V34/X2/V90 INFO0 is:"**. So `ff00:ff01` is
the remote INFO0 and `ff18:ff19` the local one. This also refines the earlier
description of `ff18` as "the outgoing INFO buffer": it is the local INFO0
word pair.

**The bit called "bit 7" here is bit code 7, so it is `ff00` bit 8.** It is
read once, at `906b` in the 4.03 capture, as the fallback source for `fff4`
bit 0 - the mask-`0001` bit, not the setup flag - when the scheme word's own
validity bit is clear.

**And that bit has a second writer this document missed.** The full chain is
in the next section.

The INFO0 parser - at `91e8` in the 4.03 capture, `9223` in the build this
section was first written against - is the best description of the layout the
image gives:

| field | code | meaning as used |
|---|---|---|
| bits 11:7 | `lacl * / bsar 7 / and #001f` | a 5-bit count; `+1` into `0309`, halved into `f999` |
| bit 13 | `bit 2` | sets `fff4` bit 0 |
| bit 12 | `bit 3` | clear sets `fff4` bit 8 |
| bits 6:3 | `lacc *,5 / and #0f00` | a 4-bit value, negated and offset against `[ff26]` |

Shifts and masks are plain bit numbers - only a `bit` instruction's operand
is a code - so the two extracted fields are `11:7` and `6:3`. Note that the
bit read at `909e` falls **inside** the 5-bit count at bits `11:7`, so the
fallback is testing a bit of that count rather than an independent flag. Naming the fields themselves needs the x2 INFO0 layout,
which these images do not state; what the firmware fixes is the shape - a
5-bit count, two flags, and a 4-bit value compared against `ff26`.

## Audit: every bit claim in the docs, rechecked

Mechanically, against both 512 KiB images: extract all 1,924 `BIT` sites from
the resident and three overlays, then take every documentation line that names
a four-hex address and a bit number and compare the claim against `15 - code`.
Shift-and-mask extractions were checked separately, since those carry plain
bit numbers and no code.

**The other documents were already right.** Every one of them either converts
explicitly or quotes without claiming:

* `dsp-rom-probe.md` annotates its conversions inline - "TI numbering: the low
  bit" at `83a3` (code 15), "TI numbering: bit 2" at `8482` (code 13), "TI bit
  10 is bit 5" at `ae15`, and the `ae18..ae21` ladder follows it.
* `pcm-x2-v90.md` states the rule and applies it - `de0d` code 8 as bit 7,
  `a45b` code 9 as bit 6, the `adf1..adfd` ladder as bits 5 down to 1, `81e4`
  code 7 as `@1f` bit 8, and the `c9d2`/`c9f3`/`c5e0` note that code 13 is
  bit 2.
* `fsk-modulation.md` gives the rule as `~code & 0xf` and its slot table is in
  converted numbering; `d95f` code 7 is annotated "bit 8 of the cell".
  `9b42` "sets `@6f` bit 14" is mask-derived (`opl @6f, #4040`) and correct,
  though the same instruction also sets bit 6.
* `datapump-slots.md` inherits the same converted table.
* `codec-sample-rates.md`'s bit numbers are frame **offsets** for the
  bit-field routines, not `BIT` operands, as is "received bit 12".
* `vpcm-datapump.md`, `window-312-baseline.md`, `what-the-asic-does.md`,
  `codec-rate-312.md`, `mailbox-312-comparison.md` and `sdl-boot-block.md`
  refer to x86 port and mask bits, which are literal.
* `c52-v8-static-analysis.md` quotes `bit 5` and `bit 1` without deriving a
  bit number from either.

**This document was the only one with the error**, introduced with the `fff7`
work, and it is corrected above. Two of the corrections were themselves
wrong on the first pass and are fixed here: the INFO0 parser's extracted
fields come from shifts, not `BIT`, so they are bits `11:7` and `6:3` in plain
numbering and must not be converted a second time.

## The `fff4` bit 0 chain, in correct numbering

Bit 0 here means the mask-`0001` bit, which is what `opl *, #0001` writes.
It is **not** the bit the three `bit 0, *` sites read - those are bit code 0,
i.e. bit 15, the x2 setup flag covered above. Enumerated across both images by
resolving the `ar1` each `fff4` access loads, the complete picture is:

### Two writers, both OR-only

```text
9095  lar   ar1, #fff5            ; 4.03: #fff6
9097  bit   14, *                 ; code 14 -> fff5 bit 1
9098  lacl  #00 / xc 1,tc / lacl #01
909b  bit   15, *                 ; code 15 -> fff5 bit 0
909c  bcnd  90a4, tc              ; ...bit 0 set: keep the value from bit 1
909e  lar   ar1, #ff00
90a0  bit   7, *                  ; code 7 -> ff00 bit 8
90a1  lacl  #00 / xc 1,tc / lacl #01
90a4  lar   ar1, #fff4
90a6  or    * / sacl *            ; OR the 0/1 in
```

```text
9231  bit   2, *                  ; code 2 -> ff00 bit 13   (ar1 still ff00)
9232  lar   ar1, #fff4
9234  xc    2, tc
9235  opl   *, #0001              ; the only opl of this bit in any image
```

So:

| source | condition | site |
|---|---|---|
| `fff5` bit 1 | when `fff5` bit 0 is set | `9095..909c` |
| `ff00` bit 8 | when `fff5` bit 0 is clear | `909e..90a3` |
| `ff00` bit 13 | unconditionally OR-ed | `9231..9235` |

Both writers only ever set it. It is cleared in exactly two places: `8071` at
reset, and `8d3c` `splk *, #8000` - the tag-`70` x2 setup, which writes the
whole word. **An x2 setup therefore clears this bit and sets bit 15**, which
is the cleanest evidence that the two are unrelated flags that my earlier
reading had merged.

### Two readers, both `bit 15` (code 15)

```text
9257  lar   ar1, #fff4            ; and ov8 e1a5, identically
9259  bit   15, *
925a  lacl  #00 / xc 1,tc / lacl #42
925d  sacl  @61                   ; DP 6 -> [0361] := 0042 or 0
```

```text
e0d0  lar   ar1, #fff4            ; overlay 8, assembling a word
e0d2  bit   15, *
e0d3  lar   ar1, #0361
e0d5  xc    2, tc
e0d6  or    #4000                 ; set bit 14 when fff4 bit 0 is set
e0d8  cpl   *, #0000              ; and then, on [0361]...
e0db  xc    2, ntc
e0dc  or    #2000                 ; set bit 13 when [0361] is non-zero
```

The value `0042` and the word overlay 8 assembles are not identified; what is
established is the wiring. `fff4` bit 0 is a **latched capability bit sourced
from the INFO0 exchange** - `ff00` bit 13 always, plus either `ff00` bit 8 or
`fff5` bit 1 depending on `fff5` bit 0 - whose only effect is to put `0042`
in `0361` and to set two bits of a word overlay 8 sends. It gates nothing in
the diagnostic path, and it has no bearing on the rolloff thresholds or the
code generator; those all read bit 15.

## `fff5` bit 0 is the tag-`52` argument's bit 0, and it is always zero

### `fff5` is a host command's payload

The DSP's host-command table is at resident `8401` in the stock image and
`83e9` in 4.03, indexed by tag. It checks out against the tags this document
already named - tag `70` reaches `8d30`/`8d29`, tag `71` the `fff3` handler at
`8d49`/`8d3a`, tag `1d` reaches `9bb8`/`9b94` - and tag **`52`** reaches
`8d22`/`8d17`:

```text
stock                                   4.03
8d22  smmr  @7a, #ff2e                  8d17  smmr  @7a, #ff2e
8d24  lar   ar1, #f99b                  8d19  smmr  @7a, #fff6
8d26  splk  *+, #003f                   8d1b  lar   ar1, #f99b
8d28  splk  *, #ffff                    8d1d  splk  *+, #003f
8d2a  call  8d40                        8d1f  splk  *, #ffff
        8d42  apl  ff2e, #ffef          8d21  lar   ar1, #fffa
        8d44  lacc ff2e                 8d23  splk  *, #0000
        8d47  sacl fff5
```

So the word the `909b` test reads is **the tag-`52` argument**: stock copies it
through `ff2e` with bit 4 cleared into `fff5`, 4.03 stores it straight into
`fff6`. That is the same one-word shift seen elsewhere between the two builds,
and it confirms `fff5`/`fff6` are the same thing under two names. `fff5` has
exactly one writer and one reader in the whole stock image.

### What the supervisor puts in it

Both tag-`52` sends (`8a11` and, in the other caller, the same sequence) build
the argument at supervisor `8a55` and pass it in `BX`:

```text
8a55  mov bx, 1ef0
8a58  and bx, ffc7                  ; -> 1ec0
8a5b  test [04c6], 01 / jne         ; S56 bit 0 clear -> or bx, 0008
8a65  test [04c6], 08 / jne         ; S56 bit 3 clear -> or bx, 0020
8a6f  test [04c6], 10 / jne         ; S56 bit 4 clear -> or bx, 0010
8a79  cmp [04e9] against 0, 4, 5    ; otherwise            and bx, ffbf
8a91  test [04c5], 80 / je          ; S55 bit 7 set   -> or bx, 0100
8a9c  mov ax, 52 / lcall the mailbox thunk
```

`04c6` is S56, the V.34 options register this document already uses for the
capability word, and `04c5` is S55. The reachable bits are **3 through 12** and
nothing else: the base constant `1ef0` has bits 0, 1, 2 clear, the mask `ffc7`
only clears, and the three `or`s are `0008`, `0020`, `0010` and `0100`.

### Therefore

**`fff5` bit 0 can never be set.** The test at `909b` (`bit 15, *`, code 15) is
always false, the `bcnd 90a4, tc` at `909c` never branches, and the
`fff5` bit 1 source is unreachable - that bit is always zero for the same
reason. `fff4` bit 0 is in practice fed from **`ff00` bit 8 alone**, plus the
unconditional OR from `ff00` bit 13 at `9235`.

So `fff5` is not an x2 word at all: it is the datapump's V.34 options mask,
built from S55 and S56, and the branch in the `fff4` bit 0 computation that
consults it is dead in this firmware.

### A disassembler caveat this rests on

`BLDD` has two forms and the disassembler prints both as `bldd dma, #lk`:
`A9` copies **dma into the long address**, `A8` copies **the long address into
dma**. Everything above, and the code generator's `bldd @7d, #fff6` (`A9`,
so `@7d` into `fff6`), depends on that split. The reading is self-consistent -
`A9` at `9049` makes the `splk @7d,#N` codes reach `fff6`, and `A8` at `9419`
(`bldd *, #ff2e`, `ar1 = 0345`) makes `ff2e` the source feeding `0345`, which
is the direction the surrounding code needs - but the mnemonic alone does not
show it.

## The `ff18` frame: it is shared V.34-family INFO0, not a proprietary x2 frame

The open question above - "what is the framing of the x2-conditioned
capability payload after the DSP packs it into `ff18`" - is now answered from
the image alone.  `ff18` is serialized by the same machinery, in the same
message family, as `ff1a`.

### The bit-offset convention

`8769` (insert) and `877a` (extract) both take a **bit offset** in `@7f` and a
buffer base in `ar0`:

```text
8769  sacl  @7d              ; value
876a  lacc  @7f
876b  bsar  4                ; word index  = offset >> 4
876c  samm  @11              ; -> INDX
876d  lacl  @7f
876e  cmpl                   ; shift count = ~offset
876f  samm  @0d              ; -> TREG1
8770  mar   *0+              ; ar0 += INDX
...
8775  addt  @7d              ; value << (15 - (offset & 15))
```

So offset `n` addresses word `base + (n >> 4)`, bit `15 - (n & 15)`.  Offset 0
is `ff18` bit 15; offset 16 is `ff19` bit 15.  Offsets count **in transmission
order**, which is what makes the numbers below comparable with a standard's
field table.

### The serializer and its script

Message transmission is a small interpreted script.  `996b` is the
interpreter: `@4b` is the script PC, and each step is a `(handler, bit count)`
pair read with `tblr`.

```text
996b  lacl  @4b
996c  tblr  @48              ; handler
996d  add   #01
996e  tblr  @4a              ; bit count
996f  lacl  @4a
9970  retc  eq               ; count 0 ends the script
9971  lacl  @4b
9972  retd
9973  add   #02
9974  sacl  @4b
```

The handlers share one bit engine.  Two of them differ **only in the buffer
loaded in a delay slot**:

```text
99d6  bd    99dc, *
99d8  lar   ar0, #ff18       ; delay slots - entry for the local INFO0
99da  lar   ar0, #ff1a       ; separate entry - INFO1a
99dc  calld 877a, *
99de  lacl  @4a              ; delay slots: bit offset = remaining count - 1
99df  sub   #01
```

Because the offset is `@4a - 1`, a 17-bit body is emitted offset 16 first,
down to 0.

The bit is then folded into a CRC and a scrambler:

```text
99e1  and   @7b
99e2  xor   @59
99e3  sfr
99e5  xc    2, c
99e6  xor   #8408            ; CRC-16-CCITT, reflected polynomial
99e8  sacl  @59
```

`99c6` initialises both registers - `@50 = 04ef` (fill pattern) and
`@59 = ffff` (CRC preset) - and `99d1` shifts `@59` out.

### The scripts

The script table is one region entered at different offsets; `@4b` writers
select the message.  The `ff18` script is at `9983`, set at `9114`, `9148`
and - to repeat the message - at `99b8`:

| step | handler | count | meaning |
|---|---|---|---|
| `9983` | `99c6` | 12 | init CRC/fill, emit 12 fill bits |
| `9985` | `99d6` | **17** | **`ff18` body, offsets 16..0** |
| `9987` | `99d1` | 16 | CRC-16 |
| `9989` | `99c2` | 4 | trailing constant bits |
| `998b` | `99af` | 0 | end; restarts the script at `99b8` |

The `ff1a` scripts have the identical shape and differ only in body length:
`998d` = 77 bits, `9999` = 38 bits, `99a3` = 7 bits, each followed by the same
12-bit fill preamble and 16-bit CRC.

That settles it.  `ff18` is **not** an x2-proprietary MP-equivalent frame with
its own framing.  It is a 17-bit body in the same fill/body/CRC-16 message
family as `ff1a`, emitted by the same handler with a different `ar0`.  The
77-bit `ff1a` body is the one this document already traced as carrying V.90
`INFO1a[37:39]` at offset `0025` (37) - and offsets 76, 63, 37, 24, 19, 15 and
9 all fall inside 77, which independently confirms the offset convention.
`ff18` is the local INFO0 of that same handshake; x2 rides inside its
reserved bits rather than replacing the frame.

### What the 17 bits contain

* **Offsets 16..1** - the `fff1`/`fff2` selector word, inserted whole at
  `8e53` with `splk @7f, #0010`.  That single write covers all but the last
  bit of the body.
* **Offset 0** (`ff18` bit 15) - a one-bit flag, cleared at `8e69`
  (`apl *, #7fff`) and set at `8e8b`, `9120` and `9141` (`opl *, #8000`),
  always immediately before the `8766` sequencer call.
* **Offset 10** - the bit the code generator tests at `9049`.  That
  test is `bit 5, *` on `ff18`, and this document's earlier sections read it
  correctly as **`ff18` bit 5** (their "bit 10" is the raw encoded bit code,
  which the disassembler already converts when it prints `bit 5`).  Applying
  the offset convention above, word bit 5 is body **offset 10**.  An earlier
  revision of this section stated the inverse - "bit 10 of the word is body
  offset 5" - which was wrong in both directions.

The receive side matches.  At `9519`-`9528` the firmware reassembles both
INFO0 bodies and intersects them:

```text
9519  lar    ar3, #ff00
951b  lacc16 *+
951c  or     *-               ; remote INFO0 pair
951d  bit    0, @1f
951e  bsar   2
951f  xc     1, ntc
9520  bsar   13               ; alignment depends on @1f bit 0
9521  sacl   @7d
9522  lar    ar3, #ff18
9524  lacc16 *+
9525  or     *-               ; local INFO0 pair
9526  bsar   15
9527  sacl   @7e
9528  and    @7d              ; local AND remote
9529  sacl   @7f
```

A bitwise AND of the local and remote capability words is exactly INFO0
capability negotiation, and it is further evidence that both ends are speaking
one shared format rather than an x2-only exchange.

### What this still does not give

The *names* of the individual 17 bits.  The image fixes the frame (17-bit
body, 12-bit fill, CRC-16-CCITT preset `ffff`, poly `8408`), the transmission
order, the intersection rule, and three individual bit positions (0, 5, and
the 16..1 span).  Assigning standard field names to the rest needs the V.34
INFO0 field table or an x2 specification; it no longer needs another pass over
this firmware.

## The fill pattern and the trailing bits

Both are framing, not payload.  The decisive structural fact is that the fill
handler (`99cc`), the CRC-output handler (`99d1`) and the constant handler
(`99c2`) all branch straight to the common tail at `99e9`, **bypassing the CRC
update at `99e1`-`99e8`**.  Only the `99d6`/`99da` body handler runs the CRC.
So the CRC-16 covers the 17-bit `ff18` body (or the 77/38/7-bit `ff1a` body)
and nothing else.

### Every bit is differentially encoded

The common tail is a DBPSK mapper:

```text
99e9  lacl  @5a
99ea  xor   @7d              ; running XOR - the differential encoder
99eb  sacl  @5a
99ec  bit   0, @5a
99ed  lacc  #21fc
99ef  xc    1, ntc
99f0  neg                    ; bit clear -> -21fc
99f1  lar   ar1, #01fa
99f3  sacl  *                ; symbol out
```

A data `1` inverts the transmitted phase, a data `0` holds it, and the symbol
written to `01fa` is `+0x21fc` or `-0x21fc`.  `@5a` is reset to `0001` by the
handler at `99be`, which then branches to `99ec` *past* the XOR - so that
handler emits a reference symbol without consuming a data bit.

(Only bit 0 of `@5a` is ever read, but the XOR at `99ea` uses the whole word,
so `@5a`'s upper bits accumulate junk from the handlers that put a full word
in `@7d`.  That is harmless, not a bug.)

### The 12-bit fill is `04ef`, shifted out LSB first

```text
99c6  splk  @50, #04ef
99c8  splk  @59, #ffff       ; CRC preset
99ca  splk  @48, #99cc       ; subsequent bits re-enter here
99cc  lacc  @50, 15          ; ACC = @50 << 15
99cd  bd    99e9, *
99cf  sach  @50              ; @50 >>= 1
99d0  sach  @7d, 1           ; @7d = the pre-shift @50
```

`sach @50` with no shift stores `ACC >> 16`, which is `@50 >> 1`: a plain
right-shifting register with no feedback, so this is a fixed pattern, not a
scrambler.  `sach @7d, 1` recovers the pre-shift word, and the tail reads only
its bit 0.  The bit consumed each period is therefore the **LSB**.

`04ef` = `0000 0100 1110 1111`, so the twelve data bits in transmission order
are:

```text
1 1 1 1 0 1 1 1 0 0 1 0
```

The same `99c6` step heads every message script, so this is a shared frame
delimiter.  The CRC preset `ffff` is loaded here rather than at the body step,
which is why the fill must precede the body and cannot be reordered.

### The CRC is also sent LSB first

`99d1` is the identical shift-out applied to `@59`, so the 16 CRC bits follow
the same LSB-first order as the fill.

### The 4 trailing bits are four `1`s

```text
99c2  bd    99e9, *
99c4  splk  @7d, #0001
```

The handler supplies a constant data `1`, so `@5a` toggles every period and
the four trailing bits are four **consecutive phase reversals** - an
alternating symbol pattern closing the frame.  The same handler supplies the
two *leading* `1`s that head the `998d` and `99a3` scripts.

### Full frame layout

| step | bits | contents |
|---|---|---|
| lead-in (`99c2`, some scripts only) | 2 | `1 1` |
| fill (`99c6`/`99cc`) | 12 | `04ef` LSB first; also presets the CRC |
| body (`99d6`/`99da`) | 17 / 77 / 38 / 7 | `ff18` or `ff1a`, offset high-to-low |
| CRC (`99d1`) | 16 | CRC-16-CCITT, preset `ffff`, poly `8408`, LSB first |
| tail (`99c2`) | 4 | `1 1 1 1` |

`ff18`/INFO0 is therefore a **49-bit** frame (12+17+16+4); the `ff1a` frames
are 111 (`998d`, with its 2-bit lead-in), 70 (`9999`) and 41 (`99a3`, likewise
with the lead-in).

### How a script terminates

A step with count 0 does **not** mean "do nothing".  `996b` loads `@48` from
the table before it checks the count, and its callers (`9929`, `99bc`) do
`lacl @48 / bacc` regardless of how it returned:

```text
996f  lacl  @4a
9970  retc  eq                ; count 0 -> return, but @48 is already loaded
```

So a count-0 entry is the script's **terminal action**.  For the `ff18` script
that is `99af`, which either falls through to `99ec` or - at `99b8` - reloads
`@4b` with `9983` and sends the message again.  `99f4` is a bare `ret`, so it
serves as the do-nothing terminator, and a `99f4` step with a nonzero count
(`9977`, `997b`, `997f` all use 42) is an idle interval that holds the last
symbol for that many periods.

### A transcription note on `bit`

The C5x `BIT` instruction encodes a bit *code* equal to `15 - bit number`, and
`tools/c5x_disasm.py` converts it when printing (`bit {15 - (base & 15)}`).
So the operand this document quotes from disassembly listings is the **true
bit number**: `bit 15, *` at `d45d` and `903d` tests `fff4` bit 15, matching
its `splk *, #8000` writer, and `bit 5, *` at `9049` tests `ff18` bit 5.  The
"bit code" parentheticals in the earlier sections name the raw encoded field,
not the printed operand; their stated conclusions are the correct bit numbers.
Confirmed independently against `@62`, whose `opl`/`apl` masks span exactly
bits 0-7 and whose `bit` tests span exactly 0-7.

## Appendix: bit-numbering sweep

Prompted by an error introduced in the framing section above, every
bit-numbering claim in this document was re-checked against the 4.03 capture.
The conclusion is that the **method was already right**: the disassembler
converts the encoded bit code when it prints (`bit {15 - (base & 15)}` in
`tools/c5x_disasm.py`), so a printed operand is the true bit number, and this
document's stated bit numbers are true bit numbers.  The `(bit N, a bit code)`
parentheticals name the *encoded* field, which is `15 - bit`.  That reads as a
contradiction but is not one.

Independently anchored three ways, each pairing a `bit` test against a literal
mask on the same cell:

| cell | `bit` tests present | `opl`/`apl` masks present | agrees with |
|---|---|---|---|
| `@62` | 0..7 only | `0001`..`0080` only, no high bits | printed = bit number |
| `039f` (= `@1f`, DP 7) | includes `bit 14` at `8da1` | `opl #4040` sets bits 6 and 14 | printed = bit number |
| `fff4` | `bit 15` at `903d`, `d45d` | `splk #8000` (tag `70`) | printed = bit number |

Under the alternative reading those masks would have to touch bits 8-15, 1
and 0 respectively, and none of them does.

### Claims checked and confirmed

| claim | 4.03 site | verdict |
|---|---|---|
| `@70` bit 2 gates `fff7` `0004` | `d56d  bit 2, @70` | correct |
| `fedd` bit 7 in the `fff7` `0008` guard | `d61c  bit 7, *` | correct |
| `@1f` bit 14 set **and** `fff4` bit 1 clear | `8da1  bit 14, @1f`; `8da6  bit 1, *` | correct |
| `ff18` bit 5 in the `fff7` `0200` guard | `9049  bit 5, *` | correct |
| `039f` bit 6 on the x2-setup route | `9041  bit 6, *` (`ar1 = 039f`) | correct |
| `ff00` bit 8 as the `fff4` bit 0 fallback | `906b  bit 8, *` | correct |
| INFO0 `bit 13` sets `fff4` bit 0 | `91f6  bit 13, *` -> `opl fff4, #0001` | correct |
| INFO0 `bit 12` clear sets `fff4` bit 8 | `91fe  bit 12, *` -> `opl fff4, #0100` | correct |
| `ff1a` bit 76 / `ff08` bit 37 / received bit 12 | `9697 #4c`, `969d #25`, `96a3 #0c` | correct - these are bit *offsets*, not codes |

### Claims corrected

* **`ff18` bit 10 -> bit 5.**  Two sentences used the encoded code `10` as if
  it were the bit number, contradicting the same document's own `ff18` bit 5
  elsewhere.  The test is `9049  bit 5, *`.
* **The `d45d` listing.**  It was transcribed as `bit 0, *`; the disassembler
  prints `bit 15, *`.  The conclusion drawn from it was right.
* **`9070`, `d47f`, `d76f`.**  Not `fff4` bit tests in this image.  The real
  sites are `903d` and `d45d`.
* **`909e`/`9069` -> `906b`** for the `ff00` bit 8 read.
* **`9223` -> `91e8`** for the INFO0 parser.
* **The framing section's own `ff18` claim**, which had the offset mapping
  inverted; word bit 5 is body offset 10.

### Address drift is the real hazard, not bit numbering

Several corrected items are addresses, not bit numbers: sections written
against an earlier build cite sites that decode to something unrelated in the
4.03 capture.  The header's warning that the update ROMs relocate their code
applies to this document's own body text, so an address here should be
re-resolved before it is trusted, in the way the confirmed table above does.

## Against the ITU Recommendations

Checked against `T-REC-V.34-199610` and `T-REC-V.90-199809`.  Everything the
framing section derived from the image alone is confirmed, and the numbering
question it left open is now closed - in the opposite direction to what the
top of this document assumed.

### What V.34 10.1.2.3 says

* **Modulation** - "All INFO sequences are transmitted using binary DPSK
  modulation at 600 bit/s.  The transmit point is rotated 180 degrees from the
  previous point if the transmit bit is a 1, and 0 degrees ... if the transmit
  bit is a 0."  That is the tail at `99e9` exactly: `@5a ^= bit`, symbol
  `+/-21fc`.
* "Each INFO sequence is preceded by a point at an arbitrary carrier phase.
  When multiple INFO sequences are transmitted as a group, only the first
  sequence is preceded by a point" - that is the handler at `99be`, which
  resets `@5a` and branches *past* the XOR so it emits a reference symbol
  without consuming a data bit.  It explains why only some scripts begin with
  it.
* **CRC** - "x16 + x12 + x5 + 1 ... load the shift register with all ones ...
  output the contents starting with bit 0 ... Bit 0 of the CRC is the LSB."
  `@59 = ffff`, poly `8408` (the reflection of `1021`), shifted out LSB
  first.
* "The CRC is formed by passing all of the information bits in a sequence,
  **except the frame sync bits, the start bits, and the fill bits**."  That is
  precisely why `99cc`, `99d1` and `99c2` branch straight to `99e9` and skip
  the CRC update.

### The fill step is fill bits plus frame sync

Table 14/V.34 gives INFO0 as bits `0:3` "Fill bits: 1111", `4:11` "Frame sync:
01110010, where the left-most bit is first in time".  The firmware's 12-bit
step shifts `04ef` out LSB first:

```text
04ef = 0000 0100 1110 1111   ->   1 1 1 1 | 0 1 1 1 0 0 1 0
                                  fill      frame sync
```

So `04ef` is not an opaque constant: it is V.34's fill-plus-frame-sync packed
into one word for an LSB-first shift register.  The 4 trailing bits are the
closing "Fill bits: 1111" at `45:48`.  Every INFO sequence in both
Recommendations uses the same `1111` / `01110010` opening, which is why one
`99c6` step heads every script.

### Offsets run opposite to ITU bit numbering

V.34 numbers a sequence from bit 0 "transmitted first in time", and the
serializer emits body offsets `N-1` down to `0`.  Therefore, for a body of
`N` bits occupying sequence bits `12 : 12+N-1`:

```text
ITU bit = 12 + (N - 1 - offset)
```

This is not an inference from one site.  The loop at `9172`-`9180` runs five
iterations, stepping `@7f` down by 9 from `3f`, and writes
`[ff20+i] | ([ff28+i] << 5)` each time:

| offset | ITU bit (N = 77) | Table 9/V.90 field |
|---|---|---|
| 63 | 25 | probing results, 2400 |
| 54 | 34 | probing results, 2743 |
| 45 | 43 | probing results, 2800 |
| 36 | 52 | probing results, 3000 |
| 27 | 61 | probing results, 3200 |

Five 9-bit fields landing exactly on their ITU boundaries, walked in
increasing symbol-rate order.  The 1 + 4 + 4 sub-field layout of each
(`25` carrier, `26:29` pre-emphasis, `30:33` rate) is why the value is
`ff20[i]` in bits 0:4 with `ff28[i]` shifted up by 5.  Under the opposite
reading every field would be misaligned by 2 and the rates would be walked
backwards.

### The sequences the four scripts build

| script | body | frame | sequence |
|---|---|---|---|
| `9983` (`ff18`) | 17 | 49 | INFO0 (V.34 Table 14) = INFO0a (V.90 Table 8) |
| `998d` (`ff1a`) | 77 | 109 | INFO1c (V.34 Table 15) = INFO1d (V.90 Table 9) |
| `9999` (`ff1a`) | 38 | 70 | INFO1a (V.90 Table 10 / Table 11) |
| `99a3` (`ff1a`) | 7 | 39 | not matched to a named sequence |

### `ff18` decoded against Table 14

| firmware | ITU bit | Table 14 meaning |
|---|---|---|
| `8e53`, offset 16, a 16-bit word | 12:27 | the whole capability field - symbol rates, carrier abilities, asymmetry, CME, 1664-point, clock source |
| `ff18` word bit 15 = offset 0 | 28 | "acknowledge correct reception of an INFO0 frame during error recovery" |
| `ff18` word bit 5 = offset 10 | 18 | "ability to transmit at the high carrier frequency with a symbol rate of 3200" |

The second and third are independent confirmations.  Bit 28 is set by
`opl *, #8000` at `8e8b`, `9120` and `9141` - each immediately before the
`8766` sequencer call, on the error-recovery paths, which is what an
error-recovery acknowledgement is for.  And ITU bit 18 is the local 3200
capability, which is what this document's own result-string table calls
**"3200 baud disabled on local modem"**.  So the `fff1`/`fff2` word is the
INFO0 capability field, and the two loose bits are named.

### The correction to this document's opening claim

`9189`/`918b` writes at offset `0x25` = 37.  In the 38-bit INFO1a body that is
**ITU bits 12:14**, not 37:39.  Table 11/V.34 makes 12:14 the "Minimum power
reduction ... An integer between 0 and 7", and `9267` ends by clamping its
result to exactly `0..7` (`lacl #07 / crlt`, `lacl #00 / crgt`).  So `9185` is
the power-reduction writer.

The V.90 selector is *read*, at `8fbc`, and the read is unmistakable:

```text
8fba  call  9185, *
8fbc  lacl  #0c                ; offset 12  ->  ITU bits 37:39
8fbd  calld 877a, *
8fbf  lar   ar0, #ff1a
8fc1  and   #00000007          ; three bits
8fc3  sub   #06                ; ... against 6
8fc5  xc    2, neq
8fc6  apl   @1f, #bf7f         ; not 6 -> clear @1f bit 7
8fc8  splk  @4b, #9999         ; arm the 38-bit INFO1a script
```

Table 10/V.90: "Bits 37:39 represent the integer 6, indicating that V.90
operation is desired."  Mask to three bits, compare with 6, and drop a flag if
it differs.

Two further writers fall into place the same way, both into the 38-bit body:

| firmware | offset | ITU bit | Table 10/V.90 |
|---|---|---|---|
| `925a`/`925c`, value `127 - @3e` | 24 | 25:31 | UINFO, a 7-bit Ucode |
| `9263`/`9265`, value `@5b + 30` | 15 | 34:36 | symbol rate, an integer 3..5 |

A 7-bit value written at the LSB of a 7-bit field, and a 3-bit value at the
LSB of a 3-bit field.

### Still open

**Who writes ITU bits 37:39.**  No `8769` site in this image uses offset
`0x0c`, so the field `8fbc` reads back is not written by the bit-field writer
anywhere in the downloaded program.  Either an overlay writes it - `ebea` and
`ec0f` also call `877a` - or it is deposited by a path this sweep has not
covered.  That is the remaining question for the V.90 request, and it is a
narrower one than the original "which site selects V.90".

### Server side

The Total Control Quad NAC images build the digital-modem half of the same
protocol, on the same serializer, selecting a 17- or 30-bit INFO0 body at run
time.  See "What the NAC changes for x2 and V.90" in
[`quad-x2-modem-nac.md`](quad-x2-modem-nac.md).

## What builds the x2 bits, and how x2 and V.90 differ in kind

### The x2 capability word is host-supplied, and there are two of them

The DSP does not compute the INFO0 capability field.  It copies a 16-bit word
the supervisor hands it, and it keeps **two** such words:

```text
8d14  smmr  @7a, #fff2        ; tag 51 - the plain capability word
...
8d29  smmr  @7a, #fff1        ; tag 70 - the x2 capability word
8d2b  lar   ar1, #fff1
8d2d  apl   *, #3fff          ; force the top two bits to 0
8d2f  opl   *, #0000          ; (no-op)
8d31  lar   ar1, #fff4
8d33  splk  *, #8000          ; the x2 setup flag
8d35  lar   ar1, #fff7
8d37  opl   *, #0001          ; "x2 enabled on local modem"
```

Tag `51` writes `fff2` raw; tag `70` writes `fff1` and masks it.  The
selection between them is one bit:

```text
8e4a  bit   6, @1f
8e4b  bldd  @7d, #fff1        ; bit 6 set   -> x2 word
8e4d  xc    2, ntc
8e4e  bldd  @7d, #fff2        ; bit 6 clear -> plain word
8e50  lacl  @7d
8e51  lar   ar0, #ff18
8e53  bd    8769, *
8e55  splk  @7f, #0010        ; offset 16 -> ITU bits 12:27
```

So **the x2 bits are built by the supervisor and merely placed by the DSP**,
into the standard V.34 INFO0 capability field.  The `apl #3fff` matters: value
bit `j` lands on ITU bit `12 + j`, so clearing value bits 14 and 15 forces ITU
bits **26:27** to zero - Table 14's "Transmit clock source" field, `0 =
internal`.  The x2 word is a legal INFO0 capability word with the clock-source
field pinned.

There is also a fallback: at `8e57`-`8e5a` the firmware clears `@1f` bit 6 and
re-enters `8e4a`, rebuilding the same field from `fff2`.  That is how a call
drops to the non-x2 capability set without a separate code path.

### x2 is detected by inspecting standard bits, not by a flag

The peer-side test builds the `fff7` "remote is an x2 server" bit from two
ordinary capability bits:

```text
9047  lar   ar1, #ff18
9049  bit   5, *              ; local  ITU bit 18
904a  bcnd  90bd, ntc
904c  and   #00000c00         ; remote ITU bits 23 and 24
904e  bcnd  90bd, eq
9050  lar   ar1, #fff7
9052  opl   *, #0200
```

Local ITU 18 is "ability to transmit at the high carrier frequency with a
symbol rate of 3200".  The remote pair is ITU 23 - the top bit of the
`21:23` symbol-rate asymmetry field - and ITU 24, "Set to 1 in an INFO0
sequence transmitted from a CME modem".

The remote mapping is the same as the local one because `ff00:ff01` is packed
like `ff18:ff19`; the shift at `951d` only compensates for the body length:

```text
951d  bit   0, @1f
951e  bsar  2                 ; always
951f  xc    1, ntc
9520  bsar  13                ; total 15 when @1f bit 0 is clear
```

Shift 15 is the 17-bit INFO0a form, matching `ff18`'s own `bsar 15` at `9526`;
shift 2 leaves 30 bits, which is the INFO0d body.  So on the Courier `@1f`
bit 0 means **"the remote INFO0 is a 30-bit digital-modem INFO0d"** - the same
flag whose NAC counterpart selects sending one.

### The difference in kind

| | x2 | V.90 |
|---|---|---|
| carried in | INFO0 | INFO1a |
| when | before line probing | after line probing |
| mechanism | swap the whole capability word (`fff1` for `fff2`) | one value in an existing field |
| field | ITU `12:27`, all standard definitions | ITU `37:39` |
| how the peer is recognised | a *combination* of standard capability bits - local 18, remote 23 and 24 | `37:39 == 6`, read at `8fbc` |
| standard status | none - legal V.34 values used as a private code | Table 10/V.90 |

V.34 already defined INFO1a `37:39` as "an integer between 0 and 5, indicating
that V.34 operation is desired" (Table 11/V.90, quoting V.34).  **V.90 added
exactly one value to it**: 6.  That is the whole on-wire announcement, which is
why the firmware's V.90 check is a three-bit mask and a compare with 6, and why
the V.34 path at `96a3` clamps the same field to 5.

x2 had no such field available, because it shipped before there was a
standard place to put it.  So it announces itself in the earlier message, by
sending a capability word whose *pattern* the other end recognises - and pays
for it twice over: the decision has to be made before probing, and the
recognition test is a conjunction of bits that mean something else, which is
why the firmware needs a ten-bit `fff7` condition bitmap and a failure enum
("Remote modem is not x2", "not a Server", "Multiple CODECs in channel") to
explain what went wrong.  V.90 needs none of that; a mismatch is just
`37:39 != 6`.

### Still open

The *content* of `fff1` versus `fff2` is set by the supervisor, not the DSP, so
the specific x2 bit pattern is an 80186-side question this section does not
answer.  What is established here is where it goes, what constrains it
(ITU `26:27` forced to 0), and how the peer is tested.

## Is there an x2 INFO1?

No.  x2's capability exchange is the INFO0 word swap described above - it has
no INFO1 of its own.  But the Courier does send a **fourth message that exists
in neither Recommendation**, and it is built inside the x2 region.

### The complete standard set, for contrast

Enumerating every `1111`-delimited sequence in both Recommendations by its
closing fill position:

| body | frame | sequence |
|---|---|---|
| 17 | 49 | INFO0 (Table 14/V.34) = INFO0a (Table 8/V.90) |
| 19 | 51 | INFOh (Table 22/V.34, half-duplex only) |
| 30 | 62 | INFO0d (Table 7/V.90) |
| 38 | 70 | INFO1a (Tables 10 and 11/V.90) |
| 77 | 109 | INFO1c (Table 15/V.34) = INFO1d (Table 9/V.90) |

The Courier's fourth script, `99a3`, is a **7-bit body in a 39-bit frame**.
It matches nothing in that table, while using the standard framing exactly -
the same 12-bit fill and sync, the same CRC-16, the same closing `1111`.

### It is built only under the x2 gates

The builder is at `90de`, and it is not reached from the tag-`6b` status path
that precedes it (`90da bd 83b1` branches away with its delay slots).  Its two
call sites are `908a` and `90a6`, both inside the routine that begins:

```text
903b  lar   ar1, #fff4
903d  bit   15, *              ; x2 has been set up
903e  retc  ntc
903f  lar   ar1, #039f
9041  bit   6, *               ; the x2 capability word is selected
9042  retc  ntc
```

Both gates must hold, so nothing here runs on a non-x2 call.  What the two
sites send is a small code, and the body is 7 bits wide because the code is:

```text
9085  lar   ar1, #6f
9086  bit   1, *
9087  lacl  #4d                ; 0x4d
9088  xc    1, tc
9089  lacl  #69                ; or 0x69
908a  call  90de, *
```

```text
909b  apl   @1f, #bf3f         ; clears bit 6 - drop the x2 capability word
...
90a1  lacl  *                  ; [ff20 + @5b] & 1
90a4  add   @5b, 1
90a5  add   @5b, 4             ; -> 0x48 or 0x49 with @5b = 4
90a6  call  90de, *
```

`90de` writes the value into `ff1a` at offset 6 - the top of a 7-bit body, so
the code occupies ITU bits `12:18` - and arms the script:

```text
90de  lar   ar0, #ff1a
90e0  calld 8769, *
90e2  splk  @7f, #0006
90e4  bd    991d, *
90e6  splk  @4b, #99a3
```

Note that the second site clears `@1f` bit 6 immediately before sending, so at
least one of these codes accompanies *dropping* the x2 capability word.

### The Quad NACs do not have it

Their script tables stop after the 38-bit script.  QF 6.0.3 ends at `9ff5`
(`a043 0000`) and QR 6.1.3 at `9e25`; the Courier's table continues to `99ad`
with the six extra entries that make up the 7-bit script.  So this message is
built by the analogue Courier and not by the server images.

That asymmetry looked at first like a client-to-server message, since
receiving needs no send script.  The receive side does not support that
reading - see the next section.

### What this does and does not establish

Established: a fourth transmitted frame exists; it uses V.34's framing with a
body length no standard sequence has; it is gated on both x2 conditions; it
carries a 7-bit code; and the server images do not build it.

Not established: that it is "the x2 INFO1".  It is far too small to be a
capability or probing-results message - 7 bits against INFO1c's 77 - so it
reads as a short signalling or acknowledgement frame in the x2 phase rather
than an INFO1 counterpart.  Naming its codes (`4d`, `69`, `48`/`49`) and
finding the matching receive path is the next step, and the receive side is
the better target because it is present in both the Courier and the NACs.

## The receive side, and what it says about the 7-bit frame

### The INFO receiver

`98f9` validates a received INFO frame out of the staging buffer at `0252`:

```text
98f9  lar   ar0, #0252
98fb  calld 877a, *
98fd  lacl  @22
98fe  add   #17                 ; sync at offset @22 + 23, 8 bits
9900  and   #000000ff
9901  xor   #0000004e           ; V.34 frame sync
9903  retc  neq
9904  splk  @1f, #ffff          ; CRC preset
9906  lacl  @22
9907  sacl  @7d
9908  calld 877a, *             ; loop: offsets @22+15 down to 16
990a  lacl  @7d
990b  add   #0f
990c  and   @7b
990d  xor   @1f
...
9911  xor   #00008408
9917  bcnd  9908, neq
```

`01110010` "left-most bit first in time", shifted in LSB-first, is `4e` - so
the sync test is V.34's, verbatim.  And the offsets confirm the frame model
from the receive direction:

| offsets | contents |
|---|---|
| `@22+23 : @22+16` | the 8 frame-sync bits |
| `@22+15 : 16` | the body, `@22` bits |
| `15 : 0` | the CRC |

`8 + body + 16`, with the leading and trailing `1111` fills not stored - the
leading one is consumed by the sync hunt.  Exactly the layout the transmit
scripts build.

### It is armed for four lengths, and 7 is not one of them

The receiver is parameterised: `@24` selects the buffer, `@22` the body
length.  `8e60` sets both:

```text
8e6c  splk  @24, #ff00
8e6e  lar   ar1, #039f
8e70  bit   0, *
8e71  lacl  #11                 ; 17 - INFO0a
8e72  xc    1, tc
8e73  lacl  #1e                 ; 30 - INFO0d
8e74  b     8e79, *
8e76  ldp   #006
8e77  splk  @24, #ff08          ; separate entry, length already in ACC
8e79  sacl  @22
```

Every call site:

| site | buffer | length | sequence |
|---|---|---|---|
| `8e60` | `ff00` | 17 or 30 on `039f` bit 0 | INFO0a / INFO0d |
| `8ef9` | `ff08` | `26` = 38 | INFO1a |
| `8fac` | `ff08` | `4d` = 77 | INFO1c / INFO1d |
| `8fef` | `ff08` | `4d` = 77 | INFO1c / INFO1d |

Those are the four standard bodies and nothing else.  The Courier never arms
its INFO receiver for a 7-bit body.  The two overlay `877a` sites (`ebea`,
`ec0f`) read at offsets `e4` and `e8` - 228 and 232 - so they are working on a
different, much larger buffer, not this frame.

### So the 7-bit frame is unmatched in all three images

Putting the two directions together:

* the analogue Courier **sends** a 7-bit body frame and never arms a receiver
  for one;
* neither Quad NAC **sends** one.

Nothing in these three images both produces and consumes it, which removes the
tidy client-to-server reading offered above.  What remains established is
unchanged - the frame exists, it is x2-gated at `903b`, it carries a 7-bit
code, and its length matches no sequence in V.34 or V.90.  What it is *for*
is not answered by these images.

The plausible outs, in the order worth testing: a receive path outside the
INFO receiver that this sweep has not found; a peer image not in this
repository, since the NACs here are one server generation and the x2 server
population was not uniform; or a frame whose presence and timing matter rather
than its content, which would need no CRC-checked receiver at all.
