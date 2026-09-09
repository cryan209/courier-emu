# Emulating the I-modem

Most of it already exists, and the DSP half is the same part.

## What runs today

`courier_emu.isdn.IsdnMachine` is a 386 real-mode harness on Unicorn -
`courier-emu isdn-run Ie030002.nac`.  It enters at `4030:0000`, the recovered
initialiser, and models the PC-AT furniture the firmware actually touches: an
8254 and a pair of 8259s, two 16550s at `f8f8` and `f4f8`, the board status
port `1e`, and the download ports `40`-`56`.

It gets far enough to load the DSP, and that is now checkable rather than
assumed.  In a 3,000,000-instruction run the harness captures 47,088 bytes on
the download ports, and against the images read out of the overlay table
([x2-symmetric-and-all-digital.md](x2-symmetric-and-all-digital.md)):

```
stream[16      : 15088] == image 10   (15,072 bytes, byte for byte)
stream[15088   : 47082] == image 11   (31,994 bytes, byte for byte)
```

Both images whole, in that order, after a 16-byte preamble.  That is exactly
the pair the routine at `b1655` requests - `mov [e738],0a` then `mov
[e738],0b` - so the table derivation (`cs = a400`, rows at `d682`, segment
table at `d6ca`) is confirmed by a live boot, not just by static reading.  It
also says something about the board: the image the I-modem loads first is the
PCM one.

## The DSP is the same part

The images decode with `tools/c5x_disasm.py` unchanged, the resident loads at
`8000` like the analog Courier's, the sample paths use the same memory-mapped
`@20`/`@21` (DRR/DXR), and the download handshake is the same shape - status
bits polled on port `1e`, words streamed out of `40` upward, against the analog
board's `40`-`4e`.

So `courier_emu.dsp.NativeC5x` should run these directly.  Its `load_program`
already takes raw bytes and an origin; the only thing in the way is that its
constructor is typed to `XmfImage`.  Widening that, and pointing the ISDN
harness's download ports at the core instead of a `bytearray`, is the whole
join - the analog side already has that pattern in `dsp_mailbox` and
`probe_transport`.

## Memory: more on the CPU side, not on the DSP's

| | analog Courier | I-modem |
|---|---|---|
| CPU | 80C186EB | 386, real mode |
| flash payload | `b8000` bytes at `40000` | `b8000` bytes at `40000` |
| RAM cleared at entry | - | 256 KiB, then `41c0` bytes relocated to `0ce00` |
| DSP program space used | `8000`-`f5d9` | `8000`-`ee6f` |
| DSP images | 4, 48,344 words | 7, 52,936 words |

The CPU side is plainly bigger - a 386 with a flat megabyte to play in rather
than an 80186, and a quarter of a megabyte cleared before anything starts.  The
DSP side is not: the I-modem's images top out **lower** than the analog's, at
`ee6f` against `f5d9`, so the same 32K-word external RAM
([dsp-map-302.md](dsp-map-302.md)) covers it.  What it has is more images, not
more room - seven loaded in and out of the same space, including the PCM pair
that needs two loads to fit.

## What is missing

* The C5x is downloaded but not executed - the harness records the stream.
* The ISDN front end: S/T transceiver, HDLC, B-channel routing.  Nothing in the
  DSP images touches it ([x2-symmetric-and-all-digital.md](x2-symmetric-and-all-digital.md)),
  so it is all on the 386 side and all unmodelled.
* Which device raises the system tick.  The harness drives IRQ10 from 8254
  counter 0 because that is the line the tick-delay routine at `a45df` needs;
  the physical wiring is not recovered.

## The payload is the firmware, at its final addresses

The `0xb8000` payload splits at `0x80000`, the flash window's base:

| region | size | erased | what |
|---|---:|---:|---|
| `40000`-`80000` | 256 KiB | 3.8% | the updater; holds the entry `4030:0000` |
| `80000`-`f8000` | 480 KiB | 18.5% | the runtime firmware |

And the upper half is not merely *present*, it is **already at its final
addresses**.  Payload offset X sits at `0x40000+X`; flash offset X-`0x40000`
sits at `0x80000+X-0x40000` - the same address.  Everything that executes in a
run (`a45ef`, `a543b`, `b1269`) and every DSP image (`d0d60`-`eab0c`) is above
`0x80000`.  So the image is the whole firmware, correctly placed; what a board
has and this does not is the top **32 KiB**, `f8000`-`fffff`, the boot block
with the reset vector.  The updater never supplies it - it erases at `f8100`
and programs nothing above, because it does not replace the block it boots
from.

`courier_emu/imodem_rom.py` fills that gap synthetically.  The boot block it
writes contains a reset vector and a far jump and **nothing else**: the 386EX
bring-up is left to the payload's own initialiser, which is observed doing it
in full - chip selects, both 8259s, the 8254, both SIOs, the port config -
rather than being invented here.  Two things are manufactured and should be
read as such: the real block's contents are unknown, and **the application's
own entry point is not recovered**, so the jump goes to the updater's
initialiser.  The result boots like a board and then runs the updater.

It does run.  Entered at `f000:fff0` with the assembled 512 KiB part:

```
entry f000:fff0     autoselects 5   erases 3   programs 4096
DSC registers written 28            DSP bytes downloaded 49,736
```

Programming is new - every earlier run reported `programs 0` and never got past
identification.  It then stops where it stopped before, spinning in the ring
wait at `a543b` for `[c9ae] == [c9b0]`, which only the serial ISR at `b7dcc`
advances.  Interrupts from the SIOs are the next piece.

## The application's entry point is not in the payload

Looked for, not found, and there is a structural reason rather than a search
failure.

A cold start on this board has to bring up the 386EX: chip selects, both
8259s, the 8254, both SIOs, the port configuration.  The firmware does that
from a **table of three-byte records** - port word, then value - walked by a
loop at `4040b`.  The table is at `40434`-`4046a`, and the runs in it are
recognisable:

```
43 f0 34 | 43 f0 74 | 43 f0 b4        the 8254
20 f0 11 | 21 f0 20 | 21 f0 04 | …    ICW1..ICW4, master then slave
fb f8 80 | f9 f8 00 | f8 f8 02 | …    SIO0, then the same for SIO1
```

Searching the whole payload for those runs finds **one copy of each, all in the
updater half**.  The flash half has none.  So the application does not bring up
its own hardware - the boot block does, and the boot block is exactly the
32 KiB the payload never supplies.  Nothing in an update image needs to name
the application's cold entry, and nothing in this one does.

Two consequences worth stating plainly:

* **What was modelled as "the firmware's init" is the updater's.**  The 386EX
  sequence runs at `403af`, `403cf` and `4040b`; the Am79C30A setup in
  [imodem-isdn-front-end.md](imodem-isdn-front-end.md) runs at `40b3a`.  All
  three are below `0x80000`.  The register semantics recovered there are
  unaffected - the chip is the chip - but the code driving them is the update
  program, not the application.
* **The flash half is entered through gates, and those we do have.**  The
  vectors the updater installs into it:

| vector | target | |
|---|---|---|
| INT `02` | `c774:0300` = `c7a40` | |
| INT `20` | `a400:ef1a` = `b2f1a` | a real ISR - `pusha ; push ds ; push es ; mov ax,2600 ; …` |
| INT `23` | `b2aa2` | |
| INT `25` | `cfdb0` | |
| INT `26` | `a400:120a` = `a520a` | |
| INT `2c` | `c774:0502` = `c7c42` | |
| INT `30` | `7360:0000` = `73600` | the updater's own gate, 2,085 calls in 3M instructions |
| INT `31` | `98d1:0000` = `98d10` | data, not code - the relocation descriptor for the `41c0` bytes moved from `98d50` to `0ce00` |

Those are real entry points into the flash half and are worth having.  None of
them is the cold entry.

What would settle it is 32 KiB off a board - `f8000`-`fffff`.  Short of that,
the next thing to try is a scan of the flash half for a routine that installs
the interrupt table wholesale, on the assumption that the application re-points
the vectors the updater currently owns.

### Found: `a400:0008`

The previous section said the cold entry was not in the payload.  That was
right about the *bring-up* and wrong about the entry, which is recoverable
after all - from the code that installs interrupt vectors.

Three sites in the flash half write vectors, and two of them name the segment:

```
c7d85  mov ax,0 ; mov es,ax ; mov bx,008c        ; vector 23
       mov word es:[bx], d86e
       mov word es:[bx+2], a400                  ; <- the segment
c5479  mov ax,0 ; mov es,ax ; mov di,0080        ; vectors 20..2f
       mov cx,0010 ; mov ax,00bd
       stosw ; add ax,0006 ; mov word es:[di],3497 ; add di,2 ; loop
```

So the firmware's code segment is **`a400`** - which independently matches the
DSP overlay loader, whose table at `cs:d682` resolves only with `cs = a400` -
and the hardware vectors `20`-`2f` are pointed at a sixteen-entry stub table in
**RAM at `34970`**, six bytes apart, which is exactly the RAM block observed
executing the flash identification.

Segment `a400` is physical `a4000`, and it opens:

```
a4000  bd 0b 00        mov bp, 000b        ; the same signature the analog
a4003  e9 05 0c        jmp  a4c0b          ; flash carries at its own base
a4006  eb fe           jmp $
a4008  fc              cld                 ; <- the cold start
a4009  b8 00 26        mov ax, 2600
a400c  8e d8 8e c0     mov ds, ax ; mov es, ax
a4010  e8 30 d2        call …
a4013  b8 00 80        mov ax, 8000
a4016  e8 64 d2        call …
a4019  b8 00 00        mov ax, 0000
a401c  b9 7c 24        mov cx, 247c        ; the resident DSP image, to the byte
a401f  e8 3c d3        call …              ; the download
```

`0x247c` is image 5's length exactly, so this is the sequence that loads the
DSP resident - a cold start, not a service routine.  Booting the assembled ROM
at `a400:0000` runs two instructions and traps on the `int3` at `a4c0b`;
booting at **`a400:0008`** runs 30,000,000 instructions without faulting,
relocates code into RAM, and begins the DSP download.  It then stalls at
`7f98c`, in the relocated block, having sent 24 bytes - which is the same class
of wall as before: nothing yet answers on the DSP or the interrupt lines.

`imodem_rom.DEFAULT_ENTRY` is now `a400:0008`, with `UPDATER_ENTRY` kept for
booting the update program instead.

### What it stops on, exactly

Two different things, and neither is a device.

**Booting the ROM alone, it does not stall - it derails.**  Traced from the
reset vector, the cold start runs:

```
a4008  cld ; mov ax,2600 ; mov ds,ax ; mov es,ax
a4010  call b1243          ; DSP download
a4016  call b127d          ; and again
a401c  mov cx,247c         ; the resident image's length
a401f  call b1503          ; the download proper
a4022  xor bp,bp ; pushf ; push ds ; push es ; push ax
a4028  push 0ce0 ; pop ax ; mov es,ax ; mov ds,ax ; pop ax
a4031  call far 7561:443e  -> 0x79a4e
```

`0x79a4e` is **below the flash window**.  In a ROM-only boot nothing is mapped
there, so it executes a field of zeros - `add [bx+si],al` - and walks until it
wraps.  What that call says is that the application expects RAM already
populated when it starts: code at segment `7561` and data at `0ce0`, the latter
being exactly where the update image's own initialiser puts the `41c0` bytes it
moves from `98d50`.  Populating RAM is part of the boot block's job, and the
boot block is the part we do not have.

**Booting with the payload's lower half mapped, so that RAM content exists, the
cold start completes.**  It sends **47,096 bytes** to the DSP - against 24 in
the ROM-only boot - and then settles into a two-instruction loop at
`a45df`/`a45e3`.  That is the tick-delay routine `courier_emu/isdn.py` already
names, and `hardware_interrupts` is **0**: the synthetic boot block never
programs the 8259s or the 8254, and the application does not do it for itself.

So both endings are the same missing piece.  A real boot block brings the 386EX
up and fills RAM; ours only jumps.  The bring-up half is not guesswork away -
the board's own table is in the image at `40434`, three-byte records, in order:

```
f043 34 / f043 74 / f043 b4                       the 8254
f020 11 / f021 20 / f021 04 / f021 11 / f021 ff   master ICW1..ICW4
f020 c2 / f020 48                                 OCW
f0a0 11 / f0a1 28 / f0a1 02 / f0a1 01 / f0a1 ff   slave
f8fb 80 / f8f9 00 / f8f8 02 / f8fb 03 / f8f9 0b   SIO0
f4fb 80 / f4f9 00 / f4f8 02 / f4fb 03 / f4f9 0b   SIO1
```

Replaying those from the boot block, and copying the RAM half into place, is
the next step - both are transcription rather than discovery.

### The bring-up, replayed - and where that ends

`imodem_rom.bring_up_code()` now reads the firmware's own initialisation table
out of the image and emits it as straight-line `mov dx / mov al|ax / out`, in
order, before the jump.  The table is found by its 8254 anchor
(`43 f0 34 / 43 f0 74 / 43 f0 b4`) and parsed in two sections - **35 three-byte
records** (port word, byte value) ending in a zero, then **24 four-byte
records** (port word, word value) for the chip-select unit.  379 bytes of boot
block, none of it composed here.

It works as far as it goes.  The 8254 is programmed and counting - the run
reports **12,935 timer ticks** where it reported none - and SIO0 emits its
first byte.  What does not happen is an interrupt: `hardware_interrupts` stays
**0**, and the cold start still sits in

```
a45d8  push ax
a45d9  mov ah, [c8cb]      ; the tick counter
a45dd  add ah, al          ; al = how many ticks to wait
a45df  cmp ah, [c8cb]
a45e3  jne a45df           ; spin until the ISR gets there
```

which is a delay routine waiting on a counter only a timer ISR advances.  It
cannot advance here because **IF is clear** on this path.  Unmasking the
cascade and IRQ10 by hand and setting IF in the boot block changes nothing -
still `irq 0` - because the flag is cleared again by the code that got us here.

That is the useful negative result: it is not a masked line or a missing
vector.  A real cold start would not call a tick delay with interrupts off, so
**the path being taken is not the real one** - which is what should be expected
from the far call at `a4031` landing in the update program rather than in
whatever the boot block puts at segment `7561`.  Following the cold start
faithfully needs that RAM image, and the image does not carry it.

The floor this leaves is still worth having: reset vector, board bring-up from
the board's own table, the DSP loaded with 47,096 bytes, flash command set,
DSC register file.  What it cannot do is start the application the way a board
does.

### The analog Courier's boot block, and what it says about the I-modem's

The analog side has what the I-modem lacks - a whole flash - so its boot path
can just be read.  From the reset stub at `ffff0`:

```
ffff0  cli ; mov dx,ffa4 ; mov ax,8000 ; out dx,ax   ; the 80186's UMCS
       jmp far fc00:1a21                              -> fda21

fda21  cld ; xor ax,ax ; mov ds,ax ; mov es,ax ; mov ss,ax ; mov sp,00f8
       mov word [ffa8], 00ff                          ; LMCS
       mov si,1976 ; mov cx,0024                      ; 36 word records
       lods cs:[si] ; xchg dx,ax ; lods cs:[si] ; out dx,ax ; loop
       mov si,1a06 ; mov cx,0009                      ; 9 byte records
       lods cs:[si] ; xchg dx,ax ; lods cs:[si] ; out dx,al ; loop
       xor ax,ax ; mov si,ax ; mov di,ax ; mov es,ax
       mov ax,cs ; mov ds,ax ; mov cx,1975 ; shr cx,1 ; inc cx
fda61  rep movsw                                      ; cs:0 -> 0000:0
       xor ax,ax ; mov ds,ax
fda67  int 13
```

Three things follow, and all three transfer.

* **The table-driven init is the same design.**  Word records then byte
  records, walked by `lods`/`out` - the I-modem's tables at `40434`/`4049e` are
  the 386EX version of the same idea.  So replaying them from a synthetic block
  is the right shape, not a workaround.
* **The boot block carries a low-RAM image and copies it down** - `0x1976`
  bytes from the start of its own segment to `0000:0`.  That is the piece the
  I-modem's missing 32 KiB must also hold, and it explains what the I-modem's
  code expects to find at segments `0ce0`, `3497` and `7561`.
* **The application is entered through a vector, not an address.**  The last
  instruction is `int 13`, dispatched through the table just copied in.  So
  there is no far reference to a cold entry anywhere in the flash - and there
  is none in the I-modem's payload either, which is now explained rather than
  merely observed.

**Correction.**  `a400:0008` was reported here as the I-modem's cold start.  It
is not.  A normal update run executes it exactly once, called by the updater,
and it returns through `call far 7561:443e` - into the update program.  The
sequence is real and does load the DSP resident (`mov cx,247c`), but it is a
routine the updater calls, not a boot entry.  `imodem_rom.DEFAULT_ENTRY` is
`UPDATER_ENTRY` again, with `DSP_LOAD_ENTRY` kept under its own name.

What would let the I-modem boot for real is its low-RAM image.  It is not in
the payload: the code at `79a4e` that the cold path calls appears **nowhere**
in the flash half, so the boot block is its only home.

### Can the missing piece be inferred?  Not the code - but there is less missing than it looked

Two separate answers, because two different things were being called "missing".

**The routine at `7561:443e` is not missing at all.**  It is update-program
code, and version-specific: the region at `75610` is only **1.4%-1.9%**
byte-identical between `Ie030002` and the four other releases at the same
address, and the reference block appears nowhere in any of them.  Its own first
bytes settle it -

```
75610  popa ; pop ds ; pop es ; mov ax,0011 ; int 30 ; iret
```

`int 30` is the updater's own service gate.  So `a400:0008` is a flash-half
routine **linked against the update program** - the updater calls it, it loads
the DSP resident, and it calls back through `int 30`-era code.  Nothing about
that is a boot path, which is the last confirmation that it is not the
application's cold start.

**The boot block's low-RAM image is missing, and it cannot be inferred.**  Four
places it is not:

* not in the flash half - the code at `79a4e` that the path calls appears
  nowhere in `80000`-`f8000`;
* not compressed there either - across the whole 480 KiB there are **zero**
  4 KiB windows above 7.2 bits of entropy, and the region as a whole sits at
  6.7;
* not in the sibling releases - the same address differs almost completely
  across all nine;
* not written by the updater - it erases the block at `f8100` but issues **no
  program setup** anywhere at or above `78000` in any path run so far.

43 KiB of compiled code cannot be reconstructed from its call sites.  What can
be had from them is the interface and nothing more: entered by a far call with
`ds = es = 0ce0`, and the body is compiled C (`push bp ; mov bp,sp ; sub sp,18`)
touching data at `ds:a63f`.

**What is inferable, and is now recovered**, is everything around it: the boot
block's structure from the analog's (segments and stack, the word and byte
port tables, `rep movsw` of a low-RAM image into `0000:0`, dispatch by `int`),
the I-modem's own equivalents of those tables at `40434` and `4049e`, and the
convention that the application is entered through a vector rather than an
address.  That is enough to build a boot block that is right in shape.  It is
not enough to make one that is right in content.
