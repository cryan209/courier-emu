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
