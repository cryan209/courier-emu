# The board we have mapped is not the board the emulator runs

Every pin reading in [asic-pinout.md](asic-pinout.md) is from the **25 MHz
Courier 2806**, the AC03 board. This note began by asserting that every
behavioural target here is a 20.16 MHz image, and **that was wrong** - checking
the timer constant in each one says the opposite:

| image | `T0CMPA` | clock | runs? |
|---|---|---|---|
| `IDSDL302.ROM` | `6270` | 20.16 MHz | ROM-build path |
| 4.03d flash capture | `6270` | 20.16 MHz | ROM-build path |
| `main211.xmf` | `7e00` | **25.8048 MHz** | **boots**; `ATI7` says `25 Mhz` |
| `3453Bv2.1.1.xmf` | `7e00` | **25.8048 MHz** | **boots**; `ATI7` says `25 Mhz` |
| `main2205.XMF` | `7e00` | 25.8048 MHz | reaches the main loop, no output |
| `2_3_33.XMF` | `7e00` | 25.8048 MHz | no output |
| `MAIN_2.3.31.XMF` | `7e00` | 25.8048 MHz | faults (`software-interrupt`) |
| `SV25.XMD` | `7e00` | 25.8048 MHz | **not executable** - see below |
| 2806 flash capture | `7e00` | 25.8048 MHz | loads as a ROM build, faults |

**The ROM builds are the 20.16 MHz ones; every XMF supervisor is a 25 MHz
build.** Two of them boot to a prompt and report `Clock Freq 25 Mhz` from the
firmware's own `ATI7`. `courier_emu/daa.py` already says as much in a comment -
"main211 is the 25.8048 MHz build (its Timer 0 max count is `0x7e00`, which only
lands on 5 ms at that clock)" - so the repository knew, in one place, and the
rest of it did not.

So the gap is not the clock and not a mode. **It is that the 2806's *own*
firmware is the one image that cannot be executed**, while four of its siblings
can.

## The three generations, and which board each image is

`main211` is the **newest generation** Courier, not a variant of this one. Its
own `ATI7`, printed by the harness:

```
Options      HST,V32bis,V92        Supervisor rev  2.1.1
Clock Freq   25 Mhz                DSP rev         2.1.1
Flash ROM    1024k                 dates           01/10/03
Ram          256k
```

**Twice the flash and four times the RAM**, V.92, dated 2003. `3453Bv2.1.1.xmf`
is the same generation. So the two images that boot here are a *different board*
that happens to share this one's clock - which lines the repository's images up
as three generations rather than two:

| generation | images | clock | flash |
|---|---|---|---|
| old | `IDSDL302.ROM`, the 4.03d capture | 20.16 MHz | 512 KiB |
| **middle - this board** | `SV25.XMD`, the 2806 capture | 25.8048 MHz | 512 KiB |
| new | `main211.xmf`, `3453Bv2.1.1.xmf` | 25.8048 MHz | 1024k, 256k RAM |

[board-parts.md](board-parts.md) reaches the same split from the other
direction - "the middle generation groups with the old one, not the new one" -
and that is the useful part. **The 2806 is an old-generation board with a new
clock**, so the ROM-build machinery that runs `IDSDL302` is the right machinery
for it, and the 25 MHz builds that boot are no evidence at all that this board's
image will.

## The 2806's own image exists here twice, and neither copy runs

`SV25.XMD` **is** the 2806's firmware. Stripping its 128-byte header and running
`recovery.decode_payload` over the body reproduces the board's flash capture
byte for byte except at `0x77ffc..0x77fff` - the four checksum bytes, exactly as
[sv25-recovery.md](sv25-recovery.md) documents. Verified here, not taken on
trust.

Neither form will run:

* **`SV25.XMD`** loads as an `XmdImage`, and `machine.run` then fails with
  `UC_ERR_WRITE_UNMAPPED` writing `image.data` at `image.load_base`. The XMD
  path is a decoder, not an execution target - nothing maps it.
* **The raw capture** loads as a `CourierRom`, and an earlier revision of this
  section said that was the mistake - that it is really a supervisor image being
  run through the wrong model. **That is withdrawn.** The capture is a genuine
  ROM-shaped flash image: it ends in the same reset stub as the 4.03d capture,
  `fa ba a4 ff b8 00 80 ef` then a far jump into `fc00`, and it is **45.7%
  byte-identical** to that capture - which is as close as the 4.03d capture is
  to `IDSDL302.ROM` (45.2%). All three are the same kind of image. `CourierRom`
  is the right identification.

So the container is right and the model is right, and the fault below is a
**genuine gap** rather than a misrouted load. That is a worse answer than the
one it replaces, and a more honest one.

**The work splits in two.** Giving `SV25.XMD` an execution path is worth doing
on its own - it is the same bytes with a checksum, and a decoder that cannot
run what it decodes is a gap. But it will land in the same place as the raw
capture, because the bytes are the same bytes.

## It is not a different firmware family

The repository already establishes the two things that would otherwise make
this hard:

* **Stock 7.3.14 runs on both boards** - the 20.16 MHz AC01 board and the
  25 MHz AC03 board - and its **DSP payload is byte-identical between them**,
  126,851 consecutive identical bytes covering the payload and all three
  overlays. The whole difference is in the supervisor.
* **The 25 MHz image is in hand and verified.** `sv25-recovery.md`'s decode
  matches a 512 KiB capture of a 25 MHz board in **every byte but the four
  checksum bytes** at `0x77ffc..0x77fff`.

So this is not a port to an unknown firmware. It is the same supervisor
generation, on a board whose differences are configuration rather than code.

## Where it actually stops, measured

Running the 2806's own flash capture under the mailbox-tap harness:

```
.venv/bin/python artifacts/mailbox-tap-atdt-01/tap_run.py \
    artifacts/courier-2806-25mhz-flash-20260912/courier-board.rom 60000000 \
    <outdir> ATI7
```

| | |
|---|---|
| instructions executed | **5,684,093** |
| status | `emulation-error` |
| error | `Invalid instruction (UC_ERR_INSN_INVALID)` |
| `CS:IP` at the fault | `0x2e3:0xd112` - linear **`0xff42`** |
| DSP activity before it | 1 mailbox message, 435 line-transmit samples |
| serial text | none; the input is untouched |

Three things that says, and the first is the encouraging one.

**It runs.** Five and a half million instructions of real execution, the panel
loop pulsing, timer interrupts taken, and the DSP started - a mailbox message
and line-transmit samples mean the download and the codec path both got going.
The raw `.rom` loads and executes; the container is not the obstacle.

**It dies in RAM, not in flash.** Linear `0xff42` is inside the first 64 KiB,
which `LCS` selects as SRAM. So the supervisor has copied code down and jumped
to it, and the emulator has hit something it will not decode there - the CPU
running over data rather than over code.

**The first suspect is the flash, and this is where the pinout work earns its
keep.** [asic-pinout.md](asic-pinout.md) establishes that on this board the
**ASIC holds the flash's `CE#`** and takes four of the CPU's upper address
lines while driving three - one address bit consumed by a decision the ASIC
makes. That is paging. The harness hands the firmware a flat 512 KiB image with
no register behind it, so a supervisor that pages a window to copy code down
would be copying from wherever the flat model happens to put it - and would then
jump into exactly the kind of wrongness seen here.

That is a hypothesis, not a diagnosis. What makes it the one to test first is
that it is specific to **this** board: the old-generation 20.16 MHz images run
fine through the same model, and nothing says their boards page anything.

**It never reaches the DTE.** No serial text and the input untouched, so
nothing about the `AT` layer has been exercised yet.

An earlier note in [asic-pinout.md](asic-pinout.md) said this image "runs but
emits no serial text, so the supported path is an XMF". That was
under-diagnosed - it has a specific fault at a specific address, and chasing it
is a normal debugging job rather than a porting project.

## There are two clock domains, and they split where the images do

**The ASIC runs from the same crystal on both boards.** The 25 MHz crystal is
the **CPU's alone** - reported by the owner, and it reorganises the whole
question. The board has two clock domains:

| domain | source | what hangs off it |
|---|---|---|
| audio | the shared `40.320 MHz` can, into the **ASIC** | the DSP's `CLKIN` (ASIC pin 119) and the codec's `MCLK` (ASIC pin 112) |
| supervisor | the 2806's own crystal | the CPU's `CLKOUT`, and everything timed from it |

That retires a caveat added here a moment ago. The ASIC's divider to the
codec - `40.320 / 2.880 = 14` - is **not** provisional and is not about the
other board: the ASIC's input is the same can either way, so the codec's `MCLK`
is 2.880 MHz on both. The `ECLIPTEK EC11 40.320M` identified from the 20.16 MHz
unit's photograph is the right part for this board too.

**And it explains the thing that was otherwise a coincidence.** The DSP payload
is byte-identical across the two boards while the supervisors differ. That is
exactly what two clock domains predict: the DSP and the codec see an unchanged
timebase, so DSP code has nothing to adjust, while every constant derived from
`CLKOUT` lives on the supervisor's side.

### The supervisor's timer constant is the difference, measured

`0xff32` is `T0CMPA` in the 186EB's peripheral control block. Both images write
it at two early sites, at the same offsets, surrounded by identical code:

| site | 20.16 MHz `403` capture | 25 MHz `2806` capture |
|---|---|---|
| `0x2be` | `6270` = **25,200** | `7e00` = **32,256** |
| `0x8d0` / `0x8c9` | `6270` | `7e00` |

Every other `0xff32` immediate in the neighbourhood - `1e8a`, `fb80`, `06f6`,
`39b8` - is the same in both. So this is an isolated, deliberate difference, and
it is the shape "the whole difference is in the supervisor" predicts.

**32,256 / 25,200 = 1.28 exactly.** [board-parts.md](board-parts.md) establishes
that 25,200 is a 5.000 ms tick with the timer counting at `CLKOUT/4` and
`CLKOUT` at 20.16 MHz. If the 2806 keeps the same 5 ms tick - and a supervisor
that shares this much code almost certainly does - then

```
CLKOUT = 20.16 x 1.28 = 25.8048 MHz
```

and the CPU crystal is twice that, **51.6096 MHz**. The alternative is that the
crystal is a round 50 MHz, `CLKOUT` is 25.000 MHz, and the tick is 5.161 ms -
which no one would choose on purpose when the compare value is theirs to pick.
`ATI7` reporting "25 Mhz" is consistent with either; it is a rounded figure.
**The baud registers settle it independently, below.**

### The marking does not say, but the baud divisors do

The 2806's CPU crystal is marked **`R0936391`**. That is a house part number,
not a frequency - a custom-ordered part, which is itself consistent with an
unusual value - so the marking does not settle it.

**The images do.** `0xff60` is Serial 0's baud register and `0xff70` is Serial
1's. Both captures write both, at the same two offsets, and the values differ:

| register | offset | 20.16 MHz `403` | 25 MHz `2806` | divisor (low 15 bits) |
|---|---|---|---|---|
| Serial 0 baud | `0x34a` | `8082` | `80a7` | 130 -> **167** |
| Serial 1 baud | `0x33a` | `8102` | `814f` | 258 -> **335** |

The 186EB's generator gives `baud = CLKOUT / (8 x (N + 1))`. Put the two
candidate clocks through the 25 MHz build's divisors:

| `CLKOUT` | Serial 0 (N=167) | Serial 1 (N=335) |
|---|---|---|
| **25.8048 MHz** | **19200.0** | **9600.0** |
| 25.000 MHz | 18601 (-3.1%) | 9301 (-3.1%) |

**25.8048 MHz gives two standard rates exactly.** A round 25 MHz misses both by
3.1%, which is outside what an 8N1 UART tolerates over ten bit times - nobody
ships that. So the clock is 25.8048 MHz and the crystal is twice it,
**51.6096 MHz**, which agrees with the timer constant's 1.28 ratio from an
entirely separate register.

And the crystal turns out to be chosen for exactly this:

```
51,609,600 / 19,200 = 2688 exactly
```

Which also explains something about the older board. At 20.16 MHz the same
formula gives its divisors **19236.6** and **9729.7** - 0.19% and 1.35% off
19200 and 9600, usable but not exact. The 25 MHz design picks a clock where the
UART divides perfectly, and takes an odd-looking crystal frequency to get it.
The two serial channels are exactly an octave apart, 168 and 336, which is the
same choice showing twice.

So the CPU domain is settled from the firmware alone: **`CLKOUT` = 25.8048 MHz,
crystal 51.6096 MHz, tick 5.000 ms** - the timer and the two baud generators all
agreeing, and no scope needed.

## Why this is worth doing

Not for its own sake. The pinout work has produced a set of claims that are
checkable only against a running machine on the right board - what the ASIC
does with the address bit it consumes, whether the flash is paged, which port
bit carries the speaker setting to the DSP, whether `&T1` reaches the codec.
Every one of those is a question about the 25 MHz board, and every one of them
is currently being asked of a 20.16 MHz firmware.

The first step is not a port and not a clock mode. It is to find out what the
supervisor copies into RAM before it jumps to `0xff42`, and whether the flash it
reads that from is the flash the ASIC would have given it.

**And the target-choice advice survives intact.** `main211` is the newest
generation and not a reference for this board; `IDSDL302` and the 4.03d capture
are the right behavioural references and remain so. The 2806 being an
old-generation board with a new clock is what makes that consistent rather than
contradictory - it is close kin to the images already trusted here, and the
distance to close is one board's worth of hardware, not one generation's worth
of firmware.
