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
