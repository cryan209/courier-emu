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

## What is not established

Which command sets those flags. The handler table at `0xa6615` is never indexed
by any `jmp cs:[bx+...]` in the image, no far pointer targets `a4d2:1d4c`, and
neither a factory-default profile nor a parameter sector reaches it.

What has not been tried, and is the obvious next thing: the board's own raw
EEPROM. `ATI5` renders the profile the firmware chooses to show; it is not the
512 bytes. Reading those needs the NVRAM driver run on the hardware
(`courier_emu/nvram.py` records it at `5b5e:16e0` for 302, which is not the
4.03d address), and a faithful `--nvram` image would settle whether anything in
the store matters here at all.

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
