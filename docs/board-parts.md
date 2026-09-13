# What is actually on the board

Identified from a photograph of the user's 20.16 MHz Courier (the unit running
ID_SDL 4.03d, supervisor 7.4.16 / DSP 3.1.2), with each claim checked against
the firmware where the firmware can check it.

Markings are read off one photo of part of the board. The DAA/line section is
not in frame, so nothing here says what is on it.

| marking | what it is |
|---|---|
| `NEC USA 1-016-905 9948LV001` | **the ASIC.** A USR part number on an NEC-fabricated gate array, date code week 48 1999; pinned out in [asic-pinout.md](asic-pinout.md) |
| `TI DSP 16-912 (C) US ROBOTICS D17140PQ` | the C5x-family DSP, custom-marked with a USR part number |
| `S80C186` | the Intel supervisor. Its `GCS0` (QFP pin 59) is the ASIC's chip select, so the ASIC's I/O window is set by the programmable limits at `0xff80`/`0xff82` rather than decoded in the ASIC. The pin readings identify it more precisely as an **80C186EB in the 80-lead QFP** - `RD`/`WR`/`ALE` on 36/37/38 and `INT0`/`INT2` on 62/64 all match that package's Table 7 exactly, and match the XL's not at all. Which is the device `courier_emu/uart.py`'s `EbSerial` already assumes |
| `TLC...320AC01CFN` | the voice-band codec, PLCC, next to the DSP |
| `ECLIPTEK EC11 40.320M` | the master oscillator |
| `NEC D43256BGU-70LL` x2 | the **80186's** SRAM, `U4` and `U12`: not two banks but the **low and high byte lanes of one 32K x 16**. Both `CE#` on CPU `LCS` (QFP pin 60); separate `WE#` from two '32 gates, `U12`'s qualified by latched `A0` from the ASIC and `U4`'s by `BHE#` straight from CPU pin 39 |
| `CY7C199-15VC` x2 | the **DSP's** SRAM: 2 x 32Kx8, 64 KB = 32K words on a 16-bit bus |
| `ISSI IS61C256AH-15J` | 32Kx8 15 ns SRAM |
| `ADM707` | supervisory/reset |
| `74VHC573`, `74VHC32`, `74VHC04` | bus glue. The '573 is an **address demultiplex latch**; there is exactly **one** '573 and it latches the **high** byte, `AD8`-`AD15` into `A8`-`A15`, with a `74VHC32` beside it. `A0`-`A7` come out of the **ASIC** instead - pins `71`-`64` carry system `A0`-`A7`, `A0` to the byte-lane gate and `A1`-`A7` to both memories - so the two parts split one address latch between them. The '32 makes both SRAMs' write enables - gate 4 to `U12` pin 27, gate 3 to `U4` pin 27 - each `OR`ing the board write strobe with a byte-lane term, ASIC pin 71 being the low lane's. See [asic-pinout.md](asic-pinout.md) |
| `PA28F400` | the **flash**. Intel 4 Mbit / 512 KiB, which is the 2806 dump exactly. Pinout confirmed against the Am29F400B 44-lead SO connection diagram - `A17`/`A7`/`A0` on pins 3/4/11 all match the board readings. `BYTE#` is tied high, so it runs in word mode and its `A`n is system `A`n+1 - pin 3 is system `A18`, pin 34 system `A17`. Data is unbuffered - flash `DQ11` (pin 22) lands straight on CPU `AD11` (QFP pin 20). One high address pin comes from ASIC pin 74 - read as pin 3 (`A17`) and later as pin 34 (`A16`), see [asic-pinout.md](asic-pinout.md) |
| `SN75188` x2, `U22` and `U23` | the **EIA-232 line drivers**, TTL in / EIA out, modem-to-DTE only; `RD` is traced to `U22` pin 2 and `CD` to `U23` pin 4. **Three of `U23`'s four drivers are fed from the ASIC** - ASIC pins 9, 11 and 12 onto `U23` 4/10/2 (`2A`/`3B`/`1A`), so `CD` is an ASIC output and the other two gates are unassigned modem-to-DTE signals. See [asic-pinout.md](asic-pinout.md) |
| `74AHC04` | inverter; one gate sits in the `SD` path, see [asic-pinout.md](asic-pinout.md) |
| `RA5W-K` | the **hook relay**. The `OH` lamp is on its pin 9, which is why `OH` is the one panel line not on the ASIC |
| Atmel 93C66 | serial EEPROM, the NVRAM the settings cache comes from. On the 2806 it is the **CPU's**, not the ASIC's: `CS`/`SK` on CPU pins 52/57 (`P1.5`/`P1.2`) and `DI`+`DO` tied onto CPU 79 (`P2.7`). `ORG` floats, which on the Atmel part is x16 - 256 words, matching `nvram.py`. All eight pins are read: 5 and 8 are `GND` and `VCC`, and pin 7 floats, as Atmel's `DC` pin should. See [asic-pinout.md](asic-pinout.md) |

## The DSP's RAM is 32K words, and that is its program space

Two `CY7C199-15VC` give 64 KB, which on the C5x's 16-bit program bus is
**32K words - exactly `0x8000`-`0xffff`**. That is the range the supervisor's
downloads fill: the overlay table writes `0x8000`-`0xf8b5` on 302 and
`0x8000`-`0xf949` on 403, about 31K words, so the part is sized for the job
with a little to spare. It also retires the arithmetic in
[who-produces-the-events.md](who-produces-the-events.md) that could not fit
those downloads into one 32Kx8 device: there are two, and they are the DSP's,
not the supervisor's.

The one address it does not cover is `0x23f0`, which 302's mailbox dispatcher
and its stream resume poll both `calld` on every pass. That is below the
external RAM, so it has to be on-chip - and the C5x User's Guide (SPRU056D)
turns that into a part identification.

**Table 1-1, on-chip memory in 16-bit words:**

| device | DARAM | SARAM | ROM | serial ports |
|---|---|---|---|---|
| 'C50 | 1056 | **9K** | 2K | 2, includes TDM |
| 'C51 | 1056 | 1K | 8K | 2, includes TDM |
| 'C52 | 1056 | **none** | 4K | **1**, no TDM |
| 'C53 | 1056 | 3K | 16K | 2, includes TDM |
| 'LC56 | 1056 | 6K | 32K | 2, BSP |

With `PMST.RAM` set the SARAM is mapped into program space, and for the 9K
part the guide gives its range as **`0x0800`-`0x2BFF`**. `0x23f0` is inside it.
A 3K part reaches only `0x13ff` and a 6K part only `0x1fff`; a `'C52` has no
SARAM at all, so `PMST.RAM` and `OVLY` - both of which this firmware sets -
would be meaningless on it.

The guide gives the location twice, and both match what this firmware does:

* **Program space.** With `CNF=0`, `RAM=1`, `MP/MC=1` - microprocessor mode,
  which is how this part runs - the 9K SARAM occupies **`0x0800`-`0x2BFF`**,
  with `0x0000`-`0x07FF` and `0x2C00`-`0xFFFF` off-chip. `0x23f0` is inside it,
  and the external RAM at `0x8000`-`0xFFFF` sits in the off-chip part, exactly
  as the download map needs.
* **Data space.** Table 8-8, `'C50` Local Data Memory Configuration, `OVLY=1`:
  registers `0x0000`-`0x005F`, B2 `0x0060`-`0x007F`, B0 `0x0100`-`0x02FF`,
  B1 `0x0300`-`0x04FF`, **SARAM `0x0800`-`0x2BFF`**, off-chip `0x2C00`-`0xFFFF`.
  The prologue's clears of `0x0800`-`0x08FF` and `0x0B80`-`0x0BFF`, and the 302
  mailbox ring at `0x0BD0`, all land in that SARAM window.

One further detail agrees: the `'C52` has one serial port and no TDM, while
this harness models a TDM ISR for the part.

An earlier revision of this section said the 9K SARAM "decodes with A15-A14
ignored" and therefore mirrors. That is **Table 8-15, address ranges during
external DMA**, and applies to a DMA master reaching the SARAM - not to the
CPU's own program and data addressing, which is the two tables above.

So the DSP is a **TMS320C50 or LC50**, not the `'C52` the core models. That is
inferred from the firmware's memory use against the guide's tables, not from
the part marking, which is a custom USR number.

### The guide's figures, checked against the core region by region

The three memory-map figures - program space in each MP/MC mode, and local
data memory - agree with `native/c5x_core.h` everywhere except one constant:

| region | guide | core |
|---|---|---|
| program `0000`-`003F`, MP/MC=1 | external (vectors) | external |
| program `0800`-`2BFF` | SARAM if `PMST.RAM`, else external | same |
| program `2C00`-`FDFF` | external | external |
| program `FE00`-`FFFF` | DARAM B0 if `CNF`, else external | same |
| program `0000`-`07FF`, MP/MC=0 | 2K on-chip ROM | **4K**, `0000`-`0FFF` |
| data `0000`-`004F` | memory-mapped registers | same |
| data `0050`-`005F` | the 16 I/O ports PA0-PA15 | same |
| data `0060`-`007F` / `0080`-`00FF` | DARAM B2 / reserved | same |
| data `0100`-`02FF` | DARAM B0, reserved when `CNF` | same |
| data `0300`-`04FF` / `0500`-`07FF` | DARAM B1 / reserved | same |
| data `0800`-`2BFF` | SARAM if `PMST.OVLY`, else external | same |
| data `2C00`-`FFFF` | external | external, less the shared window |

The ROM row is a harness fixture rather than a claim about the board: the
firmware runs MP/MC=1, where that window does not exist, and the probe kernels
in `dsp_probe.py` and `fsk.py` use microcomputer mode to host 4K synthetic
drivers of their own. It is recorded in the header and left alone.

**The last row is why the shared external window is ordinary.** The guide puts
*nothing* on-chip above `0x2BFF` in data space, and nothing above it in program
space either with `CNF` clear, which is how this firmware runs. So a reference
to `0x8000`-`0xFEFF` is an off-chip bus cycle in **both** spaces - the same
address driven on the same pins. One RAM answering both is then not a trick but
a board that does not separate the two strobes, which is exactly what 302's
`bldp` from data `0x80f5` needs and what
[dsp-map-302.md](dsp-map-302.md) measures.

## The NEC part is the ASIC

`1-016-905` is a US Robotics part number, not an NEC catalogue number: NEC
fabricated it, USR designed it. A gate array in a package that size, on this
board, is the part every note in this repository has been calling "the
interposed ASIC" and modelling as a black box.

That is a placement argument, not a pin trace. **It now has a pin trace**:
[asic-pinout.md](asic-pinout.md) records the DSP's address bus, the CPU's
`AD0`-`AD7`, the DSP's `IS` strobe and two CPU interrupt lines all landing on
this package, which is the interposed part described rather than inferred. What
also supports it is that the
supervisor's I/O space needs a device of exactly this description and there is
no other candidate on the bus. From `artifacts/io-port-map/board-21210/`, the
80186 drives:

| ports | role |
|---|---|
| `0x0c`-`0x1a` | board latches: hook relay, NVRAM strobe, carrier-detect pair, ring detect |
| `0x1c`, `0x1e` | mailbox status and command |
| `0x40`-`0x4e` | the DSP download window |
| `0x50`-`0x56` | second window bank |
| `0x58`-`0x5e` | mailbox tag and data registers |
| `0x60`, `0x62` | the DSP-to-host stream window |

None of that is the CPU's own peripheral block, which is relocated to memory
`0xff00`-`0xffff`. None of it is flash or SRAM. All of it is one device
bridging the 80186 bus to the DSP, the codec, the DAA and the front panel -
and the ASIC is the only device left to be it.

So everything the notes attribute to "the ASIC" lives in this package: the
mailbox, the DSP download path, the codec bring-up sequence that neither
processor performs, the line detector the harness answers by hand, and the tone
generator that is why `--exchange` still hears silence when the firmware dials.
Its behaviour is unpublished, and this identification does not change that. It
does say the missing piece is one part, and which one.

## The oscillator settles the clock independently

`40.320M`. The 80C186 divides its oscillator input by two, so CLKOUT is
**20.16 MHz** - which is what `ATI7` reports, and the number
[the timebase note](hardware-timebase-and-audio-path.md) needed.

> That is the **CPU's** clock. The DSP does not take this can directly: its
> `X2/CLKIN` (pin 96) comes from **ASIC pin 119**, so whatever rate the DSP runs
> at is what the ASIC produces. See [asic-pinout.md](asic-pinout.md) - the
> frequency has not been measured.

That closes an ambiguity in the timer argument. `T0CMPA` is 25,200 and the
80186 counts internally clocked timers at CLKOUT/4, but 25,200 lands on a round
figure either way: 5.000 ms at CLKOUT = 20.16 MHz, or 10.000 ms if 20.16 MHz
had been the crystal and CLKOUT half of it. The board's `&T1` slope of 1.000031
seconds per `S18` unit already chose the first, since seconds convert to ticks
by multiplying by 200. The can on the board now says the same thing from the
hardware side: 40.320 divided by two is 20.16, so the timer clock is 5.04 MHz
and the tick is 5.000 ms.

## The codec is a TLC320AC0x, and the firmware proves it

> **Withdrawn (2026-09-12): the photograph stands, the firmware proof does
> not.** The part next to the DSP on the 20 MHz board really is a TI
> `320AC01CFN`. But the code offered below as confirmation is in `main211.xmf`
> alone, and that board carries an Si3021/Si3014 pair and no TI codec. The
> heading's claim is therefore unsupported, and probably inverted. See
> [so the claim is withdrawn](#so-the-the-firmware-proves-it-is-a-tlc320ac0x-claim-is-withdrawn)
> at the end of this document. The disassembly below is still an accurate
> reading of what that code does; only the part it is attributed to is wrong.

The part next to the DSP is a TI PLCC marked `320AC01CFN`. The DSP's own code
confirms the family, independently of the photograph.

The TLC320AC0x pairs with a TMS320 serial port and uses **bit 0 of the
transmitted DAC word to request a secondary frame**, in which a control
register is written. That is exactly what the C52 does:

```
00c2  lacl #01 ; samm @21      ; first word after reset is 0x0001:
                               ; D0 set, asking for a secondary frame
01b8  apl  *, #fffe            ; ordinary sample: clear D0
01ba  lamm @6b ; or *+
01bc  samm @21                 ; ...then OR in the request flag
0200  and  #0000fffe ; samm @21  ; sample with D0 cleared
01ea  lamm @6c ; samm @21      ; the secondary frame: the control word
021d  lacl #00 ; samm @6b      ; request satisfied, clear the flag
```

and `0x0188` is the blocking sender that goes with it - stage the word in
`@6c`, set `@6b`, `idle` until the serial ISR has sent it, return:

```
0188  samm @6c
0189  lamm @6b
018a  cc   8190, neq
018c  smmr @6b, #012f
018e  lacl #01 ; samm @6b
0190  idle
0191  lamm @6b ; bcnd 8190, neq
```

`0x0195` reads control words out of a table at program `0x019c` and feeds them
through it: `0911 0967 0956 0934 0923 0969 0989 bc07 1019 ba01 9019 f788 be4c
7718 8b8f 8711`. That is the codec's initialisation. The individual register
fields are not decoded here - there is no TLC320AC01 datasheet in `docs/`, and
a guessed bit layout did not fit the table.

### but that code is dormant, which is the interesting part

It runs at reset and then stops. In a 60M-instruction run `dxr_writes` is
**3**, all at program `0x00c6`, and `tdxr_writes` is **0** - the DSP never
transmits on either serial port after initialising the codec. What it does
instead is poll, in one resident-bank loop: `DRR` 338,279 times, `TRCV`
676,558 times, and ASIC external I/O `0x50`/`0x52`/`0x54` 338,279 / 411,025 /
676,556 times.

So the AC0x is initialised and then not driven. Two readings fit:

1. The ASIC fronts the codec. The C52 configures the part once, and thereafter
   the ASIC moves samples, which is the topology
   `courier_firmware_analysis.md` already argues for from AN16 section 1.3 and
   from the C52's view being four ASIC ports.
2. One firmware serves two board variants, and this one does not use the
   serial-codec path.

Nothing here chooses between them.

### The generations differ in the firmware, but not the way expected

The models, as the user gives them: a 20 MHz Courier of roughly 1994-97, a
25 MHz V.Everything V.90 of 1998-2000, and a 25 MHz "business" Courier from
2000 with a V.92 update.

The AC0x code is a searchable signature, so which images carry it is a fact
rather than an inference. Locating each image's DSP payload by an anchor they
all share - `splk @2a,#0010 ; splk @28,#000a ; splk @29,#0001`, the wait-state
sequence - and then searching for the codec code:

| image | clock / flash | payload at | AC0x code |
|---|---|---|---|
| `main211.xmf` (2003) | 25.8048 MHz, 736 KiB | `0x002fe` | **yes** |
| board, ID_SDL 4.03 | 20.16 MHz, 512 KiB | `0x2914a` | no |
| board, stock 7.3.14 | 20.16 MHz, 512 KiB | `0x2908a` | no |
| `IDSDL302.ROM` | 20.16 MHz, 512 KiB | `0x2908a` | no |

The anchor lands at `0x29080` in the two stock 20.16 MHz images, which is where
`courier_firmware_analysis.md` independently says the DSP payload starts - so
the method is checked, and the negatives are real rather than a search that
missed.

Instead of the AC0x path, both 20.16 MHz builds configure **`TSPC`** (`0x32`,
the TDM serial port control register) at program `0x008a`.

> **Partly corrected.** This build drives the AC01 *and* sets up the TDM port, so
> "instead of" is too strong for the setup. But an earlier version of this note
> also claimed an overlay reads `TRCV`, and that was wrong - those sites are a
> data table read as code. Nothing in any image reads `TRCV`.
>
> **Corrected again (2026-09-07): "and then unused" is wrong.** The receive half
> is unused, but the DSP *transmits* on that port continuously - `sacl @31` at
> program `0x81c9`, inside the idle task, measured at 21,976 `TDXR` writes in one
> run. And `TSPC` decodes to the DSP being the **master** there. See
> [the second serial port](second-serial-port.md). See [vpcm-datapump.md](vpcm-datapump.md). `main211` does not,
anywhere in program `0000..2000`.

So there is a genuine architectural split between generations, and it is
visible in the firmware. **Its direction is the opposite of "older TI, newer
Si"**, at least across the two generations that can be compared: the
DSP-driven TI codec path is in the *newest* image, and the oldest builds set up
the TDM port instead.

That is consistent with the photograph rather than at odds with it. The
20.16 MHz board carries a TI AC01 whose own firmware never drives it from the
DSP - which is what an ASIC mastering the codec looks like, and is reading 1
above.

> **Corrected.** The last sentence is wrong for the ID_SDL 4.03 / DSP 3.1.2
> build. What the table above establishes is that these images do not contain
> *`main211`'s* initialisation routine, which is true. That build has its own:
> its serial ISR ORs a secondary-frame request into the word it writes to `DXR`,
> which is precisely the AC0x protocol described earlier in this section, and
> reset sends six control registers through it. So reading 1 loses its support
> for this board. The `dxr_writes` is 3 measurement behind it was taken on
> `main211`, where the DSP stops transmitting after reset; on this build `DXR` is
> written every sample. Note too that the program addresses used for the
> 20.16 MHz build in this section are `0x8000` below those in
> [codec-rate-312.md](codec-rate-312.md) - the `TSPC` setup at `0x008a` here is
> `808a` there - so the two are reading the same instructions.

`main211`'s place in the lineup is inferred, not read off a version string: its
payload is 736 KiB where both V.Everything boards report 512 KiB of flash, and
the file is dated 2003. That points at the business Courier.

> **Superseded (2026-09-12): the middle generation is now tested, and the
> container is flat after all.** `SV25.XMD` is not record-framed. Strip its
> 128-byte header and apply the same 128-byte XOR block transform the recovery
> harness already uses - `recovery.decode_payload`, documented in
> [sv25-recovery.md](sv25-recovery.md) - and the payload is flat. The shared
> anchor is at `0x296e0`, not absent. The reason searching raw failed is simply
> that the bytes were still encoded.
>
> That decode is confirmed against hardware: the decoded image matches a
> 512 KiB capture of a 25 MHz board (supervisor 7.3.14 / DSP 3.0.13, ATI7
> `25 Mhz`) in every byte but the four checksum bytes at `0x77ffc..0x77fff`.
>
> **The result is that the middle generation groups with the old one, not the
> new one.** The 16-word control table `0911 0967 ... 8b8f 8711` appears in
> `main211.xmf` alone, at `0x628`; it is absent from the 25 MHz build, from
> both 20.16 MHz builds, and from `IDSDL302.ROM`. See the part list below for
> what that table actually initialises - not a TI codec.
>
> The 2000+ V.92 image is still out of reach here:
> `firmware/legacy-usrobotics/USR03232004/` is a compressed InstallShield
> package and no extractor is installed.

### Which board has which part, recorded at last

This section previously listed two live possibilities and asked for "a datum
from the boards, not from the images". The owner supplied it on 2026-09-12,
from the units in hand:

| board | part on the DSP's serial port |
|---|---|
| the 20 MHz boards | **TLC320AC01** |
| the 25 MHz Courier 2806 | **TLC320AC03** |
| the 3453C - taken to be `main211.xmf` | **Si3021 + Si3014**, no TI codec |

That is three generations, one part each, and it retires the "one board, two
parts in two roles" option. It also settles the direction: TI first, Silicon
Labs last. The earlier guess of "older TI, newer Si" was right after all; the
firmware reading that appeared to invert it was the thing at fault, as below.

#### So the "the firmware proves it is a TLC320AC0x" claim is withdrawn

The proof offered above rests on two observations, and the part list breaks
both of them.

The control table at program `0x019c` is the stronger one, and it is in
`main211.xmf` and nowhere else - measured, not inferred. But `main211`'s board
is the one carrying **no TI codec at all**. So that table is the bring-up of
the Silicon Labs pair, not of a TLC320AC0x, and the section title has it
exactly backwards. This also rehabilitates `CodecBringUp`, which the closing
line of this document calls questionable for running an `SI3038.PDF` register
sequence: a Silicon Labs sequence is the *right* family for this build, and
only the specific part number is now in doubt.

The secondary-frame protocol - bit 0 of the transmitted DAC word requesting a
control frame - cannot discriminate either, because it shows up on both sides
of the part split: in `main211` (Si pair) and in the ID_SDL 4.03 build for a
20.16 MHz board (AC01). A protocol common to the build for a TI-codec board and
the build for a no-TI-codec board is evidence about the serial framing, not
about the silicon.

#### The AC01 to AC03 change is invisible to the DSP

Stock 7.3.14 runs on both a 20.16 MHz AC01 board and the 25 MHz AC03 board, and
its DSP payload is **byte-identical between them**: aligned on the shared
wait-state anchor, 126,851 consecutive identical bytes, covering the payload
and all three overlays and ending at the blank region past `0x48000`. The whole
difference between those two images is in the supervisor, not the DSP.

So the firmware does not distinguish AC01 from AC03. That is what reading 1 of
the previous section predicts - the ASIC fronts the codec and the C52 does not
have to know which variant is fitted - and it means an AC03 board cannot be
identified from its DSP code.

Either way `CodecBringUp` is questionable: it runs an `SI3038.PDF` register
sequence, and the part the DSP's own code initialises is not that one.

## The DSP's low program memory is RAM, and the download shows it

[The timebase note](hardware-timebase-and-audio-path.md) argued the C52's
internal mask ROM is not what executes, from the reset code's own branch
targets and from wait-state programming. A USR-marked TI DSP is exactly what a
mask-ROM part looks like, so that argument deserved a better test than it had.

There is one, and it was already in the runs. The bridge does not assume the
transfer: it accumulates the supervisor's actual download stream and compares
it against the image. Every run reports `bootstrap_match: true` at
`bootstrap_bytes: 60344` - 30,172 words, the whole origin-`0x0000` segment
covering program `0000..75d9`.

So the supervisor really does transfer 30k words whose content is
`0x0000`-origin code, spanning the entire 4K mask-ROM window. Program
`0000..0fff` is written by the CPU, so it is external RAM. Whether the die also
carries a mask ROM that is simply never mapped is still not something any of
this can say.

## The flash is an Intel part, and the harness models an AMD one

The 2806's flash is marked `PA28F400` - Intel's 4 Mbit boot-block part.
`courier_emu/flash_device.py` models an **AMD Am29F400AT**, device code
`0x2223`, with that part's eleven-sector top-boot map hard-coded as fixed
geometry rather than a parameter.

Those disagree, but not yet in a way that is a bug, and the distinction is the
usual one. The AMD choice was never read off a board: it was **inferred from
the update image**, `Ie030002.nac`, which probes for a manufacturer word and
takes the AMD path when Intel does not answer. That image is the I-modem's, not
the 2806's, and nothing establishes the two units carry the same flash. So
there are two parts here, and possibly two correct answers.

What makes it worth writing down is that the file's sector map is load-bearing.
Its comment reasons from the Am29F400AT's boot-block layout that the updater's
one erase lands in `SA8` and leaves `SA9` and `SA10` untouched - "which is what
a settings store in flash looks like". An Intel 28F400 has its own block map,
and `-T` and `-B` parts put the boot blocks at opposite ends. If the board the
updater actually runs on is the Intel part, that inference is being drawn from
the wrong geometry.

The cheap check is the one the update image itself performs: read the
autoselect words out of the 2806. Manufacturer `0x0089` is Intel and `0x0001`
is AMD, and the device word names the part and its boot orientation. That is a
monitor read, and it would either confirm the marking or find that the marking
and the silicon disagree.
