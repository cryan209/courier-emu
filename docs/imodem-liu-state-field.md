# LSR's state field, and the one value the whole stack hangs on

The layer-1 decode in [imodem-d-channel.md](imodem-d-channel.md) read `LSR`'s
low three bits as an I.430 F-state biased by one, and concluded that
`LSR & 7 = 6` is the activated line.  **It is 5**, and the difference is the
whole of layer 2.

## How the firmware settles it

The firmware stores `(LSR & 7) + 2` in a byte per interface at `ce0:a458` and
then compares that byte in seven places.  Six of them want **7**:

```
6590c  cmp byte [bx-0x5ba8], 7
67d76  cmp byte [bx-0x5ba8], 7
67e15  cmp byte [bx-0x5ba8], 7
6a932  cmp byte [bx-0x5ba8], 7      ; the TEI entity
71c9b  cmp byte [bx-0x5ba8], 7      ; the D-channel transmit gate
70f50  cmp byte [bx-0x5ba8], 4      ; the resting state
71da4  cmp byte [bx-0x5ba8], 2      ; the reset state
```

The transmit gate is the one that matters
([imodem-d-channel-transmit.md](imodem-d-channel-transmit.md)): a queued
frame goes out only when the byte is 7, or when a permission flag is set that
nothing in a run ever sets.  Storing 8 means every frame is dropped - which is
exactly what had been happening.

So the chip's LIU state numbering is its own, not I.430's, and the activated
value is 5.

## The proof is the stack running

Driving the line to `LSR & 7 = 5` instead of 6 changes nothing else in the
harness and produces this, from a run that asks for an incoming call:

```
20029952  ID_REQUEST ref 11883: assigning TEI 64
20035072  SABME from TEI 64, answering UA
          layer 2: multiple-frame-established
```

the modem transmitting three frames where it had transmitted none in every
run before it.  `ATI12` agrees, in the firmware's own words:

```
   Physical Interface:  Active
   Data Link Layer   :  Active
```

and the firmware's trace log shows it taking the call:

```
LINE_ACTIVE Detected | --SETUP | SETUP with result= | START_ALERT Detected
```

with `RING` arriving on the AT interface.

## What the old value was

`LSR & 7 = 6` stores 8, and the firmware treats that as **not** activated: its
log prints `LINE_ACTIVE Detected` and then `LINE_NOT_ACTIVE Detected` for the
same line, which is what
[imodem-firmware-trace.md](imodem-firmware-trace.md) recorded as an unexplained
teardown and briefly blamed on this repository's own peer.  It was not the
peer and it was not the frame: it was the line being driven to a state the
part does not use for an active interface.

## The table

`courier_emu/am79c30.py` carries it as a table rather than a formula, because
the chip has fewer LIU states than I.430 has F-states and a formula would be
inventing the gaps:

| state | `LSR & 7` | firmware stores | evidence |
|---|---:|---:|---|
| F1 | 0 | 2 | shown - the reset state tested at `0x71da4` |
| F2 | 1 | 3 | shown - what the machine at `0x62a27` polls out of |
| F3 | 2 | 4 | assumed - the resting state the dispatch ignores |
| F6 | 4 | 6 | assumed - one below activated |
| F7 | 5 | 7 | **shown** - and the whole stack depends on it |
| F8 | 6 | 8 | shown to be a state the firmware calls not active |

## What it leaves

Layer 2 comes up and a call is delivered, so the standing blocker is gone.
What the firmware says about the call itself is a smaller, later question:

```
SETUP not compatible INTL, release call
```

- it rings, and then releases the call as incompatible, which is a bearer
capability or progress-indicator question in the SETUP this repository's peer
builds, not a layer-2 one.
