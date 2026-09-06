# The ATY diagnostic commands and the missing line-measurement path

`ATY<n>` is a numeric-argument command family that drives the firmware's own
line diagnostics. The harness answers all of them, but every display whose
data comes from the modem's measurement hardware renders empty, and this
document records why: one input path is unmodelled, and it is the same path
for all of them.

## What the commands do

Measured offline against `IDSDL302.ROM` (supervisor 7.3.14), board id 7,
`tick_ms=5`, the mostly-erased `idsl302` EEPROM fixture, no line and no
external serial device. `artifacts/rom-at-smoke-20260906/probe.py` drives the
DTE.

| Command | Response | Data source |
|---|---|---|
| `ATY11` | `Freq     Level` header, no rows | measurement (empty) |
| `ATY12` | `Recv     Xmit` + 16 rows of `0000     0000` | measurement (empty) |
| `ATY14` | `000,000,030,007,030,000` | CPU-side, partly populated |
| `ATY15` | `CURRENT DIPSWITCH SETTINGS` + all ten switches | modelled front panel |
| `ATY16` | `OK` | - |
| `ATY17` | 8x8 grid of `0000` | measurement (empty) |
| `ATY13`, `ATY18`, `ATY19`, `ATY20` | `ERROR` | - |
| `ATY0`-`ATY9`, bare `ATY` | `OK` | - |

`ATY4` is a mode rather than a display. It stores 4 at `[0x0608]` and persists
across commands; a later dial prints `\r\nCALL PROGRESS\r\n` and should then
print level rows. Six sites test `cmp byte [0x608], 4`:

| Site | On Y4 |
|---|---|
| `0xbf2d` | print the `CALL PROGRESS` banner |
| `0x14f13` | emit CRLF and a two-space row indent |
| `0x2917` | print `LLOSS` when `[0x032c] & 0x80` |
| `0x48e32`, `0x491a5`, `0x491b9` | echo a character / a value and a space, in the `ATG` monitor extension |

Only `0xbf2d` is reached offline. `ATY4` is *not* limited to nine values:
the `cmp al, 0x0a / jae reject` at `0x26248` is the tail of a dispatch chain
that matches `0x0c`, `0x0e`, `0x0f`, `0x10` and `0x11` ahead of it.

## How ATY12 fetches its data

`ATY12` is a buffered fetch, not a live sample. Its handler at `0x6eb2`:

```
mov ah, 0x45                  ; operation
mov byte [0x942], 0x20        ; request 32 words
mov word [0x2d3], 0x20fa      ; the collector step for this reply
call 0x6ede                   ; AL=0x3f, lcall 0x8f43:0228, [0x2e3]=1,
                              ; [0x2e8]=6, spin until the flag clears
mov si, 0x20
mov dx, 2
call 0x6fbb                   ; print the reply buffer
```

`0x8f43:0228` (file `0xf658`) is a ring-buffer enqueue: it stores AX into the
queue at `[0x29e..0x2ce)` with head `[0x29c]` and tail `[0x29a]`.

`[0x2d3]` is a state-machine vector. Each incoming 16-bit word runs the step
it points at, and the step rewrites it to the next one. The collector for
this reply, at `0x20fa`, sets the write pointer `[0x944] = 0x946` and index
`[0x943] = 0`, discards two words, then stores each further word at `[0x944]`,
incrementing by two, until `[0x943] == [0x942]`, at which point it jumps to
`0x2000`: vector back to idle and `mov byte [0x2e3], 0` - the handshake's
completion. Every word is read the same way, `in al, 0x62` for the high byte
then `in al, 0x60` for the low.

The printer at `0x6fbb` then gives the buffer layout:

| Location | Meaning |
|---|---|
| `DS:0x0942` | reply word count; `CL = count >> 1` rows |
| `DS:0x0946` | **Recv** column, stride `DX` = 2 |
| `DS:0x0966` | **Xmit** column, reached as `[bx+si]` with `SI` = 0x20 |
| `0x9d7e` | prints AX as four hex digits |

So 32 words: sixteen Recv at `0x0946` and sixteen Xmit at `0x0966`.

## The interrupt that feeds everything, and its three channels

One ISR, at file `0x12d3c`, drives every consumer discussed here. It reads a
status word from ports `0x1E` (high) and `0x1C` (low) and acts on the low
three bits:

| Status bit | Channel | Data ports | Consumer |
|---|---|---|---|
| 0 | transmit ready | `out 0x5c`/`0x5e`, `out 0x58`/`0x5a` | drains the ring at `[0x29e]` |
| 1 | event word ready | `in 0x5a`/`0x58` | `call [0x298]`, the modem state machine |
| 2 | **DSP word ready** | `in 0x62`/`0x60` | `lcall 0x8000:0674` -> `call [0x2d3]` |

After the bit-1 dispatch it calls `[0x27d]`, then re-reads the status and
tests bit 2:

```
in  al, 0x1e / in al, 0x1c
and ax, 4
jz  skip
mov [0x285], ax
lcall 0x8000:0674          ; -> call word ptr [0x2d3]
```

### Channel 2 is the DSP's outbound window, not a diagnostic side-channel

`dsp_mailbox.py` already settles the producer, against hardware: the DSP's
sender - `84b7` in DSP 3.0.13, `849e` in 3.1.2 - is `out *, 0060` followed by
`lacl #04 ; samm @57`, and that 4 is the status bit the CPU reads as `0x1c`
bit 2. So the window's producer is **the DSP, one word per interrupt**; the
ASIC only bridges CPU I/O ports to DSP data cells. Acknowledging bit 2 resumes
the DSP and makes it emit the next word.

`ATY12` is a sibling of the stream that tool already drives. The documented
trigger at `0x6d08` arms `[0x2d3] = 0x1fdb` and enqueues `AL=0x3f, AH=0x06` -
tag `0x063f`, matching `STREAM_TAG`/`STREAM_DATA`. `ATY12` at `0x6eb2` arms
`[0x2d3] = 0x20fa`, sets the count to 32, and enqueues `AH=0x45` with the same
`0x3f`: tag `0x453f`, a longer collector on the same window.

**These addresses are supervisor 7.3.14's.** Under 7.4.16 the chain vector is
`[0x01cd]`, not `[0x02d3]`. The 403 board image confirms the whole shape at its
own addresses: the trampoline `call word ptr [0x01cd]` at `0x0067b`, the tag-06
trigger at `0x06d52`, and `ATY12` at `0x06efe` arming `[0x01cd] = 0x212c` with
the count cell at `[0x0836]` rather than `[0x0942]`.

## Why the measurement displays are empty

**Only channel 2 is dead.** Counting port traffic across an `ATY12` run
separates it cleanly:

| Port | Traffic |
|---|---|
| `0x1C`, `0x1E` | 2882 reads each - the ISR runs |
| `0x58`, `0x5A` | 2878 reads, 3469 writes - channel 1 and the transmit path are live |
| `0x5C`, `0x5E` | 3469 writes - live |
| `0x60`, `0x62` | **0 reads** |

So the modem event machine is running normally; it is specifically the
diagnostic channel that never signals. Port `0x1C` bit 2 never asserts: the
port returns `0x01` on all 2882 reads, which is the output-latch echo of the
`out 0x1c, 1` the ISR itself performs.

The consequence is directly observable on the `[0x2d3]` side. Sampling that
vector across a run shows three different producers arming a sequence -
`0x1fdb`, `0x20fa`, `0x4420` - and the vector never advancing past the armed
entry, because no step ever runs. Sampling the `ATY12` handshake shows the
request issued and then timing out:

```
flag=00 retry=00 count=00   (idle)
flag=01 retry=06 count=20   (request issued, 32 words asked for)
flag=01 retry=05 count=20
...
flag=01 retry=00 count=20   (retries exhausted, flag still set)
```

The buffer at `0x0946` stays zero throughout. `0x6eb2` ignores the carry flag
`0x6ede` returns, so it prints sixteen rows of `0000` regardless: the zeros
are a **timeout, not an empty reply**.

## What ATY4 actually arms

The banner site at `0xbf28` is the whole call-progress entry, and tracing its
memory writes shows the sequence:

```
mov byte [0be0], 0
cmp byte [0608], 4 / jne ...      ; print "\r\nCALL PROGRESS\r\n"
mov word [0298], 0x5782           ; the call-progress state handler
xor bx, bx / mov ax, 0x1500
lcall 0x8f43:0228                 ; enqueue command 0x1500
mov byte [0aef], 0
mov byte [0bd4], 5                ; blanking guard
mov di, 0bd6 / mov cx, 10 / rep stosb   ; clear the cadence counters
```

The module's code segment is **`0x8f43`**, not a round `0x9000`, so
`[0x298] = 0x5782` resolves to physical `0x94bb2` (file `0x14bb2`). That
handler is a table dispatch through the generic matcher at `0xf78a`
(`repne scasb` then `jmp word ptr cs:[bx+di]`), over a **36-entry
call-progress event table**: match bytes at file `0x14b40`, handler words at
file `0x14b64`.

```
83 07 3a 21 08 3d 3a 28 29 2a 2b 2c 2d 2f 47 0b 2e 23
45 46 48 30 34 35 36 37 6a 6c 6d 70 71 73 74 6b 6e 44
```

These event codes are what `ATY4` reports. Offline the arming happens six
times - `[0x0bd4] = 5` is written six times, once per dial retry - and the
state at `0x94bb2` is entered only once, so the counters at `[0x0bd6..0x0bdf]`
stay zero and no row is ever produced.

## What would have to be modelled

For the `ATY11`/`ATY12`/`ATY17` displays, channel 2 alone:

1. Port `0x1C` bit 2 asserted when a reply word is available.
2. Ports `0x62` (high byte) and `0x60` (low byte) returning that word.
3. Whatever advances 1 and 2 once per word until `[0x942]` is satisfied.

`ATY12` is the cheapest probe for it: it prints its sixteen rows at the
command prompt with no dial and no timeout, so a populated source shows up
immediately.

`ATY4` needs something different - not channel 2, but a source of
call-progress events on the already-working channel 1, drawn from the 36
codes above, delivered as values below `0x76` rather than the `0xff` the port
currently returns.

## What ATY4 prints, established by forging events

**The events below are fabricated.** Forcing `AL` at `0xf492` writes a value the
hardware never produced; it exercises the firmware's display path and says
nothing about the line. Read this section as a test of the printer, not as a
model of anything.


Channel 1 is live but carries nothing usable: the active `in al, 0x58` site is
file `0xf490`, and across a whole `ATY4` dial it reads `0xff` on all 5596
invocations. The very next instruction is the rejection:

```
in  al, 0x58
cmp al, 0x76
jb  dispatch
jmp skip            ; 0xff is discarded here
```

Event codes must be below `0x76`, so a floating `0xff` bus is rejected before
`call [0x298]` ever runs. That, not a missing display, is why nothing prints.

Forcing `AL` to a table event code at `0xf492` - and only while
`[0x298] == 0x5782`, since the vector is otherwise the idle state `0x0150` -
produces the row:

```
\r\nCALL PROGRESS\r\n00  
```

and the execution hook shows `0x94f13` running, with `AL = 0x00`. **`0x14f13`
is the `ATY4` row printer**, and it is reachable; an earlier revision of this
document wrongly called it dead on the strength of a static scan that found no
caller. Its body prints the event byte through `0x8000:0x9da6`, which lands on
`aam 0x0a` at `0x9dbd` and emits **two decimal digits**, then two spaces.

So an `ATY4` row is a run of call-progress **event codes in decimal**, two
digits each - the shape of a reported hardware line such as
`00 00 02 08 07`, whose values are codes `0, 0, 2, 8, 7`, not signal levels.

Only one row appears per injection run because the first table event, `0x83`,
dispatches to file `0x14bbe`, which sets `[0x298] = 0x150` and returns the
machine to idle. Feeding a sequence that avoids `0x83` keeps the vector out of
`0x5782` entirely and prints nothing, so a plausible ordered event sequence -
not an arbitrary one - is what a model has to supply.

## The gates are unreached, not dead

Hooking execution across `0x14dd0..0x14fc0` while events are injected records
the whole path, and it settles why the static scans found nothing:

```
14dd8 -> 14dde (lcall c800:0008) -> 14de3 ... 14e08 -> 14e30 (cadence detector)
      -> 14e40 -> 14ef7 ... 14f0e -> 14f13 (gate taken) -> 14f1b -> prints
```

`0x14f13` is reached by ordinary sequential flow inside the detector, not by a
call from anywhere. The scans looked for a caller and there is none to find;
the routine is simply downstream of an event. The stack at the gate confirms
the frame belongs to the `call word ptr [0x298]` at `0xf4e2` - the event
dispatch - with the near return address `0x8f4e6`.

So the answer to "is it dead because the line modelling is dead" is **yes for
this gate, demonstrably**. Nothing about it is vestigial: it prints the first
time a valid event reaches the detector.

The same run reaches extension entry 8 (`lcall 0xc800:0008` -> `0x48e3f`), which
had never executed before either. Entry 8 is the second-word consumer for event
`0x08`: the handler reads the accompanying data word from ports `0x5e`/`0x5c`
before calling it.

`0x48e32` and `0x491b9` still did not execute even with events flowing. Both
are separate routines rather than fallthrough targets - `0x48e32` ends in a
`ret` immediately before entry 8's body - so each needs an actual caller, and
none is discoverable. The likeliest reading is the same one proved for
`0x14f13`, since their neighbours in this family are all on line-driven paths:
`0x491a5` is called from `0x49202`, which waits on `[0x02cf]` for a received
DTMF digit. But that is inference from position, not a demonstration.

## Running it against the real bridge instead

The project does model the line: `CourierDspBridge` owns exactly the event
ports (`DSP_RUNTIME_PORTS = (0x58, 0x5A, 0x5C, 0x5E)`, plus `0x1C`) and carries
a `CourierDaa`, `LineLink`, `LineExchange` and the `NativeC5x` core. Every run
in this document until now used none of it: the probe builds a CPU-only
`CourierMachine`, which is what its own manifest calls an "offline CPU-only ROM
AT-command smoke test".

Re-running the `ATY4` dial with `with_dsp=True` and a `CourierDaa` changes the
execution - the dial reaches 68.8M instructions rather than 43.7M - but the
display stays empty. The event port is read **once**, and delivers `0xff`,
which `cmp al, 0x76` rejects. So the bridge does not synthesize a
supervisor-facing call-progress event stream, and enabling it is not a
substitute for one.

Two related gaps sit next to this. `asic_ports.IDLE` records hardware idle
values for these ports - `0x58: 0x20`, `0x1C: 0xFD`, `0x60: 0x4B` - and
`machine.py` does not import `asic_ports` at all, so a CPU-only run answers
`0xff` and the `0x1C` latch echo instead. Seeding those would not manufacture
events either; a constant idle level is not an event stream, and `0x20` is not
one of the 36 codes.

## How the detector qualifies, and why the DAA model does not fit this image

Two different things are called "qualified", and they do not measure the same
quantity.

`CourierDaa.detector_qualified` is a sample count: `qualified_samples >= 5 *
DAA_FRAME_SAMPLES`, five 100 ms frames of audio accrued while `detector_present`
holds, zeroed by `seize()` and `release()`. It never inspects a level.

`main211.xmf` counts something else. The wait at `0x1dbee` is
`cmp byte [0649], 5 / jb`, and the counter at `0x1e442` is driven by the reply
value in `[0x0285]`:

| `[0x0285]` | Effect on `[0x0649]` |
|---|---|
| `0xff` | nothing - the "no reply pending" sentinel |
| `0` | reset |
| `1..0x60` | increment - one qualifying hit |
| `> 0x60` | reset, and increment `[0x064a]` instead |

then `mov word [0285], 0xff` consumes it. So five consecutive polled replies
whose level lands inside `1..0x60`. The bridge's `DETECTOR_PRESENT_LEVEL = 0x30`
is correctly in that window; what never happens is the poll, which is what
`detector_replies: 0` reports.

**`IDSDL302.ROM` does not use that path at all.** It has no `[0x0649]` access
and no `[0x0285]` level comparison; in this image `[0x0285]` is the ISR status
word. Its detector counter is `[0x0cc0]`, its wait is at `0xb784`
(`cmp byte [0cc0], 5 / jb 0xb76f`, with `mov byte [0cc0], 0` arming it at
`0xb76a`), and the counter is updated by the four-instruction routine at
`0x14fca`:

```
14fca  test ah, 1
14fcd  je   14fd4
14fcf  inc  byte [0cc0]      ; a qualifying hit
14fd3  ret
14fd4  mov  byte [0cc0], 0   ; reset
```

`AH` there is the high byte of the **data word that accompanies event `0x08`**,
read at `0x14dd8` from ports `0x5e`/`0x5c` immediately before the call to
extension entry 8. The two call sites, `0x14df1` and `0x14e05`, are gated on
`[0x0ea7] & 1` and `[0x0ea6] & 1`.

So this supervisor qualifies its detector from **bit 0 of the high byte of
event `0x08`'s data word** - five consecutive sets - not from a polled level.
The 403 board image is the same design with different addresses: counter
`[0x0b9e]`, the identical `test ah, 1` routine at `0x14fdc`, and the wait at
`0x0b7c2`.

That puts the requirement squarely back on the channel that currently carries
nothing. For these images the bridge would have to emit event `0x08` with a
data word whose high byte has bit 0 set, five times running, before the dial
can proceed - and the DAA's sample-count model is not a stand-in for it,
because it is modelling a different supervisor's mechanism.

## What this does not establish

The 36 event codes are read off the dispatch table; their meanings are not
known, and no mapping from a line condition to a code has been demonstrated.
The injection proves the display path works when fed. It does not show that any
of those values is what hardware would send, in what order, or with what
timing, and no run in this document has produced a single genuine
call-progress event. Nothing here identifies the
`AH=0x45` / `AL=0x3f` operation behind the `ATY12` queue, or the units of the
values in its buffer.

`0x491a5`, the third extension gate, is called from `0x49202`, a helper that
waits on `[0x02cf]` and translates a nibble through the DTMF table
`"0123456789#*ABCD"` at `0x49209` - so under `ATY4` the extension echoes
received DTMF digits as well.

The command table was measured on `IDSDL302.ROM`. The 403 board image holds the
same six gates against `[0x0500]` rather than `[0x0608]` - `0x02984`, `0x0bf79`,
`0x14f25`, `0x4960a`, `0x4a1c4`, `0x4a1d8` - with the mode byte stored at
`0x262d1`, so the two builds are structurally alike but not address-compatible.
