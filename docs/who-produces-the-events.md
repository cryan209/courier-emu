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

## What this does not establish

Two `out` sites is what a scan for `out` against those port numbers finds; an
indirect port write, or one built at run time, would not appear. The packer is
called a level because of its shape - a normalised sum of two cells - not
because anything here traces its inputs to the line ADC. Nothing above shows
which DSP cell holds a call-progress state, or that event `0x08` is emitted by
either of these two routines.
