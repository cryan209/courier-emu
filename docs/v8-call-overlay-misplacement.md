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

## The next run

Point the two PC tests at the table above - which copy is live depends on
whether an overlay is loaded, so all four are worth watching - and take one
originate run. That is one question: does the firmware's V.8 dispatcher run at
all on 302/403, and if it does, which handler does `@48` hold when it stops.
