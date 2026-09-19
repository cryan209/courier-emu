# The datapump gate in 302 addresses

**Everything here is 302 and 403.** `main211.xmf` is not fully modelled and its
runs are not evidence about this board.

**The arming question is answered in
[datapump-gate-403-addresses.md](datapump-gate-403-addresses.md)**: an answered
call arms the datapump from the DSP with one message, `0047:0007`, and `&L1` or
`&T1` arm it by command. This document keeps the 302 static reading of the same
structures, and two 302 findings that belong nowhere else.

## The gate, read statically on 302

`0x8b84f` is a discriminator returning not-equal if any one of three flags is
set:

```text
8b84f  test byte [0xa96], 2
8b856  test byte [0x5a5], 1
8b85d  test byte [0x685], 1
```

All three are zero in every run this project has made, so it returns equal, and
that gates two things at once.

**The overlay id.** `[0xe3c]` is assigned at `0x8bbaa`-`0x8bc4d`, and the whole
block is skipped when the discriminator returns equal:

```text
8bbaa  call 8b863           ; CF gate
8bbad  jae  8bbc2
8bbba  mov  byte [0xe3c], 6
8bbc2  call 8b84f           ; the discriminator
8bbc5  jne  8bbca
8bbc7  jmp  8bc52           ; equal -> skip every [0xe3c] assignment
```

`[0xe3c]` stays zero, so the post-dial sequencer's gate at `0x8b5ca` never calls
the loader at `0x8e5da` and the run reports `bootstraps: 1`. The loader is the
transport the bridge already models (`out 0x1e, 4` then poll bit 2); it is simply
never entered on a dial.

**The `0x10` dispatch.** Same discriminator at the dispatch site:

```text
8bee8  mov   ax, 5a
8beeb  call  8b863        ; -> CF
8beee  jb    8bef8
8bef0  call  8b84f        ; -> ZF
8bef3  je    8bf01        ; ZF set: send nothing
8bef5  mov   ax, 10       ; the datapump dispatch
```

[datapump-slots.md](datapump-slots.md) has the nine-slot table that mailbox
commands `10` and `11` select. `mov ax, 10` is never executed on a dial; the run
emits `0017:704d` from the equal branch one site over.

Measured with `--trace-pc` across a full 302 dial:

| watch | hits |
|---|---|
| queue drain `8f521` | 45 |
| discriminator `8b84f` | 19 |
| dispatch site `8bee8` | 1 |
| `send-10` `8bef5` | **0** |
| loader gate `8b5ca` | 1 |
| `call-loader` `8b5d1` | **0** |

Flag C is the only one with a setter: `[0x685] |= 1` at `0x876c5`, reached from
`0x876b1` when `[0x33e] & 4 == 0` (the run has `033e: 2`). `0x876b1` is entry 1
of a nine-stub thunk table at `0x875d8`, reached from the indexed jump at
`0xa6ad7` (`jmp word ptr cs:[bx + 0x1dbe]`, `bx = 2 * AL`, CS `a4d2`), whose
table sits at `0xa6ade` and rejects `AL = 2`. `[0x5a5]` bit 0 has no setter
anywhere in the image, only `and [0x5a5], 0xfe` at `882db` and `8982e`; there is
no `or [0xa96], 2` either.

`AL` is **not a call-progress event code.** The router's entry at `0xa6a6c`
begins `lcall 8000:9cbc`, a decimal ASCII parser (`lodsb`, `sub al, 0x30`,
`mov ah, 0xa`, `mul ah`, accumulate), so `AL` is a number taken from a command
string - which is the reading the 403 work confirmed when it identified the
table as the ampersand family and entry 19 as `&T`.

The cells read off the running 4.03d board with `ATGLK2=`, as found, after `ATZ`,
and while an inbound call was offered with `S0=0`, are identical at all three
samples:

| `685` | `5cd` | `33e` | `5a5` | `a96` | `e3c` | `5fa` | `600` | `ea7` |
|---|---|---|---|---|---|---|---|---|
| `ff` | `e0` | `11` | `08` | `00` | `00` | `00` | `00` | `00` |

**These addresses are 302-derived and the board runs 7.4.16.** The comparison
only holds if the data layout is unchanged between builds, which is not
established - the 403 addresses are in the other document, and the board reads
taken *at* them are all zero.

## The supervisor's real dispatcher, and a bridge assumption it retires

`0x8f564` is `call word ptr [0x298]` - an indirect call through the current
state handler with a selector in AL. Across a whole dial it runs three times:

| instruction | AL | result |
|---|---|---|
| 5,847,937 | `83` | the first `0083:0083` |
| 35,662,523 | `83` | the second |
| 59,801,997 | `82` | BX=`704d`, the `0017:704d` the run emits |

So `0x82` on 302 is an internal state selector, **not an ASIC register write**.
`bridge.py`'s `_maybe_start_asic_call_engine` arms the call on
`asic_registers[0x82] == 0x00A0`, which is main211's protocol; 302 never writes
that register at all, and its `0x1f` commit fallback sees six messages all
carrying data `0000`. Hence `call_overlay_available: true`,
`call_overlay_active: false`.

## Bit 12 of the dispatch word comes off the wire: MNP LR parameter 0xC0

The data word's bit 12 is the one bit in `[0x0281]` that is not built from the
local configuration. It is written by `0x8614d`, which sets or clears it in
`[0x027f]` and `[0x0281]` together from `[0x04ed] & 4`:

```text
8614d  test byte [0x4ed], 4
86154  or  [0x281], 0x1000 ; or  [0x27f], 0x1000 ; mov al, 0x10 ; ret
86163  and [0x281], 0xefff ; and [0x27f], 0xefff ; mov al, 0x18 ; ret
```

**`[0x04ed]` is a byte the far end sent.** It has exactly two writers that put
anything but zero in it, and both are the same decode in the MNP Link Request
parser at `0x858bf`:

```text
85924  cmp  al, 0xc0        ; parameter type
85926  jne  85953
85928  call 84e80           ; next byte - the length
8592b  cmp  al, 2
8592d  jne  85950           ; not length 2 -> reject the LR
8592f  call 84e80
85932  mov  byte [0x4ed], al
85935  call 84e80
85938  and  al, 0xfc
8593a  mov  byte [0x4ee], al
```

`0x84e80` is a ring reader - `lodsb`, wrapping `0x1b00` back to `0x1a80` - and
`0x8d370` is the same decode over the second ring, `0xb000`-`0xc000`.

The frame is MNP, which the parser's own parameter set settles: type 3 length 1
with the value range 1-15 (the outstanding-LT-frame count `k`), type 4 length 2
capped at `0xf4` with a dead `cmp dx, 0x104` comparing against 260 beside it,
type 8, type 9 rejected at 3 or above, and type `0xc0` - the proprietary slot.
The transmitted template at `0x85bde` is the canonical LR header byte for byte:

```text
01 06 01 00 00 00 00 ff  02 01 03  03 01 08  04 02 40 00
```

The modem advertises its own word through the same parameter, at `0x85cd3`:

```text
85cd3  or   al, al
85cd5  je   85ce5          ; zero -> emit nothing, a plain MNP peer sees no 0xc0
85cd8  mov  al, 0xc0 ; stosb
85cdb  mov  al, 0x02 ; stosb
85cdf  stosw               ; the local capability word
85ce0  add  byte [0xc17], 4
```

Its only LR-side caller is `0x85bc3`, reached only when `0x85c67` answers 3, and
the word itself is built by `0x85f70`.

**So bit 12 of the datapump data word is a negotiated property, not a
configured one.** Everything else in `[0x0281]` is a permutation of `[0x027f]`
built at `0x8bc85` from the config bytes; this bit is the far end's answer.
Three sites read it - `0x860c6`, `0x8614d` and `0x9b024` (as `0x05`) - and
`0x860ad` returns `4` only when `[0x5a4] & 4` is clear, `[0x5f1]` is at least 4,
`[0xb8a] & 1` is clear **and** this bit is set.

### The same holds on 403, at `[0x03e5]`

The 403 board ROM carries the identical code with the cell renumbered:

| | 302 (`IDSDL302.ROM`) | 403 (`courier-board.rom`) |
|---|---|---|
| LR template | `0x85bde` | `0x85c28`, byte-identical |
| `0xc0` decode and store | `0x85924` / `0x85932` | `0x8596e` / `0x8597c` |
| second ring's store | `0x8d370` | `0x8d384` |
| the cell pair | `[0x04ed]` / `[0x04ee]` | `[0x03e5]` / `[0x03e6]` |
| bit-12 override | `0x8614d` | `0x86197` |

The correspondence is one-to-one and not a guess: both images have **30** `test
byte` sites against the cell carrying the same masks in the same order, the same
two byte stores out of the LR decode, the same four word-wide clears, the same
two literal-`1` writes at `0x910b1`/`0x910c2`, and **no** `or`, `and` or `xor`
against it anywhere.

> Scope of that scan: it covers direct `disp16` addressing only. A write reached
> through a pointer would not appear in it. Nothing suggests one - the LR decode
> accounts for the cell completely - but the claim is "no direct writer", not
> "no writer".

Note that `0x4ed - 0x3e5` is `0x108` where `0x281 - 0x17b` is `0x106`: the two
RAM maps are reshuffled, not uniformly shifted, so no 302 cell may be carried to
403 by adding a constant.

### And on the ISDN I-modem and the quad server, at their own cells

The mechanism is not Courier-specific. The same LR parameter, the same decode,
the same `0x1000` override and the same dispatch idiom are in every USR image
in this tree that carries an 80186 modem side:

| | analog Courier | ISDN I-modem | quad server |
|---|---|---|---|
| image | `IDSDL302.ROM` | `Ie030002.nac` | `position-0-channel-0-flash.bin` |
| `0xc0` decode | `0x85924` | `0x7bfe7` | `0x5e99` |
| received pair | `[0x04ed]`/`[0x04ee]` | `[0xd0a3]`/`[0xd0a4]` | `[0x84fd]`/`[0x84fe]` |
| bit-2 override | `0x8614d` | `0x7c9e5` | `0x6b97` |
| capability pair | `[0x0281]`/`[0x027f]` | `[0xc995]`/`[0xc993]` | `[0x820c]`/`[0x820a]` |
| `0xc0` emitter | `0x85cd8` | `0x7c48b` | `0x65d3` |

The override is byte-identical in all three - `test byte [cell], 4 ; je +0f ;
or word [pair0], 0x1000 ; or word [pair1], 0x1000 ; mov al, 0x10 ; ret` - and so
is the emitter, `mov al, 0xc0 ; stosb ; mov al, 2 ; stosb ; pop ax ; stosw ;
add byte [len], 4`, skipped when the local word is zero.

The dispatch idiom carries over unchanged. Where 302 has
`mov ax, 0x5a ; ... ; mov bx, [0x281] ; lcall 8f43:0224`, the I-modem has three
sites and the quad five, each `mov ax, <tag> ; mov bx, [cell] ; lcall`:

| image | tags seen at the dispatch sites |
|---|---|
| I-modem `Ie030002.nac` | `0x11`, `0x10`, `0x17` |
| quad `position-0-channel-0` | `0x1e`, `0x11`, `0x10`, `0x17`, `0x1e` |

So `0x10`/`0x11` are the same commands there, and `0x17` and `0x1e` are two more
that publish the same word - neither of which appears at the two 302 sites this
document traced. That is a loose end, not a conclusion.

Two limits on the above. The `.nac` images interleave record headers into the
byte stream, so the sequences above are read across those boundaries rather than
from an unpacked image; and this says the **mechanism** is shared, not that bit 2
means the same thing in each - nothing here reads the bit's meaning out of any of
the three, only its plumbing. `IE010203.NAC` carries a 386EX ISDN image as well,
which is a separate processor and is not what any of this addresses.

### Tags 0x17 and 0x1e, read out of the DSP table

Both are real handlers in both images, and the tag-`0x1e` one closes the chain
this section opened.

| tag | 302 / DSP 3.0.13 (base `0x8401`) | 403 / DSP 3.1.2 (base `0x83e9`) |
|---|---|---|
| `0x10` | `0x9b58` | `0x9b34` |
| `0x11` | `0x9b5c` | `0x9b38` |
| `0x17` | `0x9bc5` | `0x9ba1` |
| `0x1e` | `0x9b9d` | `0x9b79` |

(The `0x10`/`0x11` column reproduces `fsk-modulation.md`'s independently read
`9b34`/`9b38` for 403, which is the check that the table base is right.)

**`0x1e` carries exactly one bit, and it is bit 12.** Six words, 302 `0x9b9d`:

```text
9b9d  apl   @6f, #efff      ; clear bit 12 of the marker cell
9b9f  lacl  @7a             ; the inbound data word
9ba0  and   #00001000       ; keep bit 12 and nothing else
9ba2  or    @6f
9ba3  sacl  @6f
9ba4  ret
```

That is the same bit `0x8613f` writes into `[0x0281]` from `[0x04ed] & 4`, and
the supervisor calls `0x8613f` immediately before publishing the tag - `0x8404b`
`call 8613f`, then `0x8404e` `mov ax, 0x1e`. So the path runs end to end:

> MNP LR parameter `0xc0`, payload bit 2 -> `[0x04ed]` bit 2 -> `[0x027f]` and
> `[0x0281]` bit 12 -> mailbox tag `0x1e` -> DSP `@6f` bit 12.

`@6f` is the marker cell from [fsk-modulation.md](fsk-modulation.md), the one
`9b42` sets to `#4040` and each slot entry rewrites. **Tag `0x1e` is a
modulation-capability update, not a start**: it touches `@6f` and returns.

**`0x17` is a start, but it does not use the nine-slot table.** 302 `0x9bc5`:

```text
9bc5  smmr  @7a, #03a6       ; park the data word at DSP data 0x03a6
9bc7  lacl  @7a
9bc8  and   #00003200        ; bits 9, 12 and 13 survive
9bca  or    #00000040        ; bit 6 forced
9bcc  sacl  @6f              ; @6f written wholesale, bit 12 included
9bcd  bit   1, @7a           ; bit code 1 - that is bit 14
9bce  splk  @6d, #9d17
9bd0  xc    2, tc
9bd1  splk  @6d, #9cd4       ; two fixed entries, chosen by that one bit
9bd3  b     9b50, *
```

Where `0x10`/`0x11` load a table base into `@7c` and let the selector at `0x9b7e`
pick a slot from the DSP's own mode flags, `0x17` picks between **two** entries
directly off bit 14 of the data word. The polarity is that `splk #9d17` runs
first and the `xc 2, tc` overwrites it, so **bit 14 set selects `0x9cd4`, bit 14
clear leaves `0x9d17`**.

The two are not the same kind of address, and this is the part that has to be
said carefully:

| | `0x9cd4` | `0x9d17` |
|---|---|---|
| where | resident bank, below every overlay entry (`0x9d00`, `0xb000`, `0xdc00`) | **23 words inside overlay 6**, whose span is `0x9d00`-`0xc9f5` on 302 |
| stable? | yes - no overlay can overwrite it | no - what is there depends on whether overlay 6 is loaded |

`0x9cd4` is a frame loop, and it never returns:

```text
9cd4  call  d5bf ; call d47d
9cd8  splk  @28, #01ed
9cda  splk  @2b, #0050      ; <- loop head
9cdc  call  8771 ; call 9cec ; call d49a
9ce2  splk  @2b, #0028
9ce4  call  8771 ; call 9cec ; call d48e
9cea  b     9cda             ; forever
```

Two alternating phases with `@2b` loaded `0x50` then `0x28`, each running the
shared poll at `0x9cec`. That poll is a resume primitive rather than a
subroutine: `popd @7d` lifts its own return address off the hardware stack,
bit-tests `@2f` and branches away to a handler if one is set, otherwise
decrements `@2b`, `retc gt` while the count holds, and on expiry does
`lacl @7d ; bacc` back to the saved address.

**`0x9d17` is V.34 setup, and only when overlay 6 is resident.** Comparing
overlay 6's payload against the base image word for word, **52 of 11,510** words
coincide - the overlay is not a patch, it is different code - and at `0x9d17`
every word differs:

```text
9d17  sar   ar1, @51
9d18  clrc  tc
9d19  call  a6e2
9d1b  splk  @17, #9ae4
9d1d  splk  @16, #4000
9d1f  splk  @7c, #0000
9d22  call  a685
9d24  bldd  @12, #fff0
9d27  bldd  @45, #ff2e
9d2c  splk  @1a, #0c80
```

> **Corrected 2026-09-19.** An earlier revision of this section described
> `0x9d17` as opening on `bit 2, @2f` with a three-way branch. That is the
> **base image's** bytes at that address - a dispatcher shaped like `0x9cd4`'s -
> and it is exactly what overlay 6 overwrites. Any reading of an address at or
> above `0x9d00` has to say which of the two images it is reading.

All three share the prologue at `0x9b50`, which is worth naming:

```text
9b50  ldp   #007
9b51  lar   ar1, #fea1
9b53  call  d65f, *
9b55  retd
9b56  lacb
9b57  sacl  @27
```

`@27` is one of the two cells the slot selector tests, so the prologue
**refreshes the mode flags** before any dispatch reads them.

On the supervisor side the emitters line up with the gate this document traced:
`0x8bf0f` sends `0x17` when the CF gate is clear **and** the discriminator is
equal - the ordinary dial, which is the `0017:5041` already recorded above -
while `0x8404e` and `0x90f3f` send `0x1e`, each right after the bit-12
recomputation.

## On a leased line the same sites publish `0x5a` and `0x59`

The section above answers the dial. `&L1` takes a different branch of the same
instruction, and it is the branch nobody had traced.

Both dispatch sites are three-way, and both publish `[0x0281]` as the data word:

> **The RAM-map collision, resolved 2026-09-19.** `courier_firmware_analysis.md`
> also claims `[0x0281]`, as the DAA `SI` line-side register read delivered by
> mailbox tag `0x7e`. That is a different image: its addresses are Courier 3453B v2.1.1
> (`main211.xmf`, physical = file + `0x40000`), where `0x6adb5` is
> `a3 81 02` - `mov [0x281], ax` right after an `in al, 0x5c` - and `0x5e576`
> is `f6 06 81 02 01` - `test byte [0x281], 1`, the ring-detect debounce.
> **`IDSDL302.ROM` contains no store to `[0x281]` at all**, and `main211.xmf`
> contains no `mov bx, [0x281]`. The two readings never meet; 2.1.1 and 3.0.2
> simply put different variables at the same offset, and the same is true of
> `[0x027f]`, which is the capability word here and the unidentified tag-`0x7d`
> destination there. `SV25.XMD` references the cell in no form whatsoever.


```text
8bee8  mov  ax, 0x5a
8beeb  call 8b863          ; the CF gate
8beee  jb   8bef8          ; carry      -> publish 0x5a
8bef0  call 8b84f          ; the discriminator
8bef3  je   8bf01          ; all flags clear -> publish nothing here
8bef5  mov  ax, 0x10       ; a flag set -> the dialed datapump dispatch
8bef8  mov  bx, word [0x281]
8befc  lcall 8f43:0224

884cb  mov  ax, 0x59
884ce  call 8b863
884d1  jb   884de          ; carry      -> publish 0x59
884d3  mov  ax, 0x14       ; all flags clear
884d6  call 8b84f
884d9  je   884de
884db  mov  ax, 0x11       ; a flag set
884de  mov  bx, word [0x281]
884e2  lcall 8f43:0224
```

| site | CF gate carry | gate clear, flags clear | gate clear, a flag set |
|---|---|---|---|
| `0x8bee8` | **`0x5a`** | nothing | `0x10` |
| `0x884cb` | **`0x59`** | `0x14` | `0x11` |

So `0x10`/`0x11` are the *dialed* datapump commands
([datapump-slots.md](datapump-slots.md) has the nine-slot table they select) and
`0x5a`/`0x59` are their leased-line counterparts. A dial never reaches either
column because the discriminator is equal; a leased line never reaches them
because the CF gate answers first.

**`[0x05fa]` is `&L`.** The gate at `0x8b863` returns carry when
`[0x5cd] & 0x40 == 0` and `[0x5fa] == 1` and (`[0x600] == 0` or `[0x600] > 3`).
Peeked at the end of four 302 runs:

| run | `5cd` | `5fa` | `600` | `e3c` | `32c` | `a96` | `5a5` | `685` |
|---|---|---|---|---|---|---|---|---|
| idle | `00` | `00` | `00` | `00` | `00` | `00` | `00` | `00` |
| `ATDT` dial | `00` | `00` | `00` | `00` | `00` | `00` | `00` | `00` |
| leased answer | `00` | **`01`** | `00` | `00` | `00` | `00` | `00` | `00` |
| leased originate | `00` | **`01`** | `00` | `00` | `00` | `00` | `00` | `00` |

`[0x05fa]` is set only by `&L1`, which is the 302 counterpart of the `[0x04f2]`
the 403 note names, and it is the only one of the eight cells a leased seizure
moves.

### `[0x0600]` is `&N`, and it has exactly one writer

Scanning the image for every direct write to the cell - `mov`, `inc`/`dec`,
`and`/`or`/`xor`/`add`/`sub`, `xchg`, immediate or register, byte or word -
gives one site:

```text
a6995  lcall 8000:9cbc     ; the decimal ASCII parser -> AL
a699a  jb   a69e4          ; unparseable -> ERROR
a699c  mov  ah, 9          ; ceiling, raised from the [0x89d] capability bits:
                           ;   &4 -> 0a, &40 -> 0b, &80 -> 11, &20 -> 20, else 28
a69c4  cmp  al, ah
a69c6  jae  a69e4          ; out of range -> ERROR
a69c8  call a74c3
a69cb  test byte [0x694], 4  / je a69df
a69d2  test word [0x272], 4  / je a69df
a69da  mov  byte [0x677], al  ; the diverted destination
a69df  mov  byte [0x600], al  ; the only writer
```

Probed by command - one run each, `--peek 0x600`, 60M instructions:

| command | `[0x600]` | result |
|---|---|---|
| `AT&N1` | **`01`** | `OK` |
| `AT&A1`, `AT&B1`, `AT&G1`, `AT&U1`, `AT&Y1` | `00` | `OK` |
| `AT&M1` | `00` | `ERROR` |

So `[0x0600]` is `&N`, the fixed link rate, and the CF gate clears for `&N1`,
`&N2`, `&N3` only. The factory default is `&N0` - the `ATI4` profile prints it -
which is why a leased seizure carries.

`&N1` moves the leased pair onto the dial's branch, measured over a full pair
(`--at AT&N1 --at AT&L1`, 200M):

| watch | answer | originate |
|---|---|---|
| CF gate `8b863` | 2 | 3 |
| discriminator `8b84f` | 9 | 10 |
| site `8bee8` | 0 | **1** |
| `send-10` `8bef5` | 0 | **0** |
| site `884cb` | **1** | 0 |
| `send-14` `884d3` | **1** | 0 |
| `send-11` `884db` | **0** | 0 |

`0059:715d` and `005a:704d` are gone; the ends now publish `0014:5141` and
`0017:5041`, the discriminator-equal words.

**That is a loss, not progress.** Carrying the gate is what the leased branch
*is*. Traced against a plain `&L1` pair over the overlay route:

| run | `[0xe3c] <- 6` `8bbba` | loader `8b5d1` | `overlay_downloads` | `overlay_id` | publishes |
|---|---|---|---|---|---|
| `&L1` answer | **1** | 0 | **2** | **8** | `0059:715d` |
| `&L1` originate | **1** | **1** | **2** | **8** | `005a:704d` |
| `&N1 &L1` answer | 0 | 0 | **0** | none | `0014:5141` |
| `&N1 &L1` originate | 0 | 0 | **0** | none | `0017:5041` |

With `&N1` the call overlay is never downloaded at all. `&L1` on its own is the
complete leased arming - the carry reaches `mov [0xe3c], 6`, the loader chains
it to 8, and the dispatch publishes the leased command - and it is the only
configuration tried here in which the datapump overlay loads. A fixed `&N` rate
takes a leased line off that branch and onto the dial's, where it does not.

### The writer census for the gate and the discriminator

Same scan over all five cells. It finds direct `disp16` writes only, so an
indexed or based write would not appear.

| cell | role | writers |
|---|---|---|
| `[0x0600]` | `&N` | 1: `a69df` |
| `[0x05cd]` | gate, bit 6 | 5, all in `c911x`-`c917x`: `or 0xc0` x2, `or 0x60`, `and 0x7f`, `and 0x1f` |
| `[0x0a96]` | flag A, `& 2` | 7, and **none of them sets bit 1**: `or 0x10` at `84291`, six `and 0xf1`/`0xef` |
| `[0x05a5]` | flag B, `& 1` | 2, both `and 0xfe` - **no setter at all** |
| `[0x0685]` | flag C, `& 1` | 18, of which one sets bit 0: `or 0x01` at `876c5` |

Flags A and B cannot be set by this image. Flag C's single setter is the one the
dial section traces to the nine-stub thunk table. `[0x05cd]` bit 6 is the second
independent way to clear the CF gate - `test [0x5cd], 0x40 / jne` passes before
`&L` is even read - and it is settable, from the `0xc9xxx` block.

### `0x876c5` is `AT&T1` - which is the dial branch, not the leased one

`&T1` is local analog loopback. Setting flag C through it forces the *dialed*
dispatch out of a diagnostic, and has nothing to do with leased operation: the
leased branch never consults the discriminator at all, because the CF gate
answers first. This section records the route because flag C is the only one of
the discriminator's three that can be set at all, and because it establishes
that `0x10` is reachable - not because it is a step toward a leased `CONNECT`.

Flag C's setter is reached by exactly one route, and every step of it is now
identified.

**The setter.** `0x876b1` gates on one bit:

```text
876b1  test byte [0x33e], 4
876b6  je   876c5           ; clear -> the flag
876b8  or   byte [0x32c], 0x80   ; set -> the abort bit instead
876bd  or   byte [0x685], 0x40
876c5  or   byte [0x685], 1      ; FLAG C
876ca  mov  byte [0xb8a], 1
```

Runs have `033e: 02`, so bit 2 is clear and the `je` is taken.

**The thunk.** `0x876b1` is the target of stub 1 of eight `call X / retf` stubs
at `0x875d8`, stride 4: `875f8`, **`876b1`**, `876d5`, `876f2`, `876f9`,
`87700`, `87715`, `87738`. The only far references to those stubs are eight
`lcall 8000:75xx` blocks at `0xa6af0`, stride 6.

**The table.** The indexed jump at `0xa6ad7` is `jmp word ptr cs:[bx + 0x1dbe]`
with `bx = 2 * AL` and CS `a4d2`, so the table is at `0xa6ade`. Decoded, it is
nine entries wide and eight of them land on those `lcall` blocks:

| `AL` | word | target | |
|---|---|---|---|
| 0 | `1dd0` | `a6af0` | stub 0 |
| **1** | `1dd6` | `a6af6` | **stub 1 - flag C** |
| 2 | `1dbc` | `a6adc` | `stc / ret` - the reject |
| 3..8 | `1ddc`..`1dfa` | `a6afc`..`a6b1a` | stubs 2..7 |

**The router**, `0xa6a6c`, parses `AL` as a decimal argument off the command
line and range-checks it before the jump:

```text
a6a6c  lcall 8000:9cbc         ; the decimal parser -> AL
a6a71  jb   a6adc              ; unparseable -> ERROR
a6a73  test [0xea7], 1         ; set -> reject AL 1 and 8
a6a84  cmp  al, 9 / jae a6adc
a6a88  test [0x33e], 1         ; set -> reject AL 3, 6, 7
a6a9b  test [0x33e], 4 + [0x331], 1  ; both -> reject AL 6, 7
a6ab1  cmp al,0 / al,4 / al,5 / je a6ad2   ; these three skip the flag tests
a6abd  test [0x685], 7  / jne a6adc
a6ac4  test [0xa96], 0xe / jne a6adc
a6acb  test [0x5a5], 1  / jne a6adc
a6ad2  cwde / mov bx, ax / shl bx, 1 / jmp cs:[bx+0x1dbe]
```

`[0x0ea7]` is the cell the 403 table already names "rejects `AL = 1` when set".
`AL = 1` is outside `{0, 4, 5}`, so it also has to pass the three flag tests -
the discriminator's own cells, read here as a precondition. All are zero in
these runs, so `AL = 1` is admitted.

**The command is `&T`.** Probed one run each, 60M, with `--trace-pc` on all four
sites:

| command | router | idx jump | stub 1 | `876c5` | `[0x685]` | reply |
|---|---|---|---|---|---|---|
| `AT&T1` | **1** | **1** | **1** | **1** | **`01`** | (none) |
| `AT&I1` | 0 | 0 | 0 | 0 | `00` | `OK` |
| `AT&I4` | 0 | 0 | 0 | 0 | `00` | `OK` |
| `AT&I8` | 0 | 0 | 0 | 0 | `00` | `ERROR` |

which is the `&T1` the 403 note pairs with `&L1` as the two command arming
routes.

**`&N1` then `&T1` publishes `0x10`.** One modem, 220M, no line:

```text
trace  cfgate 3  discrim 10  flagC 1  site_5a 1  send_10 1
tail   0077:0000  0076:0000  0004:0000  0010:5041  001f:0000  0019:0000
peek   [0x600]=01  [0x685]=01  [0x32c]=00
```

`0010:5041` is the datapump dispatch, reached for the first time in this
project: `&N1` clears the CF gate so the path falls through to the
discriminator, and `&T1` sets flag C so the discriminator answers not-equal.
Neither command alone does it - `&N1` alone publishes `0014`/`0017`, `&T1`
alone leaves the gate carrying.

Both are loopback and fixed-rate settings, so this says `0x10` is reachable and
says nothing about a leased line, which wants `0x5a` instead and already emits
it.

**Not yet on a leased line.** `--at AT&N1 --at AT&T1 --at AT&L1` on both ends of
a linked pair aborts the harness before the dispatch, in `bridge.py`'s
`_commit_rom_group`: `C51 ROM loader did not acknowledge strobe 1`. That is a
bridge limit on the reload `&T1` provokes, not a firmware branch.

Traced across a full leased pair (`--trace-pc`, both ends `AT&L1`, 156M):

| watch | answer | originate |
|---|---|---|
| CF gate `8b863` | 2 | 3 |
| discriminator `8b84f` | 11 | 11 |
| site `8bee8` | 0 | **1** |
| `send-10` `8bef5` | 0 | **0** |
| publish `8bef8` | 0 | 1 |
| site `884cb` | **1** | 0 |
| `send-14` `884d3` | **0** | 0 |
| `send-11` `884db` | **0** | 0 |
| overlay id 6 `8bbba` | 1 | 1 |
| `call-loader` `8b5d1` | 0 | **1** |

The leased path therefore gets *further* than the dial: `[0xe3c] <- 6` is
reached at `8bbba` on both ends - by the CF gate returning carry, which is the
route the 403 note describes - and the originating end enters the loader, which
a dial never does (`bootstraps: 1`, `call-loader` 0 in the dial table above).
The run reports `overlay_downloads: 2`, `overlay_id: 8`, `overlay_match: true`.

### There is nothing to model: `0x5a` is a datapump the DSP already runs

The DSP's receive dispatcher rejects a tag above `0x7f` and otherwise vectors
through its table - base `0x8401` on 302 (3.0.13), `0x83e9` on 403 (3.1.2), per
[dsp-map-302.md](dsp-map-302.md). `0x59` and `0x5a` are inside that range and
both have real handlers, where their neighbours `0x5b` and `0x5c` are the shared
no-op:

```text
tag 0x5a -> 8ddd            tag 0x59 -> 8df9
8ddd  splk @6f, #0040       8df9  splk @6f, #0043
8ddf  splk @6d, #8f14       8dfb  splk @6d, #8fd5
8de1  splk @6e, #01e0       8dfd  splk @6e, #01e0
8de3  call 8e59             8dff  call 8e59
8de5  splk @4b, #99a3       8e01  splk @4b, #99a3
8df3  splk @0b, #43bc       8e0f  splk @0b, #4c00
8df5  splk @44, #2000       8e11  splk @44, #4000
```

`@44` is the transmit carrier increment and `@6f` the marker cell, both from
[fsk-modulation.md](fsk-modulation.md), which reads `#2000` and `#4000` at
9600 Hz as 1200 and 2400 Hz - the V.22 originate and answer carriers - and
names `#0040`/`#0043` as the values entries reached outside the `9b42` path
write.

**This is not the V.22 datapump, and an earlier revision of this section was
wrong to say so.** Tracing a leased pair over the slot entries themselves -
`0xcc90`-`0xce20`, which holds V.22 `cd79`/`ccfa` and V.22bis `cd61`/`cce0` -
gives **zero** executed instructions on both ends, as do the two windows the
core traces unconditionally, `0xc700`-`0xca00` and `0x0200`-`0x0300`. Snapshot
the last 512 instructions with a whole-space range and the DSP is in
`0x8000`-`0x9900` throughout: hottest are `0x9856`/`0x9860`, a two-pole
resonator stepping a delay line, and `0x8b1a`, a polynomial sine with
`mpy #6487` - pi/2 in Q14. The DSP is running an **oscillator**, not a trained
datapump, so there is no receiver and nothing to report.

Read the dispatch again and that is what it says: `mov ax, 0x5a` is the value
already in `AX` *before* the gate, and the gate returning carry only skips the
`mov ax, 0x10` that would have replaced it. `0x5a` is the fallback the
supervisor sends when it does **not** start the datapump - not a leased-line
counterpart of `0x10`.

Both handlers execute, traced over a leased pair with `--dsp-trace-range`:
originate runs `8ddd` through `8df5` and the `splk @44, #2000`, answer runs
`8df9` through `8e11` and the `#4000`. `host_messages_delivered` is 37 on both
ends, the same as the count assembled. **The ASIC needs no new modelling for
`0x5a`** - the register filter never sees it, but delivery to the DSP is a
different path and already works.

### The transmit side was not rate-converted

Recording the pair's line audio and taking the spectrum of each end's transmit
found every tone at `8000/9600` of where it belongs:

| end | measured before | measured after |
|---|---|---|
| originate | `1000`, `750` | `930`, `1470` |
| answer | `1500`, `2040` | **`1800`**, `2130` |

The answer end's dominant tone moving `1500 -> 1800` is the clean result: the
raw stream really does hold 1800, and `1500` is `1800 * 5/6`. The resampler was
unit-tested on synthetic 1200, 1800 and 2400 Hz tones at 9600 and reproduces
each within one bin with artifacts 40x down, so the conversion is sound. Do not
read more than the scaling out of the other peaks: these are short windows on a
changing signal, and the earlier gloss of them as V.22 sidebands was over-read.

`_queue_line_audio` converts on the way in; `_service_line` took
`core.line_tx_samples` raw and put codec-rate samples on an 8000 Hz line.
`_take_line_audio` is the conversion the audio-only path already used;
`_service_line` now shares it, and buffers, because six codec samples are five
line ones.

This does not by itself produce `CONNECT`.

### Why the DSP runs an oscillator: one gate loads the datapump and suppresses its start

The datapump image is **loaded and never started**, and the same test decides
both, in opposite directions.

`&L1` sets `[0x5fa] = 1`; with `[0x5cd] & 0x40` clear and `[0x600]` zero the CF
gate at `0x8b863` returns carry. That carry reaches two sites:

| site | branch on carry | effect |
|---|---|---|
| `0x8bbaa` | `jae 8bbc2` **not** taken | falls into `mov [0xe3c], 6` - the loader runs |
| `0x8bee8` | `jb 8bef8` **taken** | skips `mov ax, 0x10` - publishes `0x5a` instead |

The first arms the datapump; the second declines to start it. Measured on a
leased pair: `overlay_downloads: 2`, `overlay_id: 8`, 18,692 and 18,788 overlay
words verified - so overlay 6 (V.34, entry `0x9d00`) and its chained overlay 8
really are resident - while the slot dispatch at `0x9b58`/`0x9b5c` **never runs**
and `0x9d00` is **never entered**. Only mailbox commands `0x10` and `0x11`
dispatch through the nine-slot table at `0x9b48`/`0x9b51` whose slot 0 is
`0x9d00`, and those are exactly the commands the carry suppressed. What the DSP
runs instead is tag `0x5a`'s handler: `@44` set, then the resident oscillator -
`0x984c`, a two-pole resonator, and `0x8b1a`, a polynomial sine.

Forcing the other side of the gate shows the halves are exclusive. `&T1`
**alone** publishes `0010:5001` - an earlier revision of this document said
neither command alone would do it, which was wrong; `&N1` only changes the data
word, to `5041`. The slot dispatch then **does** run: `0x9b58`, `0x9b5a`,
`0x9b5e`, `0x9b60`, the selector at `0x9b7e`, and on through `0x9b65`-`0x9b6b`,
so it passes the `retc ntc` and executes the `bacc` into a slot. But that run
has `overlay_downloads: 0`, so the slot is a resident one, and `0x9d00` is still
never entered.

> **Superseded (2026-09-16).** The halt described in this subsection no longer
> reproduces. A live co-simulation trace of standalone `AT&T1` shows the
> datapump running to steady state, resumed each frame by a scheduler this
> document had not yet located. The frame-depth fault the following paragraphs
> chase was resolved by the test-flag routing and overlay-frame work
> (`4772fbe`, `e30cd0a`, `1e982eb`, `c05645c`). The reading below is kept for
> the mechanism it documents; see
> **[The scheduler runs it, and the hybrid loops it back](#the-scheduler-runs-it-and-the-hybrid-loops-it-back)**
> for the current behaviour.

**And then the DSP dies.** A whole-space snapshot of the last 512 instructions
of an `AT&T1` run is one address, 512 times:

```text
065a  setc intm
065b  b 065b          ; <-- here, forever
```

That is the on-chip ROM's halt sink, and the six instructions above it are how
the ROM dispatches: `lacc #065a / rpt #07 / push` fills all eight hardware stack
slots with the halt address, then `lamm @7d / bacc` jumps to the handler. Any
`ret` out of a handler dispatched that way lands on `0x065a`, masks interrupts
and spins. So the DSP got the start command, selected a slot, entered it, and
returned - and the ROM treats a return as fatal.

This also explains the `_commit_rom_group` abort - "C51 ROM loader did not
acknowledge strobe 1" - when `&T1` is used on a linked pair: the DSP is wedged
with `INTM` set and cannot service the loader. A real Courier does not hang on
local analog loopback, so this is a fault in the model, not the firmware's
design, and it means `0x10` being published is **not** evidence that the
datapump ran.

#### The slot was 0, and it returns out of the overlay

Setting the trace to `0x9900`-`0xffff` - high memory, with the spin address
excluded so it cannot flood the ring - catches the last 210 in-range
instructions. They run `0x9d02`, `0x9d43`-`0x9d56`, `0x9daf`, `0x9e13`, and end
on `0x9e1e` with op `ef00`, a bare `ret`.

`0x9d00` is slot 0 of the table at `0x9b6c`: **V.34, overlay 6's entry.** And
with `AT&T1` alone the overlay really is resident - `overlay_downloads: 2` - so
this is the overlay's own code, not the base image's. 35 of the 126 distinct
addresses executed carry opcodes that differ from `dsp_program_segments`,
which is exactly what a loaded overlay should look like where it overwrote the
resident.

So the sequence is: `&T1` sets flag C, the discriminator answers not-equal, the
selection block at `0x8bc41` writes `[0xe3c] = 6` and the loader brings in
overlay 6; the supervisor publishes `0010:5001`; the DSP's selector picks slot
0; the `bacc` at `0x9b6b` enters `0x9d00`; and the overlay runs to `0x9e1e` and
**returns**. The ROM dispatched it with all eight hardware stack slots preloaded
with `0x065a`, so that `ret` is the halt.

#### It expects a deeper frame than the dispatcher builds

Decoding the control flow in that traced window answers it. The chain that
reaches the slot pushes **once**:

```text
80c8  call 839b        ; the only real frame - return address 0x80ca
839b  ... bacc         ; into the tag handler, tail-jump, no push
9b6b  bacc             ; into slot 0, tail-jump, no push
```

and the slot removes **twice**:

```text
9d00  call a0b6 / 9d43 call / 9d54 call / 9d62 ret
9e19  retc            ; not taken
9e1a  be32  pop       ; an explicit stack pop
9e1e  ef00  ret       ; and then a return
```

`pop` then `ret` consumes two stack levels for one entry. Over the whole
210-instruction window the imbalance is plain: **10 calls against 19 `ret`, 9
`retc`, 3 `retd` and 2 `pop`.** The `9e19 / 9e1a / 9e1e` sequence appears twice
in the tail, so the code goes round draining one more level each pass.

The C5x stack is eight deep and the model is faithful - `native/c5x_ops.ipp`
implements it as MAME does, circular over `m_pcstack[8]`, with `POP_STACK`
replicating the bottom entry the way the part does. So the extra removals walk
back through what the ROM left there: the eight copies of `0x065a` pushed by
`lacc #065a / rpt #07 / push` at startup. One of them is popped, and that is the
halt.

**So the overlay does expect a frame, and a deeper one than a plain
subroutine's.** The explicit `pop` at `0x9e1a` says its caller is supposed to
have pushed a word - a resume or continuation address - on top of the return
address. `bacc` at `0x9b6b` pushes neither. Whatever normally enters slot 0 is
not the tail-jump this path uses, and the ROM's fill-the-stack dispatch only
turns the resulting underflow into a halt instead of a wild branch.

#### The overlay is placed correctly; `entry_word` is the entry, not the base

`DspOverlay.entry_word` for overlay 6 is `0x9D00`, and an earlier revision of
this section read that as the load address, found every executed opcode
disagreeing with the payload laid out that way, and concluded the transfer was
misaligned by 76 words. That was wrong, and the `ff62` re-point and header
length are not at fault.

The load base is `0x9D00 - 76 = 0x9CB4`, and `0x9D00` is payload **word 76**.
The check is one word: payload word 76 is `0x7a80`, which is exactly the opcode
executed at `0x9d00`. Laid out that way:

| executed addresses (126 distinct) | |
|---|---|
| inside the overlay span, matching overlay 6 | 37 of 45 |
| outside the span, matching the base resident image | 81 of 81 |

The eight that still disagree - `0xada5`-`0xadaa` and `0xb058`-`0xb060` - hold
resident content inside the span, which is what the multi-base transfer this
file already describes should produce: the payload does not occupy one
contiguous run, so a single-base span over-claims its extent. `overlay_match`
and `overlay_downloads` were never the wrong check for placement in the way that
revision said; they simply do not speak to it either way.

#### What the overlay does at `0x9e1a`: it yields

Read at the correct base the code is unambiguous:

```text
9e18  lacc @34
9e19  retc lt          ; bail if @34 < 0
9e1a  be32  pop        ; discard one frame
9e1b  lacc #9dcf
9e1d  samm @6d         ; install 0x9dcf as the resume vector
9e1e  ef00  ret        ; and return through the next one
```

`pop` then `ret` is a **coroutine yield**: it throws away its own return address
and returns two levels up, leaving `@6d` pointing at where to resume. `@6d` is
the same cell tags `0x59` and `0x5a` write, so it is the scheduler's next-resume
vector, and something is expected to re-enter through it.

So the frame finding stands, on a correct base this time: the yield needs **two**
live frames above it, and the path that reaches it builds **one**.

```text
80c8  call 839b        ; the only push - return address 0x80ca
839b  ... bacc         ; tail-jump into the tag handler
9b6b  bacc             ; tail-jump into slot 0 at 0x9d00
9d00  call 8767        ; the overlay's own frame
      ... pop + ret    ; two levels removed
```

Net one level short, so the `ret` reaches past `0x80ca` into the stale `0x065a`
the ROM left, and halts. Either an intermediate transition should be a `call`
rather than a `bacc`, or `0x9d00` is the wrong door - the coroutine may be meant
to be resumed through `@6d` by a scheduler that enters at the right depth, with
`0x9d00` only its first-time entry.

### The scheduler runs it, and the hybrid loops it back

Traced live rather than statically: `CourierMachine(with_dsp=True)` on the
`dedicated-line` preset, `AT&T1`, 40M supervisor instructions, reading the C5x
`pc_trace` (windowed) and `serial_state` from `machine.dsp_bridge.core` just
before the bridge closes. Three facts overturn the halt above.

**A frame scheduler at `0x8767` resumes the coroutine.** It is the `@6d`
re-entry the frame finding predicted but did not locate:

```text
8767  lamm @6e         ; per-datapump frame countdown
8768  bcnd 876d, eq    ; zero? -> dispatch
876a  sub #01 / samm @6e / retc neq   ; else keep counting
876d  lamm @6d         ; load the resume vector
876e  retc eq          ; none installed -> return
876f  bacc             ; else RESUME at @6d
```

Over the last 512 in-window instructions the scheduler shows `0x8767`/`0x8768`
x102, and `0x876d`/`0x876e`/`0x876f` x102-103: `@6e` is zero so the `bcnd` always
dispatches, `@6d` is non-zero so `retc eq` never fires, and `0x876f bacc`
resumes the datapump ~103 times per window. Tags `0x59`/`0x5a` install `@6d`
this same way (`0x8ddf splk @6d, #8f14`) and **return**, letting the scheduler
enter their body later; the tag-`0x10` handler at `0x9b58` instead `bacc`s into
slot 0 once, cold - `0x9b58`->`0x9b60`->`0x9b62`->`0x9b64`->`0x9b65`->`0x9b6b`->
`0x9d00`, each x1 - and thereafter the body runs only through the `@6d` resumes,
never back through `0x9d00`. So the cold entry is the first-time door and the
scheduler is the steady-state driver, exactly hypothesis (b) above.

**No halt.** The DSP tail is live datapump math (`0x9fd6`-`0x9fff`, `mpy @0b` /
`lta` filter taps), not the `0x065a` spin. The overlay is entered once and kept
running.

**The hybrid loops the modulated output back to the input.** With the modem on
hook (`HYBRID_RETURN_ON_HOOK = 240`, `bridge.py`), one `AT&T1` run measures:

| signal | value |
|---|---|
| `line_tx_writes` | 23,996 |
| `line_tx_nonzero` | 14,026 |
| `hybrid_frames` | 89,967 |
| `hybrid_peak` | 12,123 |

The datapump modulates (14k non-zero line-TX samples - the QAM/TCM carrier) and
the trans-hybrid return feeds that DAC output back into the ADC input at full
level. This is the analog loopback `AT&T1` names, and it needs no line: the
`codec_rx` queue is empty (`codec_rx_queued: 0`), so the only thing on the
analog input is the hybrid's own return.

### But it does not demodulate: no receive-side state forms

The returned samples reach the DSP - `drr_reads: 23,988` at `codec_rx_peak:
24,246`, one read per frame - and the resident serial ISR at `0x8193`
(`last_drr_pc`) even stores each one into the receive buffer (`0x8194 sacl *+`).
So the demodulator is not starved of input. But nothing forms a receive state:

| indicator | value | reading |
|---|---|---|
| `negotiation_loop_entries` | 0 | the instrumented equalizer/training loop never runs |
| `v8_dispatches`, `v8_rx_state`, `v8_flags` | 0 | no V.8 handshake |
| `0x5e`/`0x5f` writes | `0x3d`, `0x04` (2 words) | two control words, no recovered-data stream |

**The received content does not change what the datapump does.** Forcing the
hybrid return off (`HYBRID_RETURN_ON_HOOK = 0`, silence on the ADC) against the
normal on-hook value (`240`, full carrier) and diffing `serial_state` at 40M:
only the sample-level registers move - `codec_rx_peak` 24,246 vs 0, `drr` 62,334
vs 0, and the frame counters drift a little because the two runs reach slightly
different depths. Every state cell is identical, and `v8_*` and
`negotiation_loop_entries` are 0 either way. A receiver that was demodulating
would diverge on carrier-detect, energy or lock between full carrier and
silence; this one does not.

**The demodulator runs but is gated off, and the gate is located.** The
per-frame datapump loop at `0x9daf` calls three routines synchronously -
`0x8837`, `0xa2a7`, `0x9e6b` - and `0xa2a7` is the receiver: a matched filter
(`lt @76` / `mpy @14` / `ltp @77` / `mpya` / `apac`) over the sample buffers.
But it stops at its own gate before the decision stage:

```text
a2c4  lar ar1, #6f
a2c5  bit 3, *        ; @6f bit 3?
a2c6  retc ntc        ; clear -> return before the decision/equalizer stage
```

`@6f` (absolute `0x6f`) is `0x40c2` for the whole run; a data-write trace of
`0x6f` shows every value it is ever given - `0x40c2`, `0x4040`, `0x4042`, `0` -
and **bit 3 is never set**. Bit 3 has exactly one setter, `0x8ca6 opl *,#0008`,
reached by exactly one route, `0xa437 call 8ca5`, inside the receiver-enable
block at `0xa430` (`call a440` / `call a5a5` / `apl @6f,#feff` / `call 8770` /
`call 8ca5`, then `@6d = 0xa478`). That block traces **x0 - it never runs.**

It never runs because the datapump's coroutine is stuck in acquisition. `@6d`
holds `0x9dcf` for the whole steady state, and `0x9dcf`'s handler `0x9e56`
releases only on a joint condition:

```text
9e5a  lacl @2c / bcnd 9e66, neq        ; countdown not expired -> yield
9e5d  lacc16 @00 / adds @02
9e60  sub #445c / bcnd 9e66, lt         ; received level below threshold -> yield
9e64  lacc @34 / retc lt                ; else advance (return into 0x9dd1..)
9e66  pop / lacc #9dcf / samm @6d       ; yield: reinstall 0x9dcf, stay put
```

Every stuck pass reinstalls `0x9dcf`. So the receiver front-end runs, the
modulator and hybrid deliver it a full-level signal, but the acquisition state
`0x9e56` never releases to the enable block `0xa430`, `@6f` bit 3 never sets, and
`0xa2a7` bails before it demodulates. **That is what breaks `AT&T1`:** its own
loopback carrier does not carry the acquisition state past `0x9e56` to arm the
decision stage.

The three inputs are now traced too. This routine runs with DP `0x300`, so its
cells are absolute `0x32c`, `0x300:0x302`, and `0x334`. The firmware initializes
`0x32c` to zero at `0x9e27`; the periodic path at `0x9f5d..0x9f5f` then explicitly
subtracts one, so the observed `0xffff`, `0xfffe`, ... sequence is firmware
behavior rather than a broken decrement opcode. The returned carrier does make
the level accumulator exceed the threshold (`0x05c2:0xe772` in the assisted
run), but the quality path at `0x9f87` only raises `0x334` to one or two before
the conditional clear at `0x9fa0` takes it back to zero. It never reaches the
negative state required by `0x9e65 retc lt`. Gain, zero-to-eight-frame delay,
and return-polarity probes did not change that result. The remaining fidelity
fault is therefore inside the emulated analogue acquisition signal, not the
located coroutine or the C5x decrement semantics.

For testing the DSP on both sides of the gate without pretending that fidelity
fault is solved, the harness now has an explicit diagnostic assist:

```sh
./courier run firmware/legacy-usrobotics/idsdl302/IDSDL302.ROM \
  --with-dsp --dip-preset dedicated-line --at 'AT&T1' \
  --dsp-acquisition-assist --instructions 39000000 --summary
```

It acts only after the command is known to be `&T1` and the run has proved at
least 64 non-zero TX samples, 64 returned hybrid frames, 1,000 DRR reads, and a
receive peak of `0x1000`. It then sets only `@6f` bit 3. The normal run remains
untouched. The report says `rx_acquisition_assisted: true`, `@6f` changes from
`0x40c2` to `0x40ca`, and a trace of `a2c0:a360` crosses `0xa2c6` into
`0xa2c7..0xa2cc`; without the option there are zero executions beyond the gate.
That makes the workaround falsifiable and keeps the matched filter and receive
decision code under test while the remaining analogue acquisition model is
being recovered.

This is the same "receiver condition" the next section reaches from the transmit
side; located here as the `0x9e56` acquisition gate.

### Why neither end reports a result code: the DSP never sends

A result code follows the DSP telling the supervisor what the link did. On 302
that return leg is: an enqueue into the outbound ring at `0x0bd0`, indexed by
`@78` (write) and `@79` (read); a drainer at `0x83d6` that the service loop
calls from `0x80ca`; and `out @7d, 005e` / `out @7d, 005f` to hand the two
halves over. Every stage was checked and the fault is at the top of it.

**The drainer runs and finds nothing.** Traced over a leased pair, `0x83d6` is
entered and returns at `0x83d9`:

```text
83d6  ldp  #000
83d7  lacc @79
83d8  sub  @78
83d9  retc eq      ; read == write: nothing queued
```

**Read that trace carefully.** `native/c5x_core.cpp:1027` keeps the *last* 512
records and drops the oldest, so the 512 entries it returned - 128 visits x 4
addresses - describe the end of the run, not all of it. What actually proves the
ring is always empty is a total, not a window: ports `0x5e`/`0x5f` show
**34 reads and 0 writes** - the reads are the DSP taking inbound tag and word
from `0xff5e`/`0xff5f` through the `0x23f0` helper, folded onto the same
register. The host-to-DSP direction works; the DSP-to-host direction has never
carried a word.

**The enqueue never executes.** Its entry is `0x83bd`, not the `0x83bf` that is
3.1.2's - the caller passes the word in the accumulator and `83bd` opens
`ldp #000 / sacl @7d` before the space check. Traced, `0x83bd`-`0x83d5` is
**never reached** on either end.

**It has exactly two callers**, and both are reporters:

| site | word loaded | tag |
|---|---|---|
| `0xd59d` | `lacc #8048` | `0x48` |
| `0xeb4b` | `lacc #801c` | `0x1c` |

Bit 15 is the ring's more-follows marker, which the drainer strips with
`and #7fff`. Tag `0x1c` is the one the supervisor's own inbound handler
collects: `0x8f499` is `cmp al, 0x1d / je`, `cmp al, 0x1c / jne`, and the `0x1c`
arm gathers data words into the buffer at `[0x14c]` indexed by `[0x24c]` while
`0x1d` sets `[0x24d]` bit 1 and arms the `[0x24f]` countdown. So `0x1c`/`0x1d`
are the report the supervisor is waiting on, and it is never sent.

**The driver above them is dormant too.** The `0x48` reporter is called from
`0xd4b4`, `0xd4d2`, `0xd4f7` (`call d58a`) and `0xd4eb`, `0xd50c`
(`call d595`). Tracing the whole `0xd4a0`-`0xd5a0` window over a leased pair
gives **zero entries** on both ends.

So the datapump is installed, both ends transmit the right carrier and hear each
other, and the DSP's entire status-reporting machinery is still asleep. What
wakes `0xd4a0` and `0xeb00` is the open question; it is a receiver condition,
one level in from anything this document has traced.

**One thing to distrust while chasing it.**
`runtime_inbound_delivered` reports `ffff:ffff` three times per run and
`dsp_messages_taken: 3`. Since the DSP has written those ports zero times, those
are phantom: `_dsp_completion_status` returns `status ^ 0x0006` under the ROM
profile, so a DSP that has sent nothing reads back as having completed a send.
Whether the inversion or the polarity is wrong is not established here, but the
three delivered words are not messages.

**The harness discards both words.** `bridge.py`'s `_observe_asic_command`
accepts `0x13..0x1f` and `0x7d..0x84` only, so `0059:715d` and `005a:704d` - the
last thing each end publishes - fall through it, along with the rest of the
leased setup block (`0x42`, `0x44`, `0x48`, `0x49`, `0x50` x6, `0x51`, `0x52`,
`0x53`, `0x71`, `0x76`, `0x77`). 302 never writes a header above `0x77` on any
path, and its own inbound dispatcher rejects one: `0x8f492` reads the header and
`cmp al, 0x76 / jb` drops everything at or above `0x76`. The `0x7d..0x84` window
is main211's, and on this image it is empty in both directions.

## Solved along the way: why 403 sent a zero tone level

403 originally put 66,251 samples of pure silence on the line where 302 put
DTMF. Every stage was checked and every stage was correct - the tag `0x13`
handler at `0xee20` arms the oscillator from the right table entry, the phase at
`0x3c0` advances by exactly the loaded increment, the pair generator at `0x8743`
accumulates a waveform into `0x3c7`, and the ISR's sixteen-slot ring at
`0x0bc0`..`0x0bde` is written and read by both ends correctly.

The signal died at `80db  mpy @12` - the accumulator times the gain at `0x392`,
which was zero. The supervisor genuinely enqueued zero, and the value is not
computed at all:

```text
a0ab1   mov bx, word ptr [0x0cd9]   ; -> mailbox tag 001a -> DSP 0392
a0ac4   mov bx, word ptr [0x0cdb]   ; -> mailbox tag 001b -> DSP 03f1
```

Read off the running board, those cells hold `32c8` and `0c08` - the same two
values 302 sends. The full chain is **EEPROM -> RAM `0x071b` -> scattered by
`c9aa6` -> `0cd9`/`0cdb` -> mailbox tags `1a`/`1b` -> DSP `0392`/`03f1`**, and
`0x071b` is the +S extended register block `courier_emu/nvram.py` already models
as `IDSDL302_EXTENDED`, whose words at block offset 23 and 25 are exactly those.

**The gap was an EEPROM offset.** 7.3.14 stores the block from the high byte of
EEPROM word `0xc1`; 7.4.16 stores it five words later, from word `0xc6`. Running
403 against the 302 fixture landed block offset 10 at RAM `0x071b` where the
board lands offset 0:

```text
board  071b: 46 00 00 00 0a 23 04 ff 09 7d 4b 00 0d 02 00 06 ...
emu    071b: 4b 00 0d 02 00 00 40 94 11 00 40 0d 02 c8 32 08 ...   (= ref[10:])
```

The block's trailer confirms the alignment: 302's last two bytes are ASCII `"02"`
closing a `"3.02"` version string; the board's are `93 01` - `0x0193`, 403.

`CourierNvram.idsl403_fixture()` seeds the board's own block at that offset and
`--nvram-fixture idsdl403` selects it:

| observation | 403 before | 403 with the fixture |
|---|---|---|
| datapump transmit peak | 0 | **22,764** |
| digits decoded off the line | `""` | **`6245`** |
| DTMF blocks | 0 | 137 |
| exchange outcome | - | `answer`, state `ringback` |
| tag `0019` | `c802` x6, `0400` | `020d` x7 |
| tag `001a` | `0000` x4 | **`32c8` x4** |
| tag `001b` | `0000` x4 | **`0c08` x4** |
| tag `001f` | `0032` x6 | `0000` x6 |

The settings records are a separate question and the five-word shift does
**not** extend to them: both builds keep them at EEPROM word 94. The two
firmwares cache the part at different RAM addresses - 7.3.14 copies words
94..102 to `0x0752`, 7.4.16 copies the whole 512-byte part to
`0x058e..0x078d`, so the same words land at `0x058e + 188 = 0x064a`. Decoded
there they give six unanimous 3-of-3 records:

| setting | 1 | 2 | 3 | 4 | 5 | 6 |
|---|---|---|---|---|---|---|
| 403 (`IDSDL403_NVRAM`) | `0x00` | `0x1f` | `0x07` | `0x1e` | `0x00` | `0x00` |
| 302 (`IDSDL302_SETTINGS`) | `0x00` | `0x1e` | `0x07` | `0x1e` | `0x00` | `0x00` |

One bit of setting 2 apart, which is what the shared 20.16 MHz hardware
predicts. Reproduce with `courier_emu.ram_dump.decode_settings` over
`IDSDL403_NVRAM[0x064a - 0x058e:][:18]`.

## Solved along the way: host-message delivery

Delivery used to be triggered by the supervisor's `0x1C` bit 0 acknowledgement
acting on a latch pair that the `0x58`/`0x5a` and `0x5c`/`0x5e` writes updated
independently. An acknowledgement landing between those two pairs delivered a
**new tag with the previous message's data**, and one arriving when no new
message had been assembled re-delivered the stale latch - which is why both
images delivered more messages than they assembled (403: 68 assembled, 70
delivered; 302: 66 and 68).

The `0x5E` write - the message's last byte - now latches `_runtime_pending`, and
the `0x1C` commit delivers that pair and clears it. Assembled and delivered now
agree on both images, and 302 is unchanged in behaviour.

This fixed a real defect and did **not** fix the 403 tone, because the tone was
never a delivery problem. See the EEPROM offset above.

## A separate gap: the parameter sector is absent

`ATI7` on the hardware ends with a line the emulator does not print:

| field | board 4.03d | emulator, 302 + fixture |
|---|---|---|
| Product type | Russia (ex. US/Canada) External | US/Canada External |
| Supervisor rev | 7.4.16 | 7.3.14 |
| DSP rev | 3.1.2 | 3.0.13 |
| **Serial Number** | `0009540034268322` | **line absent** |

The serial number lives in the parameter sector, not NVRAM, and no dial run
passes `--parameter-sector` or `--parameter-flash`. Supplying one restores the
line. It does not affect the datapump gate. (`courier_emu/parameters.py` is a
211-only store; 302/403 have no equivalent modelled.)

The `Options` line is identical on both, so the unit's V.34/V.90 entitlement is
not what refuses the overlay.

## Ruled out - do not re-run these

**The profile hypothesis.** The three flags are not profile-derived. `AT&F`
loads the ROM defaults into the working profile the call actually uses, and the
gate does not move:

| run | `call-loader` `8b5d1` hits |
|---|---|
| `ATDT6245` | 0 |
| `AT&F` then `ATDT6245` | 0 |
| `--parameter-sector` with serial and V.34/V.90 feature bits | 0 |

**Uninitialised RAM.** The emulator's RAM is `0xff`-filled, not zeroed, so the
`00`s a 302 run reads at `685`, `5cd`, `5a5`, `5fa` and `600` are the image's own
data initialisation rather than a missing write. Watching all seven
`mov byte [0x685], 0` sites and both `and [0x5a5], 0xfe` sites across a full
dial gives zero hits on every one: they start at zero and nothing clears them.

**Applying 302 addresses to a 403 run.** This cost several revisions of this
document. 403's message ring is at `[0x194]` wrapping at `0x1c8`, not
`[0x29a]`/`0x2ce`; watching `29e` on a 403 run reads unrelated variables and
looks like a scribble. The DSP dispatch table read at program `83e9` is 3.1.2's
address, so reading it against 302 returns `8179`, inside the serial ISR, and
means nothing. **On this pair of images an address is only meaningful with its
image named.**

**Blaming the delivery path for the zero gain.** It carried the zero faithfully
at every hop. The `32c8` once attributed to a 403 run was read off a 302 run.

**Three mangled-looking words** - `0032`, `c802`, `0400` - at DSP 40.6M are not a
corrupted `32c8`. The tag `0x1a` handler does not run until 51.28M; they belong
to other tags.

## The 403 board ROM: the whole chain, and the flag that is never set

Disassembled from `artifacts/courier-board-21210-capture-403/courier-board.rom`,
with the branch measured rather than assumed.

**The reset belongs to the downloader.** Every edge of the DSP reset net comes
from one routine, entered at `0x8e3da`:

```text
8e429  mov bx, 0xff56
8e42c  mov ax, [bx]
8e42e  or  ax, 2          ; bit 1 held HIGH
8e433  and cx, 0xfff7     ; bit 3 cleared
8e436  mov [bx], ax
8e43a  mov [bx], cx       ; assert
...
8e43d  or  ax, 8          ; release after a 5-iteration delay
8e445  mov [0xff56], ax
8e44a  ...                ; poll 18/1a/1c/1e for all-ones, clc on success
```

So on this image the pulsed bit is **3**, with bit 1 held high - `machine.py`'s
`ROM_DSP_RESET_BIT = 0x0008` is right here, and the "bit 1" this repository
records elsewhere belongs to a different image.

**There is exactly one download call site.** `0x8e4ab` is the transfer body and
`0x87567` is its only caller:

```text
87551  mov word ptr [0x192], 0x110
87558  call 0x8e3a0
8755b  mov ax, 0x8000      ; the resident's entry
8755e  call 0x8e3da        ; reset + verify
87564  mov cx, 0xdd4e      ; 56,654 bytes, the resident's exact length
87567  call 0x8e4ab
```

**Overlays go through a different loader**, at `0x8e60c`, driven by a request
cell:

```text
8e61c  mov al, byte ptr [0xd28]   ; the overlay index
8e622  mov bl, 6 ; mul bl         ; six-byte rows at 0xe741
8e631  mov al, 4 ; out 0x1e, al   ; transfer-start strobe
8e638  lcall 0x8f46, 0x1e4        ; the destination
8e63d  mov byte ptr [0xd27], 0xc8 ; 200-tick timeout
8e642  test [0xd27], 0xff ; jne 8e64c
8e649  jmp 0x8e73a                ; timed out: abort, and clear 0xd28
8e64c  in al, 0x1e ; and al, 4 ; cmp al, 4 ; jne 8e642
```

`[0xd28]` is written at six sites: index 5 at `0x8b7db`, 6 at `0x8bc06` and
`0x8bc8d`, 7 at `0x8bc99`, 8 at `0x8e616`, and 0 at the abort.

### Measured: the request sites are never reached

A 403 pair, `--answer-on-ring`, counting 80186 addresses:

| address | what it is | A | B |
|---|---|---:|---:|
| `8bbf6` | `call 0x8b8a1` | 1 | 1 |
| `8bc0e` | `call 0x8b88d` | 1 | 1 |
| `8bc13` | `jmp 0x8bc9e` | **1** | **1** |
| `8bc06`, `8bc8d`, `8bc99` | request overlay 6/6/7 | **0** | **0** |
| `8e61c` | the overlay loader | **0** | **0** |
| `8e73a` | the loader's abort | 0 | 0 |

Both ends take the same path and jump over every overlay request. The loader
never runs, so it never times out either - nothing is waiting on the port `0x1e`
ready bit, because nothing ever strobes for it.

### The gate is three flags, and only one of them has a setter

`0x8b88d` returns the zero flag from the last of three tests, and the caller
loads a datapump only when one is set:

```text
8b88d  test byte ptr [0x98a], 2 ; jne 8b8a0
8b894  test byte ptr [0x49e], 1 ; jne 8b8a0
8b89b  test byte ptr [0x57c], 1
8b8a0  ret
```

Searching every write to those three cells in the ROM:

* `[0x98a]` - only `or 0x10` and `and 0xf1`/`0xef`. **Bit 1 is never set.**
* `[0x49e]` - only `and 0xfe`, twice. **Bit 0 is never set.**
* `[0x57c]` - bit 0 is set in exactly one place, `0x8770f: or byte ptr [0x57c], 1`.

So one instruction in the image enables a datapump load, and reaching it is
reached from one place only: `0x87626`, which is entry **1** of a table of
four-byte `call handler ; retf` thunks based at `0x87622`.

```text
87622  call 0x87642 ; retf    index 0
87626  call 0x876fb ; retf    index 1   -> or [0x57c], 1
8762a  call 0x8771f ; retf    index 2
8762e  call 0x8773c ; retf    index 3
```

and `0x876fb` itself branches on one more bit:

```text
876fb  test byte ptr [0x237], 4
87700  je 0x8770f              ; clear -> or [0x57c], 1   (datapump)
87702  or [0x225], 0x80 ; or [0x57c], 0x40                (something else)
```

**So the question "why does the originating end never transmit" reduces to a
single event: dispatch index 1 never fires.** Not the reset, not the line, not
the cursors, not the image layer. The next step is to find what drives that
dispatcher - the table base `0x87622` is not referenced as a literal word
anywhere, so it is computed, and that computation is what to find.

### Index 1 is not refused - the dispatcher never runs

Following the chain up from `or [0x57c], 1`:

```text
87626  call 0x876fb ; retf        entry 1 of four-byte thunks based at 87622
a6b88  lcall 0x8000:0x7626        entry 1 of six-byte thunks based at a6b82
a6b69  jmp word ptr cs:[bx+0x1d50]   bx = al*2, table at a6b70 in CS a4e2
a6afe  the command dispatcher, al = the command code
```

The jump table's entries are `1d62, 1d68, 1d4e, 1d6e, 1d74, ...`, so command 1
vectors to `0x1d68` - `a6b88` - and command 2 vectors to `0x1d4e`, the
`stc ; ret` that means "not handled".

The dispatcher screens the code before it vectors:

```text
a6b05  test byte ptr [0xd93], 1 ; je a6b16
a6b0c  cmp al, 1 ; je a6b14     ; with that bit set, command 1 is refused
a6b16  cmp al, 9 ; jae a6b6e
a6b3b  cmp al, 6 / 7 -> reject
a6b43  cmp al, 0 / 4 / 5 -> vector immediately
a6b4f  test [0x57c], 7  ; jne a6b6e
a6b56  test [0x98a], 0xe ; jne a6b6e
a6b5d  test [0x49e], 1  ; jne a6b6e
a6b64  cbw ; mov bx, ax ; shl bx, 1 ; jmp cs:[bx+0x1d50]
```

Read at the end of a 403 dial, both ends: `[0xd93]` is `00` on the originator
and `02` on the answerer - bit 0 clear on both - and `[0x57c]`, `[0x98a]` and
`[0x49e]` are all `00`. So every guard is open and command 1 would vector.

**It never arrives.** Counting execution of `a6afe`, `a6b64`, `a6b6e`, `a6b14`,
`a6b88` and `87626` over a full call gives **zero on both ends for every one of
them**. The dispatcher is not rejecting the command; nothing calls the
dispatcher at all.

So the datapump chain is intact and unreached from its very top. The
dispatcher is itself entry `0x1cde` in a table of handler offsets in CS `a4e2`,
around `0xa66ab` - `1ca9, 1cde, 1d94, ...` - and what drives *that* table is
the next thing to find. No branch or far pointer anywhere in the image targets
`a6afe` directly, so it is reached through that table rather than by a call.

### What drives the table: the `AT&` command parser

The handler table is at `cs:0x1865` in CS `a4e2` - physical `0xa6685` - and
`0xa4f63` is the only thing that indexes it:

```text
a4f3c  cmp al, 0x26        ; '&'
a4f3e  jne 0xa4f6c         ; not an & command
a4f42  lodsb               ; the letter after '&'
a4f53  cmp al, 0x41 ; jb reject
a4f57  cmp al, 0x5a ; ja reject
a4f5e  sub bl, 0x41        ; index = letter - 'A'
a4f61  shl bl, 1
a4f63  call word ptr cs:[bx + 0x1865]
```

So it is the **`AT&` command table**, twenty-six entries, one per letter. It
reads as one: `&A` `a66b9`, `&D` `a674b`, `&H` `a688e`, `&S` `a6ac9`,
`&Z` `a6ce0`, with `&E`, `&O`, `&Q` and `&V` sharing the `a6780` stub. A
sibling table at `cs:0x21ff` covers the lowercase forms.

Entry 19 is `&T`, and entry 19 is `0xa6afe` - the dispatcher this document
has been tracing. Its `al` is `&T`'s numeric argument, so the chain is:

```text
AT&T1 -> a6afe -> jmp cs:[bx+0x1d50] entry 1 -> a6b88 -> 87626
      -> 876fb -> or [0x57c], 1 -> 8b88d passes -> 8bc06 -> [0xd28] = 6
      -> the overlay loader at 8e60c
```

**Run with `AT&T1` and it all fires.** One dial's worth of counters on the
originating end:

| probe | count |
|---|---:|
| `a6afe` dispatcher | 1 |
| `a6b88` thunk index 1 | 1 |
| `87626` table index 1 | 1 |
| `8770f` `or [0x57c], 1` | 1 |
| `8e61c` overlay loader | **2** |
| `overlay_downloads` | **2**, `overlay_id` **8** |

Overlay 8 is the sync datapump, and it downloads. So nothing in this chain is
broken, in the firmware or in the harness: the port `0x1e` handshake, the
destination mailbox, the loader's timeout and the transfer all work when the
path is taken.

They are simply not taken by `ATDT`. This confirms from the other direction
what this document records at the top - that a plain dial does not reach the
loader and only the leased and `&T1`/`&L1` configurations do. The originating
end's silence on a dialed call is therefore not a missing trigger inside this
chain; it is that a dialed call loads its datapump some other way, and that
way has not been found yet.

## The normal call-state route: DSP tag `0x47`

The missing route is downstream of dialing, not in the `AT&` table.  During a
normal call the supervisor is in its off-hook state (`[0x192] = 0x5742`).  That
state's event table at `0x94ba2` accepts DSP tag `0x47`; its handler at
`0x94d83` takes the accompanying byte as the requested overlay number and
feeds the same loader at `0x8e60c`.  The answer resident emits `0x47:0007`.
The corresponding originating request is `0x47:0006`, and overlay 6 chains
to overlay 8 just as it does in the `AT&T1` control path.

The bridge now supplies that missing C51/ASIC event only when the modeled call
state says all of the following are true:

- the DAA has progressed from seizure to `dialing`;
- the line has a peer off hook; and
- the DSP is still running its boot resident.

This deliberately does not inspect the AT command text to choose an overlay.
It also distinguishes the pre-digit `originate` interval from an established
leased-line originate, so an already-off-hook answer peer cannot start the
datapump before the digits have gone out.

Call-start tag `0x17` and ready tags `0x02`/`0x03` are held until overlay 8 is
installed.  At the final hardware boundary, if the resident has already
entered its continuous frame loop and does not return to ASIC service routine
`0x811b`, the bridge performs the pending four-word BLDP transaction itself.
The source bytes remain the ASIC holding registers, the destination remains
DSP cell `0xff62`, and the completed program RAM is still checked byte-for-byte
against the selected ROM overlay.

Verification on the 403 image:

| scenario | requested/installed | destinations | verified words | result |
|---|---|---|---:|---|
| `AT&T1` control | 6 then 8 | `0x9d00`, `0xdc00` | 20,096 | exact match |
| linked `ATDT5551234` / `ATA` | DSP event `0x47:0006`, then 6 and 8 | `0x9d00`, `0xdc00` | 20,096 | exact match; tag `0x17` released |
| linked leased originate/answer | existing leased route, overlay 8 on both ends | `0x9d00`, `0xdc00` | 20,096 each | exact match; tags `0x59`/`0x5a` preserved |

Thus `AT&T1` remains a control case rather than the implementation path for a
dialed call: both converge on the supervisor loader, but only the normal
off-hook state consumes the DSP's `0x47` overlay request.
