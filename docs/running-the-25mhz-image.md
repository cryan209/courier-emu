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

**Read the marking on the 2806's CPU crystal.** It decides between an exact
5 ms tick and a rounded clock, and the harness's timing constants follow from
it. This is a much narrower question than the one asked here before the two
domains were separated - it touches the CPU's timers and nothing in the audio
path.

## Why this is worth doing

Not for its own sake. The pinout work has produced a set of claims that are
checkable only against a running machine on the right board - what the ASIC
does with the address bit it consumes, whether the flash is paged, which port
bit carries the speaker setting to the DSP, whether `&T1` reaches the codec.
Every one of those is a question about the 25 MHz board, and every one of them
is currently being asked of a 20.16 MHz firmware.

The first step is not a port. It is to find out why the CPU is executing
something it should not at linear `0xff42`.
