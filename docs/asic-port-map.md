# Modelling the 20.16 MHz ASIC through the serial monitor

The NEC gate array is the part the harness models as a black box (see
[board-parts.md](board-parts.md)). It is also the only thing on the 80186's
I/O bus: the CPU's own peripheral block is in *memory* at `0xff00`-`0xffff`,
and flash and SRAM are memory too, so whatever answers an `IN` is the ASIC.

The ID_SDL monitor can read those ports on a running board. `courier_emu.asic_probe`
does that, in three states, writing nothing:

```sh
.venv/bin/python -m courier_emu.asic_probe \
  --device /dev/cu.usbserial-21210 --baud 115200 \
  --output artifacts/asic-ports-01
```

It sweeps `0x00`-`0xff` four times idle, four times during `AT&T8`, and four
times after. `AT&T8` is what makes an active state observable: `&T1` loops the
DTE through the modem so the serial port stops taking commands, while `&T8`
runs the same analogue loopback against the modem's own pattern generator and
leaves the DTE in command mode. It needs no phone line and never goes off hook.

## The shape of the space

| finding | evidence |
|---|---|
| **Only even addresses are decoded** | all 64 odd ports in `0x00`-`0x7f` read `0x00` |
| **The decode stops at `0x7f`** | above it, all 64 even ports read back their own address and all 64 odd ports read `0x00` |
| **The idle default is `0x00`** | 96 of the 128 ports below `0x80` read zero |

The ASIC presents 16-bit registers; the monitor reads a byte, so the odd half
is a high byte nothing drives. Above `0x7f` there is no device at all - what
comes back is the bus holding the last address, which is why a sweep there
looks like a ramp.

**The third row is a discrepancy with the harness.** `machine.py` returns
`mask` - `0xff` for a byte - from any port it does not model:

```python
value = self.port_values.get(port, bridged if bridged is not None else mask)
```

The board's answer is `0x00` for three quarters of its decoded space. The
measured map is in `courier_emu.asic_ports`, and `asic_ports.seed()` produces
it in the form `port_values` takes.

## What is there

Thirty-two ports carry a non-zero idle value, all even, all below `0x80`:

| ports | idle | what they are |
|---|---|---|
| `0a` `0c` `0e` | `f7` `60` `07` | unattributed |
| `10` `12` `14` | `86` `8a` `7e` | the board latches: hook relay, NVRAM strobe, carrier-detect pair |
| `18` `1a` `1c` `1e` | `ff` `ff` `fd` `ff` | the four that move under load |
| `42` `46` `4a` `4e` `52` `56` | `ff` | the DSP download window, written in thousands and never read |
| `58` `5c` `60` | `20` `0e` `4b` | mailbox tag, data, stream window |
| `64`-`7e` | `78 09 8f a7 e8 aa b6 97 51 51 06 4f b3` | looks like fixed configuration |

That last block is the interesting one. Ten of its thirteen values -
`64 66 6c 72 74 76 78 7a 7c 7e` - are **identical** to the sweep in
`artifacts/io-port-map/hardware-2016mhz/atglk2b.txt`, taken from this unit when
it ran stock 7.3.14 rather than ID_SDL 4.03. Same values across two firmware
versions and two sessions is what identity or strapping looks like. The other
three (`68` `6a` `70`, and also `58` and `60`) differ between the captures, so
they are state.

## What moves

Only four ports differ between idle and active audio:

| port | idle | `&T8` | bits |
|---|---|---|---|
| `18` | `ff` | `c0`, `c6`, `c7` | `3f` |
| `1a` | `ff` | `c0` | `3f` |
| `1c` | `fd` | `f9` | `04` |
| `1e` | `ff` | `fb` | `04` |

`1c` and `1e` are the mailbox status pair and both move on bit 2 - the bit the
supervisor's mailbox interrupt acknowledges. `18` also varied *within* the
active state, so it carries live signal rather than a settled level.

This is the main limit of the run: with the loop on hook and no call, most of
the ASIC never does anything. Four ports out of thirty-two is what `&T8`
reaches.

## What this does not settle

Seeding the measured map into the ROM harness does **not** fix the outstanding
bug where a board ROM accepts input and transmits nothing (commit `229ef5b`).
Running the captured 7.3.14 ROM with `ATI\r` for 60M instructions:

| | transmitted | received | ticks |
|---|---:|---:|---:|
| harness default (`0xff`) | 0 | 4 | 2,732 |
| measured map | 0 | 4 | 2,730 |

The tick count moves, so the map does reach execution; the transmit path does
not depend on it. That bug is elsewhere. (Those two tests are pytest-style
functions, so `make test`, which runs unittest, does not collect them - they
fail when run under pytest directly.)

The map is therefore published and **not wired in by default**. Two reasons:
it is the idle, on-hook state, so holding those values static through a run
that goes off hook could be worse than the current `0xff`; and it is the
20.16 MHz board's ASIC, where the harness's usual image `main211.xmf` is a
different generation entirely.

Two things not attempted, both deliberate:

**No port writes.** Write-response is what separates a latch from a read-only
status register and it is the obvious next experiment, but an unknown ASIC
register is not a safe write target - three ports on this board drive the hook
relay, the NVRAM strobe and the carrier-detect pair. That needs its own
decision, not a characterization sweep.

**Reads are not always free.** The mailbox data registers at `0x5c`/`0x5e` are
how the supervisor collects a reply, and `0x1c` carries status its interrupt
acknowledges, so sampling them may consume something the firmware wanted.
`--skip-mailbox` leaves that group alone; a result that matters should be taken
both ways.
