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
x2", whose failure is entry **3**. No single shift reconciles the two lists,
and several failure strings ("Multiple CODECs in channel", "Incompatible
versions") have no counterpart among the ten bits at all. The nine failure
strings are their own progression, and the arithmetic that maps the bitmap
onto them is precisely the code that was patched out. It is not recoverable
from this image.

So the enum's *mechanism* is settled - one word in, one of nine strings out,
by an index computed from the masked bitmap - and its *table* is settled, but
the index arithmetic is not. What is closed is that the host never receives a
diagnostic code: it receives `fff7` and turns it into text locally, twice
over, by two different rules.

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
| 2 | `0004` | `d571` | `retc ntc` at `d56e` | bit 13 of `@70`, after `call d876` |
| 3 | `0008` | `d62c` | branches at `d613`..`d624` | field `0d` of `fea1` and of `fedd` both present, `fedd`'s bit 8 set, and `(value & 0x60) == 0x60` |
| 4 | `0010` | `d763` | `xc 2, gt` | a summed-difference measurement over the `02a4` buffer, scaled by `2d00`, is positive |
| 5 | `0020` | `9028` | `retc lt` at `9025` | the first nonzero entry scanning `ff2d` downwards is at least four words above `ff27` |
| 6 | `0040` | `9683` | `xc 2, lt` | `[da15] - [da18]` is below `1d3c` (below `1542` when `@63` is nonzero) |
| 7 | `0080` | `8dae` | branches at `8da2`/`8da8` | `@1f` bit 1 set **and** `fff4` bit 14 clear |
| 8 | `0100` | `968f` | `xc 2, lt` | the same measurement as bit 6, against a threshold `0e9e` lower |
| 9 | `0200` | `9052` | branches at `904a`/`904e` | `ff18` bit 10 set **and** `[ff00] & 0x0c00` nonzero |

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
`8dae`, whose guard is `@1f` bit 1 set and `fff4` bit 14 clear - a pair of
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
