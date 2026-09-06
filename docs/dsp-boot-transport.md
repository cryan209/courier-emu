# The DSP's boot ROM has two transports, and the harness picked the other one

The recovered on-chip ROM (`artifacts/dsp-onchip-rom-01/c5x-onchip-rom.bin`)
contains **two** boot loaders, not one. Earlier notes here -
[dsp-onchip-rom.md](dsp-onchip-rom.md), and the first version of
[ac01-codec-protocol.md](ac01-codec-protocol.md) - describe only the serial one,
because the disassembly they were read from stopped at `0x0700` and the second
loader starts at `0x072c`.

## The dispatch

The loader reads its boot word from data `0xffff` into `@60`, and after the low
two bits select "serial-ish" it tests two more:

```
06c6  4c60         bit  12, @60      ; bit 3 of the boot word
06c7  e100 072c    bcnd 072c, tc     ; set   -> the parallel loader
06c9  4d60         bit  13, @60      ; bit 2
06ca  f200 06d4    bcnd 06d4, ntc    ; clear -> 8-bit, set -> 16-bit
06cc  5e22 ff01    apl  @22, #ff01   ; SPC
06ce  5d22 0038    opl  @22, #0038   ; SPC
```

`bit k` tests bit `15-k`, so `bit 12` is boot-word bit 3 and `bit 13` is bit 2.

| boot word | bit 3 | bit 2 | loader | transport |
|---|---|---|---|---|
| `0x04` | 0 | 1 | `0x06e2` | serial, 16-bit |
| `0x00` | 0 | 0 | `0x06f7` | serial, 8-bit pairs |
| `0x0c` | 1 | 1 | `0x0731` | **parallel, 16-bit** |
| `0x08` | 1 | 0 | `0x0748` | **parallel, 8-bit pairs** |

## The serial loader

Receive-only on the C5x's **primary** serial port: reads `DRR` (data `0x20`),
polls `RRDY` (`SPC` bit 10, data `0x22`). It never writes `DXR`.

```
06de  4522  bit  5, @22   ; SPC bit 10 = RRDY
06e8  1020  lacc @20      ; DRR
06f3  a720  tblw @20
```

## The parallel loader, which nothing here had seen

Its word fetch is an **`XF`/`BIO` handshake**, and the data arrives on a
memory-mapped port at data `0x50`:

```
0775  be4d    setc xf            ; assert XF - "send a word"
0776  e000    bcnd 0776, bio     ; spin on the BIO pin
0778  be4c    clrc xf
0779  ec00    retc bio           ; return once BIO says the word is there
077a  7980    b    0779
```

16-bit mode reads the port once per word; 8-bit mode assembles a word from two
reads:

```
0731  7a80 0775   call 0775            ; 16-bit: fetch
0733  0950 0066   smmr @50, #0066      ; ...and take the word from port 0x50
...
0748  7a80 0775   call 0775            ; 8-bit: fetch
074a  1850        lacc @50, 8          ; high half
074c  7a80 0775   call 0775            ; fetch
074e  6950        lacl @50             ; low half
074f  bfb0 00ff   and  #000000ff
0751  6d66        or   @66
```

`SMMR dma, #addr` moves the memory-mapped register at `addr` into `dma`, so
**`@50` is the source**: the DSP is reading a port the ASIC drives, not writing
one. The block-write loop is the same `tblw` / `banz` shape as the serial
loader's.

## Why this is very likely the transport the board uses

Nothing here has measured what the ASIC presents at data `0xffff`, so this is
an argument from fit, not a reading. But four things line up:

1. **The supervisor's download is parallel.** It writes a window at 80186 ports
   `0x40`-`0x5e`. Feeding the serial loader from that requires the ASIC to do a
   parallel-to-serial conversion, which [dsp-onchip-rom.md](dsp-onchip-rom.md)
   flagged at the time as "a role for it this repository had not identified".
   The parallel loader needs no such thing.
2. **Data `0x50` is already known to be the ASIC window.** The downloaded
   resident polls I/O `0x50`/`0x52`/`0x54` for the mailbox, and the codec ISR
   writes a scaled sample to `0x50` at program `0x8199`. The boot loader reading
   the same address is the same window, used earlier.
3. **It does not touch the codec's port.** The AC01 owns the primary serial port
   (TI's `slaa006` reference design wires it there and leaves the TDM port
   pulled to COM). A serial boot has to share that port with the codec for the
   length of a 27,710-word download, and the AC01's only quiet window - `DOUT`
   in high impedance - lasts **eight frames**. That does not fit, and it is why
   the high-impedance explanation offered in `ac01-codec-protocol.md` was
   retracted.
4. **`XF` is wired to the codec's `RESET`.** `slaa006` runs `RESET` from `XF`,
   and the parallel loader drives `XF` on every word it fetches. Whatever else
   that does, it means the codec cannot be quietly listening through a parallel
   download - which is exactly the arbitration a shared serial port lacks.

## What the harness does today

`bridge.py`'s `_configure_boot_rom` writes `host_write(0xFFFF, 4)` - bit 3
clear, so **the serial loader**. That value was chosen when only the serial
loader was known, and `dsp-onchip-rom.md` states the choice as though bit 2 were
the only degree of freedom ("that single bit is what the ASIC has to present").
It is not.

The serial path does boot the DSP in the emulator: the download completes, the
firmware runs its prologue, programs the codec's six registers and reaches its
idle. So this is not a bug that shows up as a failure - it is a transport that
works in the model and probably is not the one on the board.

## What would settle it

The boot word comes from the ASIC, so the question is what the ASIC drives onto
the DSP's data bus at `0xffff` during reset. Two approaches:

* **From the board.** The same RAM-monitor rig that recovered the ROM can read
  data `0xffff` after a reset, before the supervisor's download.
* **From the model.** Implement the parallel loader - drive `BIO` and present
  words at `0x50` from the existing transfer buffer - and see whether the
  supervisor's own download stream feeds it without the reframing the serial
  path needs. A transport that consumes the captured stream as-is is evidence;
  one that needs the harness to reshape the data is not.

Neither has been done.
