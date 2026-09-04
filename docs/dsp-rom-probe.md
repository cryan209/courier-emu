# DSP ROM-read and serial transport experiment

The physical target reports US/Canada external, 20.16 MHz, 512 KiB flash,
64 KiB RAM, supervisor 7.3.14 and DSP 3.0.13 dated 03/13/98. These version
strings match the reference `IDSDL302.ROM`, but are not proof of identical
firmware or a particular DSP part.

There is a provenance correction: `docs/New Folder With Items/IDSDL302.ENG`
describes a modified 20.16 MHz release based on the stock 03/13/98 SDL. It adds
configuration and memory-editing commands. Do not treat the reference ROM as
an unmodified stock replacement for the user's modem.

## Reproducible offline probe

```sh
python -m courier_emu.dsp_probe \
  --reference IDSDL302.ROM \
  --output artifacts/dsp-rom-probe-v1
```

The output directory must be new. This creates `probe-c5x.bin` and
`manifest.json`. The binary is a **raw C5x program-RAM kernel, not an XMD/SDL
update**. There is no physical serial connection, flash operation or upload
command in this tool. Source firmware files remain unchanged.

The reference's DSP initialization starts at flash `0x29080` with C5x
instructions `LDP #0; SPLK #ffff,@57; SETC INTM`. This is stronger evidence for
choosing the instruction family than the historical TMS32025 credit string.
It does not distinguish all C5x silicon variants or ROM-protection options.

The kernel starts at DSP **word** address `0x8000`, masks interrupts, selects
DP `0x0300` and ARP1, then uses repeated `TBLR` instructions to read:

1. Eight known words embedded in its own program-RAM payload.
2. Thirty-two words at program addresses `0x0000..0x001f`.
3. The same eight control words again.

It publishes a completion marker only after all three reads, then branches to
itself with interrupts masked. It issues no peripheral output, program-memory
write or flash command. It overwrites data RAM `0x0300..0x0337`, a deliberate
scratch allocation for this standalone diagnostic, not a live-modem-safe
allocation alongside the running datapump.

| Data word range | Contents |
|---|---|
| `0300..0307` | Magic `c051`, version 1, sample origin 0, count 32, completion (`d00e` when done), control count 8, two reserved zeros |
| `0308..030f` | First control read |
| `0310..032f` | Low-program-memory sample |
| `0330..0337` | Second control read |

All serialized words are little-endian. Controls are `1357 2468 a55a 5aa5
0000 ffff 8001 7ffe`. Both controls and completion must match before interpreting
a sample. Uniform zeros or ones are inconclusive; plausible sample data alone
does not prove the internal ROM is mapped or readable.

## What has actually been tested

The native C5x core executes the kernel twice: once with a synthetic ROM mapped
at zero and once with distinct external program memory at zero. Both control
reads match, both runs complete without peripheral I/O, and the low-memory
sample changes to the correct fixture. These are **synthetic test data, not
bytes recovered from a Courier**. The core uses a C52 memory model and does not
model optional mask-ROM protection; success cannot predict protected-chip
behavior or confirm the C51's full ROM size.

Separately, Unicorn executes the reference supervisor's checksum routine at
`8000:e447` and download routine at `8000:e46e`. The harness substitutes the
kernel only in the emulator's flash source window at physical `0xa9080`.
The CPU outputs every payload byte through `0x40..0x4e`, commits groups with
`OUT 0x18,1`, and submits its calculated word sum with `OUT 0x18,4`.
The captured bytes and checksum must exactly match the kernel. All ready bits
are synthetic (`IN` returns 7), so this checks the firmware's transfer loop,
not the physical DSP boot ROM's acceptance or launch protocol.

## Supervisor launch and serial readback

The integrated experiment adds a RAM supervisor monitor and a mailbox sender
to the DSP kernel:

```sh
python -m courier_emu.probe_transport \
  --reference IDSDL302.ROM \
  --output artifacts/dsp-rom-transport-v2
python -m courier_emu.probe_transport \
  --capture artifacts/dsp-rom-transport-v2/serial.txt
```

Use a new output directory for each run. It produces `diagnostic-ram.bin`,
`probe-c5x.bin`, `serial.txt` and `manifest.json`. The manifest records the load
map, source and payload hashes, every supervisor port/PCB write, DSP mailbox
writes, reset requests, transfer checksum, packets, acknowledgements and
assumptions. The reference is pinned to SHA-256
`49f4182cc961aef983ff43468b7b7e55c03205c9dba80e9689fe20aa6ff2ccc5`.
The input ROM is opened for reading; its emulated flash mapping is also
protected against CPU writes.

The supervisor executes a contiguous copy of reference routines
`8000:e370..e597`. Keeping the block together preserves its relative calls
and branches. The only two patched immediates change the download/checksum
source segment from `a908` (flash) to `0300` (RAM). The monitor calls:

1. `e370`: initial `fff8` bootstrap request, eight `0083` window words, and
   initialization strobes.
2. `e3aa`: reset and request entry at DSP word address `8000`, including GPIO
   writes at `ff56`, timer setup and polling for `ffff` acknowledgements.
3. `e447`: compute the payload word checksum.
4. `e47b`: the alternating-window downloader used by normal startup. Four
   words go through `40..4e` with strobe 1, then four through `50..5e` with
   strobe 2; strobe 4 submits the checksum and polls for acceptance.

Timer polls use the unaccelerated timer model: forcing MAX COUNT at the first
read would falsely report a handshake timeout. Timing remains an instruction
clock approximation, not a measured 20.16 MHz board timing model.

After taking the same control/sample/control reads as the original probe, the
DSP sender follows the resident routine at program words `83d6..83ff`. It
reads MMR `57` through the external-read/MMR-read sequence used by the
resident's `23f0` helper, waits on mask `0002`, writes a tag to I/O `005e`,
writes its data word to I/O `005f`, and commits with `SAMM @57,2`.
Tags run from `5200` through `5237`.

The supervisor waits on input `1c` mask `02`, reads the tag from `5a/58`
(high/low) and data from `5e/5c`, then acknowledges with output `1c=02`,
`1e=00`. These pairings are inferred from the resident sender and supervisor
readers, including `fdb0`, `13a4c` and `f633`; they have not been measured on
the physical ASIC. The two processors have separate I/O address spaces.

The supervisor validates every tag and prints all 56 words through actual
stores to UART register `ff6a`, polling transmit readiness at `ff66` mask 8.
Serial framing is ASCII: `CDRP1 START`, `CDRP1 DATA 0038`, 56 lines of
`IIII:WWWW`, `SUM:SSSS` (16-bit additive word sum), and `CDRP1 DONE`, each
terminated by CRLF. The capture parser requires a single complete frame,
consecutive indices, a matching sum, both controls and the completion marker.
The sum detects ordinary transport corruption; it is not authentication.

Failures emit `CDRP1 ERR RESET`, `DOWNLOAD`, `MAILBOX` or `TAG` and halt.
UART timeout halts without depending on a functioning UART to report it.
Status byte `4072` contains 0 for success, 1–5 for those respective errors,
or `ff` while running. Supervisor receive and transmit loops are bounded.

| Address space | Allocation / entry assumption |
|---|---|
| Supervisor physical `2000` | Entry `0000:2000`; monitor initializes DS/ES/SS=0, SP=`eff0`, masks interrupts |
| Supervisor `2400..2627` | Copied reset/checksum/download routines |
| Supervisor `3000` | DSP payload source, including transfer padding |
| Supervisor `4000..406f` | Received 56-word buffer; checksum at `4070` |
| Supervisor `0e36..0e39` | Scratch globals used by copied downloader |
| Supervisor `ff00..ffff` | Assumed relocated peripheral control block; UART and chip selects already initialized |
| Supervisor `80000..fffff` | Read/execute-only reference flash |
| DSP program `8000` | Downloaded probe, embedded controls and mailbox sender |
| DSP data `0300..0337` | Probe result; sender also uses scratch `037c..037d` and MMR `57` |

The RAM binary is loaded at physical `2000` and includes padding up to the
kernel at `3000`. These RAM allocations assume a standalone diagnostic that
takes over the supervisor and datapump; it does not return to normal modem
operation or preserve the live firmware's RAM state.

The integrated test starts the native DSP without the kernel. Only the bytes
actually transmitted by supervisor OUT instructions are loaded into it after
checksum acceptance. Result words then travel through executed DSP
OUT/SAMM instructions, modeled ASIC latches, supervisor IN instructions and
UART stores. No DSP data-memory peek supplies the captured serial sample.
The ASIC reset acknowledgement and the boot ROM's checksum/launch action are
still synthesized; the missing boot ROM itself is not being executed.

The successful ROM-fixture run takes 18,144 supervisor instructions and 971
DSP steps, with 56 packets and 56 acknowledgements. Both ROM-mapped and
external-program-memory fixtures yield their distinct expected samples.
`--external-fixture` selects the latter. `--fault reset|checksum|no-dsp|tag|stale|uart`
exercises bounded failure reporting. Tests also reject truncated, repeated,
reordered and corrupt serial frames, and prohibit DSP memory peeks during
the integrated run. **All samples remain synthetic, not recovered ROM.**

## Existing ATG memory reader in IDSDL302

The modified reference already contains CPU memory-dump commands, established
from its code and isolated handler execution. A later user-provided physical
modem capture confirms the byte-read form on the target; see below. Other
forms remain verified only in the isolated reference handler.

At flash offset `25ba9`, the handler checks for the literal `LK2` and, if
present, skips those three characters. It does not set a persistent unlock
flag in this path. The next character is dispatched through `c800:0024`
(flash `48024`) to the extension at flash `49022`.

| Reference command | Operation |
|---|---|
| `ATG=8000:0000` or `ATGLK2=8000:0000` | Dump 256 CPU-memory bytes as 16 rows of 16 bytes |
| `ATGR8000:0000` or `ATGLK2R8000:0000` | Dump the same 256 bytes as 16 rows of eight little-endian words |

Addresses are hexadecimal CPU `segment:offset` addresses. The example reads
the start of reference flash at physical `80000`. With only one address
number, the reader uses segment zero and that number as the offset. Each
request is fixed at 256 bytes; the offset increments as a 16-bit register,
so a request crossing `ffff` wraps within the same segment.

The extension at `49022` handles `=` as byte reads and `R` as word reads.
The actual accesses are `MOV AL,ES:[BX]` at `4908c` and `MOV AX,ES:[BX]` at
`4909d`. The `W` branch at `490b8` writes memory and is a distinct operation.
A bare `ATGLK2` is not one of the verified dump forms; unrecognized suffixes
fall through to other G-command handling.

An isolated Unicorn check entered the handler at `a0ca:4f09`, with DS=0,
SI/CX pointing to each suffix and BL=`G`. It intercepted only the resident
character-output and newline helpers. All four forms above returned exactly
the first 256 reference-ROM bytes, printed correct row addresses through
`8000:00f0`, and made no memory writes outside the temporary stack. The
source firmware file remained unchanged.

The reference analysis alone does not establish availability in stock
supervisor 7.3.14. These CPU bus reads do not directly expose DSP program
memory: there is no DSP table-read or mailbox transaction in the dump loop.
Reading peripheral-mapped addresses can have device side effects; the verified
example reads the flash array.

### Physical target readback

The user subsequently supplied the output of `atglk2=8000:0000` from their
modem, previously identified by ATI7 as supervisor 7.3.14 / DSP 3.0.13. It
contains all 16 rows from `8000:0000` through `8000:00f0`, followed by `ERROR`.
All **256 bytes match** the beginning of `IDSDL302.ROM`, including the
`INT80186 Modem Functions` text. The extracted block's SHA-256 is
`ecb384d81ffa62087bde0df4507be95fcfc5dffd339388be98ec76244790189f`.
The transcript (whitespace normalized), binary block and comparison metadata
are saved locally under `artifacts/atg-monitor/hardware-8000-0000.*`.

This confirms that the physical target exposes the byte-read form and that
CPU address `8000:0000` (physical `80000`) yields the expected firmware page.
It does not identify the entire installed image, prove stock versus modified
firmware, validate the remaining flash mapping, or recover DSP internal ROM.
The trailing `ERROR` does not negate the complete matching block; its cause
is unconfirmed. A collector must retain the terminal status separately and
validate row addresses and lengths, rather than equating `ERROR` with absent
data. This single observation is not permission to accept arbitrary partial
or malformed responses as complete dumps.

The subsequent physical read `ATGLK2=F000:FF00` returned 240 bytes of `ff`
followed by the reset-vector bytes
`fa ba a4 ff b8 00 80 ef ea e9 11 00 fc 06 00 00`, again followed by `ERROR`.
It is saved as `artifacts/atg-monitor/hardware-f000-ff00.*`. The stub decodes as
`CLI; MOV DX,ffa4; MOV AX,8000; OUT DX,AX; JMP FAR fc00:11e9`.
Thus it programs the upper chip-select start for physical flash base `80000`
and jumps to physical `fd1e9`. Together with the first page and ATI7's 512 KiB
size, this supports collecting CPU addresses `80000..fffff` as the flash
image. It does not establish every intervening bank's runtime mapping.

The hardware page **differs** from the modified reference: reference reset
entry is `fc00:1a21` (physical `fda21`), and byte `ffffd` is `07` rather than
the hardware's `06`. The latter byte's meaning is unconfirmed. These three
byte differences prove the installed image is not byte-identical to
`IDSDL302.ROM`, despite its matching first page. Do not transplant the
reference's routine addresses into a hardware diagnostic without checking
the corresponding target bytes. A complete dump is now needed to resolve
the exact installed boot code and monitor implementation.

### Automated read-only external-flash capture

The POSIX collector requires no serial Python package:

```sh
python -m courier_emu.flash_dump \
  --device /dev/cu.usbserial-21210 --baud 115200 \
  --output artifacts/courier-board-21210-capture-01
```

Close any other terminal using that port first. The output directory must be
new. The collector requests exclusive access and configures the host serial
port for 8N1 with DTR/RTS asserted. It restores host settings on exit while
clearing hangup-on-close to avoid deliberately dropping DTR. It sends only
`AT`, `ATI7` and canonical `ATGLK2=<segment>:<offset>` reads: no modem reset,
configuration, memory-write, flash-programming or upload commands.

This collector deliberately targets the user's demonstrated profile: ATI7
must report 20.16 MHz, 512k flash, supervisor 7.3.14 and DSP 3.0.13. Before
the sweep, it verifies the first page's instruction prefix and the exact
reset-vector bytes supplied by the user. It reads every aligned 256-byte
page from physical `80000` through `fff00`, requiring two identical copies.
The canonical segments are `8000,9000,...,f000`, with offsets `0000,0100,...,ff00`;
requests never cross the 16-bit offset boundary.

Each response must contain exactly 16 consecutive correctly addressed rows
of 16 bytes and an `OK` or `ERROR` terminator. Echo is optional. Terminal
status is retained separately; a bare `ERROR` cannot pass validation.
Malformed or disagreeing responses cause a bounded retry, with every received
attempt retained. Three failed attempts stop the capture. Both endpoint
pages are reread at the end before the final image is published.

Outputs include `responses/` (every raw page response), `blocks/` (verified
binary pages), `pages.jsonl` (addresses and per-page SHA-256), `ati7.txt`,
`manifest.json` (progress, failures and final image SHA-256), and the complete
`courier-board.rom` only on success. An interrupted capture preserves partial
blocks and an incomplete manifest; it does not silently pad missing data or
publish a complete ROM. Automatic resume is not implemented.

Repeated matching reads establish capture consistency. They do not rule out
runtime bank aliases, and this tool does not read the DSP's internal ROM.
Parser, address-boundary, identity and inconsistent-read handling are covered
by `python -m pytest tests/test_flash_dump.py -q`.

### Handler recovered from the physical capture

The verified blocks captured from `/dev/cu.usbserial-21210` distinguish the
installed monitor from the modified reference. At flash `25ba9`, the physical
handler requires `LK2`; a missing/mismatched prefix returns carry set. Its `=`
branch at `25c36` advances past the selector and calls the original byte reader
at `26e20`. Its `R` branch at `25c7f` calls the word reader at `26e8b`. The
reference's extension call and optional-prefix behavior must not be assumed
on this board. The byte/word readers themselves match the reference.

There is evidence for a parser-count defect behind the observed terminal
`ERROR`. In the byte reader, `LODSB` at `26e2b` consumes the colon without
decrementing `CX`, unlike the hexadecimal parser's character consumption.
An isolated execution of the captured handler prints the exact expected 256
bytes for `LK2=8000:0000`, returns carry clear, and leaves `CX=1` with `SI`
pointing at carriage return. The single-number form `LK2=8000` leaves `CX=0`
and reads segment-zero memory in the emulator. Both tests observe no nonstack
memory writes. The latter test is offline only, with synthetic zeroed RAM.

The script and results are retained as
`artifacts/courier-board-21210-capture-01/handler_check.py` and
`handler-check.json`. These tests bypass the outer AT dispatcher and intercept
serial helpers, so the count defect is a likely explanation of the trailing
`ERROR`, not a reproduced end-to-end terminal result. The physical collector
continues using the demonstrated segmented-address form and validating every
row; no alternative commands were sent to the modem for this investigation.

### Complete selector table of the captured handler

The two documented dump forms are not the whole dispatcher. Disassembling the
`LK2` handler at flash `25ba9` in `courier-board.rom` recovers seven selectors.
The prefix check is `cmp word ptr [si],'LK'` then `cmp byte ptr [si+2],'2'`;
after `add si,3` / `sub cx,3`, `jcxz` leaves `BL` holding the outer `G` when the
command ends there, so a bare `ATGLK2` matches no selector and falls through to
the numeric forms below.

| Suffix | Target | Operation |
|---|---|---|
| `=` | `26e20` | Memory byte dump, 16 rows of 16 bytes |
| `R` | `26e8b` | Memory word dump, 16 rows of eight little-endian words |
| `I` | inline `25c45` | Read one I/O port, print one hex byte |
| `O` | inline `25c65` | Write one I/O port: `O<port>,<byte>` |
| `B` | `26eec` | I/O port block dump, 16 rows of 16 ports |
| `N` | inline `25c3d` | `or byte ptr [25e],1`; sets a flag, prints nothing |
| `U` | inline `25c8d` | `clc; ret`; accepted and ignored |

`26eec` begins exactly at the end of the byte/word reader range `[26e20,26eec)`
that the earlier comparison against `IDSDL302.ROM` covered, which is why the
port selectors were not previously recorded here. Their equivalence to the
reference is unverified.

The `B` routine parses one hexadecimal number into `DX`, then runs sixteen rows
of sixteen `in al, dx` reads, printing two hex digits and a space per port and
incrementing `DX` after each. It therefore reads 256 **consecutive I/O ports**
unconditionally, with no address echo per row and no way to narrow the range.

These three selectors operate on CPU **I/O space**, not on the DSP's program or
data space, and not on CPU memory. They do not constitute a DSP dump path. Their
value is that `0x40..0x5e` and `0x1c` — the ASIC bootstrap window and mailbox
latches — are I/O-space addresses that `=` and `R` cannot reach at all.

`I` and `B` are reads, but I/O reads are not inherently side-effect free: the
supervisor's own receive path consumes mailbox replies by reading `58..5e`, and
`B` sweeps those ports whether or not a reply is pending. Treat `B` as
disruptive to a live call and to any in-flight mailbox transaction, unlike the
memory dumps used by the flash and RAM collectors. `O` writes and is not a
diagnostic read at all. `I` and `B` have since been sent to idle units, and `O`
has since been used to strobe individual output-latch bits; see "CPU port-space
output latches" below, which supersedes this paragraph's statement that none of
these forms had been issued.

### Completed physical capture, 2026-09-03

The requested modem was read successfully at `/dev/cu.usbserial-21210`,
115200 baud. ATI7 matched the user's profile. The sweep of CPU physical
`80000..fffff` completed in 1,107.8 seconds, producing exactly 524,288 bytes:

```text
artifacts/courier-board-21210-capture-01/courier-board.rom
SHA-256 f3a8b01373d5e51223b8fffa95727bac4a4605477dba7ca0bacd34a9b31fe958
```

All 2,048 pages had two matching reads, with zero retries. Both endpoint
pages also matched on the final reread. Every one of the 4,100 page responses
ended with `ERROR` after its complete, correctly addressed 256-byte dump.
The offline audit reparsed all those saved replies and checked them against
the individual blocks, per-page hashes, assembled image and manifest hash.
The serial connection closed after the capture. Only `AT`, `ATI7` and
`ATGLK2=` reads were sent; there was no firmware upload or memory-write command.

Reproduce the local audit from the repository root:

```sh
.venv/bin/python artifacts/courier-board-21210-capture-01/audit_capture.py
```

This requires the original capture output: the audit re-parses `responses/` and
compares it against `blocks/`, and neither directory is tracked in git. See
`artifacts/README.md`. The assembled image, `pages.jsonl` and the manifest
hashes are tracked, so the image stays verifiable without them.

`manifest.json` contains the capture identity and acquisition details;
`audit.json` records the verification, bank hashes and differing ranges.
The captured reset stub decodes to flash base `80000` and entry `fc00:11e9`.
There are 11,295 byte differences from the pinned modified `IDSDL302.ROM`.
The DSP reset/download block `[e370,e598)`, CPU byte/word readers
`[26e20,26eec)`, and DSP startup/sender region `[29080,29880)` match exactly
(ranges are flash byte offsets, end-exclusive). This confirms those specific
reference code comparisons, not the entire DSP image or a hardware launch
protocol.

The 64 KiB windows at physical `d0000` and `e0000` both read entirely `ff`;
the other six windows have distinct hashes. Erased reads cannot distinguish
separate blank banks from aliases. The artifact is a verified capture of the
CPU-visible 512 KiB window under the running firmware's mapping. It does not
yet include a separate dump of the DSP's internal ROM.

## Live RAM capture

```sh
.venv/bin/python -m courier_emu.ram_dump \
  --device /dev/cu.usbserial-21210 --baud 115200 \
  --output artifacts/courier-board-21210-ram-01
```

The directory must be new. The collector verifies ATI7, including 64k RAM,
and the known flash endpoint signatures. It reads physical `00000..0feff`
in two sequential passes, then rechecks the flash endpoints. It sends only
`AT`, `ATI7`, and canonical `ATGLK2=` memory reads. The host serial transport
and response validation are shared with the flash collector; RAM access is
an explicit opt-in and does not widen the default flash collector's range.

Physical `0ff00..0ffff` is excluded because the firmware relocates its
peripheral control block there. In particular, reading UART and status
registers as if they were RAM could have side effects. The two output files,
`ram-pass1.bin` and `ram-pass2.bin`, therefore each contain **65,280 bytes**,
with file offset equal to physical address. They contain no fabricated
padding for the excluded 256 bytes. The nominal 64 KiB RAM size is from ATI7;
the capture does not establish inaccessible RAM beneath the peripheral
window or aliases above the first 64 KiB CPU window.

A pass is a live sequence of page reads, not an atomic snapshot. The modem
continues running and the dump commands themselves change its command
buffers, stack and other working memory. Differing data between passes is
preserved and listed in `differences.json`; it is not retried until it agrees.
Only malformed, incomplete or wrongly addressed replies trigger bounded
retries. Raw responses, individual blocks, elapsed page-read times, hashes
and the capture manifest are retained. Failure preserves partial data and
marks the manifest incomplete; each pass file is published only after all
its pages have been collected.

The collector also extracts `0000:0752..0763` into two 18-byte
`settings-cache-passN.bin` files. The physical firmware's reader at flash
`e2e9` and EEPROM driver at `1401` match the reference: this RAM block caches
EEPROM words **94..102** (byte offsets `bc..cd` in a little-endian word image).
The settings decoder at `e237` likewise matches. Each three-byte record
encodes three redundant copies; the manifest reports all decoded copies,
whether a majority exists, the recovered value, and whether both captures
of the block agree. No firmware decoder or EEPROM write routine is invoked
on the modem. These 18 bytes are a cached subset, not a full EEPROM dump;
uncaptured EEPROM words must not be presented as recovered data.

The raw RAM images include live pointers, stack and transient state. They
are useful evidence and sources for verified initialization data, not a
demonstrated restore point to load wholesale into the emulator at reset.

Tests: `python -m pytest tests/test_flash_dump.py tests/test_ram_dump.py -q`.

### Completed RAM capture, 2026-09-03

`artifacts/courier-board-21210-ram-01/` contains two complete 65,280-byte
passes from `/dev/cu.usbserial-21210` at 115200 baud. Acquisition took
139.44 seconds, with no malformed responses or retries. An offline audit
checked all 510 RAM-page responses plus four flash-anchor responses against
the stored blocks, assembled files and hashes. The modem's terminal result
was `ERROR` after every complete response, as in the earlier flash capture.

| Artifact | SHA-256 |
|---|---|
| `ram-pass1.bin` | `5e3f03971724027cf35246dfca8a61a2df01c655bced1d3f45c5beec7de49b33` |
| `ram-pass2.bin` | `e3889db731f9f897473f31c2cd94348f7f981dbec9d1db39f9633398bef0533a` |
| Each `settings-cache-passN.bin` | `e986a26abf57d5c64c426467bafaeb2f3667eeedce2c253c141d3e06a172c0f6` |

The passes differ at 44 byte addresses, listed in `differences.json`.
The cached settings block agrees exactly:

```text
RAM 0752..0763: 64 96 03 08 0b 1a 64 96 03 ef 87 1d ef 87 1d ef 87 1d
Settings 1..6: 0, 30, 7, 30, 0, 0
```

All three redundant copies agree for every setting. In particular, setting
3 is `7`, whose bit 0 satisfies the serial-output enable condition traced
in the firmware. This supplies actual board data for the previously missing
cached-settings records; it does not establish that the emulator now boots
correctly, nor has the whole RAM image been applied as emulator state.

The serial port closed after the capture. No upload or memory-write command
was sent. Reproduce the saved-data audit with:

```sh
.venv/bin/python artifacts/courier-board-21210-ram-01/audit_capture.py
```

## Upper CPU memory window investigation

```sh
.venv/bin/python -m courier_emu.ram_dump \
  --device /dev/cu.usbserial-21210 --baud 115200 --window upper \
  --output artifacts/courier-board-21210-upper-ram-01
```

This explicit mode captures CPU physical `10000..1ffff` twice, 65,536 bytes
per pass. File offset zero corresponds to physical `10000`. The known boot
table sets the lower chip select from zero to `20000` (exclusive), but ATI7
reports 64 KiB RAM. A chip-select range describes address decoding, not
necessarily distinct installed storage. This experiment checks the previously
uncaptured half of that range without writing test patterns or changing the
mapping.

The collector additionally reads six comparison groups at lower addresses
`0000`, `0700`, `2000`, `8000`, `e000`, and `fe00`. In each group, it reads
the lower page, the page `10000` bytes above it, then the lower page again.
The report separates bytes stable between the two lower reads from changing
bytes and counts how many stable bytes match the upper page. Such comparisons
can support an alias interpretation without claiming to prove that the same
physical RAM cells are selected.

`0ff00..0ffff` remains excluded. The upper address `1ff00` is outside that
relocated peripheral control block and is included in this window. Neither
window mode reads arbitrary I/O ports. Default lower-RAM and flash captures
keep their original address restrictions; upper access requires its own
transport opt-in. The upper mode does not label bytes at offset `0752` as
an EEPROM cache before establishing their relationship to lower RAM.

The DSP has a separate program-memory execution context: the captured CPU
download routines send code through `OUT` instructions at ports `40..5e`
with transfer handshakes at `18`. Those routines match the reference. Finding
data in the CPU's upper RAM window does not, by itself, establish a direct
mapping to the DSP's working RAM or internal ROM.

### Completed upper-window capture, 2026-09-03

The capture in `artifacts/courier-board-21210-upper-ram-01/` completed in
144.79 seconds. Each pass contains 65,536 bytes from physical `10000..1ffff`.
All 534 saved responses (512 sweep pages, four flash endpoints and 18 alias
comparison reads) passed the offline audit. There were no retries, uploads,
or memory-write commands. All responses ended with `ERROR` after their
complete data, as in the previous captures.

| Artifact | SHA-256 |
|---|---|
| `ram-pass1.bin` | `e0f5f5dbb4bddf9f2a3cd1bb3584391278afa0b4ae8132d5c54258d0a9ebad6b` |
| `ram-pass2.bin` | `44e4771ac50e1a71050baf6f13b891e4938036d5bbeb6b3fb84eeb94159a49a2` |

Only 17 bytes differ between the two upper passes. Compared with the earlier
lower `ram-pass2.bin`, each upper pass differs at 45 of the 65,280 comparable
bytes; 249 of 255 whole pages match exactly. The known settings-cache bytes
also match at the corresponding offset.

Five fresh lower/upper/lower groups match completely: lower pages `0700`,
`2000`, `8000`, `e000`, and `fe00`. For page `0000`, 244 byte positions agree
between the bracketing lower reads, and 242 of those match the upper read.
The two exceptions are offsets `fb` (lower `00`, upper `0f`) and `fe`
(lower `04`, upper `f0`). These observations do not establish that the page
was unchanged between observations or explain the remaining discrepancies.

The extensive matching data strongly supports the interpretation that the
upper window mirrors the 64 KiB supervisor RAM. A write-based alias test was
not performed, so shared physical cells are not conclusively established.
This capture provides no evidence that the upper window exposes a distinct
DSP RAM bank. The DSP's separate RAM/execution context remains a different
target for the mailbox/diagnostic investigation.

The last upper page `1ff00..1ffff` also matches exactly between passes. It
provides 256 bytes absent from the lower capture, whose `0ff00..0ffff`
addresses were excluded as peripheral registers. Identifying that upper
page as the underlying low RAM relies on the alias interpretation; it is
not a captured peripheral-register snapshot.

Reproduce the saved-data audit and comparisons with:

```sh
.venv/bin/python artifacts/courier-board-21210-upper-ram-01/audit_capture.py
```

## CPU I/O port map

The DSP dump path runs entirely through I/O space: the bootstrap window, the
download strobes and the mailbox are all `IN`/`OUT` addresses that the `=` and
`R` memory dumps cannot reach. This section records what the captured image
shows about that space.

### How the map was produced

```sh
python tools/io_port_scan.py \
  artifacts/courier-board-21210-capture-01/courier-board.rom \
  artifacts/io-port-map/board-21210
```

The output directory must be new. It writes `sites.json` (every accepted
instruction site), `ports.json` (per-port access counts and site lists) and
`manifest.json`.

A linear sweep of a 512 KiB image desynchronizes inside the big-endian datapump
and the coefficient table, so the scanner accepts an `IN`/`OUT` opcode only when
at least four disassemblies started at earlier offsets converge on it, and it
scans only `0x00000..0x29800`, `0x44000..0x7c000` and `0x7e000..0x80000`. Ports
loaded into `DX` are resolved only when an immediate `mov dx` reaches the site
with no intervening branch, call or non-immediate redefinition of `DX`.

The run over the captured board image accepted **971 sites** and left **295
`DX` sites unresolved**. Those unresolved sites are excluded from the table, so
every count below is a lower bound. Consensus decoding is a heuristic, not a
proof, and a site's existence does not make its path reachable at run time.

### Bus shape

Every densely used port is **even and byte-wide**, from `0x00` to `0x62`,
suggesting a peripheral bank at a stride of two. The physical readback below
confirms the stride and extends the bank to `0x7e`, giving 64 registers rather
than the 50 the static sites alone reach. Sixteen-bit and odd-address forms do
appear in the scan
(`0x03`, `0x05`, `0x0d`, `0x11`, `0x1f`, `0x2d`, `0x4f`, `0x57`, `0xc3`), each at
one or two isolated sites; they are more likely surviving decode noise than real
registers, and none is corroborated by an emulator run. They are not listed as
established below. The physical readback recorded further down supports this
indirectly: no odd port is driven on real hardware, though that dump cannot by
itself separate an unmapped odd port from a mapped one reading zero.

### Established ports

Attribution combines the site counts with the semantics the emulator already
models (`courier_emu/panel.py`, `nvram.py`, `bridge.py`) and with the execution
evidence in `courier_firmware_analysis.md`.

| Port | Sites | Direction | Function |
|---|---:|---|---|
| `0x00` | 12 | r/w | DTE serial data path |
| `0x0e` | 12 | write | Panel latch driver output |
| `0x10` | 30 | r/w | Board latch 0: hook relay, off-hook, NVRAM strobe/data/chip-select/clock; reads return NVRAM ready and data-out |
| `0x12` | 4 | r/w | Board latch 1: indicators, id-strap drive B; reads DTE DTR at bit `0x40` |
| `0x14` | 20 | r/w | Board latch 2: carrier-detect pair, id-strap drives A/C/D; reads ring detect (`0x02`) and strap sense (`0x08`) |
| `0x18` | 101 | r/w | DSP download strobe/status. `OUT 0x18,1` commits a four-word group, `OUT 0x18,4` submits the checksum; reads return ready bits |
| `0x1a` | 86 | r/w | Second strobe/status register, paired with `0x18` |
| `0x1c` | 26 | r/w | Mailbox valid/acknowledge. Bit 1 advertises a reply; supervisor acknowledges with `1c=02` |
| `0x1e` | 28 | r/w | Mailbox command register |
| `0x40`–`0x4e` | 59 | r/w | DSP bootstrap window A: eight byte latches carrying four payload words |
| `0x50`–`0x5e` | 125 | r/w | Window B and the runtime mailbox. `0x58`/`0x5a` carry tag low/high, `0x5c`/`0x5e` data low/high |
| `0x60`, `0x62` | 27 | read only | Third 16-bit read window, high byte at `0x62` and low at `0x60`. See below |

The `0x40..0x4e` and `0x50..0x5e` split matches the alternating-window
downloader at `e47b`: four words through the first bank with strobe 1, four
through the second with strobe 2.

### The `0x60`/`0x62` read window

This pair is new to this document and is not modelled by the emulator. All 27
sites fall in one routine at `01fe0..02128`, driven through an indirect
continuation vector at `[0x02d3]` that each step rewrites to the address of the
next step, dispatched by `call word ptr [0x2d3]` at `00674`. Every step reads a
16-bit value as `in al,0x62` (high) then `in al,0x60` (low) and appends it to a
buffer walked through `[0x08a2]`, with a countdown at `[0x02d1]`.

The high-then-low byte pair is the same convention the supervisor uses on
`5a`/`58` and `5e`/`5c`, so this is a third inbound 16-bit window in the same
family rather than an unrelated device. Its producer is not identified. The
vector is also written from `0423e` and `06d08`, which is where the question of
what fills the buffer should be picked up.

There is no write site at either port anywhere in the scanned regions, so this
window is read-only to the CPU. That makes it a plausible inbound bulk path —
which is exactly the shape a DSP readback needs — but nothing here shows the
DSP as its source, and the routine has never been observed executing.

### The `0xc0`–`0xc6` cluster

A separate coherent block at `08332..083b5` sets `PACS` to `0xe000`, sets
`[0xff18]` to `0x10`, then reads `0xc2`/`0xc0` and writes `0xc4`/`0xc6` while
streaming `0x1554` words from segment `0xe000`. It is entered from an `AT`
handler that first checks for the literal `L` at `08327`. Because it reprograms
a chip select and drives an otherwise unused port bank, it should be treated as
a device-programming path, not a diagnostic read, and it must not be invoked on
the physical modem while its function is unknown.

### Physical port-space readback

`ATGLK2B` sweeps have now been taken from two idle units:

| Unit | Device | Ports read | Source |
|---|---|---|---|
| 25 MHz | not recorded | `0x000..0x15f` | `artifacts/io-port-map/hardware-25mhz/` |
| 20.16 MHz | `/dev/cu.usbserial-21210` | `0x000..0x2ff` | `artifacts/io-port-map/hardware-2016mhz/` |

The 20.16 MHz unit is **the same board that produced `courier-board.rom`**, so
its readback can be compared against the static analysis directly. The 25 MHz
unit reports the same supervisor 7.3.14, DSP 3.0.13 and 03/13/98 dates, with
512k flash and 64k RAM; only clock and serial number differ. Matching revision
strings are not proof of identical firmware.

Every response was 16 correctly addressed rows terminated by `OK`, not the
trailing `ERROR` that every memory-dump page produced. That is consistent with
the parser-count defect being specific to the `=` reader's colon handling, since
`B` parses a single number and consumes no colon. `B` also reaches the **full
16-bit I/O space**: it loads its parsed address into `DX` and never truncates.

#### How an unmapped I/O read behaves

The sweeps above `0x0100` read `00 01 02 01 04 01 ...`: even ports return the
address low byte and **odd ports return the address high byte**. On the 80186's
multiplexed bus the address is driven across `AD0..AD15` during T1, and with no
device responding in T3 each byte lane holds the address byte belonging to that
lane. An unmapped row therefore reads back as a clean ascending address pattern,
which makes a `B` sweep a direct decoder probe: "nothing here", not "zeros here".

#### Confirmed on two units: the bank is the 64 even ports `0x00`–`0x7e`

Applying that model to all 768 ports read from the 20.16 MHz unit and all 352
from the 25 MHz unit, **both units drive exactly the same 63 ports, `0x02`
through `0x7e` even, and nothing else.** (Port `0x00` reads `00`, which
coincides with its own address byte, so it is formally ambiguous; it is the DTE
serial data port and is certainly mapped.) Everything from `0x80` to `0x2ff` is
unmapped without exception.

The peripheral bank is therefore 128 bytes of I/O space at a stride of two.
Nothing drives the upper byte lane at any address, so accesses are byte-wide on
even addresses; whether that is an 8-bit device bank or a decoder ignoring `A0`
is not settled here. The odd and 16-bit sites in the static scan have no
hardware support, and the scattered high-port sites address unmapped space on
both units. The `0xc0`–`0xc6` cluster reads as unmapped, which fits the routine
at `08332` reaching a device there only *because* it first reprograms `PACS` to
`0xe000` and moves the peripheral window. That remains a reason not to invoke
it blind.

#### The bootstrap windows do not read back as written words

An earlier revision of this document read the 25 MHz values at `0x40`–`0x5e`
(`1a 00 17 00 55 00 1f 00`, `a8 00 d3 00 08 00 02 00`) as four little-endian
words per window with zero high bytes, matching what the `e47b` downloader
writes. **The second unit refutes that.** On the 20.16 MHz board the same ports
read:

| Ports | `40` | `42` | `44` | `46` | `48` | `4a` | `4c` | `4e` |
|---|---|---|---|---|---|---|---|---|
| 20.16 MHz | `00` | `ff` | `00` | `ff` | `00` | `ff` | `00` | `ff` |
| 25 MHz | `1a` | `00` | `17` | `00` | `55` | `00` | `1f` | `00` |

A strict `00`/`ff` alternation is not word data, and the two units disagree on
every port in both windows. Reads of this window return status rather than the
latch contents — consistent with the existing note that the emulator's synthetic
ready bits stand in for `IN` here. The write-side four-word structure recovered
from `e47b` is unaffected; what is withdrawn is the claim that a read confirms
it. Which ports carry ready bits and which carry anything else is unresolved.

#### Stable and varying registers

Values identical on both units: `0x00`–`0x08` and `0x16` (`00`), `0x0c` (`60`),
`0x0e` (`07`), `0x10` (`86`), `0x14` (`7e`), `0x18`/`0x1a` (`ff`), `0x1c` (`fd`,
bit 1 clear — no mailbox reply pending, a coherent idle state), `0x1e` (`ff`),
all of `0x20`–`0x3e` (`00`), `0x5a`/`0x5e` (`00`), and `0x60`/`0x62` (`0b 00`).

Values differing between units: `0x0a` (`f7` vs `24`), `0x12` (`9a` vs `8a`, one
bit apart in the indicator/strap latch), the whole of `0x40`–`0x58`, `0x5c`, and
`0x64`–`0x7e`.

`0x60` reading `0b` on both units, with `0x62` zero, is worth noting: under the
high-at-`0x62` convention the reader at `01fe0` uses, that is a stable `0x000b`
where the neighbouring registers vary freely. An identity or revision register
is a plausible reading, and an unverified one.

#### The `0x60`–`0x7e` block is live

| Port | `60` | `62` | `64` | `66` | `68` | `6a` | `6c` | `6e` | `70` | `72` | `74` | `76` | `78` | `7a` | `7c` | `7e` |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 20.16 MHz | `0b` | `00` | `78` | `09` | `8d` | `a3` | `e8` | `00` | `ae` | `b6` | `97` | `51` | `51` | `06` | `4f` | `b3` |
| 25 MHz | `0b` | `00` | `ba` | `08` | `bd` | `3c` | `71` | `c6` | `fd` | `fd` | `7d` | `19` | `46` | `dd` | `e8` | `44` |

Fourteen of the sixteen registers hold varied, non-trivial data that differs
between units. The static scan found **no** resolvable site at any port from
`0x64` upward. Something reaches these registers through the 295 unresolved `DX`
sites, through code outside the scanned regions, or on read paths not yet
located — see "Who reads `0x64`-`0x7e`" below, which establishes that no
supervisor instruction reaches them at all, and the repeat experiment that shows
the block is stable rather than streaming.

#### Decoded but idle: `0x20`–`0x3e`

Sixteen registers read `00` on both units, which is not their address byte, so
they are driven rather than floating. The static scan attributes no confirmed
site to any of them. They are mapped and either unused or write-only.

### Who reads `0x64`–`0x7e`: nothing does

The live block at `0x60`–`0x7e` raised the question of which code reaches it,
with 295 `DX`-form sites unresolved by the first scan. That question is now
closed, and the answer is negative.

#### The `DX` form and what it reaches

An earlier revision of this section claimed the `DX` form was never used for
board ports, on the strength of a scan that returned zero validated
`mov dx, imm16` sites with a board-range immediate. **That was wrong**, and the
error was in the scanner rather than the image: the consensus boundary test
rejects genuine instructions preceded by short or irregular code. `mov dx, 0x40`
at `0e3ad` sits after `push cx; pushf; cli` and draws only three converging
predecessors, so a six-vote threshold discarded it. The threshold is back to
four, and the tool now documents that absence from its output is not evidence of
absence.

There are 60 raw `mov dx, imm<=0xff` candidates in the code regions. Tracing
each forward through `add`/`sub`/`inc` on `DX`, fifteen reach an `IN`/`OUT`, and
between them they address only:

| Port | Sites | Context |
|---|---:|---|
| `0x16` | 1 | `005af` |
| `0x18` | 1 | `0e3c4`, the DSP reset strobe |
| `0x1c` | 1 | `0e3d3`, mailbox valid/ack |
| `0x40` | 12 | `00fba`–`01039`, `0e377`, `0e3ad`, `0e54f`, `0e5b1` |

Every one is a port the map already establishes, and none lies in `0x64`–`0x7e`.
The remaining `DX` loads carry peripheral-control-block addresses (`0xff00`+) or
come from the register/value tables at `0x2c6` and `0x28ed8`, which the bootstrap
walks with `lodsw` / `xchg dx,ax` / `out dx,ax`.

One residual gap is worth stating plainly: `DX` is also loaded **from memory**,
as at `0e515` (`mov dx, word ptr [0xe37]`), which then walks `0x50`–`0x5e` by
repeated `add dx,2` / `add dx,4`. A memory-sourced port cannot be bounded by
static inspection alone, so the scan cannot be called complete for the bank.

#### Every apparent access above `0x62` is a decoding artifact

Across the whole image, 235 byte pairs look like an immediate `IN`/`OUT` at a
port in `0x60`–`0x7f`. Of those, 26 are the genuine `0x60`/`0x62` reads in the
`01fe0` state machine; most of the rest lie inside `0x29800..0x44000`, which is
big-endian C5x datapump, not x86 code. Fifty-one fall in x86 regions, eight
survive a six-vote boundary test, and **all eight are refuted by their raw
bytes**:

| Site | Apparent port | Actual bytes | Real instruction |
|---|---|---|---|
| `0cd92` | `7f` | `80 e4 7f` | `and ah, 0x7f` |
| `26b03` | `75` | `9a e4 75 00 80` | `lcall 0x8000:0x75e4` |
| `282a4` | `74` | `0a e4` `74 01` | `or ah,ah` then `jz` |
| `1684e`, `1687f` | `7c` | `c7 06 b5 03 e5 7c` | `mov word ptr [0x3b5], 0x7ce5` |
| `1c153`, `1c167` | `75` | `e8 6b e5` | `call rel16` displacement |
| `1818a` | `69` | `44 6f e7 69 6e 20` | ASCII text |

Three of them name odd ports, which the hardware readback already shows are
undriven. The dominant artifact class is a far pointer to an offset whose low
byte is `e4`–`e7`: `lcall 0x8000, 0x7ae4` assembles to `9a e4 7a 00 80`, and its
middle two bytes read as `in al, 0x7a`. That single pattern accounts for the
13-site "cluster" at `174d4..17654` that first looked like real code.

**Conclusion: no instruction found in the supervisor reads or writes any port
from `0x64` to `0x7e`.** The only code touching the block is the `0x60`/`0x62`
reader. This rests on the raw-byte refutation of every candidate above, not on
the boundary heuristic. It is not a proof of absence: a `DX` loaded from memory,
as the downloader does at `0e515`, could in principle reach those ports on a path
this analysis cannot bound.

#### Why recursive descent was not used

An attempt to replace consensus decoding with recursive descent, seeded from the
reset stub and iterated over far-call targets to a fixpoint, reached only 589
instructions. This firmware dispatches through indirect vectors (`call word ptr
[0x2d3]`, `jmp word ptr cs:[bx+0x107b]`) and register tables, so a static
traversal stalls almost immediately. Consensus decoding over known code regions,
with raw-byte confirmation of anything isolated, is the workable method here.

#### What this implies about the block

`0x64`–`0x7e` is driven with varied, unit-specific data that no firmware path
reads. Two readings were open: sixteen distinct registers the firmware simply
never uses, or **one streaming register aliased across the range**, since the
`01fe0` machine reads `0x62` (high) then `0x60` (low) repeatedly and appends each
word to a buffer walked through `[0x08a2]` — a FIFO read rather than a scan of
distinct addresses.

A read-only repeat experiment on the idle, on-hook 20.16 MHz unit settles it.
`ATGLK2I0060` returned `0b` on five consecutive reads, and `ATGLK2B0000` issued
six times in succession returned six byte-identical responses across the whole
`0x00`–`0xff` range, `0x60`–`0x7e` included. The transcript is saved as
`artifacts/io-port-map/hardware-2016mhz/repeat-stability.txt`.

**The streaming reading is refuted.** Repeated reads do not pop, advance or
otherwise disturb the block, so these are sixteen stable registers, and the
`01fe0` machine's repeated reads of `0x60`/`0x62` are polling one register rather
than draining a queue. That also removes the block from consideration as a bulk
inbound path for a DSP readback: a register that returns the same value on every
read cannot carry a stream.

What remains is a stable, per-unit block that the firmware never reads. Its
values differ between the two units while holding constant within each, which is
the shape of identity or configuration state presented by the ASIC rather than
live datapump status. That is an observation about its behavior, not an
identification: nothing here shows what the values mean, what writes them, or
whether any firmware path reads them through a mechanism this analysis cannot
see. Reads of the block are cheap and non-disturbing, so it is safe to sample
again under different conditions — off-hook, mid-call, after a reset — which is
the obvious way to learn whether any of it tracks call state.

### Reading the map on hardware

The `B` selector dumps 256 consecutive I/O ports and takes a full 16-bit
address, so `ATGLK2B0000` covers the whole peripheral bank and `ATGLK2B0100`
and beyond probe for further decoded windows. It is a read of every port in the
requested range, including the mailbox data registers whose reads the
supervisor's own receive path treats as consuming, so it is only meaningful with
the modem idle and on-hook, and it is not safe during a call or an in-flight
mailbox transaction. Every sweep recorded above was taken on an idle unit.

Because an unmapped port returns its own address byte, a `B` sweep distinguishes
decoded from undecoded space directly, and a row that reads back as a clean
ascending address pattern means "nothing here" rather than "zeros here".

The emulator corroborates the low bank but not the rest: a 30 M-instruction
`run` of the captured image reaches main-loop and touches only `0x00..0x1e`,
`0x40..0x5e` and the boot-time PCB, because the flash image carries no separable
C52 payload and the DSP bridge cannot be attached to it. `0x60`–`0x7e` and
`0xc0`–`0xc6` were not executed in any run recorded here, so the live values in
that block have no counterpart in the emulator's model.

## How the DSP gets its program

The DSP's program is not resident in the DSP. It is held in flash and
**downloaded over the I/O ports at every boot**, which is both the CPU-to-DSP
write path and the answer to how a feature like V.90 was ever added to a
shipped modem: a firmware update replaces the flash image, and the flash image
contains the datapump.

### The write path

`e47b` in the captured image is the downloader, and it writes to the DSP through
the port bank:

```text
074f2..07507   quiesce, then call e370 (bootstrap/window setup)
0750a  mov ax,8000    ; DSP entry, requested word address
0750d  call e3aa      ; reset and request entry at DSP word 0x8000
07510  mov ax,0       ; source offset
07513  mov cx,d87c    ; end offset
07516  call e47b      ; download
```

`e47b` sets `ES = 0xa908` (physical `0xa9080`, flash offset `0x29080`), takes the
word count as `(CX-AX)/2`, and then loops: four words out through `0x40`, `0x42`,
`0x44`, `0x46`, `0x48`, `0x4a`, `0x4c`, `0x4e` as low byte then high byte, strobe
`OUT 0x18,1`, wait on `IN 0x18` bit 1; four more words through the second window
based at `[0x0e37]`, walking `0x50`/`0x52`, `0x54`/`0x56`, `0x58`/`0x5a`,
`0x5c`/`0x5e` by `add dx,2` and `add dx,4`, strobe `OUT 0x18,[0x0e36]`. When the
count is exhausted it sends the 16-bit sum computed by `e447` through `0x40`/`0x42`,
strobes `OUT 0x18,4`, and polls `IN 0x18` bit 4 for acceptance. `[0xff46]` bit
`0x20` is the timeout escape on every wait.

`e46e` is the same routine entered with `[0x0e36]=1` and `[0x0e37]=0x40`, so both
halves go through window A; `e47b` uses `2` and `0x50` for the alternating form.

This is what the port map calls "bootstrap window A and B". It is more usefully
described as a **single 8-word write channel to the DSP**, handshaked on `0x18`.

### The load base, now pinned

The call site fixes what was previously an open hypothesis. `courier_firmware_analysis.md`
records `file = 0x29800 + 2·prog` as unverified. The executable code gives a
different and exact answer:

- source flash `0x29080`, length `0xd87c` bytes = **27,710 words**
- extent flash `0x29080..0x368fc`
- entry requested at **DSP word `0x8000`**

```text
flash_offset = 0x29080 + 2 * (dsp_word - 0x8000)
```

Two independent checks agree. Flash `0x29080` is where the DSP reset code
`LDP #0; SPLK #ffff,@57; SETC INTM` already sits, and it maps to word `0x8000`,
the address `e3aa` requests. The resident sender at words `83d6..83ff` maps to
flash `0x2982c..0x2987e`, inside the `[0x29080,0x29880)` startup/sender region
identified separately. The older `0x29800 + 2·prog` hypothesis would have put
word `0x8000` at `0x39800` and should be discarded.

### What this means for the dump goal

The consequence is that **the datapump is already in hand**. Flash
`0x29080..0x368fc` of `courier-board.rom` is, byte for byte, what the DSP
executes from word `0x8000`, and the mapping above makes it directly
disassemblable. Reading it out of the DSP would recover a copy of something
already captured.

What remains unrecovered is narrower than "the DSP": it is the DSP's **internal
boot ROM**, the mask-programmed code below word `0x8000` that implements the
reset handshake, accepts this download, verifies the checksum and launches the
image. That is what the probe kernel's read of program words `0x0000..0x001f`
was aiming at, and it is the only part a physical readback can add.

Two things are open. Only one call to `e47b` exists in the image, covering
`0x29080..0x368fc`, while the datapump region is usually described as running to
`0x44000`; how the remainder reaches the DSP, whether as overlays through the
same channel or not at all, is not established here. And the `23f0` helper that
the resident sender calls maps below word `0x8000` under the pinned base, which
would place it inside the internal ROM rather than the downloaded image — worth
confirming, since it would mean downloaded code calls into ROM entry points.

## CPU port-space output latches

The `ATGLK2O` selector writes CPU I/O ports, so the three output latches at
ports `0x10`, `0x12` and `0x14` are directly drivable from the AT interface.
This section records their mechanism, the confirmed function of each driven
bit, and the hazards. Unlike everything above it, part of this is **physical
write evidence**: `O` commands were sent to a modem. That is the first time a
write of any kind has been issued to a unit in this investigation, and it
supersedes the standing statement elsewhere in this document that only `AT`,
`ATI7` and `ATGLK2=` reads have ever been sent.

### Mechanism

Two helpers in `courier-board.rom` drive the latches, `0x2771` (set bits) and
`0x279b` (clear bits), with the port table at `0x27c7`. `AH` is the bit mask and
`AL` a descriptor whose bit 3 must be set; `AL & 3` selects both the port and a
RAM shadow byte:

| `AL` | Port | Shadow |
|---|---|---|
| `08` | `0x10` | `[0x30e]` |
| `09` | `0x12` | `[0x30f]` |
| `0a` | `0x14` | `[0x310]` |
| `0b` | `0x12` | `[0x311]` — no call site uses it |

The latches are **write-only**. Reading ports `0x10`/`0x12`/`0x14` returns input
signals, not the latch contents, which is why the firmware keeps shadows and
performs a `cli`-protected read-modify-write against them. Initialization at
`0x2728` fills `0x30e..0x312` with `0xff`, then forces `[0x30e]=0xfe` and
`[0x30f]=0x7f`.

The captured idle RAM of the 20.16 MHz unit
(`artifacts/courier-board-21210-ram-01/ram-pass1.bin`, confirmed by `pass2`)
holds `fe 7d f5 ff` at `0x30e..0x311`. Those values are readable live with
`ATGLK2=0000:0300`, bytes `0x0e..0x11` of the page.

Nothing reads `[0x310]`, and there is no direct `out 0x14` in that code bank, so
port `0x14` holds whatever is written until the next helper call touches it.

### The `O` selector does not read-modify-write

`O` is a bare `out dx,al` of the byte supplied. It writes all eight bits, and it
does not update the firmware's shadow. Two consequences:

- A single-bit poke must be composed by hand from the current shadow value.
  `ATGLK2O0014,40` does not set bit 6; it clears the other seven.
- After a write, the shadow and the latch disagree. The firmware believes its
  shadow, so it will not restore the latch on its own; a bit left flipped stays
  flipped until an explicit write or a power cycle. This was observed: setting
  port `0x12` bit 1 turned MR off and it remained off.

The firmware's own read-modify-write is interrupt-protected. A read of the
shadow followed by a separate `O` write is not atomic against it.

### Confirmed function of the driven bits

Bit functions below were established by strobing single bits on a physical unit
and observing the front panel; they are user-reported observations, not captured
transcripts. Port `0x14` is active low: `0` lights the indicator.

| Port | Bit | Function | Evidence |
|---|---|---|---|
| `0x14` | 0 | CD lamp | observed |
| `0x14` | 1 | CS lamp (lit at idle) | observed |
| `0x14` | 2 | — | no driver located |
| `0x14` | 3 | driven, no visible effect | `0x22d6`/`0x22f3` |
| `0x14` | 4 | AA lamp | observed |
| `0x14` | 5 | ARQ lamp | observed |
| `0x14` | 6 | HS lamp | observed |
| `0x14` | 7 | SYN lamp | observed |
| `0x12` | 1 | MR lamp (lit at idle) | observed |
| `0x12` | 3 | untested | `0x267d`/`0x269d`, gated on `[0xdfd]` |
| `0x12` | 4 | analog path: audible pop | observed |
| `0x12` | 5 | untested | `0x25d0`, gated on `[0x693] & 6` |
| `0x12` | 7 | forced low at init, no driver | `0x2737` |
| `0x10` | 0 | CD line to the DTE | `0x92b1`/`0x9380` set on connect, `0x93a2`/`0x93d9`/`0x96a7` clear on teardown, all gated on `[0x5b4] & 2`; `0x0b45` clears on timer expiry |
| `0x10` | 3, 5, 6 | serial EEPROM bit-bang | `0x1490`..`0x15a5` |

Port `0x14` bit 0 driving the CD *lamp* while port `0x10` bit 0 drives the CD
*line* is consistent: `&C` controls the line, the lamp follows carrier. The
panel indicators with no latch bit — RD, SD, TR, RS — are the ones expected to
be wired to the UART and control lines in hardware.

### Port `0x10` is not safe to write

`0x1490` starts from `[0x30e]`, forces bit 5 high and bit 3 low, `out 0x0e,0x6f`
to select, then toggles bit 6 as a clock with `in al,0x10` reading data back;
`0x1540` restores the shadow and writes `out 0x0e,7`. That is a bit-banged
serial EEPROM — the store holding the modem's saved profiles. The same pattern
recurs at `0x27a6e..0x27b64` in another bank.

These bits are driven by direct `out 0x10` writes that bypass the helper API, so
a scan of helper call sites does not see them. An arbitrary byte written to port
`0x10` can clock the NVRAM interface. **Do not write port `0x10`.**

### What the self-test routine covers

`0x26a8` walks a nine-entry table at `cs:0x26f2`, calls clear on every entry,
delays, then calls set on every entry with interrupts masked. It is reached by
`lcall 8000:26a4` from a dispatcher at `0x26247` when the parsed value is `5`;
the AT syntax that reaches that dispatcher has not been identified.

| Entry | `AX` | Port | Bit |
|---|---|---|---|
| 0 | `1009` | `0x12` | 4 |
| 1 | `400a` | `0x14` | 6 |
| 2 | `100a` | `0x14` | 4 |
| 3 | `010a` | `0x14` | 0 |
| 4 | `0108` | `0x10` | 0 |
| 5 | `0209` | `0x12` | 1 |
| 6 | `020a` | `0x14` | 1 |
| 7 | `800a` | `0x14` | 7 |
| 8 | `200a` | `0x14` | 5 |

This table was the basis for choosing which bits to strobe: the firmware drives
each of them in both directions itself, so doing so by hand reaches no state the
firmware does not. That argument survives, but the accompanying reading that the
group is purely front-panel does not — entry 0 produced an audible pop, so the
routine is a broader self-test than a lamp test. Entry 4 is on port `0x10` and
should be excluded on the NVRAM grounds above despite appearing here.

Port `0x12` bits 3 and 5 are driven by the firmware but are **not** in this
table, so they lack that cover, and the latch is now known to reach the analog
path.

### Bearing on the DSP

No bit that the firmware drives is a DSP control line. Every driven bit above
resolves to a front-panel indicator, a DTE control line, the NVRAM interface or
the analog path.

That is not the same as establishing that the latch bank contains no DSP
control. Port `0x14` bit 2, port `0x12` bits 0, 2 and 6, and port `0x10` bits 1,
2, 4 and 7 have no located driver, and absence of a driver is not evidence that
nothing is wired to the pin. The positive evidence that DSP reset is elsewhere
is `0xe3ab`/`0xe429` driving `[0xff56]` bit 1 directly, which is a CPU port pin
rather than an ASIC latch; that argument covers reset specifically and does not
exclude some other DSP-related strap or enable.

Port `0x14` bit 2 is the best remaining candidate for a blind probe: it sits on
the latch whose other seven bits are all confirmed panel or DTE signals, with no
NVRAM lines and no analog surprise so far. From shadow `f5` the strobe byte is
`f1` and the restore is `f5`. A DSP disturbed by such a poke is recoverable by
power cycle, since the datapump is downloaded from flash at every boot; the
risk in that experiment is the latch, not the DSP.

### Port `0x14` bit 2 probed, 2026-09-04

The probe was run on the 20.16 MHz unit (`/dev/cu.usbserial-21210`, serial
`0009540034268322`, the board that produced `courier-board.rom`). Live shadows
read `fe 7d f5 ff`, matching the earlier RAM capture exactly, so the strobe was
`f1` and the restore `f5`.

Sequence: `AT`, `ATI7`, `ATGLK2=0000:0300`, two `ATGLK2B0000` sweeps, the
`ATGLK2O0014,F1` write, two more sweeps, `ATGLK2O0014,F5`, two more sweeps.
Each phase required two byte-identical sweeps before being accepted, and the
restore was issued from a `finally` block. No flash, NVRAM or upload command was
sent. Saved as `artifacts/io-latch-bit2-01/`.

**Result: zero of the 256 ports changed while bit 2 was held low**, and the
post-restore sweep is byte-identical to the baseline. Because port `0x14` has no
refresh path, the bit genuinely stayed low across both intervening sweeps rather
than being restored underneath the measurement.

This is a null result about *feedback*, not about function. An `ATGLK2B` sweep
sees only what the CPU can read back; a latch bit routed to a DSP pin, a lamp or
an analog gate would not appear in the peripheral bank at all. What it does
establish is that bit 2 is not wired into anything the supervisor can observe
through I/O space, and that the write/restore cycle disturbs nothing else.
Whether the bit is visible on the front panel was not checked on this run.

## Remaining hardware integration

The supervisor code, DSP sender and serial parser now exist and execute
together offline. A way to place the monitor in the physical supervisor's RAM
and transfer control to `0000:2000` has not been established. In particular,
the monitor assumes a working UART and peripheral mapping on entry; it is
not a reset-vector replacement.

The updated supervisor also needs a verified compatible SDL container and a
known restoration path. The stock upload's `T` option has not been shown to
execute a RAM payload; it must not be represented as a RAM-only diagnostic
loader. Neither the modified reference ROM nor this raw kernel is a prepared
hardware update.

TI documents table reads and the optional C5x protection mechanism in
[SPRU056D, §8.2.4](https://www.ti.com/lit/pdf/spru056). Protection can prevent
instructions executing from external RAM from reading on-chip program ROM.
That question remains a hardware experiment once launch and readback work.

Tests:

```sh
python -m pytest tests/test_dsp_probe.py tests/test_probe_transport.py -q
```
