# 3453C watchdog clock investigation

The immediate watchdog abort was caused by two board/CPU interrupt-model
mismatches. No C52 opcode or interrupt-recognition change was needed to fix it.
The C52 serial clock and stock codec setup are already executing.

## Recovered watchdog behavior

The original firmware increments byte `[0176]` in the mailbox INT0 handler at
physical `67704`. At 25 interrupts without a reset it sets `[0694]=80`.
The line-qualification routine tests that flag and returns an error.

The installed vector table is decisive:

| Vector | Physical handler | Role |
| --- | --- | --- |
| `0C` | `67700` | DSP/ASIC mailbox service; raises the watchdog counter |
| `0F` | `58693` | External board tick; resets the counter at `58750` |
| `08` | `58DD4` | Internal timer-0 handler, just EOI/IRET at this point |
| `12` | `7A925` | DTE timer-1 handler |
| `13` | `7A9EB` | DTE timer-2 handler |

The prior codec audit's suggestion that internal CPU timer delivery was the
missing watchdog reset was too broad. Enabling those interrupts changes the
DTE/loader paths and does not deliver the required external tick.

## Fixes

1. Select `EbInterruptController` for the 2.3.x supervisor. The legacy
   DMA-equipped controller used consecutive IMASK positions with INT3 at
   bit 6. The 80C186EB has a reserved bit 1, serial at bit 2, INT4 at bit 3,
   and INT0–INT3 at bits 4–7. Consequently, a firmware mask can disable INT2
   while leaving INT3 enabled. The old model wrongly blocked the tick.
2. Recognize the mailbox ISR's IRET at `677F1`. The legacy injected-mailbox
   service marker only recognized older firmware return addresses. It stayed
   asserted after the 3453C handler returned, suppressing later board ticks.

Both fixes retain firmware mask handling. They do not clear the guest
watchdog flag or counter directly. Its original handler performs the reset.
The controller map is documented in the local Intel manual
[270830-003](../../docs/270830-003%2080C186EB%2C80C188EB%20Microprocessor%20Users%20Manual-Feb95.pdf),
Table 4-1 and Figures 8-4/8-8.

## Execution evidence

- `baseline.json`: 3 million instructions before these fixes, no watchdog
  reset-handler hits, one qualification abort, `[0694]=80`.
- `eb-controller.json`: 10 million instructions with the fixes, **357 tick
  reset-handler hits**, no qualification-abort hits, `[0694]=00`. Hook remains
  asserted while the firmware qualifies the line. Codec reads advance from
  zero to 27 in this standalone disconnected-line diagnostic.
- `interrupts.json`: historical diagnostic that enables internal timer
  interrupts while retaining the old timer-read behavior. It fails during a
  DSP overlay transfer at BMAR `00B4`; this is not the chosen fix.
- `full-real.json`: historical diagnostic enabling internal timer reads and
  interrupts with real delays. The resident boots and clocks, but DTE input
  remains queued in a pre-command wait. Again, this is not the chosen fix.

`timer_interrupts` in the machine result is a historical counter that also
includes injected mailbox-service interrupts; it is not proof that the
watchdog tick came from an internal timer. `ticks` and the PC watch at
`58750` show the external tick and the actual firmware reset.

The full I-modem retest runs 150 million analog and 400 million I-modem
instructions. The analog model delivers **6,791 board ticks**. Hook asserts
at instruction 2,308,756 and releases at 15,290,095, about **3 seconds**
later with this CPU timebase. The native codec clocks **222,509 frames** at
7,200 Hz. There is still **no CONNECT, incoming call or payload delivery**;
transmitted PCM remains silent. Call qualification/transport is still
incomplete despite the watchdog clock correction.

## Remaining C52/codec evidence

`codec_read_probe.py` isolates the original resident's serial read sequence:
it directly loads and initializes the stock resident, supplies a connected,
off-hook external line, then sends native mailbox command `7C:0000`.
That requests Si3034 register 12 (`2CFF`). The model's documented expected
status is `44` (frame detect plus modeled loop current).

The initial probe observed zero at every readback handler and pending cell
`012F=0200`. The serial model now queues DXR until FSYNC, raises XINT at
that boundary, and completes reception sixteen SCLKs later (SCLK = 256 × Fs).
The secondary read therefore completes before the following primary XINT,
without replacing DRR prematurely at that boundary. The updated
`codec_read_probe.json` shows `0044` at `11E9` and `11FC`, followed by
`012F=0244`. No guest reply cell or handler PC is patched.

The initial full pair retest in `readback-pair/` advanced into a DSP overlay
transfer and stopped with `3453C overlay mismatch at 3B21`. The focused
`readback-transfer-diagnostic/` run established a verification bug: the payload
was correctly installed at `7658`, with the firmware end marker `7F62=765C`.
The verifier had sampled foreground BMAR (`3B21`) before the resident restored
its saved overlay pointer at `1158`. It now checks the four words ending at
the firmware completion marker. A regression test runs the unchanged loader
with differing foreground BMAR and saved overlay destination.

The prior observation of repeated `7C`/`80` commands without codec reads
refers to the earlier run in `pair/`. The final retest after correcting the
verifier is stored in `readback-verified-pair/`.

## Final readback retest

`readback-verified-pair/` completes the configured 150 million analog and
400 million I-modem instructions without CPU/DSP or overlay-verification
errors. The native Si3034 clocks 244,369 primary frames at 7,200 Hz, with
52 register writes and 67 reads. The resident verifies 4,272 overlay words.
The completed PCM captures now contain nonzero audio: analog transmit peak
11,288 with 54,721 nonzero samples, and receive peak 2,703 with 58,828
nonzero samples, each over 275,200 samples. The preceding watchdog-only run
had entirely silent analog transmit PCM.

The I-modem reports `RING`, answers the ISDN bearer, and subsequently reports
`NO CARRIER`. There is no CONNECT or payload delivery in either direction.
The DAA readback and overlay-verifier corrections therefore remove the early
qualification/transfer stalls; successful carrier negotiation remains open.
See `readback-verified-pair/summary.json` for the final result.

## Validation and reproduction

**147 tests passed**, covering native C5x execution, audio clocks/acquisition,
3453C boot, UART status, watchdog clocks, native CPU execution, pair probe and
ASIC mappings. The new guest-execution tests exercise mailbox entry, EOI and
IRET alongside the board tick. They verify repeated tick delivery when INT3
is enabled and zero delivery when the guest masks it.

Run from the repository root:

```sh
.venv/bin/python artifacts/3453c-watchdog-20261003/probe.py \
  --parameters artifacts/3453c-parameter-sector-20261003/f8000-fbfff.bin \
  --output /tmp/3453c-watchdog.json

.venv/bin/python artifacts/3453c-watchdog-20261003/codec_read_probe.py

.venv/bin/python -m tools.probe_imodem_analog_pair \
  --analog-board 3453c \
  --analog-parameter-flash artifacts/3453c-parameter-sector-20261003/f8000-fbfff.bin \
  --protocol v90 --instructions 400000000 --analog-instructions 150000000 \
  --analog-send '3453C-TO-IMODEM-12345' --imodem-send 'IMODEM-TO-3453C-67890' \
  --output /tmp/3453c-watchdog-pair
```

Parameter-flash probes use disposable copies. Historical baseline/timer runs
record the code before the controller/ISR-return corrections; their exact
results should not be expected from the fixed default profile.
