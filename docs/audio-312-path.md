# DSP 3.1.2 audio path: original firmware now produces samples

The connected 20.16 MHz Courier runs supervisor 7.4.16 / DSP 3.1.2.
Its own code generates all 16 DTMF pairs and transfers the samples to the
standard DSP serial transmitter in the component harness. The harness does
not synthesize a sine wave or insert PCM into the firmware's output buffer.

Five flash pages containing the tone selector, oscillator, mixer and serial
ISR were read from the modem and matched the captured 3.1.2 ROM. See
`artifacts/audio-312-01/hardware-firmware-check.json`.

## The path in this firmware

```text
host tag 13, digit index
    -> ee20: select phase increments, install callback 8743
    -> 80d3: call current callback, clear output accumulator in delay slots
    -> 8743/874f: advance two oscillators using sine helper 8b6a
    -> DSP data 03c7: combined tone sample
    -> 80da..80e7: apply gain, clear low codec bits, store interleaved buffer
    -> 8178 ISR: read DRR into input slot, read next (output) buffer slot
    -> 818f: SAMM @21 writes DXR, the standard serial transmit register
```

Tag `13` masks the index to four bits and reads two phase increments from
`ee34 + 2*index`. The phases are data `03c0`/`03c1`; increments are
`03f2`/`03f4`. The amplitudes are `03f3`/`03f5`. Its callback address is stored
in `039a`. Tag `16` replaces that callback with the bare return at `8128`.

The main loop writes an output word next to an input word in the circular
sample area initialized at `0bc0..0bdf`. The serial ISR reads `DRR` at `8182`,
writes the input slot, and loads the adjacent output word before writing
`DXR` at `818f`. It ORs in the secondary-frame request at `006b`; the control
sender at `819e` sends the control word from `006c` instead of a sample.

This is evidence for a serial-codec audio path in **this image**. It does not
prove which board pins carry that serial stream. The `main211` external-I/O
audio path and its runtime counters describe another image and must not be used
to rule this one out - and the reading that an ASIC fronts the codec here has
since lost its support: the ISR at `818d` implements the AC0x secondary-frame
protocol, and reset programs six of the part's control registers. See
[codec-rate-312.md](codec-rate-312.md).

## Why the emulator was silent

Single-stepping the sine helper exposed three instruction errors, corrected
against TI's [TMS320C5x User's Guide, SPRU056D](https://www.ti.com/lit/ug/spru056d/spru056d.pdf):

* `SQRA` and `SQRS` ignored the memory operand and squared stale TREG0. They
  now read the operand, update the temporary registers as specified by TRM,
  and calculate the square after accumulating the previous product
  (sections 6-253 and 6-255).
* `PAC` added the product to ACC instead of replacing ACC, and incorrectly
  affected arithmetic flags (6-193).
* `NORM` did not update TC or handle zero as complete. The sine helper uses
  that flag to choose the sign of the result (6-181).

The disassembler also incorrectly treated `NORM` as two words, swallowing the
following `SQRA` instruction. That decoding is fixed separately.

## Reproducing and listening

```sh
.venv/bin/python -m courier_emu.audio312 \
  --rom artifacts/courier-board-21210-capture-403/courier-board.rom \
  --output /tmp/courier-audio-reproduction
```

The output is `firmware-dtmf.wav` and a JSON manifest with per-digit spectra,
PCM hashes, and serial counters. The saved run in `artifacts/audio-312-01`
contains `123456789*0#ABCD`, with 200 ms per digit and 100 ms silence between.
Every digit has the expected row/column spectral pair. Each 1440-sample tone
executes 1440 DRR reads and 1440 DXR writes at the original firmware sites.
The runner checks each serial output word against the word the original mixer
put in the buffer.

The WAV uses **7200 samples/second**, inferred from the labelled keypad phase
increments: digit 1 uses `18c8` and `2afd`, which correspond to approximately
697 and 1209 Hz at that rate. This is not yet a measurement of the physical
codec clock.

That figure is the **dial path's** rate and must not be read as the board's one
sample rate. It is well founded for this code - DTMF's tight tolerance means no
other plausible rate fits, and the ISR takes one buffer word per codec interrupt,
so while dialing the generator and the codec run at the same number. But this
unit advertises `x2` and `V90`, whose 8000-baud carrier cannot live under
7200 Hz sampling's 3600 Hz Nyquist, and V.34+ at 3429 baud does not fit either.
So the codec rate must change for those modulations, and tag `2c` is a mailbox
command that writes an arbitrary AC01 control register at runtime. See
[codec-rate-312.md](codec-rate-312.md).

The component harness supplies idle RAM, the dial-path gain/amplitude values,
a dummy second callback, and one reusable input/output buffer pair. It invokes
the selector, original main-loop mixer and serial ISR body, stopping before
RETE because it has not entered through a real interrupt. Thus the result
proves sample computation and transport through the firmware, not full boot,
interrupt scheduling, analog levels or completed modem negotiation.

## Physical recording attempt

Asterisk at `root@asterisk.net.cryan.nz` exposes local echo test `9099`.
Two attempts were made from serial `21210`, first with delayed trailing digits,
then with just `ATDT9099;`. Neither produced a `9099` channel on Asterisk before
the bounded timeout. Both were aborted, followed by `ATH` and a successful
`AT`. No recording was started, no PBX configuration was changed, and no other
call was recorded. Transcripts are in `artifacts/audio-312-hardware-01` and
`-02`. Mapping the Courier to its actual gateway port is the outstanding step
before comparing a physical waveform.

## Validation limits

The focused arithmetic, all-digit audio, prior DSP audio/readback/stream and
mailbox tests pass (54 tests). The full suite could not complete: two existing
modules import removed `FIRST`/`RESET` names, and CPU/CLI paths encounter a
Unicorn SIGILL in this environment. An isolated bridge/CLI run passed 29 tests
before stopping on three CLI worker SIGILL failures. These failures prevent a
claim that full-supervisor behavior has been regression-tested.

The earlier `62` query difference remains after the arithmetic corrections:
hardware `0069:0015`, fixture-state emulator `0069:0012`. Audio progress has
not been used to hide that mismatch.
