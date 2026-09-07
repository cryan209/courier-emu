# The datapump's second voice: a 2100 Hz answer tone

DSP 3.1.2's dial path was already producing DTMF through the firmware's own
oscillator, mixer and serial ISR ([audio-312-path.md](audio-312-path.md)). It
is not the only generator in the resident bank. The same callback slot drives a
family of oscillators, and one of them is a modem tone rather than a dialling
tone: **2100.0 Hz, with a 180 degree phase reversal every 3239 samples**.

Both numbers come out of the firmware, not out of a specification consulted
first, and the ROM's own caller supplies them.

## How the generators are selected

The mixer at `80d3` calls whatever address sits in data `0x39a`. Scanning the
resident bank for stores to that cell finds the family:

| callback | what it does |
|---|---|
| `874f` | one oscillator: increment `0x3f2`, amplitude `0x3f3`, phase `0x3c0` |
| `8743` | a second oscillator on `0x3f4`/`0x3f5`/`0x3c1`, falling through to `874f` - the DTMF pair |
| `8739` | decrements a counter, inverts the phase's top bit with `XPL` when it expires, reloads, falls through to `874f` |
| `8712`, `8716` | `874f` or `8739`, then `8718`, a second oscillator that *multiplies* the tone |

The arming routine at `86d1` takes a phase increment in the accumulator, stores
it at `0x3f2`, installs `874f`, sets the amplitude to `0x0898` and clears the
phase. Its caller at `9f40` is what makes this a modem tone:

```text
9f40  lacc  #4aab
9f42  call  86d1
9f44  splk  @28, #01d7
9f46  splk  @75, #0ca7     ; the reversal counter's reload
9f4c  splk  @1a, #8739     ; the reversing callback
9f58  splk  @73, #06cf     ; a quieter amplitude than 86d1's
```

At the dial path's 7200 Hz, `0x4aab / 65536 * 7200` is **2100.04 Hz**, and
`0x0ca7` is 3239 samples, or **449.9 ms**. Those are the V.25 answer tone and
its 450 ms phase-reversal period, to within the resolution the numbers have.
This is a second, independent corroboration of the 7200 Hz figure that
`audio-312-path.md` inferred from the DTMF increments: no other plausible rate
puts `0x4aab` on a standard tone and `0x0ca7` on a standard interval at once.

`8718` is the same story one level up. It advances a second phase at increment
`0x0089` - 15.05 Hz at 7200 Hz - and multiplies the carrier by it. That is
V.8's ANSam amplitude modulation, and it explains why the selector offers four
callbacks rather than two: reversals or not, modulated or not.

## Rendering it

`courier_emu.answer_tone` arms the tone with the firmware's own instruction
words, lifted verbatim from `9f40`, `9f46`, `9f4c` and `9f58`, and then runs the
same main-loop mixer and serial ISR body that `audio312` runs for DTMF. It
synthesizes nothing.

```sh
.venv/bin/python -m courier_emu.answer_tone \
  --rom artifacts/courier-board-21210-capture-403/courier-board.rom \
  --output /tmp/answer-tone --variant ans-reversals --seconds 2
```

Saved runs are in `artifacts/answer-tone-01/`. Measured from the rendered PCM:

| variant | callback | measured | reversals |
|---|---|---|---|
| `ans` | `874f` | 2100.0 Hz | none |
| `ans-reversals` | `8739` | 2100.0 Hz | every 3200-3264 samples |

The reversal spacing is reported to the detector's 64-sample block, which
brackets the counter's 3239.

## One correction to the harness, and it is load-bearing

`audio312` enters the frame at `80d3`, the callback call itself. That is fine
for `874f` and `8743`, and wrong for `8739`, whose `BANZ` tests the register
the ARP currently points at rather than the `AR1` the instruction before it
loaded. The mixer sets ARP to 1 at `80c9`; entering below that leaves it
elsewhere, the counter is never stored back, `XPL` fires on every sample, and
the output is a constant-magnitude square instead of a tone. This harness
therefore enters at `80c7`, the top of the mixer's sample body.

That failure is worth recording because it is silent: the path runs, the ISR
transmits 1440 words, and the result is simply the wrong signal.

## What this does not show

* **Not a boot.** As with `audio312`, frame scheduling, idle RAM and one buffer
  pair are fixtures. The ISR body is entered directly rather than by interrupt.
* **Not the supervisor's decision to send it.** `9f40` is reached from a state
  machine this harness does not run; what it renders is the generator, armed
  the way that site arms it.

  *Closed on this image too, 2026-09-08.* The path is traced in
  [the section below](#the-path-to-9f40). *Also closed on the other image.* `ATA` on `IDSDL302.ROM` (DSP 3.0.13)
  emits ANSam in the full emulator, supervisor and all, from its own analogue of
  this site at `0x9f62` - and follows it with a 2250 Hz tone armed at `0xd354`.
  See [ata-answer-tone-302.md](ata-answer-tone-302.md), which also maps 3.0.13's
  oscillator family onto this one: the code addresses differ throughout, but the
  data cells - increment `0x3f2`, amplitude `0x3f3`, phase `0x3c0` - are the
  same in both builds. That does not locate 3.1.2's own path to `9f40`.
* **ANSam renders too.** *Corrected.* This section used to say the `8712` and
  `8716` variants could not be rendered, and blamed missing delay-line state.
  The real cause was a bug in this repository's C5x core: `MADD` and `MADS`
  read their coefficients from data memory instead of program memory, so the
  shaping filter at `8a88` returned zero. With that fixed - see
  [fsk-modulation.md](fsk-modulation.md) - both variants produce the 15.05 Hz
  amplitude modulation, as a symmetric sideband pair at 2085 and 2115 Hz, each
  about 10% of the carrier.
* **The `&T` self-test was not the way in.** Driving the supervisor with
  `AT&T1`, `AT&T8` and `ATS18=2&T8` under `courier_emu.mailbox_tap` produces
  `OK` and the same fourteen idle-cycle mailbox messages as a bare `AT`. The
  generator above was found by reading the callback slot's writers instead.

  *Corrected.* This originally added "the loopback path does not engage in the
  emulator", on the grounds that the runs showed no distinct execution. That
  was read off `hot_addresses`, which lists only the most-executed addresses
  and is therefore dominated by the idle loop either way. Recording every
  address instead - `CourierMachine(code_observer=...)`, added for this -
  shows `AT&T8` reaching **548 addresses a bare `AT` never reaches**, in some
  thirty regions of the supervisor. The handler runs. What has not been shown
  is that it reaches the datapump within the window observed.

## The path to `9f40`

`9f40` is never branched to. It is reached by falling into it, from a state the
scheduler dispatches.

### The scheduler

`875c` is a one-shot state machine driven from the idle path (`9f0d: call
875c`). Two memory-mapped cells drive it - `0x006e`, a frame countdown, and
`0x006d`, the address of the state to run when that countdown expires:

```text
875c: lamm @6e        ; the countdown
875d: bcnd 8762, eq
875f: sub  #01
8760: samm @6e
8761: retc neq        ; still waiting
8762: lamm @6d        ; the state vector
8763: retc eq         ; nothing armed
8764: bacc            ; branch into the state
8765: samm @6e        ; (entry point) arm the countdown
8766: pop
8767: samm @6d        ; (entry point) arm the state
```

### What arms the answer-tone state

Two sites write `9f3e` into that vector, and each is gated on a bit of the
flags word at data `0x006f`:

```text
afeb  lar ar1, #6f              reached by conditional call from
      ...                       b0e7, b233, b5a1 and b5ca
afff  bcnd 9e09, tc             gate: bit 0 of 0x006f
9e0a  splk @6d, #9f3e           @26 = 4000, @27 = 0008

a320  countdown at 0x031a       called from aaa2 and ab7e
a327  bit 14, *                 gate: bit 1 of 0x006f
a32c  call 8140                 sets the codec sample rate first
a32e  b 9e13
9e14  splk @6d, #9f3e           @26 = 4010, @27 = 0000
```

Note `bit 14` is a bit *code*, not a bit number: the C5x tests bit `15 - code`
(the core evaluates `(~op >> 8) & 0xf`), so `bit 14` reads bit 1 and `bit 15`
reads bit 0. The disassembler prints the raw code.

That path B calls `8140` on the way is a small corroboration of
[codec-rate-312.md](codec-rate-312.md): the sample rate is programmed
immediately before the tone that assumes it.

### Into the tone

```text
9f3a: lacc @2b ; sub #01 ; sacl @2b ; retc gt    the timer variant
9f3e: call a092                                  falls through
9f40: lacc #4aab ; call 86d1                     the arming
```

`9f3a` is the same state with a countdown in front, entered from `9f12`,
`9f20`, `9f28` and `9f33`; the stubs at `9f11` and `9f15` that dispatch to them
are themselves armed at `9e1d` and `9e21`.

### Confirmed by running it

Rather than a full boot - which this image does not currently reach, for
reasons unrelated to this path - the last two links were confirmed directly.
Seeding `0x006d` with `9f3e` and `0x006e` with zero, then entering the
scheduler at `875c`, executes `9f3e`, `9f40` and `86d1` and leaves:

| cell | value | |
|---|---|---|
| `0x3f2` | `4aab` | 2100.04 Hz at 7200 |
| `0x3f3` | `0898` | `86d1`'s own amplitude literal |
| `0x39a` | `874f` | the oscillator, installed |

So the scheduler does reach the arming, and the arming does load the answer
tone. What is *not* shown here is the supervisor state that sets bit 0 or bit 1
of `0x006f`; the trace stops at the four conditional callers of `afeb` and the
two of `a320`.

