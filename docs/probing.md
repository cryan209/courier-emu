# Probing the board

Everything here is the 20.16 MHz Courier - `/dev/cu.usbserial-21210`, serial
`0009540034268322`, or `/dev/cu.usbserial-11420` for later sessions - running
**ID_SDL 4.03d**, supervisor 7.4.16 / DSP 3.1.2. Some captures predate the flash
and are stock 7.3.14 / DSP 3.0.13; each says which.

> **The write and monitor commands are ID_SDL's, not the Courier's.** Stock
> 7.3.14 has `=` `I` `O` and no `W` at all. Any procedure here works on this unit
> only while it runs ID_SDL.
>
> | image | `ATGLK2` selectors |
> |---|---|
> | board, ID_SDL 4.03d | `=` `R` `W` |
> | `IDSDL302.ROM` | `=` `R` `W` |
> | board, stock 7.3.14 | `=` `I` `O` |

## Hazards, first

* **Never write port `0x10`.** It carries the NVRAM strobe (bit 3), data (5) and
  clock (6), bit-banged by direct `out 0x10` writes at `0x1490`..`0x15a5` that
  bypass the latch helper API. An arbitrary byte can clock the serial EEPROM and
  change stored settings, which a power cycle does **not** undo. Ports `0x12` and
  `0x14` are the other board latches; leave them alone too.
* **Never issue a flash command sequence.** Same reason.
* **`ATGLK2B` is disruptive.** It sweeps 256 *consecutive* I/O ports
  unconditionally with no way to narrow the range, and the supervisor's own
  receive path consumes mailbox replies by reading `58..5e`. Treat it as fatal to
  a live call and to any in-flight mailbox transaction.
* **Never send tag `41` with a value above five.** Its clamp admits `0..12`
  against a six-entry jump table, so `6..12` fetch the following instruction
  words as routine addresses. Entry six is `7a80`.
* **Never send tags `4c`, `5b`-`5d`, `64`-`6b`.** Unimplemented: their table entry
  is zero, so `bacc` takes the DSP to program word `0000`.
* **Arming a tone off-hook puts real signal on a real loop**, and the window ends
  only when tag `16` is sent.
* Everything written to **RAM** is volatile - a power cycle restores the modem
  completely - so a wrongly chosen scratch region costs a crashed session, not
  the modem.

## The monitor

`ATGLK2` is the handler at flash `25ba9`. The prefix check is
`cmp word ptr [si],'LK'` then `cmp byte ptr [si+2],'2'`; after `add si,3` /
`sub cx,3`, `jcxz` leaves `BL` holding the outer `G`, so a bare `ATGLK2` matches
no selector.

| suffix | target | operation |
|---|---|---|
| `=` | `26e20` | Memory byte dump, 16 rows of 16 bytes |
| `R` | `26e8b` | Memory word dump, 16 rows of eight little-endian words |
| `W` | `49890` | **Write** memory: `W<address>,<value>` |
| `I` | inline `25c45` | Read one I/O port, print one hex byte |
| `O` | inline `25c65` | Write one I/O port: `O<port>,<byte>` |
| `B` | `26eec` | I/O port block dump, 16 rows of 16 ports |
| `N` | inline `25c3d` | `or byte ptr [25e],1`; sets a flag, prints nothing |
| `U` | inline `25c8d` | `clc; ret`; accepted and ignored |

Addresses are hex CPU `segment:offset`; with one number the reader uses segment
zero. Each `=`/`R` request is fixed at 256 bytes and the offset increments as a
16-bit register, so a request crossing `ffff` wraps within the same segment.

`I`, `O` and `B` reach CPU **I/O space**, which is the only way to touch
`0x40..0x5e` and `0x1c` - the ASIC bootstrap window and mailbox latches - since
`=` and `R` cannot address I/O at all.

**Every complete response ends with `ERROR`, and the data before it is good.**
`LODSB` at `26e2b` consumes the colon without decrementing `CX`, unlike the hex
parser. An isolated run of the captured handler prints the exact expected 256
bytes for `LK2=8000:0000`, returns carry clear, and leaves `CX=1` at the
carriage return.

> The **modified reference** dispatches differently: on `IDSDL302.ROM`, `25ba9`
> skips `LK2` and dispatches through `c800:0024` to an extension at `49022`. The
> physical handler *requires* `LK2` and calls the readers directly. The readers
> themselves match.

### The write primitive

```text
49890  inc si ; dec cx
49892  call 0x4979c        ; parse hex -> AX, the address
49896  mov bx, ax
49898  lodsb ; dec cx
4989a  cmp al, 0x2c        ; a comma must follow
4989c  jne 0x498b6         ; ...or the command fails
498a0  call 0x4979c        ; parse hex -> AX, the value
498a4  sub dx, cx          ; how many digits that consumed
498a6  cmp dx, 2
498aa  ja  0x498b0
498ac  mov byte ptr [bx], al   ; 1-2 digits: byte write
498b0  mov word ptr [bx], ax   ; 3+ digits: word write
```

Confirmed on the live unit against `0x5d80`-`0x5d83`, verified zero first:

* **`DS` is zero**, so the address is a physical low-RAM address and the
  `mov [bx]` needs no segment reasoning. (`=` takes `segment:offset` and loads
  `ES`; `W` does not.)
* **Width follows the digit count, not the value.** `,A5` writes one byte,
  `,1234` writes a word little-endian, `,000F` writes a word.
* **It is reversible.** Writing zeros back restored the region exactly.

### The eight-hex-digit DSP command form

```text
ATGccccdddd
   │   └── 16-bit data/argument, four hex digits
   └────── 16-bit DSP command/tag, four hex digits
```

Eight uppercase hex digits including leading zeroes, no comma. Four-digit and
shorter forms select different handlers. Command numbers select firmware
operations; they are **not** DSP program addresses.

Measured on the board, all returning serial `OK`:

| sent | reply tag:data | |
|---|---|---|
| `ATG00620000` | `0069:0015` | sample-processing query |
| `ATG00070000` | `0031:0000` | status-word query |
| `ATG002D0000` | still `0031:0000` | no-op; held reply unchanged |
| `ATG00620000` | `0069:0015` | repeat changes the reply back |
| `ATG0007A55A` | `0031:0000` | query 07 ignores its data |

The alternating reply tags are what distinguish a fresh response from a stale
holding register.

**The G command queues the request and does not print the reply.** Read the
holding registers separately - `ATGLK2I0058` / `005A` for the tag, `005C` /
`005E` for the data. These byte reads are not an atomic snapshot and do not by
themselves associate a reply with a request when other DSP traffic is active.

The handler at `0x25c5b` parses the two words and calls `8f46:01e4`; the helper
at `0xf678` queues `ff00, command, data` - `ff00` selects a paired transfer and
is not sent - and the drainer at `0xf511` writes command low/high to `58`/`5a`
then data low/high to `5c`/`5e`. The queue is supervisor RAM `0198..01c7`, tail
at `0194`, head at `0196`.

**`OK` alone is not proof of delivery**: the queue helper returns without
enqueuing when there is no room, and the G handler still clears carry. Confirm
through a changed reply and drained queue pointers.

### The rest of the ATG/ATN family

| form | what it does |
|---|---|
| `ATN<n>` | **Manual rate change**, not a DSP procedure call. `0x8458` parses a decimal byte into `AL`=event code, `AH`=argument; `ATN0` gives `007c`, `ATN1` `017b`, `ATN255` `ff7b`, `ATN256` overflows and dispatches nothing. Event `7c` requests index `[0x02b4] - 1` and `7b` requests `+1`, so **zero selects down and nonzero up** - fallback / fall-forward. Whether a state accepts it depends on the modulation and the allowed-index mask. |
| `ATNL` | A fixed programmed-I/O transfer: 5,460 iterations, 16,380 source bytes repacked into 10,920 six-bit pairs out through `c4`/`c6`, polling `c2`/`c0`, after a `0f3f` header, with CPU segment `e000` mapped in. **Not** DMA, not the verified `40..4e`/`50..5e` download path, accepts no source address, and returns no DSP memory. Its recipient is unidentified, and it has readiness loops with no software timeout. |
| `ATNX` | Restart. Sets bit 0 of `[0791]`, clears BP, disables interrupts, jumps to `8000:0480`, which reinitializes segments and stack and clears RAM. **Not** an NVRAM save. |
| `ATZ`, `ATZ0`-`ATZ5` | All the same restart on this image. The handler at `0x2631c` never parses a numeric suffix - it goes to `8000:0480` with BP 2 or 3 selected by bit 7 of `[049d]`. The Sportster manual's Z0-Z5 profile mapping is **not implemented here**. |
| `ATZ!` | Writes `[049b] = 0x80` and returns without resetting. Downstream meaning unestablished. |
| `ATG?` | Not a help command. Parses zero hex digits, leaves `?` unconsumed, calls `8000:1eed`. |
| `ATGU` | `clc; ret` at `0x25ce6`. No operation. |
| `ATGN` | Sets bit 0 at `[0158]`. Consumers unmapped. |

## The ATY diagnostics

Measured against `IDSDL302.ROM`, board id 7, `tick_ms=5`, the mostly-erased
`idsl302` fixture, no line:

| command | response | data source |
|---|---|---|
| `ATY11` | `Freq     Level` header, no rows | measurement (empty) |
| `ATY12` | `Recv     Xmit` + 16 rows of `0000     0000` | measurement (empty) |
| `ATY14` | `000,000,030,007,030,000` | CPU-side, partly populated |
| `ATY15` | `CURRENT DIPSWITCH SETTINGS` + all ten switches | modelled front panel |
| `ATY16` | `OK` | - |
| `ATY17` | 8x8 grid of `0000` | measurement (empty) |
| `ATY13`, `ATY18`-`ATY20` | `ERROR` | - |
| `ATY0`-`ATY9`, bare `ATY` | `OK` | - |

`ATY4` is a mode, not a display: it stores 4 at `[0x0608]` and persists, and a
later dial prints `CALL PROGRESS` and should then print rows. It is not limited
to nine values - the `cmp al, 0x0a / jae reject` at `0x26248` is the tail of a
dispatch chain that matches `0x0c`, `0x0e`-`0x11` ahead of it.

**Every measurement display is empty for one reason**, and it is the same one:
the DSP's outbound window is dead in the harness. Counting ports across an
`ATY12` run separates it cleanly:

| port | traffic |
|---|---|
| `0x1C`, `0x1E` | 2882 reads each - the ISR runs |
| `0x58`, `0x5A` | 2878 reads, 3469 writes - channel 1 and transmit are live |
| `0x5C`, `0x5E` | 3469 writes - live |
| `0x60`, `0x62` | **0 reads** |

`0x1C` bit 2 never asserts - the port returns `0x01` on all 2882 reads, which is
the output-latch echo of the `out 0x1c, 1` the ISR itself performs. So the zeros
`ATY12` prints are a **timeout, not an empty reply**: `0x6eb2` ignores the carry
`0x6ede` returns and prints sixteen rows regardless.

`ATY12` is therefore the cheapest probe for that channel - it prints at the
command prompt with no dial and no timeout, so a populated source shows up
immediately. `ATY4` needs something different: call-progress events on the
already-working channel 1, drawn from the 36-code table, delivered below `0x76`.

> **`ATY4`'s row format, established by forging events.** Injecting a table event
> code at `0xf492` prints `CALL PROGRESS` and one row. `0x14f13` is the row
> printer, reached by ordinary sequential flow inside the cadence detector rather
> than by any caller - which is why static scans found none. It prints the event
> byte through `aam 0x0a`, two decimal digits and two spaces. So an `ATY4` row is
> a run of call-progress **event codes in decimal**, like `00 00 02 08 07`, not
> signal levels. The 36 codes are read off the dispatch table at file `0x14b40`;
> **their meanings are not known** and no mapping from a line condition to a code
> has been demonstrated.

## Placing and running a routine

There is no "go" selector, so starting a routine means overwriting something the
firmware already calls. **The 80186's IVT is at physical `0` and is RAM**, and
its entries are far pointers, so a routine at physical `0x3000` is reachable as
`0000:3000`:

| vector | contents |
|---|---|
| `08` timer 0 | `8000:108f` |
| `0f` INT3 / tick | `8000:0a77` |
| `0d` INT1 | `9e74:01eb` |
| `12` timer 1 | `9e74:0334` |

**Timer 0 is the right hook.** Its handler is vestigial - `mov word ptr
[0xff02], 0x8000` then `iret`, a non-specific EOI and nothing else - so
displacing it costs the firmware nothing.

**But timer 0 runs and never interrupts.** Read off the board, `T0CON` at
`0xff36` is `0x8021`: `EN` set, the counter moving, `T0CMPA` at exactly the
25,200 the timebase derivation gives for 5 ms - and bit 13, `INT`, **clear**. The
tick is polled, not vectored. That is why pointing vector 8 at a routine did
nothing while the modem stayed completely alive. **Arming needs a separate
`ATGLK2WFF36,A021`**, and `TCUCON` already has the timer unit unmasked.

### Where it can live

| region | after `AT&T8` | after a call |
|---|---|---|
| `0x1600`-`0x2b00` | **survives** | survives |
| `0x2c00` | overwritten `0x55` | written |
| `0x2e00`-`0x7eff` (the 20 KiB block) | **zeroed** | survives |
| `0x8000`-`0xafff` | zeroed at `0x8000` | survives |
| `0xd000`-`0xfdff` | **survives** | survives |

So `&T8` erases the surveyed-free 20 KiB block where every takeover probe is
placed. A takeover probe does not care - it runs and dies inside the ~1.5 s bound
- but anything co-resident is destroyed mid-run, with its handler erased under a
live vector. **A call does not clear it**: across `ATDT9099` only `0x2c00`,
`0xb000` and `0xc000` changed at all. The old `0x3000` placement was unsafe for
the *test being used to validate it*, not for a call.

**Zero is not the same as unused**, and the check that proves it is worth
keeping: scanning the ROM for absolute-displacement operands to find untouched
pages gives a signal that is not merely imprecise but *inverted* - the one page
with **zero** static references is the one that filled completely under load,
because the firmware reaches it through a pointer.

### The co-resident sampler

`courier_emu.cooperative_probe`. The working recipe is two conditions at once,
and every earlier build violated one:

1. **Hook a vector the firmware does not repoint mid-run** - timer 0, not INT3.
2. **Place the handler and its ring in RAM the firmware does not clear** -
   `0x1600`-`0x2b00` or `0xd000`.

Armed across `AT&T8` with the sampler at `0x1a00`: no reset, `AT` answering
throughout, and the ring filled - 960 samples at 200 Hz, 3.2 s of an 8 s run,
with every watched port moving under load where an idle run reads one constant
value each.

`--hook int0` chains INT0 instead, and there the trick is cheaper: the original
offset is **zero**, so segment `0x01a0` puts the stub at `0x1a00` directly. One
word arms it, the same word disarms it, no intermediate state. That mode
**refuses the mailbox lanes `0x58`-`0x62`**, because the handler it runs in front
of is about to read exactly those and a byte taken here is a byte it does not
get.

`courier_emu.cooperative_run` drives the whole sequence - identity, vector check,
place, verify, arm, stimulus, disarm, read out - with the disarm in a `finally`.

Two things the first hardware run taught it:

* **The ring must wrap.** Stopping when full keeps the *oldest* entries, and at
  2,401 Hz a 1,920-entry ring is 0.8 s - the first capture filled before the hook
  even closed. Wrapping keeps the newest, and a wrap counter beside the pointer
  turns "at least capacity" into an exact interrupt count.
* **Read only as far as the write pointer.** Slicing the whole ring returns the
  previous run's leftovers past the stopping point, which once looked exactly
  like the line going off hook by itself.

### Placing an image

At ~165 ms a command a 4 KiB image costs nearly six minutes, and about three
quarters of it is zeros. `--assume-zero` omits words already `0000` (2144 writes
become 606, ~350 s to ~96 s) and `--against <image>` omits words matching one
already placed. **Neither is safe alone; `verify.txt` is what makes them safe.**
For every run after the first, `--assume-zero` is right and `--against` is wrong,
because the board reboots at the end of a takeover run and the RAM is genuinely
zero - measured, not assumed.

Order of operations:

1. `ATGLK2=0000` and keep the timer-0 vector at `0x20`-`0x23`; only a power cycle
   restores it.
2. Send `place.txt`. Inert - it writes RAM and nothing runs.
3. Send `verify.txt` and diff against `diagnostic-ram.bin`. **Do not skip this**:
   the next step executes whatever is there.
4. Open the capture, send `arm.txt`, then `ATGLK2WFF36,A021`. The modem stops
   answering AT - it has been taken over, which is expected.
5. Capture until `CDRP1 DONE`, roughly 20 KiB of text.
6. Power cycle. Everything written was RAM.
7. `python -m courier_emu.probe_transport --capture <file>` validates the frame.

A second run needs the vector written again - the reboot restores it.

> The `--rom-dump` build loads at `0x3000`, routines `0x3400`, kernel `0x4000`,
> buffer `0x8000`. The download routine addresses the kernel through a **segment
> immediate patched into the relocated copy**, so the kernel must be
> paragraph-aligned and that constant must move with it.

### Every takeover run ends in a reboot, and the trigger is unattributed

The placed region reads back as zero afterwards - 4240 bytes, every byte. The
test: write `A5A5` to `0x5d80`, outside the image and untouched by the probe; it
is zero afterwards, and IVT vector 8 and `T0CON` return to their defaults with
nobody restoring them. The firmware's reboot path clears RAM and rebuilds the
IVT, which is what that after-state looks like.

**What ends the run has not been identified.** The ~1.6 s `ADM707` watchdog was
the standing explanation and matched the observed bound; the owner reports the
part is used **only as a power-good reset**, and its pin 7 goes to the ASIC with
no `WDI` source anywhere. A datasheet number agreeing with a measurement is a
good clue and was taken for a proof. The leading candidate is now a **software**
failsafe in the supervisor noticing timer 0's vector hijacked - which needs no
hardware and fits a firmware that rebuilds its own IVT, and which the cooperative
route sidesteps entirely.

The bound is on the whole takeover, not on collection: the two-halves ROM dump
was split because printing 2048 words did not fit, and collection had finished
before the reset landed.

## What has been captured off this board

| capture | extent | result |
|---|---|---|
| flash | physical `80000..fffff` | 524,288 bytes, `f3a8b013…`, 2,048 pages read twice, zero retries, 1,107.8 s |
| RAM | `0000..feff` | two passes, 65,280 bytes, 139.44 s, differing at 44 addresses |
| upper window | `10000..1ffff` | two passes, 65,536 bytes, 144.79 s, differing at 17 bytes |
| DSP on-chip ROM | program `0000..07ff` | 2048 words, in two halves, `artifacts/dsp-onchip-rom-01/` - **possibly only a quarter of it, see below** |

All read-only: `AT`, `ATI7` and `ATGLK2=` only. Each has an offline audit
re-parsing the saved responses against the stored blocks and hashes.

The first 256 bytes of flash match the reference exactly. The reset stub decodes
to flash base `80000`, entry `fc00:11e9`. The DSP reset/download block
`[e370,e598)`, the readers `[26e20,26eec)` and the DSP startup/sender region
`[29080,29880)` match the reference; **11,295 bytes elsewhere do not**. The 64 KiB
windows at `d0000` and `e0000` read entirely `ff`, and erased reads cannot
distinguish blank banks from aliases.

**The upper window is the same RAM.** Five fresh lower/upper/lower groups match
completely, each upper pass differs from the lower at 45 of 65,280 bytes, and 249
of 255 whole pages match exactly - the live-RAM churn rate the two lower passes
already show.

**The RAM capture supplied the cached settings block** the emulator was missing:

```text
RAM 0752..0763: 64 96 03 08 0b 1a 64 96 03 ef 87 1d ef 87 1d ef 87 1d
Settings 1..6:  0, 30, 7, 30, 0, 0
```

All three redundant copies agree. Setting 3 is `7`, whose bit 0 satisfies the
serial-output enable condition traced in the firmware.

### The ROM dump may be a quarter of the ROM

The capture is **2048 words, program `0x0000`-`0x07FF`** - two halves at origin 0
and 1024, `ROM_DUMP_WORDS = 0x0800`. Whether that is the whole ROM depends on a
part number nobody has read, and the answer is not close:

| | SARAM | **ROM** | serial | package | dump covers |
|---|---|---|---|---|---|
| 'C50 / 'LC50 | 9K | **2K** | 2 | 132-pin BQFP, **PQ** | **all of it** |
| 'C51 / 'LC51 | 1K | **8K** | 2 | BQFP **PQ** / TQFP PZ | **a quarter** |
| 'C52 | none | 4K | 1 | **PJ** | half - but excluded, see [board.md](board.md#which-dsp-a-c50-possibly-a-c51---not-a-c52) |

(SPRU056D Table 1-1, read from the PDF in `docs/`.)

The original plan in this file was "read program `0000..0fff`, 4096 words" on the
'C52 assumption, and the capture took 2048. **That was never reconciled**, so the
dump has been short of its own stated target throughout.

**The package marking excludes the 'C52 independently.**
`TI DSP 16-912 (C) US ROBOTICS D17140PQ` - `PQ` is the 132-pin BQFP suffix that
'C50/'LC50/'C51/'LC51 carry and the 'C52 (PJ) does not. The pin work already
leaned on Table A-4's *PQ* pinout to place `VDDD` and `IS`.

**Two things lean 'C50, neither conclusive.** 302's `calld 0x23f0` needs SARAM
past a 'C51's `0x0BFF`; and the dump's own buffer is at data `0x1000`
(`ROM_DUMP_BUFFER`), outside a 'C51's 1K SARAM, and the dump worked - 1307
distinct values and a plausible reset vector `0000: b 0670`.

**The discriminating test is a stability test, not a plausibility test.** Both
parts would return something code-like from `0x0800`; only one returns the *same*
thing twice:

```sh
.venv/bin/python -m courier_emu.probe_transport --reference IDSDL302.ROM \
    --rom-dump --rom-origin 0x0800 --rom-words 0x0800 --output /tmp/rom-0800
```

Run it twice with the resident running in between.

* **'C50** - `0x0800`+ is SARAM, the firmware's live scratch. The two reads
  should **differ**.
* **'C51** - `0x0800`-`0x1FFF` is ROM. The two reads should be **byte-identical**.

**Move `ROM_DUMP_BUFFER` off `0x1000` first**: it sits inside the range this run
reads, so the dump would overwrite its own buffer. And note the standing caveat -
**`MP/MC` has never been read directly.** What argues the ROM is mapped at all is
that program `0x0000` holds a vector table rather than the kernel's own first
words.

> **Mind which artifact directory you cite.** The top-level `dsp-rom-half0/`,
> `dsp-rom-half1/`, `dsp-rom-dump-v*`, `dsp-rom-transport-v*` and
> `dsp-rom-sample-v1` are **emulator dry-runs**: `hardware_tested: false`, and
> their `serial_text` is a synthetic ramp (`0x1234 + 0x193n`). The hardware
> captures live *inside* `dsp-onchip-rom-01/` and begin `7980 0670 0860 BE20` -
> real code, not a ramp. This has been got wrong in both directions.

## Ruled out - do not re-run these

**Hooking INT3.** The chained build is stable at idle and measures INT3 at 303 Hz,
and it dies under `&T8` because **`&T8` repoints INT3 mid-run** - vector `0x0f`'s
offset goes `0x0a77` → `0x..e0` and back. The arming trick makes that fatal: INT3
fires continuously so its vector cannot be rewritten a word at a time (masking it
across the swap resets the board - the firmware cannot lose its tick for the
third of a second two commands take), so the swap changes only the **segment**.
When `&T8` writes its new offset the vector becomes `0100:xxe0` - a wild pointer
executed on the next tick. The segment-only swap was chosen *because* it is
atomic, and that is exactly what makes this fatal.

**Every other suspect for the earlier failures.** Each ruled out by experiment;
the actual cause was placement:

| suspect | test | result |
|---|---|---|
| the extra EOI | chained build issues none | still resets |
| interrupt latency | lean `push ax/bx/ds` | still resets |
| the port reads | `--ports none` | still resets |
| the handler's work at all | a bare 5-byte `jmp far` stub | still resets |
| placement in cleared RAM | relocated to `0x1a77` | still resets |

**Feeding the watchdog.** Nothing to feed. `P1LTCH` (`0xff56`) was never it
either - its 76 accesses are the NVRAM bit-bang, a bit-6 pair around the DSP
download, and the DSP reset line, with no toggle of that latch anywhere.

**Probing vectors by interposition.** Chaining a counting stub onto each vector
in turn reached `0x0c`, which fires, and jammed the modem - RD stuck on, no AT
response, power cycle to recover. **Reading the interrupt control registers
answers the same question with no writes at all.**
