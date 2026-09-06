# The RAM-probe method: delivery is solved, execution is not

The recurring proposal in [dsp-rom-probe.md](dsp-rom-probe.md) is to stop
probing one serial round trip at a time and instead put a small 80186 routine
in the modem's own RAM, let it sample at bus speed into a buffer, and read the
buffer back. `courier_emu.probe_transport` already builds such a program -
`ENTRY 0x2000`, `ROUTINES 0x2400`, `KERNEL 0x3000`, `RESULT 0x4000` - and its
recorded blocker was "physical delivery/control of the probe".

Delivery is no longer the blocker. **The firmware this board now runs has an
arbitrary memory-write command**, and that is a property of ID_SDL rather than
of the Courier.

## The write primitive

`ATGLK2W<address>,<value>` - equivalently `ATGW<address>,<value>`. Recovered
from the board's own image at `0x49890`:

```
49890  inc si ; dec cx
49892  call 0x4979c        ; parse hex -> AX, the address
49896  mov bx, ax
49898  lodsb ; dec cx
4989a  cmp al, 0x2c        ; a comma must follow
4989c  jne 0x498b6         ; ...or the command fails
498a0  call 0x4979c        ; parse hex -> AX, the value
498a4  sub dx, cx          ; how many digits that consumed
498a6  cmp dx, 2
498aa  ja  0x498b0
498ac  mov byte ptr [bx], al   ; 1-2 digits: byte write
498b0  mov word ptr [bx], ax   ; 3+ digits: word write
```

Two details matter. The width is chosen by **how many hex digits were typed**,
not by the value: `,0F` writes a byte and `,000F` writes a word. And the store
is `[bx]` - **`DS`-relative, with no segment operand**, unlike the `=` reader
which takes `segment:offset` and loads `ES`. The neighbouring selectors in the
same handler write low addresses the same way (`mov byte ptr [0x4e1], 1` at
`0x498d3`), so `DS` is the supervisor's data segment and `W` reaches low RAM at
its physical address.

### It is not in the stock firmware

| image | selectors |
|---|---|
| board, ID_SDL 4.03d (**what it runs now**) | `=` `R` `W` |
| `IDSDL302.ROM` | `=` `R` `W` |
| board, stock 7.3.14 | `=` `I` `O` |

The stock supervisor's handler is at a different address and has no `W` at all.
So this capability arrived with the Russian firmware, and any procedure built
on it works on this unit only while it runs ID_SDL.

## Execution is the remaining half

There is no "go" or "call" selector. The other letters in the same handler are
configuration, not control:

| selector | what it does |
|---|---|
| `H` `T` `F` `A` | set option bytes at `[0x4e1]`, `[0x49b]`, `[0x4a9]`, `[0x4b0]`, `[0x4c4]`, `[0x4c6]` - the protocol-selection group |
| `=` `R` | dump 256 bytes, as bytes or as words |
| `W` | the write above |
| `I` `O` `B` | I/O port in, out, and sweep |

So a routine can be *placed* but not *started*. Starting it means overwriting
something the firmware already calls - the mailbox chain vector at `[0x02d3]`,
the DTE receive callback at `[0x026a]`, or an interrupt vector - and that is
the step that carries the risk, because a wrong pointer runs whatever happens
to be at it.

One constraint on that: the chain vector is a 16-bit near pointer, so the
routine has to be reachable in the segment the caller uses. Placing code at
physical `0x2000` and pointing a near vector at it only works if that vector's
segment is zero. This has not been checked, and it decides the whole layout.

## The write primitive, confirmed on the board

Run 2026-09-05 against the live unit. Target `0x5d80`-`0x5d83`, four bytes
verified zero immediately before writing; the script's allowlist admitted page
reads and writes to those four addresses and nothing else.

```
before             5d80: 00 00 00 00 00 00

ATGLK2W5D80,A5    -> OK
after              5d80: A5 00 00 00 00 00

ATGLK2W5D82,1234  -> OK
after              5d80: A5 00 34 12 00 00

restore           -> 00 00 00 00 00 00
AT -> OK, ATI7 -> 7.4.16
```

Three things confirmed, all as disassembled:

* **`DS` is zero.** `A5` landed at physical `0x5d80`, so the address in the
  command is a physical low-RAM address and the `mov [bx]` needs no segment
  reasoning.
* **Width follows the digit count.** `,A5` wrote one byte; `,1234` wrote a
  word, little-endian, `34 12`. The value does not decide it - `,000F` would be
  a word.
* **It is reversible.** Writing zeros back restored the region exactly, and the
  modem answered normally afterwards.

So the delivery half of the RAM-probe method is no longer theoretical. A
routine can be placed one byte or one word per command.

## Execution: the interrupt vector table

The near-vector constraint turned out not to bind, because there is a better
hook. **The 80186's interrupt vector table is at physical `0`, which is RAM on
this board, and its entries are far pointers.** Read live:

| vector | contents |
|---|---|
| `08` timer 0 | `8000:108f` |
| `0f` INT3 / tick | `8000:0a77` |
| `0d` INT1 | `9e74:01eb` |
| `12` timer 1 | `9e74:0334` |

Segment `0x8000` is physical `0x80000`, the flash base, so these are real and
in use. A far pointer carries its own segment, so a routine at physical
`0x3000` is reachable as `0000:3000` - the layout question the near vectors
raised does not arise.

The hook is then: save the original vector, point it at the routine, and have
the routine finish with a far jump to the saved one. Timer 0 fires every 5 ms,
so it gives 200 executions a second without needing anything else to happen.

The FAR-call sites found by scanning for `ff 1e` were **false positives** - the
most-referenced, `jmp FAR [0x06c7]` at `0x7c34c`, is inside
`mov word ptr cs:[0x100], 0x113d`. The near cells are real (`call word ptr
[0x220]` at `0x03b07`, `call word ptr [0x2ab]` at `0x0f892`), but near is the
wrong shape. The IVT is the answer.

One consequence worth stating: **the IVT is volatile.** Everything this method
writes - vector and routine both - is RAM, so a power cycle restores the modem
completely. That changes what the risk actually is; see below.

## Where a routine could live, and why the static answer is wrong

The obvious approach is to find RAM the firmware never touches: scan the ROM
for absolute-displacement operands and pick a region nothing references. **That
does not work, and the check that showed it is worth keeping.**

Reference counts per page are dominated by chance matches - a 512 KiB image
contains those byte sequences at random - and the real data area (`0x000`-
`0x0d00`, hundreds to thousands of hits per page) is the only part that stands
clear of the noise. Worse than imprecise, the signal is misleading. Reading
candidate pages on the live board through idle, `AT&T8` and after:

| page | static refs | idle | during `&T8` | after |
|---|---:|---|---|---|
| `02e00` `03400` `03b00` `04000` | 52-200 | zero | zero | zero |
| `05d00` `08000` `0d100` `0da00` `0ec00` | 0-174 | zero | zero | zero |
| **`09400`** | **0** | zero | **256 bytes non-zero** | zero |

The one page with **zero** static references is the one that filled completely
under load and emptied again afterwards. The firmware reaches it through a
pointer rather than an absolute displacement, which the scan cannot see. So
neither "reads zero when idle" nor "nothing in the ROM references it" is
evidence that a page is free.

The pages that stayed zero throughout are only known not to be used *by
`&T8`*, which exercises very little: no call, no fax, no error control. A
region qualified this way is qualified against a weak test.

## Risk, restated

The earlier framing here was too cautious in one direction and not cautious
enough in another.

Everything this method writes is **volatile**: the routine goes in RAM and the
hook goes in the IVT, which is also RAM. A power cycle rebuilds both. So
choosing scratch space wrongly - landing on a buffer the firmware fills during
a call - costs a crashed session and a power cycle, not the modem. The scratch
region does not have to be *proven* free, which is fortunate, because the work
above says it cannot be.

What is genuinely irreversible is narrower and sharper: port `0x10` carries the
**NVRAM strobe**, and `0x12`/`0x14` the other board latches. A routine that
writes those, or that executes a flash command sequence, can change stored
settings or flash contents, and a power cycle does not undo that. So the rule
is about what the routine does, not where it lives:

* never write ports `0x10`, `0x12`, `0x14`;
* never write flash addresses or issue a flash unlock sequence;
* keep the routine short enough to read and check by hand before it is sent.

## Original scratch survey

Read-only survey of the live board, one `ATGLK2=` page at a time, looking for
pages that are entirely zero:

| region | size |
|---|---|
| `01600..01fff` | 2 KiB |
| `02100..02bff` | 2 KiB |
| `02e00..07eff` | **20 KiB** |
| `08000..0afff` | 12 KiB |
| `0d000..0fdff` | 11 KiB |

`probe_transport`'s existing layout falls inside these: `0x3000` and `0x4000`
are both in the 20 KiB block.

**Zero is not the same as unused.** These pages were read with the modem idle
and on hook. A buffer that is zero at idle and filled during a call would look
identical here, and would be corrupted by a routine placed on top of it. Before
anything is written, the candidate region should be cross-referenced against
the supervisor's own data accesses in the ROM, or at least re-read while the
modem is doing something.

## Placing the ROM-dump image, concretely

`tools/emit_ram_writes.py` turns a built image into the commands, rather than
having them typed:

```sh
python -m courier_emu.probe_transport \
  --reference IDSDL302.ROM --output artifacts/dsp-rom-dump-v1 --rom-dump
python tools/emit_ram_writes.py \
  artifacts/dsp-rom-dump-v1/diagnostic-ram.bin \
  --base 0x3000 --output artifacts/dsp-rom-dump-v1/commands
```

It writes three files, kept separate because they carry different risk:

| file | what it does |
|---|---|
| `place.txt` | 2104 `ATGLK2W` word writes, the image itself. RAM only. |
| `verify.txt` | 17 `ATGLK2=` page dumps covering what was written |
| `arm.txt` | the IVT hook that **starts** it - read by hand before sending |

The generator reads its own output back and compares it against the image
before writing anything, because a transcription or endianness slip here would
be silent and would then run as code.

**The layout was wrong for the board and has been moved.** `probe_transport`'s
default puts the monitor at `0x2000`, and the image is contiguous from there,
so it spanned `0x2000`-`0x306f` - crossing `0x2000`-`0x20ff` and
`0x2c00`-`0x2dff`, neither of which is in the survey above. The `--rom-dump`
build now loads at `0x3000` with its routines at `0x3400`, its kernel at
`0x4000` and its result buffer at `0x8000`, so the image occupies
`0x3000`-`0x406f`, entirely inside the 20 KiB block, and the buffer sits in the
12 KiB block. One constraint that came out of moving it: the download routine
addresses the kernel through a **segment** immediate patched into the relocated
copy, so the kernel has to be paragraph-aligned and that constant has to move
with it. It does now; it did not before, and the build failed loudly rather
than silently transferring the wrong bytes.

Order of operations:

1. `ATGLK2=0000` and keep the timer-0 vector at `0x20`-`0x23`; the hook
   overwrites it and only a power cycle restores it.
2. Send `place.txt`. This is inert - it writes RAM and nothing runs.
3. Send `verify.txt` and diff the pages against `diagnostic-ram.bin`. Do not
   skip this: the next step executes whatever is there.
4. Open the serial capture, then send `arm.txt`. Timer 0 fires every 5 ms, so
   the monitor starts within milliseconds and the modem stops responding to AT
   commands - it has been taken over, which is expected.
5. Capture until `CDRP1 DONE`. At 2052 lines this is roughly 20 KiB of text.
6. Power cycle to get the modem back. Everything written was RAM.
7. `python -m courier_emu.probe_transport --capture <file>` validates the frame
   and writes `<file>.rom.bin`, 4096 bytes.

The standing rules still apply, and none of these commands break them: nothing
writes ports `0x10`, `0x12` or `0x14`, and nothing issues a flash sequence.

## What it would buy

The thing the serial monitor cannot do is sample fast. Every port read is a
command round trip, and the board's reply latency is about 165 ms, so a sweep
of the watched set takes three seconds. That is why the reset sweep saw
nothing: the whole event fits inside one read.

A routine running on the 80186 samples at bus speed. That is what would make
the DSP download window at `0x40`-`0x56` observable, and it is the only
approach here that would.

## Risk, stated plainly

Everything above is static analysis and read-only capture. Nothing has been
written to the board.

The write step is not reversible in the way the read experiments are. A stray
value can crash the firmware, which a power cycle fixes; but port `0x10` also
carries the NVRAM strobe, so a routine that misbehaves near the latches could
disturb stored settings, which a power cycle does not fix. The routine must
never touch `0x10`, `0x12` or `0x14`, and must not execute a flash command
sequence.

## The peripheral control block, read off the board

Read-only, `ATGLK2=FF00`, decoded against the `80C186EB` manual in `docs/`.
The PCB is at physical `0xff00`-`0xffff`, and the EB's map is **not** the plain
80186's - several addresses the notes had guessed at are different registers.

| address | register | value | what it says |
|---|---|---|---|
| `ff08` | `IMASK` | `0068` | |
| `ff12` | `TCUCON` | `0002` | timer unit **unmasked**, priority 2 |
| `ff14` | `SCUCON` | `0000` | serial unit unmasked, priority 0 |
| `ff18` | `I0CON` | `0002` | **INT0 unmasked**, priority 2 |
| `ff1a` | `I1CON` | `0008` | masked |
| `ff1c` | `I2CON` | `0019` | masked |
| `ff1e` | `I3CON` | `0003` | **INT3 unmasked**, priority 3 |
| `ff30` | `T0CNT` | counting | `23d7` -> `23a2` between two reads |
| `ff32` | `T0CMPA` | `6270` | **25200** - the 5 ms tick |
| `ff36` | `T0CON` | `8021` | `EN=1 INH=0 INT=0 MC=1 ALT=1` |
| `ff3e` | `T1CON` | `2001` | `INT=1` but `EN=0` - timer 1 is off |
| `ff46` | `T2CON` | `2001` | same; the download routine turns it on |
| `ff56` | `P1LTCH` | `ffdb` | Port 1 output latch |

Three of these correct readings made elsewhere in this repository.

**`0xff56` is `P1LTCH`, not a timer register.** The pulse the supervisor's
launch routine performs before the DSP download - bit 3 low, delay, bit 3 high -
is therefore a **PIO pin**, and `P1.3` is the DSP's reset line. It currently
reads high, which is reset released. That turns the argument in
[dsp-map-302.md](dsp-map-302.md) from "reset-shaped" into a named pin.

**`0xff46` is `T2CON`, and `0xff40`/`0xff42` are `T2CNT`/`T2CMPA`.** So the
download routine's `mov [0xff46], 0xc000` starts timer 2 and its
`test [0xff46], 0x20` polls that timer's max-count bit. Those are a **timeout**,
not an ASIC status handshake.

**Timer 0 runs but never interrupts.** `T0CON = 0x8021` has `EN` set and the
counter is moving, with `T0CMPA` at exactly the 25200 the timebase note derived
- but bit 13, `INT`, is **clear**. The tick is polled, not vectored. That is why
pointing interrupt vector 8 at a routine did nothing while the modem stayed
completely alive, and it is a better answer than any amount of vector probing:
the vector was right and the source was silent.

The fix is one bit: `T0CON = 0xa021` enables the interrupt, and `TCUCON` already
has the timer unit unmasked, so type 8 then fires every 5 ms.

**The serial unit does not use `INT0`.** The manual gives channel 0 receive as
interrupt **type 20** and transmit as **type 21**, so vector `0x0c` is `INT0`,
an external pin - on this board almost certainly the ASIC. An earlier note here
guessed `0x0c` was the UART because interposing on it jammed the RD light;
that guess was wrong about which peripheral, though the caution stands.

**The monitor's serial output path is correct.** `probe_transport` emits
`f70666ff0800`, which assembles to `test word ptr [0xff66], 8` - `S0STS` bit 3 -
and writes the byte to `0xff6a`, `S0TBUF`. That is exactly what the firmware's
own transmit loop does at file `0x27f04`:

```
27f04  mov  word ptr ss:[0xff6a], ax
27f08  test word ptr [0xff66], 8
27f0e  je   0x27f08
```

## What is still to do, and what is now known to work

* **Placement works.** 2104 `ATGLK2W` commands placed the 4208-byte image at
  `0x3000`-`0x406f` with zero failures, and a read-back compared byte for byte
  against `diagnostic-ram.bin` with **zero mismatches**.
* **The trigger did not.** Vector 8 was installed correctly and never fired,
  for the reason above.
* **Do not probe vectors by interposition.** Chaining a counting stub onto each
  vector in turn reached `0x0c`, which fires, and jammed the modem - RD stuck
  on, no AT response, recovered only by a power cycle. Reading the interrupt
  control registers answers the same question with no writes at all, and should
  have been done first.

The next attempt is: place the image, point vector 8 at it, then write
`T0CON = 0xa021`. Everything remains RAM, so a power cycle still undoes all of
it.
