# How the Quad loads C50 code

[`docs/x2/README.md`](x2/README.md) recorded that each Quad image has exactly
one call to its 80186-to-C50 downloader, no Courier-style x86 overlay table,
and no source-segment reference to the tail of the DSP payload — so the overlay
selection mechanism was "not yet decoded". This document decodes it. Addresses
are `QF060003`; `QR060103` is the same shape at shifted offsets.

## The supervisor loads the resident, and nothing else

The download transport is two 80186 I/O port pairs:

| Ports | Role |
| --- | --- |
| `0xc0` / `0xc2` | download data, one 16-bit word split low byte then high byte |
| `0x98` / `0x9a` | handshake — write `1`, poll bit 0; write `2`, poll bit 1 |

`0x93864` sets a destination word address (`AX` out to `0xc0`/`0xc2`, then a
`0xff56` PCB bit and a `0x98` sequence). `0x93904` is the downloader proper,
taking a source offset in `AX` and a byte length in `CX`, chunking eight words
at a time against `in al, 0x98` / `test al, 1`.

There is **exactly one** call to the downloader in the image, at `0x93810`:

```
93804  mov ax, 0x8000     ; destination program address
93807  call 0x93864
9380a  mov ax, 0           ; source offset
9380d  mov cx, 0xf450      ; byte length -- the resident, and only the resident
93810  call 0x93904
```

preceded at `0x9382a` by a preamble that sends eight words of `0x0083` to
destination `0xfff8`. So the supervisor pushes the resident bank to program
`0x8000` at boot and never pushes anything else. The overlay store at
`0xd3e00..0xdf910` is not sent this way.

## The resident plants its own fetch stub

At cold boot, sixteen words into its entry path, the resident builds three
words of code in low program memory:

```
8067  lacc  #23f0
8069  samm  @1f          ; BMAR = 0x23f0   (BMAR is MMR 0x1f, spru056d)
806a  lar   ar1, #82d6   ; source
806c  rpt   #02
806d  bldp  *+           ; program[BMAR++] = data[ar1++], three times
```

`BLDP` is "block move from data to program memory with destination address in
BMAR" (spru056d). The board's external RAM answers both program and data space
at `0x8000..0xfeff` — the window `courier_emu/dsp.py` already models — so the
source at data `0x82d6` is the resident's own image. The three words are:

```
23f0  1080  lacc  *
23f1  0880  lamm  *
23f2  ef00  ret
```

That is the host-word fetch, and it explains the `calld 23f0` that the main
loop makes to an address below the `0x8000` load origin: nothing is missing,
the resident writes that code itself before using it.

## The host link is the DSP I/O window, not data memory

The stub is called with `ar1` set in the caller's delay slot — `0xff57` in the
idle path, `0xff58` in the transfer loop. `lamm *` addresses a memory-mapped
register by the low seven bits of the auxiliary register, so those are **MMR
`0x57` and `0x58`**, inside the `0x50..0x5f` I/O window that
`native/c5x_core.cpp` already maps to board I/O.

This **corrects** a claim in [quad-dsp-pcm-path.md](quad-dsp-pcm-path.md): the
Quad's CPU-to-DSP link is not global data memory. It is the same DSP I/O window
the analog Courier's ASIC mailbox uses — ports `0x5e`/`0x5f` there
([dsp-cpu-interconnect.md](dsp-cpu-interconnect.md)), `0x57`/`0x58` here. That
is also why poking data address `0xff57` had no effect: the value never came
from data memory.

## The loader

With the stub planted, the overlay load at `0x82fc` is straightforward:

```
82fc  ldp   #1fe
82fd  lacl  @63          ; 0xff63 -- destination program address
82fe  samm  @1f          ; BMAR = it
82ff  lar   ar1, #ff58   ; the word-fetch port
8303  ldp   #000
8304  rptb  #8310
8306  calld 23f0, *      ; fetch one word from I/O 0x58
830b  sacl  @7d
830c  bldp  @7d          ; program[BMAR] = it
830d  lamm  @1f
830e  add   #01
830f  samm  @1f          ; BMAR += 1
```

So the destination is host-supplied per transfer and the words are pulled one
at a time through an I/O port. There is no static overlay table on either side
to find, which is exactly why looking for one failed.

The resident has 19 anchored `samm @1f` sites and six anchored `bldp` sites, so
this is a general facility used for several loads, not one special case.

## Confirmed by execution

Running the resident under `courier_emu.dsp.NativeC5x` and seeding DSP I/O:

| Seed | final `pc` | `SPC` writes |
| --- | --- | --- |
| none | `0x83aa` | 72 |
| `0x57 = 0x0200` | `0x83aa` | 72 |
| `0x57 = 0xffff` | `0x83aa` | 72 |
| `0x57 = 0x0200`, `0x58 = 0x0000` | `0x83aa` | 72 |
| `0x57 = 0x0200`, `0x58 = 0xef00` | **`0x0485`** | **8** |

Feeding `0xef00` (`ret`) on port `0x58` changes the run: execution reaches
`0x0485`, in the low program memory the loader writes to, and the port
initialisation settles in 8 writes instead of 72. Words taken from I/O `0x58`
are planted in program memory and executed. The mechanism works.

That is a demonstration, not a real overlay — a constant `ret` is not the
firmware's code. But it establishes the transport end to end.

## The supervisor's load table

There is a five-record table at `0x93ba6..0x93bcd` in `QF060003`. Records are
four words:

```
length in bytes | destination program address | third | 0x0000
```

It is identifiable because its **last record is the downloader call's own
arguments**: length `0xf450`, destination `0x8000` — literally the `mov cx,
0xf450` / `mov ax, 0x8000` at `0x93804`. That is the resident.

| Record | Length | Destination | Third |
| --- | --- | --- | --- |
| `0x93ba6` | `0x0cb6` (3,254 B / 1,627 w) | `0xc300` | `0x3784` |
| `0x93bae` | `0x15d6` (5,590 B / 2,795 w) | `0xc300` | `0x35c6` |
| `0x93bb6` | `0x0f18` (3,864 B / 1,932 w) | `0xd900` | `0x38e2` |
| `0x93bbe` | `0x08f2` (2,290 B / 1,145 w) | `0xc800` | `0x2000` |
| `0x93bc6` | `0xf450` (62,544 B / 31,272 w) | `0x8000` | `0x2f45` |

Every overlay destination — `0xc300`, `0xd900`, `0xc800` — lies **inside** the
resident's own span of `0x8000..0xfa28`. These are overlays in the strict
sense: they replace regions of the already-loaded resident. Two records share
destination `0xc300`, so those two are alternates for one slot, which is what a
modulation-per-overlay arrangement looks like.

This is the answer to the original question. Overlay selection is a table of
(length, destination) records on the supervisor side, and delivery is the
DSP-side `BLDP` pull described above — which is why searching for a
Courier-style overlay table reachable from a second downloader call found
nothing. There is no second downloader call, and the table is not adjacent to
the one that exists.

### What the table does not yet say

- **The third field is unidentified.** `0x3784`, `0x35c6`, `0x38e2`, `0x2000`,
  `0x2f45`. It is not a byte sum, word sum, word XOR, or CRC-16/X.25 (either
  parameterisation) of the corresponding region under the assumption that the
  four overlays follow the resident consecutively in the payload. So either it
  is not a checksum, or that layout assumption is wrong. Its values are all
  plausible low DSP program addresses, which makes an entry point the next
  hypothesis to test.
- **Each overlay's source offset is unknown.** The records carry no source
  field, and the consecutive-layout guess is unconfirmed.
- **The lengths do not account for the store.** The four overlays total
  `0x3a96` (14,998 bytes) against an overlay store of `0xbb10` (47,888 bytes).
  Roughly two thirds of the tail is something else — coefficient data, further
  tables, or records this one table does not cover.
- **The walker was not found.** No 16-bit immediate in the code region points
  at the table's address, so it is reached through a far pointer or a computed
  address. The table was located by its data signature, not by a cross
  reference.
- `QR060103` has the same downloader shape but its table was not located; an
  automated search for the same record signature returned a false positive.

## What remains

- The supervisor's side of the same conversation: which of its structures
  supplies the destination for `0xff63` and streams the bytes from
  `0xd3e00..0xdf910`. The downloader at `0x93904` is not involved, so this is
  separate code reachable from the `0x0042`/`0x0200` handshake group.
- The request and acknowledge protocol on ports `0x57`/`0x58`: bit 9 of `0x57`
  is tested as a ready flag, but seeding it alone does not advance the loop, so
  there is more handshake than one bit.
- Which overlay is chosen when, which is the original question and needs the
  supervisor side above.

## Matching the Quad's DSP code against the documented 302 overlays

[dsp-overlays.md](dsp-overlays.md) maps the analog Courier's four C5x images.
Read out of `IDSDL302.ROM` by `CourierRom.dsp_overlays`:

| id | flash offset | bytes | loads at |
| ---: | --- | ---: | --- |
| 5 | `0x29080` | 55,420 | `0x8000` (resident) |
| 6 | `0x369c0` | 23,020 | `0x9d00` |
| 7 | `0x3c2f0` | 14,998 | `0xb000` |
| 8 | `0x3fdd0` | 14,700 | `0xdc00` |

Comparing each against the whole `QF060003` DSP payload by 32-byte block
hashing, and localising where in the Quad payload the matches land:

| 302 image | shared blocks | % of that image | lands in |
| --- | ---: | ---: | --- |
| 5 resident | 13,003 | 23.7% | Quad **resident** (11,624) |
| 6 | 11,160 | **49.2%** | Quad **overlay store** (11,232) |
| 7 | 5,797 | **39.5%** | Quad **overlay store** (5,799) |
| 8 | 28 | **0.2%** | — |

Three things follow.

**The partitioning corresponds.** The 302's resident matches the Quad's
resident; the 302's overlays match the Quad's overlay store. Resident code sits
with resident code and overlay code with overlay code, so the two products
divide their DSP firmware along the same line. That is a stronger statement than
the string-level lineage in [quad-x2-modem-nac.md](quad-x2-modem-nac.md),
because it is C5x algorithm code rather than shared text tables.

**Overlay 8 is absent from the Quad.** 28 blocks out of 14,536 is noise.
[dsp-overlays.md](dsp-overlays.md) identifies overlay 8 as **the V.90 layer**
and overlay 6 as **the PCM core it runs beside** (citing
[codec-sample-rates.md](codec-sample-rates.md)). So the Quad carries the analog
Courier's PCM core and *not* its V.90 layer — even though the Quad's supervisor
string tables are full of V.90 result codes (`48000/ARQ/V90` and the rest). The
Quad does V.90; it does not do it with this DSP code.

**The equal-size coincidence is a coincidence.** 302 overlay 7 is 14,998 bytes
and the Quad's four table records total `0x3a96` = 14,998 bytes. Byte for byte
against the region immediately after the Quad resident they agree on 2.4%, so
the two numbers are unrelated.

### This says the load table is incomplete

The 302 overlay 6 matches span `0xd4166..0xdd767` in the Quad payload and the
overlay 7 matches reach `0xdf88b` — between them nearly the whole
`0xd3e00..0xdf910` overlay store, spread across it rather than confined to
`0x3a96` bytes of it. So the store holds substantially more overlay code than
the five-record table above describes, which is the same shortfall noted there,
now with positive evidence rather than arithmetic.

Either the table has rows my backward walk did not recognise, or there is more
than one table — plausibly one per line mode, given `%D0`/`%D1`/`%D2`.

### Limits

These are 32-byte block-hash overlaps, i.e. substantial shared code, **not**
identical images: at 39–49% the Quad's copies are a revision of the same
sources, not the same binary. Percentages are of the 302 side. And the
correspondence is between the 302's *named* overlays and the Quad's *store as a
whole* — it does not yet say which Quad record is the counterpart of 302
overlay 6, because the Quad records carry no source offsets.
