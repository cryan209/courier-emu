# The board we have mapped is not the board the emulator runs

Every pin reading in [asic-pinout.md](asic-pinout.md) is from the **25 MHz
Courier 2806**, the AC03 board. Every behavioural target in this repository is a
**20.16 MHz** image - `IDSDL302.ROM`, the 4.03d capture, the XMFs the harness
loads. The hardware model and the firmware target have drifted apart, and the
consequence is that the pinout work cannot currently be checked against a
running machine: it describes a board the emulator does not execute.

This note records what that would take, because the answer appears to be *not
much*.

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
to it, and the emulator has hit something it will not decode there. That is
consistent with either an 80186 instruction the harness's Unicorn setup does not
implement, or - more likely - a RAM image that is not what the firmware thinks
it wrote, so the CPU is running over data.

**It never reaches the DTE.** No serial text and the input untouched, so
nothing about the `AT` layer has been exercised yet.

An earlier note in [asic-pinout.md](asic-pinout.md) said this image "runs but
emits no serial text, so the supported path is an XMF". That was
under-diagnosed - it has a specific fault at a specific address, and chasing it
is a normal debugging job rather than a porting project.

## What is likely to differ, and what has simply gone stale

**The oscillator is the one to check first, and it is a live example of the
staleness problem.** [board-parts.md](board-parts.md) identifies the master
oscillator as an `ECLIPTEK EC11 40.320M`, and 40.320/2 = 20.16 MHz is the
`CLKOUT` that `ATI7` reports on that unit. But that part list was "identified
from a photograph of the user's **20.16 MHz** Courier", and the 2806's own can
**has not been read for its marking**. A 25 MHz `CLKOUT` wants a 50 MHz input,
which is a different part.

That matters beyond the CPU, because the ASIC divides the same oscillator down
to the codec's `MCLK`. [ac01-codec-protocol.md](ac01-codec-protocol.md) solves
`MCLK = 2.880 MHz` from the codec's divider registers and three sample rates -
which is firmware evidence and holds on whichever board runs that firmware - and
then observes that `40.320 / 2.880 = 14` exactly. **The 2.880 MHz stands; the
divide of 14 is about the 20.16 MHz board** until the 2806's can is read. If
this board's oscillator is 50 MHz-something, the ASIC's divider is a different
number here, and the codec's sample rate is only preserved if the ASIC makes it
so.

So: **read the marking on the 2806's oscillator.** It is the cheapest reading
left in the file and three separate pieces of arithmetic hang off it.

## Why this is worth doing

Not for its own sake. The pinout work has produced a set of claims that are
checkable only against a running machine on the right board - what the ASIC
does with the address bit it consumes, whether the flash is paged, which port
bit carries the speaker setting to the DSP, whether `&T1` reaches the codec.
Every one of those is a question about the 25 MHz board, and every one of them
is currently being asked of a 20.16 MHz firmware.

The first step is not a port. It is to find out why the CPU is executing
something it should not at linear `0xff42`.
