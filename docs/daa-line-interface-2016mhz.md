# What the 20.16 MHz Courier's CPU sees of its line interface

The supervisor's picture of the phone line comes from two different places, and
only one of them is the ASIC. This records the CPU-side half - what the 80186
reads and writes directly, before anything the ASIC or DSP computes - because
a model that puts every line signal behind the event channel gets the ring path
wrong.

Addresses below are file offsets in the user's board image,
`artifacts/courier-board-21210-capture-403/courier-board.rom` (supervisor
7.4.16). `IDSDL302.ROM` carries both structures too; where its addresses differ
they are noted.

## Two CPU-visible line signals, both on port 0x14

Ports `0x10`, `0x12` and `0x14` are write-only board latches, so the firmware
keeps shadow copies: `[0x011b]` mirrors port `0x12` and `[0x011c]` mirrors port
`0x14`. Every write below is built by OR-ing or AND-ing a mask into the shadow
and sending the whole byte.

### Ring sense - port 0x14 bit 1

A tick-driven cadence machine samples it directly. The ticker at `0x14ff0`:

```
14ff0  dec  byte [0ae4]
14ff4  jne  15004
14ff6  inc  word [0ad8]          ; cadence accumulator
14ffa  mov  byte [0ae4], 0x0c    ; reload: 12 ticks, 60 ms at the 5 ms tick
14fff  lcall 0x8000:0xc001
15004  call word ptr [0ada]      ; the current cadence state
```

`[0x0ada]` is a state vector in the same style as `[0x0298]` and `[0x02d3]`.
Its states read the line and branch on one bit:

```
1501d  in   al, 0x14
1501f  test al, 2
15021  jne  15039
```

with debounce counters `[0x0ade]` and `[0x0adf]` compared against a threshold
held in `[0x0cd2]`, and `0x5bb5` as the reset state. Twenty-seven sites arm the
vector; the two that start it, `0x0bfe8` and `0x0bff2`, sit in the same module
as the `CALL PROGRESS` banner. `IDSDL302.ROM` has the same machine with six
sense sites rather than ten.

This is the signal `daa.py` already models as "ring cadence presented to the
ring detector on input port 0x14", and it is the one line signal the CPU
measures for itself.

### A four-bit part identity - port 0x14 bit 3, clocked on 0x12 and 0x14

`0x287f9` bit-bangs a small serial read. It asserts masks on port `0x12`
(`0x09`, `0x02`) and port `0x14` (`0x70`, `0x40`, `0x20`, `0x10`), sampling
port `0x14` bit 3 after each and shifting it into `BX`:

```
2880c  out  0x14, al        ; 0x70 asserted
2880e  in   al, 0x14
28810  test al, 8
28812  jne  28817           ; present
28814  jmp  28898           ; absent -> return 0xff
...
28825  in   al, 0x14 / and al, 8 / or bl, al / shl bx, 1   (x4)
2888f  mov  al, bl / sar al, 4 / and al, 0x0f              ; the 4-bit value
```

Absent returns `0xFF`. The value is stored at `[0x014b]` by the caller at
`0x28426`, after a table walk indexed through `[0x0156]` against `[0x014c]`.
Its bits are tested at `0x00595`, `0x005af`, `0x00751`, `0x209d7`, `0x209ea`
and `0x49b2b` - `test byte [014b], 1` and `, 2` - so the identity selects
behaviour rather than being merely reported. The second caller, `0x28787`,
pushes the same value out the 80186 serial port (`[0xff6a]`, spinning on
`[0xff66] & 8`). `IDSDL302.ROM` carries the identical routine at `0x28765` and
a second copy at `0x7d222` in the boot area.

## What the CPU does not see

No CPU port carries a line level. The detector the dial path waits on is not
sampled here: it arrives over the ASIC event channel as event `0x08` with a
data word read from ports `0x5e`/`0x5c`, and the qualification is bit 0 of that
word's high byte, five consecutive times - see
[the ATY diagnostics](at-y-diagnostics.md). Dial tone, ringback, busy and
answer tone are all recognised on the far side of that channel.

So the split is: **ring sense and part identity are the CPU's; every level and
every call-progress tone is the ASIC's.**

## What this does not establish

The bit meanings are inferred from how the code uses them, not from a probe.
"Port `0x14` bit 1 is ring sense" rests on a tick-driven cadence machine with
debounce counters reading that bit and nothing else, plus the harness's
existing model; no capture in this repository shows the bit changing while a
line rings. The four-bit read at `0x287f9` is called an identity because it is
read once, stored, and branched on - the device on the other end of those
clocks has not been identified, and calling it the DAA rather than an option
strap or country module is an assumption. Neither routine was executed in the
emulator for this note; both were read statically from the two images.
