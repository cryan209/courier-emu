# What gates the datapump dispatch on IDSDL302

[ata-sip-line.md](ata-sip-line.md) got the board firmware to dial a real number
over SIP: the DSP generates the DTMF, the modelled loop decodes `6245` off the
line, and the call comes up. Then the line goes silent and the answering modem
times out.

The datapump is not going quiet. It never starts. This is the chain that stops
it, read out of `IDSDL302.ROM` with the run's own counters, and it ends at one
event code.

**Everything here is 302.** `main211.xmf` is not fully modelled and its runs are
not evidence about the board; the gate the bridge currently uses came from a 211
run and is the first thing below that turns out to be wrong.

## What the run shows

```sh
./courier run IDSDL302.ROM --with-dsp --exchange --exchange-number 6245=answer \
    --tick-ms 5 --board-id 7 --nvram-fixture idsdl302 --at 'ATDT6245' \
    --instructions 150000000
```

| observation | value |
|---|---|
| digits decoded off the line | `dialed: "6245"` |
| ASIC registers written | `13,15,16,17,19,1a,1b,1c,1d,1f,83` - **no `82`** |
| `control_82` | `0` |
| `commit_edges` | `0` (all six `001f` messages carry data `0000`) |
| `call_overlay_available` / `call_overlay_active` | `true` / **`false`** |
| DSP downloads | `bootstraps: 1`, 55,424 bytes - the resident bank only |
| datapump dispatch (`10`/`11`) | **never sent** |

The bridge arms the call only on `asic_registers[0x82] == 0x00A0`
([bridge.py](../courier_emu/bridge.py) `_maybe_start_asic_call_engine`), with a
fallback on a `0x1f` zero-to-bit-15 commit edge. 302 sends neither, so
`_v8_armed` stays false, `_resume_armed_call` never runs, and
`_activate_call_overlay` is never called. The C52 keeps running its resident
bank, which holds the DTMF oscillator and no data modulation.

## 302 does arm its datapump - through the mailbox

After the last digit the supervisor drains a queued batch. The queue is a ring
at `0x29e..0x2ce`, head `[0x29a]`, tail `[0x29c]`; the drain at `0x8f521`
streams `(tag, data)` pairs out `0x58/0x5a` and `0x5c/0x5e`, and `0x8f688`
enqueues one message as three words.

```text
001a:32d6  0044:003f  0048:7fff  0051:21ff  0052:1ef8  001c:0008  001d:0014
002a:0006  0042:0fd1  0049:8bf5  0050:{00c1,0145,0213,0310,040d,0500}
0053:000f  0071:0003  0077:0000  0076:0000      then  0017:704d
```

All of it inside 57.83M-58.07M instructions, 11,264 apart - a table walk,
immediately after the last digit at 54.59M. So the datapump is configured. What
never follows is the dispatch: [datapump-slots.md](datapump-slots.md) has the
nine-slot table selected by mailbox commands `10` and `11`, and neither appears
in the run.

## The gate, in five links

**1. The dispatch site is `0x8bee8`.**

```text
8bee8  mov   ax, 5a
8beeb  call  8b863        ; -> CF
8beee  jb    8bef8        ; CF set: send 5a instead
8bef0  call  8b84f        ; -> ZF
8bef3  je    8bf01        ; ZF set: send nothing
8bef5  mov   ax, 10       ; the datapump dispatch
8bef8  mov   bx, [0x281]
8befc  lcall 8f43:0224    ; enqueue
```

`0x8bf05` is the same shape one branch over and sends tag `0x17` when the same
test comes back equal. The run emits `0017:704d`, so that is the branch it
took.

**2. `0x8b84f` is the discriminator.** It returns not-equal - dispatch `10` -
if any one of three flags is set:

```text
8b84f  test byte [0xa96], 2
8b856  test byte [0x5a5], 1
8b85d  test byte [0x685], 1
```

In the run all three are zero: `supervisor_call_cells` reports `0a96: 0`, and
nothing has set the others.

**3. `[0x685] |= 1` happens at exactly one place, `0x876c5`**, reached from
`0x876b1` when `[0x33e] & 4 == 0`. The run has `033e: 2`, so that branch would
be taken - if `0x876b1` were reached at all.

**4. `0x876b1` is entry 1 of a far-call thunk table at `0x875d8`** - nine
four-byte `call near`/`retf` stubs, `0x875d8 + 4n`.

**5. The only thing that reaches it is an indexed jump on an event code.**

```text
a6ad7  jmp word ptr cs:[bx + 0x1dbe]     ; bx = 2 * AL, CS = a4d2
```

The table at `0xa6ade` is nine entries, `AL = 0..8`, each a far call into the
thunk table:

| AL | thunk | handler |
|---|---|---|
| 0 | `875d8` | `875f8` |
| **1** | **`875dc`** | **`876b1` - sets `[0x685] |= 1`** |
| 2 | - | `stc`/`ret`, rejected |
| 3 | `875e0` | `876d5` |
| 4-8 | `875e4`-`875f4` | `876f2`, `876f9`, `87700`, `87715`, `87738` |

So the whole chain reduces to one thing: **the datapump dispatch is armed by
call-progress event `AL = 1`**, and nothing in the run delivers it.

## Measured: the router never runs, and AL is not an event code

`--trace-pc ADDR[=NAME]` records the 80186's registers each time an address
executes. Running the dial with a watch on every link:

```sh
./courier run IDSDL302.ROM --with-dsp --exchange --exchange-number 6245=answer \
    --tick-ms 5 --board-id 7 --nvram-fixture idsdl302 --at 'ATDT6245' \
    --instructions 150000000 --summary \
    --trace-pc a6ad7=router-jmp --trace-pc 8b84f=discriminator \
    --trace-pc 8bee8=dispatch-site --trace-pc 8bef5=send-10 \
    --trace-pc 8bf05=send-17-site --trace-pc 876c5=set-685-bit0
```

| watch | hits |
|---|---|
| `queue-drain` `8f521` | 45 |
| `discriminator` `8b84f` | 19 |
| `dispatch-site` `8bee8` | 1 |
| `send-17-site` `8bf05` | 1 |
| **`send-10` `8bef5`** | **0** |
| **`router-jmp` `a6ad7`** | **0** |
| `router-entry` `a6a7a`, `entry1` `876b1`, `set-685-bit0` `876c5` | 0 |

The one pass through the dispatch site is the whole story, and it runs exactly
as read:

```text
@59,801,686  8bee8  ax=02b2            ; enter, mov ax,5a
@59,801,696  8b84f  ax=005a flags=0296 ; ZF set -> je 8bf01, nothing sent
@59,801,899  8bf05  ax=0019            ; the other branch
@59,801,908  8b84f  ax=0019 flags=0296 ; ZF set -> falls through to mov ax,17
```

which is the `0017:704d` the run emits. `mov ax, 10` is never executed.

**And the router is never entered at all.** Its real entry is `0xa6a6c`, which
begins:

```text
a6a6c  lcall 8000:9cbc     ; AL <- parsed number
a6a71  jb    a6adc
a6a73  test  byte [0xea7], 1
a6a78  je    a6a84          ; [0xea7]=0 here, so AL==1 is *not* rejected
a6a7a  cmp   al, 1
```

`0x89cbc` is a decimal ASCII string parser - `lodsb`, `sub al, 0x30`,
`mov ah, 0xa`, `mul ah`, accumulate. **So `AL` is a number parsed out of a
command string, not a call-progress event code.** An earlier revision of this
document called it an event code; that was wrong, and the trace is what
corrected it. `0xa6a6c` is one of a table of command handlers whose offsets sit
at `0xa6615`-`0xa6631`.

That changes what the blocker is. `[0x685] |= 1` - the one of the three flags
with any reachable setter at all - is set on a **command** path, not by the
board reporting progress. Of the other two: `[0x5a5]` bit 0 has no setter
anywhere in the image (only `and [0x5a5], 0xfe` at `882db` and `8982e` clear
it), and there is no `or [0xa96], 2` either.

## Where it actually stops: the overlay is never requested

Tracing further up found the real end of the chain, and it is not the `0x10`
message at all.

The C52 gets a datapump by the supervisor *downloading* one.
[dsp-overlays.md](dsp-overlays.md) has the map - overlays 6, 7 and 8 in flash,
loaded into program space at `9d00`, `b000` and `dc00`. The loader is at
`0x8e5da`:

```text
8e5da  mov  al, [0xe3c]      ; the overlay id
8e5df  cmp  al, 6
8e5e3  call 8e5eb            ; id 6 loads first, then
8e5e6  mov  byte [0xe3c], 8  ; ...switches to 8
8e5eb  mov  al, [0xe3c]
8e5ef  and  ax, 0xf
8e5f2  mov  bl, 6 ; mul bl ; mov bx, e711 ; add bx, ax   ; index the table
8e5fb  mov  ax, cs:[bx+4]    ; the C52 load address
8e601  mov  al, 4
8e603  out  0x1e, al         ; start the transfer
8e61c  in   al, 0x1e         ; poll for bit 2
```

That is exactly the transport the bridge already models for the resident
bootstrap. It is called from the post-dial sequencer at `0x8b5d1`, and only
when `[0xe3c]` is non-zero:

```text
8b5ca  cmp  byte [0xe3c], 0
8b5cf  je   8b5d4
8b5d1  call 8e5da            ; download the overlay
```

Measured:

| watch | hits |
|---|---|
| `loader-gate` `8b5ca` | 1 |
| **`call-loader` `8b5d1`** | **0** |
| `overlay-loader-entry` `8e5da`, `out-1e-cmd4` `8e603`, `poll-1e` `8e61c` | 0 |

`[0xe3c]` is zero, so no overlay is ever requested. That is why the run reports
`bootstraps: 1`: the resident bank and nothing else.

## One gate explains all of it

`[0xe3c]` is set to 6 or 7 by the selection code at `0x8bbaa`-`0x8bc4d`, and
that code is guarded by the same discriminator as the `0x10` dispatch:

```text
8bbaa  call 8b863           ; CF gate
8bbad  jae  8bbc2
8bbba  mov  byte [0xe3c], 6
8bbc2  call 8b84f           ; the discriminator
8bbc5  jne  8bbca
8bbc7  jmp  8bc52           ; equal -> skip every [0xe3c] assignment
```

The run reaches `0x8bc52` - it emits the `001c:0008` that the code just past it
sends - having skipped all of them. So `0x8b84f` returning equal is the single
root cause of both symptoms: no overlay downloaded, and no `0x10` dispatched.

It returns equal because `[0xa96]&2`, `[0x5a5]&1` and `[0x685]&1` are all zero,
and the only reachable setter for any of them is in the thunk cluster at
`0x876b1`/`0x87752`, reached only from the jump table at `0xa6ade`, reached only
from `0xa6a6c` - a command handler whose command this run never issues.

## The profile hypothesis, tested and not supported

The previous revision guessed that the three flags were profile settings
restored from NVRAM, and that `--nvram-fixture idsdl302` being sparse was the
gap. The settings diff is real, and the hypothesis is still wrong.

**The fixture is a blank EEPROM.** `idsl302_fixture` seeds only words 94..102
and the `+S` block and leaves the rest erased, and the firmware renders exactly
that. `ATI5` under the emulator against `ATI5` on the 4.03d hardware:

| | board | fixture |
|---|---|---|
| switches | `B0 F1 M1 X7 &A3 &B1 &G2 &H1 &I0 &K1 &L0 &M4 &N0 &P1 &R2 &S0 &T5 &U0 &X2 &Y1 %N6` | `B7 F0 M7 X0 &A3 &B7 &G7 &H7 &I15 &K7 &L3 &M15 &N3213 &P3 &R7 &S7 &T4 &U3213 &X7 &Y7 %N15` |
| S registers | `S00=001 S07=060 S11=070 S27=048 S58=064` ... | **every one `255`** |
| baud | 115200 | 110 |

But making the firmware load a real profile through its own command path does
not move the gate:

| run | `call-loader` `8b5d1` |
|---|---|
| `--at 'ATDT6245'` | 0 |
| `--at 'AT&F' --at 'ATDT6245'` | 0 |
| `--parameter-sector` with a serial and the V.34/V.90 feature bits | 0 |

`AT&F` loads the ROM defaults into the working profile - the profile the call
actually uses - so if the flags came from settings, that run would have set
them. It does not. **The three flags are not profile-derived.**

## A separate gap: the parameter sector is absent

`ATI7` on the hardware ends with a line the emulator does not print at all:

| field | board 4.03d | emulator, 302 + fixture |
|---|---|---|
| Product type | Russia (ex. US/Canada) External | US/Canada External |
| Supervisor rev | 7.4.16 | 7.3.14 |
| DSP rev | 3.1.2 | 3.0.13 |
| **Serial Number** | `0009540034268322` | **line absent** |

The serial number lives in the parameter sector, not in NVRAM -
`courier_emu/parameters.py`, sector `0x11..0x1c` to CPU `0x0a17..0x0a22` - and
none of the dial runs pass `--parameter-sector` or `--parameter-flash`, so the
store is simply not there. Supplying one restores the line. It does not affect
the datapump gate, so it is a real modelling gap on its own account rather than
the blocker.

The `Options` line is identical on both, so the unit's V.34/V.90 entitlement is
not what is refusing the overlay.

## The cells, read off the hardware

The NVRAM driver sits at the same address on 302 and 403, and ID_SDL has a
read-only memory dump command - `ATGLK2=<segment>:<offset>`, the one
`flash_dump.py` already uses to capture the 512 KiB flash. That reads the gate
cells directly off the running board. `--peek ADDR[=NAME]` reports the same
cells from a run.

Sampled on the board at three points - as found, after `ATZ`, and while an
inbound call is being offered with `S0=0` so the modem stays in command mode:

| sample | `685` | `5cd` | `33e` | `5a5` | `a96` | `e3c` | `5fa` | `600` | `ea7` |
|---|---|---|---|---|---|---|---|---|---|
| as found | `ff` | `e0` | `11` | `08` | `00` | `00` | `00` | `00` | `00` |
| after `ATZ` | `ff` | `e0` | `11` | `08` | `00` | `00` | `00` | `00` | `00` |
| while ringing | `ff` | `e0` | `11` | `08` | `00` | `00` | `00` | `00` | `00` |

**Identical at all three.** These are not call-progress state: nothing about
offering the loop a call moves them, and a reset does not either. Whatever sets
them is done before the DTE is first reachable.

## Two corrections this forced

**The emulator's RAM is `0xff`-filled, not zeroed.** Running the 403 capture
reads `685=ff, 5cd=ff, 5a5=ff, 5fa=ff, 600=ff` where the 302 run reads `00`.
So the `00`s in a 302 run are the 302 image's own data initialisation, not a
missing write - and not, as the previous revision had it, "cells the emulator
never initialises". Watching all seven `mov byte [0x685], 0` sites plus both
`and [0x5a5], 0xfe` sites across a full 302 dial gives **zero hits on every
one**: nothing clears them at runtime. They start at zero.

**The addresses are 302-derived and the hardware is 403.** `0x685`, `0x5cd`
and `0x33e` were read out of a disassembly of `IDSDL302.ROM`, supervisor
7.3.14. The board runs 7.4.16, where the same variables need not live at the
same addresses. The hardware column above is therefore only comparable to a 302
run if the data layout is unchanged between the two builds, which is not
established. The previous revision's hardware-versus-emulator table did not
state this and overreached.

The 403 capture cannot settle it yet: run in the emulator it does not dial at
all - `dialed: ""`, `call-loader` zero hits - so its cells are simply
uninitialised rather than a comparison. Making the 403 image dial is the
prerequisite for any cell-level comparison against this board, and it is the
next thing worth doing, both because it is the firmware the hardware actually
runs and because without it there is no apples-to-apples reading.

## Why the 403 capture does not dial

It is not the supervisor. Run side by side, 302 and 403 do the same things up
to the point where sound should appear:

| | 302 (`IDSDL302.ROM`) | 403 (board capture) |
|---|---|---|
| bootstrap | match, 1 download | match, 1 download |
| hook / line | off hook, dial tone qualified | off hook, dial tone qualified |
| keypad messages sent | `0013:0006 0002 0004 0005` | **the same four** |
| `0016:0000` | 8 | 8 |
| host messages / DSP took | 68 / 385 | 70 / 377 |
| **datapump transmit** | DTMF bursts, peak ~22,700 | **66,251 samples, peak 0** |
| exchange decoded | `6245` | `""` |

The 403 supervisor dials. Its DSP puts **pure silence** on the line.

And the DSP is not broken, because the same image's tone code works when it is
driven directly. `courier_emu.audio312` on that very ROM renders one digit
through the firmware's own selector, oscillator, mixer and serial ISR:

```sh
.venv/bin/python -m courier_emu.audio312 \
    --rom artifacts/courier-board-21210-capture-403/courier-board.rom \
    --digits 6 --output /tmp/one
```

peak 21,516, row 770, column 1477 - a clean `6`. So the oscillator, the mixer
and the ISR all work under 3.1.2. What does not happen in the full-board run is
whatever should arm them when the mailbox carries tag `0x13`.

That is a known divergence between the two DSP builds rather than a surprise:
[driving-the-tones.md](driving-the-tones.md) records tag `0x13`'s handler at
`0xd82f` in 3.0.13, while in 3.1.2 `13` enters `0xee20`. 302 carries 3.0.13 and
the board carries 3.1.2, which is exactly the pair that differs here.

### `ee20` runs, and it arms the oscillator correctly

The C52's trace window used to be two hardcoded ranges. `set_pc_trace_range`
adds a third, settable one - `--dsp-trace-range FIRST:LAST` - and pointed at
`ee00:ef00` it catches the handler **four times in a dial, once per digit**:

```text
ee20  ldp   #007
ee21  lamm  @7a          ; the keypad index the supervisor sent
ee22  and   #0f          ; low nibble
ee24  sfl                ; x2, two words per entry
ee25  add   #ee34        ; the frequency table
ee27  tblr  @74          ; column increment -> 3f4
ee29  tblr  @72          ; row increment    -> 3f2
ee2a  splk  @1a, #8743   ; the DTMF-pair callback, into 39a
ee2e  splk  @73, #1000   ; amplitude -> 3f3
ee31  sacl  @40 / @41    ; clear both phases
ee33  ret
```

Every cell it touches is one [answer-tone.md](answer-tone.md) already named:
`3f2`/`3f3`/`3c0` for the first oscillator, `3f4`/`3f5`/`3c1` for the second,
and `39a` for the mixer's callback slot. `8743` is precisely the pair
generator. So the handler is not the fault: it runs, per digit, and arms the
tone the way the firmware intends.

### The generator runs. The silence is after it.

`--dsp-write-watch ADDR` records every write to one C52 data cell with the
program address that made it. The core's write trace existed but was
unfiltered, and its 4096-event buffer covers a few milliseconds of a run; the
read side also traces a fixed set of cells, which floods the buffer on its own.
Both now honour the filter.

Watching `39a`, the mixer's callback slot, across a 403 dial:

```text
ee2b  8743   @51,371,302      digit 1: the handler arms the pair generator
86dc  8128   @53,720,889      ...and 86dc restores 8128
ee2b  8743   @55,664,990      digit 2
86dc  8128   @58,016,770
ee2b  8743   @59,959,466      digit 3
86dc  8128   @62,310,745
ee2b  8743   @64,253,460      digit 4
86dc  8128   @66,604,900
```

Four arm/restore pairs, one per digit, about 2.3M instructions apart - roughly
the tone's own duration. That is a one-shot callback lifetime, not the clobber
the end-of-run value suggested; `8128` is simply what the slot holds when no
tone is playing, and reading it after the run was reading the idle state.

And the generator really runs in between. Watching `3c0`, the first
oscillator's phase, inside the last window:

```text
8753  48d5   @66,442,944
8753  7856   @66,445,517
8753  a7d7   @66,448,001
8753  d758   @66,450,565
```

`+0x2f81` per sample, which is exactly the row increment `tblr` loaded into
`3f2`. The oscillator is advancing at the right rate, from the right table
entry, driven by the firmware's own code.

### The signal reaches the mixer's accumulator and dies before DXR

The write trace keeps the last 64 events, and both `3c7` and DXR are written
every sample, so a full-length run only ever shows the idle tail. Ending the
run inside the first digit instead - `--instructions 47500000`, which lands at
DSP instruction 52.6M, inside the first `8743` window - catches the tone
itself.

**The mixer's accumulator carries the tone.** Writes to `3c7` in that window:

```text
875b  edd2      874e  ...      80d6  0000
875b  35e3                     (once per frame, the calad delay slot)
875b  3028
875b  e4e7
875b  c0c5
```

`874e` and `875b` are the two `sach @47, 3` in the pair generator, and the
values are a waveform. Reading the callback confirms the shape: `8743` loads
the column increment, calls the sine table at `8b6a`, advances the phase at
`41`, multiplies by the amplitude at `75`, accumulates into `47`, then falls
through to `874f` which does the same for the row. `8128` - what the slot holds
when idle - is a bare `ret`.

**And DXR is zero at the same instant.** Watching MMR `0x21` over the same
window:

```text
818f  0000  @dsp 52,674,534
818f  0000  @dsp 52,677,095
818f  0000  @dsp 52,679,656
818f  0000  @dsp 52,682,222
```

Same run, overlapping instruction counts: `3c7` live, DXR zero.

So every stage from the mailbox to the mixer's accumulator is correct - the
handler arms, the oscillator advances at the loaded increment, the callback
accumulates a waveform - and the signal is lost in the stage after it. That
leaves about ten instructions:

```text
80da  lt    @47        ; the accumulator the callback just filled
80db  mpy   @12        ; times the gain at 392
80dc  pac
80dd  bit   5, @1f
80de  add16 @7b
80df  cc    c4e9, tc
80e1  and   #7ffe0000
80e3  mar   *, ar7
80e4  bd    80c3, *
80e6  mar   *+
80e7  sach  *+, 1      ; the store into the transmit buffer
```

and its relationship with the ISR. Both were checked, and neither is at fault.

### The buffer and the work pointer are correct

Watching `390` inside the tone shows a clean circular buffer, written only by
the ISR at `8190`:

```text
8190  0bca -> 0bcc -> 0bce -> 0bd0 -> ... -> 0bde -> 0bc0 -> 0bc2
```

Sixteen slots, `0bc0`..`0bde`, step two, wrapping. Even slots are receive - the
ISR's `sacl *+` at `8183` - and odd slots are transmit, which the mixer fills
with `sach *+, 1` at `80e7` and the ISR reads back through `or *+` at `818e`.
The two ends agree.

Watching the slots themselves in the same window:

```text
0bc1   80e7  0000     the mixer's store, into a transmit slot
0bc0   8183  0000     the ISR's receive store
```

So the mixer does reach its store, on the right slot, and **writes zero**.

### The gain is zero

`--dsp-peek` inside the tone, against a 302 run inside its own first digit:

| cell | 302, audible | 403, silent |
|---|---|---|
| `39a` mixer callback | `874e` | `8743` |
| `3c7` accumulator | `f5db` | `3fd1` |
| `3f3` amplitude | `1000` | `1000` |
| **`392` gain** | **`32c8`** | **`0000`** |
| **`3f1`** | **`0c08`** | **`0000`** |
| **`3f5`** second amplitude | **`0c08`** | **`0000`** |

`80db` is `mpy @12` - the accumulator times `392`. On 403 that multiplier is
zero, so the product is zero and `sach *+, 1` stores silence. Everything
upstream is live; the tone is multiplied by nothing.

And the two zero cells are exactly the two the supervisor sends. Its dial block
carries `001a:32c8` and `001b:0c08`, and
[driving-the-tones.md](driving-the-tones.md) has their destinations as DSP data
`0392` and `03f1`. On 302 those cells hold precisely `32c8` and `0c08`. On 403
they hold nothing; `3f5` is zero because the handler at `ee2c` copies `3f1`
into it.

### 3.1.2 puts them exactly where they belong

The dispatcher vectors through a 128-entry table at program `83e9`, and the
table validates on its own: entry `0x13` is `ee20`, the handler already watched
running. Reading the two in question out of the 403 image:

```text
8227   smmr  @7a, #03ad      ; tag 19
822a   smmr  @7a, #0392      ; tag 1a
822c   smmr  @7a, #fff0
8232   smmr  @7a, #03f1      ; tag 1b
```

`0392` and `03f1` - precisely the destinations
[driving-the-tones.md](driving-the-tones.md) records. **3.1.2 does not move
them**, and the guess in the previous revision that it might was wrong.

(The same table read against 302 is meaningless: its entry for `0x13` comes out
as `8179`, which is inside the serial ISR. The table's address is 3.1.2's, so
3.0.13's handlers are elsewhere and none of the 302 column can be trusted.)

### The handlers run, and store zero

Every write to `0392` across a 403 dial:

```text
801d  0000   @dsp    284,014     boot
807f  32d6   @dsp    284,854
  ... six such pairs through 40.6M ...
822b  0000   @dsp 51,286,031     tag 1a, just before digit 1 arms at 51,371,302
822b  0000   @dsp 55,566,786     digit 2
822b  0000   @dsp 59,861,340     digit 3
822b  0000   @dsp 64,154,570     digit 4
822b  2fd6   @dsp 68,309,089     after the dial
822b  2fd6   @dsp 68,448,105
```

The handler fires once per digit, each time a few tens of thousands of
instructions before that digit's `ee20` arms the oscillator - exactly the
ordering the supervisor's block implies. And each time it stores **zero**.

So the handler is right, the destination is right, and the value is wrong.

### The delivered word is zero

The dispatcher itself is faithful. `8387` reads three cells through the helper
at `80e8` (`lamm *`, `ret`):

```text
8393  lar ar1, #57    ; status - bit 15 is "message pending"
8399  lar ar1, #5e    ; the tag  -> 7d
8399  lar ar1, #5f    ; the data -> 7a   (sacl @7a at 839b)
839f  sub #7f
83a1  add #00008468   ; tag - 7f + 8468 == tag + 83e9, the table read above
```

`57`, `5e`, `5f` are exactly `HOST_STATUS_CELL`, `HOST_TAG_CELL` and
`HOST_WORD_CELL` in `bridge.py`. Nothing is misaddressed.

Watching `7a` - the cell `839b` fills - around the first digit:

```text
839b  0000   @dsp 51,286,021
822b  0000   @dsp 51,286,031     tag 1a stores it into 0392, ten instructions later
839b  0000   @dsp 51,314,394
839b  0006   @dsp 51,371,284
ee20  ...    @dsp 51,371,302     tag 13 arms the oscillator with the right digit
```

So the word delivered alongside tag `0x1a` **is zero**, and the handler stores
exactly what it was given. The supervisor's own message stream records
`001a:32c8`. Between the supervisor writing that message and the DSP reading
it, the data word is lost, while the tag survives - the correct handler runs -
and a small value like `0006` survives intact.

That is this emulator's host-message delivery, not the firmware. `0x13` working
while `0x1a` does not is what makes it worth chasing rather than a dead path.

(An earlier reading of this trace pointed at three mangled-looking words -
`0032`, `c802`, `0400` - as the corrupted `32c8`. They are at DSP 40.6M, and
the tag `0x1a` handler does not run until 51.28M, so they belong to other tags
and are not evidence of anything here.)

### The two delivery paths, diffed

There are not two competing writers. `_mirror_port` is unreachable for the
mailbox ports: the runtime-port branch in `io_write` **returns** before the
`asic_transparent` mirror is reached, so `MIRROR`'s `0x5C -> (0x5F, 0)` and
`0x5E -> (0x5F, 1)` never fire for `0x58`/`0x5A`/`0x5C`/`0x5E`. One writer
reaches the DSP's host cells: `_deliver_host_message`.

What differs is *when* each path acts on the message:

| | assembly | delivery |
|---|---|---|
| trigger | each port write; the message is **recorded** on the `0x5E` write, the data's high byte | the supervisor's `0x1C` bit 0, in the `boot_rom_enabled` branch |
| state | one latch pair, `_runtime_header` / `_runtime_data` | reads that same latch, whatever it holds at that instant |

The two are decoupled, and the run says so out loud:

| | messages assembled | delivered to the DSP |
|---|---|---|
| 403 | 68 | **70** |
| 302 | 66 | **68** |

Two more deliveries than there were messages, on both images. A `0x1C`
acknowledgement that arrives when no new message has been assembled
re-delivers the stale latch.

The same decoupling explains the zero. `_runtime_header` is updated by the
`0x58`/`0x5A` writes and `_runtime_data` by `0x5C`/`0x5E`, so between those two
pairs the latch holds a **new tag with the previous message's data**. A `0x1C`
bit 0 in that gap delivers exactly that. And the previous message is
`0016:0000` - the dial block's own start marker, which the run sends eight
times - so the stale data is `0000`, which is what `839b` read and `822b`
stored into the gain.

Delivery should be triggered by message completion, the same `0x5E` write that
records it, rather than by an acknowledgement that can land mid-message. That
is a bridge change and wants its own measurement afterwards: the assembled and
delivered counts should agree, `0392` should take `32c8`, and the 403 image
should put a tone on the line.

### The fix, and what it did not fix

Delivery now holds the completed pair. The `0x5E` write - the message's last
byte - latches `_runtime_pending`, and the `0x1C` bit 0 commit delivers that
pair and clears it, so a repeated acknowledgement cannot re-send the last
message and a commit landing mid-assembly cannot send a half-updated latch.

| | assembled | delivered before | delivered after |
|---|---|---|---|
| 403 | 68 | 70 | **68** |
| 302 | 66 | 68 | **66** |

302 is unaffected in behaviour: still `dialed: "6245"`, still a tone at peak
22,764, still reaching ringback.

**The tone checks still fail, and the reason is that the premise was wrong.**
403 is not being handed a corrupted gain. Its supervisor genuinely sends zero:

| tag | 302 sends | 403 sends |
|---|---|---|
| `0019` | `020d` x7 | `c802` x6, `0400` x1 |
| **`001a`** | **`32c8`** x4, `32d6` x2 | **`0000`** x4, `2fd6` x2 |
| **`001b`** | **`0c08`** x4 | **`0000`** x4 |
| `001f` | `0000` x6 | `0032` x6 |

The `32c8` attributed to 403 in the previous revision was read off a **302**
run. The DSP receives exactly what its supervisor sends, `822b` stores exactly
what it receives, and the gain is zero because 7.4.16 sent zero. Every claim
here that the delivery path corrupted a value was wrong.

So the question moves up one level again: why does 7.4.16 compute zero for the
tone's gain where 7.3.14 computes `32c8`. The whole register block differs, and
the 403 values are suggestive - `c802`, `0032`, `040b` against 302's `020d`,
`32c8`, `0c08` - which looks like the same bytes read at a one-byte offset.
Whether that is 7.4.16 reading its own parameter table differently or this
emulator feeding it a misaligned one is the next question, and it is
answerable: the supervisor assembles these into the ring at `29e` before the
drain at `8f521` sends them, so watching the 80186 write that ring says which.

### The supervisor enqueues the zero itself

`--mem-watch FIRST:LAST` records 80186 memory writes in a range with the
program address that made each. The first attempt watched `29e..2cd` on both
images and looked like a smoking gun - 302 filled by `8f678` with clean
three-word messages, 403 apparently scribbled over by a dozen unrelated PCs:

```text
302  [02aa] 001a   [02ac] 32c8   [02ae] ff00
     [02b0] 001b   [02b2] 0c08
403  [029f] 0002   [02a0] 00f4   [02a7] 0e00   [02b7] 0001 ...
```

That was another 302-derived address. 403's drain reads its pointer from
`[0x194]` and wraps at `0x1c8`, not `[0x29a]`/`0x2ce`, so `29e` on 403 is
unrelated memory and the "scribble" is just other variables.

Watching **403's own ring** shows its enqueue at `8f668` writing this:

```text
[01ba] ff00      the marker
[01bc] 001a      the tag
[01be] 0000      the data
[01c0] ff00
[01c2] 001b
[01c4] 0000
```

**The supervisor enqueues zero.** The ring is correct, the drain is correct,
the delivery is correct, the dispatcher is correct, the handler is correct and
the oscillator is correct. The supervisor enqueues zero for the tone's gain and
second amplitude where 7.3.14 enqueues `32c8` and `0c08`, and every stage after
that faithfully carries the zero to `mpy @12`.

(An earlier revision read this as "7.4.16 *computes* zero", making it a
firmware difference. It is not: the values are read from provisioned storage
the emulator was not supplying, and the board has them. See
[Answered on the board](#answered-on-the-board-they-are-not-zero-and-the-emulator-was-starving-them)
below - which is also where this document stops being about a 403-versus-302
difference at all.)

Nothing in the emulator corrupts these values, and the several revisions of
this document that said otherwise were each wrong for the same reason: an
address read off the 302 disassembly and applied to a 403 run. `29a` against
`194`, and before that the cell addresses in the hardware comparison. On this
pair of images an address is only meaningful with its image named.

### Where the 403 zero comes from

The gain is not computed. It is read straight out of two RAM cells:

```text
a0ab1   mov bx, word ptr [0x0cd9]   ; mov ax, 001a ; lcall 8f46:01e4
a0ac4   mov bx, word ptr [0x0cdb]   ; mov ax, 001b ; lcall 8f46:01e4
```

Traced across a dial, each fires exactly once, with `bx = 0000`, and
`--peek` reads both cells as zero. The far call goes through the thunk at
`8f644`, whose `CS` is `8f46` - which is why the caller's return address only
resolves with that segment, not the `8000` the rest of the supervisor runs in.

**Nothing in the image writes either cell by absolute address.** The only two
references are those reads. The neighbouring cells in the same block *are*
populated - `[0xca7]` is `55` and `[0xcf9]` is `32`, and `0x8bfc9` sends that
`32` as tag `001f` - and they are filled by the byte copy at `a0907`, which
walks a CS-relative table selected by `[0x0c9e]`:

```text
a0907  mov di, 0ca7
       mov bx, [0c9e]          ; 0d40 in this run, with CS 9efe
       mov al, byte ptr cs:[bx]
       mov byte ptr [di], al
```

So the source table is at physical `9fd20`, and the copy runs twice. But
watching every write into `0cd8..0cdc` across the run shows it never touches
them: the only writers are `fd229` at boot, `804c6` clearing the region, and
`80822`/`80828` writing `5555`/`aaaa`, which is a RAM test. `0cd9` and `0cdb`
sit past the end of what the copy fills, and nothing else fills them.

That is as far as static reading goes. The question it leaves is whether those
cells are also zero on the hardware - in which case 7.4.16 does something else
entirely for the transmit level and this whole path is a red herring - or
whether a real boot puts something there that this emulator does not.

### Answered on the board: they are not zero, and the emulator was starving them

Read off the running 4.03d board with `ATGLK2=0000:0C00`, in command mode, and
confirmed identical in both passes of the read-only RAM capture in
`artifacts/courier-board-21210-ram-403/`:

| cell | board | emulator, 302 fixture |
|---|---|---|
| `[0cd9]` | **`32c8`** | `0000` |
| `[0cdb]` | **`0c08`** | `0000` |

They are the same two values 302 sends. **So the conclusion this document
reached above - "7.4.16 computes zero for the tone's gain where 7.3.14
computes `32c8`" - is wrong.** 7.4.16 does not compute the gain at all and
does not differ from 7.3.14 about it. It reads provisioned storage, the board
has that storage populated, and the emulator was handing it an EEPROM that did
not carry it. The whole 403-versus-302 framing of this section was an
emulator gap wearing a firmware difference's clothes.

**Where the value comes from.** Not the `a0907` copy. The writer is the scatter
at `0xc9a91`, which walks a CS-relative offset table and stores bytes from RAM
`0x071b` upward:

```text
c9a91  xor  bx, bx
c9a93  mov  al, cs:[bx+0e77]     ; the destination offset
c9a9a  jz   c9aa8                ; zero offset ends the entry
c9a9e  add  ax, dx               ; ...plus the block base
c9aa2  mov  al, [bx+071b]        ; the source: the +S block in RAM
c9aa6  mov  [di], al
```

`0x071b` is the +S extended register block - the same 102-byte block
`courier_emu/nvram.py` already models as `IDSDL302_EXTENDED`, whose words at
block offset 23 and 25 are `0x32c8` and `0x0c08`. So the chain is EEPROM ->
RAM `0x071b` -> scattered by `c9aa6` -> `0cd9`/`0cdb` -> mailbox tags `1a`/`1b`.

**The gap was an EEPROM offset.** 7.3.14 stores the block from the high byte of
EEPROM word `0xc1`; 7.4.16 stores it five words later, from the high byte of
word `0xc6`. Running 403 against the 302 fixture therefore landed block offset
10 at RAM `0x071b` where the board lands offset 0 - ten bytes, exactly five
words:

```text
board  071b: 46 00 00 00 0a 23 04 ff 09 7d 4b 00 0d 02 00 06 ...
emu    071b: 4b 00 0d 02 00 00 40 94 11 00 40 0d 02 c8 32 08 ...   (= ref[10:])
```

The block's own trailer confirms the alignment: 302's last two bytes are the
ASCII `"02"` closing a `"3.02"` version string, and the board's are `93 01` -
`0x0193`, 403.

`CourierNvram.idsl403_fixture()` seeds the board's own block at that offset,
and `--nvram-fixture idsdl403` selects it. With it, an emulated 403 run
reproduces the board's `0x071b` block byte for byte and carries `32c8`/`0c08`
into the gain cells.

### Measured with the fixture in: 403 dials

```sh
./courier run artifacts/courier-board-21210-capture-403/courier-board.rom \
    --with-dsp --exchange --exchange-number 6245=answer --tick-ms 5 \
    --board-id 7 --nvram-fixture idsdl403 --at 'ATDT6245' \
    --instructions 150000000 --summary --dsp-tx-pcm /tmp/tx403.pcm
```

| observation | 403 before | 403 with the fixture |
|---|---|---|
| datapump transmit peak | **0** | **22,764** |
| nonzero transmit samples | 0 | 3,669 of 66,078 |
| digits decoded off the line | `""` | **`6245`** |
| DTMF blocks | 0 | 137 |
| exchange outcome | - | `answer`, state `ringback` |
| tag `0019` | `c802` x6, `0400` | `020d` x7 |
| tag `001a` | `0000` x4 | **`32c8` x4** |
| tag `001b` | `0000` x4 | **`0c08` x4** |
| tag `001f` | `0032` x6 | `0000` x6 |

All four register lanes now carry what 302 carries, which is what the earlier
"same bytes read at a one-byte offset" reading was groping at - the offset was
real, and it was five words in the EEPROM rather than one byte in a table.

The board firmware puts a tone on the line and the modelled exchange decodes
the dialled number. The datapump dispatch beyond ringback is not addressed by
this and remains where the rest of this document leaves it.

**One thing this does not license.** The six obfuscated settings records that
7.3.14 keeps at EEPROM words 94..102 are not 7.4.16's shape: decoding the
board's cached window with the `e237` routine gives no majority on any of the
six records. The 403 fixture therefore seeds the extended block and nothing
else, rather than writing 302's settings layout and calling it a 403.

## What is not established

Which command sets those flags, and what writes them on a real boot. The
handler table at `0xa6615` is never indexed by any `jmp cs:[bx+...]` in the
image, and no far pointer targets `a4d2:1d4c`.

## The supervisor's real dispatcher, for the record

`0x8f564` is `call word ptr [0x298]` - an indirect call through the current
state handler, with a selector in AL. It is the supervisor's event dispatcher,
and across a whole dial it runs three times:

| instruction | AL | result |
|---|---|---|
| 5,847,937 | `83` | the first `0083:0083` |
| 35,662,523 | `83` | the second |
| 59,801,997 | `82` | BX=`704d`, the `0017:704d` the run emits |

So `0x82` on 302 is an internal state selector, not an ASIC register write.
The bridge waits for `asic_registers[0x82] == 0x00A0`, which is main211's
protocol; 302 never writes that register at all.
