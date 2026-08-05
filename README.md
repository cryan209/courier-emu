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

Everything runs through the `./courier` launcher. There is nothing to install
and no environment to activate: on first use it creates `.venv` beside the
repository, installs the project into it, and from then on just starts the CLI.

```sh
./courier info main211.xmf
./courier extract main211.xmf extracted/main211
make test
```

It uses `uv` when that is on `PATH` and falls back to `venv` plus `pip`
otherwise. `PYTHON=<interpreter>` chooses the interpreter it builds the
environment from (3.10 or later), `COURIER_EMU_VENV=<path>` moves the
environment, and `make clean-venv` discards it. `./courier` may be run from any
directory. If you would rather manage the environment yourself, install the
project with `pip install -e '.[execute,disasm,dev]'` and use
`python3 -m courier_emu` in place of `./courier` everywhere below.

Execution uses Unicorn's 16-bit x86 core and runs in an isolated child process:

```sh
./courier run main211.xmf --instructions 250000
./courier run main211.xmf --instructions 1000000 --summary
./courier run main211.xmf --instructions 7000000 --with-dsp --at AT --summary
```

The C52 runner has no third-party runtime dependency; it builds with the system
C++17 compiler on first use:

```sh
./courier dsp-run main211.xmf
./courier dsp-run main211.xmf --trace 40
./courier dsp-run main211.xmf --port 0x50=0x1234
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

A command line is offered to the firmware only from its command-line-ready
state. The state machine publishes that as the callback pointer at `0x02ac`:
`a8d9` collects a line a character at a time, the terminator advances it to
`a910`, which parses the line and prints the result, and the end-of-command
path at `a8b1` clears the collector and returns to `a8d9`. Bytes delivered
into the `a910` window are assembled into a buffer nothing goes on to parse -
the firmware's own type-ahead flag at `0x1cf2` is what would carry a line
across, and it is set by the DTE front-end this harness stands in for. So the
harness waits for `a8d9` and re-arms the collect flag at `0x1cee` bit `0x40`
for each line, exactly as it does once at the main-loop milestone. That is
what makes a second and third command answer.

## The parameter flash, and storing a profile

`AT&W` writes the working profile to the parameter store. That store is four
4 KiB sectors at physical `0xf8000`, each ending in a 32-bit version at
`0xffa` and a CRC-16/CCITT at `0xffe`; the search at `0x7e07c` checksums all
four and keeps the highest version that verifies. `parameters.py` documents
the layout, and the `parameters` subcommand builds a sector.

The writer at `0x7dfa8` does not touch the part directly. It calls the boot
block through `int 0x0a` with an ASCII service letter in `BL`:

| service | meaning |
|---|---|
| `E` (0x45) | erase the 4 KiB sector selected by `ES` |
| `W` (0x57) | program the word in `AX` at `ES:DI`, then advance `DI` |
| `S` (0x53) | firmware-update path, not modelled |
| `L` (0x4c) | block lock/select, not modelled |

An XMF update image carries the application only, so in a run built from one
that vector points at nothing and `AT&W` stops on the first call. `E` and `W`
are answered by the harness when a part is attached, which is what `AT&W`
needs and no more; `S` and `L` still stop the run rather than continue on a
guess.

```sh
./courier run main211.xmf --parameter-flash board.flash --at ATS0=7 --at 'AT&W'
./courier run main211.xmf --parameter-flash board.flash --at 'ATS0?'
```

The second run answers `007`. The file is created erased (`0xff`, which is
what the blank check at `0x7e0e3` scans for), a 4 KiB file is accepted as the
first sector, and the run reports a `flash` block with the erase and program
counts and each sector's version and checksum validity. Storing repeatedly
walks the sectors in turn and erases one to wrap, all driven by the
firmware's own writer. `refused_bits` counts bits a program would have had to
set rather than clear: it stays zero while the model and the firmware agree
about what an erase leaves behind.

With a stored profile attached, `ATI5` renders it rather than the empty-store
page.

## The time base, and what waits on it

The supervisor arms countdowns and waits on them - `ATI11` gives itself 20
ticks at `0x62d68` before printing an empty diagnostics page. Nothing drives
them: the chain that decrements them is entered on vector `0x0f`, which this
firmware keeps masked for the whole run, so `ATI10` and `ATI11` stop partway
and every other firmware timeout waits forever.

`--tick-ms MS` exists to experiment with that edge, but it honours the mask, so
today it delivers nothing and the `ticks` count stays zero. That is deliberate:
an edge the firmware has switched off is one the board cannot take.

`--tick-source dsp` is the other candidate, and it is the one worth running.
It paces the chain off the DSP frame interrupt instead of off a period, which
is the only arrangement that leaves both of the firmware's mutual watchdogs
quiet - they bound the legal ratio to between 1/25 and 3 ticks per frame, and
1:1 sits inside it. It is still off by default, because 1:1 within that band is
a choice rather than a measurement. With it the diagnostics pages finish, the
line-detector poller runs, and the harness stops forging the two counters that
poller feeds; see "Two instances on one line" for what a linked pair does then.
`courier_firmware_analysis.md` has the evidence.

## Talking to it while it runs

`--at` queues commands before boot. `--console` instead attaches this terminal
to the DTE port for as long as the run lasts: type commands, watch the modem
answer, `Ctrl-]` to detach. `--instructions` then defaults to effectively
unbounded, so the session ends when you do.

```sh
./courier run main211.xmf --console
./courier run main211.xmf --console --daa-line dial-tone --nvram board.eeprom
```

Everything the modem sends goes to stdout and the run's own report goes to
stderr, so `--console > session.txt` captures exactly what the firmware said.
Input may also be piped, which is the same live path without a terminal:

```sh
printf 'ATI3\rATI4\r' | ./courier run main211.xmf --console --instructions 9000000
```

`--serial-pty` exposes the same port as a pty device instead of attaching this
terminal, for anything that drives a serial modem:

```sh
./courier run main211.xmf --serial-pty
# serial console on /dev/ttys002
screen /dev/ttys002
```

Both report a `console` block counting the bytes each way, what a terminal
that stopped reading dropped, and whether the far end closed. Typed bytes are
polled every 8,192 instructions - about a hundred times a second at the speed
this core runs, which is roughly the real board's.

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
./courier run main211.xmf --instructions 9000000 --with-dsp \
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
./courier run main211.xmf --instructions 9000000 \
  --daa-line dial-tone --at ATDT123 --summary
```

The original firmware then returns `OK` instead of `NO DIAL TONE`, and
`dsp_bridge.daa` reports hook, line, detector, and generated-sample state. This
is a firmware-derived behavioral DAA, not a claimed identification of the
physical line-interface IC. Busy/reorder tone and carrier negotiation remain
unmodeled.

### The silicon DAA as a register file

The line-interface chipset itself is modeled as registers rather than behavior,
and it is **on by default** — the board has a DAA, and `ATI7` reports a failure
without one (below). `--no-daa-codec` turns it off; it also drops out on its own
for a flash ROM, which carries no separable C52 payload for the DSP bridge the
codec rides on. Modelling it costs about 20% of a run's wall time, since it
brings the native C52 bridge up on runs that would not otherwise need it.

The board carries an Si3021 and an Si3014; `docs/SI3038.PDF` is the AC'97
sibling of that pair and is the only published register map here, so the model
uses its addresses for the shared line-side fields.

```sh
./courier run main211.xmf --instructions 20000000 \
  --daa-line dial-tone --at ATA --summary
```

`dsp_bridge.codec` then reports the whole register file, the readiness byte,
and the assembled line status:

```
"steps": ["register-reset", "sample-rate", "power-up", "ready",
          "gpio", "levels", "line-interface"],
"polls": 3,
"readiness": "0x0f", "link_up": true,
"loop_current_ma": 25, "loop_current_sense": 4,
"line_status": "0x0050"          FDT set, LCS[3:0] = 4
```

The seven steps are the datasheet's initialization procedure, including its
readiness poll, and nothing in the Courier's firmware performs them: the 80186
writes ports `0x40`..`0x4e` thousands of times and never reads them, and the
C52's only external reads are the host mailbox window and the line ADC, so
neither processor can see the readiness byte step 4 waits on. The sequence
belongs to the interposed ASIC — the arrangement AN16 section 1.3 describes —
and `CodecBringUp` stands in for it, one service frame per 100 ms.

There is no register-level read path from the firmware, so the model is driven
rather than polled: hook and line state come from the behavioral DAA, ring
bursts from the ring source, and loop-current sense, ring detect, frame lock,
and the country settings come out of the registers. `--daa-codec-line` selects
which line the part is strapped as (deciding whether readiness reads `0x0f` or
`0x33`), and `--daa-codec-rate` programs register `40h`, rounding to the
nearest rate the PLL offers.

One thing the firmware does read is the DAA's identity, and `ATI7` prints it:

```sh
./courier run main211.xmf --instructions 14000000 --at ATI7
```

```
Product ID             00345302        with --no-daa-codec: XX345302
DAA rev                0004            with --no-daa-codec: 0000
```

The supervisor's receive table stores mailbox tag `0x7b`'s data word at
`[0x287]`. `ATI7` prints that word as `DAA rev`, the self-test at `0x77eda`
appends `" : DAA Failure (zero is Invalid)"` when it is zero, and `0x8369d`
branches on it being 4 to print product ID `00345302` rather than the
placeholder `XX345302`. Nothing was producing that message, so the firmware
reported a DAA it considered invalid, which is why the codec is on by default
rather than opt-in. The report goes out on the first DSP download, since a real
part identifies itself at power up rather than at
the dial/answer boundary; `--daa-codec-revision` changes the value, and 0 will
reproduce the failure path. The 4 is read out of the firmware's own product-ID
branch, not measured off a part.

## Complete flash ROM images

`rom-info` describes a whole flash part rather than an update payload:

```sh
./courier rom-info IDSDL302.ROM
```

An XMF carries only the application, so where it lives is a modelling choice. A
ROM ends with the 80186 reset vector, and the stub there programs the chip
select that decodes the ROM before it jumps, so the image places itself. For the
1998 Courier V.Everything external ROM that gives flash at `0x80000..0xffc00`,
128 KiB of RAM at `0x00000..0x20000`, and the peripheral control block relocated
into memory at `0x0ff00` — which is the window this harness already hooks.

It also carries the ~6 KiB boot block above the application that an update image
never replaces: the hardware setup tables, the copy of itself to physical zero,
the power-on read of the settings EEPROM, the whole-flash CRC, and a second copy
of the SDL loader.

`run` takes a ROM as well, booting it from its reset vector:

```sh
./courier run IDSDL302.ROM --instructions 40000000 --int1-after 7
```

The peripheral timers are modelled from the instruction clock - the enable
gate, the zero-compare-is-full-range rule, single-shot versus continuous, the
sticky max-count bit, and the mask side of the interrupt controller - which is
what carries the ROM past its timer self-test at `0x80444`. It then reaches a
tick wait whose period this firmware calibrates from an external INT1 edge
rather than from a timer alone; `--int1-after` supplies one.
`courier_firmware_analysis.md` has the full account, including where that
sequence still stops, the cross-build confirmation of the latch driver, and
every option switch.

## ISDN Courier XMP images

`Ie030002.xmp` is an ISDN Courier update payload, and it is a different animal
from an XMF: no product text header, and an obfuscated body.

```sh
./courier xmp-info Ie030002.xmp
./courier extract Ie030002.xmp extracted/Ie030002
```

| File range | Contents |
|---|---|
| `0x00000..0x0007f` | 128-byte header: `USR XMP\0` magic, three small fields, and a 0x70-byte table |
| `0x00080..0xb807f` | 0xb8000-byte payload, every byte XOR `0x45` |

The key falls out of the image without any code analysis. Erased flash still
dominates the payload, and the pad byte reads `0xba`; `0xff ^ 0xba` is `0x45`.
Decoding with it turns `0xff` back into the most common byte, and the result
carries the VRTX kernel banner (`Copyright 1988, Ready Systems`) and the ISDN
rate-adaptation strings (`SET_V110_ENTRY`, `V110_ATO`).

The payload decodes to three programmed spans, the last being a two-byte word at
the very top of flash:

| Payload range | Size |
|---|---|
| `0x00000..0x5d320` | 381,728 |
| `0x64000..0xaab0c` | 289,548 |
| `0xb7ffe..0xb8000` | 2 |

It is an 80386 image, and it says so at payload offset `0x38`, where it clears
`dr0..dr3` and `dr7` — registers the 80186 supervisor does not have. The code
around it programs a linear address into `dr0`, sets the local and global enable
bits in `dr7`, and installs its own INT1 (`#DB`) handler at `4000:0148`, so the
firmware drives hardware breakpoints as a normal runtime mechanism. Note that
this is vector 1, distinct from the 80186's `INT1_VECTOR = 13` pin interrupt in
`timers.py`.

Nothing here executes yet. What is loaded is the container and the decoded body;
what is not modelled is the board. Two things stand out from the decode:

- Debug registers. Unicorn does not deliver `#DB` from guest-programmed `dr0..3`,
  so the harness would have to match breakpoints itself.
- The 0x70-byte header table at offset `0x10` is plaintext, not obfuscated, and
  plainly structured — a handful of 16-bit values recur through it — but its
  layout is not recovered, so `xmp-info` reports it verbatim as
  `header_table_undecoded` rather than inventing fields for it.

The load base is a modelling choice, as it is for an XMF. `FLASH_PHYSICAL_BASE`
is set to `0x40000` because the boot code installs its INT1 handler in segment
`0x4000`; the header's `load_hint` field reads `0x40`, which is consistent with
that base in 4 KiB units, but nothing in the image confirms the unit.

No protected-mode entry appears in the decoded payload — no `lgdt`, `lidt`,
`lmsw`, or `mov cr` anywhere in it. This is 386 code running in real mode, using
32-bit registers, `0x66`/`0x67` prefixes, and the debug registers.

## ISDN Courier NAC images

`Ie030002.nac` is the same firmware in a different container, and it is not
obfuscated at all. It is **Intel HEX with the ASCII stripped out**: each record
is a length byte, a big-endian 16-bit address, a type byte, and that many data
bytes. The big-endian address is the giveaway — everything else in these images
is little-endian, but Intel HEX writes its address big-endian even on x86.

```sh
./courier nac-info Ie030002.nac
./courier extract Ie030002.nac extracted/Ie030002
```

| File range | Contents |
|---|---|
| `0x00000..0x0001f` | 32-byte header |
| `0x00020..0xcd1a6` | Binary Intel HEX record stream |
| `0xcd1a7..0xcd1a8` | Two trailing bytes, `e4 a0` |

Header fields:

| Offset | Contents |
|---|---|
| `0x03` | `u32` record-stream length — exactly file size minus header minus trailer |
| `0x08` | Version triple `03 00 02`, matching the `Ie030002` file name: 3.0.2 |
| `0x0f` | Product tag `IE(`, the same tag the `.sdl` loader carries |

The record types are the Intel HEX ones:

| Type | Count | Meaning |
|---|---:|---|
| `0x00` | 42,023 | Data |
| `0x02` | 197 | Extended segment address, big-endian, scaled by 16 |
| `0x03` | 1 | Start segment address, `0ce0:0000` |
| `0x01` | 1 | End of file |

Unlike ASCII Intel HEX there is no per-record checksum byte; parsing without one
consumes the stream exactly, from the end of the header to the EOF record.

The stream's very first record is a type `0x02` setting segment `0x4000`, so the
image places itself at physical `0x40000` — the harness does not have to assume a
base for a NAC the way it does for an XMF. That independently confirms the base
the XMP section above had to infer from the boot code's INT1 handler.

The two containers agree exactly. Flattening the NAC's 42,023 data records
produces a `0xb8000` image at `0x40000` that is byte-for-byte identical to the
XOR-decoded XMP payload, and the 82,879 bytes the NAC never paints are precisely
the bytes that read as erased flash in the XMP. Two independently encoded
containers reaching the same image is the strongest check available on both
decodes, and `tests/test_nac.py` asserts it.

What is not recovered: the two trailing bytes `e4 a0`. They are not a byte sum of
the record stream and match none of the common CRC-16s (CCITT-FALSE, XMODEM, ARC,
MODBUS, KERMIT, GENIBUS) over either the stream or the whole file, so `nac-info`
reports them verbatim as `trailer_undecoded`.

The start segment address `0ce0:0000` is physical `0xce00`, which is RAM well
below the flash — the entry after the boot block relocates itself, consistent
with the code at payload `0x300` loading `0x0ce0` into a segment register.

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
./courier run main211.xmf --instructions 4000000 --at AT --dip none
```

### Dedicated-line operation

A modem on a dedicated line has no DTE holding DTR up and no call setup to
follow, so it needs DTR ignored and carrier detect held on. `--dip-preset
dedicated-line` closes `result-codes`, `dtr-override`, and
`carrier-detect-override`, and leaves `no-auto-answer` open so S0 keeps its
flash default of 1 and the modem answers on the first ring:

```sh
./courier run main211.xmf --instructions 12000000 \
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
./courier run main211.xmf --instructions 40000000 \
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
./courier run main211.xmf --instructions 40000000 \
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
./courier run main211.xmf --instructions 7000000 \
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
./courier parameters params.bin --serial 12345678 \
  --feature hst --feature fax --feature terbo --feature v34 --feature v90
./courier run main211.xmf --instructions 8000000 \
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

The sector's first byte gates each unpacked field, applying it when the bit is
clear, and `--flags` sets it. Bit 3 decides whether type1 reaches `[0x0a03]`,
and `0x8339f` tests bit `0x04` of that byte before the `ATY15` case is even
reachable — so the default `0x08` is why that command answers `ERROR`. A sector
with bit 3 clear and type1 carrying `0x04` makes it print the factory switch
page instead, which reports all ten option switches as the firmware reads them:

```sh
./courier parameters params.bin --serial 12345678 --flags 0
./courier run main211.xmf --instructions 9000000 \
  --parameter-sector params.bin --at ATY15
```

```text
CURRENT DIPSWITCH SETTINGS
DIPSWITCH #1   ON
DIPSWITCH #2   OFF
DIPSWITCH #3   ON
...
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
./courier link main211.xmf --instructions 40000000 --summary
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
samples and **every one of them was zero**, so neither side ever transmits a
carrier for the other to hear. What has changed is where the search for the
missing command goes next: the read at C52 program `0x8c1f` that earlier notes
called the datapump's command poll is not one — see "The window word 0x50 is
not the datapump's command port" below.

### Pacing the supervisor's countdown chain

`--tick-source dsp` takes both sides further, and is available on `run` too. It
drives the supervisor's countdown chain from the DSP frame interrupt, one tick
per frame, which is the only arrangement tried here that leaves both of the
firmware's mutual watchdogs quiet. It is off by default: the 1:1 ratio is a
choice inside the band those watchdogs allow rather than a measurement, and the
edge it delivers is one the interrupt controller has masked.

```sh
./courier link main211.xmf --instructions 40000000 --tick-source dsp --summary
```

With the chain running, the line-detector poller the chain carries runs too.
The bridge answers its `0x7c00` request with a reading in the low band, so the
firmware counts its own five hits at `[0x649]`; whenever the chain is paced the
harness stops writing that byte, and stops zeroing the `[0x289]` wait it is
counted inside. `dsp_bridge.detector_replies` reports how many requests were
answered.

Both sides then leave command mode:

```text
a OK  ticks=9141 detector_replies=44 frames=357 peer_off_hook=True
b OK  ticks=9141 detector_replies=44 frames=357 peer_off_hook=True
```

and swap the DTE callback table `acdf,1fce,a8d9` for `50ad,18e3,4cac`, which is
a different front end from the command-line collector. `OK` is not a call
result code, though, and there is still no carrier on the line behind it: this
is the supervisor acting on state the harness supplied, not two modems that
trained. The same option finishes `ATI11`, which previously stopped after
"Modulation", and takes `ATI10` to its "Strike a key when ready" pager.

The line carries no call setup, which is what a dedicated line is: both ends are
connected and each simply sees the other seize. Ring cadence is modelled
separately (`--ring`) and does not yet reach an answer, so an originate/answer
call over the link is not available.

### The window word `0x50` is not the datapump's command port

The C52 has no external `IN` for `0x50` at all. Data addresses `0x50..0x5f` are
reserved on a C5x, this core decodes them as external I/O, and the site at
program `0x8c1f` is a `BIT @50, 6` inside the per-sample service routine. Its
`TC` result is discarded by the `CLRC TC` at `0x8c3d` with no consumer in
between, so the word is read and thrown away. Three checks say the same thing
from the other side:

- Presenting each of the twelve header values the supervisor actually sends at
  window words `0x50`/`0x51` leaves a 3.4 M-instruction C52 run byte-identical
  in every counter, including where it stops.
- The C52's `IMR` is zero after boot, so no host interrupt can reach it either.
- Applying all 2,274 of a run's runtime messages as `host_write(header, data)`
  into C52 data space changes nothing.

So there is no host-to-datapump command path in the resident program, and
"recover the `0x58..0x5e` to C52 `0x50/0x51` valid/ack timing", which earlier
notes named as the next step, is not it. The supervisor's runtime traffic is a
real channel — 2,274 two-word messages with a valid/ack handshake on port
`0x1c`, and the `0x40..0x4e` window used only for the two program downloads —
but whatever consumes it on the board is not the C52 code these images run.

### What the datapump is doing instead

Taking instruction boundaries from a run rather than decoding statically, the
whole of what the C52 executes in steady state is 167 instructions, one pass is
169, and the loop head is at `0x0cb1` — inside the bank the supervisor
downloads. The datapump is resident and idle, not un-entered, and it uses about
6% of the cycles a 25 MHz part has per 9.6 kHz sample.

Every pass ends with `BIT *, 4` on `[0x00cc]` and a `CC 0xb4d4` on the result,
and `[0x00cc]` is zero on every sample of every run. `[0x00cc]` is the
datapump's own status word — the low half of a 32-bit value carried from sample
to sample through `[0x7e]:[0x7d]` and ACCB, holding `0x0555_0000` throughout —
and `0xb4d4` turns out not to be code at all but a numeric table, so that
conditional is not the way in.

Interrupts are enabled — the reset code sets `IMR = 0x002a` and clears `INTM` —
and of the sixteen, only number 7 changes anything when raised. That is not the
datapump waking up: `PMST.IPTR` is zero, so the vector is program `0x0010`,
which is inside the reset code, and driving the interrupt partially reboots the
C52. Almost 6,000 of the instructions it adds are below `0x00d0`.

There is no vector table in this image to point it anywhere better. `IPTR` can
only place one on 32 two-kiloword boundaries; the longest run of consecutive
two-word branches at any of them is a single slot, and nothing table-shaped
exists anywhere else in the image either. The area is never rewritten: across
600,000 instructions of startup the only program-memory instruction executed is
one `BLPD`, which reads rather than writes.

Nor in any other image here. All fifteen — six XMFs, four XMDs, the ISDN ROM,
`.nac`, `.sdl` and `.xmp` — scanned in both byte orders come up empty once the
handler word is required to vary; the long runs are filler or sequential `CALL`
code. Every XMF's DSP payload instead begins at file `0x2f0` with reset code,
identical across `main211`, `main2205` and `3453Bv2.1.1`, and a different
variant in the four 2.3.x builds whose first act is an external write to I/O
port `0x8057` and which programs different wait states (`PDWSR` `0x2000`
against `0x000a`). So the vector area holding reset code is a property of every
build in the tree, not a quirk of one image, and those wait-state values are
the one direct statement about the memory map available here.

The reading that fits is that the C52 is in microcomputer mode, its program
`0x0000..0x0fff` is on-chip ROM holding both the vector table and the bootstrap
that receives the download, and neither is in this image — so the assumption
that the downloaded segment begins at program `0x0000` puts the downloaded init
on top of the vectors.

### The C52 memory map, and what the wait states say

The core used to parse `MP/MC`, `OVLY` and `RAM` out of `PMST` and act on none
of them. It now decodes both spaces as the C52 actually lays them out: program
is on-chip ROM below `0x1000` when `MP/MC` is low, DARAM B0 at `0xfe00` under
`CNF`, external otherwise; data is registers below `0x0060`, DARAM at B2
`0x0060`, B0 `0x0100` (unless `CNF` moves it) and B1 `0x0300`, external from
`0x0800` up, and **reserved** in the gaps at `0x0080..0x00ff` and
`0x0500..0x07ff`. The C52 has no SARAM at all, so `PMST.RAM` and `PMST.OVLY`
are don't-cares on this part.

The wait-state registers are decoded too, and they answer the `MP/MC` question
the images could not. Both firmware families write `CWSR 0x0010`, which puts
every space on the plain 0/1/2/3 scale, and then:

```text
2.1/2.2  PDWSR 0x000a   program 0x0000..0x7fff  2 wait states
         IOWSR 0x0001   io      0x0000..0x1fff  1
2.3.x    PDWSR 0x2000   data    0x8000..0xbfff  2 wait states
         IOWSR 0x0101   io      0x0000..0x1fff  1, io 0x8000..0x9fff  1
```

Wait states only apply off-chip, so a non-zero field is the firmware saying it
expects external memory there. The 2.1/2.2 boards put program `0x0000..0x7fff`
off-chip — exactly the span of the 30,172-word segment the supervisor downloads
— which means `MP/MC` is high and there is no boot ROM under the download. The
pin now defaults to high for that reason rather than by convention. The 2.3.x
boards need no program wait states at all and put their slow external memory in
data space instead.

Every run reports `dsp_bridge.dsp_memory_map` with the mode bits, the
wait-state decode and per-region access counts. One of those counts is worth
reading on its own: **about 700,000 data accesses a run land in the C52's
reserved windows**, and they are the frame-block cells `[0x00ca]`–`[0x00cd]`,
including the line-DAC source and the gate above. On silicon those addresses
hold no storage. `courier_firmware_analysis.md` has the rest.

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
./courier run main211.xmf --instructions 12000000 \
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
runtime control messages on ports `0x58..0x5e` and none of them reached a
datapump. The blocker is below SIP rather than in its duration or RTP
transport, and it is not the host-latch timing earlier notes named: see "The
window word `0x50` is not the datapump's command port".

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
the original datapump command mailbox, complete 80186 peripheral timing, and
unexercised C52 opcode forms. The silicon DAA's ring, loop-current, and frame
lock state is modeled at register level under `--daa-codec`; its revision
reaches the firmware through mailbox tag `0x7b` and `ATI7`, but no read path to
the line-side status fields has been found, so those are still unconsumed. The
board latches, front-panel signal lines, and the Microwire settings EEPROM are
modeled. What remains on the settings side is a recovered parameter-flash sector
for `0xf8000` and front-panel legends for the unnamed indicator bits; there is no
boot-time NVRAM profile load in this firmware to model.
