# What the 4.03d board has actually confirmed

Everything here was read off the physical 20.16 MHz Courier running supervisor
7.4.16 / DSP 3.1.2, or watched on its front panel, and then compared against an
emulator run of that board's own ROM capture. A board reading settles what a run
cannot: the emulator can be self-consistent and still wrong, which is how the
403 datapump carried a zero transmit level through a 600-test suite.

All reads were `AT`, `ATI*` and `ATGLK2=` page reads. Writes, where they
happened, were `ATGLK2O` port writes and are called out as such.

## Confirmed

| what | board | emulator | where |
|---|---|---|---|
| identity | `7.4.16` / `3.1.2`, serial `0009540034268322` | same | `ATI7` |
| transmit levels | `[0cd9]=32c8`, `[0cdb]=0c08` | matches with `idsdl403` | [datapump-dispatch-gate.md](datapump-dispatch-gate.md) |
| settings page | `B0 F1 M1 X7 &A3 &B1 &G2 &H1 &I0 &K1 ...` | same | `ATI5` |
| NVRAM self test | `TESTING NVRAM  OK` | same | `0x81412` |
| product code | `5607A` | same | `ATI0` |
| ROM checksum | `6C04` | same | `ATI1` |
| self test | runs only with the front panel button held | same, `--port 0x14=0xb5` | `0x877cd` |

The self test reproduces line for line, through the dipswitch page to
`SELF TEST COMPLETED`.

## The settings EEPROM

The boot block copies the whole 512-byte part into RAM `0x058e..0x078d` and
checksums it there at `0x81412`: byte 511 holds the sum of bytes 0..509, with
byte 510 added and taken straight back out.

That window is why `artifacts/courier-board-21210-ram-403/` contains the part
itself, and `CourierNvram.idsl403_fixture()` is those 512 bytes rather than
anything synthesised. Three things agree it is the store: it is identical across
both capture passes, its stored byte `0xbd` matches the rule where the
neighbouring ranges give `0xbe` and `0xbc`, and it carries the +S register block
at the offset derived from the ROM before the capture was read.

**A checksum-valid fixture over erased bytes is worse than no fixture.** An
intermediate revision did that, the firmware trusted the erased profile, and the
run lost its DTE output entirely.

## The front panel

`0x877cd` gates the self test on port `0x14` bit `0x40` reading low, and
`0x87e34` then spins while it is still low - a contact being released. It is the
button, not a DIP switch, and mapping `carrier-detect-override` onto it was
booting every `--dip-preset dedicated-line` run into the self test.

The lamp stage walks a nine-entry table at `0x8275f`, one line per ~281,500
instructions:

| idx | port/bit | lamp | idx | port/bit | lamp |
|---|---|---|---|---|---|
| 0 | `0x12`/`0x10` | HS | 5 | `0x12`/`0x02` | MR |
| 1 | `0x14`/`0x40` | *no lamp - the button* | 6 | `0x14`/`0x02` | **CS** |
| 2 | `0x14`/`0x10` | **AA** | 7 | `0x14`/`0x80` | **SYN** |
| 3 | `0x14`/`0x01` | **CD** | 8 | `0x14`/`0x20` | ARQ/FAX |
| 4 | `0x10`/`0x01` | OH, and the relay | | | |

The bold four are measured: driven one at a time with `ATGLK2O0014` against a
rest state of `0xff`, with a different blink count per bit so they could not be
confused, while the panel was watched. CS is the odd one - it drops whenever the
port is released, so it is driven from this latch and idles low.

The remaining five come from the release order read off the board, and the
alignment checks itself: exactly one of the nine steps was never seen to do
anything, and it falls on `0x14` bit `0x40`, the button, which has no lamp.
Nothing had to be assumed about where the silent step was.

    bit 0x01 (0xff <-> 0xfe)   CD blinks alone
    bit 0x10 (0xff <-> 0xef)   AA blinks alone
    bit 0x80 (0xff <-> 0x7f)   SYN blinks alone Index 4 reads as a
lamp *lighting* mid-sweep rather than going out, in both the board's sequence and
the emulated run, which is what identifies OH and the relay as one line.

Port `0x14` reads its **inputs** rather than this latch - `0xfe`, `0xff` and
`0x7f` all read back as `0x7e` - so the rest state cannot be read and is `0xff`,
which is what `0x82803` writes to release. A first attempt used the `0x7e` read
as its baseline, which held both bits driven throughout, and reported CD and SYN
moving together off bit `0x80`. That was the baseline, not the board.

**This table says which latch bit lights which lamp during the test. It does not
say the supervisor drives that lamp in service, and mostly it does not.** RD,
SD, TR, RS and CS are RS-232 signals before they are lamps and follow the wire.
Across a whole 150M-instruction dial the panel sees 23 writes,
`carrier-detect-a` and `carrier-detect-b` are never driven at all, and everything
that moves is the board-ID strap scan at boot plus the hook relay. The lamp
stage is a lamp *test* - the firmware takes over lines it otherwise leaves to the
hardware, precisely so every lamp can be seen. That is what makes the sweep
usable for naming them, and why the naming cannot be turned around into "the
supervisor controls this lamp".

### Two bits conflict with dsp-rom-probe, on this same board

[dsp-rom-probe.md](dsp-rom-probe.md) has its own single-bit strobe table, taken
on this unit (`/dev/cu.usbserial-21210`, serial `0009540034268322`). It lists the
same nine self-test entries in the same order, and five attributions agree
exactly - CD on `0x14` bit 0, CS on bit 1, ARQ on bit 5, SYN on bit 7, MR on
`0x12` bit 1. **Two do not:**

| bit | dsp-rom-probe | this file |
|---|---|---|
| `0x14` bit 6 (`0x40`) | HS lamp, observed | *no lamp* - the front-panel button |
| `0x12` bit 4 (`0x10`) | analog path, audible pop | HS lamp |

Both sides are user-reported panel observations, so neither transcript
arbitrates. What tips it is firmware: `0x877cd` gates the self test on port
`0x14` bit `0x40` **reading low**, and `0x87e34` then spins while it is still
low - that is an input being released, which a lamp drive is not. And the sweep
here saw nothing at all happen on that step.

**Settled by re-strobing the two bits one at a time**, watching the panel and
listening: `0x14` bit 6 from a rest state of `0xff`, and `0x12` bit 4 from its
shadow. If bit 6 lights nothing and `0x12` bit 4 lights HS, this file is right
and dsp-rom-probe's two rows shift. Until then neither attribution should be
built on.

## The hook

Port `0x10` bit `0x01` drives the relay and the OH lamp together, **active
high** - `0xdf` pulls in, `0xde` releases, chip-select held low throughout. The
model had the hook on bit `0x04` active-low; both bits are asserted on a dial,
`0x01` at `c8fbe` and `0x04` about 43,500 instructions later at `c8fe1`, so the
wrong bit still yielded an off-hook, just late.

`[0x020d]` bit `0x02` mirrors the hook - `0x09` on-hook, `0x0b` off-hook, moved
by pulling the relay in by hand with `ATGLK2O0010,DF`. Every other candidate cell
was identical between board and emulator. **The emulator never writes `[0x020d]`
at all**: a `--mem-watch 200:220` across a whole dial catches 96 writes in that
range and every one is to `[0x0210]`. The predicate at `0x8b449` tests bit 0 of
this same cell before its success branch, so the cell is on the path.

## The speaker is not a CPU port

Driving port `0x00` bit `0x40` directly, slowly enough to hear individual clicks,
on hook and off, produces no sound; neither does bit `0x04`. Only the relay is
audible. So the `0x81703` pulse that ticks once per lamp is not the speaker, and
the CPU port sweep was never going to find it.

The path is on the DSP side. [2806-codec-mailbox-control.md](2806-codec-mailbox-control.md)
traces it on the 25 MHz board: mailbox tag `0x0f` sets a gain for a scaled ADC
sample copy to ASIC I/O `0x50`, and the CPU's `M` handler drives a latch on port
`0x12` mask `0x10` with two further conditional `L` paths on masks `0x20` and
`0x40`. On that board RAM `0x0693` read `0x22`, which forces the monitor gain
argument to zero and makes the direct volume writer return without writing, so
neither programmable path was active.

**What the physical speaker circuit is remains unidentified**, and the earlier
reasoning that put it on the codec's `MON OUT` with register 4 as its volume was
withdrawn as unmeasured - see the correction at
[asic-pinout.md](asic-pinout.md#the-speaker-is-not-on-the-board-side).
`ATM` is settable now, so a dial under each `M` setting with the panel watched is
still the probe worth running.

## The `0x81703` pulse is the ASIC's watchdog kick

Not measured on the board. Inferred from the cadence, the wiring and the one
thing that stops it - stated here because it restores an attribution
[board-parts.md](board-parts.md) had to retire, and because one command settles
it.

Two different pieces of code do the kicking, and between them they cover the
whole run with no gap. The ROM holds the same twelve-byte sequence
`e4 00 24 33 0c 40 e6 00 24 33 e6 00` three times, at `0x816d3`, `0xa7955` and
`0xfc314`.

**In an interrupt handler, first thing.** `0xfc314` and `0xa7955` are the same
routine assembled for two placements - one `cs:`-relative, one absolute - and
the handler is copied into low RAM, where it runs at `0x0314`:

```
 30c  sti
 30d  pushaw / push es
 30f  mov ax, 0 / mov es, ax
 314  in al,0 / and 33 / or 40 / out 0 / and 33 / out 0   <- the kick
 320  mov di, cs:[0x100]        ; ring head
 325  sub di, cs:[0x102]        ; minus tail
 32a  jae .+4 / add di, 0x4000  ; 16K ring, wrap
 330  cmp di, 0x2000            ; half full?
```

It saves registers and kicks **before it looks at its own work** - which is
what you do with a watchdog and nothing else. The work is a 16 KB ring buffer
with head and tail at `0x100`/`0x102`.

That the copy lands at `0x0300` is deliberate: the firmware uses only vectors
`0x00`-`0x15`, so everything above offset `0x58` in the vector table is free
space, and it stores code there. A run's `interrupt_vectors` dump is therefore
junk above `0x15` - those entries are this routine being read as pointers.

### The ring is the DTE receive buffer, and port `0x14` bit 1 is its CTS

The two halves of it are next to each other in the ROM. The receive interrupt
at `0xfc38b` fills the ring; the periodic handler above drains the flow
control.

```
 38b  pushaw / push es / es = 0
 392  ax = [0xff68]            ; the 186's serial receive register
 395  di = cs:[0x100]          ; head
 39a  stosb es:[di]            ; store, di++
 39b  cmp di, 0x5975 / jbe
 3a1  mov di, 0x1975           ; wrap
 3a4  cs:[0x100] = di
 3a9  di -= cs:[0x102]         ; occupancy
 3b4  cmp di, 0x3e00 / jb      ; 15,872 of 16,384 - 97% full
 3ba  ax = 0x020a / al = cs:[0x11c] / or al, ah / out 0x14, al
```

So the ring is **16 KB at `0x1975`-`0x5975`**, head at `cs:[0x100]`, tail at
`cs:[0x102]`, and `cs:[0x11c]` is a shadow of port `0x14`.

- **High water**, in the receive interrupt: occupancy >= `0x3e00` **sets**
  bit `0x02` at port `0x14`.
- **Low water**, in the periodic handler right after the watchdog kick:
  occupancy <= `0x2000` (half) **clears** it.

That is CTS hardware flow control with hysteresis, and it identifies the bit.
`panel.py` already has `Led("CS", 0x14, 0x02, ..., "measured: drops when the
port is released")`, and `0x14` is active low - so setting the bit drops CS and
stops the DTE, clearing it raises CS and lets it send. The lamp and the line
are one bit, which is what a `CS` lamp is for.

**This does not displace "port `0x14` bit 1 is ring sense."** The cadence
machine at `0x1501d` does `in al, 0x14 / test al, 2`, so the same bit number is
read there and written here - but a latch can carry different signals in each
direction at one address, and port `0x00` in this firmware is the worked
example: `0x33` reads as strapped inputs while `0xc4` are outputs.
`machine.py` already models `0x14`'s read side from the panel and strap inputs
rather than from the written latch. So the reading is bit 1 out = CS/CTS,
bit 1 in = ring sense, and the two routines coexist.

That restores the optocouplers as ring detect and loop-current sense.
[board-parts.md](board-parts.md) reached for them and then hedged on the
grounds that "ring sense already has a port (`0x14` bit 1)" - it does, on the
read side, and the opto is what would drive it. `U14` and `U16` have the ASIC
on their transistor side, so the ASIC receives both, which is the right
direction for an input the CPU then reads out of a latch.

The periodic handler's remaining work is three 16-bit countdowns at `cs:[0xf8]`,
`[0xfa]` and `[0xfc]`, decremented when nonzero, then `mov word [0xff02],
0x8000` - the 186's end-of-interrupt - and `iret`.

**And in the foreground**, at `0x816d1`, for when that handler is not running:

```
816d1  pushf / cli            ; the pulse must not be interrupted
816d3  in  al, 0
816d5  and al, 0x33           ; keep the four strapped input bits
816d7  or  al, 0x40 / out 0   ; raise
816db  and al, 0x33 / out 0   ; drop, next instruction pair
816df  popf / ret
```

On a 44.1 s leased-line run of `IDSDL302.ROM` the two sites fire 309 times
between them, and they hand over cleanly:

| site | kicks | span |
|---|---|---|
| the ISR copy at `0x316` | 224 | instruction 22,527 - 5,046,271 (1.48 s) |
| the foreground at `0x816d5` | 85 | instruction 5,342,208 - 149,887,999 (42.5 s) |


The first kick is at instruction 22,527, immediately after reset; the last is
at 149,887,999, the final moment of the run. The handler phase runs at a flat
151 Hz; the foreground phase is steady between 81 ms and **536 ms**.

A service that begins at reset, never stops, and whose interval has a ceiling
is a watchdog. A status poll would wander; a lamp driver would go quiet when
idle. `cli`/`popf` around a two-instruction pulse says the *width* matters,
which is an edge into a retriggerable monostable rather than a level a latch
holds.

The ASIC is the only part that can act on it. It resets the CPU through `R1`
from ASIC pin 52 into `RESIN`, and the `ADM707`'s watchdog is unused with pin 6
not connected, so the supervisor cannot. And the board resets a halted monitor
after about 1.5 s ([probe_transport.py](../courier_emu/probe_transport.py)) - a
measured bound whose trigger `board-parts.md` left unattributed when it retired
the `ADM707` explanation. 536 ms worst case against ~1.5 s is the margin you
would design for.

What suppresses the pulse closes it. `0x816ca` skips the kick when `[0x5a2]`
bit 7 is set, and exactly one site sets that byte: an `AT` parser matching
`!` at `0xa629d`. Stopping the kick is how a modem resets itself from the
command line.

**To settle it:** type `AT!` and see whether the board resets about 1.5 s
later. A scope on ASIC pin 52 does it the other way round. Either reading also
gives `board-parts.md` its attribution back.

This bit is not the speaker - see the section above - and not the line relay,
which is port `0x10` bit 0. Nor could it be: nothing mechanical switches at
151 Hz.

## Two port read-backs, measured

| port | board | emulator |
|---|---|---|
| `0x10` | `0x86` on-hook, `0x87` off-hook | `0xff`, with the NVRAM bits overlaid |
| `0x00` | `0x00` | `0x33` on the input bits |

Port `0x10` bit `0x01` mirrors the hook on the board and the emulator answers
open bus, so any firmware routine reading the port back to maintain `[0x020d]` is
being told the line is permanently off hook.

Port `0x00` is worse, because that value is one this project chose: it was set to
answer `PORT0_INPUTS` high on the reasoning that answering from the latch cost
`ATI7` its option list. The board answers `0x00`. The four bits are not
capability inputs reading high, the guess was wrong, and whatever moved the
option list has another cause still to find.

The broader shape of the port space is in [asic-port-map.md](asic-port-map.md):
only even ports decode, the decode stops at `0x7f`, and the idle default is
`0x00` where the harness returns `0xff`.

## The dial-tone wait

This is the one functional gap left on the originate path, and it is not a 403
fault.

**Both builds behave identically for a given `X`.** The "403 does not dial"
thread rested on an uncontrolled comparison - 302 dialled and 403 did not, and
the difference was taken to be the build. It is the `X` level, which sets two
things at once, so the sweep separates them: `X0` and `X1` both dial blind and
differ only in verbosity, `X2` and `X4` both wait for dial tone.

| | dialled | exchange | DTE transcript |
|---|---|---|---|
| 302, its fixture's default | `6245` | connected, answered | - |
| **302 + `ATX4`** | `""` | idle | `NO DIAL TONE` |
| 403 + `ATX0` | `6245` | connected, answered | `OK` |
| 403 + `ATX1` | `6245` | connected, answered | `OK` |
| 403 + `ATX2` | `""` | idle | `OK`, then `NO DIAL TONE` |
| 403, its fixture's default (`X4`) | `""` | idle | `NO DIAL TONE` |

Every waiting level fails on both builds and every blind level succeeds on both.
What differed was the **fixture**: `idsdl403` is the board's own captured settings
part carrying the unit's stored `X4`, and `idsdl302` is a mostly-erased part that
lands on a level that dials blind. 403 was obeying `X4` correctly and reporting
truthfully.

**And the `OK` in those rows is not the call's.** It is the `ATXn` command's own
acknowledgement. Under `X1`, where a completed call must answer `CONNECT`, the
dial produces no result code at all - so on the connecting path the dial never
terminates as far as the DTE is concerned, and the only evidence the call
happened is the exchange's.

### What the board does

Sampled with the co-resident sampler (`cooperative_probe.py`, chained onto INT3,
ring at `0x1a00`, read back to the write pointer), across four dials with
`S0=0`, `X4`, `S7=8`:

    run 1-4  NO CARRIER  n=960  hook=239  0x03 pulses on port 0x5c at 148, 370

Not approximately - the same sample index in all four. The mailbox low byte idles
at `0x82`, drops to `0x02` around the seizure, and pulses bit 0 once 0.30 s
*before* the hook closes and once 0.43 s after it. The high byte `0x5e` never
moves. A no-dial control with `ATS0=0` is flat throughout.

Unplugged, twice: both pulses gone, and `[0x020d]` never changes, so the relay
never closes. With an open pair the firmware declines before the hook and reports
`NO DIAL TONE` for a tone it never went off hook to listen for. So both pulses
are line-dependent and that byte is the relay actually closing, not a command
echo.

That makes one reading natural - 148 is the line-presence check that permits the
seizure, 370 is what the firmware waits for before dialling - but does not prove
it. Unplugged is not the same test as *plugged in with no dial tone*, and the
sample-exact reproducibility cuts both ways: it says the capture is solid, and it
also means the timing is fully determined by the firmware, which is what you would
expect either from a scheduled step or from detecting a tone already present when
the detector starts.

`0x5c` is the ASIC's host/DSP mailbox group, so a value appearing there that the
supervisor did not write comes from the DSP side. Tone detection is the C52's
job, which makes the pulse a DSP report rather than a flag the supervisor sets
for itself.

### What the emulator does

Three harness faults were found on this path and fixed, and the wait still fails.

**The C52 was not executing at all.** `bridge.py` rebuilds the core on a DSP
reset and sets `active = False`, restoring it only when a re-download reaches
`bootstrap_target_size`. The bootstrap accumulator was being cleared on any
`ENTRY_REQUEST_COMPLETE` written to `0x1c` while `not active` - which is the
whole re-download - so every such write threw away the bytes collected so far and
`active` never came back:

    CLEAR had=16     at  5,071,977     the legitimate one: setup, 8x 0083 words
    RESET            at 46,308,306
    CLEAR had=1056   at 46,313,613     <-- wipes a download in progress
    CLEAR had=2256   at 46,324,871
    ...                                and thereafter had=0, forever

The clear is meant to fire once, before program data starts. Its guard needs to
distinguish setup from program rather than testing `active`, which is false for
both. Guarded so it fires only while the accumulator still holds setup, the DSP
comes back: 129M instructions, `codec_rx_consumed` 0 -> 50,818, `drr_reads` 0 ->
66,657.

**The reset is recognised by the wrong signal.** The supervisor pulses the actual
C52 reset line - `ff56` bit 1 - twice immediately before each download, and
asserts it four times across a dial. The harness recreates the core for exactly
one of them, 74 instructions after the last release, because eight data bytes
happened to match `expected_bootstrap[:8]`. `machine.py` already takes that same
edge into `float_runtime_bus()`. The byte match is a stand-in for a signal that is
present, observable and already routed.

On the part, asserting RS resets the CPU and leaves memory alone; the harness
builds a fresh `NativeC5x`, wiping it. That costs the *program* nothing - the
supervisor re-downloads the whole 55 KB resident either way, `bootstraps: 2`,
`bootstrap_bytes: 56656`, byte-identical - so the guess that persistent RAM would
mean a short download is wrong. Whether the resident depends on its **data**
memory surviving is not measured.

**The audio in flight was destroyed with the core.** Peaks at each hop located it
exactly:

    line_rx_peak       7986   what the exchange handed the bridge
    codec_in_peak      7986   what reached _queue_line_audio
    codec_handed_peak     0   what reached the C52 that is still running
    codec_rx_peak         0   what the C52 itself ever saw

The tone was generated, converted and queued correctly, and then the bridge built
a fresh core 31 ms later and the queued audio went with it. The board's terms give
the fix directly: **the AC01 is not part of the C52.** It sits on the C52's
primary serial port where the DSP is a slave (`SPC = 0x40c8`, `MCM = 0` so `CLKX`
is an input, `TXM = 0` so `FSX` is an input), clocking a word into `DRR` every
frame from something that is not the C52 and does not stop when the C52 is reset.
There is no FIFO; the words in flight are in the AC01 and on its serial link,
outside the part being reset. So the bridge now keeps what the codec has clocked
out and the C52 has not taken - trimmed to the core's own
`codec_rx_queued - codec_rx_consumed` - and re-presents it to the new core:

    replayed across the rebuild        11,305 words
    DSP-side codec_rx_peak    0  ->  7,878
    codec_rx_consumed   130,684  -> 141,989

**The C52 now hears the dial tone**, over a second and a half of it. 302 and
`403 + ATX1` are unchanged; neither replays anything because neither rebuilds
while audio is in flight.

**And `403 + ATX2` still answers `NO DIAL TONE`**, with every other number in the
run identical to before the fix - same DAA, same seizure, same exchange timing,
same 134 DSP-originated messages. Only `codec_rx_consumed` moved, by exactly the
11,305 replayed.

### Answered: the tone was wrong, and the resident does detect

The resident was never deaf and never needed arming. It was being shown a tone
its detector does not answer.

The control was exact - the same run twice, the same 11,305 replayed words at
the same instruction, carrying dial tone in one and zeros in the other - and it
looked like a dead end: `codec_rx_peak` 7,878 against 0, and **every other
number identical**, including the tag histogram. 209,162 `DRR` reads, 134
messages, the same three tags, whether it heard dial tone or silence.

Then the tone became a parameter. The exchange was presenting
`DIAL_TONE = (350, 440)` - **North American precise dial tone** - to a unit
whose own `ATI7` says `Product type Russia (ex. US/Canada) External`, plugged
into a loop carrying a single continuous 400 Hz.

| `--exchange-dial-tone` | codec peak | tag histogram |
|---|---|---|
| `us` 350+440 | 7,878 | `0000` x71, `0002` x62, `0003` x1 |
| `nz` 400 | 3,909 | `0000` x71, `0002` x61, `0003` x1, **`0042` x1** |
| `eu` 425 | 4,000 | `0000` x71, `0002` x59, `0003` x1, **`0042` x3** |
| `eu` 425, double level | 8,000 | `0000` x71, `0002` x53, `0003` x5, **`0042` x4, `0043` x1** |

**`0x0002` and `0x0003` become `0x0042` and `0x0043`** - the same low bits with
`0x40` added, and `0x40` appears **only** for a continuous single tone, never
for 350+440. So tag `0x08` is a status word the resident sends continuously, and
**bit `0x40` in it is the dial-tone report**.

So the mailbox consume path is now the right thing to build, and for the first
time what it would carry is identified rather than assumed: `0x0008` with bit
`0x40` set, on the DSP-to-CPU direction whose 20 ms cadence the board already
gave us, and which `runtime_inbound_delivered` shows nothing consumes.

One end of that is built. `_collect_dsp_messages` reads the core's mailbox
holding pair after each DSP quantum and turns a rising write count on the word
cell into an inbound message - 389 messages on a 302 dial, 378 on a 403 dial
under `ATX0`. The other end is not: the supervisor never reads the tag lanes and
writes `0x1c` with bit 1 clear, so nothing is ever popped.

Still open, and now narrow:

* **The report is sparse** - a handful over more than a second of tone, where the
  board's own reply cadence is 20 ms. Whether the supervisor needs it sustained,
  and why the emulated resident only asserts it intermittently, is unmeasured.
* **The level model is wrong in a way that matters.** Real dial tone is specified
  at a level, not per component, so `TONE_LEVEL` should apply to the composite.
  That is why `us` reads 7,878 and `nz` 3,909 for tones that on a real loop would
  be the same loudness. Any sweep to confirm the detector's centre frequency is
  confounded until this is fixed.

## Where the retune is: the DSP, not the country record

The image carries a country table at file offset `0x1fd20` (physical `0x9fd20`),
24 entries of **121 bytes**, each beginning with a 16-byte name padded with `!`
then a country code byte:

| code | country | code | country | code | country |
|---|---|---|---|---|---|
| 0 | US/Canada | 39 | Italy | 49 | Germany |
| 81 | Japan | 64 | **New Zealand** | 0 | International |
| 102 | Finland | 42 | Czech/Slovakia | 43 | Austria |
| 46 | Sweden | 32 | Belgium | 97 | Ireland |
| 44 | UK | 45 | Denmark | 34 | Spain |
| 47 | Norway | 61 | Australia | 95 | Portugal |
| 41 | Switzerland | 33 | France | 82 | South Korea |
| 31 | Netherlands | 27 | South Africa | 88 | Taiwan |

Mostly ITU dialling codes, with USR's own numbering for a few. **There is no
Russia entry**; `ATI7`'s `Product type Russia (ex. US/Canada) External` comes
from a different string at `0x49980`, so the product type is not the country
record. The Russian build's own additions elsewhere are Caller ID features
(`RussianCID`, `+S61`), not a country. The per-country payload is dense - some
60 of the 105 bytes after the name differ between US/Canada, UK, New Zealand and
Australia - but nothing in it is a literal frequency, so the tone the detector
expects is a coefficient or an index, and the fields are not decoded.

**And the country table is not where the retune happened.** Diffing the two
captures of *this same board* - `courier-board-21210-capture-01`, stock 7.3.14 /
DSP 3.0.13, product type `US/Canada External`, against `-403`, ID_SDL 4.03d,
7.4.16 / DSP 3.1.2 - the table was rewritten wholesale: stride 110 → 121 bytes,
20 → 24 entries, every record changed at `+20`, `+21`, `+53`, `+54` and gaining a
common 11-byte tail. Beyond that format change:

    US/Canada        0 further bytes changed
    Ireland          1
    New Zealand      2
    South Africa     8
    Australia       10
    Germany         12
    ...
    Italy           41
    Netherlands     45
    Austria         57

**US/Canada is the only record with no country-specific edit at all.**

The retune is in the DSP, whose revision changed 3.0.13 → 3.1.2. Running each
firmware against the same exchange and counting the resident's `0x40` reports:

| firmware | DSP | `us` 350+440 | `nz` 400 | `eu` 425 |
|---|---|---|---|---|
| stock 7.3.14 | 3.0.13 | **3** | - | - |
| ID_SDL 4.03d | 3.1.2 | **0** | 1 | **3** |

Three reports for the matching tone in each, none for the mismatched one. **The
stock DSP answers North American dial tone and the ID_SDL DSP does not**; the
ID_SDL DSP answers a single continuous tone near 400-425 Hz. The country record
did not have to change because the retune is in the resident.

Which explains the board on the bench: a US/Canada unit whose detector now
expects a Russian-style continuous tone, sitting on a New Zealand loop carrying a
solid 400 Hz - close enough that it finds dial tone, which it would not have done
on 350+440 after the flash.

**What the harness should do.** The faithful default depends on which image is
running: `IDSDL302.ROM` and the 4.03d capture want a continuous tone (`eu` 425 is
the ITU-T E.180 tone the Russian build is presumably tuned to and produces the
most reports), and the stock 7.3.14 capture wants `us` 350+440. Neither is
currently the default for its own image - `--exchange-dial-tone` defaults to `us`
for everything. Tying the default to the image's DSP revision is the obvious fix
and is **not** made yet, because the level model above is still wrong and would
confound any confirming sweep.

## XMF-only logic

The XMF payloads load at `0x40000` and the board ROMs at `0x80000`, so any
address literal the harness holds in `[0x40000, 0x80000)` can only ever be reached
by an XMF run. `tools/xmf_only_sweep.py` lists them: 110 lines in `machine.py`,
plus a handful in `panel.py` and `daa.py`.

Most are correct and deliberate - the XMF supervisor has its own boot, delay-loop,
serial and callback quirks, milestones are `{}` for a ROM with a comment saying
why, and the ROMs reach their DTE through the 80C186EB serial unit at `ff60` which
`uart.py` models. What the sweep is for is the other kind: a block providing a
service *both* families need, where only the XMF address was ever found.

| block | consequence on a ROM run | state |
|---|---|---|
| the serial ISR-exit blocks, behind a hot-address set they could not reach | XMF DTE went deaf | fixed |
| `carrier-detect-override` mapped to `0x14`/`0x40` | every dedicated-line run booted into the self test | fixed |
| the DAA detector byte `[0x649]`, published at `0x5DB9D`/`0x5DBE7` only | dead on both ROM builds | see above |

That last is the dial-tone wait seen from the other side. `machine.py`'s five-hit
counter at `[0x649]` is a `main211` model: neither ROM run reaches those addresses
and neither emits the `daa ...-qualified 0649=05` trace line. It should be read as
a record of how the 211 path was modelled, not as anything the 302/403 supervisor
does. Whatever feeds the ROM builds' wait has to be built, not re-pointed.

Two justifications are ROM-unverified rather than wrong: `panel.py` derives ring
detect from `0x70fb4`, the XMF answer machine, and the `DIP_SWITCHES` descriptions
all cite XMF addresses. The ports and bits may well be the same; nothing has
checked. Note that `panel.py` puts ring detect on `0x14` bit `0x02` while the lamp
sweep measured that bit as CS - port `0x14` has a read/write asymmetry so both can
be true, but it is unchecked on 302/403.

## Still open

- **What `0x5de57` is doing.** It drives `0x14` bits `0x01` and `0x80` together
  for the `&C` setting, and those are measured as two different lamps, CD and SYN.
- **What port `0x10` bit `0x04` is.** Asserted on every dial, nothing visible or
  audible when driven directly, on hook or off.
- **Which line is the speaker**, and what the 2806's board-type flags at RAM
  `0x0693` physically gate.
- **Feeding the resident before the overlay.** The gate is `m_call_tdm_active` at
  `native/c5x_core.cpp:923`, set only when the call overlay comes up. The board
  detects dial tone 0.43 s after the seizure with no overlay in sight. (Not the
  cause of the silent receive path - with `m_rom_codec` set, and it is set for both
  board images, the frame driver takes `codec_frame()` with no overlay condition.)
- **The tail of the board's lamp sequence.** After `SELF TEST COMPLETED` the board
  shows CS, RD and AA moving in a pattern the emulated run does not reproduce.
  Probably not a missing *write*: those lamps follow DTE handshake and data lines,
  which is also what `TR RS CS` lit at power-on is. Reproducing it means modelling
  the panel as following the serial signals; `uart.py` tracks CTS and DTR but no
  lamp is wired to them.

## ff56 is P1LTCH, and the firmware never programs P1 as a port

Confirmed against the 80C186EB manual's peripheral control block map
(`270830-003`, chapter 11): offsets `50H` `P1DIR`, `52H` `P1PIN`, `54H`
`P1CON`, `56H` `P1LTCH`. With the block where this firmware puts it, `0xff56`
is the **Port 1 data latch** and the DSP reset is a CPU pin driven from it -
`P1.1`, CPU pin 58, to DSP `RS` pin 127, as this document already states.

What a full 403 dial actually touches in that bank:

| register | 80C186EB name | accesses on the originating end |
|---|---|---:|
| `ff50` | P1DIR | **none** |
| `ff52` | P1PIN | **none** |
| `ff54` | P1CON | **none** |
| `ff56` | P1LTCH | 36,482 reads, 36,494 writes |
| `ff58` | P2DIR | 1,044 writes |
| `ff5a` | P2PIN | 8,360 reads |
| `ff5c` | P2CON | none |
| `ff5e` | P2LTCH | 6,252 writes |

Port 2 is used exactly as the manual describes - a direction register, a pin
register for input and a latch for output. Port 1 is driven read-modify-write
through the latch alone, and **`P1CON` and `P1DIR` are never written in a
whole run**. Both reset to `FFH`, which is every pin peripheral-controlled and
every pin an input, and the manual is explicit about what that means for the
latch: "This value appears at the pin only if it is programmed as a port."

So as modelled, none of these latch writes would drive any pin on real
silicon. Either the block is relocated somewhere that makes `ff50`/`ff54`
something else, or Port 1 is configured in a path this harness never executes.
Recorded because it bears on every signal attributed to this latch, the DSP
reset among them.

### The reset bit in the code disagrees with this document

`machine.py` selects `ROM_DSP_RESET_BIT = 0x0008` - bit 3 - for an image with
no supervisor offset, which is what a board ROM dump is. This document, and
`board.md`, `asic-pinout.md` and `c51-cpu-loader.md`, all name **bit 1**.

Measured per-bit edge counts on `ff56` over one dial confirm which bits are
signals and which are attributions:

| bit | edges, originator | edges, answerer | what it is |
|---:|---:|---:|---|
| 2 | 29,177 | 29,177 | EEPROM `SK` clock |
| 5 | 1,043 | 1,043 | EEPROM `CS` |
| 1 | 12 | 16 | named here as C52 `RS` |
| 3 | 12 | 16 | what the code resets on |
| 0, 4, 6, 7 | 1 | 1 | never driven after init |

Bits 1 and 3 carry **the same number of edges** and move within about a
thousand instructions of each other, so on this image the two attributions
produce nearly the same reset schedule and changing the constant does not
change which resets happen. The disagreement is still worth closing, but it is
not the reason an originating end stays silent.

### What the reset schedule does say

Resets applied, one dial, `--answer-on-ring`:

| end | reset pulses |
|---|---|
| originator | 3 at startup, then two pulses at 38.3 M instructions - 9.0 s, **before it dials** |
| answerer | 3 at startup, two at 85.3 M (22.05 s) and two at 91.1 M (24.03 s) - **at answer** |

The answering end pulses the reset as it goes into data mode and its datapump
runs from there. The originating end's last reset is before its first digit,
and it never gets another, because it never reaches the transition that
produces one: its `ATD` never returns. Its serial output for the whole run is
`OK`, the reply to `ATX0` - no `CONNECT`, no `NO CARRIER`, no `BUSY`, 50 s
after dialing. So the dial command is still blocked on something, and that,
not the reset, is what to find next.

### The reset is the downloader's, and the originator only ever runs it once

Logging the CPU program counter at every edge of the reset net: all of them,
on both ends, come from one routine.

```text
8e43c   assert   ff56 <- 0002
8e448   release  ff56 <- 000a
```

That is the ROM's DSP downloader. The reset is not a wipe the harness happens
to apply; it is the front half of a download, pulsed twice per load, which is
what this document recorded from the board.

Counting entries to it over one dial with `--answer-on-ring`:

| end | downloader entries |
|---|---|
| originator | **one**, at 38.3 M instructions - 9.0 s, before the first digit |
| answerer | **two**, at 85.3 M (22.05 s) and 91.1 M (24.03 s), at answer |

The answering end loads once to answer and again for the datapump, and
transmits from there. The originating end loads the program it dials with and
never asks for another, so the datapump is never downloaded to it. It is not
that a reset stops it starting - it is that nothing ever requests the second
load.

Its DSP is not idle while this happens. The detector bitmap it reports over
the mailbox walks `0002 -> 0880 -> 0980 -> 0881 -> 0885 -> 08c5` across the
call, setting and clearing bit `0x0040` - the detector at cell `03be` - and
the supervisor takes 1,567 of those messages. So the reports arrive and the
CPU does not act on them.

The open question is therefore what makes the supervisor enter `8e43c` for the
datapump on an originating call, and it is a CPU-side question about the path
that consumes those detector reports.

Note also that `overlay_downloads` stays 0 on both ends while this routine runs
three times between them, so that counter is not watching this download path.
