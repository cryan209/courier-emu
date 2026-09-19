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

### The next question, singular

Does `@48` ever get written on this image - by any site, in any configuration?
If nothing writes it, the dispatcher at `0xba0b` is not the live V.8 state
machine on 403 and the signature match is a false friend; the overlay copies at
`0xadf5` and `0xc528` would then be the candidates, and neither can run until an
overlay is downloaded. That is a static question and should be asked statically
before another run.
