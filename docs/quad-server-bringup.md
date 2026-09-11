# Quad server answer bring-up (2026-09-11)

The QF server is **not yet a negotiation peer**. A fresh controller boot,
CPU-streamed DSP resident and `ATQ0V1` / `ATA` reproduce `OK` / `NO CARRIER`.
No runtime overlay request occurs. This does not test V.8 interoperability.

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
The stock resident still escapes into low program addresses with PCM enabled.

## Measured immediate call blocker

`ATA` reaches call setup at `c7cfc` and the accepted branch at `c7d3f`.
`c7d7b` is a common return, not evidence of rejection (the probe label has
been corrected). Setup clears `[82fe]` at `c7d5e`.

The periodic handler at `c0b45` checks the DSP-transfer flag `[9d3e]` and
exchange counter `[81cd]`. Three unserviced checks take `c0b69`, calling
`f226:133e` (`f359e`) with `AL=0` while `[8311]` bit 0 is set. This routine
sets `[82fe]` bit 7 at `f35a3`; the handler then requests a DSP reload at
`c0b6e`. The answer path sees that bit at `efc84` and exits via `efc9c`.

The earlier description of these reloads as harmless idle behavior in
`quad-bringup-blockers.md` is incomplete: they also abort an answer attempt.
The fresh 12M-instruction run records 22 completed DSP downloads, 22 reboots,
and zero runtime overlay bursts. Merely enabling PCM or waiting longer does
not fix this. `AT&D0` and `AT%D1` are accepted but also fail to produce an
overlay request in the tested command sequence.

Next work is the normal CPU/DSP command and response service that satisfies
this watchdog and selects an answer overlay. Disabling the watchdog or forcing
its RAM flags would conceal that missing mechanism. Stock resident interrupt
execution must also be validated before connecting the analog client.

Evidence: `artifacts/quad-server-bringup-20260911/fresh-ata.json` and
`abort-trace.json`. The Quad controller, receive, terminal, digital PCM and
stock-audio regression suites pass together (22 tests).
