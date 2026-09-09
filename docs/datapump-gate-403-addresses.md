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

## The dispatcher, found: the table starts at `a6685`

Every displacement search in this document failed for one reason: **the table
does not start at `0xa669b`.** That was where the router's neighbours happened
to be legible. The real base is `0xa6685`, `0x16` bytes earlier, and with the
right base the dispatch is immediate — enumerating every `cs:`-overridden
indexed jump and call inside segment `a4e2`:

```text
a4f53  cmp  al, 0x41            ; 'A'
a4f55  jb   reject
a4f57  cmp  al, 0x5a            ; 'Z'
a4f59  ja   reject
a4f5c  mov  bx, ax
a4f5e  sub  bl, 0x41            ; index = letter - 'A'
a4f61  shl  bl, 1
a4f63  call word ptr cs:[bx + 0x1865]    ; table at a6685
```

**The table is indexed by command letter.** Twenty-six entries, `0x1960`
(`a6780`) as the reject stub. And the three handlers this document has been
chasing fall out immediately:

| entry | letter | handler | what it writes |
|---|---|---|---|
| 11 | `L` | `a695e` | `[0x04f2]` — the CF gate cell that must be `1` |
| 13 | `N` | `a6a11` | `[0x04f8]` — the CF gate cell that must be `0` or `>3` |
| 19 | `T` | `a6afe` | the **router**, whose `AL=1` sets flag C |

The idle state handler `a4f30` — the one `[0x0192]` actually holds on the
board, measured in the trajectory above — contains this dispatch, along with a
second one at `a4f33` into the `a701f` table. So this is live code in the
state the modem sits in.

### Tested on the board: the ordinary letters do not reach it

If `ATL1` reached entry 11, it would store `1` in `[0x04f2]` and open the CF
gate, since the board already has `[0x04c6]` bit 6 clear and `[0x04f8]` zero.
The handler's one branch does not divert it either: it writes `[0x0568]`
instead only when `[0x058c] & 4` **and** `[0x016c] & 4` are both set, and the
board reads `[0x016c] = 0000`, so the branch falls to the `[0x04f2]` store.

Issued on the board, reading before and after each:

```text
ATL0 ATL1 ATL2 ATL3 ATN0 ATN4 ATN5 ATT
```

`[0x04f2]`, `[0x04f8]`, `[0x0568]`, `[0x056e]` and all seven gate cells stay
`00` throughout. **So the ordinary AT letters are not what indexes this
table.**

That is a constraint, not a dead end. The parser around the dispatch handles
`0x24` (`$`) as a special case immediately before the A–Z range, and has a
second table at `a5072` for punctuation `0x21..0x7e`. That shape suggests a
prefixed sub-interpreter rather than the main AT parser — the resident's
ordinary command table lives at file `0x250cc`, a different mechanism
entirely, as [the ATN analysis](undocumented-atn-commands.md) already
established for `N`.

So the next test is whether a prefix reaches it — `AT$L1` and friends — and
that is a command form this project has not sent to hardware before. It should
be approached the way the tone was: one command, cells read either side,
nothing assumed about what an unrecognised form does.

## `AT$` is HELP, and the letter mapping is retracted

`$` is not a prefix. `AT$` prints the firmware's own command quick reference,
captured in full at [help-dollar.txt](../artifacts/dollar-prefix-403/help-dollar.txt).
The parser's `cmp al, 0x24` is that help command, and the related forms it
lists — `&$`, `%$`, `D$`, `S$` — are per-family help, not prefixes either. The
board answers `AT` normally afterwards.

The listing is worth having on its own account. The complete command set is:

```text
A/ A> AT A Bn Cn Dn DL DSn D$ En Fn Hn In Kn Mn On P Qn
Sr=n Sr? S$ T Vn Xn Z Z! +++ $ &$ %$
```

**There is no `L` and no `N`.** So `ATL` is not a command on this firmware at
all, which is the simple reason `ATL0`–`ATL3` moved nothing — not a branch
inside a handler, and not a dispatch subtlety. `T` is listed as Tone Dial, a
dial modifier, which is likewise why `ATT` did nothing.

And the listing refutes the mapping itself. `E`, `O`, `Q` and `V` are all real
commands here, yet under the base `a6685` they land on entries 4, 14, 16 and
21 — every one of them the `0x1960` reject stub. A table that rejects four
commands the firmware documents is not the main AT letter table.

**So the previous section's identification of entries 11, 13 and 19 as `L`,
`N` and `T` is withdrawn**, and with it the prediction that `ATL1` would open
the CF gate. What stands is narrower and still useful: the dispatch at `a4f63`
exists, it indexes `a6685` by *some* letter-like index, entry 19 is the
router, and entries 11 and 13 do write the two CF gate cells. What that index
actually is remains open — either the base is not `a6685`, or this table
belongs to an interpreter the ordinary AT path does not enter.

Establishing the base empirically is the way out, and the help listing is the
instrument: pick a command in the listing whose handler is identifiable in the
image, find which entry it occupies, and the offset falls out.

## Answered: it is the ampersand table, and `&L1` opens the CF gate

The shared entry `a6780` is `stc; ret` — a genuine reject — so entries 4, 14,
16 and 21 really do reject. Under `letter - 'A'` those are `E`, `O`, `Q`, `V`,
and the non-reject letters are:

```text
A B C D F G H I J K L M N P R S T U W X Y Z
```

**That is the ampersand command set.** There is no `&E`, `&O`, `&Q` or `&V`,
while `&C`, `&D`, `&F`, `&W` and `&Z` are all standard and all present here.
The board's own `ATI5` switches — `&A3 &B1 &G2 &H1 &I0 &K1 &L0 &M4 &N0 &P1
&R2 &S0 &T5 &U0 &X2 &Y1` — are a subset of exactly this list. So `a4f63`
dispatches the `&` family, not the bare AT letters, which is why `ATL` and
`ATN` reached nothing: the letters were right and the family was wrong.

That makes the three handlers:

| entry | command | what it does |
|---|---|---|
| 11 | **`&L`** — leased line | writes `[0x04f2]`, range `< 2` |
| 13 | **`&N`** | writes `[0x04f8]` |
| 19 | **`&T`** — test | the router: `AL` 0..8, **`AL=2` rejected** |

`&T`'s shape is its own confirmation. USR's `&T` takes 0-8 — end test, analog
loopback, local digital loopback, grant/deny RDL, remote digital loopback,
self-tests — and **`&T2` is unused on these modems**. The router's nine-entry
table rejects exactly `AL=2`.

### Measured on the board

```text
before     04c6=00 04f2=00 04f8=00 ...   CF gate fails
AT&L1      04c6=00 04f2=01 04f8=00 ...   CF gate PASSES
AT&L0      04c6=00 04f2=00 04f8=00 ...   CF gate fails
```

`AT&L1` sets `[0x04f2]` to `1`, and with `[0x04c6]` bit 6 clear and `[0x04f8]`
zero — both already true at rest — **the CF gate at `0x8b8a1` passes.** The
line was released and the setting restored; the board answers normally.

### What this resolves

The CF gate passing is what reaches `0x8bc06`, `mov byte [0x0d28], 6` — the
datapump overlay id — through the branch at `0x8bbf6` that does **not** consult
the three-flag discriminator. So the datapump is armed by **leased-line mode,
or by the `&T` loopback tests**, and not by anything on the ordinary dial path.

That is why every dial this project has ever run — emulated or on the board —
skipped it. [datapump-dispatch-gate.md](datapump-dispatch-gate.md) asked "which
command sets those flags, and what writes them on a real boot", and looked for
the answer along the dial. The answer is that no dial sets them: `&T1` sets
flag C, and `&L1` opens the parallel CF gate. Both are operator commands.

Two things follow, and neither needs a phone line. The emulator can be driven
through `AT&L1` before a dial and the overlay download should then occur. And
**`&T1` is an analog loopback** — the modem trains against itself — which is a
complete datapump exercise with no far end at all, and the live handshake read
that this document has wanted throughout.

## `&T` on the board: the model predicts its errors, but the flag was not caught

Two of the router's own rejections were tested directly, and both hold:

| command | board | why the model says so |
|---|---|---|
| `AT&T2` | **`ERROR`** | entry 2 of the nine-entry table at `0xa6b70` is the `stc; ret` reject — `&T2` is unused on USR modems |
| `AT&T3` | **`ERROR`** | `a6b1a` rejects `AL` 3, 6 and 7 when `[0x0237] & 1`; the board reads `[0x0237] = 01` |
| `AT&T0` | `OK` | `AL=0` dispatches at `a6b43` before the flag tests |

That `&T2` and `&T3` fail for two different, separately predicted reasons — a
table slot and a runtime flag read off the board — confirms the ampersand
identification and the router's decoding independently of `&L`.

`AT&T1` behaves like a started test: it returns **no result code at all**, and
a following `AT&T0` returned `NO CARRIER` on the first run. Entry 1 reaches
`0x876fb`, whose branch is on `[0x0237] & 4` — clear on this board — so it
should fall to `0x8770f`, `or byte [0x57c], 1`.

**No sample ever caught it.** Across two runs, `[0x057c]` and every other gate
cell stayed `00` throughout the loopback and after it.

This is not evidence that the setter does not run. `&T1` returning no result
code means the transport has nothing to synchronise on, and the test's own
serial traffic keeps the drain from settling, so the earliest sample landed
about 8 seconds in on the second run and about 20 on the first. A flag set
during test setup and cleared by it — and `[0x057c]` has seven `mov ... , 0`
clearers, three of them in this same `0x876xx` cluster — would not survive
that latency. The second run is also equivocal about whether the test started
at all, since its `&T0` answered `OK` rather than `NO CARRIER`.

So `&T1` is unresolved, and resolving it needs sampling that does not depend
on the serial transport settling — which on this hardware means it may not be
resolvable this way at all. **`&L1` remains the demonstrated route**: it sets
`[0x04f2]` immediately, deterministically, and with the CF gate passing as a
direct consequence.

## In the emulator: `AT&L1` reaches the overlay loader

Two 403 runs, identical but for one command, 150M instructions each, native
DSP in lock-step, `--nvram-fixture idsdl403`.

| | plain `ATDT6245` | `AT&L1` then `ATDT6245` |
|---|---|---|
| `[0x04f2]` | `00` | **`01`** |
| `cf-gate` `0x8b8a1` hits | 3 | 2 |
| **`set-ovl-6` `0x8bc06`** | **0** | **1** |
| **`overlay-loader` `0x8e60a`** | **0** | **1** |
| `dialed` | `6245` | `""` |
| `dsp_messages_taken` | 972 | 1 |
| exchange state | ringback | `reorder` |

Two things follow.

**`AT&L1` sets `[0x04f2]` to `1` in the emulator exactly as it does on the
board.** The firmware path is reproduced faithfully; this is not a hardware-only
behaviour.

**The overlay loader is entered for the first time in this project.** The CF
gate passes, `0x8bc06` writes `6` to the overlay id, and `0x8e60a` runs. Every
run before this one — every run recorded in
[datapump-dispatch-gate.md](datapump-dispatch-gate.md), on either image —
reached neither. The gate that document identified is real, and `&L1` opens it.

### What it does not yet do

`bootstraps` stays 1 and `call_overlay_active` stays false, so the loader was
entered but no second download completed. And the run no longer dials: leased
line mode seizes the loop and hands the modelled exchange no digits, which
ends in `reorder`. So this run opens the gate and then loses the call for an
unrelated reason.

The exchange has a mode built for exactly this — `--exchange-hotline`, which
answers on seizure with no dial tone and no digits. Pairing it with `&L1` is
the run that should carry a leased-line handshake, and it is the obvious next
measurement.

## The hotline run: the datapump starts

`--exchange-hotline` answers on seizure with no dial tone and no digits, which
is the shape leased-line mode expects. Paired with `AT&L1`, 403, native DSP,
150M instructions:

| | plain dial | `&L1` + dial | **`&L1` + hotline** |
|---|---|---|---|
| exchange | ringback | `reorder` | **`answer`, `connected`** |
| `cf-gate` hits | 3 | 2 | 2 |
| `set-ovl-6` `0x8bc06` | 0 | 1 | 1 |
| `overlay-loader` `0x8e60a` | 0 | 1 | 1 |
| **`xfer-start` `0x8e631`** | 0 | - | **2** |
| transmit samples | 66,078 | - | **350,273** |
| **nonzero** | **3,669** (DTMF bursts) | - | **291,175** |
| peak | 22,764 | - | 15,424 |

**The datapump runs.** `0x8e631` is `out 0x1e, 4`, the instruction that starts
an overlay transfer, and it fires twice. The line output stops being isolated
DTMF bursts and becomes continuous: 83% of samples nonzero across the whole
capture, against 5.5% for a dial.

A Goertzel sweep of three windows puts the energy at **1800 Hz**, with
sidebands at 1600 and 2000 — a modulated data carrier, not a tone. (That reads
the capture at the 7200 Hz codec rate this project infers elsewhere; at a
different rate the figure scales, but the signal is in the data-carrier band
either way, and nowhere near DTMF.) The first window is silent, so the carrier
starts partway in, as a handshake does.

This is the symptom [what-runs-and-what-blocks.md](what-runs-and-what-blocks.md)
opens with — "the datapump never puts anything on the line" — resolved. It
never started because nothing in a dial opens the gate, and `&L1` opens it.

### The remaining gap is now a bridge one, and it is specific

`bootstraps` stays 1 with `bootstrap_bytes` 56,656 — the resident bank alone —
and `call_overlay_active` stays false, while the final `[0x0d28]` peek reads
`00`. So the firmware starts the transfer twice and the bridge never completes
one or marks an overlay active.

That is a much better problem than the one this document started with. The
firmware side is understood end to end: `&L1` -> `[0x04f2]=1` -> CF gate at
`0x8b8a1` -> `0x8bc06` writes the overlay id -> loader at `0x8e60a` -> `out
0x1e, 4`. What happens after that `out` is the bridge's model of the download
window, which is code this project owns and can instrument directly.

## A normal dial does not arm it — measured, not inferred

`--mem-watch` records every 80186 write in a range with the PC that made it.
Run across a full 403 dial that reaches `state: connected`, `dialed: 6245`,
972 DSP messages taken, watching both the overlay id and the `[0x0d92]` cell
that gates the overlay-5 route:

| `[0x0d92]` write | PC | what it is |
|---|---|---|
| `c7e0` @1,988 | `fd229` | boot initialisation |
| `0000` @5,417,339 | `804c6` | region clear |
| `5555`, `aaaa`, `0000` @5,637,083 | `80822`, `80828`, `8082a` | the RAM test |

**`[0x0d28]` receives no write at all**, and the three `--trace-pc` probes —
`0x8b6c4` the overlay-5 probe, `0x8b7db` the overlay-5 store, `0x94d87` the
id-from-port-`0x5c` store — all report **zero hits**.

So every write to `[0x0d92]` in an entire dial happens before 5.7M
instructions and is boot housekeeping. Nothing on the dial path touches
either cell. This is the same conclusion the static reading gave, now measured
directly, and it means the question cannot be answered from an emulated dial:
**the emulator's normal dial does not arm the datapump by any route**, so
there is no arming event in it to trace.

### Where the divergence must be

`0x8b6c4`, the probe whose result selects overlay 5, has exactly two direct
callers — `0x8b799` and `0x8b7d0` — and neither runs. That is the tightest
handle available: whatever should reach `0x8b799`/`0x8b7d0` on a real call is
the divergence, and it is two addresses rather than a region.

The board is the other half of this. It connects on an ordinary dial, so on
hardware something must set `[0x0d28]`. The bench cannot read during a
handshake — `+++` aborts it, as recorded above — but `&L1` is now known to
put the board into a state that arms the datapump *without* a handshake, and
`[0x0d28]` was never sampled repeatedly while leased-line mode was active.
That is a read-only measurement this document has not made, and it would show
whether the board's overlay id behaves as the emulator's does under `&L1`.

Two honest limits on the section above this one. The `[0x0d92]` and `[0x0d28]`
writer tables were produced by raw byte-pattern search with no alignment
check, so an entry could be a pattern lying inside data rather than an
instruction. `0x94b9b` was verified by hand — `3e 80 0e 92 0d 04 c3` is a `ds:`
override, `or`, `ret`, followed by a clean routine at `0x94ba2` — and stands.
The others have not been checked that way.

## `&L1` alone is inert on the board

Sampled continuously for 20 seconds with `&L1` set, then restored.

| | `[0x04f2]` | `[0x0d28]` | `[0x0192]` |
|---|---|---|---|
| before | `00` | `00` | `0110` |
| `&L1` live, x11 over 20 s | **`01`** | `00` | **`0110`** |
| after `&L0` | `00` | `00` | `0110` |

`[0x04f2]` holds `1` for the whole window, so the command took and stayed
taken. But `[0x0d28]` never moves, and **`[0x0192]` never leaves `0110` —
the idle state measured in the trajectory run.**

That is the explanation, and it is not a contradiction of the emulator. `&L1`
selects leased-line mode; it does not itself start a connection. The board
sits idle with the setting armed until something asks it to connect. The
emulator's `&L1` runs both included a connection attempt — `ATDT6245` in one,
the hotline exchange answering in the other — and it was on that attempt that
`0x8bc06` wrote the overlay id and the loader ran.

So the overlay id is written during a *connection attempt*, in leased-line
mode as much as in a normal call. This bench route reaches the same wall as
every other: the cells move only inside the window the DTE cannot read,
because a connection attempt takes the serial port out of command mode and
`+++` aborts rather than escapes.

The line was released, `&L0` restored, and the board answers.

## Answered: a normal dial arms the datapump from the DSP, by a counter

> **Overstated, corrected below.** The counter chain in this section is real,
> but both of its feeders are gated on cells that only an extended-register
> command sets, and the board reads both as zero. So this is *a* route to
> overlay 5, not the demonstrated normal-dial route. See
> [the correction](#not-lost-in-the-asic-the-poll-is-disabled-by-default).

Tracing up from `0x8b6c4`'s two callers gives the structure, and it is not a
flag gate at all:

```text
8b79f  call 8bf74
8b7a2  mov  word [0x134], 0x2760      ; a countdown
8b7a8  mov  byte [0xb9e], 0           ; the counter, cleared
8b7ad  cmp  word [0x134], 0
8b7b2  je   8b7cb                     ; countdown expired -> the [0x0d92] probe
8b7b4  test [0x225], 0x80  / jne 8b803    ; abort
8b7bb  test [0xa7c], 0x20  / jne 8b803    ; abort
8b7c2  cmp  byte [0xb9e], 5
8b7c7  jb   8b7ad                     ; keep waiting
8b7c9  jmp  8b7db                     ; reached 5 -> overlay 5, loader
```

**`[0x0b9e]` reaching 5 is what loads the datapump overlay.** The `[0x0d92]`
probe path this document chased earlier is the *timeout* branch, taken only
when the countdown runs out first — a fallback, not the normal route.

### What feeds the counter

`0x94fdc` is a four-instruction routine: `test ah, 1`, and on that bit either
`inc byte [0xb9e]` or `mov byte [0xb9e], 0`. So it counts **consecutive**
successes, and any failure resets it. Its two callers are the answer:

```text
94dc8  in   al, 0x5e          ; the DSP reply tag, high byte
94dca  mov  ah, al
94dcc  in   al, 0x5c          ; the DSP reply data
94dce  lcall c800:0008        ; classify
94dd3  jne  94ddf
94dd5  test [0xd93], 1
94dda  je   94e00
94ddc  call 94fdc             ; AH bit 0 -> increment or reset
```

`AH` comes from **`in al, 0x5e`** — the CPU side of the DSP mailbox, the same
port pair `0x5c`/`0x5e` this project has used all along. So the supervisor
polls the DSP for status, and when the DSP reports the bit set five times in a
row, the supervisor loads the datapump overlay and dispatches it.

**A normal dial arms the datapump from the DSP, not from a command.** That is
why no AT command, no profile setting and no NVRAM fixture ever moved these
cells: nothing on the host side arms it. The DSP does, by reporting five
consecutive good statuses during the handshake.

The same module carries the corroboration. `0x94dc1` writes `mov word
[0x192], 0x5742` — `5742` is exactly the off-hook state value measured on the
board in the trajectory run — so this is the live call-progress state machine,
not a dormant path. And `0x94d87`, the other overlay-id writer, sits here too,
taking the id straight from `in al, 0x5c`.

### Why the emulator never arms

The counter is fed only from DSP replies. The bridge's replies never carry the
bit, so `0x94fdc` resets `[0x0b9e]` on every poll, it never reaches 5, and the
countdown at `[0x0134]` expires into the `[0x0d92]` probe, which also fails.
Hence `bootstraps: 1` on every dial this project has ever run.

Two conditions qualify this and want their own measurement: both call sites
are gated — `0x94ddc` on `[0x0d93] & 1` and `0x94e07` on `[0x0d92] & 1` — and
the board reads both cells as `00` at idle, so at rest neither poll feeds the
counter. Which of them a real handshake enables is not established here.

## Not lost in the ASIC: the poll is disabled by default

The natural reading of the previous section is that the DSP fails to carry the
status bit, or that the bridge loses it. The run's own counters rule both out:

| | dial run |
|---|---|
| `dsp_originated_messages` | **973** |
| `dsp_messages_taken` | **972** |
| `detector_replies` | **0** |

973 replies produced, 972 consumed. **Nothing is being lost in transit.** The
mailbox works; this project measured it against the board and fixed it months
of work ago.

What is missing is upstream of that. Both call sites that feed `[0x0b9e]` are
conditional:

```text
94dd5  test byte [0xd93], 1  / je 94e00    ; skips the first  counter call
94e00  test byte [0xd92], 1  / je 94e0a    ; skips the second counter call
```

and each of those bits has exactly one setter, both inside a parser for the
`=`/`?` extended-register syntax:

```text
a1601  cmp al, 0x3d          ; '='
a1609  cmp al, 0x30 / 0x31   ; '0' or '1'
a1614  or  byte [0xd92], 1   ; the "=1" arm
a161b  and byte [0xd92], 0xfe ; the "=0" arm
a17ff  or  byte [0xd93], 1
```

The board reads `[0x0d92] = 00` and `[0x0d93] = 00`, and the emulator's
`--mem-watch` shows `[0x0d92]` taking only boot-time writes across an entire
dial. **So in the default configuration neither poll runs at all.** The bit is
not lost; the code that would read it is switched off.

### What that costs the previous section

The counter chain stands as code — `[0x0b9e]` reaching 5 really does reach
`0x8b7db` and load overlay 5 — but it is not demonstrated to be the route a
normal dial takes, because on a default board it cannot run. Calling it "how a
normal dial arms the datapump" was more than the evidence supports, and that
section is marked accordingly.

The question is therefore still open, and the remaining candidates are the
ones the overlay-id survey named: `0x8bc8d`/`0x8bc99` inside the
discriminator-gated block, and `0x94d87`, which takes the id straight from
`in al, 0x5c`. The last is the only one needing neither a flag nor a setting.

### A separate finding worth its own look

`detector_replies` is **0** on a dial that reached `connected` with 6245
decoded off the line. The bridge synthesises runtime answers for exactly two
tags — the line detector `0x7C` and `0x54` — and the detector answered zero
times. Whether the supervisor never asked, or asked and was not matched, is
not established here, but a modelled reply path that never fires during a
successful call is worth explaining on its own account.

## The state trajectories agree, and we are blind at the same point on both sides

`--mem-watch 0192:0193` across a 403 dial, against the board's trajectory
sample:

| | board | emulator |
|---|---|---|
| idle | `0110` | `0110` @5,920,771 from `8f569` |
| off hook | `5742` | `5742` @37,867,737 and @45,790,274 from `8bf95` |
| anything after | not observable | none |

**The emulator reaches the same off-hook state the board does**, so the
supervisor's state machine is not diverging at seizure, and the datapump
question is not downstream of some larger breakage. Everything before the
handshake agrees.

It also shows how little either side tells us past that point. The emulator
writes `5742` twice and never writes `[0x0192]` again; the board's sample sat
at `5742` for the whole window too — but the board's was a `;` dial, which
attempts no handshake, and a handshake is exactly when the DTE stops accepting
`ATGLK2=`. **So neither side has been observed past the off-hook state**, on
the board because it cannot be read there, in the emulator because nothing
arms and the run has nothing further to do.

(Two writers put `5742` in that cell: `0x94dc1`, found statically in the
call-progress module, and `0x8bf95`, which is the one that actually fires
here. The static find was not the live path.)

### So what is missing

Stated honestly, from what is measured rather than what would be tidy:

* **Not the mailbox** — 973 replies out, 972 taken.
* **Not the supervisor state machine** — same two states, same order.
* **Not the tone or codec chain** — the board's DTMF is decoded by a real
  exchange, and the emulator matches after the EEPROM-offset fix.
* **Not the gate cells at rest** — identical on both, all zero.
* **Not `&L1`** — identical on both.

What is left is inside the handshake window, and the specific shape of the
gap is that **nothing tells the emulator's supervisor to load a datapump**.
The three routes that could are each shut for a reason now understood: the
discriminator flags have no reachable setter, the CF gate needs `&L1`, and the
`[0x0b9e]` counter's feeders are switched off by default. The one route that
needs none of those is `0x94d87`, which reads the overlay id out of `in al,
0x5c` — the DSP publishing its own selection.

That remains a hypothesis. It is the only candidate left standing, and it
fits, but no measurement in this document shows the board taking it.
