# Where the ROM's AT command is lost

`IDSDL302.ROM` takes every byte of `AT\r` and answers nothing. This traces the
path from the serial interrupt to the point the line stops, with the execution
count each site reaches in a 60M-instruction run with `--at AT`.

The ROM is not idle and its serial front end is not missing. Both were earlier
misreadings: the front end is fully installed, by the firmware, and the
callback table is at `026a`, not the `02a8` the traces used to print. See
[serial callback location](../courier_emu/machine.py) and `test_serial_callbacks`.

## The chain, and how far it gets

| site | what it is | executed |
|---|---|---:|
| `80f23` | serial type 0x14 ISR: `mov ax,[ff68] ; call [026a]` | **3** |
| `89a06` | RX callback: `and ax,7f ; call [b7c]` | 3 |
| `89a1e` | `test [b88],40` - is a command line open | 3 |
| `89a68` | the line collector | 3 |
| `89acc` | `inc [b8e]` / `mov [bx+b8f],al` - store a character | **2** |
| `89a6e` | `cmp al,[598]` - the terminator, S3 | 3 |
| `89a74` | terminator path: clear `[b88].6`, zero the buffer, `al=8` | **1** |
| `89a80` | `jmp word ptr [026e]` - hand the line to the command state | **1** |
| `8934b` | the command state, idle | 556,934 |

So `A` and `T` are collected, the `\r` is recognised as the terminator, and the
line is handed over exactly once. Everything up to here works.

## Where it stops

`8934b` is a jump table, not a routine:

```text
8934b  xor ah, ah
8934d  xchg bx, ax
8934e  shl bx, 1
89350  jmp word ptr cs:[bx - 0x6cab]      ; entries at 89355 + 2*al
```

| `al` | target | |
|---:|---|---|
| 0,1,2,7,**8**,10,11 | `89386` | `xchg bx,ax ; clc ; ret` - **nothing** |
| 3 | `89392` | `mov [026e], 941c` |
| 9 | `89389` | `mov [026e], 93fc` |

The terminator arrives as `al = 8`, and in the idle state `al = 8` is a no-op.
The line is collected, handed over, and dropped on the floor. Nothing is ever
parsed, so nothing is ever transmitted: none of the 50 `mov [ff6a]` sites, the
transmit routine at `81613`, its TXE spin at `81603`, or the type 0x15 ISR at
`80f1c` executes even once.

## What is missing

`[026e]` is still `934b` when the terminator lands. Its own table shows the two
ways out of idle - `al = 3` to `941c` and `al = 9` to `93fc` - so the command
state machine has to be armed *before* the terminator, and nothing armed it.
The collector's call at `89a9c` (`call word ptr [b7f]`) is **not an AT
attention detector**. The harness installs `9b0a` there, but that routine
compares the character with `+`; its next state compares with `F`/`f`, and
the following state compares with `P`/`p` or `L`/`l`. It is a `+F` command
recognizer. Passing `A` and `T` through it cannot arm the command state.
The earlier suggestion that this callback was the missing AT detector was
incorrect.

The emulator's `_rom_dte_opened` block sets collector flags and forces the
integrated UART vector, but does not perform the firmware's command-state
transition. Its claim to complete the startup/open event is therefore too
strong: opening the collector alone leaves the state machine in idle.
The next implementation step is to recover and deliver the real command-mode /
autobaud event, including its state transition, rather than add another buffer
flag or bypass the firmware's parser.

Two of that commit's other pokes are already known to matter here, and neither
is understood:

* `[033e] = 2` steers `89a49` into `89a50`, whose other arm parks the RX
  callback on the bare `ret` at `89a67` - deaf after one character.
* `[b88] |= 0x40` is what sends the byte to the collector at all. Removing it
  drops the run from three collected characters to one and then silence, so it
  is load bearing, and it is the flag the firmware's own terminator path
  clears at `89a74`.

## 403 has an additional image-layout failure

Disassembly of `artifacts/courier-board-21210-capture-403/courier-board.rom`
shows that the 302 addresses are not portable:

| item | IDSDL302 | captured 403 |
|---|---:|---:|
| RX/TX/command callback table | `026a` | `0164` |
| integrated UART RX ISR | `80f23` | `80f54` |
| command-state pointer | `026e` | `0168` |
| command collector | `89a68` | `89a93` |
| collector flags | `0b88` | `0a7c` |
| command length / buffer | `0b8e` / `0b8f` | `0a82` / `0a83` |
| collector feature gate | `0695` | `058d` |
| `+F` recognizer pointer | `0b7f` | `0a73` |

`serial_callback_table()` already recovers `0164` from 403, but the ROM RX
delivery gate in `machine.py` still reads `026a`. The startup workaround also
tests and writes 302 RAM addresses, and forces vector 14h to `8000:0f23`
instead of 403's `8000:0f54`. If the workaround fires on 403, it writes
unrelated state and can route interrupts into the wrong code; if it does not,
the delivery gate still checks the wrong callback cell. Fixing TX-ready or
extending the instruction budget does not address either issue.

## Reproduction, 2026-09-06

The existing `tests/test_rom_serial.py` regression was run for its full 60M
instruction budget, with the EEPROM fixture, board ID 7, a 5 ms tick and
`AT\r`. It fails because serial output is empty, rather than containing
`\r\nOK\r\n`. This is a known failing regression, not evidence that the
current startup workaround works. Unicorn required execution outside the
filesystem sandbox on this host; the sandboxed run stopped with an illegal
instruction during `mem_map`, before any firmware executed.

A subsequent 40M-instruction diagnostic run used the same settings on each
image and counted the actual instruction sites:

| observation | 302 | captured 403 |
|---|---:|---:|
| UART bytes delivered / transmitted | 3 / 0 | 1 / 0 |
| startup workaround fired | yes | yes |
| executions at `80f23` | 3 (correct ISR) | 1 (wrong entry) |
| executions at `80f54` | 0 | 0 (correct ISR never entered) |
| final RX/TX/command callbacks | `9a06,1d03,934b` | `9a31,1d35,93b0` |

For 302, the collector ran three times, its terminator branch once, and the
`+F` recognizer twice. The idle command dispatcher ran 108,436 times; neither
`815f0` nor `81613` ran at all. For 403, the forced 302 ISR entry actually
executed, confirming that the address mismatch is active in this reproduction,
not just a hypothetical incompatibility. These are CPU-only harness results;
the 302 EEPROM fixture was used for both, not a captured 403 EEPROM image.
