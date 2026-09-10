# x2 scramblers recovered and executed

2026-09-10. Sources: the depacketized `firmware/legacy-usrobotics/sdl6-x2.exe`
and the captured 4.03 `artifacts/courier-board-21210-capture-403/courier-board.rom`.

**The x2-only build contains the same two V.34 scrambler recurrences and the
same selector behavior as 4.03. A fixed-GPC generator in the PCM-associated
training path is also byte-identical across the two builds.** This is now an
instruction/execution result, rather than an inference from protocol ancestry.

## Resident routines

| Function | x2 PC | 4.03 PC | Physical selector |
|---|---|---|---|
| Scramble a batch of bits | `8c63` | `8cb7` | `[006f]` bit 0 |
| Descramble a batch of bits | `8c94` | `8ce8` | `[006f]` bit 1 |
| Generate two scrambled-one bits | `8c4e` | `8ca2` | `[006f]` bit 1 |

The selector reads are indirect through `ar1 = 006f`, so their physical address
does not depend on DP. The first two routines were executed; the third is
identified by its adjacent shift/XOR implementation, but not separately tested.

| Selector | Scrambler | Descrambler |
|---|---|---|
| clear | `1 + x^-18 + x^-23` (GPC) | `1 + x^-5 + x^-23` (GPA) |
| set | `1 + x^-5 + x^-23` (GPA) | `1 + x^-18 + x^-23` (GPC) |

For DP=6, the transmitter state occupies `[0358]:[0359]`; the receiver state
occupies `[031e]:[031f]`. Each holds a 23-bit history in the low 23 bits of
the combined 32-bit word. Bit 0 is the oldest bit, and bit 22 the newest.
The input/output batches are LSB-first, at `[0350]` and `[0320]` respectively.
Masks and batch widths are `[0351]/[0352]` and `[0321]/[0322]`.
These state addresses are DP-relative; DP=6 is the tested ABI, not a property
that the routines establish internally.

For tap `t = 18` or `5`, the equivalent single-bit operation is:

```python
output = input_bit ^ ((state >> (23 - t)) & 1) ^ (state & 1)
state = (state >> 1) | (output << 22)       # scrambler
# Descrambler instead shifts the received input_bit into bit 22.
```

The GPA transmit branch has an extra `v ^ (v << 5)` operation to account for
feedback within a batch wider than five bits. That is not another polynomial.

## Fixed polynomial in the PCM-associated training path

The 18 words at x2 **`ed2e..ed3f`** are **byte-identical** to 4.03
overlay 8 **`f938..f949`**, including the state-register ABI:

```text
ed2e  lacc @7a
ed2f  bsar 5
ed30  xor  @7a
ed31  cmpl
ed32  and  @7c
ed33  sacl @7d
ed34  lacc @7d, 7
ed35  or   @79
ed36  sacl @79
ed37  lacc16 @79
ed38  adds @7a
ed39  clrc sxm
ed3a  lt   @7e
ed3b  satl
ed3c  setc sxm
ed3d  retd
ed3e  sach @79
ed3f  sacl @7a
```

The complement injects binary ones. The recurrence is GPC (18,23), without
a role test. x2's caller at `ecf8` sets width **6**, and its delayed call at
`ecfa` sets mask **003f** before entering the generator. `ecff..ed00` transfers
the six generated bits into `@53`. The handler `eceb` replenishes that word
on its `@4b == 5` condition and shifts its bits out through the sign path.

The paired path at `ed0b..ed26` collects sign decisions in `@53`, calls the
resident descrambler `8c94` at `ed19`, and packs the result into `@42/@43`.
Initialization at `e862` explicitly sets receive width 6 and mask 003f,
then installs `ed0b` in `@2f`. At `e85a..e85b`, the preceding initialization
clears the generator's `@79/@7a` state after a zero-repeat operation.

This gives concrete x2 training generator/consumer locations. It does **not**
yet identify these handlers as a named V.90 sequence, locate x2's Sd-equivalent,
or prove every scrambler reset and role selection over a complete call.

The common overlay entry at `9d00` writes `[006f] = 4042`: the dispatchers
at x2 `9a19` and 4.03 `9b41` establish DP=0 before the table-indirect jump to
`9d00`. Thus that entry selects GPC for both generic routines initially.
Do not extrapolate that initial state into an assertion about the complete
upstream/downstream call: the whole transition chain has not been traced.

## DIL comparison

The unpacked x2 image contains **zero** exact occurrences of all three known
4.03 descriptor signatures:

* SP bytes `55 4b 2d b5 b4 d2 4a 2b 01`;
* TP bytes `00 21 84 10 22 84 10 42 00`;
* assembler header `splk *+,#00c5; splk *+,#4141`.

Each occurs once in the 4.03 ROM. This is evidence that the particular V.90
descriptor machinery documented in `vpcm-datapump.md` is not present unchanged
in this x2 release. It is not proof that x2 has no impairment-learning procedure
or no differently generated descriptor. SP/TP here are this firmware's chosen
patterns, not universally fixed V.90 patterns.

## Reproduction and verification

Run from the repository root:

```sh
.venv/bin/python artifacts/x2-scrambler-hunt/verify.py
```

The script depacketizes the original EXE with `packet_runs()`. The INFO fill
handler's self-referential address anchors the resident program: flat offset
equals `0x18100 + 2*PC`. This is a local DSP mapping, not a claim that the
concatenated image is flash-address accurate.

The fixed generator is found by its unique 36-byte match. Its preceding
six-bit caller names `ed2e`, independently anchoring the training code's
program addresses (flat offset `0x3f8cc` for `ed2e`).

The original instructions run in `NativeC5x`, using a small DP/ARP-setting call
trampoline. Expected output and complete updated history come from a separate
bit-at-a-time recurrence. Results:

* 2,304 cases across both builds, both directions, both selectors, widths 1–9,
  and randomized input/state;
* 256 six-bit training cases: a continuous 768-bit zero-seeded sequence plus
  128 randomized histories;
* all **2,560** comparisons pass, including the entire updated state.

The generated disassemblies, script, and `verification.json` are under
`artifacts/x2-scrambler-hunt/`. No physical modem was accessed.
