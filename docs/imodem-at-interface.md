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
`send_serial` / `take_serial`.  SIO1's interrupt line is **not** recovered -
the only other master line the firmware unmasks is IRQ6, and its vector
reaches `a520a`, which services ports `0x00` and `0x0a` rather than a UART -
so SIO1 is left pollable and silent rather than wired to a guess.

Two details are worth knowing before reading a transcript.

**The line rate matters.**  Received bytes are released one per
`RX_INSTRUCTIONS_PER_BYTE` (20,000, a harness choice - there is no recovered
board clock to convert bit times into instructions).  This is not cosmetic:
with `--serial-pace 0` a line arrives as one burst of interrupts and some
commands stop answering.  `ATI0` answers only when the characters are spaced
out.

**The firmware transmits with bit 7 set.**  It programmes the part for eight
data bits and no parity (`LCR = 0x03`, divisor 80) and then marks the eighth
bit in software, so `USRobotics` goes out as `d5 d3 d2 ...`.  The console
masks it for display; `serial_a` in the report is the raw stream.

The firmware also swallows the first line it is given without answering it,
so a scripted session should open with a throwaway `AT`.

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
state it is in when an idle `AT` reaches that path.

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
