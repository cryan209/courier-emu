# The chassis side: SDL in `NM040103.NAC`

> Bring-up update (2026-09-10): see [Quad blockers](quad-bringup-blockers.md).
> Local RS-232 AT operation is documented; an NMC handshake is not a proven
> prerequisite. The original probe exposed spurious receive interrupts and missing
> channel-selected memory. The verification section below records the subsequent
> corrected interrupt-driven receive and CRC test.

`docs/x2/NM040103.NAC` is the Total Control Network Management Card image. It
is the *other end* of the download handshake the Quad x2 Modem NAC waits on, so
it is the place to recover that protocol from rather than guessing at it from
the card that only listens. See
[quad-x2-modem-nac.md](quad-x2-modem-nac.md) for the card side.

## Container

The file uses the same 32-byte header as the I-modem and Quad NACs — magic
`01 02 03`, then a little-endian payload length at offset 3 that equals
filesize minus 34 — but its body is **not** a binary Intel-HEX record stream.
It is a flat image beginning `eb 46` (a short jump) followed by the USR
copyright. `courier nac-info` correctly rejects it.

Body base address is `0x1fff`: string addresses pushed by the code equal file
offset plus `0x1fff`, verified across eleven separate strings and confirmed by
disassembling the referencing sites as coherent 32-bit code.

## The header fields, named by the image itself

The NMC contains its own header dumper at `+0x3b011`, which names every field:

```
%s, .SDL File Header:      %s, .NAC File Header:
file size: %d              card type: %d
sw type: %d                file type: %d
sw version: %d.%d.%d       group ID: %d
file prefix: %c%c          card list: %d, %d, ...
```

Mapping that onto the headers in this tree:

| File | Payload len (LE32 @3) | Version @8..0a | @0b..0e | Prefix @0f..10 | Card list @11.. |
| --- | --- | --- | --- | --- | --- |
| `Ie030002.nac` | `0x0cd187` | 3.0.2 | `00 02 01 01` | `IE` | `28` |
| `Ie030002.sdl` | `0x000eda` | 3.0.2 | `02 01 01 01` | `IE` | `28` |
| `QF060003.NAC` | `0x07776c` | 6.0.3 | `00 02 01 01` | `QF` | `0d 0e 0f` |
| `QR060103.NAC` | `0x0725e4` | 6.1.3 | `00 02 01 01` | `QR` | `22 23 24` |
| `QF030200.SDL` | `0x000aca` | 3.2.0 | `02 01 01 01` | `qf` | `0d 0e 0f` |
| `QR030300.SDL` | `0x000daa` | 3.3.0 | `02 01 01 01` | `QR` | `22 23 24` |
| `NM040103.NAC` | `0x132033` | 4.1.3 | `00 01 01 02` | `nm` | `06 15` |

The version triple confirms `nac.py`'s `VERSION_OFFSET = 8` against seven files,
and matches every filename. Two observations are solid: byte `0x0b` is `0x00` in
every `.NAC` and `0x02` in every `.SDL`, so it is the **file type**; and the
prefix at `0x0f..0x10` is two characters, not the three `nac.py` currently
reads, with the card list beginning at `0x11`. Each Quad release lists three
consecutive card IDs; the I-modem lists one; the NMC lists two. The exact
assignment of `card type`, `sw type`, and `group ID` among bytes `0x07`,
`0x0c`, `0x0d`, `0x0e` is **not** yet pinned down — the dumper's print order
need not be the struct order, and seven samples do not separate them.

## Backplane message framing

A second dumper at `+0xa0540` names the wire header:

```
msg_head.dest_adr: %x     msg_head.src_adr:  %x
msg_head.length:   %u     msg_head.message:  %*s
msg_head.crc1:     %x     msg_head.crc2:     %x
```

with the receive state machine logging `rx start` → `rx: alloc_buffed` →
`rx: have rbuf` → `rx: len_ok` → `rx crc ok`, and
`rxp state=%d /event=%d error` on failure.

## The CRC is shared with the card

All three images carry the same 256-entry **CRC-16/X.25** table — reflected
polynomial `0x8408`, stored little-endian — byte-identical:

| Image | Table offset |
| --- | --- |
| `QF060003` flattened | `0x1cae` |
| `QR060103` flattened | `0x1bd0` |
| `NM040103` body | `0x20d0` |

This is the `crc1`/`crc2` algorithm of the framing above, and it is also what
seals the Quad's operational image: with init `0xffff` and final XOR `0xffff`
over `0x80000..0xfbfee` it reproduces the stored word at `0xfbfee` exactly for
both Quad releases. Chassis framing and card image verification use one CRC.

## The SDL module

Function names are embedded in the image around `+0xe0567`:

```
nmc_sdl_prep              nmc_sdl_dnload_h2b_file   nmc_sdl_clac_crc
nmc_sdl_task              snd_rcv_nmc_sdl           sdl_kill_other_tasks
sdl_break_at_rec_boundary sdl_wrt_to_ws             sdl_erase_flash
ReadSlot                  WriteSlot                 ValidSlotData
```

`nmc_sdl_dnload_h2b_file` (host-to-board download, `+0x34840`) reads a 32-bit
command code from the head of the received message and dispatches on it:

| Code | Behaviour at `+0x348aa` onwards |
| --- | --- |
| `5` | falls through to the transfer step |
| `4` | posts, then returns 0 — end of transfer |
| `3` | sets the completion flag, then the transfer step |
| other | logs `Bad SDL command code (code= %d)` |

The NMC-side entry checks its own message the same way and accepts only `1`,
logging `Bad NMC SDL command code (cmd_code= %d)` otherwise.

`ReadSlot`/`WriteSlot` guard backplane slot access with VRTX event flags
(`FCLEAR`/`FAPEND`) on a `1 << (slot - 1)` mask, reporting `Read Slot
Collision!`, `Write Slot Collision!`, `Write Slot Timeout!`, and
`Read Write NVRAM conflict`.

Card-side error reporting names the rest of the transfer state machine:
`NAC Bulk trnsfr aborted (slot= %d)`, `Slot %d detects NAC data timeout`,
`Slot %d rcvd data while x'ed off`, `Slot %d rcvd invalid xfr frame`,
`Slot %d discard timer message`, and
`rcvd unexpected msg map=%d fc=%h sdl code=%d`.

## What this does and does not give the emulator

It gives the **message layer**: framing, CRC, command codes, slot arbitration,
and the transfer state machine's failure modes.

It does **not** give the byte-level register protocol at the Quad's own
`0x0226`. That port belongs to the card's local host-interface device, which
the NMC never touches directly — the NMC reaches slots through the backplane,
not through a NAC's local ports. So writing the Quad host interface still needs
the device identified from the card side: the initialisation writes
`0x0224 = 0x10,0x20,0x30,0x40,0x50`, then `0x0220 = 0x93, 0x17`,
`0x0222 = 0xff`, `0x0228 = 0x60`, `0x022a = 0x03`, `0x0224 = 0x80, 0x01`, on a
byte-wide device mapped to even addresses only (a 16-bit bus with A0
unconnected, so register *n* is at `0x220 + 2n`; the poll reads register 3).

The board latch bank is already recovered: the accessor at `QF+0x808db`
indexes a four-entry port table at `cs:0x931` — `0x0000`, `0x0200`, `0x0260`,
`0x0280` — with an output shadow at `[0x216..0x21d]`. Those are exactly the
ports the execution run touches.

## The card side of the handshake, recovered

This is the protocol the Quad engine is waiting on, read out of `QF060003`.

### Transport

The external USART block, byte-wide on even addresses:

| Port | Role |
| --- | --- |
| `0x220` | mode — written twice at init (`0x93`, `0x17`) |
| `0x222` | status — bit 0 RxRdy, bit 2 TxRdy |
| `0x224` | command — `0x10,0x20,0x30,0x40,0x50` reset walk, then `0x80`, `0x01` |
| `0x226` | data |

### The receive entry

`0x819e6` reads one byte and dispatches through a state vector:

```
push dx
mov  dx, 0x226
in   al, dx
pop  dx
mov  byte [0x467], 0x64     ; a countdown, reloaded on every byte
call word [0x45c]           ; the current state
retf
```

### The state machine

`[0x45c]` holds the next state as a near offset. Walking it:

| State | Expects | On match | On mismatch |
| --- | --- | --- | --- |
| `0x19f6` | `0x32` `'2'` | → `0x1a01` | stay |
| `0x1a01` | `0x32` `'2'` | → `0x1a19` | → `0x19f6`, clear `[0x467]` |
| `0x1a19` | `0x02` `STX` | → `0x1a44`, and initialise the frame | → `0x19f6` |
| `0x1a44` | any | collect the byte | — |

So the attention sequence is **`'2' '2' STX`**, and any wrong byte resets to the
start. On `STX` the frame state is set up: buffer pointer `[0x44c] = 0x44e`,
byte count `[0x448] = 0`, and CRC accumulator `[0x1533] = 0xffff`.

### The frame CRC

The collector at `0x1a44` stores each byte and folds it into the accumulator:

```
mov  di, [0x44c] ; stosb ; mov [0x44c], di     ; append
mov  dx, [0x1533]                              ; running CRC
xor  ah, ah ; xor al, dl ; shl ax, 1           ; index = (byte ^ crc_low) * 2
mov  bx, ax ; mov ax, cs:[bx + 0x1cae]         ; table lookup
mov  dl, dh ; xor dh, dh                       ; crc >>= 8
xor  dx, ax ; mov [0x1533], dx                 ; crc = (crc >> 8) ^ entry
```

That is the standard table-driven byte CRC with init `0xffff`, and the table at
`cs:0x1cae` is the **same CRC-16/X.25 table** that seals the flash image at
`0xfbfee` ([quad-x2-modem-nac.md](quad-x2-modem-nac.md)) and that the NMC's
`msg_head.crc1`/`crc2` uses. One CRC across the card image, the chassis framing,
and this link.

### Verification status — measured 2026-09-10

The unmodified **QF060003** controller now enters and completes this receive
path through the modelled DUART interrupt. Reproduce from the repository root:

```sh
PYTHONPATH=. .venv/bin/python tools/probe_quad_receive.py
.venv/bin/python -m pytest -q tests/test_quad.py tests/test_quad_receive.py tests/test_timers.py
```

The probe boots `docs/x2/Qf060003.zip` at `8000:0000` with `QuadBoard(identity=0)`
and runs eight million instructions. It does not patch code, seed parser RAM,
call the handler directly, or supply a periodic Courier interrupt. Results are
saved in `artifacts/quad-receive-20260910/results.json`.

The DUART drives **INT0/type 0x0c**, whose firmware vector is `8000:19ac`.
The Quad uses the 80C186EB interrupt mask layout: INT0 is IMASK bit 4,
so the startup value `0x00cc` enables it. Delivery requires CPU IF, the
controller mask, and an enabled DUART event selected by IMR. The ISR starts
with `STI`; the emulator therefore holds INT0 in service until the firmware
writes EOI (`0x8000` to `0xff02`). This prevents recursive receive interrupts.
Courier periodic INT0 events are disabled for this board profile.

The complete valid wire input was:

```text
32 32 02  00 00 00 00 04 00 00 00  41 42  7c 4d
attention  eight-byte header        body   CRC (low byte first)
```

Header bytes 4–5 specify **four trailing bytes, including the two CRC bytes**.
Byte 7 has bit 7 clear, selecting the short control-frame path. The CRC covers
the eight-byte header and `41 42`, excluding attention; init `ffff`, reflected
polynomial `8408`, final complement yields `4d7c`. Folding the appended CRC
produces the firmware's expected residue **`f0b8`**. This is a framing test;
it does not assign a higher-level command meaning to the synthetic body.

| Measurement | Valid frame | Final CRC byte changed from `4d` to `4c` |
| --- | ---: | ---: |
| Receive entry `0x819e6` | 15 | 15 |
| Header collector `0x81a44` | 8 | 8 |
| Body/CRC collector `0x81afc` | 4 | 4 |
| CRC-success branch `0x81b2c` | 1 | 0 |
| Control-completion branch `0x81b7e` | 1 | 0 |
| Final CRC accumulator | `f0b8` | `e131` |
| Empty data reads | 0 | 0 |

Both runs write the parser vector sequence
`19f6 → 1a01 → 1a19 → 1a44 → 1afc → 19f6`, consume exactly the queued 15 bytes,
and finish with an empty FIFO, empty sender queue and no pending DUART IRQ.
The valid frame reaches the instruction setting the control-complete flag;
the bad CRC returns to attention without reaching that instruction. Firmware
reads ISR `0x22a` once per received byte and never needs to poll SR `0x222`.

This supersedes the old claim that the receive entry was never reached and
the later spurious-zero result in the original blocker probe. It establishes
interrupt-driven framing and CRC acceptance in QF060003, **not** an NMC SDL
session, QR firmware validation, local AT readiness, or physical serial timing.
The sender is paced one byte per emulator service step into a three-byte FIFO;
serial baud timing, overrun, channel B, and full interrupt priority arbitration
remain outside this model.
