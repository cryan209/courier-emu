# Quad QF060003: the settings EEPROM and what each record controls

`ATI7` on the Quad reported `V32bis,Terbo,V.FC,V34+` — no HST, no x2, no V90.
None of that list was read from anything. It is the firmware's own XOR constant
surfacing as data when the settings part is absent.

The store is the same 93C66 Microwire part the 302 and 403 carry, at the same
EEPROM word, in the same layout, reached over the same 186EB PIO lines
`machine.py` already translates. Seeding one is all the Quad ever needed.

## The store

Six settings, three redundant differently-obfuscated bytes each, eighteen bytes
at **EEPROM word 94**, cached in modem RAM at `0x86ee..0x86ff`.

| | |
|---|---|
| pointer table | `0xceb4a`: `86fd 86ee 86f1 86f4 86f7 86fa` |
| storage order | physical slots hold settings **2,3,4,5,6,1** |
| getter | `0xceae1`, index 1..6 in `AL`, carry set on failure |
| setter | `0xceb58`, reached from `0xceaa9` (the `=` command path) |
| validator | `0xceba7`, 2-of-3 majority, `AH` names the dissenting copy |
| far wrapper | `0xc041:0x0e5d` — how other segments read any index |

The three copies are `ror(b,2)+5`, `rol(b,1)-0x0f`, and `b xor 0x1d` — byte for
byte the transforms `courier_emu.ram_dump.decode_settings` already implements
for the 302's `e237`. The storage order is `IDSDL302_RECORD_ORDER`. The word is
`IDSDL302_SETTINGS_WORD`. This is not a Quad-specific store; it is the Courier
settings part on a Quad card.

## The transport

Bit-banged Microwire on the 80C186EB PIO registers — not an I/O port, which is
why scanning for `out 0x10` finds nothing:

| line | register | bit |
|---|---|---|
| DI | `[0xff5e]` | 7 |
| DO | `[0xff5a]` | 7 |
| CS | `[0xff56]` | `0x20` |
| CLK | `[0xff56]` | `0x04` |
| DO direction | `[0xff58]` | 7 — cleared for the frame, restored after |

Twelve command bits are shifted MSB-first out of `BX` by the
`rol al,1 / rcl bx,1 / rcr al,1` sequence; sixteen data bits are shifted back in
from `[0xff5a]` bit 7 at `0xc1753`. Frame builders:

| routine | opcode | frame |
|---|---|---|
| `0xc16f7` | `AH=6` read | `ax = (di - 0x8632) >> 1; ah = 6; rol ax,4` |
| `0xc15e4` | `AH=5` write | same address arithmetic |
| `0xc1588` / `0xc158d` | — | fixed `bx = 0x4000` / `0x4c00` |

`(di - 0x8632) >> 1` puts RAM `0x8632` at EEPROM word 0, so the record block at
`di = 0x86ee` is word **94** exactly. `machine.py` already maps every one of
these lines onto the 93C66 model, so no new transport code was required.

## The failure mode when no part is fitted

Every record reads back zero, the majority vote fails, and the decoder returns
`0x00 xor 0x1d = 0x1d`. The boot decode at `0xc0940` takes the carry-set path,
which skips only the first two bits and then reads that `0x1d` as the feature
mask. `0x1d` carries bits 2 and 3, and those two bits are the entire reported
options list.

So the pre-seed `V32bis,Terbo,V.FC,V34+` was not a wrong feature set. It was the
XOR constant. `ATY14` printing `,,,,,` is the same fact on a different command:
six failed reads.

## What each setting controls

Measured, one record at a time against an otherwise-zeroed part, reading the
`ATI7` profile the firmware renders. Reproduce with
`PYTHONPATH=. .venv/bin/python tools/probe_quad_settings.py`; results in
`artifacts/quad-settings-20260910/results.json`.

Baseline with all six zero: `Product type US/Canada Rackmount`,
`Options V32bis`, no fax or cellular line.

### Setting 1 — country index → `[0x81c4]`

A plain index, not a bit field, into the 118-byte-per-entry country table at
`0xe6560`. Indices 0..22 are populated; 23 and above walk off the end and render
garbage.

| | | | | | | |
|---|---|---|---|---|---|---|
| 0 US/Canada | 1 Japan | 2 Finland | 3 Sweden | 4 UK | 5 Norway | 6 Switzerland |
| 7 Netherlands | 8 South Africa | 9 Italy | 10 New Zealand | 11 Czech/Slovakia | 12 Belgium | 13 Denmark |
| 14 Australia | 15 France | 16 Germany | 17 International | 18 Austria | 19 Ireland | 20 Spain |
| 21 Portugal | 22 Malaysia | | | | | |

### Setting 2 — feature mask → `[0x8838]`, `[0x8839]`, raw in `[0x81d2]`

`0xc0940` fans the bits out: bit 0 → `0x8838 |= 0x04`, bit 1 → `0x08`,
bit 2 → `0x40`, bit 3 → `0x80`, bit 5 → `0x20`, bit 6 → `0x8839 |= 0x01`.
Bits 4 and 7 are not tested there.

The options printer at `0xdf363` walks a single null-terminated string list
(`NONE HST V32bis Terbo V.FC V34+ x2,V90` at `0xdf45b`), so each set mask bit
emits the *next* string rather than a fixed one. That makes the list positional,
and worth reading as measured pairs rather than a bit-per-feature table:

| setting 2 | `[0x8838]` | Options |
|---|---|---|
| `0x00` | `0x03` | `V32bis` |
| `0x01` | `0x07` | `HST,V32bis` |
| `0x04` | `0x43` | `V32bis,Terbo` |
| `0x08` | `0x83` | `V32bis,Terbo,V.FC` |
| `0x0b` | `0x8f` | `HST,V32bis,Terbo,V.FC` |
| `0x0f` | `0xcf` | `HST,V32bis,Terbo,V.FC,V34+` |
| `0x18` | `0x83` | `V32bis,Terbo,V.FC` |
| `0x1f` | `0xcf` | `HST,V32bis,Terbo,V.FC,V34+` |
| `0x20` | `0x23` | `V32bis,x2,V90` |
| `0x3f` | `0xef` | `HST,V32bis,Terbo,V.FC,V34+,x2,V90` |
| `0x7f`, `0xff` | `0xef` | unchanged from `0x3f` |

**Bit 5 is the x2/V90 bit**, and `x2,V90` is one combined list entry, not two —
this firmware cannot report x2 without V90 or the reverse. Bit 6 switches the
ISDN line to `V.110, V.120, SYNC, PPP, X.75, & PIAFS`. Bits 4 and 7 produced no
visible change on their own; bit 1 moves `[0x8838]` but changes nothing printed.

### Setting 3 — fax → `[0x862e]`

Only bit 0 is observable: set, `Fax Options Class 1/Class 2.0` appears; clear,
the line is omitted entirely. Bits 1..7 changed nothing.

The list at `0xdf47f` also holds `Class 1` and `Class 2.0` as standalone
strings, but the three tests at `0xdf4c8`, `0xdf4d4` and `0xdf4e0` all test the
same bit 0, and no path reaches either one. They are dead, in the same way the
211's `x2` string is dead.

### Setting 4 — → `[0x862d]`, raw in `[0x81d3]`

| bit | effect |
|---|---|
| 0 | `Product type` gains an ` MSK` suffix |
| 5 | `Cellular Options MNP10 & MNP10EC` |
| 6 | `Cellular Options ETC` |
| 5+6 | `Cellular Options MNP10,MNP10EC & ETC` |
| 1,2,3,4,7 | no visible change |

`0xc09a6` forces `[0x862d] |= 0x04` immediately after the read, so that bit is
never the record's to control.

### Settings 5 and 6 — no observable effect

Neither is read by the boot decode at `0xc0940`, and sweeping all eight bits of
each changed nothing in the `ATI7` profile. They are still stored, still
majority-checked, and still printed by `ATY14`; whatever consumes them is
reached through the far wrapper rather than at boot.

## `ATY14`

`0xf0c7b` loops `cx` from 6 down to 1, calling the getter with the index in `AL`
and printing each value separated by commas. So `ATY14` reports settings
**6,5,4,3,2,1** in that order, and the bare `,,,,,` is six failed reads rather
than six empty values.

## A second writer

`0xf88fc` sets the same derived bits from a byte it reads with `lodsb`, not from
the EEPROM: bit 7 → `[0x8839] |= 1`, bit 6 and bit 5 → `[0x8838] |= 0x20`,
bit 1 → `[0x862d] |= 0x60`. It uses the cached raw settings `[0x81d2]` and
`[0x81d3]` as the baseline to fall back to when clearing those same bits.

So the EEPROM is the provisioning baseline, and something at runtime can raise
or lower x2/V90, PIAFS and cellular on top of it. What feeds that byte is not
established here.

## What is not established

- **What a real x2-provisioned Quad carries.** `0x3f` above is synthetic — it
  demonstrates that bit 5 is the x2/V90 knob and nothing more. The 403 part
  ships setting 2 as `0x1f`, with bit 5 clear.
- **Whether the Quad's power-on self test validates the part the way the 302's
  boot block does.** The 403 part is accepted without complaint, but
  `CHECKSUM_BYTE`/`CHECKSUM_SPAN` being the Quad's layout too is assumed, not
  measured.
- **What drives `0xf88fc`**, and what consumes settings 5 and 6.
