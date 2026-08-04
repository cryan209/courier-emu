# Courier XMF emulator harness

This repository contains a reproducible dual-core firmware harness for
`main211.xmf`. It validates and splits the update image, executes the Intel
80186 supervisor in a 1 MiB instrumented address space, and runs the recovered
TMS320C52 program with a standalone 16-bit fixed-point DSP core.

## Recovered `main211.xmf` layout

| File range | Contents |
|---|---|
| `0x00000..0x001ff` | 512-byte product text header |
| `0x00200..0x1b5df` | 55,792 little-endian TMS320C52 words |
| `0x1b5e0..0xb7fff` | Intel 80186 supervisor plus erased flash padding |

The image is mapped at physical `0x40000`. The normal supervisor initializer is
`5b5e:0410` (physical `0x5b9f0`). The six bytes at `5b5e:0000` are instead a
fatal-error entry: they select error `0x0b` and jump to the LED blinker at
physical `0x5c74a`. The CPU's immutable reset vector is not present in this
update payload, so the harness starts at the recovered supervisor initializer.

The DSP area is a segmented program image rather than one flat load:

| File range | C52 program words | Role |
|---|---:|---|
| `0x002f0..0x0eea3` | `0000..75d9` | reset and boot block |
| `0x0eea4..0x101ff` | `de83..e830` | service overlay; entry at `de89` |
| `0x10200..0x1b5df` | `8000..d9ef` | resident high bank |

## Usage

No dependencies are needed to inspect or extract the firmware:

```sh
python3 -m courier_emu info main211.xmf
python3 -m courier_emu extract main211.xmf extracted/main211
python3 -m unittest discover -s tests -v
```

Execution uses Unicorn's 16-bit x86 core and runs in an isolated child process:

```sh
python3 -m pip install '.[execute]'
python3 -m courier_emu run main211.xmf --instructions 250000
python3 -m courier_emu run main211.xmf --instructions 1000000 --summary
python3 -m courier_emu run main211.xmf --instructions 7000000 --with-dsp --at AT --summary
```

The C52 runner has no third-party runtime dependency; it builds with the system
C++17 compiler on first use:

```sh
python3 -m courier_emu dsp-run main211.xmf
python3 -m courier_emu dsp-run main211.xmf --trace 40
python3 -m courier_emu dsp-run main211.xmf --port 0x50=0x1234
```

With no supervisor or line-side events injected, `main211.xmf` reaches a
deterministic 169-address service/polling cycle after 10,241 DSP instructions
and reports `status: stable-loop`. Use `--instructions` to extend the run or
`--trace-start` with `--trace` to inspect a later instruction window.
Opcode forms not exercised by this firmware path fail explicitly with their PC
instead of silently producing guessed state.

The known fatal-blinker calibration loop, initial 80186 timer-ready poll, and
firmware tick-delay helpers are accelerated by default because a CPU-only core
cannot supply their hardware timing. Use `--real-delays` when
instruction-accurate delay counts matter.

Seed hardware input values with repeatable `--port PORT=VALUE` arguments. Port
`0x40` is the first recovered board-control latch. The recovered DTE UART model
accepts `--at COMMAND` (which appends carriage return) or literal
`--serial-input TEXT`. Its RX ISR is vector `0x0e`, with status/control at port
`0x00`, data at port `0x0a`, and RX-ready bit `0x08`. Transmit bytes are also
captured from the selected 80186 integrated-UART feed before its transformed
write to register `0xff6a`. `serial_text`, `serial_interrupts`, and
`serial_trace` report the resulting terminal exchange. The modeled DTE
attention detector accepts the firmware's all-uppercase or all-lowercase
`AT` prefix and passes only the remaining command body to the banked parser.
For example, a 7,000,000-instruction run of `--at AT` or `--at ATY5` reaches
command mode and returns `\r\nOK\r\n`. Captured output is capped at 64 KiB;
`serial_truncated` reports when a diagnostic command exceeds that limit.
Commands execute inside the original firmware: `ATQ1` changes its quiet-mode
profile byte and suppresses the result code, while `ATD123` and `ATA` enter the
line-control path, reset and reload the DSP, and currently return `NO DIAL
TONE` because the remaining DAA state/dial-tone decision is not modeled. DSP results
separate completed `bootstraps` and `transfer_commands` from runtime
`mailbox_commands`, with a `mailbox_windows` histogram of the latter.

The line-audio endpoint is the Courier ASIC's external C52 I/O frame, separate
from both on-chip serial ports and the 80186 download window. Firmware reads
the held ADC word twice from external I/O port `0x54` at program `0xb300` and
`0xb304`; the second read is copied into active sample cell `0x007f`. Its
matching per-frame `OUT` at program `0x8c24` writes the DAC word to external
port `0xb2e5`, sourced from output cell `0x00cb`. `TRCV` (`0x30`) and `DRR`
(`0x20`) are part of the ASIC/serial framing and address bookkeeping, not raw
linear-PCM endpoints. Supply and capture mono signed-16 little-endian words
after dial/answer activation with:

```sh
python3 -m courier_emu run main211.xmf --instructions 9000000 --with-dsp \
  --dsp-rx-pcm line.s16le --dsp-tx-pcm reply.s16le --at ATDT123 --summary
```

`dsp_bridge.serial_port` reports the register values, access counts, last
firmware PCs, queued/consumed input frames, and line-output counts. The modeled
missing board-to-DSP dial-command handoff recognizes the firmware's parsed
`D` command and drives 9.6 kHz DTMF frames through the C52's real `OUT`
instruction. `ATDT123` produces 697+1209, 697+1336, and 697+1477 Hz bursts.
This establishes bidirectional waveform transport and reproducible tone output;
the original datapump's internal command mailbox and dial-tone decision remain
to be recovered, so the 80186 still reports `NO DIAL TONE` without a complete
DAA model.

The result includes CPU registers, the first 128 I/O/MMIO operations, complete
per-address event counts, the hottest code addresses, and the final execution
path. It also records `supervisor-entry`, `dsp-transfer`, `startup-crc`, and
`main-loop` milestones; a run that reaches the normal dispatcher reports
`status: main-loop`. Unknown input ports return all ones. Input responses and output latches
are separate, matching hardware such as DSP command/status port `0x1e`;
`--port` sets only the input response. This intentionally makes unmodeled
hardware visible instead of silently pretending it exists.

On macOS, a native Unicorn library can be selected with
`--libunicorn /path/to/library/directory`. The worker boundary converts native
signals into a clean CLI failure rather than crashing the controlling process.

## Current boundary

The 80186 and C52 are lock-stepped at their recovered 20/25 MHz ratio. The
supervisor's DSP bootstrap is reconstructed from ports `0x40..0x4e`, verified
byte-for-byte against the XMF C52 boot segment, and published to the native DSP
through the recovered mailbox. The DTE serial path can inject commands and
capture firmware-generated result text. The ASIC line frame now transports
9.6 kHz input/output samples and captures dial tones. Remaining device work is
the original datapump command mailbox and DAA decision state, complete 80186
peripheral timing, persistent NVRAM, and unexercised C52 opcode forms.
