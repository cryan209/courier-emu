# The I-modem board, and the address map its chip selects draw

A photograph of the board settles several things the image could only hint at,
and one of them was being modelled wrong.

## What is on it

| marking | what it is |
|---|---|
| Intel **KU80386EX25** | the CPU, as [imodem-isdn-front-end.md](imodem-isdn-front-end.md) worked out from its peripheral registers |
| AMD **AM79C30AJC/J** | the ISDN front end - the part at ports `0300`-`0307` |
| AMD **AM7945JC** | a second AMD telecom part, not addressed by anything this image executes - see below |
| Intel **TE28F400** and AMD **AM29F400AT** | *two* 4 Mbit flash parts, side by side |
| LGS **GM76C8128ALLFW70** x2 | 128K x 8 SRAM each - 256 KiB paired |
| ISSI **IS61C256AH-12** x2 | 32K x 8 SRAM - the DSP's |
| USR **DSP EBS-64A56DW** | the DSP, custom-marked |
| Altera **EPM7032LC44** (`USR 19457`) | the glue - the board latches the firmware reaches at ports `0x10`-`0x1e` and `0x100` |
| Sipex **SP503CP** | the DTE transceiver |

plus an **AT&T** part marked `T 7256 ML2` (date code `9613S`), and the line
section: a Valor **ST15069** transformer module, a Takamisawa **RY5W-K**
relay, a CP Clare **LH1502** solid-state relay and an **XCA111E** optocoupler.

## The AT&T part is the NT, and the board is the integrated-NT variant

The board this came from is the integrated-NT version, with an analogue jack
alongside the ISDN one - which places the AT&T part.  It is the U transceiver:
line jack and Valor transformer on one side, an S/T loop to the Am79C30A's LIU
on the other, doing on the board what an external NT1 would do in a box.

That is consistent with everything the firmware does, and it is why it needs
no model.  An integrated NT is autonomous by design: the 386 never configures
it, which is why there is no window for it in I/O space, nothing in the CS1
and CS3 windows above 1 MiB, and no `NT1`, `2B1Q` or `U-Interface` anywhere in
the firmware's strings.  The only loopback text in the image is the analogue
and digital loopbacks every Courier has.  As far as the emulator is concerned
the S interface starts at the Am79C30A's LIU, and
`courier_emu/am79c30.py` driving that LIU through its I.430 states is the
whole of the line.

The analogue jack places the other unknown too.  A POTS jack needs an audio
path between a B channel and a handset, which is exactly what the DSC's MAP
and peripheral port are for - `PP_PPCR1` is enabled at init and `MCR1`-`MCR4`
are left unrouted for want of a call - and the **Am7945** sitting off the bus
next to the analogue line section is the natural occupant of that path.  Still
an inference, but now a well-supported one.

## The Am79C30A is the part at 0300, and the Am7945 is not on the bus

Worth separating, now that two AMD telecom parts are known to be fitted.  The
chip at `0300`-`0307` is the **Am79C30A** and that is not in doubt: the
indirect register file matches its block widths exactly - seven bytes to
`DLC_1_7`, two to `DRCR`, forty-six to `MAP_1_10` - and the IRQ14 handler uses
CR/IR, DR, DSR1, DER, DCTB/DCRB and DSR2 in that part's direct-map order
([imodem-d-channel.md](imodem-d-channel.md)).

The **Am7945** is not reached through I/O space at all.  A census of every
port a 40-million-instruction run touches, with the code site behind each,
leaves nothing that looks like a second device: `0x00`-`0x16` are written once
apiece from one board-init sweep at `40509` and otherwise belong to the board
latches, `0x1a` is the DSP handshake, `0x100` is the lamps, and there is no
second command/data pair anywhere.

Where such a part could sit without appearing is the DSC's own **peripheral
port**, which the firmware enables at init and never routes: `PP_PPCR1` is set
to `07` and `PP_PPCR3` to `01`, while `MCR1`-`MCR4` stay at zero for want of a
call.  That, the MAP's transmit and receive filter coefficients, and the
analogue line section on the board together point at an audio path between a
B channel and an analogue handset - which is what an I-modem does when you
plug a telephone into it.  That is an inference from the firmware and the
board, though, not something the image states; what would settle it is the
Am7945's own datasheet or a probe of which of its pins go to the DSC.

## The map, from the chip-select unit

The 386EX's chip-select unit is programmed at init, and reading back what the
firmware writes to `f400`-`f438` gives the board's memory map outright.  Each
channel's `ADH` carries A25:A16 and its `ADL` bits 15:10 carry A15:A10, with
the mask registers naming the don't-care bits:

| channel | ADH | window | size |
|---|---|---|---|
| CS0 | `0000` | `00000`-`1ffff` | 128 KiB |
| CS5 | `0002` | `20000`-`3ffff` | 128 KiB |
| CS4 | `0004` | `40000`-`7ffff` | 256 KiB |
| CS2 | `000c` | `c0000`-`fffff` | 256 KiB |
| UCS | - | **not determined** | - |
| CS1 | `0010` | `100000`+ | 16 KiB |
| CS3 | `0010` | `104400`+ | 16 KiB |

CS0 and CS5 are contiguous: **256 KiB of SRAM at `00000`-`3ffff`**, which is
the pair of LGS parts and is exactly the `Ram 256k` that `ATI7` reports.

**UCS is only half programmed.**  The firmware writes `UCSADL` and nothing
else - `f432`, `f434` and `f436` are never written in a whole run - so the
upper chip select keeps its reset window, and this file does not claim to know
what that is.  Something decodes `80000`, because that is where the flash
identify at `34983` probes (`es = 8000`, no bank loop, no parameter), but the
extent of that window is not recovered.

### 768 KiB mapped, 1 MiB fitted

`40000`-`fffff` is **768 KiB**, and `ATI7` says `Eprom 768k`.  It is also
exactly the span of the NAC payload, which loads at `40000` and runs to
`f8000` - the whole flash image bar the top 32 KiB boot block.  Three numbers
agreeing is worth something.

But two 4 Mbit parts is **1 MiB of silicon**, and 768 KiB is not 1 MiB.  So at
least 256 KiB of what is fitted is not mapped into the first megabyte.

The update image is what says how that 768 KiB is composed.  `Ie030002.nac` is
840,105 bytes on disk - 42,222 records, of which 42,023 carry data and 197 set
the segment address - and it flattens to **753,664 bytes, 736 KiB, at
`40000`-`f8000`**.  It splits exactly on the chip-select boundary:

| region | bytes | | erased |
|---|---:|---|---:|
| `40000`-`7ffff` | 262,144 | 256 KiB - all of CS4 | 3.8% |
| `80000`-`f8000` | 491,520 | 480 KiB - 512 KiB bar the top 32 KiB | 18.5% |

So the image supplies precisely one whole 256 KiB window and one whole 512 KiB
part minus the boot block it does not replace.  256 + 512 is the 768 KiB, and
it composes as **one part mapped whole at `80000`-`fffff` and half of the
other at `40000`-`7ffff`** - the reading proposed above, now with the image
agreeing rather than just the address arithmetic.  The unmapped 256 KiB is the
rest of the CS4 part.

That also means the payload's first 256 KiB is not "the updater, loaded into
RAM": RAM ends at `3ffff`, and the initialiser relocates its working copy down
to `0ce00`.  `40000` is flash, so that 256 KiB is flash part B's own contents,
and the NAC image is a dump of both mapped windows rather than only what an
update writes.

One caution on using `ATI7` as corroboration: this repository has already
caught `ATI7` reporting a firmware constant as though it were measured - its
options list on the Quad
([quad-settings-eeprom.md](quad-settings-eeprom.md)) was the firmware's own XOR
constant surfacing as data, with nothing read from any part.  `Eprom 768k` may
be a constant too, in which case it records what the design intends rather
than what is fitted.

What is certain either way: the region this repository has been describing as
"the updater, in RAM" at `40000`-`80000` is its own chip-select window, and a
flash part is the obvious occupant.

That matters for [imodem-d-channel.md](imodem-d-channel.md)'s open question.
The settings block at `2600:d476` is never filled in a run, and the harness
has only ever modelled the part at `80000`; a second flash the harness treats
as ordinary RAM is a candidate for where it is loaded from.

## The part at 0x80000 is AMD, and the harness was answering as Intel

`courier_emu/flash_device.py` defaulted its identify to Intel, so every run
took the Intel branch - `50` clear status, `20`+`d0` erase, `70` status.  The
board carries an Am29F400AT at that window, so a real board takes the **AMD**
branch, and the difference is not cosmetic:

| identity | autoselects | erases | programs |
|---|---:|---:|---:|
| Intel (what the harness answered) | 4 | 4 | 0 |
| AMD Am29F400AT (what is fitted) | 6 | 1 | 4096 |

Under Intel the updater erased and then **programmed nothing**.  Under AMD it
erases its sector and writes 4,096 words - the update actually happening.  The
model now defaults to `manufacturer 0x0001`, `device 0x2223`, and carries AMD's
command set alongside Intel's: `aa`/`55`/`a0` then a write to program,
`aa`/`55`/`80` then `aa`/`55`/`30` to erase a sector, `10` for the whole part,
`f0` to reset.

The sector map is the part's own, and it confirms a guess.  The Am29F400AT is
top boot: seven 64 KiB sectors, then 32, 8, 8 and 16 KiB.  The updater's one
erase is at flash offset `78100`, which falls in **SA8, the first 8 KiB boot
sector** - which is exactly the 8 KiB block size
[imodem-isdn-front-end.md](imodem-isdn-front-end.md) had inferred from the
erase address alone, now read off the part instead of reasoned toward.  SA9
and SA10 above it are never erased and never programmed by an update, which is
what a settings store in flash looks like.

One detail recovered alongside it: `34975` clears bit 7 of the 386EX's P2
latch and spins 6,000 times before touching the flash, and sets it again
after.  That is the write protect, and it is why port `f86a` toggles around
every flash operation.
