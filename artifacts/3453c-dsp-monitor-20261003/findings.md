# 3453C DSP monitor feasibility, 2.3.33 / DSP 2.1.41

Static analysis and isolated DSP execution, 2026-10-03. No serial device opened,
firmware flashed, or flashable image produced. Reproduce with:

```
.venv/bin/python artifacts/3453c-dsp-monitor-20261003/analyze.py
```

## Recovered receive path

The resident is XMF file `002F0..0CEAF`, loaded at DSP program words
`1000..75DF`. The low program module (overlay index 7) is file
`12B20..14B1B`, linked at `0000..0FFD`; the isolated replay explicitly loads it.
Do not assume this module is the DSP's internal mask ROM or is present at reset.

The DSP receive routine is program `12B1`:

- `IN @7d,8057`, test bit 0 for a pending host request.
- `IN @7d,805e` reads its tag; `IN @7a,805f` reads its data.
- Write 1 to `8057` to acknowledge the host request.
- Load the tag, subtract `87`, return for signed-positive results, then add
  `1394`, table-read the handler address, and BACC to it.
- The actual table base is `130D` (`1394 - 87`), 136 words for tags `00..87`.
  Its XMF file base is `0090A`. `commands.json` records each entry and source offset.

The dispatcher uses I/O space, unlike the newer memory-mapped ff5e pattern.
Full-word/high-bit tags are not a safe extension mechanism: the existing bound
is a signed comparison. A monitor prefilter must match exact tags and preserve
stock behavior for all other inputs.

## Stock tag 80 is implemented

Table slot `138D` -> `1292`. It indexes a second table at `129D` using
`(data[012F] >> 8) & 7`:

| State | Handler | Behavior |
|---|---|---|
| 0 | 1137 | Return without a reply |
| 1 | 12A3 | Queue tag 7B, then derived identity data; clear 012F |
| 2 | 0064 | Queue tag 7C, then derived value; clear 012F |
| 3 | 0074 | Queue tag 7D, then low byte of 012F; clear 012F |
| 4 | 0078 | Queue tag 7E, then low byte of 012F; clear 012F |
| 5 | 1137 | Return without a reply |
| 6 | 1137 | Return without a reply (static table) |
| 7 | 1137 | Return without a reply (static table) |

Tag 84 -> `126D`: bit 13 of the request selects `0055`, which sets
`data[012F]=0400` and enters the line-side request path at `1175`. Writes go
to `112B`. This establishes that tag 80 polls a pending result rather than
unconditionally starting a ring-register read. It explains a possible reason
for stale ATGSI output, but does not establish the live state on the board.

`replay.json` records eight passing isolated cases: states 0..5 for tag 80,
no-op tag 6C, and unsupported tag 88. State 4 with fixture 012F=0403 returns
7E:0003. Tests run actual firmware instructions with fixture RAM and an ASIC
acknowledgement adapter in the repository's C51 core; no C52 boot/timing or
hardware equivalence is claimed.

## Reusable reply path

`12C8` checks room for a multiword reply (six spare ring words); `12D3` queues
one word. Data[78] is the producer and data[79] the consumer; the ring is
`7FC0..7FCF`, with `AR0=7FD0` used for wrap checks. A tag word with bit 15 set
signals a following full data word. `12E4` sends replies:

- check status 8057 bit 1;
- output the tag with bit 15 removed to 805E;
- output a following word to 805F when flagged;
- write 2 to 8057 to notify/acknowledge the outbound transaction.

A monitor should use the existing room check, not enqueue twice blindly: a
full ring must not leave a tag without its data word.

## Concrete patch design

First milestone: identity echo and one-word program/data reads, on hook.
Proposed request tags 0088 (identify), 0089 (data read), 008A (program read)
are outside the stock table. These are design placeholders, not working stock
commands. Stock ATG already sends full tag/data pairs, so requests can be
entered as ATG00890000, for example, after a monitor is installed.

1. Replace the two-word instruction pair at program `12C0..12C1`
   (`LACL @7d; SUB #87`) with a two-word branch to a verified monitor trampoline.
   On an unmatched request, replay those instructions and branch back to `12C2`.
   Preserve DP, ARP/register expectations and stack behavior of the stock path.
2. Exact-match the proposed tags. Use request data[7A] as the 16-bit address.
   Read program space with TBLR and data space with an indirect load, keeping
   those operations separate. Restrict initial data reads to verified RAM;
   arbitrary data-space reads can touch peripheral registers.
3. Use a dedicated reply tag below 80 (provisionally 7F), plus the full value
   word, through the existing ring. The supervisor discards tags >=80.
4. Patch the 80186 receive path at physical `67700` to intercept the dedicated
   reply before stock dispatch through [02DA]. Add a bounded serial query that
   reports a value or timeout and correlates replies to the requested operation.
   Reading holding ports alone is vulnerable to other DSP replies overwriting them.
5. Add writes only after echo and reads work, with an explicit address/value
   transaction and acknowledgement. One stock tag/data request cannot carry
   both a 16-bit address and 16-bit write value, so writes need a defined
   staged protocol or a longer serial command.

## What prevents a flashable patch today

- No code cave is yet established as safe in every relevant DSP overlay/state.
  Blank bytes are not sufficient proof. The first hook is located, but its
  destination must be allocated by tracing program references and loader bounds.
- XMF/loader acceptance checks and firmware checksum handling need to be
  decoded and tested against the unchanged image before exporting a patched one.
- The full 3453C boot fails in the current emulator because its first-download
  mask-ROM loader differs from the recovered 302/403 loader. Isolated function
  tests bypass that boot and cannot validate an upgrade or reset.
- The repo has a captured boot block and stock XMF, but a tested recovery
  transfer for this exact board is still needed before the first flash.

A stock-only pre-step could send a defined raw Si register read and then ATGSI,
but this analysis did not send any commands to hardware. The practical next
engineering work is safe code allocation and a reproducible patched-image
builder with checksum verification, followed by an emulator monitor prototype.

## ATXMODEM option 1 confirmed in the 2.3.33 application

The user identified this readback route. Static verification confirms the X
handler at physical `82D22` explicitly matches the suffix `MODEM` followed by
NUL and calls `777C:1EBE` (`7967E`). The menu text includes
`(1) Read firmware` and `(2) Write firmware`. The option parser at `79978` compares AL with
ASCII 1 and branches to `79994`; that path initializes the source segment
cell `[2710]` to `4000` and prints `Start Xmodem-1K receive now.` before
calling the sender setup at `7A18C`. Option 2 takes a separate path at `799C5`.

Thus ATXMODEM is a real application command on this image. The older-family
warning in courier_firmware_analysis.md that ATXMODEM was merely shorthand
must not be generalized to 3453C 2.3.33. Option 1 can supply the board's
application-flash capture for byte comparison against the local XMF. Its
exact end bounds and transfer framing still need verification; do not assume
it captures the parameter sectors, boot block or internal DSP mask ROM.
No hardware transfer was started by this analysis.

### Option-1 bounds recovered

Sender routine `7A32B` compares paragraph count [271A] with B800 before EOT.
The source begins at segment 4000, so option 1 covers exactly physical
40000..F7FFF (B8000 bytes), excluding parameter sectors and the boot block.
The live menu prompts `Start Xmodem-1K receiver`, not the earlier wording
recorded from a neighboring inline string. The read capture is stored under
`artifacts/3453c-firmware-read-20261003/`.

### Hardware readback result

ATXMODEM option 1 captured B8000 bytes in 736 CRC-valid 1K blocks, zero
retries. The capture matches the local 2_3_33.XMF byte for byte, SHA256
c8d44a1c984a203f6e9a91b14c77382706ea05fc2b860081f986c47b6fa7c41e.
Raw frames were independently revalidated offline. ESC exits this application
menu by resetting the modem; AT OK was confirmed after reset. Thus the
firmware identity and patch baseline now have hardware byte-level verification.
