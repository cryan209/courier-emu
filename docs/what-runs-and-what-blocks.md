# What it takes to make a call complete, measured 2026-09-07

After the AC01 work, the codec chain is right end to end. A call still does not
complete. This records what was measured, so the remaining work is against
evidence rather than a guess.

## The run

```sh
./courier run IDSDL302.ROM --with-dsp --exchange --tick-ms 5 --board-id 7 \
    --nvram-fixture idsdl302 --at 'ATDT5551234' --instructions 120000000 \
    --summary --dsp-tx-pcm /tmp/tx.pcm
```

What it produces:

| observation | value |
|---|---|
| DSP bootstrap | `bootstrap_match: true`, `bootstraps: 1` |
| codec registers programmed | 6, rate 7200 Hz |
| hook | `off_hook: true`, exchange state `dial-tone` |
| **datapump output** | **59,589 samples, every one zero** |
| digits decoded by the exchange | none, `dialed: ""` |
| host -> DSP messages delivered | 87 |
| **messages the DSP consumed** | **1** |

## The chain is fine up to the DAC

The parts this session fixed are all working in the run: the boot ROM loads the
resident, the firmware programs the AC01's six registers, `fs` comes out of the
B register at 7200 Hz, a frame sync clocks one ADC word each way, and audio is
resampled in both directions between the line's rate and the codec's.

None of that matters yet, because **the datapump never puts anything on the
line**. `--dsp-tx-pcm` is 59,589 samples of digital silence.

## Where the DSP actually is

Sampling the program counter over 60,000 instructions after the download:

```
  0x0022-0x0023     3.7%     ROM interrupt dispatch
  0x80d0-0x80e1    31.6%     the resident's main loop
  0x80e4-0x80f1    22.3%       ...and its indirect dispatch through @1a/@1b
  0x8138-0x8139     5.6%
  0x8189-0x8197     0.6%     the codec ISR, receive half
  0x819e-0x81aa     0.5%     the codec ISR, transmit half
  0x81b7-0x81ca    35.4%     a dispatched handler
```

Eleven regions, 102 distinct addresses, out of a 27,710-word resident. The DSP
is **healthy and idle**: it runs its main loop, dispatches through the handler
cells at `@1a`/`@1b`, and services the codec every frame. It is not stuck, not
crashed, and not in a wait. It has simply never been asked to do anything.

Its only external reads are I/O `0x51` - 106 reads in 60,000 instructions - the
mailbox window.

## The blocker is the ASIC's host/DSP mailbox

The supervisor issues the dial, seizes the loop through its own hook relay, and
sends 87 messages toward the DSP. The DSP takes **one**. Nothing ever reaches
the resident that says "generate these digits", so no datapump code runs and the
DAC stays at zero.

This is the ASIC, which [board-parts.md](board-parts.md) already identifies as
one unpublished part and which
[what-the-asic-does.md](what-the-asic-does.md) already names as the reason
"`--exchange` still hears silence when the firmware dials". What the codec work
changes is that it is now the *only* remaining reason on this path, rather than
one of several.

Note that the harness declines to paper over it. `arm_dial_tones` returns
immediately when an exchange is present:

```python
if self.exchange is not None:
    # With a modeled line the command is the firmware's alone.
    return
```

so `dial_digits` stays empty by design and the synthetic DTMF generator is not
armed. That is the right call - the point of `--exchange` is to make the
firmware do it - but it means this path has no fallback, and the silence is the
honest result.

## Traced: why the mailbox is never polled

The resident's steady-state loop is `0x80d0 -> 0x80f1 -> 0x80d0`. It reaches the
block-level work at `0x80c8` only through one branch:

```
80d0  lar  ar0, @10
80d1  cmpr eq          ; TC = (AR[ARP] == ARCR), and ARP is 7 here
80d2  bcnd 80c8, tc
```

`AR7` is a circular pointer over the mailbox ring at `0x0bd0`-`0x0bde`, stepping
by two and wrapping - measured. **`ARCR` is never initialised**, so the compare
never matches and the block never runs. The block is where all four of these
live:

```
80c6  call 8223
80c8  call 839b     ; the host mailbox poll
80ca  call 83d6
80cc  call 847a
80ce  call 80f8
```

Forcing `ARCR` to a value `AR7` reaches (`0x0bd0` or `0x0bde`) makes the block
run and lifts the DSP from 103 distinct program addresses to 159. That is a
diagnostic, not a fix - nothing on the board would write it by hand.

The resident contains exactly **one** instruction that sets `ARCR`, `samm @19`
at `0x9644`, and it is never reached. So `ARCR` has to be set by initialisation
the DSP is not completing.

## The four routines all gate on one register, and it is I/O 0x57

```
839b:  bit 15, @7d   -> bit 0    host message pending
83d6:  bit 14, @7d   -> bit 1    (also requires @79 != @78)
847a:  bit 13, @7d   -> bit 2    then dispatches through data 0x039e
80f8:  and #0200     -> bit 9
```

All four read `0xff57`. **The TI manual settles what that is.** SPRU056D
section 3.5.11 and section 8.3.2:

> Address range `0000h-004Fh` contains on-chip memory-mapped registers, and
> address range `0050h-005Fh` contains the memory-mapped I/O ports.

> The I/O space makes it possible to address 16 locations (`50h-5Fh`) of I/O
> space via the addressing modes of the local data space [...] The locations can
> also be addressed with the `IN` and `OUT` instructions.

with `0x50` = PA0 through `0x5F` = PA15, and `0x60`-`0x7F` scratch-pad DARAM B2.
And Figure 5-10: `LAMM`/`SAMM`/`LMMR`/`SMMR` force the 9 MSBs of the address to
zero, so `lamm *` with AR1 = `0xff57` genuinely reads `0x57`.

So **`0x57` is PA7, a real external I/O port**, and the four routines are polling
a status word the ASIC drives. The mechanism is TI's; the **bit meanings are the
ASIC's**, and no TI document has them.

**The harness models one bit.** `HOST_MESSAGE_PENDING` is `0x0001`, and bits 1,
2 and 9 are never raised by anything.

That closes the loop on the initialisation problem: `0x83d6` and `0x847a` return
immediately because their bits are clear, so whatever they would have set up -
`ARCR` and the `@1a` task pointer among it - never happens. `@1a` stays pointing
at `0x8139`, which is a bare `ret`, which is why the main loop dispatches to a
no-op forever.

## What is needed, in order

1. **Model the rest of PA7 (`0x57`).** Bit 0 alone is not the protocol. What
   bits 1, 2 and 9 mean is the question, and `0x847a`'s path through data
   `0x039e` and `bacc` is the one shaped like "start this task".

   **The supervisor is where to look.** The DSP's PA0-PA7 are fed from the
   80186's parallel window at ports `0x40`-`0x5e` - that is what
   `_publish_window` already models - so whatever sets PA7's bits is 80186 code
   in an image this repository has. That is a static-analysis question against
   the supervisor, not an unanswerable one about an undocumented part.
2. **Then `ARCR` and `@1a` should be set by the firmware itself**, not by the
   harness, and the block-level loop starts running on its own.
3. **Then re-measure the DAC.** `--dsp-tx-pcm` going non-zero is the test, and
   the DTMF frequencies in it - read at the codec's current rate, not 9600 - are
   the check that the rate chain is right.
4. **Then the exchange should decode digits.** That code is implemented and
   already receives frames; it has only ever been handed silence.

Steps 2 to 4 need no new code if step 1 is right. **The remaining work on this
path is one problem - the ASIC's status register - not a list.**

This is the part [board-parts.md](board-parts.md) calls unpublished, so it will
have to be inferred from the resident's own use of it or measured off the board
the way the boot word was.

## Tried: wiring the ports together instead of interpreting them

SPRU056D makes the ASIC a register file - the 80186 on one side, the DSP's
sixteen I/O ports on the other - which suggests the harness should *wire* the
two rather than interpret one into the other. The bridge's `0x1c` handling is
currently a hand-written state machine that decodes the supervisor's writes and
synthesises DSP status.

`COURIER_ASIC_TRANSPARENT=1` turns on a mirror instead, using the mapping the
existing code already implies:

| 80186 | DSP | |
|---|---|---|
| `0x1c` | PA7 `0x57`, low byte | status. The host owns the low byte; the upper bits are the DSP's own send-complete and stream-ready flags, so writing the whole word clobbers them |
| `0x58`, `0x5a` | PA14 `0x5e` | message tag |
| `0x5c`, `0x5e` | PA15 `0x5f` | message data |

**It measurably advances the DSP**: messages completed goes from 1 to 10, and
the run reaches 36 distinct runtime message types. **It does not produce audio** -
`--dsp-tx-pcm` is still 59,589 zeros and no digits decode.

So the register-file reading looks right and is worth pursuing, but it is not
sufficient on its own, and it is off by default because a partial mapping that
advances the DSP without completing the path is not yet a model of anything.

What it does not address is the `ARCR` gate above: mirroring status bits does
not make `cmpr eq` match, so the block containing the mailbox poll still never
runs. Both have to be right.

### Two things to settle next

1. **Which bits of PA7 the host owns and which the DSP sets.** The low-byte
   split above is a guess that follows from `0x1c` being a byte port; the
   bridge's existing `DSP_STREAM_READY` / `DSP_SEND_COMPLETE` constants say the
   upper bits are the DSP's. Confirming that from the supervisor's own writes
   is static analysis on an image already here.
2. **What sets `ARCR`.** `samm @19` at `0x9644` is the only writer and is
   reached from the block it gates. Either something outside the block sets it -
   which nothing found so far does - or the DSP arrives at the resident with it
   already set, which would make it a property of the boot path rather than of
   the resident.

## Smaller things still known wrong

These are real but none of them block a call:

* **No ring trip on the `--ring` path.** `machine.py` ORs the ring-detect bit
  from `RingSource.present()` with no off-hook gate, so answering a `--ring`
  call leaves the detector asserted for the whole call. `LineExchange` gets this
  right; `RingSource` does not.
* **The boot transport is the wrong mechanism**, though it reaches the right
  state - see [dsp-boot-transport.md](dsp-boot-transport.md).
* **`XRDY` is optimistic on the legacy TDM path**, because that path models no
  framing on the primary serial port.
* **Codec gain, high-pass and loopback are decoded but not applied** to samples.
* **The four-bit part identity at supervisor `0x287f9`** is unmodelled, so it
  reads floating bits, and six sites branch on the result.
