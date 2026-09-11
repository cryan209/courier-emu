# I-modem Ie030002 payload entry points

**Updated:** [the VRTX startup trace](imodem-vrtx-startup.md) now follows
`4030:0000` through kernel initialization and nine running tasks.
The historical "updater" labels below do not imply that this is only an
update program: `a400:0008` is registered as the `TID_MODEM` task entry.

Verified directly from the decoded `Ie030002.xmp` bytes. The flattened
`Ie030002.nac` payload is byte-identical and begins at physical `0x40000`.
Offsets below are in the decoded payload; XMP file offsets add `0x80`.

| Entry | Physical | Payload offset | Purpose / evidence |
|---|---|---|---|
| `4030:0000` | `0x40300` | `0x00300` | Updater initializer; sets DS and stack, clears RAM, initializes hardware, copies data, installs vectors, then far-jumps to `7360:1ec0`. This is the existing emulator entry. |
| `7360:1ec0` | `0x754c0` | `0x354c0` | Updater kernel startup; installs INT 30 at `7360:0000` and INT 31 as a pointer to the descriptor at `98d1:0000`, then invokes INT 30 with AX=30h. |
| `7360:0000` | `0x73600` | `0x33600` | Updater INT 30 service gate, explicitly installed by the preceding startup. |
| `4000:0000` | `0x40000` | `0x00000` | Far-callable debug-service dispatcher, with selector word at physical `0xd0`; preserves DS/general 16-bit registers and returns with RETF. Not a boot entry. |
| `4000:0148` | `0x40148` | `0x00148` | Debug exception handler; installed into vector 1 by dispatcher operation 0. |
| `a400:0008` | `0xa4008` | `0x64008` | Confirmed `TID_MODEM` task entry, created through VRTX service 00; begins with DSP initialization. Requires prior kernel and subsystem setup. |

The debug dispatcher has five identifiable table words at payload offset
`0x1b`: `0025`, `005b`, `0097`, `00d2`, `010d`. Operation 0 saves the old INT 1
vector, clears DR0–DR3 and DR7, and installs its handler. Operations 1–4 write
DR0–DR3 respectively. These are internal branches sharing the dispatcher's
saved stack, not independently callable functions. The range check actually
allows doubled index `0x0a`, one word beyond those five entries; do not assume
that selector 5 is a valid service.

## The NAC start record is not a verified executable entry

The NAC type 03 record names `0ce0:0000` (physical `0xce00`). The updater copies
`0x41c0` bytes from physical `0x98d50` to that RAM address. Those bytes begin
with the text `New entry added`, not a credible startup sequence. Therefore the
record does **not** confirm the far-jump destination `7360:1ec0`, despite the
older comment in `courier_emu/isdn.py`. Enter through `4030:0000` for the
recovered updater path.

## Supervisor cold start remains unconfirmed

The update payload ends at physical `0xf8000` exclusive. It does not contain
the top 32 KiB boot block or the reset vector at `0xffff0`. The existing
synthetic boot block is an emulator construction, not evidence of the board's
entry. A real boot-block dump would establish the reset handoff; the absence
of that block alone does not prove that the eventual application entry is
absent from the rest of the payload.
