# Quad bring-up blockers (2026-09-10)

> AT execution update: [QF CPU byte-terminal mode](quad-at-terminal.md) now
> demonstrates `AT` → `OK`, an invalid command → `ERROR`, and recovery.
> This uses an explicit autobaud adapter; physical DTE/DSP blockers remain.
>
> Receive integration update: the subsequent
> [measured QF receive test](nmc-sdl-protocol.md#verification-status--measured-2026-09-10)
> now consumes a finite CRC-framed packet through DUART INT0 with zero empty
> reads, accepts its CRC, and rejects a corrupted CRC. The original diagnostic
> results below describe the earlier harness; its required receive fix is now
> covered by `tests/test_quad_receive.py`. Remaining board/AT blockers still apply.

The Quad needs a board model, not just a Courier image substitution. However,
**an NMC handshake is not established as a prerequisite for AT operation**.
The hardware supports local RS-232 AT commands, and the current harness can
manufacture misleading chassis receive activity.

## Hardware evidence: local AT and switches really exist

The original 3Com **Quad Modem NAC Product Reference, version 6.0/6.1**
(P/N 1.024.1865-00) matches the QF/QR release family:
https://files.serialport.org/network/USR_3Com_Total_Control/docs/QMODEM/24186500.PDF

Its overview describes both RS-232 through the rear Quad NIC and data routing
to a gateway card. Pages 3-8/3-9 document ten DIP switches. The older USR
hardware install guide explicitly describes AT configuration in an unmanaged
chassis (printed pages 3 and 17):
https://files.serialport.org/network/USR_3Com_Total_Control/1996_docs/pdfdocs/qdmodem/qdinstal.pdf

The 1998 Getting Started Guide independently confirms the switch functions
(page 2-2):
https://files.serialport.org/network/USR_3Com_Total_Control/docs/QMODEM/24131600.PDF

For a diagnostic local AT configuration:

| Switch | Setting | Reason |
| --- | --- | --- |
| 1 | ON, or assert real DTR with it OFF | OFF requires DTR before accepting commands |
| 2 | OFF | Word result codes |
| 3 | ON | Enable results; factory default is quiet |
| 4 | OFF | Echo commands; factory default suppresses echo |
| 8 | ON | Enable AT recognition |
| 10 | ON for initial bring-up | Load ROM defaults rather than unknown NVRAM |

These are documented logical switch positions, **not recovered emulator port
masks**. The CourierPanel DIP wiring is Courier-specific and cannot be assumed
to drive these Quad inputs. No physical jumper designator or undocumented
strap setting was established. Do not confuse engine identity at port 0x260
with the user DIP switches.

The reference also documents `%D0` (analog), `%D1` (T1/DS0), and `%D2` (PRI).
Line source and DTE routing are distinct choices. A digital line source does
not itself eliminate the local RS-232 interface.

## Confirmed harness defect: wrong interrupt source and incomplete DUART

Fresh reproduction is in `artifacts/quad-blockers-20260910/probe.py` and
`results.json`. Run from the repository root with:

```
PYTHONPATH=. .venv/bin/python artifacts/quad-blockers-20260910/probe.py
```

It flattens QF060003, enters at 8000:0000, enables interrupt emulation, uses
`tick_ms=5`, queues `AT\r` locally and `22 STX` on QuadUsart, and runs 8 million
instructions per identity setting. It does not patch firmware or force a
successful handshake. The tick and other automatic sources remain those of
CourierMachine, so this is a harness diagnostic, not hardware validation.

| Identity field | Service-loop entries | Chassis RX entries | AT bytes left | Result |
| --- | ---: | ---: | ---: | --- |
| 0 | 92,774 | 2,239 | 3 | No serial output; chassis queue drained |
| 1 | 4 | 0 | 3 | No serial output; USART initialized three times |

For identity 0 there are 2,239 reads of both 0x22a and 0x226, but **zero reads
of status 0x222**. Thus the older assertion that receive is never reached is
false for the current harness. The final parser vector is 0x1afc, but this
is not evidence of a valid frame: after the three queued bytes, the device
supplies zeros on every empty read.

The cause is concrete:

- The Quad's initial vector **0x0c points to 8000:19ac**, its chassis ISR.
- CourierMachine automatically supplies periodic INT0 frame events. The
  Quad has assigned that vector to another device.
- The ISR reads **0x22a**, tests bit 1 for receive and bit 0 for transmit.
  If both are zero, its branch still falls into receive. QuadUsart returns
  constant zero for that register, making every spurious interrupt consume
  another byte (or fabricated zero).
- QuadUsart is only connected to I/O reads/writes; its queue does not drive
  a device interrupt. It also records rather than implements command enables,
  reset operations and the interrupt mask.

The layout matches **2681/68681-family DUART channel A** semantics:

| Address | Read | Write |
| --- | --- | --- |
| 0x220 | MR1/MR2 | MR1/MR2 |
| 0x222 | status (RX bit 0, TX bit 2) | clock select |
| 0x224 | device-specific/test | command |
| 0x226 | receive holding | transmit holding |
| 0x228 | input-change register | auxiliary control |
| 0x22a | interrupt status (RX bit 1, TX bit 0) | interrupt mask |

Primary device reference: https://www.nxp.com/docs/en/data-sheet/SCC2681.pdf
(register addressing and ISR/IMR definitions). This identifies a compatible
register family, not an exact physical chip marking. The SCC2691 is a poorer
match because its receive interrupt bit is 2, whereas firmware tests bit 1.

Required fix: separate Quad IRQ routing from Courier frame/tick sources;
implement ISR/IMR, command enables and queue-driven interrupts before treating
chassis framing tests as meaningful.

## Confirmed missing mechanism: channel-selected memory and chip selects

QF code at 0x813b4 selects a target using the high byte of AX, writes it to
**port 0x280**, accesses memory through **DS=0x4000**, then deselects it.
Callers use masks 0x80, 0x40, 0x20 and 0x10, e.g. writing the same offset
0xbae1 for each selected target at 0x80b58. These are distinct selected targets
on hardware; the flat CourierMachine RAM aliases all of them to one location.

The image-copy routine 0x80730 clears 0x40000..0x7ffff and copies executable
and DSP payloads into that window. Routines 0x8032e and 0x8034e exchange
chip-select configurations at 0xff88/0xff8a and 0xff94/0xff96. Treating those
as register storage without changing the selected memory cannot reproduce
this transport. Exact RAM ownership and arbitration still need decoding.

The identity field at 0x260 bits 4-5 is live, but identity 1 repeatedly
reinitializes in this harness. It is not a magic switch that enables AT.
The other fields at 0x260, and the input at 0x280, remain incompletely decoded.

Additional startup input: 0x8048f samples port 0 bit 3 as a serial bit stream,
returning 0xffff if no qualifying sequence appears. Its periodic caller caches
AL at 0x214. Routine 0x806f6 enables another service path only for values
0x40..0x47 or 0x6f. This is evidence of another missing board input/protocol;
it is **not yet identified as DIP switches**. Do not force one of those values
and call the resulting run a board emulation.

## Later blockers: actual modem execution and DSP transport

The fresh runs never enter the watched QF DSP load setup at 0x93804. An AT
parser anywhere in the image does not prove the selected modem instance is
running it. Trace the copied application's entry, its per-channel memory,
DTE status and switch acquisition before spending more instructions waiting
for `--at` to work.

The DSP then needs the Quad transport already recovered in
`quad-c50-overlay-loader.md`: CPU ports 0xc0/0xc2 and 0x98/0x9a, with DSP I/O
0x57/0x58 for runtime transfers. The ordinary Courier bridge does not supply
this board interface. Overlay placement is already decoded; older claims that
it remains unknown or uses ordinary global data memory are superseded.
Digital audio additionally needs the appropriate PCM frame clock and byte
transfers. This comes after executable loading and host commands work.

## The C50 endpoint: where it actually stands (2026-09-10)

The card spends its entire run in the C50 overlay download. Over 12M
instructions the last 6M are one loop, and the transport is fully decoded, but
the endpoint does not work. This records the decode, the hypotheses that were
tested and killed, and the one gap that is left, so none of it is re-derived.

### What is solid

**The CPU side.** Eight 16-bit lanes at `0xc0, 0xc4 ... 0xdc`, low byte at the
port and high byte at the port + 2. `[0x9d38]` selects the lane group - `0xc0`
for the path at `0xced05`, `0xd0` for the one at `0xced12` - and `[0x9d37]` is
that group's strobe, 1 or 2, written to `0x98` after each four-word burst and
waited on at `0xced9e`. The final word comes from `[0x9d3a]`, strobed with 4 and
acknowledged on bit 2 at `0xcee12`. `0xcec72` writes `0xffff` to `0x98`/`0x9a`
and `0x9c`/`0x9e` and polls both pairs back as a reset presence check.

**What it streams.** Five complete copies of the resident in four million
instructions, byte for byte: 62,544 bytes at a 62,560-byte stride, each preceded
by eight `0x0083` lane-init words. That is row one of the load table in
[quad-c50-overlay-loader.md](quad-c50-overlay-loader.md) - source paragraph
`0x2000`, length `0xf450`, destination `0x8000`, spanning `0x8000..0xfa28`.

**The DSP side.** Running the captured resident alone gives one cycle repeated
1,768 times in 200,000 steps: write `0x57 = 0x0300` at `0x8313`, then read
`0x57`, `0x58`, `0x59`, `0x5a`, `0x5b` - every read at `0x23f1`, the fetch
stub's `lamm *` with `ar1` auto-incrementing. So it is a **five-word window**
from `0x57`: a status word and four data words, matching the CPU's burst size,
lane for lane (`0xc0`→`0x58`, `0xc4`→`0x59`, `0xc8`→`0x5a`, `0xcc`→`0x5b`).
`0x5c`..`0x5f` are never touched, so the CPU's second lane group addresses a
second device rather than a second window.

**It is not failing for lack of a transfer.** With `0x98` unmodelled and
floating high, every readiness poll passes and `0xced12` returns carry-clear on
23 of 24 loads. A supervisor at `0xede01`/`0xeddb1` then drives the load again.
The missing direction is DSP to CPU.

### Hypotheses tested and killed

Each was measured, not argued. Counters are from six-million-instruction runs.

| Hypothesis | Result |
| --- | --- |
| Acknowledge means "the DSP pulled the queued words", one word at `0x58` | 0 pulls, 0 acks, 0 loads succeeded. Wrong shape: the DSP takes four words at four addresses. |
| Four-word window, `0x57` write is the acknowledge | 3,216 pulls, 590 acks, 1 success against 177 failures. Engages, does not pace. |
| CPU `0x98` and DSP MMR `0x57` are two faces of one register, CPU sees the high byte (`0x0300 >> 8 = 0x03`, the two bits the CPU waits for) | Regression: 590 acks → 16, `0x57` ends at `0x1`. Publishing the strobe into the low byte clobbers the high byte the DSP works with. |
| A hardware "fresh burst" flag raised by the lane latches and dropped when the DSP reads, needing no supervisor write | Killed cleanly: flag raised 532 times, **cleared 2,337 times**. The DSP reads the window regardless. It does not gate on the status word at all. |

The failure profile did not move across any of them - 1 success against 177
failures, three times over. **The pacing is not the problem.**

There is also no port for a status word to be written to: the lane stride puts
MMR `0x57` at CPU port `0xbc`, and the image contains no `out 0xbc`, no
`out 0xbe`, no `in` from either, and never loads `dx` with `0xbc`/`0xbe`.

### The real gap: the resident must be booted, not planted

The endpoint pre-loads the captured image and then runs it, so the CPU is
streaming the resident to a DSP that already has the resident. That situation
never occurs on the board, and no handshake model can make it coherent.
`bridge.py` states the rule outright, in the 302/403 path that works:

```
# The boot loader must write the resident, not execute a preloaded copy.
self.core.load_program(bytes(len(resident)), origin)
```

**This is the same part.** [board-parts.md](board-parts.md) identifies the DSP
as a TMS320C50/LC50, not the `'C52` the core is named after, and
[firmware-lineage.md](firmware-lineage.md) lists the Quad as 80186 + TMS320C50.
The 55 stale `C52` references in `bridge.py` are a misnomer, and that misnomer
is a live source of error: it invites treating the Quad's DSP as a different
device needing a new boot model, when the working one already applies.

Reusing that path directly does **not** work, and the reason is specific:
`configure_rom_codec` is the Courier ASIC's mode, and it redefines two things
the Quad needs left alone. In `c5x_core.cpp`, `IO_WRITE16` makes port `0x57` an
acknowledgement register whose writes *clear* bits (`m_io[port] &= ~value`), so
the resident's `0x0300` clears bits 8 and 9 instead of setting them - which is
exactly why `0x57` read back `0x0000` and the host link looked dead. It also
gates `XRDY` on a codec frame clock this board does not drive, so the loader's
reset handshake spins.

**The boot words never needed that mode.** The loader takes them from `DRR`
gated by `RRDY`, and the ordinary path serves both from the codec receive
queue, with `XRDY` answered optimistically off `XRST`. So the sequence is the
recovered mask ROM, MP/MC low, `host_write(0xFFFF, 4)` for the boot strap -
that one is the ROM's mode selector, not a codec detail, and without it the ROM
runs into an invalid opcode at program `0x3f` - `set_pc(0)`, and the words
handed over with `queue_codec_rx([origin, len, *words, 0])`.

**Measured working.** From a *zeroed* program space with only the ROM loaded,
512 PCs execute inside the resident's span `0x8000..0xfa28` and `0x57` reads
`0xfffc`, the value the resident writes at its own `0x8033`. Code can only be
in that span because the boot loader put it there. In the full endpoint the
host link then runs: 3,979 pulls and 413 acknowledgements.

An earlier revision of this section said the gap was that "the Quad model has
no codec" to clock the loader. That was wrong. The clocking was never missing;
the ASIC mode was overwriting the Quad's status register.

**What remains is the handshake, not the boot.** With the resident booting
properly the load still fails the same way it always did - 1 success against
177 failures and 59 give-ups, the identical profile seen under every handshake
model tried. That number not moving across the boot fix as well is further
evidence the remaining fault is in how a burst is acknowledged, and that it is
independent of everything else corrected here.

### Why the card reloads the DSP for ever

It is a watchdog, and it is firing because the card has nothing to do.

`0xc0b38` is a periodic tick, measured at 21,779 instructions and stable to
better than one percent:

```
c0b45  test [0x9d3e], 1      ; a DSP transfer in progress?
c0b4a  jne  c0b73            ;   yes -> clear the strike count
c0b4c  cmp  [0x81cd], 0      ; a DSP exchange in progress?
c0b51  jne  c0b73            ;   yes -> clear the strike count
c0b53  inc  [0x81ce]         ; strike
c0b57  cmp  [0x81ce], 3
c0b5c  jb   c0b78            ;   under three -> wait
c0b6e  or   [0x9d3e], 2      ; three strikes: request a reload
```

The idle loop then services that request at `0xc93e0`, which is where the
repeated loads come from - `test [0x9d3e], 2`, clear it, and call the download
path. `[0x81cd]` is **not** a heartbeat the DSP sets. It is incremented at seven
sites, each a DSP command/response wait that gives up at `0x64` or `0x19`, so
the test means "is an exchange with the DSP under way".

Measured over six million instructions: 217 ticks, `[0x81cd]` nonzero at **zero**
of them, **zero** entries into any of the seven wait sites, and 54 strikes. So
no code ever commands the DSP. The period closes arithmetically: three idle
ticks arm a reload, the load itself runs about seventeen ticks with the
transfer flag holding strikes at zero, giving a cycle of roughly twenty ticks -
435,600 instructions, which is the spacing measured between successive loads.

**So the reload is not a fault in the DSP path.** It is what this card does when
it is idle: no call, no link traffic, nothing to drive the datapump, so no
exchange is ever started and the watchdog re-loads the part every ~128 ms. A
real card sitting in a chassis with no work would do the same.

That closes the question and hands it back to the link. Parameter `0x1f2`
arrives over the message interpreter, the interpreter needs a message, and
nothing has yet delivered one. Chasing the DSP further will not produce it.

### Reproduce

```sh
PYTHONPATH=. .venv/bin/python tools/probe_quad_c50.py           # capture the stream
PYTHONPATH=. .venv/bin/python tools/probe_quad_c50_resident.py  # the DSP-side cycle
PYTHONPATH=. .venv/bin/python tools/probe_quad_c50_live.py      # the endpoint, needs the machine wiring
```

`probe_quad_c50_live.py` needs `CourierMachine`'s `quad_c50` read/write/service
hooks, which are not committed.

## Recommended order

1. Implement a separate Quad board profile with channel-selected memory and
   IRQ routing; stop applying Courier periodic interrupt assumptions.
2. Model the DUART interrupt/status/mask behavior and verify finite queued-byte
   reception without empty reads being triggered as incoming characters.
3. Trace modem startup and recover Quad DIP/DTR/NIC input wiring. Use the
   documented diagnostic switch configuration and prove `AT` returns `OK`.
4. Connect Quad DSP resident/overlay transport, then PCM framing and call setup.
   The transport itself is decoded (see the C50 endpoint section above); what
   blocks it is that the resident has to arrive through the mask-ROM loader,
   and that loader needs the serial clocking the Quad model does not yet have.

This investigation identifies blockers and corrects the earlier diagnosis.
It does not claim the Quad now boots or answers AT.
