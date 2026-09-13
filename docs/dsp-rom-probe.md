# Reading the board through its monitor, and the DSP mask ROM

The physical target is the 20.16 MHz unit on `/dev/cu.usbserial-21210`, serial
`0009540034268322` - US/Canada external, 512 KiB flash, 64 KiB RAM, supervisor
7.3.14 / DSP 3.0.13 dated 03/13/98. Those version strings match the reference
`IDSDL302.ROM` but do not prove identical firmware.

> **Provenance.** `firmware/legacy-usrobotics/IDSDL302.ENG` describes a
> *modified* 20.16 MHz release based on the stock 03/13/98 SDL, adding
> configuration and memory-editing commands. Do not treat the reference ROM as
> an unmodified stock replacement for this unit. The captured image differs from
> the pinned reference in 11,295 bytes.

## The mask ROM has not been read, and the readback route is closed

A TMS320C52 has a **4K x 16 mask-programmable ROM at program words
`0000..0fff`** - not throughout `0000..7fff`. The downloaded image starts at
`8000`; lower addresses like `23f0`, `2100..2593` and `7a80` can be external or
installed program RAM but cannot be part of the ROM array.

Three separate questions, not one:

| question | current answer |
|---|---|
| Does a C52 die contain mask-ROM hardware? | Yes: 4K words at `0000..0fff`. The package marking still needs photographing to make the identification physical rather than instruction-set inference. |
| Is this unit's ROM programmed with the Courier bootstrap? | Strongly suggested, not hardware-proven. The unit accepts and starts a download at `8000` after reset, but an ASIC sequencer writing external DSP program RAM while the core is reset remains an architectural alternative. |
| Can externally supplied code or JTAG read it? | Unknown until the mask-programmable protection option is tested on this unit. |

TI's protection option, if programmed, makes an instruction fetched from
off-chip memory read invalid bus data for an on-chip program operand, and blocks
the emulator - so a downloaded `8000` probe and an ordinary JTAG dump both fail
by design. **On-chip SARAM is not on that exclusion list**, which is the one
gap in it.

The non-destructive discriminator, if a scope goes on the board: photograph the
DSP marking and match it against the C52/C52LC PJ or PZ pinout; **observe
`MP/MC` at DSP reset** (low maps the internal ROM, high maps external program
memory - the pin is sampled only at reset, while the `PMST` bit can change
later); and watch `PS`, `STRB` and enough address lines during reset. An
external program fetch at address zero supports `MP/MC = 1`; no such fetch while
the download handshake executes supports internal ROM execution.

### Why the host-side route closes

The DSP has a real bulk readback channel to the host - arm it with a mailbox
tag, pump it with `0x1c` bit 2, read words at ports `0x60`/`0x62`. It is
verified end to end on hardware. Tag `46` is the closest it comes to a dump,
because its handler table-reads four **program** words before streaming them:

```text
84d4  splk  @1e, #8617         ; arm: 16 words from ff80
84d6  lar   ar2, #ff80
84d9  lacl  @5b                ; the index at 03db
84da  add   #860b              ; unmasked
84dc  tblr  *+  ...            ; four program words into ff80..ff83
```

The arithmetic is unmasked, so the index reaches any 16-bit program address, the
mask ROM included. **Every piece a dump needs is present except control of the
index**, and the index cannot be controlled.

`03db` has exactly two writers. `9773` only reads it; `ae98` writes what `ae12`
returns, and `ae12` is a **six-way priority encoder**:

```text
ae12  call  ade8
ae14  sacl  @7d
ae15  bit   10, @7d ; lacl #05 ; retc tc      ; TI bit 10 is bit 5
ae18  bit   11, @7d ; lacl #04 ; retc tc
ae1b  bit   12, @7d ; lacl #03 ; retc tc
ae1e  bit   13, @7d ; lacl #02 ; retc tc
ae21  bit   14, @7d ; lacl #01 ; retc tc
ae24  lacl  #00 ; ret
```

It tests five bits, highest first, and falls through to zero. **Its output is
`0..5` by construction**, so no control over its input can widen the range. The
reader's address is confined to `860b..8610` by the shape of the encoder, not by
a clamp that might be bypassed. That closes the `84d3` route regardless of what
feeds it.

Tracing the input anyway found something worth keeping: `ade8` ANDs four cells
at `ffb0..ffb3`, and **`ffb1` is host-writable through tag `48`**, whose handler
is `smmr @7a, #ffb1 ; ret` with no range test at all - the only completely
unclamped host write into DSP data space found. `ffb2` derives from it in turn.
It does not help here, because an AND only clears bits and the other two terms
come from a call-setup routine an idle unit has not run: tested directly in
`artifacts/dsp-window-index-01/`, tag `48` with `ffff` then tag `46` armed and
pumped still returned index `0`.

**The sharpest remaining lead** is `ffb8`/`fff8`. A streamer whose source address
lives in a data cell would be an arbitrary DSP *data* read if that cell could be
reached, and the host-writable set includes `fff0`-`fff3` - adjacent to `fff8`,
but not it.

### And the datapump is already in hand anyway

The DSP's program is **downloaded over the I/O ports at every boot**, and the
load base is pinned:

- source flash `0x29080`, length `0xd87c` bytes = **27,710 words**
- extent flash `0x29080..0x368fc`
- entry requested at DSP word `0x8000`

```text
flash_offset = 0x29080 + 2 * (dsp_word - 0x8000)
```

Two independent checks agree. Flash `0x29080` holds the DSP reset code
(`LDP #0; SPLK #ffff,@57; SETC INTM`) and maps to word `0x8000`, the address
`e3aa` requests; and the resident sender at words `83d6..83ff` maps to flash
`0x2982c..0x2987e`, inside the `[0x29080,0x29880)` startup/sender region
identified separately. The older `0x29800 + 2·prog` hypothesis puts word `0x8000`
at `0x39800` and should be discarded.

So flash `0x29080..0x368fc` of `courier-board.rom` is, byte for byte, what the
DSP executes from word `0x8000`. **Reading that out of the DSP would recover a
copy of something already captured.** What the mask ROM would add is the
**internal boot ROM** at words `0x0000..0x0fff`, which is the part not in flash.

One low-memory question stays open. The image proves only the explicit
`23f0..23f2` write. The loader at `812b` reads its initial `BMAR` from external
ASIC cell `ff62`, copies four words obtained through `ff58`, increments `BMAR`
per word and writes the final value back - so nothing in the payload fixes that
external starting value to `2100..2593`. An exhaustive scan closed the apparent
lead that five more `bldp` sites install those coefficients: seven payload words
carry the `57xx` opcode byte, only two are instructions (the fixed `bldp *+` at
`80a7` and the shared loader at `812b`), and the other five sit inside tables
rooted at `967a`, `a29a`, `a82a`, `c3a4` and `dc50` with no branch into any of
them. **That was coefficient data being decoded as code.**

## The monitor

`ATGLK2` is the installed handler at flash `25ba9`. The prefix check is
`cmp word ptr [si],'LK'` then `cmp byte ptr [si+2],'2'`; after `add si,3` /
`sub cx,3`, `jcxz` leaves `BL` holding the outer `G`, so a bare `ATGLK2` matches
no selector. Seven selectors:

| suffix | target | operation |
|---|---|---|
| `=` | `26e20` | Memory byte dump, 16 rows of 16 bytes |
| `R` | `26e8b` | Memory word dump, 16 rows of eight little-endian words |
| `I` | inline `25c45` | Read one I/O port, print one hex byte |
| `O` | inline `25c65` | Write one I/O port: `O<port>,<byte>` |
| `B` | `26eec` | I/O port block dump, 16 rows of 16 ports |
| `N` | inline `25c3d` | `or byte ptr [25e],1`; sets a flag, prints nothing |
| `U` | inline `25c8d` | `clc; ret`; accepted and ignored |

Addresses are hex CPU `segment:offset`. Each `=`/`R` request is fixed at 256
bytes and the offset increments as a 16-bit register, so a request crossing
`ffff` wraps within the same segment. With only one address number the reader
uses segment zero.

**The modified reference dispatches differently.** On the reference, `25ba9`
skips `LK2` and dispatches the next character through `c800:0024` to an
extension at flash `49022`; the physical handler *requires* `LK2` and calls the
byte reader at `26e20` / word reader at `26e8b` directly. The readers themselves
match. Do not assume the reference's extension call or optional-prefix behaviour
on this board.

**Hazards.** `I`, `O` and `B` operate on CPU **I/O space**, which is the only
way to reach `0x40..0x5e` and `0x1c` - the ASIC bootstrap window and mailbox
latches - since `=` and `R` cannot address I/O at all. But I/O reads are not
side-effect free: the supervisor's own receive path consumes mailbox replies by
reading `58..5e`, and `B` sweeps 256 **consecutive** ports unconditionally with
no way to narrow the range. **Treat `B` as disruptive to a live call and to any
in-flight mailbox transaction.** `O` is a write, not a diagnostic.

**Every complete response ends with `ERROR`, and the data before it is good.**
The cause is a parser count defect: `LODSB` at `26e2b` consumes the colon
without decrementing `CX`, unlike the hex parser's character consumption. An
isolated execution of the captured handler prints the exact expected 256 bytes
for `LK2=8000:0000`, returns carry clear, and leaves `CX=1` with `SI` at the
carriage return. That test bypasses the outer AT dispatcher, so it is a likely
explanation rather than a reproduced end-to-end result.

## What has been captured off this board

| capture | extent | result |
|---|---|---|
| flash | physical `80000..fffff` | 524,288 bytes, `f3a8b013…`, 2,048 pages each read twice with zero retries, 1,107.8 s |
| RAM | `0000..feff` | two passes, 65,280 bytes each, 139.44 s, differing at 44 addresses |
| upper window | physical `10000..1ffff` | two passes, 65,536 bytes each, 144.79 s, differing at 17 bytes |

All three are read-only: `AT`, `ATI7` and `ATGLK2=` only, no upload and no
memory-write command. Each has an offline audit that re-parses the saved
responses against the stored blocks and hashes.

The first 256 bytes of flash match the reference exactly, including the
`INT80186 Modem Functions` text. The captured reset stub decodes to flash base
`80000` and entry `fc00:11e9`. The DSP reset/download block `[e370,e598)`, the
CPU byte/word readers `[26e20,26eec)` and the DSP startup/sender region
`[29080,29880)` match the reference exactly; 11,295 bytes elsewhere do not. The
64 KiB windows at physical `d0000` and `e0000` read entirely `ff`, and erased
reads cannot distinguish separate blank banks from aliases.

**The upper window is the same RAM.** Five fresh lower/upper/lower groups match
completely, each upper pass differs from the lower at 45 of 65,280 comparable
bytes, and 249 of 255 whole pages match exactly - which is the live-RAM churn
rate the two lower passes already show, not a different device.

**The RAM capture supplied the cached settings block**, which the emulator was
missing:

```text
RAM 0752..0763: 64 96 03 08 0b 1a 64 96 03 ef 87 1d ef 87 1d ef 87 1d
Settings 1..6:  0, 30, 7, 30, 0, 0
```

All three redundant copies agree. Setting 3 is `7`, whose bit 0 satisfies the
serial-output enable condition traced in the firmware.

## The CPU I/O port map

Every densely used port is **even and byte-wide**, from `0x00` to `0x62`, a
peripheral bank at a stride of two. The physical readback confirms the stride
and extends the bank to `0x7e` - 64 registers rather than the 50 the static
sites reach.

Produced with `tools/io_port_scan.py` over the captured image. A linear sweep
desynchronizes inside the little-endian datapump and the coefficient table, so
the scanner accepts an `IN`/`OUT` opcode only when at least four disassemblies
started at earlier offsets converge on it, and scans only `0x00000..0x29800`,
`0x44000..0x7c000` and `0x7e000..0x80000`. Ports loaded into `DX` resolve only
when an immediate `mov dx` reaches the site with no intervening branch, call or
non-immediate redefinition. The run accepted **971 sites** and left **295 `DX`
sites unresolved**, so every count below is a lower bound. Consensus decoding is
a heuristic, and a site's existence does not make its path reachable.

| port | sites | direction | function |
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
| `0x40`-`0x4e` | 59 | r/w | DSP bootstrap window A: eight byte latches carrying four payload words |
| `0x50`-`0x5e` | 125 | r/w | Window B and the runtime mailbox. `0x58`/`0x5a` carry tag low/high, `0x5c`/`0x5e` data low/high |
| `0x60`, `0x62` | 27 | read only | Third 16-bit read window, high byte at `0x62`, low at `0x60` |

The `0x40..0x4e` / `0x50..0x5e` split matches the alternating-window downloader
at `e47b`: four words through the first bank with strobe 1, four through the
second with strobe 2.

Sixteen-bit and odd-address forms appear in the scan (`0x03`, `0x05`, `0x0d`,
`0x11`, `0x1f`, `0x2d`, `0x4f`, `0x57`, `0xc3`), each at one or two isolated
sites, none corroborated by an emulator run - more likely decode noise than real
registers. No odd port is driven on hardware, though a dump cannot separate an
unmapped odd port from a mapped one reading zero.

**The `0x60`/`0x62` window** is read-only to the CPU - no write site at either
port anywhere in the scanned regions. All 27 sites fall in one routine at
`01fe0..02128`, driven through an indirect continuation vector at `[0x02d3]`
that each step rewrites to the next, dispatched by `call word ptr [0x2d3]` at
`00674`. Every step reads 16 bits as `in al,0x62` then `in al,0x60` and appends
to a buffer walked through `[0x08a2]`, with a countdown at `[0x02d1]`. The
high-then-low convention is the same one the supervisor uses on `5a`/`58` and
`5e`/`5c`, so this is a third inbound 16-bit window in the same family. **Its
producer is the DSP** - see the streamers below.

**Nothing reads `0x64`-`0x7e`.** No instruction found in the supervisor reads or
writes any port in that block; the only code touching it is the `0x60`/`0x62`
reader. That rests on a raw-byte refutation of every candidate, not on a
boundary heuristic, and it is not a proof of absence - a `DX` loaded from
memory, as the downloader does at `0e515`, could in principle reach those ports
on a path this analysis cannot bound.

**And the streaming reading of that block is refuted.** Repeated reads do not
pop, advance or otherwise disturb it, so those are sixteen stable registers and
the `01fe0` machine is polling one register rather than draining a queue. A
register that returns the same value on every read cannot carry a stream, which
removes the block from consideration as a bulk inbound path.

**The `0xc0`-`0xc6` cluster** is a separate coherent block at `08332..083b5`: it
sets `PACS` to `0xe000`, sets `[0xff18]` to `0x10`, then reads `0xc2`/`0xc0` and
writes `0xc4`/`0xc6` while streaming `0x1554` words from segment `0xe000`. It is
entered from an `AT` handler that first checks for the literal `L` at `08327`.
Because it reprograms a chip select and drives an otherwise unused port bank,
treat it as a **device-programming path, not a diagnostic read**, and do not
invoke it on the physical modem while its function is unknown.

## The output latches, and how to drive them safely

`ATGLK2O` writes CPU I/O ports, so the three output latches at `0x10`, `0x12`
and `0x14` are drivable from the AT interface. Part of what follows is physical
**write** evidence - the first writes of any kind issued to a unit in this
investigation.

Two helpers drive the latches, `0x2771` (set bits) and `0x279b` (clear), with
the port table at `0x27c7`. `AH` is the bit mask and `AL` a descriptor whose bit
3 must be set; `AL & 3` selects both port and RAM shadow:

| `AL` | port | shadow |
|---|---|---|
| `08` | `0x10` | `[0x30e]` |
| `09` | `0x12` | `[0x30f]` |
| `0a` | `0x14` | `[0x310]` |
| `0b` | `0x12` | `[0x311]` - no call site uses it |

**The latches are write-only.** Reading `0x10`/`0x12`/`0x14` returns input
signals, not latch contents, which is why the firmware keeps shadows and does a
`cli`-protected read-modify-write against them. Initialization at `0x2728` fills
`0x30e..0x312` with `0xff`, then forces `[0x30e]=0xfe` and `[0x30f]=0x7f`. The
captured idle RAM holds `fe 7d f5 ff` at `0x30e..0x311`, readable live with
`ATGLK2=0000:0300`. Nothing reads `[0x310]`, and there is no direct `out 0x14`
in that bank, so port `0x14` holds whatever is written until the next helper
call.

**`O` is a bare `out dx,al`.** It writes all eight bits and does not update the
shadow. So a single-bit poke must be composed by hand from the current shadow -
`ATGLK2O0014,40` does not set bit 6, it clears the other seven - and after a
write the shadow and the latch disagree. The firmware believes its shadow and
will not restore the latch on its own; a bit left flipped stays flipped until an
explicit write or a power cycle. Observed: setting `0x12` bit 1 turned MR off
and it stayed off. The firmware's own read-modify-write is interrupt-protected;
a shadow read followed by a separate `O` write is not atomic against it.

### Do not write port `0x10`

`0x1490` starts from `[0x30e]`, forces bit 5 high and bit 3 low, `out 0x0e,0x6f`
to select, then toggles bit 6 as a clock with `in al,0x10` reading data back;
`0x1540` restores the shadow and writes `out 0x0e,7`. That is the bit-banged
serial EEPROM holding the modem's saved profiles, and the same pattern recurs at
`0x27a6e..0x27b64` in another bank. These bits are driven by direct `out 0x10`
writes that bypass the helper API, so a scan of helper call sites does not see
them. **An arbitrary byte written to port `0x10` can clock the NVRAM
interface.**

### Confirmed function of the driven bits

Established by strobing single bits on a physical unit and watching the front
panel - user-reported observations, not captured transcripts. Port `0x14` is
active low: `0` lights the indicator.

| port | bit | function | evidence |
|---|---|---|---|
| `0x14` | 0 | CD lamp | observed |
| `0x14` | 1 | CS lamp (lit at idle) | observed |
| `0x14` | 2 | - | no driver located |
| `0x14` | 3 | driven, no visible effect | `0x22d6`/`0x22f3` |
| `0x14` | 4 | AA lamp | observed |
| `0x14` | 5 | ARQ lamp | observed |
| `0x14` | 6 | HS lamp | observed - **disputed, see below** |
| `0x14` | 7 | SYN lamp | observed |
| `0x12` | 1 | MR lamp (lit at idle) | observed |
| `0x12` | 3 | untested | `0x267d`/`0x269d`, gated on `[0xdfd]` |
| `0x12` | 4 | analog path: audible pop | observed - **disputed, see below** |
| `0x12` | 5 | untested | `0x25d0`, gated on `[0x693] & 6` |
| `0x12` | 7 | forced low at init, no driver | `0x2737` |
| `0x10` | 0 | CD line to the DTE | `0x92b1`/`0x9380` set on connect, `0x93a2`/`0x93d9`/`0x96a7` clear on teardown, all gated on `[0x5b4] & 2`; `0x0b45` clears on timer expiry |
| `0x10` | 3, 5, 6 | serial EEPROM bit-bang | `0x1490`..`0x15a5` |

> **Two rows conflict with [board-verified-403.md](board-verified-403.md), which
> strobed the same bits on this same unit.** That file's sweep puts **no lamp**
> on `0x14` bit 6 and identifies it as the front-panel button - which the
> firmware supports, since `0x877cd` gates the self test on that bit *reading
> low* and `0x87e34` spins while it stays low, an input being released. It puts
> **HS** on `0x12` bit 4, where the row above records an audible pop. Five other
> attributions agree exactly between the two. Both sides are user-reported panel
> observations, so neither transcript arbitrates; re-strobing those two bits one
> at a time, watching and listening, settles it. Until then neither attribution
> should be built on.

Port `0x14` bit 0 driving the CD *lamp* while `0x10` bit 0 drives the CD *line*
is consistent: `&C` controls the line, the lamp follows carrier. The panel
indicators with no latch bit - RD, SD, TR, RS - are the ones expected to be
wired to the UART and control lines in hardware.

### The self-test table, and why strobing was considered safe

`0x26a8` walks a nine-entry table at `cs:0x26f2`, calls clear on every entry,
delays, then calls set on every entry with interrupts masked. It is reached by
`lcall 8000:26a4` from a dispatcher at `0x26247` when the parsed value is `5`;
the AT syntax that reaches that dispatcher has not been identified.

| entry | `AX` | port | bit | entry | `AX` | port | bit |
|---|---|---|---|---|---|---|---|
| 0 | `1009` | `0x12` | 4 | 5 | `0209` | `0x12` | 1 |
| 1 | `400a` | `0x14` | 6 | 6 | `020a` | `0x14` | 1 |
| 2 | `100a` | `0x14` | 4 | 7 | `800a` | `0x14` | 7 |
| 3 | `010a` | `0x14` | 0 | 8 | `200a` | `0x14` | 5 |
| 4 | `0108` | `0x10` | 0 | | | | |

The firmware drives each of these in both directions itself, so doing so by hand
reaches no state the firmware does not. **That argument survives; the reading
that the group is purely front-panel does not** - entry 0 produced an audible
pop, so this is a broader self-test than a lamp test. Entry 4 is on port `0x10`
and should be excluded on the NVRAM grounds above despite appearing here. Port
`0x12` bits 3 and 5 are driven by the firmware but are *not* in this table, so
they lack that cover, and the latch is now known to reach the analog path.

### Port `0x14` bit 2, probed 2026-09-04

Live shadows read `fe 7d f5 ff`, matching the earlier RAM capture exactly, so
the strobe was `f1` and the restore `f5`. Sequence: `AT`, `ATI7`,
`ATGLK2=0000:0300`, two `ATGLK2B0000` sweeps, the write, two sweeps, the
restore, two sweeps - each phase requiring two byte-identical sweeps before
being accepted, with the restore in a `finally` block. `artifacts/io-latch-bit2-01/`.

**Zero of the 256 ports changed while bit 2 was held low**, and the
post-restore sweep is byte-identical to the baseline. Because port `0x14` has no
refresh path, the bit genuinely stayed low across both intervening sweeps.

That is a null result about **feedback, not function**. A sweep sees only what
the CPU can read back; a latch bit routed to a DSP pin, a lamp or an analog gate
would not appear in the peripheral bank at all. What it establishes is that bit
2 is not wired into anything the supervisor can observe through I/O space, and
that the write/restore cycle disturbs nothing else. Whether the bit is visible
on the front panel was not checked.

### Bearing on the DSP

No bit the firmware drives is a DSP control line: every one resolves to a
front-panel indicator, a DTE control line, the NVRAM interface or the analog
path. That is **not** the same as establishing the latch bank contains no DSP
control - `0x14` bit 2, `0x12` bits 0, 2 and 6, and `0x10` bits 1, 2, 4 and 7
have no located driver, and absence of a driver is not evidence that nothing is
wired to the pin. The positive evidence that DSP reset is elsewhere is
`0xe3ab`/`0xe429` driving `[0xff56]` bit 1 directly, a CPU port pin rather than
an ASIC latch; that covers reset specifically and does not exclude some other
DSP-related strap or enable.

## The DSP's streamers, enumerated and count-verified

Following the jump table at program `8401` through each handler settles which
host tag reaches each streamer variant and whether its source block holds
program memory or live data. `tests/test_dsp_window_stream.py` pins the result.

| tag | handler | arm stub | source | words | what it exposes |
|---|---|---|---|---:|---|
| `06` | `8489` | `848d` | `0307 03ba 0385 030f 031c 0be6` | 6 | Six discrete live call-state cells (a custom per-word streamer, not the `8684` engine) |
| `45` | `8623` | `8627` | `ff90` **or** `ff00` | 32 / 17 | Live data block; `@1f` bit 10 (`tc`) picks the variant at runtime |
| `46` | `84d3` | `8617` | `ff80` | 16 | First four words table-read from **program** `860b..8610`; the rest live `ff84..ff8f` |
| `47` | `863e` | `8642` | `ffc0` | 12 | Live data `ffc0..ffcb` |
| `57` | `8517` | `8617` | `ff80` | 16 | **Program** words near `85ff`/`8611` plus derived status |
| `58` | `864e` | `8652` | `ffc0` | 25 | Live data `ffc0..ffd8`; also sets `fff8 := 0a40` |
| `73` | `865e` | `8665` | `[fff8]` = `0a40` | 103 | Live DSP data RAM `0a40..0aa6` |
| `78` | `8671` | `8678` | `[fff8]` = `f993` | 5 | Live DSP data `f993..f997` |

Tags `73` and `78` do both jobs from one handler: `ldp #1ff ; splk @78,#imm`
points `fff8` (page `1ff` puts `@78` at `fff8`), then `ldp #007 ; retd ; splk
@1e,#stub` arms the `[fff8]` streamer with the arm landing in the `retd` delay
slot - the same idiom as tag `06` at `8489`.

Verified by installing the `23f0` accessor, arming one tag through its
jump-table handler, and pumping the resume path `847a` one word at a time,
exactly as a host does with `ATGLK2O001C,04`. Tag `46` is the anchor: it emits
`0708 0708 0960 0960 0000...`, identical to the physical `dsp-window-pump-02`
capture, so the same harness's counts for the others are trustworthy.

| tag | data words | `ffb8` walk | `[ffb9]` immediate |
|---|---:|---|---:|
| `46` | 16 | `ff80` → `ff90` | `0x10` |
| `47` | 12 | `ffc0` → `ffcc` | `0x0c` |
| `73` | 103 | `0a40` → `0aa7` | `0x67` |
| `78` | 5 | `f993` → `f998` | `0x05` |

Every count equalled its arm-stub immediate, `ffb8` advanced by exactly that
many cells, and `[039e]` cleared to `0000` at the end - the streamer disarms
cleanly rather than chaining into the `ff18` continuation.

**Two details a host driver needs.** The stream's first pumped word is the
**count itself**, not payload: the arm stub's opening `bd 84b7` emits with `ar1`
still at `ffb9`, so word 0 reads `0010`/`000c`/`0067`/`0005` - pump `count + 1`
times and discard word 0. And the emit path's "pump me again" flag and the
resume path's poll both resolve to data `0057` (the accessor's `lamm *` masks
the ASIC address to page 0), so **`0057` bit 2 is the handshake cell**.

The words came back zero in that run only because the source blocks are live
call-state RAM an idle core has not filled; the addressing is what is confirmed.
One divergence from a board, recorded so it is not mistaken for a streamer
property: the minimal `47`/`73`/`78` handlers return with `ARP = 0` and the
resume accessor reads its status word through the ARP-selected register, so the
synthetic driver sets `LARP 1` before each pump - the context the real mailbox
interrupt establishes on entry. It does not touch the counts.

Hardware confirms the channel end to end. `artifacts/dsp-window-pump-02/` and
`-03/` are identical except word twelve, `F6B2` against `F708` - a live
measurement in the computed part of the block, with the program words stable.
**Arm with a mailbox tag, pump with `1c` bit 2, read the words at `60`/`62`.**
What is missing is only the index.

## Remaining hardware integration

The supervisor code, DSP sender and serial parser exist and execute together
offline. **A way to place the monitor in the physical supervisor's RAM and
transfer control to `0000:2000` has not been established**, and the monitor
assumes a working UART and peripheral mapping on entry - it is not a
reset-vector replacement.

An updated supervisor would also need a verified compatible SDL container and a
known restoration path. The stock upload's `T` option has **not** been shown to
execute a RAM payload and must not be represented as a RAM-only diagnostic
loader. Neither the modified reference ROM nor the raw kernel is a prepared
hardware update.

The supervisor-side counterpart - how code gets *into* the DSP - is in
[the firmware analysis](../courier_firmware_analysis.md#how-the-dsp-is-loaded-and-run):
the loader routines at file `0xe370`-`0xe711`, the nine-entry overlay descriptor
table, the four-image overlay map and the two transfer engines (`out 0x18`
strobes for cold boot, `out 0x1e` for runtime swaps). Segment `0x8000` maps
linearly to physical `0x80000`. The resident kernel is overlay 5: flash
`0x29140`-`0x36e8e` → DSP `0x8000`-`0xeea6` in 7.4.16, `0x29080`-`0x368fc` →
`0x8000`-`0xec3d` in 7.3.14. Every handler address in this document falls inside
that range and decodes correctly through
`flash = 0x29140 + 2*(dsp - 0x8000)`, which cross-validates both analyses.
