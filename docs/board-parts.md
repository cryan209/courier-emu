# What is actually on the board

Identified from a photograph of the user's 20.16 MHz Courier (the unit running
ID_SDL 4.03d, supervisor 7.4.16 / DSP 3.1.2), with each claim checked against
the firmware where the firmware can check it.

Markings are read off one photo of part of the board. The DAA/line section is
not in frame, so nothing here says what is on it.

| marking | what it is |
|---|---|
| `NEC USA 1-016-905 9948LV001` | **the ASIC.** A USR part number on an NEC-fabricated gate array, date code week 48 1999 |
| `TI DSP 16-912 (C) US ROBOTICS D17140PQ` | the C5x-family DSP, custom-marked with a USR part number |
| `S80C186` | the Intel supervisor |
| `TLC...320AC01CFN` | the voice-band codec, PLCC, next to the DSP |
| `ECLIPTEK EC11 40.320M` | the master oscillator |
| `ISSI IS61C256AH-15J` | 32Kx8 15 ns SRAM |
| `ADM707` | supervisory/reset |
| `74VHC573`, `74VHC32`, `74VHC04` | bus glue |
| Atmel 8-pin | serial EEPROM, the NVRAM the settings cache comes from |

## The NEC part is the ASIC

`1-016-905` is a US Robotics part number, not an NEC catalogue number: NEC
fabricated it, USR designed it. A gate array in a package that size, on this
board, is the part every note in this repository has been calling "the
interposed ASIC" and modelling as a black box.

That is a placement argument, not a pin trace. What supports it is that the
supervisor's I/O space needs a device of exactly this description and there is
no other candidate on the bus. From `artifacts/io-port-map/board-21210/`, the
80186 drives:

| ports | role |
|---|---|
| `0x0c`-`0x1a` | board latches: hook relay, NVRAM strobe, carrier-detect pair, ring detect |
| `0x1c`, `0x1e` | mailbox status and command |
| `0x40`-`0x4e` | the DSP download window |
| `0x50`-`0x56` | second window bank |
| `0x58`-`0x5e` | mailbox tag and data registers |
| `0x60`, `0x62` | the DSP-to-host stream window |

None of that is the CPU's own peripheral block, which is relocated to memory
`0xff00`-`0xffff`. None of it is flash or SRAM. All of it is one device
bridging the 80186 bus to the DSP, the codec, the DAA and the front panel -
and the ASIC is the only device left to be it.

So everything the notes attribute to "the ASIC" lives in this package: the
mailbox, the DSP download path, the codec bring-up sequence that neither
processor performs, the line detector the harness answers by hand, and the tone
generator that is why `--exchange` still hears silence when the firmware dials.
Its behaviour is unpublished, and this identification does not change that. It
does say the missing piece is one part, and which one.

## The oscillator settles the clock independently

`40.320M`. The 80C186 divides its oscillator input by two, so CLKOUT is
**20.16 MHz** - which is what `ATI7` reports, and the number
[the timebase note](hardware-timebase-and-audio-path.md) needed.

That closes an ambiguity in the timer argument. `T0CMPA` is 25,200 and the
80186 counts internally clocked timers at CLKOUT/4, but 25,200 lands on a round
figure either way: 5.000 ms at CLKOUT = 20.16 MHz, or 10.000 ms if 20.16 MHz
had been the crystal and CLKOUT half of it. The board's `&T1` slope of 1.000031
seconds per `S18` unit already chose the first, since seconds convert to ticks
by multiplying by 200. The can on the board now says the same thing from the
hardware side: 40.320 divided by two is 20.16, so the timer clock is 5.04 MHz
and the tick is 5.000 ms.

## The codec is a TLC320AC0x, and the firmware proves it

The part next to the DSP is a TI PLCC marked `320AC01CFN`. The DSP's own code
confirms the family, independently of the photograph.

The TLC320AC0x pairs with a TMS320 serial port and uses **bit 0 of the
transmitted DAC word to request a secondary frame**, in which a control
register is written. That is exactly what the C52 does:

```
00c2  lacl #01 ; samm @21      ; first word after reset is 0x0001:
                               ; D0 set, asking for a secondary frame
01b8  apl  *, #fffe            ; ordinary sample: clear D0
01ba  lamm @6b ; or *+
01bc  samm @21                 ; ...then OR in the request flag
0200  and  #0000fffe ; samm @21  ; sample with D0 cleared
01ea  lamm @6c ; samm @21      ; the secondary frame: the control word
021d  lacl #00 ; samm @6b      ; request satisfied, clear the flag
```

and `0x0188` is the blocking sender that goes with it - stage the word in
`@6c`, set `@6b`, `idle` until the serial ISR has sent it, return:

```
0188  samm @6c
0189  lamm @6b
018a  cc   8190, neq
018c  smmr @6b, #012f
018e  lacl #01 ; samm @6b
0190  idle
0191  lamm @6b ; bcnd 8190, neq
```

`0x0195` reads control words out of a table at program `0x019c` and feeds them
through it: `0911 0967 0956 0934 0923 0969 0989 bc07 1019 ba01 9019 f788 be4c
7718 8b8f 8711`. That is the codec's initialisation. The individual register
fields are not decoded here - there is no TLC320AC01 datasheet in `docs/`, and
a guessed bit layout did not fit the table.

### but that code is dormant, which is the interesting part

It runs at reset and then stops. In a 60M-instruction run `dxr_writes` is
**3**, all at program `0x00c6`, and `tdxr_writes` is **0** - the DSP never
transmits on either serial port after initialising the codec. What it does
instead is poll, in one resident-bank loop: `DRR` 338,279 times, `TRCV`
676,558 times, and ASIC external I/O `0x50`/`0x52`/`0x54` 338,279 / 411,025 /
676,556 times.

So the AC0x is initialised and then not driven. Two readings fit:

1. The ASIC fronts the codec. The C52 configures the part once, and thereafter
   the ASIC moves samples, which is the topology
   `courier_firmware_analysis.md` already argues for from AN16 section 1.3 and
   from the C52's view being four ASIC ports.
2. One firmware serves two board variants, and this one does not use the
   serial-codec path.

Nothing here chooses between them.

### Which board has which part is not recorded

`courier_firmware_analysis.md` says the Si3014/Si3021 pair was "read off the
board" - line side at the phone jack, digital side near the CPU - but does not
say **which** board. There are at least two units in this repository's
evidence: the 20.16 MHz one photographed here, and a 25 MHz US/Canada unit
(`artifacts/io-port-map/hardware-25mhz/`, supervisor 7.3.14 / DSP 3.0.13).

The photograph covers the DSP/ASIC area of the 20.16 MHz board only. Its DAA
section, at the phone jack, is not in frame. So the two attributions are not
yet in conflict, and there are two live possibilities:

- **one board, two parts in two roles** - a TLC320AC0x on the DSP's serial port
  and an Si3021/Si3014 as the line interface; or
- **two board generations** - a TI codec in the older design and a Silicon Labs
  silicon DAA in the newer, with one firmware carrying both paths, which would
  explain the dormant AC0x code directly.

What would settle it is one look: whether the photographed 20.16 MHz board also
carries Si parts near its phone jack, and whether the 25 MHz board carries a
TI PLCC near its DSP. That is a datum from the boards, not from the images.

Either way `CodecBringUp` is questionable: it runs an `SI3038.PDF` register
sequence, and the part the DSP's own code initialises is not that one.

## The DSP's low program memory is RAM, and the download shows it

[The timebase note](hardware-timebase-and-audio-path.md) argued the C52's
internal mask ROM is not what executes, from the reset code's own branch
targets and from wait-state programming. A USR-marked TI DSP is exactly what a
mask-ROM part looks like, so that argument deserved a better test than it had.

There is one, and it was already in the runs. The bridge does not assume the
transfer: it accumulates the supervisor's actual download stream and compares
it against the image. Every run reports `bootstrap_match: true` at
`bootstrap_bytes: 60344` - 30,172 words, the whole origin-`0x0000` segment
covering program `0000..75d9`.

So the supervisor really does transfer 30k words whose content is
`0x0000`-origin code, spanning the entire 4K mask-ROM window. Program
`0000..0fff` is written by the CPU, so it is external RAM. Whether the die also
carries a mask ROM that is simply never mapped is still not something any of
this can say.
