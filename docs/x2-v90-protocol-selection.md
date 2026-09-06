# x2 versus V.90 protocol selection

This is deliberately separate from `codec-sample-rates.md`.  That document
describes the six-row V.34 rate machinery; it must not be used to identify the
V.90 protocol selector.  Addresses below are for
`artifacts/courier-board-21210-capture-403/courier-board.rom`; the bundled
update ROMs retain x2/V.90 result vocabulary but relocate their executable
code, so an absolute-address match is not a cross-version test.

## Confirmed V.90 INFO1a writer

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
an x2 server" bit (`ff18` bit 10 **and** `[ff00] & 0c00` nonzero, at `9052`
in the 4.03 resident): same two operands, opposite outcome. Code 3 turns on
`039f` bit 9, code 2 on `ff18` bit 10, and code 1 is the default - each
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
d45d  bit   0, *              ; bit code 0 = fff4 bit 15
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

The one that matters most: `bit 0, *` on `fff4`, at `9070`, `d47f` and
`d76f`, is bit code 0 and therefore **`fff4` bit 15**.

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
read once, at `909e` (`9069` in 4.03), as the fallback source for `fff4`
bit 0 - the mask-`0001` bit, not the setup flag - when the scheme word's own
validity bit is clear.

**And that bit has a second writer this document missed.** The full chain is
in the next section.

The INFO0 parser at `9223` is the best description of the word's layout the
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
