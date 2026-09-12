# The I-modem's ISDN stack logs itself, in English

Everything else this repository knows about the I-modem's ISDN stack was
recovered by disassembly and inference.  It did not have to be.  **The stack
is instrumented, and the instrumentation is symbolic** - it names the
developers' own primitives, and a run can read it back for the cost of two
memory reads.

```
LINE_ACTIVE Detected
l4_DISCONN : modem primitive
```

That is an `ATDT` in the firmware's own words, and it answers a question three
separate configuration hypotheses had failed to: the dial *does* reach layer
3, and it arrives there as a **disconnect**, not a setup.

## How it works

There is a printer at `0x77fc2`.  Callers pass it a far pointer to a string;
it packs the characters two to a word into a ring at `ds:0xa79a` and keeps the
count of words used at `ds:0xb79a`, appending a CRLF after each entry.

`ds` is `ce0` - the segment the initialiser relocates `0x41c0` bytes into from
image `0x98d50`, which is why every other address in this stack is quoted
against it.  Resolving the string offsets against that block is what turned
`push 0x1594` into `l4_DISCONN : modem primitive`.

It is a **fill-once** log, not a wrap-around one: the guards at `0x78039` and
`0x78051` compare the index against `0x7fd` and `0x7ef` and stop appending.  A
long run's log ends rather than losing its beginning.  Capacity is 2048 words.
Because the characters are packed low byte first, the ring read as raw bytes
is already the text; an odd trailing character is padded with a space by the
`or ax, 0x2000` at `0x77ff6`.

`courier_emu/imodem_trace.py` reads it, and `isdn-run` carries it in every
report as `firmware_trace`.  An index outside the ring reads as empty rather
than decoding whatever is at the address, so a wrong segment says nothing
instead of saying something false.

## The vocabulary

465 strings sit in that block.  A sample of what the ISDN side carries:

```
l4_SETUP : modem primitive          code =l4_SETUP
l4_DISCONN : modem primitive        code =l4_DISCONN
l4_CONNECT : modem primitive        code =l4_CONNECT
l4_DIGIT : modem primitive          code =l4_DIGIT
default : modem primitive           code =l4_CHANGE
                                    code =l4_TXDATA
LINE_ACTIVE Detected                code =l4_BCH_FLOW_OFF / _ON
LINE_NOT_ACTIVE Detected            code =l4_GET_V120
SPID_ERR Detected                   code =N_CONN_IN / N_CONN_CF
MISC_INFO Detected
STAT_OFFHOOK Detected>>>            TEI_REMOVED
STAT_ONHOOK Detected                TEI_REM_INFO
BCH_ENABLED Detected                N202 Cnt Exceeded - no TEI assigned!!!
START_ALERT / STOP_ALERT Detected   TEI ASSIGN msg received with TEI that
L4_DIALDGTS Detected                  had already been assigned => remove TEI
SIGNAL_IND Detected with #          CONNECT REQUEST REFUSED - NO MORE
PROGRESS_IND Detected                 B_CHANNELS AVAILABLE
                                    SETUP not compatible INTL, release call
```

Those names line up with what was already recovered the hard way and confirm
it.  The handler at `0x75882` dispatches a "modem primitive" on a character -
`'@'` logs `l4_SETUP`, `'B'` logs `l4_DISCONN`, `'C'` and `'a'` the others -
and the layer-2 arms at `0x7743c`, `0x7744f`, `0x77468` and `0x77481` are
`SPID_ERR`, `LINE_ACTIVE`, `LINE_NOT_ACTIVE` and `MISC_INFO` respectively.
`0x7744f` setting `ce0:8d7c` is therefore exactly what its name says, which
independently confirms the reading in
[imodem-config-sector.md](imodem-config-sector.md).

## What it says about ATD, and about this harness

Dialling with nothing else going on:

```
LINE_ACTIVE Detected
l4_DISCONN : modem primitive
```

so the AT layer handed layer 3 a disconnect.  Why it chose `'B'` over `'@'`
is the next question, and it is now a question about one dispatch on one
character rather than about the whole stack.

Dialling with the network peer presenting an incoming call first says
something else, and it is about **this repository's peer, not the firmware**:

```
LINE_ACTIVE Detected
LINE_NOT_ACTIVE Detected
default of n_stat_in detected
001A
l4_DISCONN : modem primitive
```

The line goes *down* after coming up.  Nothing in `courier_emu/bri.py`
deactivates it in that run, so either the peer is disturbing the S interface
while it delivers the broadcast frame, or the firmware drops layer 1 in
response to something the peer sent.  `default of n_stat_in detected` with
code `001A` is an unhandled status on top of it.  That is a concrete defect to
chase, and it took one run to find because the firmware said so itself.
