# How the DSP and the ASIC/CPU are connected

A synthesis aimed at one question: what is the path by which the 80186
supervisor and the C5x datapump say anything to each other. It separates what
is hardware-proven from what is inferred, and it retracts one claim that has
been steering the debugging in the wrong direction.

**The short version.** There is one interprocessor path, and it is parallel:
the ASIC bridges *80186 I/O ports* to the *C5x's sixteen memory-mapped I/O
ports* `PA0`-`PA15` (DSP data `0x50`-`0x5F`). That bridge is proven by a round
trip on real silicon, not inferred. The primary serial port is the codec's, and
nothing needs the ASIC on it.

## The proven part

The ROM-dump rig is the proof, and it is a genuine round trip on the board:
a kernel running on the **DSP** executed `out` to its I/O ports `0x5e`/`0x5f`,
and the **80186** read those same words back at its I/O ports
`0x58`/`0x5a`/`0x5c`/`0x5e`. Words crossed from one processor's address space
to the other's. Nothing about that is an argument from fit.

The three windows, from `artifacts/io-port-map/board-21210/` and
`artifacts/cpu-port-map-01/`:

| direction | 80186 side | C5x side | commit/resume |
|---|---|---|---|
| CPU → DSP | tag `0x58`/`0x5a`, data `0x5c`/`0x5e` | tag `PA14` (`0x5e`), data `PA15` (`0x5f`) | CPU writes bit 0 of `0x1c`; DSP acks by writing 1 to `PA7` |
| DSP → CPU | `0x60`/`0x62`, **27 reads / 0 writes** in the whole image | the sender, one word per interrupt | CPU acks bit 2 of `0x1c` |
| download | `0x40`-`0x4e`, eight latches | program RAM, DSP held in reset | no "go" - releasing reset is the go |
| status | `0x1c`/`0x1e` | `PA7` (`0x57`) | bit 0 host message pending, bit 9 gates `0x80f8` |

On the DSP side the dispatcher reads the tag, rejects tags above `0x7f`, and
branches through a 121-entry jump table. `PA0`-`PA15` are not a peripheral
block and not reserved space: SPRU056D section 3.5.11 and Table 8-8 make DSP
data `0x0050`-`0x005F` the sixteen I/O ports, reachable both by ordinary data
addressing and by `IN`/`OUT`. **The ASIC is the device on the other side of
them.**

### Why a board inspection sees no parallel traces

The objection that stalled this - a board inspection reporting no traces from
the DSP's address/data pins to anything but its two `CY7C199` SRAMs - is not in
conflict with any of the above, and it never was.

SPRU056D Table A-8 gives `DS`, `PS` and `IS` as three *space-select strobes*
sharing **one** address/data bus: "Data, program, and I/O space select signals.
Always high unless low level is asserted for communicating to a particular
external space." So an I/O cycle drives the same address and data pins as a
data cycle, distinguished only by which strobe goes low.

The ASIC is therefore tapped onto the same traces as the SRAMs and qualifies
its accesses with `IS`. **There are no separate parallel traces to find**, and
their absence is not evidence against the mailbox. This also means "the
ASIC-to-DSP link is serial" is the expected *visual* reading of a board where
the link is in fact the I/O space of a multiplexed bus.

## The retraction: the ASIC is not shown to master the primary serial bus

[second-serial-port.md](second-serial-port.md) argues that the ASIC generates
`SCLK` and `FS` for the DSP-codec link, and concludes from that that the ASIC
inserts its own words into `DRR`, making the ring at `0x0bd0` an inbound
*command* stream the harness has never supplied. **The premise does not hold,
so neither does the conclusion.**

The argument needs both devices on that bus to be slaves. For the DSP that is
read correctly from `SPC = 0x40c8` (`MCM = 0`, `TXM = 0`). For the codec it is
read from "register 6 = `0x20` puts the AC01 in free-run, and it is wired in
slave/codec mode". That step is wrong twice over:

* **Register 6 carries no master/slave bit.** It is the *digital configuration*
  register: free-run, FSD output enable, 16-bit mode, force secondary, software
  reset, software power-down (datasheet section 2.20.7). The master/slave role
  is the **`M/S` pin** - Table 2-1, "Master/slave select input. When M/S is
  high, the device is the master and when low, it is a slave." Firmware cannot
  set it, and nothing in this repository has measured it.
* **Free-run does not imply slave/codec mode.** `0x20` is `DS05`, and free-run
  does exactly one thing: it makes the ADC/DAC conversion rate follow the A and
  B registers rather than the external frame-sync interval. In codec mode that
  is a real choice; in stand-alone mode the rate already comes from A and B, so
  the bit is redundant but harmless. It is consistent with **both** topologies
  and discriminates neither.

With that premise gone, the textbook topology is fully consistent with every
firmware fact on record, and it is the one TI's own `slaa006` reference design
wires: **the AC01 is the stand-alone master, generating `SCLK` and `FS` for a
slave DSP.** That is also what [ac01-codec-protocol.md](ac01-codec-protocol.md)
already says ("the AC01 is on the primary port and supplies `SCLK` and `FS`"),
which `second-serial-port.md` contradicts without noticing.

There is a second, independent gap in the same argument. Even if the ASIC
*were* the clock and frame master, that is a **timing** role, not a data role:
driving `SCLK` and `FS` does not put the master's data on `DIN`/`DOUT`. The
step from "bus master" to "inserts its own words into `DRR`" does not follow
either way.

So the ring at `0x0bd0` is what it looks like - a codec sample ring - and the
inbound command path is the mailbox, which is proven and already modelled.

## The codec's control words decode cleanly, and give MCLK

`docs/` now has the TLC320AC01 datasheet, so the six control words this board's
firmware sends at reset can be read rather than guessed. The secondary-word
format (section 2.19.1) is two control bits, `R/W`, a 5-bit register address in
`DS12`-`DS08`, and 8 bits of data:

| word | register | data |
|---|---|---|
| `010a` | 1, A register | 10 |
| `0214` | 2, B register | 20 |
| `0300` | 3, A′ (phase) | 0 |
| `0409` | 4, amplifier gain | 9 |
| `0505` | 5, analog configuration | 5 |
| `0620` | 6, digital configuration | `0x20` = free-run |

The decode checks out against the part's own rate equation,
`fs = MCLK / (A x 2 x B)`, which with A = 10 and B = 20 gives exactly
**7200 Hz** - the dial path's measured rate - and with the B = 19 and B = 18
that [codec-rate-312.md](codec-rate-312.md) finds the V.34 path selecting,
exactly **7578.95 Hz** and **8000 Hz**. Three independent rates land on their
known values from one constant:

> **MCLK = 2.880 MHz**, which is the board's 40.320 MHz oscillator divided by
> exactly **14**.

That is a new datum. It also says where MCLK comes from: the AC01's `MCLK` is
an input in every mode, there is one can on the board, and the ASIC is the only
part that could divide it - so the ASIC supplies the codec's master clock
whether or not it supplies its shift clock.

Note also that **registers 7 and 8 are never programmed**. Register 8 is the
frame-sync number, which a master device needs in order to know how many slaves
are chained, and register 7 is the frame-sync delay, which "must be the last
register programmed when using slave devices". Their absence rules out
*master-with-slaves*, leaving stand-alone or codec mode - which is as far as
the firmware can take this. Settling it needs one look at the `M/S` pin.

## The live blocker, and a lead that does not work yet

What actually stops the two processors talking is not the topology. It is that
the DSP's mailbox poll almost never runs. The poll is in the block at `0x80c8`
(program `0x00c8`; this file uses the `+0x8000` convention), and the main loop
reaches it only when `cmpr eq` matches `AR7` against `ARCR`:

```
80d0  0010           lar     ar0, @10     ; @10 under DP=7 is 0x0390
80d1  bf44           cmpr    eq           ; AR7 vs ARCR
80d2  e100 80c8      bcnd    80c8, tc
```

`AR7` is the ring pointer - `0x802e` sets `CBCR = 0x00ef`, selecting `AR7` for
circular buffer 1 with `CBSR1 = 0x0bd0` and `CBER1 = 0x0bdf` - and data `0x0390`
is the ring **write** pointer the serial ISR maintains at `0x8191`/`0x81a1`. So
the compare wants to be a ring rendezvous, and any `ARCR` inside the ring makes
the mailbox poll run once per pass.

In the emulator `ARCR` instead holds `0xec3e`, a **program** address left by the
table walk at `0x9644` - the only `samm @19` in the resident - so the compare
never matches and 87 delivered messages overwrite each other unconsumed.

### The lead: PMST.NDX, which is real but does not fit

The `lar ar0, @10` immediately before each `cmpr eq` is pointless if the compare
reads `ARCR`, and the idiom appears at three sites (`0x80d0`, `0x8105`,
`0x810d`). SPRU056D explains why it would not be pointless - PMST bit 2, `NDX`:

> *(LAR instruction reference, page 6-124)* "You can maintain software
> compatibility with the 'C2x by clearing the NDX bit. This causes any 'C2x
> instruction that loads auxiliary register 0 (AR0) to load the auxiliary
> register compare register (ARCR) and index register (INDX) also."

Table 4-3 agrees, and gives the reset value as 0. And this firmware **clears
`NDX` explicitly**, at `0x8012`: `apl @07, #07f8` masks off bits 0, 1 and 2, and
the following `opl @07, #00b0` sets only bits 4, 5 and 7. So on paper every
`lar ar0` should be writing `ARCR` with the ring write pointer, and the core
implements none of it: `m_pmst.ndx` is parsed and stored in
`native/c5x_core.cpp`, and then read nowhere except to reconstruct the register.

Implementing it does produce exactly the predicted state - `ARCR` becomes
`0x0bdc`, inside the ring - **and it breaks the firmware**. `INDX` takes the
same value, and a stride of 3036 corrupts all 317 `*0+`/`*0-` indexed-addressing
sites in the resident; the DSP stops reaching its main loop and the codec goes
undriven (`dxr_writes` 17,931 → 15). Restricting the side effect to `ARCR`
alone, or to the direct/indirect `LAR` encoding alone, does not rescue it.

So the change was **reverted**, and the position is:

* the mechanism is real and documented, and it is the only thing found so far
  that would leave a ring address in `ARCR`;
* the firmware clears `NDX`, which by the datasheet's own table *enables* the
  side effect;
* but a firmware that ran on real hardware cannot tolerate the side effect as
  the datasheet describes it.

One of those three has to give. Worth noting that SPRU056D contradicts itself on
the polarity - the prose at section 3.5 says the side effect happens when NDX is
**set**, the LAR page and Table 4-3 say when it is **clear** - so the document is
not a reliable arbiter here, and the part's actual behaviour is the open
question. The cheap decider is a hardware probe: a kernel that clears `NDX`,
does `lar ar0, #1234`, and mails back `ARCR` and `INDX`.
