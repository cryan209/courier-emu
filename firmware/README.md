# Firmware catalogue

This directory is the entry point for firmware assets.  It intentionally does
not duplicate every image: established source-family locations under `docs/`
remain where they were found and are listed below.  The only relocated asset
set is the previously generic `docs/New Folder With Items/`, now
`firmware/legacy-usrobotics/`.

For compatibility before experimenting or flashing, read the evidence-backed
[firmware lineage map](../docs/firmware-lineage.md). It separates 20.16 MHz
and 25 MHz analog images from the incompatible 386EX I-modem/ISDN family and
marks regional classifications that remain unproven.

## Primary Courier images (kept in `docs/`)

These are the six 736 KiB XMF supervisor/DSP containers used by the emulator.
Each directory retains its companion `Firmware.txt` and its original ZIP.

| Version | Extracted image | Original archive |
| --- | --- | --- |
| 2.1.1 | `docs/3453Bv2.1.1/3453Bv2.1.1.xmf` | `docs/3453Bv2.1.1.zip` |
| 2.2.05 | `docs/3453Bv2.2.05/main2205.XMF` | `docs/3453Bv2.2.05.zip` |
| 2.3.12 | `docs/3453C_v2.3.12/MAIN_2.3.12.XMF` | `docs/3453C_v2.3.12.zip` |
| 2.3.15 | `docs/3453C_v2.3.15/MAIN_2.3.15.XMF` | `docs/3453C_v2.3.15.zip` |
| 2.3.31 | `docs/3453C_v2.3.31/MAIN_2.3.31.XMF` | `docs/3453C_v2.3.31.zip` |
| 2.3.33 | `docs/3453C_v2.3.33/2_3_33.XMF` | `docs/3453C_v2.3.33.zip` |

The XMF payloads are ignored by Git because they are redistributable binary
inputs; the small provenance files and archives remain tracked.

## Active local inputs (kept at repository root)

The emulator's convenient working-copy inputs deliberately remain at the root:
`3453Bv2.1.1.xmf`/`main211.xmf`, `main2205.XMF`, `MAIN_2.3.12.XMF`,
`MAIN_2.3.15.XMF`, `MAIN_2.3.31.XMF`, and `2_3_33.XMF`; plus
`IDSDL302.ROM`, `IDSDL302.XMD`, `SDL0430.XMD`, `SV_49.XMD`, `SV25.XMD`,
`Ie030002.nac`, and `Ie030002.xmp`.  They are ignored local binary inputs.
Several duplicate the catalogued source copies, but they are intentionally kept
where command-line experiments and ad-hoc analysis expect them.

## Legacy USRobotics collection (relocated here)

`legacy-usrobotics/` is an imported collection of firmware updaters, their
expanded payloads, and supporting installers.  Package archives stay next to
their extracted directories so provenance is preserved.

| Family | Firmware payloads | Notes |
| --- | --- | --- |
| ID_SDL 3.02 | `IDSDL302.XMD`, `IDSDL302.ROM`, `idsdl302/IDSDL302.ROM` | The two ROM files are byte-identical; SHA-256 `49f4182c…f2ccc5`. |
| ID_SDL 4.01–4.03 | `ID20C401`, `ID20C403`, `ID20D401`–`ID20D403`, `ID25C403`, `ID25D401`–`ID25D403` `.XMD` files | Each has an adjacent extracted updater directory and/or ZIP. |
| Sportster/V.90 SDL | `SDL0430N/SDL0430N.XMD`, `SDL0430X/SDL0430.XMD`, `SDL0430X 2/SDL0430.XMD`, `SDL_V90 2/SV_49.XMD`, `SV_49.XMD`, `SDL1202I/V90XX.XMD` | The two SDL0430X payloads and the two SV_49 payloads are duplicate pairs. |
| Other modem images | `2332-sdl302/Ie030002.nac`, `2332-x302*/Ie030002.xmp`, `1.00.015.dlf`, `v1_00_20120820.hex`, `v1_17_20140619.hex` | Keep the matching ZIP/RAR/EXE updater packages with these files. |

There are 16 `.XMD` payload files in this collection.  See
[`docs/xmd-container.md`](../docs/xmd-container.md) for its container format,
and use the paths above rather than the old generic import directory.

## Other established firmware archives (kept in `docs/`)

- `docs/usrdl/` — USRobotics download/update packages (12 MB).
- `docs/x2/` — x2, V.90, HiPer DSP/NMC, and NETServer-era packages (209 MB).
  This is a mixed I-modem and Total Control/NETServer collection; see
  [`docs/x2/README.md`](../docs/x2/README.md) before treating packages as
  interchangeable.
- `docs/pm/` — PM modem firmware revisions (`pm3_3.5`, `pm3_3.8`,
  `pm3_3.9`, and `pm3_3.9b9`).
- `docs/494-01.zip`, `docs/5436-files.zip`, `docs/MODEM.RAR`, and
  `docs/R54548.EXE` — standalone archived firmware/update material whose
  original names are retained until their hardware provenance is identified.

Do not treat PDFs, INF files, installers, or extracted application files as
directly executable modem firmware. They remain with their source package as
context and may contain the actual payload in an embedded archive or updater.

The two `artifacts/courier-board-21210-capture-*/courier-board.rom` files are
hardware captures, not distributable source firmware. They remain with the
experiments that produced them rather than being moved into this inventory.
