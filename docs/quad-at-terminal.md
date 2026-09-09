# Quad QF060003: measured AT terminal execution

On 2026-09-10 the QF modem firmware produced `OK` for `AT`, rejected an
unsupported command with `ERROR`, and accepted another `AT` afterwards.
This is an **opt-in CPU byte-terminal adapter**, not completed physical Quad
DTE/autobaud or DSP emulation.

Run from the repository root:

```sh
PYTHONPATH=. .venv/bin/python tools/probe_quad_at.py
```

For a shorter sequence:

```sh
PYTHONPATH=. .venv/bin/python tools/probe_quad_at.py \
  --command ATQ0V1 --command AT
```

The probe boots the original `docs/x2/Qf060003.zip` controller with `QuadBoard`
for eight million instructions, flushes the selected-channel memory, and
boots channel 0 from its firmware-loaded reset stub. It then runs that modem
for twelve million instructions with `tick_ms=5` and `quad_terminal=True`.
It does not depend on previously dumped flash or RAM artifacts. The resulting
modem flash SHA-256 is
`86e8d044ad162087283d5478398d59b9dbaa3df0f9dc84eb1aeab8feb635ce41`.

## Measured transcript

| Input | Firmware response |
| --- | --- |
| `ATQ0V1` | `OK` |
| `AT` | `OK` |
| `AT+NOTACOMMAND` | `ERROR` |
| `AT` | `OK` |

`ATQ0V1` configures normal word results through the firmware's own command
parser. The adapter does not change the quiet/verbose settings. The complete
28-byte input reaches the serial receive ISR at `0xc11b0` exactly 28 times,
the attention detector at `0xcfc6d` four times, and the command dispatcher
call at `0xc97a9` four times. The final dispatcher is idle (`[0x81f8]=0x91e6`),
and no input remains queued.

Raw `S0TBUF` output, including the earlier binary startup marker:

```text
55 aa 00
8d 0a cf 4b 8d 0a
8d 0a cf 4b 8d 0a
8d 0a c5 d2 d2 cf d2 8d 0a
8d 0a cf 4b 8d 0a
```

The terminal decodes seven data bits: QF includes parity in bit 7 of these
register writes. The report preserves raw bytes separately and excludes the
startup marker from `terminal_text`. No emulator code synthesizes `OK`,
`ERROR`, an AT command buffer, or a completed-command event.

Results: `artifacts/quad-at-20260910/results.json`. Regression:

```sh
.venv/bin/python -m pytest -q tests/test_quad_terminal.py
```

The regression checks the full fresh-boot transcript, ISR and dispatch counts,
queue drainage, return to idle, and rejection of an unknown firmware layout.

## Exact adapter boundary and remaining work

The ordinary byte harness did not exercise QF's raw-pin autobaud sequence.
Its initial serial receiver is disabled while timer/INT1 handlers sample
Port 2 pin 5. A longer unadapted run still produced only `55 aa 00` and left
`AT` unread; treating that marker as an AT response would be wrong.

`courier_emu.quad_terminal.QuadTerminal` explicitly substitutes the fixed-baud
byte front end. It verifies signatures for the recovered QF modem layout,
waits until its real command scheduler is idle, and installs the contract
seen at QF `0xe51be` and `0xcfc5f`:

- receive vector `c041:0da0` (physical `0xc11b0`);
- attention callback `[0x81f4]=0xf85d` (physical `0xcfc6d`);
- byte-receive mode `[0x8988]=2`, `S0CON=0x21`;
- masked INT1 and disabled autobaud timers 1 and 2.

It delivers input through `EbSerial` and the firmware-installed interrupt
mechanism. At each new command it restores only this receive contract, never
forces the command scheduler idle, and waits while the previous command is
processing. The firmware owns collection, dispatch, command effects and UART
output. The mode is off by default and rejects unsupported layouts, including
QR; it must not be confused with a verified hardware register-only bring-up.

DSP mailbox execution, physical baud timing, Quad DIP/DTR/NIC wiring, and
simultaneous operation of the four modem CPUs remain incomplete. Existing
open-bus DSP responses and the explicit 5 ms scheduler tick are still harness
assumptions. The CPU reaches its command scheduler but repeatedly downloads
DSP code because there is no functioning Quad DSP peer. This test establishes
usable CPU-level AT parsing and replies; it does not establish calls, audio,
or a complete Quad hardware model.
