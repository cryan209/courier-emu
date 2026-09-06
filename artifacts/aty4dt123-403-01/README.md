# ATY4DT123 on emulated 403

Ran the exact command `ATY4DT123` for 80,000,000 supervisor instructions,
with the recovered boot ROM, board ID 7, fixture EEPROM, a 5 ms tick and a
behavioral dial-tone DAA. No physical modem or external call was used.

Serial response:

```text
CALL PROGRESS
```

The firmware consumed the entire command, asserted the panel's hook relay at
instruction 37,704,462, and sent the DSP's tag-13 tone-selector commands
`0013:0001`, `0013:0002`, `0013:0003`, once each. These match digits 1, 2 and 3
in the recovered 3.1.2 tone-selector mapping.

The run ended at its instruction limit, with no CONNECT or terminal failure
response. The DSP remained active with no error and zero ROM holes.

The panel reports off-hook, but the behavioral DAA remains idle/on-hook with
zero generated samples. Thus the configured dial-tone source did not reach the
line model on this ROM path. The bridge's `dial_digits` summary is also empty;
the firmware mailbox trace, not that helper field, is the evidence for the
three requested digits. This run does not establish emitted DTMF audio or a
working connection.

`report.json` contains the full run; `serial.txt` has parity-decoded output.
Reproduce from the repository root with:

```sh
.venv/bin/python artifacts/aty4dt123-403-01/run.py
```
