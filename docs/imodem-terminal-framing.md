# I-modem terminal failures: AT framing is bypassed

Confirmed against `Ie030002.nac` on 2026-09-12, using the existing
`flashnvram.sav` read-only, external product type, and no DSP execution.
Before the fix, the `--terminal` route delivered the literal `AT` prefix to a
parser that expects the command body. It also missed the new-command reset.
Together these explain both the missing/`NO CARRIER` result and old commands
being executed again.

This supersedes the earlier explanations in [imodem-at-interface.md](imodem-at-interface.md)
that attributed these symptoms to missing capability data or typing speed.
There may still be configuration and hardware gaps, but neither a new
configuration record nor an active ISDN line was needed to obtain correct
responses in the controlled experiment below.

## Why AT produces silence or NO CARRIER

`interactive_pump` passes the whole typed line through `send_serial` to SIO0.
At idle the RX dispatch word `2600:e834` selects `a400:ec8d` (`0xb2c8d`).
That handler reads RBR and calls `[c922]`, which is `0x8b3e`: the command-body
collector at `0xacb3e`. It masks parity but does not recognize an AT prefix.

The raw ATI trace reaches the parser at `0xcbb90` with length 3 and buffer
`ATI`, where length 1 and buffer `I` are needed. The ordinary command table
dispatches the leading `A` to `0xcc564`, the answer-call handler. Its write
at `0xcc5ac` sets `[d16f]` bit 0. The following `I` still prints `USR009F`,
which makes the command appear to have worked.

At completion, `[d16f]=1` sends the parser through `0xcc182`, returning carry
set. The caller branches from `0xac74f` via `0xac764`, `0xac4eb`, and
`0xac52f` into call handling. Eventually `[c922]` becomes `0x0e0e`, the
keypress-abort receiver at `0xa4e0e`. A bare AT has no diagnostic text to
print and can therefore appear silent while waiting in this state.

The next input aborts the unintended call, setting `[d08b]=0x17` (keypress
abort). The result emitter at `0xacf8c` receives code 3 and prints
`NO CARRIER`. Input during this transition can be discarded. This is an
actual call-state transition, not a display or UART-output duplication.

## Why the old model code keeps coming back

The command length at `2600:e49a` is not reset on CR. The collector increments
it as characters arrive and terminates the buffer at `2600:e49b` on CR.
Resetting the length belongs to recognition of a new AT prefix.

The stock route skips that recognition, so subsequent accepted input appends
to the previous command body. Old `I` and `Y11` commands are parsed again.
In a raw run with **20 million instructions between lines**, ATY11 produced
the previous `USR009F` before its own heading; the following accepted ATI3
repeated both old reports before printing its banner. Waiting longer does not
reset this buffer.

Removing AT from the input is only a partial workaround: an empty line and
`I` then produce genuine OK result codes, but later `I6` and `Y11` still
re-execute accumulated commands. Prefix recognition and the buffer reset are
both necessary.

## Controlled validation

The firmware already contains an external UART prefix handler:

* `0xb3596` recognizes A, masking parity/case with `and al,0x5f`.
* `0xb35aa` recognizes T, and also handles the A/ repeat form.
* `0xb35e6` clears `[e498]` and **`[e49a]`**, selects the body collector,
  and switches RX dispatch back to `0xec8d` for the command body.

For diagnosis only, a code hook at `0xc7bf1` (after reception is armed)
selects this existing handler by writing `0xf596` to `2600:e834`. The
experiment changes this RAM dispatch word; it does not patch firmware code,
force result codes, change the configuration, inject recovery lines, or
filter transmitted output.

| Typed, consecutively in one boot | Firmware output |
|---|---|
| AT | OK |
| ATI | USR009F, then OK |
| ATI6 | Link diagnostics, No Connection, then OK |
| ATY11 | Freq / Level heading, then OK |
| AT | OK |

All five calls to the result emitter receive code 0. The disconnect cause
stays 0. There are no stale reports. The buffer lengths at result emission
are 0, 1, 2, 3, 0 respectively, containing the new command bodies.

The emulator now models that missing external-board selection at `0xc7bf1`,
the boundary where command reception has been armed. It writes `0xf596` to
the firmware's RX dispatch word and otherwise leaves prefix recognition,
buffer reset, body collection, parsing, and result emission to the firmware.
The selection is limited to the external product; the internal product keeps
its distinct input path.

With the input path fixed, `scripted_pump` no longer injects recovery lines or
suppresses stale output. Scripted and interactive sessions now deliver the
same literal terminal traffic.

## Evidence and reproduction

[Saved traces](../artifacts/imodem-terminal-diagnosis/README.md) include the
raw call-state transitions, the parser's carry-set return, the suffix-only
control, and the successful external-prefix-handler experiment.

From the repository root:

```sh
.venv/bin/python artifacts/imodem-terminal-diagnosis/probe.py \
  --mode raw --output /tmp/imodem-raw.json
.venv/bin/python artifacts/imodem-terminal-diagnosis/probe.py \
  --mode prefix-handler --output /tmp/imodem-prefix.json
```

The probe reads the local NVRAM file and never saves it. Raw and suffix modes
explicitly restore the former body-receiver selection so the original failure
remains reproducible after the production fix; prefix-handler mode exercises
the corrected selection.
