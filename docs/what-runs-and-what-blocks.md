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

## What is needed, in order

1. **Make the host -> DSP mailbox deliver.** The measurement to explain first is
   87 delivered against 1 consumed. Either the resident's poll of I/O `0x51` is
   not seeing what the bridge publishes, or the handshake the bridge models is
   not the one the resident waits on. This is the whole blocker for `--exchange`.
2. **Then re-measure the DAC.** With a command delivered, the datapump should
   emit; `--dsp-tx-pcm` going non-zero is the test, and the DTMF frequencies in
   it - interpreted at the codec's current rate, not 9600 - are the check that
   the rate chain is right.
3. **Then the exchange should decode digits**, which is already implemented and
   already receives frames; it has only ever been handed silence.

Steps 2 and 3 need no new code if step 1 is right. That is worth stating
plainly: **the remaining work on this path is one problem, not a list.**

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
* **C5x I/O space and data MMR `0x50`-`0x5f` are one array** in the core, where
  a real 'C50 keeps them separate.
* **The four-bit part identity at supervisor `0x287f9`** is unmodelled, so it
  reads floating bits, and six sites branch on the result.
