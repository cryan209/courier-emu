# The I-modem's ISDN side, from the code

Recovered by running the 386 harness and watching what it programs.  Two parts
identify themselves outright: the CPU and the ISDN chip.

## The CPU is an Intel 386EX

Not a generic 386 - the boot sequence writes the 386EX's on-chip peripheral
register file, at the addresses that part fixes:

| window | what it is |
|---|---|
| `f400`-`f438` | chip-select unit, seven channels programmed at init |
| `f020`/`f021`, `f0a0`/`f0a1` | the two 8259s - ICW1 `11`, master ICW2 `20`/ICW3 `04`, slave ICW2 `28`/ICW3 `02`, ICW4 `11`/`01` |
| `f040`-`f043` | the 8254 |
| `f8f8`, `f4f8` | SIO0 and SIO1, each opened LCR=`80`, divisor `0002`, LCR=`03`, IER=`0b` |
| `f820`/`f822`/`f824`/`f826` | P1CFG, P2CFG, P3CFG, PINCFG - `00`, `75`, `bc`, `3f` |
| `f864`/`f86c`/`f874` | the matching port latches |
| `f092` | port A |

`courier_emu/isdn.py` already models the 8254, the 8259s and both UARTs; it
calls them "PC-AT furniture", which is right in behaviour and wrong in name.
They are the 386EX's own.

## The ISDN front end is an AMD Am79C30A

At I/O `0300`/`0301`, as a command/data pair: write the register number to
`0300`, then push or pull that register's bytes through `0301`.  Every block
the firmware writes matches the Am79C30A register map, **including its block
sizes**, which is what makes the identification certain rather than plausible:

| reg | name | bytes written | value |
|---|---|---:|---|
| `21` | INIT | 1 | `00` |
| `a5` | LIU_2_4 | 3 | `00 00 00` |
| `a6` | LIU_MF | 1 | `00` |
| `a8` | LIU_MFQB | 1 | `00` |
| `88` | DLC_1_7 | **7** | zeros |
| `89` | DLC_DRCR | **2** | `00 00` |
| `8c` `8d` `8e` | DLC_FRAR4, SRAR4, DMR3 | 1 each | `00` |
| `6b` | MAP_1_10 | **46** | filter coefficients |
| `41`-`44` | MCR1-MCR4 | 1 each | `00` |
| `84` | DLC_DRLR | 6 | `10 01 10 01 10 01` |
| `86` `87` `8f` | DLC_DMR1, DMR2, DMR4 | 1 each | `0b`, `84`, `0a` |
| `92` | DLC_EFCR | 1 | `01` |
| `81` `82` | DLC_FRAR_1_2_3, SRAR_1_2_3 | 3 each | `01 01 01` |
| `a3` `a4` | LIU_LMR1, LMR2 | 1 each | `00`, `78` |
| `69` `6a` | MAP_MMR1, MMR2 | 1 each | `00`, `40` |

Seven bytes to `88` and two to `89` are not a coincidence: `DLC_1_7` is a
seven-register block and `DRCR` is two.  So is 46 bytes to `6b`, the whole
`MAP_1_10` group, and the payload is visibly a pair of symmetric FIR sets:

```
31 b1 | 1b 62 | 26 a2 | bb 16 | bb 16 | 26 a2 | 1b 62 | 31 b1
21 d1 | 12 42 | eb b1 | 61 12 | 61 12 | eb b1 | 12 42 | 21 d1
```

palindromic in 16-bit pairs, twice - the transmit and receive filters of the
audio processor.

## What that says about the architecture

The Am79C30A is three things in one package, and the firmware uses all three:

* **LIU** - the S/T transceiver.  Layer 1 lives in the chip; `LMR1`/`LMR2` and
  the multiframe registers are all the 386 touches of it.
* **DLC** - the D-channel HDLC controller.  `DRLR` is set to `0110` three
  times over: **272 bytes**, the LAPD maximum frame.  `FRAR_1_2_3` and
  `SRAR_1_2_3` are the frame-address recognition registers - TEI and SAPI
  matching done in hardware, which is exactly the service a Q.921 stack wants
  under it.  So layer 2 framing is the chip's and Q.921/Q.931 are 386 software.
* **MAP** - the audio processor, with the filter coefficients above.
* **MCR1-MCR4** - the multiplexer that routes B1, B2 and the internal channels
  between LIU, MAP and the peripheral port.  All four are cleared at init: no
  connection until a call sets one up.

That closes the question left open in
[x2-symmetric-and-all-digital.md](x2-symmetric-and-all-digital.md).  The ISDN
work is not in the DSP because it is not in software at all, mostly: layer 1
and the D-channel framing are an Am79C30A, and what the 386 adds above them is
Q.921 and Q.931.  The DSP only ever sees B-channel PCM, which is why its seven
images are four modulations and a codec and nothing else.

## For the emulator

The next piece to model is the `0300`/`0301` pair: a register file with the
block sizes above, an `LSR` that reports line status, and the DLC's frame
interface.  Until it answers, reads return zero and the boot stalls where it
waits for the LIU to come up - which is where `courier-emu isdn-run` sits
today, spinning at `0x3497f` and `0xa45ef`.

## Modelled

`courier_emu/am79c30.py` is the register file: the command/data pair at
`0300`/`0301`, every register's block width, a cursor that walks a block and
rewinds when the command port is written, and counters for reads, writes,
unknown registers and overruns.  The widths are the check on itself - if one
were wrong the firmware's writes would overrun a block and the counter would
say so.  Against `Ie030002.nac` the whole init sequence lands with **no unknown
registers and no overruns**, and reads back as:

```
INIT 11    LIU_LMR1 40   LIU_LMR2 78   LIU_2_4 00 00 00
MCR1..4 00 00 00 00      DLC_DMR1 0b   DMR2 84   DMR3 02   DMR4 0a
DLC_FRAR_1_2_3 01 01 01  DLC_SRAR_1_2_3 01 01 01  DLC_DRLR 10 01 10 01 10 01
DLC_EFCR 01              MAP_MMR1 00   MAP_MMR2 40   PP_PPCR1 07  PP_PPCR3 01
```

The registers the firmware *reads* are few and now recorded: `LIU_LSR` four
times, `INIT` twice, `MAP_MMR1`, `MAP_MMR2`, `LIU_LMR1`, `DLC_RNGR1`,
`DLC_RNGR2` once each.  Nothing here invents a line state: the LIU sits in F1
until a harness says otherwise, so an activated S interface has to be asked
for deliberately - see [imodem-d-channel.md](imodem-d-channel.md).

Three ports in the same window were unaccounted for here - `0302`, `0303` and
`0307`.  They are the DSC's after all: the part's *direct* registers sit above
the command/data pair, and the firmware's own IRQ14 handler names every one of
them.  See [imodem-d-channel.md](imodem-d-channel.md), which also brings the S
interface up and gets `ATI12` to report the physical layer active.

## What that unblocked

Modelling the DSC was not what the boot was waiting on, and following it turned
up two more parts:

* **The flash** (`courier_emu/flash_device.py`).  `Ie030002.nac` is an update
  image, and entered at its initialiser it identifies the flash and then erases
  it.  The identification is at `34970`: Intel's `ff`/`90` read-identifier
  first, comparing the manufacturer word against `0089`, then AMD's
  `aa`/`55`/`90` unlock if that fails.  With a part that answers, the run gets
  into the Intel command set proper - `50` clear status, `20`+`d0` block erase,
  `70` read status - and the model carries those, with an array that only ever
  loses bits and a status register that reports the write state machine ready.
  The block size was the one number not recovered from the image, and the
  board settles it: the part is an AMD Am29F400AT, top boot, and the erase at
  `78100` lands in its first 8 KiB sector.  It also settles which command set
  runs - AMD's, not Intel's.  See
  [imodem-board-map.md](imodem-board-map.md).
* **The DSP block handshake** at port `18`.  The loader writes `1` and spins
  until bit 0 reads back, then writes `2` and spins until bit 1 does - the DSP
  acknowledging each half-block.  The DSP is not executed here, so the latch
  answers immediately.

With the three in place the update image gets past identification, erases flash
blocks, streams 52,856 bytes to the DSP, and starts writing progress to SIO0.
