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

The service frame is 172 instructions / 258 modeled C52 cycles and corresponds
to a 9.6 kHz line cadence. The emulator now queues signed-16 input at `0x54`,
captures every `OUT` word, and models the missing board dial-command handoff.
An end-to-end `ATDT123` run emits three verified DTMF pairs through the actual
firmware `OUT` instruction. This handoff is still a board-side model rather than
the unrecovered internal datapump mailbox.

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
modeled line retains the original `NO DIAL TONE` path. The physical DAA
IC/register identity and ring/loop-current event mapping remain unconfirmed.

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
30 two-word runtime messages through ports `0x58..0x5e`. The resident C52 loop
polls external port `0x50` (notably at program `0x8c1f`), but every observed
read remained `0xffff`; none of those runtime headers reached the datapump.
Incoming supervisor event tags `0x02`, `0x03`, `0x09`, and `0x4d` execute their
recovered handlers, yet cannot compensate for the missing outbound host-latch
protocol. Recovering the `0x58..0x5e` to C52 `0x50/0x51` valid/ack timing is the
next required step before genuine answer-tone or carrier training can occur.

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

## Repro notes

Analysis tooling: Python + `capstone` (x86-16). macOS blocks reads under
`~/Downloads` (TCC) — the file had to be copied into the repo first.
