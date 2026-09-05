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

## What the senders carry, and why the list is incomplete

The supervisor has two enqueue paths, and the second one is why an earlier
enumeration missed the dial tags:

| path | routine | format |
|---|---|---|
| three-word | `f678` | `ff00`, then tag in `AX`, then argument in `BX` |
| one-word | `f64c` | a single word, `(tag << 8) \| data` |

The one-word format is confirmed by the dial marker: two sites load `AX` with
`1600` and call it, which is tag `16` with argument `0`, exactly as
`courier_firmware_analysis.md` describes the dial conversation.

Tags observed across both paths, from same-segment immediate loads: `01, 05,
08, 16, 34, 35, 40, 42, 49, 4a, 53, 54, 56, 75`. Tag `2c` is not among them, and
no site anywhere loads it as an immediate before either call.

That is not evidence of absence. The enumeration is incomplete in two known
ways. Some sites build the tag rather than loading it - `10cb4` reads a nibble
of `[0x9a5]`, indexes a table at `1831` with `xlat`, and sends it as tag `40`'s
argument. More importantly both routines have far-call thunks at `0f644` and
`0f648`, so there are callers in other segments, and the flash is banked - the
captures address it as `A000:`/`B000:` - so file offsets are not linear
segment:offset and those callers cannot be found by scanning for a byte pattern.
Resolving the bank mapping is what would finish this.

A rate change may also simply live where it is hardest to see. V.34 and V.PCM
startup would have no reason to reprogram the codec before phase 3, so the
sending code is likely inside the training state machine rather than on the dial
path - and that is the part most likely to sit in a banked overlay.

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
