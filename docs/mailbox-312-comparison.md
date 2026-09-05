# Connected-board DSP 3.1.2 mailbox comparison

On 2026-09-05 the modem on `/dev/cu.usbserial-21210` at 115200 baud
identified as ID_SDL 4.03d, supervisor 7.4.16 / DSP 3.1.2, 20.16 MHz,
512 KiB flash. Seven flash pages covering the dispatcher, query handlers,
and tone selector matched the existing `courier-board-21210-capture-403`
image byte for byte. Evidence is in
`artifacts/dsp-mailbox-312-comparison-01/`, including the raw command
transcript, hardware manifest, flash-page verification, and emulator report.
The modem answered `AT` after both sessions.

## Hardware versus original DSP code

The live sequence was `07, 2d, 62, 07`, each with data zero, using the
existing mailbox commit protocol. No dialing or firmware upload was needed.

| Command | Hardware tag:value | Emulator tag:value |
|---|---|---|
| 07 | 0031:0000 | 0031:0000 |
| 2d (no-op) | retains 0031:0000 | retains 0031:0000 |
| 62 | 0069:0015 | 0069:0012 |
| 07 | 0031:0000 | 0031:0000 |

`courier_emu.mailbox_compare` runs the actual 3.1.2 dispatcher at `8387`
and sender at `83bf`, including its real accessor at `80e8`. A small test
caller enters those routines with fixture queue pointers `ff50` and
otherwise default RAM. This is a component comparison, not a full modem boot.
It does not inject the expected reply into the DSP.

The first run with plain I/O-register storage produced no reply: the
dispatcher's write of `1` to DSP status `57` replaced the status value `3`,
losing bit 1 that the sender checks before emitting. A test-side ASIC adapter
that clears acknowledged bits while preserving the others allows both real
firmware routines to complete. The DSP writes reply tag to port `5e`, data
to `5f`, and acknowledges with `57:0002`. On the CPU side those words appear
at the byte pairs `58/5a` and `5c/5e`.

This establishes a useful minimal handshake model for these transactions.
It does not establish all status bits, physical interrupt latency, or prove
that every write to the ASIC is write-one-to-clear. The adapter is confined
to the comparison runner; it is not globally imposed on other board profiles.

The `62` difference remains visible deliberately. Its handler processes sample
RAM and prior DSP state; the emulator has neither a hardware sample snapshot
nor complete initialization. State differences and arithmetic emulation remain
possible causes. Matching the reply tag alone is not a value match.

Reproduce offline:

```sh
.venv/bin/python -m courier_emu.mailbox_compare \
  --rom artifacts/courier-board-21210-capture-403/courier-board.rom \
  --capture artifacts/dsp-mailbox-312-comparison-01/manifest.json \
  --output /tmp/courier-mailbox-comparison.json
```

## The firmware-version error and the tone path

The 3.1.2 dispatcher computes its table base as `8468 - 007f = 83e9`.
The older DSP 3.0.13 uses `8401`. Addresses and no-op assumptions cannot be
carried across unchanged:

* `0b` now enters real code at `ec63`; it is not a null control.
* `2d` still points to a bare return. The serial probe now defaults to this
  shared no-op and rejects old-profile commands before any port writes.
* `13` enters `ee20`, masks the host word to four bits, doubles it, and reads
  a coefficient pair from program `ee34 + 2 * index`. It installs callback
  `8743` in DSP data `039a`, initializes phase/state, and returns.
* `19`, `1a`, and `1b` still store to DSP data `03ad`, `0392`, and `03f1`.
  Tag `1a` additionally writes `fff0`; these are not interchangeable generic
  RAM-write commands.
* `16` installs callback `8128` in `039a`. It should not be described as an
  unconditional start command based solely on where the supervisor sends it.

The tone selector is present in this board's captured resident download; no
missing overlay is needed to explain its handler address. This finding is
specific to DSP 3.1.2 and does not resolve `main211`'s overlays. Generating or
hearing a waveform still requires executing the callback with the right frame
context and tracing its output to the codec. No tone command was sent live.

The next bounded experiment is to run that callback under controlled DSP
frame conditions, then compare a captured hardware tone. The present mailbox
comparison supplies a verified entry path and records where equivalence ends.
