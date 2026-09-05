# The codec on the 3.1.2 board: DSP-driven, and not fixed at 7200 Hz

Two claims are corrected here. This board's firmware *does* drive its TLC320AC01
from the DSP, and the 7200 Hz figure in
[audio-312-path.md](audio-312-path.md) is the **dial path's** rate, not the
board's one sample rate.

## The AC0x protocol is in this image

[board-parts.md](board-parts.md) describes the part's protocol correctly - a
TLC320AC0x pairs with a TMS320 serial port and uses bit 0 of the transmitted
word to request a secondary control frame - and then concludes that the
20.16 MHz board "carries a TI AC01 whose own firmware never drives it from the
DSP". That conclusion does not hold for this build.

The serial ISR is that protocol:

```text
818d: lamm @6b      ; the secondary-frame request
818e: or   *+       ; OR it into the sample word
818f: samm @21      ; DXR
```

and `819e` sends the control word from `006c` in place of a sample. Reset
programs six control registers through the sender at `8138`, which parks the
word in `006c`, sets the request in `006b`, and idles until the ISR has sent it:

| call | word |
|---|---|
| `80a2` | `010a` |
| `80a6` | `0214` |
| `80aa` | `0300` |
| `80ae` | `0409` |
| `80b2` | `0505` |
| `80b6` | `0620` |

The earlier search was for `main211`'s initialisation routine and its table, and
correctly did not find them. This image has its own, different one. What that
removes is the support for reading 1 there - "the ASIC fronts the codec" - **for
this board**. The `dxr_writes` is 3 measurement that motivated it was taken on
`main211`, whose DSP stops transmitting after reset; here `DXR` is written every
sample at `818f`.

Note also that document's program addresses for the 20.16 MHz build are this
document's minus `0x8000`: its `TSPC` setup "at program `0x008a`" is the
`samm @32` pair at `808a` here. The two are reading the same instructions.

## 7200 Hz is the dial path, and the dial path only

The rate was inferred from the keypad phase increments, and that inference is
sound - but only for the code it was drawn from. Digit 1's increments give
696.97 Hz and 1209.05 Hz at 7200, within 0.05% of the DTMF pair, and nothing
close at 8000, 9600, 11025 or 14400.

It is sound *because* DTMF tolerance is tight. At ±1.5%, the same increments
under a 9600 Hz codec would emit 929 Hz and 1612 Hz and fail every detector. And
the ISR consumes exactly one buffer word per codec interrupt, so while dialing
the generator's rate and the codec's rate are the same number. The dial path
really does run at 7200.

Which is what makes the figure unsafe to generalise. `ATI7` on this unit
advertises `x2` and `V90`. V.PCM carries an 8000-baud carrier and cannot live
under 7200 Hz sampling's 3600 Hz Nyquist; V.34+ at 3429 baud reaches about
3673 Hz and does not fit either. So the codec rate **must** change between
dialing and those modulations. That is a consequence of two facts already
established, not a hypothesis: either the rate is reprogrammed, or this board
cannot do what its own identity string says it does.

7200 is a sensible base rate for what this firmware lineage originally targeted -
V.32 and V.FC, comfortably inside the 300-3400 Hz telephony passband. The later
modulations were added to the same codebase over the following years, and they
are the ones that need the rate moved.

## There is a runtime path to move it

`8138` has seven call sites. Six are the reset constants above. The seventh is
tag `2c`'s handler:

```text
86de: lamm @7a      ; the host's mailbox argument
86df: b    8138     ; straight into the codec control-word sender
```

So one mailbox command writes an arbitrary 16-bit word to an AC01 control
register at runtime. That is the mechanism a rate change would use.

**Not established: that the supervisor uses it.** See below.

## What the senders carry

The supervisor has two enqueue paths, and the second one is why an earlier
enumeration missed the dial tags:

| path | routine | format |
|---|---|---|
| three-word | `f678` | `ff00`, then tag in `AX`, then argument in `BX` |
| one-word | `f64c` | a single word, `(tag << 8) \| data` |

The one-word format is confirmed by the dial marker: sites load `AX` with
`1600` and call it, which is tag `16` with argument `0`, exactly as
`courier_firmware_analysis.md` describes the dial conversation.

Both routines have far-call thunks at `0f644` and `0f648`, and most callers use
them. Resolving those needed the address mapping in
[flash-addressing.md](flash-addressing.md); scanning for the offset field alone
finds none, because the thunk is reached as `8f46:01e4`. With it, the visible
send sites go from 23 to 137:

| path | tags observed |
|---|---|
| three-word | `02 0f 10 11 12 17 19 1a 1b 1c 1d 1e 1f 21 2a` **`2c`** `30 32 33 36 37 39 3b 3c 48 50 51 52 70 71 73 74 76 77 78` |
| one-word | `01 05 06 0a 0c 0e 15 16 2a 3d 3e 3f 40 41 43 44 4a 4b 4f 55` |

Five sites build the tag rather than loading it and are not in those lists.

## Tag `2c` is sent - but it does not carry the rate

Three sites send it, each `mov ax, 0x2c` immediately before the far call:

| site | argument |
|---|---|
| `4a893` | `bx = 0405` |
| `4a8c1` | `bx = 0409` |
| `49a3c` | `bh = 4`, `bl` computed as two 2-bit fields, each forced non-zero |

All three write **register 4**. None touches registers 1 or 2. And in the DSP
image only the six reset sites call `8138` at all - a scan of every
`lacc #0nnn ; call 8138` pair in program `8000..f000` returns exactly those six.

So on this firmware the codec's divider registers are written **once, at DSP
reset, and never again**. The runtime path exists and is used, but for
register 4, whose two 2-bit fields look like gain rather than rate.

## Which leaves a real contradiction

Three things cannot all be true:

1. The dial path runs at 7200 Hz. Constrained hard by DTMF tolerance, as above.
2. Registers 1 and 2 are set once at reset and never changed.
3. This unit does x2 and V.90, which need at least 8000 Hz.

Something in that list is wrong, and this document does not know which. The
candidates, in the order worth testing:

* **A second DSP program.** The supervisor downloads DSP code, and a datapump
  image with its own initialisation would reprogram the dividers on load without
  any tag `2c` traffic. Only one codec init exists in *this* payload, but the
  payload extracted from this flash is one segment at origin `0x8000`, and
  whether another image is downloaded for the datapump is not settled here.
* **Register 4 is not only gain.** If it carries a rate or filter select, the
  three sends above are the rate change and the reading of them is wrong.
* **The register numbering.** The whole `(register << 8) | data` reading rests
  on the reset sequence looking like registers 1-6 in order, which is suggestive
  rather than decoded.

## What would settle it

Reading the six reset words as an actual sample rate needs the AC01 register
map, which the repository does not have; `board-parts.md` already records that a
guessed bit layout did not fit `main211`'s table. Under the natural
`(register << 8) | data` reading these are registers 1-6 with `A = 10` and
`B = 20`. If those are the usual dividers with `Fs = MCLK / (2 * A * B)`, that is
`MCLK / 400`, which needs a 2.88 MHz master clock to give 7200 Hz. The board's
20.16 MHz would give 50.4 kHz, which is out of range for the part, so either the
register reading or the assumed master clock is wrong.

There is a way round the missing datasheet. The dial path's 7200 Hz is known
independently, from the increments. So a second mode's register values, whatever
they are, would give the ratio between the two rates directly - and with the
`Fs = MCLK/(2AB)` form assumed, `MCLK` itself. Finding one tag `2c` send with a
known modulation would convert the whole question from a datasheet lookup into
arithmetic.
