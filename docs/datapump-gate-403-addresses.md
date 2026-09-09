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

**Superseded by the ear.** The operator heard a DTMF tone held on the line for
roughly ten seconds during this run — the length of the armed window, ending
when tag `16` was sent. So the two explanations offered here are both wrong:
the oscillator ran, the tone reached the line, and the resident arms tag `13`
perfectly well outside a call. See [the audible result](#the-tone-was-audible)
below.

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

## The tone was audible

During the off-hook run the operator heard a DTMF tone held on the line for
about ten seconds, stopping when tag `16` was sent. That is the length of the
armed window — four energy reads with their serial round trips and `0.2 s`
sleeps between them — and nothing else in the sequence would produce a tone.

**So the hand-armed tone works end to end on the board.** Three eight-digit
`ATG` commands, in command mode, with no call and no dial sequencer, put the
firmware's own DTMF on a live line:

```text
ATG001A32C8    gain      -> DSP data 0392
ATG001B0C08    amplitude -> DSP data 03f1
ATG00130006    digit 6   -> arms the oscillator through ee20
ATG00160000    restores the idle callback 8128, stopping the tone
```

### The exchange acted on it

Dial tone was present when the tone was armed, and holding it took the line to
busy. That is the switch responding: an off-hook line with dial tone treats a
DTMF digit as the start of a dial, and a digit held for ten seconds with
nothing following it is an incomplete dial, which the exchange ends in reorder.

This is better evidence than audibility. A tone can be heard and still be at
the wrong level or off-frequency; **a tone the exchange decodes and acts on is
within the network's own tolerance for level, frequency and duration.** The
transmit path is not merely producing sound, it is producing a valid DTMF
digit.

**A hazard worth stating plainly.** Arming a tone off-hook on a connected line
dials into the exchange, and nothing in the firmware times the tone out. This
run left the line in reorder until it was released. The board was afterwards
confirmed responsive, on-hook, and back on the idle callback; a reorder clears
on its own once the line is released. Anyone repeating this should keep the
armed window short and hang up immediately, or - now that the path is
confirmed - not seize a live line for tone work at all.

This is the first time this project has driven the audio path on hardware
directly rather than through a dial, and it confirms the chain
[datapump-dispatch-gate.md](datapump-dispatch-gate.md) traced statically —
gain cell, amplitude cell, selector, oscillator, mixer, serial ISR — as a
working whole on the board, not only in the emulator.

Two corrections to the sections above, which were written before this was
known. The off-hook run is **not** a null result about the tone; it is a null
result about query 62 only. And the tone is not the one-shot the dial's
arm/restore pairs suggest: nothing times it out, so an armed tone stays on the
line until tag `16` is sent. Anyone repeating this should send the stop tag in
a `finally`, as the script does.

The query-62 finding is correspondingly stronger. A real DTMF tone was
physically on the pair, and query 62 still read `0069:0015` on all four armed
reads. It is not merely insensitive to dial tone; it does not see the
firmware's own transmitted tone either.

## No tag returns transmit-side state

Sweeping all 128 entries of the 3.1.2 dispatcher table at program `0x83e9`
for a handler that could serve as a transmit-side observable. The reply
convention had to be established first, and it is not the one assumed above:

* Handlers do **not** call the sender at `0x83bf`. They enqueue a reply by
  calling or delayed-branching to `0x83b1`, the tail of the routine at
  `0x83a6`, with the value in ACC — so on a delayed branch the value is
  loaded in the delay slots after the branch instruction.
* That routine pushes into a ring masked by `ar0 = ff60`, with head and tail
  at data `0x78`/`0x79`.
* The sender at `0x83bf` drains that ring, masks `0x7fff`, and writes the
  words out to ports `0x5e` and `0x5f`, which the CPU reads as the byte pairs
  `58/5a` and `5c/5e`.

Twenty tags reply: `07 14 23 24 28 29 2e 2f 32 33 34 3b 3d 4b 55 59 5a 5f
62 7f`. Every one returns either a constant tag word paired with a status
cell, or a value computed from receive-side analysis — `62` sums squares of
`0900..098f`, as already recorded. **None replies with a value read from the
transmit block** (`0390` work pointer, `0392` gain, `039a` callback, `03c0`/
`03c1` phases, `03c7` mixer accumulator, `03f1..03f5`, the transmit slots of
the buffer at `0bc0..0bde`, or DXR).

Handlers that *touch* transmit cells are common — `13`, `1a`, `1b`, `16` and
the overlay-resident tags at `20..25`, `2e`, `2f`, `32..34` all write them —
but they are setters, not readers, and none of them replies.

So the transmit-side read this project wanted does not exist as a tag in this
image, and no experiment can be built on one. That closes the question rather
than answering it: with the tone now confirmed audible, the observable it was
meant to provide is no longer needed for this measurement.

An earlier pass of this sweep reported tag `01` and then tags `55`/`59`/`5a`
as candidates. Both were artefacts: the first followed a jump into the main
loop and inherited its references, and the second misread `bit 1, @1f` — a
status word at `039f` with twenty-five writers — as the replied value, when
those handlers reply with the constants `#06` and `#04`.

[Sweep](../artifacts/dispatcher-tag-sweep-312/sweep.py),
[table](../artifacts/dispatcher-tag-sweep-312/replying-tags.json).

## During a call: still zero, but the mode that matters was not reached

Dialled `ATDT9099;` on the connected line. The semicolon form returns to
command mode with the line still seized, which is the only way to read RAM
while a call is up — a plain `ATD` leaves the DTE waiting for a result code
and accepts no commands. 15.2 seconds off hook, released cleanly, board
responsive afterwards.

| sample | all seven cells |
|---|---|
| idle, on-hook | `00` |
| off-hook, dialling and ringing, x6 over 6 s | `00` |
| after release | `00` |

So the flags are not set by seizure, by dialling, or by ringing. That is a
real exclusion, and it is not the answer: **the semicolon form attempts no
data handshake**, so this run never ran the datapump and never exercised the
gate. The untested state is the one that matters.

### What `0d28` being zero implies

The overlay id is the strongest cell here, because its behaviour on a working
board is not in doubt. A data call on this modem *must* download a datapump
overlay — the resident bank holds the DTMF oscillator and no data modulation
— and the loader at `0x8e60a` runs only when `[0x0d28]` is non-zero. The board
plainly does connect. Therefore `[0x0d28]` **must** become non-zero at some
point on a real data call.

It is zero at idle, through dialling and through ringing. So whatever sets it
acts during the data handshake specifically, after the point this experiment
can reach. The same is then plausible for the three discriminator flags, which
gate the same selection code — but plausible is all it is, since only `0d28`
has an argument this strong.

This also revises how the emulator's run should be read. `[0x0e3c]` zero at
the dial is not by itself the modelling gap; the board is zero there too. The
gap is whatever the board does later that the emulator never reaches.

### Why this is hard to finish on this hardware

Reading RAM needs command mode. The datapump-active state is precisely when
the DTE is not in command mode. The `+++` escape reaches command mode with a
call up, but only after `CONNECT` — which needs an answering modem, and there
is none on this line. The three ways out, in order of preference:

1. **A modem to call.** Any answering modem gives `CONNECT`, then `+++`, then
   the cells read with the datapump genuinely running. This is the experiment
   that settles it.
2. **Sample immediately after `NO CARRIER`.** A plain `ATD` to a number that
   answers as anything else runs a real handshake attempt for the `S7` window,
   and the flags may persist past the failure. Cheap, needs no second modem,
   and worth trying before anything else — but a negative proves nothing,
   since the failure path may clear them.
3. **Find the setter statically.** The 302 analysis found exactly one
   reachable setter for one of the three flags, in a thunk cluster whose entry
   is not established. Repeating that search in 403 against the addresses in
   this document has not been done.

[Capture](../artifacts/gate-cells-live-call/cells.json),
[script](../artifacts/gate-cells-live-call/live-call-cells.py).

### `ATX1` gives a real handshake window; the escape aborts it

`9898` returns busy tone. With the board's own `X7` the modem detects it and
gives up in about 15 seconds, so the first two attempts never handshook at all.
`ATX1` drops busy and dial-tone detection, and the behaviour changes
completely: no result code for the whole 25-second wait, the line held, the
modem signalling into the busy tone for the full `S7` window.

That is the state this experiment wanted. It is still not readable. Sending
`+++` mid-handshake returns `NO CARRIER` — **the firmware treats DTE input
during handshake as an abort, not as an escape** — and the eight samples taken
immediately afterwards are all zero, which says nothing, since they follow the
teardown.

Off hook 36.5 seconds, line released, `X7` restored from the recorded `ATI5`,
board responsive.

So the routes stand as follows. The mid-handshake escape is closed, not merely
untried. Sampling after a natural `S7` timeout remains possible but has the
same weakness the abort samples have. **Reading the live handshake needs a
modem that answers**, and nothing else on this line will produce one: `9099`
echoes the pair, and an echoed originate-band carrier is not an answer-band
one, so it cannot train.

The static search for the setter is therefore the route that is actually open.

## The setter is unreachable in 403 too — and that reframes the gate

> **Wrong, corrected below.** The "nothing indexes that table and nothing calls
> the router" finding in this section is an artefact of searching only for
> direct references. This firmware dispatches through RAM function pointers,
> and the router's offset is stored into one. See
> [the correction](#correction-the-router-is-installed-as-a-ram-function-pointer).
> The address mapping table in this section stands; the reachability conclusion
> drawn from it does not, and neither does the "gate is on a dead path"
> reasoning that follows from it.

Repeating the 302 search against the addresses above. Flag C has two genuine
setters, `0x8770f` (`or [0x57c], 1`) and `0x8779c` (`or [0x57c], 9`); flags A
and B have none in the whole image, only clears. So flag C is the only one
with any setter at all, exactly as on 302.

Its cluster resolves completely, and mirrors 302 structurally:

| | 302 | 403 |
|---|---|---|
| thunk stubs, `call near`/`retf`, stride 4 | `0x875d8` | `0x87622` |
| entry 1 handler | `0x876b1` | `0x876fb` |
| the setter it reaches | `0x876c5` | `0x8770f` |
| indexed jump | `0xa6ad7` | `0xa6b69` |
| jump table, nine entries, `AL=2` rejected | `0xa6ade` | `0xa6b70`, CS `a4e2` |
| router entry, decimal-ASCII parse then `cmp al, 1` | `0xa6a6c` | `0xa6afe` |
| decimal parser | `8000:9cbc` | `8000:9ce7` |
| handler-offset table, router at entry 8 | `0xa6615` | `0xa669b` |
| rejects `AL=1` when set | `[0x0ea7]` | `[0x0d93]` |

**And in 403, as in 302, nothing indexes that table and nothing calls the
router.** No `jmp`/`call word ptr cs:[bx+disp]` uses its displacement, no far
pointer targets it, and there is no `mov bx, 187b`. The one indexed jump whose
CS could have reached it, `0xa6e26`, indexes a coherent local table sitting
immediately after itself. That the same negative reproduces independently on a
second image makes it a property of the firmware rather than of one
disassembly.

### What that means: the gate is on a path the board does not take

If nothing sets the three flags, the discriminator at `0x8b88d` always returns
equal on this image. The board plainly connects. So **the datapump is not
armed through this chain**, and
[datapump-dispatch-gate.md](datapump-dispatch-gate.md)'s conclusion that
`0x8b84f` returning equal is "the single root cause" identifies a real gate on
a road that is never driven.

The overlay id makes that concrete. Every write to `[0x0d28]` in 403:

| site | write | reached by |
|---|---|---|
| `0x8bc06` | `6` | the **CF gate** `0x8b8a1` returning carry — *not* the discriminator |
| `0x8bc8d`, `0x8bc99` | `6`, `7` | inside the discriminator-gated selection block |
| `0x8b7db` | `5` | gated only on `[0x0d92] & 4`, outside both |
| `0x8e616` | `8` | the loader itself, chaining `6` to `8` |
| `0x94d87` | `al` | **`in al, 0x5c` then `or al, 0x80`** — the id read from the mailbox data port |
| `0x8e73a` | `0` | teardown |

Three of these are independent of the three flags. The last is the most
interesting: `0x94d87` takes the overlay id from ASIC port `0x5c` with bit 7
forced, so on that path **the DSP side selects which overlay the supervisor
loads**. Nothing in the previous analysis looked at it, because the search
started from the discriminator and never left it.

That is where this should go next, and it needs no line: trace which of
`0x8b7db`, `0x8bc06` and `0x94d87` a real call reaches, and what `[0x0d92]`
bit 2 and the CF gate cells depend on. The CF gate is the more promising of
the two flag-based routes, because unlike the discriminator flags its cells
have ordinary setters.

None of this is yet a measurement. It says which paths exist, not which one
the board takes.

## Correction: the router is installed as a RAM function pointer

The reachability search above, and the 302 search it reproduces, both looked
only for direct references — an indexed `jmp`/`call` using the table's
displacement, a far pointer, an immediate load of its address. Neither found
one, and both concluded the code was dead.

That test is too narrow for this firmware, which dispatches through function
pointers held in RAM. `datapump-dispatch-gate.md` says so itself about a
different cell: `0x8f564` is `call word ptr [0x298]`, "an indirect call through
the current state handler". The same pattern answers this question.

**`[0x03ff]` is such a cell.** It is called indirectly at two sites:

```text
90ef1  call word ptr [3ff]
92004  call word ptr [3ff]        ; immediately after out 1c / out 1e
```

and written from about eighty-eight sites between `0x90e67` and `0x91efe`,
each a small routine installing one handler offset. One of them is:

```text
910c6  cli
910c7  mov word ptr [0x3ff], 0x1cde     ; = a4e2:1cde = a6afe, the router
910cd  mov byte ptr [0x403], 0x64
910d2  mov word ptr [0x192], 0x1cca
910d8  sti
910d9  ret
```

`0x1cde` is exactly the router entry. So the router is not orphaned code: it
is installed as the current handler in `[0x03ff]`, and `[0x03ff]` is called.

Two supporting facts. The parser the router calls, `8000:9ce7`, is confirmed
to be the decimal-ASCII routine — `lodsb`, `sub al, 0x30`, `mov ah, 0xa`,
`mul ah`, accumulate — so `AL` really is a number taken from a command string,
as the 302 reading had it. And the second call site sits directly after
`out 0x1c` / `out 0x1e`, the ASIC mailbox commit, which places this handler
family in the supervisor's DSP-facing service path rather than off to one side.

### What is now established, and what is not

Established: the dispatch mechanism, the router's installation into it, and
the parser's identity. The three-flag discriminator, the CF gate cells
`[0x04f2]` and `[0x04f8]`, and flag C are all written from handlers in this
same family — entries 0, 3 and 8 of the table at `0xa669b` — and that family
has a live dispatch path.

Not established: that `0x910c6` itself runs, or under what condition. Showing
the offset is stored into a called pointer is much stronger than finding
nothing, but it is not the same as tracing a caller into the installer. That
is the next link, and it is the one to pull.

**So the "gate is on a dead path" reading two sections up is withdrawn.** The
gate may well be on the live path after all, with the arming command simply
never issued by any run we have made — which is a very different problem, and
a more hopeful one, than code that cannot be reached.

The overlay-id survey stands on its own: `0x8b7db`, `0x8bc06` and `0x94d87`
are real alternative writers regardless of how this resolves, and `0x94d87`
taking the id from ASIC port `0x5c` remains the most interesting of them.

## The installer's caller is not found statically — but the slot is readable

Nothing branches to `0x910c6`. Building a target-to-caller map of every direct
`call`/`jmp`/`jcc` in the image and probing each installer's entry shows why
that is not the anomaly it looks like: **only 19 of the 87 installer sites have
any direct branch to them at all.** Sixty-eight, ours included, are reached
some other way. Indirect dispatch is the family's norm, so failing to find a
direct caller for one of them establishes nothing either way — the same
mistake, in a smaller form, as the reachability searches this document already
withdrew.

What the family does say is consistent. Each installer writes both `[0x0192]`
— the supervisor state handler, invoked by `call word ptr [0x0192]` from
`8f46:00f4`, the path [the ATN analysis](undocumented-atn-commands.md) already
traced — and `[0x03ff]`. Both hold offsets into segment `a4e2`, the segment the
handler table at `0xa669b` lives in. So these are state transitions, and the
question "what calls the installer" is really "what transition enters this
state".

### Read off the board, idle

| cell | value | meaning |
|---|---|---|
| `[0x0192]` state handler | `0110` -> `a4f30` | some idle state |
| `[0x03ff]` router slot | `0000` | **no router installed** |
| `[0x0403]` | `00` | |

The slot is empty at idle, which is what the whole picture predicts: the
router is installed on entering a particular state, and the modem is not in it.

This turns an intractable static question into a cheap measurement. `[0x0192]`
and `[0x03ff]` are two RAM words, readable with the same `ATGLK2=` dump used
throughout, and the `;` dial form already lets us read while a call is up. So
the state machine's actual trajectory on the board can simply be watched —
sampling both words through seizure, dialling and ringing shows which states a
real call enters, and whether `1cde` ever appears in the slot.

That is worth doing for its own sake, independently of this gate: it gives the
first direct comparison between the board's supervisor state sequence and the
emulator's.

## The state trajectory, measured

Sampled `[0x0192]`, `[0x03ff]`, `[0x0403]` and the seven gate cells
continuously across an `ATDT9099;` dial — command mode, line seized, no
handshake. Fifteen samples over 29 seconds, line released, board responsive.

| phase | `[0x0192]` | `[0x03ff]` | gate cells |
|---|---|---|---|
| idle, x2 | `0110` | `0000` | all zero |
| off-hook, x13 over 20 s | `5742` | `0000` | all zero |
| after release | `0110` | `0000` | all zero |

**The state pointer moves.** This is the first direct observation of the
board's supervisor state machine, and it gives a baseline the emulator can be
compared against: a 403 dial should reach `5742` and return to `0110`.

`[0x03ff]` stays `0000` throughout, so the router is never installed on this
path — consistent with the gate cells never moving, and the same limitation as
every other measurement here. A semicolon dial reaches exactly one extra state.

### One correction to how these values were printed

The run labelled each pointer with a linear address computed as `a4e2:value`,
on the strength of the installers writing `a4e2` offsets. That holds for the
idle state — `a4e20 + 0110 = a4f30` disassembles as real code — but **not** for
`5742`, whose implied `aa562` is garbage. So `[0x0192]` does not always carry
an `a4e2` offset, the segment varies with the state, and the linear column in
the capture should be read as a hypothesis per row rather than a fact. The
observed values and their transitions are unaffected.

### A link the trajectory turned up

The idle handler at `a4f30` begins:

```text
a4f30  popaw
a4f31  shl  bx, 1
a4f33  call word ptr cs:[bx + 0x21ff]     ; table at a701f
```

That table has 24 entries, and its filler — repeated at entries 3, 6-10, 12,
14, 16, 20, 22-23 — is `0x1960`, `a6780`. **`0x1960` is the same filler that
occupies entries 3, 5 and 10 of the handler table at `0xa669b`**, the table
holding the router. Two tables sharing a reject stub belong to one command
system.

So the `a669b` family is part of the live command dispatch after all, which is
the first positive evidence for it rather than an absence of negative evidence.
The router's own offset `0x1cde` is not among these 24 entries, so this is not
yet the dispatcher that reaches it — but it is the right neighbourhood, and
`a701f` is a better place to search from than anywhere this document has
looked so far.

[Capture](../artifacts/state-trajectory-403/trajectory.json),
[script](../artifacts/state-trajectory-403/trajectory.py).
