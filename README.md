# Courier XMF emulator harness

This repository contains a reproducible dual-core firmware harness for
`main211.xmf`. It validates and splits the update image, executes the Intel
80186 supervisor in a 1 MiB instrumented address space, and runs the recovered
TMS320C52 program with a standalone 16-bit fixed-point DSP core.

## Recovered `main211.xmf` layout

| File range | Contents |
|---|---|
| `0x00000..0x001ff` | 512-byte product text header |
| `0x00200..0x1b5df` | 55,792 little-endian TMS320C52 words |
| `0x1b5e0..0xb7fff` | Intel 80186 supervisor plus erased flash padding |

The image is mapped at physical `0x40000`. The normal supervisor initializer is
`5b5e:0410` (physical `0x5b9f0`). The six bytes at `5b5e:0000` are instead a
fatal-error entry: they select error `0x0b` and jump to the LED blinker at
physical `0x5c74a`. The CPU's immutable reset vector is not present in this
update payload, so the harness starts at the recovered supervisor initializer.

The DSP area is a segmented program image rather than one flat load:

| File range | C52 program words | Role |
|---|---:|---|
| `0x002f0..0x0eea3` | `0000..75d9` | reset and boot block |
| `0x0eea4..0x101ff` | `de83..e830` | service overlay; entry at `de89` |
| `0x10200..0x1b5df` | `8000..d9ef` | resident high bank |

## Usage

No dependencies are needed to inspect or extract the firmware:

```sh
python3 -m courier_emu info main211.xmf
python3 -m courier_emu extract main211.xmf extracted/main211
python3 -m unittest discover -s tests -v
```

Execution uses Unicorn's 16-bit x86 core and runs in an isolated child process:

```sh
python3 -m pip install '.[execute]'
python3 -m courier_emu run main211.xmf --instructions 250000
python3 -m courier_emu run main211.xmf --instructions 1000000 --summary
python3 -m courier_emu run main211.xmf --instructions 7000000 --with-dsp --at AT --summary
```

The C52 runner has no third-party runtime dependency; it builds with the system
C++17 compiler on first use:

```sh
python3 -m courier_emu dsp-run main211.xmf
python3 -m courier_emu dsp-run main211.xmf --trace 40
python3 -m courier_emu dsp-run main211.xmf --port 0x50=0x1234
```

With no supervisor or line-side events injected, `main211.xmf` reaches a
deterministic 169-address service/polling cycle after 10,241 DSP instructions
and reports `status: stable-loop`. Use `--instructions` to extend the run or
`--trace-start` with `--trace` to inspect a later instruction window.
Opcode forms not exercised by this firmware path fail explicitly with their PC
instead of silently producing guessed state.

The known fatal-blinker calibration loop, initial 80186 timer-ready poll, and
firmware tick-delay helpers are accelerated by default because a CPU-only core
cannot supply their hardware timing. Use `--real-delays` when
instruction-accurate delay counts matter.

Seed hardware input values with repeatable `--port PORT=VALUE` arguments. Port
`0x40` is the first recovered board-control latch. The recovered DTE UART model
accepts `--at COMMAND` (which appends carriage return) or literal
`--serial-input TEXT`. Its RX ISR is vector `0x0e`, with status/control at port
`0x00`, data at port `0x0a`, and RX-ready bit `0x08`. `serial_text`,
`serial_interrupts`, and `serial_trace` report the resulting terminal exchange.
The modeled DTE attention detector accepts the firmware's all-uppercase or
all-lowercase `AT` prefix and passes only the remaining command body to the
banked parser. Captured output is capped at 64 KiB; `serial_truncated` reports
when a diagnostic command exceeds that limit.

Transmit bytes come from the 80186 integrated-UART feed. The routine at
`5b5e:184b` loads the byte in `AL`, waits for transmit status bit `0x08` at
`0xff66`, then applies the framing transform at `5b5e:1913` and writes the
result to `0xff6a`. Both of its wait edges (`5b5e:1874` and `5b5e:1884`) branch
back to the routine's own entry rather than looping in place, so a byte crosses
`0x5ce2b` once per spin but is accepted only once, at `0x5ce66`. Two things
follow, and both are modeled:

- A CPU-only core never drains the transmit-holding register, so status bit
  `0x08` stays clear and the routine spins forever. The modeled DTE reports
  itself ready at the wait point. This is a missing device rather than a
  calibrated delay, so it applies regardless of `--real-delays`.
- `5b5e:1913` recomputes bit 7 as an even-parity bit whenever `[0x26c6]` is
  zero, then applies the `[0x0936]` framing. In those framings bit 7 carries no
  data, so capture reports the seven bits a receiving DTE would keep.

With that in place the diagnostic commands render their real pages. `ATI` and
`ATI0` return the product code, `ATI1` the ROM checksum, `ATI2` the RAM test
result, `ATI3` the product banner, `ATI5` the stored-profile page, `ATI6` and
`ATI11` link diagnostics, `ATI7` the configuration profile, and `ATI4` the full
settings report:

```text
USRobotics Courier V.Everything Settings...

   B0  C1  E1  F1  L2  M1  Q0  V1  X1
   BAUD=9600   PARITY=E  WORDLEN=7
   DIAL=TONE   ON HOOK   TIMER
   ...
   S00=001  S01=000  S02=043  S03=013  S04=010  S05=008  S06=002  S07=060
   ...
OK
```

Note that `ATI5` renders its "NVRAM Settings" page from the RAM shadow at
`0x095c`, not from the serial EEPROM, which matches the call-graph finding
below. Commands execute inside the original firmware: `ATQ1` changes its
quiet-mode profile byte and suppresses the result code, while `ATD123` and `ATA`
enter the line-control path. With no modeled line, an originating call follows the
firmware's `NO DIAL TONE` path. DSP results separate completed `bootstraps` and
`transfer_commands` from runtime
`mailbox_commands`, with a `mailbox_windows` histogram of the latter.

The line-audio endpoint is the Courier ASIC's external C52 I/O frame, separate
from both on-chip serial ports and the 80186 download window. Firmware reads
the held ADC word twice from external I/O port `0x54` at program `0xb300` and
`0xb304`; the second read is copied into active sample cell `0x007f`. Its
matching per-frame `OUT` at program `0x8c24` writes the DAC word to external
port `0xb2e5`, sourced from output cell `0x00cb`. `TRCV` (`0x30`) and `DRR`
(`0x20`) are part of the ASIC/serial framing and address bookkeeping, not raw
linear-PCM endpoints. Supply and capture mono signed-16 little-endian words
after dial/answer activation with:

```sh
python3 -m courier_emu run main211.xmf --instructions 9000000 --with-dsp \
  --dsp-rx-pcm line.s16le --dsp-tx-pcm reply.s16le --at ATDT123 --summary
```

`dsp_bridge.serial_port` reports the register values, access counts, last
firmware PCs, queued/consumed input frames, and line-output counts. The modeled
missing board-to-DSP dial-command handoff recognizes the firmware's parsed
`D` command and drives 9.6 kHz DTMF frames through the C52's real `OUT`
instruction. `ATDT123` produces 697+1209, 697+1336, and 697+1477 Hz bursts.
This establishes bidirectional waveform transport and reproducible tone output;
the original datapump's internal command mailbox remains to be recovered.

The behavioral DAA can attach a disconnected, quiet, dial-tone, or ringing
line. A dial-tone line seizes the hook relay, supplies 350+440 Hz audio to the
recovered ASIC ADC, qualifies the supervisor's five-hit detector at RAM
`0x0649`, removes central-office tone, and starts the parsed digits on the
already-active C52. `--daa-line` enables the DSP bridge automatically:

```sh
python3 -m courier_emu run main211.xmf --instructions 9000000 \
  --daa-line dial-tone --at ATDT123 --summary
```

The original firmware then returns `OK` instead of `NO DIAL TONE`, and
`dsp_bridge.daa` reports hook, line, detector, and generated-sample state. This
is a firmware-derived behavioral DAA, not a claimed identification of the
physical line-interface IC. Ring qualification, loop-current loss,
busy/reorder tone, and carrier negotiation remain unmodeled.

## Board latches, front panel, and NVRAM

Every board output goes through one read-modify-write latch driver, recovered at
physical `0x5e2b0` (set), `0x5e2e5` (clear), `0x5e335` (read an input port), and
`0x5e294` (read the shadow). Callers pass `AX = mask << 8 | index`; the index
table at `0x5e31c` and the shadow bytes seeded at `0x5e26c` give:

| index | port | shadow | contents |
|---:|---|---|---|
| 0 | `0x10` | `0x064d` | hook relay, settings-EEPROM bit-bang pins |
| 1 | `0x12` | `0x064e` | indicators, error-blink code byte |
| 2 | `0x14` | `0x064f` | indicators, board-ID strap drives |
| 3 | `0x12` | `0x0650` | second `0x12` signal group |

Both entry points special-case `AX == 0x0408` and `AX == [0x065c]`: the set path
at `0x5e2b4` jumps into the clear body and the clear path at `0x5e2e9` jumps into
the set body. `0x0408` is latch 0 bit `0x04`, so the **hook relay is asserted by
driving its latch bit low**. Latch 0 bit `0x01` is raised over exactly the same
window (`0x5db4e` on seizure, `0x5e197` on release).

Every run now reports a `panel` block with the current latch values, the asserted
state of each named line, `off_hook`, and a change trace:

```text
i=2191703 port=0x10 value=0xf2 pc=0x5e317 +hook-relay
i=2191740 port=0x10 value=0xf3 pc=0x5e2e0 +off-hook-aux
i=2291289 port=0x10 value=0xf2 pc=0x5e317 -off-hook-aux
i=2291366 port=0x10 value=0xf6 pc=0x5e2e0 -hook-relay
```

Bits are only named where the firmware shows what the line does. Two runtime
DTE lines are now named as well:

- Latch 2 bits `0x01` and `0x80` are driven as one pair by `0x5de57`: cleared
  together at `0x5de65`/`0x5de6b` when the `&C` setting at `[0x09e9]` is zero and
  set together at `0x5de7d`/`0x5de83` otherwise. `&C0` is "carrier detect always
  on", so the cleared level is the asserted one and these are the carrier-detect
  pair. Which one is the DTE pin and which is the front-panel lamp is not
  established, so they are reported as `carrier-detect-a` and
  `carrier-detect-b`.
- Input port `0x12` bit `0x40` is DTR. `0x5e375` samples it, `0x5e395` and
  `0x5e3b5` re-poll it, the two transitions post supervisor events 6 and 7, and
  `0x5e887` turns a low reading into event 10 when S14 bit 0 is set.

The remaining indicator bits on `0x12` and `0x14` are reported under placeholder
names with their driver-wrapper addresses in `courier_emu/panel.py`; mapping them
onto front-panel legends still needs a physical reference.

### Option switches

The board option switches are input bits on the same latch ports, sampled with
the same `mov ax, mask << 8 | index; call 0x2d4a` form the straps use. Six are
read while the profile is built at `0x63d31..0x63ec2` and the carrier-detect
switch is read separately at `0x5e3cf`. The firmware reads a **closed** switch as
a low bit, so the sense is inverted, and each switch also records itself in the
shadow word at `[0x0659]`.

Every row below was confirmed by running `ATI4` with that one input bit pulled
low and diffing the profile the firmware prints, so the effect column is
observed rather than inferred:

| switch | port/bit | closed behaviour | observed |
|---|---|---|---|
| `result-codes` | `0x14` `0x20` | `0x63e2e` clears the quiet setting at `[0x092f]` | `Q0` |
| `quiet-answer` | `0x12` `0x08` | `0x63e54` sets `[0x092f]` to 2 | `Q2` |
| `quiet-answer-alt` | `0x12` `0x80` | `0x63e75` sets `[0x092f]` to 2 | none — gated on capability bits `0x08` and `0x20` at `0x63e40` |
| `numeric-results` | `0x10` `0x02` | `0x63e17` leaves `[0x092e]` clear | `V0` |
| `no-echo` | `0x12` `0x10` | `0x63e93` leaves `[0x092d]` clear | `E0` |
| `dtr-override` | `0x12` `0x20` | `0x63d48` leaves S14 at `[0x094e]` clear | `S14=000` |
| `carrier-detect-override` | `0x14` `0x04` | `0x5e3e1` clears `[0x09e9]` | `&C0` |
| `no-auto-answer` | `0x14` `0x10` | `0x63eb5` leaves S0 at `[0x08de]` clear | `S00=000` |

Three of these names are corrections. `[0x08de]` is S0, not a profile source, so
that switch is the auto-answer switch and its closed position is the one that
stops the modem answering; the switches previously called `verbose` and `echo`
both *disable* those settings when closed. Names now describe what closing the
switch does. Mapping them onto the switch numbers printed on the case still needs
a physical unit.

`--dip` closes a switch and is repeatable; the first use replaces the default
set, and `--dip none` leaves every switch open. `result-codes` is closed by
default because a directly attached DTE wants result codes — with it open the
modem is genuinely silent, which is the real behaviour and used to be papered
over by writing `[0x092f]` directly:

```sh
python3 -m courier_emu run main211.xmf --instructions 4000000 --at AT --dip none
```

### Dedicated-line operation

A modem on a dedicated line has no DTE holding DTR up and no call setup to
follow, so it needs DTR ignored and carrier detect held on. `--dip-preset
dedicated-line` closes `result-codes`, `dtr-override`, and
`carrier-detect-override`, and leaves `no-auto-answer` open so S0 keeps its
flash default of 1 and the modem answers on the first ring:

```sh
python3 -m courier_emu run main211.xmf --instructions 12000000 \
  --dip-preset dedicated-line --at ATI4
```

The firmware confirms all three in its own profile dump: `&C0`, `S14=000`, and
`S00=001`.

### Ring detection

The answer machine at `0x70fb4` polls input port `0x14` bit `0x02` with a direct
`in al, 0x14`, and every state in it waits on an edge of that bit, so a line
that never changes level parks it in its first state forever. That bit is now
modelled: an idle line is not ringing, and `--ring` drives it with a cadence.

```sh
python3 -m courier_emu run main211.xmf --instructions 40000000 \
  --ring --at 'AT#CID=1' --summary
```

The harness has no wall clock, so the cadence is converted from milliseconds
through the instruction count. The firmware calibrates that conversion itself:
`0x70fe0` accepts a burst once the tick counter at `[0x1d50]` reaches the country
minimum at `[0x1f5c]`, which this build loads with 180, and a
2,000,000-instruction burst is exactly what takes that counter to 180. At a
North American 2 s ring that puts one firmware tick at 10 ms and the instruction
clock at 1,111 per millisecond.

With that cadence the answer machine qualifies bursts (`0x70fe9`), raises the
ring-indicate line (`0x70ff0`), and posts its ring message (`0x71026`) into the
supervisor event queue at `0x02e0`. Two gates matter there:

- `[0x094e]` is `#CID`, expanded from packed-config byte 11 of the parameter
  sector, and both ring message sites skip the post when it is zero. `AT#CID=1`
  enables them.
- `[0x0287]` bit `0x10` gates the second ring path, and it reads zero here.

What does **not** yet happen is the answer itself: the queued ring events are
never acted on, with or without `--with-dsp`, so no `RING` reaches the DTE and
the hook relay stays released. The consumer of that queue is the next thing to
recover.

### Answering

`ATA` reaches the same `0x5dbe7` line-detector wait that `ATD` does. Since an
answering seizure has no dial tone to find, the DAA qualifies detector byte
`[0x0649]` on a connected line for `answer` and keeps requiring dial tone for
`originate`:

```sh
python3 -m courier_emu run main211.xmf --instructions 40000000 \
  --at ATA --daa-line quiet --summary
```

That turns `NO DIAL TONE` into `NO CARRIER`, which is the correct answer to
answering into silence: the line is seized and qualified, and training then
fails for the reason the SIP section describes. Treating `[0x0649]` as the
line-side detector rather than a dial-tone-only counter is an inference from the
shared wait, not something the image states.

### Board identification straps

The scan at `0x5bfc6` identifies the board by driving four latch lines low one
at a time (latch 1 bit `0x02`, latch 2 bits `0x40`, `0x10`, `0x20`) and shifting
input port `0x14` bit `0x08` into a four-bit code. `0x5c051` looks that code up
in the table at `0x5c06b` and `0x5c05c` stores the result as the board
capability byte at `0x0a02`. Two capability bits are pinned down: `0x08` is
"settings EEPROM fitted", tested by every NVRAM path, and `0x40` sends `0x5bb0f`
straight to the fatal blinker.

| code | capability | | code | capability |
|---:|---|---|---:|---|
| 2 | `0x29` | | 9 | `0x28` |
| 5 | `0x14` | | 12 | `0x28` |
| 7 | `0x22` | | 13 | `0x22` |

Codes 11 and 14 map to `0x42` and `0x48`, which carry the fatal bit; every other
code is an empty table entry and `0x5c064` stores zero. `--board-id` drives the
straps and rejects the codes the firmware cannot run on. It defaults to 2, the
lowest code describing a board with an EEPROM and no fatal fault; `none` leaves
the lines floating, which the firmware reads as no board at all.

Which of 2, 9, and 12 a given board revision actually straps is not recoverable
from the image — they differ only in capability bit `0x01`, whose meaning is not
established. The default is a constrained inference, not a verified board ID.

Leaving the straps floating is not a state real hardware can be in, and the
firmware treats it as a fault. Two visible consequences:

- `0x667cb` maps a zero or `0xff` capability byte straight to result code 4, so
  `ATI1`, `ATI2`, `ATI3`, `ATI7`, `ATZ` and `ATS30?` answered correctly and then
  reported `ERROR`.
- `0x82ea4` picks the product code from capability bit `0x08`: a board with an
  EEPROM answers `ATI` with `3368`, one without answers `3368A`.

The settings store is a 93C66-class Microwire EEPROM (256 x 16) bit-banged on
latch 0. The driver is at `0x5ccc0..0x5cdf9`:

| routine | role |
|---|---|
| `5b5e:16e0` | read word; `[0x8d2]` = address, result in `[0x8d3]` |
| `5b5e:1746` | write word; `[0x8cf]` = address, `[0x8d0]` = data, EWEN/EWDS bracketed |
| `5b5e:17c6` | build and clock the twelve-bit command frame |
| `5b5e:17d2` | shift bits most-significant first |
| `5b5e:1801` | presence poll; input port `0x10` bit `0x08` must read high |

`5b5e:17c6` forms `bx = ((opcode & 3) | 4) << 8 | address` and rotates it left by
four before clocking twelve bits, which is one pad bit, the start bit, two opcode
bits, and an eight-bit address. Latch bits are `0x20` chip select, `0x40` clock,
`0x10` data in on write and data out on read.

Attach a persistent image with `--nvram`; it is created blank (all ones, like an
unprogrammed part) when the file does not exist and written back after the run:

```sh
python3 -m courier_emu run main211.xmf --instructions 7000000 \
  --at AT --nvram settings.nv --summary
```

`nvram` in the result reports reads, writes, erases, the write-enable latch, the
programmed words, and a command trace.

### Why the EEPROM stays untouched at boot

`reads` and `writes` both stay at zero through boot and plain command mode. That
is the firmware's own behaviour, not a gap in the device model. Three separate
findings account for it.

**There is no boot-time NVRAM profile load.** All eleven call sites for the two
driver entries live in banked segment `0x81b8` (`0x8374x`, `0x8386x`, `0x838b9`,
`0x84de8`), and they are command handlers: a word-by-word diagnostic dump that
prints through the resident character-output helpers, a six-word store whose last
word is a CRC-8 over the previous four, and a config write at `0x84dc7` that
parses a literal `=PW` and programs word 0 to `0x4000` or `0x0000`. None of them
is on the reset path. The working profile at `0x08de..0x095b` is instead filled
at boot from a 77-byte flash default table copied at `0x63b72`, and the saved
profile at `0x095c..0x09d9` is a plain RAM shadow (`81b8:35ee` saves, `81b8:3601`
restores and re-applies).

**The diagnostic and store paths are gated on `[0x0a02] bit 3.`** That byte is the
board capability code produced by the strap scan at `0x5bfc6`, which drives four
lines (latch 1 bit `0x02`, latch 2 bits `0x40`, `0x10`, `0x20`) low one at a time
and shifts input port `0x14` bit `0x08` into a four-bit index, then looks the
index up in the table at `0x5c06b`. With that input floating high the index is
`15`, the table entry is `0x00`, and `0x5c064` stores `[0x0a02] = 0`. Codes `2`,
`9`, `12`, and `14` yield `0x29`, `0x28`, `0x28`, and `0x48`, all of which carry
bit 3. The boot gate at `0x5bbb5` branches on the same bit.

**The persistent configuration lives in a separate parameter flash, not in the
XMF image.** The routine at `0x7e07c` — reached by the harness's `startup-crc`
milestone — scans four 4 KiB blocks from segment `0xf800` (physical
`0xf8000..0xfbfff`), checksums bytes `0x000..0xffd` into `[0x06fc]`, compares
against the word at `0xffe`, and keeps the block with the highest 32-bit version
at `0xffa`. `main211.xmf` maps at `0x40000..0xb7fff`, so that region is empty
here, `ES` comes back zero, and `0x7dffa` skips the whole unpack. Bytes 0..4 of a
valid block become `[0x0a06..0x0a0a]`, and byte 4 becomes **`[0x0a03]`** — the
capability byte that gates the profile restore at `0x6014f` and selects whether
`0x63b6d` loads defaults into the stored profile at `0x095d` instead of the
working copy at `0x08df`.

Synthesising a block confirms the mechanism: writing a 4 KiB record at `0xf8000`
with a matching checksum makes the search return `es = 0xf800` and load
`[0x0a03]`. Reaching command mode from there needs more of the parameter block
filled in than a stub provides, so the harness does not ship one; recovering a
real parameter sector from hardware is what that path needs.

## Parameter sector

The persistent configuration lives in a 16 KiB parameter flash searched at
physical `0xf8000`, which the XMF update image does not carry. The search at
`0x7e07c` walks four 4 KiB sectors, checksums bytes `0x000..0xffd`, compares
against the word at `0xffe`, and keeps the sector with the highest 32-bit
version at `0xffa`. The winner is copied to `0x0a06` one byte for one, so sector
offset *i* lands at RAM `0x0a06 + i`:

| offset | RAM | role |
|---|---|---|
| `0x00` | `0x0a06` | flags; bit 3 keeps `[0x0a03]` clear |
| `0x01..0x06` | `0x0a07..0x0a0c` | country, features, type2, type1, unused2, unused1 |
| `0x11..0x1c` | `0x0a17..0x0a22` | serial number, 12 ASCII characters |
| `0x1d..0x2f` | `0x0a23..0x0a35` | packed config, expanded at `0x64044` |
| `0x30..0x61` | `0x0a36..0x0a67` | working-profile image, scattered at `0x6406f` |
| `0xffa` | | 32-bit version |
| `0xffe` | | CRC-16/CCITT over `0x000..0xffd` |

The packed config is expanded through the `(shift, mask)` table at `0x63f8d`
into the 36 profile bytes `0x0932..0x0955`; the profile image is scattered to
`0x08de` plus the 50 offsets listed at `0x63fd6`. The serial number is read as
nine characters at `0x0a17` plus three at `0x0a20` (`0x835bb`), and `0x77bb9`
treats four `0xffff` words as no serial fitted.

Dumping the real part is not practical, so `parameters` synthesises a sector the
firmware accepts. It carries the firmware's own power-on defaults for the packed
config and profile image, so only the fields you set change:

```sh
python3 -m courier_emu parameters params.bin --serial 12345678 \
  --feature hst --feature fax --feature terbo --feature v34 --feature v90
python3 -m courier_emu run main211.xmf --instructions 8000000 \
  --parameter-sector params.bin --at ATY14
```

That reproduces the configuration dump reported for a fully featured unit, and
`ATI7` renders the full profile including the serial number:

```text
000,000,030,007,031,000

Product type           US/Canada Internal
Product ID             XX345302
Options                HST,V32bis,Terbo,VFC,V34+,V90,V92
Clock Freq             25 Mhz
Serial Number          12345678
```

Feature bit 4 (value 16) is labelled x2 in archived notes for older Courier
firmware, but on this 2002 build it gates V.90: `0x77d47` uses it to append
`,V90` to the options list, and `0x82e7d` uses it to select the `5608` product
code instead of `3368`. The options table does hold an `x2` string at
`733c:49d6`, but nothing in the image ever loads it, so **this firmware cannot
report x2 at all**.

The board identification straps select the enclosure `ATI7` reports, which is a
useful cross-check against a physical unit:

| `--board-id` | capability | `ATI7` product type |
|---:|---|---|
| 2, 9, 12 | `0x29`, `0x28` | Internal |
| 5 | `0x14` | Rackmount |
| 7, 13 | `0x22` | External |

Note the tension with the default: codes 2/9/12 carry capability bit `0x08`, the
settings-EEPROM bit, but report Internal, while the External codes do not carry
it. Capability `0x22` is also the one value `0x667cb` special-cases as always
returning `OK`. An external unit is therefore likely `--board-id 7`, which also
changes the product code to the `A` suffixed form (`5608A`/`3368A`). Running
`ATI` on real hardware settles it.

## Two instances on one line

`link` runs two instances sharing a two-wire line over a UNIX socket. Each side
hands the far end one 100 ms frame of hook state and line audio and blocks for
the far end's frame, so two independently executing runs stay on the same
emulated clock without either knowing how fast the other goes. Both sides get
the `dedicated-line` option switches and answer:

```sh
python3 -m courier_emu link main211.xmf --instructions 40000000 --summary
```

`--a-at` and `--b-at` change what each side is told to do, and `run` takes
`--line-link PATH` plus `--line-listen` directly if you would rather drive the
two processes yourself. The link implies `--with-dsp` and supersedes
`--daa-line`: the far end's hook state is the line state.

The call comes up at the line layer. Each side reports the other off hook, both
qualify the line detector, and each exchanges the same frame count:

```text
a NO CARRIER  frames=354 peer_off_hook=True
b NO CARRIER  frames=354 peer_off_hook=True
```

It gets no further, and the reason is the one the SIP section describes rather
than anything about the link. Over the same run each C52 wrote 271,869 line
samples and **every one of them was zero**, while its command poll at external
port `0x50` read `0xffff` 271,869 times. The supervisor sent 38 runtime control
messages and the datapump never received a command, so neither side ever
transmits a carrier for the other to hear. Recovering the supervisor-to-C52
runtime latch protocol is what stands between this and two Couriers training
against each other.

The line carries no call setup, which is what a dedicated line is: both ends are
connected and each simply sees the other seize. Ring cadence is modelled
separately (`--ring`) and does not yet reach an answer, so an originate/answer
call over the link is not available.

## Minimal SIP dial-out

`--sip-server` attaches the DAA to a small UDP SIP user agent and enables both
the DAA and DSP automatically. Parsed `ATD` digits become the destination URI;
the client supports an unauthenticated INVITE or one MD5 Digest retry after
`401`/`407`, SDP with PCMU payload 0, ACK/BYE, and bidirectional RTP. The modem's
9.6 kHz line stream is converted to/from 8 kHz PCMU. The current DTMF assist is
inserted at the recovered C52 DAC write, so it travels as ordinary in-band
audio; it is not yet evidence that the firmware datapump entered originate
mode.

Keep the password out of command history by putting it in the environment:

```sh
export COURIER_SIP_PASSWORD='your-password'
python3 -m courier_emu run main211.xmf --instructions 12000000 \
  --sip-server pbx.example.net:5060 --sip-username 6001 \
  --sip-target 'sip:{number}@pbx.example.net' --at ATD123 --summary
```

`dsp_bridge.sip` reports the target, response status, dialog state, RTP
endpoints/counters, and a bounded event trace; it never includes the password.
This deliberately minimal client is UDP/IPv4 and PCMU-only. It does not yet
REGISTER, use SIP/TLS, negotiate other codecs, send RFC 2833 events, or turn
SIP failure responses into Courier `BUSY`/`NO ANSWER` result codes.

A live 6000-to-7800 validation completed Digest authentication, received
`200 OK`, and carried 1,152 inbound and 507 outbound RTP packets, while the
Courier still returned `NO CARRIER`. The supervisor emitted 30 two-word
runtime control messages on ports `0x58..0x5e`, but the C52 command poll at
external port `0x50` continued to read `0xffff`. The remaining blocker is the
runtime supervisor-to-C52 host latch/acknowledgement protocol, not SIP duration
or RTP transport.

The result includes CPU registers, the first 128 I/O/MMIO operations, complete
per-address event counts, the hottest code addresses, and the final execution
path. It also records `supervisor-entry`, `dsp-transfer`, `startup-crc`, and
`main-loop` milestones; a run that reaches the normal dispatcher reports
`status: main-loop`. Unknown input ports return all ones. Input responses and output latches
are separate, matching hardware such as DSP command/status port `0x1e`;
`--port` sets only the input response. This intentionally makes unmodeled
hardware visible instead of silently pretending it exists.

On macOS, a native Unicorn library can be selected with
`--libunicorn /path/to/library/directory`. The worker boundary converts native
signals into a clean CLI failure rather than crashing the controlling process.

## Current boundary

The 80186 and C52 are lock-stepped at their recovered 20/25 MHz ratio. The
supervisor's DSP bootstrap is reconstructed from ports `0x40..0x4e`, verified
byte-for-byte against the XMF C52 boot segment, and published to the native DSP
through the recovered mailbox. The DTE serial path can inject commands and
capture firmware-generated result text. The ASIC line frame now transports
9.6 kHz input/output samples and captures dial tones. Remaining device work is
the original datapump command mailbox, remaining DAA ring/loop/call-progress
events, complete 80186 peripheral timing, and unexercised C52 opcode forms. The
board latches, front-panel signal lines, and the Microwire settings EEPROM are
modeled. What remains on the settings side is a recovered parameter-flash sector
for `0xf8000` and front-panel legends for the unnamed indicator bits; there is no
boot-time NVRAM profile load in this firmware to model.
