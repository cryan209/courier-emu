# I-modem terminal diagnosis, 2026-09-12

See [the diagnosis](../../docs/imodem-terminal-framing.md).

All runs used local `Ie030002.nac`, the existing `flashnvram.sav` loaded
read-only, default external enclosure, no DSP execution, and unfiltered
serial output with the parity bit removed for readability.

* `raw-session.json`: AT, ATI, ATI6, ATY11, AT, ATI3, AT, spaced by 5M
  instructions after a 5M warmup. Shows the unintended keypress abort.
* `spaced-session.json`: ATI, ATI6, ATY11, AT, ATI3 at 20M intervals. Shows
  aborts and accumulated old diagnostics even with widely spaced input.
* `route.json`: one ATI command; parser entry, buffer contents, `[d16f]=1`,
  carry-set return, and the branch into call handling.
* `suffix-session.json`: CR, I, I6, Y11, CR at 20M intervals. Shows that
  removing the prefix produces OK but alone does not reset the buffer.
* `prefix-handler-session.json`: AT, ATI, ATI6, ATY11, AT at 20M intervals
  with the diagnostic external RX handler selection. All five return OK.
* `verified-responses.json`: the successful experiment's output grouped by
  command. Checked for five OK result codes, a zero disconnect cause, and
  absence of old diagnostic reports in later responses.

`probe.py` reproduces a five-command session in legacy raw, suffix-only, or
prefix-handler mode. Run it from the repository root; use `--help` for its
arguments. Since the normal emulator now selects the prefix handler, the raw
and suffix modes deliberately restore the former body-receiver dispatch for
comparison. The saved traces predate the production fix.

The JSON event count `n` is the guest instruction count. Addresses in
`state`/`mem` are offsets within segment 2600; write-hook `address` and `pc`
values are physical addresses. State bytes are hexadecimal in memory order.
