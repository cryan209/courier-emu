# Nine modulations, four images, and where fax lives

[fsk-modulation.md](fsk-modulation.md) found a nine-slot datapump table that
mailbox commands `10` and `11` dispatch through, and named two of its slots by
measuring them. This names the rest, accounts for the images they live in, and
follows the two things that are *not* in that table: the PCM downstream layer
and the fax modulations.

## The modem's own list

The firmware carries its answer in plain text. `AT*C` transmits a constant
carrier, and its help text at `0x19f5a` enumerates every carrier the modem can
produce - 76 of them, two per modulation per rate, one for each side:

```text
(0)  Bell 103, 300        (8)  V.23 Forward Channel     (26) HST 48
(2)  V.21                 (9)  V.23 Backward Channel    (32) HST 375 bps Back Channel
(4)  V.22                 (10) V.32 48                  (34) V.FC 96
(6)  V.22bis              ...  V.32 up to 216           (52) V.34 24 ... 288
```

`courier_emu.datapumps.carrier_families` reads it: **Bell 103, V.21, V.22,
V.22bis, V.23, V.32, HST, V.FC, V.34**. Nine families, slowest first - and the
datapump table is the same nine in reverse.

## The slots

Flags are bit *numbers*; the `BIT` instructions that test them carry bit
codes, and the C5x shifts by `~code & 0xf`, so code 14 is bit 1.

| slot | flag | table `9b48` (originate) | table `9b51` (answer) | modulation |
|---:|---|---|---|---|
| 0 | `@27` bit 1 | `9d00` | `9d00` | **V.34** |
| 1 | `@26` bit 4 | `b000` | `b000` | **V.FC** |
| 2 | `@27` bit 3 | `b052` | `b052` | **V.32 / V.32bis** |
| 3 | `@26` bit 5 | `c533` | `c7fd` | **HST** |
| 4 | `@26` bit 3 | `cd61` | `cce0` | **V.22bis** |
| 5 | `@26` bit 2 | `cd79` | `ccfa` | **V.22** (with Bell 212A) |
| 6 | `@27` bit 10 | `da31` | `d9bc` | **V.23** |
| 7 | `@27` bit 12 | `d808` | `d7fc` | **V.21** |
| 8 | `@26` bit 6 | `d7e9` | `d7d8` | **Bell 103** |

The order is the menu's, fastest first, which is what a rate-negotiation
fallback ladder looks like. Six of the nine are held up by something measured
rather than by the ordering alone:

* **V.34 and V.FC.** The two overlay predicates gate on S56 bits `0x40` and
  `0x80`, which the modem's own help text names `V34` and `VFC` - the
  firmware's label rather than an inference. See
  [pcm-x2-v90.md](pcm-x2-v90.md). Independently, `9d00` selects codec rate
  index 5 - 8000 Hz for a 3429 baud symbol
  rate, which is V.34's alone and which no other slot asks for. See
  [codec-sample-rates.md](codec-sample-rates.md).
* **V.22bis and V.22.** Both slots install the *same* transmitter `d34a` and
  receiver `ce6e`, differing only in a pointer to a 12-16 word parameter table.
  That transmitter steps a 12-entry carrier table by `@44`, which reads 2 on
  the originate entries and 4 on the answer ones: **1200 Hz** and **2400 Hz** at
  7200, with `@6c` at 300 and 600 Hz. Two configurations of one 600-baud
  datapump is exactly V.22bis beside V.22/Bell 212A.
* **V.23.** The two sides run *different* transmitters. Originate installs
  `db2d`, which keys between increments `0x2000` and `0x1bbc` - a 13:15 ratio,
  which is 390/450 to five figures and matches no other standard pair. Answer
  installs `dae0`, which builds its increment from `0x4aab`, the 2100.0 Hz
  constant the answer tone uses, plus a data-driven term. Backward channel from
  the caller, forward channel from the answerer: V.23, and independent proof
  that table `9b48` is the originate side.
* **V.21 and Bell 103**, measured in [fsk-modulation.md](fsk-modulation.md).

Two rest on weaker evidence and are worth re-testing:

* **V.32** for slot 2, whose region writes `@08` = `#4000` = 1800.0 Hz at 7200.
* **HST** for slot 3, on structure: its two sides have different transmitters
  (`c9d2`, `c9a5`), and of what is left HST is the asymmetric one - the menu
  lists 375 and 450 bps back channels for it.

That split is itself informative. Slots 0-2 carry the same entry in both
tables; slots 3-8 are side-specific. Echo-cancelled full duplex (V.34, V.FC,
V.32) needs no side in the entry; frequency-split or asymmetric modulations
(HST, V.22, V.23, V.21, Bell 103) do.

## Four images, and why 8 rides with 6

The loader settles the count. It masks the requested index to four bits and
compares against 6, 7 and 8, everything else falling through to the resident
segment; the row table at `0xe741` has rows 0-4 zeroed and rows past 8 are
garbage. Only 5, 6, 7 and 8 are ever written to the request byte `0x0d28`.

One image is never requested by itself:

```text
e60a  mov al, [0xd28]
e60d  and al, 0x7f
e60f  cmp al, 6
e611  jne e61b
e613  call e61b            ; load overlay 6...
e616  mov byte [0xd28], 8  ; ...then overlay 8 as well
```

So the sets are **{6, 8}** or **{7}** - and they cannot be otherwise, because
overlay 7 (`b000`-`cd49`) collides with overlay 6 (`9d00`-`ce31`) in program
memory while overlay 8 (`dc00`-`f949`) collides with neither.
`courier_emu.datapumps.overlay_chain` reports it.

Two predicates choose between them, at `0x8972` for 6 and `0x8999` for 7, each
gated on a disable bit in `[0x4c6]` (`0x40` and `0x80`) and a ceiling in
`[0x4dd]`. The DSP can also ask for an image itself:
`in al, 0x5c ; or al, 0x80 ; mov [0xd28], al`.

## V.90 and x2 are overlay 8

Overlay 8 is the PCM downstream layer, and the chaining is the argument: it
loads only alongside overlay 6, the V.34 core, which is what a PCM modem needs
for its upstream. It takes no slot in the datapump table because it is not a
modulation the modem *transmits* - it is a receiver for what the digital end
sends.

The supervisor carries both rate ladders as `CONNECT` strings, in 1333⅓ bps
steps:

| | rates |
|---|---|
| **x2** | 33333 … 57333, and 64000 - 16 rates, each also `/ARQ/x2` |
| **V.90** | 28000 … 62666, and 64000 - 28 rates, each also `/ARQ/V90` |

x2 starts at 33333 where V.90 starts at 28000, and V.90 fills in every step
between. How the two are enabled, what each hands the DSP, and what is still
unknown about them is in [pcm-x2-v90.md](pcm-x2-v90.md).

## Fax is resident, and it collides with overlay 8

The `AT*C` menu has no fax entry - its own text says fax carriers need
`AT+FCLASS=1+FATX=nn` instead - and the fax commands are in a separate parser
table at `0x20d80`, names then handler offsets: `TS= RS= TM= RM= TH= RH= CLASS
ATX= ARX= AA TXD= …`, which is Class 1 (`+FTM`, `+FRM`, `+FTH`, `+FRH`) and
Class 2.0.

On the DSP side the fax modulations are **in the resident bank**, dispatched by
three mailbox tags whose handlers park a table base in `@7d` and jump to a
shared selector at `dc8e` that indexes it by the argument's high nibble:

| slot | tag `21` | tag `22` | tag `20` | carrier | modulation |
|---:|---|---|---|---|---|
| 1 | `d853` | `d808` | `d864` | 1650/1850 | **V.21 channel 2** (300 bps HDLC) |
| 2 | `dc79` → `e525`/`e532` | `dc59` | `ddbb` | **1800 Hz** | V.17 |
| 3 | `dc75` → `e4f6` | `dc55` | `dd96` | **1700 Hz** | V.29 |
| 4 | `dc71` → `e4d5` | `dc51` | `dd78` | **1800 Hz** | V.27ter |
| 5 | `def0` | `def0` | `def0` | - | none |

`courier_emu.datapumps.fax_carriers` follows each slot's branches to the
`splk @44, #<increment>` it installs and reads it at 7200 Hz. 1700 Hz is
V.29's carrier and nothing else's, which is what makes that row an
identification rather than an ordering argument; the two 1800 Hz rows are
told apart by the same descending-speed convention the data ladder uses, so
V.17 above V.27ter is inference, not measurement. Tag `21`'s slots install a
transmit carrier and tag `20`'s install receive coefficients instead, which is
what half duplex needs; slot 1 needs no carrier of its own because it reuses
the FSK modulator's cells through the V.21 setup routines.

The consequence is structural: the fax dispatch (`dc48`-`dcf4`) and its
datapumps (`e4d5` onward) sit inside `dc00`-`f949`, which is exactly overlay
8's load range. **Loading the PCM layer overwrites the fax subsystem**, so a
V.90/x2 connection and Class 1 fax cannot be resident at the same time - the
board reloads for one or the other. The one part that survives is slot 1: the
V.21 channel 2 code is the same FSK datapump the data ladder uses, and it
sits below `dc00`.

## What is still open

* Slot 2 = V.32 and slot 3 = HST rest on one constant and on structure. Both
  should be measurable the way V.22 and V.23 were, by bringing the entry up and
  reading its carrier cells.
* Nothing separates x2 from V.90 *inside* overlay 8 yet. Overlay 8 does hold
  two code families, but the bit that forks them turned out to be `&X`, the
  synchronous clock source - see [pcm-x2-v90.md](pcm-x2-v90.md).
* V.17 versus V.27ter for the two 1800 Hz fax rows is an ordering argument.
* The `+FTM`/`+FRM` handlers reach the mailbox through the supervisor's command
  ring rather than a direct call, so the mapping from a Class 1 modulation
  number to one of these five slots has not been read out of the supervisor.
