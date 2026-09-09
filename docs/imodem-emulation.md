# Emulating the I-modem

Most of it already exists, and the DSP half is the same part.

## What runs today

`courier_emu.isdn.IsdnMachine` is a 386 real-mode harness on Unicorn -
`courier-emu isdn-run Ie030002.nac`.  It enters at `4030:0000`, the recovered
initialiser, and models the PC-AT furniture the firmware actually touches: an
8254 and a pair of 8259s, two 16550s at `f8f8` and `f4f8`, the board status
port `1e`, and the download ports `40`-`56`.

It gets far enough to load the DSP, and that is now checkable rather than
assumed.  In a 3,000,000-instruction run the harness captures 47,088 bytes on
the download ports, and against the images read out of the overlay table
([x2-symmetric-and-all-digital.md](x2-symmetric-and-all-digital.md)):

```
stream[16      : 15088] == image 10   (15,072 bytes, byte for byte)
stream[15088   : 47082] == image 11   (31,994 bytes, byte for byte)
```

Both images whole, in that order, after a 16-byte preamble.  That is exactly
the pair the routine at `b1655` requests - `mov [e738],0a` then `mov
[e738],0b` - so the table derivation (`cs = a400`, rows at `d682`, segment
table at `d6ca`) is confirmed by a live boot, not just by static reading.  It
also says something about the board: the image the I-modem loads first is the
PCM one.

## The DSP is the same part

The images decode with `tools/c5x_disasm.py` unchanged, the resident loads at
`8000` like the analog Courier's, the sample paths use the same memory-mapped
`@20`/`@21` (DRR/DXR), and the download handshake is the same shape - status
bits polled on port `1e`, words streamed out of `40` upward, against the analog
board's `40`-`4e`.

So `courier_emu.dsp.NativeC5x` should run these directly.  Its `load_program`
already takes raw bytes and an origin; the only thing in the way is that its
constructor is typed to `XmfImage`.  Widening that, and pointing the ISDN
harness's download ports at the core instead of a `bytearray`, is the whole
join - the analog side already has that pattern in `dsp_mailbox` and
`probe_transport`.

## Memory: more on the CPU side, not on the DSP's

| | analog Courier | I-modem |
|---|---|---|
| CPU | 80C186EB | 386, real mode |
| flash payload | `b8000` bytes at `40000` | `b8000` bytes at `40000` |
| RAM cleared at entry | - | 256 KiB, then `41c0` bytes relocated to `0ce00` |
| DSP program space used | `8000`-`f5d9` | `8000`-`ee6f` |
| DSP images | 4, 48,344 words | 7, 52,936 words |

The CPU side is plainly bigger - a 386 with a flat megabyte to play in rather
than an 80186, and a quarter of a megabyte cleared before anything starts.  The
DSP side is not: the I-modem's images top out **lower** than the analog's, at
`ee6f` against `f5d9`, so the same 32K-word external RAM
([dsp-map-302.md](dsp-map-302.md)) covers it.  What it has is more images, not
more room - seven loaded in and out of the same space, including the PCM pair
that needs two loads to fit.

## What is missing

* The C5x is downloaded but not executed - the harness records the stream.
* The ISDN front end: S/T transceiver, HDLC, B-channel routing.  Nothing in the
  DSP images touches it ([x2-symmetric-and-all-digital.md](x2-symmetric-and-all-digital.md)),
  so it is all on the 386 side and all unmodelled.
* Which device raises the system tick.  The harness drives IRQ10 from 8254
  counter 0 because that is the line the tick-delay routine at `a45df` needs;
  the physical wiring is not recovered.
