# Reading the DSP's boot-mode word off the board

The on-chip ROM reads data `0xffff` at reset and dispatches on it. Bit 3 selects
the parallel XF/BIO loader at program `0x072c` over the serial one at `0x06d4`,
and bit 2 picks 16-bit over 8-bit pairs. See
[docs/dsp-boot-transport.md](../../docs/dsp-boot-transport.md).

The harness assumes `4` - serial, 16-bit. This measures what the board's own
ASIC presents there.

## The kernel

`build_boot_word_probe` in `courier_emu/dsp_probe.py`. It reads one DSP data
address 16 times and mails the values through the resident's outbound pattern -
the same sender that carried the ROM dump.

It samples one address repeatedly rather than sweeping a window, for two
reasons: the top data page is the ASIC's mailbox window, so a sweep risks
consuming something the firmware is using; and repetition is the actual
question, because a strap the ASIC holds reads the same every time while
mailbox traffic does not.

## Rebuilding the commands

```sh
python -m courier_emu.probe_transport --reference IDSDL302.ROM \
    --boot-word --output /tmp/bootword
python tools/emit_ram_writes.py /tmp/bootword/diagnostic-ram.bin \
    --base 0x3000 --output artifacts/dsp-boot-word-01/commands
```

## Delivery

Board: ID_SDL v4.03d, supervisor 7.4.16, DSP 3.1.2, 20.16 MHz, on the DTE port
at **57600 8N1**.

1. `place.txt` - 2120 `ATGLK2W` word writes covering `0x3000`-`0x408f`. RAM
   only; a power cycle undoes it.
2. `verify.txt` - `ATGLK2=` page dumps to check the placement.
3. `arm.txt` - points interrupt vector 8 at `0000:3000`, then Timer 0's `INT`
   bit starts the monitor.

**The vector this overwrites was `8000:108F` on this unit.** Restore with

```
ATGLK2W0020,108F
ATGLK2W0022,8000
```

or by power-cycling, which restores everything.
