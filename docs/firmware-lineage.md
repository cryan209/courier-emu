# Courier firmware lineage

This is a classification of the firmware assets in this repository, not a
claim that every file is interchangeable.  Clock, CPU, line interface, and
container format are compatibility boundaries.  The evidence column says
whether a conclusion comes from a parsed image, supplied release material, or
a filename only.

## The family tree

```
USR/3Com remote access
├── Analog Courier V.Everything — Intel 80186/80188-class supervisor + TI C5x DSP
│   ├── 20.16 MHz / 512 KiB flash
│   │   ├── stock SDL 3.02: IDSDL302.ROM / IDSDL302.XMD
│   │   └── Russian ID_SDL 4.01–4.03: ID20C* and ID20D*
│   ├── 25 MHz (25.8048 MHz in main211) / 512 KiB or later 736 KiB image
│   │   ├── stock SDL: SV25.XMD, SDL0430*, SV_49.XMD
│   │   └── Russian ID_SDL 4.01–4.03: ID25C* and ID25D*
│   └── later V.92 Courier update series: 3453B/3453C XMF images
├── Courier I-modem / ISDN — Intel 386EX + AMD Am79C30A
│   └── IE/IM releases in NAC or XMP containers, including Ie030002
└── Total Control / NETServer ISP platform
    ├── Network Application Cards: analog/digital modem and PRI/ISDN service code
    └── HiPer ARC/DSP/NMC/MultiSpan DMF firmware
```

The two top-level branches are architectural, not just software revisions:
the analog branch boots an 80186/80188-class supervisor and downloads C5x DSP
programs; the I-modem branch executes 386EX code and initializes the Am79C30A
ISDN front end.  See [the ISDN front-end analysis](imodem-isdn-front-end.md)
for the register-level proof.

## Analog Courier V.Everything

| Subfamily | Images in this tree | Clock / storage | CPU architecture | Region and identity | Evidence / confidence |
| --- | --- | --- | --- | --- | --- |
| Stock 3.02 reference | `IDSDL302.ROM`, `IDSDL302.XMD` | 20.16 MHz, 512 KiB flash | Intel 80186/80188-class + TI C5x family DSP | US/Canada External; supervisor 7.3.14, DSP 3.0.13, dated 1998-03-13 | Direct ROM strings plus two hardware probes; high confidence. |
| ID_SDL 4.01/4.02 | `ID20C401`, `ID20D401`, `ID20D402`; `ID25D401`, `ID25D402` | `ID20` = 20.16 MHz; `ID25` = 25 MHz | Same analog 80186/C5x platform | Russian AON modification, based on the 1998 International SDL; documentation says it supports US/Canada and International hardware but is adapted for Russian/ex-USSR lines | Bundled `FILE_ID.DIZ` and CP866 release notes; high confidence for intended target, not a guarantee of installed country configuration. |
| ID_SDL 4.03 | `ID20C403`, `ID20D403`; `ID25C403`, `ID25D403` | Same `ID20` / `ID25` split | Same analog 80186/C5x platform | Same Russian AON / International base. `D` 4.03 is the verified 20.16 MHz board lineage: supervisor 7.4.16, DSP 3.1.2 | Release notes identify the clock and modification; the 20.16 MHz `D` lineage is additionally verified against the 403 capture. |
| Stock 25 MHz XMDs | `SV25.XMD`, `SDL0430.XMD`, `SDL0430N/SDL0430N.XMD`, `SV_49.XMD` | 25 MHz board family, 512 KiB flash | Same analog 80186/80188-class + C5x family | `SV25` is a probed US/Canada External 25 MHz family image; the country configuration of the other files is not established | `ATI7`/ROM family evidence for `SV25`; XMD overlay decoding for the group. |
| Other analog XMD assets | `SDL1202I/V90XX.XMD`, plus duplicate package copies of `SDL0430.XMD` and `SV_49.XMD` | 512 KiB XMD payload; clock not yet established for `V90XX` | Same analog 80186/80188-class + C5x family | No regional conclusion | The decoded overlay table proves analog V.Everything lineage; it does not prove a clock/region. |
| V.92 XMF series | `3453Bv2.1.1`, `3453Bv2.2.05`, `3453C_v2.3.12`, `.15`, `.31`, `.33` XMF | 25.8048 MHz for `main211`/2.1.1; 736 KiB update image | Same analog 80186/C5x software lineage | Courier V.Everything V.92 update packages; region is not established by their bundled `Firmware.txt` | Parsed XMF layout and timer constant; high for format/clock of main211, unknown region for the series. |

`C` and `D` in the ID_SDL filenames are the release's own 4.01c/4.01d,
4.02d, or 4.03c/4.03d suffixes—not CPU types.  Likewise, `20` and `25` are
explicit clock compatibility labels in the release material, not version
numbers.  Do not cross-flash an `ID20` and `ID25` image.

The physical 20.16 MHz reference board was initially captured on stock 7.3.14
/ DSP 3.0.13 and later ran ID_SDL 4.03d / 7.4.16 / DSP 3.1.2.  That is a
software update within one 20.16 MHz analog hardware lineage; it does not make
the 25 MHz images equivalent.

## I-modem / ISDN line

| Series | In-repository forms | CPU / line hardware | Release lineage | Region |
| --- | --- | --- | --- | --- |
| I-modem | `Ie030002.nac`, `Ie030002.xmp`, and IE/IM archives under `docs/x2/` | Intel 386EX, AMD Am79C30A ISDN controller | IE 1.02.03 (1996), IM 2.00.09 (1996), IM 1.05.01 (1997), IE/IM 2.01.04 (1997), IE 2.02.02 (1997), IE/IM 2.04.05/06 (1998), IE 3.00.02 (2000) | Not established by current evidence. |

`Ie030002.nac` and `Ie030002.xmp` are two encodings of the same 753,664-byte
payload based at physical `0x40000`.  Neither includes the I-modem boot block
or reset vector.  The `.nac` stream is binary Intel-HEX-style records; the
`.xmp` body is XOR-obfuscated with `0x45`.  These files are incompatible with
the analog XMF/XMD update path even though they share Courier branding.

The I-modem feature history is independently documented in
[imodem-firmware-timeline.md](imodem-firmware-timeline.md): x2 appears in
2.01.04 and V.90 in 2.04.05/06.  That timeline is a protocol feature timeline,
not a regional classification.

## Total Control / NETServer: the larger x2-era platform

The `docs/x2/` directory also contains the ISP-side equipment that makes the
I-modem's remote-access role concrete: operational code for NETServer Network
Application Cards (`LE`/`LF`), a PRI NAC image (`DP030105`), a NETServer ISDN
NAC image (`LI030534`), HiPer ARC router firmware, and HiPer DSP/NMC/
MultiSpan card firmware.  This is a product/platform lineage shared with the
I-modem, not a claim that they run the same binary or processor.  The I-modem
is proven 386EX/Am79C30A; the HiPer ARC firmware explicitly names a PowerPC.

See [`docs/x2/README.md`](x2/README.md) for the package-by-package split and
the direct strings linking the server code to I-modem pools, PRI spans, and
B-channels. It also records a byte-level comparison: the I-modem and
inspectable NETServer/PRI images share a Ready Systems VRTX marker, but no
non-trivial identical application-code run of 32 bytes or longer was found.
The server cards explicitly use VRTX32/I386; the I-modem identifies VRTX/86 on
its 386EX.

## Container and payload types

| Type | What it contains | Applicable branch | Handling |
| --- | --- | --- | --- |
| Raw `.ROM` | Complete 512 KiB analog flash image, including boot block | Analog | `courier rom-info`; bootable subject to matching board hardware. |
| `.XMD` | 128-byte SDL header plus an encoded complete 512 KiB analog flash image | Analog | Decode before comparing code/offsets with a ROM. XMD offsets are not flash offsets. |
| `.XMF` | Courier application update with product header, supervisor, and C5x payload; no board boot block | Analog | `courier info` / `extract`; an application update, not a raw flash dump. |
| I-modem `.NAC` | 32-byte header plus binary Intel-HEX-style ISDN update record stream | I-modem / ISDN | `courier nac-info` / `extract`; programs the shared ISDN update payload. |
| `.XMP` | Header plus XOR-obfuscated ISDN update payload | I-modem / ISDN | `courier xmp-info` / `extract`; equivalent decoded payload to the matching NAC. |
| Other `.NAC` payloads | Product-tagged 3Com SDL/NAC card updates, including NetServer and PRI cards; their framing differs from I-modem NAC | Total Control / NETServer; a separate analog DSP component also appears in an SDL package | Do not feed these to `courier nac-info`; classify from package/product tag and content. |

## What remains unknown

- A file's *running country setting* is stored/configured separately from its
  broad product family. “US/Canada External” is proven only for the two probed
  reference units; the Russian ID_SDL packages are explicitly multi-country
  capable but Russian-line oriented.
- `SDL0430*`, `SV_49`, `V90XX`, and the XMF updates have no complete regional
  proof in this tree. They are therefore deliberately not labelled US-only or
  International-only.
- “C5x DSP family” is certain from the instruction set. The specific analog
  board part is more likely C50/LC50 than C52 on the photographed 20.16 MHz
  board; do not generalize that component-level conclusion to every image.
- The 736 KiB XMF sequence is a later 25 MHz-family software lineage, but only
  `main211`'s 25.8048 MHz timing is directly measured in this repository.

For the underlying direct evidence, see
[courier_firmware_analysis.md](../courier_firmware_analysis.md),
[xmd-container.md](xmd-container.md),
[hardware-timebase-and-audio-path.md](hardware-timebase-and-audio-path.md),
and [board-parts.md](board-parts.md).
