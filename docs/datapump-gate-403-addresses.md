# The datapump gate, in 403 addresses

[datapump-dispatch-gate.md](datapump-dispatch-gate.md) ends with the datapump
blocked on one routine — the three-flag discriminator at `0x8b84f` returning
equal — and with an explicit caveat: every cell address in it was read out of
`IDSDL302.ROM` (supervisor 7.3.14), while the attached board runs 7.4.16. The
hardware sample of `685`/`5a5`/`a96` in that document is therefore not a
reading of the gate at all; it is three unrelated bytes.

The new [ATG](atg-dsp-command.md) and [ATN](undocumented-atn-commands.md) work
gave the method that closes this: match the 403 image structurally against the
302 routine rather than assuming a shared layout. The `ATN` handler was found
that way in both images — 302 `0x883c8` and 403 `0x8458` are the same code,
parsing a decimal byte, selecting event `7c`/`7b`, setting a manual flag and
calling the state dispatcher — which is what showed the layout differs while
the code does not.

## The mapping

Scanning both images for the discriminator's shape — `test byte [imm16], 2`
followed by two `test byte [imm16], 1` and a `ret` — gives exactly one
counterpart, `0x8b88d`, at `+0x3e` from the 302 site. The CF gate and the
overlay loader follow immediately after it in both images, in the same order.

| role | 302 | 403 |
|---|---|---|
| discriminator | `0x8b84f` | `0x8b88d` |
| CF gate | `0x8b863` | `0x8b8a1` |
| dispatch site (`mov ax,0x10`) | `0x8bee8` | `0x8bf34` |
| overlay loader | `0x8e5da` | `0x8e60a` |
| flag A, tested `& 2` | `[0x0a96]` | `[0x098a]` |
| flag B, tested `& 1` | `[0x05a5]` | `[0x049e]` |
| flag C, tested `& 1` | `[0x0685]` | `[0x057c]` |
| CF gate cells | `[0x05cd]`, `[0x05fa]`, `[0x0600]` | `[0x04c6]`, `[0x04f2]`, `[0x04f8]` |
| overlay id | `[0x0e3c]` | `[0x0d28]` |
| dispatch data cell | `[0x0281]` | `[0x017b]` |

Flag B cross-checks independently: the unrelated routine at 302 `0xa5602`
tests `[0x5a5] & 2`, and its 403 counterpart at `0xa562d` tests `[0x49e] & 2`.
Two separate call sites agree on the same rename.

The 403 overlay loader confirms the third row of the map by its own contents:
it reads `[0x0d28]`, compares against 6, rewrites the cell as 8, indexes a
six-byte-stride table at `cs:0xe741`, and starts the transfer with
`out 0x1e, 4` — instruction for instruction the 302 loader with `[0x0e3c]`
and `cs:0xe711`.

## What this does not settle

The addresses are established; the values are not. Nothing here says whether
the board has those three flags set, and nothing here identifies the writer.
On 302 the only reachable setter for any of them is in the thunk cluster
reached from the command handler at `0xa6a6c`, which is entry 8 of the offset
table at `0xa6615` — a table this image never indexes by any far pointer or
`jmp cs:[bx+...]`, so how it is entered remains open.

The `ATN` correspondence is a lead about method, not about this gate: the
403 `7b`/`7c` consumers reach a rate-index request through operation `0054`,
not any of these three flags. Reading the shared shape of the two decimal
command parsers as evidence that `ATN` *is* the command that arms the datapump
would be a guess, and this document does not make it.

## The read this enables

`ATGLK2=0000:0900` and `ATGLK2=0000:0400` cover all three flags and the CF
gate cells. That is the existing read-only dump command, in command mode, with
no line seizure, no write and no flash access — the same primitive
`flash_dump.py` already uses. It answers directly whether a working board
carries these set, which is what decides between a provisioning gap — as the
`0cd9`/`0cdb` gain cells turned out to be — and a genuinely unreached code
path.

## Measured on the board: all seven cells are zero at idle

Read 2026-09-09 from the attached Courier on `/dev/cu.usbserial-11420`,
ID_SDL 4.03d, supervisor 7.4.16 / DSP 3.1.2, in command mode, read-only.
Two passes with identical page hashes:

| `098a` | `049e` | `057c` | `04c6` | `04f2` | `04f8` | `0d28` |
|---|---|---|---|---|---|---|
| `00` | `00` | `00` | `00` | `00` | `00` | `00` |

The pages are live rather than a failed read: `0400`, `0900`, `0c00` and
`0d00` carry 51, 54, 60 and 15 nonzero bytes, and the control cells `0cd9`
and `0cdb` read `32c8` and `0c08` — the same values the earlier RAM capture
recorded, and the ones that turned out to be the tone-gain provisioning gap.

**This kills the provisioning hypothesis for this gate.** The gain cells were
populated at idle on a board that had them and blank in an emulator that did
not. These are blank on the working board too, so they are not stored settings
the emulator is failing to supply. Either they are set during call setup —
which this idle sample cannot see — or the discriminator's equal path is the
normal path and the datapump is armed by something this chain does not
describe. Reading the same seven cells during a live call is what separates
those two, and it is the next measurement.

[Capture](../artifacts/datapump-gate-403-cells/cells.json),
[script](../artifacts/datapump-gate-403-cells/read-cells.py).

## Arming the tone by hand: clean run, unusable observable

The dial block's own three tags were sent through the eight-digit form on-hook
— `ATG001A32C8`, `ATG001B0C08`, `ATG00130006` — then the sample-energy query
`62` was read four times across the window, then tag `16` restored the idle
callback. All commands returned `OK` and `AT` answered afterwards.

Query `62` returns `0069:0015` at baseline and `0069:0015` throughout the
armed window. Interleaving query `07` proves each reply is fresh rather than a
held register: the mark flips `0031:0000` → `0069:0015` on every read.

So the value genuinely does not move, and `0015` is one of the handler's own
clamp values. **This is a null result about the observable, not about the
tone.** Query `62` sums squares of DSP data `0900..098f`, which is receive-side
analysis; on-hook there is no path from the transmitter back into it, and the
handler is sitting at a clamp in any case. Nothing here shows whether the
oscillator ran.

Settling it needs either a transmit-side reading — no tag in this image is yet
known to return one — or the same sequence off-hook on a connected line, where
the hybrid leaks transmit into receive. Neither was done.

[Capture](../artifacts/atg-tone-arm-403/tone-interleaved.json),
[script](../artifacts/atg-tone-arm-403/arm-tone-interleaved.py).

## Off-hook on a live line: query 62 is pinned, not quiet

Repeated with the line seized — `ATH1`, a few seconds, `ATH0`, released
cleanly with `AT` answering afterwards. Dial tone was present on the pair for
the three baseline reads before the tone was armed.

| point | query 62 |
|---|---|
| on-hook baseline | `0069:0015` |
| off-hook, dial tone, x3 | `0069:0015` |
| off-hook, tone armed, x4 | `0069:0015` |
| off-hook, after tag 16 | `0069:0015` |

Every reply is fresh: the interleaved query `07` mark flips `0031:0000` →
`0069:0015` on all eleven reads.

**Dial tone is a large, known signal in the receive path, and query 62 does
not move for it.** That settles what the previous section could only suspect:
`62` is not an energy detector that happens to be quiet on-hook, it is pinned
at `0015` under silence, under dial tone and under an armed tone alike. It
cannot observe the audio path in command mode at all, and no experiment built
on it will say anything about the transmitter.

Two explanations remain open and this measurement does not separate them: the
handler may be clamped or reading a buffer nothing fills in this state, or the
resident may not be in a state where tag `13` arms anything outside a call.
Distinguishing them needs a transmit-side reading, which no tag in this image
is yet known to provide.

### A consequence for the existing replay comparison

[mailbox-312-comparison.md](mailbox-312-comparison.md) records the emulator
reproducing `0069:0015` for query 62 as a match against the board, and treats
resolving the earlier `0012` discrepancy as a result about initialization. The
board now says `0015` is returned under every condition tested, including a
loud signal. Matching it therefore confirms the mailbox transport and the
dispatcher, and carries no information about the handler's sample arithmetic.
That document's hedge — "matching this idle result cannot establish
sample-by-sample audio accuracy" — is right, and understates it: `0015` is not
an idle result, it is an unconditional one.

[Capture](../artifacts/atg-tone-offhook-403/tone.json),
[script](../artifacts/atg-tone-offhook-403/offhook-tone.py).
