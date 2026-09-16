# Quad server answer bring-up (2026-09-11, remeasured 2026-09-17)

The QF server is **not yet a negotiation peer**. A fresh controller boot,
CPU-streamed DSP resident and `ATQ0V1` / `ATA` no longer abort the answer, but
no runtime overlay request occurs and the transmitted timeslot is a stuck DC
rail. This does not test V.8 interoperability. The sections below are dated:
the 2026-09-11 blocker no longer reproduces - see the 2026-09-17 section.

Run from the repository root:

```sh
PYTHONPATH=. .venv/bin/python tools/probe_quad_c50_live.py \
  --archive docs/x2/Qf060003.zip --digital-call --law mu \
  --command ATA --instructions 12000000 \
  --output /tmp/quad-server
```

The report includes command input, terminal output, call setup and abort
traces, writes to call flags, DSP boot/PCM state and overlay counters.
`current-dsp-tx.g711` contains only the current DSP instance's output; a CPU
reset discards previous samples, so an empty final capture is not proof that
no earlier frames occurred. The byte-terminal autobaud adapter and existing
Courier NVRAM seed remain harness assumptions. `--law` selects wire idle fill;
it does not program the firmware's companding-law setting.

## Corrected startup ordering

Previously `connect_digital_call` enabled DS0 framing immediately upon creating
the core, while the recovered ROM was still downloading 16-bit words through
DRR. The endpoint now buffers incoming octets until the boot queue is empty
and execution has reached resident program space. It then enables the digital
frame clock. Reset clears the active PCM state and the old core's I/O cursor.

The regression executes the real ROM against a padded test resident, verifies
that no frames occur during download, and checks its transmitted codeword
after handoff. This fixes the boot/PCM boundary; it does **not** establish that
the stock resident has all overlays and interrupt targets needed for a call.
(The escape into low program addresses recorded here no longer happens; the
2026-09-17 section has the measurement.)

## The answer abort is gone; the call now stalls silent (2026-09-17)

Re-measured with the same command line above, 12M instructions, against
`artifacts/quad-server-bringup-20260911/fresh-ata.json`:

| | 2026-09-11 | 2026-09-17 |
| --- | --- | --- |
| terminal | `OK` / `NO CARRIER` | `OK`, then ATA still up at the limit |
| DSP downloads / reboots | 23 / 22 | 2 / 1 |
| `[82fe]` bit 7 | set at `f35a3` | never set; two writes, both zeroing |
| DSP exchanges | none | 7 commands sent and acked, 1 reply posted |
| PCM | inactive, 0 bytes TX | active, 49,194 G.711 bytes |
| DSP pc at the limit | low program space | `0x82eb`, in the resident, IDLE |

`ATA` still reaches `c7cfc` and `c7d3f`, but the three unserviced checks at
`c0b69` no longer happen, so nothing sets `[82fe]` bit 7 and the answer path at
`efc84` no longer exits via `efc9c`. The resident also stays in program space
instead of escaping low - the signature of the delay-slot interrupt bug fixed
in 20133c6, whose orphaned stack pushes made `RETD` pop a stale address.

Attribution is joint, not settled: four quad-side commits landed after the
baseline (`19313a0` C51 boot ROM and split SARAM, `6369173` deferring PCM to
boot completion, `c8b4195`, `df5d709`), and the old report has no
`commands_sent` / `replies_posted` fields at all, so part of the exchange is
new code rather than a freed path. Splitting it needs a run with 20133c6
reverted.

## What still blocks a connection

`runtime_bursts` is 0. No runtime overlay is requested, so no answer overlay is
selected.

**It produces no audio.** 49,166 of the 49,194 captured bytes are codeword
`0x00`, which in mu-law is full-scale negative (-8031), not silence - a stuck DC
rail for 6.15 s. `dxr_writes` is 24,606 while DXR reads back 0 and
`line_tx_nonzero` is 0: the timeslot is clocked and the same word goes out every
frame. The part is running and framed; nothing is modulating.

Next question is why the resident parks at `0x82eb` without requesting an
overlay, given the CPU exchange it now answers.
