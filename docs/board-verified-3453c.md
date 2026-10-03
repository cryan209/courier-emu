# What the 3453C board has confirmed

A Courier V.Everything V.92, "CTR21 External", on `/dev/cu.usbserial-FT4TQOFT` at
19200, first probed 2026-10-03. Stock firmware - no ID_SDL - and it is exactly the
image the repo already carries, `docs/3453C_v2.3.33/2_3_33.XMF`. Raw captures are in
`artifacts/3453c-board-identity-20261003/` and `artifacts/3453c-parameter-sector-20261003/`;
the working notes behind every address below are
[atg-monitor-2.3.33.md](../artifacts/3453c-board-identity-20261003/atg-monitor-2.3.33.md).

Unless a section says otherwise, everything was read with `AT`, `ATI*`, `ATGSI` and
`ATG=`/`ATGR` memory reads. Exceptions, all session-only: `ATQ0`, `ATS0=9` (the modem
answered one call), and `AT~C#0` (country switched to US/Canada in RAM).

> **The capture `f8000-fbfff.bin` holds the stored dial-security password in clear**
> (sector offset `0x5f`). Do not commit it. `at-screens.txt` has it redacted.

## Identity

| | |
|---|---|
| `ATI7` | supervisor **2.3.33** (05/03/11), DSP **2.1.41** (06/04/08), DAA rev `0013`, 25 MHz, 1024k flash, 256k RAM |
| product | `ATI0` `5608A`, product ID `99345303`, options HST V32bis Terbo V34+ V90 V92 |
| `ATI1` | `13D9` |
| serial | `5MBSXA6P0183` (also at parameter-sector offset `0x11`) |
| DAA | Si3034 chipset, Si3021 + Si3014 - datasheet now at [SI3034.PDF](SI3034.PDF) |

Physical address = file offset + `0x40000` throughout. The XMF covers `0x40000..0xf7fff`
only; the parameter sectors and the boot block above it are on the board and now captured
(below).

## ATG: a full monitor, no prefix, no gate

Stock 2.3.33 carries the ID_SDL-style monitor. Main AT table `0x85e50` (indexed from `!`,
with `~` remapped past `Z` by the dispatcher at `0x816a5`); `G` -> `0x824af`. No `LK2`
prefix (7.6.7 needs one) and no dial-security check.

| form | effect |
|---|---|
| `ATGR[seg:]off` | 128 words from `es:[bx]` - **use this one** |
| `ATG=[seg:]off` | 256 bytes; with `seg:` it prints the dump then `ERROR` (the handler skips `dec cx` after `:`) |
| `ATGIport` / `ATGOport,val` | one port read / **write** |
| `ATGBport` | 256 consecutive port reads - disruptive, as on the 403 |
| `ATGhhhhdddd` | queue `ff00 hhhh dddd` to the DSP |
| `ATGSI` / `ATGSIhhhh` | tag `0x80` / tag `0x84` with a raw Si3021 control word (below) |
| `ATGT`, `ATGN`, `ATGU`, 4-hex | as on the 403 |

Hidden `ATI92` prints the V.92 `+p` settings.

## Mailbox: the 403 layout

INT0 (vector `0x0c` -> `6770:0000`, handler `0x67700`) services it. Status `in 1e`/`1c`;
bit 0 sends the next queue word (ring `0x2e0..0x30f`, tail `[0x2dc]`, head `[0x2de]`;
`ff` high byte starts a pair, a single word `hhll` goes out as tag `hh` data `ll`); bit 1
reads tag `5a:58` (tags `>= 0x80` ignored) and data `5e:5c`. Tags `7c`/`7b`/`7d`/`7e` land
in `[0x283]+[0x285]`/`[0x287]`/`[0x27f]`/`[0x281]`, the rest go to `call [0x2da]`. Ack is
`out 1c`, so **`ATGI0058`..`005E` reads the last reply without consuming it**. The idle
supervisor sends `ff00 000f 0600` routinely; the last reply at idle was `0047:0007`.

## The DAA, decoded against the Si3034 datasheet

* Tag `0x84`'s data is the Si3021 secondary-frame control word: `D13` = read, `D12:8` =
  register, `D7:0` = data. `0084:0502` writes reg 5 = `02`; `0084:3100` **reads** reg 17;
  `0084:1468`/`1408` address reg 20, which the datasheet does not list.
* Tags `7d`/`82`/`83` carry the country table's "Impedance match byte" and "SI DAA register
  17/18" (`0x677ff`) - Si registers 16, 17, 18. CTR21's `0x2c` in reg 16 is complex AC
  termination with TBR21 DC termination. That accounts for the `0x82`/`0x83` traffic the
  3453B notes could not place.
* DAA rev `[0x287]` = `0x0013`. Bit `0x10` is set, which opens the supervisor's SI polling.
  It is not raw reg 13; `CBID<<4 | REVB` (international line side, Si3014 rev C) fits, unconfirmed.
* `ATGSI` on hook, three times, and again while ringing: requests drained, **no tag `0x7e`
  reply ever came back**. Whether DSP 2.1.41 handles tag `0x80` is open.

## Country: `AT~C`

`AT~C?` lists 28 tables, `00:US/Canada` .. `27:Turkey`; this unit is **08, CTR21**.
`AT~C#n` sets `[0x173]` and `[0xa37]` and copies table `n` (`7b59:0d42 + n*0x80`) to RAM
`0x1f71`; tested with `n` = 0, and `ATI7` then reads "US/Canada External". It does not
resend the Si registers (the last `7d` in the queue stayed `2c`). `[0xa37]` is
parameter-sector offset 1, so the stored country is `08` until something rewrites the sector.
`AT~X!` restarts into the loader - do not send. `~F!`, `~C!`, `~P?`, `~P!` are unread.

The country table's own dump routine (`0x7d898`) labels every field;
`country-params-live.txt` is the live CTR21 table decoded with those labels.

## Ringing

A US ring (2 s on / 4 s off) on the connected line:

* is timed: `[0x1d94]` = 1 during a burst, `[0x1d90]` counts it to ~`0x1a0`, `[0x1d96]` latches it;
* passes the CTR21 qualifiers (13-80 Hz, >= 200 ms, silence before RING 1.2 s) and the US ones;
* is counted, but **only when S0 > 0** - `0x6e52d` skips the S1 increment at S0 = 0. With
  `ATS0=9`, S1 went 1..8 at ~6 s intervals and the ninth ring answered (`NO CARRIER`);
* flashes AA - and **never prints `RING`**, with Q0, with nothing else using the port,
  passively listened, under both CTR21 and US tables. RI never asserted (may not be wired
  through the adapter).

The ring counter reports through `57bb:c73a -> [0x2ac]` as event 3 or 9, and every
`[0x2ac]` state ignores event 3. The result printer is `0x62ee1` (`RING` = code 2,
table `0x80187`, Q in `[0x953]`); its caller `0x5b565` is reached indirectly. Where code
2 is issued is not found.

## Parameter sectors and boot block

`f8000-fbfff.bin`: four 4 KiB sectors, all programmed, versions `0x39`..`0x3c`, **all four
checksums valid** under `parameters.checksum`. The newest is a byte-for-byte copy of RAM
**`0x0a36`** - not `0x0a06` as in `main211` - so offset `n` is RAM `0x0a36 + n`:
`0x00` flags `c0`, `0x01` country `08`, `0x11` serial, profile from `0x30`.

`fc000-fffff.bin`: the boot block, which no image in the repo carries - the SDL Xmodem
recovery loader and the reset vector `cli; mov dx,ffa4; mov ax,8000; out dx,ax; jmp fc00:1d11`.

## What is still needed

1. **The DSP's first download - the 3453 family's own loader.** `./courier run 2_3_33.XMF`
   stops at "C51 mask ROM did not arm its NMI vector", because the bridge maps the mask ROM
   only when the resident leaves `MP/MC` alone (`boot_rom.maps_onchip_rom`). The C resident
   sets `MP/MC = 1`, but only in its own prologue, after it has been downloaded; at reset
   `MP/MC` is the pin, and this board's DSP boots.

   Mapping the ROM at reset anyway (a `sitecustomize` patch of `maps_onchip_rom`, no repo
   change) gets the NMI armed and the loader running, then fails at the second group:
   **"C51 ROM loader did not acknowledge strobe 1"**. The recovered loader (`0638..0652`,
   from the 20.16 MHz 302/403-family board) takes group 1 on strobe 1 from window `0x58`
   and group 2 on **strobe 2** from `0x5c` - the 403's `out 18,1` / `out 18,2`
   ([c51-cpu-loader.md](c51-cpu-loader.md)). The 3453 download at `0x66700` instead sends
   group 1 to `40..4e` with `out 1e,1` and group 2 to the port in `[0x1ff3]` with the strobe in
   `[0x1ff2]` - and **every 3453 image hard-codes those to `0x40` and `1`**: 2.1.1 (`0x69cb5`),
   2.2.05, 2.3.12 and 2.3.33 (`0x666bc`; the board's RAM reads `1`/`0x40`). Both halves of
   every block go through one window on one strobe.

   So the whole 3453 family speaks a first-download protocol the repo's mask ROM does not
   implement. **The same failure now stops `main211`**: it was introduced by `f01e9d8` ("Gate
   the DSP mask ROM on the part"), which first mapped that ROM for B-series XMF images;
   `f01e9d8~1` boots `3453Bv2.1.1.xmf` cleanly, `f01e9d8` and `HEAD` do not. Either the 3453
   DSP has a different mask ROM, or its ASIC turns the `0x1e` protocol into the loader's 1/2
   alternation. Settling it needs the 3453 DSP's part marking and, ultimately, its own ROM - a
   [ROM probe](dsp-rom-probe.md) on this board, which is invasive.
2. **A parameter-sector path for 2.3.33.** `courier_emu/parameters.py` is the 3453B layout
   at RAM `0x0a06`; this image reads it at `0x0a36`, and a real sector now exists to feed it.
   Untestable until item 1 lets 2.3.33 boot.
3. **Why `RING` is never printed** - the issuer of result code 2.
4. **Tag `0x80`'s handler in DSP 2.1.41**, and the 2.x DSP's receive dispatcher generally; it
   is not laid out like 3.x (no `lar ar1,#ff5e` pair in the resident).
5. **The rest of flash** (`0x40000..0xf7fff`) against the XMF, by `ATGR` or `ATXMODEM` option 1,
   to confirm the board runs this image byte for byte. `ATI1 = 13D9` has not been computed
   from the image either.
6. **Board parts**: DSP, RAM and ASIC markings and the Si3021/Si3014 placement - nothing here
   was read off the hardware itself.
