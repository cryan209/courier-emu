# x2 and V.90: one receiver, two capabilities

[datapump-slots.md](datapump-slots.md) placed the PCM downstream layer in
overlay 8, chained onto the V.34 core by the loader, and left the difference
between x2 and V.90 open. This closes most of it. They are not two images and
not two datapump slots: they are two capability bits over the same overlay,
and what separates them is one S-register bit each, one command, and two
result-code blocks.

## S58 is the switch, and S56 named the overlays

The modem's own help text carries the bit meanings, compressed but with the
values and names in the clear. `courier_emu.datapumps.s_register_bits` reads
them out:

| | bit 1 | bit 2 | bit 4 | bit 8 | bit 16 | bit 32 | bit 64 | bit 128 |
|---|---|---|---|---|---|---|---|---|
| **S56** | nonlinear coding | TX level deviation | preemphasis | precoding | shaping | V34+ | V34 | VFC |
| **S58** | **x2** | BLER monitor | | | | **V.90** | | |

The S-register file's base is not assumed: the `ATSn` reader takes the number
the user typed and does `mov al, byte ptr [bx + 0x48e]`, so S*n* is at
`0x48e + n` and S56 and S58 are `0x4c6` and `0x4c8`.

That settles something else on the way. The overlay predicates at `0x8972` and
`0x8999` gate on `[0x4c6]` bits `0x40` and `0x80` - which S56 names **V34** and
**VFC**. Overlay 6 is V.34 and overlay 7 is V.FC by the firmware's own label,
not by inference from symbol rates.

## The two schemes are the same routine twice

Every connection setup evaluates both, at `0xbbe6`:

```text
bbe6  call 8e9a     ; may we try x2?
bbe9  jb   bbee
bbeb  call 8f0e     ; x2 setup
bbee  call 8e59     ; may we try V.90?
bbf1  jb   bbf6
bbf3  call 8edb     ; V.90 setup
bbf6  ...           ; then the overlay choice
```

The two predicates are the same code twice over. Side by side, the only
difference is the bit:

| | x2 (`8e9a`) | V.90 (`8e59`) |
|---|---|---|
| disabled by | `test [0x4c8], 1` | `test [0x4c8], 0x20` |
| line/config gate | `call b88d` | `call b88d` |
| mode `[0x4e9]` | ≠ 1 and < 6 | ≠ 1 and < 6 |
| max speed `[0x4f8]` | 0, or ≥ `0x11` | 0, or ≥ `0x11` |
| ceiling `[0x4dd]` | ≥ 8 | ≥ 8 |

So a modem is equally eligible for either; `0x11` is the speed index where the
PCM rates begin, and the same index is the floor in both.

## What each one tells the DSP

Here they part. Both setup routines clear the same block of PCM statistics at
`0xa0c`-`0xa16`, and then:

* **x2** (`8f0e`) builds a capability word - `and bx, 0xfdff`, then `0x0200`
  from S58 bit 4, `0x0400` unless S58 bit 16, then clearing `0x1800` and the
  top two bits - and sends it as **command `70`**. The DSP's handler parks it
  at data `0xfff1` under a `0x3fff` mask and raises `0xfff4` to `0x8000`, which
  is how the datapump is told new parameters have arrived.
* **V.90** (`8edb`) has the same shape and an **empty body**: the test is
  followed by `jne +0 ; ret`, a branch to the next instruction. In this build
  the V.90 path hands the DSP nothing of its own.

`courier_emu.datapumps.pcm_control` reports both, the empty body included.

What they share is the rate mask. `8fc9` turns the min and max speed settings
(`[0x4f7]`, `[0x4f8]`, both relative to that same `0x11`) into a 15-bit mask
through the table at `0x9048`, and sends it as command `71`, which lands at
data `0xfff3` under a `0x7fff` mask. One mask, whichever scheme trains.

## The ladders

Both are multiples of **8000/6 bps** - PCM downstream is 8000 symbols a second
in six-symbol frames, so a rate is a count of bits per frame, and 1333⅓ bps is
one of them. `courier_emu.datapumps.pcm_ladders` reads the CONNECT strings:

| | rates | count |
|---|---|---:|
| **x2** | 33333 … 57333, and 64000 | 16 |
| **V.90** | 28000 … 62666, and 64000 | 28 |

V.90 starts five steps lower and fills in every step; x2 starts at 33333 and
skips 34666, 38666 and 40000. Both stop at 57333 before the 64000 entry, which
is the digital-side rate rather than a modem rate.

The result-code table at `0xa1eb` - 336 entries - keeps them apart as well.
x2's block begins at code 182 and takes four codes per rate (plain, `/ARQ`,
`/x2`, `/ARQ/x2`); V.90's begins at 258. Where the two ladders overlap, at
33333 through 57333, V.90's entries take only two codes each, because the plain
and `/ARQ` strings for those rates already exist in the x2 block.

The diagnostics are separate too: `x2 Status` and `V.90 Status` are distinct
report blocks, with reasons beside them like `x2 disabled on local modem` and
`Unspecified impairment`.

## What is still open

**The signal-level difference is not established.** Nothing here says whether
overlay 8 holds two receivers or one receiver with a mode bit - no bit test in
that image has been tied to the choice, and the two schemes' constellation
mapping, precoding and training differ in ways this has not looked for. The
`0xfff1` capability word is the place to look: x2 writes it, V.90 does not, so
whatever the overlay reads out of `0xfff1` is what x2 changes about the
receiver.

**The empty V.90 body invites a second reading.** It may mean V.90 needs no
DSP-side parameters because its capabilities travel in the V.8 CM/JM exchange,
which the supervisor drives; or it may be a routine whose body this build no
longer needs. Both are consistent with what is here.
