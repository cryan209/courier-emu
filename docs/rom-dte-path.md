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
The likely arming site is the attention detector the collector calls at `89a9c`
(`call word ptr [b7f]`), reached only when `[695].0` and `[ea7].0` are both
set. That vector is one of the cells `b013186` writes by hand, so what it holds
in a run is the harness's choice rather than the firmware's, and establishing
what the firmware itself puts there is the next step.

Two of that commit's other pokes are already known to matter here, and neither
is understood:

* `[033e] = 2` steers `89a49` into `89a50`, whose other arm parks the RX
  callback on the bare `ret` at `89a67` - deaf after one character.
* `[b88] |= 0x40` is what sends the byte to the collector at all. Removing it
  drops the run from three collected characters to one and then silence, so it
  is load bearing, and it is the flag the firmware's own terminator path
  clears at `89a74`.
