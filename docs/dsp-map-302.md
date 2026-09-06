# The DSP mailbox map for IDSDL302.ROM only

**These addresses are `IDSDL302.ROM` (DSP 3.0.13) and nothing else.** They are
not the ones in [who-produces-the-events.md](who-produces-the-events.md), which
were read off `artifacts/courier-board-21210-capture-403/courier-board.rom`
(DSP 3.1.2). The two builds differ in more than offsets - they use different
cells and a different ring - so transplanting an address between them produces
a probe that reads the wrong memory and reports nothing, which is exactly the
mistake this file exists to prevent.

Everything below is anchored on the one `out *, 0060` in the image, at file
`0x299ee`, which `dsp_mailbox.py` names as the 3.0.13 sender at DSP `0x84b7`.
Addresses are DSP program words; the linear file mapping is
`dsp = (file / 2) - 0x14CF7 + 0x84b7`.

## The map

| what | 302 (3.0.13) | 403 (3.1.2) |
|---|---|---|
| status latch, read through AR1 | **`0xFF57`** | `0x57` |
| tag cell | **`0xFF5E`** | `0x5E` |
| word cell | **`0xFF5F`** | `0x5F` |
| cell-read helper | `0x23f0` | `0x80e8` (`lamm *`) |
| service loop | `0x80c8` | `0x80bb` |
| receive dispatcher | `0x839b` | `0x8387` |
| dispatch table base | `0x8401` | `0x83e9` |
| outbound ring base | **`0x0bd0`** | `0xff60` |
| ring write / read pointers | `@78` / `@79` | `@78` / `@79` |
| message sender | `0x83d6` | `0x83d6` |
| stream resume poll | `0x847a` | `0x8462` |
| stream vector cell | `0x039e` | `0x039e` |
| tag-06 handler | `0x8489` | `0x8470` |
| stream sender | `0x84b7` | `0x849e` |
| packer | `0x84bc` | `0x84a3` |
| idle wait | `0x8149` | `0x8138` |
| frame ISR entry | `0x816b` | (not located) |

The status bits are the same in both: bit 15 a message is pending, bit 14 the
send window is free, bit 13 resume the stream; and the DSP writes `1` to
acknowledge a receive, `2` to complete a send, `4` for a stream word.

## The dispatcher, at 0x839c

```
839d  calld 23f0, * / lar ar1, #ff57   ; read the status latch
83a3  bit  15, @7d / retc ntc          ; nothing pending
83a6  calld 23f0, * / lar ar1, #ff5e   ; the TAG
83ad  calld 23f0, * / lar ar1, #ff5f   ; the WORD  -> @7a
83b3  lacl #01 / samm @57              ; acknowledge
83b6  sub  #7f / retc gt               ; reject above 0x7f
83b8  add  #00008480 / tblr @7c        ; table base 0x8480 - 0x7f = 0x8401
83bc  bacc
```

Table entries confirm the identification against constants this repository
derived from hardware: tag `0x06` to `0x8489`, and tag `0x42` to **`0xb05e`**,
which is exactly the "Tag 42's handler at b05e" in `dsp_mailbox.py` - so that
comment describes 3.0.13, not 3.1.2.

## The service loop, at 0x80c8

```
80c6  call 8223, *
80c8  call 839b, *, ar1     ; the receive dispatcher
80ca  call 83d6, *, ar1     ; the message sender
80cc  call 847a, *, ar1     ; the stream resume poll
80ce  call 80f8, *
80d0  lar  ar0, @10 / cmpr eq
80d2  bcnd 80c8, tc         ; loop
```

Same three calls per iteration as 3.1.2's loop at `0x80bb`. Note the dispatcher
entry is `0x839b`, one word before the `setc intm` this document first quoted -
`ldp #000` comes first, as it does in 3.1.2.

**The DSP does not reach it.** Sampling the core's PC across a run puts nothing
at `0x80c8`, `0x839b`, `0x83d6` or `0x847a`, and the run's own `idle` wait poll
at `0x814d` collects 237 samples while `0x80ac`, in the call sequence before
the loop, collects 26.

One caution on reading that histogram: its largest entries are an artefact.
`0x801d` takes 1617 of 3999 samples, `0x8024` 406, `0x8028` 207 - but those are
the reset prologue's block clears, `rptz #03ff` / `sach *+` and friends, where
one instruction repeats 1024, 256 and 128 times. A sampler lands there in
proportion to the repeat count. It does **not** mean the part is resetting over
and over: a run creates the core once and bootstraps once.

> **Corrected.** The last sentence is right about the harness and wrong about
> the part. The harness bootstraps once, but the *firmware* was re-entering its
> own reset prologue - four passes in 200k instructions, forty in 2M - because
> the helper copied into `0x23f0` was three zero words. With the shared external
> window below it now models, the prologue runs once. The `idle` at `0x814d`
> that this section reads as a failure to reach the loop is where a correctly
> booted part waits.

## Two things this map exposes

**The delivery this harness performs cannot work on 302.** `_deliver_host_message`
writes cells `0x5e`, `0x5f` and `0x57`, which is right for 3.1.2, where the
helper is `lamm *` and masks the address to `0x7f`. On 3.0.13 the dispatcher
reads `0xFF5E`, `0xFF5F` and `0xFF57` through a different helper. Writing the
low cells leaves the ones it reads untouched, which is why every 302 run showed
the tag and word arriving and bit 15 never being consumed.

Note also that 302 *writes* its acknowledgement with `samm @57`, which masks to
`0x0057`, while it *reads* the same latch at `0xFF57`. On the part those are
presumably the same register seen twice; in a flat model they are two
locations, so a DSP acknowledgement would not be visible to the DSP's own read
path either.

**Some handlers are outside the loaded segment.** The 302 image's one segment
is origin `0x8000`, 27710 words, spanning `0x8000..0xec3d`. The dispatch table
points below that: tag `0x7c`, the detector poll, to `0x23f0`, and tag `0x7b`,
the DAA identity, to `0x7e80`. The cell-read helper the dispatcher itself calls
is that same `0x23f0`. So on 302 the mailbox path calls into program memory no
overlay in the image provides.

That contradicts the conclusion in the other note that a ROM needs nothing
below `0x8000`, which was reached from the overlay entry words alone. Both
observations are recorded; which is wrong is not resolved here.

## What fills the SARAM

The prologue does, with a block move, and the three words it copies are the
mailbox helper itself:

```
80a0  lacc #000023f0
80a2  samm @1f          ; BMAR = 0x23f0
80a3  mar  *, ar1
80a4  lar  ar1, #80f5
80a6  rpt  #02          ; three words
80a7  bldp *+           ; data 0x80f5.. -> program at BMAR
```

and at `0x80f5` in the downloaded image:

```
80f5  1080  lacc *
80f6  0880  lamm *
80f7  ef00  ret
```

`lacc * / lamm * / ret` is exactly the cell-read helper the dispatcher and the
resume poll `calld` at `0x23f0` on every pass - and 403 needs no copy because
it keeps the same helper in-bank at `0x80e8`. So SARAM is filled by the
firmware reading its own downloaded program **through data space** and writing
it into program space.

### The external RAM answers both spaces, and the earlier retraction was wrong

`bldp` sources from data memory, so a data read of `0x80f5` has to return what
the download put at program `0x80f5`. An earlier attempt at that reported a
regression and was reverted; the measurement it asked for has now been taken,
and it says the opposite.

Logging every data access at or above `0x2c00` with its PC, across a 2M
instruction standalone run of the 302 resident, gives **twenty-five sites and
no more**:

| PC | addresses | direction |
|---|---|---|
| `0x8070`-`0x8081` | `0xfff0`, `0xfff3`, `0xfff4`, `0xfff6`, `0xfff7` | writes |
| `0x80ac` | `0xff51`-`0xff5f`, sixteen cells | writes |
| `0x80a7` | `0x80f5`, `0x80f6`, `0x80f7` | **reads** |
| `0x0bf7`, `0x0bf8` | `0xff60`, `0xff61` | reads |

So in `0x8000`-`0xfeff` the firmware performs exactly **three** data accesses,
all reads, all the `bldp` at `0x80a7`. There is no second read that "must not
return program words": there is no second read at all. Everything else above
`0x2c00` is at `0xff51` and up, which is the ASIC window the firmware reaches
through DP `0x1fe`/`0x1ff` - and that is where the shared window has to stop.

With `0x8000`-`0xfeff` backed by the program storage in both spaces, the
`bldp` reads `1080 0880 ef00` - `lacc * / lamm * / ret`, the helper this
document predicted - instead of three zero words, and the part's behaviour
changes completely:

| | prologue passes in 200k instructions | ending PC | SARAM fetches | external program fetches |
|---|---|---|---|---|
| before | 4 | `0x814d` | 1,373,184 | 16,281,745 |
| after | **1** | `0x814d` | 7,155 | 67,128 |

The "before" column is a runaway. Copying zeros into `0x23f0` makes the
dispatcher's `calld 23f0` execute nothing, the part falls off into unloaded low
memory - the 20M-instruction bridge run ends with its PC at `0x0115` - and it
re-enters its own reset prologue over and over. That, not a healthy run, is
what the earlier note recorded as "running across its prologue", and reaching
`idle` at `0x814d` was the improvement it mistook for a regression.

After the change the 302 resident boots **once**, executes its real helper out
of SARAM, and parks in the `idle` at `0x814d` waiting for an interrupt - which
is the correct place for a part whose service loop is entered from a frame ISR
that nothing in the harness yet delivers.

403 is unaffected in both directions: its `data_shared` count is zero and its
run is identical either way, because it keeps the same helper in-bank at
`0x80e8` and never reads program space as data. That is the prediction this
document already made, now measured.

**What is still not settled** is the window's exact edges. The evidence bounds
them only between `0x80f7` and `0xff50`; `0xfeff` is chosen because the
firmware's own ASIC pages are `0x1fe`/`0x1ff`, not because a read distinguishes
`0xfeff` from `0xfe00` or `0xff00`. Nothing in either build reads or writes
data between `0x8100` and `0xff50`, so no run this harness can perform will
narrow it further; that needs the board.

## The 0x8000 in these addresses is not independently established

`0x8000` is also where the *CPU's* flash lives - physical `0x80000`, segment
`0x8000` - and the two uses have not been kept apart.

* `CourierRom.dsp_download` **filters** on `DSP_ENTRY_WORD = 0x8000` and
  discards any candidate whose entry word is anything else, so the ROM path's
  origin is an assumption the scan enforces, not a measurement.
* `main211.xmf`'s segments are worse. Its first segment is loaded at origin
  `0x0000`, but the code in it is linked for `0x8000`: the stream sender sits
  at word offset `0x05d5` and the instructions around it read

```
05cb  bd    85d5, *
05cf  calld 85da, *
05d1  splk  *, #85c9
05d5  out   *, 0060
```

  Branch targets `0x85d5`, `0x85da` and `0x85c9` against offsets `0x05xx`. The
  third segment, the one actually labelled origin `0x8000`, holds different
  content and contains no sender at all - the first 4096 words of the two
  agree in 11 places.

So the harness's segment origins do not match the link addresses in the code,
in both directions. Either an origin is wrong, or the DSP's program space
ignores A15 and every label here is only meaningful modulo `0x8000`.

The one strand that does not depend on the harness is `dsp_mailbox.py`'s
constants - the sender at `84b7`/`849e`, the table at `8401`, tag `0x42`'s
handler at `b05e` - which were taken through the `ATGLK2` monitor on a physical
modem. Those agree with the addresses used throughout this document. Whether
they were read back by address from the part, or derived under the same origin
assumption, is not recorded, and settling that would settle the rest.

## What this does not establish

The map is static: every address was read from the image, and only the sender
at `0x84b7`, the tag-`0x06` handler and tag `0x42` are corroborated by
constants taken from hardware. Nothing here was executed. The frame ISR entry
at `0x816b` is inferred from its position after a `ret` and its `smmr` context
save, not from an interrupt observed reaching it. The helper at `0x23f0` could
not be disassembled - it is outside the segment, so the linear file mapping
does not reach it - and what it does is assumed from its callers.
