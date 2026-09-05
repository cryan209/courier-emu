# What the ASIC does

A synthesis of what this repository has established about the `NEC USA
1-016-905` gate array, and of what is still guessed. Each claim says which.

The short version: it is **the entire board outside the two processors**. The
80186 talks to the world through it, the C52 talks to the 80186 through it, and
the line-side parts answer to it. It is not a peripheral among several - on the
CPU's I/O bus it is the only device there is.

## Why "the only device" is a measurement, not a figure of speech

The CPU's own peripheral control block is relocated into *memory* at
`0xff00`-`0xffff`, and flash and SRAM are memory too. So anything that answers
an `IN` is the gate array. Sweeping the space
([asic-port-map.md](asic-port-map.md)) gives its shape:

* only **even** addresses are decoded - all 64 odd ports below `0x80` read
  `0x00`, because the ASIC presents 16-bit registers and `IN AL` reads a byte;
* the decode **stops at `0x7f`** - above it all 64 even ports read back their
  own address and all 64 odd ports read `0x00`, which is an undriven bus.

That is 64 registers, and the firmware uses about half of them.

## The register map, by what the firmware does with each group

Static site counts from `artifacts/io-port-map/board-21210/`, values from the
CPU-side capture in `artifacts/cpu-port-map-01/`. Read/write asymmetry is the
useful signal: a group the firmware only writes is a control surface, one it
only reads is a status surface.

| ports | sites | idle value | what it is |
|---|---|---|---|
| `0a` `0c` `0e` | 5r / 21w | `f7` `40`/`60` `07` | configuration; `0e` is write-only |
| `10` `12` `14` | 20r / 34w | `86` `8a` `7e` | **board latches** - hook relay, NVRAM strobe, carrier-detect pair, ring detect, option straps |
| `18` `1a` `1c` `1e` | 104r / 137w | `ff` `ff` `fd` `ff` | **the handshake** - busiest group by far; `1c`/`1e` are the mailbox status pair |
| `40`-`4e` | 20r / 45w | `55`/`00` alternating | **the DSP download window** - eight latches |
| `50`-`56` | 9r / 8w | `55`/`00` alternating | second window bank |
| `58` `5a` / `5c` `5e` | 68r / 44w | `20` `00` / `0e` `00` | **the mailbox** - tag pair and data pair |
| `60` `62` | **27r / 0w** | `4b` `00` | **DSP-to-host stream** - pure input |
| `64`-`7e` | 3r / 0w | `78 09 8f a7 e8 aa b6 97 51 51 06 4f b3` | read almost never; looks like identity or strapping |

Two of those rows carry their own argument. `60`/`62` has **zero** write sites
in the whole image, so it is a one-way channel out of the DSP. And ten of the
thirteen values in `64`-`7e` are byte-identical to a sweep taken when this unit
ran stock 7.3.14 instead of ID_SDL 4.03 - the same values across two firmware
versions and two sessions, which is what fixed configuration looks like rather
than state.

## The four jobs

### 1. It is the board's I/O

Ports `0x10`, `0x12` and `0x14` are latches carrying the hook relay, the NVRAM
chip strobe, the carrier-detect pair, ring detect and the option straps. The
supervisor drives every one of them through a single read-modify-write latch
driver (`panel.py` records it at physical `0x5e2b0`/`0x5e2e5`), which is why
these ports are both read and written. Nothing here is subtle; it is the front
panel and the line relay.

### 2. It bootstraps the DSP

The C52's program memory is **RAM**, not mask ROM: the supervisor's own
download stream matches the flash image's origin-`0x0000` segment byte for
byte, all 30,172 words - `bootstrap_match: true` at `bootstrap_bytes: 60344` in
every answered-call run. That covers program `0000..0fff`, the whole window a
C52's internal ROM would occupy, so the part runs in microprocessor mode and the
mask ROM is not what executes
([hardware-timebase-and-audio-path.md](hardware-timebase-and-audio-path.md)).

The transfer goes through `0x40`-`0x4e`, strobed thousands of times while the
C52 is held in reset. So the ASIC is what holds the DSP in reset and writes its
program RAM - the architectural alternative
[dsp-rom-probe.md](dsp-rom-probe.md) raised and could not choose, now settled by
the download stream.

### 3. It is the mailbox between the two processors

An outbound message is a 16-bit tag on `0x58`/`0x5a` and a value on
`0x5c`/`0x5e`, committed by answering the board's standing request - writing
bit 0 back to `0x1c`. On the far side the DSP's dispatcher reads the tag from
its own data cell `0xff5e` and the word from `0xff5f`, rejects tags above
`0x7f`, and branches through a 121-entry jump table.

So the ASIC bridges *CPU I/O ports* to *DSP data-memory cells*. Two address
spaces that have nothing to do with each other are joined inside it, and that
is the single most important thing it does for the emulator, because it is the
only path by which the supervisor and the datapump can say anything to one
another.

The reverse direction is `0x60`/`0x62`, the read-only window, driven by the
DSP's sender one word per interrupt and resumed by the CPU acknowledging bit 2
of `0x1c`.

### 4. It fronts the analogue side - and this is the part that is missing

Three things the firmware demonstrably does *not* do, which therefore belong to
the ASIC:

* **The codec bring-up.** The datasheet initialisation sequence is performed by
  neither processor: the 80186 writes `0x40`-`0x4e` thousands of times and
  never reads them, and the C52's own external reads are the host window and
  the line ADC, so neither can see the readiness byte the sequence waits on.
* **The line detector.** The supervisor counts its own five qualifying hits at
  `[0x649]`, but the reading it counts arrives from outside; the harness has to
  answer the `0x7c` poll by hand.
**Not the tone generator, though this document first said so.** The README's
"the tone generator is the ASIC's" does not survive checking. Dialling a digit
sends `0x16:0000`, three constant lanes `0x19:020d`, `0x1a:3000`, `0x1b:0c08`,
the keypad index on `0x13`, then `0x16:0000` when the tone ends - and those
three lanes are host-write tags whose handlers store into **DSP data memory**,
at `0x03ad`, `0x0392` and `0x03f1`. The tone parameters go to the C52, so the
synthesiser is the datapump's. What `--exchange` hears silence from is the
harness's C52 not reaching that code, not a generator living somewhere
unmodelled.

The tones themselves, from the firmware's own dial path:

| tone | where it is decided |
|---|---|
| DTMF, all 16 keys | `0x6353c` maps characters to keypad indices: `0`-`9` pass through, `#` to `0x0a`, `*` to `0x0b`, `A`-`D` to `0x0c`-`0x0f` |
| tone duration | S11, held at `[0x8e9]` by the countdown at `0x82342` |
| interdigit gap | the same countdown less `0x30`, at `0x8235b` |
| pulse dialling | `0x822a3`, a break/make loop - no tone at all |

and the call-progress tones it has to *recognise* rather than emit, which
`exchange.py` models: dial tone 350+440, ringback 440+480, busy and reorder
480+620, answer tone 2100.

There is a fourth, smaller one: the DAA's identity reaches the supervisor as
mailbox tag `0x7b`, once. The firmware is not blind to the line-interface part,
it is *told* about it - by the ASIC.

## What it is not

**Not the timebase.** The 5.000 ms tick is the 80186's own Timer 0 - max count
25,200 at CLKOUT/4 with a 40.320 MHz oscillator - confirmed four independent
ways, including by a counter routine run on the modem that logged exactly 200.0
increments a second.

**Not in the CPU's audio path.** Sweeping every port during analogue loopback,
only the four handshake registers move; no CPU port carries samples. Where
audio goes on the *DSP* side is still open - the DSP polls `DRR`, `TRCV` and
its own ASIC ports together, and never transmits on either serial port after
reset.

## What is still unknown

* **Its behaviour is unpublished.** Everything above is inferred from the two
  processors' traffic. There is no datasheet, and `1-016-905` is a USR part
  number, so there is unlikely ever to be one.
* **The pin connections are not traced.** "It is the only device on the I/O
  bus" is an argument from the memory map and from there being no other
  candidate, not from a probe on a pin.
* **The monitor lies about the download window.** `ATGLK2I` and the CPU's own
  `IN` agree on 51 of 64 ports and disagree on all twelve of `0x40`-`0x56`,
  with the pairing inverted (`artifacts/cpu-port-map-01/`). Anything about the
  window that rests on the monitor sweep needs re-taking.
* **`0a`, `0c`, `0e` and the `64`-`7e` block are unattributed.** The second
  looks like identity, but nothing has been shown to read it for that purpose -
  there are only three read sites in the whole image.
* **The dynamics are barely sampled.** A tick-rate sampler now exists and sees
  events the serial monitor cannot, but 200 Hz is still slow against a codec
  frame, and the only capture so far is one line seizure.
