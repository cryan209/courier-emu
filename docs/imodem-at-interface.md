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

## Open: bare `AT` answers `NO CARRIER`, not `OK`

`ATI3` is correct and repeatable.  A bare `AT`, `ATZ`, `ATE1` and `ATV0` all
answer `NO CARRIER` - result code 3 from the table at `0xcef4b`
(`OK / CONNECT / RING / NO CARRIER / ERROR`) where code 0 is expected.
`ATV0` does not take effect either; the next answer is still verbose.  With a
longer script the answers also stop arriving one per command: `AT ATV0 AT AT
ATE1` produces two `NO CARRIER`s, and `AT AT ATI3 ATI0 ATI1` produces four
answers for five commands, one of them the banner prefixed to `ATI1`'s
`A190`.

This is unaffected by `--serial-signals` (all three deasserted behaves
identically), so it is not the modem-status inputs.  Whether the parser is
mis-framing the line, or the call-control layer is genuinely reporting
carrier loss because the ISDN front end is unmodelled
([imodem-isdn-front-end.md](imodem-isdn-front-end.md)), is not settled here.
The next thing to do is find the producer of the result code - the routine
that indexes the string table - and log its argument.

What is established is the transport: the firmware receives what is typed,
parses it, and transmits firmware text in reply.
