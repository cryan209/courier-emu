# The XMD container: sixteen whole flash images, decoded

`docs/New Folder With Items` holds sixteen `.XMD` files of 524,416 bytes each.
They are not update payloads like the XMF and XMP: `0x80` of header plus a
**complete 512 KiB flash**, boot block and 80186 reset stub included.  Until
now none of them could be read.

## The obfuscation

A chained XOR over 128-byte blocks.  Every byte of a block is XOR'd with one
key byte, and a block's key is the **last plain byte of the block before it**;
the first block's key is `0x55`:

```python
key = 0x55
for each 128-byte block:
    plain = block ^ key
    key = plain[-1]
```

That was tested, not guessed.  `IDSDL302.XMD` and `IDSDL302.ROM` are the same
firmware - one obfuscated, one a board dump - so the per-block key falls out by
XOR, and every candidate rule can be scored against it:

| candidate for block *n*'s key | blocks matched |
|---|---:|
| **last plain byte of block *n*-1** | **199 / 199** |
| last cipher byte of block *n*-1 | 4 / 199 |
| sum of plain block *n*-1 | 2 / 199 |
| previous key + `0x26` | 2 / 199 |
| XOR of cipher block *n*-1 | 1 / 199 |
| sum of cipher block *n*-1 | 0 / 199 |

Decoding `IDSDL302.XMD` that way reproduces the ROM dump in **524,284 of
524,288 bytes**.  The four that differ are inside one 128-byte block at
`0x77f80` - a board's own serialisation beside the distributed image.

`courier_emu/xmd.py` implements it, and `load_image` now recognises the
container.  The decode check is the reset stub: a correct image ends
`fa ba a4 ff b8 00 80 ef ea 21 1a 00 fc` - `cli ; mov dx, ffa4 ; mov ax, 8000 ;
out dx, ax ; jmp far fc00:1a21` - which is what `CourierRom` parses for its
base.

## What is in them

All sixteen decode to images whose reset stub parses, whose supervisor
signature is present, and whose DSP overlay table reads out.  All are **analog
Courier V.Everything**; the overlay sets fall into three shapes:

| images | resident | ov6 | ov7 | ov8 |
|---|---:|---:|---:|---:|
| `IDSDL302`, `SDL0430`, `SDL0430N`, `SV_49` | 27,710 | 11,510 | 7,499 | 7,350 |
| `ID20_401`, `ID20_402`, `ID25_401`, `ID25_402`, and the `28,350`-word `ID20_401`/`ID20_403`/`ID25_403` variants | 28,327 / 28,350 | 11,510 | 7,499 | 7,350 |
| `ID20_403`, `ID25_403` (one build each), `V90XX` | 28,327 / 27,687 | 12,594 | 7,498 | 7,498 |

That third shape is the one the `courier-board-21210-capture-403` dump has, so
the 403 board's DSP set now has distributed images to compare against rather
than only the capture.

## What is not in them

**No I-modem.**  Every XMD is a V.Everything.  The only ISDN Courier firmware
in the tree is `Ie030002`, and its two containers - `Ie030002.nac` and
`Ie030002.xmp` - carry byte-identical payloads (`sha256 0c21e933…`, 753,664
bytes each).  Both are update payloads based at `0x40000`, so neither holds the
boot block or the 386 reset vector, and no amount of running the updater in
[imodem-emulation.md](imodem-emulation.md) will produce one: the updater does
not replace the block it boots from.  A bootable I-modem ROM has to come off a
board.
