# The I-modem's D channel, and bringing its line up

[imodem-isdn-front-end.md](imodem-isdn-front-end.md) identified the Am79C30A
and modelled its indirect register file, and left three ports in the same
window unaccounted for - `0302`, `0303` and `0307` - and the S interface
inactive, which is why `ATI12` answered:

```
   Physical Interface:  Inactive
   Data Link Layer   :  Inactive
```

Both of those are now closed on the layer-1 side.  The line comes up, and the
firmware says so itself.

## The interrupt line is IRQ14, and its handler names every port

Nothing about this is inferred from the part's datasheet.  Vector `0x2e` -
slave IRQ14, since the slave's ICW2 is `0x28` - reads back `4030:02f8`, a stub
that far-calls `71d7:000f`.  That routine is a D-channel interrupt service in
full view:

```
71ec0  in 0300                  read IR, the interrupt register
71ed5  test al, 2f              loop while bits 0,1,2,3 or 5 are set
71d97  test [bp-4], 20          bit 5: the line state changed
71dff  test [bp-4], 1           bit 0: the transmit buffer wants more
71e48  test [bp-4], 2           bit 1: a received byte is waiting
71eaf  test [bp-4], 0c          bits 2,3: D-channel status and error
```

with `0304` read for received bytes and `0307` for the byte-by-byte status
underneath it, and `0302`/`0303` read by the status handler at `72caf`.  That
is the Am79C30A's direct register map exactly - CR/IR, DR, DSR1, DER,
DCTB/DCRB, the two B-channel buffers, DSR2 - which settles the three unknown
ports and is a second, independent confirmation of the part.

`0305` and `0306` are never touched anywhere in the image.  The B channels are
routed by the MCRs to the peripheral port and reach the DSP; they do not pass
through the host interface, which is consistent with what
[isdn-vs-analog-dsp.md](isdn-vs-analog-dsp.md) found from the other end.

## What each path does

| path | where | what the firmware does |
|---|---|---|
| transmit | `71cb0` | write LPR, push bytes to DCTB while DSR2 bit 4 says there is room, then write the frame's **total length** to DTCR as two bytes.  Writing DTCR is what arms the frame. |
| receive | `71e64`, again at `72e1e` | read DCRB, then DSR2: bit 1 says another byte waits, bit 0 says the byte just read ended the frame.  Then read DER for the frame's errors and DRCR for its length, and pass the frame up only when `DER & 0x7b` is clear. |
| line state | `70e6f` | read LSR, take `(LSR & 7) + 2` as the interface state, and on a change dispatch through a six-entry table at `70f7e`. |

The line-state decode is the useful one, because the bias gives the encoding
away.  Adding two to a three-bit field puts the range at 2..9, the table covers
2..8 with one entry - the resting state - notifying nobody, and the entry
reached for `LSR & 7 = 6` is the one that tells layer 2 the line came up.  That
is I.430's F1..F8 numbered from 2, so **LSR bits 2:0 carry the F-state, biased
by one**.

## Layer 1 will not take a shortcut

The state the firmware keeps is a byte per interface at `ce0:a458`, and it is
not written by the interrupt handler.  The handler notifies the layer-1 machine
at `6296f`, which dispatches **on the state it is already in** - a seven-entry
table at `62e3f` - and only then on the event.  In F1 the event table at
`62e33` covers events 0 to 5, and the activation event is 6, so an interface
handed F7 straight out of F1 drops the event on the floor and the stored state
never moves.  A run that does exactly that leaves `ce0:a458` at `02`.

Walked in order - F2, then F6, then F7 - it reaches `08`, the firmware's number
for F7, and `ATI12` changes its mind:

```sh
.venv/bin/python -m courier_emu isdn-run Ie030002.nac \
    --instructions 70000000 --line-activate 3000000 \
    --send AT --send AT --send ATI12 --send-every 20000000
```

```
   Physical Interface:  Active
   Data Link Layer   :  Inactive
```

That is the firmware's own diagnostic reporting the modelled line, which is the
check on the decode above: nothing in `courier_emu/am79c30.py` writes the
string, and nothing pokes `ce0:a458`.

## Modelled

`courier_emu/am79c30.py` now carries the direct registers alongside the
register file:

* **LIU** - an F-state the harness sets, reported through LSR in the biased
  encoding, raising IR bit 5 on a change.  `set_liu_state`, `activate`,
  `deactivate`.
* **DLC receive** - `deliver_frame` queues a frame; the bytes come out of DCRB
  with DSR2's byte-available and last-byte bits, DSR1's frame-end bit, DER
  clear and DRCR carrying the length.  Frame boundaries and lengths are kept
  per frame, so two queued frames do not run together.
* **DLC transmit** - bytes written to DCTB accumulate, and writing DTCR closes
  the frame at the length it names.  `take_sent` collects them.  A length that
  disagrees with the bytes pushed is **counted** rather than silently
  accepted, because it would mean the model's idea of the buffer is wrong.

`courier_emu/isdn.py` raises IRQ14 from `poll_timers` whenever the part is
asserting, and `--line-activate` walks the S interface up.  The transmit FIFO
is modelled as always having room: the depth is not recovered, and a deep
buffer sends the whole frame in one pass rather than inventing a threshold.

## What is still down, and why

Layer 2 does not come up, and the reason is not the D channel - the firmware
never sends a frame.  `ATI12` says why in every line of it: the switch
protocol is `Invalid Switch Type`, multipoint and dialing mode are `Invalid
value`, both SPIDs and both directory numbers are empty, and both TEIs are
`Invalid fixed TEI`.  Nothing is configured, so there is nothing for Q.921 to
start.

`AT*W=4a` - ETSI NET3, A-law, from the firmware's own help page at `bf9f0` -
does reach the parser: a memory diff across two runs shows `26000:d476` going
from `ff` to `34`, the ASCII `4`.  `ATI12` still reports the switch type
invalid afterwards, so the displayed setting is read from somewhere the
parser's scratch has not reached.

The likely place is the settings store, and this harness does not have one.
`Ie030002.nac` is an update payload, not a flash dump, so every address past
the end of the payload reads as erased - `ff` - which is exactly the value the
invalid switch type, the invalid TEIs and the empty SPIDs all decode from.
Establishing where the I-modem keeps its ISDN settings, and giving the harness
a part that answers there, is the next piece of work, and it is what stands
between this and Q.921.  Note that `courier_emu/parameters.py` is not it: that
store is the 211's, and does not exist on this board.
