# Courier V.Everything Firmware Analysis — `SV25.XMD`

Analysis of the USRobotics Courier firmware image we've been testing against, to
support the V.90 interop effort (esp. the "Courier retrains to Tone A right after
our DIL, never sends CPt" blocker — see `courier-retrains-after-dil` memory).

## File facts

| | |
|---|---|
| File | `docs/SV25.XMD` |
| Size | 524,416 bytes = `0x80` header + `0x80000` (512 KB) image |
| Date | 1998-03-13 |
| MD5 | `872b9696eca7156ba22f1c874601b874` |
| Product | **USRobotics Courier V.Everything** (banner at file `0x263B7`) |
| Type | **SV = Supervisor** image, SDL/XMODEM-downloadable (`.XMD`) |

## Processors (confirmed by the modem's own `ATUSR` easter egg)

```
INT80188 Modem Functions      -> supervisor CPU = Intel 80188 (16-bit x86)
TMS32025 DSP Functions         -> datapump DSP  = TI TMS320C25 (16-bit fixed-point)
Copyright (c) 1988..1992 USRobotics
```

So `SV25.XMD` (minus the 0x80 header) is **exactly 0x80000 = 512 KB = the full
flash** — it contains BOTH the 80188 supervisor AND the TMS320C25 datapump.

## Image map

| file range | ~size | contents |
|---|---|---|
| `0x00000–0x00080` | 128 B | header: signature/checksum + `NHCFG` tag + `0x4A` fill |
| `0x00000–0x29800` | ~166 KB | **Intel 80188 supervisor** (x86-16 byte code) + string/resource tables |
| `0x08000–0x0C000` | ~16 KB | word-structured pockets (DSP tables / small overlay) |
| `0x29800–0x44000` | ~106 KB | **TMS320C25 DSP datapump** (16-bit words: code + tables + overlays) |
| `0x44000–0x7C000` | ~224 KB | `0x00` fill (unused) |
| `0x7C000–0x7E000` | ~8 KB | DSP coefficient table (int32, ~-774 default taps) |

Boundary is sharp: even/odd byte-distribution divergence (a word-vs-byte-code
discriminator) is ~0.4 in the 80188 region and jumps to **0.68–0.79** at exactly
`0x29800`. The C25 words are **big-endian** (high byte first). The DSP `B`/`CALL`
(`FF80`/`FE80`) targets are consistent 16-bit code addresses; several exceed the
region size, so the datapump is built as **multiple overlays** the supervisor
swaps in per phase (V.34 startup / V.90 / command). **The DIL-analysis and
constellation-design code — the logic that decides to send CP vs. abort to
retrain — is TMS320C25 code in `0x29800–0x44000`.**

## Format — NOT encrypted, NOT compressed

Initial entropy (~7.8) and poor gzip ratio (~83%) *looked* like compression, but
that's a red herring: the payload is **plaintext, uncompressed** code. The 80188
half is 16-bit x86; the high entropy comes from dense 5-byte far-calls
(`9A seg:off`) interleaved with tables, not a transform. Disassembly heuristics
(branch coherence) can't tell x86 code from data — 16-bit x86 is so dense that
even random bytes score as "coherent" — so region typing relied on the even/odd
word-structure metric above, not on disassembly.

Proof — disassembly at the banner-print site (file `0x263AF`):

```
0263af: 9a 41 9e 00 80   lcall 0x8000:0x9e41     ; far call into bank at seg 0x8000
0263b4: e8 6f 17         call  0x27b26           ; "print inline ASCIIZ" routine
0263b7: "USRobotics Courier V.Everything",0       ; inline string (call-then-db idiom)
0263de: a0 29 01         mov al,[0x129]          ; prints a 3-byte version as
0263e1: 9a d6 9d 00 80   lcall 0x8000:0x9dd6     ;   [0x129]:[0x128]:[0x127]
0263e8: 9a 13 16 00 80   lcall 0x8000:0x1613     ; print-char routine
```

### Layout
- `0x00000–0x00080` — 8-byte signature/checksum (`b7 f0 b2 fd d8 ec bc bd`) + `NHCFG` tag + `0x4A` fill
- `0x00080–0x44000` — active code + data + DSP tables (bank-switched x86)
- `0x44000–0x7C000` — `0x00` fill (unused)
- `0x7C000–0x7E000` — DSP coefficient table (see below)
- tail — mostly `0xFF`

### Quirks
- **Bank switching**: a 512 KB ROM can't fit one 64 KB segment. Near calls (`E8`)
  stay in-bank and disassemble linearly; far calls (`9A 8000:xxxx`) page into
  another bank. The bank→file mapping is **not yet solved** (naive `seg*16` and
  `+0x80` header offsets both fail), so cross-bank call resolution needs work.
- **String obfuscation**: some UI strings are stored **case-toggled** (XOR `0x20`
  on letters only) — e.g. credits at `0x100` read `jOHN wIERSEMA`. Others (the
  banner, diagnostics) are stored normal-case. To read reliably, per-run pick
  whichever of {identity, case-toggled} has more lowercase letters.

## Extracted content (confirmed)

### V.90 downstream rate table (file `0x019B02`) — the far-end DS0 rate grid
```
32 → 48000 bps   36 → 53333 bps
33 → 49333 bps   37 → 54666 bps
34 → 50666 bps   38 → 56000 bps
35 → 52000 bps   39 → 57333 bps
```
1333 bps grid — the exact rate codes the Courier maps for V.90 downstream.

### V.34 trellis code set (file `0x018D84`)
`8S-2D`, `16S-4D`, `32S-2D`, `64S-4D` trellis codes.

### x2 connect-result vocabulary (file `0x00AB80..0x00ADB0`)
The firmware has explicit USR x2 connect-rate strings, split across XOR-encoded
sub-blocks:

```
x2
41333/ARQ/x2
42666, 42666/ARQ, 42666/x2, 42666/ARQ/x2
44000, 44000/ARQ, 44000/x2, 44000/ARQ/x2
45333, 45333/ARQ, 45333/x2, 45333/ARQ/x2
46666, 46666/ARQ, 46666/x2, 46666/ARQ/x2
48000, 48000/ARQ, 48000/x2, 48000/ARQ/x2
49333, 49333/ARQ, 49333/x2
54666, 54666/ARQ, 54666/x2, 54666/ARQ/x2
56000, 56000/ARQ, 56000/x2, 56000/ARQ/x2
57333, 57333/ARQ, 57333/x2, 57333/ARQ/x2
64000, 64000/ARQ, 64000/x2, 64000/ARQ/x2
```

This confirms that the supervisor can report x2 as a distinct modulation/rate
label. A string scan did **not** find a separate `X2 Status` diagnostic comparable
to `V.90 Status`; x2 appears to reuse the normal last-call/link diagnostic
surfaces (`ATI6`, `ATI11`, and hidden `ATY*` tables) with x2-specific connect
result text.

### x2 / V.90 feature-gate and NVRAM evidence

There is static evidence for an installed-feature gate, not just unconditional
datapump support:

- XOR key `0x32` at file `0x1879D` decodes an S-register help entry:
  `S30` bit `1` = **`Enable feature upgrades`**.
- XOR key `0x32` at file `0x18EA6..0x18ED7` decodes the modulation-control
  help entries:
  - `S57` includes `V34+`, `V34`, and `VFC` bit labels.
  - `S58` bit `1` = **`x2`**.
  - `S58` bit `2` = **`BLER monitor`**.
- XOR key `0x64` at file `0x1C4A0` decodes:
  `Channel will not support 3200 baud.`
  `Channel is x2-capable but feature not installed.`
- XOR key `0x26` at file `0x07939..0x07953` decodes self-test vocabulary:
  `ram`, `nvram`, `dsp`, `testing`, `leds and speaker`, `ok`, `no communicate`.
- XOR key `0x26` at file `0x1C84D` decodes `NVRAM Sett.s`, confirming a
  user-visible NVRAM settings/report surface in the diagnostic text.

### Recovered `ATY14` source and feature decode

The `ATY14` handler is at `0x85250`. It prints `[0x0a0c]` down to `[0x0a07]`,
one byte per field, separated by commas, and falls back to the bare `,,,,,`
literal at `0x8525a` when `[0x0a06]` reads `0xff`.

Those seven bytes are written by the parameter-block unpack at `0x7e007`, which
copies bytes 0..6 of the accepted configuration record to `0x0a06..0x0a0c`. So
the printed fields are record bytes 6, 5, 4, 3, 2, 1, matching the field names
from the archived post:

| `ATY14` field | name | RAM | record byte |
|---:|---|---|---:|
| 1 | unused1 | `0x0a0c` | 6 |
| 2 | unused2 | `0x0a0b` | 5 |
| 3 | type1 | `0x0a0a` | 4 |
| 4 | type2 | `0x0a09` | 3 |
| 5 | **features** | `0x0a08` | 2 |
| 6 | country | `0x0a07` | 1 |

This corrects the guess above: on this firmware the configuration register dump
comes from the **memory-mapped parameter sector searched at `0xf8000`**, not from
the Microwire serial EEPROM bit-banged on port `0x10`. The unpack also feeds
`[0x0a07]` to `[0x0173]` (country), `[0x0a09]` to `[0x0a04]`, and `[0x0a0a]` to
`[0x0a03]`, each gated by a bit in the `[0x0a06]` flags byte.

Field 5 is decoded at `0x7e024` through a five-entry table at `0x7e072`:

| features bit | value | label | sets `[0x19d7]` |
|---:|---:|---|---|
| 0 | 1 | HST | `0x04` |
| 1 | 2 | Fax | `0x0a` |
| 2 | 4 | Terbo | `0x4a` |
| 3 | 8 | V.FC / V.34 | `0xca` |
| 4 | 16 | **V.90 on this firmware** | `0x6a` |

The table has exactly five entries, so this firmware recognises exactly five
feature bits. Bit 4 is real and decoded, and it is the only entry that
contributes `[0x19d7]` bit `0x20`.

**Bit 4 is not x2 here.** The archived post describing `ATY14` covers an older
Courier, and the label does not carry over to this 2002 build (the banner reads
`Copyright (c) 1988 - 2002 by USRobotics`). Two pieces of evidence:

- `0x77d47` tests `[0x19d7]` bit `0x20` to decide whether to append `,V90` to the
  `ATI7` options list. Building a sector with bit 4 set yields
  `HST,V32bis,Terbo,VFC,V34+,V90,V92`; clearing it yields
  `HST,V32bis,Terbo,VFC,V34+,V92`. `,V92` is emitted unconditionally.
- The options table at `733c:49c4` does contain an `x2` entry at `733c:49d6`,
  but `mov si, 0x49d6` does not appear anywhere in the image. Nothing can ever
  select it, so this firmware cannot report x2 at all. The x2 connect-rate
  vocabulary catalogued above is dead weight carried forward from older builds.

`0x82e7d` tests the same `[0x19d7]` bit `0x20` to select the product code
reported by `ATI`/`ATI0`, so that code tracks V.90, not x2:

| `[0x19d7]` bit `0x20` | EEPROM fitted | `ATI` |
|---|---|---|
| set | yes | `5608` |
| set | no | `5608A` |
| clear | yes | `3368` |
| clear | no | `3368A` |

Confirmed in the emulator with a synthesised parameter sector: features `031`
gives `ATI` = `5608` and an options list including `V90`, while features `015`
gives `3368` and drops `V90`.

### Parameter sector layout beyond the first seven bytes

The whole accepted record is copied to `0x0a06` one-for-one, so record byte *i*
lands at `0x0a06 + i`. Only bytes 0..6 are unpacked into the named fields above;
the rest is a packed configuration image.

Bytes `0x1d..0x2f` (RAM `0x0a23..0x0a35`) are expanded at `0x64044` into the
profile bytes `0x0932..0x0955`. The unpacker walks a `(shift, mask)` control
table at `0x63f8d`, storing `(source >> shift) & mask` per field and advancing to
the next source byte whenever `shift` is zero. That is 36 fields across 19 source
bytes. Notably:

```text
src+5 >> 4 & 0x0f -> [0x0940]
src+5 >> 0 & 0x0f -> [0x0941]
```

`[0x0941]` is a **test-mode selector**. `0x5bc57` and `0x5bc8d` compare it
against 6, and anything `>= 6` takes `ljmp 0x7a59:0000` into a diagnostic
dispatcher that selects a handler by `([0x0941] - 6) * 2` and then loops on
`call [0x1fbc]` forever. It never returns to the normal boot path.

This explains an easy trap when synthesising a parameter sector: filling the
record with `0xff` makes `[0x0941]` unpack to 15, so the firmware enters test
mode 9 and appears to hang in the rate module at `0x7abaa`. The two spin loops
there wait on `[0x1fe7]` (which mirrors port `0x14` bit `0x01`, inverted) and
`[0x1fe8]` (set by events 3 and 9 at `0x7a64e`), and they have complementary exit
conditions, so no static input frees both. The firmware is behaving correctly;
the record is wrong. A sector whose packed config decodes to sane values boots
straight through to the main loop.

Interpretation: x2 is controlled by a persistent settings/feature path. `S58`
looks like the runtime modulation mask, while `S30` looks like the bit that
allows feature-upgrade handling. The message "x2-capable but feature not
installed" is the strongest sign that some Courier hardware/line state can be
recognized as capable but held back by an installed-feature flag, loaded from the
parameter sector into the supervisor's settings block at boot as traced above. A literal unlock-key
string or key-entry prompt has **not** been found in the firmware image yet.

Live-command evidence: `ATY14` returns a compact six-field configuration-register
dump:

```text
unused1,unused2,type1,type2,features,country
```

This fits the static evidence above better than treating `ATY14` as a last-call
counter report. On a 03/13/98 US/Canada external unit with `ATI7` options
`HST,V32bis,Terbo,VFC,V34+,x2,V90`, `ATY14` reports:

```text
000,000,030,007,031,000
```

Fields 3 and 4 (`030,007`) are the product type, matching the `ATI7` product
profile. Field 5 is the `ATC8` protocol-availability byte. On this unit it is
`031` decimal (`0x1F`), meaning HST, fax, Terbo, V.FC/V.34, and x2 are enabled.
V.90 is reported by `ATI7` on this firmware but is not a separate documented
`ATC8` bit in this older mapping. Confirmed `ATC8` feature bits:

| bit | value | meaning |
|---:|---:|---|
| 0 | 1 | HST |
| 1 | 2 | Fax |
| 2 | 4 | Terbo |
| 3 | 8 | V.FC / V.34 |
| 4 | 16 | x2 |

Field 6 is the country code. On this unit it is `000`, matching US/Canada.

Archived field-upgrade notes found by Scott give this sequence for older Courier
firmware:

```text
ATY14        ; note the country/config string
ATGN         ; enable config changes
ATC10=0      ; US/Canada country code
ATC8=31      ; enable x2
ATNX         ; save changes
```

This maps very cleanly onto the observed `ATY14` string, even though the write
commands themselves have not been confirmed on the 03/13/98 image:

- `ATC10=0` matches field 6 (`000`) and the decoded country table, whose first
  entry is `US/Canada` at approximately flash `0x20480..0x20520`.
- `ATC8=31` matches field 5 (`031`). The same post says `ATC8=15` disables x2,
  confirming bit `0x10` as the x2 bit in that config word. This does not have to
  be the same bit numbering as the runtime
  `S58` modulation mask, where the help text labels bit `1` as `x2`.
- Literal scans found no clean `ATGN`, `ATNX`, `ATC8`, or `ATC10` strings. That
  is consistent with the tokenized command parser, but it also means these
  write/config verbs may be absent or differently gated on this firmware.

Safety: treat `ATGN`, `ATC8=...`, `ATC10=...`, and `ATNX` as NVRAM/country
write commands. Do not run them on a known-good interop unit without a sacrificial
modem or a full NVRAM/flash recovery plan. Read-only captures of `ATY14`,
`ATI7`, `ATS30?`, `ATS57?`, and `ATS58?` are safe and should be enough to compare
installed-feature state across units.

Capture `ATY14` with `ATS30?`, `ATS57?`, and `ATS58?` on every unit:

```text
ATS30?   ; feature-upgrade enable bit lives here in help text
ATS57?   ; V34+/V34/VFC modulation mask
ATS58?   ; bit 1 = x2, bit 2 = BLER monitor in help text
ATY14    ; compare field 5 with the feature/modulation state
```

If the 5th `ATY14` field changes across units or NVRAM profiles while the firmware
image is the same, it is the confirmed protocol-availability byte that gates
HST/fax/Terbo/V.FC/V.34/x2 availability. The diagnostic bundle now records these
S-registers before `ATY14`.

Formatter/handler hunt:
- `ATY14` is not stored as a literal command string (`Y14`, `y14`, and `ATY14`
  do not appear in the image), matching the tokenized `AT` parser model.
- The visible accepted-Y command set from live probing
  (`0..6,8,9,11,12,14,15,16,17`) does not appear as a simple bitmap
  (`0x03DB7F`) or byte sequence in raw flash.
- A direct search for a static comma-separated formatter (`mov al,','` followed
  by the known resident character-output far call) did not find a candidate in
  the visible supervisor body. The two direct calls to resident output helpers
  found so far are in the banner/version formatter.
- Current interpretation: the `ATY14` producer exists in code, but it is probably
  selected by the resident/banked command dispatcher or by an encoded diagnostic
  table interpreter. To pin the exact routine, the next dynamic watchpoints are
  the resident character-output helper and the bytes/words whose decimal values
  become `000,000,030,007,031,000`.

### Link-diagnostic vocabulary — the ATI6/ATI11-style readouts (file `~0x01CC00`)
```
V.90 Status                 (file 0x01C38D)
Far Echo Loss ... dB
Roundtrip Delay ... msec
Timing Offset ... ppm
Carrier Offset ... ppm
RX Upshifts / RX Downshifts
Constant Carrier / Carrier Usage
```
**This is the most immediately useful find** — see "How this helps the blocker".

### DSP coefficient table (file `0x7C080`)
Little-endian int32, mostly `-774` repeated, then `-781, -1087, -915, -901, ...` —
fixed-point constants loaded into the datapump DSP (default/init taps).

### Other
- Country/config list: US/Canada, Japan, Finland, Sweden, UK, Norway,
  Switzerland, Netherlands, South Africa, Italy, New Zealand, Czechoslovakia,
  Belgium, Denmark, Australia, France, Germany, International, Austria, Ireland.
- "Lowest Speed Limit", "SDL Xmodem file transfer — (Y)es (N)o (T)est", reset/dial UI
- Developer credits (`0x100`): John Wiersema, Glenn Bushey, Kevin Lacey,
  Brinn Gilbert, Doug Blatt, Art Johnson, Pete Jankus, Bill Pierce, Ken Starkey, Joe F…
- Version is printed at runtime from RAM `[0x127..0x129]` as an X:Y:Z triplet
  (not a literal string in-image; set during init).

## Architecture summary

- **Supervisor**: Intel 80188 (16-bit x86). Uncompressed, plaintext, disassemblable
  as x86-16 — handles AT/S-registers, protocol sequencing, status/diagnostic
  displays, and DSP overlay loading. Occupies `0x0–0x29800`.
- **DSP datapump**: TI TMS320C25, big-endian 16-bit words, at `0x29800–0x44000`
  (~106 KB) plus tables at `0x08000–0x0C000` and `0x7C000`. Confirmed executable
  (sane `B`/`CALL` targets), organized as multiple overlays. **This is where DIL /
  constellation / retrain logic lives.** capstone has no C2x support — needs a
  TMS320C2x disassembler (hand-rolled Python, or IDA's TMS320C2x processor module,
  or a Ghidra C2x SLEIGH module).

### DSP-supervisor mailbox/status handoff

The strongest concrete handoff found so far is a supervisor x86 reader block at
file `0x13D00` (payload/flash `0x13C80`). It reads 16-bit words from the DSP with
the high byte on I/O port `0x5E` and the low byte on I/O port `0x5C`, then stores
them into a small RAM status cluster:

```asm
13d00: in   al,0x5e   ; high byte
13d02: mov  ah,al
13d04: in   al,0x5c   ; low byte
13d06: mov  [0x0b2f],ax
13d09: ret

13d0a: in   al,0x5e
13d0c: mov  ah,al
13d0e: in   al,0x5c
13d10: mov  [0x0304],ax
13d13: test byte [0x033f],0x04
13d18: je   0x13d2d
13d1a: mov  ax,[0x0304]
13d1d: shr  ax,0x0a
13d20: and  ax,0x0007
13d23: mov  bx,ax
13d25: mov  ax,0x0006
13d28: sub  ax,bx
13d2a: mov  [0x0b26],al
13d2d: mov  byte [0x0b28],0x01
13d32: ret

13d33: ... -> [0x0306], sets [0x0b28]=1
13d42: ... -> [0x0308], sets [0x0b27]=1, [0x0b28]=0
13d56: ... -> [0x030a], sets [0x0b27]=1, [0x0b28]=0
13d6a: ... -> [0x030c], sets [0x0b27]=1, [0x0b28]=0
```

`[0x0B2F]` is confirmed as the raw V.90 status word used by `ATI11`: the formatter
at file `0x1C3B0` takes `([0x0B2F] >> 8) & 7`, special-cases value `1` to value
`8` when `[0x089D] & 0x20` is clear, and indexes the V.90-status string pointer
table at logical `CS:0x517E` (physical file `0x1C3DE`).

The likely rate/shift bucket is the DSP word stored at `[0x0304]`, because the
supervisor derives `[0x0B26] = 6 - (([0x0304] >> 10) & 7)` when `[0x033F] & 4` is
set. A direct raw-flash xref search found only this write/derivation path; no
simple `mov al,[0x0B26]` or direct read of `[0x0304]` by a formatter was found.
So `[0x0304]/[0x0B26]` is a strong candidate for the DSP's speed/rate-status
handoff, but the final consumer probably runs through the encoded diagnostic
table interpreter or a banked overlay, not a trivial inline formatter.

## How this helps the "retrain after DIL" blocker

The retrain-vs-send-CP decision is split:
- **Protocol sequencing / status** → supervisor (disassemblable, reachable).
- **DIL analysis + constellation design** (the part likely *rejecting* our DIL)
  → DSP datapump (harder to reach).

**Immediate, no-further-RE win:** the diagnostic vocabulary above means the
Courier reports its *own* measurement of our downstream signal. During a live
attempt, `ATI6` / `ATI11` (and the "V.90 Status" display) expose **Timing Offset
(ppm)**, **Carrier Offset (ppm)**, **Roundtrip Delay**, **Far Echo Loss**, and
**Up/Downshift** counts right up to the moment it bails. That distinguishes:
- a **timing/carrier-offset** problem → points back at our clock recovery / DPLL
  (`clock_recovery.c`) and RTP sample-rate accuracy, vs.
- a genuine **constellation/impairment** rejection of our DIL.

### Confirmed useful AT diagnostics on our 03/13/98 Courier units

Probe run, 2026-07-26, against `/dev/cu.usbserial-21210`:

| Command | Result on 03/13/98 US/Canada Courier | Interop value |
|---|---|---|
| `ATI6` | supported | Last-call counters, retrain/BLER/link timeout counts, disconnect reason. |
| `ATI7` | supported | Firmware identity: 03/13/98 supervisor `7.3.14`, DSP `3.0.13`, 20.16/25 MHz split. |
| `ATI11` | supported | Extended physical diagnostics: modulation, carrier/symbol rate, levels, SNR, echo loss, round-trip delay, timing/carrier offset, V.90 status. |
| `ATY8` | supported, hidden from `AT$` | Verbose `00:`..`FF:` diagnostic table. Empty while idle; likely a byte-indexed datapump/stat table worth capturing after failed V.90 training. |
| `ATY11` | supported | Frequency/level curve from the last call. Empty until a call has populated channel-probe state. |
| `ATY12` | supported | 16-row `Recv`/`Xmit` table. Meaning is undocumented here; capture it for correlation with speed-shift and V.90 status changes. |
| `ATY14` | supported | Six-field config-register dump: `unused1,unused2,type1,type2,features,country`. Field 5 is the `ATC8` protocol-availability byte (`031` on x2-enabled unit); field 6 is country (`000` = US/Canada). |
| `ATY15` | supported, hidden from `AT$` | Current physical DIP-switch state. Not per-call, but useful provenance when comparing units. |
| `ATY17` | supported, hidden from `AT$` | Verbose 16-bit diagnostic matrix. Empty while idle; likely datapump/state memory worth capturing after failed V.90 training. |
| `ATY4DT<number>` | supported | Diagnostic dial form. Prefixing `Y4` to `DT<number>` emits call-progress dumps during dialing/training. Use `tools/cx_at.py usry4dial <number>`. |
| `ATY0`..`ATY6`, `ATY9`, `ATY16` | `OK` with no report body | Accepted by the Y dispatcher but mostly not useful while idle; `ATY4` becomes useful when appended to a dial command as `ATY4DT<number>`. |
| `ATY7`, `ATY10`, `ATY13`, `ATY18`..`ATY20` | `ERROR` | Not implemented on this firmware. |
| `ATI16`, `ATI17` | `ERROR` | Newer Courier 56K Business docs alias these to support connection reports, but this 1998 V.Everything firmware does not implement them. |
| `AT+MS=?`, `AT+MS?`, `AT+GMM`, `AT+GMR`, `AT&V`, `ATI8`, `ATI9`, `ATI12`..`ATI14`, `ATI18`..`ATI20` | `ERROR` | Do not rely on generic later-Hayes diagnostics for these units. |
| `ATUSR` | `ERROR` on `/dev/cu.usbserial-21210` | The credits/proc strings are present in the image, but this unit did not expose the previously reported easter-egg command in command mode. |

Run the post-call bundle before `ATZ` or power-cycling the analogue modem:

```bash
./.venv/bin/python tools/cx_at.py --dev /dev/cu.usbserial-21210 usrdiag
```

For one-off deeper captures, especially immediately after the Courier retrains
instead of sending CPt, also run:

```bash
./.venv/bin/python tools/cx_at.py --dev /dev/cu.usbserial-21210 usrdeepdiag
```

To capture the Courier's call-progress diagnostic dump during the dial/training
itself, use the `ATY4DT<number>` form:

```bash
./.venv/bin/python tools/cx_at.py --dev /dev/cu.usbserial-21210 usry4dial 6001 --wait 120
```

For a failing V.90 attempt, the minimum evidence to preserve is:

- `ATI6` disconnect reason plus `Retrains Requested/Granted`, `Blers`, and
  `Link Timeouts`.
- `ATI11` `Timing Offset`, `Carrier Offset`, `Roundtrip Delay`,
  `Recv/Xmit Level`, `SNR`, `Near/Far Echo Loss`, and raw `V.90 Status`.
- `ATY11` frequency-level slope/notches.
- `ATY12` raw table and `ATY14` config string. Compare `ATY14` field 5 across
  units because it is the confirmed `ATC8` protocol-availability byte.
- `ATY8`/`ATY17` raw tables when running a deep capture; if they become non-zero
  only after a failed call, diffing idle vs. post-call output may identify the
  datapump reject reason path.

External cross-checks:
- Official USRobotics Courier command reference documents `ATI11` as the
  extended link screen and newer `ATI16`/`ATI17` as connection reports, but our
  firmware predates those aliases.
- Archived USR support discussions use `ATY11` after failed V.90 calls as the
  frequency-curve display, matching the command's output on our unit.

Firmware/string-scan evidence:
- Help/S-register vocabulary is concentrated around flash `0x18000..0x1A200`,
  including the V.34/V.90 control bits in `S54`..`S58`.
- The `ATY14` country-code table is visible around flash `0x20480..0x20D00`.
  Known order from Courier command references and static confirmation:
  `0=US/Canada`, `1=Japan`, `2=Finland`, `3=Sweden`, `4=UK`, `5=Norway`,
  `6=Switzerland`, `7=Netherlands`, `8=South Africa`, `9=Italy`,
  `10=New Zealand`, `11=Czechoslovakia`, `12=Belgium`, `13=Denmark`,
  `14=Australia`, `15=France`, `16=Germany`, `17=International`, `18=Austria`,
  `19=Ireland`.
- The extended V.90 status strings are at flash `0x1C30D` and `0x1CB88..0x1CBDF`
  (`V.90 Status`, `Far Echo Loss`, `Roundtrip Delay`, `Timing Offset`,
  `Carrier Offset`, `RX Upshifts`).
- The V.90 downstream rate grid is at flash `0x19A82`.
- The firmware-loader prompt `SDL Xmodem file transfer - (Y)es (N)o (T)est` is
  at flash `0x27CBB`, confirming a hidden firmware-update path entered with
  `AT~X!`. Treat that command as dangerous; do not invoke it during diagnostics.
- The visible `AT$` help does not list a plain `Y` command family, but live
  probing shows a numeric `ATY<n>` dispatcher. `ATY8`, `ATY15`, and `ATY17`
  are the new useful hidden surfaces from this pass.

## Container format (SDL/XMODEM download)

`524416 = 4097 × 128` — exactly 4097 XMODEM blocks. Block 0 (`0x00–0x80`) is the
SDL download header (checksum bytes + `NHCFG` tag + `0x4A` fill). The remaining
4096 blocks are the 512 KB flash image. **flash offset = file offset − 0x80.**
Send this file only after entering the Courier SDL loader with `AT~X!`.

## SDL/XMODEM firmware loader reversal

**Command entry:** public update instructions and firmware strings identify the
loader command as **`AT~X!`**. Do not use plain `ATXMODEM`; that was earlier
shorthand in these notes, not the command accepted by the Courier update path.
The command is destructive after confirmation.

**Other `AT~` commands:** none found so far. A full payload scan finds exactly
one clean, NUL-terminated tilde command token, `~X!`, at flash `0x7C14D`
(file offset `0x7C1CD`). Other raw `0x7E` occurrences that look superficially
command-like, such as `~N`, `~0H`, and `^~!U`, are embedded in dense code/table
regions and do not have the surrounding loader-command structure. No literal
`AT~` strings are present, which is normal because the parser stores only the
post-`AT` command token.

**AT parser / ERROR path anchors:**

- The normal command processor does not store commands as literal `AT...`
  strings. It appears to tokenize after `AT` and dispatch by command family.
- A likely `AT` entry recognizer is at flash `0x29380`:
  - `cmp al,0x41` checks for `A`; on match it writes `0x1864` to runtime word
    `[0x50]`, probably selecting the next parser state.
  - The following state at flash `0x293B8` reads the current input byte from
    `SS:[0xFF76]` / `SS:[0xFF78]`, uppercases it with `and al,0x5F`, then
    `cmp al,0x54` checks for `T`.
  - On `T`, it writes runtime words `[0x50]=0x1967` and `[0x54]=0x0385`,
    consistent with entering the post-`AT` command parser. On non-`T`, it writes
    `[0x50]=0x190B`, consistent with rejecting the `A...` prefix or returning to
    non-command input handling.
  - Both paths finish by writing `0x8000` to `SS:[0xFF02]` and `iret`, so this
    looks like an interrupt/state-machine input path rather than a linear
    subroutine.
- The result-code text table is XOR-encoded with key `0xB0` at flash
  `0x0A490`: `OK`, `CONNECT`, `RING`, `NO CARRIER`, `ERROR`, `1200`,
  `NO DIAL TONE`, `BUSY`, `NO ANSWER`, etc. `ERROR` starts at flash `0x0A4AB`.
  This is the likely final output table used when a command handler rejects a
  token or falls through.
- The `AT$` help/category vocabulary is separately encoded. One decoded anchor
  is flash `0x1773E` with XOR key `0x3D`, which includes:
  `Result Codes`, `Speaker`, `Responses`, `Register`, `Command`, `Time`,
  `Dial`, `Wait`, `Tone`, and `Test`. This looks like help text, not the parser
  table itself.
- A raw-code search for `cmp al,0x7E` found one real-looking routine at flash
  `0x16345`, but that path treats `0x7E` as a protocol flag byte and returns
  carry/clear. It is probably V.42/HDLC flag handling, not an `AT~` dispatcher.
- The parser state writes are real, but the consumer is not a trivial direct
  indirect call in the raw flash image. Searches for `call/jmp [0x50]`,
  `call/jmp far [0x50]`, and the same forms for `[0x44]`/`[0x54]` found no
  hits. Additional direct state-slot writes seen in nearby supervisor code:
  `[0x50]=0x1892` / `[0x54]=0x19CE`, `[0x50]=0x0F23` / `[0x54]=0x0F1C`, and
  `[0x50]=0x08A7` / `[0x52]=0x9EB0`. That pattern makes `[0x50]`/`[0x54]`
  look like scheduler/parser-state slots rather than a single static command
  jump table. The dispatcher is probably in resident RAM or a banked overlay.
- The recovery loader uses its own internal address model. Its bootstrap begins
  at flash `0x7DBC0` and refers to internal offsets such as `0x1B14` and
  `0x1BA4`; when reversing that copy, use `internal offset = flash - 0x7C000`.

**User-visible state machine, reconstructed from strings:**

1. `AT~X!` enters the loader and prints:
   `SDL Xmodem file transfer - (Y)es (N)o (T)est >`
2. `N` cancels.
3. `T` enters a non-flashing verification path and prints:
   `* Test mode - Flash ROM will not be modified *`
4. `Y` or `T` then prints:
   `Begin Xmodem file transfer now.`
5. The modem receives a 128-byte-block XMODEM stream.
6. On transfer completion it prints:
   `SDL Xmodem file transfer completed.`
7. It prints `Resetting modem...`, then `Calculating CRC...`.
8. If image validation passes it prints `OK` and resets; if validation fails it
   prints `failed.` or, in the recovery path, `Flash ROM failure.`

**Two loader string/code copies are present:**

| flash offset | evidence | role inference |
|---|---|---|
| `0x27CBB` | plain `SDL Xmodem file transfer`; surrounding status strings partly plain and partly XOR-encoded with key `0x69` for transfer/test/CRC text and key `0x72` for corrupted-firmware text | Normal supervisor command-mode loader. |
| `0x7C14D` | literal `~X!` token, followed by another `SDL Xmodem file transfer` copy at `0x7C1DB`; status strings XOR-encoded with keys `0x29` and `0x65` | Recovery/resident loader copy, probably used when the main firmware checksum fails. |

Decoded normal-loader status strings:

| flash offset | XOR key | decoded text |
|---|---:|---|
| `0x27CFB` / `0x27D02` | plain prefix, then `0x69` | `Resetting modem...` |
| `0x27D11` | `0x69` | `Calculating CRC...` / `OK` / `failed.` |
| `0x27D35` | `0x69` | `* Test mode - Flash ROM will not be modified *` |
| `0x27D66` | `0x69` | `Begin Xmodem file transfer...` |
| `0x27D8E` | `0x72` | `MODEM FIRMWARE IS CORRUPTED. FIRMWARE DOWNLOAD IS NECESSARY.` |
| `0x27DD0` | `0x72` | `Flash ROM failure.` |

Decoded recovery-loader status strings:

| flash offset | XOR key | decoded text |
|---|---:|---|
| `0x7C20C` | `0x29` | `completed.` |
| `0x7C219` | `0x29` | `Resetting modem...` |
| `0x7C231` | `0x29` | `Calculating CRC...` / `OK` / `failed.` |
| `0x7C255` | `0x29` | `* Test mode - Flash ROM will not be modified *` |
| `0x7C286` | `0x65` | `Begin Xmodem file transfer now.` |
| `0x7C2AE` | `0x65` | `MODEM FIRMWARE IS CORRUPTED. FIRMWARE DOWNLOAD IS NECESSARY.` |

**File/container facts from `SV25.XMD`:**

- File length is exactly `0x80080` bytes: one 128-byte SDL header plus one
  512 KiB flash image.
- XMODEM itself is not embedded in the file; a terminal sends each 128-byte file
  chunk wrapped in standard XMODEM framing.
- The first block starts with bytes
  `b7 f0 b2 fd d8 ec bc bd 4b 1f 37 13 ca 4a 4a 4a`, then `NHJ`, `NHCFG\r`,
  then `0x4A` fill to the end of the 128-byte block.
- The 512 KiB payload begins immediately at file offset `0x80`.
- Obvious checks did **not** match the first header words: byte sum, 16-bit word
  sum, CRC-16/XMODEM, CRC-16/CCITT-FALSE, CRC-16/X.25, CRC-16/KERMIT, CRC-32,
  and complemented variants over the header, payload, active `0x00000..0x44000`
  range, supervisor range, recovery range, and DSP range. The loader's
  `Calculating CRC...` therefore appears to use a USR-specific CRC/checksum or a
  non-obvious region map rather than a simple whole-file CRC.

**Safety:** `AT~X!` should never be sent during normal diagnostics. If absolutely
necessary, `T` appears to be a test/no-flash path, but it still enters the loader
and waits for an XMODEM transfer, so use it only on a sacrificial unit or when
actively reversing the loader.

## 80188 memory architecture — the blocker for reading resident/overlay code

Tooling built and working:
- **`c25dis.py`** (scratchpad) — faithful port of MAME's TMS320C25 disassembler
  (Tony La Porta table). Big-endian words. Verified correct.
- x86-16 **Capstone** disassembly installed locally under
  `/private/tmp/capstone-py`, plus recursive-descent from the confirmed banner
  code — follows only real control flow (avoids the "x86 decodes anything" trap).

What the recursive descent established:
- The banner code (flash `0x26337`) runs **from flash** and makes far calls to a
  **resident code segment `0x8000`** (26 distinct target offsets `0x0A2C…0xF42C`,
  ~47 call sites). There is **no per-call bank-select `OUT`** before them.
- `segment 0x8000` does **not** map linearly to flash `0x0`, `0x10000`, … (every
  base tried yields garbage at the known routine offsets). Combined with the spec
  ("512K Flash, **64K RAM**"), the model is: **segment `0x8000` = the 64 KB RAM**,
  into which resident code is copied from flash by bootstrap/bank code assembled
  from multiple flash sources, not one contiguous copy.
- Hardware interface seen in real code: immediate `IN` from ports **`0x19`, `0x3E`**;
  `OUT` via `DX` at flash `0x26390/0x2D690`. Candidate DSP/UART/mailbox ports.

New bootstrap anchors from the loader pass:
- Normal/supervisor-looking startup island at flash `0x295DC` (likely logical
  offset `0x15DC` in a `0x28000` bank): zeroes `DS`/`ES`/`SS`, sets `SP=0x00F8`,
  writes `[0xFFA8]=0x00FF`, then emits 36 `OUT DX,AX` setup writes from
  `CS:[0x1A50]`.
- Recovery-loader startup at flash `0x7DBC0` (logical offset `0x1BC0` in the
  `0x7C000` recovery bank): same register setup, 36 `OUT DX,AX` writes from
  `CS:[0x1B14]`, then 9 byte-wide setup writes from `CS:[0x1BA4]`.
- The recovery setup table has a strong obfuscation/bus-decode hint: XORing the
  first 27 records with `0xA1` yields plausible 80188-style internal control
  writes such as `0xFF32=0x007E`, `0xFFA4=0x8000`, `0xFF60=0x801B`,
  `0xFF64=0x0021`, and `0xFF56=0x00DB`. That does not prove the CPU sees decoded
  values, but it is a useful bank/alias hypothesis. The raw code falls through
  into bytes that are not stable x86, so some combination of bank switching, bus
  decode, and/or copied RAM image is still missing from the static view.

**Why we're still blocked:** to disassemble the resident routines (`8000:xxxx`) or
the DSP overlay loader, we need the runtime flash→RAM/overlay address mapping. The
80188 reset vector is **not** at file `0x80070` (flash `0x7FFF0`, top-mapped) as
expected — it's not a standard `EA` far jump there. The flash is bank-switched /
stored in non-linear order at coarse granularity, and the bootstrap setup appears
to change the visible code/data mapping before it reaches the resident body.

## Emulation feasibility

**Feasible, but scope-dependent.**

- **Recovery SDL loader emulation is the best first target.** It is compact,
  has a confirmed bootstrap at flash `0x7DBC0`, has a known command token
  (`~X!`), and only needs serial/XMODEM, flash-write, CRC/checksum, and a small
  80188 I/O-register model. This should be tractable with Unicorn or a small
  8086/80188 interpreter once the bank switch after the setup writes is modeled.
- **AT-command-surface emulation is feasible after the resident image is
  reconstructed.** We already have the `A`/`T` input-state anchors and the result
  code table, but the real post-`AT` dispatcher appears to run through
  `[0x50]`/`[0x54]` scheduler slots in resident RAM or a banked overlay. The first
  useful emulator would feed bytes through the input interrupt path, stub
  `SS:[0xFF76]` / `SS:[0xFF78]` / `SS:[0xFF02]`, and trap output-result routines.
- **Full modem emulation is a larger project.** That means 80188 + TMS320C25,
  banked flash/RAM, DSP program/data overlays, serial/UART, DAA/line-side
  hardware, and timing-sensitive mailbox behavior. It is possible, but it is not
  the shortest path to interop diagnostics.

Practical next step for emulation: build a focused loader harness, not a full
machine. Hook `IN`/`OUT`, log the 80188 setup writes, implement enough bank aliases
to get past the bootstrap, and stop on serial-output calls. If that reaches the
`SDL Xmodem file transfer` prompt, the same harness can be extended to the AT
parser.

## Recovered C52 line-audio interface

Instruction- and data-flow tracing corrects the initial on-chip-serial
hypothesis. The modem/DAA waveform is carried by a Courier ASIC external-I/O
frame:

- external I/O `0x54` is read at program `0xb300` and `0xb304`, then copied to
  active input cell `0x007f`;
- program `0x8c24` performs the matching per-frame `OUT` to external I/O
  `0xb2e5`, sourced from output cell `0x00cb`;
- `TRCV` reads at `0x8c1a`/`0x8c1e` are framing drains, while `DRR` is loaded
  into `AR3` and participates in address/bookkeeping state. Neither is the
  linear PCM endpoint.

The resident service slot is 172 instructions / 258 modeled C52 cycles. Later
call-overlay tracing shows this is an internal TDM slot cadence, not a direct
25 MHz / 9.6 kHz codec period; the ASIC performs the line-rate selection. The
emulator queues signed-16 idle input at `0x54`, captures the resident `OUT`
words, and models the missing board dial-command handoff.
An end-to-end `ATDT123` run emits three verified DTMF pairs through the actual
firmware `OUT` instruction. This handoff is still a board-side model rather than
the unrecovered internal datapump mailbox.

### The missing C52 TDM vector now reaches downloaded firmware

The C52's final `IMR=0x0080` enables interrupt index 7, whose vector slot is
program `0x0010`. That slot is hidden in the unavailable customer mask ROM,
which is why raising the interrupt previously executed downloaded reset code.
The branch target can now be recovered without inventing any negotiation: low
program `0x0228..0x024c` is a complete frame ISR ending in `RETE`. Its opening
words (`bdff 0852 bfb0 0003 bf90 ...`) are the build-specific successor of the
older C51 interrupt-side routine, and its frame arithmetic has the same shape.

The core can now supply that one recovered mask-vector branch. Every completed
C52 DAC `OUT` at `0xb2e5` raises interrupt 7; when `IMR` and `INTM` admit it,
execution enters `0x0228`, runs the downloaded ISR, and returns to the interrupted
sample loop. This is ASIC/frame scheduling only—the V.8 signal remains entirely
DSP-generated. A 30,000-instruction run accepts 133 frame interrupts and records
1,060 data writes from PCs `0x0228..0x024c`. Low-bank `OUT 0x006a` traffic is
kept as a TDM control slot instead of being incorrectly appended to line PCM.

Driving the fuller call entry at `0x2285` with this scheduler exposed the next
real opcode gap, `CPL dma` against `DBMR` at `0xa05a`. The documented compare is
now implemented and the path runs on instead of aborting. It still leaves the
native DAC essentially silent and `[0x00cc]` clear, so the next task is the
control/state publication performed around this frame ISR—not synthesized V.8
menus.

## Recovered DAA originate contract

Dynamic execution of `ATD1` identifies the supervisor-side dial-tone contract:

- the originate routine at physical `0x5db51` performs an off-hook settle wait,
  then loads call-progress timeout `0x2580` into timer word `0x0289`;
- it waits at `0x5dbe7` until detector byte `0x0649` reaches five;
- timeout branches through `0x5dc4a`, sets call-progress flag `0x08d9.4`, and
  ultimately selects result code 6, `NO DIAL TONE`;
- qualification continues into the dialer overlay, whose hardware-timer waits
  use `0x08d6` and `0x0161` for pre-dial and make/break cadence.

The emulator's behavioral DAA supplies a North American 350+440 Hz dial tone
through the confirmed C52 line ADC, debounces five 100 ms frames, publishes the
recovered `0x0649 = 5` event, removes dial tone, and starts DTMF at the active
C52 DAC boundary. This advances the original supervisor to `OK`; a quiet or disconnected
modeled line retains the original `NO DIAL TONE` path. The part is now
identified from the board and its register semantics are known (below);
what remains unconfirmed is the mapping from those fields onto the ASIC
ports the firmware actually reads.

## DAA chipset identity — Si3021 + Si3014

The parts are read off the board: an **Si3014** on the line side at the phone
jack, and an **Si3021** on the digital side near the CPU. That is a Silicon
Laboratories two-chip silicon DAA, the serial-interface member of the family
the Si3034/35/44/56 chipsets belong to. `docs/` carries the Si3038 datasheet
(the AC'97 sibling, Si3024 + Si3014), AN16 (multiple-device support for the
serial parts), and AN19 (layout).

The topology matters more than the part number. AN16 section 1.3 is
"ASIC Master with single Si3021/56 Slave": the Si3021 sits in slave mode while
something other than a DSP supplies SCLK and FSYNC. Every measurement here
agrees that this is the Courier's arrangement, with the ASIC as that master:

- the C52 configures its own serial port as a **slave** and then switches it
  off (below), so it never drives the bus;
- the C52's entire view of the outside world is four ASIC external-I/O ports;
- AN16 figure 1 routes the DAA's `FC/RGDT` ring-detect output to the DSP's
  `INT0` pin, while the recovered ring detector on this board is an 80186
  input latch bit (port `0x14`, bit `0x02`) — a board-level indication, not
  the DSP pin, which is what an interposed ASIC implies.

So a faithful DAA model does not answer on the C52 serial port. It has to
answer where the firmware actually reads, which is the ASIC boundary:

| surface | rate | state today |
|---|---|---|
| C52 external I/O `0x50` | 201,524 reads in a 30 M-instruction `ATDT` run, once per service frame, program `0x8c1f` | the host mailbox window's low word |
| C52 external I/O `0x54` | twice per frame, program `0xb300`/`0xb304` — the line ADC | fed by the behavioral DAA |
| C52 external I/O `0x56`/`0x57` | one write each at program `0x2b`/`0x02`, both `0xffff` | unmodelled |
| 80186 ports `0x40`..`0x4e` | eight latches, ~7,550 writes each per `ATDT` run, never read | the host mailbox window |

Port `0x50` was listed here as an open question — read once per frame and
floating high because nothing drove it. It is not floating. The harness
publishes the eight-byte host window into C52 I/O `0x50`..`0x53`, and both
mailbox commands of an `ATDT` run carry `ffffffffffffffff`, so the `0xffff` the
program reads is a value the host wrote. There is no spare port on the C52
side: its only external reads are this window and the line ADC.

The 80186 side has no register read path either. Ports `0x40`..`0x4e` take
~7,550 writes each in the same run and **zero reads**, so the supervisor cannot
poll a status byte out of the DAA even in principle.

What it does have is the mailbox, and one of its messages is the DAA's
identity. See "The DAA identity arrives as mailbox tag 0x7b" below: the
supervisor is not blind to the part, it is told about it once.

### What the datasheet says the status should carry

The Si3038 register map is AC'97-addressed and the serial parts number their
registers differently, so these are the *fields* rather than addresses. They
line up with what this project listed as unmodelled — ring qualification,
loop-current loss, and billing tone — and are what `courier_emu/codec.py` now
carries:

| field | register | meaning |
|---|---|---|
| `LCS[3:0]` | 5Eh | loop current in 6 mA steps; 0 is under 0.4 mA, 1111 is over 155 mA |
| `RDTP` / `RDTN` | 5Eh | ring detected, positive and negative half-cycles reported separately |
| `BTD` (with `BTE`) | 5Eh / 5Ch | billing tone detected, off-hook held through the tone |
| `FDT` | 5Eh | line-side to system-side frame lock |
| `ROV` | 5Eh | receive overload |
| `OHS` | 5Ch | on-hook speed, fast or slow |
| `RT` | 5Ch | ring threshold, 11-22 or 17-33 V RMS |
| `RZ` | 5Ch | ringer impedance, maximum or synthesized |
| `DCT[1:0]`, `ACT` | 5Ch | DC termination (FCC / Japan / CTR21) and AC termination |
| `DIAL`, `LIM[1:0]`, `VOL[1:0]` | 62h | DTMF headroom, current limit, line voltage trim |

### The bring-up nobody on this board performs

The datasheet's initialization procedure is a sequence with a handshake in the
middle of it:

1. write any value to `3Ch` — a register reset;
2. program the sample rate in `40h`/`42h`;
3. write `0x0000` to `3Eh` to power the part up;
4. **poll `3Eh[7:0]`** until it reads `0x0f` (line 1) or `0x33` (line 2);
5. program the GPIO registers `4Ch`..`54h`;
6. program the DAC/ADC levels in `46h`/`48h`;
7. program the country-specific line parameters in `5Ch` and `62h`.

Step 4 is the discriminator. It requires a controller that can *read* the
codec, and neither processor on this board has one: the 80186 only writes
`0x40`..`0x4e`, and the C52's two external reads are the host window and the
line ADC. Whatever runs this sequence is on the far side of the ASIC, which is
exactly the arrangement AN16 section 1.3 describes and which the ring detector
landing on an 80186 latch bit already implied.

`courier_emu/codec.py` models that. `SiliconDaa` is the register file — reset
defaults, the PLL's supported rate table, the readiness byte recomputed rather
than latched, and register `5Eh` assembled from the line rather than stored —
and `CodecBringUp` is the ASIC-side master that runs the seven steps against
it. The ordering constraints are the model's, not decoration:

- with the PLL left at zero the readiness poll never completes, because no
  line-side communication happens at all, which is why step 2 precedes step 3;
- the reference and GPIO come up a frame before the converters, so step 4's
  poll reads `0x03` before it reads `0x0f`;
- reaching a line-side register before the ISOcap barrier is up latches `CLE`
  and drops the write, so an out-of-order bring-up leaves a trace.

The register addresses are the Si3038's. The board's Si3021 reaches the same
line-side fields through its own control frames and numbers them differently,
so an address in that module means "the register carrying this field", never a
value the Courier's firmware emits.

Since no register read path exists, the model is driven rather than polled: the
bridge hands it one ASIC service frame per 100 ms, feeds it hook state and line
state from the behavioral DAA and the ring cadence from the ring source, and
reports it under `dsp_bridge.codec`. It is where loop-current sense, ring
qualification, frame lock, and the country settings now live; a read path to
those fields, if one is ever found, plugs into the same object.

### The DAA identity arrives as mailbox tag 0x7b

One thing the supervisor *is* told about the DAA is its revision, and `ATI7`
prints it. The receive handler at `0x6ad5b` reads a tag from the mailbox
header ports `0x58`/`0x5a`, rejects anything at or above `0x80`, and dispatches
four DAA tags, each taking its data word from `0x5e`/`0x5c`:

| tag | destination | carries | requested by |
|---|---|---|---|
| `0x7b` | `[0x287]` | the DAA revision | — (sent unprompted) |
| `0x7c` | `[0x283]` and `[0x285]` | the line reading `[0x649]` qualifies on | `0x7c00` |
| `0x7d` | `[0x27f]` | unidentified | unidentified |
| `0x7e` | `[0x281]` | a line-side register read | `0x8000` |

`0x7e` is the one that names itself. An AT diagnostic at `0x82b64` matches the
literal `"SI"`: with no argument it sends request `0x8000`, waits, and prints
`[0x281]` under `"\r\nta_report_si_read="`; with a four-hex-digit argument it
parses that into `BX` and sends command `0x0084`, the register **write**. The
consumer at `0x5e576` then tests only bits 0 and 1 of `[0x281]`, each against
its own four-hit debounce in `[0x647]`/`[0x648]`, and clears the word — which
is `RDTN` and `RDTP`, the two ring-detect half-cycles of register `5Eh`,
reported separately exactly as the datasheet describes. Both the read and the
write are gated on `test byte [0x287], 0x10`, so the line-side revision decides
whether the path is live at all.

The supervisor already issues `0x0084` writes during an ordinary boot —
`0084:1468` and `0084:1408`, plus `0084:0100` on a call — so this is not a
diagnostic-only path. None of it runs in the harness today; see "The mask is
set at boot and never cleared" below for why.

Three sites read `[0x287]` back:

```
0x77edb   mov ax, [0x287]          ; ATI7's "DAA rev", printed as four hex digits
0x77ee3   cmp word [0x287], 0
0x77ee8   jne  ...                 ; zero falls through to the inline string
          " : DAA Failure (zero is Invalid)"
0x8369d   cmp word [0x287], 4
0x836a2   jne  ...                 ; 4 prints "00345302", anything else "XX345302"
```

So the firmware carries its own verdict on this word: zero is a failed DAA, and
4 is the revision this build expects, because that is the value that turns the
product ID from the placeholder `XX345302` into `00345302`. Nothing in the
harness produced the message, so every run reported a DAA the firmware itself
considered invalid:

```
Product ID             XX345302        DAA rev  0000
```

The bridge now queues tag `0x7b` carrying the modelled part's revision, and it
does so on the **first** DSP download rather than the second.
The coprocessor-ready pair `0x02`/`0x03` belongs to the dial/answer boundary; a
part identifies itself at power up, before any call, and the identity has to be
in place before the first `ATI7`. That run reports:

```
Product ID             00345302        DAA rev  0004
```

The revision itself is still a guess. 4 is read out of the product-ID branch,
not off a part, and it does **not** have bit `0x10` set — so the value that
gives the tidier product ID is also the one that leaves the `si` register path
switched off. Register `5Ah` in the datasheet packs two chips' revisions into
one word (`REVA[3:0]` system side, `REVB[3:0]` line side, `CBID` at bit 8, with
`0010` = Rev B and `0011` = Rev C), which reads the two firmware tests as two
different fields rather than a contradiction: `== 4` matches the whole word,
`& 0x10` is `REVB` bit 0, separating a Rev C line side from a Rev B one. If
`[0x287]` is that register, then a real board with a Rev C line side prints
`XX345302`, and the placeholder is correct. Settling it needs the `si` path to
run, which it cannot yet.

`0x7d` is the one tag with no consumer found anywhere. Its only other
appearance is a printer at `0x794de` that renders `[0x283]` `:` `[0x27f]` `:`
byte `[0x64c]` as a colon triple; injecting marker values for all three tags
and confirming delivery in the trace surfaced them on no reachable page.

### The C52 serial port is configured once and disabled

Tracing the C52's own writes to its memory-mapped registers gives the whole
serial life of the program:

```
program 0x00be   SPC <- 0x0008    receiver and transmitter held in reset
program 0x00c0   SPC <- 0x40c8    both out of reset, burst frame sync,
                                  TXM = MCM = 0: externally clocked slave
program 0x00c2   DXR <- 0x0001    prime the transmitter
program 0x00c6   DXR <- 0x0001    prime again
program 0x00cb   IMR <- 0x002a    unmask INT2, TINT and XINT
program 0x8189   SPC <- 0x0000    shut the port down
```

`SPC = 0x40c8` is the slave configuration AN16 describes, and priming `DXR`
twice with `XINT` unmasked is an interrupt-driven transmitter. The shutdown at
`0x8189` is reached by an unconditional jump out of the boot block into the
high bank — there is no condition to satisfy — and the enable word `0x40c8`
occurs exactly **once** in the whole DSP image. Across every reachable path,
including a full `ATDT123` on a dial-tone line, `SPC` stays zero and `DXR`
keeps its three boot writes while `DRR` is read tens of thousands of times.

This program therefore never opens the serial link. That is not the datapump
mailbox gating it; nothing in the reachable image turns it back on.

## SIP line adapter

The behavioral DAA can now terminate on a minimal SIP/SDP/RTP client. The
recovered `ATD` number is used to form an INVITE URI only after the firmware's
`0x0649 = 5` dial-tone transition. SIP trying/ringing/connected/failed states
update the DAA operation state, while PCMU RTP is converted between 8 kHz and
the ASIC's confirmed 9.6 kHz line cadence. The current DTMF assist is inserted
at the recovered C52 line-output write and is carried in-band rather than sent
as SIP events; the datapump itself has not yet accepted the originate command.

A loopback PBX validation of `ATD123` produced `INVITE sip:123@127.0.0.1`,
completed `200 OK`/ACK, sent 250 RTP packets, and decoded the first packet burst
as 697+1209 Hz. This proves firmware command → DAA qualification → SIP signaling
→ C52 audio → PCMU RTP. A subsequent live 6000-to-7800 call received `200 OK`
and exchanged 1,152 inbound / 507 outbound RTP packets, but the firmware still
returned `NO CARRIER`.

The failure is now localized below SIP. During that call the supervisor sent
30 two-word runtime messages through ports `0x58..0x5e`, and none of them
reached the datapump. Incoming supervisor event tags `0x02`, `0x03`, `0x09`,
and `0x4d` execute their recovered handlers, yet cannot compensate.

An earlier revision of this section called the read at C52 program `0x8c1f` the
datapump's command poll and named "recover the `0x58..0x5e` to C52 `0x50/0x51`
valid/ack timing" as the next required step. That lead is closed; see below.

### The window word `0x50` is not a command port

There is no `IN` for port `0x50` anywhere in the C52 image. Data addresses
`0x50..0x5f` are reserved on a C5x and this core decodes them as external I/O,
which is what makes them appear in the I/O event log at all. The site is a
single instruction:

```
8c19  0100  LAR   AR1, @00
8c1a  1130  LACC  @30            ; TRCV
8c1c  0320  LAR   AR3, @20       ; DRR
8c1e  1130  LACC  @30
8c1f  4650  BIT   @50, 6         ; TC = bit 9 of the host window word
...
8c24  0c80  OUT   *, 0xb2e5      ; the line DAC
8c3d  be4a  CLRC  TC             ; and the bit is discarded here
8c3e  7980  B     0xb2e9
```

`BIT` writes only `TC`, and nothing between `0x8c1f` and the `CLRC TC` at
`0x8c3d` reads it. The word is read once per sample and thrown away. Three
checks against the running core agree:

| check | result |
|---|---|
| each of the 12 header values the supervisor sends, placed at window words `0x50`/`0x51`, over a 3.4 M-instruction run | byte-identical in every counter, including the stop PC |
| `IMR` after boot | `0x0000` — no host interrupt can be taken |
| all 2,274 runtime messages of a run applied as `host_write(header, data)` into C52 data space | no change |

So the resident program has no host-to-datapump command path of any shape.

A differential `AT`/`ATDT123` capture now narrows the board-side protocol much
further.  The bridge reports a complete histogram plus the first 80186
instruction and PC for each distinct message.  Plain command mode sends only
12 words.  Dialling adds a one-time `0082:0060` transition and then repeatedly
queues this 12-message block:

```
0082:0020  0082:0000  0015:0000  001f:0000
0019:020d  0019:020d  0016:0000  0016:0000
001a:3000  001b:0c08  0013:0001  001f:8000
```

The apparent send PCs identify two real transmit paths rather than C52 data
writes.  `0x6ad47..0x6ad5f` emits the single pending word at `[0x02ca]`, while
`0x6ae81..0x6aec3` walks a circular queue at `[0x02e0..0x030f]` using pointer
`[0x02dc]`.  Thus the values below `0x80` are board/ASIC register commands;
treating their headers as C52 data addresses was categorically the wrong
model.  `0082:0060` is the first originate-mode transition.

The producer is now recovered too.  The generic immediate sender is
`0x5d76b`; if `[0x02cb]` is free it stores `AX` at `[0x02ca]`, otherwise it
queues it.  The call at `0x5dc03`, immediately after the five-hit detector wait
succeeds, enters ASIC routine `0x6ae51`:

```
6ae51  mov ah,82h
6ae53  mov al,[1fab]       ; ASIC register-shadow byte
6ae56  or  al,60h
6ae58  and al,7bh          ; set 60, clear 84
6ae5a  call update-shadow
6ae5f  call send-immediate ; emits 82:60 with the default shadow
6ae64  mov ah,82h
6ae66  mov al,[1fab]
6ae69  and al,3bh          ; clear 40,80,04; leaves 20 initially
6ae6b  call update-shadow
```

The later `82:20` and `82:00` messages are therefore successive writes to the
same ASIC control register, not arbitrary event tags.  The neighbouring init
routine at `0x6adff` similarly publishes shadow bytes `[0x1faa..0x1fac]` as
registers `0x7d`, `0x82`, and `0x83`, followed by two `0x84` words.  This pins
`[0x1fab]` as register 0x82's software shadow and the call-progress routine at
`0x5dbb0..0x5dc63` as the source of its originate transition.

An `ATA` differential run takes the same `82:60 -> 82:20 -> 82:00` path, so
these bits select common line-operation phases rather than originate versus
answer modulation.  The emulator now exposes the shadowed block under
`dsp_bridge.asic`: register values and write counts, decoded register `0x82`
phase, and register `0x83` ring-indicate bit.

The read/modify/write masks give the high bits of `0x82` useful individual
semantics, rather than merely four opaque states:

| bit | observed sequencing | inferred ASIC output |
|---:|---|---|
| `0x80` | set in held state `a0`, explicitly cleared before `60` | call-engine hold |
| `0x40` | set only for `60`, then immediately removed from the shadow | start strobe |
| `0x20` | present in `a0`, `60`, and `20`; cleared on shutdown | line/datapump enable |
| `0x04` | explicitly cleared by both transition masks | unknown interlock |

That makes the sequence `a0 -> 60 -> 20 -> 00` read as **engine held while
enabled -> release hold plus start strobe -> enabled/run -> disabled**.  This
is the first interpretation that explains every mask operation, the pulse-like
lifetime of bit 6, and the common originate/answer path.  The emulator reports
these as `engine_hold`, `start_strobe`, and `line_enable`.

The supervisor code rules out two tempting interpretations.  C52 reset is a
separate path at `0x69bf1..0x69c84`: it manipulates 80186 peripheral register
`0xff56`, floats ports `0x1c/0x1e`, waits for both words to read `0xffff`, and
then enters downloader `0x69cd2..0x69deb`.  Dynamic `ATD` and `ATA` runs execute
that bootstrap once only; the `0x82` transition does not reset or redownload
the C52.  Program loading/bank placement is likewise performed by the explicit
eight-byte downloader using `[0x1fb2]/[0x1fb3]` and ports `0x40..0x4e`; no
`0x82` shadow value is consulted anywhere in that path.

Consequently `0x82` is not the C52 reset control and there is no code evidence
that it selects a downloaded program bank.  Its placement after line-detector
qualification, identical use by `ATD` and `ATA`, and shutdown at `0x5e5e8`
identify it more narrowly as the ASIC's **line/call engine enable and start
strobe**.  The initial `0xa0` is the engine's held/initialised state, not the
C52's reset state.  The code and a feature differential settle an important naming point: there is
no separate supervisor-side "enter V.92" command.  Two otherwise identical
`ATDT123` runs, one with the full `hst,fax,terbo,v34,v90` parameter sector and
one with only `hst`, emit the same call-engine stream value-for-value:

```
82:60 -> 82:20 -> 82:00
13:01, 15:00, 1f:00, 19:020d (twice), 16:00 (twice),
1a:3000, 1b:0c08, 13:01, 1f:8000
```

The V.90 feature bit changes product reporting and capability policy, while
V.92 is printed unconditionally by this build; neither changes the ASIC call
start.  The textual V.92 references elsewhere in the supervisor are reporting,
configuration, and post-call diagnostics.  None feeds a distinct value into
`[0x1fab]`, the queue helper, or the C52 downloader.

Therefore what the supervisor code activates is the **generic automatic
negotiation datapump**, at `0x5dc03 -> 0x6ae51 -> 82:60`.  V.92 must be selected
later by that datapump from the V.8/V.8bis and training exchange with the far
end, falling back through V.90/V.34 as appropriate.  There is no V.92-only
entry point to call from the 80186.  The missing implementation is the ASIC
consumer of the repeated `0x13/0x15/0x16/0x19/0x1a/0x1b/0x1f` block and the
resulting DSP-side start/frame state; recovering that generic consumer is what
will make the existing V.92 code reachable.

### Where the command stream is consumed

This can be bounded completely from the executable code even though the
consumer's implementation is not present in the XMF.  The 80186 producer ends
at four byte-wide output latches:

```
port 58 = command/header low
port 5a = command/header high
port 5c = argument low
port 5e = argument high
port 1c = valid/acknowledge state
```

After `OUT 5e,AL`, no 80186 routine dispatches the command locally.  The only
software on the far side in the image is the C52, and it cannot be the
consumer:

- its downloaded program never executes an `IN` from these 80186 ports;
- the eight-byte C52 window is the separate `0x40..0x4e` bootstrap surface;
- applying every runtime pair as C52 data writes changes no execution state;
- its only steady external reads are the reserved/frame word corresponding to
  `0x50` and line ADC `0x54`; and
- every tested command value at the former is discarded before `TC` is used.

The receive direction proves the same topology.  The 80186 reads replies back
from `0x58..0x5e`, including DAA identity and detector results that originate
outside either processor, while bit 1 of port `0x1c` advertises them.  Thus the
bidirectional queue terminates in the interposed Courier ASIC's hardware
command engine.  It is not an omitted 80186 routine or a hidden entry in the
downloaded C52 program.

The code also constrains what that hardware engine does with the call block.
Commands `0x13..0x1f` repeat while register `0x82.5` enables the engine;
`0x82.6` starts it, and clearing `0x82.5` stops it.  The same ASIC is demonstrably
the master of the Si3021 serial link and the source/sink of the C52's framed
ADC/DAC words.  Therefore the consumer is the ASIC's line-frame/call state
machine, which translates the queue into DAA transactions and DSP frame/control
state.  Its gates or microcode are silicon and are absent from all supplied
firmware files; the XMF contains only the producer and the downstream C52
payload.

A first behavioral implementation now consumes that block.  It stores
registers `0x13..0x1f`, recognizes the observed `0x1f:0000 -> 0x1f:8000`
rising edge as commit, starts the call engine once, and returns tags `0x02` and
`0x03` because the recovered supervisor receive table maps those to its two
coprocessor-ready latches.  Repeated commit edges are counted but do not repeat
the ready reports.  In an 8 M-instruction `ATDT123` run the original firmware
accepts both replies and changes its callbacks to `50ad,18e3,4cac`, with
`[0x1cf0]=1`; the C52 still emits only its single startup nonzero sample.

That result validates the guessed **command acceptance/ready** half of the ASIC
contract while falsifying the idea that ready replies alone activate the
modulation code.  The remaining guessed half must be DSP-facing frame/control
state generated on commit; it cannot be replaced by another supervisor tag.

There is a non-accidental DSP-side interpretation of the control block: every
command number is a C52 memory-mapped control-register address.

| command | C52 register | supplied value |
|---:|---|---:|
| `0x13` | `AR3` | `0001` |
| `0x15` | `AR5` | `0000` |
| `0x16` | `AR6` | `0000` |
| `0x19` | `ARCR` | `020d` |
| `0x1a` | `CBSR1` | `3000` |
| `0x1b` | `CBER1` | `0c08` |
| `0x1f` | `BMAR` | `0000 -> 8000` |

The byte lanes need swapping at the ASIC/C52 boundary.  The unswapped pair
`CBSR1=3000, CBER1=0c08` describes an impossible descending circular buffer;
the physical C52 values are the coherent `CBSR1=0030, CBER1=080c`.  The whole
batch therefore becomes `AR3=0100`, `ARCR=0d02`, `CBSR1=0030`, `CBER1=080c`,
and `BMAR=0080`.  This is strong independent evidence that these are genuine
C52 register lanes rather than command numbers that happen to overlap them.

The behavioral consumer now batches those values and publishes them to the
C52 atomically on the wire-level `BMAR=8000` (C52 `0080`) commit edge.  This is materially different
from the earlier failed experiment that replayed every mailbox pair at
arbitrary instruction boundaries: the ASIC owns the frame boundary and the
`BMAR` transition is its commit marker.  A full run accepts 77 commits and
remains stable, but still emits no carrier.  So this recovers one real-looking
piece of DSP control state, while showing that the register batch alone is not
the missing frame event.  The next control surface is the event accompanying
the atomic register publication—most likely the ASIC's C52 frame/TDM edge or a
program-memory block move selected by `BMAR`.

The earlier bounded behavioral V.8 fallback is no longer attached to normal
calls. It proved that 1300 Hz CI and 2100 Hz ANSam could cross the recovered
9.6 kHz line path, but it also replaced every subsequent DSP DAC word and hid
the failure being investigated. The explicit native tone API remains useful as
a transport test; the bridge now relinquishes the DAC after board-side DTMF so
V.8 and all later modulation must come from downloaded DSP code.

The computed call-engine entry is now pinned at C52 program `0x2295`.  Forcing
that PC from the settled service state immediately executes `BLPD *BMAR`, then
branches through `0xa9a9`, runs a substantial datapump initializer, and returns
to the 169-instruction service cycle.  It originally stopped at two missing
core operations; implementing the documented C5x `BLPD BMAR` and `MAC`
semantics makes the whole path complete.  This is the first recovered
call-time transition inside the original C52 rather than behavioral line
synthesis.  The ASIC commit now enters `0x2295` after publishing
`BMAR=0x0080`; a regression executes 5,000 instructions from that entry and
requires it to return to stable line-frame output without an unsupported
opcode.

`ATA` and originate commits still enter the recovered C52 call boundary, but no
longer arm synthesized ANSam or CI. `dsp_bridge.asic.v8_armed` now means that
the datapump entry was requested; nonzero post-dial DAC output is evidence the
firmware itself advanced, rather than evidence that a fallback was attached.

The bridge reports `call_engine_started`, `commit_edges`,
`dsp_register_commits`, and the complete latched command register block under
`dsp_bridge.asic` so each subsequent DSP-side experiment is observable.

The recovered responsibilities now make the ASIC boundary fairly tight:

- arbitrate the 80186 command queue and interrupt/status handshake;
- bootstrap the C52 through the eight-byte `0x40..0x4e` window;
- master the Si3021 serial DAA and report its identity/status;
- frame the 9.6 kHz ADC/DAC stream visible at C52 external I/O;
- carry line detector and ring-indicate state; and
- sequence a call through register `0x82` independently of whether the
  supervisor selected originate or answer.

Dynamic tracing also recovers queue helper `0x6b067` (`MOV [BX],AX` at
`0x6b083`) and now records both its return address and the outer producer when
a wrapper is used.  That separates detector polling (`0x6db4c/0x6db5b`), call
control (`0x6cebc`), and other producers instead of attributing every command
to the common sender.

What the supervisor's runtime channel *is* remains well defined — 2,274
two-word messages in a 12 M-instruction run, with a valid/ack handshake on port
`0x1c` (`in 0x1c` 2,279, `out 0x1c` 4,558), and the `0x40..0x4e` window used
only for the two program downloads — but its consumer on the board is not the
C52 code these images run. The remaining candidates are that the datapump entry
lives in the downloaded low bank and is never entered here, or that the channel
terminates in the ASIC rather than in the C52 at all.

## The datapump is resident, idle, and gated on one bit

Decoding a C5x image statically floods, because any word decodes; taking the
instruction boundaries from a real run does not. On that basis the whole of
what the C52 executes in steady state is **167 instructions**, and one pass of
it is 169 instructions — about 6% of the 2,604 cycles a 25 MHz part has per
9.6 kHz sample. It is entered per sample at `0x0cb1` and runs:

```
0cb1 (low bank)  ->  c1cd  ->  de89  ->  8c19  ->  b2e9  ->  c7f7
                 ->  e24b  ->  b30b  ->  de9c  ->  8195  ->  a8c7  ->  back
```

The first thing that settles is that the **downloaded bank is entered**. Of the
three program segments the image carries, only the low one (`0x0000..0x75d9`)
is what the supervisor downloads, and the loop head at `0x0cb1` is inside it.
The datapump is resident and running, not waiting to be started.

### The gate

Near the end of every pass:

```
a8c7  b5cc  LAR   AR5, #0xcc
a8c8  bf09  LAR   AR1, #0x02ff
a8ca  4b80  BIT   *, 4          ; bit 4 of [0x00cc]
a8cb  e900  CC    0xb4d4, TC    ; never taken
```

`[0x00cc]` reads zero on every sample of every run, so `0xb4d4` is never
entered. Setting bit 4 by hand is the first thing that has moved the datapump:

| | line-DAC writes | non-zero samples | parked PC |
|---|---:|---:|---|
| untouched | 14,102 | 1 | `0x8195` (resident bank) |
| `[0x00cc]` bit 4 set | 15,515 | 10 | `0x0bda3` (downloaded bank) |

### What sets `[0x00cc]`

The datapump itself, from a value it carries around a closed loop. Tracing
every data write into the frame block shows `[0x00cc]` written to zero on every
sample from four sites — three in the `0xde89` prologue and `0x81a0` — and it
sits one cell above `[0x00cb]`, the line-DAC source. `0x81a0` is the last of the
four before the test, and single-stepping the block with signal on the line
gives the whole chain:

```
b304  ADD  @54        ; ACC 00000000 -> ffffe605, the held ADC word
b305  SACL @7f        ; [0x7f] = e605
b306  LACB            ; ACC <- ACCB = 05550000, and the sample is gone
b307  SACH @7e        ; [0x7e] = 0555
b308  SACL @7d        ; [0x7d] = 0000
...
b30b  LACC @7e, 16    ; and the pass ends by rebuilding ACCB
b30c  ADDS @7d        ;   from the same two cells
b30d  SACB
...
81a0  SACL *          ; [0x00cc] = [0x7d]
a8ca  BIT  *, 4       ; bit 4 of it
```

So `[0x00cc]` is the low half of a 32-bit word the datapump carries from sample
to sample through `[0x7e]:[0x7d]` and ACCB. It holds `0x0555_0000` for the whole
run — high half `0x0555`, low half zero — so bit 4 is clear and the gate stays
shut.

That also explains why signal changes nothing. The line sample *does* reach the
accumulator at `0xb304` and *is* stored, to `[0x7f]` at `0xb305`. Then `LACB` at
`0xb306` reloads ACC from ACCB and the sum is discarded, and `[0x7f]` itself is
overwritten at `0x81b1` by a `TBLR` from a program table before anything reads
it. The receive path is a dead end in this state by construction, not by
accident of what the harness feeds it.

Nothing outside can set the word either. Holding each cell of the C52's
on-chip data space in turn — 1,952 of them — and comparing line-DAC counts, the
serial registers, the parked PC and the cycle count moves the run for **eight**:

| cell | what it is |
|---|---|
| `[0x00cb]`, `[0x00cc]` | the frame block's DAC source and the gate |
| `[0x007f]` | the scratch cell the discarded sample lands in |
| `[0x0082]` | perturbs the run without producing output |
| `[0x037d]`, `[0x037e]`, `[0x03fd]`, `[0x03fe]` | the same `@7d`/`@7e` offsets on the DP pages `0xde9c` and `0xa8d0` select |

An idle datapump reads essentially nothing: not its own RAM, not the line, not
the host window, and not an interrupt — `IMR` is zero. Whatever starts it does
not arrive through any input this build of the C52 is watching.

### The receiver is gated off, not merely unsignalled

Feeding the ASIC line input a 2100 Hz, 1800 Hz or 980 Hz tone at the confirmed
9.6 kHz cadence, or noise, instead of silence leaves every counter identical:
19,984 line-DAC writes, one of them non-zero, `[0x00cc]` never anything but
zero, and the same parked PC. The datapump does not respond to signal at all
until something commands it, which is consistent with the gate above and rules
out "it is listening but hears nothing".

### What `0xb4d4` expects on entry: nothing, because it is not code

Forcing the gate and catching the first entry gives the state it is handed —
`DP` 0x380, `ARP` 5, `AR5` = `0x00cc`, `ACC` `ffffff00`, `ACCB` `05550000`,
`[0x7b..0x7f]` = 0, 0, 0, `0555`, 0 — and then 570 instructions that decode as a
run of `LAR AR0, @xx` over a smooth numeric sequence broken by runs of `0xffff`:

```
b4d4: 0053 0064 0079 0092 ffff ffff ffff ffff ffff 0093 0078 0061 0052 0049
b4e2: 002a 002f 003a 0047 005f 007d 009e ffff ffff ffff 009f 007b 005e 0046
```

That is a table, not a routine. It falls through into `0xc418`, `0xe580` and
`0xb671`, spends 1,171 instructions there, and returns. So the earlier reading
of `0xa8cb` as a live conditional call into the datapump was wrong: forcing the
bit runs the CPU into data, and the ten non-zero line words it produced are
that, not a carrier.

### The reset code, which is anchored, says something different

Program `0x0000` — the one origin that is not a guess, since it is the bank the
supervisor downloads — is unambiguous C5x startup:

```
0000  LDP  #0
0007  SPLK #0x0010, @2a     ; CWSR
0009  SPLK #0x000a, @28     ; PDWSR
000b  SPLK #0x0001, @29     ; IOWSR
0011  SPLK #0x27bd, @7d ; LST ST1
0014  APL  #0x07f8, @07 ; OPL #0x00b0, @07   ; PMST: AVIS, OVLY, RAM
001d  LAR  AR1, #0x0100 ; RPTZ #0x3ff ; SACH *   ; clear 1,024 words
00bd  SPLK #0x0008, *   ; SPC = 0x0008
00bf  SPLK #0x40c8, *   ; SPC = 0x40c8, receiver out of reset
00c9  LACC #0x002a ; SAMM @04              ; IMR = 0x002a
00cc  CLRC INTM                            ; interrupts on
00cf  CALL 0x8188
```

The `CALL 0x8188` literal lands exactly where `SPC` is written again — the one
site in the image carrying `0x40c8`, and here it writes `0x0000`. So the serial
port is opened by the reset code and closed immediately by the routine reset
calls; "nothing in the reachable image turns it back on" was half the story.

### Two earlier measurements were mine, not the firmware's

`courier_c5x_get_data` and `courier_c5x_set_data` go straight to the data array
and skip the C5x register decode, so reading address `0x04` answers
`m_data[0x04]` rather than `IMR`. **`IMR` is not zero.** It is `0x002a` out of
reset and every sample ends with `0x0080` written to it from `0x81be`.

### Interrupt 7 is enabled, and raising it re-runs the boot

Raising each of the sixteen interrupts in turn, exactly one changes the run —
number 7, the TDM serial port. It looked at first like the datapump coming
alive: executed instruction sites went from 167 to 521, most of the line-DAC
words stopped being zero, and the C52 started writing its serial transmit
register. It is not that. Counting where those instructions go:

| | sites | instructions below `0x00d0` | `0x0010` entered | SPC writes |
|---|---:|---:|---:|---:|
| idle | 167 | 0 | 0 | 0 |
| interrupt 7 driven | 521 | **5,895** | **5** | 15, from `00be`, `00c0`, `8189` |

`PMST.IPTR` is zero, so interrupt 7 vectors to program `0x0010` — which is
inside the reset code. The extra 354 sites are the boot path, the SPC and DXR
writes are the boot's own, and the line output is the DC level boot leaves
behind. Driving the interrupt partially reboots the C52.

### There is no vector table in this image

That collision is not a detail; it is the whole question. `PMST.IPTR` can only
place the table on one of 32 two-kiloword boundaries, and a C5x table is 2 words
per vector, normally a branch. Scoring all 32 legal bases for a run of
consecutive two-word branches whose targets land inside a loaded segment gives
the longest run as **one slot**, at `0xc800`. Relaxing the search to the whole
image finds nothing table-shaped either — the longest runs are `0x519a` (14),
`0x2184` (8) and `0xbb70` (7), and all three are ordinary sequential `CALL`
code; `0xbb70` is seven identical `CALL 0xc881`.

Nor is the area rewritten after boot. Over 600,000 instructions of startup the
only program-memory-touching instruction executed is a single `BLPD` at
`0x0030`, and `BLPD` reads program into data. No `TBLW`, no `BLDP`. The reset
code stays on top of the vector area for the life of the run.

So the vectors are not in the XMF. The reading that fits is that the C52 is in
microcomputer mode, its program `0x0000..0x0fff` is on-chip ROM carrying both
the vector table and the bootstrap that receives the download, and neither is in
this image — which means the harness's assumption that the downloaded segment
begins at program `0x0000` puts the downloaded init on top of the vectors.

### No image in the tree has one either

The absence is not peculiar to `main211`. Scanning all fifteen images here — six
XMFs, four XMDs, the ISDN ROM, `.nac`, `.sdl` and `.xmp` — in both byte orders
for runs of two-word branch slots turns up nothing table-shaped anywhere. The
apparent 15- and 16-slot runs in `SV25.XMD`, `SDL0430.XMD`, `SV_49.XMD` and
`IDSDL302.XMD` are filler: one word repeated, `7d77`, `7a37` or `7077`. The
runs in the XMFs are all the same sliding window over one block of sequential
`CALL` code — `0xa624` in the 2.1/2.2 builds, `0x4554` in `main2205` — whose
targets repeat rather than fan out. Requiring the handler word to vary leaves
nothing.

Nor would a C52 boot ROM be here to find: it is a TI mask ROM, not something
USR ships in a firmware update.

### What the family does share, and where it splits

Every XMF's DSP payload starts at file `0x2f0` with reset code, in two variants:

| build | opening |
|---|---|
| `main211`, `main2205`, `3453Bv2.1.1` | `LDP #0` · `SPLK #0xffff, @57` · `SPLK #0, @7a` · `SETC INTM` |
| `2_3_33`, `MAIN_2.3.12/15/31` | `LDP #0xfe` · `SPLK #0xffff, @53` · **`OUT @53, 0x8057`** · `LDP #0` · `SPLK #0, @7a` · `SETC INTM` |

The three older builds are byte-identical over their whole opening. The 2.3.x
build differs in two ways worth following. Its very first act, before it sets
wait states or anything else, is an external write of `0xffff` to I/O port
`0x8057`. And it programs different wait states: `PDWSR` `0x2000` against
`0x000a`, `IOWSR` `0x0101` against `0x0001`.

### What the wait states say

`PDWSR` gives each 16K block of program and data space a two-bit field, `IOWSR`
gives each pair of I/O ports one — or each 8K block when `CWSR`'s `BIG` bit is
set — and `CWSR` decides whether a field means 0/1/2/3 wait states or 0/1/3/7
(SPRU056D §9.4.1–9.4.3, tables 9–5 and 9–10). Both builds write `CWSR` `0x0010`:
`BIG` set, and every space on the plain 0/1/2/3 scale. That resolves the two
`PDWSR` words:

| build | field | range | wait states |
|---|---|---|---:|
| 2.1/2.2 (`0x000a`) | Program 1 | `0x0000..0x3fff` | **2** |
| | Program 2 | `0x4000..0x7fff` | **2** |
| | everything else | | 0 |
| 2.3.x (`0x2000`) | Data 3 | `0x8000..0xbfff` | **2** |
| | everything else | | 0 |

and the two `IOWSR` words: 2.1/2.2 `0x0001` gives I/O `0x0000..0x1fff` one wait
state; 2.3.x `0x0101` gives that block one and `0x8000..0x9fff` one as well —
the block holding port `0x8057`, which is the port its very first instruction
writes.

Software wait states only apply to **off-chip** accesses. Zero says nothing,
because zero is also what you leave a region you do not care about, but a
non-zero field is the firmware stating it expects external memory there. So:

- **The 2.1/2.2 boards put program `0x0000..0x7fff` off-chip**, which is exactly
  the span of the 30,172-word segment the supervisor downloads
  (`0x0000..0x75d9`). The download lives in external program RAM at `0x0000`.
- The 2.3.x boards need no wait states in program space at all and instead put
  slow external memory in **data** `0x8000..0xbfff`. The two generations hang
  their external memory off different spaces.

That settles `MP/MC`. Table 8–3 says microcomputer mode puts 4K of on-chip ROM
at program `0x0000..0x0fff`, where wait states would do nothing; programming two
of them across `0x0000..0x3fff` is only meaningful with **`MP/MC` = 1**, all
program space off-chip. The pin now defaults to 1 for that reason rather than
by convention, and the flat program space this harness always had turns out to
be right — now for a stated reason.

Either way, the vector area holding reset code is a property of every build in
the tree, across five years and two product lines, rather than a quirk of one
image.

### The memory map, now modelled

`PMST` carries `MP/MC`, `OVLY` and `RAM`, and this core parsed all three and
acted on none of them. It now decodes both spaces through the C52's map:

The regions are the C52's own, from tables 8–3 and 8–10 rather than the family
generalities: **the C52 has no SARAM at all**, which makes `PMST.RAM` and
`PMST.OVLY` don't-cares on this part, and its data space is off-chip only from
`0x0800` up with two reserved gaps below that.

| space | region | when |
|---|---|---|
| program | on-chip ROM, `0x0000..0x0fff` | `MP/MC` = 0 |
| program | DARAM B0, `0xfe00..0xffff` | `CNF` |
| program | external | otherwise |
| data | memory-mapped registers, `0x0000..0x005f` | always |
| data | DARAM B2 `0x0060..0x007f`, B0 `0x0100..0x02ff` (unless `CNF`), B1 `0x0300..0x04ff` | |
| data | external, `0x0800..0xffff` | always |
| data | reserved — `0x0080..0x00ff` and `0x0500..0x07ff` | |

`MP/MC` is a pin, not something an image records, so it is supplied to the core
and defaults to 0 — the level this core has always presented when the firmware
reads `PMST` back, and the firmware does read it. `courier_c5x_set_mpmc_pin`
changes it; over a 1.5 M-instruction run either level ends at the same PC, so
the bit costs almost nothing in behaviour and buys the accounting.

There is no on-chip ROM to put in the window — no XMF carries one — so with none
supplied the window still answers from the downloaded image, exactly as before,
and the fetches are counted instead. That count is the size of the assumption.
Over a 12 M-instruction `ATA`:

```
program_external 13,843,991    program_rom 692,059    rom_holes 692,059
data_registers    1,176,533    data_daram 1,384,195
data_reserved       692,047    data_external 69,208
```

`courier_c5x_load_rom` takes a ROM if a dump of the C52's ever appears; until
then `dsp_bridge.dsp_memory_map` reports the mode bits, the wait-state decode,
the per-region counts and the hole count on every run.

Two of those counts are worth reading.

`program_rom` is 692,059 even with the pin at 1, because `PMST` is written zero
mid-run — by the same stores at `0xb626`, `0xb65f`, `0xb667`, `0xb677` and
`0xb67c` that zero `IMR` and `IFR` — which clears `MP/MC` and re-opens the ROM
window under the running program. Firmware does not switch the part out of
microprocessor mode on purpose.

`data_reserved` is 692,047: **nearly 700,000 data accesses a run land in the
C52's reserved windows.** Those are the frame-block cells — `[0x00ca]` through
`[0x00cd]`, holding the line-DAC source and the gate this section opened with —
and `0x0080..0x00ff` is a range the C52 has nothing in. On silicon those
addresses hold no storage at all. That is an independent confirmation, from the
part's own memory map rather than from behaviour, of what the vector-table
search concluded from the other end: the addresses the low bank computes are
not landing where the code thinks they are.

### Two core defects found on that path

- **TREG0 was not memory-mapped.** `LT` and its relatives wrote `m_treg0`
  while a data-space access to `0x0c` saw a cell nothing updated, even though
  its neighbours TREG1, TREG2 and DBMR were all mapped. Fixed. It is not on the
  idle loop, so no result above changes.
- **The BIO pin is unimplemented** — `GET_TP_CONDITION` answers "BIO low"
  false unconditionally, which makes every conditional instruction that tests
  it dead. There are 711 candidate sites in the image, including `0x0cc0`, a
  `CCD` a few words past the loop head. None is reached: counting evaluated
  opcodes over a run, idle and with the gate forced, gives **zero**. So the TODO
  costs nothing today and would matter the moment a new state reaches one.

## Datapump is present & readable — but needs human-driven RE

Confirmed by decoding real code: the DSP region contains genuine V.34/V.90
datapump code, e.g. at file `0x040F98`:
```
rptk B5h ; mac $4450,*0+,AR3     ; 182-tap MAC, coeffs @prog 0x4450
rptk B5h ; mac $5450,*0+,AR3     ; another 182-tap filter @0x5450
mac  $2756 ; blkp $CD2F ; macd $37C4 ; macd $28C4 ...
```
That's a **bank of 182-tap correlators / matched filters** — the equalizer /
DIL-correlation machinery. The `mac` coefficient tables (e.g. file `0x320A0` =
prog `0x4450`) hold 182 large-amplitude signed values — consistent with **DIL /
probing reference sequences**, a strong candidate for the DIL-correlation input.

**What automation can't do here** (verified, don't re-attempt):
- Pin the DSP load/base address. `file = 0x29800 + 2·prog` is only a *hypothesis*:
  it gave locally-plausible hits, but `prog 0x0000` isn't a reset branch, and
  recursive-descent produces identical floods under correct and wrong bases
  (~46K insns, 7.9% invalid, 2 rets either way). C25 decodes arbitrary bytes, so
  code-vs-data and base cannot be resolved statistically.
- Isolate the specific DIL/constellation-design routine. Needs a person who can
  recognise routine boundaries, coefficient tables, and algorithm shape.

**Recommendation:** load `SV25.XMD` into **IDA** (has a TMS320C2x processor
module) or Ghidra, region `0x29800–0x44000`, big-endian words, and drive it
manually — seed from the FIR bank at `0x040F98` and the reference tables at prog
`0x4450/0x5450`. Everything above (region, endianness, verified code site,
candidate DIL tables, working `c25dis.py`) is the head-start. Alternatively, a
live DSP dump from the modem sidesteps the base/overlay problem entirely.

## The supervisor's time base is not driven

The supervisor hangs its timeouts off a chain of countdowns serviced in one
routine: `[0x15b]`, `[0x15d]`, `[0x174]`, `[0x738]`, `[0x73a]`, `[0x742]`,
`[0x84f]`, `[0x1d74]`, `[0x2d4]` and `[0x32d]` are each decremented once per
pass, several with a call when they reach zero. The chain is entered at
`5b5e:0b1a` (physical `0x5c0fa`), which is the handler on **vector 0x0f** —
INT3 on the 80186.

In a payload run that routine never executes. `ATI11` is where it shows:
`0x62d63` sets `[0x328]`, `0x62d68` arms `[0x32d]` with 20 ticks, and
`0x62d6d` spins until either the flag clears or the count reaches zero. The
command is written to give up gracefully; with no tick it waits forever, and
the page stops after "Modulation". `ATI10` stops the same way.

Delivering a periodic edge on vector `0x0f` does complete both pages — and is
wrong. The interrupt controller shows `int3` **masked** for the entire run,
while `int0` and the timer are unmasked, so that edge is one the board cannot
take. Injecting it anyway changes call behavior: two linked instances answer
`OK` where an undriven run reports `NO CARRIER`, and `NO CARRIER` is the
correct answer for an `ATA` with no modelled DAA. The harness therefore
honours the mask: no edge is delivered on vector `0x0f` while `int3` is masked,
and `ATI10`/`ATI11` remain unfinished rather than finished by a fabricated one.

The DSP interrupt looked like the real source for a while: vector `0x0c` —
INT0, unmasked — enters at `0x6ad00` and begins with what reads as a divider,
`inc byte [0x176]`, compare against 25, and on reaching it
`mov byte [0x66c], 0x80`. Tracing that flag settles it, and not in favour of
the hypothesis: `[0x66c]` bit `0x80` is a watchdog alarm rather than a tick,
and it is never tested to decide whether to run the chain. See "The two
handlers watch each other" below. The chain still has exactly one entry, the
masked vector.

### The mask is set at boot and never cleared

`int3` is not masked by a condition the harness fails to meet. The peripheral
control block's setup table, written a word at a time by the `out` at
`0x5ba06`, masks it outright:

```
out 0xff1e = 0x000b     INT3 control: priority 3, MSK (bit 3) set
out 0xff08 = 0x0068     IMASK: INT0, INT2 and INT3 masked
```

Nothing writes either register again. Once the block is relocated into memory
the firmware touches only `0xff16` (DMA1), `0xff18` (INT0, ten times) and
`0xff1a` (INT1) — never `0xff1e`, never `0xff08`. The only post-boot accesses
to IMASK anywhere in the image are two read-modify-writes, at `0x5f3b5` and
`0x7a619`, and both are `or ax, 0x0004`: they set the DMA1 bit and preserve
INT3's.

The handler has no other way in, either. A byte-exhaustive sweep for `rel16`
references across its whole 64 KiB segment finds no `call` and no `jmp` to
`0x5c0fa`, nor to the second prologue at `0x5c178`. It is reachable only as a
vector.

Register offsets here are the **80C186EB/EC** map rather than the original
80186's — IMASK at `+0x08`, the interrupt controls at `+0x18`..`+0x1e`, timer 0
at `+0x30`..`+0x36`, and the chip selects at `+0xa0`..`+0xa8` as start/stop
pairs, which is the shape `rom.py` decodes from the reset stub. Base `0xff00`
is confirmed arithmetically: timer 0's max count of `0x7e00` is written to
`0xff32`, and that is the 32,256 the timer model reports as `compare_a`.

### The one enabled periodic source is a stub

Timer 0 *is* unmasked, and fires — 2,842 timer interrupts in a 14 M-instruction
run. Its handler, vector `0x08` at `5b5e:1246` (physical `0x5c826`), is:

```
0x5c826   c70602ff0080   mov word ptr [0xff02], 0x8000    EOI
0x5c82c   cf             iret
```

Acknowledge and return. So the payload has no live periodic service at all:
the source wired to the countdown chain is masked, and the source left enabled
goes nowhere.

### The same table is in every image here, including a boot block

This is not an artifact of an update payload lacking its boot block. The
identical setup table appears in every Courier firmware in the tree, with the
same `1eff 0b00` entry:

| image | table at |
|---|---|
| `main211.xmf`, `3453Bv2.1.1.xmf` | `0x1b908` |
| `main2205.XMF` | `0x1b928` |
| `MAIN_2.3.12/15/31.XMF`, `2_3_33.XMF` | `0x17ed8` |
| `IDSDL302.ROM` | `0x326` |

`IDSDL302.ROM` is a complete flash part, and `0x326` is inside its boot block.
So the boot block masks INT3 too, unchanged from 2.1.1 through 2.3.33 and
across two products. What the two images share is only this table: the
byte-identical window around it is 62 bytes (−40..+22), and two entries just
outside it already differ — `[0xff70]` is `0x8102` in the ROM against `0x814f`
in `main211`, `[0xff60]` is `0x8082` against `0x80a7`. Same registers,
board-specific values; the interrupt configuration is what does not vary.

For contrast, the ISDN Courier's **386** payload has everything this one lacks.
`Ie030002.nac` initialises the 8259 pair and takes 2,894 delivered interrupts
in a 20 M-instruction run, programs all three 8254 counters as mode 2 rate
generators at 641.5 Hz, 133.6 Hz and 33.4 Hz, and runs VRTX on top of them —
5,822 `int 0x30` kernel calls in the same run. That is what a live time base on
this hardware family looks like.

### The two handlers watch each other

`[0x66c]` is a bitfield, not a flag — 335 accesses across the image use every
bit from `0x01` to `0x80`. Bit `0x80` is the one both interrupt handlers write,
and each writes it when the *other* has stopped.

The tick's side sits at `0x5c18f`, inside the countdown chain:

```
test byte [0x1fb9], 1
jne  0x5c1b2                 ; the check is switched off
cmp  byte [0x176], 0
jne  0x5c1b2                 ; a DSP interrupt arrived this tick, so all is well
inc  byte [0x177]            ; otherwise count consecutive silent ticks
cmp  byte [0x177], 3
jb   0x5c1b7
mov  byte [0x66c], 0x80      ; three silent ticks: raise the alarm
or   byte [0x1fb9], 2
0x5c1b2:  mov byte [0x177], 0
0x5c1b7:  mov byte [0x176], 0    ; and reset the DSP counter every tick
```

The DSP's side is the divider above: `inc byte [0x176]`, and once it reaches 25
without a tick having cleared it, the same `mov byte [0x66c], 0x80`. So the
tick fires the alarm when the DSP goes quiet, and the DSP fires it when the
tick does. The bit carries no timing — it means "my counterpart has stopped" —
and the code that waits treats it as an abort. `0x5dbe0` tests it immediately
before the detector wait and jumps to the timeout at `0x5dc53` when it is set;
there are around a hundred `test byte [0x66c], 0x80` sites.

In this harness that watchdog is permanently tripped. `[0x176]` is only ever
cleared at `0x5c1b7`, inside the handler that never runs, so it free-runs as a
byte and spends 231 counts in every 256 at or above 25. Over a 30 M-instruction
`ATDT` run:

| site | executions |
|---|---:|
| `0x6ad00` INT0 entry | 6,618 |
| `0x6ad11` `mov byte [0x66c], 0x80` | 5,969 |
| `0x5c0fa` INT3 entry | 0 |
| `0x5c1b7` `mov byte [0x176], 0` | 0 |

Nine DSP interrupts in ten stamp the alarm. The instruction is a `mov`, not an
`or`, so each of those ~6,000 stores also wipes bits `0x01`..`0x40` — six other
flags that hundreds of sites across the image read and write. The masked
interrupt does not merely withhold the countdowns; its absence actively
corrupts a shared byte several thousand times per run, and any behaviour read
off a run has to be weighed against that.

### What the mask costs

The handler's last act before its EOI is a call into the DAA:

```
0x5c69d   e86c1d         call 0x5e40c
0x5c6a0   9af900d06a     lcall 0x6ad0, 0x00f9
0x5c6a5   ff16dd06       call word ptr [0x6dd]
...
0x5c6b6   c70602ff0080   mov word ptr [0xff02], 0x8000
0x5c6bc   cf             iret
```

`0x5e40c` is a prescaler — `inc [0x642]`, compare against `[0x640]`, and on
wrap `call word ptr [0x65e]` — driving the state chain armed at `0x5db6c`
(period 3), `0x5dbb2` (4) and `0x5dc11` (20). Those states send `0x7c00` and
`0x8000` to the board and consume the replies, which arrive as mailbox tags
`0x7c` into `[0x285]`/`[0x283]` and `0x7e` into `[0x281]`. `[0x285]` is banded
zero / `1..0x60` / above `0x60`, and the low band is what increments `[0x649]`
— the five-hit detector byte the originate contract above depends on.

So the harness's stand-ins are not filling in for a missing device. `[0x649]`,
`[0x8d6]` and the `[0x14e]`/`[0x152]` delay pair are all counters this one
handler services, and they are forged because the interrupt that would service
them is switched off. Driving `int3` faithfully would retire all of them
together; forging `[0x649]` in particular also keeps the poller from ever
running, so no run has yet sent a `0x7c00` request or received a `0x7c` reply.

`[0x289]` does **not** belong on that list, though an earlier revision of this
section put it there. Its servicer is alive; see below.

### Two clocks, not one

Every countdown named above is decremented at exactly one site, and for all but
one of them that site is inside the masked handler. Scanning the whole image
for `inc`/`dec` against each of them gives a single exception:

```
[0x289]   sites in the INT3 handler: 0    elsewhere: 1  (0x6ade5)
```

`0x6ade5` is in the tail of the **DSP** interrupt, vector `0x0c`, which is
unmasked and runs:

```
0x6add3   cmp word [0x161], 0
0x6add8   je  0x6adde
0x6adda   dec word [0x161]
0x6adde   cmp word [0x289], 0
0x6ade3   je  0x6ade9
0x6ade5   dec word [0x289]
0x6ade9   pop es ; popaw
0x6adeb   mov word [0xff02], 0x8000     EOI
0x6adf1   iret
```

That handler advances exactly three things: `[0x176]`, the watchdog counter
above, and the two countdowns `[0x161]` and `[0x289]`. Nothing else.

`[0x289]` is the detector wait — armed at `0x5db8d`, tested at `0x5dbe7`, and
the interval the originate path spends waiting on the line. It is therefore on
a **live** clock, and is being advanced in every run today. Over the same 30 M
`ATDT` run as above:

| site | executions |
|---|---:|
| `0x6ade5` `dec word [0x289]` | 6,616 |
| `0x6adda` `dec word [0x161]` | 0 (never armed on this path) |
| `0x5dbe7` the detector wait's compare | 15,416 |
| `0x5dc4a` that wait timing out | 0 |

`[0x161]` is a real timer too, armed from eleven sites and compared at
fourteen; a dial simply does not use it.

The split this implies fits the board better than a single time base would: the
tick handles supervisor housekeeping, and the DSP frame interrupt handles what
has to track line time. It is also a point in favour of the countdown chain
being genuinely dormant in these builds rather than something the harness
merely fails to trigger, since the parts of the firmware that must keep line
time are not on it.

### Pacing the chain from the DSP interrupt

If the DSP frame interrupt is what keeps line time, the obvious thing to try is
letting it pace the countdown chain too — deliver vector `0x0f` once per DSP
interrupt and see what the firmware makes of it. This now ships as
`--tick-source dsp`, off by default, on both `run` and `link`.

It runs, and the firmware's own consistency check is what says so:

| site | with the tick paced | before |
|---|---:|---:|
| `0x5c0fa` INT3 entry | 6,691 | 0 |
| `0x5e40c` the poller | 6,691 | 0 |
| `0x5c1b7` `mov byte [0x176], 0` | 6,691 | 0 |
| `0x6ad11` the watchdog stamp | **0** | 5,969 |

The mutual watchdog goes quiet for the first time. That is not luck: its two
limits *bound the legal ratio*. The DSP interrupt has to arrive at least once
in three ticks or the tick's side alarms, and the tick has to arrive at least
once in twenty-five DSP interrupts or the DSP's side does. So ticks per DSP
interrupt must lie between 1/25 and 3, and 1:1 sits inside that. The band is
read out of the firmware; the choice of 1:1 within it is not, and remains a
guess.

Downstream, things that had never happened started happening. Host-to-board
traffic gained `0084:3100` — the revision-gated register write at `0x5e551` —
alongside `0080:0000` and `007c:0000`, the `si` read and the detector request.
With the forged `[0x649]` still in place `ATDT5551234` answered `OK` where
every previous run answered `NO CARRIER`.

Removing the forgery is where it gets informative. With the poller asking and
nothing answering, the firmware reports `NO DIAL TONE` — the correct answer for
a line it cannot hear, reached through its own code rather than through ours.
Answering `0x7c00` with a reading in the `1..0x60` band then increments
`[0x649]` through the firmware's own path for the first time.

Both halves of that are now in the tree. The bridge answers the detector
request whenever the DAA has something on the line — `dsp_bridge`
`detector_replies` counts them, 44 in a 40 M-instruction linked run — and
pacing the chain switches the harness's two forgeries off together: it neither
writes `[0x649]` at `0x5dbe7` nor zeroes the `[0x289]` wait that count runs
inside, because both are the firmware's own once the poller is alive. A linked
pair then leaves command mode, swapping the DTE callback table `acdf,1fce,a8d9`
for `50ad,18e3,4cac`, and answers `OK`. `OK` is not a call result code and the
line behind it is still silent on both sides, so this is the supervisor acting
on state the harness supplied rather than two modems that trained.

### What parks the state chain

It does not reach five hits, and the reason is not a stall. State `0x3023` —
physical `0x5e603` — is a bare `ret`, a do-nothing idle state, and the chain is
pointed at it deliberately. Of 1,657 dispatches in that run:

```
3023 (idle ret)          1,644
2e44 send 0x7c00             3
2e53 send 0x8000             3
2e62 consume [0x285]         2
2f5a gate block              2
2eb7 send 0x7c00 (loop B)    1
2ec6 send 0x8000  (loop B)   1
2ed5 consume      (loop B)   1
```

So the chain armed, cycled through both request/consume loops, and was then
parked. Fifteen sites write `0x3023` into `[0x65e]`, and two of them account for
it: `0x65512`, the supervisor's main loop, and `0x5dbfa`, immediately after the
detector wait. The chain is **scoped to a line operation** — armed at
`0x5db6c`, `0x5dbb2` and `0x5dc11` when one begins, parked the moment the wait
finishes or the supervisor returns to its command loop.

That is correct behaviour, and it relocates what is left. The window closed
because the detector never qualified, not because the pacing is wrong. Inside
it the chain got about a dozen dispatches and landed one low-band reading
across two consume passes, because a reply queued when the request is written
is not necessarily visible when the consume state next runs. The remaining
problem is therefore delivery timing — the same shape as the `0x02`/`0x03`
handshake the bridge already models, where a reply has to be on the bus when
the consumer polls rather than merely queued. Five hits inside the 500-decrement
window is otherwise comfortable: at 1:1 with a prescaler of 3 they cost about
fifteen dispatches.

Two things this does not establish. The 1:1 ratio is a choice inside the legal
band, not a measurement. And the experiment used revision `0x33`; with the
default 4 the gate at `0x5e547` fails and `0084:3100` never fires, so the
revision question is now load-bearing rather than cosmetic.

### Why this is the blocker for placing and answering calls

Most of what a call needs is downstream of this one interrupt. Qualifying what
comes back from a seizure is the `[0x649]` path; ring qualification is the
`[0x647]`/`[0x648]` debounce on the tag `0x7e` ring bits, counted against the
S-register at `[0x92a]`; the pre-dial interval is `[0x8d6]`; call progress runs
through the same `[0x65e]` state chain. Those are serviced by the handler on
the masked vector, and every one the harness forges is a place where the
firmware stops telling us what the board would do and starts telling us what we
told it.

The exception narrows the problem usefully. The wait the originate path spends
on the line, `[0x289]`, is on the live clock, so the call path is not uniformly
dark: what is missing inside a wait that already works is the counter that wait
is waiting on. That makes `[0x649]` the single counter standing between here
and an originate that runs on the firmware's own terms.

Four explanations for the mask have been tested and three are closed. It is not
a condition the harness fails to meet: nothing in the image writes the register
a second time. It is not a misread register map: timer 0's max count
cross-checks the base. It is not an update payload inheriting a boot block's
work: the one complete flash ROM here masks it inside its own boot block. What
remains is that the countdown chain is dormant in every build we have and the
shipping modem keeps time somewhere we have not looked — which cannot be
settled from these images alone. A RAM or state dump from a physical Courier,
already the highest-leverage item under "Possible next steps", would settle it
directly: read `[0x176]`, `[0x177]`, `[0x66c]` and the interrupt controller's
mask on a running modem and the question answers itself.

The pacing experiment above weakens one reading of that, though. If the chain
were vestigial in these builds, running it should have produced nonsense;
instead it put both watchdogs into their healthy state, sent the register write
its own revision gate asks for, and answered a dial through its own code. That
is not proof the board drives it from the DSP frame — only that no other
configuration tried here leaves the firmware's own consistency checks
satisfied.

## The DTE front end the harness stands in for

The board's UART front end is absent from a payload run, so the harness
installs its callbacks at the main-loop milestone. Four further pieces of that
same contract were recovered by driving a live console:

- **Attention prefix.** `0x65f03` receives the assembled line, and the harness
  strips the `AT`/`at` prefix there. The other half of the contract was
  missing: a line with no prefix was passed through unchanged, so `I3` ran as
  `ATI3`. The terminator advances the command state whatever was typed,
  because that state machine sits downstream of the detector, so a completed
  line without the prefix is now returned to command-line-ready with the
  parser uncalled — no result code, nothing executed. `A/` and `A>` are the
  detector's own two-character forms and are left alone.

- **One command line at a time.** The state machine publishes itself as the
  callback pointer at `0x02ac`: `a8d9` collects a line a character at a time,
  the terminator advances it to `a910`, which parses and prints, and the
  end-of-command path at `a8b1` clears the collector and returns to `a8d9`.
  Bytes delivered into the `a910` window are assembled into a buffer nothing
  goes on to parse — the firmware's own type-ahead flag at `0x1cf2` is what
  carries a line across, and it is set by the front end. Holding input until
  `a8d9` is what makes a second and third command answer.

- **Collect versus keystroke.** At `0x662d0` the receive path tests the
  collect flag `0x1cee` bit `0x40`: armed, it appends to the command buffer at
  `0x1cf5`; clear, it takes `0x662d7` instead and sets bit `0x20`, the flag a
  running command waits on for a keystroke. The help pages spin on that flag —
  `test byte [0x1cee], 0x20`, nine sites in `main211`, one of them the
  `0x73824` loop behind "Strike a key when ready". Arming the collector for
  every delivered byte swallows those keystrokes as command text and the pager
  never wakes.

- **A reset rebuilds the table.** `ATZ` reloads the profile and rewrites the
  callbacks to the board-less defaults. Installing the stand-in only once left
  the DTE deaf afterwards: the next typed byte entered the receive ISR at
  `0x5d5b0`, dispatched through the nulled callback into the fatal entry at
  `5b5e:0000`, and blinked error `0x0b` for the rest of the session.

Echo belongs to the same layer. The setting is `[0x092d]`, which `ATE0`/`ATE1`
change and which the `no-echo` option switch leaves clear at `0x63e93`, so the
harness echoes from the firmware's own byte rather than a flag of its own.

## The parameter flash service the update image does not carry

`AT&W` assembles a sector image in RAM and then calls the boot block through
`int 0x0a` with an ASCII service letter in `BL`:

| service | meaning |
|---|---|
| `E` (0x45) | erase the 4 KiB sector selected by `ES` |
| `W` (0x57) | program the word in `AX` at `ES:DI`, then advance `DI` |
| `S` (0x53) | firmware-update path |
| `L` (0x4c) | block lock/select |

The writer at `0x7dfa8` blank-checks the destination at `0x7e0e3` — 2,048
words against `0xffff` — erases when that fails, then walks the assembled
image a word at a time. An update payload has no boot block, so every one of
those calls lands on a vector that is not there and `AT&W` stops on the first.
The harness answers `E` and `W` against a modelled part; `S` and `L` still
stop the run rather than continue on a guess.

That the answers match the part is checked by the firmware itself: the sector
it writes passes the CRC computed independently by `parameters.py`, its own
reader finds the value again after a fresh boot, repeated stores rotate the
four sectors and erase one to wrap, and no program ever tries to set a bit in
an unerased word.

`ATY15` is gated on this store rather than missing. `0x8339f` tests
`[0x0a03]` bit `0x04` before the `cmp al, 0x0f` case is even reachable, and
`[0x0a03]` is loaded at `0x7e05c` from sector offset `0x04` — type1 — only
when the sector's flags bit 3 is clear. With a sector built that way the
command prints the factory switch page, which reports all ten option switches
and is an independent read on the board model.

## Emulator core corrections

Two defects in the C52 core were found by following the serial path:

- **Indirect addressing modes 8 and 9 were missing.** The ARU field is bits
  6-4 with bit 3 selecting the ARP update, so `100` is `*BR0-`, the
  bit-reversed form. The service overlay reaches it at program `0xe581` once
  the serial port answers a transmit-ready poll, and the core stopped dead
  there. The core had `*BR0-` at modes `0x6`/`0x7`, which that encoding
  reserves.
- **The serial port had no status bits.** `SPC` read back exactly as written,
  so `XRDY` and `RRDY` never set and a transmit handshake could not complete.
  They are now answered from the port's state.

## Possible next steps

1. **Live RAM/state dump from the physical modem** (highest leverage): if the
   Courier exposes any memory-peek / debug-monitor capability, dumping segment
   `0x8000` (RAM) gives the resident code directly, and dumping DSP program RAM
   during a V.90 handshake gives the *active* overlay — sidestepping the whole
   static bank-mapping problem. Worth probing what debug AT commands this firmware
   supports (there are undocumented USR ones).
2. **Interactive disassembler + human loop**: load the flash into IDA/Ghidra (IDA
   has a TMS320C2x module) and resolve the boot/bank config manually, starting from
   the verified banner anchor and the port `0x19/0x3E` I/O. This is patient,
   multi-session RE — not automatable here because of the decode-anything problem.
3. **Mine the DSP data tables** (tractable now): the datapump region is
   data-dominated — extract the constellation/interleaver map (`flash 0x3B780`) and
   coefficient tables, which describe the constellation machinery without needing
   code RE.
4. **Correlate live** (needs a connected call): `ATI6`/`ATI11` Timing/Carrier
   Offset + echo vs. our DIL timing, to fork clock-recovery vs. constellation
   rejection.
5. **Answer as the DAA at the ASIC boundary**: establish what the C52 reads
   once per frame from external I/O `0x50` at program `0x8c1f` — the code that
   consumes it, and which bits it tests — then drive it from the line model
   instead of letting it float high. The datasheet fields above say what that
   status should carry. The eight supervisor latches at `0x40`..`0x4e`, written
   about 15,000 times each during a dial, are the other half of the same
   boundary.
6. **Trace the tick**: find how `[0x66c]` bit `0x80`, set by the DSP interrupt
   every 25 entries, reaches the countdown chain at `0x5c0fa`. That would give
   the supervisor a time base from the source the board actually has, and with
   it every firmware timeout — including the `ATI10`/`ATI11` pages.

## Complete flash ROM — `IDSDL302.ROM`

A 1998 512 KiB ROM dump of a Courier V.Everything **external** (`$USR0100\\MODEM\\
PNPC107\\Courier V.Everything EXT`, copyright through 1998). This is the whole
part rather than an update payload, which settles several things `main211.xmf`
could only leave as modelling choices. `courier-emu rom-info` recovers all of it
from the image.

### The image places itself

The last sixteen bytes are the 80186 reset vector, and the stub there programs
the chip select that decodes the ROM before it jumps:

```asm
ffff0  cli
ffff1  mov dx, 0xffa4        ; UCS start, 80C186EB chip-select unit
ffff4  mov ax, 0x8000
ffff7  out dx, ax
ffff8  jmp far 0xfc00:0x1a21
```

So the ROM occupies `0x80000..0xfffff`, and the boot block is entered at
physical `0xfda21`. The boot stub then replays two setup tables — 36 word
writes and 9 byte writes — which give the rest of the map:

| register | value | meaning |
|---|---|---|
| `0xffa4`/`0xffa6` | `0x8000`/`0xffce` | flash `0x80000..0xffc00` |
| `0xffa0`/`0xffa2` | `0x0000`/`0x200a` | RAM `0x00000..0x20000`, 128 KiB |
| `0xffa8` | `0x10ff` | peripheral control block relocated into **memory** at `0x0ff00` |

That last row is worth stating plainly: the harness already hooks memory
`0xff00..0xffff` as the peripheral control block, and this is the firmware
programming that relocation itself.

The byte table seeds the board latches, and two of its values are exactly what
the 2002 firmware's own boot writes: port `0x12` = `0x7f`, port `0x14` = `0xf5`.

### The boot block the update image does not carry

`main211.xmf` starts at the application; the ROM has ~6 KiB above it at
`0xfbff0..0xfda69` that the update never replaces. It does, in order:

1. programs the peripheral control block from the two tables,
2. copies its own 0x1975 bytes to physical zero — the first 0x400 bytes of that
   block are an interrupt vector table, so the copy installs the vectors and the
   code together — and enters through `int 0x13`,
3. polls input port `0x10` bit `0x08` with a timeout, then bit-bangs the
   Microwire settings EEPROM,
4. CRC-16s the whole flash a segment at a time,
5. jumps into the application at `0x80000`.

The CRC routine at relocated `0x03e0` is the same per-byte CCITT update
recovered from `main211.xmf` at `0x72930` and implemented in
`courier_emu/parameters.py`, confirmed across a four-year build gap.

Step 3 qualifies a claim made from the update image alone. There is no
boot-time NVRAM profile load in `main211.xmf` — but the code that reads the
EEPROM at power-on is in the boot block, which an XMF update does not contain.
Booting this ROM against the emulator's EEPROM model shows it reading word 0,
finding `0xffff`, and programming it to `0x0000`: an unconfigured part being
initialised.

A second `SDL Xmodem file transfer` copy sits at `0xfc1db`, inside the boot
block, which is where a recovery loader has to live.

### The parameter sectors are the top of the same part

The search at `0x7e07c` walks four 4 KiB sectors from `0xf8000`. In this image
all of them read erased, so a dumped image cannot supply a parameter sector —
it is written per-unit at manufacture. What the ROM does establish is that the
region is not a separate part: it is the top of the same flash, immediately
below the boot block.

### Cross-build confirmation of the board model

The ROM has the same latch driver, called the same way (`mov ax, mask << 8 |
index; call`), with the same index encoding — read entry at `0x827d1`,
set/clear at `0x82771`/`0x8279b`, shadow read at `0x82750`. Every board input
the 2002 firmware reads is read here too:

| signal | `main211.xmf` | `IDSDL302.ROM` |
|---|---|---|
| identification strap sense | 5 sites | 5 sites, same mask/index |
| board option input `0x80`/port `0x10` | 1 site | 1 site |
| DTR, port `0x12` bit `0x40` | 3 sites | 3 sites |
| carrier-detect switch, port `0x14` bit `0x04` | `0x5e3cf` | `0x82876` |

The carrier-detect handler is structurally identical: same mask, same shadow
bit `0x20`, same `[0x652]`-equivalent flag bit, same setting byte cleared to
zero for `&C0`.

The option switches themselves move. This build reads seven of them from one
port (index 3, masks `0x01`, `0x02`, `0x04`, `0x08`, `0x10`, `0x20`, `0x80`)
where the 2002 firmware spreads the same functions across ports `0x10`, `0x12`,
and `0x14`. Matching them by what each one writes:

| function | ROM port/mask | `main211.xmf` port/mask |
|---|---|---|
| result codes displayed | `0x12` `0x01` | `0x14` `0x20` |
| numeric result codes | `0x12` `0x02` | `0x10` `0x02` |
| auto answer off (S0) | `0x12` `0x04` | `0x14` `0x10` |
| echo off | `0x12` `0x08` | `0x12` `0x10` |
| quiet in answer mode | `0x12` `0x10` | `0x12` `0x08` |
| DTR override (S14) | `0x12` `0x20` | `0x12` `0x20` |
| quiet, capability-gated | `0x12` `0x80` | `0x12` `0x80` |
| carrier detect forced on | `0x14` `0x04` | `0x14` `0x04` |

Two land on the same pin in both builds and one function per row is identical,
so this is independent confirmation of what each switch *does*. It is not a
switch numbering: the ROM's bit order does not follow the published switch
numbers either, so which position on the case drives which pin still needs a
physical unit.

### Booting it

`courier-emu run IDSDL302.ROM` boots the ROM from its reset vector. The image
type is detected from the file, the ROM maps where its own chip select says,
and the harness dispatches real-mode software interrupts so the boot block can
enter through the vector table it installs at physical zero.

The peripheral timers are modelled from the instruction clock, which is what
gets the ROM past its self-test:

```asm
80432  mov word ptr [0xff46], 0xc000   ; T2CON: enable
80438  mov word ptr [0xff42], 0        ; T2CMPA: a zero compare is 65,536
8043e  mov word ptr [0xff40], 0        ; T2CNT
80444  test word ptr [0xff46], 0x20    ; wait for MAX COUNT
8044a  je 0x444
```

The model covers the enable gate (a new ENABLE is only taken when INHIBIT is
set in the same write), the zero-compare-is-full-range rule this self-test
depends on, single-shot versus continuous, and the sticky max-count bit. It
also covers the mask side of the interrupt controller, which turns out to
matter: the boot table writes `IMASK = 0x0079`, masking the timers, and
delivering a timer interrupt through that mask lands in a handler that is only
consistent later in the sequence.

### The system tick is calibrated from an external interrupt

With the timers modelled the ROM runs on to a different wait, at `0x80a52`:

```asm
80a52  push ax
80a53  mov ah, byte ptr [0x12a]        ; the tick byte
80a57  add ah, al                      ; al = how many ticks to wait
80a59  cmp ah, byte ptr [0x12a]
80a5d  jne 0xa59
```

Nothing advances that byte, and the reason is that this firmware does not run
its tick from a fixed timer period at all. `0x9eb73` starts timer 1 as a
stopwatch with a 54,166-tick timeout and unmasks INT1. The INT1 handler at
`9ea4:0722` then does the calibration:

```asm
9f162  mov word ptr [0xff46], 0xe001   ; T2CON: enable, interrupt, continuous
9f169  mov ax, word ptr [0xff38]       ; timer 1's count - the measured interval
9f16c  rcr ax, 1
9f16e  and ax, 0x7fff
9f171  add ax, word ptr [0xff38]       ; one and a half times it
9f175  mov word ptr [0xff42], ax       ; T2CMPA: the system tick period
9f178  mov word ptr [0xff12], 0        ; unmask the timer interrupt
9f183  mov word ptr [0xff3e], 0x6001   ; stop timer 1
9f189  mov word ptr [0xff1a], 8        ; mask INT1 again
```

So timer 2 is the tick, and its period is one and a half times however long the
first INT1 edge takes to arrive. What drives INT1 physically is not established
here. `--int1-after MS` supplies one edge as a harness stimulus, the same way
`--ring` supplies ring cadence, and with it the sequence runs: timer 1 stops
with a count, timer 2 is programmed, the timer interrupt is unmasked, and a
timer 2 tick is delivered through vector 19.

Two things then stop it short of a running tick, both visible in a trace:

- The measured interval comes out around 45,000 ticks, and one and a half times
  that overflows sixteen bits, so the tick period lands at 2,112 ticks instead
  of the intended value. The interval is set by how long the firmware keeps
  interrupts disabled after starting the stopwatch, which is about 10,000
  instructions here; whether that is faithful depends on an instruction-to-time
  ratio calibrated against the 2002 build, not this one.
- Code at `0x8e3e6` and `0x8e487` reuses timer 2 as a scratch delay - enable,
  zero compare, poll max count - which clears the interrupt bit the tick needs.
  On hardware something must sequence those against the tick; what, is not
  recovered.

The XMF path is deliberately left alone. An update image is entered at the
application, past the boot block that programs the control block, and its
delays are already served by the harness's calibrated helpers; answering its
timer reads from the model instead puts its own timer interrupt service routine
on a path it does not return from. Its writes are still tracked, so a run now
reports what it programs: compares of 32,256, 40,624, and 65,535 on the three
timers.

## Older C51 SDL package and V.8 frame path

The DOS `SDL_49.EXE` stores firmware in 16-byte records followed by a checksum,
a `0x10` marker, and a 24-bit address token. `tools/unpack_sdl.py` removes that
framing, joins continuation runs, decodes each module's `02 00 00 02` load
descriptor, and reconstructs a sparse 1 MiB flash image. The C51 resident DSP
image is loaded at program `0x8000`; call overlay 7 is downloaded to `0xb000`.
The mapping is exact in the reconstructed flash: module 10 at physical/file
`0xa9140` supplies 55,392 bytes at C51 program `0x8000`, and module 12 at
`0xbc3b0` supplies 14,976 bytes at program `0xb000`. For example, dispatcher
word `BACC` at program `0xc537` is byte `20 be` at flash `0xbee1e`, independently
fixing the overlay origin. The supervisor selects it with `[0x0d28]=7` and
transfers it through ports `0x40..0x4e` under command/status port `0x1e`.

Overlay 7's V.8 setup occupies `0xb4c5..0xb55c`, its dispatcher is
`0xc529..0xc537`, and the state table is `0xc538..0xc5e9`. The indirect branch
at `0xc537` reads callback word `[0x03c8]`; handlers beginning at `0xc5ea` and
`0xc5f9` advance it through the table and reach the matched-filter code around
`0xc9d9`. This path exposed and now has implementations for `MACD`, `SQRA`,
`SQRS`, `SUB ...,16`, `NORM`, `ZALR`, `ABS`, and `SATH` in the native core.

The older ASIC's line output is external C51 I/O port `0x006a`. Startup clears
it at program `0x804e`, and the two runtime paths write words at `0x81ea` and
`0x8205`; the native sample collector now captures that port. Their separation
is now concrete rather than just an observed alternation. The interrupt-side
entry at `0x81cc` first executes `LDP #0x17`, uses data page `0x0b80`, writes
its `@0x7b` word at `0x81ea`, and ends in `RETE` at `0x81f0`. The datapump calls
the other entry, `0x81f5`, from exactly `0xb318` and `0xcf99`. It retains the
caller's page (`DP=0x0380` on the V.8 path), tests `BIT @0x1f,8`—effective cell
`0x039f`—and branches to `0x89da` while that bit is clear. With bit 8 set it
falls through and writes the page's `@0x7e` word (`0x03fe`) at `0x8205`.
Dynamic runs take 166 instructions and emit nothing for the clear phase, versus
20 instructions and one `0x8205` write for the set phase. Thus `0x81ea` is the
interrupt/control slot and `0x8205` is the paced datapump slot; treating every
`0x006a` write as consecutive PCM would interleave two different TDM slots.
The paced slot is consistent with one complete line sample at **9.6 kHz**, the
same rate used by the later board.

Forcing the ready bit proves transport and captures nonzero words, but does not
yet produce valid V.8 audio without the C51 mask-ROM scheduler and real ASIC
phase word. The other previously-fatal boundary is now decoded and implemented
architecturally: `0xbe71` at `0xcfa6` is `INTR 17`, specifically the software
TRAP vector. It pushes `PC+1`, masks interrupts, saves the interrupt context,
and transfers to `(PMST.IPTR<<11)|0x22`; `RETI` restores that context while
leaving `INTM` set. This removes an emulator opcode gap but also makes the
remaining hole precise: vector `0x22` and its handler are in the absent C51
mask ROM, not in the downloaded resident or overlay image.

The initial V.8 table selector is now exact. At `0xb4da`, AR1 is loaded with
`0x006f`; the code masks that control word to its low two bits, ORs in `0x0050`,
and tests bit 1. It first installs table `0xc544`, then `XC 2,TC` conditionally
replaces it with `0xc53c`. Thus `[0x006f]&2` selects `0xc53c` and a clear bit
selects `0xc544`. Dynamic execution confirms the resulting words are `0x0052`
and `0x0050`, respectively. Later states explicitly install `0xc548` at
`0xb50d`, `0xc538` at `0xb521`, `0xc540` at `0xb544`, and `0xc53c` at `0xb559`.
The table choice is therefore DSP-local originate/answer control, not an ASIC
address: the ASIC supplies phase-ready bit 8 at `[DP|0x1f]`, while the low
control bits at `[0x006f]` select the V.8 state family. Launching through the
real selector now works: establish ARP1, set `[0x006f]=2`, and enter `0xb4d7`;
the routine normalizes the control to `0x0052`, installs `0xc53c`, and the
`0xc529` dispatcher enters `0xc5f9` rather than a manually seeded callback. It
advances the active handler to `0xc61c` while retaining pattern `0x0303` in the
state block. Reinvoking the dispatcher without the mask-ROM frame service only
toggles state word `[0x03ca]` between zero and one and leaves `0xc61c` active.
The slot interpretation is therefore no longer the ambiguous part: the missing
step is the ROM/ASIC scheduler that drives the `0x81cc` control interrupt,
publishes bit 8 in `[0x039f]`, and resumes the V.8 callback once per audio slot.
It is not another table selector.

## C52 call-overlay publication and recovered service slot

The later C52 image carries the call datapump as a runtime program overlay at
source `0xb9c0`, with `0x0a58` words copied to destination `0xc418`. Publishing
that bank immediately is incorrect: the resident idle service still executes
through the destination range before the ASIC commits the call bank. The native
ASIC model therefore holds the overlay pending and publishes it atomically with
the call entry.

The missing mask-ROM dispatcher also imposes a concrete entry ABI. The
call initializer begins at the overlapping instruction stream at `0x2295` and
must be entered while resident code is at `0xb2f6`, with TDM phase zero and
between 128 and 192 C52 cycles remaining before the next 258-cycle frame edge.
Entering at an arbitrary instruction or at the wrong subframe writes zero to
`IMR` after roughly 45 frames and strands the datapump around `0xc81a`. At the
recovered service slot it installs `IMR=0x9880`; IRQ 7 continues through the
downloaded ISR at `0x0228`, and the overlay emits sustained nonzero samples.
The ASIC also changes the shared `0x50..0x5f` pins from download-window data to
running TDM latches on this same edge.

Tracing both reads and writes in the ISR pins the external TDM slots more
closely. The handler reads prior/control words at `0xfff8..0xfffd`, rereads the
normalization word at `0xfffe` three times from PC `0x0241`, writes the
oversampled line result to `0xfffd` at PC `0x0238`, and writes the repeating
control word to `0xffff` at PC `0x0247`. Constant-value experiments identify
`0xfff8` and `0xfff9` as the two input-delay terms multiplied by the phase
coefficient at `0xfffa`; changing either strongly changes the result, while
changing `0xfffd` before the ISR or changing `0xfffe` does not. The ASIC now
shifts each new 9.6 kHz ADC word through `0xfff8/0xfff9` and boxcar-filters the
`0xfffd` polyphase output back to line rate. I/O `0x5b`/`0x5e` is used only
during a short initializer around `0xb627..0xb669`, not continuously.

The 258-cycle interrupt is a roughly 96.9 kHz TDM *slot* clock, not itself the
9.6 kHz codec rate. Physical line exchange is consequently paced by complete
960-sample DSP frames instead of the faster supervisor instruction clock. This
removed a large queue of stale idle samples that had delayed current call audio
by many emulated seconds.

The linked-line model now also supplies exchange dial tone until an originating
side starts dialing, then switches to the peer's loop/audio; it no longer
requires the obsolete second-bootstrap assumption. Repeated supervisor register
commits are only latched by the ASIC and are not written asynchronously into a
running C52. That prevents hundreds of later `AR3..BMAR` command blocks from
corrupting the datapump context.

With one side originating and one answering, both consume current line-rate
peer samples and produce distinct role-dependent output. The input is now
observably live: feeding the answer stream instead of zero changes receive
filter cells `0x035c`, `0x069c`, and `0x0b49`, which are consumed by the long
convolution loops at `0xc81c` and `0xc855`. A 50-million-instruction linked run
exchanges 79,018 samples per side without stale backlog or an emulator error,
but still does not reach `CONNECT`. The remaining blocker is the call-state
transition/callback after these filters, including the still-unmodeled
ASIC-to-supervisor completion publication; native `TRCV/TDXR` is polled during
initialization but does not carry the sustained stream.

### The firmware route to CM/JM, and the word that blocks it

The answer-side experiment that re-entered `0x2295` after detecting CI was
wrong. `0x2295` is the one-time call initializer; entering it again discarded
the live datapump context and eventually wrote zero to `IMR`. The downloaded
overlay remains active across the CI/ANSam handoff. The ASIC now only stops its
bootstrap tone and releases the overlay's callback-ready bit; it does not
invent a second firmware entry.

Following that route exposes the firmware's own V.8 state engine. Handler
`0xc617` calls the indirect dispatcher at `0xc418` while timer 0 counts down.
The dispatcher reads handler pointer `0xc617` from data register `0x48`. Once
the countdown expires, the handler executes the setup through `0xc6bc` and
enters the convolution/division loop at `0xc853`:

```text
c852  ZPR
c853  BCNDd c853, GEQ
c855  LTS   *+, AR2       ; delay slot
c856  MPYU  *-, AR1       ; delay slot
```

The first operand pair is exact: data `0xa51b` is zero and data `0xd2a8` is
one. Subsequent cells on both walks are zero. `ZPR` clears the first product,
so `LTS` never reduces the positive accumulator; AR1 walks upward and AR2
downward forever while IRQ 7 continues to service TDM. This is not a missing
callback: it is the callback running on an absent data vector.

Two bounded perturbations locate what is missing. Setting only `0xa51b` to
`0xffff` lets the first invocation return and changes the active handler from
`0xc617` to `0xc597`. Presenting `0xffff` across the walked range carries the
firmware farther, through `0xc865`/`0xc872`. Copying program words into the
range instead eventually branches through a zero handler and is decisively
wrong. None of these perturbations is retained as a device model, and their
audio is not evidence of CM or JM; they prove that the next input is an
ASIC/external-data vector, not another PC, BIO edge, normalization constant, or
supervisor message.

The practical route to **CM/JM and beyond** is therefore:

1. keep the call overlay and its `IMR=0x9880` context live after CI/ANSam;
2. release callback-ready bit 8 at `0x039f` when the opposite bootstrap signal
   qualifies;
3. recover and publish the ASIC-produced external-data vector beginning at
   `0xa51b` before `c617` dispatches the next state; and
4. let `c418` advance the firmware handler table naturally, then publish its
   completion/status word to the supervisor.

The summary now reports `0xa51b`, `0xd2a8`, the role detector byte `0x0306`,
and per-frame 980/1180 Hz V.21 scores. That makes a future vector experiment
falsifiable: reaching a later PC is not enough; CM/JM must appear as strong
300-bit/s V.21 low-channel symbols in firmware DAC output.

### Publishing a guessed vector does not work

The proposed next step above has now been executed, and it corrects one part of
that conclusion: `0xa51b` is the first missing operand, but it is **not the
start of one contiguous ASIC vector that can be reconstructed from the line
samples**.

The core now records every entry into the three identical numerical loops at
`0xc7f7`, `0xc81a`, and `0xc853`, including accumulator, source address/value,
and paired address/value. With the callback held low until native CI/ANSam
qualification, the first firmware-owned entry is reproducibly:

```text
loop=c853  ACC=00007fef  source=a51b:0000  pair=d2a8:0001
```

The following models were then tried at the real read boundary:

- a single `ffff` or Q15 `8000` at `a51b`;
- the same value in the descending four-word cells `a51b`, `a517`, ...;
- a contiguous block over the surrounding external-data range;
- the latest 960 codec samples, both contiguous and four-phase interleaved;
- program-space words mirrored into data space; and
- a Q15 result returned directly to the source operand of all three loops.

The first two let `c853` return, but later invocations request `a517` and other
work cells. Filling those reaches `c81a`, whose next source is register `0035`
(`TRAD`), then `ffd0`; forcing those reaches `c7f7`, whose source becomes
`0000`. Constant-Q15 publication can keep all three routines executing, but it
makes them cycle hundreds of thousands of times, eventually clears `IMR`, and
produces no strong 980/1180 Hz symbols. Mirroring program words eventually
branches through a zero handler. Raw codec history also reaches later loops but
fails their fixed-point tests. These are clean falsifications, not candidate
implementations, and none remains enabled.

So the values are intermediate fixed-point work products with addresses passed
by the firmware's state routines, not a wire-format sample or detector array.
The absent customer-ROM/ASIC scheduler must run an upstream producer that
constructs that workspace before releasing `039f.8`. The update firmware
contains the consumers and coefficient tables but not that producer. There is
no value-preserving way to synthesize it from the supplied images alone; a
physical C52 data-memory capture at callback release, or the customer mask ROM,
is required. The new loop diagnostics define the minimum useful capture:
`ST0/ARP`, all AR registers, ACC/PREG/TREG0, and data around the reported source
and pair for each of the three loop PCs.

## Repro notes

Analysis tooling: Python + `capstone` (x86-16). macOS blocks reads under
`~/Downloads` (TCC) — the file had to be copied into the repo first.
