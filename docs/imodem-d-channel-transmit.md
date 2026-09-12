# What reaches the D-channel transmitter, and what stops it

[imodem-config-sector.md](imodem-config-sector.md) ends on this:

> The D-channel transmit path at `0x71cb0` is never entered, and it has no
> direct callers - no far call anywhere in the image targets it, and no near
> call from any plausible segment - so it is reached through a pointer. That
> indirection is where the next look belongs.

**There is no pointer.**  That conclusion came from searching for callers of
`0x71cb0`, and `0x71cb0` is not a function - it is the middle of one.  The
body starts at `0x71cb4` and the function entry is **`0x71c77`**, which has
five ordinary far callers:

```
lcall to 71c77: 62fd9, 71074, 71c49, 72dde, 72f49
```

all encoded `71ac:01b7`.  One of them runs.  During a TEI Identity Request
([imodem-tei-request.md](imodem-tei-request.md)) `0x71c49` calls it and the
function is entered - 377 instructions after the request is assembled.  The
transmitter is reached.  What it is not is *permitted*.

## The gate

```
71c8f  or word es:[bx+0x1e], 1        ; mark the link transmit-pending
71c94  mov al, [bp+6] ; mov bx, ax    ; the interface
71c9b  cmp byte [bx-0x5ba8], 7        ; ce0:a458+interface, the layer-1 state
71ca0  je 71cb4                       ; == 7            -> transmit
71ca2  mov bx, [bp-4]
71ca5  mov ax, es:[bx+0x10]
71ca9  and ax, 0x80 ; cmp ax, 0x80
71caf  je 71cb4                       ; flag 0x80 set   -> transmit
71cb1  jmp 71d7b                      ; otherwise nothing goes out
```

Two ways in, and in a run neither is open:

* **The layer-1 state byte is 8, not 7.**  8 is the activated state - it is
  the value that makes the dispatch at `0x70f38` push event 6, the activation
  event, and it is what produces `LINE_ACTIVE Detected`.  The `== 7` arm is
  the *other* one: state 7 is one step below, and the firmware will transmit
  while activation is still in progress.  Shifting the model's LSR field by
  one to make F7 store 7 was tested and does not work - it stops the line
  coming up at all, and the log goes empty.  So 8 is right and this arm is
  simply not the one meant for an activated link.
* **The transmit-permission flag is never set.**  `es:[bx+0x10]` bit 7, on
  the structure the far pointer at `ce0:a448` names.

## The flag, and the one routine that sets it

Two sites set it, `0x72bd4` and `0x732b4`, and two clear it.  Neither setter
executes in any run here.  The interesting one is `0x72b83`:

```
72b8b  select 0xa4            ; LIU_LMR2
72b99  read it
72ba6  or al, 2               ; set the activation-request bit
72bae  select 0xa4 ; write al ; LMR2 |= 2
72bcd  les bx, [0x138e] ; les bx, es:[bx]
72bd4  or word es:[bx+0x10], 0x80    ; and now the link may transmit
```

That is I.430 activation **requested by the terminal** - the TE asking the
LIU to drive INFO1 - immediately followed by permitting layer 2 to send.  It
is the missing half of the line handling: this repository's peer activates
from the network side, and the firmware never asks from its own.

It has exactly one caller, `0x7067f`, which is one arm of a command dispatch
in the layer-1 driver, every arm of which calls a different `7234:xxxx`
routine.  So the chain is

```
<some layer-1 command>  ->  0x7067f  ->  0x72b83  ->  LMR2 |= 2
                                                  ->  transmit permitted
```

and the open question is now a single one: **what issues that command.**

## What this corrects

* `0x71cb0` is not an entry point and is not reached through a pointer.  The
  transmit function is `0x71c77` and its callers are ordinary far calls.
* "The transmit path is never entered" is wrong.  It is entered, by
  `0x71c49`, and returns without sending.
* [imodem-d-channel.md](imodem-d-channel.md) notes that `LIU_LMR1` is written
  once at init and never again, and concludes there is no terminal-initiated
  activation to model.  The register to watch is **LMR2**, not LMR1, and the
  write is `|= 2` from `0x72b83`.  It still never happens - but now there is
  a specific routine whose execution would be the evidence, rather than an
  absence.
