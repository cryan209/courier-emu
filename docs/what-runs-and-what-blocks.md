# The DSP's mailbox poll: PA7 and the ARCR compare

This file opened as "what it takes to make a call complete" and its original
blocker - the datapump putting nothing on the line - is resolved: see
[datapump-gate-403-addresses.md](datapump-gate-403-addresses.md), where an
answered call arms the datapump from the DSP with one message and `&L1`/`&T1`
arm it by command. What survives is the mailbox poll, which is a separate
mechanism and still partly modelled by hand.

## The status register is PA7, and the harness models one bit of it

Four routines in the resident all read `0xff57`:

```text
839b:  bit 15, @7d   -> bit 0    host message pending
83d6:  bit 14, @7d   -> bit 1    (also requires @79 != @78)
847a:  bit 13, @7d   -> bit 2    then dispatches through data 0x039e
80f8:  and #0200     -> bit 9
```

SPRU056D settles what that address is. Section 3.5.11 and 8.3.2: `0000h-004Fh`
is on-chip memory-mapped registers, `0050h-005Fh` is memory-mapped I/O -
`0x50` = PA0 through `0x5F` = PA15, with `0x60`-`0x7F` scratch-pad DARAM B2. And
Figure 5-10: `LAMM`/`SAMM`/`LMMR`/`SMMR` force the 9 MSBs of the address to
zero, so `lamm *` with `AR1 = 0xff57` genuinely reads `0x57`.

**So `0x57` is PA7, a real external I/O port, and these four routines poll a
status word the ASIC drives.** The mechanism is TI's; the bit meanings are the
ASIC's, and no TI document has them.

The harness raises `HOST_MESSAGE_PENDING` (`0x0001`) and nothing else. Bits 1, 2
and 9 are never set, so `0x83d6` and `0x847a` return immediately and whatever
they would set up - `ARCR` and the `@1a` task pointer among it - never happens.
`@1a` stays pointing at `0x8139`, a bare `ret`, which is why the main loop
dispatches to a no-op.

**Where to look for the rest.** The DSP's PA0-PA7 are fed from the 80186's
parallel window at ports `0x40`-`0x5e`, which `_publish_window` already models,
so whatever sets PA7's bits is 80186 code in an image this repository has. That
is a static-analysis question against the supervisor, not an unanswerable one
about an undocumented part. `0x847a`'s path through data `0x039e` and `bacc` is
the one shaped like "start this task".

## The mailbox dispatch itself works

Handing the resident one message and diffing the executed addresses:

| | distinct PCs | furthest PC |
|---|---|---|
| no message | 338 | `0x8487` |
| one message delivered | **397** | **`0x8b8c`** |

The DSP leaves idle, dispatches through the tag table at `0x8480`, runs a
handler and comes back - `0x86e9` is reached, next door to one of the dozen
`splk @1a, #8139` sites that put the task pointer back to idle. None of the
receive path is broken. What is wrong is **how often the DSP looks.**

## The ARCR compare, and what it actually tests

The poll lives in the block at `0x80c8`, which the main loop reaches only when
`cmpr eq` matches `AR7` against `ARCR`. The ring is known exactly: `0x802e` sets
`CBCR = 0x00ef`, selecting `AR7` for circular buffer 1 with `CBSR1 = 0x0bd0` and
`CBER1 = 0x0bdf`. An `ARCR` anywhere in that ring makes the block run once per
pass, a few hundred times a second - a sensible mailbox poll rate. With `ARCR` at
zero it runs **once, during initialisation**, which is why a full run shows 87
messages delivered and almost nothing consumed: they overwrite each other in the
two-register window while the DSP is not looking.

**`@10` is data `0x0390`, and `0x0390` is where `AR7` is kept.** Direct
addressing is DP-relative and `ldp #007` sits immediately before the
`lar ar0, @10` at `0x8105` and `0x810d`, with the steady-state loop passing the
`ldp #007` at `0x80e6` every turn - so `@10` is *not* the memory-mapped `AR0` at
data `0x0010` that a DP-0 reading would give. That is the trap here. `sar ar7,
@10` at `0x808f` and `0x81a1` store the cell; `lar ar7, @10` at `0x80c5` and
`0x8192` restore it.

Which makes the sequence coherent and self-contained:

```text
80c5  lar  ar7, @10     ; AR7 <- saved ring pointer
...   the gated block
80d0  lar  ar0, @10     ; AR0 <- the same cell, and ARCR/INDX with it
80d1  cmpr eq           ; TC = (AR7 == ARCR)
80d2  bcnd 80c8, tc     ; ...so: has AR7 moved off its saved value?
```

The compare is not waiting for an uninitialised register to be filled by
something unfound. It tests the **live ring pointer against its own saved
value**, and `ARCR` is reloaded from that slot every pass. It needs nothing
external.

## The `NDX` side effect is real, measured on the part

That reading depends on `lar ar0` loading `ARCR` as a side effect. SPRU056D's
`LAR` page and Table 4-3 say it does when `NDX` is clear; its section 3.5 prose
says when `NDX` is set. The document cannot arbitrate itself, so the part was
asked - `artifacts/ndx-probe-01/`, on the live board, loading `AR0` three ways
under each polarity and rewriting sentinels `ARCR = 0xEEEE` / `INDX = 0xDDDD`
before every load so "loaded" and "untouched" cannot be confused:

| | `PMST` | `lar ar0, @7b` | `lark ar0, #55` | `lar ar0, #4321` |
|---|---|---|---|---|
| **`NDX` clear** | `00b0` | `ARCR`/`INDX` = **`1234`** | = **`0055`** | = **`4321`** |
| **`NDX` set** | `00b4` | `ARCR`/`INDX` = `EEEE`/`DDDD` | - | - |

1. **The side effect is real on this part**, not a documentation artefact.
2. **The `LAR` page and Table 4-3 have the polarity right**; the prose is wrong.
   This firmware clears `NDX` explicitly at `0x8012` (`apl @07, #07f8` then
   `opl @07, #00b0`), so the side effect is **active** on the live board.
3. **It is not restricted to 'C2x instructions.** `lar ar0, #4321` is the 'C5x
   long-immediate form and it loaded `ARCR` and `INDX` too. The trigger is
   loading `AR0` at all, whatever the encoding; the manual's "'C2x
   compatibility" framing is misleading about scope.

`AR0` was mailed back in both halves (`4321`, then `1234`) to prove the loads
executed - without that, a surviving sentinel could just mean a skipped
instruction.

**The core does not model this.** It parses `m_pmst.ndx` and never reads it, so
that is a known-wrong model rather than a neutral omission.

## The unresolved part

Implementing the side effect gives exactly the predicted state - `ARCR` =
`0x0bdc`, inside the `0x0bd0`-`0x0bdf` ring - and **breaks the firmware in the
harness**: `INDX` takes the same value, a stride of 3036 corrupts all 317
`*0+`/`*0-` sites in the resident, the DSP stops reaching its main loop and the
codec goes undriven (`dxr_writes` 17,931 -> 15, `tdxr_writes` 801,645 -> 0).
Restricting the effect to `ARCR` alone, or to one `LAR` encoding, does not
rescue it.

**The board does this and runs anyway**, so the breakage is the harness's
problem to explain, not evidence against the mechanism. Re-landing the side
effect without resolving the `*0+` behaviour would swap a wrong model for a
broken one, so the emulator is deliberately left unchanged.

## The open measurement

Read on the board, `0x0390` is `0x0000` - all sixteen samples,
`artifacts/dsp-at10-01/`. The control matters, because zero is also what a broken
probe returns: the same kernel pointed at data `0xffff` returned `0x0083` sixteen
times, matching `artifacts/dsp-boot-word-01`. So the path reads live cells and the
zero is a reading.

But it was taken idle and on hook, and after the monitor had reset the DSP, so it
is the value the resident left behind rather than a sample of the running loop.
With `@10` at zero, `AR7` restores to zero, `ARCR` is set to zero and the compare
matches - consistent with the block running during initialisation and never
again. It does **not** follow that `@10` is zero during a call: the ring and task
machinery may only be set up once a connection starts.

**Sampling `0x0390` during a call is the next thing worth doing**, and it needs a
probe that runs alongside the firmware rather than replacing it - the shape
`cooperative_probe.py` has, which cannot currently reach DSP data memory.

`ARCR` is shared scratch, which is part of why this was hard to read: the
resident's only write to it, `samm @19` at `0x9644`, computes
`(@7e >> 10) + 0xd9fe`, a **program** address for a table walk, and `0xafdf`
reads it back. It is a general-purpose ARAU register the firmware reuses, exactly
as SPRU056D suggests.

See [dsp-cpu-interconnect.md](dsp-cpu-interconnect.md).

## Smaller things still known wrong

None of these blocks a call:

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

## Ruled out - do not re-run these

**Wiring the ASIC ports together instead of interpreting them.**
`COURIER_ASIC_TRANSPARENT=1` mirrors the 80186 side onto the DSP's I/O ports
rather than decoding the supervisor's writes and synthesising status. It does not
substitute for the protocol: the supervisor's `0x1c` handshake is a sequence, not
a register image.

**Reading `@10` as the memory-mapped `AR0` at data `0x0010`.** DP is 7 at every
one of those sites, so it is data `0x0390`.
