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
