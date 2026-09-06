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

## What this does not establish

The map is static: every address was read from the image, and only the sender
at `0x84b7`, the tag-`0x06` handler and tag `0x42` are corroborated by
constants taken from hardware. Nothing here was executed. The frame ISR entry
at `0x816b` is inferred from its position after a `ret` and its `smmr` context
save, not from an interrupt observed reaching it. The helper at `0x23f0` could
not be disassembled - it is outside the segment, so the linear file mapping
does not reach it - and what it does is assumed from its callers.
