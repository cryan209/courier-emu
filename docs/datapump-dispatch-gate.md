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

## What is not established

Which command reaches `0xa6a6c`. No far call or far pointer in the image
targets `a4d2:1d4c`, and no `jmp cs:[bx+...]` dispatcher indexes the table at
`0xa6615`, so it is reached some other way - a `call word ptr` through that
table, or a handler address assembled at runtime.

The open question is therefore no longer "which board event is missing" but
"which command configures the datapump, and does the emulator's command path
ever reach it". The next probe is the same hook pointed at the table's other
handlers and at `0x89cbc` itself, to catch the command dispatcher in the act.
