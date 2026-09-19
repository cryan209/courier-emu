# The call-overlay publication is a 2.1/2.2 step applied to 302/403

One question: why a 302/403 run does not get past V.8. This does not answer it.
It removes a wrong answer that any such run is standing on, and it repoints the
instrument that was supposed to be reporting the failure.

## The 2.1/2.2 arrangement, which is real

`bridge.py` carries three constants and a comment:

```python
# Call overlay 7 is stored at b9c0 with branches already linked for c418. The
# ASIC publishes that bank over c418..ce6f when it starts the datapump.
C50_CALL_OVERLAY_SOURCE = 0xB9C0
C50_CALL_OVERLAY_DESTINATION = 0xC418
C50_CALL_OVERLAY_SIGNATURE = bytes.fromhex("4a6908e3")   # lacl @4a ; bcnd ...
```

That describes the 2.1/2.2 family, and
[c52-v8-static-analysis.md](c52-v8-static-analysis.md) independently gives
`main211.xmf`, `main2205.XMF` and `3453Bv2.1.1.xmf` an overlay source of
`b9c0`/`b9c8`. The mechanism is stored-here, runs-there: the stored copy's
branches are pre-linked for `0xc418`.

## On 302/403 the signature matches code that is already in place

`_find_call_overlay` scans the resident bank for the signature. Both images
give **two** hits, and the one it accepts is the wrong one:

| image | hit | `size = (0xc418 - source) * 2` | taken |
|---|---|---|---|
| 302 | `0xba2f` | 5074 | **yes** |
| 302 | `0xca41` | -3154 | no, negative |
| 403 | `0xba0b` | 5146 | **yes** |
| 403 | `0xca1d` | -3082 | no, negative |

The accepted block is not a stored overlay. Its branches are linked for its own
address:

```text
ba2f  lacl  @4a
ba30  bcnd  ba3c, neq        ; <- ba3c, not c425
ba32  lacl  @4d
ba33  bcnd  ba3c, eq
ba35  sach  @4d
ba36  lar   ar1, #03c8
ba38  rpt   #02 ; tblr *+ ; add #03 ; sacl @4b
ba3c  lacl  @48
ba3d  bacc
```

So the harness copies 2,537 words of **live, self-linked resident code** to
program `0xc418`, landing it across `0xc418`-`0xce00`, where every internal
branch in the copy still points back into `0xba2f`.. and where the resident bank
had its own code - on 403 `0xc81a` is
`splk @04, #038d ; splk @2b, #0003 ; splk @1b, #c821`, and on 302 the originate
slot table's entry 3 is `0xc557`, inside the overwritten span.

**The 2.1/2.2 profile's own note already says these are two different transfer
protocols** - an update payload strobing one window on `0x1e` against a flash
ROM's `e47b` downloader alternating two windows on `0x18`. 302 and 403 are flash
ROMs and carry the real overlay table
([dsp-overlays.md](dsp-overlays.md)): overlay 6 at `0x9d00`, 7 at `0xb000`, 8 at
`0xdc00`. The `0xc418` publication is a third, incompatible thing.

## Where the dispatcher actually is

The same signature, found properly, gives three copies per image - and the
overlay ones carry a two-word guard the resident ones do not:

| image | resident | resident (2nd) | overlay 6 | overlay 7 |
|---|---|---|---|---|
| 302 | `0xba2f` | `0xca41` | `0xade8` | `0xc529` |
| 403 | `0xba0b` | `0xca1d` | `0xadf5` | `0xc528` |

```text
ade6  bit   1, @4c        ; the overlay copies only
ade7  retc  ntc
ade8  lacl  @4a
```

All four are the same routine as 2.1/2.2's `0xc418`, down to the identical
`lar ar1, #03c8` table pointer.

## What this does and does not establish

**Established.** The native core's V.8 instrumentation is pinned to 2.1/2.2
addresses:

```cpp
if (previous_pc == 0xc418) { ++m_v8_dispatches; m_v8_record = ...; }
bool negotiation_loop = previous_pc == 0xc7f7 || previous_pc == 0xc81a ||
    previous_pc == 0xc853;
```

`0xc7f7`, `0xc81a` and `0xc853` are the 2.1/2.2 divide loops from the static
analysis; on 302/403 they are ordinary resident routines. And `0xc418` only ever
becomes `lacl @4a` **because the misplacement put it there**, so
`v8_dispatches` on a 302/403 run counts entries to the injected copy, not to the
firmware's own dispatcher. Any reading of those counters on this target is
worthless.

**Not established.** That this is *the* reason V.8 does not complete. These
counters are write-only - they are exported in the status struct and never feed
back into execution - so the instrumentation half is blindness, not causation.
The copy itself is a live-code overwrite and is a defect on its own terms, but
nothing here traces a failing V.8 exchange to it. The honest state is that the
one instrument aimed at this question has been aimed at the wrong firmware, and
no run has yet asked the question with it aimed correctly.

**The native V.8 tone bootstrap is not implicated either.** `detect_v8_tones`,
the write to `@0306` and the `0x0100` bit in `@039f` are all gated on
`m_v8_mode`, which is only left `Off` unless `set_v8_calling` /
`set_v8_answering` is called - and `bridge.py` calls those only under
`legacy_carrier_fallback`. In a normal run the firmware owns both cells, as the
comment there claims.

## The run

Both changes are in. The core takes its dispatcher addresses from the image
(`Bridge._v8_dispatch_addresses`, the same signature over the resident bank and
every declared overlay), and `_find_call_overlay` now requires the candidate to
be **pre-linked for the destination** - its first branch target must be
`0xc418 + 0x0d`, which 2.1/2.2's stored copy satisfies and a self-linked
resident copy does not.

A 403 linked pair, `ATX0` + `ATDT5551234` against `ATA`, 85 M instructions
(`artifacts/v8-dispatcher-403-01/`):

| | A base | A gated | B base | B gated |
|---|---:|---:|---:|---:|
| `v8_dispatches` | 22,471 | 22,471 | 21,172 | 21,172 |
| `v8_dispatch_pc` | `0xba0b` | `0xba0b` | `0xba0b` | `0xba0b` |
| **`v8_handler` (`@48`)** | **0** | **0** | **0** | **0** |
| `v8_countdown` (`@4a`) | 0 | 0 | 0 | 0 |
| `v8_flags` (`@4d`) | 0 | 0 | 0 | 0 |
| `v8_rx_peak` | 0 | 0 | 0 | 0 |
| `negotiation_audio.rms` | 0 | 0 | 0 | 0 |
| `overlay_downloads` | 0 | 0 | 0 | 0 |
| `call_overlay_available` | True | **False** | True | **False** |

`base` is the same command with the pre-linked test forced true - the old
behaviour. **Every V.8 number is identical.** Only `call_overlay_available`
moves, and `call_overlay_active` was already false in both, so the misplaced
block was found but never published in this run. The gate removed a latent
hazard and changed nothing observable here; it did not cause any of what
follows.

### Three things the run says

**1. The dispatcher runs.** `0xba0b` is the 403 resident copy, entered 22,471
times on the originator. The instrument now reports.

**2. It has no handler.** `@48` is zero, and so are `@4a` and `@4d`, so every
entry takes the short path - `bcnd ba18, eq` straight to `lacl @48 ; bacc` -
and branches to program address **0**. In 2.1/2.2 the handlers are installed by
the `c509`/`c527`/`c54d`/... sites writing into `@48`; nothing installs one
here. The state machine is spinning on a null vector.

**3. There is no audio at all.** `v8_rx_peak`, `rms` and every tone bin are
zero on both sides, in the baseline too. The DSP receives no line samples, so
the V.8 exchange has nothing to detect even if a handler were installed.

### What (3) is downstream of

The codec receive block is gated on `m_call_tdm_active`, which has exactly two
setters and both sit inside `_activate_call_overlay`, behind
`self._call_overlay is not None`. With the gate correct that path is now
properly dead on a flash ROM - and it was never the right trigger for a flash
ROM anyway, which loads its datapump through the real overlay table over ports
`0x18`/`0x1e`.

But `overlay_downloads` is **0**, so that does not happen either. This document
does not get to call that a bug: [datapump-dispatch-gate.md](datapump-dispatch-gate.md)
records that a plain dial never reaches the loader, because the discriminator
answers equal - only the leased and `&T1`/`&L1` configurations do. So a plain
`ATDT` run having no datapump overlay may be the firmware behaving correctly,
and the line-audio gate being tied to the 2.1/2.2 publication is the modelling
defect standing behind it.


## Why there is no audio from the originator: the two ends stop at different times

The audio capture (`artifacts/v8-dispatcher-403-01/audio/`) splits the question
cleanly. `b-tx` and `a-rx` are **identical** - 23,841 nonzero samples, peak
17,188, running sample 96,273 to 120,113, which is 12.03 s to 15.01 s: the
answer tone, delivered to the originator sample for sample. The socket, the
7200-to-8000 conversion and the framing all work. `a-tx` is 127,200 frames of
zero, while the core says side A's datapump wrote 5,176 nonzero samples into
`m_line_tx`. The samples exist and none reached the wire.

### The instrumented answer

`Bridge._line_service` counts each branch of `_service_line`. One 403 pair,
`artifacts/v8-dispatcher-403-01/run-instrumented.json`:

| | A (originate) | B (answer) |
|---|---:|---:|
| `_service_line` calls | 77,786 | 77,786 |
| `no_codec_clock` | 1 | 1 |
| **`originate_return`** | **0** | **0** |
| `fallback_frames` | 0 | 0 |
| `drained_frames` | **228** | 158 |
| `buffer_left` | 126 | 737 |
| `line.frames` shipped | **158** | 158 |
| `line.connected` | **False** | True |
| `line.error` | *the far end closed the line* | - |

> **The originate early return was not it.** An earlier revision of this
> document proposed the `not self._call_overlay_active` guard in
> `_service_line` as the cause, on the strength of its being the only
> originate/answer asymmetry in that function and of a 69%/99% shipping split.
> It fires **zero** times in this run, on both ends. The inference was wrong
> and the guard is exonerated.

A's buffer is nearly empty at the end - 126 samples - so nothing is stuck. A
calls `_service_line_frame` **228** times and only **158** of them reach the
peer. The other **70 frames are exactly 7.00 s**, which is the shortfall the
previous revision measured and misexplained as an unshipped tail. They are not
unshipped; they are shipped into a socket that has already closed.

### The two instances diverge by 44 % in line time

Both ends stop at the same 85,000,000 x86 instructions, and that is not the
same amount of call:

| | A | B |
|---|---:|---:|
| x86 instructions | 85,000,000 | 85,000,000 |
| DSP instructions | 276,637,801 | 243,300,764 |
| codec samples produced | 164,278 | 114,428 |
| **codec time** | **22.82 s** | **15.89 s** |

B reaches its budget at 15.89 s of line time and exits; A runs on to 22.82 s
talking to nothing. And the answer tone A is responding to lands at 12.03 s -
15.01 s, right at the end of B's life, so **every nonzero sample A produces is
generated after B has gone.** That is why `a-tx` is silent end to end rather
than merely late: A had nothing to say until the last second of B's run, and
said it afterwards.

This is a harness fault, not a firmware one. Pairing two instances on an
instruction budget each, when their instruction-to-codec-sample ratios differ by
44 %, gives them different clocks on a shared wire. The line socket pairs them
frame for frame, so the shorter-lived end silently truncates the call. Nothing
about V.8 can be concluded from a run that ends mid-exchange.

### What to fix, and what it does not explain

Budget the pair on **line frames** rather than x86 instructions, or run until
both ends agree they are done. Until then no linked-pair run reaches a
conclusion about negotiation.

It remains separately true that `@48` is zero through all 22,471 dispatches -
see above - and that is not explained by the truncation, because the dispatcher
is entered from the first seconds. Both faults are live; this one has to be
cleared first, because it makes every run unreadable after 15.89 s.

## Budgeting on line frames: the truncation is fixed, and A is still silent

`--line-frames N` on `run` and `link` stops each side once it has exchanged N
line frames. `Bridge.line_frame_budget` trips `Machine.request_stop` from
`_service_line_frame`, so both ends leave at the same point in *call* time and
`--instructions` is only a ceiling.

`artifacts/v8-line-frames-403-01/`, 300 frames against a 250 M ceiling:

| | A (originate) | B (answer) |
|---|---:|---:|
| `line.frames` | 300 | 300 |
| `line.connected` at exit | **True** | **True** |
| `line.error` | none | none |
| `buffer_left` | 2 | 2 |
| x86 instructions | 97,386,495 | 111,219,711 |
| codec samples | 216,007 | 216,007 |
| **codec time** | **30.00 s** | **30.00 s** |

The divergence is gone: identical call time, the instruction counts differing by
14% as they should, no socket closing under the other end, nothing left in
either buffer. The mechanism works.

**And it changed nothing about the audio.** Over 30 s, with both ends alive
throughout:

| wav | frames | peak | nonzero | span |
|---|---:|---:|---:|---|
| `b-tx` | 240,000 | 17,188 | 23,841 | 12.03 s - 15.01 s |
| `a-rx` | 240,000 | 17,188 | 23,841 | 12.03 s - 15.01 s |
| **`a-tx`** | **240,000** | **0** | **0** | - |
| **`b-rx`** | **240,000** | **0** | **0** | - |

`line_tx_nonzero` is 5,176 on A, the same figure as the truncated run, and
`a-tx` is 240,000 zeros.

> **Superseded.** The section above concluded that A's silence followed from
> the truncation - that every nonzero sample A produced was generated after B
> had gone. **That is refuted.** Given 30 s with the peer alive the whole time,
> A produces exactly the same 5,176 nonzero samples and still puts none of them
> on the wire. The truncation was real and worth fixing, but it was not why A
> is silent.

### What that leaves

The samples are in the core's own buffer - `m_line_tx` holds 216,007 words of
which 5,176 are nonzero, and the same array is what `line_tx_samples` hands the
bridge. `_exchange_tx_index` starts at zero, no core rebuild happened
(`core_rebuilt_at: 0` on both ends), and essentially the whole array was
consumed: 240,000 line samples shipped against 216,007 codec samples produced,
which at 7200-to-8000 is the entire stream. So the nonzero words were read out
of the array and did not survive to the socket.

Two candidates, neither tested: the codec-to-line conversion in
`_take_line_audio`, and whichever of the four `m_line_tx.push_back` sites on the
core side A's nonzero writes come from - `line_dac_writes` is 0, so they are not
the datapump's DAC slot. B's audio crosses the same conversion intact, which
argues against the resampler and for the write path, but that is an argument,
not a measurement.

## The transmit array and the bridge's reading of it disagree

The datasheets are not what is missing here. Following A's silence down to the
sample gives a contradiction inside the harness.

`Bridge._final_line_tx_scan` reads the core's entire `m_line_tx` once, at the
end of the run, so the answer cannot depend on when it was sampled. Beside it,
`_take_line_audio` now records how much it consumed and the peak it saw:

| | A (silent) | B (audible) |
|---|---:|---:|
| core counter `line_tx_writes` | 216,007 | 216,007 |
| core counter `line_tx_nonzero` | 5,176 | 29,375 |
| final scan total | 216,007 | 216,007 |
| final scan nonzero | 5,176 | 29,375 |
| final scan peak | **22,748** | **28,040** |
| final scan first nonzero | 27,412 (3.81 s) | 20,406 (2.83 s) |
| bridge consumed | 216,003 | 216,003 |
| bridge index reached | 216,003 | 216,003 |
| **peak the bridge saw** | **0** | **17,188** |

The final scan agrees with the core's own counters exactly, on both ends. And
the bridge consumed indices 0 to 216,002 - which **includes** index 27,412,
where A's first nonzero sample sits - and came away with a peak of zero.

The same disagreement is on the audible end, in smaller print: B's array peaks
at 28,040 and the bridge only ever saw 17,188, which is also the peak in
`b-tx.wav`. So the bridge's view is self-consistent with what reached the wire
in both cases; it is the *array* that has values the bridge never read.

Ruled out, each by measurement rather than by reading:

* **Not a core rebuild.** `core_rebuilt_at` is 0 on both ends, and `bootstraps`
  is 1.
* **Not trimming.** `m_line_tx` has exactly one `clear()`, in `reset()`, and no
  `erase`, `resize` or `pop_front` anywhere.
* **Not the resampler.** The peak is zero *before* the codec-to-line
  conversion, not after it.
* **Not an out-of-range read.** The accessor returns 0 past the end, but every
  index in question is well inside an array the same call reports as 216,007
  long.
* **Not the truncation**, and **not the originate early return** - both settled
  above.

A `std::vector` does not change a value at an index that has already been
written, so one of these two measurements is not measuring what it appears to.
That is the next thing to find, and it is a bookkeeping fault in the harness
rather than anything about the AC01, the ASIC or V.8. **No conclusion about the
firmware should be drawn from a transmit path in this state.**

### The next question, singular

Does `@48` ever get written on this image - by any site, in any configuration?
If nothing writes it, the dispatcher at `0xba0b` is not the live V.8 state
machine on 403 and the signature match is a false friend; the overlay copies at
`0xadf5` and `0xc528` would then be the candidates, and neither can run until an
overlay is downloaded. That is a static question and should be asked statically
before another run.

## The next question, answered: `@48` is written, and the dispatcher is still not it

Two faults in the instrument, then the answer.

**The originate gate stopped admitting a dialed call.** `_maybe_start_originate_engine`
returned unless `daa.operation == "originate"`, which its docstring explains -
it was written for the leased line, where the originating side never dials.
Once the socket path grew a digit receiver the operation moves to `"dialing"`
on the first digit, so the originating end stopped arming at all. A dialing
seizure now qualifies once the called party has answered, which is when a real
originating modem starts V.8 rather than putting CM under its own digits.

**`@48` was read from the wrong data page.** The core sampled `m_data[0x48]`.
A direct operand on the C5x resolves to `(DP << 7) | offset`, so that reading
asserts `DP == 0`. Measured at the dispatch, **DP is 0x180**, so `@48` is data
address **0xc048** and `@4a`/`@4d` are `0xc04a`/`0xc04d`. Every previous
report of a null handler was reading a cell the firmware never uses.

**And the image does write it.** A static scan of the 403 resident segment for
stores to the direct operands:

| cell | sites |
|---|---:|
| `@48` | 57 |
| `@4a` | 26 |
| `@4d` | 58 |

Almost every `@48` site is `splk @48, #<the address two words later>` -
`a688: splk @48, #a68a`, `bb55: splk @48, #bb57`, `e637: splk @48, #e639` -
so `@48` is a continuation vector and `lacl @48 ; bacc` resumes it. This is
the same arrangement as 2.1/2.2's `c509`/`c527`/`c54d` sites. The signature
match is not a false friend for want of writers.

### What the corrected instrument says

A 403 pair with `--answer-on-ring`, 600 line frames:

| | A (originate) | B (answer) |
|---|---:|---:|
| `v8_dispatches` | 47,425 | 62,759 |
| `v8_dispatch_pc` | `0xba0b` | `0xba0b` |
| `v8_dispatch_dp` | `0x180` | `0x180` |
| **`v8_handler` (`0xc048`)** | **0** | **0** |
| `v8_countdown` (`0xc04a`) | 0 | 0 |
| `v8_flags` (`0xc04d`) | 0 | 0 |
| `v8_record` | `0xb779` | `0x0194` |
| line audio produced | DTMF only | answer tone, 2.98 s |

`@48` is zero at every dispatch **on both ends, including the end that works**.
B emits a full 2.98 s 2100 Hz answer tone in this run while its handler vector
reads null through 62,759 dispatches of the same routine at the same page.

**So `0xba0b` is not the live V.8 state machine on 403.** That was the doc's
own stated alternative, and it is now the supported one: a routine whose vector
is null on the side that is successfully negotiating is not the routine doing
the negotiating. `v8_dispatches`, `v8_handler`, `v8_countdown` and `v8_flags`
should not be read as V.8 progress on this target, whatever page they are
sampled at.

What does separate the two ends is the mailbox stream. Their originated tags
barely overlap: A produces `0008:*` (`0008:0080` 673 times, `0008:0880` 387,
`0008:0885` 128) and B produces `0016:*` (`0016:0080` 895, `0016:0088` 116),
sharing only `0002:0000`, `0008:0000` and `000f:0000`. The two ends are running
different programs, and the question of why A never transmits belongs to that
difference rather than to `0xba0b`.

### Also settled since the sections above were written

The transmit-array contradiction at the end of the previous section is
resolved, and it was not a bookkeeping fault of the kind guessed there. The
supervisor resets the DSP two or three times per call; `reset()` clears
`m_line_tx`, and the bridge's output cursors did not restart with it, so the
start of every generation was skipped. Both measurements were correct and were
reading different generations of the array. The cursors now reset with the
core. `a-tx` is no longer silent on that account - it carries the dialed
digits - and `b-tx` went from 23,841 nonzero samples to 38,914.

## The mailbox tag difference is one report from two detector banks

The previous section left the two ends "running different programs" on the
strength of their originated tags barely overlapping - A produces `0008:*`,
B `0016:*`. That reading is too strong, and the code says so.

**Both tags leave from the same instruction.** Every originated message on
both ends is emitted at `pc 83d4`, in a generic sender at `0x83bf`:

```text
83c0  lacc  @79 ; sub @78 ; retc eq     ; ring empty, nothing to send
83cd  lar   ar1, @79                    ; read pointer into the ring at ff60
83ce  bit   15, *                       ; does a data word follow?
83cf  lacl  *+ ; and #7fff
83d3  out   @7d, 005e                   ; the tag
83d6  out   @7d, 005f                   ; high word, always 0000
83de  out   *+, 005f                    ; the data word, if bit 15 was set
```

So the "tag" is just the first word the caller queued, masked to 15 bits, and
bit 15 means one word follows. It carries no role of its own. The enqueue is
the routine above it at `0x83b0`, and the image has **118 call sites**.

**The two sites are the same report.** `0x9c93` and `0x9f02` are structurally
identical - tag, then the same payload:

```text
9c93  lacc  #00008008        9f02  lacc  #00008016
9c95  call  83b1             9f04  call  83b1
9c97  lacl  @2f              9f06  lacl  @2f
9c98  and   #00008fff        9f07  and   #00008fff
9c9a  call  83b1             9f09  call  83b1
```

Both send `@2f & 0x8fff`. Not two subsystems - one status word, reported from
two places.

**What differs is the detector bank above each one.** `a09b` is a threshold
compare: the caller points `ar1` at a measurement cell, puts a constant in the
accumulator, and `xc 2, leq` sets a bit in `@2f` on the result.

| site | cell | threshold | bit set |
|---|---|---|---|
| `9c7e` | `03be` | `2adb` | `0x0040` |
| `9c87` | `01fe` | `59d8` | `0x0080` |
| `9c90` | `01fa` | `61d7` | `0x0100` |
| `9ef0` | `03b8` | `47a2` | `0x0010` |
| `9ef9` | `03b6` | sum > `1f40` | `0x0400` |

So `@2f` is a bitmap of detector results and the tag identifies which bank
filled it. A runs the bank at `0x9c78`, B the one at `0x9ee8`, which is what
an originating and an answering end should do. The tag difference is a
consequence of the two roles, not evidence of a fault, and the payload
histograms read as that bitmap: A's commonest value is `0x0080`, exactly the
bit `9c87` sets, and B's is also `0x0080` with `0x0400` and `0x0008` added,
the bits its own bank sets.

**One asymmetry worth keeping.** After reporting, B calls `a0b3`
unconditionally (`9f0b`); A calls it only when bit 10 of `@2f` is clear
(`9c9c: bit 10, @2f ; cc a0b3, ntc`). Bit 10 is `0x0400`, which is the bit
`9ef9` sets from the energy sum at `03b6` - and it appears in B's payloads
(`0016:0408`, `0016:0448`) and in none of A's. On this run A therefore always
takes that call. Whether `a0b3` is what acts on a detection is not established
here, and no claim is made about what any of these banks detect; the cells and
thresholds are recorded above so the question can be asked directly.
