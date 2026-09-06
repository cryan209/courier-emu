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
| 2 | diagnostic word ready | `in 0x62`/`0x60` | `lcall 0x8000:0674` -> `call [0x2d3]` |

After the bit-1 dispatch it calls `[0x27d]`, then re-reads the status and
tests bit 2:

```
in  al, 0x1e / in al, 0x1c
and ax, 4
jz  skip
mov [0x285], ax
lcall 0x8000:0674          ; -> call word ptr [0x2d3]
```

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
codes above.

## What this does not establish

The `ATY4` row printer itself is still unlocated. `0x14f13` emits a CRLF and a
two-space row indent under the `[0x0608]` gate, and the cadence detector beside
it at `0x14f31` compares `[0x0bda]` and `[0x0bde]` against threshold pairs at
`[0x081d..0x0823]`, but hooking execution over `0x94e20..0x94fc0` for a whole
`ATY4` dial records **zero** instructions there, and no reference to it exists
by near call, far call, or as a table word at its segment-`0x8f43` offset
`0x5ae3`. It may be unreachable in this build. Of the six `[0x0608]` gates,
only the banner at `0x8bf2d` executes offline; the three in the `0x49xxx`
`ATG` monitor extension echo characters rather than levels.

Nothing here identifies the `AH=0x45` / `AL=0x3f` operation on the far side of
the queue, the meaning of the 36 event codes, or the units of any printed
value. The mapping from an event code to a row like `00 00 02 08 07` is
inferred from the table's contents, not observed.

The command table was measured on `IDSDL302.ROM`. The 403 board image produces
the same `CALL PROGRESS` behaviour for `ATY4DT`, but its `ATY` handler bytes
were not located, so the two builds are not shown to implement `Y` alike.
