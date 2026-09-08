# How the DSP and the ASIC/CPU are connected

**Update, 2026-09-07:** fresh board probes explain and fix the NDX/PA7 interaction.
See [the board comparison and corrections](dsp-mailbox-board-fix.md). The older
ARCR/INDX blocker conclusions below are historical and superseded.

A synthesis aimed at one question: what is the path by which the 80186
supervisor and the C5x datapump say anything to each other. It separates what
is hardware-proven from what is inferred, and it retracts one claim that has
been steering the debugging in the wrong direction.

**The short version.** A *logical* path is proven: on the live board a kernel
running on the DSP wrote its I/O ports `0x5e`/`0x5f` and 2048 words arrived at
the 80186. The *physical* arrangement is now settled too, and it
is the obvious one: the ASIC is on the DSP's 16 data pins, and `IS` - the
I/O-space strobe, which nothing but an `IN`, an `OUT` or a `PA0`-`PA15` access
asserts - is connected to it. So the ASIC decodes the DSP's I/O cycles across
the bus the SRAMs already sit on, and the serial reading is retired. See "The
physical objection, resolved" below.

## The proven part

The evidence is `artifacts/dsp-onchip-rom-01/`, and **only** that one - "read
from the DSP of a live Courier", 20.16 MHz board, ID_SDL v4.03d, 2026-09-07. A
kernel placed in supervisor RAM with `ATGLK2W` and started from Timer 0's
interrupt ran at DSP program `0x8000`, read the on-chip ROM with `RPT`/`TBLR`,
and returned 2048 words. Its sender is the resident's own outbound pattern, and
in `build_rom_dump_probe` that is literally `out @7c, 0x005e` / `out *+,
0x005f` / `2 -> @57`. The returned image has a plausible reset vector
(`0000: b 0670`), 1307 distinct values, and two independent runs agree.

So **the DSP's I/O-space writes reach the 80186 on the real board.** That much
is measured.

The ROM came off the board **in two halves**, because the watchdog resets it
before a 2048-word frame can finish. The two real captures are
`artifacts/dsp-onchip-rom-01/half0-frame.txt` and `half1-frame.txt`, and
`dsp-onchip-rom-01/manifest.json` records how they were joined.

> **Mind which directory you cite.** The top-level `dsp-rom-half0/`,
> `dsp-rom-half1/`, `dsp-rom-dump-v*`, `dsp-rom-transport-v*` and
> `dsp-rom-sample-v1` directories are the **emulator dry-runs** of the same
> kernel: they carry `hardware_tested: false` and their `serial_text` is a
> synthetic ramp (`0x1234 + 0x193n`). The hardware captures of the two halves
> live *inside* `dsp-onchip-rom-01/`, and begin `7980 0670 0860 BE20` - real
> code, not a ramp. Two earlier versions of this document got this wrong in
> both directions: first citing a dry-run as the proof, then concluding from
> the same flag that no half-dump was ever taken on hardware. Both were wrong;
> the dry-runs and the real runs simply share a kernel and a naming scheme.
>
> `artifacts/dsp-boot-word-01/` is real hardware but does not prove this
> either: its kernel is placed and started the same way, and it establishes
> what the ASIC presents at DSP data `0xffff`, not the return path.

The three windows, from `artifacts/io-port-map/board-21210/` and
`artifacts/cpu-port-map-01/`:

| direction | 80186 side | C5x side | commit/resume |
|---|---|---|---|
| CPU → DSP | tag `0x58`/`0x5a`, data `0x5c`/`0x5e` | tag `PA14` (`0x5e`), data `PA15` (`0x5f`) | CPU writes bit 0 of `0x1c`; DSP acks by writing 1 to `PA7` |
| DSP → CPU | `0x60`/`0x62`, **27 reads / 0 writes** in the whole image | the sender, one word per interrupt | CPU acks bit 2 of `0x1c` |
| download | `0x40`-`0x4e`, eight latches | program RAM, DSP held in reset | no "go" - releasing reset is the go |
| status | `0x1c`/`0x1e` | `PA7` (`0x57`) | bit 0 host message pending, bit 9 gates `0x80f8` |

On the DSP side the dispatcher reads the tag, rejects tags above `0x7f`, and
branches through a 121-entry jump table. `PA0`-`PA15` are not a peripheral
block and not reserved space: SPRU056D section 3.5.11 and Table 8-8 make DSP
data `0x0050`-`0x005F` the sixteen I/O ports, reachable both by ordinary data
addressing and by `IN`/`OUT`. **The ASIC is the device on the other side of
them.**

### Why a board inspection sees no parallel traces

The objection that stalled this - a board inspection reporting no traces from
the DSP's address/data pins to anything but its two `CY7C199` SRAMs - is
weakened by the following, but **not** disposed of by it. See "The physical
objection".

SPRU056D Table A-8 gives `DS`, `PS` and `IS` as three *space-select strobes*
sharing **one** address/data bus: "Data, program, and I/O space select signals.
Always high unless low level is asserted for communicating to a particular
external space." So an I/O cycle drives the same address and data pins as a
data cycle, distinguished only by which strobe goes low.

So an I/O port on the C5x is not a separate parallel port with its own pins.
If the ASIC is on that bus at all, it is tapped onto the *same nets* that run
from the DSP to its SRAMs, qualified by `IS`. That removes one form of the
objection - nobody should be looking for a second, dedicated 32-wire bus - but
it does not remove the objection itself.

## What this does and does not block

Worth separating, because it has been costing time. **The physical medium is
not on the emulator's critical path.**

The harness never simulates traces. It simulates what `out @7c, 0x5e` does on
one side and what `in al, 0x5c` returns on the other, and that programming
model is confirmed twice over: SPRU056D section 3.5.11 and the Table 8-8 note
put the sixteen I/O ports `PA0`-`PA15` at data `0050h`-`005Fh`, reachable by
data addressing, MMR addressing and `IN`/`OUT` alike; and the on-chip ROM came
back off the live board through exactly that protocol - poll `PA7` bit 1, tag
to `PA14`, word to `PA15`, `2` back to `PA7` - which is the protocol
`bridge.py` already implements.

So whether the ASIC realises those sixteen ports with twenty parallel taps, a
shift register, or something else entirely, **both processors' instruction
streams see the same thing, and the emulator is already right about it.**
Settling the medium is worth doing for the board documentation. It will not
change a line of code, and it is not what stops a call.

What stops CPU-DSP comms in the harness is the *rate*: the DSP's mailbox poll
is gated behind the `ARCR` compare, so delivered messages overwrite each other
unconsumed. That is the blocker, and it is in
[what-runs-and-what-blocks.md](what-runs-and-what-blocks.md).

## The channel discipline is a single-word window with ready/ack

This is the part that can be settled from the firmware, and both sides now
agree on it. **Every DSP-CPU transfer in this firmware moves one word and then
stops for an acknowledgement.** Nothing anywhere does a block transfer.

**DSP side, the mailbox sender** (`0x83eb`):

```
83eb  0c7d 005e      out  @7d, 005e     ; tag
83ee  0c7d 005f      out  @7d, 005f     ; word
...            lacl #02 ; samm @57      ; raise "message ready"
```

**DSP side, the stream sender** (`0x84b7`) - and this one is a *coroutine*:

```
8499  ae80 849f      splk *, #849f      ; where to resume next time
849b  7d80 84b7      bd   84b7, *
849d  bf09 0385      lar  ar1, #0385    ; ...the source for *this* word
...
84b7  0c80 0060      out  *, 0060       ; exactly one word
84b9  ff00           retd
84ba  b904           lacl #04
84bb  8857           samm @57           ; raise "stream ready", and return
```

Each resume point (`0x8499`, `0x849f`, `0x84a5`, `0x84ab`, `0x84b1`) sends one
more word from a different address and yields again. The resume poll at
`0x8462` tests bit 13 - by the `bit` inversion, **bit 2** - before continuing.

**CPU side, the stream reader** (`0x1fec`), which is the mirror image:

```
001fec  e462         in   al, 0x62      ; high byte
001fee  8ae0         mov  ah, al
001ff0  e460         in   al, 0x60      ; low byte
001ff2  8987d502     mov  [bx+0x2d5], ax
001ff6  80eb02       sub  bl, 2
001ff9  7805         js   0x2000        ; ...done
001ffb  881ed102     mov  [0x2d1], bl
001fff  c3           ret                 ; one word per call
```

It assembles **one** 16-bit word from two byte reads, stores it, steps a
counter, and returns; `[0x2d3]` holds the address to resume at, so the whole
receiver is a state machine re-entered once per acknowledgement. A second
variant at `0x2037` does the same into a pointer at `[0x8a2]` with a length
counter at `[0x8a0]`/`[0x8a1]`.

So the ASIC presents a **one-word holding register with ready/ack flow
control**, in both directions, and the CPU's `0x60`/`0x62` window has 27 read
sites and **zero** write sites in the whole image.

### What that does and does not prove

It **rules out** shared memory or any random-access window between the two
processors. There is no buffer either side can index into; there is one word in
flight, and a handshake per word. That is what a serial link looks like from
software, and it is consistent with the board.

It does **not**, on its own, exclude a narrow parallel mailbox register, which
would need the same discipline for the same reason. Stating it as proof of a
serial medium would be the third over-reading in this document's history, so it
is not stated that way here. What is fair to say: **nothing in the firmware
contradicts a serial link, and the thing that was previously taken to
contradict it does not.**

That thing was "the DSP has a wide parallel window". It does not. The DSP's
entire I/O footprint is eight ports, touched one word at a time:

| port | use |
|---|---|
| `0x5e` / `0x5f` | mailbox tag and word (`out`, `0x83eb`) |
| `0x60` | the stream sender (`out`, `0x84b7`) |
| `0x68`-`0x6c` | written at reset (`0x8048`-`0x8056`) and in the ISR region |
| `0x57` (`PA7`) | the status latch, read by `lamm` from `0xff57` |

The wide window at `0x40`-`0x4e` is on the **CPU** side only. Note also that
`0x60` and `0x68`-`0x6c` are **outside** `PA0`-`PA15` (`0x50`-`0x5f`), so
[what-the-asic-does.md](what-the-asic-does.md)'s "the ASIC presents at most
sixteen 16-bit registers to the DSP" is too narrow - those are ordinary I/O
addresses that happen not to alias into data space.

## If the link is serial, it is the *primary* port, not the second one

The natural guess - the C50 has two serial ports, one is the codec's, so the
other is the ASIC's - does not survive the firmware. The second port cannot
carry the interprocessor link **in either direction**.

**It cannot carry CPU to DSP.** That would need the DSP to read `TRCV`, and it
never does:

* `IMR` is written exactly once, at `0x809e`, with `0x002a`. `TRNT` is bit 6 and
  `TXNT` bit 7; neither is enabled anywhere in the 27,710-word resident, so an
  arriving word cannot interrupt.
* `TSPC` is touched exactly twice through MMR addressing, both at reset
  (`samm @32` at `0x808a` and `0x808c`), and never read - so `RRDY` is never
  polled either.
* `TRCV` is never read through MMR addressing anywhere.
* The one direct-addressed candidate, `lacl @30` at `0xaa4b`, is scratch on a
  non-zero data page, and this is now checked rather than asserted: its helper
  at `0xaa68` **writes** `@30`-`@33` (`sacl @30`, `sach @31`, `sacl @32`,
  `sach @33`) as a 64-bit rotate. Under `DP = 0` that would be storing to
  read-only `TRCV` and rewriting `TSPC` inside a shift loop. It is not the TDM
  block. (The surrounding `0xaa14`-`0xaa21` is a symmetric coefficient table
  disassembled as code.)

**It does not carry DSP to CPU either.** Both senders use `OUT`, not `TDXR`:
the mailbox at `0x83eb` writes ports `0x5e`/`0x5f`, and the stream coroutine at
`0x84b7` writes port `0x60`.

What the second port actually does is stream one way, constantly: the idle task
at `0x81b7` packs two scaled bytes out of data `0x0302`/`0x0303` and writes
`TDXR` every pass. Several routines re-point it at the same pair (`0xaa34`,
`0xab50`, `0xc594`, `0xceff`), so *what* it streams is mode-dependent. That is a
data sink, not a command channel, and its far end is still unidentified.

Note also that the 'C5x's ports are **synchronous** - `CLKX`/`FSX`, not a
start/stop UART - so nothing here would be a 16550. The ASIC end would be a
shift register in the gate array. And on the second port the **DSP** is the
master (`TSPC = 0x00f8`, `MCM = 1`, `TXM = 1`), so it would be clocked by the
DSP, not by the ASIC.

### Which leaves the primary port, and one pin decides it

On the primary port the DSP is a **slave**: `SPC = 0x40c8`, `MCM = 0` so `CLKX`
is an input, `TXM = 0` so `FSX` is an input. Something else drives that bus.

If that something is the AC01 in stand-alone/master mode, the ASIC is not on
the serial link at all. If the AC01 is instead in **codec/slave** mode, then it
is not driving the clock either, and the only remaining candidate is the ASIC -
which would make the primary serial port the CPU-to-DSP path, with the ASIC's
words arriving at `DRR` and landing in the ring at `0x0bd0` that the main loop
walks. That reading is consistent with the board being serial, and it would tie
the interconnect to the `ARCR` ring gate that is the live blocker.

The firmware **cannot** decide between those two, for the reason set out above:
the role is the `M/S` **pin**, not a register bit, and free-run does not imply
it. So this is one measurement, on an accessible package pin:

> **Probe `M/S` on the TLC320AC01CFN: pin 18 of the FN (PLCC) package**
> (datasheet terminal table, whose numbers are for the FN package; `MCLK` is
> pin 14 and `PWR DWN` pin 2 on the same numbering).
>
> * **High** - the AC01 is master. It clocks the primary bus, the ASIC is not
>   on it, and the interprocessor link is elsewhere.
> * **Low** - the AC01 is a slave. Neither it nor the DSP drives `SCLK`/`FS`,
>   so a third device does, and the ASIC is the only candidate on that bus.

That single reading settles the retraction recorded above, decides whether the
`0x0bd0` ring is a codec buffer or the inbound command stream, and does it
without tracing anything.

## The physical objection, resolved

The count still has to work. To capture `out` to `PA14`/`PA15` and answer reads
of `PA7`, the ASIC needs the DSP's **16 data lines**, enough address to
separate the ports (~4), and `IS` plus the read/write strobes: roughly **20-23
connections**, not 32, and all of them taps onto nets that already exist. But
they must still physically reach the ASIC.

If the board genuinely has no such connection - the reported inspection - then
one of these is true, and this document cannot say which:

1. **The taps exist and were missed.** The nets are shared with the SRAMs, and
   the ASIC may sit physically between or beside the DSP and its RAMs, so
   "traces go from the DSP to its RAMs" and "the ASIC is on those nets" look
   the same from above. This is a continuity question, not a visual one.
2. **I/O cycles alias into the shared RAM.** This is the hypothesis
   `build_io_alias_probe` in `courier_emu/dsp_probe.py` was written to test, and
   it fits the inspection best: if an `out` lands in the DSP's external RAM, and
   the ASIC can already read that RAM - which it must, to load 30,172 words of
   program into it - then the mailbox needs **no** I/O-specific wiring at all.
   The probe writes one port and reads it back six ways, including from
   external RAM at data `0x8053`. It is built but not wired to the CLI and has
   never been run.
3. **The return path is not what the kernel's code says.** Least likely - the
   sender is three instructions - but it has not been independently checked.

Reading 2 would also reconcile the boot observation cleanly: the DSP could boot
by **serial** download (its ROM loader, on the primary port) and still reach the
supervisor at runtime through RAM-aliased I/O cycles. Serial boot and a working
mailbox are not mutually exclusive.

**The decider is cheap and does not need the emulator:** run the I/O-alias
probe on the board, or put a meter on the ASIC's pins against the DSP's data
bus and `IS`.

### The data bus does reach the ASIC (2026-09-07)

A board observation reports the DSP connected to the ASIC across its **16 data
pins**. That chooses **reading 1** over the serial hypothesis, and it does so
by removing the premise the serial reading rested on: the earlier inspection
saw traces going only to the two `CY7C199`s, and that is what "the mailbox
cannot be parallel" was built from. If the ASIC is on the data bus, nothing in
this document needs a serial medium any more.

The shape fits. The SRAMs split the bus `D0`-`D7` / `D8`-`D15` - see
[dsp-map-302.md](dsp-map-302.md) on the 32Kx8 parts - so a device on all
sixteen is not hanging off one RAM, it is on the DSP's bus proper, which is
exactly the "between or beside the DSP and its RAMs" arrangement reading 1
predicts.

**Two things this does not do.**

* **It does not separate reading 1 from reading 2.** Both put the ASIC on the
  same sixteen wires. In reading 1 the ASIC decodes the I/O cycle; in reading 2
  it is only watching the memory bus and an `out` lands in RAM it can already
  read. The data pins are common to both, so they cannot choose between them.
  The discriminator is unchanged and is a single pin: **`IS`, pin 90** - see
  [dsp-pin-probes.md](dsp-pin-probes.md). `IS` at the ASIC means it decodes
  `OUT`, and `PA0`-`PA15` are ASIC registers; `IS` going nowhere near it means
  the alias reading, and the mailbox needs no I/O-specific wiring at all.
* **It is not yet anchored to numbered pins.** This repository has no
  `D0`-`D15` pin numbers from SPRU056D Table A-4; every other pin claim here is
  anchored, and this one is not. Anchor it before treating it as established -
  the same caution that the M/S pin numbering needed.

And the method carries the same caveat as the inspection it overturns: seen
from above, a net that passes near the ASIC and a net that lands on it look
alike. Continuity to the ASIC's pins is the reading that counts, in both
directions.

**Follow-up meter readings, cheapest first:** `IS` (90) to the ASIC; then
enough address lines to separate the ports (~4); then `R/W` (92) and `STRB`
(93). Neighbours for orientation on that edge: `DS` 89, `PS` 91.

### `IS` is connected to the ASIC (2026-09-07)

A meter on **pin 90** reports continuity to the ASIC. That closes the question
this document has carried through three revisions.

`IS` has exactly one purpose. SPRU056D Table A-8 gives `DS`, `PS` and `IS` as
three space-select strobes sharing one address/data bus, each "always high
unless low level is asserted for communicating to a particular external space",
and the SRAMs need only `DS` and `PS`. So `IS` goes low for an `IN`, an `OUT`,
or an access to `PA0`-`PA15`, and nothing else. A device wired to it is wired
to it in order to decode the DSP's I/O cycles; there is no other reason for
that net to exist.

**So reading 1 is correct.** The ASIC sits on the nets that run from the DSP to
its two `CY7C199`s, qualified by `IS`, and `PA0`-`PA15` are real ASIC
registers. `out @7d, 0x5e` is a parallel write into a hardware register on the
gate array, and the poll of `PA7` is a parallel read back out of one.

**What that retires:**

* **The serial medium.** Not merely unsupported now - unnecessary. Every
  statement in this document hedged as "nothing in the firmware contradicts a
  serial link" can be dropped rather than defended.
* **Reading 2, the RAM alias.** Its whole appeal was that it needed no
  I/O-specific wiring. There is I/O-specific wiring. `build_io_alias_probe` in
  `courier_emu/dsp_probe.py` no longer has a question to answer - it is still
  unwired and unrun, and can stay that way.
* **Reading 3, the return path being other than what the kernel's code says.**
  It was already the least likely, and it was only ever needed to explain how
  three `out` instructions reached the CPU if the bus did not carry them.

**What it does not settle**, and these are now the open ones:

* **How much address the ASIC has.** Answered: `A0`-`A3` (55-58) **and `A5`**
  (60), with `A4` (59) absent. See "The decode is five lines" below - this is
  no longer an open item, and it settles the alias question it was raised for.
* **Whether the ASIC also answers `DS`.** `artifacts/dsp-boot-word-01/` has the
  ASIC presenting `0x0083` at DSP **data** `0xffff`, which is a `DS` cycle, not
  an `IS` one. With the gate array confirmed on the bus that reading is easier
  to believe than it was - but an SRAM with `/CE` tied low would answer the
  same cycle, so it is not yet the ASIC's word for certain. See
  [dsp-map-302.md](dsp-map-302.md) on what drives the RAMs' chip selects.

**No emulator change follows.** The harness never simulated traces; it
simulates what `out @7c, 0x5e` does on one side and what `in al, 0x5c` returns
on the other, and that programming model was already right. This settles the
board documentation, as the section above said it would. The blocker on
CPU-DSP comms remains the mailbox poll rate - see
[what-runs-and-what-blocks.md](what-runs-and-what-blocks.md).

### The decode is five lines: `A0`-`A3` and `A5`

The follow-up reading came back: `A0`-`A3` (55-58) and **`A5`** (60) reach the
ASIC, and **`A4`** (59) does not. That retires the alias predicted in the
previous revision of this section - `0x60` is **not** `PA0`, and the stream
sender at `0x84b7` writes a register of its own.

**Every port the DSP actually uses is uniquely decoded by those five lines.**
The firmware's whole I/O footprint is `0x57`, `0x5e`, `0x5f`, `0x60` and
`0x68`-`0x6c`. Within `0x50`-`0x5f` the low nibble separates them; `0x60` and
`0x68`/`0x6a`/`0x6c` carry `A5` high and `A4` low where the `PA` bank carries
`A5` low and `A4` high, so the two groups cannot collide, and inside the second
group the low nibble separates again.

**Skipping `A4` while taking `A5` is the informative part.** It is not an
arbitrary saving. `0x5x` and `0x6x` differ in *both* bits 4 and 5, so one line
distinguishes the banks and the other is redundant - and a gate array wired to
one of the two is a designer who knew there were exactly two banks to tell
apart. So this is positive evidence for the two-bank picture rather than merely
being consistent with it:

| bank | `A5` | ports | what it is |
|---|---|---|---|
| `0x50`-`0x5f` | low | `PA0`-`PA15` | the memory-mapped I/O ports, aliased into data space at `0x0050`-`0x005f` |
| `0x60`-`0x6f` | high | `0x60`, `0x68`-`0x6c` | pure I/O space, no data-space alias |

**So the register file is larger than sixteen after all**, and
[what-the-asic-does.md](what-the-asic-does.md)'s "at most sixteen" is wrong for
the reason first given. The correction stands; the doubt raised about it in the
previous revision does not.

**A falsifiable prediction, and a cheap one.** With `A4` unconnected, ports
that differ *only* in bit 4 are indistinguishable to the ASIC. The firmware
never touches those, but a probe can:

* an `out` to port `0x40` should land in `PA0` (`0x50`)
* an `out` to port `0x47` should land in `PA7` (`0x57`) - readable straight
  back through the status latch at `0xff57`
* an `out` to port `0x70` should land wherever `0x60` goes

None of those can be tested by writing a value and reading it back: the ASIC's
DSP-side registers are not general storage - `PA7` returns status bits whoever
wrote it, and `PA0` is a sample sink and a boot-word source. So the test has to
be **differential on an observable effect**, and the mailbox is the effect this
repository has already driven end to end on hardware.

`build_port_fold_probe` in `courier_emu/dsp_probe.py` is that kernel: the proven
outbound sender, mailing a recognisable pattern, with the tag and data going out
on **`0x4e`/`0x4f`** instead of `0x5e`/`0x5f`. Nothing else changes - not the
frame, not the ack, not the host capture. The ack stays `samm @57`, which is a
data-space MMR write rather than an I/O cycle and so is not part of what is
under test.

```bash
.venv/bin/python -m courier_emu.probe_transport \
  --reference IDSDL302.ROM --output artifacts/port-fold-01 --port-fold
```

**Run the positive control first**, which is the same kernel on the real ports:

```bash
.venv/bin/python -m courier_emu.probe_transport \
  --reference IDSDL302.ROM --output artifacts/port-fold-control-01 \
  --port-fold --fold-tag-port 0x5e --fold-data-port 0x5f
```

Reading the result:

| control | folded | conclusion |
|---|---|---|
| frame arrives | frame arrives | `A4` is not decoded - the fold is real, and `0x4e` *is* `PA14` |
| frame arrives | nothing | `A4` is decoded after all, and the visual reading of pin 59 is wrong |
| nothing | either | the run did not work; the folded result means nothing |

The third row is why the control is not optional. A negative result here is
silence, and silence has many causes.

### Run on the board: the fold is real (2026-09-07)

`artifacts/dsp-port-fold-01/`. Three runs on the live unit, each image placed at
`0x3000` with `ATGLK2W` and verified byte-exact before it was started.

| run | ports | payload | result |
|---|---|---|---|
| control | `0x5e`/`0x5f` | `4E00` | `CDRP1 DONE`, 8 words, `SUM:701C` |
| **A4 fold** | `0x4e`/`0x4f` | `F700` | **`CDRP1 DONE`, 8 words, `SUM:B81C`** |
| A5 control | `0x6e`/`0x6f` | `A500` | `CDRP1 START`, then `CDRP1 ERR TAG` |

**`A4` is not decoded.** A mailbox frame sent to `0x4e`/`0x4f` arrives exactly as
one sent to `0x5e`/`0x5f`. **`A5` is decoded**: `0x6e`/`0x6f` delivers nothing,
which is what rules out the alternative reading that the ASIC ignores the
address bus and answers any `IS` cycle. So the board's electrical behaviour
confirms the visual reading of pins 55-58, 59 and 60 by their effect.

**The payload pattern is load-bearing.** The first fold attempt reused the
control's `4E00`, and its frame was therefore indistinguishable from a re-run of
the kernel the DSP already held in program RAM - the download could have failed
silently and produced the same output. It is not counted. The run above carries
`F700`, which only the freshly downloaded kernel could emit. `--fold-pattern`
exists for this, and every run on the board should use its own.

**The emulator had it wrong, and now does not.** The harness compared
`port == 0x5E` and predicted `CDRP1 ERR TAG` for the folded run; the board sent
the frame. `bridge.ASIC_DSP_PORT_MASK` now models the measured decode, and all
three runs reproduce the board's frames byte for byte. Note its stated limit:
bits 6 and 7 were never tested, so the mask is possibly narrower than the
board's decode and will accept `0x0e` where the board might not.

**Two procedural notes for anyone repeating this**, both cost a run here:

* `emit_ram_writes.py`'s `arm.txt` only hooks IVT vector 8, and on this board
  that starts nothing. `T0CON` at `0xff36` reads `0x8021` - `EN=1`, `INT=0` -
  so timer 0 runs and never interrupts. Starting the monitor takes a separate
  `ATGLK2WFF36,A021`, which is what
  [ram-probe-delivery.md](ram-probe-delivery.md) means by "enabling timer 0's
  interrupt".
* **The board reboots after every run**, so a second run needs
  `ATGLK2W0020,3000` / `ATGLK2W0022,0000` written again, or it produces no
  output at all and looks like a failed probe. An earlier version of this note
  said "the monitor restores vector 8", which was wrong - see
  [ram-probe-delivery.md](ram-probe-delivery.md) on the watchdog reset, which
  restores the vector, clears RAM and brings `AT` back as one event.

## The retraction: the ASIC is not shown to master the primary serial bus

[second-serial-port.md](second-serial-port.md) argues that the ASIC generates
`SCLK` and `FS` for the DSP-codec link, and concludes from that that the ASIC
inserts its own words into `DRR`, making the ring at `0x0bd0` an inbound
*command* stream the harness has never supplied. **The premise does not hold,
so neither does the conclusion.**

The argument needs both devices on that bus to be slaves. For the DSP that is
read correctly from `SPC = 0x40c8` (`MCM = 0`, `TXM = 0`). For the codec it is
read from "register 6 = `0x20` puts the AC01 in free-run, and it is wired in
slave/codec mode". That step is wrong twice over:

* **Register 6 carries no master/slave bit.** It is the *digital configuration*
  register: free-run, FSD output enable, 16-bit mode, force secondary, software
  reset, software power-down (datasheet section 2.20.7). The master/slave role
  is the **`M/S` pin** - Table 2-1, "Master/slave select input. When M/S is
  high, the device is the master and when low, it is a slave." Firmware cannot
  set it, and nothing in this repository has measured it.
* **Free-run does not imply slave/codec mode.** `0x20` is `DS05`, and free-run
  does exactly one thing: it makes the ADC/DAC conversion rate follow the A and
  B registers rather than the external frame-sync interval. In codec mode that
  is a real choice; in stand-alone mode the rate already comes from A and B, so
  the bit is redundant but harmless. It is consistent with **both** topologies
  and discriminates neither.

With that premise gone, the textbook topology is fully consistent with every
firmware fact on record, and it is the one TI's own `slaa006` reference design
wires: **the AC01 is the stand-alone master, generating `SCLK` and `FS` for a
slave DSP.** That is also what [ac01-codec-protocol.md](ac01-codec-protocol.md)
already says ("the AC01 is on the primary port and supplies `SCLK` and `FS`"),
which `second-serial-port.md` contradicts without noticing.

There is a second, independent gap in the same argument. Even if the ASIC
*were* the clock and frame master, that is a **timing** role, not a data role:
driving `SCLK` and `FS` does not put the master's data on `DIN`/`DOUT`. The
step from "bus master" to "inserts its own words into `DRR`" does not follow
either way.

So the ring at `0x0bd0` is what it looks like - a codec sample ring - and the
inbound command path is the mailbox, which is proven and already modelled.

## The codec's control words decode cleanly, and give MCLK

`docs/` now has the TLC320AC01 datasheet, so the six control words this board's
firmware sends at reset can be read rather than guessed. The secondary-word
format (section 2.19.1) is two control bits, `R/W`, a 5-bit register address in
`DS12`-`DS08`, and 8 bits of data:

| word | register | data |
|---|---|---|
| `010a` | 1, A register | 10 |
| `0214` | 2, B register | 20 |
| `0300` | 3, A′ (phase) | 0 |
| `0409` | 4, amplifier gain | 9 |
| `0505` | 5, analog configuration | 5 |
| `0620` | 6, digital configuration | `0x20` = free-run |

The decode checks out against the part's own rate equation,
`fs = MCLK / (A x 2 x B)`, which with A = 10 and B = 20 gives exactly
**7200 Hz** - the dial path's measured rate - and with the B = 19 and B = 18
that [codec-rate-312.md](codec-rate-312.md) finds the V.34 path selecting,
exactly **7578.95 Hz** and **8000 Hz**. Three independent rates land on their
known values from one constant:

> **MCLK = 2.880 MHz**, which is the board's 40.320 MHz oscillator divided by
> exactly **14**.

That is a new datum. It also says where MCLK comes from: the AC01's `MCLK` is
an input in every mode, there is one can on the board, and the ASIC is the only
part that could divide it - so the ASIC supplies the codec's master clock
whether or not it supplies its shift clock.

Note also that **registers 7 and 8 are never programmed**. Register 8 is the
frame-sync number, which a master device needs in order to know how many slaves
are chained, and register 7 is the frame-sync delay, which "must be the last
register programmed when using slave devices". Their absence rules out
*master-with-slaves*, leaving stand-alone or codec mode - which is as far as
the firmware can take this. Settling it needs one look at the `M/S` pin.

## The live blocker, and a lead that does not work yet

What actually stops the two processors talking is not the topology. It is that
the DSP's mailbox poll almost never runs. The poll is in the block at `0x80c8`
(program `0x00c8`; this file uses the `+0x8000` convention), and the main loop
reaches it only when `cmpr eq` matches `AR7` against `ARCR`:

```
80d0  0010           lar     ar0, @10     ; @10 under DP=7 is 0x0390
80d1  bf44           cmpr    eq           ; AR7 vs ARCR
80d2  e100 80c8      bcnd    80c8, tc
```

`AR7` is the ring pointer - `0x802e` sets `CBCR = 0x00ef`, selecting `AR7` for
circular buffer 1 with `CBSR1 = 0x0bd0` and `CBER1 = 0x0bdf` - and data `0x0390`
is the ring **write** pointer the serial ISR maintains at `0x8191`/`0x81a1`. So
the compare wants to be a ring rendezvous, and any `ARCR` inside the ring makes
the mailbox poll run once per pass.

In the emulator `ARCR` instead holds `0xec3e`, a **program** address left by the
table walk at `0x9644` - the only `samm @19` in the resident - so the compare
never matches and 87 delivered messages overwrite each other unconsumed.

### The lead: PMST.NDX, which is real but does not fit

The `lar ar0, @10` immediately before each `cmpr eq` is pointless if the compare
reads `ARCR`, and the idiom appears at three sites (`0x80d0`, `0x8105`,
`0x810d`). SPRU056D explains why it would not be pointless - PMST bit 2, `NDX`:

> *(LAR instruction reference, page 6-124)* "You can maintain software
> compatibility with the 'C2x by clearing the NDX bit. This causes any 'C2x
> instruction that loads auxiliary register 0 (AR0) to load the auxiliary
> register compare register (ARCR) and index register (INDX) also."

Table 4-3 agrees, and gives the reset value as 0. And this firmware **clears
`NDX` explicitly**, at `0x8012`: `apl @07, #07f8` masks off bits 0, 1 and 2, and
the following `opl @07, #00b0` sets only bits 4, 5 and 7. So on paper every
`lar ar0` should be writing `ARCR` with the ring write pointer, and the core
implements none of it: `m_pmst.ndx` is parsed and stored in
`native/c5x_core.cpp`, and then read nowhere except to reconstruct the register.

Implementing it does produce exactly the predicted state - `ARCR` becomes
`0x0bdc`, inside the ring - **and it breaks the firmware**. `INDX` takes the
same value, and a stride of 3036 corrupts all 317 `*0+`/`*0-` indexed-addressing
sites in the resident; the DSP stops reaching its main loop and the codec goes
undriven (`dxr_writes` 17,931 → 15). Restricting the side effect to `ARCR`
alone, or to the direct/indirect `LAR` encoding alone, does not rescue it.

So the change was **reverted**, and the position is:

* the mechanism is real and documented, and it is the only thing found so far
  that would leave a ring address in `ARCR`;
* the firmware clears `NDX`, which by the datasheet's own table *enables* the
  side effect;
* but a firmware that ran on real hardware cannot tolerate the side effect as
  the datasheet describes it.

One of those three has to give. Worth noting that SPRU056D contradicts itself on
the polarity - the prose at section 3.5 says the side effect happens when NDX is
**set**, the LAR page and Table 4-3 say when it is **clear** - so the document is
not a reliable arbiter here, and the part's actual behaviour is the open
question. The cheap decider is a hardware probe: a kernel that clears `NDX`,
does `lar ar0, #1234`, and mails back `ARCR` and `INDX`.

## The channel is interrupt-driven, and the harness invents the interrupt

Everything above is about the *ports*. This is about the line that says *when*,
and it is the part the harness does not model.

On the 403 board, IVT vector `0x0c` - INT0, an external pin - reads
`8f46:0000`, and that address is the entire DSP-to-CPU path:

```
8f46:0000  fb        sti
           fc        cld
           60        pushaw
           06        push es
           e41e      in   al, 0x1e
           8ae0      mov  ah, al
           e41c      in   al, 0x1c
           250300    and  ax, 3          ; two bits, and nothing else
           a37f01    mov  [0x17f], ax
      test 1 -> out 0x58, 0x5a, 0x5c, 0x5e        ; host -> DSP send
      test 2 -> in al,0x5a / in al,0x58 / call [0x192]   ; DSP -> CPU receive
           a17f01    mov  ax, [0x17f]
           e61c      out  0x1c, al       ; ack: the status written back *set*
           86c4      xchg ah, al
           e61c      out  0x1c, al
```

**Nothing in the image calls or jumps to that address.** A search of all 512 KiB
for a near call, a near jump, a far call and for the bare word `0000` paired
with segment `8f46` finds no reference at all: the handler is only ever entered
through the vector. So every message either processor ever receives is one entry
to this interrupt, and the "supervisor never pops" symptom is a statement about
an interrupt line, not about a polling loop.

A second, near-identical copy sits at `8f46:0939` (file `0xfd99`) and masks to
`7` rather than `3`, adding a bit-2 branch that `lcall 8000:067b`. It is
likewise unreferenced. Which of the two a given firmware state vectors is not
established here; the run measured below enters the one at offset zero.

### What the harness does instead

[machine.py:1565](../courier_emu/machine.py:1565) raises vector `0x0c` whenever
`FRAME_INSTRUCTIONS` have elapsed since the last one, and
[machine.py:523](../courier_emu/machine.py:523) says why in as many words:
"Nothing on the CPU side produces that edge, so a ROM run has to stand in for it
the way it already stands in for the tick." On the board the ASIC drives that
pin from mailbox state. In the harness it free-runs.

Measured on the failing 403 plain dial, with `--trace-pc` on each branch of the
handler:

```sh
./courier run artifacts/courier-board-21210-capture-403/courier-board.rom \
    --with-dsp --exchange --exchange-number 6245=answer --tick-ms 5 \
    --board-id 7 --nvram-fixture idsdl403 --at 'ATDT6245' \
    --instructions 150000000 --summary \
    --trace-pc 8f460=int0_entry --trace-pc 8f4bc=recv_branch \
    --trace-pc 8f4c9=recv_call --trace-pc 8f4d0=ack_1c --trace-pc 8f495=send_branch
```

| | count |
|---|---|
| INT0 entries | 12,809 |
| receive branch taken (bit 1) | 61 |
| send branch taken (bit 0) | 6 |
| `dsp_originated_messages` | 28 |
| reads of `0x5c`/`0x5e` | 28 each |

12,809 interrupts to carry 34 events. Every one of the other 12,775 re-reads a
status the ASIC never asserted and re-acks it by writing it back to `0x1c`.

The tag the handler reads says the same thing more sharply. Across the 57 calls
to `[0x192]`, the word taken from `0x5a`/`0x58` is:

    0008   28 times    the resident's messages, all of them
    0000   29 times    an empty lane

So the 28 real messages do arrive, and the free-running edge manufactures 29
more receive cycles on top of them, each one reading a mailbox with nothing in
it and dispatching on a tag of zero. The channel is not silent in the harness;
it is being driven at random against a request line nobody is asserting.

This does not by itself prove the free-running edge is what breaks the 403 dial.
It does mean the harness has never had a faithful version of the one event the
whole channel is built on.

### Measured: the edge free-runs at 2.4 kHz, and the reply cadence is 20 ms

**Run on hardware, 2026-09-09**, `artifacts/coop-int0-01` and `-02`: the board
at `/dev/cu.usbserial-11420`, ID_SDL 4.03d, supervisor 7.4.16, DSP 3.1.2, a line
in the jack, stimulus a bare `ATD` held 6 s and then aborted (`NO CARRIER`).

    interrupts            15,868 in 6.61 s   =  2,401 / s
    0x1c = fd             1,895 of the last 1,920 entries
    0x1c = ff                25 of them
    0x1e = ff             1,920 of 1,920

**The first claim above is wrong and is withdrawn.** The ASIC does *not* assert
this pin from mailbox state. It free-runs, at 2,401 Hz, and the handler polls
`0x1c` on every one of them - which is why `0x1c` reads `fd` for 98.7% of the
entries: bit 0 standing, bit 1 clear, nothing to do. The harness standing in for
the edge with a periodic one is therefore right *in kind*, and the paragraph
saying the board would settle whether it is event-driven has been answered
against the hypothesis that prompted it.

What the harness has wrong is the rate, and it is wrong the opposite way to what
"12,809 interrupts to carry 34 events" suggested. That run covers 6,858 ticks of
5 ms - 34.3 s of emulated time - so it raises **373 INT0 per second** against the
board's 2,401. The harness's mailbox is not being hammered; it is being serviced
**six times too slowly**.

And the part that is genuinely a signal is bit 1:

    entries between consecutive 0x1c = ff, in order:
    48 48 48 48 48 48 48 48 48 48 48 48 48 48 48 48 48 48 48 48 48 48 58 81

Twenty-two consecutive intervals of exactly 48 interrupts. At 2,401 Hz that is
**20.0 ms**, a 50 Hz report from the DSP held to the sample, with the last two
intervals stretching as the dial is aborted and the loop released. The earlier
capture, whose ring stopped when full and so holds the *first* 0.8 s after
arming - before the hook closes - shows `0x1c` flat at `fd` with no bit 1 at
all. So the cadence is not free-running with the interrupt: it starts with the
seizure.

That is the shape the harness has to produce, and it is a much more specific
target than "the resident should report something": a message every 20 ms for as
long as the loop is off hook, against 28 heartbeats 70 ms apart that nothing
consumes.

### And the harness cannot yet run at that rate

Setting the edge to the measured 2,401 Hz **breaks the one path that worked**:

| | 391 Hz (default) | 2,401 Hz (measured) |
|---|---|---|
| 302 plain | `6245`, ringback, answer | `""`, dial-tone |
| DTMF blocks | 136 | **770** |
| DSP-originated messages | 389 | 389 |
| 403 plain | `""`, idle | `""`, idle |

The reason is in the handler's own tail. It does not end at the acknowledgement:

```
00f4d8  e8155b        call 0x14ff0
00f4db  b001          mov  al, 1
00f4dd  9a76060080    lcall 8000:0676
00f4e2  833e340100    cmp  word ptr [0x134], 0
00f4e7  7404          je   0xf4ed
00f4e9  ff0e3401      dec  word ptr [0x134]
```

Unconditionally, on every entry. **This interrupt is the firmware's fine
timebase**, so raising it six-fold makes every countdown it drives elapse six
times faster in emulated time, and the dial emits 5.7x the tone blocks while the
exchange decodes no digits from any of them.

Both numbers cannot be right, and the board is not the thing that is wrong - the
same firmware dials on it, at 2,401 Hz, with the same `dec [0x134]` running. So
the harness holds a *second* error that 391 Hz was quietly compensating for,
somewhere between this countdown chain and the codec-sample clock the exchange
measures digit lengths in. Finding it is the next piece of work, and it is now a
bounded question rather than a guess: something in the harness is six times out
against a rate that is no longer in doubt.

Until then the default stays at `MODELLED_FRAME_HZ = 391`, which is the rate the
rest of the harness is consistent with, and `--frame-hz` reproduces the
comparison in one flag:

```sh
./courier run IDSDL302.ROM --with-dsp --exchange \
    --exchange-number 6245=answer --tick-ms 5 --board-id 7 \
    --nvram-fixture idsdl302 --at 'ATDT6245' --instructions 150000000 \
    --summary --frame-hz 2401
```

Keeping the wrong rate as the default is a deliberate choice and worth naming as
one: the alternative is a harness that is faithful about this interrupt and
cannot complete a call, which would trade a known-wrong number for a broken
bench.

`0x1e` never moved, in either capture. Whatever the handler's `mov ah, al` is
carrying, it is not carrying it here.

### How it was measured

`courier_emu.cooperative_probe --hook int0` chains this vector the way the INT3
mode chains the tick, and the trick is cheaper here: the original offset is
**zero**, so the segment `0x01a0` puts the stub at `0x1a00` - the bottom of the
`0x1600`-`0x2b00` region that survives `AT&T8`, with the whole gap to the live
firmware data at `0x1aab` free for its 42 bytes. One word arms it, the same word
disarms it, and there is no intermediate state.

It records `0x1e` and `0x1c` - in the handler's own order, so the columns compare
directly against the `and ax,3` it performs on them - and then `jmp far
8f46:0000`, so the firmware services the interrupt exactly as if it had been
entered directly. That yields the real edge *rate* and the real status *at* each
edge, which are the two numbers the harness is currently inventing.

The mailbox lanes `0x58`-`0x62` are refused in this mode. Elsewhere sampling them
only might race the firmware; inside INT0 it certainly does, because the handler
this stub runs in front of is about to read exactly those, and a byte taken here
is a byte it does not get.

`courier_emu.cooperative_run` drives the whole sequence on the board - identity,
vector check, place, verify, arm, stimulus, disarm, read out - with the disarm in
a `finally`. Two things the first hardware run taught it:

* **The ring must wrap.** Stopping when full keeps the *oldest* entries, and at
  2,401 Hz a 1,920-entry ring is 0.8 s: `coop-int0-01` filled before the hook
  even closed and recorded 1,920 samples of an idle mailbox. Wrapping keeps the
  newest, and a wrap counter beside the pointer turns "at least capacity" into
  the exact interrupt count, which is what makes the 2,401 Hz figure available
  at all.
* **A filled ring is a lower bound on nothing else.** 15,868 interrupts were
  taken and 1,920 kept. The 20 ms cadence is measured across the kept window and
  is not evidence about the 15.6 s of interrupts that fell out of it.
