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
