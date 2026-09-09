# `x2/` collection: product families

This directory is a historical download collection, not one firmware family.
Its name reflects the x2 era, but it contains both retail/remote I-modem code
and the much larger USR/3Com ISP access-platform stack.

## I-modem updates

`ie*` and `im*` packages are the Courier I-modem line:

- `IE010203`, `IE020104`, `IE020202`, `IE020405`, `IE020706`
- `IM010501`, `IM020009`, `IM020104`, `IM020406`

Their archives contain matching `.NAC`, `.XMP`, and `.SDL` update forms and
the I-modem-specific installer material.  They are the releases documented in
[the I-modem timeline](../imodem-firmware-timeline.md).  `Ie030002` elsewhere
in the repository is the same product family.

## Total Control / NetServer access platform

In this section **NAC means Network Application Card**: a service card in the
Total Control/NETServer chassis.  The chassis uses NACs for analog/digital
modem resources and for network/ISDN/PRI service roles.  A `.NAC` file is that
card's operational-code download, not a generic synonym for an I-modem image
or an ISDN container.

### NAC execution architecture

The inspected NETServer NAC operational images (`LE`, `LF`, `DP`, and `LI`)
are **IA-32 / 80386-class firmware**.  They boot through a small 16-bit x86
reset path, then use 386 operand- and address-size prefixes (`0x66`/`0x67`) to
enter their larger application.  `LE` and `DP` identify their runtime as
`VRTX32` with `RTSCOPE I386` diagnostic support, including `CR0` and `CS:EIP`
state.  LI shares byte-identical bootstrap/runtime code with LE, establishing
the same architecture even where LI's own strings are sparse.

This proves a 386-compatible execution environment, not an exact CPU model.
The current evidence does not distinguish a discrete 386 from a 486-compatible
gateway implementation.  It is distinct from the **individual I-modem**,
which identifies an Intel 386EX and `VRTX/86`; both belong to x86/VRTX
heritage, but should not be treated as one firmware binary.

The later Quad x2 modem NACs are a separate, much closer hardware branch:
`QF060003.NAC` and `QR060103.NAC` explicitly identify **`INT80186 Modem
Functions`** and **`320C50 DSP Funct`**, as well as DSP date/revision fields
and x2/V.90 negotiation/result tables. They are binary-Intel-HEX update
streams with a 32-byte header and paint a sparse image from physical `0x80000`
to `0xfbff0`, the same top-of-8086-address-space flash arrangement as the
analog Courier. Their 3.23–3.39 C5x call-opcode pairs/KiB are even denser than
the individual I-modem update (1.68/KiB). This is direct evidence that these
are the shared 80186 + C50 per-channel firmware for a Quad x2 Modem NAC, not
the 386/VRTX controller applications represented by LE/LF/DP/LI.

The currently recoverable raw C50 payload ranges are approximately
`0xc49b0..0xdf910` in QF 6.0.3 (110,432 bytes / 55,216 words) and
`0xc2230..0xdb7e0` in QR 6.1.3 (103,856 bytes / 51,928 words). Both begin with
plausible little-endian C50 initialization instructions (`bc00`, `ae57`,
`ffff`, ...), not a compression signature. They may contain resident code and
overlays, but their internal image-table/overlay boundaries have not yet been
recovered; calling either entire range a single DSP image would be premature.

One boundary is now direct rather than inferred. The 80186 boot path calls the
DSP downloader with entry word `0x8000`, source offset zero, and end offsets
`0xf450` (QF) / `0xfa58` (QR). Thus the resident banks are
`0xc49b0..0xd3e00` (31,272 words) and `0xc2230..0xd1c88` (32,044 words),
respectively. The remaining 23,944 (QF) / 19,884 (QR) C50 words are an
**C50 overlay store** (hardware context confirmed). They begin with valid C50
control/data code rather than a packed-stream header. Each Quad image has
exactly one direct call to its 80186-to-C50 downloader—the resident boot
load above—and no Courier-style x86 overlay table, alternate downloader call,
or source-segment reference to the tail. The table to recover is therefore
the Quad platform's different selection mechanism, likely reached through
C50-side table reads; its individual source/destination records are not yet
decoded.

### I-modem boot-ROM hypothesis

The common x86/VRTX background makes a shared *design* ancestry plausible, but
the available NETServer NAC files do not contain a demonstrated copy of the
missing I-modem boot ROM.  The decoded `Ie030002` update payload is explicitly
an update image: its NAC records load a 0xB8000-byte image at physical
`0x40000`, and it contains neither the I-modem reset vector nor its boot block.
The NETServer release notes likewise describe their NAC files as **operational
code**: that code detects the SDL sequence, transfers control to a loader, and
CRC-checks itself at NAC power-up.

LE/LI/DP do contain their own 16-bit x86 bootstrap followed by 386 protected
mode setup, but exact comparison with the decoded I-modem image finds no
non-trivial common boot/application run.  The appropriate conclusion is that
both products carry updateable operational code plus a separate loader/boot
layer; the server NAC bootstrap is a candidate for studying the *style* of that
layer, not evidence that it is the I-modem's absent ROM.  Recovering an
I-modem flash/boot-ROM dump remains the decisive next artifact.

The following are server/chassis-card firmware, not standalone Courier
firmware:

| Package family | Direct content evidence | Classification |
| --- | --- | --- |
| `le*`, `led*`, `lew*`, `lf*` | Their `.NAC` payloads identify themselves as `Total Control (tm) NETServer Card`; strings cover modem slots, PPP/SLIP, PRI, and a NETServer console. | Operational code for NETServer Network Application Cards. |
| `dp030105` | Its `.NAC` strings include PRI span/D-channel handling and explicitly reserve analog and I-modem resources by B-channel. | Operational code for the PRI/digital-access NAC in the same chassis. |
| `qf060003`, `qr060103` | Their NACs name `INT80186 Modem Functions`, `320C50 DSP Funct`, DSP revision fields, x2/V.90 negotiation, and modem result codes. | **Quad x2 Modem NAC** per-channel 80186/C50 firmware; the strongest match for the photographed four-modem board. |
| `li030534` | The bundled `NS3534C.PDF` identifies `LI` as the **NETServer ISDN Card** SDL/NAC prefix. The release requires an EPB gateway card plus a Munich daughtercard to offer ISDN service. | Operational code for the NETServer ISDN NAC, release 3.5.34. |
| `ne*` / `ne040172-7.dmf` | Identifies itself as HiPer ARC and a `RISC NETServer`; code strings name a PowerPC processor, NETServer V.34, and NETServer V.34 with ISDN. | HiPer Access Router / RISC NETServer firmware. |
| `hd*`, `he*`, `hh*`, `hm*` `.dmf` files and named HiPer archives | Archive names identify HiPer DSP, E1/PRI DSP, NMC, and ARC cards. The NMC image enumerates `3COM ISDN NETServer NAC`, `3COM DSP Multi Span NAC`, and `3COM HiPer ARC NAC`. | HiPer/Total Control component firmware. |

`tcm*`, `harm*`, `netserver-manager-*`, and `3Com Software.zip` are
management/installation suites, not card payloads themselves.  They belong
with this family as the host-side tooling for Total Control and HiPer systems.

## What is shared with the I-modem line

The relationship is real but should be stated precisely:

1. Both are USR/3Com remote-access products from the x2/V.90 era.
2. Both use the SDL/NAC distribution ecosystem.  This is not a single file
   format: I-modem NAC streams parse as the 32-byte-header, binary-Intel-HEX
   form described in `imodem-firmware-timeline.md`; the NetServer `LE`/`LF`/`DP`
   NACs have different record framing and product tags, so the I-modem decoder
   correctly rejects them.
3. The server images directly understand I-modem resources.  `DP030105.NAC`
   contains messages for I-modem pools, PRI spans, D-channels, and B-channels;
   the HiPer ARC names both V.34 and ISDN NETServer configurations.
4. The hardware/software architectures are not proven identical.  The
    I-modem payload is established as 386EX + Am79C30A; HiPer ARC explicitly
    names PowerPC.  A shared product/platform lineage must not be mistaken for
    a shared CPU binary.

The server-card NACs tested here are **not compressed at their outer payload
layer**.  After their 32-byte product headers, `LE030011.NAC`, `DP030105.NAC`,
and `LI030534.NAC` start with an x86 short jump (`EB 49` or `EB 52`) and retain
readable executable strings throughout.  Their body entropy (6.43–6.92 bits
per byte) is consistent with ordinary code/data, not an opaque packed stream.
The `.DMF` HiPer packages are a separate matter; the ARC ones demonstrably
contain bzip2-compressed inner images, described below.

## DMF card images

DMF is a 3Com component-download wrapper, not one executable format.  Every
sample has a human-readable product/version preamble and a binary `\x1a\x01DMF`
header, followed by one or more component images.

| DMF family | Target and contents established from the image |
| --- | --- |
| `ne040172-7`, `ne050302`, `ne050303`, `ne0503107` | **HiPer ARC / RISC NETServer** router-card update. Version 5.3 images contain multiple `BZh` bzip2 streams. Decompressing them yields two ~0.78 MiB PowerPC boot/runtime chunks, a ~7.6 MiB PowerPC **Pilgrim Router Core**, and ~0.4 MiB SDL/update resources (`sdloader.dmi`, string indexes, flash-update messages). The code is big-endian PowerPC, independently confirming it cannot be I-modem x86 code. |
| `hd305103`, `hd305105`, `hd030512` | **HDM T1 / HiPer DSP** system-image updates. The preamble says `HDM T1 RELEASE DMF FILE FOR DOWNLOAD`; visible updater code names flash, DRAM, `hdmsys.dmi`, and a system-image download. Its internal image layout has not been decoded. |
| `he030513` | **HDM E1** counterpart of the T1 DSP image; same flash/DRAM updater vocabulary and `hdmsys.dmi` naming. |
| `jt030512` | **HiPerDSP II T1/PRI (MultiSpan)** update. It contains the `RISC NETSERVER SDL-2 Downloader` and `sdlldr.dmi`; exact card runtime is not yet separated from its transport loader. |
| `hm080603`, `hh080703` | **NMC system-image** updates. Their preamble says NMC download/system image and their strings cover flash burning, shared memory, and the inventory of NETServer, ISDN NETServer, DSP MultiSpan, and HiPer cards. |

The ARC result explains the earlier ambiguity: a raw `strings` scan can see
loader strings but not most of the router core because it is bzip2-packed.  In
contrast, the older NETServer/PRI NACs are directly readable x86 applications.

## Direct I-modem/server code comparison

There is **shared operating-system provenance, but no demonstrated shared
application code** in the inspectable images.  The decoded `Ie030002.XMP`
payload was compared byte-for-byte with the raw `LE030011`, `LE030303`,
`LF030015`, `DP030105`, and `LI030534` server-card NAC payloads using exact
16-, 32-, and 64-byte windows.

Every meaningful common run was either padding, the 33-byte printable ASCII
table, or this common VRTX marker (preceded by NOP padding):

```
Copyright 1988, Ready Systems
```

The server payloads and the I-modem therefore both carry a Ready Systems VRTX
component.  The server images explicitly say `VRTX32` and `RTSCOPE I386`; the
I-modem says `VRTX/86 Task Status Inquiry` and `INT80386EX ... Functions`.
That is a close architectural relationship—same RTOS family on x86, but not
necessarily the same VRTX version or binary. No non-trivial identical
machine-code run of 32 bytes or longer was found.  This is evidence of a common
RTOS/toolchain heritage, not evidence that a NETServer/PRI application was
copied into the I-modem.

### Shared strings and call-control vocabulary

The string comparison has one meaningful result beyond the VRTX banner:
`Ie030002` and `DP030105.NAC` both carry the ISDN/Q.931-style labels
`SETUP_ACK` and `PROGRESS_IND`. The I-modem has messages such as
`PROGRESS_IND Detected` and `SETUP not compatible`; the PRI NAC has the larger
controller-side vocabulary: `USR_SETUP_REQ`, `USR_MDM_SETUP_REQ`,
`uccm_bld_usr_I_mdm_setup_con_req`, `uccm_bld_usr_progress_ind`, and explicit
I-modem/analog resource-pool assignment and B-/D-channel routing messages.

This is strong integration evidence: the PRI NAC knows how to build and route
setup/progress messages *to* an I-modem resource. It is not a shared binary
routine—the longer symbol names and surrounding code differ—but it pinpoints
the protocol boundary where the server controller and I-modem meet. Other
shared strings (`Access Denied`, `Configuration`, `Compression`, `Xon/Xoff`,
and hexadecimal character tables) are generic management/runtime vocabulary
and carry much less lineage weight.

### Does a server NAC package modem CPU/DSP firmware?

That is a sensible hardware hypothesis, but the shipped NAC files do **not**
currently support it.  I compared all 16 decoded Courier `.XMD` flash images
(the 80186/C5x analog family) against `LE030011`, `LF030015`, `LI030534`, and
`DP030105` with exact 32-byte windows, extending every collision in both
directions.  There is no non-padding, code-like shared run: the longest
collisions are short low-entropy fill/table material (at most 63 bytes), not
an embedded Courier supervisor or C5x program.

The same discriminator used for the Courier DSP is negative in every server
NAC: byte-pairs for its frequent C5x `call`/`b` encodings occur only
`0.005–0.074` and `0.013–0.054` times per KiB respectively, versus `1.68` and
`0.59` per KiB in `Ie030002`.  `LE`, `LF`, and `DP` have no high-entropy
compressed-payload-sized region; they look like one linked i386/VRTX program
plus data.  `LI` does have an opaque, high-entropy tail around `0x0e0000`, but
it has neither a recognizable compressor header nor Courier-like C5x density,
so it cannot presently be identified as a modem image.

The conservative model is therefore: a NAC file is the **card controller's**
i386/VRTX firmware, which configures and dispatches modem resources over the
backplane.  The physical modem engines may indeed be separate Intel/DSP pairs
on the board, but their firmware is either mask/flash-resident on those
engines, delivered by another card-specific package, or encoded in a form not
yet recognized here.  It is not recoverable from these NAC images by simply
splitting out an obvious Courier-style blob.

This was followed up across all available Ethernet NAC revisions
(`LE030011`, `.15`, `.22`, `LE030107`, `LE030206`, and `LE030303`): none has a
standard bzip2/gzip/zip/7z/LZMA stream, a high-entropy payload plateau, or
strings that describe loading/programming modem or DSP firmware.  The word
“compression” in those images is PPP/IP header-compression configuration, not
an image unpacker.  Conversely, `DP030105` explicitly names a **Quad Modem
NAC** as a separately inserted/removable resource (`Change DS0 state on Quad
Modem NAC action`, `uccidm_get_avail_quad_I_mdm`).  That is the stronger lead:
the pictured four-modem card's shared engine image belongs in a *Quad Modem
NAC* package rather than in the Ethernet or PRI controller NACs.

The NMC system-image packages establish that this is not a speculative card
name. Both newer NMC builds list **`3COM Quad X2 Modem NAC`** in their card
inventory, beside the earlier Quad V.32/V.34 analog, digital, and
digital-analog NAC variants. They are nevertheless NMC system-image updates
(`nmcsys.dmi`), not bundles of those card images: each has only its own DMF
container header and no nested NAC/DMF image. The older standalone
`NM040103.NAC` supplies the same Quad-modem inventory for the pre-x2 family.
The subsequently recovered `QF060003.NAC` and `QR060103.NAC` are that
dedicated Quad x2 download; their direct 80186/C50 and x2/V.90 strings confirm
the inference.

`DP030105.NAC` makes the chassis arrangement explicit.  It identifies itself
as a **Dual T1 PRI Application Card** and carries messages for reserving analog
and I-modem NAC resources from pools, then routing incoming DS0s to PRI
B-channels and D-channels.  This supports the model of a controller/service
card managing a farm of modem/I-modem resources; it does not show that the
individual I-modem firmware itself was embedded in the PRI card image.

`LI030534.NAC` is the companion NETServer ISDN Network Application Card image,
not an individual I-modem update.  It comes with `LI030421.SDL`, a small x86
download loader, and `NS3534C.PDF` (NETServer Card 3.5 maintenance release notes).
Those release notes map prefix `LI` to **NETServer ISDN Card** and identify the
3.5.34 release's EPB gateway/Munich-daughtercard hardware.

LI shares substantial bytes with the NETServer Ethernet (`LE`) images: exact
matches include 319–320-byte x86 initialization code, a 649-byte runtime code
run in the closest 3.5 build, and several multi-kilobyte shared data/runtime
regions.  That is direct binary evidence that LI and LE are sibling NETServer
applications built on a common server-card base.  It still does not create a
matching application-code run against the individual I-modem image; the
I-modem relationship remains shared x86/VRTX platform and system integration.

That test is intentionally bounded: HiPer `.DMF` files are card-specific
download packages whose inner payloads were not decoded for this comparison,
and a revised VRTX build can share source lineage while having no long
byte-identical region.  The currently supported conclusion is “shared VRTX,
different application images,” not “no source was ever shared.”

This gives a useful hierarchy:

```
USR/3Com remote access
├── I-modem (individual ISDN access modem)
└── Total Control / NETServer (ISP chassis)
    ├── NETServer and PRI/ISDN access cards
    └── HiPer ARC, DSP, NMC, and MultiSpan cards
```

The `x2shoot4.pdf` guide ties these together operationally: it names I-modem,
NETServer I-modem, and Total Control Enterprise Network Hub as x2 server-side
endpoints, requiring a digital T1/PRI/BRI-side path.
