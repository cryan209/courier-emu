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

V.90 starts four steps lower and fills in every step; x2 starts at 33333 and
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
`e4c5`-`eaff` and an **f-family** around `f442`-`f94a`. They share subroutine
bodies verbatim - `courier_emu.datapumps.receiver_twins` finds ten runs of at
least ten identical words far apart at a consistent offset, among them

```text
e9be-e9cb  ==  f7eb-f7f8    (+0xe2d)
e9d8-e9e1  ==  f805-f80e    (+0xe2d)
e9f2-e9ff  ==  f821-f82e    (+0xe2f)
e59f-e5b3  ==  f4e2-f4f6    (+0xf43)
```

Only 158 of 7,498 words repeat verbatim, and at the best alignment of the two
spans just 46 words of 1,536 match, so this is not one state machine built
twice: it is two sequences that call the same helpers - `e019`, `e356`, `8766`,
`8797` - and diverge in what they do with them.

**The fork is one bit.** At `de0b`, at the top of the image's dispatch:

```text
de0b  lar   ar1, #039f     ; the datapump flag word, @1f on page 7
de0d  bit   8, *           ; bit code 8, which is bit 7
de0e  bcnd  f442, ntc      ; clear -> the f-family
de10  b     e4c5           ; set   -> the e-family
```

**Bit codes are not bit numbers.** The C5x `BIT` shifts by `~code & 0xf`
(`op_bit` in `native/c5x_ops.ipp`), so `bit 8, *` tests **bit 7**, mask
`0x0080`. `courier_emu.datapumps.receiver_fork` reports the number.

The V.34 core dispatches into both from its own side, and there it is two bits,
one per family:

```text
a456  bit  8, *  ; bcnd e9a0, tc     ; bit 7 - the e-family
a45b  bit  9, *  ; bcnd f7d8, tc     ; bit 6 - the f-family
```

`0x039f` is the same flag word every datapump entry writes, so bits 7 and 6 are
two more datapumps in the same register. Bit 7 is set by two identical resident
routines, `b402` and `c91a`, and cleared at `b2df` and `c87f`.

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

## What the two families differ in

`courier_emu.datapumps.receiver_families` reads the four differences out of the
image.

| | e-family (`e4c5`) | f-family (`f442`) |
|---|---|---|
| equalizer installed at `@0a` | `e055`, **96 taps** | `e047`, **64 taps**, then `e055` later |
| its adaptation at `@16` | `e08c` | `e079`, `e0be`, then `e08c` |
| phase hooks at `0x03cd` | `ae72`, `ae7b`, `ae64` | `ae57`, `ae60`, `ae31` |
| `0xfff4` bits tested | 9, 12 | **2**, 1, 0, 12 |
| into the V.34 core | `a35e` | `a35e`, `a661`, `c56a`, `c5e0`, `c91c`, `c961`, `c9fc` |

**The equalizer.** `e047` is a 64-tap `mac` against the coefficient bank at
`fba0` with a two-tap section after it; `e055` is a 96-tap `macd` with 14-tap
and 6-tap sections and a different bank. `e079` adapts the 64-tap bank,
`e08c` and `e0be` the 96-tap one, both gated on `0xfff4` bit 6. The e-family
installs the long filter at its entry and keeps it. The f-family starts short
and **switches to the long pair at `f6e4`** - immediately after its
four-candidate search - so it grows its equalizer partway through startup.

**The phase hook.** `0x03cd` is the callback cell every datapump phase writes.
The e-family's values reach the codec rate selector: `ae72` calls `adee`, loads
a batch of parameters and falls into `call 8140`, and `ae7b` is a shorter entry
into the same `call 8140`. The f-family's are `ret` and nothing else - `ae57`
and `ae60` are both a bare `ret`. **The e-family reprograms the codec sample
rate at that hook; the f-family does not.**

**What the rate change selects.** The e-family's hook is the only path that
reaches `8140`, and the index it passes comes from `adee`:

```text
adee  call adc4        ; acc = ffb0 & ffb1 & ffb2 & ffb3, parked at ffb4
adf0  sacl @7d
adf1  bit 10, @7d ; lacl #05 ; retc tc     ; bit 5 -> row 5
adf4  bit 11 -> 04    ; bit 4 -> row 4
adf7  bit 12 -> 03    ; bit 3
adfa  bit 13 -> 02    ; bit 2
adfd  bit 14 -> 01    ; bit 1
ae00  lacl #00                             ; none -> row 0
```

Those are bit codes again, so the scan reads **bits 5 down to 1**. The
supervisor builds the capability word at `0xffb1` from three S-registers -
`(~S54 & 0x3f) | ((~S55 & 0x0f) << 6) | ((~S56 & 0x1f) << 10)` - and **S54's
bits 0 to 5 are the six V.34 symbol rates**, 2400, 2743, 2800, 3000, 3200 and
3429, per the modem's own help text. `0xffb0` is a fixed mask (`7d7f`),
`0xffb2` is written during negotiation and `0xffb3` is built at `adcc`, so the
`and` is what every party allows.

So the e-family's rate change selects **the codec sample rate for the fastest
V.34 symbol rate all four words agree on**, which
`courier_emu.datapumps.rate_choice_selects` reads out:

| common symbol rate | codec row | sample rate |
|---:|---:|---|
| 3429 | 5 | 8000 Hz |
| 3200 | 4 | 8000 Hz |
| 3000 | 3 | 7578.95 Hz |
| 2800 | 2 | 7578.95 Hz |
| 2743 | 1 | 7578.95 Hz |
| none of them | 0 | 7200 Hz |

The fit is its own check on the bit numbering: six symbol rates land on six
codec rows in order, which the bit *codes* would not do.

**The parameter flags and the V.34 core.** The f-family reads `0xfff4` bits 2,
1 and 0 where the e-family reads none of them; both read bit 12. Its
four-candidate search *sets* bit 13 (`opl *, #2000`), which overlay 6 reads at
`c5e7`. Note that this is not the same flag as the one overlay 6's parameter
selectors read: `c9f3`, `c9d2` and `c5e0` are written `bit 13` but that is a
bit code, so they read **bit 2**. Which sites consume the search's own bit 13,
beyond `c5e7`, wants redoing with the numbering right.

The f-family calls into the V.34 core at seven points and its phase pointers
include overlay-6 addresses (`c4e7`, `c50a`, `c682`, `c683`), so it hands
sequencing back and forth with the core. The e-family calls the core once and
keeps all of its phase pointers inside overlay 8.

So the f-family is the elaborate one - fits four candidates, grows its
equalizer, drives the core's parameter tables - and the e-family is
self-contained and reprograms the codec rate instead. Which is consistent with
the bit that selects them being `&X`: the e-family is what runs when the
transmit clock is recovered from the received signal.

## The `0xfff1` thread ends short of the fork

x2's capability word does not reach the datapump as a bit test. **No overlay
reads `0xfff1` at all**; only the resident does, at `8e4b`, where it picks
`fff1` or `fff2` and hands it on. What every overlay does branch on is
`0xfff4`, and its **bit 2** (the instructions say `bit 13`, a bit code) is
not the scheme:

```text
f632  lar   ar1, #0822 ; rptz #0006 ; sacl *+     ; clear seven words
...                                                ; try four candidates,
f6b5  lar   ar1, #0822 ; cpl *, #0003             ; keep the best in 0x0822
f6c3  lar   ar1, #fff4 ; xc 2, tc ; opl *, #2000  ; winner 4 sets bit 13
```

`f632`-`f6b3` is a search: `@72` counts four candidates down, each scored by a
sum of squares against tables at `f7bb` and `f7c5`, the best kept in `0x0830`
and copied to `0x0822`. Bit 2 then picks between two parallel parameter sets
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
block - past the S-registers, which the help text documents only to S70.

## The command is `&X`, and it is the clock source

The setting names itself in the `&V` display. Each line there is a label
routine followed by a value, and a label routine prints the string that follows
its own call:

```text
1b4d6  call 1bb11            ; the label
1b4d9  jae  ...              ; then the value:
1b4f0  mov  al, [0x4ed]
1b4f3  jmp  1b38e            ; print it as a number

1bb11  test byte [058b], 48
1bb18  call <print inline>
1bb1b  82 '&' 'X' 00         ; the string it prints
```

`courier_emu.datapumps.receiver_setting_command` follows that and reads **`&X`**
out of the image. Its help entry at `0x19790` has three options and ends
`RX ... is Source`: `&X` is the **synchronous transmit clock source** - DCE,
DTE, or recovered from the received signal.

| `&X` | `[0x4ed]` | tag | sample path `@61` | `@1f` |
|---:|---:|---|---|---|
| 0 | 0 | `4d` | `819d`, a sample from two 8-bit halves | clears bit 8 |
| 1 | 1 | `4e` | `81bb`, interpolating, writes port `0x6a` | clears bit 8 |
| 2 | 2 | `4f` | `819d` | **sets bit 8** |

The two sample paths make sense of it: when the DTE supplies the clock, the
data has to be resampled between two clocks, which is what `81bb` does with its
interpolation, where `819d` just assembles the word. `@1f` bit 8 is read back
at `81e4` (`bit 7, @1f`), in the same ISR region as those two paths.

## What this retires

**`&X` does not select the receiver family, and the families are not x2 and
V.90 either.** Two readings die here, one from each of the last two sections.

The three-way shape of the setting had looked suggestive of
"off / one scheme / the other" - that was a guess about a shape, and naming the
setting killed it. Then the bit numbering killed the rest: `&X2` sets `@1f`
**bit 8** (`opl @1f, #0100`), while the fork tests **bit 7**. They are
different bits. `&X` reaches the sample path, not the fork.

What survives is the structure: overlay 8 holds two code families, `de0b` forks
between them on `@1f` bit 7, and the V.34 core dispatches into both on bits 7
and 6. What sets bit 7 is `b402`/`c91a`, inside the datapump phase code rather
than any configuration path, so what the two families are *for* is open.

## What is still open

**The V.90 wire-level selector is recovered; x2's is not.** The DSP has one
writer for outgoing INFO1a bits `37:39`: `9185` calls `9267` and writes its
three-bit result to `ff1a` at bit offset `0x25`. Under Table 10/V.90, the
integer `6` in that field requests V.90 and the digital modem's 8000-symbol/s
direction. The nearby six-row V.34 index decoder is a different path and must
not be mistaken for this selector. x2 has no parallel writer for bit offset
`0x25`; its known local difference remains command `70` into `fff1`. See
[x2-v90-protocol-selection.md](x2-v90-protocol-selection.md) for the exact
instructions and the remaining x2 trace.

**What the two families are.** With the clock-source reading in hand, the fork
looks like a timing variant, but nothing here says what differs between the
tables each family carries.

**Bit 9's arming.** `dccd` sets it from inside the `dc00` block, which overlay 8
replaces, so which image owns that handler at the moment it runs needs
establishing.

**What bit 2 actually measures.** Four candidates and a least-squares fit is
the right shape for µ-law against A-law, or for the digital pad, but nothing
here names it.

**The empty V.90 body invites a second reading.** It may mean V.90 needs no
DSP-side parameters because its capabilities travel in the V.8 CM/JM exchange,
which the supervisor drives; or it may be a routine whose body this build no
longer needs. Both are consistent with what is here.
