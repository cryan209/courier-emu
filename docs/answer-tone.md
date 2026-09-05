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
* **ANSam is identified, not rendered.** The `8712` and `8716` variants route
  the modulated tone through a five-tap filter at `8a88` over a delay line at
  `0x01e1`. Under idle-RAM fixtures only two of its taps are ever written and
  the output is silence, which the tool reports as `silent` rather than
  guessing at the missing state. The 15.05 Hz second oscillator does run, and
  its phase advances correctly; it is the shaping filter that wants state the
  fixture has not got.
* **The `&T` self-test was not the way in.** Driving the supervisor with
  `AT&T1`, `AT&T8` and `ATS18=2&T8` under `courier_emu.mailbox_tap` produces
  `OK` and the same fourteen idle-cycle mailbox messages as a bare `AT`, at
  both 9M and 60M instructions. The loopback path does not engage in the
  emulator, so it could not be used to make the datapump speak. The generator
  above was found by reading the callback slot's writers instead.
