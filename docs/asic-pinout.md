# Pinning out the NEC ASIC

[board-parts.md](board-parts.md) identifies the ASIC only by its marking -
`NEC USA 1-016-905 9948LV001`, a USR part number on an NEC-fabricated gate
array, week 48 of 1999. That is as far as the marking goes: `1-016-905` is
USR's number, `LV001` is NEC's lot code, and the metal is custom. There is no
catalogue part and no datasheet to find. A 120-pin plastic QFP is the usual
body for an NEC customer gate array of that era (the µPD65xxx-family masters),
but the package says nothing about what is inside it.

So the part has to be identified by what it is wired to. This file records
that, from the owner's continuity readings on the 20.16 MHz board - the unit
running ID_SDL 4.03d, supervisor 7.4.16 / DSP 3.1.2, the same board
[asic-port-map.md](asic-port-map.md) probed through the monitor.

## Orientation and pin numbering

The package is 120 pins, 30 a side, with the index dot at the **bottom left**
as the board is read. Under the JEDEC convention - pin 1 at the dot, numbering
counter-clockwise viewed from above - that puts:

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

**This is the one coordinate not yet confirmed.** NEC's own drawings use
counter-clockwise from the top view, which is what the table assumes, but a
clockwise reading is possible and it is not a small difference: clockwise
numbers the same dot as `1`-`30` up the *left* side, which would put the
address bus at pins `31`-`36` instead of `85`-`90` and `IS` at pin `7` instead
of `114`. Both are given below. Confirming it needs one pin identified
independently - a ground, or the pin that reaches the oscillator - not another
count.

## What is connected

| side / local | pin (CCW) | pin (CW) | signal |
|---|---|---|---|
| top 1 | 90 | 31 | power or ground, unresolved |
| top 2 | 89 | 32 | DSP `A0` |
| top 3 | 88 | 33 | DSP `A1` |
| top 4 | 87 | 34 | DSP `A2` |
| top 5 | 86 | 35 | DSP `A3` |
| top 6 | 85 | 36 | DSP `A5` |
| top 7-14 | 84-77 | 37-44 | CPU `AD0`-`AD7` |
| right 8 | 53 | 68 | CPU `INT2`/`INTA0#` (CPU pin 64) |
| right 14 | 47 | 74 | CPU `INT1` |
| left 7 from bottom | 114 | 7 | DSP `IS` (DSP pin 90) |

DSP `A4` is **not connected**. CPU `INT0` (CPU pin 62) is **not connected**.
CPU `AD8`-`AD15` reach the CPU's SRAMs and do not appear on the ASIC.

## Three things this settles

### The ASIC decodes the DSP's I/O cycles

[dsp-pin-probes.md](dsp-pin-probes.md) put this as the one pin that decides how
the mailbox travels: `IS` is the C50's I/O-space select strobe, it goes low for
an `IN`, an `OUT` or a `PA0`-`PA15` access and for nothing else, so continuity
from DSP pin 90 to the ASIC decides between a parallel mailbox and some other
route. **It is connected.** The mailbox really is parallel, across the same bus
the DSP's SRAMs sit on, and the `out @7d, 0x5e` at `0x83eb` and the stream
coroutine's writes to port `0x60` land in this chip.

### The ASIC is byte-wide on the CPU side

[asic-port-map.md](asic-port-map.md) reads the probe's all-zero odd ports as
16-bit registers whose high half nothing drives - the monitor reads a byte, so
the odd address returns an undriven upper byte. That reading is now wrong.
`AD8`-`AD15` go to the SRAMs only; they are not on the package. The ASIC is a
**byte-wide device decoded on even addresses**, and the 64 odd ports reading
`0x00` is the bus, not an undriven half of a register.

### The DSP address decode is incomplete, and not contiguous

`A0`-`A3` are present, `A4` is absent, `A5` is present. Two things follow.

The decode is **not contiguous**, so `A5` is not simply the sixth bit of a
64-location select - it qualifies something. And these six lines are **not
enough for the ports the firmware actually writes**: the mailbox sender at
`0x83eb` writes `0x5e` and `0x5f` and the stream coroutine at `0x84b7` writes
`0x60`, and `0x60` needs `A6`. So at least one more DSP address line lands on a
side that has not been read yet. Finding it, and finding what `A4`'s absence
means, both wait on the remaining three edges.

## One discrepancy, and how to settle it

**The harness drives the wrong interrupt.** `machine.py` models the board's
frame edge as `INT0` - `INT0_VECTOR = 12`, type `0x0c`, the service the 302
build vectors at `8f43:0000` - and the comment at
[machine.py:585](../courier_emu/machine.py) says so outright. The board says
`INT0` is unconnected and the ASIC drives `INT2` and `INT1` instead. On the
80186 `INT2` is interrupt **type 14, `0x0e`**, not `0x0c`.

So either the vector-table reading that named the service is right and the pin
reading is mislabelled, or the harness has been raising a type the hardware
never raises and it works only because the firmware's service happens to be
reachable both ways.

This is cheap to decide and does not need a scope. The IVT is at physical `0`
and is RAM, and the monitor reads it - that is the method
[ram-probe-delivery.md](ram-probe-delivery.md) already uses, which read
`08`, `0d`, `0f` and `12` live. **Read vectors `0x0c` and `0x0e` on the running
board.** Whichever one holds a real far pointer into flash is the edge the ASIC
drives. The 80186's interrupt controller settles it a second way: the `INT0`
and `INT2` control registers in the peripheral block will show which input is
unmasked.

`INT1` at right 14 is a second ASIC interrupt on a line the harness already
uses for the ROM's serial engine ([machine.py:582](../courier_emu/machine.py)).
Whether that is a conflict or whether the serial engine's `INT1` is a different
build's arrangement is not resolved here.

## What is still unknown

Ninety-eight of the 120 pins are unread. The ones worth finding next, in the
order they would pay:

1. **A ground or the oscillator pin**, to fix the numbering direction and make
   every number above absolute rather than conditional.
2. **The CPU's address latch and strobes** - `ALE`, `RD#`, `WR#`, and whatever
   chip select decodes the ASIC's `0x00`-`0x7f` I/O window. The window's top
   at `0x7f` is a decode somebody chose, and the pin that implements it is on
   this package.
3. **DSP pin 107, `TDX`.** [dsp-pin-probes.md](dsp-pin-probes.md) calls this
   the pin that identifies the far end of the DSP's second serial port, which
   is driven constantly and which nothing has yet accounted for. If it lands on
   the ASIC, the ASIC is the far end.
4. **The codec.** The AC01 is on the DSP's primary serial port, but
   [board-parts.md](board-parts.md) argues the ASIC fronts the codec variant
   from the DSP - if any of the codec's pins reach this chip, that argument has
   a wire behind it.
