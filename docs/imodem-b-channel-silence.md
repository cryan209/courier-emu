# The B channel is silent, and the modem is the one keeping it quiet

[imodem-bri-network.md](imodem-bri-network.md) put a network on the S
interface and left the bearer deliberately unjudged: the peer counts the
octets it captures and refuses to call `ff` silence, because on an opaque
64 kbit/s channel `ff` is a byte like any other.

It is silence.  A whole answered call's worth of it - **156,456 captured
octets, none of them anything but `ff`** - and this page follows it back to
the one thing that produces it.

## The call, end to end

The run is an incoming call the modem answers:

```sh
.venv/bin/python -m courier_emu isdn-run Ie030002.nac --with-dsp \
    --no-flash-nvram --instructions 80000000 \
    --bri-network --bri-establish terminal \
    --bri-call-at 20000000 --bri-call-to 7349195 \
    --bri-rx-g711 far-end.g711 --bri-tx-g711 modem.g711 \
    --send ATA --send-after 30000000
```

and it goes all the way, which is new:

```
ID_REQUEST ref 16399: assigning TEI 64      RING on the AT interface, three times
SABME from TEI 64, answering UA             ATA
SETUP to the modem from 5551000             ALERTING, then CONNECT
```

with the firmware's own log agreeing at every step:

```
LINE_ACTIVE Detected | --SETUP | SETUP with result= | 0000 | END of INTL_TYPE
Just Sent IC SETUP | Prim = N_CONN_IN : | l4_CONNECT : modem primitive
BCH_ENABLED Detected
```

Q.931 reaches Active, the peer binds media to B1, and the Am79C30's MUX is
programmed for it - `MCR1 = 16h`, which is **B1 <-> Bd**, the peripheral port
the DSP sits on.  157,047 frames are routed through that connection.  Every
one of them carries `ff` out of the modem.

## Two things had to be right before the call would happen at all

Both cost a run each, and both are the modem's configuration rather than the
peer's:

* **The called number has to be the modem's own.**  The stored directory
  numbers are `7349195` and `7349196`, at `ce0:8e84` and `ce0:8e99` - the two
  entries of a `0x82`-stride block.  A SETUP for anything else is refused at
  `0x5c292`, which calls the comparison at `0x5bb3e`, gets a negative answer,
  emits RELEASE_COMPLETE with **cause 88, incompatible destination**, and logs
  its own verdict as `CDN failure`.  That is the whole of the refusal
  [imodem-liu-state-field.md](imodem-liu-state-field.md) ended on; it is not
  the bearer capability.
* **The bearer has to be one the modem takes.**  `--bri-bearer data`, an
  unrestricted 64 kbit/s call, gets `0000` and rings, and that is the call this
  page follows.  `--bri-bearer speech` used to get `SETUP with result= FFFE`
  and `NO CARRIER`, which was read here as the bearer class being refused.  It
  was not: it was **A-law**.  Offered as mu-law the same modem rings on speech
  and on 3.1 kHz audio, answers as a modem, and puts ANSam on the bearer - see
  [imodem-audio-bearer.md](imodem-audio-bearer.md).

The peer now prints the cause it is given, so neither of those has to be
chased through a disassembler again:

```
RELEASE_COMPLETE call reference 1, cause 88 incompatible destination
```

## Where the silence comes from

Not the chip, and not the routing.  The DSP.

The C5x writes its serial transmit register every 8 kHz frame - 212,601 writes
- and the value is `ffff` every time.  The octet on B1 is the low byte of it,
so the modem transmits the idle codeword for the whole call.  Injected
network-to-terminal audio reaches the other side of the same register: the
8,000 octets of `--bri-rx-g711` are delivered, routed, and consumed, and
nothing observable comes back out.

The reason is one command that is never taken.

[imodem-ceml4.md](imodem-ceml4.md) established that `BCH_ENABLED` ends in
DSP command **`005e`** with the bearer selector as its argument.  The firmware
does send it - the mailbox shows `5e 0001` posted, at the right moment, for
the right channel.  It is the twentieth command of the run and **only
nineteen are consumed**.

The DSP stops listening one command earlier.  Every command up to and
including `62 0004` is delivered while the resident is at IDLE and is
acknowledged; the resident's dispatcher polls port `57h` to find them, and it
polls it 239,343 times before that point.  While handling `62 0004` the DSP
leaves IDLE for overlay code at `e8ba..e8de`, and from that instruction to the
end of the run - some 26 seconds of call - it reads port `57h` **exactly zero
more times**.  The mailbox's command byte is still sitting in the latch when
the run ends.

```
0xe8ba  splk  @7d, #0000        the loop the DSP runs instead
0xe8bc  splk  @7e, #0000
0xe8be  call  ....
0xe8c0  xc    2, ntc
0xe8c1  lacl  @79
0xe8c2  sacl  @7f
0xe8c3  bcnd  ...., ntc
0xe8d7  lamm  @0e
0xe8d8  sub   @7c
0xe8d9  bitt  *
0xe8da  xc    2, eq
0xe8dd  lamm  @0e
0xe8de  retd
```

- a called routine, entered and returning, over and over, testing a bit in
data memory.  It is real downloaded overlay code doing real work; what it is
not doing is going back to the resident's dispatcher.

## What the loop is waiting on

It is an **HDLC flag hunt**, and reading it back settles both what it wants and
why it can never get it.  `NativeC5x.program()` reads a downloaded overlay out
of the core - nothing on the host side keeps a second copy - so the thing the
DSP is actually running can be disassembled:

```
e8ac  splk  @7d, #e8b6
e8b1  splk  @7f, #0009      ; nine flags before sync is declared
e8b6  call  e8d7            ; one bit
e8b8  bcnd  e8ac, tc        ; a 1 here is not the leading zero: start over
e8ba  splk  @7d, #e8be
e8bc  splk  @7e, #0006      ; six ones
e8be  call  e8d7
e8c3  bcnd  e8ba, ntc       ; a 0 breaks the run: start over
e8c5  lacc  @7e / sub #01 / bcnd e8be, gt
e8ca  splk  @7d, #e8cc
e8cc  call  e8d7
e8ce  bcnd  e8ac, tc        ; a seventh one is an abort, not a flag
e8d0  lacc  @7f / sub #01 / bcndd e8b6
```

Zero, six ones, zero - `01111110` - nine times over.  `@7d` holding `e8b6`,
`e8be` or `e8cc` is a resume address, so this is a coroutine: it is written to
be re-entered a bit at a time and to hand control back, not to spin.

The bit source is the helper it calls:

```
e8d7  lamm  @0e             ; TREG2, the bit pointer
e8d8  sub   @7c             ; @7c = 7
e8d9  bitt  *               ; bit TREG2 of the word at *AR1
e8da  xc    2, eq
e8db  pop / ret             ;   TREG2 == 7: the byte is spent, unwind a level
e8dd  lamm  @0e
e8de  retd / sub #01 / samm @0e   ; otherwise step the bit pointer down
```

`AR1` is `0x0889`, and `@7c` is 7 - the pointer is meant to walk **15 down to
8**, the top half of a sixteen-bit word, and unwind when it runs out so the
level above can fetch the next one.

## And why it never gets it

`0x0889` is filled by the resident, at the splitter that takes one received
serial word apart:

```
80d9  lacl  *, ar1          ; the received word
80da  sacl  @0b             ; 0x088b
80db  apl   @0b, #00ff      ;   low octet
80dd  bsar  8
80de  sacl  @09             ; 0x0889 - high octet
```

That splitter is in the resident, on the same background path as the mailbox
dispatcher that polls port `57h`.  **It stops when the overlay loop starts**,
and the counters say so exactly: `0x0889` takes 57,187 writes, the last of them
from the overlay at `eb3f`, and across the whole 26-second call after the `5e`
command it takes **none**.  The cell the flag hunt reads is frozen at whatever
was in it when the background loop stopped running.

The receive path itself is fine, which is what makes this precise rather than
vague.  Octets keep arriving all through the loop - the interrupt side fills a
ring at `0x0bd0..0x0bde`, 4,491 writes to each of its eight words, with the
pointers at `0x0390`/`0x0391` - and feeding the peer `7e` instead of a sine
wave turns every word of that ring into `007e`.  The bytes are there.  Nothing
carries one to `0x0889`, because the thing that would is the loop's own caller.

So the deadlock is complete and symmetrical: the flag hunt waits for a byte the
background loop supplies, the background loop cannot run until the flag hunt
returns, and the `5e` command waits behind both.  `TREG2` shows it directly -
3,186,292 writes during the loop, free-running downward through all sixteen bit
positions instead of being reloaded to 15 per byte, because the per-byte level
that would reload it is never reached.

The `ff` on the wire, meanwhile, is deliberate.  The overlay picks its own idle
codeword at `e8e9` and `e909` - `splk @21, #00ff`, DXR - choosing between `ff`
and `7f` on a flag bit.  A modem whose HDLC receiver has not synchronised
transmits mark idle, which is exactly what the capture contains.

## Two time slots per frame, which the model now clocks

The firmware programs the serial port with **`SPC = 40c8`**, and `FO` - bit 2,
per the C5x user's guide table 9-13 - is **0**: sixteen-bit word format.  That
is not a new reading.  [quad-dsp-pcm-path.md](quad-dsp-pcm-path.md) already
separates the two products on exactly that bit, the Quad's `40cc` against the
302's `40c8`, and says in as many words that the 302 moves sixteen-bit words.
The core had it the other way round - a comment claiming byte format, and one
octet per frame in the low byte with the high byte left zero.

The firmware says the same thing twice more.  Its splitter at `80db..80de`
takes *two* octets out of one received word, and the flag hunt's `@7c = 7`
terminator is the bit index where the top half of a sixteen-bit word ends.
Sixteen bits every 125 us is 128 kbit/s: **two eight-bit peripheral-port time
slots**, where one B channel is 64.

So the boundary is now modelled as the part runs it:

* `native/c5x_core.cpp` reads `FO` out of `SPC` instead of assuming it.  `FO=1`
  keeps one octet per frame, which is the Quad's path and is untouched.  `FO=0`
  exchanges a whole sixteen-bit word - **MSB first, so the frame's first time
  slot is the high byte at both ends**, which is what decides the mapping
  rather than a preference.
* `Am79C30.peripheral_slots()` says which logical channel each slot carries.
  It takes them in the order the MCRs list their connections, MCR1 first.
  `PPCR1` (`07` here) and `PPCR2` are recorded and *not* decoded: nothing in
  the image has shown what their fields mean, and a slot map invented from
  them would be a guess wearing a datasheet's clothes.
* `ImodemDsp._sync_pcm` exchanges one MUX frame per pair of octets, so B1 still
  carries one octet per 125 us and stays 64 kbit/s.  An odd octet at the end of
  a scheduler slice is half a frame and waits for its other half.

A modem call programs `MCR1 = 16h` and nothing else, so B1 takes the first slot
and the second is unconnected.  The run now shows `DRR = 7eff`: the far end's
flag octet in the high half, from `Bd`, and the idle codeword in the low half,
from a slot the MUX has nothing on.  `0x0889` - the cell the flag hunt reads -
holds `007e` where it used to hold zero, and the report names the slots:

```
pcm   slots ['Bd', None]   frames 144798   octets 289596
dsc   peripheral_slots [6, None]   routes [[1, 6]]
```

one `DRR` read and one `DXR` write per frame, which is what a sixteen-bit port
should do.

This does not move the deadlock, and was not expected to: the flag hunt still
cannot get a second byte, because the cell is refilled by the background loop
it is blocking.  What it does is remove the doubt about *which* byte, so the
question above it is the only one left.

## Why the byte-ready test never fired: TREG2 was not a register

The flag hunt is a coroutine and it has a driver, at `e63a`, which does exactly
what a coroutine driver should:

```
e63a  lacc  #000f
e63c  samm  @0e        ; TREG2 = 15 - start at the top bit
e63d  lacc  #0007
e63f  sacl  @7c        ; stop after bit 8: the high byte, eight bits
e640  lacl  @67 / sacl @7e     ; restore the hunt's saved counters
e642  lacl  @69 / sacl @7f
e644  lacl  @65 / sacl @7d     ; @65 is where it got to last time
e646  cala                     ; run it
e647  lacl  @7d / sacl @65     ; and save where it got to this time
```

with the second stream immediately after it at `e64f`, `@7c = 8` - seven bits
rather than eight, the same 7/8 choice the initialiser at `e8ec` makes.

So the byte-ready test is not a gate that fired early.  It is `TREG2` counting
down from 15 to `@7c` as the hunt eats the byte, and the `pop; ret` that trips
on it is how the hunt gets back to its driver: the helper was `call`ed, so
discarding its return address and returning lands on the driver's.  The whole
per-frame cycle is the resident splitting a word, calling the handler the
overlay installed at `0x088c`/`0x088d`, that handler at `eb39` bit-reversing
the octet and chaining on, the hunt eating eight bits, and `pop; ret` bringing
control home.

It never came home because **`TREG2` was only half a register in this core**.
The write side of `cpuregs_w` bound TREG1, TREG2 and DBMR; the read side of
`cpuregs_r` bound TREG0 and stopped.  `lamm @0e` therefore read a dead data
cell rather than the register `samm @0e` had just written - the exact split the
comment above `case 0x0c` warns about, left half-applied.

The consequences line up with every symptom on this page.  `lamm @0e` returns
0, `sub @7c` is -7 and never equal, the `pop; ret` never executes, and
`samm @0e` writes `0 - 1 = ffff` back every single time - so `bitt` tested bit
15 of the byte, over and over, for 3,186,292 iterations, while the counter it
was waiting on never moved.  Binding the read side is four lines.

## What it does when the register is whole

Everything downstream of it unblocks at once:

```
bri.media   tx_non_ff 6937 of 46608      the B channel stops being silent
mailbox     23 / 23 consumed             the 5e command is taken
```

and the octets are not noise - they are **`7e`, HDLC flags**, 6,937 of them in
an unbroken run once the receiver synchronises.  The modem answers, syncs on
the far end's flags, and idles the link with its own, which is what a V.120
terminal does after CONNECT.

Given longer, the call finishes properly too.  The far end here only replays
flags - the peer does not speak anything above HDLC on the B channel yet - so
the modem waits, gives up, and clears down in its own words:

```
BCH_ENABLED Detected | l4_DISCONN : modem primitive | Prim = N_DISC_CF :
```

`NO CARRIER` at the DTE, the call cleared, the mailbox drained 39 of 39, and
the DSP back at IDLE.  A whole call, from SETUP to hangup, with the bearer
running underneath it.

## What that makes the frontier

The chain from an incoming call to a routed B channel is now complete and
observable at every joint: line, TEI, data link, called-number match, bearer,
RING, `ATA`, CONNECT, `BCH_ENABLED`, MCR, and a bearer command built and
posted.  The single missing joint is the last one:

**what the DSP is waiting on in that loop, and what would return it to the
dispatcher at `85c6` so the `5e` command is taken.**

That is answered above, and the answer was in this repository's core rather
than in the firmware: a memory-mapped register bound for writing and not for
reading.  The modem was never waiting on the board.  It was waiting on a
counter that could not count.

What is open now is a floor higher.  The bearer carries HDLC and the modem
frames it, but the peer at the other end of the B channel replays whatever
file it was given, so nothing above the framing is answered and the call
clears on a timeout.  `courier_emu/v120.py` is that far end now - HDLC, the
logical link identifier, and Q.921's procedures on the bearer - and
[imodem-v120.md](imodem-v120.md) records how far it gets: the frames go out
correctly framed and the modem does not answer them, which makes the remaining
question a protocol one rather than a hardware one.

Inventing a wake-up instead would produce a modem that appears to talk.  The
counters are what tells the difference, and they are cheap to read:
`bri.media`'s `tx_non_ff`, the mailbox's `consumed` against `committed`, port
`57h`'s read count before and after the command, and the write count on
`0x0889`.
