# The DSP is a 'C51: 8K of on-chip ROM, not 2K

`probe_transport --memory-test`, run twice on the 25 MHz board, identical both
times. Seventeen words.

## What it does

The stability test [probing.md](../../docs/probing.md) proposed - read `0x0800`
twice and see whether the firmware's live scratch moves - cannot work, because
the probe resets the DSP and takes it over. There is no firmware running
underneath to move anything, and both parts return the same thing twice. What
separates them without needing the firmware alive is whether the region accepts
a **write**: SARAM seen from both spaces is one physical memory, so a write
through data space must read back through program space. ROM cannot.

Each address is written twice, with two different patterns, so a region that
merely returns a constant cannot pass by coincidence.

## What came back

```
PMST as found                00b0
PMST after RAM|OVLY          00b0
0800 program before          ffff
0800 data after A55A         a55a      <- the write lands in data space
0800 program after A55A      ffff      <- and program space does not see it
0800 data after 5AA5         5aa5
0800 program after 5AA5      ffff
1800 program before          ffff
1800 data after A55A         a55a
1800 program after A55A      ffff      <- same
1800 data after 5AA5         5aa5
1800 program after 5AA5      ffff
2400 program before          ab5e
2400 data after A55A         a55a
2400 program after A55A      a55a      <- here program space follows the write
2400 data after 5AA5         5aa5
2400 program after 5AA5      5aa5
```

**`PMST` = `00b0`: `IPTR` 0, `AVIS` 1, `OVLY` 1, `RAM` 1, `MP/MC` 0.**

## MP/MC has now been read

Bit 3 of `PMST` is `MP/MC`, and it is **0** - microcomputer mode, on-chip ROM
mapped at program `0x0000`. Every ROM reading in this repository carried the
caveat that this had never been read directly. It has now, and it agrees with
what the vector table at `0x0000` implied.

Note also that `RAM` and `OVLY` are **already set when the kernel starts** -
`PMST` reads `00b0` before the `opl @07, #0030` as well as after. That `opl`
has never been changing anything.

## Why this is a 'C51

With `MP/MC=0` and `PMST.RAM=1`:

* a **'C50** maps its 9K SARAM into program space over `0x0800`-`0x2BFF`, so
  `0x0800` and `0x1800` would both follow the write. Neither does. **Excluded.**
* a **'C51** has 8K of on-chip ROM at `0x0000`-`0x1FFF`, which wins over SARAM
  in program space in microcomputer mode, and only 1K of SARAM. `0x0800` and
  `0x1800` read ROM and ignore the write; `0x2400` is above the ROM and is
  writable. **That is exactly the observed split.**

The package marking agrees and always did: `D17140PQ`, and `PQ` is carried by
'C50/'LC50/'C51/'LC51 alike.

## The instrument shows both signatures

Run offline against the emulator fixture - which maps a 4K ROM at
`0x0000`-`0x0FFF` and SARAM above it - the same kernel reports `0x0800`
unaffected by the write and `0x1800`/`0x2400` following it. The opposite split
from the board, from the same instrument, so a null result here would have been
visible as one.
