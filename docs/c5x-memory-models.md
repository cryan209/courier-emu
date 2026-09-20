# C51 and C53 memory models

Observed Courier boards use a C51. MICA uses a C53. Earlier C50/C52
identifications in analysis notes are historical inferences, not model selectors.
The implementation supports these two memory maps explicitly; it does not infer
the silicon from firmware load addresses.

Source: TI SPRU056D, figures 8-2/8-4 and section 8.4 (the PDF is in this directory),
and [TI's C5x datasheet](https://www.ti.com/tw/lit/gpn/tms320lbc53s).
All addresses and sizes below are in 16-bit words.

| Region | C51 | C53 | Control |
| --- | --- | --- | --- |
| Program ROM | 0000–1FFF | 0000–3FFF | MP/MC=0 |
| Program SARAM | 2000–23FF | 4000–4BFF | RAM=1 |
| Data SARAM | 0800–0BFF | 0800–13FF | OVLY=1 |
| Program DARAM B0 | FE00–FFFF | FE00–FFFF | CNF=1 |
| Data DARAM B0 | 0100–02FF | 0100–02FF | CNF=0 |
| Data DARAM B1/B2 | 0300–04FF / 0060–007F | same | always |

SARAM has independent physical storage. Its program and data windows alias it
when enabled; disabling a window exposes external storage without losing SARAM.
The existing missing-ROM fallback to loaded program storage remains available
for diagnostic runs without a ROM dump.

Python callers use `NativeC5x.from_program(origin, image, model="c53")` for MICA
images, or `NativeC5x(xmf, model="c53")` for a compatible container. The default is
`c51`. The standalone runner and `dsp-run` accept `--model c51|c53`; selecting a
DSP does not add a MICA image parser or emulate its board peripherals.

The Courier's shared external program/data RAM at 8000–FEFF is a board mapping.
C53 instances start with that mapping disabled; their harness must configure
any board-specific external aliases explicitly.

GREG selects global external bus cycles, asserting BR with DS. It does not
create RAM inside the processor. By default GREG leaves the board's existing
storage mapping intact. A board that uses BR to select distinct storage may
request `separate_global_memory=True` on either Python constructor, or use
`courier_c5x_set_separate_global_memory` in the C API. This option supports the
contiguous allocations 80, C0, E0, F0, F8, FC, FE, FF from TI table 8-14.
Fragmented allocations for other values and BR/READY arbitration timing remain
unmodelled. GREG resets to zero and reads unused high bits as ones.
