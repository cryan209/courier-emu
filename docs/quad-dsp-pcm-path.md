# Where the PCM goes on the Quad x2 Modem NAC

The question this answers: does the G.711 codeword stream reach the C50 DSP
directly, or does the 80186 supervisor carry it? On this card it is direct, over
the C5x **TDM serial port**. The supervisor is not in the sample path.

## The proven part

Both Quad builds program `TSPC` — the TDM Serial Port Control register, C5x
memory-mapped address `0x32` — in the DSP resident bank's startup path, with
byte-identical code:

```
lacl  #38
samm  @32        ; TSPC
lacl  #f8
samm  @32
```

| Build | Resident base | `samm @32` sites |
| --- | --- | --- |
| `QF060003` 6.0.3 | `0xc49b0` | word `0x099` (`0xc4ae2`), word `0x09b` (`0xc4ae6`) |
| `QR060103` 6.1.3 | `0xc2230` | word `0x085` (`0xc233a`), word `0x087` (`0xc233e`) |

Written first as `0x38`, then rewritten as `0xf8` — the same value with the top
two bits set. That is the ordinary configure-then-release idiom for this
register: set the mode with the reset bits held, then release them.

The C5x TDM serial port is the multi-channel variant: `TRCV`/`TDXR` for data,
`TSPC` for control, `TCSR` for channel selection, `TRTA` for the timeslot
address. It exists to put several devices, or several channels, on one
time-division serial highway. That is what a four-channel modem card needs, and
it is what taking DS0s from the chassis needs.

## The contrast that makes it meaningful

| Product | DSP serial interface used | Peer |
| --- | --- | --- |
| Analog Courier V.Everything | plain serial port only — `DRR`/`DXR` | local TLC320AC01 codec, see [ac01-codec-protocol.md](ac01-codec-protocol.md) |
| Quad x2 Modem NAC | **TDM serial port** — `TSPC` programmed at init | shared PCM highway / chassis DS0s |
| Courier I-modem | Am79C30A peripheral port | see below |

`main211`'s C52 payload contains **no** TDM-register writes at all. The Quad's
DSP therefore drives an interface the standalone Courier's DSP never touches,
which is the concrete hardware difference behind the `%D1 T1 Mode (DS0)` line
mode in [quad-x2-modem-nac.md](quad-x2-modem-nac.md).

## The 80186 is not in the sample path

The supervisor's entire I/O map is the four-entry board latch bank
(`0x0000`, `0x0200`, `0x0260`, `0x0280`), the management USART block
(`0x0220`–`0x022a`), and the `0x0042` handshake group with status at `0x0200`
and `0x0240`. All of these are byte-at-a-time and none sits in a sample-rate
loop. Its DSP interface is a queue in shared RAM — the 35 initialisation writes
at `0x02ca..0x030e` that the execution run records (`QF` at `pc=8016a`, `QR` at
`pc=80176`) — which is control messaging, the same shape as the analog
Courier's mailbox in [dsp-cpu-interconnect.md](dsp-cpu-interconnect.md).

## Method, and why the counts in a naive scan are wrong

Counting `lamm`/`samm` opcode words across a C5x payload produces mostly false
positives. A word like `0x0830` is `lamm @30` only if it is at an instruction
boundary; far more often it is the immediate operand of a preceding
`lar arN, #0830`, or it is table data. A first pass over the QF resident found
15 apparent TDM-register sites; running each through `tools/c5x_disasm.py`'s
`anchored()` filter and then reading the surrounding instructions leaves only
the `TSPC` pair above as unambiguous code. The `lamm @30` clusters near
`0xc33e`, `0xc393`, `0xc472` and `0xc4cc` are plainly tables — monotone small
values disassembling as a run of `lar ar0, @xx`.

The same caution applies in the other direction: `Ie030002`'s flattened image
cannot be scanned this way at all, because it is 386 code with DSP images
embedded in it, so C5x word patterns there mean nothing.

## What is not established

- The per-sample receive/transmit ISR has not been located. "The TDM port is
  configured at init" is proven; "every codeword flows through it" is the
  strong inference from that, not a traced path.
- `TCSR`/`TRTA` — channel select and timeslot address — have no confirmed write
  site. Recovering those would say how the four channels are assigned to
  timeslots, which is the interesting part.
- Which companding law is in force, and whether the analog line mode uses a
  local codec on the same TDM port or a separate one, is unknown from the
  firmware alone.

## The I-modem, for comparison

[imodem-isdn-front-end.md](imodem-isdn-front-end.md) records that the
Am79C30A's `MCR1`–`MCR4` multiplex B1, B2 and the internal channels between the
LIU, the MAP audio processor and the **peripheral port**, and that `PP_PPCR1`
and `PP_PPCR3` are programmed during init. The peripheral port is that chip's
serial PCM interface to an external device, so B-channel PCM reaches the DSP
over a route the Am79C30A sets up — not by the 386 copying codewords.

That is an inference from the register set, with a stated limit: the same
document records `MCR1`–`MCR4` as **cleared** at init, "no connection until a
call sets one up", and no live call has been traced — `courier-emu isdn-run`
still stalls waiting on the LIU. So the per-call routing is not observed.

Across the three products the transports differ — local codec, TDM highway,
ISDN peripheral port — but none of them is a CPU copy loop.
