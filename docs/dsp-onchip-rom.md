# The DSP's on-chip ROM, read off the board

`artifacts/dsp-onchip-rom-01/c5x-onchip-rom.bin` is **2048 words read from the
DSP of the live 20.16 MHz Courier** on 2026-09-07, SHA-256
`3e30fb31ac87fc9d0b8a85da245511ef3caa4e83249f56b5852d9d0829e93f67`. It is the
object every argument in [dsp-map-302.md](dsp-map-302.md) was reaching for, and
it settles them by measurement rather than inference.

## How it was taken

1. `probe_transport --rom-dump` builds a RAM monitor for the 80186 carrying a
   C5x kernel, using the reference's own launch and download routines
   relocated out of flash.
2. `tools/emit_ram_writes.py` turns the image into `ATGLK2W` commands. 2096
   word writes place it at `0x3000`-`0x405f`; a read-back compares byte for
   byte against the image, zero mismatches.
3. Interrupt vector 8 is pointed at `0000:3000`, then **`T0CON` is written
   `0xa021`**. Timer 0 was already running with `T0CMPA` = 25200, the 5 ms
   tick, but with its `INT` bit clear - so the tick was polled, not vectored.
   Setting that one bit is what starts the monitor.
4. The monitor resets the DSP, downloads the kernel, and the kernel reads
   program memory with `RPT`/`TBLR` and mails each word back with the tag as a
   sequence number. The monitor prints the frame over the DTE serial port.

## Two things that had to be got right, and were not obvious

**The read does not need to run from SARAM.** The kernel originally staged its
`TBLR` loop into on-chip SARAM with `bldp`, because TI's program-memory
protection option blocks instructions fetched from off-chip memory from reading
on-chip program memory, and does not name SARAM. That variant returned nothing.
The 56-word sample probe then read `0x0000`-`0x001f` from a kernel at `0x8000`
and got the vector table back, which proves **protection is not programmed on
this part**, so the staging was unnecessary and only added a way to fail.

**The board's watchdog bounds the run.** A halted monitor is reset after
roughly a second and a half, and printing 2048 words as `NNNN:VVVV` does not
fit: the first full attempt printed 491 words and was cut off mid-line, with
the collected buffer lost because the firmware clears RAM on reboot. The dump
prints four hex digits a word instead of eleven bytes, and is taken in two
halves of 1024. Collection was never the problem - it had already finished when
the reset landed.

## What it contains

Program `0x0000` is a vector table, and it is **not** the alias of the kernel
that read it - the kernel begins `be41 bc06`, this begins `7980 0670`:

```
0000  7980 0670  b     0670          ; reset
0002  0860       lamm  @60           ; every interrupt dispatches indirectly
0003  be20       bacc                ; through a DARAM B2 cell
0004  0861 be20  lamm @61 ; bacc
...
```

So downloaded code installs its own handlers by writing data cells `0x60`-`0x6e`
- which is exactly what the 302 prologue's `lar ar1, #60 / rpt #1f` clear at
`0x801e` is preparing.

The reset target is the **boot loader**:

```
0670  setc intm ; ldp #000
067a  apl  @07, #ffd8        ; PMST: clear OVLY and the low bits
067c  opl  @07, #0010        ; PMST: set RAM
0680  splk @28, #ffff        ; PDWSR: maximum wait states
0682  splk @05, #0080        ; GREG
0684  lar  ar1, #ffff
0686  lacl *-                ; read data 0xffff - the boot source word
068c  lacl @60 / and #0003   ; dispatch on its low two bits
068f  bcnd 06c6, eq
0694  bcnd 069b, eq
069b  lar  ar1, @65          ; ...and for that mode
069c  lacc *+ / sacl @66 / sacl @1f   ; destination address -> BMAR
```

It reads its boot table from **data memory at `0xffff`**, which is the top of
the ASIC window, and takes a destination address from it. That is how the
supervisor's parallel download reaches the part, and it is the mechanism
[dsp-map-302.md](dsp-map-302.md) argued for from the download *order* alone -
destination first, reset pulse, then the block, with no "go" afterwards because
the loader itself transfers control.

## What this settles

* **MP/MC = 0. The part runs in microcomputer mode.** Program `0x0000`-`0x07ff`
  is on-chip ROM, not the external RAM that A15 being unwired would alias
  there. This was inferred twice and is now read.
* **The boot loader is real and is what starts the downloaded program**, so
  `dsp_download`'s `entry_word == 0x8000` is a boot-table destination rather
  than an assumption the scan enforces.
* **The vector base makes sense.** With `IPTR = 1` the firmware's vectors sit at
  `0x0080`, inside this ROM, which is why nothing in either build ever writes a
  vector table and why the emulator's timer runs away at `0x0088` - it has no
  ROM under it.

## What it does not settle

The frame carries no controls or completion marker, so what vouches for the
content is the tag sequence during collection, the declared word count and the
checksum - plus two independent corroborations: a truncated earlier run
returned words `0x0000`-`0x01ea` and **agrees with this one on all 491**, and
the 56-word sample probe returned `0x0000`-`0x001f` separately.

`MP/MC` itself was not read off the pin. What shows on-chip ROM is mapped is
that program `0x0000` holds this table rather than the kernel's own words.

## Running it in the emulator

Loading the recovered image with `load_rom`, setting `MP/MC = 0` and starting
the core at `0x0000` boots it exactly as the disassembly reads:

```
0000 -> 0670 -> PMST and wait-state setup -> read data 0xffff -> serial boot
```

**The boot mode is the word at data `0xffff`.** The loader takes its low two
bits first (`and #0003`, and only `0` reaches the serial paths), then `bit 12`
and `bit 13` of it - bits 3 and 2 - to choose between three variants. With the
cell reading `0` the loader picks the **8-bit** serial mode at `0x06f7`, which
assembles words from byte pairs; setting **bit 2** picks the 16-bit mode at
`0x06e2`. That single bit is what the ASIC has to present.

The boot table it then reads over the serial port is

| word | meaning |
|---|---|
| 1 | destination address, kept in `@66` and loaded into `AR1` |
| 2 | length; added to the destination and stored in `ARCR` |
| 3.. | the block, written with `TBLW` and `MAR *+` |

with one detail that matters when feeding it: **the terminating `CMPR EQ` runs
at the top of the loop, before the write**, so after the last block word one
further word has to clock through for the comparison to fire. Without it the
loader sits in its wait at `0x06dc` having written the whole block correctly -
which is exactly what the first attempt here did, and it looks like a failure
until the iteration count is examined.

With destination `0x8000`, the 27710-word 302 resident and one trailing word,
the loader completes and branches to `0x8000`. The firmware then runs its
prologue **once** and parks in the `idle` at `0x814d` - the same place the
harness's hand-forced `set_pc(entry_word)` reaches, now arrived at through the
part's own boot path.

Two consequences worth stating:

* **The ASIC feeds the DSP serially.** The supervisor writes a parallel window
  at ports `0x40`-`0x5e`; the loader reads `DRR` and polls `SPC`. So the ASIC
  is converting those parallel writes into serial words on the DSP's port,
  which is a role for it this repository had not identified.
* **The vectors now have memory under them.** Interrupts dispatch through the
  ROM's `lamm @6x / bacc` table rather than into unloaded space, so the timer
  runaway at `0x0088` that
  [dsp-map-302.md](dsp-map-302.md) records is a consequence of having no ROM,
  not a fault in the firmware.

**Not yet wired into the bridge.** This was run standalone; `bridge.py` still
forces the PC and runs `MP/MC = 1`. Note also that `RRDY` in this core is fed
from the codec receive queue, so the experiment used `queue_codec_rx` - that is
the harness's plumbing, not a claim about which pin the ASIC drives.
