# Undocumented modem commands in the Sportster upgrade FAQ

The supplied Robert Aghababyan FAQ revision 1.15 lists `ATNn`, `ATNL` and
`ATNX`. Its descriptions are historical leads, not instructions to execute.
The saved HTML is already an English translation, despite its KOI8-R header.
This analysis follows the actual captured ID_SDL 4.03d supervisor 7.4.16 /
DSP 3.1.2 image. No commands were sent to the physical board.

## The useful correction: ATN is a manual rate-change request

The FAQ calls `ATNn` a DSP procedure call. On our image it is a supervisor
event injection, with consumers that request a change in the current rate
index. It is not an arbitrary DSP subroutine-number interface.

The normal command table at file `0x250cc` sends `N` to `0x250e8`, which
far-calls `8000:83a2`. The numeric handler at `0x8458` parses a decimal byte:

| Input | AX handed to the supervisor event dispatcher |
|---|---|
| `ATN0` | `007c` |
| `ATN1` | `017b` |
| `ATN7` | `077b` |
| `ATN255` | `ff7b` |
| `ATN256` | No dispatch: numeric overflow |

AL is the event code and AH retains the argument. The handler sets byte
`[0x0a16]=1`, then calls `8f46:32fb` (file `0x1275b`). That wrapper calls
`8f46:00f4` (file `0xf554`), which invokes the current supervisor state via
`call word [0x0192]`. It does not send `n` as a DSP mailbox tag.

State tables at `0x123b1`, `0x132cb` and `0x13f48` have consumers for events
`7b` and `7c`. In the last family:

- `7c` reaches `0x1401b`, then `0x14414`: with the manual flag set, take
  `[0x02b4] - 1` as the requested index.
- `7b` reaches `0x14078`, then `0x1442d`: with the manual flag set, take
  `[0x02b4] + 1` as the requested index.
- Common code clears the manual flag, checks allowed-index masks and saves
  the accepted request in `[0x0a25]`. The caller sends operation `0054`
  through the regular queue helper with this value in BX.

This supports **manual fallback / fall-forward** as the practical meaning
in those connection states. Zero selects down; a nonzero argument selects up.
The examined consumers do not treat `7` as procedure 7 or an absolute target
rate. Which states accept the event, which modulation is active and whether
the requested index is allowed determine its effect. An idle `OK` would not
prove a DSP action. A live-call rate-change capture remains unmeasured.

The `7b/7c` numbers here are supervisor event codes. They must not be confused
with identically numbered DSP outbound messages or nonexistent inbound
dispatch-table entries; see [the earlier table-boundary correction](who-produces-the-events.md).

## ATNL: a fixed programmed-I/O transfer, not a dump command

The branch at `0x83b7` recognizes `L`. The code at `0x83bf..0x8457`:

1. Disables interrupts, programs `[ffa4]=e000`, saves `[ff18]`, and sets
   `[ff18]=0010`.
2. Reads ports `c2/c0`, polls bit `0010` of the integrated peripheral register
   at `ff0e`, and sends header `0f3f` through `c4/c6`.
3. Selects CPU segment `e000`, offset zero, and loops `1554` hex times.
4. Consumes three source bytes per iteration and repacks them into two pairs
   of six-bit values (`and ...,3f3f`). Each pair is written to `c4/c6`, with
   readiness polling and reads from `c2/c0` between transfers.
5. Restores DS and `[ff18]`, calls `0x06fd`, restores flags and returns.

That is **5,460 iterations, 16,380 source bytes and 10,920 packed transfers**
after the header. The FAQ's “10K” is a loose description; its “DMA?” is not
how this implementation moves the bytes. The CPU explicitly loads, shifts,
polls and outputs each value. Output is through `c4/c6`; `c0/c2` are read.

The physical recipient and source-bank contents after the mapping write
have not been established here. A legacy download/test interface is a
plausible interpretation, not a measured identification. This is not the
verified `40..4e`/`50..5e` parallel DSP download path, accepts no arbitrary
source address, and does not return DSP memory over the serial terminal.
It also has readiness loops without a software timeout.

## ATNX: restart

At `0x83a6`, suffix `X` sets bit 0 of `[0791]`, clears BP, disables interrupts
and jumps to supervisor restart entry `8000:0480`. That entry reinitializes
segments and stack and clears RAM. This verifies the FAQ's broad “boot start”
description. It does not establish an NVRAM-save operation or a DSP entry-point
argument. The older configuration recipe calling it “save changes” should
not be read as proof that this handler writes NVRAM.

## The rest of the FAQ, and relevance to our DSP work

| Commands | Meaning / current evidence |
|---|---|
| `ATG=` / `ATGR` | Supervisor CPU memory dumps in bytes / words. Verified in this project; CPU addresses are not DSP data/program addresses. |
| `ATGI` / `ATGO` / `ATGB` | CPU I/O read, write and sweep. These are the useful primitives for the verified DSP mailbox. |
| `ATGW` | RAM write. Our ID_SDL extension supports byte or word writes depending on hex digit count, beyond the FAQ's byte-only description. Used by the successful RAM probes. |
| `ATGU`, `ATGBOOT5` | Historical claims / unknown semantics in this analysis. Do not infer that BOOT5 is a RAM-code execution command. |
| `ATY4` (historically `Y24`) | Call-progress diagnostic mode; already traced in our firmware. |
| `ATY7`, `ATY9` | FAQ describes connected-call analog statistics / 255 unidentified values. Exact fields and applicability to 4.03d are not established by that list. |
| `ATY5`, `ATY6` | FAQ describes an LED self-test and an ATI6-like report. Version-dependent historical descriptions. |
| `ATY14`, `ATY15` | Configuration and current DIP-switch report; already identified in the repo. |
| `ATUSR`, `ATRS99?`, `ATI92`, `ATI99` | Credits/copyright/date according to the FAQ; no direct DSP access implied. |
| `AT!E`, `AT&J`, `ATZ` variants | Calling-tone control, uncertain jack selection, and reset variants according to the FAQ. Not DSP memory primitives. |

For actual DSP observations, our already traced `ATY12` buffered receive /
transmit report and mailbox streamers are more direct than the new `ATN`
lead. See [ATY diagnostics](at-y-diagnostics.md),
[RAM delivery](ram-probe-delivery.md), and the
[recent measured NDX probe](dsp-mailbox-board-fix.md).

## Evidence and limits

### Remaining command mapping, and a newly verified G queue form

**Update:** this form has now been measured on the board with alternating
query replies and queue readback. See [ATG DSP command format](atg-dsp-command.md)
for the verified syntax, capture and reply retrieval. The paragraph below
records the initial offline finding.

There is no complete semantic inventory of the command parser yet. The
most relevant newly traced form is **`ATGhhhhdddd`**, exactly eight hex
digits after G: first a command word, then a data word. At `0x25c5b` the
handler selects this form by remaining length, parses two four-digit words,
puts the first in AX and the second in BX, and calls `8f46:01e4`.
File `0xf644` forwards this to `0xf678`, which queues three words:
`ff00`, AX, BX. This is the same queue helper used by normal supervisor
command/data requests. It provides a candidate direct AT route into the
DSP transmit path, without individual ATGO staging writes.

`g-queue-check.py` executes that path from the captured ROM with an empty
synthetic queue. The deliberately artificial input `ATG00541234` yields
`ff00 0054 1234` in order and advances the queue head by six bytes. The test
stops before transmission: no real-board delivery, response handling or
full-queue behavior has been verified. The example's data is a parser test,
not a recommended hardware request. The helper also does not wait for space
when the queue is too full, so successful parsing alone cannot prove delivery.

Still worth mapping:

| Form / area | What is known | What remains |
|---|---|---|
| Four-digit and shorter numeric `ATG` | Different code paths through `1ef1` or `1eed`; the latter stages an AL byte when enabled. | Exact user-facing semantics, prerequisite state and delivery behavior. |
| `ATGN` | Sets bit 0 at `[0158]`. | All consumers of this enable flag and its relationship to configuration writes. |
| `ATZ!` | Stores `80` at `[049b]`, then returns. | Downstream meaning and reconciliation with older notes calling it a reset. |
| `ATNL` | Fixed packed transfer traced above. | Physical recipient and mapped source contents. |
| `ATY7` / `ATY9` | Historical analog/statistics descriptions. | Exact 4.03d applicability, fields and DSP producers. |
| ID_SDL extension selectors | Some are documented in the Russian ID_SDL manual; others have only partial code traces. | Complete command-to-handler-to-state-effects inventory. |

The resident `ATGU` branch itself is just `clc; ret` at `0x25ce6`; it performs
no operation there and does not consume U. That does not establish the final
whole-command response. There is no reason to label it a DSP operation.

The ID_SDL `AT+S` family is already partly mapped, including DTMF levels;
see [extended registers](idsdl-extended-registers.md). Missing from ordinary
AT help is not the same as unknown to this project.

### Follow-up: ATG? and ATZ variants

The FAQ's `? - some more secret commands :)` is not evidence of a literal
help command. In captured 403, `ATG?` finds no matching selector in the
extension or resident G handler. The generic path at `0x25c7a` parses zero
hex digits from `?`, obtains AX=0, leaves the question mark unconsumed and
calls `8000:1eed`. It does not display a command list. The isolated check
stops at that call, so no final serial response is claimed.

For comparison, the [USR Sportster Windows X2 manual](https://ads.usr.com/support/s-win/s-win-docs/winx2.pdf)
documents Z0 as the selected reset profile, Z1/Z2 as stored profiles 0/1,
and Z3/Z4/Z5 as factory profiles &F0/&F1/&F2 respectively. That mapping is
**not implemented by the Z handler in our captured 403 image**.

Our command table selects file `0x2631c` (`a4e2:14fc`). Except for suffix
`!`, it goes directly to restart `8000:0480` with BP=2 or 3, selected by
bit 7 of existing byte `[049d]`. It never parses a numeric suffix. Isolated
execution of bare Z and Z0 through Z5 confirms the same restart entry and
BP=2 with that bit clear; every numeric suffix is still unconsumed.
These are equivalent reset requests on this image, not six profile choices.

There is a separate `ATZ!` branch: it writes `[049b]=80` and returns without
resetting. Its downstream significance is not established here.

The reproducible `g-z-check.py` and `g-z-results.json` in the artifact
directory record these checks. They stop before restart or the G fallback
call; nothing was sent to the board.

[Artifacts](../artifacts/undocumented-atn-analysis/provenance.json) include the
ROM SHA-256, selected disassembly and a reproducible isolated-handler check.
The check runs real captured instructions and stops at state dispatch,
restart or transfer entry. It verifies decoding, not downstream hardware
behavior. The full serial harness attempt exhausted its instruction budget
before completing even `AT`; it supplies no acceptance/rejection result.
No emulator core or board settings were changed.

Source: the supplied
[Sportster FAQ](<x2/US-Sportster Upgrade FAQ. Frequently asked questions.html>),
section “Undocumented Teams” (translated heading for undocumented commands).
