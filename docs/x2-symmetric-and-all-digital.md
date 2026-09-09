# x2 Symmetric and V.90 All-Digital: where 64000 comes from

The Courier's result-code table carries `64000`, `64000/ARQ`, `64000/x2`,
`64000/ARQ/x2` and `64000/V90`, `64000/ARQ/V90` in every image from 2.1.1
through 2.3.33 ([pcm-x2-v90.md](pcm-x2-v90.md)).  64000 is not an analog PCM
rate - the client can never train to it over a subscriber loop - and the
supervisor cannot ask for it either: the rate mask at `8fc9` is 15 bits over
the x2 ladder's 15 analog rates (33333 … 57333), and 64000 sits outside it.
It is the rate of a **digital-to-digital** connection, and the mode that
reaches it is not in this firmware.  It is in the server.

## The server has three x2 roles, not two

The Total Control HDM MIB (`TCM/BIN/SNMPMIBS/ALLMIBS/HDM.MIB` in
`docs/x2/tcmw551.zip`) and the Network Management Card's object table
(`docs/x2/3Com Software.zip`) give the x2 mode bits as S76:

| bit | object | help text |
|---|---|---|
| S76.0 | `hdmScX2DisableClient` | "The modem can receive information at x2 speeds." |
| S76.1 | `hdmScX2DisableServer` | "The modem can distribute information at x2 speeds." |
| **S76.2** | `hdmScX2DIsableSymmetric` / `mdmScX2Symmetric` | **"requires both the server and client modem to send and receive information at the same x2 speed"** |
| S76.3 | - | x2 fallback to V.34 |
| S76.7 | `hdmScHighPowerConst` | x2 high-power constellation, legal only in some countries |

So **x2 Symmetric is real, it is a distinct third x2 role, and it is a server
S-register bit (S76.2), enabled by default.**  It is PCM in *both* directions
at the same rate - up to the 64000 the speed enums carry - which is only
reachable when neither end has an analog local loop.

## V.90 has the same three, and names them

The same MIB continues at S81:

| object | S-bit | description in the MIB |
|---|---|---|
| `hdmScV90Analogue` | S81.4 | "the V.90 client (**APCM**) modulation" |
| `hdmScV90Digital` | S81.5 | "the V.90 server (**DPCM**) modulation" |
| `hdmScV90AllDigital` | **S81.6** | "the V.90 **symmetric** modulation (**DDPCM**)" |

The NMC table labels the last one "V.90 All Digital Mode (S81.6)".  So the
user's hunch is right on both counts: x2's symmetric mode and V.90's
all-digital mode are the same idea, and USR shipped both as server options
with their own S-register bits.

## The RADIUS dictionary counts them as separate modulations

`dictnary` in `docs/x2/ne050303.zip` (NETServer) reports the trained
modulation per call:

```
x2                23      v90Analogue     33
x2client          29      v90Digital      34
x2symmetric       30      v90AllDigital   35
piafs             31      v92             36
```

and `Initial-Connect-Speed` value 39 is `64000-BPS`.  The HiPer ARC MIB keeps
a per-rate call counter `usrCipSpeedStatisticsSpeed64000`, "the number of
calls with speed of 64000" - a rate that would never increment if 64000 were
only a string.

## Where V.91 fits

ITU-T **V.91** (approved May 1999, still in force) is
"a digital modem operating at data signalling rates of up to 64 000 bit/s for
use on a 4-wire circuit switched connection and on leased point-to-point
4-wire digital circuits".  That is the standardised form of the same
symmetric-64k idea, but it is a *4-wire / leased-circuit* recommendation, not
a mode of V.90 - V.90 itself defines only the analog client and digital
server halves.  DDPCM as USR shipped it is a vendor extension over the V.90
PCM machinery, not V.91, and the name V.91 appears nowhere in this firmware
or in any of the server archives.

## What this means for the Courier

Nothing in the client image implements either mode:

* `symmetric`, `all digital`, `DDPCM` and `V.91` appear in **no** Courier
  image (2.1.1, 2.2.05, 2.3.12/15/31/33, IDSDL302).
* The Courier's PCM option register is S58 - bit 1 x2, bit 32 V.90
  ([pcm-x2-v90.md](pcm-x2-v90.md)) - and it has no S76.2 or S81.6 equivalent.
  Its x2 setup builds one capability word and sends it as tag `70`; there is
  no second, digital-side capability path.
* The 64000 result codes are there because the **result-code table is shared
  across the product line**, not because a V.Everything can reach 64000.  A
  Courier on an analog loop cannot: it has a DAA and a codec, which is the one
  analog conversion the rate forbids.

The emulator should therefore keep 64000 as a reportable code and out of the
negotiable rate mask, which is what the firmware itself does.

## The server is not the same machine

Nothing on the server side shares the Courier's silicon. Measured over the
archives in `docs/x2/`, counting the C5x `call`/`b` encodings (`80 7a`,
`80 79`) that saturate the Courier's DSP images:

| image | `call` /KB | `b` /KB | what it is |
|---|---:|---:|---|
| `MAIN_2.3.31.XMF` (Courier) | 1.82 | 0.62 | 80C186EB supervisor + TI C5x DSP |
| `Ie030002.nac` (ISDN Courier) | 1.64 | 0.57 | same pair |
| `LE030303.NAC` (NETServer) | 0.01 | 0.02 | i386 + Ready Systems VRTX |
| `DP030105.NAC` (Dual T1/PRI) | 0.07 | 0.05 | i386 (`RTSCOPE I386`) + VRTX |
| `hd030512.dmf` (HiPer DSP) | 0.02 | 0.02 | PPC403, payload compressed |

The NETServer and T1/PRI NACs are Livingston-lineage i386 boards - they still
carry `Copyright 1989…1992 Livingston Enterprises` beside the USR notice - and
carry no datapump at all.  The HiPer DSP card is a PowerPC: its `.dmf` opens
with a PPC prologue (`9421 fff0 / 7c08 02a6 / 93e1 000c`), and its own release
notes print `!!-----> SDL2 for the PPC403 <-------!!` at the download prompt
and list the four images as "Boot Block, Board Manager, ACP, and DSP".  Only
the first of those is readable here; the rest of the `.dmf` is compressed at
7.94 bits/byte, so the modem DSP's instruction set is not determined by these
archives.

What *is* shared is the supervisor lineage above the DSP.  The HDM MIB's speed
enum is the Courier's result-code table in the same order:

```
18 bps33333 … 32 bps57333, 33 bps64000,          <- the x2 block, 15 rates + 64000
34 bps28000 35 bps29333 36 bps30666 37 bps32000
38 bps34666 39 bps36000 40 bps38666 41 bps40000
42 bps58666 43 bps60000 44 bps61333 45 bps62666  <- exactly the V.90-only additions
```

That is the same partition the Courier's flash uses - x2 codes first, the
V.90-only rates appended in that order - and the same 15 analog x2 rates the
mask at `8fc9` covers.  The rate tables and the S-register/AT surface are
common; the processor and the datapump underneath them are not.

## The Courier I-modem is one of the server modems

The vendor documentation in `docs/` names it directly.  The Quad Modem
product reference (`24186500.PDF`, "Server Modems") lists the server side of
x2 as:

> Server modems send data to analog x2 client modems at speeds up to 56K.
> The following modems are examples of server modems: **Courier I-modem**,
> HiPer DSP, Quad Modem, MP I-modem.

and adds, of the Quad, "The Quad Modem does not support client mode" - these
are server-role products, not clients with a server option.  The 1997
NETServer x2 release notes say the same, and give the physical requirement:
the host end must be digital - "a channelized T1, ISDN PRI, or ISDN BRI" - and
trunk-side, with "ISDN PRI and BRI lines automatically trunk-side".  A Courier
I-modem is a BRI device, so it *is* the digital end of the call.

The HiPer DSP reference (`24187300.PDF`) gives S76 in full, as disable bits:

| S76 bit | value | disables |
|---:|---:|---|
| 0 | 1 | Client mode |
| 1 | 2 | Server mode |
| 2 | 4 | Symmetric mode |
| 3 | 8 | x2/V.90 fallback to V.34 |

and its `incompatibleX2modes` diagnostic states the pairing rule outright:
"Either one modem must be a server and the other a client, **or both must be
symmetric**."  So symmetric is a third role both ends run, not a client or a
server variant - which is why it needs its own bit and its own
`x2symmetric` modulation code in the RADIUS dictionary.

One correction to the section above, and a correction to that correction.
The HiPer DSP text for `excessiveHFAttenuation` reads: "Some portion of the
channeling is analog for x2 symmetric and V.90 all-digital modes."  That is
not saying the data path is partly analog.  It is the **negotiation** that is
analog-domain: V.8 call indicate and menu exchange, then the INFO0/INFO1A
sequences, are audio-band signals carried through the channel before either
end switches to PCM.  Symmetric and all-digital modes still run that dance, so
high-frequency attenuation on the path can still kill the connection even when
both ends are digitally attached - which is exactly what that diagnostic is
for.

The image agrees.  The 403 carries a whole analog-negotiation report block at
`49f39`, distinct from anything in the analog builds:

```
49f39  Remote X2/V90 INFO0 is:
49f6b  Remote VFC/V34 INFO0 is :
49f9a  Main V34/X2/V90 INFO0 is:
49fc8  INFO0 is absent
49fde  V.8 octets Main  :
4a00a  V.8 octets Remote:
```

Both sides' V.8 octets, and INFO0 split by scheme - and
`courier_emu.datapumps.v90_info1a_writer` finds the routine that builds INFO1A.
So the digital end of an x2 call is running the same audio-band V.8/INFO
opening as the analog end; it is the data phase that differs.

The claim to keep from the section above is the narrower one: 64000 is the
digital-side rate, and the analog **client** Courier cannot reach it because
its own DAA and codec are an analog conversion.

### The I-modem image says it in its own help text

`Ie030002.nac` - the one image in this tree that identifies itself as
`I-Modem` - replaces S58 outright.  Its help block reads:

```
S58 x2 Mode and Remote Server Xmit
   1   x2
   2   server mode
   4   Force x2 A-law mode
   8   symmetric mode
  16   -6dbm constellation
  32   V.90
```

against the analog Courier's S58, which is `1 x2`, `2 BLER monitor`,
`32 V.90`, with bits 4, 8, 16, 64 and 128 present but with their text blanked.
So on the I-modem the same register carries **server mode** and **symmetric
mode** as named bits - and there is no client-mode bit at all, matching the
Quad Modem manual's "does not support client mode" for the server-role
products.  Bit 4 "Force x2 A-law mode" and bit 16 "-6dbm constellation" are
the server-side controls the analog build leaves unnamed; the latter is the
Total Control MIB's `hdmScHighPowerConst` (S76.7) under another name.

Its result codes follow: alongside the usual `.../x2` and `.../V90` ladders it
carries a `/DIGITAL` set - `56000/DIGITAL`, `56000/ARQ/DIGITAL`,
`64000/DIGITAL`, `64000/ARQ/DIGITAL`, and `300/DIGITAL` upward - plus
`TURBO PPP`, `112000` and `128000` for bonded B channels.

What is still open on the I-modem image: whether V.90's symmetric
(all-digital, DDPCM) role is present as well.  S58 bit 8 is named "symmetric
mode" under a heading that says x2, and the I-modem's S81/S82 are X.75 layer 2
and layer 3, not the Total Control V.90 register.  Its DSP overlay set has
not been extracted either - the overlay-table segment compares this tree's
reader looks for are absent from that loader, so the comparison in
[isdn-vs-analog-dsp.md](isdn-vs-analog-dsp.md) has not yet been run against
the real ISDN image.

### What the analog ID_SDL ROMs show

The images this tree calls 302 and 403 are **analog** Courier V.Everything
ROMs with the ID_SDL extended-help build (supervisor dates 03/13/98 and
04/30/98), not ISDN.  What they add over the stock `MAIN_*.XMF` payloads is
diagnostics: the failure enum at `1c246` (`Remote modem is not a Server`,
`Multiple CODECs in channel`, `Incompatible versions`, `Channel is x2-capable
but feature not installed`) and, in the 403 only, the negotiation report block
at `49f39`.  Those are a client's view of a failed x2 call, which is what a
V.Everything is.  The x2 setup path itself is identical in all of them - one
capability builder matching the same 26-byte pattern at `8f43` (403), `8eb3`
(302), `25112` (2.1.1), `252c3` (2.2.05), `218db` (2.3.31), each followed by a
single `mov ax, 70`.

## The I-modem's DSP: seven images, and none of them is the client receiver

The I-modem's overlay loader is not this tree's reader's shape - it takes the
index, masks `and ax, 0x000f`, multiplies by six against a table at `cs:d682`,
and picks the source segment from a *second* table at `cs:d6ca` indexed by
`(index - 5) * 2` (`83 e3 0f / 80 eb 05 / d1 e3 / 2e 8e 87 ca d6`).  With
`cs = 0xa400` the two tables read out cleanly, and every row's start is zero -
each image has its own segment:

| idx | segment | file | words | loads at |
|---:|---|---|---:|---|
| 5 | `e869` | `a8690` | 4,670 | `8000` |
| 6 | `d0d6` | `90d60` | 13,909 | `a000` |
| 7 | `d7a1` | `97a10` | 5,173 | `b800` |
| 8 | `da28` | `9a280` | 2,436 | `9260` |
| 9 | `db59` | `9b590` | 3,215 | `b000` |
| 10 | `dceb` | `9ceb0` | 7,536 | `d100` |
| 11 | `e099` | `a0990` | **15,997** | `9260` |

Seven images against the analog Courier's four, they tile the DSP region
`90d60`-`aab0c` contiguously, and the load addresses are its own - `a000`,
`b800`, `9260`, `d100` - not the analog's `9d00`/`b000`/`dc00`.  The resident
is 4,670 words where the analog's is 26,080-30,170: this DSP is organised
differently, with the weight in the loadable images.

**Image 11 is the PCM one, and it is the only one that touches the PCM
parameter cells.**  Counting the cells the x2/V.90 setup path writes:

| image | `fff3` | `fff4` | `3fff` | `fff7` |
|---|---:|---:|---:|---:|
| 5, 7, 9 | 0 | 0 | 0 | 0 |
| 6 | 0 | 0 | 0 | 1 |
| 8 | 0 | 0 | 0 | 1 |
| 10 | 0 | 0 | 0 | 5 |
| **11** | **6** | **4** | **1** | **8** |

And image 11 is 15,997 words against the analog PCM overlay's 6,197 - **2.6
times the size**.

**None of the seven is the analog client receiver.**  Coverage against the
analog 2.3.31 segments, byte-exact runs of ≥12:

| I-modem image | vs analog resident | vs ov6 | vs ov7 | vs **ov8 (PCM)** |
|---|---:|---:|---:|---:|
| 5 (4,670 w) | 11.4% | 3.0% | 12.0% | **0.1%** |
| 6 (13,909 w) | 2.9% | 24.4% | 0.2% | **0.3%** |
| 7 (5,173 w) | 5.9% | 12.8% | 0.6% | **0.2%** |
| 8 (2,436 w) | 5.6% | 13.3% | 0.6% | **0.0%** |
| 9 (3,215 w) | 54.0% | 1.0% | 0.0% | **0.0%** |
| 10 (7,536 w) | 26.9% | 0.5% | 0.2% | **0.0%** |
| 11 (15,997 w) | 36.4% | 1.4% | 1.8% | **0.0%** |

The longest shared run with the analog PCM overlay, across all seven images,
is 14 bytes.  Elsewhere the same metric finds 24-54% and runs of hundreds of
bytes, so this is not the metric being harsh: the analog's PCM *downstream
receiver* is simply absent from the I-modem, and image 11 was written for a
different job.

That is what "server and symmetric, no client" looks like in the image.  A
server does not need the client receiver; it needs a PCM sender, and symmetric
mode needs both halves at once - which is a plausible reading of an image 2.6
times the size of the one it replaces, though what is inside image 11 still
has to be disassembled to say so outright.

## Where V.90 all-digital sits in the standards

DDPCM was never standardised in this form.  V.90 itself defines only the
analog client and digital server halves; the symmetric case went to a separate
work item and came out as **V.91** (approved May 1999), scoped to "a 4-wire
circuit switched connection and … leased point-to-point 4-wire digital
circuits" - not the 2-wire dial-up case these modems were doing it on.  V.92
then went the other way, adding upstream PCM at up to 48 kbit/s over the
existing asymmetric arrangement rather than a symmetric 64k mode.  So USR's
`x2 symmetric` and `V.90 all-digital` are pre-standard vendor modes filling a
gap the ITU addressed only for 4-wire circuits, and they kept their own
S-register bits and their own RADIUS modulation codes because there was no
recommendation to name.

## What the other six images are

Each one is named by where the supervisor requests it and by what it matches.
The request variable is the byte at `e738`; every writer of it, and the
loader's own pairing rule, gives the structure:

```
ae2cb  mov [e738], 6     ; taken when the first predicate passes
ae2e5  mov [e738], 7     ; taken when the second does
b1503  cmp al, 7 / jne / call / mov [e738], 8    ; requesting 7 also loads 8
b1655  mov [e730],1 ; mov [e738],0a ; call load ; mov [e738],0b ; call load
c84d8 …cb1ed  mov [e738], 9   - seven sites, all inside the `+F…` code
```

and coverage against the 2.1.1 payload's own four segments (byte-exact runs of
≥12; the figure is coverage, the number after it the longest single run):

| image | words | @ | vs resident | vs ov6 V.34 | vs ov7 V.FC | vs ov8 PCM | what it is |
|---:|---:|---|---:|---:|---:|---:|---|
| 5 | 4,670 | `8000` | 19.3%/193 | 6.2%/193 | 0.5%/16 | 0.1%/12 | **resident** |
| 6 | 13,909 | `a000` | 2.6%/52 | **24.8%/186** | 9.7%/104 | 0.3%/14 | **V.34** |
| 7 | 5,173 | `b800` | 6.2%/64 | 13.0%/84 | **68.0%/1039** | 0.2%/12 | **V.FC** |
| 8 | 2,436 | `9260` | 19.1%/640 | 13.7%/104 | 43.4%/110 | 0.0%/0 | **V.FC companion** |
| 9 | 3,215 | `b000` | 54.2%/376 | 1.0%/36 | 0.9%/36 | 0.0%/0 | **fax** |
| 10 | 7,536 | `d100` | 27.7%/202 | 0.5%/64 | 0.4%/64 | 0.0%/0 | **PCM, part 1** |
| 11 | 15,997 | `9260` | 47.6%/770 | 1.4%/64 | 2.6%/65 | 0.0%/13 | **PCM, part 2** |

* **7 is V.FC beyond argument** - 68% of it is byte-identical to the analog
  2.1.1 overlay 7, including one run of 1,039 bytes.  **6 is V.34** by its best
  match, by size, and by the chooser at `ae2cb`/`ae2e5` being the same
  two-predicate shape the analog uses to pick V.34 or V.FC.
* **8 is V.FC's second half**, not an independent modulation: the loader pairs
  it to 7 the way the analog pairs 8 to 6.
* **9 is fax.**  It is requested from seven sites and every one of them sits in
  the Class 2 code - `+FHT:`, `+FHR:`, `+FCI:`, `+FIS:`, `+FTI:`, `+FCS:`,
  `+FPS:`, `+FET:` are all within a few hundred bytes of the requests.  Its 54%
  against the resident is shared helper bodies, not shared modulation.
* **10 and 11 are one program in two loads**, requested back to back by the
  routine at `b1655` with a flag at `e730` held across both.  They tile:
  11 covers `9260`-`d0dd` and 10 covers `d100`-`ef91`, 23,533 words together.

That last point is the structural difference from the analog Courier.  There,
PCM is overlay 8, 6,197 words, *chained onto* the V.34 core - the loader sees a
request for 6 and adds 8, and the PCM layer rides on V.34's receiver.  Here the
PCM image is 23,533 words in its own right, occupying the same program space
V.34 would use (`a000`-`d6a9`), so it is an alternative to V.34 rather than an
addition to it: a complete datapump, nearly four times the size of the client's
PCM overlay, sharing nothing with it.

## ISDN is 4-wire

Worth stating, because it closes the V.91 question rather than leaving it as an
aside.  A BRI B-channel is a 4-wire class circuit - separate paths per
direction, full duplex, no hybrid and no echo to cancel - and it is circuit
switched.  That is precisely V.91's scope: "a 4-wire circuit switched
connection".  So the I-modem's symmetric mode is not doing something V.91 does
not cover; it is doing the thing V.91 would later describe, two years before
V.91 was approved (May 1999) and with no recommendation to cite in the
meantime.  Which is why it shipped as an S58 bit with a vendor name.
