# 20 MHz ROM serial execution

The 302/403 CPU-only harness has a byte-oriented terminal adapter. It enters
the ROM's existing attention detector, which recognizes `A` then `T`, collects
the command body, calls the original parser, and generates the response.
Output is captured only when firmware writes the integrated UART's S0TBUF
(`ff6a`); entering a character-output routine does not fabricate output.

For the bundled 302 image:

```sh
./courier run IDSDL302.ROM --instructions 60000000 \
  --tick-ms 5 --board-id 7 --nvram-fixture idsl302 --at AT --summary
```

The captured 403 image can be used with the same options:

```sh
./courier run artifacts/courier-board-21210-capture-403/courier-board.rom \
  --instructions 60000000 --tick-ms 5 --board-id 7 \
  --nvram-fixture idsl302 --at AT --summary
```

The fixture is a recovered 302 settings fixture, not a captured 403 EEPROM.
UART output may carry parity in bit 7; mask with `0x7f` to interpret its ASCII
text. The tests retain raw bytes and also assert that their count equals the
UART's actual transmitted-byte count.

## What the adapter supplies

`courier_emu/rom_serial.py` locates the callback table's RX ISR, attention
handler, command dispatchers, mode byte, and output-routing flag from the
resident instructions. It checks the command dispatcher's event-1 transition
before accepting a layout. Unknown or incomplete layouts do not enable this
adapter.

| Resident item | 302 | captured 403 |
| --- | --- | --- |
| RX/TX/command table | `026a` | `0164` |
| UART RX ISR, segment `8000` | `0f23` | `0f54` |
| `A` attention detector | `f170` | `f1a0` |
| Ready command dispatcher | `931d` | `93b0` |
| Dispatcher after `A` | `93b0` | `9443` |
| Mode byte | `033e` | `0237` |
| Output-routing flag | `0ea7` | `0d93` |

At the first queued byte after the existing boot delay, the adapter selects
command mode and the attention handler, and disables the separate buffered
output route. It supplies bytes through this image's integrated-UART ISR.
After a command, queued input waits until the firmware returns to its ready
state; the adapter then reselects the attention handler. It does not inspect
command text or construct result strings.

This remains an explicit substitute for raw-pin autobaud in a CPU-only run.
It does not establish cycle-accurate baud detection, DSP startup, or a working
telephone connection. Timing still uses the harness's instruction-based boot
and character delays.

## Hardware-facing corrections

The terminal remains connected after its input queue drains. Previously the
last carriage return also deasserted DTR while firmware was processing the
command.

The resident ROM switch wiring differs from the XMF supervisor. In particular,
its profile builder reads result-code enable at port `12h`, bit 0 (selector 3,
mask `01h`), whereas XMF reads port `14h`, bit 5. Applying the XMF wiring to
these ROMs left Q1 selected and suppressed otherwise valid responses. The
panel now selects the resident mapping for recognized ROMs.

The prior workaround forced a 302 collector and ISR into both layouts, skipped
attention recognition, and redirected output to a RAM buffer. That block and
its character-routine capture hook have been removed. The earlier failure
analysis in `rom-dte-path.md` describes the pre-fix behavior.

## Regression coverage

`tests/test_rom_serial.py` checks actual UART responses, complete consumption
of queued input, repeated commands, and Q1/Q0 behavior. The layout tests cover
both resident builds and reject incomplete signatures. The XMF callback
regression checks that its existing serial path still works.

Validation on 2026-09-06: the focused ROM serial, serial callback, layout, and
panel suite passed **31 tests and 8 subtests**. Both ROMs completed
`AT`, `ATI`, `ATQ1`, `ATQ0`, `AT` with four OK responses and no response to Q1.
Captured 403 returned identification `5607A`. These tests executed Unicorn
outside the filesystem sandbox because its sandboxed memory mapping crashes
on this host before firmware starts.
