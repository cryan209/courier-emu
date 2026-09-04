# The Courier boot-block flash loader

This is the downloader FreeLSD and SDL.EXE talk to. It lives in the top 16 KiB
flash block and is a different mechanism from the application's `AT~X!` XMODEM
updater: it takes a raw 512 KiB flash image rather than an `.XMD` container, and
it speaks its own binary protocol. Everything here is disassembled from
`artifacts/courier-board-21210-capture-01/courier-board.rom`, the user's own
supervisor 7.3.14 unit. Physical addresses are file offset plus `0x80000`, and
segment `fc00` is file `0x7c000`.

`courier_emu/sdl_download.py` implements the host side.

## Reset to RAM

`0xffff0` programs the chip select that decodes the ROM and jumps:

```
cli ; mov dx,0xffa4 (UCSST) ; mov ax,0x8000 ; out dx,ax ; jmp far fc00:11e9
```

`fc00:11e9` zeroes the segment registers, sets `SP=0xf8`, writes RELREG, replays
`0x24` word records from `fc00:113e` and 9 byte records from `fc00:11ce` as
`OUT`s, copies `0x113d` bytes of itself to physical zero and dispatches `INT 13h`
through the IVT it just copied. The loader therefore executes from RAM, which is
why it can erase the block it came from.

## Which way it goes

`fc00:07ad`:

1. The word at `f7ff:000a` (`0xc000` on both this board and `IDSDL302.ROM`) sets
   the installed image type in `cs:[0x127]`: `2` for it, `4` otherwise.
2. `fc00:0702` identifies the flash: `0x90` to `0xffff0`, read manufacturer and
   device, `0xff` to restore. `0x4470` selects the seven-block table and
   `cs:[0x126]=6`; `0x2274` selects the five-block table and `4`; anything else
   is unsupported and the loader refuses.
3. `fc00:08a3` checks the image CRC. A failure goes straight to the download
   loop at `fc00:07f2`.
4. With a good CRC it reads `in al, 0x12` and boots the application unless
   `!(al & 0x14) && (al & 0x40) && !(P2PIN & 0x40)`. `0xff5a` is P2PIN, so that
   last term is an input pin. 3Com's `XMODEM.TXT` documents the same condition
   as DIP switches 1, 5 and 10 on with 8 off (7 on internal units). Which switch
   drives which bit is not established here.
5. Otherwise `cli; RELREG=0x00ff; jmp far f7ff:0005` into the application.

## Autobaud, and the knock

`fc00:0d38` arms the receive path. `fc00:0de6` and `fc00:0f61` sample the
receive line as a **P2PIN bit under timer control** — software serial, not the
UART — assemble one character, and require `(byte & 0x5f) == 'A'`. The captured
timer value becomes B0CMP, so the host picks the rate by sending `A`. `fc00:0e52`
installs `0x802a` for the recognised case.

Eight bytes then land at `0x12d` and `fc00:0d0c` compares them against the
constant at `0x141`:

```
02 45 07 48 6d 58 09 08
```

This is the same value the `.XMD` header carries inverted in its first eight
bytes, and byte 5 is the product discriminator (`0x58` Courier, `0x59` on
`SV25.XMD`). A first byte of `'!'` boots the application instead. Anything else
prints `MODEM FIRMWARE IS CORRUPTED. FIRMWARE DOWNLOAD IS NECESSARY.` and rearms,
so a failed knock is safe to retry.

## Identify

`fc00:0992`, and the application carries a byte-identical copy at file `0x28654`:

| step | who | bytes |
|---|---|---|
| 1 | modem | `0xe3` |
| 2 | modem | sets B0CMP `0x8082` |
| 3 | host | `'Q'` |
| 4 | modem | sets B0CMP `0x8102`, echoes `'Q'` |
| 5 | modem | restores the autobaud rate, sends two identity bytes and two zeros |
| 6 | host | image type (`2` or `4`), CRC high, CRC low |

The three B0CMP values the loader uses are `0x802a`, `0x8082` and `0x8102`.
`baud = clock / (8 × (CMP+1))` puts them at 58605, 19237 and 9730 on a 20.16 MHz
part — 57600, 19200 and 9600. **The host has to follow both switches**, sending
its `'Q'` at 19200 and reading the echo at 9600.

## Erase

`fc00:043d` walks block indices from `cs:[0x108]` to `cs:[0x126]`. The start is
2 for a 256 KiB image on a 512 KiB part and 0 otherwise. Indices 4 and 5 are
skipped. From the table at `fc00:0393`:

| idx | physical | size | erased |
|---:|---|---|---|
| 0 | `0x80000` | 128K | type 4 only |
| 1 | `0xa0000` | 128K | type 4 only |
| 2 | `0xc0000` | 128K | yes |
| 3 | `0xe0000` | 96K | yes |
| 4 | `0xf8000` | 8K | **never** |
| 5 | `0xfa000` | 8K | **never** |
| 6 | `0xfc000` | 16K | yes |

So the only permanently protected regions are the two 8 KiB parameter blocks,
which on this board hold nothing but a far jump at `0xfbff0`. **Block 6 is the
loader itself**, and it is erased and reprogrammed by every download.

## Records

`fc00:0b3c` drops the P1LTCH bit 6 write gate and feeds each received byte to the
handler in `cs:[0x10e]`, a state machine at `fc00:0b65`:

```
[len] [offset high] [offset low] [type] [data ...] [checksum]
```

The offset field loads DI. Type `2` takes two big-endian bytes into ES; type `0`
programs `len` bytes as little-endian words at ES:DI, advancing DI by two per
word and padding an odd tail with `0xff`; any other type ends the stream and
returns `0x17`. Every byte including the checksum is summed and must total zero.

The programming primitive at `fc00:0c67` is the Intel `0x40` word write with a
status poll. A record aimed at flash the loader did not erase cannot succeed.

## CRC, and how the download ends

`fc00:026f` is a table-less CRC-16 seeded `0xffff`. The spans it walks depend on
the image type, from `fc00:08a3`:

- type 2: `0xc0000..0xf7ffd`
- type 4: `0xc0000..0xfffff` **then** `0xc0000..0xf7ffd`, because the longer path
  falls through into the shorter one. Four blocks are summed twice and the
  parameter blocks and boot block are included. Both loops start at segment
  `c000`; this is what the ROM does.

Reimplementing it reproduces the word stored at `0xf7ffe` in both real images —
`0x3e73` for the board, `0x53bc` for `IDSDL302.ROM` — which pins the algorithm.
In download mode the loader computes that word itself and programs it at
`fc00:0956`, so a record stream must leave those two bytes alone.

The modem sends `0x15` before the erase and `0x16` when it completes, then
after the records: `0x14` complete, `0x17` stream ended, `0x18` record checksum
error, `0x19` image CRC mismatch, `0x1a` program timeout, `0x1b` erase failed,
`0x1d` block erase error. Then it reboots into the application.

A CRC mismatch is not fatal: the word is never programmed, so the next reset
fails the check at step 3 and drops back into this loader. The unrecoverable
window is a failure while block 6 is erased or being written.

## Building a stream

```sh
.venv/bin/python -m courier_emu.sdl_download IDSDL302.ROM \
  --preserved artifacts/courier-board-21210-capture-01/courier-board.rom \
  --image-type 4 --output artifacts/sdl-download-idsdl302-type4
```

`--preserved` supplies the blocks this download will not erase, so the expected
CRC is computed over what the flash will actually contain rather than over the
image alone. The report carries the CRC to hand the modem, the erased and
protected spans, and the result of replaying the stream through a model of the
loader's own state machine. For `IDSDL302.ROM` at type 4 that is 507,902 bytes
programmed in a 527,803-byte stream with no mismatches, expecting `0x952d`;
at type 2 it is 245,758 bytes expecting `0x53bc`, the word the reference ships.

Type 2 does not erase blocks 0 and 1, where `IDSDL302.ROM` differs from this
board in 180 bytes including the `LK2` dispatcher at `0x25ba9`, so a type 2
download would install the modified image only in part.

## What is verified, and what is not

Verified offline: the CRC algorithm against two real images; the record format,
checksums and coverage, by replaying a generated stream through a model of
`fc00:0b65`; the erase set and the protected blocks; the knock constant against
the boot block.

Not verified: everything on the wire. The autobaud, the knock exchange, the
three-rate identify handshake and the erase and result timings are transcribed
from the disassembly and have never been run against hardware or an emulated
loader. Running the boot block under the `recovery.py` style harness and driving
`Session` against it is the next step, and would close that gap without touching
the modem.

Tests:

```sh
.venv/bin/python -m pytest tests/test_sdl_download.py -q
```
