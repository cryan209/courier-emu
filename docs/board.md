# The board

The 20.16 MHz Courier and the 25 MHz Courier 2806, identified from photographs
and from the owner's continuity readings, with each claim checked against the
firmware where the firmware can check it.

> **Which board a reading came from matters per pin.** The **DSP side
> transfers**: stock 7.3.14 runs on both the 20.16 MHz AC01 board and the 25 MHz
> AC03 board and its **DSP payload is byte-identical between them** - 126,851
> consecutive identical bytes covering the payload and all three overlays - and
> code that identical cannot be talking to two different interfaces. So `IS`,
> `INT2`, `READY` and the data bus are findings about both.
>
> **The CPU side does not.** The whole difference between those two images is in
> the supervisor, which is exactly where differing CPU-side wiring would show up.
> `ALE`, `RD#`, `WR#`, the interrupt lines and the unconnected `INT0` are
> findings about the 2806 alone.
>
> The pin readings below are the **2806's**. The ASIC marking is the
> **20.16 MHz** board's - the 2806's ASIC has never been read for a marking, so
> nothing establishes the two carry the same gate array. Reading it is the
> cheapest outstanding item here.

## The parts

| marking | what it is |
|---|---|
| `NEC USA 1-016-905 9948LV001` | **the ASIC.** A USR part number on an NEC-fabricated gate array, week 48 1999. No catalogue part, no datasheet, custom metal. |
| `TI DSP 16-912 (C) US ROBOTICS D17140PQ` | the C5x-family DSP, custom-marked. Probably a **'C50 or 'LC50**, not the 'C52 the core models - see below. |
| `S80C186` | the supervisor, more precisely an **80C186EB in the 80-lead QFP**: `RD`/`WR`/`ALE` on 36/37/38 and `INT0`/`INT2` on 62/64 match that package's Table 7 exactly and the XL's not at all. Which is the device `uart.py`'s `EbSerial` already assumes. Its `GCS0` (pin 59) is the ASIC's chip select. |
| `TLC...320AC01CFN` | the voice-band codec, PLCC, next to the DSP. The 2806 carries an **AC03** instead. |
| `ECLIPTEK EC11 40.320M` | the **ASIC's** oscillator, the same part on both boards - so the DSP's clock and the codec's `MCLK` are board-independent. The 2806 carries a **second** crystal for the CPU alone. |
| `NEC D43256BGU-70LL` x2 | the **80186's** SRAM, `U4` and `U12`: not two banks but the low and high byte lanes of one **32K x 16**. |
| `CY7C199-15VC` x2 | the **DSP's** SRAM: 2 x 32Kx8 = 32K words on a 16-bit bus, exactly `0x8000`-`0xffff`. |
| `ISSI IS61C256AH-15J` | 32Kx8 15 ns SRAM. |
| `ADM707` | supervisory reset - and on this board a **power-good reset only, with its watchdog unused**. |
| `74VHC573`, `74VHC32`, `74VHC04` | bus glue. Exactly **one** '573, latching the **high** byte; the ASIC latches the low byte. |
| `PA28F400` | the **flash**. Intel 4 Mbit / 512 KiB, which is the 2806 dump exactly. |
| `SN75188` x2, `U22`/`U23` | the **EIA-232 drivers**, TTL in / EIA out, modem-to-DTE only. Three of each part's four gates are fed from the ASIC. |
| `DS1489AM`, `U18` | the **EIA-232 receiver**, EIA in / TTL out, DTE-to-modem. |
| `74AHC04` | inverter; one gate sits in the `SD` path. |
| `H11B2` x2, `U14`/`U16` | **optocouplers** - the line-side isolation barrier, and the first named parts in the DAA section. |
| `RA5W-K` | the **hook relay**. The `OH` lamp is on its pin 9, which is why `OH` is the one panel line not on the ASIC. |
| Atmel 93C66 | serial EEPROM, the settings store. On the 2806 it is the **CPU's**, not the ASIC's. |

The DAA/line section was not in the photograph, so nothing here describes it
beyond the two optocouplers.

## The ASIC is the entire board outside the two processors

The 80186 talks to the world through it, the C5x talks to the 80186 through it,
and the line-side parts answer to it. On the CPU's I/O bus it is not a peripheral
among several - **it is the only device there is**, which is a measurement rather
than a figure of speech: the CPU's own peripheral control block is relocated into
*memory* at `0xff00`-`0xffff`, and flash and SRAM are memory too, so anything
answering an `IN` is the gate array.

Its four jobs:

1. **The board's I/O** - ports `0x10`, `0x12`, `0x14` carry the hook relay, the
   NVRAM strobe, the carrier-detect pair, ring detect and the option straps.
2. **Bootstrapping the DSP** - it holds the C5x in reset and writes its program
   RAM through the `0x40`-`0x4e` window.
3. **The mailbox** - it bridges *CPU I/O ports* to *DSP data-memory cells*. Two
   address spaces with nothing to do with each other are joined inside it, and
   that is the single most important thing it does for the emulator. See
   [dsp-cpu-link.md](dsp-cpu-link.md).
4. **The memory controller** - it latches the CPU's low address byte, drives the
   flash's top three address lines and its `CE#`, and folds four upper address
   lines into three.

**Not the timebase.** The 5.000 ms tick is the 80186's own Timer 0 - max count
25,200 at CLKOUT/4 - confirmed four ways, including a counter routine run on the
modem that logged exactly 200.0 increments a second. `40.320 / 2 = 20.16 MHz`
CLKOUT, so the timer clock is 5.04 MHz. (25,200 lands on a round figure either
way - 5 ms at 20.16 MHz CLKOUT, or 10 ms if 20.16 had been the crystal - and the
board's own `&T1` slope of 1.000031 s per `S18` unit had already chosen the
first.)

**Not in the CPU's audio path.** Sweeping every port during analogue loopback,
only the four handshake registers move; no CPU port carries samples.

**Not the tone generator**, though the README once said so. Dialling sends
`0x16:0000`, three constant lanes `0x19`/`0x1a`/`0x1b`, the keypad index on
`0x13`, then `0x16:0000` when the tone ends - and those lanes are host-write tags
whose handlers store into **DSP data memory** at `0x03ad`, `0x0392` and `0x03f1`.
The tone parameters go to the C5x, so the synthesiser is the datapump's.

## The CPU's I/O space

Only **even** addresses are decoded - all 64 odd ports below `0x80` read `0x00` -
and the decode **stops at `0x7f`**, above which all 64 even ports read back their
own address and all odd ports read `0x00`, which is an undriven bus. That is 64
registers, and the firmware uses about half.

**The idle default is `0x00`, not `0xff`.** 96 of the 128 ports below `0x80` read
zero on the board, where the harness returns `0xff` for any port it does not
model. `courier_emu.asic_ports` carries the measured map; `asic_ports.seed()`
produces it in the form `port_values` takes. It is **not wired in by default** -
it is the idle, on-hook state, so holding those values static through a run that
goes off hook could be worse than `0xff`.

| ports | sites | idle | what it is |
|---|---|---|---|
| `0x00` | 12 r/w | `00` | DTE serial data path |
| `0a` `0c` `0e` | 5r / 21w | `f7` `60` `07` | configuration; `0e` is the panel latch driver, write-only |
| `10` `12` `14` | 20r / 34w | `86` `8a` `7e` | **board latches** - hook relay, NVRAM, carrier-detect pair, ring detect, straps |
| `18` `1a` `1c` `1e` | 104r / 137w | `ff` `ff` `fd` `ff` | **the handshake**, busiest group by far; `1c`/`1e` are the mailbox status pair, `18` is the ROM images' DSP command port and `1e` the XMF images' |
| `40`-`4e` | 20r / 45w | `ff` | **the DSP download window** - eight latches carrying four payload words |
| `50`-`56` | 9r / 8w | `ff` | second window bank |
| `58` `5a` / `5c` `5e` | 68r / 44w | `20` `00` / `0e` `00` | **the mailbox** - tag pair and data pair |
| `60` `62` | **27r / 0w** | `4b` `00` | **DSP-to-host stream** - pure input |
| `64`-`7e` | 3r / 0w | `78 09 8f a7 e8 aa b6 97 51 51 06 4f b3` | read almost never; identity or strapping |

Two rows carry their own argument. **`60`/`62` has zero write sites in the whole
image**, so it is one-way out of the DSP. And **ten of the thirteen values in
`64`-`7e` are byte-identical** to a sweep taken when this unit ran stock 7.3.14
instead of ID_SDL 4.03 - the same values across two firmware versions and two
sessions is what fixed configuration looks like. The three that differ (`68`,
`6a`, `70`, and also `58` and `60`) are state.

**Nothing reads `0x64`-`0x7e`.** No instruction in the supervisor reads or writes
any port in that block; the only code touching it is the `0x60`/`0x62` reader.
That rests on a raw-byte refutation of every candidate, not a boundary heuristic,
and it is not a proof of absence - a `DX` loaded from memory, as the downloader
does at `0e515`, could reach those ports on a path the analysis cannot bound.

**And the streaming reading of that block is refuted.** Repeated reads do not
pop, advance or disturb it, so those are sixteen stable registers and the `01fe0`
machine is polling one register rather than draining a queue.

> **The `0xc0`-`0xc6` cluster is a device-programming path, not a diagnostic
> read.** The block at `08332..083b5` sets `PACS` to `0xe000` and `[0xff18]` to
> `0x10`, then reads `0xc2`/`0xc0` and writes `0xc4`/`0xc6` while streaming
> `0x1554` words from segment `0xe000`, entered from an `AT` handler checking for
> a literal `L`. **Do not invoke it on the physical modem.** It is `ATNL`; see
> [probing.md](probing.md).

> **The monitor lies about the download window.** `ATGLK2I` and the CPU's own
> `IN` agree on 51 of 64 ports and disagree on all twelve of `0x40`-`0x56`, with
> the pairing inverted. Anything about the window resting on a monitor sweep
> needs re-taking.

Only four ports differ between idle and `AT&T8` analogue loopback: `18`
(`c0`/`c6`/`c7`), `1a` (`c0`), `1c` (`f9`) and `1e` (`fb`). `1c` and `1e` both
move on bit 2 - the bit the supervisor's mailbox interrupt acknowledges - and
`18` varies *within* the active state, so it carries live signal. With the loop
on hook and no call, most of the ASIC never does anything.

> **A reset sweep is a clean negative and a structural limit.** Sweeping either
> side of an `ATZ` finds **0 of 256 ports differing**, because the monitor is
> firmware: the board stops answering the moment it restarts and is readable
> again only once the supervisor is back at its command loop. The outage is under
> 375 ms. Moving the download window needs a transition the monitor can survive,
> and there are only two - power-on, unobservable through the firmware's own
> monitor, and a call setup, which needs the loop off hook.

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
| 16 | 75 | flash pin 12, `CE#` - **the ASIC selects the flash** |
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
| 9 | 9 | `U23` pin 4 (`2A`) - the `CD` driver's input |
| 10 | 10 | `CS` lamp |
| 11 | 11 | `U23` pin 10 (`3B`) |
| 12 | 12 | `U23` pin 2 (`1A`) |
| 13 | 13 | `AA` lamp |
| 14 | 14 | `ARQ` lamp |
| 15 | 15 | **Talk/Data** switch |
| 16 | 16 | `HS` lamp |
| 17 | 17 | `SYN` lamp |
| 18 | 18 | `TR` lamp |
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

**The CPU does its own SRAM select** - one of `LCS` (pin 60) or `UCS` (pin 61)
reaches the common `CE#` net; both have one reading each and they are adjacent
pins, so one is an off-by-one. See the open probes.

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
| 12 | `CE#` | - | 75 |

The ASIC supplies the flash's bottom eight address lines, its top three and its
chip select; the '573 supplies the middle. Between the two parts the flash's
entire address bus is accounted for, and only one of them also decides when the
device is selected. **That is not a bus buffer. That is a memory controller.**

### The fold: four address lines in, three out

The CPU's four upper address lines arrive together, on four ASIC pins stepping
over the corner supply pair at `61`/`60`:

| CPU pin | line | ASIC pin |
|---|---|---|
| 29 | `A16` | 63 |
| 30 | `A17` | 62 |
| 31 | `A18` | 59 |
| 32 | `A19` | 58 |

**Four in, three out.** One bit of the CPU's upper address space is consumed by
the ASIC's decision and does not reach the flash. A part that takes four address
lines and emits three is not buffering and not substituting - it is deciding,
and that is **paging**: a 512 KiB device reached through a smaller window with
the ASIC choosing which part of the device is behind it. The ordinary reason a
1990s board puts a gate array between a CPU and its boot flash.

**The harness's flat 512 KiB flash image is therefore a simplification of
something with a register behind it.** Nothing in `courier_emu` pages anything,
and if the supervisor switches banks to reach its upper half it is getting away
with it because the emulator hands it the whole device at once. No port bit has
been identified as the paging register; this is the largest unmodelled behaviour
on the board.

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
[the port map above](#the-cpus-io-space) reads the probe's 64 odd ports returning
`0x00` as the undriven upper byte of a 16-bit register, and an 8-bit CPU
interface would replace that with "nothing is there" - but the port sweep was
run on the 20.16 MHz board and this trace on the 2806. A candidate, not a
replacement, until the 2806's marking is read.

**Both directions of the mailbox are physical.** `IS` (DSP pin 90) on ASIC `114`
gives DSP-to-CPU: the DSP's I/O strobe reaches the ASIC, so `out @7d, 0x5e` at
`0x83eb` and the stream coroutine's writes to port `0x60` land in this chip.
`INT2` (DSP pin 39) on ASIC `109` gives the other direction, and it is the
interrupt the firmware arms - [dsp-cpu-link.md](dsp-cpu-link.md) records
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
and bit `0x04` directly on the 20.16 MHz board produces no sound on or off hook -
slowly enough to hear individual clicks, and only the relay is audible - so the
`0x81703` pulse that ticks once per lamp is not the speaker and no CPU port sweep was going
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

[probing.md](probing.md) attributes a measured ~1.5 s bound
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
trace - [probing.md](probing.md) has the bit-by-bit table, measured
by driving single bits and watching the panel, and `courier_emu/panel.py` models
the latch driver. What this trace adds is **which part the latches are in**: no
document had attributed the panel to any silicon.

That matters because the panel is the only output of this system a person can
read without instrumentation. Every other observation needs the monitor at its
command loop, a flash dump, a port sweep or a meter, and the panel keeps working
through the states none of those reach - the outage across a reset that
[the port map above](#the-cpus-io-space) documents as a structural limit of the
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

**This explains a failure the harness records.** [the board measurements below](#measured-on-the-4-03d-board)
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

This is the question [dsp-cpu-link.md](dsp-cpu-link.md) posed and could not
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
[probing.md](probing.md) already uses. **Read vectors
`0x0c` and `0x0e`**; whichever holds a real far pointer into flash is the edge
that board's ASIC drives. The 80186's interrupt control registers settle it a
second way.


## Measured on the 4.03d board

| what | board | emulator | where |
|---|---|---|---|
| identity | `7.4.16` / `3.1.2`, serial `0009540034268322` | same | `ATI7` |
| transmit levels | `[0cd9]=32c8`, `[0cdb]=0c08` | matches with `idsdl403` | [datapump-dispatch-gate.md](datapump-dispatch-gate.md) |
| settings page | `B0 F1 M1 X7 &A3 &B1 &G2 &H1 &I0 &K1 ...` | same | `ATI5` |
| NVRAM self test | `TESTING NVRAM  OK` | same | `0x81412` |
| product code | `5607A` | same | `ATI0` |
| ROM checksum | `6C04` | same | `ATI1` |
| self test | runs only with the front panel button held | same, `--port 0x14=0xb5` | `0x877cd` |

The self test reproduces line for line, through the dipswitch page to
`SELF TEST COMPLETED`.

### The settings EEPROM

The boot block copies the whole 512-byte part into RAM `0x058e..0x078d` and
checksums it there at `0x81412`: byte 511 holds the sum of bytes 0..509, with
byte 510 added and taken straight back out.

That window is why `artifacts/courier-board-21210-ram-403/` contains the part
itself, and `CourierNvram.idsl403_fixture()` is those 512 bytes rather than
anything synthesised. Three things agree it is the store: it is identical across
both capture passes, its stored byte `0xbd` matches the rule where the
neighbouring ranges give `0xbe` and `0xbc`, and it carries the +S register block
at the offset derived from the ROM before the capture was read.

**A checksum-valid fixture over erased bytes is worse than no fixture.** An
intermediate revision did that, the firmware trusted the erased profile, and the
run lost its DTE output entirely.

### The front panel

`0x877cd` gates the self test on port `0x14` bit `0x40` reading low, and
`0x87e34` then spins while it is still low - a contact being released. It is the
button, not a DIP switch, and mapping `carrier-detect-override` onto it was
booting every `--dip-preset dedicated-line` run into the self test.

The lamp stage walks a nine-entry table at `0x8275f`, one line per ~281,500
instructions:

| idx | port/bit | lamp | idx | port/bit | lamp |
|---|---|---|---|---|---|
| 0 | `0x12`/`0x10` | HS | 5 | `0x12`/`0x02` | MR |
| 1 | `0x14`/`0x40` | *no lamp - the button* | 6 | `0x14`/`0x02` | **CS** |
| 2 | `0x14`/`0x10` | **AA** | 7 | `0x14`/`0x80` | **SYN** |
| 3 | `0x14`/`0x01` | **CD** | 8 | `0x14`/`0x20` | ARQ/FAX |
| 4 | `0x10`/`0x01` | OH, and the relay | | | |

The bold four are measured: driven one at a time with `ATGLK2O0014` against a
rest state of `0xff`, with a different blink count per bit so they could not be
confused, while the panel was watched. CS is the odd one - it drops whenever the
port is released, so it is driven from this latch and idles low.

The remaining five come from the release order read off the board, and the
alignment checks itself: exactly one of the nine steps was never seen to do
anything, and it falls on `0x14` bit `0x40`, the button, which has no lamp.
Nothing had to be assumed about where the silent step was.

    bit 0x01 (0xff <-> 0xfe)   CD blinks alone
    bit 0x10 (0xff <-> 0xef)   AA blinks alone
    bit 0x80 (0xff <-> 0x7f)   SYN blinks alone Index 4 reads as a
lamp *lighting* mid-sweep rather than going out, in both the board's sequence and
the emulated run, which is what identifies OH and the relay as one line.

Port `0x14` reads its **inputs** rather than this latch - `0xfe`, `0xff` and
`0x7f` all read back as `0x7e` - so the rest state cannot be read and is `0xff`,
which is what `0x82803` writes to release. A first attempt used the `0x7e` read
as its baseline, which held both bits driven throughout, and reported CD and SYN
moving together off bit `0x80`. That was the baseline, not the board.

**This table says which latch bit lights which lamp during the test. It does not
say the supervisor drives that lamp in service, and mostly it does not.** RD,
SD, TR, RS and CS are RS-232 signals before they are lamps and follow the wire.
Across a whole 150M-instruction dial the panel sees 23 writes,
`carrier-detect-a` and `carrier-detect-b` are never driven at all, and everything
that moves is the board-ID strap scan at boot plus the hook relay. The lamp
stage is a lamp *test* - the firmware takes over lines it otherwise leaves to the
hardware, precisely so every lamp can be seen. That is what makes the sweep
usable for naming them, and why the naming cannot be turned around into "the
supervisor controls this lamp".

#### Two bits conflict with dsp-rom-probe, on this same board

[probing.md](probing.md) has its own single-bit strobe table, taken
on this unit (`/dev/cu.usbserial-21210`, serial `0009540034268322`). It lists the
same nine self-test entries in the same order, and five attributions agree
exactly - CD on `0x14` bit 0, CS on bit 1, ARQ on bit 5, SYN on bit 7, MR on
`0x12` bit 1. **Two do not:**

| bit | dsp-rom-probe | this file |
|---|---|---|
| `0x14` bit 6 (`0x40`) | HS lamp, observed | *no lamp* - the front-panel button |
| `0x12` bit 4 (`0x10`) | analog path, audible pop | HS lamp |

Both sides are user-reported panel observations, so neither transcript
arbitrates. What tips it is firmware: `0x877cd` gates the self test on port
`0x14` bit `0x40` **reading low**, and `0x87e34` then spins while it is still
low - that is an input being released, which a lamp drive is not. And the sweep
here saw nothing at all happen on that step.

**Settled by re-strobing the two bits one at a time**, watching the panel and
listening: `0x14` bit 6 from a rest state of `0xff`, and `0x12` bit 4 from its
shadow. If bit 6 lights nothing and `0x12` bit 4 lights HS, this file is right
and dsp-rom-probe's two rows shift. Until then neither attribution should be
built on.

### The hook

Port `0x10` bit `0x01` drives the relay and the OH lamp together, **active
high** - `0xdf` pulls in, `0xde` releases, chip-select held low throughout. The
model had the hook on bit `0x04` active-low; both bits are asserted on a dial,
`0x01` at `c8fbe` and `0x04` about 43,500 instructions later at `c8fe1`, so the
wrong bit still yielded an off-hook, just late.

`[0x020d]` bit `0x02` mirrors the hook - `0x09` on-hook, `0x0b` off-hook, moved
by pulling the relay in by hand with `ATGLK2O0010,DF`. Every other candidate cell
was identical between board and emulator. **The emulator never writes `[0x020d]`
at all**: a `--mem-watch 200:220` across a whole dial catches 96 writes in that
range and every one is to `[0x0210]`. The predicate at `0x8b449` tests bit 0 of
this same cell before its success branch, so the cell is on the path.

### Two port read-backs

| port | board | emulator |
|---|---|---|
| `0x10` | `0x86` on-hook, `0x87` off-hook | `0xff`, with the NVRAM bits overlaid |
| `0x00` | `0x00` | `0x33` on the input bits |

Port `0x10` bit `0x01` mirrors the hook on the board and the emulator answers
open bus, so any firmware routine reading the port back to maintain `[0x020d]` is
being told the line is permanently off hook.

Port `0x00` is worse, because that value is one this project chose: it was set to
answer `PORT0_INPUTS` high on the reasoning that answering from the latch cost
`ATI7` its option list. The board answers `0x00`. The four bits are not
capability inputs reading high, the guess was wrong, and whatever moved the
option list has another cause still to find.

The broader shape of the port space is in [the port map above](#the-cpus-io-space):
only even ports decode, the decode stops at `0x7f`, and the idle default is
`0x00` where the harness returns `0xff`.


## The output latches, and how to drive them safely

`ATGLK2O` writes CPU I/O ports, so the three output latches at `0x10`, `0x12`
and `0x14` are drivable from the AT interface. Part of what follows is physical
**write** evidence - the first writes of any kind issued to a unit in this
investigation.

Two helpers drive the latches, `0x2771` (set bits) and `0x279b` (clear), with
the port table at `0x27c7`. `AH` is the bit mask and `AL` a descriptor whose bit
3 must be set; `AL & 3` selects both port and RAM shadow:

| `AL` | port | shadow |
|---|---|---|
| `08` | `0x10` | `[0x30e]` |
| `09` | `0x12` | `[0x30f]` |
| `0a` | `0x14` | `[0x310]` |
| `0b` | `0x12` | `[0x311]` - no call site uses it |

**The latches are write-only.** Reading `0x10`/`0x12`/`0x14` returns input
signals, not latch contents, which is why the firmware keeps shadows and does a
`cli`-protected read-modify-write against them. Initialization at `0x2728` fills
`0x30e..0x312` with `0xff`, then forces `[0x30e]=0xfe` and `[0x30f]=0x7f`. The
captured idle RAM holds `fe 7d f5 ff` at `0x30e..0x311`, readable live with
`ATGLK2=0000:0300`. Nothing reads `[0x310]`, and there is no direct `out 0x14`
in that bank, so port `0x14` holds whatever is written until the next helper
call.

**`O` is a bare `out dx,al`.** It writes all eight bits and does not update the
shadow. So a single-bit poke must be composed by hand from the current shadow -
`ATGLK2O0014,40` does not set bit 6, it clears the other seven - and after a
write the shadow and the latch disagree. The firmware believes its shadow and
will not restore the latch on its own; a bit left flipped stays flipped until an
explicit write or a power cycle. Observed: setting `0x12` bit 1 turned MR off
and it stayed off. The firmware's own read-modify-write is interrupt-protected;
a shadow read followed by a separate `O` write is not atomic against it.

### Do not write port `0x10`

`0x1490` starts from `[0x30e]`, forces bit 5 high and bit 3 low, `out 0x0e,0x6f`
to select, then toggles bit 6 as a clock with `in al,0x10` reading data back;
`0x1540` restores the shadow and writes `out 0x0e,7`. That is the bit-banged
serial EEPROM holding the modem's saved profiles, and the same pattern recurs at
`0x27a6e..0x27b64` in another bank. These bits are driven by direct `out 0x10`
writes that bypass the helper API, so a scan of helper call sites does not see
them. **An arbitrary byte written to port `0x10` can clock the NVRAM
interface.**

### Confirmed function of the driven bits

Established by strobing single bits on a physical unit and watching the front
panel - user-reported observations, not captured transcripts. Port `0x14` is
active low: `0` lights the indicator.

| port | bit | function | evidence |
|---|---|---|---|
| `0x14` | 0 | CD lamp | observed |
| `0x14` | 1 | CS lamp (lit at idle) | observed |
| `0x14` | 2 | - | no driver located |
| `0x14` | 3 | driven, no visible effect | `0x22d6`/`0x22f3` |
| `0x14` | 4 | AA lamp | observed |
| `0x14` | 5 | ARQ lamp | observed |
| `0x14` | 6 | HS lamp | observed - **disputed, see below** |
| `0x14` | 7 | SYN lamp | observed |
| `0x12` | 1 | MR lamp (lit at idle) | observed |
| `0x12` | 3 | untested | `0x267d`/`0x269d`, gated on `[0xdfd]` |
| `0x12` | 4 | analog path: audible pop | observed - **disputed, see below** |
| `0x12` | 5 | untested | `0x25d0`, gated on `[0x693] & 6` |
| `0x12` | 7 | forced low at init, no driver | `0x2737` |
| `0x10` | 0 | CD line to the DTE | `0x92b1`/`0x9380` set on connect, `0x93a2`/`0x93d9`/`0x96a7` clear on teardown, all gated on `[0x5b4] & 2`; `0x0b45` clears on timer expiry |
| `0x10` | 3, 5, 6 | serial EEPROM bit-bang | `0x1490`..`0x15a5` |

> **Two rows conflict with [the board measurements below](#measured-on-the-4-03d-board), which
> strobed the same bits on this same unit.** That file's sweep puts **no lamp**
> on `0x14` bit 6 and identifies it as the front-panel button - which the
> firmware supports, since `0x877cd` gates the self test on that bit *reading
> low* and `0x87e34` spins while it stays low, an input being released. It puts
> **HS** on `0x12` bit 4, where the row above records an audible pop. Five other
> attributions agree exactly between the two. Both sides are user-reported panel
> observations, so neither transcript arbitrates; re-strobing those two bits one
> at a time, watching and listening, settles it. Until then neither attribution
> should be built on.

Port `0x14` bit 0 driving the CD *lamp* while `0x10` bit 0 drives the CD *line*
is consistent: `&C` controls the line, the lamp follows carrier. The panel
indicators with no latch bit - RD, SD, TR, RS - are the ones expected to be
wired to the UART and control lines in hardware.

### The self-test table, and why strobing was considered safe

`0x26a8` walks a nine-entry table at `cs:0x26f2`, calls clear on every entry,
delays, then calls set on every entry with interrupts masked. It is reached by
`lcall 8000:26a4` from a dispatcher at `0x26247` when the parsed value is `5`;
the AT syntax that reaches that dispatcher has not been identified.

| entry | `AX` | port | bit | entry | `AX` | port | bit |
|---|---|---|---|---|---|---|---|
| 0 | `1009` | `0x12` | 4 | 5 | `0209` | `0x12` | 1 |
| 1 | `400a` | `0x14` | 6 | 6 | `020a` | `0x14` | 1 |
| 2 | `100a` | `0x14` | 4 | 7 | `800a` | `0x14` | 7 |
| 3 | `010a` | `0x14` | 0 | 8 | `200a` | `0x14` | 5 |
| 4 | `0108` | `0x10` | 0 | | | | |

The firmware drives each of these in both directions itself, so doing so by hand
reaches no state the firmware does not. **That argument survives; the reading
that the group is purely front-panel does not** - entry 0 produced an audible
pop, so this is a broader self-test than a lamp test. Entry 4 is on port `0x10`
and should be excluded on the NVRAM grounds above despite appearing here. Port
`0x12` bits 3 and 5 are driven by the firmware but are *not* in this table, so
they lack that cover, and the latch is now known to reach the analog path.

### Port `0x14` bit 2, probed 2026-09-04

Live shadows read `fe 7d f5 ff`, matching the earlier RAM capture exactly, so
the strobe was `f1` and the restore `f5`. Sequence: `AT`, `ATI7`,
`ATGLK2=0000:0300`, two `ATGLK2B0000` sweeps, the write, two sweeps, the
restore, two sweeps - each phase requiring two byte-identical sweeps before
being accepted, with the restore in a `finally` block. `artifacts/io-latch-bit2-01/`.

**Zero of the 256 ports changed while bit 2 was held low**, and the
post-restore sweep is byte-identical to the baseline. Because port `0x14` has no
refresh path, the bit genuinely stayed low across both intervening sweeps.

That is a null result about **feedback, not function**. A sweep sees only what
the CPU can read back; a latch bit routed to a DSP pin, a lamp or an analog gate
would not appear in the peripheral bank at all. What it establishes is that bit
2 is not wired into anything the supervisor can observe through I/O space, and
that the write/restore cycle disturbs nothing else. Whether the bit is visible
on the front panel was not checked.

### Bearing on the DSP

No bit the firmware drives is a DSP control line: every one resolves to a
front-panel indicator, a DTE control line, the NVRAM interface or the analog
path. That is **not** the same as establishing the latch bank contains no DSP
control - `0x14` bit 2, `0x12` bits 0, 2 and 6, and `0x10` bits 1, 2, 4 and 7
have no located driver, and absence of a driver is not evidence that nothing is
wired to the pin. The positive evidence that DSP reset is elsewhere is
`0xe3ab`/`0xe429` driving `[0xff56]` bit 1 directly, a CPU port pin rather than
an ASIC latch; that covers reset specifically and does not exclude some other
DSP-related strap or enable.

## Which DSP: a 'C50, possibly a 'C51 - not a 'C52

The core models a 'C52. **It is not one**, and the firmware says so three ways.

**Not a C2x either.** A 1200-word census finds `splk` (98), `samm` (71), `lamm`
(31), `bsar` (32), `bd` (32), `calld` (31), `retd` (36), `retcd` (108), `lacc16`
(21), `bcnd` (48), `bldd` (13), `smmr` (19), `lmmr` (2) and `apl`/`opl`/`xpl`
(14) - none with a C2x encoding. A TMS320C25 cannot run this program. The C50,
C51, C52 and C53 share the instruction set and differ in on-chip memory, so the
census fixes the family and the **memory map** has to choose the member.

SPRU056D Table 1-1, on-chip memory in 16-bit words:

| device | DARAM | SARAM | ROM | serial ports |
|---|---|---|---|---|
| 'C50 | 1056 | **9K** | 2K | 2, includes TDM |
| 'C51 | 1056 | 1K | 8K | 2, includes TDM |
| 'C52 | 1056 | **none** | 4K | **1**, no TDM |
| 'C53 | 1056 | 3K | 16K | 2, includes TDM |
| 'LC56 | 1056 | 6K | 32K | 2, BSP |

**1. The firmware maps SARAM that a 'C52 does not have.** Its prologue is

```text
8014  apl @07, #07f8      ; keep bits 3-10
      opl @07, #00b0      ; set bits 4, 5 and 7
```

and on a C5x bit 4 is `PMST.RAM` and bit 5 is `PMST.OVLY` - the two bits that map
on-chip SARAM into program space and overlay it into both spaces. A build sets
them only on a part with SARAM to map. Bit 7 is `IPTR`'s LSB, putting the vector
table at `0x0080`, which likewise needs on-chip memory there. On a 'C52 all three
are meaningless.

**2. `0x23f0` only fits the 9K part.** 302's mailbox dispatcher and its stream
resume poll both `calld 0x23f0` on every pass. That is below the external RAM, so
it has to be on-chip, and with `PMST.RAM` set the guide gives the 9K SARAM's
program range as **`0x0800`-`0x2BFF`**. A 3K part reaches only `0x13ff`, a 1K part
`0x0bff`, a 6K part `0x1fff`. **Only the 'C50 covers `0x23f0`.**

Data space agrees: Table 8-8 with `OVLY=1` puts SARAM at `0x0800`-`0x2BFF`, and
the prologue's block clears cover `0x0100-0x04ff`, `0x0800-0x08ff` and
`0x0b80-0x0bff`, with 302's mailbox ring at `0x0bd0` - all inside it.

**3. The 'C52 has one serial port and no TDM**, while this firmware sets up
`TSPC`, the TDM serial port control register, and transmits on that port
continuously from the idle task.

> **The 403 build does not need the 9K.** It puts the same helper in-bank at
> `0x80e8`, so only the older build reaches `0x23f0`. A board running 403 could
> therefore be a **'C51** on this evidence - 1K SARAM at `0x0800`-`0x0bff` still
> covers the ring at `0x0bd0` and the prologue's clears. What is excluded on every
> build is the 'C52.

**4. The package suffix says the same.** `TI DSP 16-912 (C) US ROBOTICS
**D17140PQ**` - `PQ` is TI's 132-pin BQFP suffix, carried by 'C50, 'LC50, 'C51
and 'LC51. The 'C52 is **PJ** and the 'C53 is not a PQ part either. The pin work
above already leaned on SPRU056D Table A-4's *PQ* pinout to place `VDDD` and
`IS`, so this was in the evidence unremarked. The rest of the marking is a custom
USR number and says nothing.

### The ROM size is the practical consequence, and it is not small

Table 1-1's ROM column decides whether the on-chip ROM has been fully captured:

| | SARAM | **ROM** | dump of `0x0000`-`0x07FF` covers |
|---|---|---|---|
| 'C50 / 'LC50 | 9K | **2K** | **all of it** |
| 'C51 / 'LC51 | 1K | **8K** | **a quarter** |
| 'C52 | none | 4K | half - excluded above |

`artifacts/dsp-onchip-rom-01/` is 2048 words, two halves at origin 0 and 1024. On
a 'C50 that is the whole ROM, and the 2K tiling exactly up to where the 9K SARAM
starts at `0x0800` is part of why the 'C50 fits. **On a 'C51 three quarters of it
has never been read.** [probing.md](probing.md#the-rom-dump-may-be-a-quarter-of-the-rom)
has the test that separates them - a stability test at `0x0800`, since both parts
would return something code-like there and only one returns the same thing twice.

### What that means for the core

`native/c5x_core.h` has the part with 4K of program ROM, three DARAM blocks and
**no SARAM at all**, making `PMST.RAM` and `PMST.OVLY` don't-cares, with
everything from `0x0800` up `External`. The guide's three memory-map figures agree
with the core everywhere *except* that:

| region | guide | core |
|---|---|---|
| program `0000`-`003F`, MP/MC=1 | external (vectors) | external |
| program `0800`-`2BFF` | **SARAM if `PMST.RAM`**, else external | external, always |
| program `2C00`-`FDFF` | external | external |
| program `FE00`-`FFFF` | DARAM B0 if `CNF`, else external | same |
| program `0000`-`07FF`, MP/MC=0 | 2K on-chip ROM | **4K**, `0000`-`0FFF` |
| data `0000`-`004F` / `0050`-`005F` | registers / the 16 I/O ports | same |
| data `0060`-`007F` / `0100`-`02FF` / `0300`-`04FF` | B2 / B0 / B1 | same |
| data `0800`-`2BFF` | **SARAM if `PMST.OVLY`**, else external | external, always |
| data `2C00`-`FFFF` | external | external, less the shared window |

**So the correction to make is the memory map, not just the part number**: SARAM
mapped by `PMST.RAM`/`OVLY` instead of stubbed. That has not been made or tested.
The ROM row is a harness fixture rather than a claim about the board - the
firmware runs MP/MC=1 where that window does not exist, and the probe kernels in
`dsp_probe.py` and `fsk.py` use microcomputer mode to host 4K synthetic drivers
of their own.

**And the shared external window is ordinary, not a trick.** The guide puts
nothing on-chip above `0x2BFF` in data space, and nothing above it in program
space with `CNF` clear, which is how this firmware runs. So a reference to
`0x8000`-`0xFEFF` is an off-chip bus cycle in **both** spaces - the same address
driven on the same pins. One RAM answering both is a board that does not separate
the two strobes, which is what 302's `bldp` from data `0x80f5` needs.

> An earlier reading had the 9K SARAM "decoding with A15-A14 ignored" and
> therefore mirroring. That is **Table 8-15, address ranges during external
> DMA**, and applies to a DMA master reaching the SARAM - not to the CPU's own
> program and data addressing.

### Its program memory is RAM

The bridge does not assume the transfer: it accumulates the supervisor's actual
download stream and compares it against the image. Every run reports
`bootstrap_match: true` at `bootstrap_bytes: 60344` - 30,172 words, the whole
origin-`0x0000` segment covering program `0000..75d9`.

So the supervisor transfers 30k words of `0x0000`-origin code spanning the entire
mask-ROM window. **Program `0000..0fff` is written by the CPU, so it is external
RAM**, and the part runs in microprocessor mode. Whether the die also carries a
mask ROM that is simply never mapped is not something this can say.

The two `CY7C199-15VC` give 64 KB = **32K words, exactly `0x8000`-`0xffff`** - the
range the supervisor's downloads fill (`0x8000`-`0xf8b5` on 302, `0x8000`-`0xf949`
on 403, about 31K words). The part is sized for the job with a little to spare.

## The codec, and a withdrawn identification

| board | part on the DSP's serial port |
|---|---|
| the 20 MHz boards | **TLC320AC01** |
| the 25 MHz Courier 2806 | **TLC320AC03** |
| the 3453C - taken to be `main211.xmf` | **Si3021 + Si3014**, no TI codec |

Three generations, one part each, reported by the owner from the units in hand.
TI first, Silicon Labs last.

**The firmware does not prove the part, and a claim that it did is withdrawn.**
The 16-word control table at program `0x019c` - `0911 0967 0956 0934 0923 0969
0989 bc07 1019 ba01 9019 f788 be4c 7718 8b8f 8711` - was offered as proof of a
TLC320AC0x. It appears in `main211.xmf` **and nowhere else**, and `main211`'s
board is the one carrying **no TI codec at all**. So that table is the bring-up of
the Silicon Labs pair, and the claim was exactly inverted. (This rehabilitates
`CodecBringUp`, which runs an `SI3038.PDF` sequence: a Silicon Labs sequence is
the right family for that build, and only the part number is in doubt.)

The secondary-frame protocol - bit 0 of the transmitted DAC word requesting a
control frame - cannot discriminate either, because it appears on both sides of
the split: in `main211` (Si pair) and in the ID_SDL 4.03 build for an AC01 board.
A protocol common to both is evidence about serial framing, not about silicon.

**The AC01-to-AC03 change is invisible to the DSP**, and the reason is not the
ASIC. An earlier explanation had the ASIC fronting the codec so the DSP need not
know which variant is fitted; the continuity readings put `DOUT`, `DIN` and `FS`
straight onto DSP pins 43, 106 and 104, with the ASIC's only line being `MCLK`.
The simpler explanation survives and needs no ASIC: **AC01 and AC03 are the same
family**, same protocol, same register map, so identical DSP code drives either.

## The flash is Intel and the harness models an AMD part

The 2806's flash is marked `PA28F400`, Intel's 4 Mbit boot-block part.
`courier_emu/flash_device.py` models an **AMD Am29F400AT**, device code `0x2223`,
with that part's eleven-sector top-boot map hard-coded as fixed geometry.

Those disagree, but not yet in a way that is demonstrably a bug. The AMD choice
was never read off a board: it was **inferred from the update image**,
`Ie030002.nac`, which probes for a manufacturer word and takes the AMD path when
Intel does not answer. That image is the I-modem's, not the 2806's.

What makes it worth recording is that the sector map is load-bearing: the file
reasons from the Am29F400AT's boot-block layout that the updater's one erase lands
in `SA8` and leaves `SA9`/`SA10` untouched, "which is what a settings store in
flash looks like". An Intel 28F400 has its own block map, and `-T` and `-B` parts
put the boot blocks at opposite ends.

**The cheap check is the one the update image itself performs**: read the
autoselect words out of the 2806. Manufacturer `0x0089` is Intel, `0x0001` is AMD,
and the device word names the part and its boot orientation. That is a monitor
read.

The flash pinout is confirmed against the Am29F400B 44-lead SO diagram - `A17`,
`A7` and `A0` on pins 3, 4 and 11 all match the board readings - and `BYTE#` is
tied high, so it runs in word mode and its `A`n is system `A`n+1.
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
2. **The paging register.** The ASIC consumes one CPU address bit and drives the
   flash's top three plus its `CE#`, so something chooses what it substitutes.
   No port bit has been identified and nothing in `courier_emu` pages the flash.
   **The largest unmodelled behaviour on the board.**
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
16. **Whether `&T1` is the codec's analog loopback.** Register 5 `DS01`-`DS00` =
    `00` is analog loopback and the bring-up writes `0505`, which is not. A
    `0504` in the payload would tie the `AT` diagnostic to a hardware mode; its
    absence would say the loopback is arithmetic in the DSP. No hardware needed.
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
