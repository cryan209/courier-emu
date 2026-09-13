# The datapump gate in 302 addresses

**Everything here is 302 and 403.** `main211.xmf` is not fully modelled and its
runs are not evidence about this board.

**The arming question is answered in
[datapump-gate-403-addresses.md](datapump-gate-403-addresses.md)**: an answered
call arms the datapump from the DSP with one message, `0047:0007`, and `&L1` or
`&T1` arm it by command. This document keeps the 302 static reading of the same
structures, and two 302 findings that belong nowhere else.

## The gate, read statically on 302

`0x8b84f` is a discriminator returning not-equal if any one of three flags is
set:

```text
8b84f  test byte [0xa96], 2
8b856  test byte [0x5a5], 1
8b85d  test byte [0x685], 1
```

All three are zero in every run this project has made, so it returns equal, and
that gates two things at once.

**The overlay id.** `[0xe3c]` is assigned at `0x8bbaa`-`0x8bc4d`, and the whole
block is skipped when the discriminator returns equal:

```text
8bbaa  call 8b863           ; CF gate
8bbad  jae  8bbc2
8bbba  mov  byte [0xe3c], 6
8bbc2  call 8b84f           ; the discriminator
8bbc5  jne  8bbca
8bbc7  jmp  8bc52           ; equal -> skip every [0xe3c] assignment
```

`[0xe3c]` stays zero, so the post-dial sequencer's gate at `0x8b5ca` never calls
the loader at `0x8e5da` and the run reports `bootstraps: 1`. The loader is the
transport the bridge already models (`out 0x1e, 4` then poll bit 2); it is simply
never entered on a dial.

**The `0x10` dispatch.** Same discriminator at the dispatch site:

```text
8bee8  mov   ax, 5a
8beeb  call  8b863        ; -> CF
8beee  jb    8bef8
8bef0  call  8b84f        ; -> ZF
8bef3  je    8bf01        ; ZF set: send nothing
8bef5  mov   ax, 10       ; the datapump dispatch
```

[datapump-slots.md](datapump-slots.md) has the nine-slot table that mailbox
commands `10` and `11` select. `mov ax, 10` is never executed on a dial; the run
emits `0017:704d` from the equal branch one site over.

Measured with `--trace-pc` across a full 302 dial:

| watch | hits |
|---|---|
| queue drain `8f521` | 45 |
| discriminator `8b84f` | 19 |
| dispatch site `8bee8` | 1 |
| `send-10` `8bef5` | **0** |
| loader gate `8b5ca` | 1 |
| `call-loader` `8b5d1` | **0** |

Flag C is the only one with a setter: `[0x685] |= 1` at `0x876c5`, reached from
`0x876b1` when `[0x33e] & 4 == 0` (the run has `033e: 2`). `0x876b1` is entry 1
of a nine-stub thunk table at `0x875d8`, reached from the indexed jump at
`0xa6ad7` (`jmp word ptr cs:[bx + 0x1dbe]`, `bx = 2 * AL`, CS `a4d2`), whose
table sits at `0xa6ade` and rejects `AL = 2`. `[0x5a5]` bit 0 has no setter
anywhere in the image, only `and [0x5a5], 0xfe` at `882db` and `8982e`; there is
no `or [0xa96], 2` either.

`AL` is **not a call-progress event code.** The router's entry at `0xa6a6c`
begins `lcall 8000:9cbc`, a decimal ASCII parser (`lodsb`, `sub al, 0x30`,
`mov ah, 0xa`, `mul ah`, accumulate), so `AL` is a number taken from a command
string - which is the reading the 403 work confirmed when it identified the
table as the ampersand family and entry 19 as `&T`.

The cells read off the running 4.03d board with `ATGLK2=`, as found, after `ATZ`,
and while an inbound call was offered with `S0=0`, are identical at all three
samples:

| `685` | `5cd` | `33e` | `5a5` | `a96` | `e3c` | `5fa` | `600` | `ea7` |
|---|---|---|---|---|---|---|---|---|
| `ff` | `e0` | `11` | `08` | `00` | `00` | `00` | `00` | `00` |

**These addresses are 302-derived and the board runs 7.4.16.** The comparison
only holds if the data layout is unchanged between builds, which is not
established - the 403 addresses are in the other document, and the board reads
taken *at* them are all zero.

## The supervisor's real dispatcher, and a bridge assumption it retires

`0x8f564` is `call word ptr [0x298]` - an indirect call through the current
state handler with a selector in AL. Across a whole dial it runs three times:

| instruction | AL | result |
|---|---|---|
| 5,847,937 | `83` | the first `0083:0083` |
| 35,662,523 | `83` | the second |
| 59,801,997 | `82` | BX=`704d`, the `0017:704d` the run emits |

So `0x82` on 302 is an internal state selector, **not an ASIC register write**.
`bridge.py`'s `_maybe_start_asic_call_engine` arms the call on
`asic_registers[0x82] == 0x00A0`, which is main211's protocol; 302 never writes
that register at all, and its `0x1f` commit fallback sees six messages all
carrying data `0000`. Hence `call_overlay_available: true`,
`call_overlay_active: false`.

## Solved along the way: why 403 sent a zero tone level

403 originally put 66,251 samples of pure silence on the line where 302 put
DTMF. Every stage was checked and every stage was correct - the tag `0x13`
handler at `0xee20` arms the oscillator from the right table entry, the phase at
`0x3c0` advances by exactly the loaded increment, the pair generator at `0x8743`
accumulates a waveform into `0x3c7`, and the ISR's sixteen-slot ring at
`0x0bc0`..`0x0bde` is written and read by both ends correctly.

The signal died at `80db  mpy @12` - the accumulator times the gain at `0x392`,
which was zero. The supervisor genuinely enqueued zero, and the value is not
computed at all:

```text
a0ab1   mov bx, word ptr [0x0cd9]   ; -> mailbox tag 001a -> DSP 0392
a0ac4   mov bx, word ptr [0x0cdb]   ; -> mailbox tag 001b -> DSP 03f1
```

Read off the running board, those cells hold `32c8` and `0c08` - the same two
values 302 sends. The full chain is **EEPROM -> RAM `0x071b` -> scattered by
`c9aa6` -> `0cd9`/`0cdb` -> mailbox tags `1a`/`1b` -> DSP `0392`/`03f1`**, and
`0x071b` is the +S extended register block `courier_emu/nvram.py` already models
as `IDSDL302_EXTENDED`, whose words at block offset 23 and 25 are exactly those.

**The gap was an EEPROM offset.** 7.3.14 stores the block from the high byte of
EEPROM word `0xc1`; 7.4.16 stores it five words later, from word `0xc6`. Running
403 against the 302 fixture landed block offset 10 at RAM `0x071b` where the
board lands offset 0:

```text
board  071b: 46 00 00 00 0a 23 04 ff 09 7d 4b 00 0d 02 00 06 ...
emu    071b: 4b 00 0d 02 00 00 40 94 11 00 40 0d 02 c8 32 08 ...   (= ref[10:])
```

The block's trailer confirms the alignment: 302's last two bytes are ASCII `"02"`
closing a `"3.02"` version string; the board's are `93 01` - `0x0193`, 403.

`CourierNvram.idsl403_fixture()` seeds the board's own block at that offset and
`--nvram-fixture idsdl403` selects it:

| observation | 403 before | 403 with the fixture |
|---|---|---|
| datapump transmit peak | 0 | **22,764** |
| digits decoded off the line | `""` | **`6245`** |
| DTMF blocks | 0 | 137 |
| exchange outcome | - | `answer`, state `ringback` |
| tag `0019` | `c802` x6, `0400` | `020d` x7 |
| tag `001a` | `0000` x4 | **`32c8` x4** |
| tag `001b` | `0000` x4 | **`0c08` x4** |
| tag `001f` | `0032` x6 | `0000` x6 |

The settings records are a separate question and the five-word shift does
**not** extend to them: both builds keep them at EEPROM word 94. The two
firmwares cache the part at different RAM addresses - 7.3.14 copies words
94..102 to `0x0752`, 7.4.16 copies the whole 512-byte part to
`0x058e..0x078d`, so the same words land at `0x058e + 188 = 0x064a`. Decoded
there they give six unanimous 3-of-3 records:

| setting | 1 | 2 | 3 | 4 | 5 | 6 |
|---|---|---|---|---|---|---|
| 403 (`IDSDL403_NVRAM`) | `0x00` | `0x1f` | `0x07` | `0x1e` | `0x00` | `0x00` |
| 302 (`IDSDL302_SETTINGS`) | `0x00` | `0x1e` | `0x07` | `0x1e` | `0x00` | `0x00` |

One bit of setting 2 apart, which is what the shared 20.16 MHz hardware
predicts. Reproduce with `courier_emu.ram_dump.decode_settings` over
`IDSDL403_NVRAM[0x064a - 0x058e:][:18]`.

## Solved along the way: host-message delivery

Delivery used to be triggered by the supervisor's `0x1C` bit 0 acknowledgement
acting on a latch pair that the `0x58`/`0x5a` and `0x5c`/`0x5e` writes updated
independently. An acknowledgement landing between those two pairs delivered a
**new tag with the previous message's data**, and one arriving when no new
message had been assembled re-delivered the stale latch - which is why both
images delivered more messages than they assembled (403: 68 assembled, 70
delivered; 302: 66 and 68).

The `0x5E` write - the message's last byte - now latches `_runtime_pending`, and
the `0x1C` commit delivers that pair and clears it. Assembled and delivered now
agree on both images, and 302 is unchanged in behaviour.

This fixed a real defect and did **not** fix the 403 tone, because the tone was
never a delivery problem. See the EEPROM offset above.

## A separate gap: the parameter sector is absent

`ATI7` on the hardware ends with a line the emulator does not print:

| field | board 4.03d | emulator, 302 + fixture |
|---|---|---|
| Product type | Russia (ex. US/Canada) External | US/Canada External |
| Supervisor rev | 7.4.16 | 7.3.14 |
| DSP rev | 3.1.2 | 3.0.13 |
| **Serial Number** | `0009540034268322` | **line absent** |

The serial number lives in the parameter sector, not NVRAM, and no dial run
passes `--parameter-sector` or `--parameter-flash`. Supplying one restores the
line. It does not affect the datapump gate. (`courier_emu/parameters.py` is a
211-only store; 302/403 have no equivalent modelled.)

The `Options` line is identical on both, so the unit's V.34/V.90 entitlement is
not what refuses the overlay.

## Ruled out - do not re-run these

**The profile hypothesis.** The three flags are not profile-derived. `AT&F`
loads the ROM defaults into the working profile the call actually uses, and the
gate does not move:

| run | `call-loader` `8b5d1` hits |
|---|---|
| `ATDT6245` | 0 |
| `AT&F` then `ATDT6245` | 0 |
| `--parameter-sector` with serial and V.34/V.90 feature bits | 0 |

**Uninitialised RAM.** The emulator's RAM is `0xff`-filled, not zeroed, so the
`00`s a 302 run reads at `685`, `5cd`, `5a5`, `5fa` and `600` are the image's own
data initialisation rather than a missing write. Watching all seven
`mov byte [0x685], 0` sites and both `and [0x5a5], 0xfe` sites across a full
dial gives zero hits on every one: they start at zero and nothing clears them.

**Applying 302 addresses to a 403 run.** This cost several revisions of this
document. 403's message ring is at `[0x194]` wrapping at `0x1c8`, not
`[0x29a]`/`0x2ce`; watching `29e` on a 403 run reads unrelated variables and
looks like a scribble. The DSP dispatch table read at program `83e9` is 3.1.2's
address, so reading it against 302 returns `8179`, inside the serial ISR, and
means nothing. **On this pair of images an address is only meaningful with its
image named.**

**Blaming the delivery path for the zero gain.** It carried the zero faithfully
at every hop. The `32c8` once attributed to a 403 run was read off a 302 run.

**Three mangled-looking words** - `0032`, `c802`, `0400` - at DSP 40.6M are not a
corrupted `32c8`. The tag `0x1a` handler does not run until 51.28M; they belong
to other tags.
