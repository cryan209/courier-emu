# How the datapump gets armed

The datapump used to never start. It does now, by two independent routes, and
the remaining gap is downstream of arming. This is the whole chain, in 403
addresses, with the 302 counterparts alongside.

## Answered: an answered call arms it from the DSP, in one message

On a real peer - two `courier run` instances over one line socket, A
originating and B answering, `--line-audio-only` so the bridge injects nothing
at all - the answering side carries exactly one message:

```text
0047:0007
```

**Tag `0x47`, data `0x0007`: the DSP asking for overlay 7.** Fifty-nine
instructions later the supervisor has started fetching it:

```text
94d83  ovl-from-5c   @53,010,564    in al, 0x5c -> 07, force bit 7 -> [0x0d28]
8e60f  id-after-mask @53,010,610    al = 07      (after the loader's and al, 0x7f)
8e631  xfer-start    @53,010,623    ax = bx = b000, out 0x1e, 4
```

`b000` is overlay 7's documented load address in
[dsp-overlays.md](dsp-overlays.md):

| overlay | flash range | bytes | C52 load address |
|---|---|---|---|
| 6 | `36e90..3d0f4` | 12,594 | `9d00` |
| **7** | `3d100..40b94` | 7,498 | **`b000`** |
| 8 | `40ba0..44634` | 7,498 | `dc00` |

So the chain is correct and self-consistent end to end, and none of it needs a
command, a profile setting, an NVRAM fixture or leased-line mode:

```text
peer answers
  -> the DSP sends 0047:0007
  -> 0x94d83 reads 07 off port 0x5c, forces bit 7, stores [0x0d28]
  -> loader 0x8e60a masks to 7, indexes cs:0xe741, resolves b000
  -> out 0x1e, 4 starts the transfer at 0x8e631
  -> 1874 blocks, four words each, acknowledged 1 / 2 per half-block
  -> 14,996 bytes, matching the ROM, published at b000
```

The consumer forces bit 7 to mark the id as DSP-requested for the loader's
`and al, 0x7f`; the DSP does not send it set.

`0x94d83`'s trace record carries `ret_seg 0000`, `ret_off 006d` - not a
plausible return address, which is consistent with the indirect dispatch that
defeated every static search for its caller. It is dispatched, not called.

## The second route: `&L1`, leased-line mode

`AT&L1` writes `[0x04f2] = 1`, and with `[0x04c6]` bit 6 clear and `[0x04f8]`
zero - both true at rest - the **CF gate** at `0x8b8a1` passes. That reaches
`0x8bc06`, `mov byte [0x0d28], 6`, through the branch at `0x8bbf6` that does
not consult the three-flag discriminator at all.

Measured on the board, read-only apart from the setting itself, which was
restored:

```text
before     04c6=00 04f2=00 04f8=00    CF gate fails
AT&L1      04c6=00 04f2=01 04f8=00    CF gate PASSES
AT&L0      04c6=00 04f2=00 04f8=00    CF gate fails
```

In the emulator, `AT&L1` paired with `--exchange-hotline` (answer on seizure,
no dial tone, no digits - the shape leased-line mode expects):

| | plain dial | `&L1` + dial | **`&L1` + hotline** |
|---|---|---|---|
| exchange | ringback | `reorder` | **`answer`, `connected`** |
| `cf-gate` `0x8b8a1` hits | 3 | 2 | 2 |
| `set-ovl-6` `0x8bc06` | 0 | 1 | 1 |
| `overlay-loader` `0x8e60a` | 0 | 1 | 1 |
| **`xfer-start` `0x8e631`** | 0 | - | **2** |
| transmit samples | 66,078 | - | **350,273** |
| **nonzero** | **3,669** (DTMF bursts) | - | **291,175** |
| peak | 22,764 | - | 15,424 |

The line output stops being isolated DTMF bursts and becomes continuous - 83%
of samples nonzero against 5.5% for a dial. A Goertzel sweep of three windows
puts the energy at **1800 Hz** with sidebands at 1600 and 2000: a modulated
data carrier, not a tone. (That reads the capture at the 7200 Hz codec rate
this project infers elsewhere; at another rate the figure scales, but it is in
the data-carrier band either way and nowhere near DTMF.) The first window is
silent, so the carrier starts partway in, as a handshake does.

## Where the three flags actually come from

The discriminator at `0x8b88d` tests three flags, and the long search for what
sets them has an answer: **operator commands, not the dial path.**

The handler table at `0xa669b` is the **ampersand** command family, not the
bare AT letters - which is why `ATL` and `ATN` reached nothing. The shared
entry `a6780` is `stc; ret`, a genuine reject, and the non-rejecting letters
are `A B C D F G H I J K L M N P R S T U W X Y Z` - exactly the ampersand set,
with no `&E`, `&O`, `&Q` or `&V`, and the board's own `ATI5` switches are a
subset of it.

| entry | command | what it does |
|---|---|---|
| 11 | **`&L`** - leased line | writes `[0x04f2]`, range `< 2` |
| 13 | **`&N`** | writes `[0x04f8]` |
| 19 | **`&T`** - test | the router: `AL` 0..8, **`AL=2` rejected** |

`&T`'s shape is its own confirmation: USR's `&T` takes 0-8 and `&T2` is unused
on these modems, and the router's nine-entry table rejects exactly `AL=2`.
Tested on the board:

| command | board | why the model says so |
|---|---|---|
| `AT&T2` | **`ERROR`** | entry 2 of the table at `0xa6b70` is the `stc; ret` reject |
| `AT&T3` | **`ERROR`** | `a6b1a` rejects `AL` 3, 6 and 7 when `[0x0237] & 1`; the board reads `[0x0237] = 01` |
| `AT&T0` | `OK` | `AL=0` dispatches at `a6b43` before the flag tests |

So `&T1` sets flag C and `&L1` opens the parallel CF gate. Both are operator
commands, and **`&T1` is an analog loopback** - the modem trains against
itself, a complete datapump exercise with no far end and no phone line.

The router is reached through a RAM function pointer, not a direct branch.
`[0x03ff]` is called at `0x90ef1` and at `0x92004` (immediately after
`out 0x1c` / `out 0x1e`, the ASIC mailbox commit) and written from about
eighty-eight installer sites, one of which is:

```text
910c6  cli
910c7  mov word ptr [0x3ff], 0x1cde     ; = a4e2:1cde = a6afe, the router
910cd  mov byte ptr [0x403], 0x64
910d2  mov word ptr [0x192], 0x1cca
910d8  sti
```

Nothing branches to `0x910c6` either, and that is not the anomaly it looks
like: only 19 of the 87 installer sites have any direct branch to them at all.
Indirect dispatch is this family's norm.

## The 302/403 address map

Scanning both images for the discriminator's shape - `test byte [imm16], 2`
then two `test byte [imm16], 1` and a `ret` - gives exactly one counterpart,
at `+0x3e` from the 302 site. The CF gate and the overlay loader follow
immediately after it in both images, in the same order.

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
| thunk stubs, stride 4 | `0x875d8` | `0x87622` |
| entry 1 handler | `0x876b1` | `0x876fb` |
| the setter it reaches | `0x876c5` | `0x8770f` |
| indexed jump | `0xa6ad7` | `0xa6b69` |
| jump table, nine entries | `0xa6ade` | `0xa6b70`, CS `a4e2` |
| router entry | `0xa6a6c` | `0xa6afe` |
| decimal parser | `8000:9cbc` | `8000:9ce7` |
| handler-offset table | `0xa6615` | `0xa669b` |
| rejects `AL=1` when set | `[0x0ea7]` | `[0x0d93]` |

Flag B cross-checks independently: the unrelated routine at 302 `0xa5602`
tests `[0x5a5] & 2`, and its 403 counterpart at `0xa562d` tests `[0x49e] & 2`.
The 403 loader confirms the map by its own contents - it reads `[0x0d28]`,
compares against 6, rewrites the cell as 8, indexes a six-byte-stride table at
`cs:0xe741` and starts the transfer with `out 0x1e, 4`, instruction for
instruction the 302 loader with `[0x0e3c]` and `cs:0xe711`.

## The overlay id has six writers, and three ignore the flags

| site | write | reached by |
|---|---|---|
| `0x8bc06` | `6` | the **CF gate** returning carry - not the discriminator |
| `0x8bc8d`, `0x8bc99` | `6`, `7` | inside the discriminator-gated selection block |
| `0x8b7db` | `5` | gated only on `[0x0d92] & 4`, outside both |
| `0x8e616` | `8` | the loader itself, chaining `6` to `8` |
| `0x94d87` | `al` | **`in al, 0x5c` then `or al, 0x80`** - the DSP-requested route |
| `0x8e73a` | `0` | teardown |

## The counter route exists and is disabled by default

There is a third structure, and it is worth knowing about because it looks like
the answer and is not. `[0x0b9e]` reaching 5 loads overlay 5:

```text
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

`0x94fdc` feeds it - `test ah, 1`, then either `inc byte [0xb9e]` or
`mov byte [0xb9e], 0` - so it counts **consecutive** successes, with `AH` from
`in al, 0x5e`, the DSP mailbox. The corroboration is in the same module:
`0x94dc1` writes `mov word [0x192], 0x5742`, and `5742` is exactly the off-hook
state value measured on the board, so this is the live call-progress state
machine.

**But both of its call sites are gated** - `0x94ddc` on `[0x0d93] & 1` and
`0x94e07` on `[0x0d92] & 1` - and the board reads both cells as `00`. On the
two-instance link, side A polls `0x5e`/`0x5c` 536 times at `0x94dc8` and never
calls `0x94fdc` once. So the poll is disabled by default and this is *a* route
to overlay 5, not the normal one. The `[0x0d92]` probe the earlier chase
followed is the countdown's **timeout** branch, a fallback.

## Measured on the board: all seven gate cells are zero at idle

Read 2026-09-09 from the Courier on `/dev/cu.usbserial-11420`, ID_SDL 4.03d,
command mode, read-only, two passes with identical page hashes:

| `098a` | `049e` | `057c` | `04c6` | `04f2` | `04f8` | `0d28` |
|---|---|---|---|---|---|---|
| `00` | `00` | `00` | `00` | `00` | `00` | `00` |

The pages are live rather than a failed read - `0400`, `0900`, `0c00` and
`0d00` carry 51, 54, 60 and 15 nonzero bytes, and `0cd9`/`0cdb` read
`32c8`/`0c08`.

**This kills the provisioning hypothesis for this gate.** The tone-gain cells
were populated on a board that had them and blank in an emulator that did not
([datapump-dispatch-gate.md](datapump-dispatch-gate.md)). These are blank on
the working board too, so they are not stored settings the emulator fails to
supply. They are set by command, or not at all.

[Capture](../artifacts/datapump-gate-403-cells/cells.json),
[script](../artifacts/datapump-gate-403-cells/read-cells.py).

## What remains

Two stand-ins under the working download, both recorded in
[dsp-overlays.md](dsp-overlays.md):

- the `0x1e` readiness bits answer all-ones, so the transfer never waits;
- `load_program` bypasses whatever C52 code receives an overlay while the
  resident runs.

And `call_overlay_active` is still false on the `&L1` hotline run, where
`bootstraps` stays 1 - that route reaches `out 0x1e, 4` twice and no second
download completes, where the DSP-requested route now does. Whether the two
should converge on one transfer path is not settled.

## Ruled out - do not re-run these

**"Nothing indexes that table, so the gate is on a dead path."** Reached twice,
independently, on both images, by searching only for *direct* references - an
indexed `jmp`/`call` using the table's displacement, a far pointer, an
immediate load of its address. This firmware dispatches through RAM function
pointers; the search was too narrow both times. Reproducing a negative on a
second image made it look like a property of the firmware rather than of the
method.

**Reading `ATN` as the arming command.** The 403 `7b`/`7c` consumers reach a
rate-index request through operation `0054`, not any of these flags. The shared
shape of the two decimal command parsers is about method, not about this gate.

**`0008:0885` as the overlay request.** That reading reasoned from `0x85` being
`0x80 | 5` and from the consumer's `or al, 0x80`. The correspondence is a
coincidence; the request is `0047:0007` and the consumer sets bit 7 itself.

**A probe placed before the store.** `0x94d83` fires before its `in al, 0x5c`
executes, so the `al = 47` it records is stale, not the id. Probe `0x8e60f`,
after the loader's `and al, 0x7f`.
