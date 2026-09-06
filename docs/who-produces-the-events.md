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

**Not an older TI part.** The instruction census settles the family: `splk`,
`samm`, `lamm`, `bsar`, `bd`/`calld`/`retd`/`retcd`, `lacc16`, `bcnd`, `bldd`,
`smmr`/`lmmr` and `apl`/`opl`/`xpl` all appear in a 1200-word window, and none
of them has a C2x encoding. A TMS320C25 cannot run this program.

**But it is probably not a C52 either, and the model assumes one.**
`c5x_core.h` says the part has "4K words of program ROM and three DARAM blocks
and **no SARAM at all**, which makes PMST.RAM and PMST.OVLY don't-cares", and
`program_region`/`data_region` implement exactly that: everything from `0x0800`
up is `External`, and `PMST.RAM` "does nothing here".

The firmware disagrees. Its prologue is

```
8014  apl @07, #07f8      ; keep bits 3-10
      opl @07, #00b0      ; set bits 4, 5 and 7
```

and on a C5x bit 4 is **RAM** and bit 5 is **OVLY** - the two bits that map
on-chip SARAM into program space and overlay on-chip memory into both spaces.
A build sets them only on a part that has SARAM to map. Bit 7 is IPTR's LSB,
putting the vector table at `0x0080`, which likewise needs on-chip memory there.

Everything else this note has traced sits in the same place. The prologue's
block clears cover `0x0100-0x04ff`, `0x0800-0x08ff` and `0x0b80-0x0bff`; the
302 mailbox ring is at `0x0bd0`; and the dispatcher's own helper is at program
`0x23f0`. On the modelled C52 the last three are off-chip. On a C5x with SARAM
they are not, and `0x23f0` in particular is beyond what a 3K SARAM part would
cover, which points at the larger member rather than the smaller.

### How far the code pins the part down

An earlier revision of this section claimed two dispatch-table handlers below
the resident bank, `0x23f0` and `0x7e80`. **Both were misreads.** The table is
121 entries, `0x00`-`0x78`, exactly as `dsp-rom-probe.md` says; reading `0x80`
of them runs off the end into the code that follows. The words that appear at
"tags" `0x79`-`0x7c` are identical in both builds because they are
instructions, not entries:

```
847a  bc00   ldp  #000        <- "tag 79"
847b  be41   setc intm        <- "tag 7a"
847c  7e80 23f0  calld 23f0   <- "tag 7b", "tag 7c"
```

That is the stream resume poll's own prologue, sitting immediately after the
table. So **no handler is below `0x8000`**, and tag `0x7b` - the DAA identity -
is an outbound tag with no inbound slot at all.

What survives is narrower and still real: 302's dispatcher and its resume poll
both `calld 0x23f0`, so that helper is genuinely program memory below the
external RAM. 403 puts the same helper in-bank at `0x80e8`, so only the older
build needs it.

So the correction to make is the memory map rather than the part number: SARAM
mapped by `PMST.RAM`/`OVLY` instead of stubbed, and program space above the
DARAM that is not simply `External`-and-empty but writable and persistent
across the whole `0x0800`-`0xffff` range the firmware uses. That is a bigger change than
anything else in this note and has not been made or tested. None of it comes
from a part marking - the board photo shows only
`TI DSP 16-912 (C) US ROBOTICS D17140PQ`.

### The original family note

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

### Wiring the bridge to the real dispatcher: how far it gets

`_deliver_host_message` now does the ASIC's write side - tag to DSP cell
`0x5e`, word to `0x5f`, bit 15 of `@57` - and the return leg reports the DSP's
own completions where the CPU looks for them, with the acknowledgement raising
**bit 13**, which is what the resume poll actually tests:

```
8462  calld 80e8, * / lar ar1, #57     ; read the status latch
8469  bit  13, @7d
846a  retc ntc                          ; bit 13 clear - nothing to resume
846b  lar  ar1, #039e
846d  lacc *                            ; the vector the handler armed
846e  retc eq                           ; unarmed - return
846f  bacc                              ; continue the coroutine
```

Both stream handlers arm that cell the same way: tag `0x06` at `0x8470` writes
`splk @1e, #8474`, and tag `0x45` - the one `ATY12` sends - at `0x860a` writes
`splk @1e, #860e`. `@1e` under `ldp #007` is cell `0x039e`.

**The message is delivered and never consumed.** Instrumenting the
acknowledgement shows the state at that moment:

```
ACK set=2000 clr=0004   @57 8000 -> a000   io60=ffff   cell 039e=0000
```

`@57` still carries bit 15, so the dispatcher at `0x8387` has not read the
message - it acknowledges by writing bit 0 - and `0x039e` is still zero, so no
handler has armed a stream.

### What calls the dispatcher, and why it never runs here

The DSP's service loop, at `0x80bb`, calls all three mailbox routines on every
iteration:

```
80b9  call 8212, *
80bb  call 8387, *, ar1     ; the receive dispatcher
80bd  call 83bf, *, ar1     ; the message sender
80bf  call 8462, *, ar1     ; the stream resume poll
80c1  call 80ea, *
80c3  lar  ar0, @10 / cmpr eq
80c5  bcnd 80bb, tc         ; loop
```

Reaching it means getting past six `call 8138` sites earlier in the same
routine, and `0x8138` is a wait:

```
8138  samm @6c
8139  lacl #03
813a  samm @6b
813b  idle              ; halt
813c  lamm @6b
813d  bcnd 813b, neq    ; back to idle until @6b reaches zero
813f  ret
```

Sampling the core's own state during a run settles it: `idle` is **true**, and
1316 of 3999 PC samples sit in that region. The C52 is parked in `idle`
waiting for interrupts that never arrive, so the loop at `0x80bb` never runs a
single iteration and `0x8387` is never called.

So the mailbox wiring is not what is missing. **The DSP's periodic interrupt
is.** `_configure_frame_interrupt` arms one only for a supervisor at offset
`0x17BB0` or a bootstrap matching the TDM ISR signature; neither applies to
these flash images, so nothing wakes the part.

### Which interrupt, and why arming it is not enough

Firing each candidate at the core and watching its state answers the first
half. **IRQ 5** wakes it - `idle` goes false - and IRQ 6 and IRQ 4 leave it
parked exactly as before. That matches the one the harness already arms for
the XMF build, `configure_line_frame_interrupt(5, 0x0206)`, and it matches the
waiting routine: the ISR that clears `@6b` is at `0x8188`, ends in `rete`, and
reads `@6b`, compares it to 3, and zeroes it - which is what releases the
`idle` loop at `0x813b`.

But the woken core does not reach the service loop. Its PC goes to program
`0x000c` and stays there, because **the low program block is not loaded**:

```
courier-board.rom   origin 8000 words 28327
main211.xmf         origin 0000 words 30170 | origin de83 words 2478 | origin 8000 words 23024
```

An update payload carries a segment at origin `0x0000`; a flash image, as this
harness slices it, carries only the `0x8000` bank. The C5x fetches its vectors
from low program memory, so IRQ 5 vectors into memory that was never
populated and the core runs away instead of servicing anything.

### There is no low block: a ROM's vectors are at 0x8000

`CourierRom.dsp_overlays` lists every C52 image a ROM can send, and on both
boards all four enter high:

| index | entry word | words (403 / 302) |
|---|---|---|
| 5 | `0x8000` | 28327 / 27710 |
| 6 | `0x9d00` | 12594 / 11510 |
| 7 | `0xb000` | 7498 / 7499 |
| 8 | `0xdc00` | 7498 / 7350 |

**None at `0x0000`.** An XMF payload has an origin-`0x0000` segment; a ROM has
nothing there. So an earlier revision of this note was wrong to call the low
block "missing": there is none to find. The resident bank is the program, it is
loaded into the C52's program RAM at `0x8000`, and its vectors are at its own
base.

The core's hardware vectoring makes the consequence exact:

```
m_pc = vector != 0xffff ? vector
                        : uint16_t((m_pmst.iptr << 11) | ((irq + 1) << 1));
```

With `iptr` zero, IRQ 5 goes to `(5 + 1) << 1` = `0x000c` - unloaded memory,
which is exactly where the woken core was seen to run away. The same slot above
a `0x8000` base is `0x800c`, inside the bank the supervisor downloaded.

Arming that takes the core out of `idle` and puts its PC across its own code,
including the call sequence that precedes the mailbox service loop:

```
idle=False  801d:1617  8024:406  814d:237  8028:207  8020:49  80ac:26  80a2:5 ...
```

`_configure_frame_interrupt` now arms IRQ 5 at `origin + 0x0c` for any image
whose first segment has a non-zero origin, leaving the XMF paths as they were.

### Can the two processors transfer yet? Not yet

With the frame interrupt armed and the mailbox wiring in place, sampling the
DSP's own cells through an `ATY12`:

```
DSP @57=0000 039e=0000 io60=ffff 5e=0000 5f=0000 ring w=0000 r=0000
DSP @57=a000 039e=00ef io60=ffff 5e=0083 5f=0083 ring w=0000 r=0000
...
DSP @57=a000 039e=00ef io60=ffff 5e=0045 5f=003f ring w=0000 r=0000
```

| observation | meaning |
|---|---|
| `5e`/`5f` carry each tag and word | the CPU-to-DSP write lands |
| `@57` reaches `a000` and never changes | bit 15 is **never consumed** - the dispatcher at `0x8387` has not run |
| `@57` never shows `1`, `2` or `4` | the DSP has written no acknowledgement, send or stream completion |
| `io60` stays `ffff` | the stream sender at `0x849e` has never executed |
| ring `w == r` throughout | nothing has been queued for the CPU |
| `039e` flips between `0000` and `00ef` | the DSP is running and uses that cell, but not as an armed stream vector |

So **a transfer completes in neither direction.** The outbound half is
delivered and ignored; the return half never has anything to carry.

What stands in the way is the DSP reaching its service loop. Its PC sits in the
early routine and the `call 8138` waits - `0x801d`, `0x8024`, `0x8028`,
`0x8020`, with only a handful of samples at `0x80ab`-`0x80ad` - and each pass
has six of those waits, each needing the ISR to count three interrupts before
it clears `@6b`. Eighteen frame interrupts per iteration, against a supervisor
that gives up after six 5 ms ticks, is the shape of the problem. The lever is
`m_line_frame_period`, currently 258 cycles.

That is a rate question rather than a protocol one: the addresses, cells and
bits are confirmed on both sides, and what remains is that the DSP does not
reach `0x8387` inside the window the supervisor waits.

### The stand-in the wiring replaces

`CourierDspBridge.write` used to intercept all four mailbox ports, assemble the
header and data, record the message, and call `_answer_runtime_request` -
writing nothing to `@5e`, `@5f` or `@57`.

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
