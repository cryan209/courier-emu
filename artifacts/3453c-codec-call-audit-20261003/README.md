# 3453C codec and hook-control audit

The 2.3.33 firmware uses the Si3034 for considerably more than PCM. It also
controls line-side power, external hook-pin enable, country termination,
calibration/current limits, DTMF headroom, gain/mute and diagnostic loopback.
The supervisor's GPIO path and the DSP's serial codec path are separate.

This audit uses the unmodified `2_3_33.XMF`. Hardware wiring conclusions below
are qualified where the emulator inherits measurements from another board.
The register definitions come from [the local Si3034 revision-2.02
datasheet](../../docs/SI3034.PDF), registers 1–19. Addresses below are physical
80186 byte addresses or C52 program-word addresses, as indicated.

## DSP command decoder

[codec-control.asm](codec-control.asm) contains the original resident and
low-overlay instructions. Stock dispatcher `12B1` uses the table at `130D`.
The following are capabilities recovered statically; not all were exercised
by this dial attempt.

| Host tag | DSP handler | Codec action |
| --- | --- | --- |
| `7D` | `1275` | `(data & 00EF) + 1000`: write register 16, forcing IIRE clear |
| `82` | `127C` | `(data & 00FF) + 1100`: write register 17 |
| `83` | `1283` | `(data & 00FF) + 1200`: write register 18 |
| `84` | `126D` | Send the supplied raw secondary control; bit 13 selects read |
| `7F` | `0042` | Data 1 sends `0610` (line-side power down); other values send `0502` and select `0102` isolation loopback or `0201` RX/hybrid configuration through conditional execution |
| `81` | `005C` | Send `31FF`, a register-17 read, and mark a pending reply |
| `80` | `1292` | Poll the pending identity/register-read result; corresponding replies use `7B`–`7E` |

Thus **tag 82 is not the older-family ASIC start/hold register**. Register-17
bit 6 is MCAL (manual calibration). The emulator now records this command
without creating the older call engine's synthetic `02`/`03` replies. Its
older `line_enable`, `engine_hold`, `start_strobe` and `ring_indicate`
interpretations are reported as null on this board, with
`command_protocol: si3034`.

The DSP serial helper at `112B` queues a control word in data cell `006C` and
sets `006B`. The primary ISR requests the secondary frame; the secondary ISR
writes the control word and samples its reply before returning to primary
PCM. These are actual DSP instructions, rather than host codec setup.

## What the firmware programs

Resident initialization sends `0100, 0203, 0502, 0670, 0704, 083F, 0911,
0A00, 0D00, 0660` through the serial helper. Notable effects:

- `0502` enables the **external off-hook pin** (OHE), with software OH clear.
  The codec can also assert hook through register-5 OH independently, but
  this attempt does not do that.
- `0670 -> 0660` clears PDL after clock setup. Registers 7–10 set the PLL.
  The existing nominal 2.88 MHz MCLK produces 7,200 Hz with these values.
- `0203` enables receive and the transmit hybrid. Register 1 exposes
  isolation digital loopback; register 2 exposes analog loopback. Register
  15 provides separate gain and mute controls. These are codec capabilities;
  this run does not exercise every mode.
- Country commands observed on the host bus are `7D:002C`, `82:00B8` and
  `83:0002`. They become registers 16=`2C`, 17=`B8`, 18=`02`.
  Documented bits select complex AC termination, TBR21 DC termination,
  automatic-calibration disable, TBR21 current limiting and full-wave ring
  detection. Register-18 DIAL can increase DTMF headroom, but it is clear
  in this run. The register-17 `80` bit is reserved in this datasheet;
  retain the firmware's value without inventing its purpose.
- Raw commands `84:1468` and `84:1408` access register 20, which this
  datasheet does not document. Their physical effect remains unknown.
- Initialization also writes DSP-side ASIC ports `8068..806C` with
  `000F,0002,0000,0078,0901`. This establishes another external setup path;
  the register names and electrical effects are still unverified.

Ring status is available in register 5; isolation-link/frame detect and loop
current are available in register 12; revision IDs in 11/13. **No native
codec register read occurs in the failing pair run**, so missing Si3034
status readback is not the immediate trigger seen here. Calibration timing,
loopback behavior, electrical termination and sticky ring state still need
more complete emulation.

## GPIO hook sequence and watchdog abort

[supervisor-control.asm](supervisor-control.asm) and the bounded
[dial-hook-trace.txt](dial-hook-trace.txt) recover the supervisor side.

The generic latch routines at `5A8B9` and `5A8EE` select ports `10`, `12`,
`14` through CS table `2D75`, maintaining shadow bytes at `0675` onward.
They have inverted set/clear handling for the selected hook descriptor in
`[0684]`, and for descriptor `0408`. In this run `[0684] = 0108`:

1. `5A130` clears port-10 bit `04` via descriptor `0408`.
2. `5A139` clears logical descriptor `0108`, whose inversion **sets physical
   port-10 bit `01`**: `F2 -> F3`.
3. During the qualification wait, INT0 handler `67700` increments `[0176]`.
   At 25 or more interrupts it writes `[0694] = 80` at `67711`.
4. The wait at `5A186` detects that abort flag, branches to `5A246`, and
   returns carry set. The dial caller takes its error path.
5. Cleanup at `5FAC4 -> 5A79D` clears physical bit `01`: `F3 -> F2`, then
   restores bit `04`: `F2 -> F6`.

The emulator treats port-10 bit `01` as the hook relay. This mapping was
measured on an older Courier board; this trace confirms the 3453C firmware
uses it as the selected hook signal, **not the exact physical 3453C relay
wiring**. Bit `04` is a separate paired line-control signal, with its
physical role still unverified. Do not call it a second relay on this evidence.

The tick handler resets `[0176]` at `58750`. The initial audit attributed
the missing resets to internal CPU timer delivery. The later
[watchdog investigation](../3453c-watchdog-20261003/README.md) checks the
installed vectors: the reset comes through external vector 0F at `58693`.
The actual blockers were the legacy interrupt-mask layout and an unrecognized
2.3.x mailbox ISR return. Both are now corrected. The timer experiments
below remain historical diagnostics, not the chosen fix.

Two diagnostic runs enable timer interrupts without changing guest RAM:

- `timer-interrupt-experiment.json`: retaining the old timer-read behavior
  reaches an overlay attempt, then fails `3453C overlay did not acknowledge
  at 00B4, PC=1134`.
- `timer-full-experiment.json`: also enabling modeled timer reads changes
  the bootstrap path; at 3 million instructions the resident has not begun
  codec setup. This is not a validated timer fix.

These are opt-in experiments in `trace_call.py`, not changes to the default
machine profile. They demonstrate why simply turning on another clock is
insufficient to claim the call-control path is repaired.

## Corrections and pair result

The abort path also waits for UART transmit-empty at `593E2..59403`.
Previously only a particular printf polling address supplied that bit.
The synchronous payload transmitter now returns TX-empty at the actual
`FF66` status-register read, preserving all other bits. This allows the
error path to complete and release hook.

- Before: 6 million instructions, **353,736 hits** on the UART wait,
  `FF66=00`, hook still asserted.
- After: 10 million instructions, **one hit**, `FF66=08`, hook released.
- Pair retest: 150 million analog and 400 million I-modem instructions.
  The native codec clocks **243,925 frames**, performs **39 writes, zero
  reads**, and remains at 7,200 Hz. Both TX audio captures are silent.
  **No CONNECT, no incoming call, and no payload delivery.**

The pair directory preserves raw results and audio. That run preceded the
command-82 interpretation correction; its `engine-held-enabled` label is
obsolete. It did not exercise MCAL/start bit 6, so that correction does not
change the observed call result.

Validation: 140 tests passed across native C5x execution, audio rates and
acquisition, UART status, native machine execution, recovered 3453C boot,
pair probe and ASIC mappings. An attempted
Unicorn variant encountered SIGILL in the installed Unicorn library's
`mem_map`; the new guest-MMIO regression therefore uses the project's
normal native interpreter, including byte/word reads and preservation of
unrelated status bits.

## Reproduce

Run from the repository root. Every command uses a temporary copy of the
parameter flash; no source sector is modified or copied into this bundle.

```sh
.venv/bin/python artifacts/3453c-codec-call-audit-20261003/trace_call.py \
  --parameters artifacts/3453c-parameter-sector-20261003/f8000-fbfff.bin \
  --output /tmp/3453c-hook-trace.txt

# Diagnostic only; use 'full' to also enable modeled timer reads.
.venv/bin/python artifacts/3453c-codec-call-audit-20261003/trace_call.py \
  --parameters artifacts/3453c-parameter-sector-20261003/f8000-fbfff.bin \
  --output /tmp/3453c-timer-experiment.txt --hardware-timers interrupts

.venv/bin/python -m tools.probe_imodem_analog_pair \
  --analog-board 3453c \
  --analog-parameter-flash artifacts/3453c-parameter-sector-20261003/f8000-fbfff.bin \
  --protocol v90 --instructions 400000000 --analog-instructions 150000000 \
  --analog-send '3453C-TO-IMODEM-12345' --imodem-send 'IMODEM-TO-3453C-67890' \
  --output /tmp/imodem-3453c-pair
```
