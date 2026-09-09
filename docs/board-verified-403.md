# What the 4.03d board has actually confirmed

Everything here was read off the physical 20.16 MHz Courier running supervisor
7.4.16 / DSP 3.1.2, or watched on its front panel, and then compared against an
emulator run of that board's own ROM capture. It is kept separate from the
analysis documents because a board reading settles a question that a run
cannot: the emulator can be self-consistent and still wrong, which is how the
403 datapump carried a zero transmit level through a 600-test suite.

All reads were `AT`, `ATI*` and `ATGLK2=` page reads. Nothing here wrote to the
board.

## Confirmed

| what | board | emulator | where |
|---|---|---|---|
| identity | `7.4.16` / `3.1.2`, serial `0009540034268322` | same | `ATI7` |
| transmit levels | `[0cd9]=32c8`, `[0cdb]=0c08` | was `0000`, now matches | [datapump-dispatch-gate.md](datapump-dispatch-gate.md) |
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
anything synthesised. Three things agree it is the store: it is identical
across both capture passes, its stored byte `0xbd` matches the rule where the
neighbouring ranges give `0xbe` and `0xbc`, and it carries the +S register
block at the offset derived from the ROM before the capture was read.

**A checksum-valid fixture over erased bytes is worse than no fixture.** An
intermediate revision did that, the firmware trusted the erased profile, and
the run lost its DTE output entirely.

## The front panel

`0x877cd` gates the self test on port `0x14` bit `0x40` reading low, and
`0x87e34` then spins while it is still low - a contact being released. It is
the button, not a DIP switch, and mapping `carrier-detect-override` onto it
was booting every `--dip-preset dedicated-line` run into the self test.

The lamp stage walks a nine-entry table at `0x8275f`, one line per ~281,500
instructions. Driving the bits and watching the panel names all nine:

| idx | port/bit | lamp | idx | port/bit | lamp |
|---|---|---|---|---|---|
| 0 | `0x12`/`0x10` | HS | 5 | `0x12`/`0x02` | MR |
| 1 | `0x14`/`0x40` | *no lamp - the button* | 6 | `0x14`/`0x02` | **CS** |
| 2 | `0x14`/`0x10` | **AA** | 7 | `0x14`/`0x80` | **SYN** |
| 3 | `0x14`/`0x01` | **CD** | 8 | `0x14`/`0x20` | ARQ/FAX |
| 4 | `0x10`/`0x01` | OH, and the relay | | | |

The bold four are measured, not inferred: driven one at a time with
`ATGLK2O0014` against a rest state of `0xff`, with a different blink count per
bit so they could not be confused, while the panel was watched. CS is the odd
one - it drops whenever the port is released, so it is driven from this latch
and idles low.

The remaining five come from the release order read off the board, and the
alignment now checks itself: exactly one of the nine steps was never seen to do
anything, and it falls on `0x14` bit `0x40` - the front-panel button, which has
no lamp on it. Nothing had to be assumed about where the silent step was.

    bit 0x01 (0xff <-> 0xfe)   CD blinks alone
    bit 0x10 (0xff <-> 0xef)   AA blinks alone
    bit 0x80 (0xff <-> 0x7f)   SYN blinks alone

Port `0x14` reads its inputs rather than this latch - `0xfe`, `0xff` and `0x7f`
all read back as `0x7e` - so the rest state cannot be read and is `0xff`, which
is what `0x82803` writes to release. A first attempt used the `0x7e` read as
its baseline, which held both bits driven throughout, and reported CD and SYN
moving together off bit `0x80`; that was the baseline, not the board.

Releasing the port also drops CS, so CS is driven from here and idles low.

Those two fixed points also re-align the sweep. The alignment needs one step of
the nine to have been invisible, and with CD at index 3 it is index 2 rather
than index 3 - `0x14`/`0x10`, named `id-strap-drive-c` for its other use, whose
lamp is still unknown.

Index 4 reads as a lamp *lighting* mid-sweep rather than going out, in both the
board's sequence and the emulated run. That is what identifies OH and the relay
as one line: the sweep drives `0x10` bit `0x01` and never touches bit `0x04`.

**This table says which latch bit lights which lamp during the test. It does
not say the supervisor drives that lamp in service, and mostly it does not.**
RD, SD, TR, RS and CS are RS-232 signals before they are lamps, and in normal
operation they follow the wire rather than a latch. The runs say so plainly:
across a whole 150M-instruction dial the panel sees 23 writes, `carrier-detect-a`
and `carrier-detect-b` are never driven at all, and everything that does move
is the board-ID strap scan at boot plus the hook relay. The same two lines are
driven twice each in the self test, and only inside the lamp sweep.

So the lamp stage is a lamp *test* - the firmware takes over lines it otherwise
leaves to the hardware, precisely so that every lamp can be seen. That is what
makes the sweep usable for naming them, and it is also why the naming cannot be
turned around into "the supervisor controls this lamp".

The speaker is port `0x00` bit `0x40`, pulsed high then straight back low by
`0x81703` - one click, called once per lamp as the sweep releases them, which
is the ticking that stage makes.

## The hook, the speaker, and what X7 exposed

Port `0x10` bit `0x01` drives the relay and the OH lamp together, active high -
`0xdf` pulls in, `0xde` releases, chip-select held low throughout. Bit `0x04`
does nothing observable on or off hook. The model had the hook on bit `0x04`
active-low; both bits are asserted on a dial, `0x01` at `c8fbe` and `0x04`
about 43,500 instructions later at `c8fe1`, so the wrong bit still yielded an
off-hook, just late.

**The speaker is not identified.** `0x81703` pulses port `0x00` bit `0x40` once
per lamp as the sweep releases them, which looked conclusive next to the
ticking that stage makes. Driving that bit directly - slowly enough to hear
individual clicks, on hook and off - produces no sound, and neither does bit
`0x04` of the same port. Only the relay is audible. Either these writes do not
reach the latch, or the ticking has another source.

**A 403 dial needs `ATX0`, and the reason is not the exchange.** With the
board's real profile the modem is `X7` and waits for dial tone, and the DTE
answers `NO DIAL TONE`. An earlier revision here blamed the exchange for not
presenting one. It does present one, and the DAA qualifies on it - instrumented,
the seizure takes the DAA to `dial-tone` with `op=originate` and
`detector_present` true, and 4,800 samples later `dial_tone_qualified` goes
true, exactly the five 100 ms frames the debounce wants.

What never happens is the firmware being *told*. The detector byte is published
by [machine.py](../courier_emu/machine.py) writing `[0x649]`, and that block is
gated on `address in (0x5DB9D, 0x5DBE7)` - both below `0x80000`, so both are
XMF-only and neither executes on a ROM image. The ROM waits on its own cell at
its own address and nothing writes it.

So the work is to find the ROM's detector cell and the wait that reads it, the
way `0x5DBE7` and `[0x649]` were found for the XMF builds. That search has been
run and has not found it. What it ruled out, so the next attempt does not
repeat it:

**The XMF shape is not in the ROM.** The XMF wait is a countdown loop -
`mov word [0289],2580`, then `cmp word [0289],0 / je` for the timeout and
`cmp byte [0649],5 / jb` back for the detector - and `0x5DBE7` is the timeout
test, which is where the harness hooks. Searching the ROM for that exact
sequence gives **zero** matches, and the looser form (any `cmp byte [x],5 / jb`
with a word-zero test within 14 bytes) gives zero as well.

**The wait is a service poll, not a counter loop.** Diffing executed addresses
between the failing dial and the same dial under `ATX0` isolates it: `0x892c4`
calls `0x89309`, `0x8b3e7`, `0x8b42d`, `0x8b495` and `0x8b4b5` in turn, and its
caller spins 2.8M extra times. `0x8b42d` tests `[0x02f7]`, `[0x04f2]`,
`[0x03d7]` and `[0x020d]`; `0x8b495` divides `[0x0ae1]` by `[0x0ae0]` into
`[0x0ae2]` behind `[0x0ca5]` bit `0x20`, which looks like a level average.

**Not a mailbox report either.** The DSP tells the host nothing during the
wait: `runtime_inbound_delivered` is empty, and the bridge's only inbound
messages - `0009`, `0044`, `004d`, `001d`, `0002`, `0003` - are published at
call-overlay activation and are call-progress, not tone detection.

**Not `[0x04dd]`.** It holds a result code, but its only `= 6` writer is inside
the self test, so the runtime `NO DIAL TONE` is produced elsewhere.

Those cells have now been read off the board. Idle, every one of them matches
the emulator exactly. Pulling the relay in by hand - `ATGLK2O0010,DF`, which
leaves the DTE in command mode - moves exactly one:

    [020d]   on-hook 0x09    off-hook 0x0b

Bit `0x02` of `[0x020d]` mirrors the hook. **The emulator never writes
`[0x020d]` at all** - a `--mem-watch 200:220` across a whole dial catches 96
writes in that range and every one is to `[0x0210]`. The predicate at `0x8b449`
tests bit 0 of this same cell before it reaches its success branch, so the cell
is on the path.

The level-average cells `[0x0ae0..0ae2]` and `[0x0ca5]` did not move, but not
for want of a line. There is one, and it carries dial tone:

    ATX4      OK          full result codes, so NO DIALTONE would be reported
    ATS7=8    OK
    ATD       NO CARRIER

`NO CARRIER` and not `NO DIALTONE` means the firmware heard dial tone, passed
its wait, dialled nothing and timed out on S7. The board's detector works, and
the question is answerable on this bench.

What the hand-pulled relay could not do is catch it. Closing the relay behind
the firmware's back does not put it in a dial, so its detector routine is not
running and the cells stay idle; and after a real `ATD` completes they are back
to idle before the DTE can be read again, because the DTE is unavailable for
the whole of the attempt.

### The co-resident sampler, run across three dials

`cooperative_probe.py` now takes `--cell` as well as `--ports`, so it can watch
segment-0 RAM while a call is up. Placed at `0x1a00`, chained onto INT3, armed,
`ATD`, disarmed: the board survives it, answers `NO CARRIER` as usual, and the
INT3 vector reads back `8000:0a77` afterwards every time.

It works, and it says the detector is not where any of this looked:

| sampled | result |
|---|---|
| `[020d]` | `0x09` -> `0x0b` at **sample 239, 0.79 s** - the hook closing |
| `[03d7]` `[04f2]` `[0ae0..0ae2]` `[0ca5]` | flat `0x00` for the whole capture |
| `[0149]` `[0d60]` `[02e8]` `[0d11]` `[0d74]` `[0225]` | flat `0x00` |
| ports `0x18` `0x1a` `0x1e` | flat `0xff` |
| port `0x1c` | one-tick blip `0xfd`->`0xff`->`0xfd` at 0.45 s, before the seizure |

`[020d]` moves at the same sample in every run, which is the check that the
instrument is real.

**The candidate selection was circular and that is why it found nothing.**
All thirteen cells came from the addresses the *emulator* spins on during its
failed wait - `0x8b3e7`, `0x8b42d`, `0x8b495`, `0x89309`. The emulator spins
there because it is stuck; that is where it waits, not where the board decides.
`0x8b42d` cannot even succeed, since it short-circuits on `[04f2]` being zero.

### The mailbox data pair does move

Sampling `0x5c`/`0x5e` - excluded from the probe's defaults because reading
them may consume what the firmware was about to read - is the first thing that
shows structure. Across a dial, at 303 Hz:

    0.45s   port 1c    fd -> ff -> fd        one tick
    0.49s   port 5c    82 -> 03 -> 02        two ticks in 03
    0.79s   [020d]     09 -> 0b              the hook closes
    1.22s   port 5c    02 -> 03 -> 02        two ticks in 03
    -       port 5e    flat 00 throughout

So the mailbox low byte idles at `0x82`, drops to `0x02` around the seizure,
and pulses bit 0 twice: once just before the hook closes and once **0.43 s
after** it. The high byte never moves.

The control - the same capture with no dial, `ATS0=0` so nothing can answer -
is flat. `0x5c` stays `0x82`, `[020d]` stays `0x09`, `0x1c` stays `0xfd`,
nothing moves for its whole 833 samples. So every transition above belongs to
the dial.

A first attempt at that control appeared to show the line going off hook by
itself, and that was an artifact of the read-back, not the board. **The sampler
stops when the ring is full, and the write pointer says where it stopped.** The
idle run wrote 833 samples and stopped at `0x2904`; the read-back sliced the
whole `0x1c00`-`0x2b00` ring anyway, so everything past sample 833 was the
previous dial's leftovers, and the "event" at sample 834 was simply the first
stale byte. Read to the pointer, never to the end of the ring.

Reading the pair did not disturb the call: it still answered `NO CARRIER`, and
the board was on hook with its INT3 vector restored afterwards. The dial
capture filled its ring - pointer `0x2b00`, 960 samples - so all of it is
fresh.

**Four dials, sample-identical.** Repeated with `S0=0`, `X4`, `S7=8`, reading
only as far as the write pointer:

    run 1  NO CARRIER  n=960  hook=239  0x03 pulses at 148, 370
    run 2  NO CARRIER  n=960  hook=239  0x03 pulses at 148, 370
    run 3  NO CARRIER  n=960  hook=239  0x03 pulses at 148, 370
    run 4  NO CARRIER  n=960  hook=239  0x03 pulses at 148, 370

Not approximately - the same sample index in all four. One pulse 91 samples
(0.30 s) *before* the hook closes, one 131 samples (0.43 s) after it.

That reproducibility cuts both ways. It says the capture is solid and the
events are real. It also means the timing is fully determined by the firmware,
which is what you would expect either from a scheduled step or from detecting a
tone that is already present when the detector starts - so it does not, on its
own, say the second pulse is the dial tone.

### Unplugged, twice

    run 1  NO DIAL TONE  n=960  hook=None  0x03 pulses at []
    run 2  NO DIAL TONE  n=960  hook=None  0x03 pulses at []

Both pulses gone, and more than that: **`[020d]` never changes, so the relay
never closes.** With an open pair the firmware does not seize the line at all -
it declines before the hook, and reports `NO DIAL TONE` for a tone it never
went off hook to listen for. So that byte is the relay actually closing and the
firmware's decision to close it, not a command echo.

That does not isolate which pulse is the dial tone, and it is worth being
plain about why: unplugged is not the same test as *plugged in with no dial
tone*. Without a pair there is no loop current, the firmware stops at the first
gate, and everything downstream is absent for that reason rather than for want
of a tone.

What it does establish is that both pulses are line-dependent, and it makes one
reading much the most natural: `148`, which fires 0.30 s *before* the seizure,
is the line-presence check that permits it, and `370`, 0.43 s after, is what
the firmware waits for before dialling. A line drawing loop current but
carrying no dial tone would separate them outright; nothing else here will.

The other reading is still open. The probe "cannot read the DSP's internal data
memory", tone detection is the C52's job, and a message the supervisor consumes
on arrival is invisible from this side however it is sampled.

### Two port read-backs, measured

Reading the ports themselves says why `[0x020d]` may never move:

| port | board | emulator |
|---|---|---|
| `0x10` | `0x86` on-hook, `0x87` off-hook | `0xff`, with the NVRAM bits overlaid |
| `0x00` | `0x00` | `0x33` on the input bits |

Port `0x10` bit `0x01` mirrors the hook on the board, and the emulator answers
open bus - so any firmware routine that reads the port back to maintain
`[0x020d]` is being told the line is permanently off hook.

Port `0x00` is worse, because that value is one this project chose. It was set
to answer `PORT0_INPUTS` high on the reasoning that answering from the latch
cost `ATI7` its option list. The board answers `0x00`. So the four bits are not
capability inputs reading high, the guess was wrong, and whatever moved the
option list has another cause still to find.

Blind-dialling sidesteps all of it: `ATX0` gives `dialed: "6245"`, ringback,
answer. The stub fixture used to dial only because its erased profile read
`X15`.

## XMF-only logic, swept

The XMF payloads load at `0x40000` and the board ROMs at `0x80000`, so any
address literal the harness holds in `[0x40000, 0x80000)` can only ever be
reached by an XMF run. `tools/xmf_only_sweep.py` lists them: 110 lines in
`machine.py`, plus a handful in `panel.py` and `daa.py`.

Most are correct. The XMF supervisor has its own boot, delay-loop, serial and
callback quirks that a ROM does not share, and the harness gates the bulk of
them behind `_payload_hooks` deliberately - milestones are `{}` for a ROM with
a comment saying why, and `_serial_started` follows the same flag, so the whole
serial-capture and ISR-exit group is XMF-only by design rather than by
accident. The ROMs reach their DTE through the 80C186EB serial unit at `ff60`
instead, which `uart.py` models.

What the sweep is for is the other kind: a block providing a service *both*
families need, where only the XMF address was ever found. Three have turned up,
each after a long chase:

| block | consequence on a ROM run | state |
|---|---|---|
| the serial ISR-exit blocks, behind a hot-address set they could not reach | XMF DTE went deaf | fixed |
| `carrier-detect-override` mapped to `0x14`/`0x40` | every dedicated-line run booted into the self test | fixed |
| the DAA detector byte `[0x649]`, published at `0x5DB9D`/`0x5DBE7` only | `NO DIAL TONE` with a qualified detector unread | **open** |

The last is the only functional gap the sweep leaves. Everything else in the
list is either payload-gated on purpose or a comment citing where a fact was
recovered from, which is fine - `0x6355F` at `machine.py` line 1327 shows the
shape to copy, an XMF address named alongside its three ROM counterparts.

Two justifications are ROM-unverified rather than wrong: `panel.py` derives
ring detect from `0x70fb4`, the XMF answer machine, and the `DIP_SWITCHES`
descriptions all cite XMF addresses. The ports and bits may well be the same;
nothing has checked.

### It is the DSP, and the emulated one is not listening

`0x5c` is the ASIC's host/DSP mailbox group, so a value appearing there that
the supervisor did not write comes from the DSP side. Tone detection is the
C52's job on this board, which makes the pulse a DSP report and not a flag the
supervisor sets for itself.

That changes what the emulator is missing, and the counters say so plainly. In
a 403 dial that ends in `NO DIAL TONE`:

    codec_rx_queued        228480     the exchange's dial tone, delivered
    codec_rx_consumed           0
    drr_reads                   0     the C52 never reads a sample
    line_frame_interrupts       0
    line_tx_writes              0

228,480 samples of line audio are queued into the codec and the DSP reads none
of them. Its receive path is not running during the dial-tone wait at all - it
comes alive later, with the call overlay, which is why the same image happily
generates DTMF once `ATX0` gets it past the wait.

So the emulated C52 cannot detect dial tone for the simplest possible reason:
it never hears any. Publishing `[0x649]`, or a pulse on `0x5c`, would paper
over that - the firmware would be told a tone was found by a DSP that has not
processed a sample. What the board does is run the resident's audio path from
the seizure onward and report what it finds.

**Not the TDM gate, and not a gate at all.** An earlier revision put this on
`m_call_tdm_active`, which is main211's branch: with `m_rom_codec` set, and it
is set for both board images, the frame driver takes `codec_frame()` instead
and that pops `m_codec_rx` into DRR with no overlay condition on it.

Instrumenting the core - `codec_rx_size`, `line_frame_irq`, `frame_period`,
`line_frame_next_cycle` and `cycles` added to `codec_state()` and surfaced as
`core_codec` - answers it in one run:

    line_frame_irq          5          configured
    frame_period         3472
    line_frame_next_cycle 3472          the first edge
    cycles                  0          <-- never advances
    codec_rx_size      228480          the queue, entirely undrained
    frames_clocked          0
    pc / instructions       0 / 0
    active              False
    bootstraps              1

`m_cycles` is zero because **the C52 never executes a single instruction.**
The frame driver's `m_cycles >= m_line_frame_next_cycle` cannot become true,
`codec_frame()` never runs, and the queue simply fills.

Why it never executes is `bridge.py:1327`. A DSP reset closes the core, builds
a fresh `NativeC5x`, and sets `active = False`; the bridge only sets it true
again once a re-download reaches `bootstrap_target_size`. In this run that
second download never arrives - `bootstraps` stays at 1 - so the part is held
dead for the rest of the dial. Under `ATX0` the supervisor skips the wait,
goes on to load the call overlay, and the DSP comes back, which is why the same
image dials perfectly well that way.

So the dial-tone failure is not a missing detector, a missing flag or a gated
ISR. The DSP is reset mid-dial and never restarted, and everything downstream
follows from that.

**And the supervisor is not at fault.** Logging the reset and the bootstrap
clear across a dial gives one reset and 9,206 clears:

    CLEAR had=16     at  5,071,977     the legitimate one: setup, 8x 0083 words
    RESET            at 46,308,306     the supervisor re-enters its download
    CLEAR had=1056   at 46,313,613     <-- wipes a download in progress
    CLEAR had=2256   at 46,324,871
    CLEAR had=2224   at 46,336,137
    ...                                and thereafter had=0, forever

The reset is real and intended, but `bridge.py:1318` is not what recognises it.
The supervisor pulses the **actual C52 reset line** - `ff56` bit 1, the one
`8b1f972` established this morning - twice, immediately before the download:

    ASSERT  46,307,057
    release 46,307,573
    ASSERT  46,307,716
    release 46,308,232
            46,308,306   <-- and only here does the harness recreate the core

So the answer to "does the supervisor want the DSP reset" is yes, demonstrably,
on a wire the harness can already see. It asserts that line four times across a
dial - at 5.07M, 5.63M, 37.71M and 46.30M - and the harness recreates the core
for exactly one of them, 74 instructions after the last release, because eight
data bytes happened to match `expected_bootstrap[:8]`. The byte match is a
stand-in for a signal that is present, observable and already routed:
`machine.py` takes that same edge into `float_runtime_bus()`, which floats the
bus and does not touch the core.

**Does the reset clear the DSP's RAM?** On the part, no: asserting RS resets
the CPU - PC, registers, status - and leaves memory alone, so external program
RAM keeps what was downloaded into it. The harness builds a fresh
`NativeC5x`, which wipes all of it.

That costs the program nothing, because the supervisor re-downloads the whole
resident regardless. Suppressing the spurious clears and letting the transfer
finish gives `bootstraps: 2`, `bootstrap_bytes: 56656`, `bootstrap_match:
true`, `active: true` - the full 55 KB image, byte-identical, not a partial
overlay. So the guess that persistent RAM would mean a short download is wrong;
it sends everything either way.

Where the fresh core is still wrong is *data* memory, which a real reset
preserves and this discards. Whether the resident depends on that is not
measured.

And the clear is necessary but **not sufficient**. Guarded so it fires only
while the accumulator still holds setup, the DSP comes back and comes alive:

    instructions      0 -> 129,099,202
    codec_rx_consumed 0 ->      50,818
    drr_reads         0 ->      66,657
    line_frame_ints   0 ->      38,333
    line_tx_nonzero   0             0

It hears the line now. It still puts nothing on it, the DTE still answers
`NO DIAL TONE`, and the exchange stays `idle`.

### The third fault: nothing reports

`runtime_inbound_delivered` is empty. The resident polls the host status cell
`0x57` **115,014 times** and writes its host-facing cells exactly once, at
init - so it never sends the supervisor anything at all, and the supervisor is
waiting to be told.

One end of that is now built. `_collect_dsp_messages` reads the core's
mailbox holding pair after each DSP quantum - the core keeps the resident's
writes to `PA14`/`PA15` separate from what the host writes to the same
addresses - and turns a rising write count on the word cell into an inbound
message. It collects real traffic: 389 messages on a 302 dial, 378 on a 403
dial under `ATX0`, both of which still reach `6245`, ringback and answer
unchanged.

**The other end is still missing.** On the failing 403 dial the resident sends
only 28, all of them `0008:0000` about 70 ms apart - a heartbeat rather than a
report - and `runtime_inbound_delivered` stays empty, so none is consumed. The
status the CPU reads already carries bit 1 while anything is queued, and the
pop needs the supervisor to read the tag lanes and then write `0x1c` with bit 1
clear. It never does. Whether that is because tag `0x08` is not what it is
waiting for, or because the handshake needs more than the queue, is not settled.

The earlier claim here that "the resident is not reporting" was measured on a
run where the DSP was executing zero instructions, and did not survive the DSP
being brought back.

Which is where the board's `0x5c` pulse belongs, and why it was worth finding:
it is the shape of the message this path has to produce.

Two reset semantics for one event, neither keyed to the event. What follows is
the harness's own doing. `bridge.py:1247` clears the bootstrap
accumulator on any `ENTRY_REQUEST_COMPLETE` written to `0x1c` while `not
self.active`, and after a reset `active` is false for the whole re-download.
So every one of those writes throws away the program bytes collected so far,
the accumulator never approaches `bootstrap_target_size`, and `active` never
comes back.

That clear is meant to fire once, before program data starts: its own comment
says the setup "goes through the same window and strobes as the program does -
eight `0083` words on the captured board", and the first clear duly reports
`had=16`. The ones reporting `had=1056` and `had=2256` are mid-stream and are
the bug. Its guard needs to distinguish setup from program rather than testing
`active`, which is false for both.

## Still open

- **What `0x5de57` is doing.** It drives `0x01` and `0x80` together for the
  `&C` setting, and those are now measured as two different lamps, CD and SYN.
- **What port `0x10` bit `0x04` is.** Asserted on every dial, but driving it
  directly does nothing visible or audible, on hook or off.
- **Feeding the resident before the overlay.** The gate is `m_call_tdm_active`
  at `native/c5x_core.cpp:923`, set only when the call overlay comes up. The
  board detects dial tone 0.43 s after the seizure, with no overlay in sight.
- **Which line is the speaker.** Not port `0x00` bit `0x40`, measured. `ATM` is
  settable now, so a dial under each setting is still the probe worth running.
- **The tail of the board's lamp sequence.** After `SELF TEST COMPLETED` the
  board shows CS, RD and AA moving in a pattern the emulated run does not
  reproduce; it makes 38 panel writes in 600M instructions and none fall there.
  Given the above this is probably not a missing *write* at all - those lamps
  follow DTE handshake and data lines, which is also what the `TR RS CS` lit at
  power-on is. Reproducing it means modelling the panel as following the serial
  signals, which nothing here does: `uart.py` tracks CTS and DTR, but no lamp
  is wired to them.

## There is no 403 fault: it is the `X` level, and both builds share it

The "403 plain does not dial" thread, carried through several commits above,
rested on a comparison that was not controlled. 302 dialled and 403 did not, and
the difference was taken to be the build. It is not.

Run each at the other's `X` level, everything else identical. `X` sets two
things at once - whether the dial waits for dial tone, and how much the result
code set can say - so the sweep below separates them: `X0` and `X1` both dial
blind and differ only in verbosity, `X2` and `X4` both wait.

| | dialled | exchange | DTE transcript |
|---|---|---|---|
| 302, its fixture's default | `6245` | connected, answered | - |
| **302 + `ATX4`** | `""` | idle | `NO DIAL TONE` |
| 403 + `ATX0` | `6245` | connected, answered | `OK` |
| 403 + `ATX1` | `6245` | connected, answered | `OK` |
| 403 + `ATX2` | `""` | idle | `OK`, then `NO DIAL TONE` |
| 403, its fixture's default (`X4`) | `""` | idle | `NO DIAL TONE` |

The waiting axis is the whole of it: both blind levels dial and connect, both
waiting levels report `NO DIAL TONE`. The two builds behave identically for a
given `X`.

**And the `OK` in those rows is not the call's.** It is the `ATXn` command's own
acknowledgement - `X2`'s transcript shows both, `OK` for the setting and
`NO DIAL TONE` for the dial. Under `X1`, where extended codes are enabled and a
completed call must answer `CONNECT`, **the dial produces no result code at
all**. So on the connecting path the dial never terminates as far as the DTE is
concerned, and the only evidence the call happened is the exchange's: digits
decoded off the line and a far end that answered. An earlier version of this
section read that `OK` as success, which it is not; under `X0` it is close to the
only thing the modem can say. What differed was the
**fixture**: `idsdl403` is the board's own captured settings part, which carries
the unit's stored `X4`, and `idsdl302` is a mostly-erased part seeded with
recovered records, which lands on a level that dials blind. So 403 was obeying
`X4` correctly and reporting truthfully; the harness simply never gives it dial
tone to hear. Nothing here makes 403 dial that was not already true of 302 - it
routes around the dial-tone check rather than fixing it.

That collapses three commits' worth of "the third fault" into one fault, which
is not 403's and was already recorded under its own name:
[the exchange presents dial tone and the ROM is never told](../docs/dsp-cpu-interconnect.md).
Every `X4` dial fails on both builds, and every blind dial succeeds on both.

### What is now known about that one fault

With the DSP/CPU instruction ratio corrected the C52 does hear the line - 613 M
DSP instructions and a live codec queue on the failing run - and the exchange
does present dial tone: it counts the seizure (`calls: 1`), enters its
`dial-tone` state and reports `tone_present: true`, and the DAA mirrors that
state. The audio is there and the DSP is running in it. What is missing is still
the report: nothing turns "the C52 heard 350 + 440 Hz" into the thing the
supervisor's originate path waits on.

`machine.py`'s existing model of that wait - the five-hit counter at `[0x649]`,
poked at physical `0x5DB9D` / `0x5DBE7` - is **dead on both builds**. Neither run
reaches those addresses, and neither emits the `daa ...-qualified 0649=05` trace
line that would say it had. Those are `main211` addresses, and they should be
read as a record of how the 211 path was modelled rather than as anything the
302/403 supervisor does.

The missing `CONNECT` is very likely the same hole seen from the DTE side:
`runtime_inbound_delivered` is empty even on the `ATX1` calls that reach
`connected` and answer. So the supervisor consumes no
DSP-originated message on any path yet: the working call is carried by the
bridge's own overlay logic, not by the mailbox report. Whatever feeds the dial
tone wait has to be built, not merely re-pointed.

## The dial tone reaches the C52 and is then thrown away with it

Before building a mailbox consume path for a dial-tone report, the premise was
checked: does the DSP actually receive the tone? **It does not.** The audio path
now reports its own peaks at each hop, and they locate the break exactly.

    line_rx_peak       7986   what the exchange handed the bridge
    codec_in_peak      7986   what reached _queue_line_audio
    codec_handed_peak     0   what reached the C52 that is still running
    codec_rx_peak         0   what the C52 itself ever saw

    non-zero audio last handed at instruction   47,026,207
    core rebuilt at instruction                 47,162,901
    handed since that rebuild                            none, ever

The tone is generated, converted and queued correctly. Then, **136,694
instructions later - about 31 ms - the bridge builds a fresh `NativeC5x` at the
call boundary and the queued audio goes with it.** After that no non-zero sample
is handed to the C52 again for the rest of the run, so the supervisor waits out
its dial-tone timer against a queue of silence and answers `NO DIAL TONE`
truthfully.

`bridge.py:1369` is the rebuild. An earlier finding above established that
rebuilding costs the *program* nothing, because the supervisor re-downloads the
whole resident either way. That is still true, and it is not the whole account:
nobody checked the **receive queue**, which is not re-sent by anybody. On the
board the line does not stop while the DSP resets - the tone is still on the
wire when it comes back - so discarding samples in flight is not what the
hardware does.

### Two things this rules out

The C52's own `codec_rx_peak` cannot answer this question and reading it as an
answer is a trap this document fell into first: the counter lives in the core,
so a rebuild zeroes it whether or not the tone ever arrived. Only a peak kept
bridge-side, and compared against the instruction the rebuild happened at, can
tell "the DSP heard nothing" from "the DSP that heard it no longer exists".

And it rules out the resampler, which was the other suspect: 263 conversions in
the run, none of them empty, and a standalone 9,600 -> 7,200 conversion of a
350 + 440 Hz tone returns a 720-sample block at full amplitude.

### So the mailbox consume path is not the next thing to build

It would carry a report the DSP has no way to originate, because the DSP never
hears the tone. The order is: keep the receive queue across the rebuild, or stop
rebuilding, then find out whether the resident detects the tone, and only then
build the path that carries what it found.

### Corrected: the codec is not part of the DSP, and the fix follows from that

The framing above - "the queued audio goes with the rebuilt core" - describes the
symptom in the harness's own terms. The board's terms are better and give the
fix directly. **The AC01 sits on the C52's primary serial port**, and on that
port the DSP is a slave: `SPC = 0x40c8`, `MCM = 0` so `CLKX` is an input, `TXM =
0` so `FSX` is an input
([the interconnect](dsp-cpu-interconnect.md#which-leaves-the-primary-port-and-one-pin-decides-it)).
The codec converts the line and shifts a word into `DRR` every frame, clocked by
something that is not the C52 and does not stop when the C52 is reset. There is
no FIFO on the board; the words in flight are in the AC01 and on its serial
link, **outside the part being reset**, and the dial tone is still on the wire
when the DSP comes back.

`native/c5x_core.cpp:codec_frame` already models the receiving end correctly -
one word per primary frame into `DRR`, a delivered zero when there is nothing,
never a stale repeat. What was wrong was ownership: the bridge's queue stood for
the codec's serial stream but was destroyed with the core.

So the bridge now keeps what the codec has clocked out and the C52 has not taken
- trimmed each time to the core's own `codec_rx_queued - codec_rx_consumed`, so
it holds exactly the words in flight - and re-presents them to the new core.

    replayed across the rebuild        11,305 words
    DSP-side codec_rx_peak    0  ->  7,878
    codec_rx_consumed   130,684  -> 141,989

**The C52 now hears the dial tone**: over a second and a half of it, where
before it heard silence. 302 and `403 + ATX1` are unchanged - both still dial
`6245` and connect, and neither replays anything, because neither rebuilds while
audio is in flight.

### And it is still not enough, which is now a clean statement

`403 + ATX2` still answers `NO DIAL TONE`, and **every other number in the run is
identical** to the run before the fix - same DAA, same seizure, same exchange
timing, same 134 DSP-originated messages. Only `codec_rx_consumed` moved, by
exactly the 11,305 replayed.

So the resident hears the tone and does not report it. That is no longer an
audio-path question, and the next one is narrow: does the 3.1.2 resident have a
dial-tone detector on this path at all, and does it run in this state? The
harness can now put a known tone in front of it and ask.

### A known tone in front of the resident: it does not react at all

With the codec's words now surviving the rebuild, the resident can be given a
known tone and asked. The control is exact: the *same* run twice, the same
11,305 replayed words at the same instruction, carrying dial tone in one and
zeros in the other. Nothing else differs.

| | tone | silence |
|---|---|---|
| `codec_rx_peak` | **7,878** | **0** |
| `codec_rx_consumed` | 141,989 | 141,989 |
| `drr_reads` | 209,162 | 209,162 |
| DSP-originated messages | 134 | 134 |
| `0008:0000` | 71 | 71 |
| `0008:0002` | 62 | 62 |
| `0008:0003` | 1 | 1 |

`codec_rx_peak` confirms the two runs really did carry different audio. **Every
other number is identical, including the tag histogram.** The resident reads
`DRR` 209,162 times, consumes every sample, and says exactly the same three
things - a heartbeat on tag `0x0008` - whether it is hearing dial tone or
silence.

So the resident, in this state, reports nothing about what it hears. That is a
statement about its **output**, and it is worth keeping the two apart:

* It does **not** show that 3.1.2 has no call-progress detector. A detector
  could be setting an internal cell that the supervisor reads with a command it
  never sends, or could live in an overlay that is never published on this path.
* It does show that **nothing the supervisor could poll over the mailbox changes
  when a tone arrives**, so no consume path built on the mailbox can carry a
  dial-tone report as things stand.

The supervisor's side points the same way: across the whole failing dial it puts
only six words through the INT0 send path. It never asks the resident for
anything before giving up, so if there is a detector that has to be armed, it is
never armed.

That is the next question, and it is a firmware one rather than a harness one:
what does a 3.1.2 resident have to be told before it will listen, and does the
supervisor's originate path ever tell it? The board can be asked the same way
the mailbox cadence was - the resident's own traffic during a real dial, sampled
through the INT0 hook.

## The tone was wrong: the resident detects, and reports it as bit 0x40

Scott's observation, and it turns a dead end into a mechanism. The exchange
presented `DIAL_TONE = (350, 440)` - **North American precise dial tone** - to a
unit whose own `ATI7` says `Product type Russia (ex. US/Canada) External`,
plugged into a loop carrying a single continuous 400 Hz. A detector tuned for
one does not answer the other.

With the tone made a parameter (`--exchange-dial-tone us|nz|uk|eu`), the same
failing `ATX2` dial, everything else identical:

| dial tone | codec peak | tag histogram |
|---|---|---|
| `us` 350+440 | 7,878 | `0000` x71, `0002` x62, `0003` x1 |
| `nz` 400 | 3,909 | `0000` x71, `0002` x61, `0003` x1, **`0042` x1** |
| `eu` 425 | 4,000 | `0000` x71, `0002` x59, `0003` x1, **`0042` x3** |
| `eu` 425, double level | 8,000 | `0000` x71, `0002` x53, `0003` x5, **`0042` x4, `0043` x1** |

**`0x0002` and `0x0003` become `0x0042` and `0x0043`** - the same low bits with
`0x40` added, and `0x40` appears **only** for a continuous single tone, never for
350+440. So tag `0x08` is a status word the resident sends continuously, and
**bit `0x40` in it is the dial-tone report**.

The resident was never deaf and never needed arming. It was being shown a tone
its detector does not answer, at half the level besides: the exchange applies its
level per component, so a two-frequency tone sums to twice the amplitude of a
one-frequency tone, and the doubled-level run shows the report count rising with
level as well as with frequency.

### What this changes

The mailbox consume path is now the right thing to build, and for the first time
the thing it would carry is identified rather than assumed: `0x0008` with bit
`0x40` set, arriving on the DSP-to-CPU direction whose 20 ms cadence the board
already gave us, and which `runtime_inbound_delivered` shows nothing consumes.

Still open, and now narrow:

* **The report is sparse** - a handful over more than a second of tone, where the
  board's own reply cadence is 20 ms. Whether the supervisor needs it sustained,
  and why the emulated resident only asserts it intermittently, is unmeasured.
* **The level model is wrong in a way that matters.** Real dial tone is specified
  at a level, not per component, so `TONE_LEVEL` should apply to the composite.
  That is why `us` reads 7,878 and `nz` 3,909 for tones that on a real loop would
  be the same loudness.
* **The right default is not settled.** `us` is wrong for this board; `nz` matches
  the loop it is plugged into; `eu` 425 is the ITU-T E.180 tone and produced the
  most reports. Which the Russian firmware's detector is actually tuned for is a
  firmware question this has not asked.

## The country table: 24 records of 121 bytes, and no Russia in it

Scott's point - that this firmware carries selectable regions, and a region tuned
for one country's tones will not answer another's - is borne out by a table in
the image, at file offset `0x1fd20` (physical `0x9fd20`), 24 entries of **121
bytes** each. Each begins with a 16-byte name padded with `!`, then a country
code byte:

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
Russia entry**, and `ATI7`'s `Product type Russia (ex. US/Canada) External` comes
from a different string at `0x49980` - the product type is not the country
record. The Russian ID_SDL build's own additions elsewhere in the image are
Caller ID features (`RussianCID`, `+S61`), not a country.

Diffing four records shows the per-country payload is dense - some 60 of the 105
bytes after the name differ between US/Canada, UK, New Zealand and Australia -
and it is where the telephony parameters live. Nothing in it is a literal
frequency, so the tone the detector expects is either a coefficient or an index;
which it is has not been established, and the fields have not been decoded.

### What this means for the harness

The exchange's tone is now selectable and the resident answers a single
continuous tone with bit `0x40`. What is not yet settled is **which record this
board runs**, and therefore which tone is the faithful default. Three ways to
find out, in increasing cost:

1. Decode the country code out of the board's own settings part - the
   `idsdl403` fixture is that part, captured.
2. Sweep `--exchange-dial-tone` against the `0x40` report count. `eu` 425
   currently produces the most, `nz` 400 the fewest of the two single tones -
   but frequency and level are confounded until the level model is fixed.
3. Decode the 121-byte record, which would give the detector's expectation
   directly rather than by search.

The board itself is the tiebreak and needs no probe: it sits on a New Zealand
loop carrying a solid 400 Hz, and it finds dial tone on it. Whatever record it
runs accepts 400 Hz, so a harness that models this unit should not be presenting
North American 350+440 by default.

## Where the retune actually is: the DSP, not the country record

Scott's suspicion - that the 403's US/Canada region is not the stock one, and
that a US/CAN board running Russian firmware is being tuned for Russian tones -
is right in substance and wrong in location. The evidence is a diff of the two
captures of **this same board**, before and after the flash:
`courier-board-21210-capture-01` is stock 7.3.14 / DSP 3.0.13, product type
`US/Canada External`, and `-403` is ID_SDL 4.03d, 7.4.16 / DSP 3.1.2.

**The country table was rewritten, and US/Canada was the one record left alone.**
The stride grows 110 -> 121 bytes and the entry count 20 -> 24 (Spain, Portugal,
South Korea and Taiwan are added; `Czechoslovakia` becomes `Czech/Slovakia` and
gains code 42; Austria's code changes 52 -> 43). Every record changes at `+20`,
`+21`, `+53` and `+54`, which is the format change, and gains a common 11-byte
tail. Beyond that:

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

US/Canada is the **only** record with no country-specific edit at all.

### So the detector was retuned in the DSP

The DSP revision changed too, 3.0.13 -> 3.1.2, and that is where the tone
detector lives. Running each firmware in the harness against the same exchange,
counting the resident's `0x40` reports:

| firmware | DSP | `us` 350+440 | `nz` 400 | `eu` 425 |
|---|---|---|---|---|
| stock 7.3.14 | 3.0.13 | **3** | - | - |
| ID_SDL 4.03d | 3.1.2 | **0** | 1 | **3** |

Three reports for the matching tone in each, none for the mismatched one. **The
stock DSP answers North American dial tone and the ID_SDL DSP does not**; the
ID_SDL DSP answers a single continuous tone near 400-425 Hz instead. The country
record did not have to change because the retune is in the resident.

Which also explains the board on the bench: it is a US/Canada unit whose detector
now expects a Russian-style continuous tone, sitting on a New Zealand loop
carrying a solid 400 Hz - close enough that it finds dial tone, which it would
not have done on 350+440 after the flash.

### What the harness should do with that

The faithful default depends on which image is being run, not on one global
choice:

* `IDSDL302.ROM` and the 4.03d capture want a continuous tone; `eu` 425 produces
  the most reports and is the ITU-T E.180 tone the Russian build is presumably
  tuned to.
* The stock 7.3.14 capture wants `us` 350+440.

Neither is currently the default for its own image, and `--exchange-dial-tone`
still defaults to `us` for everything. Tying the default to the image's DSP
revision is the obvious fix and is not made here, because the level model is
still wrong - the exchange applies its level per component, so a one-tone and a
two-tone dial tone differ in amplitude by 6 dB, and any sweep to confirm the
detector's centre frequency is confounded until that is fixed.
