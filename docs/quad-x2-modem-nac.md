# The Quad x2 Modem NAC images

> Bring-up update (2026-09-10): see [Quad blockers](quad-bringup-blockers.md).
> Local RS-232 AT operation is documented; an NMC handshake is not a proven
> prerequisite. Fresh probes expose spurious receive interrupts and missing
> channel-selected memory. Historical execution conclusions below are superseded
> where they conflict with that report.

`QF060003.NAC` (6.0.3) and `QR060103.NAC` (6.1.3), both dated 1998-09-22, ship
in `docs/x2/Qf060003.zip` and `docs/x2/Qr060103.zip`. This document records
what is directly measured from them, separately from the platform
classification in [`docs/x2/README.md`](x2/README.md).

## Shared lineage with the analog Courier

Flattened with `courier-emu extract` and compared by 32-byte block hashing,
then greedy run extension:

| Pair | Shared 32 B blocks | Longest identical run |
| --- | --- | --- |
| QF 6.0.3 ~ QR 6.1.3 | 178,191 | 7,500 B |
| QF 6.0.3 ~ `IDSDL302.ROM` | 43,468 | 3,618 B |
| QR 6.1.3 ~ `IDSDL302.ROM` | 30,444 | 2,050 B |
| `main211` supervisor ~ `IDSDL302.ROM` | 21,010 | 2,777 B |
| QF 6.0.3 ~ `main211` C52 payload | 14,026 | 1,039 B |

The Quad NAC shares more with the standalone analog Courier SDL 3.02 ROM than
`main211` — an admitted later Courier release — does. That is shared source
lineage, not merely shared architecture.

The limit of this test: on *both* the QF↔ROM and the main211↔ROM side the long
runs are dominated by data tables (help screens, S-register text, result codes,
the `/ARQ/V32`…`/ARQ/V90` rate tables). `QF+0x572c0`, the 3,618-byte run, is a
pointer table. Byte-identical *executable* code is not established here.

`Do DS0` also appears in `IDSDL302.ROM`, but as a fragment of the `&`-command
help token dictionary. It is further lineage evidence, not analog-Courier DS0
support.

## Analog and digital in one image

The images are a combined build whose line side is selected at runtime.

The AT help table at `QF+0x233db` carries a three-way mode command that exists
in no standalone analog Courier image:

```
%D0  Standard Analog (POTS)
%D1  T1 Mode (DS0)
%D2  ISDN PRI Mode
```

Occurrences of those mode strings: `IDSDL302.ROM` 0, `main211` supervisor 0,
QF 6.0.3 five, QR 6.1.3 five.

The Courier product-name table at `QF+0x020331` extends the usual
`Dual Standard` / `HST` / `V.32bis` / `14400` … `Fax` list with
`Analog/Digital Quad`, `Analogue/Digital Quad`, `Digital Quad`,
`Analog Quad`, and `Analogue Quad`.

Both plants are implemented, not merely named:

- Analog: `OFF HOOK` / `ON HOOK`, `PHONE OFF HOOK`, `OFF HOOK RESTRICTED`,
  `Loop loss disconnect`, blacklist, pulse and DTMF dialling with the full
  `DTMF "0"`…`DTMF "D"` digit table, `Analogue Loopback (ALB)`.
- Digital: the `S47` bitmap (`Disable Call Signaling`, `Dial using DTMF, not
  MF`, `Disable KP & ST MF Xmit`, `Config based on ANI`, `Force Gateway NAC
  Routing`), `S62 Number of ANI digits`, `S63 Number of DNIS digits`,
  `S71 T1 Idle Disconnect Pattern`, `S73 Default Dialout PRI Slot`,
  `ISDN Universal Connect`, `LLC IE for ISDN HDLC`.

The digital support is DS0-level, not T1-framer-level: there are no `ESF`,
`B8ZS`, `AMI`, `D4`, alarm, or slip strings in either image. That matches
`DP030105`'s `Change DS0 state on Quad Modem NAC` — the framer lives on the
PRI/gateway NAC, and the Quad card runs a Courier modem engine per delivered
DS0, or drives a real DAA when the card is the analog variant.

## Execution

Current results: [interrupt-driven chassis reception](nmc-sdl-protocol.md) and
[QF CPU byte-terminal AT/OK execution](quad-at-terminal.md) are now measured.
The historical flat-image probe below predates the selected modem memory and
terminal adapter; its conclusion that a chassis handshake is required is not
established.


Neither NAC contains a reset vector. Their start record is a null `0000:0000`
and their top painted span is two bytes at `0xfbfee`, not `0xffff0`; like the
I-modem NAC these are operational code without the card's boot block. The
first painted word at the `0x80000` load base is `e9 30 01`, a near jump to
`0x80133`, followed by the PCB initialisation table (`0xffa0`/`0xffa2` =
`LCSST`/`LCSSP` and `0xffa4`/`0xffa6` = `UCSST`/`UCSSP` on the 80C186EB — see
the peripheral-map note below). The card's boot block enters the
operational image there, so that is the entry to model.

Entered at `0x80000` under `CourierMachine`, both images execute 8,000,000
instructions with no fault: they program the PCB chip selects and timers, write
the interrupt vector table, and issue their DSP queue initialisation
(35 writes, `QF` at `pc=8016a`, `QR` at `pc=80176`). Neither reaches its AT
layer — `serial_text` is empty and `ticks` and `timer_interrupts` are both zero.

Both park in the same routine (`QF+0x819e6`, `QR+0x81908`):

```
push dx
mov  dx, 0x226
in   al, dx
pop  dx
mov  byte [0x467], 0x64
call word [0x45c]
retf
```

followed by a state machine that compares `al` against `0x32` (`'2'`) and `0x02`
and rewrites the dispatch vector at `[0x45c]`. This is the card waiting on its
host interface — the SDL detection the NETServer release notes describe for
operational code. `QF` additionally polls `in 0x0200` 96,170 times against
`out 0x0042` 96,151 times; `QR` spins on memory with almost no I/O (283 events).

So the images stop where real hardware would stop: waiting for the Total
Control chassis to speak to them. Going further means modelling the NAC host
interface at `0x0220`–`0x022a` and `0x0200`, not stubbing the poll.

## Would the Courier boot block match?

No. The two share the boot block's conventions exactly, and disagree on every
value that describes the board.

### The table format is an exact match

The Courier 3.02 boot block enters at `fc00:1a21` (`0xfda21`) and drives a
`(port, value)` word-pair table at `cs:0x1976` (`0xfd976`) with:

```
lodsw ax, cs:[si]   ; port
xchg  dx, ax
lodsw ax, cs:[si]   ; value
out   dx, ax
loop
```

It has `0x24` (36) entries. The Quad application header at `0x80003` — reached
by the `e9 30 01` near jump at the `0x80000` load base — is a table in the
*same* encoding with the *same* 36 entries, and writes the same
`0xffa4 = 0x8000` that the Courier reset stub at `0xffff0` writes itself —
though the two chips do not agree on what `0xffa4` is, see below.
The Quad operational image carries the Courier boot block's own initialisation
convention.

### The values describe a different board

Nineteen ports appear in both tables. Only six hold identical values
(`0xff80`, `0xff84`, `0xff88`, `0xff94`, `0xffa0`, `0xffa4`).

Both parts are **80C186EB**, and the comparison below uses that map
(Table 4-1 of the manual in this tree). Decoding the 302's boot table with it
cross-checks against this repository's own hardware-derived model:
`courier_emu/uart.py` documents the board's serial unit as `B0CMP` "written
`0x8015`" and `S0CON` "written `0x21`", in a "relocated peripheral control
block" — and the table writes exactly `0xff60 = 0x8015`, `0xff64 = 0x0021`,
and `0xffa8 RELREG = 0x10ff`. Three independent agreements, so the decoding is
right.

| EB register | 302 boot block | Quad init table |
| --- | --- | --- |
| `LCSST` / `LCSSP` | `0x0000` / `0x200a` | `0x0000` / **`0x400a`** |
| `UCSST` / `UCSSP` | `0x8000` / `0xffce` | `0x8000` / `0xffcf` |
| `RELREG` | `0x10ff` — PCB relocated | **not written** |
| `B0CMP`/`B0CNT`/`S0CON` | `0x8015`/`0x0000`/`0x0021` | not in the table |
| `B1CMP`/`B1CNT`/`S1CON` | not written | **written** |
| `GCS` pairs | 0, 1, 2, 4, 5, 6 | **all eight, 0-7** |
| `T0CMPA` / `T0CON` | `0x6270` / `0xc001` | `0x04ec` / `0xc000` |
| `T1CMPA`/`T1CMPB`/`T1CON`, `T2CNT`/`T2CMPA`/`T2CON` | not in the table | **written** |
| `P1DIR`/`P1CON`/`P1LTCH`, `P2DIR`/`P2CON`/`P2LTCH` | written | not in the table |
| `IMASK`, `PRIMSK`, `INSERV`, `REQST`, `INSTS`, `SCUCON`, `I3CON`, `PWRCON` | written | `I1CON`-`I4CON`, `IOCON` instead |

Same silicon, different board. The differences that matter are `LCSSP`
(`0x200a` against `0x400a` — a different lower chip-select extent, so a
different RAM size), the Quad using all eight general chip selects where the
302 uses six, the Quad programming all three timers where the 302's boot table
programs only `T0`, the 302 relocating its peripheral block where the Quad does
not, and the two setting up *different* on-chip serial channels — the 302
channel 0, the Quad channel 1.

So the Courier boot block would hand the Quad application a card with the wrong
RAM extent, two chip selects unconfigured, its peripheral block relocated out
from under it, and the wrong serial channel running.

### Grafting it on

Copying the Courier boot block (`0xfc000..0xfffff` of `IDSDL302.ROM`) onto the
Quad flash and entering at the reset vector `0xffff0`, the boot block executes
normally on Quad flash: 36 word writes and 9 byte writes from its two tables,
then `rep movsw` of `0x1975` bytes of itself to `0000:0000` (the hot address is
`0xfda61`, 3,260 iterations), then `int 0x13` — its dispatch, where the harness
stops with `status: software-interrupt`.

That path is not open to the Quad either: `recovery.py:178` accepts `int 0x13`
only at `BANK_PHYSICAL + 0x1c05`, the SV25 bank address.

So the graft shows the Courier boot block *executes* on Quad flash. It does not
reach a handoff, and the table comparison above says it should not be given
one.

### The word at `0xfbfee` is the image CRC

`recovery.py` shows the Courier loader computing an application CRC and
comparing it against a stored word before entry (its `application-crc` event at
`0x10a3`). The Quad images leave `0xfbff0..0xfffff` — 16 KiB, boot-block sized —
entirely unpainted, and paint exactly two bytes at `0xfbfee`, immediately below
it: `QF 6.0.3 = 0xf40a`, `QR 6.1.3 = 0xc29d`.

Both values are reproduced exactly by **CRC-16/X.25** — reflected polynomial
`0x8408`, init `0xffff`, final XOR `0xffff` — over `0x80000..0xfbfee`, with
unpainted flash counted as erased `0xff`:

```
QF 6.0.3 -> 0xf40a   (stored 0xf40a)
QR 6.1.3 -> 0xc29d   (stored 0xc29d)
```

Two independent images matching on the first algorithm tried after the table
was identified is proof rather than coincidence. The 256-entry `0x8408` table
itself is present in both Quad images (`QF+0x1cae`, `QR+0x1bd0`) and in the
chassis NMC image `NM040103.NAC` (`+0x20d0`), byte-identical and
little-endian — the same CRC the NMC's `msg_head.crc1`/`crc2` framing uses.
See [nmc-sdl-protocol.md](nmc-sdl-protocol.md).

So the card's own boot block verifies the operational image with the same CRC
the chassis uses on the wire, and the covered range confirms that
`0xfbff0..0xfffff` is reserved for the boot block and excluded from the check.

Note also that on the Courier, `0xf8000..0xfbfff` is the parameter sector area
(`courier rom-info` lists sectors from `0xf8000`), not application space. The
Quad does not paint there either, so the two agree on the shape of the reserved
top of flash while disagreeing on what fills it.


## A note on the peripheral map

`0xff56` is written by the Quad's DSP-interface routine at `0x93864`, which
sets its bit 1, then later clears bit 1 and pulses bit 3. Table 4-1 of the
80C186EB manual in this tree names `0xff56` **`P1LTCH`**, the Port 1 output
latch — so those are GPIO strobes around the DSP access.

Finding that is what forced the map above. Two claims made here earlier are
withdrawn:

- **"The Quad leaves the Courier's timer setup alone."** It does not. `T0CON`,
  `T1CON` and `T2CON` are all in its table. That error came from reading
  `0xff50`-`0xff66` as the timer block, which is the classic 80186 map, not
  this part's.
- **"The two program different silicon, so the tables are not comparable."**
  Also wrong, and briefly committed here. It rested on reading `0xffa8 = 0x10ff`
  as an `MPCS` value implying a classic part; on the EB `0xffa8` is `RELREG`,
  and `uart.py` independently describes this board relocating its peripheral
  control block. Both parts are 80C186EB and the tables compare directly, as
  above.

The Quad also programs an on-chip serial channel, and uses **channel 0**
heavily at runtime — `S0CON` at 38 sites, `S0STS` 30, `S0RBUF` 20, `S0TBUF` 39
— which is the same channel `uart.py` models as the analog board's DTE path.
Channel 1 is barely used (`S1RBUF` never read). The external `0x220` block
identified in [nmc-sdl-protocol.md](nmc-sdl-protocol.md) is a separate device
and is the one the SDL state machine polls, so that identification stands.
