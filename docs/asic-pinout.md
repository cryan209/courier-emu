# Pinning out the NEC ASIC

[board-parts.md](board-parts.md) identifies the ASIC only by its marking -
`NEC USA 1-016-905 9948LV001`, a USR part number on an NEC-fabricated gate
array, week 48 of 1999. `1-016-905` is USR's number, `LV001` is NEC's lot code,
and the metal is custom: there is no catalogue part and no datasheet. So the
part is identified by what it is wired to, and this file records that from the
owner's continuity readings.

> **These readings are from the 25 MHz Courier 2806** - the AC03 board,
> supervisor 7.3.14 / DSP 3.0.13, dumped in
> `artifacts/courier-2806-25mhz-flash-20260912`.
>
> The marking above is **not** from that board. It was read off a photo of the
> **20.16 MHz** unit running ID_SDL 4.03d that [asic-port-map.md](asic-port-map.md)
> probed through the monitor. **The 2806's ASIC has not been read for a marking
> at all**, so nothing establishes that the two boards carry the same gate
> array. Reading the text off this one is the cheapest outstanding item here.

## Which findings cross between the boards

> **A third board joined these on 2026-09-18** - a **2805 ISA internal**, same
> ASIC, same flash, no slot to run it in. Its readings are kept together in
> [its own section](#the-2805-isa-board---a-third-unit-and-the-first-internal-one)
> rather than mixed into the tables below, because it agrees with them on the
> memory side and diverges on the panel side. It is what retracted the flash
> `CE#` claim.


**The DSP side transfers.** [board-parts.md](board-parts.md) establishes that
stock 7.3.14 runs on both the 20.16 MHz AC01 board and this 25 MHz AC03 board
and that its **DSP payload is byte-identical between them** - 126,851
consecutive identical bytes covering the payload and all three overlays. Code
that identical cannot be talking to two different interfaces, so `IS`, `INT2`,
`READY` and the data bus are findings about both boards.

**The CPU side does not.** The same comparison finds the whole difference
between those images is in the supervisor, which is exactly where a differing
CPU-side wiring would show up. `ALE`, `RD#`, `WR#`, the interrupt lines and the
unconnected `INT0` are findings about the 2806 only.

## Orientation and pin numbering

120 pins, 30 a side, index dot at the **bottom left** - in the part's own frame,
viewed from above with the `NEC USA 1-016-905` markings upright. That is the
orientation to reproduce before re-checking any of this.

Under JEDEC's convention of pin 1 at the dot, numbering counter-clockwise from
a top view - **confirmed by the owner**, who took the readings and owns the
frame they were recorded in:

| pins | edge | direction |
|---|---|---|
| `1`-`30` | bottom | left to right |
| `31`-`60` | right | bottom to top |
| `61`-`90` | top | right to left |
| `91`-`120` | left | top to bottom |

Readings were taken in per-side local numbering; the translation is **top** pin
= `91 - N` counted left to right, **right** pin = `61 - N` counted top to
bottom, **left** pin = `121 - N` counted bottom to top.

Three independent checks agree with the direction. The bottom-edge readings
land on the one edge that was unread and the edge the panel was predicted to be
on; read clockwise, five of them would collide with pins already measured as
the DSP data bus. The CPU's four upper address lines land on four ASIC pins
stepping over a corner supply pair. And **all eight corner pins are read and
all eight are supplies**:

| corner | pins | | corner | pins |
|---|---|---|---|---|
| bottom left | `120` `GND`, `1` `VCC` | | top right | `60` `GND`, `61` `VCC` |
| bottom right | `30` `VCC`, `31` `GND` | | top left | `90` `VDD`, `91` `GND` |

A corner pad is a supply under *either* numbering direction, so this confirms
the 30-a-side count rather than the direction - but it holds everywhere it has
been checked, and it is what the inferred bus runs below lean on.

Every bare pin number below is an **ASIC** pin; DSP and CPU pins are named as
such, because they collide otherwise.

![The ASIC's pins as currently mapped](asic-pinout.svg)

Generated from `tools/draw_asic_pinout.py`, which holds the map as data. When a
reading lands or is corrected, edit the table here **and** `PINS` there, then
re-run the tool. [board-map.svg](board-map.svg) answers the other question -
what talks to what - from `tools/draw_board_map.py` on the same terms.

![The board's parts and the nets between them](board-map.svg)

## What is connected

Measured pins are marked; the rest of a bus run is **inferred** from the
measured ends being contiguous and in order, and is marked so.

### Top edge - the address side

| local | pin | signal |
|---|---|---|
| 1 | 90 | `VDD`, shared with DSP pin 15 (`VDDD`) |
| 2-5 | 89-86 | DSP `A0` `A1` `A2` `A3` |
| 6 | 85 | DSP `A5` - `A4` is **not connected** |
| 7-14 | 84-77 | CPU `AD0`-`AD7` |
| 15 | 76 | flash pin 35, `A15` (system `A16`) |
| 16 | 75 | flash pin 13, `GND` - **not** the flash's `CE#`; see the retraction below |
| 17 | 74 | flash pin 34 (`A16`, system `A17`) |
| 18 | 73 | flash pin 3 (`A17`, system `A18`) |
| 19 | 72 | *unread* |
| 20 | 71 | latched `A0` **out** - 74VHC32 pin 12 (`4A`), the low byte lane's term in `U12`'s `WE#` |
| 21 | 70 | latched `A1` **out** - RAM pin 10 and flash pin 11, which are those parts' own `A0` |
| 22-26 | 69-65 | latched `A2`-`A6` **out** *(inferred)* |
| 27 | 64 | latched `A7` **out** - RAM pin 4, which is that part's `A6` |
| 28 | 63 | CPU `A16` **in** - CPU pin 29 |
| 29 | 62 | CPU `A17` **in** - CPU pin 30 |
| 30 | 61 | `VCC` |

Pin `72` is the only unread one on this edge.

### Right edge - CPU bus control, the DTE, and the telco

| local | pin | signal | CPU pin |
|---|---|---|---|
| 1 | 60 | `GND` | - |
| 2 | 59 | `A18` **in** | 31 |
| 3 | 58 | `A19` **in** | 32 |
| 4 | 57 | `ALE` | 38 |
| 5 | 56 | `WR#` | 37 |
| 6 | 55 | `RD#` | 36 |
| 7 | 54 | *unread* - the prime suspect for the ASIC's own chip select | - |
| 8 | 53 | `INT2`/`INTA0#` | 64 |
| 9 | 52 | `RESIN` **out** - through `R1`, 1k | 68 |
| 10 | 51 | `TXD0` **in** - serial channel 0's transmit | 2 |
| 11 | 50 | `U22` pin 10 (`3B`) | - |
| 12 | 49 | `U22` pin 4 (`2A`) | - |
| 13 | 48 | `U18` pin 11 (`4Y`) - the EIA receiver | - |
| 14 | 47 | `INT1` | 63 |
| 15 | 46 | `U22` pin 2 (`1A`) - **the `RD` net** | - |
| 16 | 45 | `GND` | - |
| 23 | 38 | phone-line header pin 6 | - |
| 24 | 37 | phone-line header pin 5 | - |
| 30 | 31 | `GND` | - |

Three groups down one edge: CPU bus control at the top, the DTE's EIA-232
interface in the middle, the telco at the bottom. `ALE`, `WR#` and `RD#` land
adjacent, and pin `54` sits between `RD#` and the first interrupt - which is
where the decode for the `0x00`-`0x7f` I/O window would be.

CPU `INT0` (CPU pin 62) is **not connected**.

Eleven pins are unread here, `32`-`36` and `39`-`44` - the largest unread run on
the package, bracketed by the DTE group above and the telco pins below.

### Left edge - the DSP's bus, its clock, and the codec's

| local (from top) | pin | signal |
|---|---|---|
| 1 | 91 | `GND` |
| 2 | 92 | DSP `D15` |
| 3-8 | 93-98 | DSP `D14`-`D9` *(inferred)* |
| 9 | 99 | DSP `D8` |
| 10 | 100 | `GND` - the bus-splitting pin |
| 11 | 101 | DSP `D7` |
| 12 | 102 | DSP `D6` |
| 13-17 | 103-107 | DSP `D5`-`D1` *(inferred)* |
| 18 | 108 | DSP `D0` |
| 19 | 109 | DSP `INT2` (pin 39) |
| 20 | 110 | `GND` |
| 21 | 111 | `ADM707` pin 7 - the supervisor's active-high `RESET` |
| 22 | 112 | `AC03` codec pin 14, `MCLK` - the ASIC's **only** line to the codec |
| 23 | 113 | DSP `TOUT` (pin 122) - the DSP's timer output |
| 24 | 114 | DSP `IS` |
| 25 | 115 | DSP `R/W` (pin 92) |
| 26 | 116 | DSP `STRB` (pin 93) |
| 27 | 117 | *unread* |
| 28 | 118 | **DIP switch 3** |
| 29 | 119 | DSP `X2/CLKIN` (pin 96) - **the ASIC clocks the DSP** |
| 30 | 120 | `GND` |

The five measured data pins fall in two exact descending runs - `99`-`92` for
`D8`-`D15` and `101`-`108` for `D7`-`D0` - so the twelve between them are
inferred. **Pin 100 sits between the two groups**, and a ground splitting the
bus halves was predicted from the shape of the run alone and then measured.

Pin `117` is the only unread one on this edge.

### Bottom edge - the panel, the DIP switches, the barrier

| local | pin | signal |
|---|---|---|
| 1 | 1 | `VCC` |
| 2 | 2 | DIP switch **2** |
| 3 | 3 | DIP switch **5** |
| 4 | 4 | DIP switch **4** |
| 5 | 5 | DIP switch **10** |
| 6 | 6 | DIP switch **9** |
| 7 | 7 | DIP switch **8** |
| 8 | 8 | DIP switch **7** |
| 9 | 9 | **`DCD`** - `U23` pin 4 (`2A`), the `CD` driver's input; reaches the 2805's UART `DCD` (pin 59) |
| 10 | 10 | **`CTS`** - drives the `CS` (Clear to Send) lamp here; reaches the 2805's UART `CTS` (pin 60) |
| 11 | 11 | **`RI`** - `U23` pin 10 (`3B`); reaches the 2805's UART `RI` (pin 61) |
| 12 | 12 | **`DSR`** - `U23` pin 2 (`1A`); reaches the 2805's UART `DSR` (pin 62) |
| 13 | 13 | `AA` lamp |
| 14 | 14 | `ARQ` lamp |
| 15 | 15 | **Talk/Data** switch |
| 16 | 16 | `HS` lamp |
| 17 | 17 | `SYN` lamp |
| 18 | 18 | `TR` lamp - **and the 2805's UART `DTR` (pin 50) lands here**, which is a direction conflict; see the 2805 section |
| 19 | 19 | optocoupler `U14` pin 5 - the line-side barrier |
| 20 | 20 | DIP switch **6** |
| 21 | 21 | `AA` lamp, **second pin** |
| 22 | 22 | optocoupler `U16` pin 5 - the line-side barrier |
| 24 | 24 | `GND` |
| 25 | 25 | `RS` lamp |
| 27 | 27 | `MR` lamp |
| 29 | 29 | phone-line header pin 12 |
| 30 | 30 | `VCC` |

Bottom-edge local and absolute numbering are the same thing. `23`, `26` and
`28` are unread.

**`AA` lands on two pins**, 13 and 21, where the firmware drives one bit
(`0x14` bit `0x10`). Doubled drive for lamp current, a sense return, or two
`AA`-labelled nets merged in the reading - unresolved, and a continuity check
between the two settles it.

## The part is a memory controller

**The ASIC latches the CPU's low address byte.** An 80C186EB multiplexes
`AD0`-`AD15` and drives `A16`-`A19` separately. The board's one `74VHC573`
latches the high byte (`'573` pin 9 is `D7`, CPU pin 11 is `AD8`), and nothing
else on the board latches the low byte, which flash and SRAM both need. ASIC
pin 70 goes to RAM pin 10 and flash pin 11, both `A0` at those parts:

| ASIC pin | system address | where it goes |
|---|---|---|
| 71 | `A0` | '32 pin 12 - byte lane, never reaches a memory |
| 70 | `A1` | RAM pin 10, flash pin 11 - those parts' `A0` |
| 69-65 | `A2`-`A6` | *inferred* |
| 64 | `A7` | RAM pin 4 - that part's `A6` |

Eight consecutive pins for the eight bits latched off `AD0`-`AD7`. So the memory
address bus comes from three places: `A0`-`A7` from the ASIC, `A8`-`A15` from
the '573, `A16`-`A19` from the CPU - except the flash's top three, which are
also the ASIC.

**Every address label at the memories is shifted by one.** On a 16-bit bus `A0`
selects the byte lane and never reaches a memory's address pins, so each part's
`A`n is system `A`n+1. `BYTE#` is tied high, so the flash is in word mode and
the shift is confirmed rather than inferred: `A0`-`A17` addressing 256K words is
the 512 KiB the dump measures.

**The SRAM pair is one 32K x 16 bank.** Both `CE#` pins are connected together
and both `OE#` pins are connected together; only the write enables are separate:

```text
U12 WE#  =  ASIC pin 71 (A0)  OR  write strobe      - low byte lane
U4  WE#  =  CPU BHE# (pin 39) OR  write strobe      - high byte lane
```

`'32` pin 13 is flash pin 43, `WE#`, the board write strobe; `'32` pin 10 is CPU
pin 37, `WR#`. The asymmetry between the lane terms is the bus's own: `A0`
arrives latched from the ASIC because `AD0` is multiplexed and nothing else
holds it, `BHE#` arrives raw from the CPU because on the 80C186EB it is a
dedicated pin. Gates 1 and 2 of the '32 are unread.

**The CPU does its own SRAM select**, and it is `LCS` (pin 60). Both `LCS` and
`UCS` were once recorded on the common `CE#` net, which cannot both be true;
`UCS` turning out to hold the *flash*'s `CE#` (see the retraction below) leaves
`LCS` on the SRAM and closes that off-by-one. `LCS` is programmed to
`0x00000`-`0x20000`, low memory from zero, which is where the SRAM belongs.

> **Retracted 2026-09-18. The ASIC does not select the flash; `UCS` does.**
> ASIC pin 75 goes to flash pin **13**, `GND`, not to flash pin 12. Three
> things agree and nothing now dissents:
>
> * **A second board.** On the 2805 ISA board - same `1-016-905` ASIC, same
>   `PA28F400` - pin 75 meters to flash 13, flash 13 meters to ground, and
>   flash 12 (`CE#`) meters to **CPU pin 61, `UCS`**. The rest of the edge
>   transfers exactly: `70` to flash 11 *and* RAM 10, `73` to flash 3, `74` to
>   flash 34, `76` to flash 35. Four pins agreeing and one disagreeing is a
>   slip, not a bond-out difference.
> * **The firmware.** The reset stub's single job is to program `0xFFA4`
>   (`UCS_START`) to `0x8000`, giving a `UCS` window of `0x80000`-`0xffc00` -
>   512 KiB, the flash exactly. Both images do it, stock 7.3.14 and
>   `IDSDL302.ROM`. Programming `UCS` to the flash's own size and location is
>   pointless unless `UCS` selects the flash. Read it with
>   `CourierRom.chip_selects()`.
> * **This file contradicted itself.** `LCS` (60) and `UCS` (61) were both
>   recorded on the SRAM pair's common `CE#` net, which cannot both be true.
>   `UCS` on the flash resolves it: `LCS` takes the SRAM, and the open probe
>   that asked which of the two answers is closed.
>
> The same region already produced one off-by-one - the "74 is pin 3 or pin 34"
> conflict, recorded above as one miscounted pin. This is the second.
>
> The paragraph and table below are left as written, because the reasoning they
> carry is what the address readings still support; only the `CE#` row and the
> conclusion drawn from it are withdrawn.

**And the ASIC selects the flash.** Flash pin 12, `CE#`, comes from ASIC pin 75.
`UCS` is the 80186's upper chip select, the one active at reset that fetches the
first instruction, and on this board it does not reach the boot device.

| flash pin | flash's name | system address | from ASIC pin |
|---|---|---|---|
| 11 | `A0` | `A1` | 70 |
| ... | `A1`-`A6` | `A2`-`A7` | 69-65 *(inferred)* |
| 4 | `A7` | `A8` | 64 |
| 35 | `A15` | `A16` | 76 |
| 34 | `A16` | `A17` | 74 |
| 3 | `A17` | `A18` | 73 |
| 12 | `CE#` | - | ~~75~~ - **CPU pin 61, `UCS`**; ASIC 75 is `GND` |

The ASIC supplies the flash's bottom eight address lines and its top three; the
'573 supplies the middle. Between the two parts the flash's entire address bus
is accounted for - but **the select is the CPU's**, so the sentence this
section used to end on does not follow. What the readings establish is that the
ASIC is the board's **address latch**, for both memories and across the whole
bus. Whether it is more than that is the question the next section reopens.

### The fold: four address lines in, three out

The CPU's four upper address lines arrive together, on four ASIC pins stepping
over the corner supply pair at `61`/`60`:

| CPU pin | line | ASIC pin |
|---|---|---|
| 29 | `A16` | 63 |
| 30 | `A17` | 62 |
| 31 | `A18` | 59 |
| 32 | `A19` | 58 |

**Four in, three out** - and that is exactly what a **flat** map needs, which is
why this is no longer evidence of paging.

`UCS` decodes `0x80000`-`0xfffff`, so inside the flash's window system `A19` is
constant at 1. The flash never needs it. In word mode the part's `A0`-`A17`
carry system `A1`-`A18`, and the ASIC emits precisely those top three: system
`A16`, `A17`, `A18`. The fourth line in, `A19`, is what tells the ASIC the flash
region is being addressed; it has no business going out. Four in and three out
is a **pass-through with `A19` consumed by the decode**, not a fold.

So the argument that ran from "one bit is consumed" to "therefore paging"
**does not hold**, and with `CE#` on `UCS` rather than the ASIC the memory-
controller reading loses its other support at the same time.

**And there is no room for paging.** `UCS` decodes `0x80000`-`0xfffff`: 512 KiB,
which is the `PA28F400` entire. Paging means reaching a large device through a
*smaller* window - the retracted text said exactly that, "a 512 KiB device
reached through a smaller window" - and the window is not smaller. The CPU
addresses every byte of the part directly. That is not an absence of evidence
for a paging register, it is an absence of anything for one to do.

**What is still unexplained is `A19`.** It reaches the ASIC on both boards
(pin 58, CPU pin 32, metered on the 2806 and the 2805), and with `UCS` holding
`CE#` the ASIC does not need it to gate anything. Qualifying its own address
outputs so they tri-state outside the flash region is the ordinary answer and
needs no register. That is a guess about *why* the line is there, not a
measurement, and it is the one loose end this retraction leaves.
The position now is the plain one: no port bit has ever been identified as a
paging register, nothing in `courier_emu` pages the flash, the harness's flat
512 KiB image reproduces both boards' behaviour, and the observation that used
to argue otherwise is explained by the flat map. Something still has to be said
about why the high address lines are routed through a gate array at all rather
than latched with the rest; board layout and the ASIC already owning `A0`-`A7`
are sufficient answers, and neither needs a register.

### The memories sit on the CPU's raw `AD` bus

Flash pin 22 (`DQ11`) goes to CPU pin 20 (`AD11`); flash pin 31 (`DQ15`) goes to
CPU pin 28 (`AD15`). Two data lines, one from each byte, straight onto the
matching multiplexed bus line with nothing in between.

So the flash and the SRAM pair hang directly on `AD0`-`AD15` and do their own
address/data separation from the strobes. No buffer, no transceiver. The ASIC
has `AD0`-`AD7` only, as an **input**, for latching - the two are on the same
wires for different reasons, and the ASIC's 8-bit CPU port shares the bus with a
16-bit memory system rather than fronting it.

## The part is the DSP's entire external interface

**The ASIC is a 16-to-8 width converter.** All sixteen DSP data lines are on the
package; only eight CPU lines are, and `AD8`-`AD15` go to the CPU's SRAMs and
appear nowhere on the ASIC. So it presents a **16-bit port to the DSP and an
8-bit port to the CPU**, and the conversion is a function of this part.

The 16-bit half is a DSP-side finding and transfers to both boards; the 8-bit
half is CPU-side and does not. That matters for what it appears to settle:
[asic-port-map.md](asic-port-map.md) reads the probe's 64 odd ports returning
`0x00` as the undriven upper byte of a 16-bit register, and an 8-bit CPU
interface would replace that with "nothing is there" - but the port sweep was
run on the 20.16 MHz board and this trace on the 2806. A candidate, not a
replacement, until the 2806's marking is read.

**Both directions of the mailbox are physical.** `IS` (DSP pin 90) on ASIC `114`
gives DSP-to-CPU: the DSP's I/O strobe reaches the ASIC, so `out @7d, 0x5e` at
`0x83eb` and the stream coroutine's writes to port `0x60` land in this chip.
`INT2` (DSP pin 39) on ASIC `109` gives the other direction, and it is the
interrupt the firmware arms - [dsp-pin-probes.md](dsp-pin-probes.md) records
`IMR = 0x002a`, unmasking `INT2`, `TINT` and `XINT`.

`R/W` on `115` and `STRB` on `116` complete the group: the ASIC can tell a DSP
read from a DSP write and has the strobe to time it, so the mailbox is not
write-only and the polling loop has a physical read path. With `IS` and the
sixteen data lines, the ASIC has the DSP's **complete external bus control
group**, and the SRAM pair is the only other thing on that bus.

**`READY` is tied high, so every wait state is software.** DSP `READY` goes to
`VDDD`. The C5x samples it to extend an external access, so no device on either
bus ever stretches a DSP cycle - the ASIC included. All timing comes from the
DSP's own software wait-state generator, which is what
[hardware-timebase-and-audio-path.md](hardware-timebase-and-audio-path.md) uses
as an anchor. This retires an option: the ASIC is **not** a bus arbiter and
cannot throttle the DSP. A mailbox read that is not ready has to be handled by
polling, because the hardware has no way to make the DSP wait.

### The ASIC generates both timebases in the audio path

**ASIC pin 119 goes to DSP pin 96, `X2/CLKIN`** - the DSP's external clock
input, not pin 97 `X1`, which only carries anything with a crystal across it and
this board clocks from a can. **The DSP's clock comes out of the ASIC.**

That is a different kind of fact from the rest of this file: every other pin is
a signal the firmware moves, and this one sets the rate at which the DSP
executes anything. The `ECLIPTEK EC11 40.320M` can is the board's one
oscillator and it feeds the CPU; the DSP gets whatever the ASIC produces from
it. So the ASIC is positioned to divide, gate or stop the DSP's clock, and
nothing in this repository has considered that the DSP's machine cycle might not
be a board constant. A fixed divide is the likeliest thing, and the firmware's
timing numbers have been checked against a real board - but it was assumed
rather than known.

**ASIC pin 112 is the codec's `MCLK`** (`AC03` pin 14), and that one *is*
known - not from a scope but from the firmware.
[ac01-codec-protocol.md](ac01-codec-protocol.md) solves it out of the codec's
own divider registers: the DSP writes `A = 10` and `B = 20`, the datasheet's
`fs = MCLK/(2AB)` applies, and three independently established sample rates
converge on **MCLK = 2.880 MHz**. Which is `40.320 / 14` exactly, so the divider
inside the ASIC is 14 and the pin reading confirms the path the number travels.

That holds on both boards: the 2806's 25 MHz crystal is the **CPU's alone**, the
ASIC runs from the same 40.320 MHz can either way, and the codec's `MCLK` and
the DSP's clock are board-independent - which is why the DSP payload can be
byte-identical across the two while the supervisors differ. See
[running-the-25mhz-image.md](running-the-25mhz-image.md).

`MCLK` matters more for the codec than for the DSP because the conversion rate
is divided from it: the datasheet's reference point is "a 16-kHz
data-conversion rate and 7.2-kHz filter bandwidth for a 10.368-MHz master clock".
Change `MCLK` and every one of those moves. The sample rate is over-determined
and safe, but the divide producing it is now known to sit **inside a part with
registers**.

### The DSP's timer output comes back to the ASIC

Pin `113` is DSP pin 122, **`TOUT`**, the C5x's on-chip timer output. Taken with
pin `119` driving `CLKIN`, the clock relationship runs both ways: the ASIC
clocks the DSP and the DSP's timer reports back into the ASIC.

That is a periodic hardware signal arriving at the part that generates the CPU's
interrupts, and this repository has an open question shaped exactly like it.
[machine.py:596](../courier_emu/machine.py) describes `INT0` as "the board's
frame edge", says "nothing on the CPU side produces that edge", and has a ROM
run stand in for it.

**It is a candidate and not yet more**, with a specific obstacle: CPU `INT0`
(pin 62) is not connected on this board, so whatever `TOUT` produces does not
arrive there. Either the edge comes in on `INT1` or `INT2`, or the `INT0`
reading is wrong, or the frame edge is not what `TOUT` carries. **`TOUT`'s
period settles it** - if it matches the 5 ms tick the harness models, or the
mailbox's frame rate, the identification is made. A scope on DSP pin 122.

### The codec is the DSP's, not the ASIC's

| `AC03` pin | name | direction | DSP pin |
|---|---|---|---|
| 11 | `DOUT` | out of the codec - ADC results | 43 |
| 10 | `DIN` | into the codec - DAC data and commands | 106 |
| 12 | `FS` | frame sync | 104 |

Those DSP pins sit immediately beside ones already identified - `TDR` on 44,
`TFSX` on 105, `TDX` on 107 - which is what the C5x's two serial ports look like
interleaved on the package. Three readings each landing next to their predicted
neighbour.

So the codec's serial interface goes to **the DSP's own serial port with no ASIC
between them**, and the ASIC's single line to it is the master clock. **That
contradicts a standing claim**: [board-parts.md](board-parts.md) argues the ASIC
fronts the codec and thereby hides the AC01/AC03 difference from the DSP. It
cannot. Whatever explains two boards running byte-identical DSP payloads across
different codecs, it is not that.

### The speaker is not on the board side

The speaker's gate was chased here twice and both readings are withdrawn. The
two optocouplers are **not** it: `U14` and `U16` are `H11B2` photodarlingtons
with the ASIC on their transistor side, so the ASIC receives through them, and a
darlington opto is slow and non-linear - the audio a call-progress speaker wants
is already on the logic side of the barrier. And the later reading that put it on
the codec's `MON OUT` with register 4 bits `DS05`-`DS04` as its volume - squelch
and three gains, against an `AT` command set with exactly four states - was
**not measured** and is withdrawn in full.

What is established is where it is *not*: driving ASIC port `0x00` bit `0x40`
and bit `0x04` directly on the 20.16 MHz board produces no sound on or off hook
([board-verified-403.md](board-verified-403.md)), so no CPU port sweep was going
to find it. The live paths are on the DSP side and are traced in
[2806-codec-mailbox-control.md](2806-codec-mailbox-control.md): mailbox tag
`0x0f` sets a gain for a scaled ADC sample copy to ASIC I/O `0x50`, and the CPU's
`M` handler drives a latch on port `0x12` mask `0x10` with two conditional `L`
paths on masks `0x20` and `0x40`. On that board RAM `0x0693` read `0x22`, which
forces the monitor gain to zero and makes the direct volume writer return without
writing, so neither programmable path was active.

**The physical speaker circuit is still unidentified.** Codec word `0409` and the
register-4 monitor bits must not be used to assert that the speaker is wired to
`MON OUT`; that wiring was never measured.

### The DSP and the codec share one reset net

DSP `RS` (pin 127) does not come from the ASIC. It goes to the codec's pin 8,
`RESET`. The harness drives that net from bit 1 of `0xFF56` and models **only**
the DSP side - [machine.py:2384](../courier_emu/machine.py) floats the DSP's
transfer interface and sets `_dsp_in_reset`, and nothing happens to the codec.
On the board every one of those pulses also resets the codec, which by the
datasheet's own conditions of reset returns its registers to defaults. Any codec
state the firmware set up before a DSP reset is gone afterwards, and the harness
does not know that.

## The reset tree

| part | reset source | how |
|---|---|---|
| the **ASIC** | `ADM707` pin 7 | active-high power-good reset, into ASIC pin `111` |
| the **CPU** | the **ASIC**, pin `52` | through `R1` (1k) into `RESIN`, CPU pin 68 - *not* the `ADM707`, whose pin 6 is unconnected |
| the **DSP** and the **codec** | the **CPU**, in software | `P1LTCH` (`0xff56`) bit 1 = `P1.1` = **CPU pin 58**, one net to DSP `RS` (pin 127) and the codec |

So the boot order is not an inference:

1. Rails come up; the `ADM707` releases the **ASIC**.
2. The ASIC releases the **CPU**.
3. The CPU's firmware releases the **DSP** and the codec.

Each part is held until the part it depends on is ready, and the ASIC - which
holds the flash's `CE#` and so decides whether the CPU's first instruction fetch
can succeed at all - is first out of reset by construction.

**The DSP's reset is confirmed at both ends.** The harness drives
`DSP_RESET_PORT`/`DSP_RESET_BIT` ([machine.py:54](../courier_emu/machine.py)),
bit 1 of `0xff56`; that is `P1.1`; the board puts DSP `RS` on CPU pin 58, which
is where the port-pin arithmetic said it would be. Model recovered from
firmware, predicted onto a pin, read on the board.

Three consequences follow from the asymmetry:

* **The CPU necessarily runs before the DSP.** Only the CPU can take the DSP out
  of reset, so the boot order is what the wiring permits, not a firmware choice.
* **What holds the DSP at power-on is still open.** The 80186EB's port pins come
  out of reset in their chip-select function rather than as driven GPIO, so the
  level on that net during the first microseconds depends on `P1CON`'s default
  and whatever pull the board fits. If it floats high the DSP is *released*
  before the CPU has loaded anything into its RAM.
* **There are two ways to stop the DSP.** This net is the documented one; the
  other is the clock, which comes out of the ASIC. A part that supplies another
  part's clock can halt it without asserting any reset at all.

**The 1k series resistor is worth a look.** A gate array driving a processor's
reset through a resistor is either damping, or making the node overridable - with
1k in series, anything pulling `RESIN` low at the CPU end wins without
contention, which is the standard way to let a reset button or a debug header
assert reset on a line a chip is already driving. What else is on CPU pin 68
decides which.

### And it retires an explanation the repository was relying on

[ram-probe-delivery.md](ram-probe-delivery.md) attributes a measured ~1.5 s bound
on every probe run to the `ADM707`'s **1.6 second watchdog**, "which matches the
observed bound". **The owner reports the `ADM707` is used only as a power-good
reset on this board**, so there is no `WDI` source to find and no watchdog in
use.

What stands and what does not:

* **The observations stand.** Cleared RAM, a restored vector, `AT` answering
  again - measured repeatedly.
* **The firmware's reboot path stands.** That file establishes it clears RAM and
  rebuilds the IVT, which is what the after-state looks like.
* **The trigger is now unattributed.** Something ends those runs at about a
  second and a half, and it is not this part's watchdog.

The candidates are a **software** failsafe in the supervisor noticing that timer
0's vector has been hijacked - which needs no hardware and fits a firmware that
rebuilds its own IVT - or the **ASIC**, which is in the reset tree and has
timers reaching it. A software reboot can be disarmed by cooperating with the
firmware, which is the route that file already recommends for other reasons.

A datasheet number that matches an observation is a good clue and a bad proof.
The 1.6 s coincidence is why nobody looked further.

## The panel and the DTE interface

**The ASIC drives the front-panel LEDs.** The lamps were mapped long before this
trace - [dsp-rom-probe.md](dsp-rom-probe.md) has the bit-by-bit table, measured
by driving single bits and watching the panel, and `courier_emu/panel.py` models
the latch driver. What this trace adds is **which part the latches are in**: no
document had attributed the panel to any silicon.

That matters because the panel is the only output of this system a person can
read without instrumentation. Every other observation needs the monitor at its
command loop, a flash dump, a port sweep or a meter, and the panel keeps working
through the states none of those reach - the outage across a reset that
[asic-port-map.md](asic-port-map.md) documents as a structural limit of the
monitor, a call in progress, a training sequence that hangs.

**The transceivers**: two **SN75188** quad line drivers, `U22` and `U23`,
driving out, and one **`DS1489AM`** quad receiver, `U18`, receiving in - the
1488/1489 pair, found one half at a time.

| `U18` output | pin | goes to | CPU pin | what the DTE sends |
|---|---|---|---|---|
| `1Y` | 3 | CPU `RXD0` | 3 | `TXD` - the DTE's data |
| `2Y` | 6 | CPU `CTS0` | 1 | `RTS` |
| `4Y` | 11 | ASIC pin 48 | - | `DTR`, most likely |
| `3Y` | 8 | *unread* | - | - |

**The DTE is on serial channel 0.** The DTE's transmitted data arrives at
`RXD0`, which is what `courier_emu/uart.py` models - its `EbSerial` docstring
says "Serial port 0 of the 80C186EB".

**`CTS0` is a real pin and the harness fabricates it.** `uart.py` models
`clear_to_send` as a stand-in, raising it with each delivered character, and its
own comment says the chain "is reached by the right bit for the wrong reason".
The DTE's `RTS` comes through `U18` gate 2 to CPU pin 1. A concrete harness item
with a known-correct target.

**The transmit path is asymmetric, and deliberately so.** Receive comes to the
CPU directly from the receiver; transmit leaves the CPU on `TXD0` (pin 2) into
ASIC pin 51, and the `RD` driver is fed from ASIC pin 46. The DTE's data reaches
the CPU untouched; the modem's data to the DTE passes through the gate array. A
part placed on one direction only is there to do something to it - gating the
receive line during handshake or retrain is the obvious candidate - and **no
port bit has been identified for it.**

### Which panel signals are in the ASIC, and which are not

The handshake lines are in the ASIC and the data lines are not:

| signal | where | |
|---|---|---|
| `CD` | ASIC pin 9 → `U23` pin 4 (`2A`) | out to the DTE, latch at `0x10` bit 0 |
| `RD` | ASIC pin 46 → `U22` pin 2 (`1A`) | out to the DTE |
| `CS` | ASIC pin 10 | out to the DTE, **no established port** |
| `TR` | ASIC pin 18 | follows the DTE's `DTR`, read at `0x12` bit `0x40` |
| `RS` | ASIC pin 25 | follows `RTS`, **which has no port at all** |
| `SD` | 74AHC04 between CPU pins | **not on the ASIC**; the group reading is retired |
| `OH` | RA5W-K relay, pin 9 | not on the ASIC |

So every modem-to-DTE signal that leaves through a 75188 leaves through the
ASIC. Six driver inputs are fitted - `U22` gates 1-3 and `U23` gates 1-3, gate 4
unused on both - for five signals (`RD`, `CD`, `CTS`, `DSR`, `RI`), so either
one more signal crosses than is named or one gate is spare. `DSR` and `RI` are
unaccounted for.

On a 1488/75188 gates 2 and 3 have two inputs each and the ASIC is on `3B`.
Whatever is on `3A` is not the ASIC - an enable level, or a second source gating
that output - and that pin is worth reading before the gate is assigned a
signal.

**This explains a failure the harness records.** [board-verified-403.md](board-verified-403.md)
has `CS`, `RD` and `AA` moving after `SELF TEST COMPLETED` with no panel write
anywhere near it. The three lamps have three *different* mechanisms: `AA` is a
latch bit the firmware writes, `CS` is an ASIC pin with no port behind it, `RD`
follows the 75188's input. A model that makes the panel follow the serial
signals has to do it per lamp.

`RD` is the only lamp left that does not reach the package, and it is worth
re-probing from `U22` pin 2 back toward the ASIC before that distinction is
relied on - the same reading went wrong twice already for `CD`.

## The line side

**The isolation barrier is found and the ASIC is on the receiving side.** Pins
`19` and `22` go to optocouplers `U14` and `U16`, pin 5 of each, and the parts
are `H11B2` photodarlingtons - LED in, transistor out. Pin 5 is on the
transistor side, so **the ASIC is on the output side of both barriers: it is
receiving, not driving.** Which of collector, base or emitter changes how the
pin is biased, not who is talking to whom.

Two isolated inputs from the line is a familiar shape - **ring detect and
loop-current sense** are what a modem of this era brings across as logic - and
the firmware side already has one named: ring sense, port `0x14` bit 1, which
[daa-line-interface-2016mhz.md](daa-line-interface-2016mhz.md) has a cadence
machine sampling from a 5 ms ticker. One of `19` and `22` is very likely its
physical origin.

**The phone-line header is a module interface, not a line connection.** It has
at least **twelve** positions, and three ASIC pins reach it - `37`, `38` and
`29`. Nothing about tip and ring needs twelve pins. With the two optocouplers
that is five line-side pins spread across two edges. The module on the far side
is unidentified, and this is the largest unmapped subsystem left.

The earlier pairing of `37`/`38` as the hook drive and the ring sense rested on
there being exactly two line-side pins for the two line-side signals with ports.
There are five, and ring detect has a better candidate in an opto. What the
header pair carries is open.

## The DIP switches

Ten positions, and they are read two different ways:

| switch | where |
|---|---|
| 1 | **CPU pin 80** (`P2.6`), read in `P2PIN` at `0xff5a` bit `0x40` |
| 2, 4-10 | ASIC bottom-edge pins 2-8 and 20 |
| 3 | ASIC pin **118** |

| ASIC pin | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 20 |
|---|---|---|---|---|---|---|---|---|
| DIP switch | 2 | 5 | 4 | 10 | 9 | 8 | 7 | 6 |

Pins `5`-`8` are a clean descending run - switches 10, 9, 8, 7. The rest is
scrambled relative to pin order, so **whichever port bit the firmware reads a
switch in is not positional** and that mapping has to come from the firmware.
Pin 20 sits away from the group, among the lamps, and is the one entry worth a
second reading.

**`P2PIN` bit 6 is not modelled.** `machine.py` models bit 7 as the 93C66's data
line and bit 5 as the serial receive the ROM's autobaud timer samples
([machine.py:2340](../courier_emu/machine.py),
[machine.py:2345](../courier_emu/machine.py)); a read of bit 6 returns whatever
the emulated register happens to hold rather than a switch position. (A comment
near that code calls `ff5a` an "ASIC latch". It is not - `0xff5a` is the
80186EB's own `P2PIN`. The behaviour is unaffected; the name is wrong.)

**Switch 1 is the DTR override, and two firmware families read it elsewhere.**
The owner reports its function: off is DTR normal, on is DTR always asserted.
That raises the possibility that `P2.6` carries the DTR *signal* rather than the
switch, since shorting the sense line to its asserted level gives the same
behaviour with no firmware involvement. The behaviour cannot distinguish them.
But `courier_emu/panel.py` maps `dtr-override` to ASIC port `0x12` bit `0x20` on
the XMF supervisor (recovered at `0x63d31`/`0x63d48`), and the 302/403 ROM
builds read the same switch on the same port bit through a different selector.
So on both firmware families mapped so far it is a strap the firmware reads
through the ASIC. If the 2806 routes it to `P2.6` instead, that is a **third**
switch wiring - not impossible, but it needs more than one continuity reading.

**The strap scan is real but it is not these switches.** `panel.py`'s
`id-strap-drive-a`..`d` and `id-strap-sense` are a four-drive, one-sense matrix
recovered from the supervisor's scan at `0x5bfc6`:

| line | port | bit | driven at |
|---|---|---|---|
| `id-strap-drive-a` | `0x14` | `0x40` | `0x5bfed` |
| `id-strap-drive-b` | `0x12` | `0x02` | `0x5c001` |
| `id-strap-drive-c` | `0x14` | `0x10` | `0x5c015` |
| `id-strap-drive-d` | `0x14` | `0x20` | `0x5c03d` |
| `id-strap-sense` | `0x14` | `0x08` | *read* |

Four drives and one sense read four **board-ID straps**, read once at boot - a
different physical thing from the DIP bank, which this file had folded into it
because both were unread. Eight switches on eight dedicated pins is not a
matrix; four drive lines exist to save pins and this part spent the pins. The
arithmetic now closes: ten switches, one on the CPU, nine on the ASIC.

### The unpopulated four-switch footprint

The owner reports room for a second DIP bank of four, unpopulated, near the
serial connector, and suggested it might select between the CPU's two serial
channels.

**One probe killed it: CPU pin 8, `TXD1`, is not connected.** A UART channel
whose transmit pin goes nowhere is not a port, so the CPU's serial channel 1 is
unused and there is no second serial path to select between.

What remains is a coincidence rather than a mechanism - a spare receiver channel
(`U18` `3Y`), two spare driver gates (`U22` and `U23` gate 4) and an unused UART
are all real and none are wired to each other. Spare gates on a quad part are
ordinary. The footprint is something else, and what is left to probe is its own
pads, against the three unread bottom-edge pins and against ground, since the
populated bank's common is grounded.

**A bank that reroutes a signal needs no port bit at all**, which is the shape
of the owner's suggestion and the shape that would leave no trace in the image.
`panel.py` names eight option switches the supervisor reads against ten wired
positions, so two already move no bit the firmware looks at.

## The second serial port goes to a debug header

This is the question [dsp-pin-probes.md](dsp-pin-probes.md) posed and could not
answer: `TDX` is driven constantly by the idle task and nothing accounted for
where the data went.

| DSP signal | DSP pin | lands on |
|---|---|---|
| `TDX` | 107 | `J7` pin 2 |
| `TDR` | 44 | `J7` pin 4 |
| `TFSX` | 105 | `J7` pin 6 |

It is not wired to any part on the board. It is brought out for
instrumentation, and the firmware drives it on every pass of the idle task
whether anything is listening or not.

**That is a live diagnostic stream available on real hardware** - a fourth
source after the monitor, the flash images and port sweeps, and unlike the
monitor it does not need the supervisor to be at its command loop. What the
stream contains is unknown.

`TCLKX` (123) is not directly traced, but there is a 100 ohm resistor from it to
`TCLKR` (126) - series termination, which is what a clock driven off-board into
a header wants, and it explains why `TCLKR` has no source of its own. Consistent
with a one-way stream out to `J7`, the receive half wired for completeness and
never read: `TDR` is on the header but no instruction reads it.

## The EEPROM is the CPU's

Two parts of `courier_emu` disagree about how the Atmel serial EEPROM is
reached. `panel.py` puts `nvram-strobe`, `-data-in`, `-chip-select` and `-clock`
on ASIC port `0x10`; `machine.py` drives the same 93C66 from the CPU. On this
board `machine.py` is right, and every predicted net is confirmed:

| 93C66 pin | net | CPU pin | harness register |
|---|---|---|---|
| 1 `CS` | chip select | 52 (`P1.5`) | `0xff56` bit `0x20` |
| 2 `SK` | clock | 57 (`P1.2`) | `0xff56` bit `0x04` |
| 3 `DI` + 4 `DO` | one shared net | 79 (`P2.7`) | `0xff5e` / `0xff5a` bit `0x80` |
| 5 `GND` | ground | - | - |
| 6 `ORG` | **floating** - selects x16 | - | - |
| 7 `DC` | floating - no bond inside | - | - |
| 8 `VCC` | supply | - | - |

**The shared data net is the distinctive one.** `DI` and `DO` are separate pins
on the chip; one net carrying both is not an accident, and it is exactly what
`machine.py` assumes when it drives `P2LTCH` and then samples `P2PIN` for the
same bit. That model was **recovered from the ROM's driver** - inferred from the
sequence of register writes, with the shared pin read off the code rather than
the board. The board now says the same thing.

**`ORG` floating is a setting, not a gap.** On the Atmel part an unconnected
`ORG` is pulled up internally and selects x16: 256 words of 16 bits, 512 bytes -
which is what `courier_emu/nvram.py` already models, chosen because the driver
reads and writes words and the boot block copies 512 bytes. The marking is read,
so the pull-up is the datasheet's and this is specification rather than
inference.

That also completes the CPU's chip-select allocation:

| CPU select | goes to |
|---|---|
| `GCS0` (pin 59) | the ASIC |
| `LCS` (pin 60) | both SRAMs' `CE#` - but see `UCS` |
| `UCS` (pin 61) | **a RAM's pin 20** (`CE#`) - *not* the flash, which the ASIC selects |
| `P1.2/GCS2` (pin 57) | **not a select** - EEPROM clock, driven as GPIO |
| `P1.5/GCS5` (pin 52) | **not a select** - EEPROM chip select, driven as GPIO |

Two generic selects spent as ordinary outputs is a choice the firmware makes
explicitly, through **Port 1 Control at `0xff54`** - bit 0 set, bits 2 and 5
clear. Nothing in `courier_emu` reads it.

These mappings came from different firmware families - the ROM builds for the
CPU path, the XMF supervisor for the ASIC path - so this settles the 2806 and
says nothing about the other board.

## The interrupt map, and why it is not yet a discrepancy

On this board CPU `INT0` (pin 62) is unconnected and the ASIC drives `INT1` and
`INT2`. On the 80186 `INT2` is interrupt type 14, `0x0e`. `machine.py` models
the board's frame edge as `INT0` - `INT0_VECTOR = 12`, type `0x0c`
([machine.py:585](../courier_emu/machine.py)).

Those do not agree, and it is **not yet a harness bug**: the harness models the
20.16 MHz board running ID_SDL 302/403, the pin reading is from the 2806 running
stock 7.3.14, and the CPU side is the half that does not transfer. Two boards
are allowed to wire their interrupts differently.

So there are two questions and only one is open here. **On the 2806**, which
vector does `INT2` reach? **On the 20.16 MHz board**, is the frame edge `INT0`?
Nothing above bears on the second; it needs that board's own `INT0` pin read.

Both are cheap and neither needs a scope. The IVT is at physical `0` and is RAM,
and the monitor reads it - the method
[ram-probe-delivery.md](ram-probe-delivery.md) already uses. **Read vectors
`0x0c` and `0x0e`**; whichever holds a real far pointer into flash is the edge
that board's ASIC drives. The 80186's interrupt control registers settle it a
second way.

## The 2805 ISA board - a third unit, and the first internal one

A **Courier 2805 ISA internal** (barcode `00280500 R:2`) was metered on
2026-09-18. It carries the same `1-016-905` ASIC - date code **9726**, against
the 2806's 9948 and the I-modem's 9612 - and the same `PA28F400` flash, so the
tables above are a hypothesis it can test rather than a map it inherits. It has
**no ISA slot available**, so nothing here is a live reading; it is continuity
only.

It has already paid for itself twice: its flash readings caught the `CE#` slip
retracted above, and its UART nets are the first measurement of what the ASIC's
panel pins do on a board with no panel.

### What transfers, pin for pin

| ASIC | goes to | same as 2806 |
|---|---|---|
| `63` | CPU 29, `A16` | yes |
| `62` | CPU 30, `A17` | yes |
| `59` | CPU 31, `A18` | yes |
| `58` | CPU 32, `A19` | yes |
| `70` | flash 11 **and** RAM 10 - the split address latch | yes |
| `73` | flash 3 (`A17`, system `A18`) | yes |
| `74` | flash 34 (`A16`, system `A17`) | yes |
| `76` | flash 35 (`A15`, system `A16`) | yes |
| `75` | flash 13, `GND` | **no** - and the 2806 was wrong, see above |

All four upper address inputs and all three flash address outputs are now
measured on two boards independently. Four in, three out is not a transcription
of one board's readings.

### What replaces the EIA section

There are no `SN75188`s and no `DS1489AM`. In their place is a **`TL16PNP550AFN`**
- a TI Plug-and-Play ISA 16550 in a 68-pin PLCC - facing the host. The DTE is
the ISA bus, so the part that made TTL into EIA levels on the 2806 makes TTL
into bus registers here. Everything inboard of that boundary appears unchanged,
which is why `EbSerial` on CPU serial channel 0 should apply to this board as it
stands.

The pin numbers are the datasheet's, from
[TL16PNP550A-SLLS190B.pdf](TL16PNP550A-SLLS190B.pdf) - SLLS190B, March 1995,
revised March 1996 - held here so nobody has to find it again.

| UART pin | datasheet name | dir | 2805 | 2806's same signal |
|---|---|---|---|---|
| 6 | `SIN` | I | ASIC 46 | ASIC 46 to `U22` pin 2 - the `RD` net |
| 49 | `RTS` | O | CPU 1 (`CTS0`) | `DS1489` `2Y` to CPU 1 |
| 50 | `DTR` | O | ASIC **18** - *not* the predicted 48 | ASIC 18 is the `TR` lamp; `DS1489` `4Y` goes to ASIC 48 |
| 51 | `SOUT` | O | CPU 3 (`RXD0`) | `DS1489` `1Y` to CPU 3 |
| 59 | `DCD` | I | ASIC 9 | ASIC 9 to `U23` pin 4 - the `CD` driver |
| 60 | `CTS` | I | ASIC 10 | ASIC 10, recorded as "the `CS` lamp" |
| 61 | `RI` | I | ASIC 11 | ASIC 11 to `U23` pin 10 (`3B`) |
| 62 | `DSR` | I | ASIC 12 | ASIC 12 to `U23` pin 2 (`1A`) |

**Every net lands on the signal the 2806 says it should.** `RD` reaches `SIN`,
the `CD` driver's source reaches `DCD`, the host's `RTS` reaches `CTS0` and the
UART's `SOUT` reaches `RXD0`. The DTE architecture transfers whole: the same
signals in the same directions, with the 550 doing in bus registers what the
75188/1489 pair does in EIA levels. `EbSerial` on CPU serial channel 0 describes
this board as it stands.

### `ASIC 10` is `CTS`, and that corrects the 2806's table

This section first read ASIC 10 as a **repurposed** pin - the `CS` lamp on the
external, something else on the internal - and concluded that the ASIC's
bottom edge is re-used on a board with no panel. **That was wrong, and the
datasheet is what corrects it.** UART pin 60 is `CTS`, and `CS` is the *Clear to
Send* lamp. It is the same logical signal with a different consumer: on the
external it lights a lamp, on the internal it drives the host UART's `CTS`
input.

So the correction runs the other way, and improves the 2806's own map. Two
bottom-edge entries above name a **destination** where they could name a
**signal**:

| ASIC pin | recorded as | is |
|---|---|---|
| 9 | "`U23` pin 4 - the `CD` driver's input" | **`DCD`** |
| 10 | "`CS` lamp" | **`CTS`** |

That is the method rule below in miniature - a trace that stops at a part's
input pin has found one end of a net, not the whole of it - applied to a lamp
rather than a line driver.

`ASIC 11` and `12` then close the modem-status group the same way, and neither
needs a correction: both were already recorded as 75188 driver inputs, and they
reach `RI` and `DSR`. All six of the 2806's driver-fed signals now have names.

Nothing yet says whether the *rest* of the bottom edge transfers. Eight DIP
switches and a Talk/Data switch have no obvious internal-card equivalent, and
those readings remain the 2806's alone.

### `DTR` on ASIC 18 does not fit, and the direction is why

Every net above keeps its direction. `ASIC 10` drives the `CS` lamp on the
external and the UART's `CTS` **input** on the internal - an ASIC output in
both cases, which is why that one reconciled cleanly.

`ASIC 18` does not. UART pin 50 is `DTR`, an **output** from the 550, so on the
2805 ASIC 18 is an **input**. On the 2806 it drives the `TR` lamp, which makes
it an **output**. The same pin cannot be both unless something is being
reconfigured, and three readings are possible:

1. **The `TR` lamp entry is a destination, not a signal** - the lamp sits on
   the `DTR` net rather than being driven by a dedicated ASIC output, and ASIC
   18 is the `DTR` input on both boards. This is the same correction `ASIC 9`
   and `10` just took, and `TR` is *Terminal Ready*, so the signal name fits.
2. **The gate array reconfigures the pin** per product variant.
3. **One of the two readings is wrong.**

**Reading 1 is the one the firmware supports.** `DTR` is a DTE-to-modem signal:
the terminal drives it and the modem senses it, so an ASIC pin carrying `DTR`
should be an input on *any* board. And the firmware treats it as one -
`courier_emu/panel.py` puts `0x12` bit `0x40` in the **input** map as
`dte-dtr`, sampled at `0x5e375` and re-polled at `0x5e395` and `0x5e3b5`, with a
low reading posting supervisor events 6 and 7. The supervisor reads `DTR`; it
never drives it. The panel table above already says pin 18 "follows the DTE's
`DTR`, read at `0x12` bit `0x40`" - which is a sense input described as a lamp.

So the `TR` lamp is most likely sitting **on** the `DTR` net rather than being
driven by a dedicated ASIC output, exactly as `CS` turned out to be `CTS`.

That leaves `DS1489` `4Y` to **ASIC 48**, recorded as "most likely `DTR`" - an
inference, never confirmed, and now the weaker of the two. Both pins cannot be
the `DTR` input. The 2805 is the argument against 48: it has no EIA receiver,
so if 48 were the sense pin there was nothing stopping USR routing the 550's
`DTR` to it, and they routed it to 18 instead.

**Measured 2026-09-18: ASIC 48 goes nowhere on the 2805.** That was offered
here as the probe that separates the two, and it is not - *both* readings
predict a dead pin 48 on a board with no EIA receiver. The result is consistent
with either, and the claim that it would decide was wrong.

What the readings actually leave is two sound arguments pointing opposite ways:

* **For 18.** A gate array's pin functions are fixed silicon and do not move
  between boards. The 2805 puts `DTR` on 18, so if `DTR`-sense is a die
  function it is on 18 on both. The address-side transfers support the
  same-silicon premise.
* **For 48.** The `DS1489` has four receivers and the DTE-to-modem set has
  exactly three members - data, `RTS`, `DTR`. `1Y` is data and `2Y` is `RTS`,
  so by elimination `4Y` into ASIC 48 is `DTR`. That is why the entry reads as
  it does.

Both hold, so their shared premise is the wrong one: **48 and 18 are probably
not alternatives but two ASIC pins on one net** - `1489` `4Y` feeding 48, 18 and
the `TR` lamp together, probed from different ends on different days and written
down as separate facts. This file already carries an unexplained instance of the
same shape: `AA` on ASIC pins 13 and 21 for one firmware bit.

**The probe that does separate them is on the 2806, not the 2805: meter ASIC 18
against ASIC 48.** Continuous means one net and both entries stand. Open means
they are genuinely different pins and the 2805 decides which one carries `DTR`.

### There are two `93C66`s, so nothing is shared

The 550 has its own serial-EEPROM interface - `CS` (54), `SCLK` (55), `SIO`
(57) - and the datasheet specifies an **`ST93C56/66` or equivalent** holding
"the clock prescalar divisor and PnP resource data", organised x16 with `ORG`
tied high or floating. That is the same part in the same configuration as the
2806's settings NVRAM, and pin **58** is an arbitration line that goes low when
"either the TL16PNP550A **or controller**" is accessing the EEPROM - so TI
expected the part to be shared, and this section first inferred that it was.

**It is not. The 2805 carries two `93C66`s.** One is the PnP controller's
resource store and one is the supervisor's settings NVRAM, and the arbitration
pin buys nothing here because the parts are separate. So `nvram.py`'s 256-word
map still describes a part the supervisor owns alone, and a captured settings
EEPROM off this board is directly comparable with the 2806's - **provided the
right one of the two is read.** Tell them apart by metering `CS`: the
supervisor's answers to a CPU pin (`CS`/`SK` on 52/57, `DI`+`DO` on 79 over
there), the PnP one to UART pin 54.

### Three oscillators, and the clock

| | marking | frequency |
|---|---|---|
| X1 | `eb726391` | the CPU's - **50 MHz**, inferred |
| X2 | 22.118M | the UART's - `12 x 1.8432 MHz` |
| X3 | `R0730318` | the ASIC's - 40.320 MHz, the product-line constant |

The 80C186EB halves its crystal input to make `CLKOUT`, which is why the
20.16 MHz board runs the CPU off the ASIC's 40.320 and needs no second can.
A 25 MHz `CLKOUT` needs 50 MHz in, so a third oscillator is the signature of a
25 MHz board - and X1 carries a house number rather than a frequency, so the
50 MHz is arithmetic, not a reading.

X2 settles what the UART is: `22.1184 / 16 = 1,382,400`, so divisor 12 gives
115200. The 550 makes its own baud rate from its own crystal and is a real
autonomous UART the host drives, not something the modem's CPU clocks.

### What this board is for

Its DSP is **not** the TI `D17140PQ`. It is a Sierra Semiconductor `SC34350CQ`
(`HBS-66A4ETW`), alongside a `TLC320AC01CFN` codec, an Atmel `93C66`, two
`CY62256-70SNC` and a USR flash label dated `11-22-96`. A Sierra datapump will
not take the four-row C5x overlay table in
[dsp-overlays.md](dsp-overlays.md), and cannot hold the TI mask-ROM loader at
`0610` that the supervisor hands its first block to - so this is most likely a
separate firmware family rather than a strap variant, and `courier_emu`'s C5x
model does not describe it.

**Dumping its flash decides that**, and `CourierRom.dsp_overlays` runs the test
as it stands: a four-row table loading at `8000`/`9d00`/`b000`/`dc00` means the
same lineage, its absence means a separate target. Its `93C66` is SOIC-8 and
clip-readable, and **no captured 93C66 image exists in this repository from any
board**.

## Method rules this board taught

**A continuity reading to ground is not evidence that a pin is a ground.** It is
evidence that a pin is grounded *at that moment*. The DIP bank's common is
grounded, so any pin tied to ground through a closed switch reads exactly like a
supply. Pin `118` sat in the left-edge table as "DSP `VSSC`/`VDDI`, decoupled"
because switch 3 was closed when that pass was taken; pin `15` was recorded as
ground because the Talk/Data button was pressed. **Only readings taken with the
switch moved distinguish them.**

That direction is the dangerous one. A switch reading on a supply pin is
obviously wrong and gets challenged. A supply reading on a switch pin looks like
the pad-ring convention holding up, agrees with everything around it, and gets
believed.

Grounds without independent corroboration want re-reading with the switches
open. `100` and `120` are corroborated by position and by the bus shape that
predicted them; the corner pins are safe for the same reason. `24` is not - it
was taken in the same pass as pin 15 and has not been re-read.

**A trace that terminates at a part's input pin has found one end of a net, not
the whole of it.** `CD` and `RD` were both listed as "not on the ASIC" on the
strength of landing at a 75188's TTL-side input; both are ASIC outputs. The
claim was about where the probe stopped. `OH` is the only one of that original
list that is safe, because a relay coil is a terminus rather than an input.

**Off-by-one pin miscounts happen.** Three have been found: the top edge counted
from 60 rather than 61 (making one flash line `73` instead of `74`, and hiding
that `73` and `74` are two different flash pins), CPU pin 28 recorded where 29
was meant, and `LCS`/`UCS` on adjacent CPU pins 60 and 61. When two readings
conflict on adjacent pins, that is the likely explanation rather than anything
subtle.

## Reference tables, carried so nobody has to fetch them

### 80C186EB, 80-lead QFP - Table 7

The part is an **80C186EB in the 80-lead QFP**, not the plain `S80C186` that
[board-parts.md](board-parts.md) records from the marking: the XL's QFP puts
`ALE` on pin 10 and `INT0` on 31, which these readings are nothing like. Every
CPU pin number in this file checks against this table, `INT3` excepted.

| pin | name | pin | name | pin | name | pin | name |
|---|---|---|---|---|---|---|---|
| 1 | `CTS0` | 21 | `AD4` | 41 | `S1` | 61 | `UCS` |
| 2 | `TXD0` | 22 | `AD12` | 42 | `S0` | 62 | `INT0` |
| 3 | `RXD0` | 23 | `AD5` | 43 | `DEN` | 63 | `INT1` |
| 4 | `P2.5/BCLK0` | 24 | `AD13` | 44 | `HLDA` | 64 | `INT2/INTA0` |
| 5 | `P2.3/SINT1` | 25 | `AD6` | 45 | `HOLD` | 65 | `INT3/INTA1` |
| 6 | `P2.4/CTS1` | 26 | `AD14` | 46 | `TEST` | 66 | `INT4` |
| 7 | `P2.0/RXD1` | 27 | `AD7` | 47 | `LOCK` | 67 | `PDTMR` |
| 8 | `P2.1/TXD1` | 28 | `AD15` | 48 | `NMI` | 68 | **`RESIN`** |
| 9 | `P2.2/BCLK1` | 29 | `A16` | 49 | `READY` | 69 | **`RESOUT`** |
| 10 | `AD0` | 30 | `A17` | 50 | `P1.7/GCS7` | 70 | `OSCOUT` |
| 11 | `AD8` | 31 | `A18` | 51 | `P1.6/GCS6` | 71 | `CLKIN` |
| 12 | `VSS` | 32 | `A19/ONCE` | 52 | `P1.5/GCS5` | 72 | `VCC` |
| 13 | `VCC` | 33 | `VSS` | 53 | `VSS` | 73 | `VSS` |
| 14 | `VSS` | 34 | `VCC` | 54 | `VCC` | 74 | `CLKOUT` |
| 15 | `AD1` | 35 | `VSS` | 55 | `P1.4/GCS4` | 75 | `T0OUT` |
| 16 | `AD9` | 36 | `RD` | 56 | `P1.3/GCS3` | 76 | `T0IN` |
| 17 | `AD2` | 37 | `WR` | 57 | `P1.2/GCS2` | 77 | `T1OUT` |
| 18 | `AD10` | 38 | `ALE` | 58 | `P1.1/GCS1` | 78 | `T1IN` |
| 19 | `AD3` | 39 | `BHE/RFSH` | 59 | `P1.0/GCS0` | 79 | `P2.7` |
| 20 | `AD11` | 40 | `S2` | 60 | `LCS` | 80 | `P2.6` |

Source: Intel `80C186EB/80C188EB, 80L186EB/80L188EB` datasheet, Table 7. Names
in the 188EB's parentheses are dropped.

### TLC320AC01, FN package - terminal functions

| pin | name | pin | name | pin | name | pin | name |
|---|---|---|---|---|---|---|---|
| 1 | `MON OUT` | 8 | `RESET` | 15 | `FC0` | 22 | `ADC GND` |
| 2 | `PWR DWN` | 9 | `DGTL VDD` | 16 | `FC1` | 23 | `ADC VMID` |
| 3 | `OUT+` | 10 | `DIN` | 17 | `FSD` | 24 | `ADC VDD` |
| 4 | `OUT-` | 11 | `DOUT` | 18 | `M/S` | 25 | `IN-` |
| 5 | `DAC VDD` | 12 | `FS` | 19 | `EOC` | 26 | `IN+` |
| 6 | `DAC VMID` | 13 | `SCLK` | 20 | `DGTL GND` | 27 | `AUX IN-` |
| 7 | `DAC GND` | 14 | **`MCLK`** | 21 | `SUBS` | 28 | `AUX IN+` |

Source: TI `TLC320AC01C` data manual, SLAS057D.

## Readings that need retaking

1. **The `SD` group.** Recorded as CPU pins 4, 7 and 63 plus 74AHC04 pin 11. CPU
   63 is `INT1`, now read from both ends (ASIC `47` to CPU `63`). CPU 7 is
   `P2.0/RXD1`, the receive half of a channel whose transmit pin is not
   connected. Two of three have failed, so **where the `SD` lamp is driven from
   is unknown again** and the group should be retaken pin by pin rather than
   reinterpreted.
2. **`'573` pin 19**, recorded as reaching RAM pin 1 and flash pin 20. Flash pin
   20 is `DQ10`, a *data* line; RAM pin 1 is `A14`, an address line. No latch
   output is both.
3. **The `A7` net** at flash pin 4 and RAM pin 3, recorded as running to `'573`
   pin 12. The '573 latches `A8`-`A15` and cannot carry `A7`; the ASIC drives
   system `A7` from pin 64. Retake toward the ASIC.
4. **CPU `INT3`**, recorded on CPU pin 75. Table 7 gives 75 as `T0OUT`; `INT3` is
   pin 65. If `T0OUT` really is on that net, a timer output going somewhere is a
   finding in itself.
5. **`LCS` or `UCS` on the SRAM bank.** The pair shares one `CE#` net, so one of
   the two adjacent readings is wrong. Probe RAM pin 20 against CPU 60, then
   against 61; exactly one should answer. The 80186's `LCS` covers low memory
   from address zero and `UCS` the top of the space, so the firmware's memory map
   follows from which.
6. **A second `RS` reaching codec pin 13.** Pin 13 is `SCLK`, the serial shift
   clock, which is not a reset of anything and belongs on the DSP's shift clock
   beside the three serial lines on DSP 43, 104 and 106. Almost certainly a
   mislabel, and it has a predicted destination to check against.
7. **Pin `24`, recorded as `GND`** in the same pass as pin 15, which turned out
   to be a pressed button. Re-read with the panel's switches moved.

## What is still unknown

Sixteen of the 120 pins are unread; of the rest, seventeen are inferred middles
of measured runs (the two DSP data groups and `A2`-`A6`). The top and left edges
are finished but for one pin each; the bottom edge is at 26 of 30; the right
edge has eleven unread, `32`-`36` and `39`-`44`.

In the order they would pay:

1. **The frequency at DSP pin 96.** The ASIC drives the DSP's clock and nothing
   here knows what rate it produces. A scope on that pin is the only thing that
   answers it, and the DSP's machine cycle - which the timebase note and every
   DSP-side analysis treat as a board constant - follows from it. `CLKMD1` (DSP
   pin 71) and `CLKMD2` (pin 103) say what the DSP divides it by, and those are
   meter readings.
2. **Whether there is any paging at all.** *Downgraded 2026-09-18.* This used to
   read "the paging register" and be the largest unmodelled behaviour on the
   board. The ASIC does **not** drive the flash's `CE#` - `UCS` does - and its
   four-in/three-out address path is what a flat map needs, with `A19` consumed
   by the `UCS` decode. Nothing now argues for a paging register, and the flat
   512 KiB image the harness uses matches both boards. What remains open is the
   weaker question of why the top three address lines are routed through the
   ASIC at all.
3. **The left edge's last two, `112` and `117`**, against the DSP control signals
   still missing. The ASIC has the data bus, `IS`, `R/W`, `STRB`, `INT2` and the
   clock. Four candidates would each change something: **`DS` (DSP pin 89) and
   `PS` (91)** - `IS` alone makes the ASIC an I/O device, `DS` would put it in
   the DSP's *data memory* alongside the SRAM; **`MP/MC` (pin 5)**, which decides
   whether the DSP boots from on-chip ROM or external memory, and which
   [board-parts.md](board-parts.md) records as running at 1 without saying who
   sets it; **`BIO` (130)** and **`XF` (109)**, a handshake pair the firmware
   could poll and answer with. Two pins for four candidates.
4. **The phone-line header's pinout.** Twelve positions, three of them reaching
   the ASIC, with two optocouplers beside them. Continuity to the `RA5W-K`'s coil
   names the hook output; watching the pins while the line rings names the ring
   input.
5. **Which port bit each DIP switch appears in**, and what is on the other side
   of switch 1. Live through the monitor rather than with a meter: flip each
   switch in turn and watch which port bit moves. It also shows which switches
   are read by nothing. For switch 1, one probe on its other terminal -
   ground/`VCC` makes it a strap on `P2.6`, the DTR net makes `P2.6` the signal
   and the override hardware. A second check separates them live: unplug the DTE
   so nothing asserts DTR, then toggle the switch.
6. **What gates the transmit path.** `TXD0` goes into the ASIC and the `RD`
   driver comes out of it while receive reaches the CPU directly. A part on one
   direction only is there to do something to it, and no port bit is identified.
7. **What `J7` carries.** The DSP's second serial port streams continuously to
   that header and nothing knows what is in it. A capture, not a meter - and the
   one item here that could produce new information about the *firmware* rather
   than about the board.
8. **The right edge's unread block**, `32`-`36` and `39`-`44`. By elimination it
   is where the codec and the DAA behind the phone-line header must land. Not a
   single probe but the place to sweep once the targeted ones are done.
9. **Why `AA` is on two ASIC pins**, 13 and 21, when the firmware drives one bit.
   A continuity check between them.
10. **What else is on CPU pin 68**, and **what level ASIC pin `52` takes while
    the ASIC is itself in reset.** If it does not hold low, the CPU is released
    before the ASIC is ready and the boot chain above describes the steady state
    rather than power-on.
11. **CPU `RESOUT` (pin 69)**, and **`INT4` (pin 66)**. Neither has been
    followed.
12. **`U18`'s output `3Y`** (pin 8). Three DTE inputs are accounted for, so the
    fourth channel is spare or carries something unexpected.
13. **Top-edge pin `72`.** Three of that edge's four unread pins went to the
    flash, so `72` is most likely a fourth flash line. Completeness rather than a
    question with something riding on it.
14. **The unpopulated four-switch footprint's pads**, against the three unread
    bottom-edge pins and against ground.
15. **The codec's `M/S` (pin 18).** The firmware's free-run configuration implies
    the codec is the slave and the DSP drives `SCLK`/`FS`. One meter reading.
    `MCLK` needs no reading - it is 2.880 MHz, solved from the divider registers.
16. ~~**Whether `&T1` is the codec's analog loopback.**~~ **Answered: yes.** The
    resident writes register 5 with `0508` at `90c3` and `90e1`, both real code
    paths under the cell `0x6f` state word, through the register writer at
    `8770`. `DS01`-`DS00` = `00` is analog loopback, and `0508` has it - so the
    loop is *inside the AC01*: "In loopback, `OUT+` and `OUT-` are internally
    connected to `IN+` and `IN-`" (docs/ac01.txt 2.15.2). There is no external
    switch and the ASIC is not involved; the DSP throws it over `DIN`. The
    bring-up's `0505` at `80bd` is the normal setting, as this entry said.

    This stayed open because the entry guessed the wrong encoding. It looked
    for `0504` - `DS02` set - and the firmware writes `0508`, with `DS03` set.
    Same field, so a literal grep for `0504` found only a coincidence in a
    byte-pair table at `c269`. Enumerate every `bf80 05xx` and mask `DS01`-`DS00`
    instead of grepping one value.
17. **DSP `A6` (61) and `A7` (62), and a second pass on `A4` (59).** The hole in
    the address decode: the firmware writes port `0x60`, which needs `A6`, and
    six lines with a gap at `A4` cannot produce it. At least one more address
    line is on an unread edge.
18. **`GCS0 Start`/`Stop` at `0xff80`/`0xff82`, and Port 1 Control at
    `0xff54`.** Those define the address range that selects the ASIC and which
    `P1` pins are generic chip selects. Both are readable out of a run with no
    hardware at all, and nothing in `courier_emu` looks at either.
19. **The 2806's ASIC marking.** Still unread, and it is what decides whether any
    of the CPU-side findings here transfer to the 20.16 MHz board.
