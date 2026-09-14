# ATG's eight-hex-digit DSP command form

Confirmed on the attached Courier on 2026-09-09: ID_SDL 4.03d,
supervisor 7.4.16, DSP 3.1.2, at `/dev/cu.usbserial-11420`, 115200 baud.

```text
ATGccccdddd
   │   └── 16-bit data/argument, four hexadecimal digits
   └────── 16-bit DSP command/tag, four hexadecimal digits
```

Use eight uppercase hex digits, including leading zeroes, with no comma.
Four-digit and shorter forms select different handlers. Command numbers
select firmware operations; they are not arbitrary DSP program addresses.

## Fresh board measurement

| Sent through ATG | Mailbox reply tag:data | Interpretation |
|---|---|---|
| `ATG00620000` | `0069:0015` | Known sample-processing query |
| `ATG00070000` | `0031:0000` | Known status-word query |
| `ATG002D0000` | still `0031:0000` | No-op; held reply unchanged |
| `ATG00620000` | `0069:0015` | Repeat query changes reply again |
| `ATG0007A55A` | `0031:0000` | Query 07 ignores its supplied data |

All five returned serial `OK`. The supervisor's queue head advanced six
bytes each time and the tail caught up each time. RAM retained the exact
frames, including `ff00 0007 a55a` for the last request. The alternating
reply tags distinguish a fresh response from reading a stale holding register.
The `0015` value is this capture's result, not a universal constant for tag 62.

Only those already-characterized queries and no-op were sent. No direct
mailbox writes, memory writes, reset, flash operations or dialing were used.
AT answered after the sequence. The experiment does not prove every possible
16-bit command is valid or that every handler uses its data argument.

## Reply retrieval

The G command queues the request; it does **not** print the DSP reply as
part of its serial response. Read the holding registers separately:

```text
ATGLK2I0058    reply tag, low byte
ATGLK2I005A    reply tag, high byte
ATGLK2I005C    reply data, low byte
ATGLK2I005E    reply data, high byte
```

The supervisor serviced the mailbox automatically during this test. We did
not write the commit or acknowledgement ports. Idle CPU status was `fffd`
after each observed transaction; the supervisor had consumed the readiness
event while the reply bytes remained held. These byte reads are not an atomic
snapshot and do not by themselves associate a reply with a request when
other DSP traffic is active.

## Exact firmware path

The captured 403 G handler at file `0x25c5b` selects the eight-character
case. It parses the first four hex digits into AX and the second four into
BX, then calls `8f46:01e4` (file `0xf644`). Its helper at `0xf678` queues:

```text
ff00, command, data
```

The `ff00` marker selects a paired transfer and is not sent to the DSP.
The drainer at `0xf511` writes command low/high to `58/5a`, then data
low/high to `5c/5e`. Thus textual `A55A` becomes bytes `5a` then `a5` on
the data ports. Queue words reside in supervisor RAM `0198..01c7`, with
tail at `0194` and head at `0196`.

The queue helper returns without enqueuing when there is insufficient room,
and the G handler still clears carry. Consequently **serial OK alone is not
proof of delivery**. Our empty/idle test confirms delivery through changed
DSP replies and drained queue pointers. Saturated-queue handling and
connected-call concurrency remain unmeasured.

This gives us a shorter way to invoke known DSP operations through the normal
supervisor path. It does not add a DSP memory reader or arbitrary subroutine
caller; those still require a suitable DSP handler or a RAM probe.

## Evidence

[Hardware capture](../artifacts/g-eight-hex-board/hardware.json),
[raw command transcript](../artifacts/g-eight-hex-board/transcript.json),
[capture script](../artifacts/g-eight-hex-board/capture.py), and
[drainer disassembly](../artifacts/g-eight-hex-board/drainer-disassembly.txt).
The prior [isolated queue test](../artifacts/undocumented-atn-analysis/g-queue-results.json)
independently checks parsing/order without hardware.

The [normally booted DSP replay](../artifacts/g-eight-hex-board/booted-emulator.json)
now matches all five board results. This resolves the previously reported
query-62 `0012` versus `0015` mismatch as a difference in test initialization;
see [the comparison analysis](mailbox-312-comparison.md).

## The same command on 7.6.7, and what it costs online

Measured 2026-09-15 on the leased-line unit at `/dev/cu.usbserial-FT4TQOFT`,
supervisor 7.6.7 / DSP 3.1.2, serial `21OWZ849PS95` - the board whose flash is
`artifacts/courier-board-11430-flash-20260914-unit2-02/courier-board.rom`.

**`LK2` is mandatory on this build.** Bare `ATG00070000` answers `ERROR`, and so
does bare `ATG`. The handler itself is byte-equivalent to 4.03d's, relocated to
file `0x26794`, with the queue helper at `8f51:01e4`; only the prefix check
differs. At `0x2673b` both builds compare `word [si]` against `'LK'` and
`[si+2]` against `'2'`; 4.03d's mismatch branch continues into the subcommand
dispatch, while 7.6.7 jumps to `stc; ret`. So every form below carries the
prefix: `ATGLK200070000` queues what `ATG00070000` queues on 4.03d.

The subcommand letters, disassembled from the same image:

| Form | Handler | Action |
|---|---|---|
| `ATGLK2Iport` | `0x267d7` | one `in al, dx` |
| `ATGLK2Bport` | `0x27af4` | 16 consecutive ports, `in`/`inc dx` |
| `ATGLK2Oport,val` | `0x267f7` | one `out dx, al`; the comma is required |
| `ATGLK2=[seg:]off` | `0x27a28` | 16 memory bytes from `es:[bx]` |
| `ATGLK2R[seg:]off` | `0x27a93` | 8 memory words |
| `ATGLK2N` | `0x267cf` | sets bit 0 of `[0x158]` |

`I` reads ports, not memory, so the queue pointers cannot be read with it:
`ATGLK2I0194` returns `94` and `I0196` returns `96` because those ports are
unmapped and float the address low byte. `R` reads them properly.

**Query 07 is delivered and answered during a live V.34 call.** With the pair
connected at 33600/33600, `ATGLK2R0190` showed tail and head both at `0x019E`
before and `0x01A4` after, the six bytes at `0x0198` holding the expected
`ff00 0007 0000` frame, and port `0x58` moving from `0x20` to `0x31` - reply tag
`0x0031`, the same value the idle 4.03d board gave. This answers the
concurrency question left open above, for that query.

**Query 62 dropped the call and wedged the supervisor.** Issued next on the same
connection, `ATGLK200620000` was followed by `NO CARRIER`, and the modem then
stopped answering `AT` at all until it was power cycled. Treat tag `0x62` as
unsafe while a call is up. Whether it is the query or the concurrency that wedges
the supervisor is not established; one occurrence, not repeated.

[Online capture](../artifacts/leased-pair/dsp-queue-online.json),
[prefix comparison](../artifacts/leased-pair/dsp-lk2-prefixed.json), and the
[refusals before the prefix was known](../artifacts/leased-pair/dsp-online.json).

## Idle and online on one board, the same afternoon

Measured 2026-09-15 on the 4.03d board, by then on `/dev/cu.usbserial-FT4TQOFT`,
with DTR held for the whole run so the hook state never moved underneath it.
The port block was read with `ATGLK2B0050` and the queue with `ATGLK2R0190`.

Idle, after `ATH0`, the reply path behaves as the board did on 2026-09-09:

| after | port `0x58` | port `0x5c` | tail = head |
|---|---|---|---|
| - | `44` | `00` | `019e` |
| `ATG00070000` | `31` | `00` | `01a4` |
| `ATG00620000` | `69` | `15` | `01aa` |
| `ATG00070000` | `31` | `00` | `01b0` |

Tag `0031:0000` and `0069:0015` reproduce exactly, the alternation shows each
reply is fresh rather than a stale holding register, and the ring carries both
frames - `ff00 0007 0000` and `ff00 0062 0000` - six bytes per request, drained
each time.

Online, on the same board minutes earlier, the request path is identical and the
reply path is not. Pointers stepped `01b6` to `01bc` with the frame in the ring,
while ports `0x50` through `0x7f` came back byte-identical before and after, and
identical again across three samples seconds apart. Two ports separate the
states outright: `0x58` reads `20` during a call against `44` idle, and `0x60`
reads `61` during a call against `0a` idle. So a queued request is delivered
mid-call but its reply is not published to the holding registers.

Read these as 16-bit latches, low byte at the even address: every odd byte in
the block reads `00`.

[Idle A/B](../artifacts/leased-pair/dsp-403-idle.json),
[online sweep](../artifacts/leased-pair/dsp-403-online-sweep.json),
[repeated online samples](../artifacts/leased-pair/dsp-403-port-timeseries.json).
