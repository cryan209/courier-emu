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
    --instructions 60000000 --send-every 0 \
    --flash-overlay 0xf8000=config.bin --flash-save flash-after.bin \
    --send AT --send "AT*M=1" --send "AT*P1=5551000" \
    --send "AT*T1=0" --send "AT&W" --send ATI12
```

The batch driver waits for the complete final-result line from each command.
`--send-every` is now only a minimum delay, so zero is safe here.  In
particular, it does not send the next line after seeing `OK\r`; it waits for
`OK\r\n`.  Sending in that one-character gap was enough for the UART to count
the next line while the firmware's command task discarded it.

`ATI12` reads the result back in the firmware's own words:

```
   Multipoint      *M   1                     Multi-point
   Directory No.   *P1  5551000               ADP Directory Number
   TEI             *T1  00                    Automatic TEI
```

and the sector it wrote differs from the one it started with only where those
fields were set.  The verified offsets are collected in
[the block map](#the-verified-block-map) below.

Two things that method settles for free.  The firmware answers
`*ATZ! Required*  :  Settings Have Changed` until a reset, so a session that
changes settings uses `AT&W` to persist them and may use `ATZ` to reload them
in the same session.  And a sector the *firmware* wrote verifies against
`page_crc`, which checks the CRC recovered above from the other side - not
just that our seal is accepted, but that we compute the same word the firmware
does.

With command delivery fixed, four erased-NVRAM sessions set exactly one field
before `AT&W`.  Each produced a sealed page, and comparison with the matching
baseline page gave these complete ISDN-block diffs:

```text
AT*S1=11112222  2..10   ff...ff -> 31 31 31 31 32 32 32 32 00
AT*S2=22223333  23..31  ff...ff -> 32 32 32 32 33 33 33 33 00
AT*P2=44445555  65..73  ff...ff -> 34 34 34 34 35 35 35 35 00
AT*O=1           90     ff       -> 31
```

No other byte in the 91-byte block changed in any of those four comparisons.

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
them.  A record the firmware accepts unlocks the rest of its own report.
The product type does not come from this record.  The formatter at `c0be0`
selects it from the hardware-mode byte at `2600:d2c3`: bit 3 is External and
bit 2 is Internal, neither bit is Rackmount, and bit 1 takes priority to select
Undefined.  Bit 0 at `2600:d2c4` independently appends ` MODEM`.  The harness
exposes all combinations through `isdn-run --product-type
undefined|external|internal|rackmount` and `--product-modem` (or
`--no-product-modem`), and defaults to External without the suffix.  The old
Undefined result was the `0x22` left by the incomplete modem-status loopback
probe, not a missing configuration-sector field.

The adjacent ATI7 options formatter reads the capability byte at `2600:e358`.
The harness sets it to `0xe5` after the board probe, enabling every modulation
name present in this image: `HST,V32bis,Terbo,V.FC,V34+,x2,V.90`.  V.90 has no
capability bit in 3.0.2; the formatter appends it unconditionally.

The serial is **twelve** characters, not the fifteen the copied span covers:
thirteen were written and `ATI7` printed twelve.  What the remaining three
bytes before the MAC carry is not established.  The MAC is six raw bytes in an
eight-byte field.  `00:c0:49` is USRobotics' OUI, which is also what the
board's own barcode label carries - so a unit's real identity can be put back
into a sector from the sticker on the board.


## The modem writes its own record: `AT&W`

The recipe on this page starts from a sector dumped off a real unit, and this
repository has never had one - nothing in the tree holds a page the loader
accepts. It does not need one. **`AT&W` makes the firmware build a valid record
itself**, and `--flash-save` captures it:

```sh
.venv/bin/python -m courier_emu isdn-run Ie030002.nac --with-dsp \
  --instructions 170000000 --line-activate 3000000 \
  --send AT --send 'AT*S1=5551212' --send 'AT*P1=5551212' --send 'AT&W' \
  --send-every 28000000 --flash-save flash-after.bin
```

The run reports 3 erases and 10,240 programs, and the saved window holds three
sealed pages - at `0x78000`, `0x7a000` and `0x7b000` - whose ISDN block carries
what was typed (`35 35 35 31 32 31 32` is the `5551212` from `AT*S1=`). Cut the
sector out at `0x78000` and it is the base the rest of this page assumed:

```python
sector = flash[0x78000:0x78000 + 0x2000]
sector = imodem_config.seal(imodem_config.set_switch_protocol(sector, 4))
```

Booted back with `--flash-overlay 0xf8000=`, `ATI12` reports

```
   Switch Protocol *W   4                     ETSI NET3 (Mu-Law)
   Multipoint      *M   0                     Point to point
   Directory No.   *P1  5551212               ADP Directory Number
```

- and the SPID rows correctly disappear, because NET3 uses directory numbers
rather than SPIDs. That is the firmware changing its own display for the switch
type it was given, which is what makes the record credible rather than merely
accepted.

`BUS_CONFIGURATION` (ISDN block index 1) is confirmed the same way: `'0'`
prints `Point to point` and `'1'` prints `Multi-point`.

### Which settings come from where

| shown by ATI12 | settable by AT | from the record |
|---|---|---|
| `*S1`, `*S2` SPID | yes, and `AT&W` persists it | yes |
| `*P1`, `*P2` directory number | yes, persisted | yes |
| `*W` switch protocol | **no** - `AT*W4` answers `Invalid Switch Type` | index 0 |
| `*M` bus configuration | no | index 1 |
| `*T1`, `*T2` fixed TEI | not established | not established |

So a session can bootstrap itself: type what the AT interface accepts, `AT&W`,
save the flash, patch the record-only fields into the saved sector, and boot
with it.

## What this does *not* fix

With all of that in place - switch protocol ETSI NET3, bus configuration set,
directory number set, and the S interface walked to **F7** - the D channel
still reports:

```
{"frames_received": 0, "frames_transmitted": 0, ...}
```

and `ATI12` still ends `Data Link Layer   :  Inactive`.

The modem never sends a single layer-2 frame, so it never asks for a TEI, so
there is nothing for a network peer to answer. **That rules configuration out
as the cause**, which was the leading hypothesis: the settings are now real,
firmware-written, and displayed back correctly, and layer 2 is no closer to
starting.

The D-channel transmit path at `0x71cb0` is never entered, and it has no direct
callers - no far call anywhere in the image targets it, and no near call from
any plausible segment - so it is reached through a pointer. That indirection is
where the next look belongs.

**Every sentence of that paragraph is wrong**, and
[imodem-d-channel-transmit.md](imodem-d-channel-transmit.md) replaces it.
`0x71cb0` is the middle of a function, not an entry; the entry is `0x71c77`
and it has five ordinary far callers; one of them runs; and the transmitter
is entered and then refused by a permission flag that nothing ever sets.


## The verified block map

The isolated writes establish the starts of `*S1`, `*S2`, `*P2`, and `*O`.
Earlier isolated writes establish the other persisted settings.  ATI12's
descriptor table independently names every row's RAM address and establishes
the field boundaries.

It runs from `0xc4570` to `0xc4700`, and each row is `80 83 <label>
<descriptor>`.  A settings row's descriptor is `01 <lo> d4` - the RAM address
`2600:d4<lo>` that row displays.  Subtract the block's own base, `d476`:

| field | page offset | block index | RAM address | width |
|---|---:|---:|---|---:|
| `*W` switch protocol | `0x1b0` | 0 | `d476` | 1 |
| `*M` bus configuration | `0x1b1` | 1 | `d477` | 1 |
| `*S1` voice SPID | `0x1b2` | 2 | `d478` | 21 |
| `*S2` data SPID | `0x1c7` | 23 | `d48d` | 21 |
| `*P1` voice directory number | `0x1dc` | 44 | `d4a2` | 21 |
| `*P2` data directory number | `0x1f1` | 65 | `d4b7` | 21 |
| `*T1` voice TEI | `0x206` | 86 | `d4cc` | 2 |
| `*T2` data TEI | `0x208` | 88 | `d4ce` | 2 |
| `*O` dialing mode | `0x20a` | 90 | `d4d0` | 1 |

The widths are the spacings, and the total is the check on the whole reading:
`1 + 1 + 21 + 21 + 21 + 21 + 2 + 2 + 1 = 91`, which is the length the
checksum at `c4ecb` covers.  A wrong offset anywhere would leave a gap or an
overlap.  `tests/test_bri.py` asserts that tiling.

Only offsets established by a firmware write/readback or by the descriptor
table are included here.  In particular, `*P1` is 21 bytes, and `*T1` and
`*T2` start at 86 and 88; the older 8-byte and 86/87 interpretations were
artifacts of comparing non-isolated runs.

### `*O`, the dialing mode

Its renderer at `0xc3304` is the whole specification in four instructions:

```
c3304  mov bl, [d4d0]
c3308  cmp bl, '0' ; jb  c3312
c330d  cmp bl, '1' ; jbe c3314
c3312  mov bl, '2'              ; anything else
c3316  sub bx, '0' ; shl bx, 1 ; add bx, 0x64b8 ; mov si, cs:[bx]
```

a three-entry table of `En-Bloc mode`, `Overlap Sending mode`, `Invalid
Value`.  So the field is ASCII, `'0'` and `'1'` are the only valid values,
and an unset `0xff` is why `ATI12` has always printed `Invalid Value`.
The isolated `AT*O=1` write puts ASCII `1` at index 90; ATI12 renders that as
`Overlap Sending mode`.

### The bearer capabilities are not in this block

`*V1` (voice bearer: `0` Analog Telephony, `1` ISDN 3.1kHz Telephony) and
`*V2` (data bearer: `0` Auto Detect, `1` V.120, `2` V.110, `3` Modem/Fax
Emulation, `4` Clear Channel, `5` Auto Mode PPP, `6` X.75) are in the
firmware's help page but not in ATI12's table, and the block above is full.
A session that sends `AT*V1=1`, `AT*V2=3` and `AT&W` changes exactly one byte
of the record, at **page offset `0x25f`**, from `00` to `0x10`.  Which of the
two wrote it, and how the value is packed, is not established.

### `AT*V1` is refused, and it is not the interface going deaf

An earlier revision of this page claimed the AT interface answers `NO
CARRIER` to everything past roughly 40,000,000 instructions into a run.
**That was wrong**, and the way it was wrong is worth keeping, because it is
the ordinary trap of reading a response as belonging to the command before
it.  Sent on its own at 65,000,000, `ATI12` prints its whole report.

What actually happens is per-command, and one run separates it cleanly:

```sh
.venv/bin/python -m courier_emu isdn-run Ie030002.nac \
    --instructions 120000000 --line-activate 3000000 \
    --send ATI12 --send 'AT*V1=1' --send ATI12 \
    --send-after 30000000 --send-every 30000000
```

```
30000128  sent ATI12       31855616  the full report
60000256  sent AT*V1=1     60425216  NO CARRIER
90000384  sent ATI12       91871232  the full report
```

So `AT*V1=1` is **refused**, with `NO CARRIER` as its own answer, and the
interface is untouched either side of it.  Why that command is refused is not
established; `*V1` is in the firmware's help page and `*V2` appears to be
accepted, since a session sending both changes the byte at `0x25f`.
