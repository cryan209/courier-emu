# Recovered I-modem VRTX startup

The Ie030002 payload contains a working VRTX initialization-to-task startup
path. A 3,000,000-instruction run of the existing `IsdnMachine`, with no guest
code patches, creates nine tasks successfully and executes all nine entries.
The firmware itself calls the task at `a400:0008` **TID_MODEM**.

This supersedes the earlier interpretation that the lower payload is merely
an updater and that `a400:0008` is only a DSP helper. Flash command activity
does not, by itself, distinguish an updater from normal firmware startup.

## Startup chain

| Address | Action |
|---|---|
| `4030:0000` (`40300`) | Existing harness entry: initializes stack/hardware, clears RAM, relocates data, installs vectors. |
| `4030:006e` (`4036e`) | Far jump to `7360:1ec0`. |
| `7360:1ec0` (`754c0`) | Installs INT 30 at `7360:0000`, INT 31 as descriptor pointer `98d1:0000`. |
| `7360:1ee0` (`754e0`) | `mov ax,30h; int 30h`: kernel initialization. |
| `7360:1b3d` (`7513d`) | Service 30 implementation: clears kernel workspace, builds task-control-block/free lists and idle context. |
| `7360:1f30` (`75530`) | Far call to `6ac3:000c`, firmware subsystem initialization. |
| `6ac3:003d` (`6ac6d`) | Calls `6ad6:000f`, which calls nine subsystem initializers, including `4607:000a`. |
| `4607:000a` (`4607a`) | Creates synchronization objects and explicitly creates nine tasks. These are immediate call arguments, not a standalone task-pointer table. |
| `4063:02ae` (`408de`) | C task-creation wrapper: task entry in ES:BX, ID in CL, priority in CH; calls service 00 at `408f1`. |
| `7360:03e2` (`739e2`) | Service 00 implementation: allocates task state, installs saved entry/context, queues task. |
| `7360:1f35` (`75535`) | Service 15 with CX=3, after subsystem setup returns. Its exact API name is not assigned here. |
| `7360:1f4e` (`7554e`) | `mov ax,31h; int 30h`: scheduler start. |
| `7360:1e21` (`75421`) | Service 31 switches to the prepared stack, enables scheduling state and branches to the scheduler. |

The service dispatch table is at `7360:1e59` (`75459`), 50 little-endian
near offsets indexed by AX. The kernel has special interrupt entry/exit paths
for services 16h/11h outside the ordinary dispatch path.

## Tasks, in creation order

See [task roles and queue routing](imodem-task-roles.md) for the subsequent
analysis: TOUT is timeout processing, and the other short C tasks mostly
dispatch messages between ISDN protocol layers and modem call control.

Names come from the `TCreate TID_*` strings referenced by the success/error
branches immediately following the creation calls in `4607:000a`.
All nine requests use priority `0x20` and return status zero.

| ID | Firmware name | Entry | First execution, instruction count |
|---|---|---|---|
| 1 | TID_TOUT | `459b:0008` | 657132 |
| 4 | TID_T3L2 | `4678:0009` | 657417 |
| 2 | TID_CES3 | `46e9:0008` | 657702 |
| 3 | TID_S3CE | `45f2:0002` | 657987 |
| 6 | TID_L2S3 | `4692:0005` | 658272 |
| 9 | TID_P3CE | `45fc:000e` | 658557 |
| 5 | TID_LLL2 | `46ae:0000` | 658842 |
| 12 | TID_MODEM | `a400:0008` | 659130 |
| 10 | TID_CEML4 | `46dd:000a` | 2742349 |

For example, `4607:0421` pushes priority 20h, ID 0ch, segment a400h and offset
0008h, then calls the task-creation wrapper at `4607:042b`. The associated
strings are `TCreate TID_MODEM Failure = ` and `TCreate TID_MODEM`.
The task begins by initializing DSP-related state and calls back into other
payload code. Those callbacks do not disqualify it as a task entry.

## Evidence and limits

Run from the repository root:

```sh
.venv/bin/python tools/imodem_vrtx_trace.py \
  --output artifacts/imodem-vrtx-startup/trace.json
```

The probe records image hashes, service counts, register arguments, creation
return codes and first execution of each task. It uses the existing peripheral
model and stops at the instruction limit. This demonstrates startup and task
execution, not complete modem functionality or hardware-accurate timing.
The observed run makes four modeled flash erases and zero program operations.

The real reset vector and boot block remain unavailable. We therefore have
not proved the exact hardware reset handoff, nor a relocation mapping that
would make an assembled flash boot independently. But the stronger previous
claim that VRTX/application startup code must be missing is unsupported:
the payload already contains the chain above. In particular, the lower
payload contains both VRTX and eight of the nine task entries; treating
everything below `80000` as disposable updater code loses required code for
this demonstrated startup path.
