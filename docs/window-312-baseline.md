# The DSP 3.1.2 readback window: baseline, and what it cannot see

The `0x60`/`0x62` window is the only channel that carries DSP state to the
host. This records what it holds on an idle 3.1.2 board, corrects two profile
constants that were carried across firmware revisions unchanged, and states
which audio-path questions the window cannot answer at all.

Evidence: `artifacts/dsp-window-pump-312-01/`, a 24-pump run on the 20.16 MHz
board on `/dev/cu.usbserial-21210`, supervisor 7.4.16 / DSP 3.1.2. No dialing,
no firmware upload; the six mailbox registers and the bit-2 acknowledgement are
the only writes. The modem answered `AT` afterwards.

## The stream is seven words, not six

`STREAM_SOURCES` listed six cells - `0307, 03ba, 0385, 030f, 031c, 0be6`. That
is one short. In both captured board images the streamer's last step calls a
packer that reads DP-007 cells `0381` and `0383`, NORMs the sum, and leaves an
exponent/mantissa pair in scratch `007d`, which is then streamed like any other
source. So a run carries a seventh word that is **computed rather than read**.

The hardware says the same thing without reference to the disassembly. Port
`0x1c` bit 2 is the DSP's "another word is ready" flag, and across 24 pumps it
stayed set for exactly seven, then cleared and stayed clear:

| pumps | `1C` | meaning |
|---|---|---|
| 1-7 | `FD` | bit 2 set: a further word pending |
| 8-24 | `F9` | bit 2 clear: the sequence is finished |

The handler moved between revisions but its shape did not:

| | 3.0.13 | 3.1.2 |
|---|---|---|
| handler | `8489` | `8470` |
| streamer (`out *, 0060`) | `84b7` | `849e` |
| packer | `84bc` | `84a3` |
| sources | the same six | the same six |

## Every word is zero on an idle unit

All 24 pumps read `0000`. The window held `004b` before arming, so it did move;
it moved to zero and stayed there. This is the sharper form of the note first
made in `artifacts/dsp-window-pump-01/` - the sources are not merely quiet on an
idle unit, they read as zero - and it is a clean baseline: any non-zero word
after a command is a signal.

One thing this run does not separate: seven zero-valued cells, versus a stream
that ran its length while its sources happened to be empty. The bit-2 sequence
establishes the length, not the provenance of the values.

## The supervisor chain moved, and was re-derived rather than assumed

The pump refuses to run unless the chain vector it finds is an address the
supervisor's own chain parks or steps at, because the mailbox interrupt
dispatches through that vector. On this board the check fired: the vector cell
`[0x02d3]` read `0000`.

That cell is 7.3.14's. In 7.4.16 the chain vector is **`[0x01cd]`**. The
derivation is structural, not a guess: `mov [cell], imm` writes whose immediate
is a nearby code address pick the self-chaining vector out uniquely, and there
are exactly 14 of them on `02d3` in 7.3.14 and 14 on `01cd` in 7.4.16, with the
chain code shifted a constant `+0x32` and the arm site moving `6d08` -> `6d52`.
Every one of the 18 steps maps at that shift, including the bare `ret` the chain
parks on (`200c` -> `203e`). The countdown and header keep their positions
either side of the vector and are referenced the same number of times inside the
chain region. The four buffers map at the same instruction offsets, a constant
`-0x10c`, with the length/count/pointer trio intact at `-4/-3/-2`.

The board then confirmed it: `[0x01cd]` reads `200d`, which is exactly what
7.4.16's arm site writes there, and the run proceeded.

## What the window cannot see

None of the audio path's cells is a source of either window:

| cell | what it is | streamed? |
|---|---|---|
| `0390`/`0391` | the ISR's sample-buffer pointer | no |
| `0399` | decremented once per codec interrupt | no |
| `039a` | the installed tone callback | no |
| `03c0`/`03c1` | the two oscillator phases | no |
| `03f2`-`03f5` | phase increments and amplitudes | no |

Two consequences, both of which change work already written down.

**The tone-diff experiment in [driving-the-tones.md](driving-the-tones.md)
cannot observe the tone state on this firmware.** Arming `06`, sending the tone
sequence and diffing the window tests whether the tone path perturbs six
datapump cells it does not write. A null result there would say "not visible
here", which that document already anticipated as its second blocker - this
makes the blocker specific and certain rather than a risk.

**The 7200 Hz sample rate in [audio-312-path.md](audio-312-path.md) stays an
inference.** `0399` is the natural measurement - read it twice across a known
interval, against the 5.000 ms tick that
[hardware-timebase-and-audio-path.md](hardware-timebase-and-audio-path.md)
established - but it is not reachable. A static walk of all 128 dispatch entries
at `83e9`, looking for handlers that reach the `out *, 0060` site, found only
`07`, `46` and `57`; tag `4a` matched only because `opl @6f, #0060` is an OR
with a constant, not an output. That walk has a bounded instruction budget, so
it is evidence that no arbitrary DSP-data read exists, not proof.

## Is `0399` mirrored in host RAM? No

Asked two ways, and both say no.

**Statically, the DSP never sends it.** Every DSP-to-host word leaves through
the sender at `83bf`, and a walk of all 128 dispatch entries reaches none of the
sites that touch `0399`. Of the sites a linear scan turns up, only two are real
code: the ISR at `8179`/`817b`, and a block at `d035`/`d038` that three
control-flow sites target under `ldp #007`. The other three candidates are data
read as code and have zero control-flow sites - `8d04` is a fourteen-word table
of `0011`-`001f`, and the `a2e0` region decodes to out-of-range branches. Note
also that `samm @19` and `lamm @19` address memory-mapped register `0x19`, not
`0399`, so those sites do not belong on the list at all.

**Empirically, no host cell runs at an audio rate.** `artifacts/host-ram-rate-01/`
re-reads the five pages that moved between the two live passes in
`courier-board-21210-ram-01`, fourteen times over 18.3 s, each read stamped with
a host monotonic clock, and fits a rate to every 16-bit cell. Thirty cells move.
Exactly one is a counter:

| address | rate | what it is |
|---|---:|---|
| `0x012a` | **200.00 Hz** | the 5.000 ms firmware tick |

The other twenty-nine are non-monotone with a handful of distinct values - a
scratch region churning, whose fitted "rates" are artefacts of unwrapping noise.
One of them, `0x00e6`, is monotone only after unwrapping and returns to the value
it started at, which is what that artefact looks like from the inside.

That `0x012a` lands on 200.00 Hz is a fourth independent line on the timebase,
and the most direct one: the other three in
[hardware-timebase-and-audio-path.md](hardware-timebase-and-audio-path.md)
infer 5.000 ms from the `&T1` slope, from the firmware's own seconds-to-ticks
multiply, and from the 80186 timer constant. This reads the tick counter itself.

The scan had the resolution to find what it was looking for: a sweep is about
1.3 s, in which a 7200 Hz 16-bit counter advances about 9,360, well inside one
wrap. So this is a negative result rather than an inconclusive one - for the low
64 KiB, and within it for the pages that moved between two passes 69 s apart. The
relocated peripheral block at `0xff00` and the `0x10000..0x1ffff` window were not
scanned.

The practical consequence: **measuring the codec clock needs a path that does not
exist yet.** Not the fixed windows, not a mailbox query, and not a host-side
mirror. The remaining candidates are all builds rather than reads - a tick-hooked
sampler that watches the window densely, or a route that gets `0399` into
something the host can already see.

## Not established here

Tag `46`'s window is still decoded only for 3.0.13. In 3.1.2 its handler moved
to `84ba` and reads a different table, so `PROGRAM_STREAM_BASE` and the `03db`
index do not carry across; `--arm 46` is refused on this firmware and the tests
pin that refusal.

Separately, both board captures carry a DSP payload of a single segment at
origin `0x8000`. The `0x0000` segment that section 3 of the timebase document
reasons from belongs to `main211`, not to either board image, so the question of
what this board runs below `0x8000` is open and is not answered by these
captures.
