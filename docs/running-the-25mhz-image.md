# The 2806's own firmware runs, and always could

This file was started to work out what it would take to run the 25 MHz Courier
2806's firmware - the board every pin reading in
[asic-pinout.md](asic-pinout.md) comes from. It went through three wrong
premises before the answer turned out to be **nothing**. The image runs today,
on the machinery already here, and the wrong turns are kept below because each
was reached by a plausible route.

## It runs

```
artifacts/boot-2806-capture-20260913/boot_run.py \
    artifacts/courier-2806-25mhz-flash-20260912/courier-board.rom 60000000
```

**Since 2026-09-13 that needs no arguments at all** beyond the image: the tick
is the default now (see below), `board_id` already defaulted to 7, and the
EEPROM fixture turns out not to be needed - with and without it the profile
differs by three bytes. The recipe recorded in the artifact passes all three
explicitly because that is what was run. The board's own `ATI7`:

```
USRobotics Courier V.Everything Configuration Profile...

Product type           US/Canada External
Options                HST,V32bis,Terbo,VFC,V34+,x2,V90
Clock Freq             25 Mhz
Flash ROM              512k
Ram                    64k
Supervisor rev         7.3.14
DSP rev                3.0.13
```

Supervisor 7.3.14, DSP 3.0.13, 25 MHz, 512k flash, 64k RAM - the 2806 exactly
as [board-parts.md](board-parts.md) describes it. No 25 MHz mode, no loader
change, no paging model.

`serial_text` is **7 data bits and even parity**, not 8N1 - all 430 bytes of
that profile match even parity and none match odd - so mask to seven bits to
read it. That is the firmware's choice: `S0CON` is mode 1, eight bits on the
wire, and the firmware puts ASCII in seven of them and parity in the eighth.

A real board reaches the right format two ways - it **autonegotiates** from the
`AT` prefix, and the format is **stored in the settings EEPROM** - and neither
works here. The autonegotiation has nothing to measure: on the board the
received data goes inverted through a 74AHC04 into `T1IN` (CPU pin 78) so the
firmware can time a bit cell, a path [asic-pinout.md](asic-pinout.md) traced and
the harness does not model. Feeding input with bit 7 set gets no response at
all, which is the same gap from the other end. And no fixture carries a stored
format: booting this capture against no NVRAM, the 302 fixture and the 403
fixture gives 427, 430 and 473 bytes of profile, all three with the parity bit
set.

**There is no captured 93C66 image in this repository.** One would settle this
and several other blank-fixture caveats, and the part is now fully mapped -
`CS`/`SK` on CPU 52/57, `DI`+`DO` on CPU 79 - so reading one off a board is a
known job rather than a search.

## The tick is the default now

`tick_ms` used to be off by default, on the grounds that supplying it changes
call timing and which behaviour is faithful was open. **An undriven run is not a
slower run, it is a broken one** - see the next section - so the default is now
`SUGGESTED_TICK_MS`, 5 ms. Pass `tick_ms=0` or `--tick-ms 0` for the old
behaviour.

It remains a stand-in. What produces the real periodic edge is still not
established, and modelling that is the actual fix; defaulting the stand-in only
stops every long run from walking into the same wall.

## The fault that started this was a missing tick

Running the same image under `artifacts/mailbox-tap-atdt-01/tap_run.py` dies:
`UC_ERR_INSN_INVALID` at **5,684,093** instructions, at `0x2e3:0xd112`, linear
`0xff42` - in RAM rather than flash. That looked like a board-specific gap, and
this file argued at length that it was one.

**It is not.** `tap_run.py` does not pass `tick_ms`, and
[machine.py](../courier_emu/machine.py) says plainly that the tick "is not
driven by default". Run the **20.16 MHz 4.03d capture** the same way and it
stops at **5,689,414** instructions - within 0.1% of the same place. Two boards,
two generations, the same wall. Supply `tick_ms=5` and both run to a
60,000,000-instruction limit with no error at all.

So the fault was the harness starving the firmware of its timebase, and the
address it died at was wherever that happens to strand it.

## The wrong turns, and what settled each

Kept because the routes were reasonable and the corrections came from evidence
rather than from re-reading.

**"Every behavioural target here is a 20.16 MHz image."** Wrong: `T0CMPA`
(`0xff32`) shows the ROM builds are 20.16 MHz (`6270`) and **every XMF
supervisor is 25.8048 MHz** (`7e00`). `courier_emu/daa.py` already said so in a
comment. Settled by reading the constant out of eight images.

**"The capture is a supervisor image misrouted through the ROM model."**
Wrong: it ends in the same reset stub as the 4.03d capture - `fa ba a4 ff b8 00
80 ef` then a far jump into `fc00` - and is 45.7% byte-identical to it, as close
as that capture is to `IDSDL302.ROM` (45.2%). `CourierRom` is the right
identification. Settled by comparing the three images.

**"The gap is board-specific, and the flash paging is the suspect."** Wrong,
and the reason is the useful part. **The ASIC is the same part across the old
and middle generations**, so a board-specific explanation for a fault only this
board's image showed was suspect from the start - and the 4.03d capture failing
at the same instruction count confirms it. Settled by running the other capture
under the same conditions.

**Retracted 2026-09-18.** This used to add that "the paging finding itself
stands - the ASIC does hold the flash's `CE#`". It does not. Flash `CE#` is on
CPU `UCS`, and the reset stub quoted above is the proof in this file's own
bytes: `ba a4 ff b8 00 80` is `mov dx,0xffa4` / `mov ax,0x8000` - programming
`UCS_START` to the flash's own base before anything else runs. The ASIC does
consume one upper address line, but `A19` is consumed by the `UCS` decode, which
is what a flat map looks like. See
[asic-pinout.md](asic-pinout.md#the-fold-four-address-lines-in-three-out).
Boot not exercising paging is now the unremarkable case rather than a puzzle.

## What this leaves

Not a porting problem. Two narrower ones:

* **Nothing in the repository had run this image.** The target guidance points
  at `IDSDL302` and the 4.03d capture, both 20.16 MHz, while the pin readings
  are all from the 2806. That gap was real; it closes with an invocation rather
  than with code.
* **`SV25.XMD` still cannot execute.** It decodes to this capture byte for byte
  but for the four checksum bytes at `0x77ffc..0x77fff` - verified here - and
  `machine.run` fails mapping an `XmdImage` (`UC_ERR_WRITE_UNMAPPED`). A decoder
  that cannot run what it decodes is a real gap, but a convenience one: the
  bytes are already runnable in their captured form.

## The three generations

| generation | images | clock | flash / RAM |
|---|---|---|---|
| old | `IDSDL302.ROM`, the 4.03d capture | 20.16 MHz | 512k / 64k |
| **middle - this board** | the 2806 capture, `SV25.XMD` | 25.8048 MHz | 512k / 64k |
| new | `main211.xmf`, `3453Bv2.1.1.xmf` | 25.8048 MHz | 1024k / 256k |

`main211` is the **newest** generation - V.92, rev 2.1.1, dated 2003 - not a
variant of this board. [board-parts.md](board-parts.md) reaches the same split
from the firmware side: "the middle generation groups with the old one, not the
new one". The shared ASIC is the hardware saying it too, and the practical
clincher is that **one recipe boots both**.

So preferring 302/403 as behavioural references costs nothing here. This board
is old-generation kin with a faster clock, and its own image answers to the same
machinery.

## The clock, which is settled

`CLKOUT` is **25.8048 MHz** and the crystal is **51.6096 MHz**, from firmware
alone and confirmed twice over:

* `T0CMPA` is `0x7e00` = 32,256 against the 20.16 MHz builds' 25,200. The ratio
  is 1.28 exactly, and 32,256 at `CLKOUT/4` is a 5.000 ms tick.
* The baud divisors are 167 and 335 against 130 and 258. Through
  `baud = CLKOUT / (8 x (N+1))`, 25.8048 MHz gives **exactly** 19200 and 9600;
  a round 25 MHz misses both by 3.1%, which no 8N1 link tolerates.

`51,609,600 / 19,200 = 2688` exactly - the crystal was chosen to make the UART
divide perfectly, which the 20.16 MHz board's 0.19% and 1.35% errors do not. The
CPU crystal is marked `R0936391`, a house part number that gives no frequency.

**This is the CPU's domain only.** The ASIC runs from the shared 40.320 MHz can
on both boards, so the DSP's clock and the codec's `MCLK` are board-independent
- which is why the DSP payload is byte-identical across the two while the
supervisors differ.
