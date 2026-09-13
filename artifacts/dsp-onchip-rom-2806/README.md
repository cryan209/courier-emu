# The 25 MHz board's DSP carries the same mask, and the C50/C51 test does not work

Taken after the 2806 was reflashed from stock 7.3.14/3.0.13 to ID_SDL v4.03d
(`artifacts/xmodem-program-id25-403`), which is what put `ATGLK2W` on this board
and made the probe deliverable at all. The board then matches the 20.16 MHz unit
in supervisor and DSP revision, so the two differ only in clock.

## The answer to the question this was run for

`0x0000`-`0x07FF` off this board is **byte-identical** to
`artifacts/dsp-onchip-rom-01`, taken off the 20.16 MHz unit -
`sha256 3e30fb31ac87fc9d0b8a85da245511ef3caa4e83249f56b5852d9d0829e93f67` on
both. Same mask, both generations. Nothing about the DSP boot path needs to be
modelled twice.

## The C50/C51 test in probing.md is invalid as written

That test says: read `0x0800` twice, and on a 'C50 the two reads should
**differ**, because `0x0800` is the 9K SARAM holding the firmware's live
scratch. Run here, twice, the two reads are byte-identical - which the test
would score as 'C51.

**It is not a 'C51 result, it is a broken test.** The probe *resets the DSP* and
downloads its own kernel to program `0x8000`. After that reset `PMST` is at its
reset defaults, `RAM=0` and `OVLY=0`, so the 9K SARAM is not mapped into program
space **on either part**, and the firmware's scratch that the test wanted to
observe is gone before the first word is read. The premise needed the firmware
to still be running underneath, and a takeover probe is exactly the thing that
guarantees it is not.

What `0x0800`-`0x0BFF` actually returns is not memory at all: **two distinct
values in 1024 words, a 32-word period of 16 x `FFFF` then 16 x `0000`**, stable
across two runs. The same square wave is already present in the ROM dump from
`0x0780` to `0x07FF` and runs straight through the `0x0800` boundary without a
seam - so those last 128 words of the "ROM" are not ROM content either. Real
content in the dump ends at `0x077b`, on a self-loop `b 0779`.

## The loose end at 0x1F90

Reading `0x1C00`-`0x1FFF` - chosen because it is the last kilo-word of where a
'C51's 8K ROM would end, and clear of the dump buffer at data `0x1000` - gives
the same square wave for 909 of 1024 words, and then **112 words of
kernel-shaped code at `0x1F90`-`0x1FFF`**. It is not in the on-chip ROM dump and
it is not the kernel this probe delivers, but it shares that kernel's second
through fourth words (`bc00 5d07 0030`) and ends `7980 1fa2`, a self-loop.

Do not read a part number off this until it is explained. Something being
resident there argues the region is writable and therefore not ROM, which would
exclude the 'C51 - but the same observation is equally consistent with the read
not landing where it claims to.

## Reproducing

```sh
python -m courier_emu.probe_transport --reference IDSDL302.ROM --rom-dump \
    --rom-origin 0 --rom-words 0x400 --output artifacts/dsp-onchip-rom-2806/half0
python artifacts/dsp-onchip-rom-2806/run-board.py \
    artifacts/dsp-onchip-rom-2806/half0 /dev/cu.usbserial-FT4TQOFT
```

`--reference IDSDL302.ROM` is not a claim about what is flashed. It is where the
monitor's copy of the DSP launch and download routines is lifted from, and only
`IDSDL302` carries them in the form `probe_transport` recognises; the 20.16 MHz
capture was taken the same way while that board ran 4.03d.

Every run here restored the board: `AT` answered afterwards and the watchdog put
the timer-0 vector back, checked each time.
