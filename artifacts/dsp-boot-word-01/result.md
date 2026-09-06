# Result: the boot word is 0x0083, and it selects neither loader

Read from the live 20.16 MHz Courier (ID_SDL v4.03d, supervisor 7.4.16, DSP
3.1.2) on 2026-09-07, DTE port at 57600 8N1.

```
CDRP1 START
CDRP1 DATA 0010
0083008300830083008300830083008300830083008300830083008300830083
SUM:0830
CDRP1 DONE
```

Sixteen reads of DSP data `0xffff`, all `0x0083`; the checksum is the sum of
them and agrees. Placement was verified byte for byte first - 4240 of 4240
bytes, zero mismatches - and all 2120 `ATGLK2W` writes returned `OK`.

## What 0x0083 does

The ROM's dispatch, with the measured value substituted:

```
0686  lacl *-          ; acc = [0xffff] = 0083
0688  lacc @60, 8      ; 8300
0689  and  #fc00       ; 8000
068b  sacl @65
068d  and  #0003       ; 0083 & 3 = 3
068f  bcnd 06c6, eq    ; not taken
0691  sub  #02         ; 1
0692  bcnd 06ab, lt    ; not taken
0694  bcnd 069b, eq    ; not taken
0696  dmov @65         ; @66 = 8000
0699  lacc @66
069a  bacc             ; -> program 8000
```

So the low two bits being `3` is a **fourth mode that transfers nothing**: it
branches to an entry address carried in the boot word's own bits 7:2, shifted
up ten places. `0x83 >> 2 = 0x20`, `0x20 << 10 = 0x8000` - exactly the resident's
origin and the address the supervisor's download targets.

Confirmed by running the recovered ROM in the emulator with each candidate:

| boot word | outcome |
|---|---|
| `0x0083` (measured) | reaches program `0x8000` |
| `0x0004` (harness assumption) | parks at `0x06dc`, the serial loader's wait |
| `0x000c` (parallel hypothesis) | parks at `0x0779`, the XF/BIO wait |

## What that means

Neither ROM loader runs on this board. The DSP's ROM does a bare warm start,
which means **the ASIC puts the resident into the DSP's external RAM itself** -
the two `CY7C199` at program `0x8000`-`0xffff` - while the DSP is held in reset,
and the reset release is the "go".

That also answers a question `dsp-map-302.md` raised from the download order:
there is no "go" command after the transfer because none is needed.

## The caveat

This was read while the modem was running normally, after the supervisor's own
download. Strictly, what is measured is that **the ASIC holds `0x0083` at DSP
data `0xffff` during normal operation**; that it holds the same value during the
reset window is an inference. Two things support it: all sixteen reads are
identical, so it is a held level rather than traffic; and it decodes to exactly
`0x8000`, which a stale mailbox word would not do by chance.
