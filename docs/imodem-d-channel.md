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

### The settings block, and that nothing fills it

The ISDN settings are a **91-byte block at `2600:d476`**, and the firmware
checksums it at `c4ecb`:

```
c4ecf  mov word ptr [cf30], 0
c4ed5  mov si, d476
c4ed8  mov cx, 5b               ; 91 bytes
c4edb  lodsb ; lcall b3d9:6aa9  ; accumulate into [cf30]
c4ee1  loop c4edb
```

Its accessors are the routines around `c3111`-`c357d`, in the same region as
the switch-type name table at `c339f` (`AT&T 5ESS`, `Northern Telecom
DMS-100`, ... `Invalid Switch Type`), which is what `ATI12` indexes.

In a run the block is cleared by the general RAM wipe at `a4051` and then
**never written again**.  A memory watch over it across a session that sends
`AT*W=4A` records the boot-time zeroing, the boot-time checksum read, and
nothing else for the remaining 97 million instructions.  So the block is not
loaded from anywhere, and every field decodes from zero as invalid - which is
the whole of `ATI12`'s complaint.

### It is not the 93C66 the other Couriers carry

Worth ruling out explicitly, because the board furniture does look familiar.
The I-modem has the same board-latch signal abstraction as the 302, 403 and
Quad - a signal id of `mask << 8 | flags | index`, a read helper at `a5e0e`
and set/clear helpers at `a5f2b`/`a5ebf` - and **index 0 of its input port
table at `a5f97` is port `0x10`**, the very latch those boards bit-bang their
Microwire EEPROM on ([quad-settings-eeprom.md](quad-settings-eeprom.md)).

The transport is not there, though:

* A run does look like it clocks a serial part - one signal toggled 941
  times, another 941, a third 94 - but that is the **front-panel lamps**.  The
  routine at `abf4b` drives two indicators with modes 0 off, 7 on, 8 slow and
  anything else fast, dividing a tick by `0x14` or `3`.  A board-revision flag
  at `[c8f1]` bit 2 switches both lamps between port `0x100` and the older
  latches, which is why they land on plausible-looking pins.
* Statically, all ~100 near callers of the three signal helpers are in the
  `a400` segment and none of them is a shift loop.  There is no 12-bit command
  frame, no 16-bit read-back.
* The Courier settings-record obfuscation - `ror(b,2)+5`, `rol(b,1)-0x0f`,
  `b xor 0x1d` - does not appear either: `xor al,1d` occurs once in the whole
  image, with no `sub al,0f` anywhere near it.

So whatever fills `2600:d476` is not the 93C66 store this repository already
models, and pointing `courier_emu/nvram.py` at the I-modem would not be
modelling its hardware.  Where the block does come from is not established.
The two candidates left are the flash - `Ie030002.nac` is an update payload,
so everything past its end reads erased - and the missing 32 KiB boot block,
which is where a loader that runs before anything else would sit.  Finding it
is what stands between this and Q.921.  Note that `courier_emu/parameters.py`
is not it: that store is the 211's, and does not exist on this board.
