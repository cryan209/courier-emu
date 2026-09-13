# The full 8K read again, from a gadget executing in on-chip SARAM

Same board and same day as
[dsp-onchip-rom-20mhz-8k](../dsp-onchip-rom-20mhz-8k/README.md) - 20.16 MHz,
ID_SDL v4.03d, serial `0009540034268322`. Eight 1K windows, `--via-saram` on
every one.

## Result

```
SARAM-hosted     sha256 d57bc46e1bcd6d4dc8872b97bba2d98ba8fb6b8661440c566b534f0b3f82fac9
off-chip-hosted  sha256 d57bc46e1bcd6d4dc8872b97bba2d98ba8fb6b8661440c566b534f0b3f82fac9
```

**All 8192 words identical.** TI's program-memory protection is not programmed
on this part, and every ROM reading taken here through a kernel at external
`0x8000` is the real ROM.

## Why this needed doing, and why SARAM rather than DARAM

Protection blocks instructions fetched from **off-chip memory**, **DARAM B0**,
external DMA and the emulator from reading on-chip program memory. Every earlier
read ran from program `0x8000`, off-chip - the first item on that list. Two
windows had been spot-checked from SARAM; this is the whole ROM.

DARAM is not an alternative:

* **B0** is named on the exclusion list, so hosting the loop there would be
  blocked exactly as `0x8000` would.
* **B1** (`0x0300`-`0x04FF`) and **B2** (`0x0060`-`0x007F`) cannot be reached
  from program space at all. Only B0 maps into program space, via `CNF`, at
  `0xFE00`-`0xFFFF`.

So SARAM - program `0x2000`-`0x23FF` on this part - is the only on-chip site that
is both executable and absent from the exclusion list. `ROM_DUMP_GADGET` is
`0x2000` for that reason.

## What it does not show

A null result cannot distinguish "protection is off" from "protection is on but
SARAM is exempt", which is the reading the TI wording invites. Either way the
data is the ROM. What would separate them is a read hosted in DARAM B0: if
protection were active and SARAM merely exempt, that read would fail where these
succeed. Not run - nothing here depends on the distinction.
