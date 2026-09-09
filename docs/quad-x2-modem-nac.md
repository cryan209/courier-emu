# The Quad x2 Modem NAC images

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

Neither NAC contains a reset vector. Their start record is a null `0000:0000`
and their top painted span is two bytes at `0xfbfee`, not `0xffff0`; like the
I-modem NAC these are operational code without the card's boot block. The
first painted word at the `0x80000` load base is `e9 30 01`, a near jump to
`0x80133`, followed by the 80186 PCB initialisation table (`0xffa0` UMCS,
`0xffa2` LMCS, `0xffa4` PACS, `0xffa6` MMCS). The card's boot block enters the
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
`0xffa4 PACS = 0x8000` that the Courier reset stub at `0xffff0` writes itself.
The Quad operational image carries the Courier boot block's own initialisation
convention.

### The values describe a different board

Nineteen ports appear in both tables. Only six hold identical values
(`0xff80`, `0xff84`, `0xff88`, `0xff94`, `0xffa0` UMCS, `0xffa4` PACS).

| Register | Courier 3.02 | Quad | Consequence |
| --- | --- | --- | --- |
| `0xffa2` LMCS | `0x200a` | `0x400a` | 128 KiB RAM vs 256 KiB |
| `0xffa6` MMCS | `0xffce` | `0xffcf` | different mid-range chip select |
| `0xff32` INT0 | `0x6270` | `0x04ec` | reassigned; the Quad writes `0x6270` to `0xff42` instead |
| `0xff36` INT2 | `0xc001` | `0xc000` | |
| `0xff3a` INT4, `0xff3c`, `0xff3e`, `0xff40`, `0xff42`, `0xff46`, `0xff70`, `0xff72`, `0xff74`, `0xff8c`, `0xff8e`, `0xff9c`, `0xff9e` | not programmed | programmed | four channels need more interrupt inputs and selects |
| `0xff50` T0CNT, `0xff56` T0CON, `0xff58` T1CNT, `0xff5e` T1CON, `0xff60` T2CNT, `0xff62` T2CMPA | programmed | not programmed | the Quad sets its timebase elsewhere |

The Courier boot block would hand the Quad application a card with half its RAM
mapped and the wrong interrupt wiring.

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

### An open question: the word at `0xfbfee`

`recovery.py` shows the Courier loader computing an application CRC and
comparing it against a stored word before entry (its `application-crc` event at
`0x10a3`). The Quad images leave `0xfbff0..0xfffff` — 16 KiB, boot-block sized —
entirely unpainted, and paint exactly two bytes at `0xfbfee`, immediately below
it: `QF 6.0.3 = 0xf40a`, `QR 6.1.3 = 0xc29d`.

Position and precedent both suggest this is the stored application checksum the
card's own boot block verifies. It is **not proven**. Over the painted body,
neither value is reproduced by a byte sum, a word sum, their negations, a word
XOR, or CRC-16 IBM, MODBUS, CCITT-FALSE, or XMODEM. The algorithm and the
covered range are both still unrecovered.

Note also that on the Courier, `0xf8000..0xfbfff` is the parameter sector area
(`courier rom-info` lists sectors from `0xf8000`), not application space. The
Quad does not paint there either, so the two agree on the shape of the reserved
top of flash while disagreeing on what fills it.
