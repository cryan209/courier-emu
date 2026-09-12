# Pinning out the NEC ASIC

[board-parts.md](board-parts.md) identifies the ASIC only by its marking -
`NEC USA 1-016-905 9948LV001`, a USR part number on an NEC-fabricated gate
array, week 48 of 1999. That is as far as the marking goes: `1-016-905` is
USR's number, `LV001` is NEC's lot code, and the metal is custom. There is no
catalogue part and no datasheet to find. A 120-pin plastic QFP is the usual
body for an NEC customer gate array of that era (the µPD65xxx-family masters),
but the package says nothing about what is inside it.

So the part has to be identified by what it is wired to. This file records
that, from the owner's continuity readings.

> **These readings are from the 25 MHz Courier 2806** - the AC03 board,
> supervisor 7.3.14 / DSP 3.0.13, the unit dumped in
> `artifacts/courier-2806-25mhz-flash-20260912`. Confirmed by the owner.
>
> The marking above is **not** from that board. It was read off a photo of the
> **20.16 MHz** unit, the one running ID_SDL 4.03d that
> [asic-port-map.md](asic-port-map.md) probed through the monitor. **The
> 2806's ASIC has not been read for a marking at all**, and until it is,
> nothing establishes that the two boards carry the same gate array. Reading
> the text off this one is the cheapest outstanding item in the file.
>
> What does transfer, and what does not, is worked out below.

## Which findings cross between the two boards

The two boards are not interchangeable and the distinction matters per pin, so
it is worth settling before the map rather than after.

**The DSP side transfers.** [board-parts.md](board-parts.md) establishes that
stock 7.3.14 runs on both the 20.16 MHz AC01 board and this 25 MHz AC03 board,
and that its **DSP payload is byte-identical between them** - 126,851
consecutive identical bytes covering the payload and all three overlays. Code
that identical cannot be talking to two different interfaces. So `IS`, `INT2`,
`READY` and the data bus are findings about both boards, not just this one.

**The CPU side does not.** The same comparison finds the whole difference
between those two images **is** in the supervisor. A differing supervisor is
exactly where a differing CPU-side wiring would show up, so `ALE`, `RD#`,
`WR#`, the two interrupt lines and the unconnected `INT0` are findings about
the 2806 and are not evidence about the 20.16 MHz board.

That split is what the sections below are graded against.

## Orientation and pin numbering

The package is 120 pins, 30 a side, with the index dot at the **bottom left**.

"Bottom left" is **in the part's own frame, not the board's**: the readings
were taken viewed from above with the `NEC USA 1-016-905` markings upright, and
"top", "right" and "left" below mean the edges of the chip in that position.
That is the orientation to reproduce before re-checking any of this - it does
not depend on how the ASIC happens to sit relative to the board's silkscreen,
and it is the frame a package drawing would use.

It also fixes which of the two common QFP drawing styles applies. Both number
counter-clockwise from a top view; they differ in where pin 1 sits. Pin 1 at
the top-left runs `1`-`30` down the left side. Pin 1 at the **bottom** left -
which is what the dot shows in the part's own frame - runs `1`-`30` along the
bottom. So, under the JEDEC convention of pin 1 at the dot and numbering
counter-clockwise viewed from above - **confirmed by the owner**:

| pins | edge | direction |
|---|---|---|
| `1`-`30` | bottom | left to right |
| `31`-`60` | right | bottom to top |
| `61`-`90` | top | right to left |
| `91`-`120` | left | top to bottom |

The readings below were taken in per-side local numbering. The translation is:

* **top edge**, counted left to right: pin = `91 - N`
* **right edge**, counted top to bottom: pin = `61 - N`
* **left edge**, counted bottom to top: pin = `121 - N`

**The direction is confirmed: `1`-`30` is the bottom edge.** Stated by the
owner, who took the readings and therefore owns the frame they were recorded
in. That retires the clockwise alternative, which would have numbered the same
dot `1`-`30` up the *left* side, putting the address bus at `31`-`36` instead
of `85`-`90` and `IS` at `7` instead of `114`. Everything below is in the
counter-clockwise scheme and needs no second reading.

The bottom-edge readings agree with it independently, which is worth keeping
because it is a check rather than an assertion. `10`-`27` land on the one edge
that was unread, and the edge the panel was predicted to be on. Read clockwise
they would land on pins already read as the DSP data bus - `13`, `14`, `16`,
`17` and `18` would be `D5`, `D4`, `D2`, `D1` and `D0`, with `18` a *measured*
pin, not an inferred one. Five collisions with a bus against a clean fit on the
free edge is the same answer the owner gives, arrived at from readings taken
months apart.

What no measurement settled, and what the confirmation is therefore doing, is
worth being precise about. The supply pin does not settle it: the top-left pin
is tied to DSP pin 15, which SPRU056D's Table A-4 for the PQ package gives as
`VDDD` - one of four digital-core supply pins at 14, 15, 32 and 33, in adjacent
pairs, with `IS` at 90 in the same table, so the package is confirmed as the
132-pin BQFP the part marking implies. But that pin is physically at a *corner*,
and a corner is where a gate-array library puts a supply pad under either
convention. What it confirms is the 30-a-side count and that the top edge
starts at a corner, not the direction. Nor could a meter have decided it:
counter-clockwise and clockwise number the same physical pins in the same
frame. The frame is the owner's, and **the edge and the count from the corner
remain the durable record** - if a numbering question ever reopens, that is
what to check against.

Every bare pin number in the table below is an **ASIC** pin. DSP and CPU pins
are named as such - they collide otherwise.

## What is connected

Measured pins are marked; the rest of a bus run is **inferred** from the
measured ends being contiguous and in order, and is marked so.

### Top edge

| local | pin | signal |
|---|---|---|
| 1 | 90 | `VDD`, shared with DSP pin 15 (`VDDD`) |
| 2-5 | 89-86 | DSP `A0` `A1` `A2` `A3` |
| 6 | 85 | DSP `A5` - `A4` is **not connected** |
| 7-14 | 84-77 | CPU `AD0`-`AD7` |
| 18 | 73 | flash `A17` - PA28F400 pin 3 |
| 20 | 71 | 74VHC32 pin 12 - gate 4's `A` **input** |
| 21 | 70 | `A0` - RAM pin 10 **and** flash pin 11 |

Locals 15-17 (`76`-`74`), 19 (`72`) and 22-30 (`69`-`61`) are unread.
This edge is the address side of the part: see below.

### Right edge - the CPU control group

| local | pin | signal | CPU pin |
|---|---|---|---|
| 4 | 57 | `ALE` | 38 |
| 5 | 56 | `WR#` | 37 |
| 6 | 55 | `RD#` | 36 |
| 7 | 54 | *unread* | - |
| 8 | 53 | `INT2`/`INTA0#` | 64 |
| 14 | 47 | `INT1` | - |

`ALE`, `WR#` and `RD#` land adjacent, which makes this edge the CPU-side bus
control group and gives **pin 54 as the prime suspect for the chip select**
that decodes the `0x00`-`0x7f` I/O window. That window's top at `0x7f` is a
decode somebody chose, and its pin has to be somewhere; one pin between `RD#`
and the first interrupt is where it would sit.

CPU `INT0` (CPU pin 62) is **not connected**.

### Left edge - the DSP data bus and its strobes

| local (from top) | pin | signal |
|---|---|---|
| 2 | 92 | DSP `D15` |
| 3-8 | 93-98 | DSP `D14`-`D9` *(inferred)* |
| 9 | 99 | DSP `D8` |
| 10 | 100 | *unread* - see below |
| 11 | 101 | DSP `D7` |
| 12 | 102 | DSP `D6` |
| 13-17 | 103-107 | DSP `D5`-`D1` *(inferred)* |
| 18 | 108 | DSP `D0` |
| 19 | 109 | DSP `INT2` |
| 24 | 114 | DSP `IS` |

The five measured data pins fall in two exact descending runs - `99`-`92` for
`D8`-`D15` and `101`-`108` for `D7`-`D0` - so the twelve unread ones between
them are inferred, not read. **Pin 100 sits between the two groups** and is not
part of either; a ground or supply splitting the bus halves is the obvious
candidate and it has not been checked.

Pins `110`-`113` and `115`-`120` are unread.

#### The ASIC is in the flash's high address path

Pin 73 goes to the flash's `A17`, and that is not a line the CPU should need
help with. The part is a **PA28F400**, 4 Mbit, and the 2806 dump
(`artifacts/courier-2806-25mhz-flash-20260912/courier-board.rom`) is 524,288
bytes - the whole device, with no second bank hiding behind it. So `A17` here
is the part's own top address line, not a page select onto more silicon.

Which leaves the question of why it comes out of the ASIC at all. An 80186 has
a 20-bit address and 512 KiB of flash needs `A0`-`A18` of it; nothing about
that requires an intermediary. Two readings fit:

* **The ASIC buffers or remaps the high flash addresses.** The CPU's upper
  address lines are not multiplexed onto `AD0`-`AD7` and have to reach the
  flash somehow, and if one of them is routed through the ASIC the rest
  probably are too.
* **`A17` is switchable**, splitting the part into two 256 KiB halves the ASIC
  selects between. The dump does not rule this out - a full-device read through
  the monitor would see both halves either way - but nothing in the firmware
  analysis has ever needed a flash bank, so this is the weaker of the two.

Either way it makes a prediction, and a cheap one. **`72`-`61` and `76`-`74`
are the unread rest of this edge**, immediately adjacent, and if the high flash
addresses come through this part then `A16` and `A18` are in there. Three or
four continuity readings settle which of the two readings above is right, and
they are the highest-value pins left on the package - a CPU-to-flash path
running through the ASIC is a structural fact about the memory map that nothing
here has modelled.

#### The CPU is an 80C186EB in the 80-lead QFP, and now the pin numbers check

`'573` pin 9 goes to **CPU pin 11**, and that reading is worth more than the
latch question it was asked to settle. Every CPU pin number in this file can
now be checked against a datasheet instead of taken on trust.

Intel's `80C186EB/80C188EB` datasheet, Table 7, gives the 80-lead QFP package
locations. Against the readings recorded here:

| CPU pin | this file says | datasheet Table 7 | |
|---|---|---|---|
| 36 | `RD#` | `RD` | ok |
| 37 | `WR#` | `WR` | ok |
| 38 | `ALE` | `ALE` | ok |
| 62 | `INT0`, unconnected | `INT0` | ok |
| 64 | `INT2`/`INTA0#` | `INT2/INTA0` | ok |
| 11 | *(this reading)* | `AD8 (A8)` | - |
| 75 | `INT3` | `T0OUT` | **no** |

Five exact matches is not a coincidence, and it settles two things at once.
**The part is an 80C186EB**, not the plain `S80C186` that
[board-parts.md](board-parts.md) records from the marking - the XL's QFP puts
`ALE` on pin 10 and `INT0` on 31, which these readings are nothing like. And
the **package is the 80-lead QFP**, which is why pin numbers above 68 appear at
all. Everything the harness does with `EbSerial` is on the right device.

The one miss is `INT3`. It is on QFP **65**, not 75; 75 is `T0OUT`. That
reading should be retaken - it is a loose end in the interrupt map, and now it
is a loose end with a predicted answer.

#### There is one '573, and it latches the high byte

`'573` pin 9 is `D7`, and CPU pin 11 is `AD8`. So `AD8` is on this latch's
input side, which is the **second** reading to say so - the earlier one said
only "the other side goes to `AD8`" without naming a pin. Two readings agreeing
on the one signal that decides it: **this '573 latches the high byte**,
`AD8`-`AD15` into `A8`-`A15`.

And there is **only one '573 on the board**, with a **74VHC32** beside it. That
was the other half of the question and it closes off the easy answer. The
previous revision proposed two latches, one per byte, with the readings taken
across both without distinguishing them. There is no second latch to distribute
them to.

#### The ASIC latches `A0`-`A7`, and pin 70 is the proof

An 80C186EB multiplexes `AD0`-`AD15` and drives `A16`-`A19` separately. The
'573 accounts for the high byte. **Nothing else identified on the board latches
the low byte**, and the memories need it - flash and SRAM both take `A0`-`A7`
as ordinary address inputs and neither has any idea what `ALE` is.

**ASIC pin 70 goes to RAM pin 10 and flash pin 11. Both are `A0`.** That is the
low byte's first bit, driven out of this part into both memories, and it settles
what a previous revision could only propose:

* the ASIC is the **low-byte address latch** for the memory bus,
* which is what `AD0`-`AD7` on pins `84`-`77` and `ALE` on pin `57` are *for* -
  not merely self-decoding its own `0x00`-`0x7f` window, which is all this file
  had ever used `ALE` to explain,
* and the '573 beside it is the high-byte half of one shared job.

The memory address bus therefore comes from three places at once: `A0`-`A7`
from the ASIC, `A8`-`A15` from the '573, `A16`-`A19` from the CPU - except
`A17`, which is also the ASIC, on pin 73.

**The outputs are on the top edge, not where the last revision guessed.** It
predicted the unread `28`-`46` run at the bottom right; `A0` is at 70 and flash
`A17` at 73, both on the top edge, in the run this file had already flagged as
the neighbours of the `A17` pin. So the top edge is the address side of the
package end to end: `AD0`-`AD7` in at locals 7-14, latched address out at
locals 18 and 21, with locals 15-17, 19-20 and 22-30 still unread between and
around them.

That is thirteen unread pins on one edge for the seven remaining low-address
bits, and it is now the cheapest high-value trace on the part - `A1` is RAM pin
9 and flash pin 10, and they walk down from there. If `A1`-`A7` are in that run
the low-byte latch is fully mapped, and whatever is left over on that edge is
the next question.

**`A17` is the odd one out and stays odd.** `A16`-`A19` are non-multiplexed CPU
outputs that need no latch, so there is no bus reason for one of them to come
out of the ASIC. Routing it through a part that also holds a latch is what
**remapping** looks like, not buffering. Flash `A16` and `A18` are what decide
it, and they are in the same unread run.

#### The ASIC also feeds the decode glue

**Pin 71 goes to 74VHC32 pin 12**, which on a quad 2-input OR is `4A` - an
*input* to gate 4. So the ASIC drives that gate, and the '32 stops being
unattributed glue: it is downstream of this part.

Where that pin sits is the first thing it says. `71` is between flash `A17` on
73 and `A0` on 70, in the middle of the address run - so **the top edge is not
purely address**. Something the ASIC computes leaves on a pin its neighbours
use for address bits.

What a quad OR next to an address latch is normally for is memory decode:
`OR`ing a chip select with `RD` or `WR` to make per-device strobes. With
active-low signals an OR gate is an AND of the conditions, so `4Y` low needs
both inputs low - the shape of "this device is selected **and** this strobe is
active". If that is what gate 4 is, then the ASIC holds a qualifier on a memory
access, and **the part decides what the CPU can reach**, not just where the
address lines run.

That would join up with `A17`. A part that drives one high flash address line
*and* gates a memory strobe is doing memory mapping, which is the reading this
file has been circling since pin 73 turned up.

**Two pins settle it, and they are on the '32, not the ASIC.**

* **pin 13** (`4B`) - gate 4's other input. `RD`, `WR` or a CPU chip select
  each imply a different circuit.
* **pin 11** (`4Y`) - its output. If it lands on the flash's or the SRAM's
  `CE#`, `OE#` or `WE#`, the claim above is established outright. If it goes
  somewhere else entirely, the OR is doing something other than decode and this
  paragraph is wrong.

The '32 has three more gates. Whatever they do is unread, and the same two
questions apply to each.

**One reading is now known to be wrong.** `A7` was traced from flash pin 4 and
RAM pin 3 back to `'573` pin 12. `A7` is a low-byte bit, the low byte comes out
of the ASIC, and this net should land on the ASIC's top edge alongside `A0`.
That one wants retaking.

### Bottom edge - the panel and the two handshake lines

Read after the edges above, and it is where the lamps were predicted to be.

| local | pin | signal |
|---|---|---|
| 10 | 10 | `CS` lamp |
| 13 | 13 | `AA` lamp |
| 14 | 14 | `ARQ` lamp |
| 16 | 16 | `HS` lamp |
| 17 | 17 | `SYN` lamp |
| 18 | 18 | `TR` lamp |
| 21 | 21 | `AA` lamp, **second pin** |
| 25 | 25 | `RS` lamp |
| 27 | 27 | `MR` lamp |

Bottom-edge local numbering and absolute numbering are the same thing, so
these need no translation.

`AA` lands on **two** pins, 13 and 21, and that is the one entry here that is
not self-explanatory. Nothing in the firmware writes `AA` twice - it is one bit,
`0x14` bit `0x10`. Two pins on one net is either a doubled drive for lamp
current, a sense return, or one of the two being a different `AA`-labelled net
that the reading merged. It has not been resolved.

Four lamps were traced and are **not** on the ASIC:

| lamp | lands on |
|---|---|
| `RD` | `U22`, an SN75188, pin 2 - driver 1's TTL-side input |
| `CD` | `U23`, an SN75188, pin 4 - driver 2's TTL-side input |
| `OH` | the RA5W-K relay, pin 9 |
| `SD` | CPU pins 4, 7 and 63, and 74AHC04 pin 11 (inverter 5 in); AHC04 pin 10 (inverter 5 out) goes to CPU pin 78 |


## What this settles

### The ASIC is a 16-to-8 width converter

All sixteen DSP data lines are on the package. Only eight CPU lines are -
`AD8`-`AD15` go to the CPU's SRAMs and appear nowhere on the ASIC. So the ASIC
presents a **16-bit port to the DSP and an 8-bit port to the CPU**, and the
width conversion between them is a function of this part, not a property of
either bus.

The 16-bit half of that is a DSP-side finding and transfers to both boards.
The 8-bit half is CPU-side and does not.

That matters for what it appears to settle.
[asic-port-map.md](asic-port-map.md) reads the probe's 64 odd ports returning
`0x00` as the undriven upper byte of a 16-bit register, and an 8-bit CPU
interface would replace that with a simpler explanation - nothing is there. But
**the port sweep was run on the 20.16 MHz board and the bus trace on the 2806**,
and the CPU side is the half that does not cross. The explanation is the better
one only if the two boards share the interface, which is precisely what reading
the 2806's ASIC marking would help establish. Until then it is a candidate, not
a replacement, and the note in that file says so.

### Both directions of the mailbox are now physical

`IS` (DSP pin 90) on ASIC `114` gives the DSP-to-CPU direction: the DSP's I/O
strobe reaches the ASIC, so `out @7d, 0x5e` at `0x83eb` and the stream
coroutine's writes to port `0x60` land in this chip rather than going nowhere.

`INT2` (DSP pin 39) on ASIC `109` gives the other direction, and it is the
interrupt the firmware actually arms: [dsp-pin-probes.md](dsp-pin-probes.md)
records `IMR = 0x002a`, which unmasks `INT2`, `TINT` and `XINT`. The ASIC
drives the one external interrupt the DSP is listening for.

So the CPU-DSP mailbox is a parallel port in this ASIC, written by the DSP
through `IS` and signalled back to the DSP through `INT2`. Nothing about that
is inferred from firmware any more.

### `READY` is tied high, so every wait state is software

DSP `READY` goes to `VDDD`. The C5x samples `READY` to extend an external
access, so tying it high means **no device on either bus ever stretches a DSP
cycle** - the ASIC included. Whatever timing the external SRAMs and the ASIC
need comes entirely from the DSP's own software wait-state generator, which is
what the firmware programs and what
[hardware-timebase-and-audio-path.md](hardware-timebase-and-audio-path.md)
uses as an anchor.

This retires an option: the ASIC is **not** a bus arbiter, and it cannot
throttle the DSP. A mailbox read that is not ready has to be handled in
software, by polling, because the hardware has no way to make the DSP wait.

### The DSP and the codec share one reset net

DSP `RS` (pin 127) does not come from the ASIC. It goes to the codec's pin 8,
which the TLC320AC01 datasheet gives as `RESET` in the FN package. So the DSP
and the codec are held in reset together, by one net.

The harness drives that net from bit 1 of `0xFF56`, a CPU latch in the
peripheral control block, and models **only** the DSP side of it -
[machine.py:2384](../courier_emu/machine.py) floats the DSP's transfer
interface and sets `_dsp_in_reset`, and nothing happens to the codec. On the
board, every one of those pulses also resets the codec, which by the
datasheet's own "conditions of reset" returns its registers to defaults. Any
codec state the firmware set up before a DSP reset is gone afterwards, and the
harness does not know that.

### The ASIC drives the front-panel LEDs

The lamps themselves were mapped long before this trace, and thoroughly:
[dsp-rom-probe.md](dsp-rom-probe.md) has the bit-by-bit table, measured by
driving single bits on a physical unit and watching the panel - `0x14`
active-low carrying CD, CS, AA, ARQ, HS and SYN, `0x12` bit 1 MR, `0x10` bit 0
OH and the relay - and `courier_emu/panel.py` models the latch driver and holds
the nine-lamp list with the self-test order read off the board.

What this trace adds is **which part the latches are in**. No document had
attributed the panel to any silicon; it is this ASIC.

That matters for what the panel can be used for. It is the only output of this
system a person can read without instrumentation: every other observation here
has needed the monitor at its command loop, a flash dump, a port sweep or a
meter, and the panel keeps working through the states none of those reach - the
outage across a reset that [asic-port-map.md](asic-port-map.md) documents as a
structural limit of the monitor, a call in progress, a training sequence that
hangs.

The drive pins are now traced, and they are where that prediction said to
look: eight of them on the bottom edge, in the table above. `OH` is the
exception among the nine, and it is the one the firmware already describes
differently - it drives the hook relay, and the reading finds it at the relay
(RA5W-K pin 9) rather than on the ASIC.

### The RS-232 control lines are very likely in here too

Proposed by the owner from the board, and the firmware analysis has been
predicting it from the other side for some time without anyone joining the two
up.

**Two RS-232 signals are already known to live in ASIC ports.** From
[dsp-rom-probe.md](dsp-rom-probe.md)'s port table: `0x10` bit 0 is the **CD
line to the DTE** - set on connect at `0x92b1`/`0x9380`, cleared on teardown -
and `0x12` reads the **DTE's DTR** at bit `0x40`. An output and an input, both
already attributed, both in the part now known to hold those latches. So the
ASIC demonstrably handles at least two interface lines already.

**Four lamps require it.** The same document notes that RD, SD, TR and RS have
**no latch bit**, and concludes they "are the ones expected to be wired to the
UART and control lines in hardware". Those lamps light. Something drives them
from the data and handshake lines without the firmware writing anything. Since
the ASIC drives the panel, the ASIC is what has those signals - TR from DTR, RS
from RTS, SD and RD from the data pair. That is close to a deduction rather than
a guess, and it is the owner's hypothesis arrived at independently.

**It would explain a failure the harness already records.**
[board-verified-403.md](board-verified-403.md) has an open item: after
`SELF TEST COMPLETED` the real board shows CS, RD and AA moving in a pattern the
emulated run does not reproduce, and it makes no panel writes anywhere near it.
That file's own reading is that the emulator is not missing a write, because
there is no write - the lamps follow the serial lines, and "modelling the panel
as following the serial signals" is what it says is needed. If those lines are
inputs to the ASIC, that is the mechanism, and the discrepancy stops being
mysterious.

#### Traced, and it splits the two pairs apart

The bottom-edge readings answer most of this, and the answer is not uniform:
the **handshake lines are in the ASIC and the data lines are not**.

**The transceiver is found.** It is not a single-chip part but a pair of
**SN75188 quad line drivers, `U22` and `U23`** - the 1488 half of the
1488/1489 pair this section guessed at. Both are recorded in
[board-parts.md](board-parts.md) now. A 75188 is a driver only, TTL in, EIA
out, so it carries the modem-to-DTE direction and nothing else; **the matching
receiver has not been found**, and something has to convert the DTE's `TXD`,
`DTR` and `RTS` down to logic levels. Finding it is the remaining part of this.

**`TR` and `RS` are on the ASIC**, pins 18 and 25. That is the hypothesis above
confirmed on its own terms: `TR` follows the DTE's `DTR`, which port `0x12` bit
`0x40` already reads, and `RS` follows `RTS`, which has no port at all. The ASIC
sees both handshake inputs.

**`RD` and `SD` are not.** `RD` lands on `U22` pin 2 and `SD` on a 74AHC04
inverter between CPU pins - neither touches the package. So of the three
candidate routes this section listed for the data pair, it is the third: the
data lines **reach the ASIC not at all**, and the `SD`/`RD` lamps tap the
transceiver and the CPU's own UART pins instead. The harness running the DTE
through the 80186EB's on-chip UART is right about the data path, and ASIC port
`0x00` is not the serial data path that [dsp-rom-probe.md](dsp-rom-probe.md)
calls it - whatever those 12 sites are doing, it is not moving DTE bytes.

**`CD` is at `U23` pin 4**, the TTL-side input of a driver, which is the same
answer from the other side: the firmware's `0x10` bit 0 drives carrier detect
out to the DTE through that driver, and the lamp is tapped at the driver's
input. Consistent with the ASIC holding the latch; it just means the trace
landed on the transceiver end of the net rather than the ASIC end.

**`CS` is on the ASIC**, pin 10 - an output to the DTE with no established
port, which is one of the three this section asked about. `DSR` and `RI` are
still unaccounted for.

What this changes for [board-verified-403.md](board-verified-403.md)'s open
item - `CS`, `RD` and `AA` moving after `SELF TEST COMPLETED` with no panel
write - is that the three lamps now have three *different* mechanisms, not one.
`AA` is a latch bit the firmware writes. `CS` is an ASIC pin with no port
behind it. `RD` is not in the ASIC at all and follows the 75188's input. A
model that makes the panel "follow the serial signals" has to do it per lamp.

### The second serial port goes to a debug header, not to a device

This is the question [dsp-pin-probes.md](dsp-pin-probes.md) posed and could not
answer: `TDX` is driven constantly by the idle task and nothing accounted for
where the data went.

It goes to **`J7`**, a header:

| DSP signal | DSP pin | lands on |
|---|---|---|
| `TDX` | 107 | `J7` pin 2 |
| `TDR` | 44 | `J7` pin 4 |
| `TFSX` | 105 | `J7` pin 6 |

So the second serial port is not wired to any part on the board. It is brought
out for instrumentation, and the firmware drives it on every pass of the idle
task whether anything is listening or not.

**That is a live diagnostic stream available on real hardware.** Every reading
in this repository so far has come from the monitor, the flash images, or
port sweeps; `J7` is a fourth source, and unlike the monitor it does not need
the supervisor to be at its command loop. What the stream contains is unknown -
the firmware writes `TDXR` from the idle task, and nothing here has looked at
what value.

`TCLKX` (123) is not directly traced, but there is a **100 ohm resistor from it
to `TCLKR` (126)**. That is series termination, which is what a clock driven
off-board into a header wants, and it also explains why `TCLKR` has no source
of its own: the receive clock is the transmit clock. Consistent with the whole
port being a one-way stream out to `J7` with the receive half wired for
completeness and never read - `TDR` is on the header but no instruction reads
it.

## The interrupt map, and why it is not yet a discrepancy

On this board CPU `INT0` (pin 62) is **unconnected**, and the ASIC drives
`INT1` and `INT2` instead. On the 80186 `INT2` is interrupt **type 14, `0x0e`**.

`machine.py` models the board's frame edge as `INT0` - `INT0_VECTOR = 12`,
type `0x0c`, the service the 302 build vectors at `8f43:0000`
([machine.py:585](../courier_emu/machine.py)). Those do not agree, and an
earlier revision of this file called that a harness bug.

**It is not, or at least not yet.** The harness models the 20.16 MHz board
running ID_SDL 302/403; the pin reading is from the 2806 running stock 7.3.14;
and the CPU side is the half that does not transfer between them, because the
supervisor is the whole of what differs between the two images. Two boards are
allowed to wire their interrupts differently, and a supervisor built for each
is where that difference would live.

So there are two separate questions, and only one of them is open here.

* **On the 2806**, which vector does `INT2` reach? That is a fact about a board
  nothing has modelled yet.
* **On the 20.16 MHz board**, is the harness right that the frame edge is
  `INT0`? Nothing above bears on this. It needs that board's own `INT0` pin
  read, which has not been done.

Both are cheap and neither needs a scope. The IVT is at physical `0` and is
RAM, and the monitor reads it - the method
[ram-probe-delivery.md](ram-probe-delivery.md) already uses, which read `08`,
`0d`, `0f` and `12` live. **Read vectors `0x0c` and `0x0e`.** Whichever holds a
real far pointer into flash is the edge that board's ASIC drives. The 80186's
interrupt controller settles it a second way: the `INT0` and `INT2` control
registers in the peripheral block show which input is unmasked.

Doing it on both boards is what would turn this into either a harness bug or a
board difference. Doing it on one leaves it where it is.

## What is still unknown

Seventy-eight of the 120 pins are unread. The bottom edge is now partly read -
nine pins of it - and the other twenty-one are still open. The ones worth
finding next, in the order they would pay:

1. **`A1`-`A7` on the top edge.** `A0` is on pin 70 and thirteen pins of that
   edge are unread. `A1` is RAM pin 9 / flash pin 10 and they walk down from
   there; finding them completes the low-byte latch. The `A7` net previously
   recorded on `'573` pin 12 belongs here and should be retaken.
2. **74VHC32 pins 11 and 13** - the output and other input of the gate ASIC
   pin 71 drives. If the output is a memory `CE#`, `OE#` or `WE#`, the ASIC
   gates memory access and the `A17` pin stops looking like buffering.
3. **Flash `A16` and `A18`, in the same run.** `A17` on pin 73 has no bus
   reason to be there - those lines need no latch - so if `A16` and `A18` are
   also on the ASIC it is buffering the high address, and if they are not, it
   is remapping `A17` alone.
4. **ASIC pin 54** - the one gap in the CPU control group, between `RD#` and
   the interrupts. If that is the chip select decoding `0x00`-`0x7f`, the
   CPU-side interface is complete.
5. **ASIC pin 100** - the gap splitting the DSP data bus into its two halves.
   Probably a supply, and if it is, the pad-ring convention it implies helps
   predict the unread edges.
6. **DSP `A6` (61) and `A7` (62), and a second pass on `A4` (59).** Still the
   hole in the address decode: the firmware writes port `0x60`, which needs
   `A6`, and six lines with a gap at `A4` cannot produce it. At least one more
   address line is on an unread edge.
7. **What `J7` carries.** The second serial port streams continuously to that
   header and nothing knows what is in it. This needs a capture, not a meter,
   and it is the one item here that could produce new information about the
   firmware rather than about the board.
8. **The codec's remaining pins.** `RESET` is shared with the DSP. Whether any
   of the rest reach the ASIC decides the claim in
   [board-parts.md](board-parts.md) that the ASIC fronts the codec and hides
   the AC01/AC03 difference from the DSP.
9. **The EIA-232 receiver.** `U22` and `U23` are drivers only. The DTE's
   `TXD`, `DTR` and `RTS` arrive at EIA levels and something shifts them down;
   `DTR` demonstrably reaches port `0x12` and `RTS` reaches ASIC pin 25, so
   the part is on the board and unidentified. A 75189 next to the two 75188s
   is the thing to look for.
10. **Why `AA` is on two ASIC pins**, 13 and 21, when the firmware drives one
   bit. Cheap to settle with a continuity check between the two.
11. **CPU `INT3` (CPU pin 75) and `INT4`.** `INT3` has been located on the CPU
   but not followed; `INT4` has not been found. With `INT0` unconnected and
   `INT1`/`INT2` on the ASIC, these are what remain of the interrupt map.

### Readings recorded but not yet interpreted

**The `SD` reading mostly resolves against the EB pinout.** `SD` is on CPU
pins 4, 7 and 63 and on 74AHC04 pin 11; AHC04 pin 10 goes to CPU pin 78. With
Table 7 those stop being anonymous. **Pin 7 is `P2.0/RXD1`**, the receive input
of the CPU's second serial channel - exactly where the DTE's transmitted data
should arrive, and independent confirmation that the DTE runs on the CPU's own
UART rather than through the ASIC. **Pin 78 is `T1IN`**, a timer input, so the
AHC04 gate feeds an inverted copy of that same data to a timer, which is what
measuring a bit cell for autobaud - or timing a break - looks like. The harness
has seen the firmware side of this without knowing the wiring:
[machine.py:2357](../courier_emu/machine.py) notes the ROM measuring something
before it enables the receiver.

Two of the three are still unexplained. Pin 4 is `P2.5/BCLK0` and pin 63 is
`INT1` - and `INT1` is separately recorded as reaching ASIC pin 47, so either
one of those readings is wrong or this net is not what it appears. That wants
`SD` re-probed pin by pin rather than as a group.

**A second `RS` is noted as reaching codec pin 13.** On the AC01's FN package
pin 13 is `SCLK`, the serial shift clock, which is not a reset of anything and
would normally come from the DSP's `CLKX`. Either the signal is misnamed in the
notes, or the AC03's pinout differs from the AC01's, or it is a genuinely
different net from the DSP `RS` above. It is recorded here rather than
interpreted because guessing which would put a wrong wire in the map.
