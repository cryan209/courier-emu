# A modulation, not a tone: V.21 and Bell 103 from the firmware's own modulator

[answer-tone.md](answer-tone.md) got the datapump to emit a 2100 Hz answer
tone. That is a signalling tone: one oscillator, no data. This document gets
the same firmware to run an actual **modulation** - FSK, keyed by a data bit -
and then to **demodulate its own transmitter through analogue loopback**, which
is what the `&T` self-test does. All four 300 bps bands recover a 511-bit
sequence without error.

Getting there required fixing four opcodes in the C5x core. Those are the
reason none of this worked before, and they are the most portable result here.

## The four bands, found by arithmetic

Reading the resident bank for 16-bit constants that are phase increments at the
dial path's 7200 Hz turns up four adjacent pairs, in six setup routines at
`d790`-`d7d7`:

| setup | `@72` | `@73` | frequencies | modulation |
|---|---|---|---|---|
| `d790` | `22d8` | `29f5` | 980 / 1180 Hz | V.21 channel 1 (originate) |
| `d79a` | `2d28` | `260b` | 1270 / 1070 Hz | Bell 103 originate |
| `d7b4` | `3aab` | `41c7` | 1650 / 1850 Hz | V.21 channel 2 (answer) |
| `d7be` | `4f1c` | `4800` | 2225 / 2025 Hz | Bell 103 answer |

Four more routines set a receive carrier: `d7c8` 1080 Hz, `d7d0` 1170 Hz,
`d7a4` 1750 Hz, `d7ac` 2125 Hz. Those are the band centres of the four
transmit pairs.

Every one of these eight numbers lands on a standard 300 bps frequency only if
the sample rate is 7200 Hz. With `0x4aab` and `0x0ca7` from the answer tone,
that is now three independent confirmations of the rate that
[audio-312-path.md](audio-312-path.md) originally inferred from DTMF alone.

## The modulator

Program `d95f`, installed in the mixer's first callback slot:

```text
d95f  bit    7, @50     ; the data bit - bit 8 of the cell
d960  lacc16 @72        ; mark increment
d961  xc     1, ntc
d962  lacc16 @73        ; ...or space
d963  add16  @63        ; frequency offset
d964  add16  @40        ; phase accumulator
d965  sach   @40
d966  calld  8b0f       ; sine
d96a  bit    11, @70    ; transmit enable
d96c  xc     1, tc      ; ...else feed the filter a zero
d96d  lacc   @42
d970  calld  8a88       ; shaping filter, coefficients addressed by @5f
d975  mpy    @67        ; amplitude
d977  sach   @47, 1     ; the transmit sample
```

`courier_emu.fsk` calls the ROM's own setup routine, installs `d95f`, and runs
the same mixer and serial ISR as `audio312` and `answer_tone`. **This harness
supplies the data bit from outside, once every 24 samples**, and on that basis
a 511-bit maximal-length sequence modulates and demodulates with zero bit
errors in three of the four bands:

| mode | mark | space | bit errors over 511 |
|---|---:|---:|---:|
| `v21-originate` | 980 | 1180 | 0 |
| `v21-answer` | 1650 | 1850 | 0 |
| `bell103-answer` | 2225 | 2025 | 0 |
| `bell103-originate` | 1270 | 1070 | 34 |

The last row is a limit of the **demodulator in this tool**, not of the
firmware: its two tones are 200 Hz apart at one bit per 24 samples, closer than
non-coherent energy detection can separate, and a real Bell 103 receiver uses a
discriminator rather than two matched filters. The modulator itself is exact -
holding the bit produces 1270.0 Hz and 1070.0 Hz measured.

> **Withdrawn: the 300 baud figure was this harness's, not the firmware's.**
> An earlier version of this document called 24 samples a bit "exactly
> 300 baud", because 7200/24 is 300. That is arithmetic about a number this
> harness chose, not a measurement of the ROM. The firmware has its own
> transmit bit clock and it says something else: `@50` is a shift register that
> `d978`-`d983` shifts right **once per modulator invocation**, reloading when
> the marker bit falls out, so it presents one data bit per invocation. Since
> the same invocation advances the carrier phase by an increment that is only a
> V.21 frequency at 7200 Hz, taking both at face value gives 7200 bps, which is
> not a 300 bps modulation. Something about how often this datapump's callback
> actually runs is therefore still unaccounted for, and until it is, no baud
> figure here is the firmware's. What the increments do establish is the
> **modulation's identity** - the frequencies are exact - not its bit rate.

```sh
.venv/bin/python -m courier_emu.fsk \
  --rom artifacts/courier-board-21210-capture-403/courier-board.rom \
  --output /tmp/fsk --mode v21-answer
```

Saved runs for all four are in `artifacts/fsk-01/`.

## The loopback table

Eight dispatch entries at `d7d8`-`d812` each call one transmit setup and one
receive setup. Sorting them by whether the receiver sits inside the
transmitter's own band splits them exactly in half:

| entry | transmitter | receive carrier | |
|---|---|---:|---|
| `d7d8` | Bell 103 answer 2225/2025 | 2125 | **own band** |
| `d7e3` | Bell 103 answer 2225/2025 | 1170 | normal |
| `d7e9` | Bell 103 originate 1270/1070 | 1170 | **own band** |
| `d7f4` | Bell 103 originate 1270/1070 | 2125 | normal |
| `d7fc` | V.21 answer 1650/1850 | 1750 | **own band** |
| `d802` | V.21 answer 1650/1850 | 1080 | normal |
| `d808` | V.21 originate 980/1180 | 1080 | **own band** |
| `d80e` | V.21 originate 980/1180 | 1750 | normal |

A modem in a call never listens to its own transmit band - that is the whole
point of splitting the band in two. A configuration that does is a modem
listening to itself, which is what analogue loopback needs. So four of these
eight entries are the loopback self-test's datapump configuration, one per
300 bps modulation.

That began as an argument from the table's structure. The next section runs
it.

## The loopback, closed

The loop closes. The firmware's own transmitter now drives the firmware's own
receiver, and the receiver recovers the bits.

The bring-up is the ROM's, in the order dispatch entry `d7fc` and `d829`
perform it: the transmit setup, the receive setup, then `d94e` (install the
modulator at `d95f`), `d895` (initialise the AGC) and `d879` (install the
receiver at `d8aa` and clear its delay lines). Nothing is installed by hand;
the harness only supplies the data bit and the loop.

Three things had to be right, and each was wrong first:

* **The receiver raises `INTR 17` on every sample**, vectoring to program
  `0x0022`. The resident bank begins at `0x8000` and does not contain that
  vector, so the harness puts a bare `RETE` there.
* **The loop must be fed through the codec receive queue.** `DRR` is served
  from the core's codec queue, so the returned word goes in with
  `queue_codec_rx`. Feeding the line queue instead - which is what the first
  attempt did - leaves `DRR` at zero and looks exactly like a dead receiver.
* **The buffer pointer and PC must be restored each frame**, as `audio312` and
  the transmit-only path already do. Without it the ISR walks off the two-word
  window and `DXR` reads zero from the second sample - the symptom that made
  the first attempt look like a receiver failure when the receiver was fine.

With those, every transmitted word fed back as the next received word:

| mode | sampling offset | bit errors over 511 |
|---|---:|---:|
| `v21-originate` | 41 | 0 |
| `v21-answer` | 43 | 0 |
| `bell103-originate` | 44 | 0 |
| `bell103-answer` | 42 | 0 |

```sh
.venv/bin/python -m courier_emu.fsk --loopback \
  --rom artifacts/courier-board-21210-capture-403/courier-board.rom \
  --output /tmp/loopback --mode v21-answer
```

Saved runs are in `artifacts/fsk-loopback-01/`. Note that this is the
**firmware's** demodulator, not the crude two-tone detector further up: it
recovers Bell 103 originate, the mode that detector could not, without error.

### Two properties of the receiver, measured rather than assumed

**The sampling offset is the receiver's group delay.** It is not a free
parameter fitted per run: it is stable per mode across patterns and seeds, at
41 to 44 samples, and the tests assert it lands in that band rather than
accepting whatever scores best.

**The decision polarity belongs to the modulation, not the harness.** `@6a` is
an integrate-and-dump on the signal mixed against the band centre, so its sign
says whether the tone is above or below that centre - not which bit it is.
V.21 puts mark *below* the centre (1650 against 1750) and Bell 103 puts it
*above* (2225 against 2125), so the two families decode with opposite sign.
`slice_bits` takes that from the frequency table. Getting this wrong is what
made V.21 appear to fail while Bell 103 passed, on an otherwise identical run.

### What is still open

**48 samples a bit is measured, not derived.** It was found by scanning the
symbol period for the error minimum, and it is sharp - 48 gives zero errors
where 40 and 36 give seventeen. But it does not reconcile with the transmit
shift register above, which presents one bit per invocation, and this harness
overrides that register rather than letting it run. So the receiver's natural
symbol period is 48 modulator invocations, and what that is in real time still
depends on the callback rate this document could not establish. If the
callback runs at 7200 Hz it is 150 baud; V.21's 300 baud would need 14400.
**Neither the baud rate nor the callback rate is settled here.**

## Which band a receive setup hears, measured

The loopback argument above rests on the receive setup choosing the band the
receiver listens on. That was read off the constants; this measures it.

One signal, four receivers. The firmware's own modulator produces a **V.21
answer** signal at 1650/1850, the transmitter is left on the originate band and
gated off, and the same signal is handed to the receiver with each of the four
receive setups installed in turn:

| receive setup | carrier | bit errors over 120 |
|---|---:|---:|
| `d7a4` | 1750, the answer band centre | **0** |
| `d7ac` | 2125 | 56 |
| `d7c8` | 1080 | 64 |
| `d7d0` | 1170 | 64 |

Only the setup whose carrier is the signal's own band centre recovers anything;
the other three are at chance. So the receive setup selects the band, and the
four dispatch entries that pair a transmitter with its own band centre really
are the modem hearing itself. Whatever else they are for, they cannot be a
configuration for a call: no V.21 or Bell 103 modem in a call listens to the
band it is transmitting in.

```sh
.venv/bin/python -m courier_emu.fsk --band-scan --mode v21-answer \
  --rom artifacts/courier-board-21210-capture-403/courier-board.rom \
  --bits 111111111000000000... --output /tmp/band
```

The run above is saved in `artifacts/fsk-band-01/`, with the dispatch tables
and mode flags read out of the same image. `--bits` is worth passing: the
default 511-bit sequence is four receiver runs long here.

## Where those entries are dispatched from

Mailbox commands **`10`** and **`11`** in the table at `83e9` enter at `9b34`
and `9b38`. Each loads a table base into `@7c`; both then take an index from
the mode flags and jump:

```text
9b34  splk   @7c, #9b48     ; one table
9b38  splk   @7c, #9b51     ; the other
...
9b3e  call   9b5a           ; the index, from the mode flags
9b40  retc   ntc            ; no flag set, nothing to start
9b42  opl    @6f, #4040
9b44  add    @7c
9b45  tblr   @7d
9b47  bacc
```

The selector at `9b5a` is a run of `bit n, @cell ; lacl #index ; retc tc`, so
each modulation's slot is fixed by which flag it sets. Nine slots:

| slot | flag | table `9b48` | table `9b51` | |
|---:|---|---|---|---|
| 0 | `@27` bit 14 | `9d00` | `9d00` | **overlay 6's entry** |
| 1 | `@26` bit 11 | `b000` | `b000` | **overlay 7's entry** |
| 2 | `@27` bit 12 | `b052` | `b052` | resident |
| 3 | `@26` bit 10 | `c533` | `c7fd` | resident |
| 4 | `@26` bit 12 | `cd61` | `cce0` | resident |
| 5 | `@26` bit 13 | `cd79` | `ccfa` | resident |
| 6 | `@27` bit 5 | `da31` | `d9bc` | resident |
| 7 | `@27` bit 3 | `d808` | `d7fc` | V.21, own band |
| 8 | `@26` bit 9 | `d7e9` | `d7d8` | Bell 103, own band |

`courier_emu.fsk.mode_tables` and `mode_flags` read both out of the image
rather than repeating them.

A second dispatcher on the **same flag bits** - `9da6`, `a00d`, `9dc1`, `a054` -
branches instead to the four cross-band FSK entries `d7f4`, `d7e3`, `d802`,
`d80e`, and for slots 4 and 5 to `cd13`/`cd42` and `cc9e`/`ccc6`, neighbours of
the table's `cd61`/`cd79` and `cce0`/`ccfa`. So these modulations have two
entry points each, and for the two that can be read, the pair differs by
exactly which band the receiver is put on.

The path leaves a marker. `9b42` sets `@6f` bit 14, and every entry it
dispatches to sets it again - overlay 6's `9d00` writes `#4042`, overlay 7's
`b010` and the resident `b052` write `#4841` - where entries reached any other
way write `#0040` or `#0043`. Five resident sites test that bit and configure
differently; at `8d6f` it swaps the transmit carrier between `#2000` and
`#4000`, which at 9600 Hz are 1200 and 2400 Hz, the V.22 originate and answer
carriers - again a transmitter moved onto the band its own receiver is on.

## The overlays carry no loopback entries of their own

Nothing in overlays 6, 7 or 8 sets up an FSK band. Scanning each image for
`splk @72` and `splk @73` - the mark and space increment cells - finds the
eight resident writes and nothing in overlay 6 or 7; overlay 8's nine hits are
loop counters on another data page (`splk @73, #0005`, `#001f`, `#0004`). The
four 300 bps bands, all eight transmit/receive pairings, and both dispatchers
are resident.

What the overlays do have is a place in the table: slots 0 and 1 are their
entry addresses. Their loopback behaviour is **not** established here, and two
things say to leave it that way. No overlay tests `@6f` bit 14, and none of
them calls any of the five resident routines that do - their entries set the
bit and go. And what that bit means is itself unsettled: the `8d6f` reading
above is as consistent with an answer-side flag as with a self-test flag, and
only the two FSK slots have been shown to listen to themselves.

## The core bug that hid all of this

`MAC`, `MACD`, `MADD` and `MADS` are the C5x's FIR instructions: each walks a
coefficient table in **program** memory alongside a data window. Two things
were wrong in `native/c5x_ops.ipp`, and together they made every filter in the
firmware return zero or nonsense:

* **The coefficient address did not advance under `RPT`.** These four relied on
  the outer repeat loop, which re-executes the instruction with the program
  address reset. A `rpt #0e ; macd *-` therefore convolved a 15-sample window
  against one constant coefficient instead of fifteen different ones.
* **`MADD` and `MADS` read their coefficient from data memory** at BMAR. They
  address program memory. Every coefficient table this firmware uses - `d9a3`,
  `d9b2`, `d98f`, `872f` - is a program address sitting just past the code that
  scans it, so the data-memory read returned zero for all of them.

Both are fixed in the shape the file already uses for `TBLR` and `BLPD`:
consume the repeat internally, incrementing a local `pfc`. All four now also
load `TREG0` with the data operand, as SPRU056D specifies.

`tests/test_c5x_anchoring.py` pins it with a four-tap `MADS` whose answer is
checked against hand arithmetic; reverting either half of the fix fails it.

The fix is what made this document possible, and it retroactively removes a
limitation recorded in [answer-tone.md](answer-tone.md): ANSam's `8712` and
`8716` variants were silent only because their shaping filter returned zero.
They now render, with the 15 Hz modulation visible as a symmetric sideband pair
at 2085 and 2115 Hz, each about 10% of the carrier.

## Two traps for anyone extending this

Both cost real time here, and both are silent - the code runs and produces a
plausible wrong answer.

1. **ARP, not the register name.** `BANZ *-`, `MADS *+` and friends index
   through whichever register `ARP` points at. `LAR AR1, ...` does not change
   `ARP`. The firmware's mixer sets `ARP` to 1 at `80c9`, so a harness that
   enters below that line silently uses `AR0`.
2. **Data page 0 is the memory-mapped registers.** `SPLK @1f, #x` writes BMAR
   only with `DP` at 0; on any other page it writes an ordinary variable.
