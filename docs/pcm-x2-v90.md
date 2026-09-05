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

## Overlay 8 holds two receivers

It is two state machines, not one. The image splits into an **e-family** around
`e4c5`-`eaff` and an **f-family** around `f442`-`f94a`, and the pair leaves the
mark two builds from one source leave: runs of identical code far apart at a
consistent offset. `courier_emu.datapumps.receiver_twins` finds ten of at least
ten words, among them

```text
e9be-e9cb  ==  f7eb-f7f8    (+0xe2d)
e9d8-e9e1  ==  f805-f80e    (+0xe2d)
e9f2-e9ff  ==  f821-f82e    (+0xe2f)
e59f-e5b3  ==  f4e2-f4f6    (+0xf43)
```

Only 158 of 7,498 words repeat verbatim; the rest of each family is its own
tables and constants. Both call the same lower-level helpers - `e019`, `e356`,
`8766`, `8797` - so what is doubled is the sequencing, not the arithmetic.

**The fork is one bit.** At `de0b`, at the top of the image's dispatch:

```text
de0b  lar   ar1, #039f     ; the datapump flag word, @1f on page 7
de0d  bit   8, *
de0e  bcnd  f442, ntc      ; bit 8 clear -> the f-family
de10  b     e4c5           ; bit 8 set   -> the e-family
```

`courier_emu.datapumps.receiver_fork` reads it out. The V.34 core dispatches
into both from its own side, and there it is two bits, one per family:

```text
a456  bit  8, *  ; bcnd e9a0, tc     ; the e-family
a45b  bit  9, *  ; bcnd f7d8, tc     ; the f-family
```

`0x039f` is the same flag word every datapump entry writes - overlay 6 sets bit
5 for itself, overlay 7 bit 4, the resident V.32 entry bit 0 - so bits 8 and 9
are two more datapumps in the same register.

**The supervisor arms them by mailbox command.** Three siblings at `823d`,
`8245` and `824d` each install a sample-path routine in `@61` and then move the
flag:

| tag | sample path `@61` | flag |
|---|---|---|
| `4f` | `819d` | **sets** bit 8 |
| `4d` | `819d` | clears bit 8 |
| `4e` | `81bb` | clears bit 8 |

`819d` and `81bb` are the two sample paths, and the difference is what PCM
needs: `819d` assembles each sample from **two 8-bit halves** with saturation -
codewords - where `81bb` interpolates and writes port `0x6a`. The two commands
that select the PCM sample path, `4d` and `4f`, differ *only* in the receiver
bit. Bit 9 is set and cleared by another pair, at `dccd` and `dcde`.

## The `0xfff1` thread ends short of the fork

x2's capability word does not reach the datapump as a bit test. **No overlay
reads `0xfff1` at all**; only the resident does, at `8e4b`, where it picks
`fff1` or `fff2` and hands it on. What every overlay does branch on is
`0xfff4`, and its **bit 13** is not the scheme:

```text
f632  lar   ar1, #0822 ; rptz #0006 ; sacl *+     ; clear seven words
...                                                ; try four candidates,
f6b5  lar   ar1, #0822 ; cpl *, #0003             ; keep the best in 0x0822
f6c3  lar   ar1, #fff4 ; xc 2, tc ; opl *, #2000  ; winner 4 sets bit 13
```

`f632`-`f6b3` is a search: `@72` counts four candidates down, each scored by a
sum of squares against tables at `f7bb` and `f7c5`, the best kept in `0x0830`
and copied to `0x0822`. Bit 13 then picks between two parallel parameter sets
everywhere downstream, in overlay 6 as well as overlay 8 - `c9f3` chooses table
`cc72` or `cb47`, `c9d2` and `c9e3` choose adjacent entries, `c5e0` chooses 1 or
2. That is the shape of a **measured property of the digital path** - a law or
a pad, decided by fitting four candidates - not of a scheme the supervisor
configured.

## Who sends `4d`/`4e`/`4f`, and it is not V.8

They never appear as `mov ax, imm` because they do not go through that sender.
They go through the **packed** one - `lcall 0x8f46:0x01e8`, tag in `ah` and data
zero - and the tag is chosen by a byte of the stored profile:

```text
be6f  mov  al, byte ptr [0x4ed]
be72  cmp  al, 1 ; je be7e
be76  cmp  al, 2 ; je be82
be7a  mov  ah, 0x4d      ; 0
be7e  mov  ah, 0x4e      ; 1
be82  mov  ah, 0x4f      ; 2
be84  xor  al, al
be86  lcall 0x8f46, 0x1e8
```

`courier_emu.datapumps.receiver_selector` finds both sites that do this:

* **`0xbe6f`**, a bare sender guarded by `[0x4e9] <= 5` and `!= 1`. Its caller
  is the datapump bring-up, and the instruction before the call is the overlay
  loader: `b620 cmp byte [0xd28], 0 ; jne ; call e60a` then `b62d call be5f`.
  The receiver family is armed in the same breath as the image that holds it.
* **`0x4749`**, inside a routine that reprograms ASIC ports 2, 4, 6 and 8 and,
  for the same three cases, writes `0x3c`, `0x3d` or `0x3e` to port `0x0c`
  before sending the tag. The analogue path is switched with the receiver.

So the selection is neither V.8 nor an INFO sequence. **It is a saved
setting.** `[0x4ed]` is written only at `0x26cae`, by an AT handler that parses
a number and rejects anything above 2, and it has a twin at `[0x563]` chosen by
the same active-or-stored test the S-register reader uses. The two profile
blocks start at `0x048e` and `0x0504`, and both copies sit `0x5f` into their
block - past the S-registers, so this is an ampersand-style option rather than
an S-register. Nothing in the negotiation paths writes it.

Putting the three together with the DSP handlers:

| `[0x4ed]` | tag | sample path | receiver |
|---:|---|---|---|
| 0 | `4d` | `819d`, 8-bit codewords | bit 8 clear - the **f-family** |
| 1 | `4e` | `81bb`, interpolating | bit 8 clear, no PCM path |
| 2 | `4f` | `819d`, 8-bit codewords | bit 8 set - the **e-family** |

## What is still open

**Which family is x2 and which is V.90.** The shape of the setting is
suggestive - three values where one takes the ordinary sample path and the
other two take the PCM path and differ *only* in which receiver runs, which is
what "off / one scheme / the other" would look like - but that is a reading of
the shape, not a label. Naming it needs the AT command that writes `[0x4ed]`,
and its handler at `0x26c88` is reached through an indirect dispatch that has
not been located, so the command letter and its documented values are still
unread.

**Bit 9's arming.** `dccd` sets it from inside the `dc00` block, which overlay 8
replaces, so which image owns that handler at the moment it runs needs
establishing.

**What bit 13 actually measures.** Four candidates and a least-squares fit is
the right shape for µ-law against A-law, or for the digital pad, but nothing
here names it.

**The empty V.90 body invites a second reading.** It may mean V.90 needs no
DSP-side parameters because its capabilities travel in the V.8 CM/JM exchange,
which the supervisor drives; or it may be a routine whose body this build no
longer needs. Both are consistent with what is here.
