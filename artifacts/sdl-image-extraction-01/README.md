# Firmware images out of the SDL upgrade packages

`docs/usrdl/` holds seventeen vendor flash-upgrade packages. Until now they were
archives; this makes the firmware inside them readable, and uses that to settle
what the Sportster Vi DSVD package actually is.

`extract_sdl.py` handles both carriers:

- **`SDL*.EXE`** - the DOS loaders. The image sits in the loader as a run of
  binary download records, sixteen bytes each:
  `[len=0x10] [addr hi] [addr lo] [type=00] [16 data] [checksum]`, the whole
  record summing to zero mod 256. That checksum is what makes the format
  identified rather than guessed: 13,193 consecutive records validate in
  `SDL.EXE`, 18,090 in the V.90 `SDL20.EXE`.
- **`*.XMD`** - the images the modem's own XMODEM loader takes. A 64-byte
  header, then the firmware under a flat **XOR 0x55**.

```bash
python3 artifacts/sdl-image-extraction-01/extract_sdl.py extract SDL.EXE --out /tmp/img
python3 artifacts/sdl-image-extraction-01/extract_sdl.py compare a.img b.img
```

`images.json` records what came out of four packages, with sha256 of each image.
The images themselves are not tracked - they are reconstructible from the
archives, which are.

## What is not established

The record addresses are 16 bits and wrap, so they order records within a
segment but do not place them in a 512 KiB flash. Where the address fails to
advance by 0x10 the tool reports a segment break (17 in the Sportster loader, 27
in the V.90 loader) rather than inventing a mapping. **Nothing here is a
flash-accurate image, and none of it should be fed to the emulator as one.** It
is good for strings and for structure, not for addresses.

The XMD 64-byte header is not decoded. It varies per build around an `NHCFG`
marker; a checksum and a model gate are the obvious candidates, given the
"wrong model will make your unit inoperable" warnings in the packages, but that
is a guess and is not tested.

## The Sportster Vi DSVD is a cut-down Courier

`dsvd-sdl.exe` sits in a directory of Courier upgrades and is labelled a
Sportster. Comparing its image against the international Courier 7666 build
(`comparison.txt`):

- **919 of its 1,184 strings - 77.6% - are shared with the Courier.**
- The **ATI7 field layout is identical**: `Product type`, `Options`,
  `Supervisor date`, `Supervisor rev`, `Clock Freq`, `Fax Options`.
- The Sportster image carries the **product-name table with `Courier` and
  `Sportster` as adjacent entries**, and the literal banner string
  `USRobotics Courier V.32`.
- The **result-code table is the same table in the same order** - `CONNECT`,
  `RING`, `NO CARRIER` ... `9600/ARQ`, `4800`, `7200`, `12000` ... - with the
  HST entries (`9600/HST`, `4800/ARQ/HST`, `12000/ARQ/HST`) deleted from the
  sequence and the DSVD codes appended.

What was removed is the Courier's premium feature set, and only that:

| | Courier 7666 | Sportster Vi |
|---|---|---|
| HST result codes / Dual Standard | present | removed (11 vestigial references remain in shared tables) |
| Dial Security | 3 references | none |
| Remote Access | 8 references | none |
| `CURRENT DIPSWITCH SETTINGS` | present | none |
| `Serial Number` in ATI7 | present | none |
| ASL statistics (Naks, SREJ, Reversals) | present | none |
| Developer credits block | full | stripped |

What was added is the DSVD voice path: `AUDIO date`, `AUDIO rev`,
`Audio Sampling Rate`, `Algorithm Selection`, `Blocking Factor`, and the
`-SMUTE=n` / `-SMUX=n` commands. Even the trellis labels were reworded - the
Courier says `16S-4D trellis code`, the Sportster says `16S-4D map`.

The two are not contemporaneous builds of one tree. The Sportster copyright line
stops at 1993; the Courier 7666 line runs to 1995, though the Sportster package
is dated 12/95. It reads as a 1993 fork of the Courier supervisor, maintained
separately afterwards.

## One thing worth carrying into the emulator

The loaders name their own CPU. `SDL_7666.EXE` (international, 11/95) says
**`INT80188 Modem Functions`**; the V.90 `SDL20.EXE` (03/98) says
**`INT80186 Modem Functions`**. Two different part strings across the Courier
line, which is worth resolving before assuming one bus width across builds.
This is a string, not a measurement - it has not been checked against a board.
