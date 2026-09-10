# Where the PCM goes on the Quad x2 Modem NAC

> Bring-up update (2026-09-10): see [Quad blockers](quad-bringup-blockers.md).
> Local RS-232 AT operation is documented; an NMC handshake is not a proven
> prerequisite. Fresh probes expose spurious receive interrupts and missing
> channel-selected memory. Historical execution conclusions below are superseded
> where they conflict with that report.

The question: does the G.711 codeword stream reach the C50 DSP directly, or
does the 80186 supervisor carry it? The answer for the supervisor is settled —
it is not in the sample path. The DSP-side detail is only partly recovered, and
this document is explicit about which is which.

## Proven: the 80186 is not in the sample path

The supervisor's entire I/O map, taken from every `mov dx, imm16` followed by
an `in`/`out` in the real 16-bit code region (`0x80000..0xc49a3`), is:

| Ports | Role |
| --- | --- |
| `0x0000`, `0x0200`, `0x0260`, `0x0280` | the four-entry board latch bank at `cs:0x931`, with an output shadow at `[0x216..0x21d]` |
| `0x0220`–`0x022a` | the management USART — see [nmc-sdl-protocol.md](nmc-sdl-protocol.md) |
| `0x0042`, `0x0200`, `0x0240` | the backplane handshake group |

All of these are byte-at-a-time, and none sits in a sample-rate loop. The
supervisor's DSP interface is a queue in shared RAM — the 35 initialisation
writes at `0x02ca..0x030e` that the execution run records (`QF` at `pc=8016a`,
`QR` at `pc=80176`) — which is control messaging, the same shape as the analog
Courier's mailbox in [dsp-cpu-interconnect.md](dsp-cpu-interconnect.md).

So no codeword copy loop exists on the 80186. Whatever carries PCM reaches the
DSP without the supervisor touching each sample.

## Proven: the Quad's DSP programs `TSPC` in its resident init

Both builds carry byte-identical code at the head of the DSP resident bank:

```
splk  @18, #0003
dmov  @18
lacl  #38
samm  @32        ; TSPC, the TDM serial port control register
lacl  #f8
samm  @32
```

| Build | Resident base | `samm @32` sites |
| --- | --- | --- |
| `QF060003` 6.0.3 | `0xc49b0` | word `0x099` (`0xc4ae2`), word `0x09b` (`0xc4ae6`) |
| `QR060103` 6.1.3 | `0xc2230` | word `0x085` (`0xc233a`), word `0x087` (`0xc233e`) |

Written first as `0x38`, then as `0xf8` — the same value with the top two bits
set, the ordinary configure-then-release shape for this register. Both sites
are anchored, in the entry path, and identical across two independent builds.

## Proven by execution: the Quad's serial port is byte-formatted

The DSP residents run under this repository's own C5x core
(`courier_emu.dsp.NativeC5x`, program loaded at origin `0x8000`, entry
`0x8000`). Against the SDL 3.02 analog reference from `IDSDL302.ROM`
(`rom-info` gives its DSP payload as flash `0x29080..0x368fc`, entry word
`0x8000`):

| Image | `SPC` | `SPC` writes | `TSPC` | `TSPC` writes | final `pc` |
| --- | --- | --- | --- | --- | --- |
| `QF060003` Quad | `0x40cc` | 118 | `0xf8` | 118 | `0x265b` |
| `QR060103` Quad | `0x40cc` | 28 | `0xf8` | 28 | `0x82e0` |
| SDL 3.02 analog | `0x40c8` | 2 | `0xf8` | 2 | `0x814d` |

`TSPC` is `0xf8` on **both** products, so the TDM port is not what separates
them. The whole difference is one bit in `SPC`, the standard serial port
control register: `0x40c8` against `0x40cc`.

Per the C5x user's guide in this tree (`spru056d`, Table 9-13), bit 2 is **FO,
Format**:

> FO = 0 — The data is transmitted and/or received as 16-bit words.
> FO = 1 — The data is transferred as 8-bit bytes. The data is transferred with the MSB first.

So the analog Courier moves **16-bit words** and the Quad moves **8-bit bytes,
MSB first**. That is the G.711 codeword, and it is the concrete register-level
form of the analog/digital split. It agrees with
[ac01-codec-protocol.md](ac01-codec-protocol.md), where the TLC320AC01
"exchanges one 16-bit word each way per frame" — a 14-bit linear sample plus
two control bits, which is exactly what FO = 0 carries.

The rest of both values decode the same way: `Soft` set, `RRST` and `XRST` set
(both halves out of reset), `FSM` set, and — the part that matters for a
chassis card — **`TXM = 0` and `MCM = 0`**: frame sync is an input and the
transmit clock comes from the `CLKX` pin. The DSP is a slave on somebody
else's PCM timing, which is what sitting on a shared highway requires.

### Why the Quad rewrites the registers

The 302 payload programs `SPC`/`TSPC` twice and moves on, because this
repository models its AC01 codec and therefore its frame clock. The Quad
payload rewrites them 118 (QF) and 28 (QR) times, because nothing supplies the
external clock and frame sync its `TXM = 0` / `MCM = 0` configuration waits
for, so it keeps resetting the port and retrying. That is the expected shape of
a missing peer, not a fault in the image.

Caveat on the runs: QF's final `pc` of `0x265b` is below the `0x8000` program
origin, so that instance has run out of loaded program space by the end of two
million instructions. QR stays inside it at `0x82e0`. The register counts above
are still meaningful — they accumulate during the init phase — but QF's late
execution should not be read as firmware behaviour.

## Not established, and a correction

An earlier version of this document contrasted the analog Courier's "plain
serial port" with the Quad's "TDM port", on the strength of a scan finding no
TDM-register writes in a `main211` payload. **That claim is withdrawn**, for
three reasons, and the execution results above supersede it: `TSPC` is `0xf8`
on the analog SDL 3.02 image too.

1. **Wrong reference image.** `main211` is not a behavioural reference for this
   tree; 302 and 403 are. Every comparison here now uses the SDL 3.02 payload
   out of `IDSDL302.ROM`.
2. **Wrong method.** Counting `lamm`/`samm` opcode words misses the normal
   idiom: on the C5x, memory-mapped registers `0x00..0x5f` are data page 0, so
   code reaches them with `ldp #0` and direct addressing (`lacc @30`), or
   indirectly — the Quad's own `SPC` writes are `lar ar1, #22` followed by
   `splk *, #000c` / `splk *, #40cc`, invisible to every static scan tried.
3. **It contradicted this repository's own model.** `native/c5x_core.cpp`
   implements the full TDM register file (`0x30`–`0x35`), and its comments
   describe the legacy TDM path with the ASIC as TDM clock master. Those come
   from live board probes and outrank a static word scan.

Still **open**:

- `TCSR` (`0x33`) and `TRTA` (`0x34`) — channel select and timeslot address —
  have no confirmed access in either Quad payload, statically or in two million
  executed instructions. Given `TXM = 0` / `MCM = 0`, the card is a timing
  slave, so timeslot selection may be done by board logic outside the DSP
  rather than by these registers at all. Not settled either way.
- Which companding law is in force. FO = 1 establishes 8-bit MSB-first
  transfers; it does not distinguish A-law from mu-law.
- How the four channels are separated. One serial port carries byte-formatted
  PCM, but nothing found so far says how four calls share it.
- The per-sample receive/transmit ISR has not been located in either payload.

## Method note

Static scanning of a C5x payload is unreliable and every result above that
depends on it is labelled accordingly. Three failure modes, all observed here:

1. A word such as `0x0830` is `lamm @30` only at an instruction boundary. More
   often it is the immediate operand of a preceding `lar arN, #0830`.
2. Coefficient and pointer tables disassemble into plausible instruction runs.
   `tools/c5x_disasm.py`'s `anchored()` filter removes some but not all.
3. Direct addressing is page-relative, so identifying a register access needs
   the value of `DP`, which linear decoding through data cannot track soundly.

The `TSPC` pair survives all three because it is `lacl #imm` / `samm` — an
opcode with no page dependence, at an anchored site, in the entry path, and
duplicated across two independently built images.

Settling the rest wants the DSP executed rather than read: `courier-emu
dsp-run` against the Quad resident, with the TDM registers watched, would show
the ISR and the timeslot writes directly.

## Digital timeslot model (2026-09-10)

`NativeC5x.configure_digital_pcm` now models the peer that the analysis below
found missing. It is deliberately not the AC01 codec path:

- its frame period is `20,160,000 / 8,000 = 2,520` C50 cycles;
- DRR receives exactly one opaque octet per frame and falls back to the
  selected law's idle octet when the queue is empty;
- DXR's low octet is captured once per frame without linearising or
  recompanding it;
- XRDY/RRDY follow those frame edges.

`QuadC50Endpoint.connect_digital_call`, `receive_g711`, and `transmit_g711`
carry that interface across DSP resets and the CPU-driven resident download.
The focused test also runs a C50 frame ISR that toggles the G.711 sign bit in
DSP data memory and writes the result to DXR. Its output alternates `1c 9c` at
8 kHz: a 4 kHz square tone whose codewords are demonstrably written by C50
instructions, not generated in Python or in the line peripheral.
`tools/probe_quad_digital_tone.py` makes this executable and records a raw
one-second stream plus the C50's DXR write count and producing PC.

That closes the framing and codeword-transport blocker. It does not close the
stock call-control blocker: the QF CPU still needs a chassis request that makes
it select and download the appropriate overlay before serial interrupts can be
enabled safely. The resident-only failure described below remains the expected
result when that ordering is skipped.

## Trying to make the stock firmware produce samples

Achieved for the resident's stock DTMF component path. `courier_emu.quad_audio`
runs the captured QF060003 selector (`8de0`), two oscillators (`8e54` and
`8e60`), sine helper (`92da`), mixer (`82be`) and primary serial ISR (`83e1`).
The runner supplies frame scheduling and idle RAM, but it supplies no waveform
or oscillator code. For every one of the sixteen keypad indices, spectral
measurement finds the two frequencies selected by the stock phase table and
the original ISR writes the mixer's exact word to DXR at `83ef`.

The fourth column is a useful image-specific check: QF stores increment
`0x3b21`, approximately 1663 Hz at the generator's 7200 Hz rate, where the
analog Courier stores `0x3a10` for 1633 Hz. The runner measures QF's value,
which would not happen if it were accidentally executing the analog image.

The stock G.711 path has now been located in this same QF resident. Expansion
starts at `0x8115`; compression starts at `0x817f`. The mu-law branches use
`cmpl` and the `0x84` bias, while the A-law branches use `xor #0x00055000`.
Data word `0x039f` bit 14 selects A-law. Routine `0x8238` clears or sets that
bit from the low nibble of data word `0x007a`, the resident's host-argument
scratch word, so idle-codeword selection is not the law control. (The `lamm`
instruction ignores DP; `0x7a` is not one of the `0x50..0x5f` external I/O
registers.) `courier_emu.quad_audio.render_g711` now executes that compressor
with its recovered calling convention and passes every result through the
stock serial ISR at `0x83e1`. The runner supplies only the 9:10 frame schedule
between the resident's 7.2 kHz generator and the 8 kHz DS0; it does not
calculate or compand audio. All sixteen decoded pairs are correct under both
laws. The remaining control-plane question is tracing the host argument back
to its supervisor setting.

The compressor dispatch is concrete:

```
817f  bit   14, @1f        ; data 039f: A-law when set
8180  bcnd  8197, tc
8182  lacb                 ; mu-law input
8187  add   #00840000      ; mu-law bias
818b  rpt   #06
818c  norm  *-
8194  cmpl                 ; mu-law inversion
8195  b     81ad
8197  lacb                 ; A-law input
819c  or    @7b
819f  rpt   #06
81a0  norm  *-
81ab  xor   #00055000      ; A-law alternating-bit transform
81ad  mar   *, ar7
81b1  sach  *+, 4          ; store compressed result in the serial buffer
```

The expander immediately above it has the inverse split at `0x8112`: the
mu-law half uses `cmpl` and subtracts `0x21` (the `0x84` bias at its working
scale); the A-law half uses `xor #0x00055000`. These signatures occur in the
executed QF resident at flat RAM `0x20000`, not in a generated test program or
in Python.

One tooling correction fell out of this: C5x `BIT` encodes the bit number
inverted in opcode bits 11..8. Opcode `0x411f` is therefore `bit 14, @1f`, not
`bit 1, @1f`; the local disassembler now reports it correctly.

The execution bug was the compressor ABI, not missing signal code. Its repeated
`norm *-` exponent search expects auxiliary register pointer ARP=1 on entry.
Entering it with the mixer's ARP=7 decremented the output pointer during
normalisation and made the apparent codewords constant. The runner now selects
ARP=1, loads the stock mixer's signed result into ACCB at its native 16-bit
scale, points AR7 at the serial buffer, and lets `0x817f..0x81b1` produce the
octet. The unchanged ISR writes that octet to DXR at `0x83ef`.

### Frame timing is the first blocker, and it is real

Given a frame clock — `NativeC5x.configure_rom_codec(True)` — the Quad
resident stops thrashing its serial port:

| | `SPC` writes | `TSPC` writes | final `pc` |
| --- | --- | --- | --- |
| no frame clock | 118 | 118 | `0x265b` (out of program space) |
| frame clock | **2** | **2** | `0x82eb` |

The 118 rewrites are therefore a stalled retry loop, not normal behaviour,
which is consistent with the `TXM = 0` / `MCM = 0` reading: the port waits on
external timing.

Read that table narrowly. `configure_rom_codec` does not supply a sustained
frame clock here — the run ends with `primary_frames = 2` and
**`frames_clocked = 0`**. What it changes is the `XRDY` answer: per
`native/c5x_core.cpp`, without the codec `XRDY` keeps an optimistic value,
and with it `XRDY` follows the codec's frame clock. Two frames were enough
for the firmware to settle its init. That is not the same as a working
timing source, and the table should not be read as one.

**This is a diagnostic, not a model.** The codec being enabled is the AC01,
which exchanges 16-bit words; the Quad runs `FO = 1`, 8-bit bytes. It is the
wrong peer, used only to establish that *some* frame source unblocks init.
A Quad board model needs its own timing source, not this one.

### Where it then waits

The firmware reaches a structured host-command wait at program `0x82d9`:

```
82d9  setc  intm
82da  calld 23f0, *
82dc  lar   ar1, #ff57      ; delay slot
82de  clrc  intm
82df  and   #0200           ; test bit 9 of what came back
82e1  bcnd  82ec, neq       ; set -> go do work
...
82ea  idle                  ; else wait for an interrupt
```

**Superseded — see [quad-c50-overlay-loader.md](quad-c50-overlay-loader.md).**
The address in `ar1` is `0xff57`, and the routine at `0x23f0` reaches it with
`lamm *`, which addresses a memory-mapped register by the low seven bits: MMR
`0x57`, inside the DSP I/O window. So the link is the DSP I/O window after all —
the same one the analog Courier's ASIC mailbox uses at `0x5e`/`0x5f`
([dsp-cpu-interconnect.md](dsp-cpu-interconnect.md)) — not global data memory as
first written here.

Identifying `0xff57` as *the* host flag cell is inference from the delay-slot
`lar`; the routine at `0x23f0` has not been read.

Writing `0x0200` into data `0xff57`, `0xff58` and `0xff63` does **not** advance
it, and the reason is now known: the value is read from an I/O port, never from
data memory. Seeding DSP I/O `0x58` does change the run.

### Interrupts do wake it

Delivering any of IRQ 0-7 moves it off `idle` into a loop at program `0x8109` /
`0x810c`, where it then runs steadily. But across 300,000 further instructions
there are still **no `DXR` or `TDXR` writes** and the codec clocks no frames.
It is running, and idle in the sense of having nothing commanded.

### What a tone would need

On the analog Courier a tone is a short mailbox conversation — tags `0x16`,
`0x19`, `0x1a`, `0x1b`, then `0x13:<digit index>`
([driving-the-tones.md](driving-the-tones.md), and `audio-312-path.md` for the
oscillator it drives). The Quad's equivalent command set is **unknown**: its
link is shared memory rather than that mailbox, so neither the tags nor the
cells transfer.

The remaining work, in order:

1. Read the routine at `0x23f0` to learn how the host word is actually
   fetched, and which cell carries the ready flag.
2. Decode the supervisor's side of the same queue — the 35 writes at
   `0x02ca..0x030e` are its initialisation, so the command encoding is
   reachable from the 80186 code that fills it.
3. Supply a frame source appropriate to `FO = 1` byte transfers rather than
   borrowing the AC01.

Only then is asking for a tone meaningful.


## Feeding it idle codewords

The right instinct for real hardware: a PCM receiver is never starved, and an
idle channel carries an idle codeword rather than nothing. The firmware agrees
— it has an `S71 T1 Idle Disconnect Pattern` register.

It does not help yet, and the reason is worth recording.

Queued 20,000 idle codewords into the receive side and stepped 1.5 M
instructions, trying mu-law `0xff` and `0x7f`, A-law `0x55` and `0xd5`, plus
`0x0000` and `0xffff` as controls, through both `queue_serial_rx` and
`queue_codec_rx`. Every variant gives the identical result:

```
pc=0x03e6  dxr=0x0001  tdxr_writes=0  rx_consumed=0  frames=2  clocked=0
```

Two things are wrong there, and neither is the codeword value.

`rx_consumed` stays 0: nothing is clocking frames, so the queue is never
drained. Feeding the right byte cannot matter while no frame sync consumes it.

More seriously, `pc = 0x03e6` is **outside the loaded program**. The resident
bank occupies program `0x8000..0xfa28`. A control run with no receive data and
no interrupt stays put at `0x82eb`; queueing receive data alone — without
delivering any IRQ — is enough to derail it, because the core raises a receive
interrupt and the firmware's handler leaves loaded space immediately.

So the blocker is not the idle pattern. It is that **the DSP program is
incomplete**: only the resident bank is loaded. Per
[x2/README.md](x2/README.md), the remaining 23,944 (QF) / 19,884 (QR) C50 words
are an overlay store whose selection mechanism is not yet decoded, and the
interrupt path evidently reaches code that is not in the resident. Any
experiment that provokes an interrupt will run off into unmapped memory until
the overlays are placed.

That reorders the remaining work. Before a tone, or an idle stream, is
meaningful:

1. Recover the Quad's C50 overlay placement, so a full program is loaded and
   interrupt handlers land in real code.
2. Then supply framing suited to `FO = 1` byte transfers, at which point an
   idle codeword stream becomes the correct thing to feed.
3. Then decode the shared-memory command queue to ask for a tone.

## What else the DSP code shows

Comparisons are against the SDL 3.02 payload from `IDSDL302.ROM`.

### Full six-rate V.34, byte-identical

The V.34 symbol-rate table is present and identical in all three images:

```
2400  2743  2800  3000  3200  3429      (0x0960 0x0ab7 0x0af0 0x0bb8 0x0c80 0x0d65)
```

at file `0x29ca2` in `IDSDL302.ROM`, `0x462fc` in `QF060003` (DSP program
`0x8ca6`), and `0x43b92` in `QR060103`. Immediately before it, the V.34 carrier
table is likewise byte-identical in all three:

```
1800  1829  1867  1875  1920  1959      (0x0708 0x0725 0x074b 0x0753 0x0780 0x07a7)
```

So the Quad runs the full V.34 rate and carrier set, and runs it from the same
tables as the analog Courier. That is consistent with the block-hash lineage —
V.34 is what both ends of a V.PCM connection need, and it is what carried over.

### One extra word where the 302 has none

In both Quad builds a single word follows the symbol-rate table before the code
resumes, and the 302 has nothing there:

| | after the table |
| --- | --- |
| `IDSDL302.ROM` | `ae80 8684 ...` — straight into code |
| `QF060003` (prog `0x8cac`) | **`0x1f40` = 8000**, then `ae80 8cf1 ...` |
| `QR060103` | **`0x1f40` = 8000**, then `ae80 8cfc ...` |

8000 is the DS0 sample rate, and a fixed sample rate is what a card clocked off
a TDM highway has, where the analog Courier switches its AC01 between 7200,
7578.95 and 8000 Hz by rate index
([codec-sample-rates.md](codec-sample-rates.md)). That reading is **not
established**: the word has not been traced to a use, and counting `7200` and
`8000` across the payloads does not corroborate it — both also occur as bit
rates, and the Quad in fact holds more of each than the 302 does. What is solid
is only the structural difference: one extra constant, in both Quad builds, at
the end of the rate-table block.

### Four CPUs, one DSP each

The card is **four 80186 + C50 engines**, not one supervisor driving four
channels. The single image runs on all four, which is why the resident is only
13% larger than the single-channel 302's and why the supervisor code is shaped
like a single modem throughout.

The firmware reads its own position. At `0x801d6`, early in the entry path:

```
mov  dx, 0x260
in   al, dx
shr  al, 4
and  al, 3            ; a 2-bit field: 0..3
mov  byte [0x213], al ; cached
cmp  byte [0x213], 1
je   0x801ec
call 0x80dd8          ; taken only when the position is not 1
```

So **port `0x260` bits 4-5 carry the engine's position**, cached at RAM
`0x213`, and position 1 is distinguished from the rest. The same field is read
again at `0x8169e`, and at `0x8262b` it drives a three-way dispatch
(`cmp al,1` / `cmp al,2` / else). Port `0x260` carries at least two other
fields, read as `and al,0xc0` at `0x81661` and `and al,0x0f` at `0x81683`.

Confirmed in the emulator by seeding the port:

| Seed | I/O events | MMIO events |
| --- | ---: | ---: |
| unseeded (reads `0xff`, so position 3) | 192,624 | 652 |
| `0x260 = 0x00` (position 0) | 192,624 | 652 |
| `0x260 = 0x10` (**position 1**) | **192,604** | **642** |
| `0x260 = 0x20` (position 2) | 192,624 | 652 |
| `0x260 = 0x30` (position 3) | 192,624 | 652 |

Position 1 diverges, by exactly the skipped `call 0x80dd8`. The branch is live
and the field is what selects it. All five still park at the chassis-link wait,
which is a separate blocker.

For a board model this is a required input: something has to present a position
on `0x260` bits 4-5, and the four instances differ.

The 8-word preamble the supervisor sends to destination `0xfff8` before the DSP
download remains unexplained.

### Does it print or respond? No — and now the control does

**The analog 302 answers; the Quad does not.**

The control had to be got working first. `IDSDL302.ROM` prints nothing at 8 M or
even 60 M instructions, which made an earlier version of this section
uninformative. The threshold is in `machine.py`: `DTE_READY_INSTRUCTIONS =
30_000_000`, so no run shorter than that opens the DTE at all. At 40 M with
`--tick-ms 5 --at ATI6` the 302 replies:

```
US\xd2o\xe2otic\xf3\xa0\xc3o\xf5rier\xa0V.\xc5\xf6er\xf9t\xe8i\xee\xe7 ... Link Diagnostics...
```

— the Link Diagnostics banner, with bit 7 set on some characters, which is the
parity bit arriving with the data rather than corruption.

Against that control, the Quad stays silent:

| Image | Instructions | ticks | serial ints | input left | output |
| --- | ---: | ---: | ---: | ---: | --- |
| `IDSDL302.ROM` | 40 M | 1,806 | 0 | **0** | the ATI6 banner |
| `QF060003` | 40 M | 1,654 | 0 | 5 | none |
| `QF060003` | 80 M | 3,488 | 0 | 5 | none |
| `QR060103` | 80 M | 3,633 | 0 | 5 | none |

The Quad never consumes a byte — all five of `ATI6\r` are still queued at 80 M —
and never writes `S0TBUF`. It is not slow to answer; it is not listening.

That is consistent with everything else here: the engine parks in the SDL poll
on the chassis interface, and on a NAC the command path is the backplane, not a
local DTE. The `S0` traffic counted in the supervisor (38 `S0CON` sites, 39
`S0TBUF`) is inherited Courier code on a path that never opens in isolation.

The `--at` mechanism is not the difference: `cli.py:255` shows `--at` simply
appends `\r` and hands the bytes to the same `serial_input` this used.

Two results stand from the attempts. Earlier `ticks = 0` readings here were an
artifact — the image shim lacked `emulates_interrupts`, so interrupt emulation
was never enabled; with it set the Quad reaches 239 timer interrupts and 888
ticks at `tick_ms = 1`, so its EB timer configuration is functional.

And **position 1 forks hard**. With `tick_ms = 5` over 8 M instructions:

| Position (`0x260` bits 4-5) | ticks | timer ints | I/O events | hot addresses |
| ---: | ---: | ---: | ---: | --- |
| 0 | 187 | 239 | 205,614 | `0x81976`, `0x81979`, `0x8197c`, `0x81980` |
| **1** | **2** | **0** | **385,236** | `0x80842`, `0x8082f`, `0x80751`, `0x8017f` |
| 2 | 187 | 239 | 205,614 | same as 0 |
| 3 | 187 | 239 | 205,614 | same as 0 |

Positions 0, 2 and 3 are indistinguishable; position 1 never reaches the timer
path and sits in the block-copy region instead. That is the
`cmp byte [0x213], 1` branch at `0x801e2`. For a board model the position input
is not cosmetic — one of the four engines runs a materially different startup.
