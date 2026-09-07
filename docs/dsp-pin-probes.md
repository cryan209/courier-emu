# Where to put a probe on the DSP

Pin numbers are TI's, from SPRU056D Table A-4, *Signal/Pin Assignments for the
'C50, 'C51, and 'C53 in 132-Pin BQFP*. They apply to this board because the
part is marked **`D17140PQ`**, and TI's device table (page 1-4) lists `PQ` as
the 132-pin BQFP package for the 'C50 and 'LC50.

That is worth noting on its own: [board-parts.md](board-parts.md) concluded the
part is a **'C50 or 'LC50 rather than the 'C52** the core was first written
against, and it reached that from the firmware's memory use - the `0x23f0`
call landing inside a 9K SARAM, `PMST.RAM` and `OVLY` both being set. The
package suffix says the same thing independently: a 'C52 is **100-pin QFP**,
not `PQ`. Two unrelated routes to the same part.

## The one pin that settles the mailbox medium

**`IS` - pin 90.**

`IS` is the I/O-space select strobe. SPRU056D Table A-8 gives `DS`, `PS` and
`IS` as three space selects sharing one address/data bus, each "always high
unless low level is asserted for communicating to a particular external space".
So `IS` goes low for **one thing only**: an `IN` or `OUT`, or an access to
`PA0`-`PA15`. The SRAMs do not need it; they answer `DS` and `PS`.

The whole DSP-to-CPU mailbox runs on `OUT` instructions - the sender at
`0x83eb` to ports `0x5e`/`0x5f`, the stream coroutine at `0x84b7` to port
`0x60`. Every one of those asserts `IS`.

> * **`IS` (pin 90) routed to the ASIC** - the ASIC decodes the DSP's I/O
>   cycles, and the mailbox is parallel across the bus the SRAMs already sit on.
> * **`IS` unconnected, tied, or going nowhere near the ASIC** - the ASIC cannot
>   see an `OUT` at all, and the mailbox has to reach the CPU by some other
>   route. That would make the serial reading correct and force the question of
>   how `out @7d, 0x5e` gets anywhere.

This is a better test than counting data traces: `IS` is a single pin with
exactly one purpose, and continuity to the ASIC is a meter reading.

The rest of that group, for context: `DS` 89, `PS` 91, `R/W` 92, `STRB` 93,
`RD` 82, `WE` 83.

## The two serial ports

The second serial port and the "TDM port" are **the same pins and the same
registers** - `TSPC` bit 0 selects, and SPRU056D's bit table reads
`TDM -> 0: TDM port is configured as standard serial port`. This firmware
writes `TSPC = 0x00f8`, bit 0 clear, so it runs as an ordinary second serial
port. Two of its pins are dual-function and only take their TDM meaning when
that bit is set, which here it never is.

| signal | pin | port | what the firmware makes it |
|---|---|---|---|
| `DX` | 106 | primary | codec DAC data - written every sample |
| `DR` | 43 | primary | codec ADC data - read every sample |
| `CLKX` | 124 | primary | **input** (`SPC` `MCM = 0`) |
| `FSX` | 104 | primary | **input** (`SPC` `TXM = 0`) |
| `CLKR` | 46 | primary | input |
| `FSR` | 45 | primary | input |
| `TDX` | **107** | second | **driven constantly** - the one-way stream |
| `TDR` | **44** | second | never read by any instruction |
| `TCLKX` | **123** | second | **output** (`TSPC` `MCM = 1`) |
| `TFSX`/`TFRM` | **105** | second | **output** (`TSPC` `TXM = 1`); `TFRM` only if TDM=1 |
| `TCLKR` | 126 | second | - |
| `TFSR`/`TADD` | 125 | second | `TADD` only if TDM=1, so not here |

### What the board should look like if the firmware is right

Each of these is falsifiable with a scope or a meter:

1. **`TCLKX` (123) and `TFSX` (105) are actively driven by the DSP.** `MCM` and
   `TXM` are both set, so the DSP masters that bus. If they are quiet, the
   register decode is wrong.
2. **`TDX` (107) is toggling constantly** - the idle task writes `TDXR` every
   pass. **Follow pin 107**: whatever it reaches is what the DSP streams to, and
   that identifies the far end of the second port, which nothing has yet.
3. **`TDR` (44) is tied or floating.** The receive half is unused four ways -
   `TRNT`/`TXNT` never enabled in `IMR`, `TSPC` never read so `RRDY` never
   polled, `TRCV` never read through MMR addressing, and the one direct-addressed
   candidate at `0xaa4b` is scratch. The datasheet's own note says "input pins
   that are unused may be connected to VDD or to an external pullup resistor".
   If `TDR` is tied high, that **confirms the ASIC cannot send to the DSP on
   this port** - and the second port is ruled out as the command link by the
   board as well as by the firmware.
4. **`CLKX` (124) and `FSX` (104) are driven by something that is not the DSP.**
   Both are inputs here. Whatever drives them owns the primary bus - and that is
   the open question: the AC01 in stand-alone mode, or the ASIC. The codec-side
   version of this test is `M/S` on the TLC320AC01**CFN**, pin 18 of the **FN**
   package - a different part and a different package from the DSP's `PQ`.

Between them, 3 and 4 decide the topology: 3 closes off the second port, and 4
says whether the ASIC is on the primary one.
