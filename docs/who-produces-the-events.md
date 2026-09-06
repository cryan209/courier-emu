# ASIC or DSP: who produces the supervisor's line events

The supervisor's call-progress display (`ATY4`) and its buffered readouts
(`ATY11`, `ATY12`, `ATY17`) both wait on words the CPU reads from its I/O
ports. This settles what is on the other end of those ports, from the DSP
program in the board image rather than from the port traffic.

Addresses are file offsets in
`artifacts/courier-board-21210-capture-403/courier-board.rom` (supervisor
7.4.16 / DSP 3.1.2) and DSP program addresses where noted. `IDSDL302.ROM`
carries the same two routines at `0x29856` and `0x299ee`.

## The DSP writes exactly three ports

Scanning both images for C5x `out` instructions against the mailbox ports finds
two sites, and only two:

| file | DSP addr | writes |
|---|---|---|
| `0x298e6` | `0x83d3` | ports `0x5e` and `0x5f` - the message sender |
| `0x29a7c` | `0x849e` | port `0x60` - the stream sender |

Nothing in the DSP program writes `0x58`, `0x5a`, `0x5c` or `0x1c`. So every
word the supervisor reads as an event or a stream value **originates in the
DSP**; the ASIC transports it and remaps the port numbers - the CPU takes the
tag from `0x58`/`0x5a` for words the DSP put on `0x5e`/`0x5f`.

## The message sender, at DSP 0x83d6

```
83bf  ldp  #000
83c0  lacc @79          ; ring read pointer
83c1  sub  @78          ; ring write pointer
83c2  retc eq           ; nothing queued - return
83c3  setc intm
83c4  calld 80e8        ; with ar1 = #57
83c7  clrc intm
83c8  sacl @7d
83c9  bit  14, @7d
83ca  retc ntc          ; the host window is busy - return
83cb  lar  ar0, #ff60
83cd  lar  ar1, @79
83cf  lacl *+           ; take the queued word
83d0  and  #00007fff
83d3  out  @7d, 005e    ; low half
83d6  out  @7d, 005f    ; high half
```

This is the routine `dsp_mailbox.py` already names - "the resident sender at
`83d6` drains the ring at data `0bd0`", with `QUEUE_READ = 0x0079`. Its guard
is a two-pointer ring in DSP data memory: `@78` write, `@79` read, equal means
idle.

## The stream sender, at DSP 0x849e

```
8480  splk *, #8486     ; each step stores its own resume address
8482  bd   849e, *
8484  lar  ar1, #0385   ; source cell
...
8496  lar  ar1, #0be6
8498  calld 84a3, *     ; the packer
849c  lar  ar1, #7d     ; the derived cell
849e  out  *, 0060      ; the word
84a0  retd
84a1  lacl #04
84a2  samm @57          ; raise the bit the CPU reads as 1c bit 2
```

The source cells are exactly `STREAM_SOURCES` in `dsp_mailbox.py` - `0x0307`,
`0x03ba`, `0x0385`, `0x030f`, `0x031c`, `0x0be6` - and the packer at `0x84a3`
is the seventh, derived, word:

```
84a3  ldp  #007
84a4  lacc16 @01        ; cell 0x0381
84a5  adds @03          ; + cell 0x0383
84a7  norm *+           ; normalise
84aa  sar  ar1, @7d     ; exponent
84ab  apl  @7d, #000f
84ad  bsar 16
```

A normalised exponent and mantissa of the sum of two cells is a **level**
computation, done in the DSP. That is the strongest indication in this
repository that the line measurements the supervisor displays are the DSP's
work rather than the ASIC's.

## The receive side: the DSP's mailbox handler at 0x8387

The CPU-to-DSP direction does not arrive as an `in` instruction - the DSP
program contains no `in` from any mailbox port. It arrives as memory-mapped
cells, polled by this handler:

```
8387  ldp  #000
8388  setc intm
8389  calld 80e8, *      ; the guarded host-cell read helper
838b  lar  ar1, #57      ;   @57, the status latch
838d  sacl @7d
838e  bit  15, @7d
838f  retc ntc           ; bit 15 clear - nothing pending, return
8391  calld 80e8, *
8393  lar  ar1, #5e      ;   @5e - the TAG
8395  sacl @7d
8397  calld 80e8, *
8399  lar  ar1, #5f      ;   @5f - the DATA word
839b  sacl @7a
839c  lacl #01
839d  samm @57           ; acknowledge by setting status bit 0
839e  lacl @7d
839f  sub  #7f
83a0  retc gt            ; tag above 0x7f - reject
83a1  add  #00008468     ; tag - 0x7f + 0x8468 = tag + 0x83e9
83a3  tblr @7c           ; read the handler address from program memory
83a4  lacc @7c
83a5  bacc               ; branch to it
```

So the protocol on the DSP side is: **bit 15 of the status latch `@57` means a
message is waiting; the tag is cell `@5e` and the word is cell `@5f`; the DSP
acknowledges by writing bit 0 to `@57`;** tags above `0x7f` are rejected, and
the rest index a table.

The arithmetic puts the **table base at program `0x83e9`**, 128 entries running
to `0x8468`. (`c5x_core.cpp` says "the jump table at program word 8401"; that is
this table indexed from tag `0x18`.) Reading it back confirms the tags this
repository already knows from the other side:

| tag | handler | known as |
|---|---|---|
| `0x06` | `0x8470` | `STREAM_TAG` - matches "handler 8470 in 3.1.2" |
| `0x42` | `0xb03a` | `SIMPLE_WRITE_TAG` |
| `0x45` | `0x860a` | the tag `ATY12` sends |
| `0x7c` | `0x80e8` | `DETECTOR_TAG` |
| `0x08` | `0x8212` | - |
| `0x7b` | `0x7e80` | the DAA identity tag |

Immediately after the dispatch, at `0x83a6`, is the outbound producer a handler
uses to reply: it compares the ring pointers `@78` (write) and `@79` (read),
refuses when the ring is within six of full, and appends at `ar0 = #ff60`. That
is the same ring the sender at `0x83d6` drains.

The two status-latch writes distinguish the directions: `lacl #01 ; samm @57`
acknowledges a received message, `lacl #02 ; samm @57` at `0x83e5` completes a
send, and `lacl #04 ; samm @57` after the stream sender is the bit the CPU
reads as `0x1c` bit 2.

## Which DSP

The board photo shows a custom marking - `TI DSP 16-912 (C) US ROBOTICS
D17140PQ` - so the part number is not readable, and `board-parts.md` says only
"C5x-family" while other notes say "C52".

The program settles the family but not the member. A 1200-word window around
the senders contains `splk` (98), `samm` (71), `lamm` (31), `bsar` (32),
`bd` (32), `calld` (31), `retd` (36), `retcd` (108), `lacc16` (21),
`bcnd` (48), `bldd` (13), `smmr` (19), `lmmr` (2), and `apl`/`opl`/`xpl` (14).
All of those are C5x instructions with no C2x encoding, so **it is not a
TMS320C25**. The C50, C51, C52 and C53 share this instruction set and differ in
on-chip memory size, so the program alone cannot choose between them; calling
it a C52 is an assumption inherited from elsewhere, not something the code
shows.

## Why this matters for firing events

`dsp_mailbox.py`'s `queue` experiment already seeds that ring at data `0bd0`
and resets both pointers on a physical modem, so the resident sender reports a
chosen word on its next run. That is a hardware-validated way to make the DSP
emit an event - unlike forcing `AL` at the CPU's `in al, 0x58`, which
fabricates a word no device produced.

## Probing the DSP from the CPU: the full round trip

With both halves mapped, one mailbox probe is:

| step | side | action |
|---|---|---|
| 1 | CPU | tag low to port `0x58`, high to `0x5a` |
| 2 | CPU | word low to `0x5c`, high to `0x5e` |
| 3 | CPU | commit - write bit 0 back to port `0x1c` |
| 4 | ASIC | lands tag in DSP cell `@5e`, word in `@5f`, sets `@57` bit 15 |
| 5 | DSP | `0x8387` sees bit 15, reads `@5e`/`@5f`, acks with `lacl #01 ; samm @57` |
| 6 | DSP | rejects tag > `0x7f`, else `tblr` from `0x83e9 + tag` and `bacc` |
| 7 | DSP | the handler appends its reply to the ring at `ar0 = #ff60` (`@78`/`@79`) |
| 8 | DSP | sender `0x83d6` writes ports `0x5e`/`0x5f`; `lacl #02 ; samm @57` |
| 9 | ASIC | remaps those to CPU `0x58`/`0x5a`, raises `0x1c` bit 1 |
| 10 | CPU | the ISR reads the tag and calls `[0x298]` |

The stream variant differs only after step 6: tag `0x06` vectors to `0x8470`,
which runs the coroutine at `0x8480`, and each word leaves through
`out *, 0060` with `lacl #04 ; samm @57` - the CPU's `0x1c` bit 2, collected by
the chain vector (`[0x02d3]` under 7.3.14, `[0x01cd]` under 7.4.16).

`dsp_mailbox.py` drives steps 1-3 directly over the `ATGLK2` monitor on a
physical modem, which is why its notes already name `0x8470`, `0x42` and the
ring at data `0bd0`.

### In the emulator the probe stops at step 4

`CourierDspBridge.write` intercepts all four mailbox ports, assembles the
header and data, records the message, and calls `_answer_runtime_request`.
**Nothing writes `@5e`, `@5f` or `@57` bit 15**, so the DSP's dispatcher at
`0x8387` never runs and no handler ever executes. The C5x core is loaded and
stepping, but deaf to the supervisor.

`_answer_runtime_request` stands in for it, and only for two tags: `0x7c`, the
detector poll, and `0x54`. Every other tag - including `0x45`, the one `ATY12`
sends - is recorded and dropped. That is the gap behind the empty displays, and
it is upstream of everything else in this note: no handler runs, so nothing
reaches the ring, so the sender has nothing to drain.

The one `host_write` the bridge does perform writes DSP data cells directly and
is labelled in its own comment as "a convenience for seeding the modelled C52's
call registers, not a model of the board's write path".

## What this does not establish

Two `out` sites is what a scan for `out` against those port numbers finds; an
indirect port write, or one built at run time, would not appear. The packer is
called a level because of its shape - a normalised sum of two cells - not
because anything here traces its inputs to the line ADC. Nothing above shows
which DSP cell holds a call-progress state, or that event `0x08` is emitted by
either of these two routines.
