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
* **The bearer has to be unrestricted digital.**  `--bri-bearer speech` to the
  same number gets `SETUP with result= FFFE` and `NO CARRIER` at the DTE.
  `--bri-bearer data` gets `0000` and rings.

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

## What that makes the frontier

The chain from an incoming call to a routed B channel is now complete and
observable at every joint: line, TEI, data link, called-number match, bearer,
RING, `ATA`, CONNECT, `BCH_ENABLED`, MCR, and a bearer command built and
posted.  The single missing joint is the last one:

**what the DSP is waiting on in that loop, and what would return it to the
dispatcher at `85c6` so the `5e` command is taken.**

Two honest possibilities, and this page does not choose between them:

* the overlay is waiting for something the board provides and this harness
  does not, in which case the thing to find is what sets the bit it tests;
* the overlay is waiting for the `5e` command itself to be delivered some
  other way than the polled dispatcher - an interrupt the host raises, which
  the model does not raise because nothing has shown it exists.

Inventing either one would produce a modem that appears to talk.  The counters
above are what tells them apart, and they are cheap to read: `bri.media`'s
`tx_non_ff`, the mailbox's `consumed` against `committed`, and port `57h`'s
read count before and after the command.
