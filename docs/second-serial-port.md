# The DSP's second serial port, where the ASIC probably is

Prompted by looking at the board: the link between the ASIC and the DSP looks
like a serial interface. The firmware agrees, and the two serial ports are
configured for opposite roles.

## What the firmware programs

Both control registers are written at reset through MMR addressing, so these
two sites are unambiguous:

```
8089  lacl #38 ; samm @32     ; TSPC = 0038  (reset held, modes set)
808b  lacl #f8 ; samm @32     ; TSPC = 00f8  (released)
...
8091  splk *, #0008           ; SPC  = 0008
8093  splk *, #40c8           ; SPC  = 40c8
```

Decoded against SPRU056D Table 9-13 (bit 4 `MCM` selects the `CLKX` source,
bit 5 `TXM` the `FSX` direction, bit 0 is `TDM` on `TSPC` only):

| register | value | bits | `MCM` | `TXM` | the DSP is |
|---|---|---|---|---|---|
| `SPC` (primary) | `0x40c8` | FSM XRST RRST Soft | 0, `CLKX` input | 0, `FSX` input | **slave** |
| `TSPC` (second) | `0x00f8` | FSM MCM TXM XRST RRST | 1, `CLKX` **output** | 1, `FSX` **output** | **master** |

`TSPC` bit 0 is clear, so the port is **not** in TDM multiprocessing mode - it is
running as an ordinary second serial port. "TDM port" is only the register
block's name here.

The two roles are exactly right for what is on each:

* the **AC01 is on the primary port** and supplies `SCLK` and `FS`, which is why
  the DSP is the slave there - see
  [ac01-codec-protocol.md](ac01-codec-protocol.md);
* on the **second port the DSP drives both clock and frame sync**, so whatever
  is on the other end is clocked by the DSP.

## The DSP transmits on it continuously

The idle task writes `TDXR` every pass. `0x81b7` is the handler the idle state
reaches - `@1b` holds `0x8138`, which is `intr 17`, vectoring through ROM
`0x0022` to `@69` = `0x81b7` - and it begins `ldp #000`, so its `sacl @31` at
`0x81c9` is genuinely `TDXR`:

```
81b7  ldp  #000
81b9  lar  ar5, @74
81ba  lacc16 *+ ; adds *-      ; a 32-bit value from a pair
81bc  lt   @76 ; sath ; satl   ; scaled by TREG
81bf  sacl @7c
81c0  lar  ar5, @75            ; ...and a second one the same way
81c6  and  #00ff
81c8  add  @7c, 8
81c9  sacl @31                 ; TDXR = (first << 8) | (second & 0xff)
81ca  rete
```

so it packs two scaled bytes into each word. Measured at **21,976 `TDXR` writes**
in one 60,000-instruction sample window, against **zero `TRCV` reads**.

## What this corrects

[board-parts.md](board-parts.md) said the TDM port is "configured and then
unused". The receive half is unused; the transmit half is one of the busiest
things the DSP does. The scan behind that claim looked for `TRCV` reads and drew
a conclusion about the whole port.

## The receive half really is unused - and here is why that is not circular

The obvious objection to "zero `TRCV` reads" is that the harness never delivers
a word on that port, so nothing could read one. That objection is correct about
the *runtime* measurement, which proves nothing on its own - it is the same trap
as the codec receive queue, where nothing arrived, so the firmware consumed
nothing, so the model looked consistent with itself.

The static evidence is independent of it, and it agrees:

* **`IMR` is written exactly once**, at `0x809e` during reset, with `0x002a` -
  INT2, TINT and XINT. `TRNT` is bit 6 and `TXNT` bit 7; **neither is enabled
  anywhere in the 27,710-word resident**, so an arriving word could not
  interrupt.
* **`TSPC` is written twice at reset and never read.** Nothing polls `RRDY` on
  that port, so an arriving word could not be noticed by polling either.
* **`TRCV` is never read through MMR addressing anywhere in the resident.**

The one direct-addressed candidate, `lacl @30` at `0xaa4b`, is not a register
read at all:

```
aa4b  lacl @30 ; sub #4f52 ; retc neq     ; 0x4f52 = "RO"
aa4f  lacl @31 ; sub #4b43 ; retc neq     ; 0x4b43 = "CK"
```

That is an ASCII signature check - "ROCK" - against cells on some other data
page, sitting in a chain of `retc neq` guards. It is not `TRCV`/`TDXR`.

So the link is **one-way: DSP to ASIC**. `RRST` is set in `TSPC`, leaving the
receiver out of reset, but nothing in the firmware ever looks at what it
receives.

Worth noting what the neighbouring routine at `0xaa30` does, since it lands on
the same registers by coincidence: it writes `@74`, `@75`, `@76`, `@77` with
`0x0302`, `0x0303` and `0x18`, which are exactly the cells the idle task reads
to build its `TDXR` word. So that is the configuration of *what* gets streamed
out this port - two source pointers and a shift.

## What it does not establish

The other end of the second port has not been traced, and nothing here shows the
ASIC on it - that is the board observation, not a firmware result. Nor is it
established what the packed byte pairs carry; they are two independently scaled
values sent every idle pass, which is consistent with metering or control, but
that is a guess.

What is firm: **the DSP masters a serial link that it transmits on constantly,
and the harness models that link as completely inert.** `queue_serial_rx` feeds
the primary port; nothing ever delivers a word on `TRCV`, and `TDXR` writes are
counted and discarded. If the ASIC answers on that port, the emulator has never
heard it - which is a candidate explanation for the DSP never leaving its idle
task, alongside the `ARCR` gate in
[what-runs-and-what-blocks.md](what-runs-and-what-blocks.md).
