# The CPU-DSP link

One question: how the 80186 supervisor and the C5x datapump say anything to each
other. The protocol is settled on both sides and confirmed on hardware. What is
not settled is the *rate*, and that is where the harness still diverges.

## The physical arrangement

The ASIC is on the DSP's sixteen data pins, and `IS` - the I/O-space strobe,
which nothing but an `IN`, an `OUT` or a `PA0`-`PA15` access asserts - is
connected to it. So the ASIC decodes the DSP's I/O cycles across the same bus
the SRAMs sit on.

That answers the objection that stalled this for a long time: a board inspection
reporting no traces from the DSP's address/data pins to anything but its two
`CY7C199` SRAMs. SPRU056D Table A-8 gives `DS`, `PS` and `IS` as three
*space-select strobes* sharing **one** address/data bus, so an I/O cycle drives
the same pins as a data cycle and is distinguished only by which strobe goes low.
**Nobody should have been looking for a second, dedicated 32-wire bus.**

**The decode is five address lines: `A0`-`A3` and `A5`. `A4` is not connected.**
Measured on the board by effect, not by eye - three runs, each image placed with
`ATGLK2W` and verified byte-exact:

| run | ports | payload | result |
|---|---|---|---|
| control | `0x5e`/`0x5f` | `4E00` | `CDRP1 DONE`, 8 words, `SUM:701C` |
| **A4 fold** | `0x4e`/`0x4f` | `F700` | **`CDRP1 DONE`, 8 words, `SUM:B81C`** |
| A5 control | `0x6e`/`0x6f` | `A500` | `CDRP1 START`, then `CDRP1 ERR TAG` |

A frame sent to `0x4e`/`0x4f` arrives exactly as one sent to `0x5e`/`0x5f`, and
`0x6e`/`0x6f` delivers nothing - which rules out the alternative reading that the
ASIC ignores the address bus and answers any `IS` cycle.

**Skipping `A4` while taking `A5` is the informative part.** `0x5x` and `0x6x`
differ in both bits 4 and 5, so one line distinguishes the banks and the other is
redundant - a gate array wired to one of the two is a designer who knew there
were exactly two banks:

| bank | `A5` | ports | what it is |
|---|---|---|---|
| `0x50`-`0x5f` | low | `PA0`-`PA15` | the memory-mapped I/O ports, aliased into data space at `0x0050`-`0x005f` |
| `0x60`-`0x6f` | high | `0x60`, `0x68`-`0x6c` | pure I/O space, no data-space alias |

So the register file is larger than sixteen. `bridge.ASIC_DSP_PORT_MASK` models
this; its stated limit is that bits 6 and 7 were never tested, so the mask is
possibly narrower than the board's and will accept `0x0e` where the board might
not.

> **The payload pattern is load-bearing.** The first fold attempt reused the
> control's `4E00`, which made its frame indistinguishable from a re-run of the
> kernel the DSP already held - the download could have failed silently and
> produced the same output. Every board run should use its own
> `--fold-pattern`.

**The medium was never on the emulator's critical path.** The harness simulates
what `out @7c, 0x5e` does on one side and what `in al, 0x5c` returns on the
other, and both processors' instruction streams see the same thing whether the
ASIC realises those ports with parallel taps or a shift register.

## The protocol

### The DSP writes exactly three ports

Scanning both images for C5x `out` against the mailbox ports finds two sites and
only two:

| file | DSP addr | writes |
|---|---|---|
| `0x298e6` | `0x83d3` | ports `0x5e` and `0x5f` - the message sender |
| `0x29a7c` | `0x849e` | port `0x60` - the stream sender |

Nothing in the DSP program writes `0x58`, `0x5a`, `0x5c` or `0x1c`. **Every word
the supervisor reads as an event or a stream value originates in the DSP**; the
ASIC transports it and remaps the port numbers.

### The receive dispatcher, DSP `0x8387`

The CPU-to-DSP direction does not arrive as an `in` - the DSP program contains no
`in` from any mailbox port. It arrives as memory-mapped cells:

```text
8387  ldp  #000
8388  setc intm
8389  calld 80e8, *      ; the guarded host-cell read helper
838b  lar  ar1, #57      ;   @57, the status latch
838e  bit  15, @7d
838f  retc ntc           ; bit 15 clear - nothing pending
8393  lar  ar1, #5e      ;   @5e - the TAG
8399  lar  ar1, #5f      ;   @5f - the DATA word
839c  lacl #01
839d  samm @57           ; acknowledge by setting status bit 0
839f  sub  #7f
83a0  retc gt            ; tag above 0x7f - reject
83a1  add  #00008468     ; tag - 0x7f + 0x8468 = tag + 0x83e9
83a3  tblr @7c
83a5  bacc               ; branch to the handler
```

**Bit 15 of `@57` means a message is waiting; the tag is `@5e` and the word is
`@5f`; the DSP acknowledges by writing bit 0 to `@57`.** The table base is
program `0x83e9`, **121 entries** running to `0x8468`.

The three status writes distinguish the directions:

| write | meaning | CPU sees |
|---|---|---|
| `lacl #01 ; samm @57` | received a message | - |
| `lacl #02 ; samm @57` at `0x83e5` | a send is complete | `0x1c` bit 1 |
| `lacl #04 ; samm @57` after the stream sender | a stream word is ready | `0x1c` bit 2 |

### The full round trip

| step | side | action |
|---|---|---|
| 1 | CPU | tag low to `0x58`, high to `0x5a` |
| 2 | CPU | word low to `0x5c`, high to `0x5e` |
| 3 | CPU | commit - write bit 0 back to `0x1c` |
| 4 | ASIC | lands tag in `@5e`, word in `@5f`, sets `@57` bit 15 |
| 5 | DSP | `0x8387` sees bit 15, reads the cells, acks with `lacl #01` |
| 6 | DSP | rejects tag > `0x7f`, else `tblr` from `0x83e9 + tag` and `bacc` |
| 7 | DSP | the handler appends its reply to the ring at `ar0 = #ff60` (`@78` write, `@79` read) |
| 8 | DSP | sender `0x83d6` writes `0x5e`/`0x5f`; `lacl #02 ; samm @57` |
| 9 | ASIC | remaps those to CPU `0x58`/`0x5a`, raises `0x1c` bit 1 |
| 10 | CPU | the ISR reads the tag and calls `[0x298]` |

The stream variant differs only after step 6: tag `0x06` vectors to `0x8470`,
which runs the coroutine at `0x8480`, and each word leaves through
`out *, 0060` with `lacl #04 ; samm @57` - collected through the chain vector,
`[0x02d3]` under 7.3.14 and `[0x01cd]` under 7.4.16.

### Handshake polarity, corrected

The bridge had this backwards for a long time:

* **PA7 bit 1** means *the DSP can send*; **CPU `0x1c` bit 1** means *a reply is
  waiting*. CPU acknowledgement sets the DSP-ready bit again.
* **CPU `0x1c` bit 0** means the input holding register is free; **DSP PA7 bit
  0** means a CPU message is pending.
* The stream bit uses the same opposite polarity.

CPU input and DSP output are **separate holding registers**, and reading an
acknowledged output still returns the last word.

> `dsp_messages_taken` counts **CPU acknowledgements of DSP replies**. Older
> notes use it as a count of messages consumed by the DSP, which it is not -
> actual DSP receive acknowledgements are writes of `1` to PA7.

### A tag is a command index, not an address

It selects one of 121 handlers, and anything above `0x7f` never reaches the
table. **So the `host_write(address, value)` shape is wrong**, and the plan of
writing DSP data `03e6` through the mailbox was never going to work with or
without a commit edge. That - not a missing strobe - is why
`dsp-mailbox-write-01` and the queue runs saw nothing.

An outbound message is a 16-bit tag word on `58`/`5a` and a 16-bit value on
`5c`/`5e`, low byte at the lower port. The compact path at `0fddb` sends a
one-byte tag and value zeroing the high lanes; the variant at `12cbb` sends two
full words out of a ring, so both halves really are 16 bits wide.

**Reads and writes are separate latches**: the interrupt writes `58`/`5a` for
outbound and reads the same addresses for inbound, so an `ATGLK2I` of these ports
observes the **board's** side, not the host's.

**Twelve tags are unimplemented** - `4c`, `5b`-`5d`, `64`-`6b`. Their table entry
is zero, so `bacc` takes the DSP to program word `0000`.

### Known tags

| tag | handler | what |
|---|---|---|
| `0x06` | `0x8470` | `STREAM_TAG` |
| `0x07` | `0x84cb` | status query - replies `0031:0000`, ignores its data |
| `0x08` | `0x8212` | the resident's continuous status word |
| `0x13` | `0xee20` (3.1.2) | arm the DTMF pair from the keypad index |
| `0x1a`/`0x1b` | - | tone gain → DSP `0392`, second amplitude → `03f1` |
| `0x2d` | - | no-op; leaves the held reply unchanged |
| `0x42` | `0xb03a` | `SIMPLE_WRITE_TAG` |
| `0x45` | `0x860a` | the buffered report `ATY12` requests |
| `0x47` | - | **outbound**: the DSP asking for an overlay |
| `0x48` | - | `smmr @7a, #ffb1 ; ret` - the only completely unclamped host write |
| `0x62` | - | sums squares of `0900..098f` - replies `0069:0015` |
| `0x7b` | - | **outbound only**, the DAA identity - no inbound slot |
| `0x7c` | `0x80e8` | `DETECTOR_TAG` |

> **`0x7b` and `0x7c` are not inbound handlers.** The table is 121 entries,
> `0x00`-`0x78`; reading `0x80` of them runs off the end into the code that
> follows, and the words that appear at "tags" `0x79`-`0x7c` are instructions:
> `847a bc00 ldp #000`, `847b be41 setc intm`, `847c 7e80 23f0 calld 23f0` - the
> stream resume poll's own prologue. **No handler is below `0x8000`.**

## The rate, measured on the board

INT0 - IVT vector `0x0c`, reading `8f46:0000` on the 403 board - is the entire
DSP-to-CPU path. **Nothing in the image calls or jumps to that address**; a
search of all 512 KiB for a near call, a near jump, a far call and the bare word
`0000` paired with segment `8f46` finds no reference at all. So every message
either processor receives is one entry to this interrupt, and "the supervisor
never pops" is a statement about an interrupt line, not a polling loop.

```text
8f46:0000  sti ; cld ; pushaw ; push es
           in   al, 0x1e ; mov ah, al
           in   al, 0x1c
           and  ax, 3          ; two bits, and nothing else
      test 1 -> out 0x58, 0x5a, 0x5c, 0x5e        ; host -> DSP send
      test 2 -> in al,0x5a / in al,0x58 / call [0x192]   ; DSP -> CPU receive
           out  0x1c, al       ; ack: the status written back *set*
```

Measured with the INT0 hook on a live 403 board, stimulus a bare `ATD` held 6 s:

    interrupts            15,868 in 6.61 s   =  2,401 / s
    0x1c = fd             1,895 of the last 1,920 entries
    0x1c = ff                25 of them
    0x1e = ff             1,920 of 1,920

**The pin free-runs at 2,401 Hz.** The ASIC does not assert it from mailbox
state; the handler polls `0x1c` on every edge, which is why `0x1c` reads `fd` for
98.7% of entries - bit 0 standing, bit 1 clear, nothing to do. So the harness
standing in for the edge with a periodic one is right *in kind*.

**The signal is bit 1, and its cadence is exactly 20 ms:**

    entries between consecutive 0x1c = ff:
    48 48 48 48 48 48 48 48 48 48 48 48 48 48 48 48 48 48 48 48 48 48 58 81

Twenty-two consecutive intervals of 48 interrupts at 2,401 Hz, with the last two
stretching as the dial is aborted. A **50 Hz report from the DSP, held to the
sample**, and it starts with the seizure - the earlier capture, which holds the
first 0.8 s after arming, shows `0x1c` flat at `fd` with no bit 1 at all.

`0x1e` never moved in either capture.

### The harness cannot yet run at that rate

Setting the edge to 2,401 Hz **breaks the one path that worked**:

| | 391 Hz (default) | 2,401 Hz (measured) |
|---|---|---|
| 302 plain | `6245`, ringback, answer | `""`, dial-tone |
| DTMF blocks | 136 | **770** |
| DSP-originated messages | 389 | 389 |

The reason is in the handler's tail, which runs unconditionally on every entry:

```text
00f4d8  call 0x14ff0
00f4dd  lcall 8000:0676
00f4e2  cmp  word ptr [0x134], 0
00f4e9  dec  word ptr [0x134]
```

**This interrupt is the firmware's fine timebase.** Raising it six-fold makes
every countdown it drives elapse six times faster in emulated time, so the dial
emits 5.7x the tone blocks and the exchange decodes no digits from any of them.

Both numbers cannot be right, and the board is not what is wrong - the same
firmware dials on it at 2,401 Hz with the same `dec [0x134]` running. **So the
harness holds a second error that 391 Hz was quietly compensating for**, between
this countdown chain and the codec-sample clock the exchange measures digit
lengths in. That is a bounded question rather than a guess.

`MODELLED_FRAME_HZ = 391` stays the default, which is the rate the rest of the
harness is consistent with; `--frame-hz` reproduces the comparison. Keeping a
known-wrong number as the default is deliberate: the alternative is a harness
faithful about this interrupt that cannot complete a call.

## The dial-tone wait and the datapump load are one mechanism

Two separate investigations described the same counter without noticing.

The **datapump** side: `[0x0b9e]` reaching 5 is what loads overlay 5.

```text
8b7a2  mov  word [0x134], 0x2760      ; a countdown
8b7a8  mov  byte [0xb9e], 0           ; the counter, cleared
8b7ad  cmp  word [0x134], 0
8b7b2  je   8b7cb                     ; countdown expired -> the [0x0d92] probe
8b7b4  test [0x225], 0x80  / jne 8b803    ; abort
8b7bb  test [0xa7c], 0x20  / jne 8b803    ; abort
8b7c2  cmp  byte [0xb9e], 5
8b7c7  jb   8b7ad                     ; keep waiting
8b7c9  jmp  8b7db                     ; reached 5 -> overlay 5, loader
```

The **dial-tone** side: 403's detector counter is `[0x0b9e]`, its wait is at
`0x0b7c2`, and it is updated by the four-instruction routine at `0x14fdc`.

`0x14fdc` and `0x94fdc` are the same routine at file and physical addresses, and
`0x0b7c2` is `8b7c2` above. **It is one loop.** Five consecutive DSP replies with
the right bit set qualifies dial tone, and falling out of that loop is what loads
the datapump overlay.

The routine:

```text
14fca  test ah, 1          ; (302; 403 is 14fdc)
14fcd  je   14fd4
14fcf  inc  byte [0cc0]    ; a qualifying hit
14fd3  ret
14fd4  mov  byte [0cc0], 0 ; reset
```

`AH` is the **high byte of the data word that accompanies event `0x08`**, read at
`0x14dd8` from ports `0x5e`/`0x5c` immediately before the call. So this
supervisor qualifies its detector from **bit 0 of the high byte of event `0x08`'s
data word, five consecutive times** - not from a polled level.

| build | counter | wait | routine | call sites gated on |
|---|---|---|---|---|
| `IDSDL302` | `[0x0cc0]` | `0xb784` | `0x14fca` | `[0x0ea7] & 1`, `[0x0ea6] & 1` |
| 403 board | `[0x0b9e]` | `0x0b7c2` | `0x14fdc` | `[0x0d93] & 1`, `[0x0d92] & 1` |

**`main211` does something else entirely** and is not a model for either. Its
wait at `0x1dbee` is `cmp byte [0649], 5 / jb`, and its counter at `0x1e442` is
driven by a **level** in `[0x0285]`: `0xff` does nothing, `0` resets, `1..0x60`
increments, above `0x60` resets and increments `[0x064a]` instead. The bridge's
`DETECTOR_PRESENT_LEVEL = 0x30` is correctly in that window, and
`CourierDaa.detector_qualified` - five 100 ms frames of accrued audio, never
inspecting a level - is a third mechanism again. **Neither is a stand-in for what
the ROM builds do.**

### Which leaves one thing to reconcile

The resident's dial-tone report is tag `0x08` with **bit `0x40` of the data
word** - measured, `0x0002`/`0x0003` becoming `0x0042`/`0x0043` when the exchange
presents a continuous tone. The supervisor's detector tests **bit 0 of the high
byte** of that same word, which for `0x0042` is clear.

Both observations are solid and they do not obviously meet. Possibilities, none
tested: the emulated resident sets the wrong bit; the qualifying word is a
different message from the one the tag histogram counts; or the high byte carries
something the emulated resident never populates. **This is the next thing to
measure, and it is measurable** - the board's own traffic during a real dial,
sampled through the INT0 hook, says which.

## Why nothing transfers in the harness yet

The addresses, cells and bits are confirmed on both sides. What fails is the DSP
reaching its service loop.

The loop at `0x80bb` calls all three mailbox routines every iteration:

```text
80bb  call 8387, *, ar1     ; the receive dispatcher
80bd  call 83bf, *, ar1     ; the message sender
80bf  call 8462, *, ar1     ; the stream resume poll
80c3  lar  ar0, @10 / cmpr eq
80c5  bcnd 80bb, tc         ; loop
```

Reaching it means getting past six `call 8138` sites earlier in the same routine,
and `0x8138` is a wait that ends in `idle` until an ISR counts `@6b` down to
zero. Sampling the core's state during a run: **`idle` is true, and 1316 of 3999
PC samples sit in that region.** The C52 is parked waiting for interrupts that
never arrive, so `0x8387` is never called.

**IRQ 5 is the one that wakes it** - IRQ 4 and 6 leave it parked. That matches
what the harness already arms for the XMF build and it matches the waiting
routine: the ISR that clears `@6b` is at `0x8188`, ends in `rete`, and reads
`@6b`, compares it to 3, and zeroes it.

**But a ROM image has no low program block, and the vectors follow the base.**

| index | entry word | words (403 / 302) |
|---|---|---|
| 5 | `0x8000` | 28327 / 27710 |
| 6 | `0x9d00` | 12594 / 11510 |
| 7 | `0xb000` | 7498 / 7499 |
| 8 | `0xdc00` | 7498 / 7350 |

**None at `0x0000`.** An XMF payload carries an origin-`0x0000` segment; a ROM
carries nothing there, so an earlier reading calling the low block "missing" was
wrong - there is none to find. With `iptr` zero the core's own vectoring sends
IRQ 5 to `(5 + 1) << 1` = `0x000c`, unloaded memory, which is exactly where the
woken core was seen to run away. The same slot above a `0x8000` base is `0x800c`.
`_configure_frame_interrupt` now arms IRQ 5 at `origin + 0x0c` for any image
whose first segment has a non-zero origin.

With that armed and the wiring in place, sampling the DSP's cells through an
`ATY12`:

| observation | meaning |
|---|---|
| `5e`/`5f` carry each tag and word | the CPU-to-DSP write lands |
| `@57` reaches `a000` and never changes | bit 15 **never consumed** - `0x8387` has not run |
| `@57` never shows `1`, `2` or `4` | no acknowledgement, send or stream completion |
| `io60` stays `ffff` | the stream sender has never executed |
| ring `w == r` throughout | nothing queued for the CPU |

**A transfer completes in neither direction**: the outbound half is delivered and
ignored, the return half never has anything to carry. The DSP's PC sits in the
early routine's waits - `0x801d`, `0x8024`, `0x8028`, `0x8020` - and each pass has
six of them, each needing the ISR to count three interrupts. **Eighteen frame
interrupts per iteration, against a supervisor that gives up after six 5 ms
ticks**, is the shape of the problem. The lever is `m_line_frame_period`,
currently 258 cycles.

That is a rate question rather than a protocol one, and it is the same kind of
error as the 2,401 Hz finding above.

## The poll rate on the DSP side

The DSP's own mailbox poll lives in the block at `0x80c8`, which the main loop
reaches only when `cmpr eq` matches `AR7` against `ARCR`. The ring is exact:
`0x802e` sets `CBCR = 0x00ef`, selecting `AR7` for circular buffer 1 with
`CBSR1 = 0x0bd0` and `CBER1 = 0x0bdf`. An `ARCR` anywhere in that ring makes the
block run once per pass, a few hundred times a second. With `ARCR` at zero it
runs **once, during initialisation**, which is why a full run shows 87 messages
delivered and almost nothing consumed.

**`@10` is data `0x0390`, and that is where `AR7` is kept.** Direct addressing is
DP-relative and `ldp #007` sits immediately before the `lar ar0, @10` at `0x8105`
and `0x810d` - so `@10` is *not* the memory-mapped `AR0` at data `0x0010` that a
DP-0 reading gives. That is the trap. `sar ar7, @10` at `0x808f` and `0x81a1`
store the cell; `lar ar7, @10` at `0x80c5` and `0x8192` restore it:

```text
80c5  lar  ar7, @10     ; AR7 <- saved ring pointer
80d0  lar  ar0, @10     ; AR0 <- the same cell, and ARCR/INDX with it
80d1  cmpr eq           ; TC = (AR7 == ARCR)
80d2  bcnd 80c8, tc     ; has AR7 moved off its saved value?
```

So the compare tests the **live ring pointer against its own saved value** and
needs nothing external.

### The `NDX` side effect is real, and measured on the part

That reading depends on `lar ar0` loading `ARCR` as a side effect. SPRU056D's
`LAR` page and Table 4-3 say it does when `NDX` is clear; its section 3.5 prose
says when `NDX` is set, so the document cannot arbitrate itself. The part was
asked, with sentinels rewritten before every load:

| | `PMST` | `lar ar0, @7b` | `lark ar0, #55` | `lar ar0, #4321` |
|---|---|---|---|---|
| **`NDX` clear** | `00b0` | `ARCR`/`INDX` = **`1234`** | = **`0055`** | = **`4321`** |
| **`NDX` set** | `00b4` | `ARCR`/`INDX` = `EEEE`/`DDDD` | - | - |

1. **The side effect is real on this part.**
2. **The `LAR` page and Table 4-3 have the polarity right**; the prose is wrong.
   This firmware clears `NDX` at `0x8012`, so the side effect is **active**.
3. **It is not restricted to 'C2x instructions.** `lar ar0, #4321` is the 'C5x
   long-immediate form and it loaded both registers. The trigger is loading `AR0`
   at all, whatever the encoding.

Confirmed since by a second capture, and the further readings settle the edges:
**`SAMM AR0` does not** copy to `ARCR`/`INDX` under either polarity; **`MAR`
increment/decrement of `AR0` does**, with `NDX` clear; **loading `AR1` does
not**. The core implements `LAR` and `ARAU` `AR0` side effects while leaving MMR
writes independent.

> **Two faults were masking one another.** The core omitted the `AR0` side
> effects, *and* PA7 writes manufactured false download-ready status. Fixing
> `NDX` alone made the firmware enter that false ready path and repeatedly
> download `FFFF`, including into its interrupt vector area. **That was not
> evidence of bad `*0+` addressing**, which is what it looked like and what an
> earlier revision concluded. On the measured ROM profile, PA7 writes acknowledge
> flags instead of replacing the whole register: the board reads PA7 as `0002`
> before and after writes of `0200`, `0300` and `0000`.

`ARCR` is shared scratch, which is part of why this was hard to read: the
resident's only write to it, `samm @19` at `0x9644`, computes
`(@7e >> 10) + 0xd9fe` - a **program** address for a table walk - and `0xafdf`
reads it back.

**Read on the board, `0x0390` is `0x0000`** - all sixteen samples. The control
matters, because zero is also what a broken probe returns: the same kernel
pointed at data `0xffff` returned `0x0083` sixteen times. But it was taken idle,
on hook, and after the monitor had reset the DSP, so it is what the resident left
behind rather than a sample of the running loop. **Sampling `0x0390` during a
call is the open measurement**, and it needs a probe that runs alongside the
firmware - the shape `cooperative_probe.py` has, which cannot currently reach DSP
data memory.

## The status register is PA7

Four routines in the resident read `0xff57`:

```text
839b:  bit 15, @7d   -> bit 0    host message pending
83d6:  bit 14, @7d   -> bit 1    (also requires @79 != @78)
847a:  bit 13, @7d   -> bit 2    then dispatches through data 0x039e
80f8:  and #0200     -> bit 9
```

SPRU056D section 3.5.11 and 8.3.2 put `0050h-005Fh` at the memory-mapped I/O
ports, `0x50` = PA0 through `0x5F` = PA15, and Figure 5-10 has
`LAMM`/`SAMM`/`LMMR`/`SMMR` force the 9 MSBs of the address to zero - so
`lamm *` with `AR1 = 0xff57` genuinely reads `0x57`. **`0x57` is PA7, and these
four routines poll a status word the ASIC drives.** The bit meanings are the
ASIC's and no TI document has them.

The harness raises `HOST_MESSAGE_PENDING` (`0x0001`) and nothing else, so
`0x83d6` and `0x847a` return immediately and `@1a` stays pointing at `0x8139`, a
bare `ret`. Whatever sets PA7's other bits is 80186 code in an image this
repository has, since the DSP's `PA0`-`PA7` are fed from the 80186's window at
`0x40`-`0x5e`. `0x847a`'s path through data `0x039e` and `bacc` is the one shaped
like "start this task".

## The readback channel, and why it cannot dump the mask ROM

The `0x60`/`0x62` window is a real bulk readback channel, verified end to end on
hardware: **arm with a mailbox tag, pump with `0x1c` bit 2, read the words.**
Following the jump table at `8401` through each handler settles which tag reaches
which streamer and whether its source holds program memory or live data.
`tests/test_dsp_window_stream.py` pins it.

| tag | handler | arm stub | source | words | what it exposes |
|---|---|---|---|---:|---|
| `06` | `8489` | `848d` | `0307 03ba 0385 030f 031c 0be6` | 6 | six discrete live call-state cells (a custom per-word streamer) |
| `45` | `8623` | `8627` | `ff90` **or** `ff00` | 32 / 17 | live data; `@1f` bit 10 picks the variant at runtime |
| `46` | `84d3` | `8617` | `ff80` | 16 | first four table-read from **program** `860b..8610`, rest live |
| `47` | `863e` | `8642` | `ffc0` | 12 | live data `ffc0..ffcb` |
| `57` | `8517` | `8617` | `ff80` | 16 | **program** words near `85ff`/`8611` plus derived status |
| `58` | `864e` | `8652` | `ffc0` | 25 | live data; also sets `fff8 := 0a40` |
| `73` | `865e` | `8665` | `[fff8]` = `0a40` | 103 | live DSP data RAM `0a40..0aa6` |
| `78` | `8671` | `8678` | `[fff8]` = `f993` | 5 | live DSP data `f993..f997` |

Every count equalled its arm-stub immediate, `ffb8` advanced by exactly that many
cells, and `[039e]` cleared at the end - the streamer disarms cleanly. Tag `46`
is the anchor: it emits `0708 0708 0960 0960 0000...` in the emulator, identical
to the physical `dsp-window-pump-02` capture.

**Two details a host driver needs.** The first pumped word is the **count
itself**, not payload - the arm stub's opening `bd 84b7` emits with `ar1` still
at `ffb9` - so pump `count + 1` times and discard word 0. And the emit path's
"pump me again" flag and the resume path's poll both resolve to data `0057`, so
**`0057` bit 2 is the handshake cell**.

The resume poll tests **bit 13**, not bit 2, of the status latch:

```text
8462  calld 80e8, * / lar ar1, #57
8469  bit  13, @7d
846a  retc ntc                          ; nothing to resume
846b  lar  ar1, #039e
846d  lacc *                            ; the vector the handler armed
846e  retc eq                           ; unarmed
846f  bacc                              ; continue the coroutine
```

Both stream handlers arm that cell: tag `06` at `8470` writes
`splk @1e, #8474`, and tag `45` at `860a` writes `splk @1e, #860e`. `@1e` under
`ldp #007` is cell `0x039e`.

### The index cannot be widened

Tag `46` is the closest this comes to a dump, because its arithmetic is
**unmasked** - `lacl @5b ; add #860b` reaches any 16-bit program address, the
mask ROM included, and the streamer carries the result to the host. Every piece a
dump needs is present except control of the index.

`03db` has exactly two writers. `9773` only reads it; `ae98` writes what `ae12`
returns, and `ae12` is a **six-way priority encoder**:

```text
ae15  bit 10, @7d ; lacl #05 ; retc tc      ; TI bit 10 is bit 5
ae18  bit 11, @7d ; lacl #04 ; retc tc
ae1b  bit 12, @7d ; lacl #03 ; retc tc
ae1e  bit 13, @7d ; lacl #02 ; retc tc
ae21  bit 14, @7d ; lacl #01 ; retc tc
ae24  lacl #00 ; ret
```

**Its output is `0..5` by construction**, so no control over its input can widen
the range. The address is confined to `860b..8610` by the shape of the encoder,
not by a clamp that might be bypassed. That closes the route regardless of what
feeds it - and tracing the input anyway confirms it: `ade8` ANDs four cells at
`ffb0..ffb3`, of which only `ffb1` is host-writable (tag `48`), an AND only
clears bits, and the other terms come from a call-setup routine an idle unit has
not run. Tested directly: tag `48` with `ffff` then tag `46` still returns index
`0`.

**The sharpest remaining lead** is `ffb8`/`fff8`. A streamer whose source address
lives in a data cell would be an arbitrary DSP *data* read if that cell could be
reached, and the host-writable set includes `fff0`-`fff3` - adjacent to `fff8`,
but not it.

### And the datapump is already in hand

The DSP's program is downloaded over the I/O ports at every boot, and the load
base is pinned - `flash_offset = 0x29080 + 2 * (dsp_word - 0x8000)`, checked two
ways: flash `0x29080` holds the DSP reset code and maps to word `0x8000`, and the
resident sender at words `83d6..83ff` maps to flash `0x2982c..0x2987e`. So flash
`0x29080..0x368fc` **is**, byte for byte, what the DSP executes. Reading it out
of the DSP would recover a copy of something already captured.

What the mask ROM would add is the **internal boot ROM** at words `0000..0fff`,
which is not in flash. A C52 has 4K words there - not throughout `0000..7fff`, so
lower addresses like `23f0`, `2100..2593` and `7a80` can be external or installed
program RAM but cannot be part of the ROM array.

TI's protection option, if programmed, makes an instruction fetched from off-chip
memory read invalid bus data for an on-chip program operand and blocks the
emulator, so a downloaded `8000` probe and an ordinary JTAG dump both fail by
design. **On-chip SARAM is not on that exclusion list**, which is the one gap.

The non-destructive discriminator, if a scope goes on the board: photograph the
marking; **observe `MP/MC` at DSP reset** (low maps the internal ROM, high maps
external - sampled only at reset, while the `PMST` bit can change later); and
watch `PS`, `STRB` and enough address lines during reset. An external program
fetch at address zero supports `MP/MC = 1`.

## Which DSP

**Not a 'C52**, which is what `native/c5x_core.h` models. The firmware's prologue
maps SARAM a 'C52 does not have, 302's dispatcher `calld`s `0x23f0` which only the
9K part covers, and the build sets up a TDM serial port a 'C52 does not have. It
is a **'C50, possibly a 'C51** for builds that do not reach `0x23f0`. The
argument, the Table 1-1 comparison and what it means for the core's memory map
are in [board.md](board.md#which-dsp-a-c50-possibly-a-c51---not-a-c52).

## What this does not establish

Two `out` sites is what a scan for `out` against those port numbers finds; an
indirect port write, or one built at run time, would not appear. The stream
packer at `0x84a3` - a normalised sum of two cells - is called a **level**
because of its shape, not because anything traces its inputs to the line ADC.
Nothing here shows which DSP cell holds a call-progress state, or that event
`0x08` is emitted by either of the two sender routines.
