# The DSP's boot ROM has two transports, and the board uses neither

> **Measured, but weaker than first stated.** The board's ASIC presents
> **`0x0083`** at DSP data `0xffff` *while the modem is running normally*, long
> after boot. Its low two bits are `3`, a mode that transfers nothing and
> branches to `0x8000`. See
> [artifacts/dsp-boot-word-01/result.md](../artifacts/dsp-boot-word-01/result.md).
>
> **That is not the same as knowing what the cell holds during reset**, and the
> corroboration originally offered for it does not survive scrutiny: the claim
> that it "decodes to exactly the download destination" is weak, because *any*
> value `0x80`-`0x83` yields entry `0x8000`. Only the low two bits carry content.
>
> **The board inspection that argued for a serial download is withdrawn.** It
> said the ASIC-to-DSP link was serial; the board says otherwise - the ASIC is
> on the DSP's 16 data pins and `IS` is connected to it, so the link is
> parallel. See
> [dsp-cpu-interconnect.md](dsp-cpu-interconnect.md). That removes the support
> for preferring the serial loader, but it does **not** promote the parallel
> one: the runtime read above is still a runtime read, and the reset-time value
> at data `0xffff` remains unmeasured. The harness's `host_write(0xFFFF, 4)` is
> now an unsupported choice rather than a corroborated one.
>
> Note also that a `0xffff` read is a `DS` cycle, so the ASIC answering it is a
> separate question from the `IS` decode that is now established.
>
> The two loaders and the argument for the parallel one are kept below because
> the loaders are real and the reasoning is what led to the measurement - but
> the conclusion it was reaching for is superseded.

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

## What settled it

The board, via the RAM-monitor rig that recovered the ROM. `--boot-word` builds
a DSP kernel that reads one data address sixteen times and mails the values
back. All sixteen read `0x0083`.

Decoding that against the dispatch above: `0x0083 & 3 == 3`, which falls past
all three tested branches to `0x0696`, where the loader moves
`(0x0083 << 8) & 0xfc00 = 0x8000` into `@66` and does `bacc`. **It transfers
nothing and branches to program `0x8000`** - the resident's origin, and the
address the supervisor's download targets. The entry is carried in the boot
word's own bits 7:2.

Running the recovered ROM in the emulator with each candidate confirms the
decode:

| boot word | outcome |
|---|---|
| `0x0083` (measured) | reaches program `0x8000` |
| `0x0004` (what the harness assumes) | parks at `0x06dc`, the serial loader's wait |
| `0x000c` (the parallel hypothesis) | parks at `0x0779`, the XF/BIO loader's wait |

So the ASIC writes the resident into the DSP's external RAM directly - the two
`CY7C199` at program `0x8000`-`0xffff` - while the DSP is held in reset, and
releasing reset is the "go". That is also why the download sequence has no "go"
command after it, which `dsp-map-302.md` noticed and explained differently.

**What the harness does is therefore wrong in mechanism but right in outcome.**
It writes 4 to `0xffff` and serialises the supervisor's transfer through the
ROM's serial loader; the resident ends up at `0x8000` either way, which is why
this never showed as a failure. Modelling it faithfully means the ASIC placing
the resident in DSP RAM and the ROM warm-starting - simpler than what is there
now.

### The caveat

The read was taken while the modem was running normally, after its own
download. What is strictly measured is that the ASIC holds `0x0083` there
**during normal operation**; that it holds the same value during the reset
window is an inference. Sixteen identical reads make it a held level rather
than traffic, and it decodes to exactly the download destination, which a stale
mailbox word would not do by chance.
