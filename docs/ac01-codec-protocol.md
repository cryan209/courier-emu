# The TLC320AC01 protocol, as this board's DSP actually drives it

The codec next to the DSP is a TI `320AC01CFN` ([board-parts.md](board-parts.md)).
This decodes the serial protocol between it and the C5x from two sources that
agree: the datasheet (`tlc320ac01.pdf`, section 2.19 and 2.20) and the DSP
firmware itself, disassembled out of `IDSDL302.ROM`'s payload and then watched
executing under the boot ROM.

Program addresses are the 20.16 MHz build's, origin `0x8000`. `main211`'s copy
of the same code sits `0x8000` lower.

## The frame

The AC01 exchanges one 16-bit word each way per frame. The word the DSP sends
is a **14-bit DAC sample in DS15..DS02 plus two control bits in DS01:DS00**;
the word it receives is the ADC sample. The two LSBs select what happens next:

| D01 D00 | effect |
|---|---|
| `00` | ordinary frame, no phase shift |
| `01` / `10` | phase-shift request (earlier / later) |
| `11` | **request a secondary frame** |

Datasheet section 2.17.1 and Table 2-3. So a DAC sample is never a full 16 bits,
which is why `native/c5x_core.cpp` masking the transmitted word with `0xfffc`
was right.

A **secondary frame** carries a control-register write instead of a sample
(section 2.19.1):

```
DS15 DS14 | DS13 | DS12 .. DS08 | DS07 .. DS00
control   | R/W  | reg address  | register data
 (2 bits) |      |   (5 bits)   |   (8 bits)
```

## What the firmware does

### Reset: prime the port, then write six registers

`0x8090` sets up the serial port and sends two priming frames:

```
8090  lar  ar1, #22          ; ar1 -> SPC
8091  splk *, #0008          ; SPC = 0008
8093  splk *, #40c8          ; SPC = 40c8
8095  lacl #01 ; samm @21    ; DXR = 0001
8097  bit  4, *              ; SPC bit 11 = XRDY
8098  bcnd 8097, ntc         ; spin until the shifter has taken it
809a  samm @21               ; DXR = 0001 again
```

Then six calls to the blocking control-word sender at `0x8149`:

```
80ad  lacc #010a ; call 8149
80b1  lacc #0214 ; call 8149
80b5  lacc #0300 ; call 8149
80b9  lacc #0409 ; call 8149
80bd  lacc #0505 ; call 8149
80c1  lacc #0620 ; call 8149
```

### The sender is three lines and an `idle`

```
8149  samm @6c              ; stage the secondary word
814a  lacl #03 ; samm @6b   ; request code 11
814c  idle                  ; wait for the next XINT
814d  lamm @6b
814e  bcnd 814c, neq        ; spin until the ISR clears the flag
8150  ret
```

`@6b` is the pending request code and `@6c` the staged control word. Both are
DARAM B2 cells, in the same block as the ROM's interrupt dispatch table.

### The ISR ORs the request into the sample

`@65` is the B2 cell the on-chip ROM dispatches XINT through
([dsp-onchip-rom.md](dsp-onchip-rom.md)), and the firmware installs `0x8189`
in it. RINT's cell `@64` gets the shared do-nothing stub `0x81ae` — **the part
is driven entirely off the transmit interrupt**, and one handler does both
directions:

```
8189  ldp  #007
818a  lacc @19 ; sub #01 ; sacl @19   ; frame countdown
818d  xc   2, eq ; clrc xf
818f  dmov @18
8190  mar  *, ar7 ; sar ar7, @11 ; lar ar7, @10
8193  lamm @20              ; ACC = DRR - the ADC word
8194  sacl *+               ; into the receive ring
8195  samm @0c              ; TREG0 = sample
8196  lacl @1d ; bcnd 819e, eq
8199  spm #0 ; mpy @1d ; pac ; bsar 14 ; samm @50   ; scaled copy to I/O 50
819e  lamm @6b
819f  or   *+               ; DAC sample OR the request code
81a0  samm @21              ; DXR = sample | 3
81a1  sar  ar7, @10 ; lar ar7, @11
81a3  setc xf
81a4  lamm @6b ; sub #03
81a6  bcnd 81ab, eq         ; request pending -> arm the secondary frame
81a8  lacl #00 ; samm @6b ; rete
81ab  lacc #81af ; samm @65 ; rete    ; revector XINT for exactly one frame
```

and the secondary-frame handler restores itself:

```
81af  lamm @6c ; samm @21   ; DXR = the control word
81b1  lacl #00 ; samm @6b   ; request satisfied
81b3  lacc #8189 ; samm @65 ; put the normal ISR back
81b6  rete
```

**There is no state machine to find: the state is which address is in `@65`.**
The ISR rewrites its own vector cell for one frame and then undoes it.

### Watched executing

Stepping the boot-ROM run and sampling `@6b`, `@6c` and `@65`:

```
@6b=0x0000  @6c=0x0000  @65=0x8189
@6b=0x0003  @6c=0x010a  @65=0x8189
@6b=0x0003  @6c=0x010a  @65=0x81af
@6b=0x0003  @6c=0x0214  @65=0x8189
@6b=0x0003  @6c=0x0214  @65=0x81af
...
@6b=0x0003  @6c=0x0620  @65=0x81af
@6b=0x0000  @6c=0x0620  @65=0x8189
```

Six words, each with the vector flipping out and back. The disassembly and the
run agree.

## What the six words program

| word | reg | data | meaning |
|---|---|---|---|
| `010a` | 1, A register | 10 | `FCLK = MCLK / (2 x A)` = MCLK/20 |
| `0214` | 2, B register | 20 | `fs = FCLK / B` = MCLK/400 |
| `0300` | 3, A' register | 0 | no phase-shift adjustment |
| `0409` | 4, amplifier gain | `0x09` | monitor squelch; **analog input +6 dB**; analog output 0 dB |
| `0505` | 5, analog config | `0x05` | DS02 set: **high-pass filter bypassed**; `IN+`/`IN-` selected (not AUXIN), no loopback |
| `0620` | 6, digital config | `0x20` | DS05 set: **ADC and DAC conversion free run** |

All six have DS15:DS14 = `00` (no phase shift) and DS13 = 0 (write mode). No
register is ever read back, and registers 7 and 8 - frame-sync delay and
frame-sync number, the ones that only matter when slaves are chained - are left
at their defaults. So this is a single AC01, not a chain.

### Free run is the interesting bit

Register 6 DS05 puts the part in free-run mode (datasheet 2.15.4): the external
shift clock and frame sync **control only the data transfer**, while the ADC
and DAC conversion timing comes from the A and B registers off MCLK. Combined
with registers 7 and 8 being untouched, the topology is: the ASIC supplies
SCLK and FS and moves words, and the codec clocks its own converters.

That is the concrete version of the claim in
[board-parts.md](board-parts.md) that "the ASIC fronts the codec" - it is true
of the data path, and false of the conversion clock.

### The rate: MCLK is 2.880 MHz, and it is over-determined

The datasheet's equations are `FCLK = MCLK/(2 x A)` and `fs = FCLK/B`.
[codec-sample-rates.md](codec-sample-rates.md) establishes the three sample
rates independently of any clock - from the dial path's DTMF phase increments
and from a six-row table indexed by V.34's negotiated symbol rate, which
reprograms **register 2 only**, with `0214`, `0213` or `0212`. Solving for MCLK
with A fixed at 10:

| B | fs | implied MCLK | FCLK |
|---:|---|---|---|
| 20 | 7200 Hz | 2.880000 MHz | 144.000 kHz |
| 19 | 7578.95 Hz | 2.880001 MHz | 144.000 kHz |
| 18 | 8000 Hz | 2.880000 MHz | 144.000 kHz |

Three independent rates converge on one value. **MCLK = 2.880 MHz**, and

```
40.320 MHz / 2.880 MHz = 14.000
```

exactly - so the codec clock is an integer division of the board's master
oscillator, and the second can on the board does not have to be its source.

Two things fall out that read as design rather than coincidence:

* **FCLK = 144.000 kHz is the datasheet's own characterization point.** Every
  filter and distortion table in section 3.5 is specified at "FCLK = 144 kHz,
  fs = 8 kHz", and B = 18 gives exactly 8.000 kHz. The board runs the part where
  TI characterized it.
* **A is never reprogrammed, and that is why.** The anti-alias low-pass corner
  is `FCLK/40`, which depends on A alone - a fixed **3.6 kHz** across all three
  sample rates, the standard voiceband corner. Only B moves, so changing the
  sample rate does not disturb the filter.

The part's own high-pass filter is switched **out** (register 5 DS02 = 1), so
the `fs/200` corner never applies and the DAC and ADC paths are DC-coupled as
far as the codec is concerned. Whatever removes DC is downstream, in the DSP or
the ASIC.

An earlier revision of this section said the design point was 9600 Hz and that
MCLK was therefore 3.840 MHz, an awkward 10.5 division of the 40.320 MHz can.
That was wrong - it took the harness's `DAA_SAMPLE_RATE` for a measurement. The
9600 figure appears nowhere in the firmware, the datasheet or the arithmetic.

## What the emulator does with all of this today: nothing

`native/c5x_core.cpp` stores `DXR`, counts the write, and for two hardcoded PCs
pushes `value & 0xfffc` into the line-transmit buffer. The two control bits are
discarded, no secondary frame is ever delivered, and the register file does not
exist - so input gain, the high-pass filter, the analog input select, free run
and the A/B rate have no effect anywhere. `SPC` reports `XRDY` set whenever
`XRST` is set rather than following a frame clock, so the reset spin at `0x8097`
and the `idle` at `0x814c` both fall straight through.

`courier_emu/codec.py` models an Si3038 register map instead, which this board's
DSP never drives.

### And the sample rate is wrong on the side that generates audio

`configure_rom_codec` sets `m_line_frame_period = 3472`, which is `25e6/7200` -
the frame *interrupt* already arrives at the 2400-baud rate. But everything that
*fills* the receive queue assumes 9600 Hz:

| site | what assumes 9600 |
|---|---|
| `courier_emu/daa.py` | `DAA_SAMPLE_RATE`, and the 350/440 Hz dial tone it renders |
| `courier_emu/line.py` | `LINE_FRAME_MS`, the frame unit two linked instances exchange |
| `courier_emu/bridge.py` | the SIP rate converters and three tone mixers |
| `native/c5x_core.cpp:396` | the V.8 1300 Hz and 2100 Hz correlator references |
| `native/c5x_core.cpp:419` | the answer-tone cadence |
| `native/c5x_core.cpp:754` | the line-sample phase accumulator |

So samples are synthesized at 9600 Hz and consumed by firmware that believes
they arrived at 7200. **Every frequency the firmware sees is scaled by 4/3.**
Dial tone reaches it as 262/330 Hz instead of 350/440; the 2100 Hz answer tone
arrives as 1575 Hz; DTMF lands nowhere near its detector's tolerance, which
[codec-rate-312.md](codec-rate-312.md) already showed is only ±1.5%.

This is a candidate explanation for `--exchange` hearing silence and for the
V.8 bootstrap needing a native detector rather than the firmware's own - but it
is a candidate, not a demonstration. Nothing here has been re-run at 7200 Hz to
show the tones are then recognised.

## The model (2026-09-07)

`C5xCore::codec_transmit` now decodes every `DXR` write the way the part does.
Which kind of frame a word belongs to is decided by the *previous* frame's
control bits, so the model needs no knowledge of where the write came from -
this replaces a test against two hardcoded ISR addresses, `0x818f` and `0x81a0`,
which recognised the samples of two known builds and nothing else.

* Primary word: sample is the top 14 bits; `11` in the LSBs arms a secondary
  frame, `01`/`10` count as phase-shift requests and are otherwise ignored.
* Secondary word: parsed into a nine-entry register file. Register 0 is the
  no-op. `DS13` set is a read, which returns the register in `DRR`'s low byte
  and programs nothing. Register 6 `DS02` forces every frame secondary;
  `DS01` is a software reset and restores the power-up defaults.
* **The sample rate is derived, never assumed.** Writing register 1 or 2
  recomputes `fs = MCLK/(2 x A x B)` and with it the frame period in C5x
  cycles. `configure_rom_codec` still starts at 3472 - it has no way to know
  what the ASIC clocks the port at before the firmware programs anything - but
  from the firmware's first divider write the rate is the part's own.

`courier_emu/dsp.py` exposes `codec_state()` and `codec_sample_rate`.

Booting 302 through the ROM and reading the model back:

```
registers      ['0x00', '0x0a', '0x14', '0x00', '0x09', '0x05', '0x20', '0x00', '0x01']
sample rate    7200.0 Hz          frame period 3472 cycles
secondary 6    reg writes 6       reg reads 0    phase shifts 2
free_run=True  high_pass=False    loopback=False
input gain 6 dB   output gain 0 dB
```

The six registers are the six words above, the rate falls out of B, and the two
phase shifts are the reset priming writes.

### Line audio meets the codec at the codec's rate

`bridge.LineToCodec` resamples everything entering the receive queue from the
harness's line rate to whatever the codec currently converts at, with linear
interpolation and a carried sample so a batch seam does not click. Every audio
path in `bridge.py` now goes through `_queue_line_audio`; the boot table, which
is not audio, still goes straight to `queue_codec_rx`.

A 2100 Hz tone carried at 9600 and delivered to a 7200 Hz codec measures
2100 Hz after conversion, where handing it over unresampled measured 1575.

### The frame clock, per the datasheet

`C5xCore::codec_frame` runs at every frame sync, and it is what the harness did
without: `DRR` used to be filled lazily when the firmware happened to read it,
so a run whose receive queue was empty returned the same stale word every frame
for the whole run.

* **One ADC word per primary frame** - "one word for each primary
  communication interval", section 2.4. The converter runs whether or not the
  DSP is listening, and an empty queue is silence on the line, so it delivers a
  zero rather than repeating the last word.
* **A secondary frame delivers no sample.** Section 2.4 again: DOUT carries the
  addressed register when a read was requested and is otherwise all zeros. The
  register value therefore arrives when the secondary frame sync does, not when
  the host reads `DRR`.
* **The secondary frame sync arrives half a frame period after the primary that
  requested it** - Figure 2-1's note gives `(B/2)` FCLK periods, and since
  `fs = FCLK/B` that is `fs/2`. It is serviced ahead of the next primary rather
  than replacing it.
* `RRDY` now follows a word actually having been clocked in, rather than the
  harness merely having audio queued.

Measured on the 302 boot: 1911 frame syncs, 1911 samples consumed - one word
each, exactly - with `DRR` holding live audio instead of a stale zero.

**The boot table is not the sample stream.** The ROM loader polls `DRR` for its
boot table over the same port, before the codec is programmed, so a frame sync
consuming those words breaks the download outright - which is what happened the
first time this was wired up. `queue_codec_boot` keeps them in their own queue,
drained by the loader's polls and never by a frame.

### What is still not modelled

`SPC` still reports `XRDY` set whenever `XRST` is set rather than following the
frame clock, so the reset spin at `0x8097` and the `idle` at `0x814c` fall
through rather than waiting. The gain, high-pass and loopback settings are
decoded and reported but do not yet alter the samples. Phase-shift requests are
counted and otherwise ignored. The legacy TDM path (`m_rom_codec` false) still
decimates at a fixed 9600 Hz; it is not the AC01 path and this change
deliberately left it alone.

## What this does not establish

The register semantics are the datasheet's and the words are the firmware's;
nothing here was measured against the physical codec. Whether the ASIC's FS rate
matches the A/B conversion rate on the real board is an inference from the
datasheet's own constraint that the two must agree within half an FCLK period,
not an observation. The `0x8189` ISR was read under the boot ROM with an empty
receive queue, so every `DRR` value it consumed in that run was stale.
