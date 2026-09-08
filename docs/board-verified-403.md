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
way `0x5DBE7` and `[0x649]` were found for the XMF builds. The originate path's
spin is at `0x8b42d`-`0x8b49a`, polling `[0x02f7]`, `[0x04f2]`, `[0x03d7]` and
`[0x020d]`, which is a state poll rather than the counter itself. `[0x04dd]`
holds a result code but its only `= 6` writer is in the self test, so the
runtime `NO DIAL TONE` comes from somewhere else again.

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

## Still open

- **What `0x5de57` is doing.** It drives `0x01` and `0x80` together for the
  `&C` setting, and those are now measured as two different lamps, CD and SYN.
- **What port `0x10` bit `0x04` is.** Asserted on every dial, but driving it
  directly does nothing visible or audible, on hook or off.
- **The ROM's dial-tone detector cell.** The exchange presents dial tone and
  the DAA qualifies; the ROM firmware is never told, because the `[0x649]`
  publisher is XMF-only. Until that is found, anything but `X0` answers
  `NO DIAL TONE`.
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
