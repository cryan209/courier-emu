# Putting a network on the I-modem's S interface

[imodem-d-channel.md](imodem-d-channel.md) brought layer 1 up and
[imodem-config-sector.md](imodem-config-sector.md) gave the modem a real
configuration, and both ended in the same place: the modem never transmits a
layer-2 frame, so layer 2 never starts.  The reason turns out to be simpler
than the pointer chase that page ended on.  **There was nobody on the line.**

A BRI terminal does not talk to itself.  On a point-to-point line it waits for
the network to establish the data link; on a multipoint line it asks for a TEI
when it has traffic.  Either way the first move belongs to the far end, and
this repository had no far end.

`courier_emu/bri.py` is one.  It is not a model of anything on the board - the
board's side is the Am79C30A and the firmware - it is a peer, built from Q.921
and Q.931, and it reaches the modem only through the chip's own receive and
transmit buffers, `deliver_frame` and `take_sent`.  It never writes the
modem's memory and never pokes its registers, which is what keeps it evidence
rather than a stand-in.

```sh
.venv/bin/python -m courier_emu isdn-run Ie030002.nac \
    --instructions 60000000 --line-activate 3000000 --bri-network
```

`--bri-establish network|terminal` chooses which end establishes,
`--bri-tei` the TEI the network addresses, and `--bri-call-at` places a call
at the modem.  The run reports everything the peer did under `bri`.

## What the peer speaks

* **Q.921** - address decoding for SAPI and TEI, the U, S and I formats,
  TEI assignment on SAPI 63 / TEI 127, multiple-frame establishment with
  SABME/UA, N(S)/N(R) accounting, RR and REJ, and T200 with N200
  retransmissions.
* **Q.931** - SETUP, CALL PROCEEDING, ALERTING, CONNECT, CONNECT
  ACKNOWLEDGE, DISCONNECT, RELEASE, RELEASE COMPLETE, and the information
  elements those carry: bearer capability, channel identification, called
  and calling party number, cause.

`tests/test_bri.py` checks the encodings against the standards, including the
one asymmetry that is easy to get backwards - Q.921 gives the C/R bit
opposite senses on the two sides, so the same octet is a command from the
user and a response from the network.

## What it found, on the first run

With a record whose switch protocol is ETSI NET3 and a point-to-point line,
the peer sends SABME to TEI 0 and the modem does not answer.  It is not
ignoring it: the chip's counters show the frames arriving, and a trace shows
the firmware reading every byte of them.

The receive path is fully accounted for now:

| where | what it does |
|---|---|
| `0x72e1e` | the ISR's receive loop - DCRB into a buffer, DSR2 bit 0 for the last byte and bit 1 for more waiting |
| `0x72eac` | `test [bp-2], 0x7b` - the DER error check; a frame with any of those bits is dropped here |
| `0x72f07` | posts the frame up as **message `0x33`** |
| `0x6674c` | the Q.921 entity's receive handler, reached from the dispatcher at `0x66734` |

and so is the validation the entity does, which is where our SABME dies:

```
667b1  test es:[bx+1], 1      ; octet 2's EA bit must be set
667ba  cmp [bp-0x16], 3       ; at least three octets
667d4  sar ax, 2              ; SAPI  = octet 1 >> 2
667e0  sar ax, 1              ; TEI   = octet 2 >> 1
667e9  SAPI must be 0, 2, 0x10 or 0x3f, else discard
66814  cmp dl, 0x7f           ; TEI 127 goes to TEI management
668a2  lcall 6757:2fe         ; otherwise look the data link up
```

and the lookup at `0x6786e` walks a six-byte-per-entry table at `[0x6b88]`,
indices 3 to 12, matching the interface id, the SAPI and the TEI, with two
further passes that accept `0xfe` and `0xfc` as wildcards.  **No entry
matches SAPI 0 / TEI 0**, so the frame is discarded and the modem is right to
stay silent: it is configured for automatic TEI assignment, so it does not
own TEI 0 and a network addressing that TEI is addressing nobody.

That is a real answer to the question the previous page left open, and it
replaces the hypothesis there.  The transmit path at `0x71cb0` is not
unreachable through some missing pointer; it is simply never asked, because
no data link exists.

## What is still open

Two things stand between this and a call, and both are on the modem's side of
the configuration rather than the peer's:

* **The modem does not request a TEI on its own.**  Configured multipoint
  (`AT*M=1`) with automatic TEI (`AT*T1=0`), with the peer waiting in
  `--bri-establish terminal`, it sends nothing.  A TE asks for a TEI when it
  has traffic, so the trigger should be a call.
* **`ATD` is refused before it reaches layer 2.**  It answers `NO CARRIER`
  immediately with no D-channel activity at all.  `ATI12` still reports
  `Dialing Mode *O  Invalid Value`, and `*O=n` is in the firmware's own help
  page, so the next step is to find what it accepts - `AT*O=0` was dropped at
  the pace these runs send at, rather than rejected.

Also worth writing down, because it cost a detour: the ISDN block's TEI field
is at **index 88**, two ASCII characters, not the index 86 that
[imodem-config-sector.md](imodem-config-sector.md) lists.  `AT*T1=0` followed
by `AT&W` stores `30 30` there, which `ATI12` reads back as `Automatic TEI`.

## The store makes this repeatable

None of the above needs a sector cut out by hand any more.  `isdn-run` keeps
the part's non-volatile region - the 32 KiB above the update payload, which
is the three top boot sectors - in `flashnvram.sav` between runs, so a
session that types settings and `AT&W` leaves them there for the next one.
`--no-flash-nvram` runs against an erased store.
