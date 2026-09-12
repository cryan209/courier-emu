# The I-modem's AT interface

The command interface works.  `isdn-run` can now type at it and read what
comes back, and what comes back is the firmware's own text:

```sh
.venv/bin/python -m courier_emu isdn-run Ie030002.nac --with-dsp \
  --instructions 55000000 --send AT --send AT --send ATI3
```

```
<<< \r\nNO CARRIER\r\n
<<< \r\nUSRobotics Courier I-Modem with ISDN/V.34\r\n
```

`--terminal` attaches the invoking terminal instead, keystrokes in and output
out, Ctrl-] to detach; the run report goes to stderr so stdout stays the
serial stream.

## Which part, and how it is known

SIO0 at `0xf8f8` is the command port, and nothing about that decode is
assumed.  The firmware unmasks IRQ3 on the master 8259, whose vector `0x23`
reads back from a live run as `a400:eaa2` = **`0xb2aa2`**:

```
b2aa2  pusha ; push ds ; push es ; mov ax,2600 ; mov ds,ax ; mov es,ax ; cld
b2aad  mov dx,[e83a] ; in al,dx        ; IIR
       test al,1 ; jne b2abd           ; bit 0 set: nothing pending, so EOI
       movzx bx,al ; jmp [bx-17d0]     ; otherwise dispatch on the value
```

The dispatch table is four words at `2600:e830`, and the port variables
follow it.  Both read back from a run as:

```
e830  c8 ea  84 ec  8d ec  ec ea      iir 0,2,4,6 -> b2ac8 b2c84 b2c8d b2aec
e838  ad ea                           the re-poll at b2aad
e83a  fa f8   fd f8   fe f8   f8 f8   f8fa  f8fd  f8fe  f8f8
```

which is a 16550's IIR, LSR, MSR and RBR/THR at base `0xf8f8`, in their
standard places, named by the firmware's own handlers:

| IIR | handler | what it does |
|---|---|---|
| 0 | `b2ac8` | reads MSR, tests `01`/`10`/`02`, updates a flag at `[ca42]` |
| 2 | `b2c84` | clears the transmit-busy flag at `[c914]` |
| 4 | `b2c8d` | reads RBR, echoes it when `[d2c3]` bit 3 and `[d1e0]` allow, calls `[c922]` |
| 6 | `b2aec` | reads LSR, tests `10` and `08` |

So the receive path is interrupt-driven, and a model that answers LSR and
nothing else - which is what the harness had - can never reach any of it.

The modem-status inputs are wired DCE-side.  The signal query at `a5e0e`
picks its MSR mask by logical signal: `0x0424` reads `0x80` or `0x20`
depending on a mode flag at `[d2c3]`, `0x8024` reads `0x10`.  That is
DCD-or-DSR for "the terminal is there" and CTS for flow control - the DTE's
DTR and RTS arriving on this part's inputs.  `--serial-signals` sets them;
the default asserts all three.  In practice the firmware answers the same way
with all of them deasserted, so nothing here depends on the choice.

## What the model adds

`courier_emu/sio.py` is a 16550 channel: RBR/THR with a DLAB-routed divisor,
IER, IIR with the standard priority, LCR, MCR including loopback, LSR with a
real data-ready bit, and MSR with read-once delta bits.  `courier_emu/isdn.py`
gives each SIO one, raises the channel's IRQ from `poll_timers`, and exposes
`send_serial` / `take_serial`.

**SIO1 has no interrupt line because the firmware never services it.**  The
variable block at `2600:e83a` runs to `e84a` and holds all nine registers of
one part - `f8fa f8fd f8fe f8f8 f8f8 f8f9 f8ff f8fc f8fb`, this 16550's IIR,
LSR, MSR, RBR, THR, IER, SCR, MCR and LCR - and there is no second block.
Over a command session SIO1 is addressed seven times, all of them in the init
at `4030:010b` that sets its LCR, divisor and IER and reads its MSR twice;
after that nothing touches `0xf4f8` again.  So leaving SIO1 pollable and
silent is what the firmware does with it, not a gap in the decode.

The one interrupt-driven path beyond IRQ3 is **IRQ12**, and it belongs to SIO0
rather than SIO1.  Its handler at `0xc7c42` masks SIO0's IER through `[e844]`,
programmes the 386EX DMA registers at `0xf001`, `0xf00a`, `0xf00c`, `0xf010`
and `0xf098`, and restores IER - a DMA-fed transmitter for the command port,
gated on `[ca42]` bit 1.  None of those DMA registers is touched during a
command session, so the AT interface does not use it; it is recorded here
rather than modelled.

Three details are worth knowing before reading a transcript.

**The line rate is derived, not assumed.**  Received and transmitted bytes
cross distinct holding and shift registers, and the interval between them now
comes from the divisor the firmware programmes and the clock it selects for
it - about 20,900 guest instructions at its own 9600 default.  See
[the two clocks](#the-board-has-two-uart-clocks) below.  `--serial-pace`
overrides the interval for experiments; with `--serial-pace 0` a line arrives
as one burst and some commands stop answering.

**The link is 7E1, generated in software.**  The firmware programmes the part
for eight data bits and no parity (`LCR = 0x03`) and computes the parity bit
itself into the top bit, so `USRobotics` leaves the part as
`55 53 d2 6f e2 6f 74 69 63 f3`.  That is not an 8N1 stream with a quirk: an
8N1 frame's eighth data bit occupies exactly the slot a 7E1 frame's parity bit
occupies, and both frames are ten bits, so what reaches the wire *is* 7E1 and
a 7E1 terminal parses it correctly.  Over a full banner-and-result-code stream
73 bytes of 73 carry correct even parity, and `ATI4` says the same thing in
words: `BAUD=9600 PARITY=E WORDLEN=7`.  The console masks the parity bit for
display and sets it on the way in; `serial_a` in the report is the raw stream.

Receive is the same technique in reverse - the firmware takes eight bits and
masks the top one rather than checking it - so parity on the way in is not
load-bearing.  A line sent with it and a line sent without it produce
identical answers.

**The firmware does not swallow the first line.**  A session whose only
command is `ATI3` gets the banner, and one that opens with `AT` gets an answer
to the `AT` as well.  What made it look otherwise is that a bare `AT` answers
`NO CARRIER` rather than `OK` (see below), which reads like a lost line when
the transcript opens with a throwaway.  Nothing needs to be primed.

## The board has two UART clocks

The rate setter at `0xc7ae7` takes a rate code 1..12, indexes a twelve-word
table at `c774:04db`, and writes that word into the divisor latch:

```
1  2  4  6  40  80  161  322  643  1286  2572  1782
```

It also records `0x0c - code` at `[d1db]`, and the setup menu at `0xc0570`
labels those display indices - 5 is `4800 bps`, 6 `9600`, 7 `19200`, 8
`38400`, 9 `57600`, 10 `115200`.  So code 1 is 230400 and code 11 is 300.

Having named the rates, every divisor in the table comes out exact - against
two different clocks:

| code | rate | divisor | clock | exact value |
|---|---|---|---|---|
| 1 | 230400 | 1 | 3.6864 MHz | 1 |
| 2 | 115200 | 2 | 3.6864 MHz | 2 |
| 3 | 57600 | 4 | 3.6864 MHz | 4 |
| 4 | 38400 | 6 | 3.6864 MHz | 6 |
| 5 | 19200 | 40 | 12.3456 MHz | 40.1875 |
| 6 | 9600 | 80 | 12.3456 MHz | 80.375 |
| 7 | 4800 | 161 | 12.3456 MHz | 160.75 |
| 8 | 2400 | 322 | 12.3456 MHz | 321.5 |
| 9 | 1200 | 643 | 12.3456 MHz | 643 |
| 10 | 600 | 1286 | 12.3456 MHz | 1286 |
| 11 | 300 | 2572 | 12.3456 MHz | 2572 |

Each group is exact to the rounding a divisor latch forces, and neither group
fits the other's clock.  Code 12's `1782` has no menu entry and is not
interpreted.

The firmware picks between the two itself.  Immediately after loading the
divisor it reads `0xf836`, clears bit 1 for codes 1..4 and sets it for codes
5..12, and writes it back:

```
c7b17  mov dx, 0xf836
c7b1a  in al, dx
c7b1b  shr bx, 1          ; bx = code - 1
c7b1d  cmp bx, 3
c7b20  ja  c7b26
c7b22  and al, 0xfd       ; codes 1..4  -> 3.6864 MHz
c7b24  jmp c7b28
c7b26  or  al, 2          ; codes 5..12 -> 12.3456 MHz
c7b28  out dx, al
```

That boundary is exactly the boundary between the two clocks, so bit 1 of
`0xf836` is the board's UART clock select.  (It is where the 386EX puts its
serial configuration register, which is consistent, but the split is
established by the table, not by the part number.)  The init at `4030:010b`
writes `0x00` there while setting both SIOs to divisor 2 - which on 3.6864 MHz
is 115200 exactly.

The instruction clock the interval is scaled against comes from the firmware's
own description of its board: `ATI7` prints `Clock Freq 20.16Mhz`.  At roughly
one instruction per clock that puts a 9600-baud character at about 20,900
instructions - within 5% of the 20,000 that had been verified empirically long
before the clock was recovered.  Two independent routes to the same number.

Note that `pit.INSTRUCTIONS_PER_SECOND` still carries an older 2,500,000
assumption for the 8254 ratio, documented there as an assumption rather than a
measurement.  Reconciling the two is a separate change with a much wider blast
radius and has not been made.

## Why every command answers `NO CARRIER`

Not just a bare `AT`. Swept over `AT`, `ATZ`, `AT&F`, `ATE1`, `ATH`, `ATQ0`,
`ATV1`, `ATX0` and `AT&V`, watching `AL` at `0xacf8c` - the routine that emits
the result code - **every one of them emits code 3, and code 0 is never
emitted at all.**

**An earlier claim on this page was wrong.** It argued the result table was not
mis-indexed because "`ATI2` answers a plain `OK`, so index 0 is reachable".
`ATI2`'s `OK` is its own text - the checksum test passing - and the result code
that follows it is `NO CARRIER` like everything else. Index 0 was never shown
to be reachable. (The table itself does look conventional: 0 OK, 1 CONNECT,
2 RING, 3 NO CARRIER.)

**Where the code is chosen.** Commands end at the go-idle epilogue's decision:

```
a8067  cmp byte ptr [d08b], 1     ; the recorded disconnect cause
a806c  jne a808c
a806e  test byte ptr [d2a1], 47
a8073  je  a808c
a8083  xor al, al                 ; -> 0, OK
a808c  ...
a8096  mov al, 3                  ; -> 3, NO CARRIER
a80d3  call acf8c                 ; emit the result code in AL
```

In a run `[d08b]` is **0** and `[d2a1]` is 0, so both tests fail.

**The reason table confirms what 0 and 1 mean.** The NUL-separated list starts
at `0xc194a`, not the `0xc1abb` quoted earlier, which lands mid-string. From
there: 1 `DTR dropped`, 2 `Escape code`, 3 `Loss of Carrier`, ... and index 23
= `0x17` lands exactly on `Keypress Abort`, which is the cross-check that the
indexing is right. So index **0 means no disconnect was recorded at all** -
and the firmware answers `NO CARRIER` for it.

**The Keypress Abort story no longer applies.** The cause is 0, not `0x17`: the
receive callback at `0xa4e0e` is never entered, because `[c922]` is loaded with
a different handler (`0x9d17` from `0xadc37`). A rewrite used to sit in
`courier_emu/isdn.py` turning a `0x17`-with-no-flags state into DTR-dropped so
a plain `AT` would answer `OK`; its condition never matched, so it did nothing.
It has been removed rather than left looking like a fix.

**How a command gets to that epilogue.** Through `0xadc82`, which is reached
only when three flags are all clear:

```
adc3d  test [e78e], 1 ; jne adc88     ; set -> a different route entirely
adc44  test [e78f], 1 ; je  adc63
adc63  test [e770], 4 ; je  adc82     ; adc82 calls the epilogue
```

All three read 0 for the whole run, and each has exactly one setter:

* `[e770]` bit 2 is set only at `0xc83d0`, and that site is gated on `[d2c5]`
  bit 0, which is 0.
* `[e78e]` bit 0 is set only at `0xc824c`, reached by parsing an AT command of
  the `...=1` form.
* `[d1ea]`, tested against 6 along this path, is 4 - and it is copied from a
  settings block at `0xab700`, so it is configuration rather than live state.

**What has been ruled out.** `--line-activate` walks the S interface to F7 and
changes nothing. A sealed but all-zero configuration record laid over the
config sector makes it worse - the modem emits nothing at all - so an empty
record is not simply a missing field either.

**The gate is `[d2c5]`, and it comes from a configuration record.**
`[d2c5]` has exactly one computed write, at `0xa449b`, in a routine that
unpacks a block of product-capability bytes:

```
a4451  mov [d2c5], 0
a4456  mov [d2c4], 0
a4460  and [e358], 33
a4465  test [d2c6], 1 ; jne a4484     ; else walk a table at cs:04ac by [d2c7]
a4484  test [d2c6], 2 ; jne a4491     ; else [d2c8] -> c8e4
a4491  test [d2c6], 4 ; jne a449e     ; else [d2c9] -> d2c5
a449e  test [d2c6], 8 ; jne a44ab     ; else [d2ca] -> d2c4
```

So `[d2c5]` is `[d2c9]`, unless `[d2c6]` bit 2 says the field is absent. And
`[d2c6]` onwards is not computed at all - it is a **4 KiB configuration record
copied out of flash**. The loader at `0xc532b` walks four 0x1000-byte pages
from segment `f800`, validates each at `0xc53fd` with a CRC-16 seeded `0xffff`
whose residue must be `0xf0b8`, keeps the highest version word at `0xffc`, and
copies the winner verbatim to `2600:d2c6..e2c5`. When none validates,
`0xc5312` fills that whole 4 KiB with `0xff` instead.

That is what happens here. `[d2c6]` reads `0xff`, so bit 2 is set, so the copy
is skipped, so `[d2c5]` stays `0`, so `0xc83d0` can never set `[e770]` bit 2,
so every command routes to the disconnect epilogue and answers the
"no disconnect recorded" code.

**The chain, end to end:**

```
no capability record in flash
  -> c5312 blanks 2600:d2c6..e2c5 to ff
  -> [d2c6] bit 2 set, so [d2c9] is not copied
  -> [d2c5] = 0
  -> c83d0 gated off, so [e770] bit 2 is never set
  -> adc63 falls to adc82, the call-termination epilogue
  -> [d08b] = 0 (no disconnect recorded), so a8067 fails
  -> result code 3, NO CARRIER, for every command
```

### The record format is recovered; its values are not

`tools/imodem_capability_record.py` builds one, and **the firmware accepts it**
- it validates, it wins on version, the blank path stops running, and its
bytes arrive at `d2c6` with `[d2c9]` copied on to `[d2c5]`. That is what
establishes the CRC transcription and the layout, and
`tests/test_imodem_console.py` checks it against the firmware rather than
against our arithmetic.

What the fields should *hold* on a real unit is **not** recovered, and guessing
makes things worse rather than better: a record setting `[d2c9]` bit 0 leaves
the firmware masking IRQ3 and silent, and a record that is merely valid but
all-zero silences it too, because those 4 KiB are real configuration and
zeroing them is not a neutral choice. No page anywhere in this repository
validates against the loader - the single hit in a compressed archive is a
chance CRC collision, which one expects at roughly this rate over the data
volume searched.

So `NO CARRIER` is not a fault in the serial port, the line, or the result
table. It is the absence of the product-capability record, and closing it
needs that record's real contents - a dump from a unit, or the field meanings
recovered one at a time from the sites that read them.

`tests/test_imodem_console.py` pins the current behaviour, so that a fix shows
up as a failing test rather than passing unnoticed.

## The line is down, and that is the harness's doing

`ATI12` says so in as many words:

```
   Physical Interface:  Inactive
   Data Link Layer   :  Inactive
```

`courier_emu/am79c30.py` starts the LIU in I.430's F1, so `LIU_LSR`, the S/T
line status, reads `0` and the line never activates unless a harness brings it
up.  That is deliberate: nothing there fakes a line that is not there.  The consequence is that L1 and
L2 never come up, the modem is never idle-with-a-line, and commands that end
in the go-idle epilogue report a disconnect instead of `OK`.

S/T activation is now modelled, and `isdn-run --line-activate` walks the
interface up: with it, `ATI12` reports **Physical Interface: Active**.  See
[imodem-d-channel.md](imodem-d-channel.md).  It does not change this result
code - the keypress-abort cause above is recorded by the receive callback and
has nothing to do with the line - and layer 2 stays down for want of a
settings store, which that page ends on.

`tools/imodem_at_probe.py` reproduces the whole chain - it watches `a8067`,
`ab33b` and the transcript together:

```sh
.venv/bin/python tools/imodem_at_probe.py --send AT --send AT --send ATI3 \
  --instructions 54000000 --output artifacts/imodem-at/probe.json
```

```json
"disconnect_causes":  [{"cause": 23, "recorded_at": "0xa4e1e", ...}],
"result_decisions":   [{"cause": 23, "flags": 0, "result": 3,
                        "answer": "NO CARRIER", ...}]
```

## `ATI` through `ATI30`

Swept one command per run - `AT`, a throwaway `AT`, then the command - and
recorded in `artifacts/imodem-at/ati-sweep.json`.  `ATI` alone is `ATI0`.

| command | answer |
|---|---|
| `ATI0` | `USR009F` - the product code |
| `ATI1` | `A190` - the ROM checksum |
| `ATI2` | `OK` - the checksum test passing |
| `ATI3` | `USRobotics Courier I-Modem with ISDN/V.34` |
| `ATI4` | current settings: the `B/C/E/F/L/M/Q/V/X` set, `BAUD=9600 PARITY=E WORDLEN=7`, the `&` and `%`/`*` registers, and S00-S83 |
| `ATI5` | the same again from NVRAM, plus the ten stored phone numbers |
| `ATI6` | link diagnostics - byte and block counters, retrains, `Data Compression NONE`, `Equalization Long`, and `Disconnect Reason is Keypress Abort` |
| `ATI7` | configuration profile: `Options V32bis,x2,V.90`, `Clock Freq 20.16Mhz`, `Eprom 768k`, `Ram 256k`, `Supervisor rev 3.0.2`, `DSP rev 3.0.5`, `Product ID 992332-01`. With a valid configuration record in place it prints more - product type, the supervisor and DSP dates, and the serial number. See [imodem-config-sector.md](imodem-config-sector.md) |
| `ATI10` | dial security status - the account, password and phone-number table |
| `ATI11` | link diagnostics, physical layer: modulation, carrier frequency, symbol rate, trellis, precoding, shaping, preemphasis, levels, delay and offsets - all empty or zero with no call up |
| `ATI12` | ISDN switch settings: `*W` protocol, `*M`, `*O`, the `*S`/`*P`/`*T` SPID, directory-number and TEI pairs, and the two layer states quoted above |
| `ATI15` | party-number status: calling and called party type, plan and number, charge advice, date, time, display |
| `ATI16` | Turbo PPP settings - `*D0`-`*D4`, `*K`, `*P`, `*T`, and a note that the modem is not set for PPP |
| `ATI17` | a diagnostics page: `CP`, `CGP`, `CPSA`, `CGPSA`, `BC`, `LLC`, `HLC`, `CHID` |
| `ATI8` `ATI9` `ATI13` `ATI14` `ATI18`-`ATI30` | nothing within the window |

`ATI7` is worth keeping: it is the firmware describing its own board, and it
agrees with the hardware this repository has been reading - 20.16 MHz, 768 KiB
of EPROM, 256 KiB of RAM, and x2/V.90 in the options list.  The empty ones are
reported as observed; whether they are unimplemented or simply slower than the
window has not been separated.


## Open: the board probe never completes, so there is no echo

This is the live defect, and it is not fixed.

`ATI4` reports `E1`, so the firmware should echo every character typed at it.
It does not. The receive handler's echo is gated on two flags:

```
b2c8d  mov dx,[e840] ; in al,dx     ; RBR
b2c92  test [d2c3], 8               ; External?
b2c97  je  b2ca1                    ; no -> skip the echo
b2c99  test [d1e0], 0xff            ; echo enabled?
b2c9e  je  b2ca1
b2ca0  out dx, al                   ; echo, straight back to THR
```

At runtime `[d1e0]` is `1` - echo is on, as `ATI4` says - and `[d2c3]` is
**`0x00`**, so bit 3 fails and the echo never happens.

`[d2c3]` is meant to be written by the board probe, and **the probe never gets
that far**. It runs seven instructions and gives up:

```
a44c2  mov ax,082a ; call a5ebf     ; drive one signal
a44c8  mov ax,802a ; call a5ebf     ; drive another
a44ce  mov ax,4024 ; call a5e0e     ; sense
a44d4  je  a4528                    ; sense clear -> abandon the probe
```

Decoding the three signal routines gives the wiring. A signal id's low byte
indexes a port table at `a400:1f97` (`0010 0012 0014 0012 0014 0100 f870
f862`); `0x082a` and `0x802a` set bits `0x08` and `0x80` in the latch at
**port `0x14`**, and `0x4024` reads bit **`0x40`** back from that same port.
The harness answers `0` for port `0x14`, so the sense line never asserts and
the probe abandons.

The consequence is wider than the echo: **`--product-type` is a no-op.** It is
applied by a hook on `0xa4506`, which is inside the part of the probe that is
never reached, so every run has `[d2c3] = 0` whatever the flag says.

### What is behind it: a second UART at 0x80 on IRQ5

Making port `0x14` read back, with the sense bit following the driven `0x80`,
does let the probe finish and store an External `[d2c3]` - and then the
command port goes **completely silent**. Characters still arrive (8 in, all of
both test lines) but nothing is transmitted at all: no THRE interrupts, two
THR writes in a whole session, no echo, and the DMA transmitter at `0xc7c42`
is not used either.

So `[d2c3]` bit 3 is not a cosmetic identity bit: it selects **which serial
interface the modem uses at all**.

Tracing the stall shows the firmware is not stuck, it is idle. The spin is
`0xac62f` (`xchg bx,ax / clc / ret`), the no-op entry of the jump table at
`0xac617`, reached 92,825 times from the main loop's `mov al,0 / call [c926]`
at `0xac4e5` - the idle poll of a state machine that never gets a command
event. It never gets one because **the serial ISR is never entered**: zero
entries at `0xb2aa2`, zero RBR reads, zero IIR reads.

The master 8259 mask says why. It goes from `0xb3` to `0xda`:

| | unmasked master lines |
|---|---|
| probe bails (today) | 2 (cascade), **3**, 6 |
| External | 0, 2 (cascade), **5** |

**IRQ3 is masked and IRQ5 is unmasked**, and IRQ5's vector `0x25` points at
`cfdb:0000` = `0xcfdb0` - a different serial ISR entirely, which opens

```
cfdb0  pusha ; push ds ; mov ax,2600 ; mov ds,ax
cfdb7  in al, 0x8b   ; test al,80 ; jne ...   ; else give up
cfdc0  in al, 0x8c   ; test al,40 ; jne ...   ; else give up
cfdc9  mov byte ptr [e8d8], 1
cfdce  mov al,0 ; out 0x8c, al                ; acknowledge
cfdd2  mov dx,0x8a ; in al,dx ; and al,8
```

And the firmware re-points its whole serial port-variable block to match.
Read back from the two runs, `2600:e83a`..`e84a`:

| | IIR | LSR | MSR | RBR | THR | IER | SCR | MCR | LCR |
|---|---|---|---|---|---|---|---|---|---|
| probe bails | `f8fa` | `f8fd` | `f8fe` | `f8f8` | `f8f8` | `f8f9` | `f8ff` | `f8fc` | `f8fb` |
| **External** | `0082` | `0085` | `0086` | `0080` | `0080` | `0081` | `0082` | `0084` | `0083` |

That is a 16550 register file at base **`0x80`**, in its standard order, on
**IRQ5**. The runtime trace agrees: with the probe completing, the signal
query's MSR read at `0xa5e4c` goes to port `0x86` 9,469 times, and `0xb2a3a`
reads port `0x80` 500 times - while nothing in `0x80..0x8f` is touched at all
on the path the harness takes today.

The init that sets it up is a table walk at `0xb2a6a`:

```
b2a6a  mov dx, cs:[si] ; inc si ; inc si     ; port
b2a6f  mov al, cs:[si] ; inc si              ; value
b2a73  out dx, al
b2a74  loop b2a6a                            ; cx = 0x0e, si = 0xea78
```

whose fourteen (port, value) pairs at `a400:ea78` begin

```
0088=76  0088=66  009d=25  0088=04  0089=00  008f=00
0082=80  0083=80  0080=08  0081=00  0083=00 ...
```

- the DLAB sequence `0083=80`, `0080=08`, `0081=00`, `0083=00` is a divisor of
**8** being loaded, which is what confirms `0x80`/`0x83` as THR/LCR - plus
board registers at `0x88`, `0x89`, `0x8f` and `0x9d` that are not part of the
16550.

So the earlier note in this file that no UART at `0x80` on IRQ5 could be found
was **wrong**, and wrong for a specific reason: it was measured only on the
path where the board probe bails out, which is the fallback that uses the
386EX's own SIO0 at `0xf8f8` on IRQ3. The external unit does not use SIO0 for
its command port at all.

### Correction: IRQ5 is not the command port, IRQ0 is

The note above that IRQ5 carries the command port was wrong, and decoding its
ISR is what shows it. `0xcfdb0` never touches `0x80`..`0x86` at all. It reads
status from `0x8b`, `0x8c` and `0x8a`, streams bytes out of a table in its own
code segment, and writes them a word at a time to `0x9c` and `0x9b`:

```
cfdb7  in al,0x8b ; test al,80 ; jne ...      ; else EOI and leave
cfdc0  in al,0x8c ; test al,40 ; jne ...      ; else EOI and leave
cfdc9  mov byte ptr [e8d8],1
cfdce  mov al,0 ; out 0x8c,al                 ; acknowledge
cfdd2  mov dx,0x8a ; in al,dx ; and al,8
cfdd8  jne ...     ; bit 3 clear -> mov word ptr [e8d0],00c1   (rewind)
cfe04  mov al,cs:[si] ; inc [e8d0]            ; si = [e8d0], the read cursor
cfe61  out 0x9c,al ; xchg ah,al ; out 0x9b,al
```

The **command port on this path is the 16550 at `0x80`, serviced from IRQ0**,
whose handler at `0xb2f1a` is a polled service driven by the tick:

```
b2f24  in al,0x86            ; MSR -> [e857]
b2f34  in al,0x85            ; LSR, test 10 (break)
b2f53  in al,0x85 ; test 20  ; THRE -> call b2fd6, transmit
b2f67  in al,0x85 ; shr al,1 ; data ready -> jmp [e834], receive
```

Note IRQ0 is the PC-AT timer line. The harness routes 8254 counter 0 to IRQ10,
which is what the `[d2c3] = 0` fallback wants; this path wants IRQ0.

### The IRQ5 device is the ISA Plug and Play responder

The table the ISR clocks out, at `cfdb:00c1`, parses exactly as ISA PnP
resource data with nothing left over:

```
serial identifier: vendor USR009E  serial ffffffff  checksum 0xb1
  PnP version                1.0
  ANSI identifier string     'USRobotics Courier I-Modem INT'
  Logical device ID          USR009E
  Compatible device ID       PNPC10F
  Start dependent function 0   Fixed I/O 0x02f8 len 8   IRQ 3
  Start dependent function 1   Fixed I/O 0x03f8 len 8   IRQ 4
  Start dependent function 1   Fixed I/O 0x03e8 len 8   IRQ 4
  Start dependent function 1   Fixed I/O 0x02e8 len 8   IRQ 3
  Start dependent function 2   Fixed I/O 0x03e8 len 8   IRQ 3,5,7
  Start dependent function 2   Fixed I/O 0x02e8 len 8   IRQ 4,5,7
  End dependent function / End tag
```

`USR` is the correctly compressed EISA form of `56 72`, `PNPC10F` is the
standard modem compatible id, and the COM2/COM1/COM3/COM4 alternatives with
IRQ 3, 4, 5 and 7 are what an internal card offers a **host PC** - they are
the host's resources, and say nothing about this board's own port map.

So the register file is:

| port | meaning |
|---|---|
| `0x8b` bit 7 | host request pending; the ISR leaves unless it is set |
| `0x8c` bit 6 | second gate on the same request |
| `0x8c` write 0 | acknowledge the request |
| `0x8a` bit 3 | clear rewinds the read cursor `[e8d0]` to the start of the structure |
| `0x9c`, `0x9b` | the data path back to the host, low byte then high |

`[e8d0]` is the cursor, running `0x00c1`..`0x0131`; the ISR substitutes
`[e8d2]`, `[e8d4]`, `[e8d6]` and `[e8d7]` at cursor positions `0xc5`, `0xc7`,
`0xc9` and `0x131` - the serial-number and checksum fields the identifier
needs filled in per card.

**The contradiction is resolved: `0x08` is Internal, not External.**

ATI7's formatter at `0xc0be0` is the authority, and it had been read backwards.
It picks a string by testing bit 1, then bit 3, then bit 2, with a fallback:

```
c0bf3  mov si,3d95 ; test [d2c3],02 ; jne print
c0bfd  mov si,3d9e ; test [d2c3],08 ; jne print
c0c07  mov si,3da7 ; test [d2c3],04 ; jne print
c0c11  mov si,3d8a
```

Those four offsets point into a run of consecutive strings whose lengths match
the gaps exactly (`0x3d95-0x3d8a = 11` = `"Undefined "`, and so on), so
reading them back names each bit:

| bit | string |
|---|---|
| 1 (`0x02`) | `External` |
| 3 (`0x08`) | `Internal` |
| 2 (`0x04`) | `Rackmount` |
| none | `Undefined ` |

with `[d2c4]` bit 0 appending `" MODEM"`.

So the probe's two verdicts are `0x28` = **Internal** and `0x22` = **External**
- and the earlier note that `0x22` is what the formatter "correctly calls
Undefined" was wrong too. `courier_emu/isdn.py`'s `PRODUCT_TYPE_MODES` had
every entry one position out, so `--product-type external` wrote the Internal
bit; that is fixed.

### Which wiring gives which verdict

Measured at `0xa4503`, the instant the probe stores its verdict, rather than at
end of run:

| sense wiring at port `0x14` | verdict |
|---|---|
| follows the `0x80` drive | `0x28` **Internal** |
| follows the `0x08` drive | `0x22` **External** |
| set whenever either is driven | `0x22` **External** |
| never asserts (today) | probe abandons, `[d2c3]` stays `0`, **Undefined** |

Only one write to `[d2c3]` happens in a whole run, so nothing downstream
second-guesses it. The `INT` identifier seen earlier was simply the Internal
branch, reached because the first wiring guessed was the `0x80` one.

### Both real variants use the same UART; only the failure path does not

With the probe completing, External and Internal produce **identical**
hardware: the port-variable block reads `0082 0085 0086 0080 0080 0081 0082
0084 0083` and the master mask is `0xda` in both cases. The enclosure bit does
not change the port map.

That means the `0xf8f8` / IRQ3 interface this harness has been driving all
along is **the fallback taken when the probe fails** - the 386EX's own SIO0 -
and is not what either shipped product uses for its command port. The real
command port is the 16550 at `0x80`, polled from the IRQ0 handler at
`0xb2f1a`, which is why the echo and the second command have never worked.

Confirmed viable: with the latch answering, a `SerialChannel` at `0x80`, and
the 8254 tick routed to **IRQ0** instead of IRQ10, that handler runs - 8,703
entries in a 35M-instruction session, against 0 with the tick on IRQ10.
Characters reach the part; it does not yet transmit, so the `0x80` channel
needs finishing.

### Correction: the external unit uses SIO0, and it is now modelled

An earlier conclusion here - that both variants use the `0x80` UART and the
`0xf8f8` interface is only a failure path - was an artifact of the forcing
hook, which overwrote `[d2c3]` in *both* runs being compared so both were
really the Internal branch. With the probe's own verdict left alone:

| verdict | command port | master mask |
|---|---|---|
| `0x22` **External** | SIO0 at `0xf8f8`, IRQ3 | `0xb3` |
| `0x28` **Internal** | 16550 at `0x80`, IRQ0, plus PnP on IRQ5 | `0xda` |
| probe abandons, Undefined | SIO0 at `0xf8f8`, IRQ3 | `0xb3` |

So `0xf8f8` / IRQ3 **is** the external unit's command port. The harness had the
right part all along; what it did not have was the identity, the signal sense,
or the enclosure probe.

The ISR-level echo at `0xb2ca0` is gated on `[d2c3]` bit 3, which is
*Internal* - so the external unit does not echo from its ISR, and the absence
of echo there is the firmware's behaviour rather than a modelling gap.

### The modem-status inputs are active low, and it is load-bearing

The signal query at `0xa5e0e` masks the MSR and then does `sete al`: it reports
a signal present when its bit reads **0**. The matching set and clear routines
drive the MCR the same way round. That is the inversion an external unit's
RS-232 transceivers put in the path, and `TERMINAL_PRESENT` had it backwards.

It is not cosmetic. With DSR reading 1 the firmware decides no terminal is
attached: a bare `AT` still answers, but anything longer produces **nothing** -
`ATI7` printed not a single byte. With DSR reading 0 it prints its whole
configuration profile. That one bit is the difference between a command port
that looks half-broken and one that works.

### Where this leaves the interface

`--product-type external` (the default) now:

* answers the probe's board latch at port `0x14`, so the firmware reaches its
  own verdict instead of abandoning - no value is written into `[d2c3]` by the
  harness any more;
* reports **`Product type            External`** in `ATI7`, where it used to
  say `Undefined`;
* answers `ATI3` with `OK` rather than `NO CARRIER`.

`--product-type internal` installs the 16550 at `0x80` on IRQ0 and routes the
8254 tick to IRQ0, which is what services it. That much works: the handler at
`0xb2f1a` runs 8,703 times in a 35M-instruction session, and all eight
characters of a two-line session are received and dispatched through `[e834]`.
**It does not transmit yet** - the transmit routine at `0xb2fd6` is entered
8,448 times and finds something to send once, so the internal command task is
not producing output. That is the open end.

### What is still neededThree separate things, now that they are separable:

1. **The board latch at port `0x14`** so the probe completes at all - but with
   its sense wiring settled rather than guessed, because the guess currently
   selects a branch whose own identifier says `INT`.
2. **The 16550 at `0x80`**, which is an ordinary one - the IRQ0 handler only
   uses RBR, THR, LSR and MSR - plus the 8254 tick routed to **IRQ0** rather
   than IRQ10, since that handler is what polls it.
3. **The PnP responder** at `0x8a`/`0x8b`/`0x8c`/`0x9b`/`0x9c`, which is
   decoded above but needs no model unless a host bus is being emulated: with
   `0x8b` bit 7 reading 0 the ISR simply EOIs and returns, which is a card
   nobody is interrogating.

Item 3 is therefore *not* a blocker for the AT interface. Items 1 and 2 are.


## Using the terminal, and what it still gets wrong

Four things a person hits with `--terminal`, and where each comes from.

**It does not echo.** It does now, locally. The modem genuinely does not echo:
the firmware's only character echo is the `out dx, al` at `0xb2ca0` in the
serial ISR, gated on `[d2c3]` bit 3 - which is *Internal*. An external unit
never takes that branch. Raw mode has already turned the terminal driver's own
echo off, so before this a person typed completely blind. `--no-local-echo`
shows the literal stream.

**It looks like it buffers your commands and replays them on Return.** The
receive path is correct - traced over a four-command session, the firmware
consumes exactly the sixteen characters typed, in order, with nothing lost or
repeated. What creates the impression is the two things above and below it:
you cannot see what you type, and the answer arrives seconds later, so it
lands next to whatever you typed since.

**It is slow.** About **9x slower than the real board**: 2.26M instructions a
second against the 20.16 MHz the firmware runs at. A command takes 4-9M
instructions to answer, which is a fifth of a second of emulated time but
three to five seconds of yours. The cost is the per-instruction Python
callback the emulator makes for every instruction executed. Making the
address profile opt-in (`profile=False`, which `--terminal` now selects unless
`--report` asks for it) recovered about a fifth of it; the rest needs the
instruction count to come from somewhere other than a per-instruction hook,
which has not been attempted.

Anything typed before the command task exists is discarded, so `--terminal`
now prints `[command port ready]` on stderr - stdout is the serial stream -
when it stops being discarded.

**It answers `NO CARRIER` a lot.** Every bare `AT` does, and that is the
keypress-abort chain described above, not a fault in the port.

### Open: a response is sometimes re-sent

Typing faster than the modem answers, a previous answer is emitted again
alongside the new one - `ATI3` after `ATI0` produces `USR009F` a second time
before its banner.

This is **not** the UART model. Traced over a session that reproduces it, the
firmware makes 143 THR writes, all from `0xa4f16`, and the host receives
exactly 143 bytes: every byte written is delivered once, and the duplicate
bytes are written twice by the firmware. Something in the firmware's output
path re-sends when a command arrives while it is still transmitting. Not
explained yet.


## The capability record's fields, from the sites that read them

Recovered one field at a time, from the code that consumes each. See
`tools/imodem_capability_record.py` for the page layout these sit in.

### `[d2c6]` - which fields the record carries

Established outright by the unpacker at `0xa4465`..`0xa44ab`: each bit says a
field is **absent**, and the copy is skipped when it is set.

| bit | when clear |
|---|---|
| 0 | walk the options table with `[d2c7]` |
| 1 | `[d2c8]` -> `c8e4` |
| 2 | `[d2c9]` -> `d2c5` |
| 3 | `[d2ca]` -> `d2c4` |

With no record every bit reads 1, so nothing is copied - which is the whole
reason the rest of the block is inert.

### `[d2c7]` - modulation capability

`0xa4476` walks a five-entry table at `a400:04ac` with `lodsw`, testing
`[d2c7]` with the low byte and OR-ing the high byte into the options byte at
`e358`. The table reads `01 04 02 08 04 40 08 80 10 20`:

| `[d2c7]` bit | sets in `[e358]` |
|---|---|
| 0 | `0x04` |
| 1 | `0x08` |
| 2 | `0x40` |
| 3 | `0x80` |
| 4 | `0x20` |

`[e358]` is masked with `0x33` first, so its bits 0, 1, 4 and 5 survive from
elsewhere. **What the `e358` bits are called is not settled**: the harness used
to force this byte, and that turns out to have been dead - the firmware writes
it again at `0xa4446` after the hook and leaves it `0x23`, and sweeping the
forced value over `0x00`..`0xe5` leaves ATI7 printing `V32bis,x2,V.90` every
time. That forcing has been removed. The modulation names it chooses between
live at `0xc0cff`: `NONE`, `HST`, `V32bis`, `Terbo`, `V.FC`, `V34+`, `x2`,
`V.90`.

### `[d2c9]` -> `[d2c5]` bit 0 - fax capability

ATI7's formatter names it. `0xc0d70`..`0xc0d92` tests the bit and picks a
string:

```
c0d70  test [d2c5],1 ; je c0d7c ; mov si,3e87 ; jmp c0d88
c0d7c  test [d2c5],1 ; je c0d98 ; mov si,3e9b ; jmp c0d92
c0d88  test [d2c5],1 ; je c0d92 ; mov si,3eb1
c0d92  call c0b1b                              ; print it
```

and those three strings are `Fax Options<tab>Class 1`,
`Fax Options<tab>Class 2.0` and `Fax Options<tab>Class 1/Class 2.0`. So
**`[d2c5]` bit 0 is "fax fitted"**: set, ATI7 prints a Fax Options line; clear,
it prints none. All three tests read bit 0 - confirmed against the raw bytes,
`f6 06 c5 d2 01` three times - so in this build only `Class 1/Class 2.0` is
reachable and the other two strings are dead.

### `[d2ca]` -> `[d2c4]` bit 0 - the product-name suffix

`0xc0c17` tests it and appends `" MODEM"` to ATI7's product type.

### `[d2c8]` -> `c8e4` - a grouped code, not identified

Its one consumer is `0xbd1a1`, which splits it: repeatedly subtracting 8 into a
quotient at `[d2b0]`, then translating the remainder through a table with
`xlatb` into `[d2b1]`. A group-and-member code of some kind; which one is not
established, and is not guessed at here.

### This does *not* fix `NO CARRIER`, and it corrects the previous section

`[e770]` bit 2 - the flag whose absence routes commands into the
call-termination epilogue - is set at `0xc83d0`, gated on `[d2c5]` bit 0. Now
that `[d2c5]` bit 0 is known to mean *fax*, that site is a fax-mode command:
it parses a `=0` / `=1` / `=2` argument and a `=?` query at `0xc822c`, which is
the shape of `+FCLASS`.

So the chain in the previous section is mechanically right but its conclusion
was not: opening that branch would put the modem in **fax mode**, not repair
the result code. A non-fax modem legitimately takes `0xadc82` into the
epilogue, so the open question is unchanged and is where it always was - why
the epilogue answers code 3 when `[d08b]` is 0, i.e. when nothing disconnected.


## Why the epilogue answers 3 when `[d08b]` is 0

**Literally: because there is no branch for it.** `a8067` answers `0` only when
the cause is exactly 1 *and* `[d2a1] & 0x47`. Every other combination - "no
disconnect recorded" included - falls through `a808c` into `mov al, 3`:

```
a8067  cmp [d08b], 1 ; jne a808c
a806e  test [d2a1], 47 ; je a808c
a8083  xor al, al          ; 0, OK      -> jmp a8098, skipping the 3
a808c  test [ca68], 20 ; jne a80df      ; the only other way out of a808c
a8093  call a45c2
a8096  mov al, 3           ; 3, NO CARRIER
a80d3  call acf8c          ; emit AL
```

and that other way out, `[ca68]` bit 5, jumps *past* the emitter - it prints
nothing at all, not `OK`. So cause 0 is not a case this decision handles. The
decision is only correct where it was meant to run: after a call has ended.

**And it runs after every command.** Counted: one command reaches `a8067`
once, three commands reach it three times. The route is `adb8d call adc32`,
and `adc32` has exactly three escapes from the teardown at `adc82`. All three
setters are now traced, and they are all in the same module, and all three are
gated on **`[d2c5]` bit 0 - the fax bit**:

| escape | set at | gate |
|---|---|---|
| `[e78e]` bit 0 | `0xc824c` | the `=0`/`=1`/`=?` parser at `0xc822c` |
| `[e78f]` bit 0 | `0xc843f` | `0xc840b  test [d2c5], 1` |
| `[e770]` bit 2 | `0xc83d0` | `0xc83ad  test [d2c5], 1` |

So the mechanism is complete: **no capability record -> fax not fitted -> every
escape closed -> every command ends in the call-termination teardown -> cause 0
-> result code 3.**

### What that still does not explain, and what is ruled out

A real non-fax Courier answers `OK` to `AT`, so one of these must be true and
none is settled: a real unit's record has fax fitted; there is a fourth escape
not yet found; or `[d08b]` is 1 on real hardware for a reason not seen here.

Ruled out by measurement, not by argument:

* **Not DTR.** The only site that records cause 1 is `0xa62ae`, in a handler
  whose head is `0xa6279`. That handler is **never entered** - not with DTR
  asserted throughout, not with it dropped and re-asserted, not with it
  dropped and left down. `[d08b]` stays 0 in all three.
* **Not the ISDN line.** `--line-activate` reaches F7 and changes nothing.
* **Not a mis-indexed result table.** `a8083` really does load 0, and 0/1/2/3
  as OK/CONNECT/RING/NO CARRIER is conventional.
* **Not a command-parsing failure.** `ATI3` prints its banner, so commands
  execute; the result code is appended afterwards.
* **Not spontaneous.** With nothing typed, nothing is transmitted at all, so
  the `NO CARRIER` is genuinely the command's result code.


## The gate on the direct `[d08b]` write, and the end of this trail

`0xa629c` writes `[d08b] = 1` directly. Its gate, from `0xa6279`:

```
a6279  test [ca68], 1 ; jne a62b2      ; bit 0 must be clear
a6280  test [ca68], 2 ; jne a62ae      ; bit 1 must be clear
a6287  test [ca68], 4 ; je  a62c5      ; bit 2 must be SET
a628e  cmp  [ca5c], 1 ; jne a62ae      ; and [ca5c] must be 1
a6295  cmp  [d08b], 0 ; jne a62ae
a629c  mov  [d08b], 1
```

`[ca68]` is written as an enum - 1, 2, 4, 0x20, 0x24, 0x80 - and `[ca5c]` is
set to 1 at exactly four sites, `0xa708c`, `0xa7855`, `0xa78aa` and `0xa7c24`,
all in the call-setup region. So `0xa629c` is a **call-time** handler: it
records "DTR dropped" when DTR drops *during a call*. The handler it sits in is
never entered in an idle session at all.

The other writer of `[d08b] = 1` is `ab329` called from `0xa62ae` - inside the
same handler, behind the same gate.

### So the OK branch is call-teardown-only, by construction

That is the whole answer. Presented with the state its OK branch wants, the
decision prints `OK`; presented with the real one, it prints `NO CARRIER`:

| `[d08b]`, `[d2a1]` at `a8067` | a8083 | a8096 | printed |
|---|---|---|---|
| the real idle state, `0`, `0` | 0 | 1 | `NO CARRIER` |
| forced to `1`, `0x01` | 1 | 0 | `OK` |

So the decision is not broken and the result table is not mis-indexed. There is
simply **no route to `OK` for an idle modem in this image**: the only two
writers of cause 1 are both behind a gate that only a live call opens.

### Everything eliminated

Each of these was tested, not argued:

| hypothesis | result |
|---|---|
| a DTR transition records the cause | the handler at `a6279` is never entered, DTR up, down, or toggled |
| the fax capability opens an escape | forcing `[d2c5]` bit 0 changes nothing - the escapes are set by *executing* `+FCLASS`, not by the capability |
| `[d1ea]` is the wrong state | held at every value 0..7; none produces `OK`, and 6 and 7 produce no result at all |
| the ISDN line is down | `--line-activate` reaches F7, no change |
| the result table is mis-indexed | `a8083` demonstrably prints `OK` |
| the command is not parsed | `ATI3` prints its banner |
| it is spontaneous | nothing typed, nothing transmitted |

What is left is a question this repository cannot settle from the image alone:
whether a real Courier I-Modem, with no line and no configuration, also answers
`NO CARRIER` to a bare `AT` - in which case the harness is right and the
expectation was wrong - or whether a real unit reaches a state that skips this
epilogue entirely. Settling it needs a real unit, or a capability record dumped
from one.

The rewrite that used to be in `courier_emu/isdn.py` made `AT` print `OK` by
supplying exactly the two values in the table above. That is the only thing
that ever made it answer `OK`, and it was fiction.
