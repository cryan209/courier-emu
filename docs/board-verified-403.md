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
