# The RAM-probe method: a co-resident sampler that survives load

The recurring proposal in [dsp-rom-probe.md](dsp-rom-probe.md) is to stop
probing one serial round trip at a time and instead put a small 80186 routine in
the modem's own RAM, let it sample at bus speed, and read the buffer back.

Both halves now work. `courier_emu.cooperative_probe` places a handler, hooks
timer 0, samples on every tick while the firmware keeps running underneath, and
survives a load that reset four earlier builds.

**The working recipe is two conditions at once**, and every earlier build
violated one of them:

1. **Hook a vector the firmware does not repoint mid-run** - timer 0, not INT3.
2. **Place the handler and its ring in RAM the firmware does not clear** -
   `0x1600`-`0x2b00` or `0xd000`, not `0x3000`-`0x7eff`.

Measured with the sampler at `0x1a00`, armed across `AT&T8`
(`artifacts/coop-timer0-safe-01/`): no reset, the sentinel at `0xd000` survived,
`AT` answered before, during and after, and the ring filled - 960 samples at
timer 0's 200 Hz, 3.2 s of an 8 s run. Every watched port moved under load,
where an idle run reads one constant value per port:

| port | distinct | transitions | values |
|---|---|---|---|
| `0x18` | 8 | 54 | `C0 C4 C8 CC CE D8 DC FF` |
| `0x1a` | 3 | 15 | `C0 DF FF` |
| `0x1c` | 3 | 5 | `F9 FD FF` |
| `0x1e` | 3 | 2 | `FB FC FF` |

## Why this is worth the trouble

Every serial port read is a command round trip and the board's reply latency is
about 165 ms, so a sweep of the watched set takes three seconds - which is why
the reset sweep in [asic-port-map.md](asic-port-map.md) saw nothing: the whole
event fits inside one read. A routine on the 80186 samples at bus speed. That is
what would make the DSP download window at `0x40`-`0x56` observable, and it is
the only approach here that would.

It also buys **sampling while the firmware runs**, which a takeover design
cannot do at all: every reading taken by takeover is of a machine whose DSP has
just been reset and whose supervisor is not executing.

## The write primitive

`ATGLK2W<address>,<value>` - equivalently `ATGW<address>,<value>`. Recovered
from the board's own image at `0x49890`:

```text
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

Confirmed on the live unit against `0x5d80`-`0x5d83`, four bytes verified zero
first, with an allowlist admitting page reads and those four addresses only:

* **`DS` is zero.** `A5` landed at physical `0x5d80`, so the address in the
  command is a physical low-RAM address and the `mov [bx]` needs no segment
  reasoning. (The `=` reader takes `segment:offset` and loads `ES`; `W` does
  not.)
* **Width follows the digit count, not the value.** `,A5` wrote one byte;
  `,1234` wrote a word, little-endian. `,000F` would be a word.
* **It is reversible.** Writing zeros back restored the region exactly.

**It is not in the stock firmware.** This capability arrived with the Russian
firmware, and any procedure built on it works on this unit only while it runs
ID_SDL:

| image | selectors |
|---|---|
| board, ID_SDL 4.03d (**what it runs now**) | `=` `R` `W` |
| `IDSDL302.ROM` | `=` `R` `W` |
| board, stock 7.3.14 | `=` `I` `O` |

## Execution: the interrupt vector table

There is no "go" or "call" selector - the other letters in the same handler are
configuration (`H` `T` `F` `A` set the protocol-selection option bytes at
`[0x4e1]`, `[0x49b]`, `[0x4a9]`, `[0x4b0]`, `[0x4c4]`, `[0x4c6]`). Starting a
routine means overwriting something the firmware already calls.

**The 80186's IVT is at physical `0`, which is RAM on this board, and its
entries are far pointers.** Read live:

| vector | contents |
|---|---|
| `08` timer 0 | `8000:108f` |
| `0f` INT3 / tick | `8000:0a77` |
| `0d` INT1 | `9e74:01eb` |
| `12` timer 1 | `9e74:0334` |

A far pointer carries its own segment, so a routine at physical `0x3000` is
reachable as `0000:3000` and the near-vector layout question does not arise.
Save the original vector, point it at the routine, and have the routine finish
by chaining to the saved one.

**Timer 0 is the right hook** because its handler at `8000:108f` is vestigial:

```text
108f  c70602ff0080  mov word ptr [0xff02], 0x8000   ; non-specific EOI
1095  cf            iret
```

It does nothing else, so displacing it costs the firmware nothing, and it fires
every 5 ms - 200 executions a second without needing anything else to happen.

**The IVT is volatile.** Everything this method writes - vector and routine both
- is RAM, so a power cycle restores the modem completely.

## Where a routine can live

Two measurements, both taken with **nothing armed** so no reset could confound
them, using markers written across low RAM and read back.

**`AT&T8` zeroes `0x3000`-`0x8000`:**

| region | after `&T8` |
|---|---|
| `0x1600`-`0x2b00`, `0xd000` | **survived** |
| `0x2c00`, `0x9000`, `0xa000` | overwritten with `0x55` |
| `0x3000`, `0x3a00`, `0x4000`, `0x5000`, `0x6000`, `0x7000`, `0x7d00`, `0x8000` | **zeroed** |

So the surveyed-free 20 KiB block at `0x2e00`-`0x7eff`, where every takeover
probe in this repository is placed, is mostly **erased** by `&T8`. A takeover
probe does not care - it runs and dies inside the ~1.5 s bound. Anything
co-resident is destroyed mid-run, with its handler erased under a vector still
pointing at it.

**A call does not.** Across `ATDT9099` - off hook, dialled, nothing answered,
`NO CARRIER` at the 60 s `S7` timeout - **not one marker was cleared**. Only
`0x2c00`, `0xb000` and `0xc000` changed at all, and none is in the sampler's
region. (A repeat under `ATX4` produced no `NO DIALTONE` inside 25 s, which is
what a *present* line looks like.)

That reframes the erasure usefully: the old `0x3000` placement was not
necessarily unsafe for a *call*, it was unsafe for the *test being used to
validate it*. The current placement at `0x1a00` with the ring ending at `0x2b00`
survives both, and `0x2c00` is written in both cases, which is why the ring
stops short of it.

**Still untested: a connected call.** Nothing answered, so no handshake ran. The
sweep is worth repeating against a number that answers before a capture is
trusted.

## Placing the image

At about 165 ms a command, a 4 KiB image costs nearly six minutes, and roughly
three quarters of it is zeros - 1538 of 2144 words in a typical probe. Two flags
skip work:

* `--assume-zero` omits words already `0000`. 2144 writes become 606, and a
  placement drops from ~350 s to ~96 s, measured.
* `--against <image>` omits words matching an image already placed at the same
  base.

**Neither is safe alone, and `verify.txt` is what makes them safe** - a wrong
claim shows up as a mismatch before anything executes. For every run after the
first, `--assume-zero` is **right** and `--against a previously placed image` is
**wrong**, because the board reboots at the end of a takeover run and the RAM is
genuinely zero. That is measured, not assumed: `--against` was tried and
produced 1067 mismatches.

Order of operations for a takeover build:

1. `ATGLK2=0000` and keep the timer-0 vector at `0x20`-`0x23`; the hook
   overwrites it and only a power cycle restores it.
2. Send `place.txt`. This is inert - it writes RAM and nothing runs.
3. Send `verify.txt` and diff the pages against `diagnostic-ram.bin`. **Do not
   skip this**: the next step executes whatever is there.
4. Open the serial capture, then send `arm.txt`. Timer 0 fires every 5 ms, so
   the monitor starts within milliseconds and the modem stops answering AT
   commands - it has been taken over, which is expected.
5. Capture until `CDRP1 DONE`. At 2052 lines this is roughly 20 KiB of text.
6. Power cycle to get the modem back. Everything written was RAM.
7. `python -m courier_emu.probe_transport --capture <file>` validates the frame
   and writes `<file>.rom.bin`, 4096 bytes.

The `--rom-dump` build loads at `0x3000` with routines at `0x3400`, kernel at
`0x4000` and result buffer at `0x8000`. One constraint from moving it: the
download routine addresses the kernel through a **segment immediate patched into
the relocated copy**, so the kernel must be paragraph-aligned and that constant
must move with it. It does now; it did not before, and the build failed loudly
rather than silently transferring the wrong bytes.

## Every takeover run ends in a reboot, and the trigger is unattributed

Once a takeover probe completes, the whole placed region reads back as zero -
4240 bytes of `0x3000`-`0x408f`, every byte. The first reading was "the monitor
zeroes its own image", and it was wrong. **The board reboots.**

The test: write `A5A5` to `0x5d80`, outside the placed image and untouched by
the probe; run a probe; read it back. Zero afterwards. In the same run, IVT
vector 8 returned to `8000:108f` and `T0CON` to `0x8021` with nobody restoring
them.

The firmware's reboot path clears RAM and rebuilds the IVT, which is what that
after-state looks like. **What ends the run has not been identified.** This
document previously attributed it to the `ADM707`'s 1.6 second watchdog, which
matched the observed bound. The owner reports the `ADM707` is used on this board
**only as a power-good reset**, and [asic-pinout.md](asic-pinout.md) finds its
pin 7 going to the ASIC with no `WDI` source anywhere. A datasheet number
agreeing with a measurement is a good clue and was taken for a proof.

The leading candidate is a **software** failsafe in the supervisor - it would
notice timer 0's vector hijacked, needs no hardware, and fits a firmware that
rebuilds its own IVT. If that is right, the cooperative route is not a way of
living with the bound but the way of removing it, which is what the timer-0
result above suggests. The other candidate is the ASIC, which is in the reset
tree and has timers reaching it.

Consequences worth having:

* **Restoring the vector and `T0CON` by hand after a takeover run is
  unnecessary.** Harmless, and several runs here did it, but the reset already
  has.
* A repeat run never needs a power cycle - it has effectively just had one.
* **The bound is on the whole takeover, not on collection.** The two-halves ROM
  dump was split because printing 2048 words did not fit, and
  [dsp-onchip-rom.md](dsp-onchip-rom.md) notes collection had finished before the
  reset landed.

## The peripheral control block, read off the board

Read-only, `ATGLK2=FF00`, decoded against the `80C186EB` manual. The PCB is at
physical `0xff00`-`0xffff`, and **the EB's map is not the plain 80186's** -
several addresses this repository had guessed at are different registers.

| address | register | value | what it says |
|---|---|---|---|
| `ff08` | `IMASK` | `0068` | |
| `ff12` | `TCUCON` | `0002` | timer unit **unmasked**, priority 2 |
| `ff14` | `SCUCON` | `0000` | serial unit unmasked, priority 0 |
| `ff18` | `I0CON` | `0002` | **INT0 unmasked**, priority 2 |
| `ff1a` | `I1CON` | `0008` | masked |
| `ff1c` | `I2CON` | `0019` | masked |
| `ff1e` | `I3CON` | `0003` | **INT3 unmasked**, priority 3 |
| `ff30` | `T0CNT` | counting | `23d7` → `23a2` between two reads |
| `ff32` | `T0CMPA` | `6270` | **25200** - the 5 ms tick |
| `ff36` | `T0CON` | `8021` | `EN=1 INH=0 INT=0 MC=1 ALT=1` |
| `ff3e` | `T1CON` | `2001` | `INT=1` but `EN=0` - timer 1 is off |
| `ff46` | `T2CON` | `2001` | same; the download routine turns it on |
| `ff56` | `P1LTCH` | `ffdb` | Port 1 output latch |

**Timer 0 runs but never interrupts.** `T0CON = 0x8021` has `EN` set and the
counter is moving, with `T0CMPA` at exactly the 25200 the timebase note derived -
but bit 13, `INT`, is **clear**. The tick is polled, not vectored. That is why
pointing vector 8 at a routine did nothing while the modem stayed completely
alive: the vector was right and the source was silent. The fix is one bit -
`T0CON = 0xa021` enables the interrupt, `TCUCON` already has the timer unit
unmasked, and type 8 then fires every 5 ms. Arming a probe therefore needs a
separate `ATGLK2WFF36,A021` after the vector is written.

**`0xff56` is `P1LTCH`, not a timer register.** The pulse the supervisor's launch
routine performs before the DSP download - bit low, delay, bit high - is
therefore a **PIO pin**, and that pin is the DSP's reset line. It reads high,
which is reset released. That turns the argument in
[dsp-map-302.md](dsp-map-302.md) from "reset-shaped" into a named pin.

**`0xff46` is `T2CON`, and `0xff40`/`0xff42` are `T2CNT`/`T2CMPA`.** So the
download routine's `mov [0xff46], 0xc000` starts timer 2 and its
`test [0xff46], 0x20` polls that timer's max-count bit. Those are a **timeout**,
not an ASIC status handshake.

**The serial unit does not use `INT0`.** The manual gives channel 0 receive as
interrupt **type 20** and transmit as **type 21**, so vector `0x0c` is `INT0`, an
external pin - on this board the ASIC. An earlier note guessed `0x0c` was the
UART because interposing on it jammed the RD light; that guess was wrong about
which peripheral, though the caution stands.

**The monitor's serial output path is correct.** `probe_transport` emits
`f70666ff0800`, which assembles to `test word ptr [0xff66], 8` - `S0STS` bit 3 -
and writes the byte to `0xff6a`, `S0TBUF`. That is exactly what the firmware's
own transmit loop does at file `0x27f04`:

```text
27f04  mov  word ptr ss:[0xff6a], ax
27f08  test word ptr [0xff66], 8
27f0e  je   0x27f08
```

## The original scratch survey

Read-only, one `ATGLK2=` page at a time, looking for pages entirely zero with
the modem idle and on hook:

| region | size |
|---|---|
| `01600..01fff` | 2 KiB |
| `02100..02bff` | 2 KiB |
| `02e00..07eff` | **20 KiB** |
| `08000..0afff` | 12 KiB |
| `0d000..0fdff` | 11 KiB |

`probe_transport`'s layout falls inside these - `0x3000` and `0x4000` are both in
the 20 KiB block. **But zero is not the same as unused**, and the two load
measurements above are that warning coming true: the 20 KiB block is actively
*cleared* by `&T8`, and the co-resident placement belongs in `0x1600`-`0x2b00` or
`0xd000` instead.

## Standing rules

Everything this method writes is volatile, so choosing scratch space wrongly
costs a crashed session and a power cycle, not the modem. The scratch region
does not have to be *proven* free - which is fortunate, because it cannot be.

What is genuinely irreversible is narrower and sharper. Port `0x10` carries the
**NVRAM strobe** and `0x12`/`0x14` the other board latches; a routine that writes
those, or that executes a flash command sequence, can change stored settings or
flash contents, and a power cycle does not undo it. So the rule is about what the
routine does, not where it lives:

* never write ports `0x10`, `0x12`, `0x14`;
* never write flash addresses or issue a flash unlock sequence;
* keep the routine short enough to read and check by hand before it is sent.

## What the sampler cannot reach

A cooperative ISR samples **what the CPU can reach** - the ASIC's ports and CPU
RAM - at bus speed on a live board. It cannot sample DSP-side cells.

`0x0390` is the **DSP's** internal data memory and the 80186 reaches the DSP only
through the mailbox. The resident's 121-entry dispatch table was scanned in
`IDSDL302.ROM` for a handler that reads an address and mails it back; **there is
none.** Sampling DSP-side cells during a call needs a DSP-side mechanism that
does not exist yet, and the `@10` caveat in `artifacts/dsp-at10-01/` stands
unaddressed.

## Ruled out - do not re-run these

**Finding free RAM by scanning the ROM for absolute-displacement operands.**
Reference counts per page are dominated by chance matches in a 512 KiB image,
and the signal is not merely imprecise but misleading:

| page | static refs | idle | during `&T8` | after |
|---|---:|---|---|---|
| `02e00` `03400` `03b00` `04000` | 52-200 | zero | zero | zero |
| `05d00` `08000` `0d100` `0da00` `0ec00` | 0-174 | zero | zero | zero |
| **`09400`** | **0** | zero | **256 bytes non-zero** | zero |

The one page with **zero** static references is the one that filled completely
under load. The firmware reaches it through a pointer rather than an absolute
displacement, which the scan cannot see. **Neither "reads zero when idle" nor
"nothing in the ROM references it" is evidence that a page is free.**

**Hooking INT3, by any means.** The chained build - save AX/BX/DS, sample,
restore, `jmp far 8000:0a77`, leaving the interrupt frame untouched so the
firmware's handler owns both the EOI and the `iret` - is stable at idle and
measures INT3 at about **303 Hz**. It still dies under `&T8`, and the cause is
known: **`&T8` repoints INT3 mid-run.** Vector `0x0f`'s offset goes `0x0a77` →
`0x..e0` during the test and back afterwards (vector `0x0c` changes too, while
four unused slots survive, so this is not a wholesale IVT rebuild).

The arming trick makes that fatal. INT3 fires continuously, so its vector cannot
be rewritten a word at a time - any intermediate state points somewhere arbitrary
and the next tick runs it. Masking INT3 across the swap **resets the board**: the
firmware cannot lose its tick for the third of a second two commands take. The
swap is instead made atomic by changing only the **segment** word, leaving the
offset at `0x0a77` and placing the handler at `(segment << 4) + 0x0a77`. So when
`&T8` writes its new offset the vector becomes `0100:xxe0` instead of
`8000:xxe0` - a wild pointer, executed on the next tick.

The segment-only swap was chosen *because* it is atomic, and that is exactly what
makes this fatal. Had the hook rewritten both words, the firmware's re-vector
would simply have replaced it - a lost hook rather than a crash.

**Every suspect proposed for the timer-0 builds' earlier failures.** Each was
ruled out by experiment, and the actual cause was placement:

| suspect | test | result |
|---|---|---|
| the extra EOI | chained build issues none | still resets |
| interrupt latency | lean `push ax/bx/ds` instead of `pushf`/`pushaw` | still resets |
| the port reads | `--ports none` | still resets |
| the handler's work at all | a bare 5-byte `jmp far` stub | still resets |
| placement in cleared RAM | relocated to `0x1a77`, which `&T8` spares | still resets |

Those were all INT3 builds. The timer-0 builds died under `&T8` too, and vector
`0x08` is **not** one of the vectors `&T8` rewrites - but those handlers sat at
`0x3000`, inside the range `&T8` zeroes, so they were erased under a live vector.
A sufficient cause that was never separated from the others, because the
relocation and the chaining changed at the same time.

**Feeding the watchdog.** There is nothing to feed: the part's watchdog is
unused here. `P1LTCH` (`0xff56`) was never it either - the firmware's 76 accesses
to it are the NVRAM bit-bang, a bit-6 pair around the DSP download, and the DSP
reset line, with no `xor`, `not` or any other toggle of that latch anywhere in
the image.

**Probing vectors by interposition.** Chaining a counting stub onto each vector
in turn reached `0x0c`, which fires, and jammed the modem - RD stuck on, no AT
response, recovered only by a power cycle. **Reading the interrupt control
registers answers the same question with no writes at all**, and should have been
done first.

## What remains

* **A connected call.** The RAM sweep was taken against a number that did not
  answer, so no handshake ran and the datapump never trained. Repeat it against
  one that answers before trusting a capture.
* **Ring capacity.** 3.2 s at four ports in `0x1600`-`0x2b00`. A longer event
  needs fewer ports or the `0xd000` block.
* **What the captured port values mean.** The `coop-timer0-safe-01` run proves
  the instrument survives load; it does not interpret what it recorded.
