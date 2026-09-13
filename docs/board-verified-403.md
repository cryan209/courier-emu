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
| 2 | `0x14`/`0x10` | *unknown* | 7 | `0x14`/`0x80` | **SYN** |
| 3 | `0x14`/`0x01` | **CD** | 8 | `0x14`/`0x20` | ARQ/FAX |
| 4 | `0x10`/`0x01` | OH, and the relay | | | |

The bold four are measured: driven one at a time with `ATGLK2O0014` against a
rest state of `0xff`, with a different blink count per bit so they could not be
confused, while the panel was watched. CS is the odd one - it drops whenever the
port is released, so it is driven from this latch and idles low.

The remaining five come from the release order read off the board, and the
alignment checks itself: exactly one of the nine steps was never seen to do
anything, and it falls on `0x14` bit `0x40`, the button, which has no lamp.
Nothing had to be assumed about where the silent step was. Index 4 reads as a
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

### What is left

Nothing turns "the C52 heard 350 + 440 Hz" into the thing the supervisor's
originate path waits on. One end is built: `_collect_dsp_messages` reads the
core's mailbox holding pair after each DSP quantum and turns a rising write count
on the word cell into an inbound message. It collects real traffic - 389 messages
on a 302 dial, 378 on a 403 dial under `ATX0`. On the failing dial the resident
sends only 28, all `0008:0000` about 70 ms apart, a heartbeat rather than a
report, and `runtime_inbound_delivered` stays empty on **every** path including
the `ATX1` calls that connect and answer. So the supervisor consumes no
DSP-originated message at all yet; the working call is carried by the bridge's own
overlay logic. The pop needs the supervisor to read the tag lanes and write `0x1c`
with bit 1 clear, and it never does.

Whether that is because tag `0x08` is not what it waits for, or because the
handshake needs more than the queue, is not settled. The board's `0x5c` pulse is
the shape the path has to produce.

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
- **What lamp is on `0x14` bit `0x10`** (index 2, `id-strap-drive-c`).
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
