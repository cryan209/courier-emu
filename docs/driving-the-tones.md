# Driving the tones ourselves, and reading the DSP back

Can the host command the C52 to generate a tone, and then observe that it did?
The primitives for both halves already exist and most are confirmed on
hardware. This records what they are, what is proven, and what is not, so the
experiment can be judged before it is run.

Nothing here has been executed. It is a plan with its evidence attached.

**Written against DSP 3.0.13. Two of its load-bearing claims do not survive the
move to the board's 3.1.2, and the experiment below should not be run as
written.** The tag `0x06` window does not carry any cell of the 3.1.2 audio
path, so its diff cannot see a tone; and blocker 3's "tag `0x13` is not traced"
is now out of date - `13` enters `ee20` and is fully traced in
[mailbox-312-comparison.md](mailbox-312-comparison.md). See
[window-312-baseline.md](window-312-baseline.md) for the measured baseline, the
seventh streamed word, and the corrected chain vector. Blocker 3's addresses
are also wrong; [dsp-overlays.md](dsp-overlays.md) has the measured overlay map.

## Driving: six mailbox messages

The supervisor's own dial path is not a waveform, it is a short conversation
(`courier_firmware_analysis.md`, "What it produces"):

| message | meaning |
|---|---|
| `0x16:0000` | start marker |
| `0x19:020d` `0x1a:3000` `0x1b:0c08` | three constant lanes |
| `0x13:<index>` | the keypad index from `0x6353c` |
| `0x16:0000` | end marker, when the tone stops |

Every one is an ordinary mailbox write - tag word on `0x58`/`0x5a`, value word
on `0x5c`/`0x5e`, committed by writing bit 0 back to `0x1c` - which
`courier_emu.dsp_mailbox` already implements and which is **confirmed on
hardware**: `artifacts/dsp-mailbox-command-02/` reports `predictions_held:
true`, with every inbound-register prediction fixed from the disassembly before
the run.

Three of the six are additionally understood rather than merely sendable.
`0x19`, `0x1a` and `0x1b` appear in the recovered host-write table with known
destinations - DSP data `0x03ad`, `0x0392` and `0x03f1` - so their effect is a
store to a known cell. That table is also why the tone generator is the
datapump's rather than the ASIC's: the parameters land in DSP memory.

## Reading back: two fixed windows

Both arrive through the DSP-to-host stream at `0x60`/`0x62`, which has 27 read
sites and zero write sites in the whole image, and which the CPU resumes by
acknowledging bit 2 of `0x1c`.

| tag | what it streams | status |
|---|---|---|
| `0x46` | four DSP **program** words from `0x860b + index` | confirmed on hardware, `artifacts/dsp-window-pump-02/`-`03/`, against addresses predicted beforehand |
| `0x06` | six DSP **data** cells: `0x0307`, `0x03ba`, `0x0385`, `0x030f`, `0x031c`, `0x0be6` | channel confirmed responding, `artifacts/dsp-window-pump-01/` |

The second one is what makes this worth trying, because of a detail recorded
when it was first pumped: **its sources are empty on an idle unit.** So there is
a baseline to move away from.

## The experiment that needs no new code

1. On hook, idle. Arm tag `0x06` and pump the window; record the six cells.
2. Send the six-message tone sequence.
3. Pump again and diff.

If any of the six moves, the DSP acted on the tone command, and the generator
is confirmed behaviourally rather than only from the mailbox table. If none
moves, the result is genuinely ambiguous - see the second blocker.

## Blockers, stated before the run rather than after

1. **The mailbox belongs to the supervisor.** Writing it while the firmware has
   a conversation in flight corrupts that conversation. This is why
   `dsp_mailbox` runs against an idle modem, and it is why none of this can be
   done during a call.
2. **The read windows are fixed.** Six data cells and one program base, chosen
   by the DSP's own code rather than by us. If the tone state lives anywhere
   else, a null result means "not visible here", not "did not happen".
3. **Tag `0x13` is not traced.** Its handler at `0xd82f` calls `0x84da` twice
   and then `0x0cb1`, and an attempt to disassemble the neighbouring table
   entries was unreliable - tag `0x19`'s entry points at `0xdaaf`, which falls
   in the gap between the resident bank ending at `0xd9ef` and the overlay
   starting at `0xde83`, so it reads as zeros. Either the jump-table base is
   wrong or that handler is in an overlay that is not loaded. Sending `0x13`
   therefore has effects that have not been established.
4. **Tag `0x16` is ambiguous by the firmware's own design.** The call-start
   block uses the same `0x13`/`0x16` lanes with the same constants, and
   "nothing in a single message tells the two uses apart" - what separates them
   is whether the loop is seized. On hook it should be inert; that is an
   expectation, not a measurement.
5. **The line cannot be heard.** Even a perfectly generated tone is observable
   only as DSP state, unless it goes somewhere that can listen. The modem's own
   `AT%T` DTMF detector is the obvious candidate, but the only no-line loopback
   is `AT&T8`, which clears all free RAM (`artifacts/ram-sampler-01/`).

## Where the RAM routine would come in

Only after the cheap version says there is something to see. The host pumps the
window one word per serial round trip, about 165 ms; a tone held for S11
milliseconds is badly aliased at that rate. The tick-hooked sampler
(`courier_emu.ram_sampler`) reads at 200 Hz, so it could capture the window
densely across a tone burst - and it could drive the mailbox writes at bus
speed too, which the six-message sequence would otherwise spread across a
second of serial traffic.

That is a larger and riskier build than the baseline/diff above, and it is not
worth doing until the diff shows a signal.
