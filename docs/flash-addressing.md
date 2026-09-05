# There is no flash banking

The captures address the board as `A000:9200`, and the image's own pointers are
segmented, which made the flash look banked. It is not. The mapping is flat and
the notation is ordinary 80186 real mode.

`physical_start` in every flash capture manifest is **`0x80000`**, and the length
is `0x80000`. So the 512 KiB flash occupies CPU physical `0x80000..0xfffff`
contiguously, and

```text
physical    = (segment << 4) + offset
file offset = physical - 0x80000
```

`ATGLK2=A000:9200` reads physical `0xa9200`, which is file `0x29200`. Segment
`8000` is the base of the window, so within it an offset *is* a file offset -
which is why `9a ed 1e 00 80`, a far call to `8000:1eed`, targets file `0x1eed`.

`courier_emu.flash_dump.physical` and `.file_offset` implement this, and refuse
an address outside the window, which is what a pointer into RAM or the relocated
peripheral block at `ff00` looks like.

## What it was blocking

Near calls need no mapping - source and target share a segment, so a `E8`
displacement is the same in file offsets as in segment offsets, and scanning for
them works. Far calls do, and scanning for the *offset* field alone finds
nothing, because the same physical address has many encodings: the mailbox
thunk at file `0xf644` is reached as `8f46:01e4`, not as `8000:f644`.

Resolving them properly turns 23 visible mailbox send sites into 137. See
[codec-rate-312.md](codec-rate-312.md), where that is what located the tag `2c`
sends.

## What this does not establish

The capture manifests record the assumption behind the window - "CPU addresses
`80000..fffff` expose the 512 KiB flash at runtime" - and note that identical
repeated reads establish capture consistency, **not the absence of bank
aliases**. Nothing here changes that. What is established is that the image's
own far pointers resolve consistently under the flat mapping, across 1,400 of
them, and that the two mailbox routines' call graphs close under it. A bank
register that selects between whole 512 KiB images would be invisible to both
that capture and this analysis.

DSP program addresses are a separate mapping again. This image's payload places
program `0x8000` at file `0x29140`, so `program = 0x8000 + (file - 0x29140) / 2`.
Note that [board-parts.md](board-parts.md) numbers the same code from a payload
origin `0x8000` lower.
