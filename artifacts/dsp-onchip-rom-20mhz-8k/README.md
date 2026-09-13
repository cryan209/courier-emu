# The 20.16 MHz board's full 8K on-chip ROM

Board: ID_SDL v4.03d, supervisor 7.4.16, DSP 3.1.2, 20.16 MHz, serial
`0009540034268322` - the unit `artifacts/courier-board-21210-capture-403` and
`artifacts/dsp-onchip-rom-01` came from. Read 2026-09-13 on
`/dev/cu.usbserial-FT4TQOFT` (the adapter name the 25 MHz board also used; the
serial number and clock are what identify the unit, not the port).

Eight 1K windows, `c5x-onchip-rom-8k.bin`,
`sha256 d57bc46e1bcd6d4dc8872b97bba2d98ba8fb6b8661440c566b534f0b3f82fac9`.

## It is the same part, and mostly the same ROM

`memtest` is **word-for-word identical** to the 25 MHz board's
(`artifacts/dsp-memory-test-2806/run-a`): `PMST` = `00b0`, `MP/MC` = 0, `RAM`
and `OVLY` already set, `0x0800` and `0x1800` ignoring a write and `0x2400`
following it. Both boards carry a **'C51**.

| region | 20.16 MHz | 25 MHz |
|---|---|---|
| `0000`-`077F` | boot code, 1920 words | **byte-identical** |
| `0780`-`0F7F` | array pattern | array pattern |
| `0F80`-`0FFF` | **array pattern** | **a copy of the `1F80` block** |
| `1000`-`1F7F` | array pattern | array pattern |
| `1F80`-`1FFF` | 128-word mailbox block | **byte-identical** |

Everywhere the ROM is genuinely programmed the two parts agree exactly. The
whole difference between the two 8K images is **96 words at `0x0F9D`-`0x0FFC`**.

## The 0x0F80 block is not mask content

An earlier commit called it "a 128-word block the mask carries twice, at `0x0F80`
and `0x1F80`". That is wrong. The mask carries it **once**, at `0x1F80`. The
25 MHz part also returns it from `0x0F80`; this part does not, and returns pure
array pattern there.

Neither reading is a fluke - each board was read through two independent
execution paths, a kernel at external `0x8000` and a gadget staged into on-chip
SARAM, and on each board the two paths agree with each other:

| | via `0x8000` | via SARAM |
|---|---|---|
| 25 MHz, `0F80` block | present | present |
| 20.16 MHz, `0F80` block | absent | absent |

So it is a property of the part, not of the read. A mask that duplicated a block
on one die and not another is not credible, which leaves a decode difference -
the top row of the array answering with `A12` treated as a don't-care on one part
- as the likely shape. **Not established**, and nothing here depends on it: the
programmed ROM is `0x0000`-`0x077F` plus `0x1F80`-`0x1FFF`, identical on both.

## Reproducing

Same runner as the 25 MHz set:

```sh
python artifacts/dsp-onchip-rom-2806/run-board.py \
    artifacts/dsp-onchip-rom-20mhz-8k/at0c00 /dev/cu.usbserial-FT4TQOFT
```

Every run restored the board - `AT` answering and the timer-0 vector back,
checked each time.
