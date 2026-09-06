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

## Why every measurement display is empty

The consumer that runs a `[0x2d3]` step is the trampoline at `0x0674`
(`call word ptr [0x2d3]; retf`). Its four call sites all read a status port
first:

```
in  al, 0x1c
and ax, 4
jz  skip
mov [0x285], ax
lcall 0x8000:0674
```

**Port `0x1C` bit 2 is the word-ready signal, and it never asserts in the
harness.** During an `ATY12` run the port is read 2882 times and returns `0x01`
every time; `asic_ports` carries a `0x1C` idle default of `0xFD` and a
loopback value of `0xF9`, but the value observed at runtime comes from the
output latch - `out 0x1c, 1` occurs 5764 times, paired with the reads.

The consequence is directly observable. Sampling `[0x2d3]` across a run shows
three different producers arming a sequence - `0x1fdb`, `0x20fa`, `0x4420` -
and the vector never advancing past the armed entry, because no step ever
runs. Sampling the `ATY12` handshake shows the request issued and then timing
out:

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

## What would have to be modelled

One mechanism, feeding every display above:

1. Port `0x1C` bit 2 asserted when a reply word is available.
2. Ports `0x62` (high byte) and `0x60` (low byte) returning that word.
3. Whatever advances 1 and 2 once per word until the requested count is met.

`ATY12` is the cheapest probe for it: it prints its sixteen rows at the
command prompt with no dial and no timeout, so a populated source shows up
immediately.

## What this does not establish

The `ATY4` row printers are traced only as far as the `[0x0608]` gates listed
above. `0x14f13` emits the row indent, and the call-progress detector beside
it at `0x14f31` compares `[0x0bda]` and `[0x0bde]` against threshold pairs at
`[0x081d..0x0823]`, but no static caller of `0x14f13` was found by near call,
far call, or a scan for its offset as a table word, so what drives it - and
whether the levels it prints arrive over the same `0x60`/`0x62` path - is
unconfirmed. The `0x49xxx` Y4 gates are inside the `ATG` monitor extension and
echo characters, not levels. Nothing here identifies the `AH=0x45` / `AL=0x3f`
operation on the far side of the queue, or the units of the values.

The command table was measured on `IDSDL302.ROM`. The 403 board image produces
the same `CALL PROGRESS` behaviour for `ATY4DT`, but its `ATY` handler bytes
were not located, so the two builds are not shown to implement `Y` alike.
