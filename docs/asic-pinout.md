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

![The ASIC's pins as currently mapped](asic-pinout.svg)

That picture is generated from `tools/draw_asic_pinout.py`, which holds the map
as data. It is drawn rather than parsed from this file, so when a reading lands
or is corrected, edit the table here **and** `PINS` there, then re-run the tool.

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
| 17 | 74 | a high flash address line - read as flash pin 3 (`A17`, system `A18`) and later as flash pin 34 (`A16`, system `A17`); see below |
| 20 | 71 | latched `A0` **out** - 74VHC32 pin 12 (`4A`), the low byte lane's term in `U12`'s `WE#` |
| 21 | 70 | latched `A1` **out** - RAM pin 10 and flash pin 11, which are those parts' own `A0` |
| 22-26 | 69-65 | latched `A2`-`A6` **out** *(inferred)* |
| 27 | 64 | latched `A7` **out** - RAM pin 4, which is that part's `A6` |
| 28 | 63 | CPU `AD15` **in** - CPU pin 28 |
| 29 | 62 | CPU `A17` **in** - CPU pin 30 |
| 30 | 61 | `VCC` |

Only locals 15-16 (`76`-`75`) and 18-19 (`73`-`72`) are unread on this edge.
This edge is the address side of the part: see below.

> **One row was renumbered.** The flash address pin was read with the top edge
> miscounted from 60 rather than 61, so it is `74`, not the `73` first reported.
> The owner confirms the miscount was confined to that reading: pins `71` and
> `70` stand as given.

### Right edge - the CPU control group

| local | pin | signal | CPU pin |
|---|---|---|---|
| 1 | 60 | `GND` | - |
| 4 | 57 | `ALE` | 38 |
| 5 | 56 | `WR#` | 37 |
| 6 | 55 | `RD#` | 36 |
| 7 | 54 | *unread* | - |
| 8 | 53 | `INT2`/`INTA0#` | 64 |
| 14 | 47 | `INT1` | - |
| 23 | 38 | phone-line header pin 6 | - |
| 24 | 37 | phone-line header pin 5 | - |

`ALE`, `WR#` and `RD#` land adjacent, which makes this edge the CPU-side bus
control group and gives **pin 54 as the prime suspect for the chip select**
that decodes the `0x00`-`0x7f` I/O window. That window's top at `0x7f` is a
decode somebody chose, and its pin has to be somewhere; one pin between `RD#`
and the first interrupt is where it would sit.

CPU `INT0` (CPU pin 62) is **not connected**.

**The lower half of this edge is not CPU at all.** `37` and `38` go to the
**phone-line header**, pins 5 and 6. The CPU control group sits at locals 4-14;
these are at 23 and 24, well down the edge, with eight unread pins between. So
the right edge is two groups, not one, and the second is the telco side.

That is the first pin on this package to reach the line interface, and it does
not arrive without a firmware counterpart waiting for it. Two line signals are
already attributed to ASIC ports and neither had any physical evidence:

* **Ring sense**, port `0x14` bit `1`. [daa-line-interface-2016mhz.md](daa-line-interface-2016mhz.md)
  has the cadence machine sampling it directly from a 5 ms ticker - `in al,
  0x14` / `test al, 2` at `0x1501d` - so this is an **input** the ASIC latches
  for the CPU to poll.
* **The hook relay**, port `0x10` bit `0`, which [dsp-rom-probe.md](dsp-rom-probe.md)
  records as clicking with the `OH` lamp. An **output**.

An input and an output, both line-side, both in this part's ports, and now two
line-side pins on the package. The obvious pairing is that these are those two,
but **nothing here establishes which pin is which, or that the pairing is right
at all** - a header carries whatever the board put on it.

**What to read next is the header itself.** Its pinout is unknown and it is
cheap: pins 1-6 against ground, the relay coil, and the `RA5W-K`. Two specific
checks would settle the pairing - continuity from ASIC `37` or `38` to the
relay's coil terminals names the hook output, and whichever of the two changes
state when the line rings is the ring sense.

**One thing the header is probably not is bare tip and ring.** A digital gate
array cannot sit on a telephone line; there has to be a transformer or an opto
between, and the header is far likelier to be a **DAA module interface carrying
logic-level signals** than the line itself. [board-parts.md](board-parts.md)
says outright that "the DAA/line section is" outside the photograph it was
compiled from, so that module is unidentified, and identifying it is the same
outstanding item as the EIA-232 receiver - a part everyone knows is there that
nobody has looked at.

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
| 25 | 115 | DSP `R/W` (pin 92) |
| 26 | 116 | DSP `STRB` (pin 93) |
| 28 | 118 | a supply - DSP `VSSC`/`VDDI`, decoupled |
| 29 | 119 | DSP `X2/CLKIN` (pin 96) - **the ASIC clocks the DSP** |
| 30 | 120 | `GND` |

The five measured data pins fall in two exact descending runs - `99`-`92` for
`D8`-`D15` and `101`-`108` for `D7`-`D0` - so the twelve unread ones between
them are inferred, not read. **Pin 100 sits between the two groups** and is not
part of either; a ground or supply splitting the bus halves is the obvious
candidate and it has not been checked.

Pins `91`, `110`-`113` and `117` are unread - six of the thirty.

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
`A17`, which is also the ASIC, on pin 74.

**The outputs are on the top edge, not where the last revision guessed.** It
predicted the unread `28`-`46` run at the bottom right; `A0` is at 71, `A1` at 70 and the flash's high
address bit at 74, both on the top edge, in the run this file had already flagged as
the neighbours of the `A17` pin. So the top edge is the address side of the
package end to end: `AD0`-`AD7` in at locals 7-14, latched address out at
locals 18 and 21, with locals 15-17, 19-20 and 22-30 still unread between and
around them.

That is thirteen unread pins on one edge for the seven remaining low-address
bits, and it is now the cheapest high-value trace on the part - `A1` is RAM pin
9 and flash pin 10, and they walk down from there. If `A1`-`A7` are in that run
the low-byte latch is fully mapped, and whatever is left over on that edge is
the next question.

**The high flash address line is the odd one out and stays odd.** The CPU's
high address lines are non-multiplexed outputs that need no latch, so there is
no bus reason for one of them to come out of the ASIC. Routing it through a part
that also holds a latch is what **remapping** looks like, not buffering. Which
bit it is has been read two ways - see the conflict noted below, along with the
one-bit shift that makes every flash address label one less than the system
address it carries.

#### The two SRAMs are a 16-bit pair, and the ASIC supplies the byte lane

Two more readings finish the memory decode, and they deflate the claim the
previous revision made from a partial view of it.

| reading | |
|---|---|
| '32 pin 12 (`4A`, in) | ASIC pin 71 |
| '32 pin 13 (`4B`, in) | flash pin 43, `WE#` - the board write strobe |
| '32 pin 11 (`4Y`, out) | SRAM `U12` pin 27, `WE#` |
| '32 pin 8 (`3Y`, out) | SRAM `U4` pin 27, `WE#` |
| both SRAMs' `CE#` | **CPU pin 60, `LCS`** |

**The CPU does its own chip select.** `LCS` reaches both SRAMs directly, so the
ASIC is not decoding the RAM, and the previous revision's stronger reading -
that the ASIC owns the SRAM's decode - is excluded outright. That was the probe
this file asked for and it came back against the claim.

**Both SRAMs share one select and have separate write enables, which says what
they are.** Two 32Kx8 parts enabled together, on a CPU with a 16-bit data bus,
are not two banks: they are the **low and high byte lanes of one 32K x 16
memory**. Steering a byte write to one lane or the other is then done exactly
the way this board does it - a `WE#` per lane, each `OR`ed from the common
write strobe and a lane term. That is what gate 4 and gate 3 are, one lane each.

So ASIC pin 71 is the **low lane's term**, and on any 16-bit 80186 design that
term is `A0`. The ASIC latches `A0`-`A7`; `A0` is the bit that never reaches a
memory's address pins in a 16-bit system, because it selects the lane instead.
Which is why pin 70, the other address output found so far, lands on the
memories' own `A0` pins - **that is system `A1`**, and the whole latched address
is shifted by one at the parts.

**The veto reading is withdrawn.** The previous revision had the ASIC holding a
term of the SRAM's write enable and concluded it could stop a CPU write and that
firmware could not route around it. The gate is real and the term is real, but
the term is an address bit doing byte steering, not a permission. Nothing is
being gated in the sense that claim meant. The ASIC's role here is the one
already established - it is the low-byte address latch - and this is that same
job seen from the memory's side.

This is also the arrangement [board-parts.md](board-parts.md) already records
on the other side of the board, where the DSP's `CY7C199` pair is described as
"2 x 32Kx8, 64 KB = 32K words on a 16-bit bus". The CPU's pair is the same
thing and was not recognised as such until its `CE#` lines were read.

**Confirmed.** `'32` pin 9 is `3A` and goes to **CPU pin 39, `BHE#`**; `'32`
pin 10 is `3B` and goes to **CPU pin 37, `WR#`**. So the strobe both gates share
is the CPU's write strobe unmodified, and the flash's `WE#` on pin 43 is that
same net reaching the flash directly. The two gates are

```
U12 WE#  =  ASIC pin 71 (A0)  OR  write strobe      - low byte lane
U4  WE#  =  CPU BHE#          OR  write strobe      - high byte lane
```

which is byte-lane steering on a 16-bit bus, complete and unambiguous. `U12`
carries `D0`-`D7`, `U4` carries `D8`-`D15`, both enabled together by `LCS`.

The asymmetry between the two lane terms is the bus's own. `A0` arrives
**latched, from the ASIC**, because `AD0` is multiplexed and there is nothing
else on the board that holds it. `BHE#` arrives **raw from the CPU**, because on
the 80C186EB it is a dedicated pin and never needed latching. Two different
routes for the two halves of the same decision, each the only route available.

That is the memory decode closed for the SRAM, and it settles ASIC pin 71 as
latched `A0` rather than anything more interesting. Gates 1 and 2 of the '32 -
pins 1-3 and 4-6 - are still unread.

#### Every address label at the memories is shifted by one

The consequence is worth stating separately, because it re-reads an earlier
finding.

On a 16-bit bus `A0` selects the lane and never reaches a memory's address
pins. So each part's `A`n is system `A`n+1, and the readings in this file that
name a memory's own pin numbers have to be translated before they mean a system
address. Pin 70 is the visible case: it lands on RAM pin 10 and flash pin 11,
both of which those parts call `A0`, and it is **system `A1`**.

**`BYTE#` is tied high**, so the flash is in word mode and the shift is
confirmed rather than inferred. The flash has `A0`-`A17` addressing 256K words,
which is the 512 KiB the dump measures, and its `A`n is system `A`n+1 exactly as
the SRAM's is.

Which sharpens the question that pin has always posed - and puts a conflict in
the middle of it.

**ASIC pin 74 has been read as two different flash pins.** First as flash pin
3, `A17`, which is system `A18`. Then, answering this file's request for flash
`A16`, as **flash pin 34**, which is `A16` and system `A17`. One ASIC pin cannot
carry two address bits, so one reading supersedes the other, and the later one
was taken deliberately in answer to a question rather than in passing - which
is a reason to prefer it, not a proof.

It does not change the shape of the finding. Either way **the ASIC drives one
high flash address line**, and the other one has to come from somewhere else.
What changes is which bit, and that matters for the remapping reading: `A18`
swaps the flash's two 256 KiB halves, `A17` swaps 128 KiB quarters within a
half.

**Two probes settle it, and they settle it from the other end.** Flash pin 3
and flash pin 34 each go somewhere. One of them is ASIC pin 74; the other should
be a direct CPU output - **CPU QFP pin 31 (`A18`)** for flash pin 3, **pin 30
(`A17`)** for flash pin 34. Whichever flash pin lands on the CPU is the one the
ASIC does *not* drive, and it names the other by elimination.

If instead **both** flash pins reach the ASIC, on 74 and on one of its unread
neighbours, then the part is buffering the high address rather than remapping a
single bit of it, and the interesting reading is dead. That is the outcome this
file has been asking after since pin 74 first turned up, and it is now one
continuity check away.

#### The low-byte latch is complete, `71` down to `64`

**ASIC pin 64 goes to RAM pin 4**, and that pin is the one this file had
already predicted without knowing it. The latched outputs run contiguously
down from 71:

| ASIC pin | system address | where it goes |
|---|---|---|
| 71 | `A0` | '32 pin 12 - byte lane, never reaches a memory |
| 70 | `A1` | RAM pin 10, flash pin 11 - those parts' `A0` |
| 69-65 | `A2`-`A6` | *inferred* |
| 64 | `A7` | RAM pin 4 - that part's `A6` |

Eight consecutive pins for the eight bits the ASIC latches off `AD0`-`AD7`,
with the one-bit shift landing `A7` on the SRAM's `A6` exactly. The five in the
middle are inferred from both ends being measured and in order, the same
standard the DSP data bus runs in this file are held to.

> The reading named RAM pin 4 as `A8`. On the JEDEC 28-pin 32Kx8 pinout that
> all three of the board's SRAM types share, **pin 4 is `A6`** - and `A6` at
> that part is system `A7`, which is what the run predicts for pin 64. The pin
> number fits perfectly and the label does not; applying the one-bit shift
> twice, or in the wrong direction, gives exactly `A8`. Recorded as the pin
> number, which is what was measured.

That closes the low byte. `AD0`-`AD7` in on `84`-`77`, `ALE` in on `57`,
`A0`-`A7` out on `71`-`64` - the whole latch, both sides, on one part.

#### The ASIC takes `A17` in, which is the other end of the remap

**Pin 62 is CPU pin 30, `A17`.** A high address line, non-multiplexed, going
*into* the ASIC.

This is the finding the flash address pin has been waiting for. Pin 74 drives a
high flash address line **out**; pin 62 takes a high system address line **in**.
A part with an address bit on each side of it is not buffering - a buffer needs
no other input to decide with, and the ASIC has `A0`-`A7` latched and `A17`
besides. **The remapping reading now has both ends**, and it stops being an
inference from one anomalous pin.

What it cannot yet say is the mapping. If pin 74 is flash `A17` (system `A18`)
then the part takes system `A17` in and drives system `A18` out, which is a
shift as well as a remap. If pin 74 is flash `A16` (system `A17`) then in and
out are the same bit and the part is either buffering it after all or
substituting for it conditionally. **That is the flash pin 3 / pin 34 conflict
again**, and it now decides something bigger than which bit: it decides whether
there is a shift.

#### `AD15` on pin 63, which the width-converter claim did not expect

**Pin 63 is CPU pin 28, `AD15`.**

[What this settles](#the-asic-is-a-16-to-8-width-converter) above says only
`AD0`-`AD7` are on the package, and concludes the ASIC presents an 8-bit port
to the CPU. One line of the high byte being here does not overturn that - eight
pins would, and seven of them are elsewhere - but it does mean the claim was
made from an incomplete edge and needs qualifying rather than repeating.

A single high `AD` line is not a data path. What it is good for is **decoding**:
`AD15` latched is `A15`, and `A15` with `A17` and the low byte is the beginning
of an address comparator. A part that has to recognise its own `0x00`-`0x7f`
window, and that is already taking `A17` in for the flash, would want exactly
this sort of assortment. That is a reading, not a finding.

**The remaining unread pins on this edge are `76`, `75`, `73` and `72`** - four
of thirty. Whatever else the ASIC watches on the CPU bus is in there, and the
edge is otherwise accounted for end to end.

#### The corners are supplies, which corroborates the numbering

`61` is `VCC` and `60` is `GND` - the top-right corner pair, the last pin of the
top edge and the first of the right. The top-left corner already had `90` on
`VDD`, shared with the DSP's `VDDD`.

Supply pads at the corners is the gate-array convention this file noted when it
could not use it: a corner pad is a supply under *either* numbering direction,
so the top-left one settled nothing about which way the numbers ran. Two corners
is different in one respect only - it confirms the **30-a-side count** from a
second place, since the run from `61` to `90` is exactly one edge and both its
ends are now known.

#### The memories sit on the CPU's raw `AD` bus

**Flash pin 22 goes to CPU pin 20.** The Am29F400B diagram gives flash pin 22
as `DQ11`; the 80C186EB QFP table gives CPU pin 20 as `AD11`. A data line
straight to the matching multiplexed bus line, with nothing in between.

Small, and it closes a hole. Every finding above is about *address*: the ASIC
latching the low byte, the '573 the high, the '32 steering lanes, `LCS` and the
high bits. None of it said how **data** reaches the memories, and the answer is
that it does not go anywhere - the flash and the SRAM pair hang directly on
`AD0`-`AD15`, and the parts do their own address/data separation using the
strobes. No buffer, no transceiver, nothing to find.

It also draws the boundary of what the ASIC touches. The ASIC has `AD0`-`AD7`
only, as an **input**, for latching. The memories have all sixteen, as data. So
the two are on the same wires for different reasons, and the ASIC's own 8-bit
CPU port - the `0x00`-`0x7f` window - shares the bus with a 16-bit memory
system rather than fronting it.

#### The flash pin numbering is confirmed, and one old net reading is not

The same datasheet checks the frame these readings were taken in, and it holds:

| flash pin | the readings say | Am29F400B 44-SO | |
|---|---|---|---|
| 3 | `A17` | `A17` | ok |
| 4 | `A7` | `A7` | ok |
| 11 | `A0` | `A0` | ok |
| 43 | *(this reading)* | `WE#` | - |

Three for three, so the flash pin numbers in this file can be trusted the way
the CPU's now can.

Which condemns one net. `'573` pin 19 was recorded as reaching **RAM pin 1 and
flash pin 20**, and flash pin 20 is `DQ10` - a *data* line - while RAM pin 1 is
`A14`, an address line. No latch output is both. That reading was already
suspect on other grounds; it is now excluded by the pinout itself and needs
retaking rather than reinterpreting.

**One reading is now known to be wrong.** `A7` was traced from flash pin 4 and
RAM pin 3 back to `'573` pin 12. `A7` is a low-byte bit, the low byte comes out
of the ASIC, and this net should land on the ASIC's top edge alongside `A0`.
That one wants retaking.

#### The ASIC clocks the DSP

**ASIC pin 119 goes to DSP pin 96, `X2/CLKIN`.** Not pin 97, `X1`, which an
earlier reading gave and which would have been a circuit that should not exist -
`X1` only carries anything with a crystal across it, and this board clocks from
a can.

`X2/CLKIN` is the DSP's external clock input. **The DSP's clock comes out of the
ASIC.**

That is a different kind of fact from the rest of this file. Every other pin
here is a signal the firmware moves or a wire the address decode needs; this one
sets the rate at which the DSP executes anything at all. The `ECLIPTEK EC11
40.320M` can that [board-parts.md](board-parts.md) identifies is the board's
one oscillator and it feeds the CPU; the DSP does not get it directly, it gets
whatever the ASIC produces from it.

**What that opens.** The ASIC is now positioned to divide the DSP's clock, gate
it, or stop it - and nothing in this repository has ever considered that the
DSP's machine cycle might not be a board constant.
[hardware-timebase-and-audio-path.md](hardware-timebase-and-audio-path.md)
derives the harness's timing from the oscillator and the DSP's software wait
states, and [dsp-pin-probes.md](dsp-pin-probes.md) and the rest of the DSP-side
work take the rate as given. None of that is *wrong* - a fixed divide is the
likeliest thing the ASIC does here, and the firmware's own timing numbers have
been checked against a real board - but it was being assumed rather than known,
and it is now a property of a part with registers in it.

**The number is the thing to establish.** 40.320 MHz divided by two is 20.16,
which is the CPU's `CLKOUT`; the DSP's divide-by-2 mode would then give a 10.08
MHz machine cycle from a 20.16 MHz input. Whether the ASIC passes 40.320 through,
halves it, or produces something unrelated is a scope measurement at DSP pin 96
and nothing else will answer it. `CLKMD1` (DSP pin 71) and `CLKMD2` (pin 103)
say what the DSP then does with it - `0`/`0` or `1`/`1` both select the external
divide-by-2, and those are meter readings.

#### The ASIC is the DSP's entire external bus interface

`115` is DSP `R/W` (pin 92) and `116` is DSP `STRB` (pin 93). With `IS` on 114
and the sixteen data lines down the edge, the ASIC now has **the DSP's complete
external bus control group**: the space select, the strobe, and the direction.

This is more than the mailbox this file had established. `IS` alone showed that
DSP I/O writes land in the ASIC. `R/W` means the part can tell a read from a
write, so **the DSP can read the ASIC**, not only write to it - which is what
the polling loop the `READY` finding requires has to do, and which had no
physical evidence until now. `STRB` gives it the timing edge to do so within the
wait states the DSP's software generates.

Put beside the clock pin, the shape of the DSP subsystem is that the ASIC
supplies its clock and is its external bus. The SRAM pair is the only other
thing on that bus.

#### A third corner supply

`120` is `GND`. That is the bottom-left corner - the last pin of the left edge,
adjacent to pin 1 at the index dot. With `90` at the top left and `61`/`60` at
the top right, three of the four corners are now known to be supplies, which is
the pad-ring convention holding up everywhere it has been checked.

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
`AD8`-`AD15` go to the CPU's SRAMs and appear nowhere on the ASIC.

> **One exception since found.** `AD15` is on pin 63. Seven of the high byte's
> eight lines are still absent, so the conclusion below stands - one line is not
> a data path - but "appear nowhere" was written from an unread edge and is no
> longer true. What `AD15` is doing there is taken up with the top edge. So the ASIC
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

`R/W` on ASIC `115` and `STRB` on `116` complete the group and answer the
question this section left standing. The mailbox is not write-only: the ASIC
knows a DSP read from a DSP write and has the strobe to time it, so the polling
loop that the `READY` finding below says the software must run has a physical
read path to poll.

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

### The DIP switches are read two different ways, and only one is the ASIC

**DIP switch 1 goes to CPU pin 80.** The 80C186EB QFP table gives that as
**`P2.6`** - a plain general-purpose port pin, no alternate function. So switch
1 is not in the ASIC at all: the CPU reads it directly, in `P2PIN` at `0xff5a`,
bit `0x40`.

The harness already lives in that register. `machine.py` models **bit 7** as the
93C66 EEPROM's data line and **bit 5** as the serial receive the ROM's autobaud
timer samples ([machine.py:2340](../courier_emu/machine.py),
[machine.py:2345](../courier_emu/machine.py)). **Bit 6 is not modelled**, so a
read of it returns whatever the emulated register happens to hold rather than a
switch position. That is a small, concrete harness item and the first one this
pinout work has produced.

> A comment near that code calls `ff5a` an "ASIC latch". It is not - `0xff5a`
> is the 80186EB's own `P2PIN` in its peripheral control block. The behaviour
> it describes is unaffected; the name is wrong.

#### But switch 1 is the DTR override, and the firmware reads that elsewhere

The owner reports what switch 1 *does*: off is DTR normal, on is DTR always
asserted. That is the documented function of a Courier's first DIP switch, and
it raises the possibility that **`P2.6` carries the DTR signal rather than the
switch** - the switch shorting the DTR sense line to its asserted level would
produce exactly that behaviour in hardware, with no firmware involvement at all.

It is a good hypothesis and it has to be taken seriously, because the behaviour
does not distinguish the two cases. Firmware reading a strap and hardware
forcing a line both give "DTR always on".

**The wiring does distinguish them, and there is already a reason to doubt the
simple reading.** `courier_emu/panel.py` maps `dtr-override` to **ASIC port
`0x12` bit `0x20`** on the XMF supervisor, recovered at `0x63d31`/`0x63d48`
where a closed switch leaves `S14` at zero - and `S14` bit 0 is what `0x5e89f`
tests before turning a low DTR reading into event 10. The 302/403 ROM builds
read the same switch, also on port `0x12` bit `0x20`, through a different
selector. So on **both** firmware families this file has mapped, switch 1 is a
strap the firmware reads through the ASIC, and the override is done in software.

If the 2806 routes it to `P2.6` instead, that is a **third** switch wiring. Not
impossible - `panel.py` already carries two that disagree, and this file's own
rule is that CPU-side findings do not cross between boards - but it is a claim
that needs more than one continuity reading.

**The decisive measurement is the switch's other terminal.** One probe:

* to **ground or `VCC`** - it is a strap, `P2.6` reads the switch, and the 2806
  reads its DTR override on a pin no other build uses.
* to the **DTR net** - the owner's reading is right, the override is hardware,
  and `P2.6` is watching a line rather than a switch.

A second check separates them live: unplug the DTE so nothing asserts DTR, then
toggle switch 1. A pin that follows the switch with no terminal attached is a
strap; a pin that only moves when a DTE asserts DTR is the signal.

Worth knowing either way that **DTR already has a home in this file** - ASIC
port `0x12` bit `0x40`, `dte-dtr`, and the `TR` lamp on ASIC pin 18 follows it.
A second DTR path to the CPU would be redundant unless the 2806 moved the whole
line off the ASIC, which nothing else suggests.

#### The rest of them are a scanned matrix, which is why the meter misbehaves

The other switches read oddly with a meter, and there is a specific reason to
expect that: **the firmware scans them**, and a scan needs a shared return.

`courier_emu/panel.py` has the whole arrangement named already, recovered from
the supervisor's strap scan at `0x5bfc6` - four drive lines and one common
sense, all of them ASIC ports:

| line | port | bit | driven at |
|---|---|---|---|
| `id-strap-drive-a` | `0x14` | `0x40` | `0x5bfed` |
| `id-strap-drive-b` | `0x12` | `0x02` | `0x5c001` |
| `id-strap-drive-c` | `0x14` | `0x10` | `0x5c015` |
| `id-strap-drive-d` | `0x14` | `0x20` | `0x5c03d` |
| `id-strap-sense` | `0x14` | `0x08` | *read* |

Each drive is pulled low in turn and the common return is sampled. **Every
switch on that matrix is therefore wired to every other one through the sense
line**, and a continuity check with the board unpowered finds exactly that: a
probe on one switch reads through the closed contacts of its neighbours and the
common return. Weird readings are the expected result of metering a matrix, not
evidence against the switches being on the ASIC.

So the picture is a switch the CPU reads directly and a group the ASIC scans -
which fits, because a board-ID strap is read once at boot and a DIP switch the
user flips wants to be readable whenever.

**Do not meter it - read it live.** The instrument is already on the board. The
monitor can drive `0x12` and `0x14` and read `0x14` back, so: pull one strap
drive low, read bit `0x08`, flip each DIP switch in turn, and the one that
changes the sense bit is on that drive line. Four passes name four switches
without a meter touching anything, and it reads through whatever resistors and
diodes are making the meter lie.

**The arithmetic does not close yet.** Four drives and one sense read four
straps; switch 1 is a fifth, on the CPU. A Courier's DIP bank has more positions
than that, so either there are further sense lines not yet found in the
firmware, or some switches are not read by either part - strapped options that
only change hardware behaviour. The live scan above would show which, since a
switch that moves no readable bit is in the second group.

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

Fifty-two of the 120 pins are unread. Of the sixty-eight that are not,
seventeen are inferred middles of a measured run rather than measurements - the
two DSP data groups and `A2`-`A6`. **The top edge is finished but for four pins
and the left edge but for six**; the bottom is nine of thirty; the right edge has two groups started and eight
pins unread between them, and it still holds the ASIC's own chip select.
The ones worth finding next, in the order they would pay:

1. **The frequency at DSP pin 96.** The ASIC drives the DSP's clock, and no
   document here knows what rate it produces. A scope on that pin is the only
   thing that answers it, and the DSP's machine cycle - which the timebase note
   and every DSP-side analysis treat as a board constant - follows from it.
   `CLKMD1` (DSP pin 71) and `CLKMD2` (pin 103) say what the DSP divides it by,
   and those are meter readings.
2. **The phone-line header's pinout**, and which of ASIC `37`/`38` is the
   hook relay drive and which the ring sense. Continuity to the `RA5W-K`'s coil
   names the output; watching the pair while the line rings names the input.
   The DAA module on the far side of that header is unidentified.
3. **What is on the other side of DIP switch 1** - ground/`VCC` makes it a
   strap on `P2.6`; the DTR net makes `P2.6` the signal and the override
   hardware. Both firmware families already mapped read this switch through
   ASIC port `0x12` bit `0x20` instead, so either answer says something.
4. **Which DIP switch is on which strap drive**, read live through the
   monitor rather than with a meter - drive one of `0x12`/`0x02`,
   `0x14`/`0x40`, `0x14`/`0x10`, `0x14`/`0x20` low and watch `0x14` bit `0x08`
   while flipping each switch. It also shows which switches are read by nothing.
5. **Top-edge pins `76`, `75`, `73` and `72`** - the four left unread on the
   edge that holds everything else the ASIC does with the CPU bus. Two of them
   sit between the flash address pin and the latched run, which is where a
   second high address line would be if the part takes more than `A17`.
6. **Flash pins 3 and 34, both ends.** ASIC pin 74 has been read as each of
   them and can only be one. With `A17` now known to go *into* the ASIC on pin
   62, this decides whether the part shifts the address it remaps or leaves it
   in place. Whichever lands on a direct CPU output - pin 31
   (`A18`) or pin 30 (`A17`) - is the one the ASIC does not drive. If both
   reach the ASIC, it is buffering the high address rather than remapping a
   bit, and the interesting reading is dead. Flash `CE#` (pin 12) should be CPU
   `UCS` (QFP pin 61) and would finish the decode.
7. **The `A7` net at flash pin 4 and RAM pin 3**, recorded as running to
   `'573` pin 12. The '573 latches `A8`-`A15` and cannot carry `A7`; the ASIC
   drives system `A7` from pin 64. That reading should be retaken toward the
   ASIC.
8. **ASIC pin 54** - the one gap in the CPU control group, between `RD#` and
   the interrupts. If that is the chip select decoding `0x00`-`0x7f`, the
   CPU-side interface is complete.
9. **ASIC pin 100** - the gap splitting the DSP data bus into its two halves.
   Probably a supply, and if it is, the pad-ring convention it implies helps
   predict the unread edges.
10. **DSP `A6` (61) and `A7` (62), and a second pass on `A4` (59).** Still the
   hole in the address decode: the firmware writes port `0x60`, which needs
   `A6`, and six lines with a gap at `A4` cannot produce it. At least one more
   address line is on an unread edge.
11. **What `J7` carries.** The second serial port streams continuously to that
   header and nothing knows what is in it. This needs a capture, not a meter,
   and it is the one item here that could produce new information about the
   firmware rather than about the board.
12. **The codec's remaining pins.** `RESET` is shared with the DSP. Whether any
   of the rest reach the ASIC decides the claim in
   [board-parts.md](board-parts.md) that the ASIC fronts the codec and hides
   the AC01/AC03 difference from the DSP.
13. **The EIA-232 receiver.** `U22` and `U23` are drivers only. The DTE's
   `TXD`, `DTR` and `RTS` arrive at EIA levels and something shifts them down;
   `DTR` demonstrably reaches port `0x12` and `RTS` reaches ASIC pin 25, so
   the part is on the board and unidentified. A 75189 next to the two 75188s
   is the thing to look for.
14. **Why `AA` is on two ASIC pins**, 13 and 21, when the firmware drives one
   bit. Cheap to settle with a continuity check between the two.
15. **CPU `INT3` (CPU pin 75) and `INT4`.** `INT3` has been located on the CPU
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
