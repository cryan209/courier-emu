# ATG monitor in stock 2.3.33 (static, not yet run on the board)

Physical addresses, `2_3_33.XMF` loaded at `0x40000` (physical = file + 0x40000).
Code segment for the command module is `0x813C` (from the ATI table: `jmp cs:[bx+1477]`
at `0x8280e`, table at `0x82837`).

## Route

Main AT letter table at `0x85ea0` (cs-relative words): `G` = `10ef` -> `0x824af`.
No dial-security or password test on the way: `[0x178]` bit 0, which gives
`[ ACCESS DENIED ]` for ATI10, is not tested by G. **No `LK2` prefix** (7.6.7
needs one; 2.3.33, like 4.03d, does not).

| Form | Handler | Action |
|---|---|---|
| `ATGSI` | `0x824df` | queue word `8000` (6770:077b), print `ta_report_si_read=` + `[0x281]` |
| `ATGSIhhhh` | `0x824c2` | queue `ff00 0084 hhhh` |
| `ATGT` | `0x8252d` | 8-word x16 dump at `0000:(([0x2b8]-e0)&fff0, min 5700)` - the saved stack |
| `ATG=[seg:]off` | `0x83c00` | 256 bytes from `es:[bx]`; no `seg:` means segment 0 |
| `ATGR[seg:]off` | `0x83c6b` | 128 words, same addressing |
| `ATGIport` | `0x826ba` | one `in al, dx` |
| `ATGBport` | `0x83ccd` | 16x16 consecutive `in` - **256 ports, disruptive** (see docs/probing.md) |
| `ATGOport,val` | `0x826da` | one `out dx, al` - **write** |
| `ATGN` | `0x825cb` | sets bit 0 of `[0x29c]` (403: `[0x158]`) |
| `ATGU` | `0x82702` | `clc; ret` |
| `ATGhhhh` | `0x8257e` | parse, then `57bb:21ab` (403: `8000:1ef1`) |
| `ATGhhhhdddd` | `0x8258e` | queue `ff00 hhhh dddd` via `6770:0777` |
| other lengths | `0x825ad` | parse, then `57bb:21a7` (403: `8000:1eed`) |

Queue helper `0x67eab` is the 403's `0xf678` byte for byte except the cells:
ring `0x2e0..0x30f`, tail `[0x2dc]`, head `[0x2de]` (403: `198..1c7`, `194`/`196`).
Same silent drop when fewer than 6 bytes free - serial `OK` still is not delivery.

## The mailbox: the INT0 handler at `0x67700` (vector `0x0c` -> `6770:0000`)

Same register layout as the 403. Status is `in 1e`/`in 1c`, masked to 2 bits, kept in `[0x2c6]`:

* **bit 0, host->DSP empty:** take the next queue word. Pending pair state in `[0x2ca]`
  (sentinel `7f3f`); a word whose high byte is `ff` starts a pair (`0x67881`). A single
  word `hhll` goes out as **tag `00hh`, data `00ll`**: `58`=hh, `5a`=0, `5c`=ll, `5e`=0.
* **bit 1, DSP->host ready:** tag from `5a:58`; tags `>= 0x80` are ignored. Tags
  `7c`/`7b`/`7d`/`7e` copy data (`5e:5c`) to `[0x283]+[0x285]` / `[0x287]` / `[0x27f]` / `[0x281]`,
  then `call [0x2da]` dispatches the rest.
* Acknowledge: `out 1c` with `[0x2c6]` (low byte, then high byte). End of interrupt via `[ff02]=8000`.

So reading `58`..`5e` with `ATGI` is passive, as on the 403. The code I first took for the drainer
(`0x68241..0x6836d`: status bits at `18`/`1a` selecting `dx` = `54`/`58`/`5c`) is **not** the mailbox;
unidentified.

## ATGSI

The same diagnostic the 3453B carries (courier_firmware_analysis.md, "The DAA identity arrives as
mailbox tag 0x7b"): `ATGSI` queues single word `8000` (tag `0x80`), yields three times, prints
`[0x281]` (the last tag-`0x7e` line-side register read: RDTN/RDTP ring bits). `ATGSIhhhh` queues
`ff00 0084 hhhh`, the line-side register **write**; the supervisor itself sends `0084:1468`,
`0084:1408`, `0084:3100`, `0084:0502`. Its own line poller (`0x5ab64..`, state in `[0x686]`) sends
`8000` and `7c00` only when `[0x287] & 0x10`.

**This board's DAA rev is `0x0013`** (`[0x287]`, and ATI7). Bit `0x10` set, so the SI path is
live on real hardware - the value the 3453B notes could only guess (they used 4).

## What it does and does not give

* Any 80186 memory (RAM, flash, peripheral control block via `=`/`R`) - read-only.
* Any single I/O port read; port writes via `O`.
* DSP commands by tag through the normal queue.
* **No direct DSP memory read.** That needs a DSP-side handler for a tag, as before.

Other: hidden `ATI92` (`0x845f2`, not in the ATI table) prints current/stored `+p` (V.92) settings.

## First board reads, 2026-10-03 (`atg-first-reads.txt`)

Idle, on hook, 19200. `AT` answered before and after.

* `ATG=0000:0000` printed the 256 bytes and then **`ERROR`**. Firmware quirk, matches the
  code: the `=` handler consumes the `:` with `lodsb` but never `dec cx` (`0x83c0b`),
  while `R` does (`0x83c7b`), so `=seg:off` leaves the parser one character out.
  The dump itself is good; `ATGR` with a segment answers `OK`.
* IVT: most vectors are `57bb:xxxx` (supervisor), some `7a4d:`; **INT0 (vector `0x0c`)
  -> `6770:0000`**, the module holding the DSP queue helper; vector `0x0a` (DMA0) ->
  `0000:2070`, a handler in RAM; vector `0x16` -> `d4a0:0000`.
* Queue: tail `[2dc]` = head `[2de]` = `02ee` -> empty. The ring holds stale
  `ff00 000f 0600` frames repeated, plus one `5700 5800 0600` - the idle supervisor
  sends tag `000f`, data `0600`, routinely.

## ATGSI on the board, 2026-10-03 (`atgsi-reads.txt`, `atgsi-mailbox.txt`)

* Cells before and after: `[0x27f]`=0, `[0x281]`=0, `[0x283]`=0, `[0x285]`=`00ff` (the "no reading"
  sentinel), `[0x287]`=`0013`.
* Three `ATGSI`: three `8000` words queued (`2ee`->`2f4`) and drained. Each printed
  `ta_report_si_read=0000`.
* Mailbox holding registers before and after: tag `0047`, data `0007`, unchanged. **No tag-`0x7e`
  reply arrived**; the printed 0000 is the stale cell, not a reading. On hook, line state unknown.
  Whether DSP 2.1.41 handles tag `0x80` at all is not established - its dispatcher is not laid out
  like 3.x (no `lar ar1,#ff5e` pattern in the resident).

## Against the Si3034 datasheet (Si3021 + Si3014; `docs/SI3034.PDF`, Rev 2.02)

The `0x84` data word fits the Si3021 secondary-frame control word exactly (Figures 26/27):
`D15:14 = 00`, `D13` = R/W (1 = read), `D12:8` = register, `D7:0` = data.

| supervisor sends | decodes as |
|---|---|
| `0084:0502` | write reg 5 (DAA Control 1) = `02`: OHE, off-hook pin enabled, on hook |
| `0084:0100` | write reg 1 (Control 1) = `00` |
| `0084:3100` | **read** reg 17 (International Control 2: MCAL CALD LIM BTE ROV BTD), sent only when `[0x287]&0x10` |
| `0084:1468`, `0084:1408` | reg 20 - outside this datasheet's map (it stops at 19) |

So `ATGSIhhhh` is a raw Si3021 register access, write or read, not only a write.

`[0x287]` = `0x0013` is **not** raw reg 13 (that would give REVB = 4, which isn't in Table 21). It does fit
`CBID<<4 | REVB`: CBID = 1 (international line side - this is a CTR21 unit) and REVB = `0011` =
**Si3014 rev C**. On that reading the firmware's `& 0x10` gate is "international line side",
and `== 4` is CBID 0 with REVB 4. This is a best fit, not confirmed.

The ring bits in the datasheet are reg 5 D6 (RDTN), D5 (RDTP) and D2 (RDT). The supervisor's tag-`7e`
consumer tests bits 0 and 1 of `[0x281]`, so the DSP repacks before replying - or reads something
else. The 80186 never sees a raw Si3021 register; the DSP masters the link, so reply formats are
the DSP's.

## Ringing, 2026-10-03 (`atgsi-ring-live.log`, `ring-now.log`)

Line connected and ringing; the AA LED flashed with each ring (live S0=000, so AA is otherwise dark).
With Q0 set (volatile), over ~30 s: **S1 stayed 000, no `RING` result, RI never high**, `ATGSI` 0000,
reply cells and mailbox (`0047:0007`) unchanged. So something drives the AA LED on ring, but the
supervisor never counts a ring and no tag-`7e` reply arrives. Untested candidates: ring
qualification (cadence/frequency for a CTR21 build on this line) rejecting the ring after the
raw detect, or the LED being driven from the raw ring-detect line rather than the counted ring.

### The ring handler, `0x6e3c9..0x6e58c` (static, plus a RAM dump taken after ringing)

Live S-registers sit at `0x902` (S0), so S1 = `[0x903]`, S70 = `[0x948]` (found by dumping
`0000:0000..3fff` with `ATG=` and matching the ATI4 values. A second matching run at `0xa67` is not the live copy; its role is unchecked).

* S70 (distinctive ring types) is counted first (`[0x1d9e]`). With S70 = 0 no type is enabled and the
  handler accepts any ring (`[0x1d9c]=0`, `[0x1d9d]=2`). **S70 is not blocking a US ring.**
* `0x6e52d`: `cmp [0x902],0 ; je 0x6e56d` - **with S0 = 0, S1 is never incremented.** S1 reading 000
  while ringing is the firmware's behaviour with auto-answer off, not evidence of a rejected ring.
* Otherwise: `inc [0x903]`; when S1 >= S0 it queues word `7a00` to the DSP (tag `0x7a` - answer)
  and raises event 9; below S0 it raises event 3.
* Events go through `57bb:c73a` -> `call [0x2ac]`. Idle, `[0x2ac]` = `a7b0` (`0x62360`), which acts
  only on events 0 and 9, so with S0 = 0 the ring raises event 3 into a handler that ignores it.
* The RAM after ringing shows the handler ran: `[0x1da4]` = 2 (latched from `[0x1d9d]`),
  `[0x1f60]` copied from `[0x1f57]`.
* Where the `RING` text and RI come from is still not located.

### S0=9 test (`ring-s0-9.log`, volatile ATQ0S0=9, restored to S0=0 after)

US-cadence ring. S1 counted 1..8 at ~6 s intervals (2 s on / 4 s off), so the ring is detected,
qualified and counted. At the 9th ring the modem answered (serial went quiet), then `NO CARRIER`
~4 s later. **No `RING` result was printed at any point, even with Q0.** So ring counting works
and the open question is only the `RING` result code (and RI), not ring detection.
