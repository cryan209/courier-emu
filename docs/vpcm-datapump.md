# Where V.PCM lives, and why 7200 Hz was never the whole story

Overlay 8 is the V.90 datapump. It is identified by its own DIL descriptor, and
finding it also explains how a board whose codec is fixed at one rate runs a
modulation that needs another: there are two serial converters, not one.

## The identification

V.90's digital impairment learning has the analog modem send a Ja descriptor.
Its sign and training patterns are fixed by the standard, so they are a
signature. Both are in the flash, packed LSB-first, and both match bit for bit
across 66 bits:

```text
4234c  55 4b 2d b5 b4 d2 4a 2b 01   SP  101010101101001010110100101011010010110101001011010100101101010010
42356  00 21 84 10 22 84 10 42 00   TP  000000001000010000100001000010000100010000100001000010000100001000
42360  0a 0a 0a 0a 0a 0a 0a 0a      H1-8 = 10, 10, 10, 10, 10, 10, 10, 10
42368  00 00 00 00 00 00 00 00      REF all zero
```

The reference values are the user's own notes for the descriptor; the flash
contents above are what this image holds. H1-8 and REF follow immediately, in
the order the notes give them, which is what turns two pattern hits into a
descriptor block.

That block is inside **overlay 8**, at DSP program `e7d6`. The 3.0.13 board and
`IDSDL302.ROM` carry the same block in their own overlay 8, at `e599` - so x2
and V.90 were present in the older build too.

The training UCode sequence is not stored anywhere in any image, in bytes or in
either word order. It is generated rather than tabulated - and running the
generator confirms it, below.

## The assembler, and the descriptor it produced on the wire

Immediately after the field block, at program `e7e8`, is the code that builds
the descriptor:

```text
e7e8: ldp  #006
e7e9: lar  ar1, #0940      ; the build buffer
e7eb: splk *+, #00c5       ; N = 197
e7ed: splk *+, #4141       ; LSP-1 = 65 and LTP-1 = 65, packed as two bytes
e7f0: blpd *+, #e7d6       ; 5 words of SP
e7f3: blpd *+, #e7db       ; 5 words of TP
e7f6: blpd *+, #e7e0       ; 4 words of H1-8
```

So `N = 197`, `LSP = 66`, `LTP = 66`, and the patterns come straight out of the
block above.

That can be checked against the wire rather than left as a reading. The user's
V.90 DIL lab carries `COURIER_JA_HEX`, a 2058-bit Ja recovered from a capture of
this modem transmitting, with a valid CRC. Parsing it with that tool's own field
framing and comparing every field against this image:

| field | transmitted Ja | overlay 8 | |
|---|---|---|---|
| N / LSP / LTP | 197 / 66 / 66 | 197 / 66 / 66 | match |
| SP | 66 bits | `e7d6` | match |
| TP | 66 bits | `e7db` | match |
| H1-8 | 10 x8 | `e7e0` | match |
| REF | 0 x8 | `e7e4` | match |

Every field, from the ROM to the signal.

The raw recovered hex does **not** appear anywhere in the flash, and that is the
expected result rather than a contradiction: the wire format is framed, with a
zero bit ahead of each chunk of up to 16 payload bits and the H and REF entries
carried as 7-bit values between framing bits, while the ROM stores the patterns
unframed and LSB-packed. The framing, the training Ucodes and the CRC are all
added when the descriptor is assembled - which is what the CRC below is for.

## The four images, and which ones do I/O

| image | loads at | span | serial-port access |
|---|---|---|---|
| resident | `8000` | `8000..eea7` | `DRR` read x1 (the ISR), `DXR` write x4, **`TSPC` setup x2** |
| overlay 6 | `9d00` | `9d00..ce32` | **`DRR` read x32, `TRCV` read x4** |
| overlay 7 | `b000` | `b000..cd4a` | none |
| overlay 8 | `dc00` | `dc00..f94a` | none |

Overlay 8 touches no converter at all. It is pure algorithm, and it does not
overlap overlay 6, so the two are loaded together: **6 moves the samples, 8 runs
V.PCM on them.** Overlay 7 sits inside overlay 6's range, so those two are
alternatives.

## Two converters, which is the answer

The resident bank programs `TSPC` - the TDM serial port's control register - at
`808a`, and overlay 6 reads `TRCV`, that port's receive register. So this board
takes samples on **both** C5x serial ports: the primary one, where the
TLC320AC01 sits, and the TDM port.

That dissolves the contradiction recorded in
[codec-rate-312.md](codec-rate-312.md). The AC01's divider registers are written
once at reset and never again, and the dial path's DTMF pins that rate at
7200 Hz - both still true. Neither constrains the datapump, because the
datapump's samples need not come through the AC01 at all.

It also corrects [board-parts.md](board-parts.md) a second time. That document
says the 20.16 MHz builds "instead of the AC0x path... configure `TSPC`". It is
not instead: this build does both, and the two paths are the two halves of the
answer.

## What is hypothesis, and what is not

Established: the descriptor block and its location; which images do which I/O;
that both serial ports are set up and read; that the AC01's rate never changes.

Not established: **which converter carries which direction, and at what rate.**
V.90 is asymmetric - a PCM downstream at 8000 symbols per second, a V.34-like
upstream - so an obvious reading is that the TDM port carries the
8000 Hz-aligned receive path while the AC01 carries the analog side at 7200. The
counts are suggestive of a split (overlay 6 reads `DRR` 32 times and `TRCV` four
times, and no overlay transmits at all - every `DXR` write is in the resident
bank) but they are static site counts, not traffic. What actually sits on the
TDM port is also unestablished; the ASIC is the obvious candidate and this does
not demonstrate it.

## The CRC is in code, ahead of the modulator

The framing checksum is computed in software, bitwise, with the polynomial as a
literal - no table. The step at overlay 6 program `a4fa` is the whole method:

```text
a4f3: sfl              ; shift the data bit out
a4f4: lacl #00
a4f5: rol              ; rotate it into the low bit
a4f6: xor  @42         ; against the running remainder
a4f7: sfr
a4f9: xc   2, c        ; and if a one fell out...
a4fa: xor  #00008408   ;   ...fold in the polynomial
a4fc: sacl @42         ; store the remainder back
```

`8408` is CRC-16 CCITT reversed - the V.42 FCS polynomial, and the one V.34's
INFO sequences use. Every site in every image uses that one polynomial:

| image | sites | where |
|---|---:|---|
| board 3.1.2 | 4 | resident `9911`, `99e6`; overlay 6 `a4fa`, `b131` |
| board 3.0.13 | 4 | the same four, shifted |
| `main211` | 5 | - |

**Overlay 8 has none.** So the split holds on this axis too: overlay 6 carries
the framing - CRC, and the sample I/O - while overlay 8 is the V.PCM algorithm
alone. The CRC runs in the DSP rather than on the 80186, and ahead of the
modulator rather than in the supervisor's data path.

A caution about how these were found. Searching for the polynomial as a bare
constant is worthless here: `1021` is also the encoding of `lacc @21`, and it
turned up in the resident bank and in two overlays as exactly that. Only the
`xor #<poly>` opcode pair distinguishes a polynomial from an instruction, and
all four sites above are that pair.

## The 197 training Ucodes are arithmetic

They are not in the flash because the firmware counts them out. `courier_emu.vpcm`
runs the assembler in the C5x core and reads back what it wrote; all 197 match
the ladder in the captured Ja exactly.

The store is what disguises them. `e838` keeps `127 - value` and packs two per
word, low byte first, so nothing in the image ever looks like the ladder:

```text
e838: neg ; add #7f        ; keep 127 - value
e83a: bit 15, @7c          ; bit code 15 is bit 0 - the pack toggle
e83b: bcndd e841, tc
e83d: xpl  @7c, #0001      ; flip it every call
e83f: sacl *               ; first of a pair: park it
e841: sacl @7f             ; second: combine with the parked one
e844: add  @7f, 8          ;   low | (this << 8)
e845: sacl *+
```

The ladder itself is two counters:

| step | emits |
|---|---|
| `@7d` = 11, five times, incrementing | 116, 115, 114, 113, 112 |
| `@7d` = `10`, `@7e` = `7f`, sixteen pairs | 111, 0, 110, 1, ... |
| `@7d` = `20`, `30`, `40`, same `@7e` | three more blocks of sixteen pairs |
| `@7d` = `50`, `@7e` = `6f`, **twice** | 47, 16, 46, 17, ... repeated |

5 + 6 x 32 = 197, which is N. The last two calls take identical parameters,
which is why the captured ladder ends with the same 32 Ucodes twice - a detail
that reads as an oddity in the capture and as one duplicated instruction pair in
the ROM.

### A trap for anyone entering this code directly

The assembler reaches its buffer through `*`, which selects whichever auxiliary
register `ARP` names, not `AR1` - despite the `lar ar1, #0940` two instructions
earlier. Its real caller arrives with `ARP` already 1. Entering at `e7e8` without
setting it sends every store through `AR0`, and the run produces a descriptor
that is *almost* right: the ladder appears, but shifted, with its first Ucode
missing, because `banz *-, ar1` at `e807` sets `ARP` partway through. `vpcm.py`
selects `AR1` first, the way the firmware's own `mar *, ar1` does.
