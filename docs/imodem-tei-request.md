# The modem does ask for a TEI

Two pages of this repository say it does not.
[imodem-bri-network.md](imodem-bri-network.md) lists "the modem does not
request a TEI on its own" as an open question, and
[imodem-firmware-trace.md](imodem-firmware-trace.md) inherits it.  **Both are
wrong.**  It asks.  The request is built, it is correct, and it is thrown away
before it reaches the wire.

## Watching it happen

Present an incoming call on the broadcast data link - the one path that
reaches a terminal owning no TEI - and the TEI management entity runs:

| instructions | what runs |
|---:|---|
| 20,025,601 | the broadcast SETUP is decoded and distributed |
| 20,027,632 | `0x69b70`, the TEI state machine, on event 0 |
| 20,027,667 | `0x6a755`, the Identity Request builder |
| 20,030,865 | queued through `652e:000d`, the entity returns |
| **20,036,512** | the stack raises **`LINE_NOT_ACTIVE`** |
| 20,039,663 | status `0x1a`, which its dispatcher has no arm for |

The state machine at `0x69b70` dispatches on `[bp+8]`; event 0 is "start
assignment".  It checks the per-interface TEI state at `es:[bx+0x85]`, finds
0, sets the retry counter `es:[bx+0x8e]` to 1 - that is **N202**, whose
exhaustion the firmware logs as `N202 Cnt Exceeded - no TEI assigned!!!` -
and calls the builder.

The builder assembles the message a byte at a time:

```
6a8b0  mov byte es:[bx], 1        ; message type 1 - Identity Request
6a8ba  mov byte es:[bx], 0xff     ; Ai - TEI 127, EA set
```

and reading the assembled buffer out of memory at `0x6a8d4` gives, in full:

```
00 00 00 00 00 00 | 0f 2e 6b 01 ff
                    |  |     |  `- Ai         0xff, TEI 127
                    |  |     `---- message    01, Identity Request
                    |  `---------- Ri         0x2e6b, the reference
                    `------------- MEI        0x0f
```

That is a textbook Q.921 Annex D Identity Request.  Nothing about it is
malformed, and `courier_emu/bri.py` answers exactly this shape - the peer has
been able to assign a TEI the whole time and has never been asked.

## Where it dies

It is queued to another task through `lcall 652e:000d` and never transmitted:

```
frames the chip actually transmitted: 0
peer saw from the modem:              0
```

and nothing in the D-channel transmit region `0x71a00`-`0x72000` executes at
any point after the request is queued.  About 5,600 instructions later the
stack raises `LINE_NOT_ACTIVE` and abandons the procedure.

That verdict is not the line.  In the same window the chip is touched exactly
three times - a write to `DLC_RNGR1`, then a select and read of `LIU_LSR`
which returns `0x06`, decoding through the firmware's own `(LSR & 7) + 2` to
**8, F7, active**.  The firmware reads the line as up and reports it as down.

So the gap is between a queued layer-2 frame and the D-channel transmitter,
and it is the same gap the transmit path at `0x71cb0` has always shown: it
has no direct callers and is reached through a pointer that nothing in a run
has yet been seen to set.

## One thing this did fix

The `Ri` above is `0x2e6b` because of this investigation.  The firmware reads
it from the Am79C30's **random number generator**, `DLC_RNGR1`/`DLC_RNGR2`,
and `courier_emu/am79c30.py` was answering those out of the register file -
so they returned whatever had been written, which is 0.  Every Identity
Request this harness ever built carried `Ri 0000`.

That is legal, and it is not why the request fails, but it is not what the
part does: Ri exists so two terminals asking at once can tell their answers
apart, and a constant defeats it.  The registers are now a generator, seeded
per instance with an LCG so a run stays reproducible - a harness whose frames
change between runs is worse to debug than one whose random number is fixed
per seed.

## What to correct elsewhere

"The modem does not request a TEI" should be read as "the modem's TEI request
is never transmitted" everywhere it appears.  The distinction matters: the
first says the stack has not decided to ask, which would point at
configuration; the second says it has asked and the frame is stuck, which
points at the transmit path.
