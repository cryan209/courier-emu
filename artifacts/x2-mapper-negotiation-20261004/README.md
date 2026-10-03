# Verified Quad PCM placement and six-position preparation

The stock QF060003 controller resolves the former conditional placement.
The seven overlay flat offsets were two bytes too early; the resident offset
was correct. No leading word is omitted by the downloader. A fresh run of
8,000,000 controller instructions reproduces all seven source copies in all
four modem RAM banks, with all 28 complete byte comparisons passing.
`placement-verification.json` records offsets, lengths and SHA256 values.
Reproduce with `.venv/bin/python tools/verify_quad_pcm_placement.py`.

The reusable map in `tools/probe_quad_pcm_codewords.py` is corrected, and the
server helper reconstruction was regenerated and passed its 6,562 cases.
The old extra leading codeword and EF00 selector output were extraction
artifacts, not valid mapping parameters.

## Received parameters and position controls

Original instructions and manual C agree in **13,504 cases**, with an
additional **128 integrated original-instruction contexts**:

| Check | Cases | Scope |
| --- | ---: | --- |
| C6E5 nonzero six-position count | 4,096 | Every 12-bit control word |
| C6F4 size distribution | 4,096 | Zero selects high byte, nonzero low byte |
| C92A descriptor expansion | 192 | Seeded candidate lengths and contents |
| C870 parameter unpacking | 512 | Random working records and flags |
| AB06 received-record transfer | 512 | TC set at entry; stops at AB2E |
| Received record to six banks | 4,096 | Every control combination; supplied candidates |
| C840 startup caller through C4AB | 128 | Original constructor, conversion and expansion |

AB06 transfers FF48/FF49 to 0340/0341 and FF4A/FF4B to E8F1/E8F2
in the tested PCM branch. C870 consumes six four-bit cells from the low
24 bits of the latter pair, high cell first. Each cell's low three bits
index `[0,1,2,1,0,3,0,3]`; its high bit is ignored. Results form six
two-bit controls. The last decoded cell supplies the least significant
control, consumed first by bank expansion. This is working-record order,
not established wire serialization.

The routine stores E8F2 bits 8..10 separately. Mode comes from 0340 bits
11..14; FFD9 bit 12 can force the stored mode to zero, but one scale lookup
retains the original mode. Meaning and units remain unresolved. When every
control is zero, it substitutes control word 0002 while keeping active
count zero. The C lift preserves that default state.

C92A expands banks at E8F4, E974, E9F4, EA74, EAF4, EB74, choosing source
0A60 for control zero or 0880 for nonzero. An odd control ORs 0100 into
each copied entry. Stored copy counts are last indices: 3 copies 4 words.
The flag's physical meaning is open.

## Constructor and its callers

C9BF chooses one nine-word constructor table by FFD9 bit 2:

```
A5 A7 AD AF B7 BD C5 CF E5
95 97 9D 9F A7 AD B5 BF D5
```

These are alternative constructor tables, not automatically the two
candidate sets consumed by C92A. The difference of hexadecimal 10 is a
codeword difference, not a verified amplitude ratio or companding law.

The 128 integrated contexts run the unmodified C840 caller, C9BF, C920,
C761/C777 and C92A until C4AB. They seed the second candidate, ninth-index
extra entries, level indices and levels. Checks establish constructor low
byte preservation, six size slots of 9, and final bank selection/flags.
They do not independently lift the intermediate level converter.
C761 processes nine entries while C92A copies ten with count 9; the extra
entry's full-call initialization and purpose remain open.

The 4,096 received-record pipeline cases execute transfer, unpacking and
expansion sequentially with prebuilt candidates. They intentionally skip
the intervening negotiated candidate builder. No complete negotiated
connection, payload mapper, alignment waveform, PCM law or receiver inverse
is claimed.

Run `.venv/bin/python tools/recover_x2_mapper.py` to regenerate the listing
and report. Tests use the corrected full overlay bytes without modifying
original program instructions. Negotiation framing and the historical
preamble-detector correction remain in `docs/x2-v90-protocol-selection.md`.
