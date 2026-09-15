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

## On a leased line the same sites publish `0x5a` and `0x59`

The section above answers the dial. `&L1` takes a different branch of the same
instruction, and it is the branch nobody had traced.

Both dispatch sites are three-way, and both publish `[0x0281]` as the data word:

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

That is the thing to fix or to model next: what pushes the word the overlay
pops.

**A caution about the windows in this document.** "`0x9d00` never entered", said
earlier, came from a trace range that stopped at `0x9d20`; the overlay's code
runs past it. Three of the ranges used here were too narrow to see what they
were meant to rule out. A negative from `--dsp-trace-range` only means *nothing
in that window ran* - and the ring keeps the last 512 records, so a positive can
be a tail. The leased-side claim is not affected: it rests on a whole-space
snapshot whose highest address is `0x9893`.

The leased case is different and is not this: its whole-space snapshot spreads
over `0x8000`-`0x9900`, 346 distinct addresses, with the DSP alive throughout.

**The likeliest missing piece is `[0x05cd]` bit 6.** The gate is evaluated twice,
at `0x8bbaa` and again at `0x8bee8`, so an input that changes in between gives
carry at the load and clear at the dispatch - which is exactly the combination a
leased call needs. `[0x5cd]` bit 6 is such an input, and it is settable:
`or [0x5cd], 0xc0` at `0xc9114` and `0xc9134`, `or 0x60` at `0xc9154`, inside
far-called routines that also set `[0x5a2]`, `[0x5b0]`, `[0x5b7]` and `[0x5cb]`
- a profile block. None of them runs in any run here and `[0x5cd]` measures `00`
throughout.

A second candidate is that something sends `0x10` once the overlay reports
ready. Worth knowing while testing it: **DSP-originated messages differ by
harness path**. The same leased pair run with `--line-audio-only` reports
`dsp_originated_messages: 1`, tag `006b:4321`, on both ends; the default path
reports **0**. The default path is also the one that delivers 37 host messages
including the `0x5a` that installs the oscillator, so this is not by itself a
harness fault - but any test of the arming route has to account for it.

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
