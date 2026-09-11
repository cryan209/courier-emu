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

## Why a bare `AT` answers `NO CARRIER`

It is not a mis-indexed result table.  `ATI2` answers a plain `OK`, so index 0
is reachable; the firmware asks for index 3 deliberately.  The chain is short
and every step is named by the firmware's own text.

**Where the code is chosen.**  Commands that fall through to the go-idle
epilogue at `a8000` end at:

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

So `OK` needs the cause to be **1** and a second flag set.  In a run the cause
is `0x17` and `[d2a1]` is `0`.

**Where the cause comes from.**  `ab329` is a helper that pops its return
address, reads one inline byte after the call, and stores it in `[d08b]` -
but only if `[d08b]` is still zero, so the first writer wins:

```
ab329  pop ax ; xchg si,ax ; push ax ; cld
ab32d  lodsb cs:[si]                   ; the inline cause byte
ab32f  or byte ptr [ca57], 80
ab334  cmp byte ptr [d08b], 0
ab339  jne ab33e
ab33b  mov byte ptr [d08b], al
```

The site that records `0x17` is `a4e1e`:

```
a4e0e  test byte ptr [e753], 2
a4e13  je a4e17
a4e15  clc ; ret                       ; nothing recorded
a4e17  cmp byte ptr [d1ea], 6
a4e1c  jge a4e22
a4e1e  call ab329
a4e21  db 17                           ; the cause
```

**And `a4e0e` is the received-character callback.**  `a4de5` and `a4dfb` load
`[c922]` with `0e0d` - `a400:0e0d`, the `ret` immediately above this routine -
and `[c922]` is what the serial ISR's received-data handler at `b2c8d` calls
for every character.  So typing is what records the cause.

**The firmware names `0x17` itself.**  `ATI6` prints
`Disconnect Reason is Keypress Abort`, and the reason table at `0xc1abb` -
`DTR dropped`, `Escape code`, `Loss of Carrier`, ... - puts **Keypress Abort**
at index 23 = `0x17`, with `DTR dropped` at the index 1 that `OK` requires.

So the firmware is doing something sensible: a keypress aborts a call attempt,
and the epilogue reports the abort rather than `OK`.  What is wrong is the
state it is in when an idle `AT` reaches that path.  The harness now recognizes
only the impossible idle combination (cause `0x17` with no call-state flags)
and presents the epilogue with its idle `cause=1, flags=1` state, so a plain
`AT` returns `OK` without hiding genuine disconnect causes.

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

**An open contradiction.** The identifier string ends `INT`, and the whole
device only makes sense for the internal ISA card, yet `[d2c3]` reads `0x08`
on this path and ATI7's formatter at `0xc0be0` calls bit 3 External. Either
the guessed loopback wiring at port `0x14` selects the internal branch, or bit
3 does not mean what that formatter comment says. This is not resolved, and it
matters: the Courier I-Modem this repository targets is an external desktop
unit, so a wiring that lands on the internal ISA card is suspect.

### What is still needed

Three separate things, now that they are separable:

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
