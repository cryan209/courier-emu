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
something else:

```
LINE_ACTIVE Detected
LINE_NOT_ACTIVE Detected
default of n_stat_in detected
001A
l4_DISCONN : modem primitive
```

That was first written up here as a defect in `courier_emu/bri.py`.  **It is
not**, and the way it was ruled out is worth keeping, because "our peer must
be breaking it" is the comfortable answer and it was wrong.

* The peer never touches the line after activation.  A watch on
  `Am79C30.set_liu_state` records exactly three changes in the whole run -
  F1→F2, F2→F6, F6→F7 - all during activation, none near the frame.
* The chip model is not mangling the frame.  35 bytes delivered, **35 bytes
  read back** by the firmware, and DRCR reports 35.
* The firmware re-reads the line itself at `0x71b3d`, computes `(LSR & 7) + 2`
  = **8**, stores F7 - and then raises the status anyway.  Its own stored
  state says the line is up while it reports that it is not.
* It is not the broadcast data link, and it is not the information elements.
  Injecting four different frames and reading the log back separates them
  completely:

  | frame | firmware's verdict |
  |---|---|
  | UI, SAPI 63 / TEI 127, TEI identity check | `LINE_ACTIVE` only |
  | UI, SAPI 0 / TEI 127, payload `00 00 00` | `LINE_ACTIVE` only |
  | UI, SAPI 0 / TEI 127, bare SETUP, no IEs | `LINE_NOT_ACTIVE`, `001A` |
  | UI, SAPI 0 / TEI 127, full SETUP | `LINE_NOT_ACTIVE`, `001A` |

A junk UI down the same broadcast path does nothing.  Only a **valid Q.931
SETUP** does it.  So this is the firmware's own layer 3 reacting to an
incoming call it owns no TEI for, and `001A` is a status code its
`n_stat_in` dispatcher has no arm for - the `default` at `0x774ac`.

### What was actually wrong with the peer

Chasing it did find two real defects, both of which made the firmware's
behaviour harder to read rather than causing it:

* **No T303.**  The peer sent one SETUP and then reported `call_state:
  call-present` for the rest of the run, so a call nobody took looked like a
  call in progress.  Q.931 has the network retransmit once after four
  seconds and then clear.  It does now, and says so.
* **No notion of the line going down underneath it.**  The peer only ever
  read back the state it had set, so had the firmware deactivated its LIU the
  peer would have gone on reporting a data link that could not exist.  It now
  notices, drops its layer-2 and call state, and does not walk the line
  straight back up - re-activating would hide exactly the behaviour worth
  seeing.

Both are covered by `tests/test_bri.py`.  Neither changes the trace above,
which is the point: the firmware was never reacting to them.
