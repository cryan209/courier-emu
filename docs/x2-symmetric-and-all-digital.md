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

> **Correction from the release-series comparison.**  Images 10 and 11 are
> not a second standalone datapump.  Together with the small I-modem resident
> they reconstruct the analogue Courier's resident-class program; the pair
> predates x2.  What x2 adds is new PCM transmit/state-machine code inside that
> split resident program.  See [Nine I-modem builds](imodem-firmware-timeline.md).

### Isolating the first x2 server and symmetric addition

The last pre-x2 build (`IM020009`, October 1996) and first x2 build
(`IM020104`/`IE020104`, March 1997) bound the new DSP code exactly:

| image | pre-x2 words | first-x2 words | growth with x2 |
|---:|---:|---:|---:|
| 10 | 5,545 | 6,881 | **1,336** |
| 11 | 14,525 | 15,811 | **1,286** |
| combined | 20,070 | 22,692 | **2,622** |

The addition is split almost evenly across the load boundary.  The supervisor
always loads images 10 and 11 back to back, so this is one program, not one
image for server mode and another for symmetric mode.

S58 bit 2 (server) and bit 8 (symmetric) also arrive together in the first x2
release.  Binary presence alone therefore cannot distinguish the two roles,
and it does not yet prove that either control reaches the DSP.  The required
discriminating trace is:

```text
S58 stored byte, bit 2 / bit 8
    -> supervisor mailbox argument
    -> DSP parameter word in images 10 and 11
    -> one-way PCM transmit or two-way symmetric state machine
    -> equal-rate selection, including the 64,000 terminal case
```

Only the endpoints of that diagram are presently proved: the S58 labels and
the x2-era growth in the paired DSP program.  The intervening arrows are the
open reverse-engineering task.  In particular, a supervisor test of either
mask is not enough unless its result can be followed into a mailbox write and
then to a C5x data-cell consumer.

This narrows the 64,000 path as well.  It is outside the analogue client's x2
rate mask and cannot be produced by the tag-`69` line-quality map.  For x2
symmetric it must come from the server-side role/rate path above.  Transparent
ISDN `/DIGITAL` calls remain a separate path that does not require the modem
DSP.

### False lead closed: `9074` is legacy HST, not x2

An initial comparison appeared to find a new first-x2 bitmap at `ds:9074`.
Its consumers select levels 2 through 7 from masks `10h`, `08h`, `04h`, `20h`,
`40h`, and `80h`, and a parser fills it from a literal `HST/c0` record.  That
looked superficially like the remote-server transmit selector named by S58.

The release comparison disproves it.  In `IM020009`, six months before x2,
the same `HST/c0` handler stores its two octets at `9086`/`9087` instead of
`9073`/`9074`, and the consumers of `9087` contain the same mask tests and the
same level-selection logic.  The whole block moved by 19 bytes as RAM layout
changed.  It is the legacy USR **HST modulation** parser, not an x2 host/DSP
message.

This is a useful negative result: direct-address absence is not evidence that
a state variable is new across firmware releases.  A proposed x2 addition now
has to survive relocation-aware code matching against `IM020009`.  The real
server/symmetric trace must connect S58 bits 2 and 8 to the new code in DSP
images 10 and 11; the HST bitmap contributes nothing to that proof.

### First server-control spine in the DSP

The first-x2 overlay table can now be read independently of the later 3.00.02
addresses.  Its rows are byte counts and load addresses; its source-segment
table begins 0x48 bytes after the row-table base.  The three pieces that form
the resident-class C5x program are:

| image | source | bytes | words | C5x load range |
|---:|---:|---:|---:|---|
| 5 | `e005:0000` | `2322h` | 4,497 | `8000..9190` |
| 11 | `d84c:0000` | `7b86h` | 15,811 | `9194..cf56` |
| 10 | `d4ef:0000` | `35c2h` | 6,881 | `d000..eadf` |

That makes it possible to follow pointers across the image boundaries instead
of comparing the three blobs separately.  A dispatch table in image 5 names
two adjacent entries in image 10:

```text
e11a: lacc #0000  -> e120
e11e: lacc #0100  -> e120

e120: sacb                  ; preserve which entry was selected
      lacc @7a
      and  #00c0
      sub  #00c0            ; classify host-supplied mode
      ...
      lamm @7d -> @70       ; import host/DSP parameter words
      lamm @7e -> @6e
      lamm @7f -> @6f
      lamm @7a
      orb  saved-entry-flag
      -> @60 and @6d        ; working mode words
```

The resulting mode word is not passive.  `@60` bits 5, 4, 2, 1 and 0 choose
different state paths, while bit 8 in the saved/combined word chooses between
callback `e184` and the older callback `8b52`.  The initializer installs
function pointers `e65f/e67b` or `e692/e6a1`, and state callbacks including
`e2b1`, `e438`, `e4bc`, `e5e7`, `e60b`, `e61d` and `e62c`.  The large new
block `e185..e4cc` is therefore a callback-driven protocol engine, not a table
or unused payload.

This gives the middle of the required control path:

```text
supervisor-selected DSP entry (e11a or e11e)
    -> host parameter word @7a and imported @7d:@7f
    -> combined mode words @60/@6d
    -> role-dependent callback set
    -> staged engine e185..e4cc
```

Two links are still deliberately unnamed.  The supervisor caller that chooses
`e11a` versus `e11e` must be tied to S58 `02h`/`08h`, and the callbacks must be
classified against observable V.8, INFO, Phase 3, Phase 4 and data events.
Those are now bounded searches over this control spine rather than searches of
all seven images.

### Tags `70` and `71` are consecutive setup fields, not the two roles

> **Superseded in part.** The dispatch-table base and the bit-numbering
> convention used below are both wrong; see *The dispatch base is `882b`*
> at the end of this document for what survives and what does not.

The small resident's 128-word host-command dispatch table starts at `8817`.
As on the analogue Courier, the received tag is the direct index into this
table; the valid range is `00..7f`.  The two adjacent entries therefore resolve
without guessing:

| host tag | table cell | handler | bit contributed to `@60` / `@6d` |
|---:|---:|---:|---:|
| `70` | `8887` | `e11e` | `0100` |
| `71` | `8888` | `e11a` | `0000` |

There are only two other references to either handler in the joined program.
They are the internal chooser at `e769..e779`, which tests `@6f` bit 0 and
branches to the same pair (`e11a` when set, `e11e` when clear).

The extra `0100` is operational, not a status label.  Both handlers merge it
with host word `@7a` and copy the result to both working mode words.  At
`e166..e16b`, bit 8 then selects the callback installed in `@1a`:

```text
mode bit 8 clear  -> e184   ; new callback-driven x2 engine
mode bit 8 set    -> 8b52   ; older resident callback
```

Following the supervisor producers corrects the tempting interpretation that
these are the server and symmetric commands.  `addca..ade10` constructs a
capability/configuration word in `BX`, sends it as tag `70`, and returns.
`ade11..ade21` computes the intersection of two rate masks, saves it at
`a7e3`, and sends that value as tag `71`.  The normal call-start paths at
`a97c2..a97dd` and `a99c1..a99dc` send both, in that order.  They are two
fields of one setup transaction, not mutually exclusive roles.  Bit `0100`
still has the callback effect above, but it must not be named "symmetric" from
that fact.

### The actual symmetric selector: S58 bit 8 makes both descriptors mode 8

The I-modem keeps S58 at supervisor byte `2800:9187`.  This is identified by
the complete named bit set in executable code: the same byte is tested for
`01h`, `02h`, `04h`, and `08h`, matching x2 enable, server mode, forced A-law,
and symmetric mode.  The symmetric test occurs in two parallel call-record
builders, at physical `5f649` and `6057c`.

The first path is representative.  Before the override, the builder has made
an asymmetric x2 record: byte `+7` is mode `0ah` and byte `+9` is 1.  When S58
bit 8 is set, it performs the following paired update:

```text
test byte es:[9187], 08h       ; S58 symmetric mode
jz   ordinary-asymmetric-path

mov  byte [primary + 9], 0
mov  byte [mirror  + 2], 0
mov  byte [primary + 7], 8
mov  byte [mirror  + 3], 8
```

The second builder at `6057c..605a4` makes the same four writes.  The two
structures are a primary call descriptor and the mirrored descriptor passed
to the other side of the negotiation code; the builder deliberately keeps the
role and modulation bytes identical between them.  Thus the implementation of
"both modems send and receive at the same x2 speed" begins by replacing the
ordinary directional x2 role (`+9 = 1`) with **no privileged direction**
(`+9 = 0`) and selecting the same proprietary modulation mode, internal value
8, in both descriptors.

This is also release-bounded evidence.  The 45-byte block containing that
S58-bit-8 override occurs once in `IM020104`, the first x2 build, and not at all
in `IM020009`, the last pre-x2 build.  Mode 8 here is therefore the executable
I-modem implementation of x2 symmetric, not the unrelated result-code value 8
in the analogue Courier diagnostics.

The rate agreement then has the two directional MP maximum-rate nibbles
recovered below available to it.  The descriptor writes prove equal role/mode,
but the final write that makes the two MP rate nibbles equal has not yet been
isolated; using the mutually acceptable ordinal for both is the interpretation
supported by the MIB's explicit equal-rate requirement.  Ordinal 15 is the
terminal case, 64,000 bit/s (`K = 48`, eight payload bits per 8-kHz PCM sample).
On an analogue path the measurement-derived ceiling prevents that ordinal;
between two digital endpoints there is no analogue measurement clamp, so 15
remains available.

### The Quad image exposes the digital-server DSP hand-off

QF 6.0.3 is a better image for naming the server half because its overlay map
is recovered and it contains the digital modem's V.90 INFO0d builder.  The
important correction is that "digital mode" is not represented by one bit.
At least two internal bits in DSP data word `039f` carry different parts of
the decision:

| DSP state | tested at | effect |
|---|---|---|
| `039f` bit 0 | `9535`, `957c`, `a01f` | build and transmit the 30-bit V.90 INFO0d body rather than the 17-bit INFO0a body |
| `039f` bit 7 | `a92f`, `aab3`, `aad9`, `aafb` | select the digital-server receive rules and enter the server-only overlay at `c800` |
| `ffd9` bit 8 | `c801`, `c81c`, `c870` | distinguish the two passes/substates inside that overlay |
| `ffd9` bit 9 | `c89e` | gate the transition out of its setup path |

These are DSP RAM bits, not ITU bit positions.  The first is the advertised
V.90 role; the second changes executable control flow and therefore proves
that the role reaches the datapump rather than stopping in the supervisor.

The join after INFO is now concrete.  Shared code at `aaa4..aafe` receives a
framed bit stream and updates a CRC with polynomial `8408`.  Once the received
CRC agrees, the ordinary path continues at `ab00`, but `039f` bit 7 branches
to `c86f`:

```text
aab3  lar   ar1, #039f
aab5  bit   7, *             ; choose server receive buffer/rules
...
aac9  xor   #8408            ; framed receive CRC
...
aaf7  lacl  @42
aaf8  xor   @24              ; received CRC agrees?
aaf9  bcnd  ab49, neq
aafb  lar   ar1, #039f
aafd  bit   7, *
aafe  bcnd  c86f, tc         ; valid server frame -> server overlay
```

`c86f` copies the negotiated working words into `0340`/`0341`, expands the
server tables, and finally installs `c922` in `03cd`.  `03cd` is the datapump's
phase callback/descriptor cell throughout these images.  A later threshold
test at `c8ce` changes the cell to `c90e` and reports a five-word status stream
to the supervisor:

```text
c8b7  lar   ar1, #03cd
c8b9  bd    ab2e
c8bb  splk  *, #c922         ; install first server phase descriptor

c8ce  lar   ar1, #03c8
c8d0  cpl   *, #c423
c8d2  retc  ntc
c8d3  lar   ar1, #03cd
c8d5  retd
c8d6  splk  *, #c90e         ; advance the server phase descriptor

c8d8..c8e7 -> supervisor queue: 806c, 0000, 806d, 0600, 8074
```

The queue routine is resident `86cd`; it writes each word to the ring at
`0bd0`.  Thus the transition has both required consequences: a new DSP phase
descriptor and an observable control-plane notification.  The high bit on
`806c`, `806d` and `8074` marks control/status words in this mailbox stream;
the exact supervisor names for tags `6c`, `6d` and `74` remain to be recovered.

The resident dispatcher at `c03d..c048` explains what those values are.  It
loads `03cd`, copies the next three program words into working cells
`03c8..03ca`, advances the script address by three, and dispatches through the
working callback.  Thus `03cd` is a three-word phase-script pointer, rather
than merely an untyped callback cell:

```text
c03d  lacl  @4d              ; DP 7: data 03cd, current script pointer
c03e  bcnd  c047, eq
c040  sach  @4d              ; consume the pending pointer
c041  lar   ar1, #03c8       ; three working words
c043  rpt   #02
c044  tblr  *+
c045  add   #03
c046  sacl  @4b              ; next three-word record
c047  lacl  @48
c048  bacc                    ; run this record's callback
```

Following `c922` in three-word steps terminates exactly at `c93a`, whose first
word is `c423`.  `c423` is executable resident code that reports status through
`86cd`; `c8ce` watches working cell `03c8` for that same value and performs the
`c922 -> c90e` switch.  This proves that `c922` is a finite server sub-script
and that `c8ce` is its completion callback.

It does **not**, by itself, prove a Phase-4-to-data boundary.  A complete
cross-reference finds an earlier installer at `a180..a18a`: bit 15 of `039f`
chooses `c67f`, then bit 7 chooses `c7dd` or `c90e`.  The digital-server role
therefore installs `c90e` before the `c922` detour, and `c8ce` restores that
enclosing server script.  Calling `c90e` a newly entered data script would
contradict that earlier use.

The complete selector at `a180` is:

| `039f` bit 15 | `039f` bit 7 | installed at `03cd` | present interpretation |
|---:|---:|---|---|
| 0 | either | `c67f` | non-PCM/default family; bit 7 is not consulted |
| 1 | 0 | `c7dd` | PCM analogue/client-side path |
| 1 | 1 | `c90e` | PCM digital-server path; its constants identify the V.90 sequence in this dual-protocol build |

`c922` is not a fourth peer in that selector.  It is installed later by the
digital-server receive path as a finite detour, after which `c90e` is restored.
Therefore the immediate candidate to inspect for an alternative PCM sequence
is `c7dd`; assigning it specifically to x2 still requires tracing the producer
of `039f` bit 15 and comparing an x2-only server build.

The nearby engine at `c93e` remains a strong six-interval PCM mapper candidate:
it initializes six intervals, derives independent counts from negotiated
buffers, repeatedly calls `c524`/`c99c`/`c9d2`, and returns to common setup at
`c565`.  Its actual enable edge still has to be followed rather than inferred
from adjacency to the script table.

The evidence-backed call spine is therefore:

```text
supervisor mode/config command
    -> DSP RAM 039f bit 0: INFO0d field layout and 30-bit serializer
    -> DSP RAM 039f bit 7: digital-server datapump role
    -> shared framed INFO receive + CRC (aaa4..aafe)
    -> c800 server overlay (c86f)
    -> phase cell 03cd = c922
    -> finite server sub-script terminal callback c423 at c8ce
       + phase cell 03cd = c90e
       + mailbox status 6c/6d/74 to the supervisor
    -> enclosing server script resumes
```

### Decompiling the `c90e` / `c922` script bodies

Loading the Quad's `c800` mode image at its real DSP destination removes an
important ambiguity: these regions are not opaque encoded bit fields. They
are descriptor streams containing native callback addresses interleaved with
counts and parameters. The conspicuous callback words include resident
`c434`, `c4a6` and `c423`, plus mode-local `c9ec`, `ca00`, `c52e` and `cba0`.
Following those addresses produces ordinary C5x code for filter setup, mapper
setup, table construction and terminal mailbox notification.

The raw streams contain the following count-sized values:

| script | values present | value at 8000 symbols/s |
|---|---|---|
| enclosing `c90e` | `0180`, `0080`, `0018`, `0012`, `000c`, `00c0` | 384, 128, 24, 18, 12, 192 symbols |
| finite detour `c922` | `0080`, `0018`, `0bb8`, `000c`, `01ff`, `0120`, `05dc` | 128, 24, 3000, 12, 511, 288, 1500 symbols |

`0180` is especially diagnostic: **384 symbols is exactly the length of
V.90 Sd**, specified as 64 repetitions of a six-symbol sequence. It occurs
in the enclosing digital-server script, alongside a call to the same resident
`c434` waveform setup used by the detour. This is the first direct numerical
placement of an Sd-sized interval in the recovered server phase program.

The large `0bb8` and `05dc` quantities in `c922` are 375 ms and 187.5 ms at
8000 symbols/s, respectively, which makes the detour training/timing code
rather than a packed rate message. The final `c423` callback is still the
terminal status notification identified above.

### The V.90 interpretation, not yet an x2 result

The following signal names and ordering come specifically from V.90.  V.90
9.3.1.3 through 9.3.1.6 requires the digital transmitter to send, in order:

```text
Sd 384T -> Sd-bar 48T -> TRN1d >= 2040T -> repeated Jd -> Jd' 12T
          -> optional DIL -> enter Phase 4
```

The beginning of `c90e` has those distinguishing constants in that same
order.  Its `0180` is the 384-symbol `Sd`.  The following `0018` drives the
packed two-codeword output path for 24 iterations, hence 48 transmitted
symbols and `Sd-bar`.  `TRN1d` and `Jd` do not have useful fixed table-length
constants: `TRN1d` is only bounded below and `Jd` repeats until the receiver
detects the analogue modem's S transition.  Their callbacks therefore occupy
the variable/repeating middle of the script.  The subsequent literal `000c`
is the fixed 12-symbol `Jd'` terminator.  The descriptor-driven step after it
is the optional DIL; its length and Ucodes come from the received Ja rather
than a constant in this table.  In particular, Ja's `N = 0` is the defined
skip condition: the digital modem does not transmit DIL.  The likely firmware
implementation is therefore a zero-count completion in the callback rather
than a branch encoded directly in the linear `c90e` table; the Ja `N` input to
that callback still needs to be traced.

The next fixed value is `00c0`, 192 symbols.  V.90 9.4.1.1 says that the first
digital-modem signal in Phase 4 is `Ri` for a minimum of exactly 192T.  Thus
the constants strongly identify `c90e` as the V.90 digital-transmit programme
that carries the end of Phase 3 into the start of Phase 4.

That attribution must not be transferred automatically to x2.  `Qf060003`
is a dual-protocol x2/V.90 server build, so finding the V.90 sequence in it
proves that the image contains a V.90D path; it does not prove that x2 uses
the same training sequence.  A normalized match against a pre-V.90 x2-only
server image is required before any of these V.90 signal names can be applied
to x2.

Within that V.90 interpretation, the DSP installs `c922` at
`c8b7..c8bb` only after the framed receive path has:

1. accepted a CRC-valid MP-family frame;
2. copied its first two received MP words unchanged to `0340`/`0341`; and
3. expanded the negotiated mapper parameters.

In V.90, MP is a Phase 4 exchange, after `Ri`, `Ri-bar` and `TRN2d`.
Consequently none
of `c922` can be `Sd`, `Sd-bar`, `TRN1d`, `Jd`, `Jd'`, or DIL.  It is the
post-MP Phase 4 tail: MP/MP' acknowledgement completion, `Ed`, `B1d`, and the
mapper hand-off toward data mode.  Its `0bb8` and `05dc` values are therefore
timeouts/guard intervals in that tail, not Phase 3 training lengths.  When its
terminal `c423` record fires, `c8ce` restores `c90e`, which is the enclosing
programme it interrupted.

The V.90 waveform labels supported for this path are therefore:

| signal | recovered location | basis |
|---|---|---|
| `Sd` | `c90e`, `0180` stage | exact 384T length and correct ordering |
| `Sd-bar` | following `0018` stage | 24 packed two-symbol iterations = 48T |
| `TRN1d` | variable middle of `c90e` | follows `Sd-bar`; minimum/duration is runtime-controlled |
| `Jd` | repeating middle of `c90e` | MP-family framed generator, terminated by received S |
| `Jd'` | `c90e` literal `000c` stage | exact 12T termination sequence |
| DIL | descriptor-driven stage after `Jd'` | received Ja supplies the parameters; `N = 0` suppresses transmission |
| `Ri` | `c90e` literal `00c0` stage | exact Phase 4 opening minimum of 192T |
| post-MP Phase 4 tail | `c922` | installed only after valid received MP and mapper expansion |

For the V.90 path, the remaining callback-level task is narrower: attach the individual
variable middle callbacks to the `TRN1d` generator versus the repeating `Jd`
serializer, and split the `c922` tail precisely into MP', `Ed`, and `B1d`.
The phase placement and the fixed-duration signals no longer depend on that
last naming step.  The separate x2 task is to determine whether an x2-only
server build contains an equivalent script or a proprietary alternative.

This changes the remaining reverse-engineering task from "find a hidden
scalar wire field" to "label each descriptor callback and its duration".
There must still be a decodable rate representation: the peer has to recover
the same mapper configuration.  The likely representation is structural—the
six interval constellation/cardinality choices—so its inverse is the number
of payload bits assigned across one six-symbol frame, `K`, followed by
`rate = K * 8000 / 6`.  In particular,
the entry points at `c9ec` and `ca00` lead into the server-specific mapper and
training constructors; their inputs derived from `0340`/`0341` are the likely
location where the selected codeword set—and therefore the effective PCM
rate—is encoded.

### The compact descriptor is received MP, not a five-bit x2 rate

The server overlay copies two selected descriptor words into data `0340` and
`0341`.  A later unpacker at `c8a5` extracts this slice from the first word:

```text
lacl  [0340]
bsar  2
and   #001f
```

It was tempting to call `0340[2:6]` the compact x2 PCM-rate code.  A
cross-generation check disproves that identification: the same receive copy
and the same consumers occur in the 1995 `SDL_CS3` V.34-only overlay.
Moreover, `a4fc..a504` in the x2-only image establishes the provenance
directly: after a valid MP CRC, the DSP copies the first two words of the MP
receive buffer `ff48` unchanged to `0340` and `0341`.

The MP writer in the V.34-only image masks `03fc`, and its standard field
construction identifies the layout.  In the first DSP word:

| DSP bits | transmitted MP bits | field |
|---|---|---|
| `9:6` | `20:23` (bit order reversed in the word) | maximum rate, call-to-answer |
| `5:2` | `24:27` (bit order reversed in the word) | maximum rate, answer-to-call |

So the five-bit read crosses the boundary between two ordinary four-bit V.34
fields; it is not one wire field.  x2's added routine at `a340..a356` performs
a direction-selected minimum and writes back into this same eight-bit MP
region.  This proves that the x2 negotiation reuses the two directional MP
rate nibbles.

The proprietary value mapping is forced by the complete x2 result ladder.
There are exactly sixteen entries, including the digital-only endpoint, so
they fill a four-bit ordinal without a hole:

| code | nominal rate | six-symbol `K` |
|---:|---:|---:|
| 0 | 33333 | 25 |
| 1 | 37333 | 28 |
| 2 | 41333 | 31 |
| 3..14 | 42666..57333 | 32..43 |
| 15 | 64000 | 48 |

For the measured analogue range, therefore, the conversion is
`MP_code = measurement_index - 7`: local indices `10..21` become codes
`3..14`.  Code 15 naturally names the all-digital 64 kbit/s case, while codes
0..2 name the three fixed fallback rates that the measurement clamp cannot
produce.  This mapping is structurally unique given the ordered sixteen-entry
firmware table; a captured MP exchange would still be the ideal independent
wire-level confirmation.

Separately, the receiver-side measurement produces local indices 10 through
21, which decode without another table as

```text
K = index + 22
rate = K * 8000 / 6
```

giving 42,666 2/3 through 57,333 1/3 bit/s.  This is the reversible rate
representation that the earlier field search was missing.

That local index must not be inserted directly into MP: values 16 through 21
do not fit either four-bit wire field.  A translation or ordinal selection
therefore lies between the measurement result and the MP writer.

The surrounding routine expands six records of eight words each from a table
of six source pointers.  Consequently the compact rate/geometry descriptor
does not directly list all six mapper constellations; it selects parameters
from which the DSP builds six interval-specific records.  V.90 CP makes that
same result explicit with six four-bit constellation-index fields.

The other proven fields are `0340[13:14]`, transformed into a geometry/count
parameter, `0341[14:15]`, transformed into a second parameter, and `0341[0]`,
which controls a mode-dependent branch.  Their exact x2 wire names remain to
be assigned, but they are independent of the five-bit rate index.

What is still missing is now narrow: identify the resident mailbox handlers
that set `039f` bits 0 and 7, map their controller commands back to S76/S81,
and follow the enable edge into the `c93e` mapper.  For V.90, `c922` is now
placed in the post-MP Phase 4 path.  For x2, the remaining protocol-attribution
problem is to compare these scripts with an x2-only server build rather than
assign V.90's `Sd`, `Sd-bar`, `TRN1d`, `Jd`, `Jd'` and DIL names by analogy.

## The x2-only phase path: do not start from `c90e`

For reconstructing x2 itself, the decisive image is the pre-V.90
`sdl6-x2.exe`.  Its PCM overlay has its own phase callback cell `@2f`; direct
installers select this sequence of handlers:

| installer | handler installed in `@2f` |
|---|---|
| `e739` | `eceb` |
| `e868` | `ed0b` |
| `e8f3` | `ed40` |
| `e9ab` | `ed83` |
| `eb84` | `ed8f` |
| `eda5` | `eecd` |

This is an x2-only state machine and therefore needs no inference from V.90
signal names.  Two parts are already concrete.  `eceb` conditionally calls
the six-bit fixed-GPC generator `ed2e`; `ed0b` consumes the associated stream
through the x2-only build's resident descrambler `8c94`.  `ed40` performs a
six-entry cyclic update (`ed7d..ed82` is the interval pattern `0,2,1,1,2,0`),
and `ed83`/`ed8f` share the later `ef0f`, `ef3f`, `eedf` processing path.
Finally, `eecd` repeatedly processes received state until a threshold test
passes, then calls the common transition routines at `b4b3` and `831e`.

The next x2-only task is to map the writes that install these six handlers to
the INFO/modulation-parameter events and to determine which transitions are
used for ordinary asymmetric x2 versus S58 symmetric mode.  The QF `c90e`
table is retained only as a later V.90 comparison and is not the starting
point for naming x2 phases.

### False lead: `032a` and `cbb4` predate x2

The March 1997 `IM020104` DSP routine at `cbb4` begins with the same structural
fixed-GPC recurrence as the client's `ed2e`:

```text
cbb4  lacc   @7a
cbb5  bsar   5
cbb6  xor    @7a
cbb7  cmpl
cbb8  and    @21       ; caller-supplied mask
cbba  lacc   @7d, 7
cbbb  or     @79
cbbd  lacc16 @79
cbbe  adds   @7a
cbbf  lt     @22       ; caller-supplied width
cbc0  satl
```

Unlike the small client generator, this routine then immediately uses the
generated value to select PCM tables (`0460` and subsequent tables), combine
the selected codeword with interval/mapping state, and produce the transmit
sample.

The installer at `bbe0..bbf0` selects it through the transmit callback cell
`@2f`.  State `@2a = 0` goes to `caca`, which installs `cb66`; states 1 or 2
install `cbb4`, then dispatch through a state table at `cabd + @2a`.  Other
table cases install `cc02`, `cc26`, or `cb98`.  This supplies a concrete
transmit sub-state machine:

```text
cb66 / cb98 / cbb4 / cc02 / cc26
```

But it is **not x2-specific**.  The October 1996 `IM020009` build contains the
same machinery six months before x2: its handlers `ba99`, `ba9f` and `bc7d`,
selector table `caa3`, installer `bbd0`, and generator/mapper `cb9a` relocate
to `bab3`, `bab9`, `bc97`, `cabd`, `bbea`, and `cbb4` respectively in
`IM020104`, almost uniformly by `+001ah` words.  The command semantics and
state ranges are unchanged.  Consequently this is inherited resident
transmit/mapping infrastructure and cannot by itself be called the x2 server
transmitter.

### Inherited working-state glossary

The `@xx` notation in the C5x disassembly is a **direct-page offset**, not an
absolute data address.  In the server PCM routines discussed here DP is 6, so
the relevant names expand as follows:

| shorthand | absolute cell | recovered use |
|---|---:|---|
| `@21` | `0321` | GPC output mask used by `cbb4` |
| `@22` | `0322` | GPC width/multiplier used by `cbb4`; bit 0 also selects one of two following mapper paths |
| `@2a` | `032a` | PCM transmit submode index; selects the callback and a jump-table entry |
| `@2f` | `032f` | current per-sample transmit callback |
| `@79` | `0379` | high part of the 23-bit GPC history/state |
| `@7a` | `037a` | low part of the 23-bit GPC history/state |
| `@7d` | `037d` | newly generated, masked GPC value |

This page qualification matters: an apparent `sacl @2a` after `ldp #007`
writes `03aa`, not this `032a` state.  An unqualified cross-reference search
mixes unrelated cells from several data pages.

`032a` is demonstrably a selector rather than a duration.  At `bbe0` it is
tested to choose `cb66` versus `cbb4`; at `bbec` it indexes the table beginning
at `cabd`.  The table's cases install `cb66`, `cb98`, `cbb4`, `cc02`, or
`cc26` in `032f` and select associated mapper tables and parameters.
Supervisor/DSP dispatch code at `bab3..babe` accepts an input index below 6,
adds 6, and stores values 6 through 11 into `032a`, showing that the same cell
also names later externally selected PCM submodes.  The semantic names of all
cases still need to be obtained from their producers; calling `032a` a rate,
phase number, or Ja field would not yet be justified.

`032a` is not advanced by a local incrementing phase counter.  It is replaced
by three DSP mailbox-command handlers from the resident dispatch table at
`8817`:

| mailbox tag | handler | accepted argument | value written to `032a` |
|---:|---:|---:|---:|
| `4bh` | `bab9` | `0..5` | argument + 6 (`6..11`) |
| `4dh` | `bab3` | `0..5` | argument (`0..5`) |
| `55h` | `bc97` | `0..12` | argument (`0..12`) |

The table addresses prove the tags: `8862 - 8817 = 4b`, `8864 - 8817 = 4d`,
and `886c - 8817 = 55`.  Handlers `bab3` and `bab9` validate the incoming DSP
argument in `@7a`, then use an absolute `smmr ...,#032a` or DP-6 store.
Handler `bc97` likewise rejects arguments 13 and above before copying the
argument to `032a` and scheduling its continuation.  The same commands are
already present in `IM020009`: its dispatch table begins at `8911`, where
tags `4b`, `4d`, and `55` select `ba9f`, `ba99`, and `bc7d`.  A scan of the
I-modem supervisor's 56 literal calls to its normal DSP-mailbox sender finds
no literal `4b`, `4d`, or `55`; their active producer, if any, is indirect or
table-driven.  More importantly, none of this is the x2-era addition.

The x2 trace must instead stay on code absent from `IM020009`: the new
`e185..e4cc` callback engine selected by combined mode bit 8, plus its new
initializers and supervisor inputs.  `032a/cbb4` may be reused downstream by
x2, but it cannot identify or order x2's proprietary training stages.

### The proved supervisor-to-x2-DSP bit bridge

> **Superseded in part.** The dispatch-table base and the bit-numbering
> convention used below are both wrong; see *The dispatch base is `882b`*
> at the end of this document for what survives and what does not.

The shared machinery does have an x2-specific use, but the discriminator is
the mode word passed through tag `70`, not `032a`.  The supervisor builder at
`addca..ade10` edits the active S58-derived capability word before sending
tag `70`:

```text
S58 server bit 02h set     -> clear payload bit 12 (`and bh,efh`)
S58 symmetric bit 08h set  -> clear payload bit 11 (`and bh,f7h`)
```

DSP tag-`70` handler `e11e` contributes bit 8, then common handler `e120`
merges the received word and copies it to both working mode words `@60` and
`@6d`.  This establishes the requested executable relationship:

```text
supervisor x2/server/symmetric configuration
    -> tag 70 payload bits 12/11
    -> DSP mode @60/@6d bits 12/11
    -> branches inside the new x2-era engine
```

The consumers are direct.  True bit 12 is tested as C5x `bit 3` at `e556`
and `e56f`.  With bit 12 set the engine enters `e574`, reports status `8058`,
and installs a legacy callback pair into `039a/039b`; with server mode clearing
bit 12 it bypasses that path at `e585`.  True bit 11 is tested as C5x `bit 4`
at `e14f` and `e61f`.  Symmetric mode clears bit 11, causing `e14f` to branch
directly to the alternative setup at `e172` instead of installing the
`e2b1/e438/e4bc` asymmetric callback chain at `e152..e170`.  The later `e61f`
test applies the same bit again at the common completion/transition point.

Thus the first role split is now proved from code alone:

| configuration | DSP mode bit | immediate engine effect |
|---|---:|---|
| ordinary/non-server | bit 12 remains set | take `e574` legacy-side callback setup |
| x2 server | bit 12 cleared | bypass `e574` through `e585` |
| ordinary asymmetric | bit 11 remains set | install `e2b1/e438/e4bc` chain |
| x2 symmetric | bit 11 cleared | skip that chain and enter `e172` alternative setup |

The remaining work is to name the signal operations performed by the two
callback chains and determine where they converge on the inherited sample
mapper.  That trace, rather than the inherited `032a` values, will yield the
x2 training sequence.

### `e172` is a mode-family initializer, not a transmitted signal

`e172` is the entry reached when mode bit 11 is clear, including the symmetric
selection above.  It is a short dispatcher over the three high mode bits.  As
elsewhere, C5x `bit` operands are complemented bit codes: `bit 2`, `bit 1`,
and `bit 0` test true bits 13, 14, and 15 respectively.

```text
e172  test @60 true bit 13 -> if set, e60b
e175  test @60 true bit 14 -> if set, call e822
e178                         then enter e61d
e17a  otherwise alter the bit-15 selector and derive @63/@64
e180                         enter e5e7
```

The destinations show its job:

* `e60b` installs callbacks `e4ca` and `e4f0`, installs `e5b8` in two working
  callback cells, initializes `@63/@64` to `07d0h`, and then joins `e61d`;
* `e822` performs a much larger banked-state initialization and installs
  table/callback pointers before joining the same path;
* `e5e7` is the common width/state initializer.  It selects a 7- or 8-bit
  mask (`007fh` or `00ffh`), initializes the associated width to 7 or 8,
  clears state cells, and installs resident callback `84af`.

Thus `e172` should be named provisionally `x2_mode_family_init`: it decides
which x2 engine setup to perform from mode bits 13--15.  It does not itself
generate training symbols.

One line above needs correcting: `e17a` is `xpl @60, #0001`, which toggles
true bit **0** - the low symbol-rate/carrier bit named below - not the bit-15
selector the following `bit 0, @60` goes on to test.  The toggle and the test
are two different bits that happen to be adjacent in the listing.

### Every producer of mode bits 8 and 13--15, from the one sender

> **Superseded in part.** The dispatch-table base and the bit-numbering
> convention used below are both wrong; see *The dispatch base is `882b`*
> at the end of this document for what survives and what does not.

The remaining question - which of the three arms a symmetric call takes - is
answered by reading the whole of the tag-`70` payload builder rather than only
its two S58 edits.  `IM020104` contains exactly one `mov ax, 70`, at `ade03`,
so `addca..ade10` and the `ada3c` it opens with are the complete producer.

`ada3c` builds the payload from scratch:

```text
ada3e  al = ~S54 (917a), then al >>= 1        ; S-bits are disables
ada45  for i in 0..4: if al bit i: bl |= cs:[dabc + i]
       table dabc = 01 02 18 60 84
ada5b  S56 (917c) bit 1 clear -> or bx, 0100  ; TX level deviation enabled
ada66  S56 (917c) bit 5 clear -> or bx, 2000  ; V.34+ enabled
```

The S-register block is anchored, not assumed: `9146` is the escape character
compared at `a0cf9` against the counter that trips at three, `914b` is
multiplied by 100 at `a596e` and `914d` by 10 at `a598c` - S2, S7 and S9 in
their documented units against a 10 ms tick.  So S0 sits at `9144`, which puts
S54 at `917a`, S56 at `917c` and **S58 at `917e`** - the byte `addca` tests for
`01/02/04/08`, confirming the bit names this document already gives S58 from
the MIB.

That makes the payload's low byte the ordinary V.34 symbol-rate/carrier mask -
the overlapping table entries pair a low and a high carrier per rate - and it
identifies the two high-bit producers:

| payload bit | set when | consumer |
|---:|---|---|
| 0..7 | S54 symbol rates, inverted through `dabc` | `@60` bits 0..7, the state paths at `e14c`/`e395`/`e542` |
| 8 | S56 bit 1 clear (TX level deviation) | merged with the `0100` tag-`70` handler adds |
| 9 | S58 bit 2 set (force A-law) | `or bx, 0200` at `addd8` |
| 10 | S58 bit 4 set | `or bx, 0400`; `bit 5, @60` at `e14c` -> `e62c` |
| 11, 12 | always, then cleared for symmetric / server | `e14f`, `e556` |
| **13** | **S56 bit 5 clear (V.34+ enabled)** | **`e172` arm 1 -> `e60b`** |
| 14, 15 | **never** | `e172` arms 2 and 3 |

So the arm is not a symmetric decision at all.  Symmetric mode's own edit is
`and bh, f7h` followed by `and bx, 3fffh`, and bits 14 and 15 were already
clear: nothing in `ada3c` or `addca` can set them, and inside the engine the
only writes to `@60` are `e14a`, `e15f` (`or 0200`), `e17a` (`xor 0001`) and
the `apl/opl` pairs at `e395..e55d`, none of which touch bits 13--15.  The
`3fff` mask is defensive.

Three consequences follow directly.

* **A symmetric call takes arm 1, `e60b`,** whenever V.34+ is enabled - which
  is the default - and otherwise falls through to arm 3.  Arm 1 installs
  `e4ca`/`e4f0`, puts `e5b8` in both working callback cells, sets `@63/@64` to
  `07d0h`, and calls `e5e7` from `e61d`.
* **Arm 2 is unreachable in this build.**  `e822` is called from `e176` and
  from nowhere else in the joined program, and bit 14 has no producer.  The
  large banked-state initializer is either dead or waiting for a sender that
  `IM020104` does not contain.
* **`e5e7` always selects eight bits.**  Its width choice is `bit 0, @60`,
  true bit 15: set gives mask `007fh` and width 7, clear gives `00ffh` and
  width 8, and clear is the only case the build can produce.  Eight payload
  bits at the 8 kHz PCM rate is 64,000 bit/s - the same terminal ordinal the
  MP rate field reaches, arrived at from the datapump side.

The remaining `e172` unknown is now narrow: what selects seven-bit operation,
given that no shipping producer does.  A second tag, a later build, or a
field of `@7d:@7f` imported at `e141..e146` are the three places to look.
The first of those is now excluded: `IM020104`, `IE020104`, `IE020202`,
`IE020405`, `IM020406`, `IE020706` and `Ie030002` each contain exactly one
tag-`70` sender, and all seven carry the identical `and f9ff / or 0200 /
or 1800 / or 0400 / and 3fff` edit set.  No I-modem build from the first x2
release to the V.90 era ever sets bit 14 or bit 15.

### The firmware names its own S-register bits

No inference was needed for S54, S56 and S58 after all: the on-line help text
the `AT$` screens print is in the image, at `ba130..ba420`, and it enumerates
the bits by value.

```text
S54  1 2400 / 2 2743 / 4 2800 / 8 3000 / 16 3200 / 32 3429 symbol rate
     64 V.8 Call Indicate / 128 V.8 Mode
S56  1 Non linear coding / 2 TX level deviation / 4 Pre-emphasis /
     8 Pre-coding / 16 Shaping / 32 V34+ / 64 V.34 / 128 V.FC
S58  x2 Mode and Remote Server Xmit:
     1 x2 / 2 server mode / 4 Force x2 A-law mode / 8 symetric mode /
     16 -6dbm constellation
S67  Misc. ISDN Configuration:
     1 Enable V.110 in Automode / 2 Fix Connection Rate for Digital Calls /
     4 Connect at 64K (else 56K) / 8 AT&T 5ESS Custom: Route Analog to
     Data Port / 16 Enable Data Link Delay
```

This confirms the byte assignments from the S0 = `9144` anchor exactly - S54,
S56 and S58 two apart at `917a`, `917c`, `917e` - and it names two payload
bits this document had left unnamed: bit 13 is **V34+ enabled**, and bit 10,
the `or bx, 0400` from S58 `10h`, is the **-6 dBm constellation**, whose
consumer is `bit 5, @60` at `e14c` branching to `e62c`.

It also shows that **S58 is a DSP register and nothing else.**  All five of
its bits are read at exactly five instructions - `add95`, `addd1`, `adde0`,
`addeb`, `addf5` - every one of them inside the tag-`70` builder.  x2 enable,
server, A-law, symmetric and constellation power reach the datapump through
that one word and touch no other part of the supervisor.

### Correction: the mode-8 descriptor override is S67, not S58

Which forces a correction to the "S58 bit 8 makes both descriptors mode 8"
section above.  The byte those builders test is `2800:9187`, and `9187` is
nine past S58, so it is **S67** - and S67 is also read DS-relative elsewhere
in the same task, so the two views are one array, not two registers that
happen to share an offset.  S67 bit `08h` is "AT&T 5ESS Custom: Route Analog
to Data Port", so `5f649` and `6057c` are rewriting a call descriptor for
5ESS analog-to-data-port routing, not for x2 symmetric.  The four writes and
the release bounding stand as observations; the register attribution does not.

The genuinely load-bearing symmetric evidence is unaffected, because it never
depended on that site: S58 `08h` at `addf5` clears payload bit 11, and DSP
`e14f` branches on it.

### What a symmetric 56000/56000 connection would be

> **Superseded in part.** The dispatch-table base and the bit-numbering
> convention used below are both wrong; see *The dispatch base is `882b`*
> at the end of this document for what survives and what does not.

Worth working out, because 56000 is exactly seven bits at 8 kHz and it is
tempting to read the `e5e7` width as the robbed-bit case.  The firmware has
three separate 56k mechanisms and they are not the same thing.

**The x2 rate ladder already contains 56000, at full eight-bit width.**  Rates
are `K * 8000/6` - `K` bits per six-sample frame - so 56000 is `K = 42`, MP
ordinal 13, against 64000's `K = 48`, ordinal 15.  A symmetric call at
56000/56000 is both directional MP nibbles carrying 13.  The datapump still
runs eight-bit codewords; the six-symbol frame mapper is what drops the
average to seven bits per sample.  Nothing about that needs mode bit 15, and
the `a340..a356` directional minimum already makes the two nibbles equal.

**The ISDN 56k restriction is a bearer setting that never reaches the DSP.**
S67 bit 4, "Connect at 64K (else 56K)", is read at `7d57d`, `7d651` and
`7d70e`, each time in call setup and each time paired with S67 bit 2, "Fix
Connection Rate for Digital Calls".  S67 is not read by the tag-`70` builder
at all.  That is the `56000/DIGITAL` result code's path - rate adaption in the
ISDN front end, consistent with this document's finding that the ISDN modes
are not in the DSP.

**Mode bit 15 is the third thing, and it is an alphabet restriction rather
than a rate.**  It sets the codeword mask to `007fh` and the width `@02` to 7,
and `@02` is the bit count the resident packer at `83c9` counts `@04` against
while shifting octets together.  Seven-bit width means the eighth bit of every
sample is unusable - a channel that can carry only seven bits, which is what a
genuinely restricted 56k digital path is, as distinct from a clean channel run
at a lower rate.  The hardware supports it; no shipping producer selects it.

So the honest statement is that a 56000/56000 symmetric connection in this
firmware is ordinal 13 on a 64k-clean bearer, and the seven-bit datapump mode
that would serve a restricted bearer was built and left unwired.

Both spaces are reproducible from the archive with
[imodem_x2_map.py](../tools/imodem_x2_map.py):

```bash
python tools/imodem_x2_map.py dsp e172 e186
python tools/imodem_x2_map.py sup ada3c ade12
```

## ISDN is 4-wire

Worth stating, because it closes the V.91 question rather than leaving it as an
aside.  A BRI B-channel is a 4-wire class circuit - separate paths per
direction, full duplex, no hybrid and no echo to cancel - and it is circuit
switched.  That is precisely V.91's scope: "a 4-wire circuit switched
connection".  So the I-modem's symmetric mode is not doing something V.91 does
not cover; it is doing the thing V.91 would later describe, two years before
V.91 was approved (May 1999) and with no recommendation to cite in the
meantime.  Which is why it shipped as an S58 bit with a vendor name.

## The ISDN modes are not in the DSP

Worth checking rather than assuming, because the seven images are the whole
story: sorted by file offset they tile `90d60`-`aab0c` end to end, with gaps of
0, 2, 6, 6, 6 and 8 bytes - paragraph alignment, nothing more.

```
idx  6  090d60-097a0a      idx 10  09ceb0-0a0990   (gap 2)
idx  7  097a10-09a27a  (6) idx 11  0a0990-0a868a   (gap 0)
idx  8  09a280-09b588  (6) idx  5  0a8690-0aab0c   (gap 6)
idx  9  09b590-09ceae  (8)
```

52,936 words, no room left over, and the loader's segment table at `cs:d6ca`
covers exactly indices 5 to 11.  So there is no eighth image hiding anywhere,
and every one of the seven is requested from analog-modem code: the
V.34/V.FC chooser at `ae2cb`/`ae2e5`, the Class 2 fax handlers, and the routine
that loads the PCM pair.  No `mov [e738], n` sits in the V.110/V.120/X.75
paths.

The content agrees.  V.110 is bit-stuffing into 80-bit frames and V.120/X.75
are HDLC - framing and rate adaption, not modulation - and none of the seven
images carries an HDLC CRC table: the CCITT polynomial `1021` appears once in
image 6 and once in image 8, `8408` twice in 6 and twice in 11, which is noise
at these sizes, and `7e7e` never.  On a 386 board with an ISDN front end and
two 16550s ([isdn.py](../courier_emu/isdn.py)), a B-channel carrying V.120 or
X.75 needs a serial controller, not a datapump.

So the division is clean: the DSP does the **analog** work - V.34, V.FC, fax -
plus the one digital-side datapump that genuinely needs a datapump, the PCM
image that sends x2 into the B channel.  The `/DIGITAL` result codes
(`300/DIGITAL` through `64000/DIGITAL`, and `112000`/`128000` for bonded
channels) are the rate-adapted and clear-channel ISDN calls, and those never
reach the DSP at all.

## No G.711 tables, in either family

Tested, because a digital-side datapump looks like it ought to carry one.  The
whole I-modem DSP payload (`90d60`-`aab0c`) was searched for the G.711 decode
table in codeword order - µ-law and A-law, as signed words and as magnitudes,
at shifts 0 through 4.  The first table entry occurs at most twice anywhere in
the payload, and no site continues into the table: best in-order agreement is
**zero** of the first 32 entries.  The same search over the analog payloads'
DSP regions (2.1.1 and 2.3.31) finds the same nothing.  No arithmetic ladder
either: sweeping for constant-step runs with the G.711 step sizes
(8, 16 … 2048) turns up eight runs in the whole payload, all in image 6, none
with the doubling-per-segment structure a companding table has.  The usual
companding constants are not concentrated anywhere either - `0055`, `0084`,
`00d5` appear 0-2 times per image, the same as in the analog images.

Which is consistent rather than surprising, once stated the right way round: a
PCM datapump does not convert between companded and linear, it **works in
codeword space**.  The transmitter picks which octet to send from a
constellation of allowed codewords; the receiver decides which codeword it
was.  What that needs is a table of *which* codewords, not a converter - and
S58 bit 4, "Force x2 A-law mode", then selects a different allowed set rather
than a different conversion.  The analog side's own sample path agrees: the
routine `courier_emu.datapumps` calls `PCM_SAMPLE_PATH` (`819d`) "assembles a
sample from two 8-bit codewords", so the DSP is handed octet pairs, not linear
samples.

So the conversion this board does need is in hardware on the PCM highway, and
the constellation table is what to look for in image 11 - not a G.711 codec.

## Found it: G.711 is computed, not tabulated, and only the I-modem has it

Two corrections and one answer.

**The answer.** The I-modem resident carries a complete G.711 codec in both
directions and both laws, at `81b8`-`8215`, immediately before its sample
paths.  The expander first:

```
81b8: bit   4, *              ; which law?
81b9: bcnd  81d4, ntc         ;   ntc -> the µ-law copy below
81bb: bit   8, *              ; sign bit -> TC
81bc: lacc  *, 12
81bd: xor   #00055000         ; A-LAW: the 0x55 toggle
81bf: and   #0007f000         ; magnitude
81c1: sach  @7d               ; exponent (segment)
   …
81cb: add   #00010800         ; hidden bit
81cd: sach  @7e, 5            ; mantissa
81ce: lt    @7d
81cf: lact  @7e               ; mantissa << exponent
81d0: xc    1, ntc / neg      ; apply sign

81d4: bit   8, *
81d5: lacc  *, 12
81d6: cmpl                    ; µ-LAW: the inversion
81d7: and   #0007f000
81d9: sach  @7d               ; exponent
81db: add   #00010800         ; hidden bit
81dd: sach  @7e, 5            ; mantissa
81de: lt    @7d / lact @7e
81e0: sub   #21               ; µ-law's bias - 0x84 at this scale
81e1: xc    1, ntc / neg
```

`xor #55`/`cmpl` is exactly the pair that separates the two laws, and only
µ-law carries the bias subtraction - textbook G.711, expressed as
exponent-and-mantissa rather than as a lookup.  The compressor follows it, the
same two ways round, using `norm` to find the exponent:

```
81ec: clrc ovm ; lar ar1,#07 ; rpt #06 ; norm *-    ; exponent search
   …  sar ar1, @7d ; add16 @7d ; retd
81fb: xor  #00055000                                ; A-law
8203: clrc ovm ; lar ar1,#07 ; rpt #06 ; norm *-
   …  sar ar1, @7d ; retd ; add16 @7d
820f: cmpl                                          ; µ-law
```

And the law is a runtime choice - `bit 4, *` at the top - which is S58 bit 4,
"Force x2 A-law mode", carried down to the DSP.

**It is I-modem only.**  The A-law toggle `xor #00055000` appears twice in the
I-modem resident (`81bd` in the expander, `81fb` in the compressor) and **zero
times** in the analog Courier residents, 2.1.1 and 2.3.31 alike.  Those two
sit behind a TLC320AC01 that hands them linear samples: their ISRs at `81ad`,
`81e8`, `8203` are `lamm @20 ; sacl *` and nothing more.  The I-modem needs the
codec because its analog datapumps - V.34, V.FC, fax - run over a B channel
that carries companded octets, exactly as expected.

**Correction.** The routine at `8374`, described in the section above as "a
shift by a stored exponent … the segment-and-mantissa method", is not
companding.  Its shift counts come from `@76`/`@77`, and `83a3`-`83a5` sets
both to a constant `0x18`:

```
839f: lacc #03cf ; samm @74 ; samm @75     ; two buffer pointers
83a3: lacl #18   ; samm @76 ; samm @77     ; two shift counts, both 24
```

So `sath ; satl` there is a fixed 24-bit right shift - the top byte of a
32-bit accumulator - and `and #00ff ; add @7c, 8` packs two of those into one
16-bit word.  That is the *linear* two-samples-per-word path, not a codec.  The
codec is the separate routine at `81b8`, and the earlier claim that no
companding existed anywhere in the DSP was wrong: no *table* exists, which is
a different thing.

## The dispatch base is `882b`, and the bit numbers were double-converted

Two mechanical errors ran through the sections above.  Both are settled by
executable code and by the C5x manual, and together they move the x2 engine's
mode word to a different pair of host commands.

### The host-command table starts at `882b`, not `8817`

The resident's receive path is at `851c`:

```text
851f  in   @7d, #005e        ; tag
8521  in   @7a, #005f        ; payload, one 16-bit port read
852f  lacl @7d
8530  sub  #75
8531  retc gt                ; reject tag > 75h
8532  add  #88a0
8534  tblr @7c               ; table[tag] = (tag - 75h) + 88a0h
8536  cala
```

The subtraction is never undone, so the base is `88a0 - 75 = 882b` and the
table is exactly `76h` entries for tags `00..75` - the `add` names its own
last row.  `8817..882a` is a signed curve (`0038 0027 0017 0008 fff9 …`),
not addresses.

Three independent checks agree, and each of them fails on `8817`:

* tags `1c` and `1d` reach `a05d` and `a062`, two adjacent handlers that each
  compute `@7a * 5` into adjacent cells.  Their senders at `aa09a` pass a byte
  in `bl` - `[9161]` and S9 at `[914d]` - which is exactly a timer being
  rescaled.  On the old base tag `1c` reaches `834a`, which ignores its
  argument.
* tags `5c` and `5d` reach `e11e` and `e11a`.  Their senders at `a9cac` and
  `a98bf` both finish with `or bl, (es:[0ce0:b5b9] & 3) << 6`, and `e120`
  opens with `lacc @7a / and #00c0 / sub #c0` - the same two-bit field, in the
  same two bit positions.
* tag `70` reaches `91a1`, which masks the payload with `3fffh` - the same
  two unused top bits the supervisor's own symmetric edit clears.

### The `bit` operand is already the true bit

`spru056d` gives BIT as `(dma bit at bit address (15 - bit code)) -> TC`, and
[c5x_disasm.py](../tools/c5x_disasm.py) prints `15 - (base & 15)`.  So the
number in the listing **is** the bit of the word; the "complemented bit codes"
rule applied above converts a second time and lands back on the raw code.
Read directly, the engine tests only bits 0--9 and 15 of `@60`/`@6d`, and
every write to `@60` inside it (`opl #0200`, `xpl #0001`, `apl #fdff/fffd/
fffe`, `and #0006`) is in that same low range.

### So tag `70` is the capability word, and `5c`/`5d` are the mode word

`91a1` stores the tag-`70` payload, masked to `3fffh`, into DSP cell `ffdb`
and sets bit 15 of `ffd9`; `91ae` stores tag `71` into `ffda`.  `ffdb` is read
at `927f`, which picks `ffdb` or `ffdc` on `039f` bit 12 and spills the word
into the `fef0` work area - a transmit-side capability structure.  That is the
INFO0 capability word
[x2-v90-protocol-selection.md](x2-v90-protocol-selection.md) already derives
from S54/S56/S58, arrived at here from the receiving end.

**What survives.**  The S-register decode is unchanged: the builder at
`ada3c`/`addca` is still the only tag-`70` sender in all seven builds, S54,
S56, S58 are still at `917a`, `917c`, `917e`, the help text still names their
bits, and S58 is still read at exactly five instructions.  What changes is the
destination: those bits are the **declared capability word**, not the engine's
mode word, so "symmetric clears payload bit 11, which `e14f` tests" does not
hold - `e14f` tests bit 4 of a word that comes from somewhere else.

**Where the mode word comes from.**  `@60`/`@6d` are built from the tag-`5c`
and tag-`5d` payloads, and their builders read the call descriptor rather than
S-registers.  The tag-`5c` builder at `a9bc0..a9cac`:

```text
a9bf8  descriptor mode byte = 8   -> leave without sending
a9c1d  mode byte = 0ah -> ax = 0, [a416] = 1
a9c25  mode byte = 9   -> ax = 0, [a416] = 3
a9c2d  otherwise       -> ax = 2 | (descriptor byte +3 << 8), [a416] = 2
a9c4f  descriptor byte +1 nonzero -> or ax, 1
a9c5d  S67 bit 2 set (Fix Connection Rate for Digital Calls):
           and ax, fffeh
           S67 bit 4 clear (56K, not 64K) -> or ax, 1
       S67 bit 2 clear:
           unless [a416] = 2 or [a410] = 3 -> or ax, 4
```

### Which answers the 56000 question properly

The seven-bit datapump mode is not unwired at all; the earlier section reached
that conclusion from the wrong tag.  The chain is short and every link is an
instruction:

```text
S67 bit 4 clear = "Connect at 56K"
    -> tag-5c payload bit 0            (a9c81: or ax, 1)
    -> @60 bit 0                       (e120: lamm @7a / orb / sacl @60)
    -> e5e7 selects mask 007fh, width @02 = 7
    -> 7 bits x 8 kHz = 56000
```

`e5e7`'s other consumer agrees: `e17c` doubles `@63/@64` when bit 0 is
**clear**, the 64K case.  So a restricted 56k digital bearer really does drop
the datapump to a seven-bit alphabet, and the eight-bit alphabet is the 64K
bearer - which is what the `56000/DIGITAL` and `64000/DIGITAL` result codes
are naming.  The x2 ladder's own 56000 (`K = 42`, MP ordinal 13, eight-bit
codewords in a six-symbol frame) remains a separate mechanism for analogue
paths; both exist, and they are not the same 56000.

`e172`'s three arms are live for the same reason.  Bit 2 selects `e60b` and is
set for descriptor modes `0ah` and `9` on an unfixed rate; bit 1 selects
`e822` and is set for the `ax = 2` family, every descriptor mode that is
neither `0ah` nor `9`; bit 0 - the 56K bit - then chooses the width in the
fall-through arm.

### The -6 dBm constellation

S58 bit `10h`, "-6dbm constellation", sets capability-word bit 10, which
reaches `ffdb` and the transmitted INFO0 word.  The server-side counterpart is
in `HDM.MIB` as `hdmScHighPowerConst`, S76.7: "used to enable/disable the X2
high-power constellation.  This object is only valid in countries, where it is
legal."

There is no 0 dBm constellation.  The string `dbm` occurs once in the whole
I-modem image, in that one help line; the analogue Couriers do not carry the
option at all, and their only `-dBm` strings are the level displays and the
S16/S17 transmit-level registers.  It is a single boolean.

### The help text is tokenized, and the tokens set the polarity

`-6` being below zero makes "high power" look backwards, so the reference
point matters.  It is not 0 dBm, and the firmware says so itself once the help
strings are decoded: bytes above `7f` in them are dictionary tokens, and two
of them carry the sense of every bit line.  `ed` is `= `, **`bd` is `Disable`
and `ee` is `Enable`**, which is checkable against registers whose bits are
documented independently:

```text
S15  1 = Disable High-Freq EQ      S27  4 = Disable V32
S15 16 = Disable MNP Level 4       S27 32 = Disable V.42
S34  8 = Enable V23 Fallback       S53  1 = Enable Dial Security
```

So S58 reads, in full:

```text
S58  1 = Disable x2                4 = Force x2 A-law mode
     2 = Disable server mode      16 = Enable -6dbm constellation
     8 = Disable symetric mode
```

Three disables, one force, one **enable** - and the enable is the only bit of
the five that is opt-in.  That resolves the sense in three independent ways
that agree:

* the bit is *Enable*, and setting it *sets* capability bit 10 (`addd8`),
  where the disable bits *clear* their capability bits (`addf2`, `addfc`).
  You opt in to this constellation; you opt out of the others;
* the identical bit on the server is `hdmScHighPowerConst`, S76.7, "the X2
  **high-power** constellation ... only valid in countries, where it is legal";
* a country-restricted opt-in is a licence to transmit *more*, not less.

The baseline the `-6` is measured against is therefore the regulatory ceiling
on the digital end's transmit power, which sits below `-6` dBm - not 0 dBm,
which no PSTN downstream would be permitted anyway.  The exact default figure
is not stated anywhere in these images, so this document does not assert one.

This also corrects the polarity used in the S58 table above: bits 1, 2 and 8
are *disables*, so capability bits 11 and 12 are cleared when symmetric and
server are **disabled**, and carry the advertisement when they are on.

### Half-dB steps are real, and Table 15/V.90 is the scale

Confirmed from the Recommendation rather than from these images.  Table
15/V.90, "Limits for the average power calculation", is indexed by "Maximum
digital modem transmit power, dBm0" and runs **-0.5 to -16 dBm0 in 0.5 dB
steps**, each row giving a squared amplitude limit from `(15124)^2` down to
`(2540)^2`.  So V.90 does resolve digital-side transmit power to the half
decibel.

Two things follow for the `-6` question, and both point the same way as the
Enable/Disable reading above.

**The scale is dBm0 and its ceiling is -0.5.**  0 dBm0 is not the standard
power; it is not a permitted value at all - the table stops half a decibel
short of it.  The ladder runs downward from there, so every real operating
point is negative, and a bit named "-6dbm" is naming a row in the upper third
of that ladder rather than an attenuation from a 0 dBm norm.

**-6 against the customary -12 is exactly a 6 dB uplift.**  Both are rows in
this table, twelve steps apart, and `(8028)^2` against `(4024)^2` is the
factor of four in power that 6 dB means.  That is the shape of the feature the
server MIB calls high-power and restricts by country.

**The table itself is in none of these images.**  Ten client builds
(`IM010501` through `Ie030002`, plus the 4.03 Courier ROM) and ten server
images (`QF060003`, `QR060103`, `NM040103`, the HiPer DSP and NETServer
payloads) were searched for it: no run of even three consecutive rows in
table order at either word alignment, and the squared limits appear in no
encoding tried - 32-bit little- or big-endian, either alignment.  Isolated
matches on single amplitudes occur at the rate chance predicts, including in
`IM020009`, which predates x2 by six months.  Which fits: the limit binds the
*digital* modem's transmitter, x2 shipped two years before the
Recommendation, and a client never needs the table.

## What V.90 added to the same firmware

Two axes, read from the eight I-modem images this tree holds, sorted by the
date inside their archives rather than by version number - the numbering is
not monotonic, and `IE020706` (April 1998) predates `IE020405` (August 1998).

### The AT surface: x2 cost five bits, V.90 cost one

[imodem_help.py](../tools/imodem_help.py) decodes the built-in help screens.
They are tokenized: a length-prefixed word dictionary sits immediately before
the text and ends flush against `ff`, so its 96 entries fix the first token at
`a0`.  That yields `bd = Disable`, `ee = Enable`, `ed = " = "` and
`cf = Reserved` - the Enable/Disable reading above, obtained without inference
this time.

S58 across the lineage:

| date | image | S58 |
|---|---|---|
| 1996-10-31 | `IM020009` | absent |
| 1997-02-12 | `IM010501` | absent |
| 1997-03-04 | `IE020104` | 1 Disable x2, 2 Disable server mode, 4 Force x2 A-law mode, 8 Disable symetric mode, 16 Enable -6dbm constellation |
| 1997-12-07 | `IE020202` | as above, "symetric" spelled correctly |
| 1998-04-03 | `IE020706` | **+ 32 Disable V.90** |
| 1998-08-20 | `IE020405` | same six |
| 1998-09-24 | `IM020406` | same six |
| - | `Ie030002` | same six |

So x2's entire user-visible surface is five bits of one register, arriving
whole in March 1997, and V.90's is a **single further bit in the same
register** - a disable, so on by default.  The firmware treats V.90 as another
mode of the x2 feature, not as a subsystem beside it.  Everything else that
moves between these builds is ISDN wording and V.110/V.120 options.

### The DSP surface: V.90 brings one new command, tag `72`

`IM020104` and `IE020202` contain no tag-`72` sender at all.  Every V.90-era
build does, and it is gated by a predicate that ANDs S58 bit `20h` clear with
the same environment checks the x2 predicate uses.

In `IE020706` the payload is read straight from an S-register:

```text
b44c6  S58 bit 20h set (Disable V.90) -> give up
b44f6  bl = 6
b44f8  if 6 <= S70 <= 15h: bl = S70
b450a  bx |= 0b70h
b450e  send tag 72
```

and that register is named in its own help text: **`S70 Power Level for
V.90`**.  Sixteen usable steps, `6..15h`, on a scale the Recommendation
resolves to the half decibel.

### The knob was taken away again

`S70` reads "Power Level for V.90" in `IE020706` and **`Reserved` in every
other image** - `IE020405` and `IM020406` mark it reserved, `Ie030002` has no
S70 heading at all.  The register did not stop being read, though.  In
`IE020405` (S58 at `d1b2`, so S70 at `d1be`):

```text
b29b1  bx = [e6c0]                  ; the country-profile record
b29b5  al = cs:[bx + 71h]           ; that country's ceiling
b29ba  ah = S70
b29be  if S70 > 10h: use the ceiling
b29c3  else use min(S70, ceiling)
b29cb  ((n - 1) * 2 | 1) << 4 | 0a06h  -> tag 72
```

So between April and August 1998 the V.90 transmit power stopped being a
number the user sets and became `min(S70, country_ceiling)`, with S70's own
range cut from 21 to 16 and its name removed from the help.  The command
encoding changed with it - `0b70h | n` became `((n-1)*2|1) << 4 | 0a06h`.

That is the sharpest x2/V.90 contrast in the whole tree, and it lands exactly
where Table 15/V.90 does: x2 controls the digital end's power with **one
boolean** whose only documented constraint is "legal only in some countries",
while V.90 controls it with a **numeric level on a half-dB ladder** - which
this firmware first exposed and then clamped per country.
