# Where to put a probe on the DSP

Pin numbers are TI's, from SPRU056D Table A-4, *Signal/Pin Assignments for the
'C50, 'C51, and 'C53 in 132-Pin BQFP*. They apply to this board because the
part is marked **`D17140PQ`**, and TI's device table (page 1-4) lists `PQ` as
the 132-pin BQFP package for the 'C50 and 'LC50.

That is worth noting on its own: [board-parts.md](board-parts.md) concluded the
part is a **'C50 or 'LC50 rather than the 'C52** the core was first written
against, and it reached that from the firmware's memory use - the `0x23f0`
call landing inside a 9K SARAM, `PMST.RAM` and `OVLY` both being set. The
package suffix says the same thing independently: a 'C52 is **100-pin QFP**,
not `PQ`. Two unrelated routes to the same part.

## The one pin that settles the mailbox medium

**`IS` - pin 90.**

`IS` is the I/O-space select strobe. SPRU056D Table A-8 gives `DS`, `PS` and
`IS` as three space selects sharing one address/data bus, each "always high
unless low level is asserted for communicating to a particular external space".
So `IS` goes low for **one thing only**: an `IN` or `OUT`, or an access to
`PA0`-`PA15`. The SRAMs do not need it; they answer `DS` and `PS`.

The whole DSP-to-CPU mailbox runs on `OUT` instructions - the sender at
`0x83eb` to ports `0x5e`/`0x5f`, the stream coroutine at `0x84b7` to port
`0x60`. Every one of those asserts `IS`.

> * **`IS` (pin 90) routed to the ASIC** - the ASIC decodes the DSP's I/O
>   cycles, and the mailbox is parallel across the bus the SRAMs already sit on.
> * **`IS` unconnected, tied, or going nowhere near the ASIC** - the ASIC cannot
>   see an `OUT` at all, and the mailbox has to reach the CPU by some other
>   route. That would make the serial reading correct and force the question of
>   how `out @7d, 0x5e` gets anywhere.

This is a better test than counting data traces: `IS` is a single pin with
exactly one purpose, and continuity to the ASIC is a meter reading.

The rest of that group, for context: `DS` 89, `PS` 91, `R/W` 92, `STRB` 93,
`RD` 82, `WE` 83.

## The two serial ports

The second serial port and the "TDM port" are **the same pins and the same
registers** - `TSPC` bit 0 selects, and SPRU056D's bit table reads
`TDM -> 0: TDM port is configured as standard serial port`. This firmware
writes `TSPC = 0x00f8`, bit 0 clear, so it runs as an ordinary second serial
port. Two of its pins are dual-function and only take their TDM meaning when
that bit is set, which here it never is.

| signal | pin | port | what the firmware makes it |
|---|---|---|---|
| `DX` | 106 | primary | codec DAC data - written every sample |
| `DR` | 43 | primary | codec ADC data - read every sample |
| `CLKX` | 124 | primary | **input** (`SPC` `MCM = 0`) |
| `FSX` | 104 | primary | **input** (`SPC` `TXM = 0`) |
| `CLKR` | 46 | primary | input |
| `FSR` | 45 | primary | input |
| `TDX` | **107** | second | **driven constantly** - the one-way stream |
| `TDR` | **44** | second | never read by any instruction |
| `TCLKX` | **123** | second | **output** (`TSPC` `MCM = 1`) |
| `TFSX`/`TFRM` | **105** | second | **output** (`TSPC` `TXM = 1`); `TFRM` only if TDM=1 |
| `TCLKR` | 126 | second | - |
| `TFSR`/`TADD` | 125 | second | `TADD` only if TDM=1, so not here |

### What the board should look like if the firmware is right

Each of these is falsifiable with a scope or a meter:

1. **`TCLKX` (123) and `TFSX` (105) are actively driven by the DSP.** `MCM` and
   `TXM` are both set, so the DSP masters that bus. If they are quiet, the
   register decode is wrong.
2. **`TDX` (107) is toggling constantly** - the idle task writes `TDXR` every
   pass. **Follow pin 107**: whatever it reaches is what the DSP streams to, and
   that identifies the far end of the second port, which nothing has yet.
3. **`TDR` (44) is tied or floating.** The receive half is unused four ways -
   `TRNT`/`TXNT` never enabled in `IMR`, `TSPC` never read so `RRDY` never
   polled, `TRCV` never read through MMR addressing, and the one direct-addressed
   candidate at `0xaa4b` is scratch. The datasheet's own note says "input pins
   that are unused may be connected to VDD or to an external pullup resistor".
   If `TDR` is tied high, that **confirms the ASIC cannot send to the DSP on
   this port** - and the second port is ruled out as the command link by the
   board as well as by the firmware.
4. **`CLKX` (124) and `FSX` (104) are driven by something that is not the DSP.**
   Both are inputs here. Whatever drives them owns the primary bus - and that is
   the open question: the AC01 in stand-alone mode, or the ASIC. The codec-side
   version of this test is `M/S` on the TLC320AC01**CFN**, pin 18 of the **FN**
   package - a different part and a different package from the DSP's `PQ`.

Between them, 3 and 4 decide the topology: 3 closes off the second port, and 4
says whether the ASIC is on the primary one.


## `TDR` measured driving high and low (2026-09-07)

A probe on the board reports pin 44 switching constantly. That is worth
resolving carefully, because it contradicts the firmware in **both** builds.

### The firmware, re-checked on the board's own image

The disassembly work in this repository has mostly used `IDSDL302.ROM`, which
is **DSP 3.0.2**. The board runs **3.1.2**, so the check was redone against
`artifacts/courier-board-21210-capture-403/courier-board.rom` - the board's own
flash - whose DSP payload starts at `0x29140` (anchor at `0x2914a`). The second
port is configured identically:

| | 3.0.2 | board 3.1.2 |
|---|---|---|
| `TSPC` writes | `0x0038` then `0x00f8`, at `0x808a`/`0x808c` | **identical** |
| `SPC` writes | `0x0008` then `0x40c8` | **identical** |
| `IMR` | `0x002a` | **identical** |
| `TRCV` reads via MMR | none | **none** |
| `TSPC` reads | none | **none** |

`IMR = 0x002a` is INT2, TINT and XINT. Note it does **not** include `RINT`
either, and the codec's receive plainly works - the ports are synchronous, so
one interrupt per frame services both halves. So "no interrupt enabled" is not
on its own proof a port is unused. For the TDM port the case rests on three
independent things: `TRNT`/`TXNT` never enabled, `RRDY` never polled because
`TSPC` is never read, and `TRCV` never read.

So this is not a firmware-version difference, and something is driving a pin
that no instruction in either build looks at.

### Distinguishing `TDR` from `DR` without counting pins

`DR` is **43** and `TDR` is **44** - adjacent. `DR` carries the AC01's ADC
output and toggles every frame, continuously, exactly like the reported
measurement. An off-by-one, or a different pin-1 reference, produces precisely
this result.

The clean discriminator is the clock, not the count:

> Scope the suspect data pin against **`TCLKX` (123)** and **`CLKX` (124)**.
>
> * synchronous with **`CLKX` (124)** - an **input** to the DSP - it is `DR`,
>   and this is the codec.
> * synchronous with **`TCLKX` (123)** - an **output** the DSP drives, because
>   `TSPC` `MCM = 1` - it is genuinely `TDR`, and something really is
>   transmitting into the second port.

Worth checking as well whether `TDR` is simply **strapped to `DR`**. Tying an
unused serial input to an active neighbouring signal is a common alternative to
tying it to VDD, and it would make pin 44 switch without anything addressing it.

If it survives the clock test, it is a real and significant finding: a device
transmitting to the DSP on a port this firmware never reads. That would mean
either the ASIC broadcasts there and this build ignores it, or the pin sees
traffic addressed to something else.

## Correction: the board's ring is `0x0bc0`, not `0x0bd0`

Found while checking the above, and it matters for the `ARCR` blocker. The two
builds differ:

| | 3.0.2 | board 3.1.2 |
|---|---|---|
| `CBSR1` (`@1a`) | `0x0bd0` | **`0x0bc0`** |
| `CBER1` (`@1b`) | `0x0bdf` | `0x0bdf` |
| ring size | 16 words | **32 words** |
| `lar ar7` at reset | `#0bd0` | `#0bc0` |

`CBCR` is `0x00ef` in both. Everything in this repository that quotes
"`0x0bd0`-`0x0bdf`" is describing `IDSDL302.ROM`; **on the user's board the ring
is `0x0bc0`-`0x0bdf`.**


## `TCLKX` and `CLKX` are driven differently - and that is the prediction

A probe reports the two transmit clocks behaving unlike each other. That is
exactly what the register decodes require, and it converts into the measurement
that settles the `M/S` question **without probing `M/S`**.

| pin | signal | `MCM` | direction | driven by |
|---|---|---|---|---|
| 124 | `CLKX` (primary) | `SPC` bit 4 = **0** | **input** | whatever masters the codec bus |
| 123 | `TCLKX` (second) | `TSPC` bit 4 = **1** | **output** | the DSP itself |

So they *must* differ. The useful part is that both sides have a predicted
frequency.

### `CLKX` decides the retraction

If the AC01 is the master, its `SCLK` is "generated internally by dividing the
master clock signal frequency by four" (datasheet terminal table, `SCLK` pin 13
FN). This repository already fixed **MCLK = 2.880 MHz** independently, from the
reset control words `A = 10`, `B = 20` reproducing exactly 7200 Hz through the
part's own rate equation, and `B = 19`/`B = 18` reproducing exactly 7578.95 and
8000 Hz - see [dsp-cpu-interconnect.md](dsp-cpu-interconnect.md). So:

> **`CLKX` (124) at 720 kHz** = MCLK/4 with MCLK = 2.880 MHz. Two independent
> routes to the same number, and the AC01 is the master - which means the ASIC
> is **not** on the primary serial bus, and the retraction in
> `second-serial-port.md` stands.
>
> **`CLKX` at anything else** - the AC01 is not generating it, and the only
> other candidate on that bus is the ASIC.

There is a second, independent discriminator on the same pin that does not need
a frequency counter:

> **Continuous or bursty?** An AC01 in master mode divides MCLK by four and
> free-runs, so `CLKX` is a continuous 720 kHz square wave whatever the frame
> rate. A bridge clocking words across would instead produce **bursts of 16
> clocks**, one per frame. Bursty `CLKX` means something is moving words on
> demand, and that is not what the codec does.

For scale, at 720 kHz sixteen clocks take **22.2 us**, against a frame period of
138.9 us at 7200 Hz, 131.9 us at 7578.95 Hz or 125.0 us at 8000 Hz - so the two
cases are easy to tell apart on a scope: continuously busy, or ~18% busy.

### `TCLKX` gives the DSP's core clock, which nothing here has measured

`TCLKX` is driven at **CLKOUT1/4**. The board's oscillator is 40.320 MHz, so:

| DSP `CLKOUT1` | `TCLKX` | ratio to a 720 kHz `CLKX` |
|---|---|---|
| 20.16 MHz (oscillator / 2) | **5.04 MHz** | 7x |
| 40.32 MHz (oscillator x 1) | **10.08 MHz** | 14x |

Measuring `TCLKX` therefore reads the DSP's core clock straight off the pin,
which this repository has only ever inferred. The clock mode is set by `CLKMD1`
(pin 71) and `CLKMD2` (pin 103) if the frequency needs corroborating.

> **If `TCLKX` is not driven at all**, that is a different and more serious
> result: `TSPC = 0x00f8` sets `MCM = 1` and `XRST = 1`, and the idle task
> writes `TDXR` continuously, so the pin should be actively clocking. A static
> `TCLKX` would mean the `TSPC` decode is wrong, the port is not really
> enabled, or the pin identification is off - and it would also remove the only
> reason to think the DSP masters anything.


## `M/S` reported switching, `TCLKX` possibly not driven (2026-09-07)

Two reports that pull in the same direction: **the pin numbering needs an
anchor before any of this is load-bearing.**

### `M/S` sits between two pins that pulse every frame

| FN pin | signal | I/O | behaviour |
|---|---|---|---|
| 14 | `MCLK` | in | **2.880 MHz** (derived - see below) |
| 15 / 16 | `FC0` / `FC1` | in | tied low if unused |
| 17 | `FSD` | **out** | active-low pulse, one per frame |
| **18** | **`M/S`** | **in** | static master/slave select |
| 19 | `EOC` | **out** | high at ADC conversion start, low at end - **one pulse per frame** |
| 20 | `DGTL GND` | - | DC |

`M/S` is an *input* wedged between two *outputs* that both pulse at the frame
rate. Off by one in either direction lands on a signal that looks exactly like
"driven high and low", which is the same trap as `DR` (43) and `TDR` (44).

**The discriminator is phase against `FS` (pin 12).** `FSD` and `EOC` are locked
to the frame: one pulse per `FS` period, fixed phase, at 7200-8000 Hz. Anything
locked like that is one of them. If the suspect pin toggles *independently* of
`FS` - a different rate, bursty, or aperiodic - then it really is `M/S`.

### If it really is `M/S`, that changes the answer

`M/S` is specified as a static select: "when M/S is high, the device is the
master and when low, it is a slave", and section 2.3 says the *only* difference
is that `SCLK` and `FS` are outputs when high and inputs when low. So driving it
dynamically is exactly the primitive you would need to **time-share the primary
serial bus**: the AC01 masters it and exchanges samples while `M/S` is high, and
releases `SCLK`/`FS` to the ASIC while it is low.

That would mean the codec ISR's unconditional store of every `DRR` word into the
ring is picking up **both** codec samples and ASIC words - which is precisely the
claim retracted in [second-serial-port.md](second-serial-port.md), arriving by a
mechanism nobody had proposed. It would also make the ring the inbound command
path, tie the interconnect to the `ARCR` ring gate, and need no wide parallel
bus. The retraction was of the *argument* (register 6 carries no master/slave
bit, and it does not); a toggling `M/S` pin would be independent evidence for
the *conclusion*.

So this is worth resolving carefully rather than either way by assumption.

### Anchor the numbering first - two pins do it, and both pay twice

Neither package's pin 1 has been confirmed against a measurement here, and a
132-pin BQFP read from the wrong reference shifts **every** DSP number in this
file.

> **AC01 (44-pin PLCC): find `MCLK`, pin 14.** It should be **2.880 MHz**. That
> single reading anchors the codec's numbering *and* independently confirms the
> MCLK value this repository derived from the A and B registers - so if a pin
> reads 2.880 MHz, both the number and the numbering are right at once.
>
> **DSP (132-pin BQFP): find `X2/CLKIN`, pin 96.** It should carry the board
> oscillator at **40.320 MHz**, which the can is marked with. `CLKOUT1` (110)
> is the other unmistakable one.

Until one of those lands, treat every pin number here as provisional.

### A correction to withdraw first: "the DSP transmits constantly"

`TCLKX` reading as undriven is less surprising than it first looks, and the
fault may be this repository's.

[second-serial-port.md](second-serial-port.md) says the DSP transmits on the
second port continuously, measured at "21,976 `TDXR` writes in one
60,000-instruction sample window". **That measurement was taken in the emulator,
and the writer is the idle task at `0x81b7`.** The emulator's DSP never leaves
idle - that is the `ARCR` blocker this whole investigation is about. So the
figure says the idle task runs constantly *because the DSP is stuck in it*, not
because the firmware streams constantly.

On a working board the DSP is doing real work and would be in that idle task far
less, so a quiet `TDX`/`TCLKX` is consistent with the firmware. The one thing
that does not fit is that `MCM = 1` should free-run `TCLKX` regardless of
whether anything is transmitted - so if `TCLKX` is genuinely static, either the
pin identification is off, or the `TSPC` decode is wrong, or that port is not
brought up on this board at all.

**This is the same trap as the codec receive queue and the `TRCV` scan**: a
measurement taken inside the model, describing the model.


## Is `M/S` driven by the DSP's `XF`? What `XF` actually does

A good hypothesis, and the firmware answers it sharply. `XF` is **pin 109** on
the DSP; `M/S` is **pin 18** on the AC01. Whether they are connected is a
continuity check between two named pins - much better than any waveform
argument. But the waveform settles the *consequence* either way.

### `XF` is a static high with a glitch every eight seconds

There are exactly **two** `XF` sites in the whole 3.1.2 resident, both inside
the codec ISR:

```
8178  ldp  #007
8179  lacc @19            ; data 0x0399
817a  sub  #01
817b  sacl @19            ; decrement, every frame
817c  f788   xc  2, eq    ; ...only when it reaches zero:
817d  be4c   clrc xf      ;    XF low
...
8192  be4d   setc xf      ; XF high, every frame, unconditionally
```

The decisive detail: **`0x0399` is never reloaded.** The only write to it in the
entire image is the ISR's own decrement at `0x817b`, and the prologue's
`rptz #03ff` from `0x0100` zeroes it at reset. So it is a free-running 16-bit
counter, and `XF` goes low once every **65536 frames**:

| frame rate | interval between `XF` low pulses |
|---|---|
| 8000 Hz | **8.19 s** |
| 7578.95 Hz | 8.65 s |
| 7200 Hz | 9.10 s |

and the low lasts from `0x817d` to `0x8192` - about 21 instructions, so roughly
**2-4 us**.

So `XF` is, to any practical measurement, **held high**, with a microsecond
glitch about every eight seconds.

### What that means for each candidate

* **A pin observed toggling continuously is not `XF`.** `EOC` (17... no, **19**)
  and `FSD` (**17**) pulse *every* frame, at 7200-8000 Hz. That is the signature
  of continuous switching, and both are immediate neighbours of `M/S` (18).
* **`XF` cannot be bus arbitration.** Two microseconds every eight seconds
  cannot hand a serial bus over; a 16-bit frame at 720 kHz alone takes 22 us.
  So the time-shared-bus idea sketched in the previous section is **dead** if
  `XF` is the driver.
* **If `XF` does drive `M/S`, then `M/S` is high** - and a high `M/S` means the
  **AC01 is the master**, generating `SCLK` and `FS`. The ASIC would then not be
  on the primary serial bus at all, and the retraction in
  [second-serial-port.md](second-serial-port.md) stands rather than being
  overturned.

That last point is the useful one: the hypothesis, if true, **confirms** the
codec as bus master rather than undermining it.

### It also makes the `slaa006` reading unlikely

[dsp-boot-transport.md](dsp-boot-transport.md) says "`XF` is wired to the
codec's `RESET`", taken from TI's `slaa006` reference design. That does not fit
this firmware: pulsing the AC01's `RESET` every eight seconds would reinitialise
its registers to defaults - a 16 kHz rate for a 10.368 MHz MCLK - and the
firmware would have to reprogram all six control registers each time. It sends
them **once**, at reset. So either `XF` does not drive `RESET` on this board, or
that eight-second pulse is a latent bug nobody has hit.

`XF`'s other known use is as the request half of the boot ROM's `XF`/`BIO`
handshake at `0x0775`, which pairs it with **`BIO` (pin 130)**. If `XF` goes
anywhere other than the codec, the ASIC is the candidate.

### The test

> Continuity: **DSP pin 109 (`XF`)** to **AC01 pin 18 (`M/S`)**. Two named pins,
> one meter.
>
> And on the waveform: a pin switching at **7200-8000 Hz** is `EOC` or `FSD`. A
> pin sitting high with a **~2-4 us dip every ~8 seconds** is `XF`. Nothing on
> this board should look like anything in between.

## The data and address buses, anchored (2026-09-07)

A board observation reports the DSP tied to the ASIC across its 16 data pins -
see [dsp-cpu-interconnect.md](dsp-cpu-interconnect.md). That claim was recorded
without pin numbers, which every other pin claim in this file has. Here they
are, from the same SPRU056D Table A-4, 132-pin BQFP, that anchors the rest.

| signal | pins |
|---|---|
| `D0`-`D7` | 30, 29, 28, 27, 26, 25, 24, 23 - descending |
| `D8`-`D15` | 13, 12, 11, 10, 9, 8, 7, 6 - descending |
| `A0`-`A9` | 55, 56, 57, 58, 59, 60, 61, 62, 63, 64 - ascending |
| `A10`-`A15` | 72, 73, 74, 75, 76, 77 - ascending |
| `IS` / `DS` / `PS` | 90 / 89 / 91 |
| `R/W` / `STRB` | 92 / 93 |
| `RD` / `WE` | 82 / 83 |

Two things fall out of the numbering, and both are checkable on the board.

**The data bus is one contiguous block: pins 6-13 and 23-30.** What sits
between them is power and reserved - `VDDD` 14/15, `VSSD` 20/21, and the
not-connected pins 16-19 and 22 - so all sixteen data lines leave the package
from one region of one edge. That is consistent with an observation phrased as
"the 16 data pins": they are visually a single group, and nothing else is
mixed into them.

**The address lines and the strobes are on a different edge.** `A0`-`A15` run
55-64 and 72-77, and `IS`, `DS`, `PS`, `R/W` and `STRB` are 89-93, just past
them. So an inspection that establishes the data bus reaches the ASIC has
established nothing at all about `IS` - it was not looking at that side of the
part. This is why the data-pin observation cannot decide between the ASIC
decoding I/O cycles and the ASIC merely watching the memory bus: the pin that
separates those two readings is nowhere near the pins that were traced.

**Where to put the meter next**, in order:

1. **`IS` (90) to the ASIC.** The single decider. Low for `IN`/`OUT` and for
   `PA0`-`PA15`, high for everything the SRAMs answer.
2. **`A0`-`A3` (55-58) to the ASIC.** Four lines are enough to separate `PA7`,
   `PA14` and `PA15`. If the ASIC has the data bus and `IS` but no address at
   all, it cannot tell the mailbox tag port from the data port, and the
   programming model in the firmware could not work as written.
3. **`R/W` (92) and `STRB` (93).** Direction and cycle timing; needed for the
   ASIC to answer a read of `PA7` rather than only latch writes.

The `IS` reading is worth taking before the other two: if it is not connected,
2 and 3 stop mattering and the alias hypothesis is the live one.

**Confirmed electrically (2026-09-07).** `IS` was metered to the ASIC, and the
address decode was then measured by its effect rather than by continuity: a
mailbox frame sent to ports `0x4e`/`0x4f` arrives on the host exactly as one
sent to `0x5e`/`0x5f`, and one sent to `0x6e`/`0x6f` does not arrive at all. So
`A4` is not decoded and `A5` is, which is what the pin readings said. See
`artifacts/dsp-port-fold-01/` and
[dsp-cpu-interconnect.md](dsp-cpu-interconnect.md).
