# The chassis side: SDL in `NM040103.NAC`

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

### Verification status

Partial. At runtime `[0x45c]` reads `0x19f6`, so the initial state is installed
where this says it is, which corroborates the walk above.

But it does not advance. Holding `0x222 = 0x01` (RxRdy) with `0x226` set to
`0x32`, to `0x02`, or `0x222 = 0xff`, produces a run identical to the
unseeded one — same tick count to the tick — so the receive entry at `0x819e6`
is **never reached**. It is not polled from the idle loop; the idle loop at
`0x81976` is a *transmit* scheduler, walking `bx` over 0, 2, 4, 6 and testing
`word [bx + 0x4a1] & 1` for a pending slot.

So the entry is interrupt-driven off the USART, and this harness has no model of
that block as an interrupt source. Exercising the handshake needs one: a device
at `0x220`-`0x22a` that raises the engine's receive interrupt, presents RxRdy in
`0x222`, and hands the queued byte through `0x226`. With that, the sequence to
feed is `'2' '2' STX` followed by a frame — and the CRC to compute over it is
the one above.
