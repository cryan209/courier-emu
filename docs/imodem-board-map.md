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

## The AT&T part: what can be said without its datasheet

Its function is not identified here, and guessing a part number's job into
this file would be worse than leaving it open.  What the firmware does settle
is that **the emulator does not need it**:

* It is not in I/O space.  The port census below covers every port a
  40-million-instruction run touches; there is no window for it.
* It is not in the two chip-select windows above 1 MiB either.  CS1 at
  `100000` and CS3 at `104400`, both 16 KiB, are programmed at init and then
  **never read or written** in a run - though that is weak evidence, since
  this harness enters in real mode and could not reach them anyway.
* The firmware has no vocabulary for a U interface.  `NT1`, `2B1Q`,
  `U-Interface` and the like appear nowhere in its strings; the only loopback
  text is the analogue and digital loopbacks every Courier has.  So the 386
  does not drive it.

Which leaves a part that is autonomous or slaved to another chip.  Three cases
are distinguishable by what its pins go to, and one probe settles it:

| if it connects to | then it is |
|---|---|
| the line jack and the Valor transformer on one side, the Am79C30A's LIU pins on the other | a U-to-S/T converter - an integrated NT1, which by design needs no host configuration, and would make this the US variant |
| the DSC's **peripheral port** pins | an audio or codec part on the DSC's serial port - which would fit `PP_PPCR1` being enabled at init and `MCR1`-`MCR4` never routed |
| the analogue line section and the relays | part of the telephone interface rather than the ISDN one |

The second is the one the firmware faintly favours, for the reasons in the
section above; none of it is established.

The two flash parts are the important observation.  A board carrying an Intel
and an AMD part at once explains the boot code's identify sequence far better
than second-sourcing does: it tries Intel's `ff`/`90` first and falls back to
AMD's `aa`/`55`/`90`, which is what you write when either vendor's part may
answer at the window you are addressing.

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
| UCS | - | `80000`-`fffff` | 512 KiB |
| CS2 | `000c` | `c0000`-`fffff` | 256 KiB |
| CS1 | `0010` | `100000`+ | 16 KiB |
| CS3 | `0010` | `104400`+ | 16 KiB |

CS0 and CS5 are contiguous: **256 KiB of SRAM at `00000`-`3ffff`**, which is
the pair of LGS parts and is exactly the `Ram 256k` that `ATI7` reports.

Everything from `40000` to `fffff` is **768 KiB**, which is exactly the
`Eprom 768k` `ATI7` reports - and it is not one part.  CS4 covers `40000`-
`7ffff` on its own, and the flash the updater identifies is at `80000`:
`34983` loads `es` with `8000` and probes there, with no bank loop and no
parameter.  So the region this repository has been describing as "the updater,
in RAM" at `40000`-`80000` is its own chip-select window, and the second flash
part is the obvious occupant.

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
