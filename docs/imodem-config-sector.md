# Where the I-modem keeps its settings

[imodem-d-channel.md](imodem-d-channel.md) ended on a 91-byte settings block at
`2600:d476` that nothing in a run ever fills, and
[imodem-board-map.md](imodem-board-map.md) ruled out the 93C66 EEPROM the other
Couriers carry.  The store is in the flash, and the updater walks straight
through it.

## The updater erases one sector and writes 196 bytes into it

Answering the flash as the AMD part the board actually carries
([imodem-board-map.md](imodem-board-map.md)) is what made this visible: under
the Intel identity the updater programmed nothing at all.  Under AMD it does
exactly one erase and one programming pass, and both land in the same place:

```
erase   flash offset 0x78000                  - SA8, the first 8 KiB boot sector
program flash 0x78000-0x79ffe, 8,192 bytes    - cpu 0xf8000-0xf9fff
```

Of those 8,192 bytes, **196 are not `ff`**.  That is not a firmware image.  It
is a record, written into an otherwise empty sector.

## It is stored twice

The sector is two 4 KiB pages, and they are identical:

```
page 0                                   page 1
0x002e  00                               0x102e  01        <- a generation byte
0x020b  07 00 08 00                      0x120b  07 00 08 00
0x024d  87 bytes of record               0x124d  the same 87 bytes
0x0ffa  01 00 00 00 ea 7f                0x1ffa  01 00 01 00 f0 7e
```

Byte for byte the same between `+0x30` and `+0xffa`; the only differences are
the generation byte at `+0x2e` and the six-byte trailer at the very end of each
page, whose third byte is that same generation and whose last word differs.  So
the layout is **two copies with a generation counter and a per-page trailer**,
which is how a part that can lose power mid-write keeps a good copy.  The last
word is a CRC, and it is recovered - see below.

## The record is the modem's configuration

No decoding needed to recognise it.  Twenty-one bytes into the record:

```
2b 0d 0a 08 02 3c 02 06 12 46 32
S2 S3 S4 S5 S6 S7 S8 S9 S10 S11 S12
43 13 10  8  2 60  2  6 18  70 50
```

S2 = 43 `+`, S3 = 13 CR, S4 = 10 LF, S5 = 8 backspace, S7 = 60 seconds to wait
for carrier - the Hayes S-register defaults, exactly as every Courier ships
them.  This is the NVRAM block `ATI5` prints.

What the updater is doing, then, is a read-modify-write of the configuration
sector: it looks for a valid record, finds an erased sector in this harness,
falls back to factory defaults, and writes two copies of them back.  That the
defaults are what it writes is itself the evidence that it looked and found
nothing.

## The firmware reads it back, and that is checkable

Capture the sector the updater wrote, lay it back over the flash window on a
second run, and the block at `2600:d476` changes - from the zeros the RAM wipe
leaves to the record's own content - and `ATI12` changes with it, `*P1` and
`*P2` going from `Voice Directory Number (DN1)` / `Data Directory Number
(DN2)` to `ADP Directory Number` / `Data Port Directory Number`.  Nothing
pokes RAM to do that; the firmware loads it.

```sh
# run once and keep what the updater wrote
.venv/bin/python -m courier_emu isdn-run Ie030002.nac \
    --instructions 20000000 --flash-save flash.bin
dd if=flash.bin of=config.bin bs=1 skip=$((0x78000)) count=$((0x2000))

# boot again with it in place
.venv/bin/python -m courier_emu isdn-run Ie030002.nac \
    --instructions 140000000 --flash-overlay 0xf8000=config.bin \
    --send AT --send AT --send ATI12
```

`--flash-overlay ADDR=FILE` lays a file over the window before the firmware
runs, reaching both what the CPU reads and what the part's own array holds;
`--flash-save FILE` writes the window out afterwards.

## The seal is a reflected CRC-16-CCITT

The firmware's own checksum routine is at **`0xba80f`**, reached through the
far entry `b3d9:6aa9` that the RAM-block checksum at `c4ecb` calls once per
byte.  Twenty instructions, no table:

```
ba815  mov dx,[cf30]     ; the accumulator
ba815  xor al,dl         ; mov dl,al ; mov ah,0
ba81b  shl ax,4          ; xor dx,ax ; shr ax,1
ba822  xchg dl,dh        ; xor dx,ax ; shl ax,4
ba829  and ah,7          ; xor dx,ax ; shl ax,1
ba830  xor dl,ah         ; mov [cf30],dx
```

That is the compact byte-at-a-time form of a **reflected CRC-16-CCITT**, poly
`0x1021` - the algorithm usually called CRC-16/KERMIT.  The transcription
proves itself against that standard's published check value: with a zero seed,
the CRC of `123456789` is `0x2189`.

The seed took solving.  The two pages of a captured sector differ in exactly
two bytes, so if one seed explains both stored words then
`stored ^ crc(page, 0)` has to be equal for the two - and it is, `0x0267`
both times.  Solving that over GF(2) gives **`0x169e`**, and it reproduces
both:

| page | stored | `crc16(page[:0xffe], 0x169e)` |
|---|---|---|
| 0 | `0x7fea` | `0x7fea` |
| 1 | `0x7ef0` | `0x7ef0` |

Seed against xor-out is not separable from this sector alone, because every
page is the same length; `0x0267` xored onto a zero seed fits equally well.

## The record is writable, and the firmware accepts it

Painting every erased byte of a resealed page with its own offset, booting,
and reading `2600:d476` back says where the ISDN block comes from without any
more disassembly: the block reads `b0 b1 b2 ...`, so it is loaded from page
offset **`0x1b0`**, and its 91 bytes end at `0x20a` - immediately before the
`07 00 08 00` at `0x20b` that the original sector already showed.  The block
is copied verbatim.

Setting byte 0 of it to ASCII `4` and resealing is then the whole test:

```sh
.venv/bin/python -m courier_emu isdn-run Ie030002.nac     --instructions 140000000 --line-activate 3000000     --flash-overlay 0xf8000=config-net3.bin     --send AT --send AT --send ATI12 --send-every 30000000
```

```
   Switch Protocol *W   4                     ETSI NET3 (Mu-Law)
   ...
   Physical Interface:  Active
   Data Link Layer   :  Inactive
```

The firmware read a configuration record this repository built, checked its
CRC, loaded it, and named the switch type back.  `courier_emu/imodem_config.py`
is that: `crc16`, `seal`, `read_isdn_block`, `set_switch_protocol`.

## What this opens

The settings the ISDN stack needs - switch protocol, SPIDs, directory numbers,
TEIs - are fields in this record, and the accessor at `c3570` walks them
through a twenty-entry table, validating each: the switch type at `d476` has
to be an ASCII digit `0`-`8` or it stores `ff`, which is the `Invalid Switch
Type` `ATI12` has been printing all along.

### Let the firmware fill it in

Painting offsets works, but there is a better way to map the block and it
needs no reverse engineering at all: **set each field over the AT interface,
let the firmware write its own sector, and diff it.**  `isdn-run` has both
halves already.

```sh
.venv/bin/python -m courier_emu isdn-run Ie030002.nac \
    --instructions 300000000 --send-every 20000000 \
    --flash-overlay 0xf8000=config.bin --flash-save flash-after.bin \
    --send AT --send "AT*M=1" --send "AT*P1=5551000" \
    --send "AT*T1=0" --send "AT&W" --send ATZ --send ATI12
```

`ATI12` reads the result back in the firmware's own words:

```
   Multipoint      *M   1                     Multi-point
   Directory No.   *P1  5551000               ADP Directory Number
   TEI             *T1  00                    Automatic TEI
```

and the sector it wrote differs from the one it started with in exactly the
fields that were set:

| block index | field | command | stored as |
|---:|---|---|---|
| 0 | switch protocol | `*W=n` | ASCII digit `0`-`8` |
| 1 | bus configuration | `*M=n` | ASCII `0` or `1` |
| 44-51 | voice directory number | `*P1=n..n` | ASCII, NUL terminated |
| 86 | voice channel TEI | `*T1=nn` | ASCII, `00` is automatic |
| 87 | data channel TEI | `*T2=nn` | ASCII |

Two things that method settles for free.  The firmware answers
`*ATZ! Required*  :  Settings Have Changed` until a reset, so a session that
changes settings has to end `AT&W`, `ATZ` before the sector is what the next
boot will read.  And a sector the *firmware* wrote verifies against
`page_crc`, which checks the CRC recovered above from the other side - not
just that our seal is accepted, but that we compute the same word the firmware
does.

The remaining fields - dialing mode, the SPIDs, the data directory number -
map exactly the same way; they are not listed above only because a run drops
some commands at the current `--serial-pace`, so each needs a short session of
its own rather than one long one.

`courier_emu/imodem_config.py` carries the offsets that are established.

## The serial number and the MAC address

Both are in the same record, near its front, and the firmware's own printer
names them.  At `cd270`:

```
cd273  mov bx, d2e6 ; lcall a400:8f88 ; call ...   db "MAC ", 0
cd283  mov bx, d2d7 ; lcall a400:8f88 ; call ...   db "Serial Number ", 0
```

so the serial lives at **`2600:d2d7`** and the MAC at **`2600:d2e6`** in RAM,
fifteen bytes and then eight.  In a run both read back as `ff` rather than the
`00` the RAM wipe leaves, which is the tell that they are loaded from the
record and simply unset: an update-written sector has no identity in it,
because a factory-programmed unit already had one.

Painting the sector puts them at page offsets **`0x011`** (15 bytes) and
**`0x020`** (8 bytes), contiguous, ending just before the generation byte at
`0x02e`.  Writing them proves the path:

```python
sector = set_record_bytes(sector, SERIAL_NUMBER, b"IMD0123456789\x00\x00")
sector = set_record_bytes(sector, MAC_ADDRESS,
                          bytes.fromhex("00c04901ab74") + b"\x00\x00")
```

```
2600:d2d7 -> 49 4d 44 30 31 32 33 34 35 36 37 38 39 00 00   "IMD0123456789"
2600:d2e6 -> 00 c0 49 01 ab 74 00 00
```

And `ATI7` prints it back, which is the proof that closes this:

```
Product type            Undefined
Options                V32bis,x2,V.90
Clock Freq             20.16Mhz
Eprom                  768k
Ram                    256k
Supervisor date        07/06/00
DSP date               11/12/99
Supervisor rev         3.0.2
DSP rev                3.0.5
Product ID             992332-01
Serial Number          IMD012345678
```

Worth noting what else that report gained.  With no valid record, `ATI7`
printed neither the dates, nor the product type, nor a serial at all - the
sweep in [imodem-at-interface.md](imodem-at-interface.md) recorded it without
them.  A record the firmware accepts unlocks the rest of its own report, and
`Product type  Undefined` says there is a product-type field in the record
still to be located.

The serial is **twelve** characters, not the fifteen the copied span covers:
thirteen were written and `ATI7` printed twelve.  What the remaining three
bytes before the MAC carry is not established.  The MAC is six raw bytes in an
eight-byte field.  `00:c0:49` is USRobotics' OUI, which is also what the
board's own barcode label carries - so a unit's real identity can be put back
into a sector from the sticker on the board.
