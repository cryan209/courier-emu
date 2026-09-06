# The DSP mailbox map for IDSDL302.ROM only

**These addresses are `IDSDL302.ROM` (DSP 3.0.13) and nothing else.** They are
not the ones in [who-produces-the-events.md](who-produces-the-events.md), which
were read off `artifacts/courier-board-21210-capture-403/courier-board.rom`
(DSP 3.1.2). The two builds differ in more than offsets - they use different
cells and a different ring - so transplanting an address between them produces
a probe that reads the wrong memory and reports nothing, which is exactly the
mistake this file exists to prevent.

Everything below is anchored on the one `out *, 0060` in the image, at file
`0x299ee`, which `dsp_mailbox.py` names as the 3.0.13 sender at DSP `0x84b7`.
Addresses are DSP program words; the linear file mapping is
`dsp = (file / 2) - 0x14CF7 + 0x84b7`.

## The map

| what | 302 (3.0.13) | 403 (3.1.2) |
|---|---|---|
| status latch, read through AR1 | **`0xFF57`** | `0x57` |
| tag cell | **`0xFF5E`** | `0x5E` |
| word cell | **`0xFF5F`** | `0x5F` |
| cell-read helper | `0x23f0` | `0x80e8` (`lamm *`) |
| service loop | `0x80c8` | `0x80bb` |
| receive dispatcher | `0x839b` | `0x8387` |
| dispatch table base | `0x8401` | `0x83e9` |
| outbound ring base | **`0x0bd0`** | `0xff60` |
| ring write / read pointers | `@78` / `@79` | `@78` / `@79` |
| message sender | `0x83d6` | `0x83d6` |
| stream resume poll | `0x847a` | `0x8462` |
| stream vector cell | `0x039e` | `0x039e` |
| tag-06 handler | `0x8489` | `0x8470` |
| stream sender | `0x84b7` | `0x849e` |
| packer | `0x84bc` | `0x84a3` |
| idle wait | `0x8149` | `0x8138` |
| frame ISR entry | `0x816b` | (not located) |

The status bits are the same in both, and the DSP writes `1` to acknowledge a
receive, `2` to complete a send, `4` for a stream word.

> **Corrected: those are bit *codes*, not bit numbers.** `BIT dma, code` on the
> C5x tests bit `15 - code` - this core evaluates `(~op >> 8) & 0xf` - so the
> instructions this document read as "bit 15", "bit 14" and "bit 13" test bits
> **0**, **1** and **2**:
>
> | instruction | disassembles as | tests | meaning |
> |---|---|---|---|
> | `4f7d` | `bit 15, @7d` | **bit 0** | a message is pending |
> | `4e7d` | `bit 14, @7d` | **bit 1** | the send window is free |
> | `4d7d` | `bit 13, @7d` | **bit 2** | resume the stream |
>
> This is not cosmetic: `bridge.py` raised `0x8000` for pending and `0x2000`
> for resume, so the dispatcher's poll never saw either. It is the direct cause
> of the symptom recorded further down this document - "the tag and word
> arriving and bit 15 never being consumed".

## The dispatcher, at 0x839c

```
839d  calld 23f0, * / lar ar1, #ff57   ; read the status latch
83a3  bit  15, @7d / retc ntc          ; nothing pending
83a6  calld 23f0, * / lar ar1, #ff5e   ; the TAG
83ad  calld 23f0, * / lar ar1, #ff5f   ; the WORD  -> @7a
83b3  lacl #01 / samm @57              ; acknowledge
83b6  sub  #7f / retc gt               ; reject above 0x7f
83b8  add  #00008480 / tblr @7c        ; table base 0x8480 - 0x7f = 0x8401
83bc  bacc
```

Table entries confirm the identification against constants this repository
derived from hardware: tag `0x06` to `0x8489`, and tag `0x42` to **`0xb05e`**,
which is exactly the "Tag 42's handler at b05e" in `dsp_mailbox.py` - so that
comment describes 3.0.13, not 3.1.2.

## The service loop, at 0x80c8

```
80c6  call 8223, *
80c8  call 839b, *, ar1     ; the receive dispatcher
80ca  call 83d6, *, ar1     ; the message sender
80cc  call 847a, *, ar1     ; the stream resume poll
80ce  call 80f8, *
80d0  lar  ar0, @10 / cmpr eq
80d2  bcnd 80c8, tc         ; loop
```

Same three calls per iteration as 3.1.2's loop at `0x80bb`. Note the dispatcher
entry is `0x839b`, one word before the `setc intm` this document first quoted -
`ldp #000` comes first, as it does in 3.1.2.

**The DSP does not reach it.** Sampling the core's PC across a run puts nothing
at `0x80c8`, `0x839b`, `0x83d6` or `0x847a`, and the run's own `idle` wait poll
at `0x814d` collects 237 samples while `0x80ac`, in the call sequence before
the loop, collects 26.

One caution on reading that histogram: its largest entries are an artefact.
`0x801d` takes 1617 of 3999 samples, `0x8024` 406, `0x8028` 207 - but those are
the reset prologue's block clears, `rptz #03ff` / `sach *+` and friends, where
one instruction repeats 1024, 256 and 128 times. A sampler lands there in
proportion to the repeat count. It does **not** mean the part is resetting over
and over: a run creates the core once and bootstraps once.

> **Corrected.** The last sentence is right about the harness and wrong about
> the part. The harness bootstraps once, but the *firmware* was re-entering its
> own reset prologue - four passes in 200k instructions, forty in 2M - because
> the helper copied into `0x23f0` was three zero words. With the shared external
> window below it now models, the prologue runs once. The `idle` at `0x814d`
> that this section reads as a failure to reach the loop is where a correctly
> booted part waits.

## Two things this map exposes

**The delivery this harness performs cannot work on 302.** `_deliver_host_message`
writes cells `0x5e`, `0x5f` and `0x57`, which is right for 3.1.2, where the
helper is `lamm *` and masks the address to `0x7f`. On 3.0.13 the dispatcher
reads `0xFF5E`, `0xFF5F` and `0xFF57` through a different helper. Writing the
low cells leaves the ones it reads untouched, which is why every 302 run showed
the tag and word arriving and bit 15 never being consumed.

Note also that 302 *writes* its acknowledgement with `samm @57`, which masks to
`0x0057`, while it *reads* the same latch at `0xFF57`. On the part those are
presumably the same register seen twice; in a flat model they are two
locations, so a DSP acknowledgement would not be visible to the DSP's own read
path either.

### Both halves of that are now measured, and both were wrong

Driving the dispatcher directly settles it. Run the resident from `0x8000` only
as far as the `bldp` - so the helper is installed at `0x23f0` - then stage a
tag, a word and a status, and enter through the service loop's own call site at
`0x80c8`, which is what sets `ARP` to 1 (jumping straight to `0x839b` instead
leaves `*` reading whichever `AR` the prologue left selected, and the helper
reads the wrong address):

| pending flag | `@7d` | `@57` after | `@7a` | outcome |
|---|---|---|---|---|
| bit 15, as `bridge.py` raised it | `8100` | `8100` | `0000` | returns, nothing consumed |
| **bit 0**, what `bit 15, @7d` tests | `0001` | **`0001`** | **`beef`** | word arrives, acknowledged |

The status was staged as `0x0100 | flag`, so `@57` reading exactly `0x0001`
afterwards is the dispatcher's own `lacl #01 / samm @57` overwriting the
marker - an acknowledgement, not the value handed in.

So there were **two** faults on this path, not one:

1. **The wrong bit.** Bit 15 for pending, per the bit-code inversion above.
2. **The wrong storage.** The tag and word in that passing run were staged in
   the **I/O ports**, not in data cells. `lamm` masks to `0x7f` and reads a
   memory-mapped register, and this core resolves `0x50`-`0x5f` through the I/O
   ports; `_write_host_cell` used `set_data` alone, so it wrote a cell nothing
   reads. The `lacc *` half does load the data cell, but `lamm *` immediately
   overwrites the accumulator with the register.

`_write_host_cell` now writes the I/O view alongside both data views, and
`_read_host_cell` folds it in.

**Some handlers are outside the loaded segment.** The 302 image's one segment
is origin `0x8000`, 27710 words, spanning `0x8000..0xec3d`. The dispatch table
points below that: tag `0x7c`, the detector poll, to `0x23f0`, and tag `0x7b`,
the DAA identity, to `0x7e80`. The cell-read helper the dispatcher itself calls
is that same `0x23f0`. So on 302 the mailbox path calls into program memory no
overlay in the image provides.

That contradicts the conclusion in the other note that a ROM needs nothing
below `0x8000`, which was reached from the overlay entry words alone. Both
observations are recorded; which is wrong is not resolved here.

## What fills the SARAM

The prologue does, with a block move, and the three words it copies are the
mailbox helper itself:

```
80a0  lacc #000023f0
80a2  samm @1f          ; BMAR = 0x23f0
80a3  mar  *, ar1
80a4  lar  ar1, #80f5
80a6  rpt  #02          ; three words
80a7  bldp *+           ; data 0x80f5.. -> program at BMAR
```

and at `0x80f5` in the downloaded image:

```
80f5  1080  lacc *
80f6  0880  lamm *
80f7  ef00  ret
```

`lacc * / lamm * / ret` is exactly the cell-read helper the dispatcher and the
resume poll `calld` at `0x23f0` on every pass - and 403 needs no copy because
it keeps the same helper in-bank at `0x80e8`. So SARAM is filled by the
firmware reading its own downloaded program **through data space** and writing
it into program space.

### The external RAM answers both spaces, and the earlier retraction was wrong

`bldp` sources from data memory, so a data read of `0x80f5` has to return what
the download put at program `0x80f5`. An earlier attempt at that reported a
regression and was reverted; the measurement it asked for has now been taken,
and it says the opposite.

Logging every data access at or above `0x2c00` with its PC, across a 2M
instruction standalone run of the 302 resident, gives **twenty-five sites and
no more**:

| PC | addresses | direction |
|---|---|---|
| `0x8070`-`0x8081` | `0xfff0`, `0xfff3`, `0xfff4`, `0xfff6`, `0xfff7` | writes |
| `0x80ac` | `0xff51`-`0xff5f`, sixteen cells | writes |
| `0x80a7` | `0x80f5`, `0x80f6`, `0x80f7` | **reads** |
| `0x0bf7`, `0x0bf8` | `0xff60`, `0xff61` | reads |

So along the resident's boot path the firmware performs exactly **three** data
accesses in `0x8000`-`0xfeff`, all reads, all the `bldp` at `0x80a7`.
Everything else above `0x2c00` is at `0xff51` and up, which is the ASIC window
the firmware reaches through DP `0x1fe`/`0x1ff` - and that is where the shared
window has to stop.

> **That count is the boot path only, and taking it for the whole firmware was
> a mistake.** The overlays read data in the window too: the V.34 arming path
> reads data `0xfea1` six times from `0xd668`, walking the capability
> descriptor list [v34-arming.md](v34-arming.md) recovered. That does not
> contradict the shared model - `0xfea1` is above the resident's `0xec3d` and
> above the highest overlay's `0xf8b5`, so it is free RAM being used as data,
> which is exactly what one memory answering both spaces predicts. What it
> broke was the *harness*: `set_data` staged the descriptor into the data array
> while the running program now read the program one, two arrays for one RAM.
> Both accessors follow the window now.

With `0x8000`-`0xfeff` backed by the program storage in both spaces, the
`bldp` reads `1080 0880 ef00` - `lacc * / lamm * / ret`, the helper this
document predicted - instead of three zero words, and the part's behaviour
changes completely:

| | prologue passes in 200k instructions | ending PC | SARAM fetches | external program fetches |
|---|---|---|---|---|
| before | 4 | `0x814d` | 1,373,184 | 16,281,745 |
| after | **1** | `0x814d` | 7,155 | 67,128 |

The "before" column is a runaway. Copying zeros into `0x23f0` makes the
dispatcher's `calld 23f0` execute nothing, the part falls off into unloaded low
memory - the 20M-instruction bridge run ends with its PC at `0x0115` - and it
re-enters its own reset prologue over and over. That, not a healthy run, is
what the earlier note recorded as "running across its prologue", and reaching
`idle` at `0x814d` was the improvement it mistook for a regression.

After the change the 302 resident boots **once**, executes its real helper out
of SARAM, and parks in the `idle` at `0x814d` waiting for an interrupt - which
is the correct place for a part whose service loop is entered from a frame ISR
that nothing in the harness yet delivers.

403 is unaffected in both directions: its `data_shared` count is zero and its
run is identical either way, because it keeps the same helper in-bank at
`0x80e8` and never reads program space as data. That is the prediction this
document already made, now measured.

### The window applies to the ROM images, not to every image

`main211.xmf` presents a first segment at origin `0x0000` *and* one at
`0x8000`, and which of those is its real payload is the unresolved question at
the end of this document. For an image like that the harness cannot say where
the board's RAM sits, so `NativeC5x` switches the window off when any program
segment origin is below `0x8000`, and that image's data space behaves exactly
as it did before the window existed. Turning it on for `main211` regressed its
call-overlay run to the point of never arming `IMR`.

So the window is a fact established for the 20.16 MHz ROM downloads, whose
segments are all at `0x8000` or above, and an open question everywhere else.

**What is still not settled** is the window's exact edges. The evidence bounds
them only between `0x80f7` and `0xff50`; `0xfeff` is chosen because the
firmware's own ASIC pages are `0x1fe`/`0x1ff`, not because a read distinguishes
`0xfeff` from `0xfe00` or `0xff00`. Nothing in either build reads or writes
data between `0x8100` and `0xff50`, so no run this harness can perform will
narrow it further; that needs the board.

## The 0x8000 in these addresses is not independently established

`0x8000` is also where the *CPU's* flash lives - physical `0x80000`, segment
`0x8000` - and the two uses have not been kept apart.

* `CourierRom.dsp_download` **filters** on `DSP_ENTRY_WORD = 0x8000` and
  discards any candidate whose entry word is anything else, so the ROM path's
  origin is an assumption the scan enforces, not a measurement.
* `main211.xmf`'s segments are worse. Its first segment is loaded at origin
  `0x0000`, but the code in it is linked for `0x8000`: the stream sender sits
  at word offset `0x05d5` and the instructions around it read

```
05cb  bd    85d5, *
05cf  calld 85da, *
05d1  splk  *, #85c9
05d5  out   *, 0060
```

  Branch targets `0x85d5`, `0x85da` and `0x85c9` against offsets `0x05xx`. The
  third segment, the one actually labelled origin `0x8000`, holds different
  content and contains no sender at all - the first 4096 words of the two
  agree in 11 places.

So the harness's segment origins do not match the link addresses in the code,
in both directions. Either an origin is wrong, or the DSP's program space
ignores A15 and every label here is only meaningful modulo `0x8000`.

### The firmware never chooses the mode, and reset lands on the image

Two measurements narrow this.

**MP/MC is never written.** Disassembling all four overlays of both images and
keeping only writes to `@07` reached with `DP=0` - the memory-mapped `PMST` -
finds **exactly two in each image, both in the resident, none in any overlay**:

```
8012  apl  @07, #07f8     ; keep bits 3-10, clear the rest
8014  opl  @07, #00b0     ; set RAM (4), OVLY (5), IPTR bit 0 (7)
```

`apl`'s mask preserves bit 3, and `opl`'s does not touch it. Bit 3 is MP/MC.
So the firmware sets `RAM` and `OVLY` and then **defers entirely to whatever
the pin latched at reset** - it never selects microprocessor or microcomputer
mode, in either build. (The pin's name carries a bar over `MC` because it is
one pin read in two polarities: high is microprocessor mode, low is
microcomputer mode. There is no second pin.)

Every run in this repository therefore has `MP/MC` set by the harness, not by
the firmware, and no path reaches microcomputer mode with `PMST.RAM` set: the
probe kernels that force the pin low write `PMST` as `0x0000`, so `RAM` is
clear there.

**Nothing is ever downloaded below `0x8000`.** All four overlay origins in both
images are `0x8000`, `0x9d00`, `0xb000` and `0xdc00`. But a C5x comes out of
reset fetching from program `0x0000`, and `bridge.py` covers that gap by hand -
it calls `set_pc(entry_word)` to place the part at `0x8000`. So how the real
part gets there is unmodelled.

The image says how. Program `0x8000` is not a branch and not a vector table:

```
8000  ldp   #000
8001  splk  @57, #ffff
8003  setc  intm
8004  ldp   #000
8005  splk  @2a, #0010
```

That is straight-line initialisation - exactly what reset should land *on*, not
what a reset vector points *with*. And it does land on it if external program
space ignores A15, which is what wiring a 32K-word RAM across a 64K space gives
you unless something else decodes the top bit. Aliasing external program fetches
to `address | 0x8000` and starting the part at `0x0000` instead of `0x8000`
reproduces the boot exactly: the same single prologue pass, the same `rptz`
repeat counts at the aliased `0x001d`/`0x0024`/`0x0028`, and the same `idle` at
`0x814d` once a branch to an absolute `0x8xxx` label carries it up.

That reading - **`0x8000` and `0x0000` being the same cell** - is the second of
the two possibilities this section raised, and it would dissolve the
`main211.xmf` problem: a segment placed at origin `0x0000` whose code is linked
for `0x8000` is no contradiction on a board that decodes fifteen address lines.

### The vector base is what argues against it, not the RAM

An earlier revision of this section claimed the alias was disproved because
program `0x23f0` would then be the same cell as `0xa3f0`, which is live code in
both builds. **That argument is wrong.** `program_region` tests SARAM before
external, and `PMST.RAM` is set, so `0x23f0` is on-chip whichever way A15
decodes: an aliased external RAM is never consulted there. The alias survives
that test untouched.

The sizing objection does not land either. Two 32Kx8 SRAMs are 32K **words**,
and the C5x addresses 64K words, so the RAM covers *half* the space however it
is decoded. The bottom half is empty unless something aliases into it, and a 2K
on-chip ROM at `0x0000`-`0x07FF` therefore shadows nothing and wastes nothing.

What does argue against the alias is the vector base, and it comes out of the
same `opl` this document has been reading:

* The core's PMST layout is confirmed **behaviourally**, not from the guide
  alone: `RAM` must be bit 4 and `OVLY` bit 5, because `opl #00b0` has to map
  SARAM for the `bldp` into `0x23f0` to produce a helper, and the 302 boot only
  completes when it does. A layout placing those bits elsewhere leaves SARAM
  unmapped and reproduces the broken run.
* That same layout makes bit 7 `IPTR`'s LSB. `opl #00b0` sets it, so
  `IPTR = 1` and the vector base is `0x0080`. The frame interrupt, IRQ 5, would
  vector to `0x0080 + (5 + 1) * 2` = `0x008c`.
* Under the alias `0x008c` is image `0x808c`, which is

```
808b  b9f8       lacl  #f8
808c  8832       samm  @32      ; TSPC - live prologue code
```

  and the prologue enables interrupts at `0x809f`, thirty-odd words later. The
  part would be enabling interrupts whose vectors sit on top of the
  instructions it is executing.

So `0x0080`-`0x00bf` has to be memory that is *not* the aliased RAM. On-chip
ROM is what the C5x puts there, in microcomputer mode, and a ROM vector table
dispatching into fixed addresses in the downloaded bank would explain the frame
ISR entry at `0x816b` that this document could only infer from its position.

One rescue for the alias is available in principle and is ruled out by
measurement. The prologue at `0x8080`-`0x80bf` runs once, so the firmware could
install a vector table over it afterwards. It does not: logging every
`PM_WRITE16` across a 20M-instruction bridge run of 302 gives **three writes in
total**, all the `bldp` at `0x80a7` into `0x23f0`-`0x23f2`. Nothing writes a
vector anywhere, in any space, ever.

### The on-chip boot loader supplies the mechanism the ROM reading was missing

The C5x on-chip ROM carries an optional boot loader that "can be used to
transfer a program automatically from data memory or the serial port to
anywhere in program memory", with the source on any 1K-word boundary in data
memory, and which "releases control to the program for execution" once the
transfer is done.

That is the piece the microcomputer-mode reading lacked, and it fits what this
repository already measured, without needing anything new:

* **It explains the entry.** Program `0x8000` is `ldp #000` and straight-line
  initialisation, with no branch and no vector table. A boot loader that
  transfers a block and then jumps to it lands on exactly that.
* **It explains the origin.** `CourierRom.dsp_download` filters candidates on
  `entry_word == 0x8000` and discards the rest, which this document flagged as
  an assumption the scan enforces rather than a measurement. Under the boot
  loader it is neither: it is the destination address in the boot table the
  supervisor hands over, which is why every overlay in both images carries one.
* **It explains why nothing is downloaded below `0x8000`.** The transfer is a
  block copy to one destination, not a link map.
* **It puts the vector base somewhere legal.** `IPTR = 1` gives `0x0080`, inside
  the 2K on-chip ROM at `0x0000`-`0x07FF`, which is memory the firmware neither
  owns nor writes - consistent with the measurement above finding no vector
  writes at all.

### A15 is not wired, and that decides the decode without deciding the mode

Read off the board: **the DSP's A15 goes nowhere.** It cannot be an address
input to a 32Kx8 part in any case - those have fifteen address pins - and it is
not in the chip-select decode either. So nothing distinguishes external
`0x0000`-`0x7fff` from `0x8000`-`0xffff`: the 32K-word RAM answers both as the
same cells, in whichever spaces its `/CE` admits. The alias is a fact about the
board, not a hypothesis.

What that does **not** settle is `MP/MC`, and the reason is that the alias turns
out to be invisible almost everywhere the firmware goes. Across a 20M
instruction bridge run of 302 plus the V.34, FSK and VPCM probe runs, there are
**no data accesses at all in `0x2c00`-`0x7fff`** - the range where a data-side
alias would show - so the whole low half of data space is unreferenced, and the
shared window this core models at `0x8000`-`0xfeff` covers every access there
actually is.

### Where the alias is not invisible: the vectors, and the part runs away there

The same instrumentation counts external *program* fetches below `0x8000`, and
finds 2,524 of them, contiguous, **starting at `0x0088`**.

`0x0088` is not arbitrary. With `IPTR = 1` the vector base is `0x0080`, and the
C5x lays its vectors out two words apart from there:

| IFR bit | interrupt | vector |
|---|---|---|
| 3 | `TINT`, the timer | **`0x0088`** |
| 5 | `XINT` | `0x008c` |

So the **timer interrupt is being taken and hardware-vectored to `0x0088`**,
where it finds nothing, and the part then runs contiguously up through empty
program memory until it reaches `0x8000` and re-enters its own reset prologue.
That is the mechanism behind a discrepancy this document had not explained: the
`bldp` at `0x80a7` executes **40 times** in a bridge run while the standalone
run executes it once. The DSP is restarting forty times, and the timer vector is
why.

Note also that `XINT` at `0x008c` is the same slot `_configure_frame_interrupt`
arms by hand at `origin + 0x0c` = `0x800c`. The harness installs an explicit
vector for the one interrupt it cares about and leaves the rest to hardware
vectoring, which is why only the timer runs away.

This corrects a claim made earlier in this section. Hardware-vectored
interrupts **are** observed on this firmware; `0x0080` is not merely read off
`PMST`. And it sharpens what the vector table needs to be, now that A15 is
known: under the alias `0x0088` is image `0x8088`, which is

```
8088  7718  dmov @18
```

live prologue code, not a vector. So `0x0080`-`0x00bf` cannot be the aliased
RAM either way, and the only thing the C5x can put there is **on-chip ROM, in
microcomputer mode** - which is also where the boot loader lives, and which is
consistent with `MP/MC` being unwired.

That makes one coherent account of the whole board:

* `MP/MC` unwired, so microcomputer mode; on-chip ROM at `0x0000`-`0x07ff`
  holds the boot loader **and** the vector table the firmware points at with
  `IPTR = 1`.
* The boot loader transfers the supervisor's block from data memory to program
  `0x8000` and releases control to it, which is why `0x8000` is straight-line
  init with no branch and why nothing is ever downloaded below it.
* `PMST.RAM` maps SARAM at `0x0800`-`0x2bff`, holding the mailbox helper the
  prologue's `bldp` writes to `0x23f0`.
* The external RAM is 32K words with A15 unwired, so it answers `0x2c00`-`0x7fff`
  and `0x8000`-`0xffff` as one memory, in both spaces - and since the firmware
  references only `0x8000` and up, the aliasing never shows.

**What still keeps this open.** The boot loader is optional and its ROM is mask
programmed, so its presence on a USR-marked part is not established here, and
this repository has no image of it. The vector-base caution this paragraph
used to carry - that no hardware-vectored interrupt had ever been observed -
is withdrawn above: the timer is vectored to `0x0088` on every bridge run.

The two readings still disagree about one thing only - what answers program
`0x0000`-`0x07ff` - and the board settles it. Note that A15 cannot be an
*address* input to a 32Kx8 part at all: those have fifteen address pins, so
A0-A14 go to both RAMs in parallel with the data split D0-D7 / D8-D15, and A15
can only appear in the chip-select decode. So the question is not "does A15
reach the RAMs" but **what drives their `/CE`**: tied low, they answer every
external cycle in both spaces, which is the shared window and the alias
together; gated on A15 they answer one half; gated on `/PS` and `/DS` they
answer whichever spaces the glue admits. The `74VHC32` and `74VHC04` in
[board-parts.md](board-parts.md) are the parts that would do that gating.

Only the shared *data* window is in the core; the alias was reverted.

The one strand that does not depend on the harness is `dsp_mailbox.py`'s
constants - the sender at `84b7`/`849e`, the table at `8401`, tag `0x42`'s
handler at `b05e` - which were taken through the `ATGLK2` monitor on a physical
modem. Those agree with the addresses used throughout this document. Whether
they were read back by address from the part, or derived under the same origin
assumption, is not recorded, and settling that would settle the rest.

## What this does not establish

The map is static: every address was read from the image, and only the sender
at `0x84b7`, the tag-`0x06` handler and tag `0x42` are corroborated by
constants taken from hardware. Nothing here was executed. The frame ISR entry
at `0x816b` is inferred from its position after a `ret` and its `smmr` context
save, not from an interrupt observed reaching it. The helper at `0x23f0` could
not be disassembled - it is outside the segment, so the linear file mapping
does not reach it - and what it does is assumed from its callers.
