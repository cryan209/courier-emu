# CPU–DSP parallel mailbox: board comparison, 2026-09-07

The NDX failure is now explained. Two faults masked one another: the core
omitted AR0 compatibility side effects, and PA7 writes incorrectly manufactured
download-ready status. Fixing NDX alone made the firmware enter that false
ready path and repeatedly download `FFFF`, including into its interrupt vector
area. This was not evidence of bad `*0+` addressing.

## Fresh hardware measurements

The connected board at `/dev/cu.usbserial-1420` reports ID_SDL 4.03d,
supervisor 7.4.16, DSP 3.1.2, 20.16 MHz. Both probe images were uploaded only
to RAM and read back byte for byte before execution. Both returned complete
checksummed frames. Afterwards AT answered, vector 8 was `8000:108F`, and
T0CON was `8021`. No stored settings or flash were written.

`artifacts/ndx-addressing-02/` contains 47 words from a uniquely marked probe:

- With NDX clear, direct, indirect, short-immediate and long-immediate LAR AR0
  all copy the loaded value to ARCR and INDX.
- With NDX set, those registers retain their independent sentinels.
- SAMM AR0 does **not** copy to ARCR or INDX under either polarity.
- The tested non-ARP-update indirect addressing modes agree with the core,
  including indexed addition/subtraction and reverse-carry addressing.

`artifacts/dsp-status-03/` contains 23 further words:

- PA7 reads `0002` before and after writes of `0200`, `0300`, and `0000`.
  These writes do not create incoming-download readiness or destroy bit 1.
- MAR increment/decrement of AR0 copies the resulting value to ARCR/INDX
  with NDX clear, and leaves them alone with NDX set.
- Loading AR1 does not copy to ARCR/INDX. Its accompanying first AR0 sample
  is incoming bootloader state and is excluded from emulator assertions.

The original `artifacts/ndx-probe-01/manifest.json` has incorrect decoded
fields for the first direct load. Its raw frame supports the later notes,
not those fields. The fresh captures remove that ambiguity.

## Implementation

The core implements LAR and ARAU AR0 side effects, while leaving MMR writes
independent. On the measured ROM-board profile, PA7 writes acknowledge flags
instead of replacing the whole register. Empty-window hardware observations
support the correction; a populated download-window acknowledgement still
needs its own measurement. No universal semantics for every unused PA7 bit
are claimed.

The bridge also had the return handshake backwards. PA7 bit 1 means the DSP
can send; CPU port 1C bit 1 means a reply is waiting. CPU acknowledgement sets
the DSP-ready bit again. The corresponding stream bit uses the same opposite
polarity. CPU bit 0 means the input holding register is free, while DSP PA7
bit 0 means a CPU message is pending.

For the measured ROM profile the bridge now commits the staged CPU tag/data
on the bit-0 write to 1C, returns readiness from the actual latch, and reads
status from one authoritative I/O value instead of OR-ing stale mirrors back
in. CPU input and DSP output have separate holding registers, and reading
an acknowledged output still returns the last word. The legacy image profiles
retain their existing bridge behavior.

`dsp_messages_taken` is a count of **CPU acknowledgements of DSP replies**.
Older notes mistakenly use it as a count of messages consumed by the DSP.
Actual DSP receive acknowledgements are writes of `1` to PA7; the new
round-trip regression checks those directly.

## End-to-end command check

`artifacts/mailbox-confirm-04/` repeats `07, 2D, 07` on the recovered board.
The reply holding registers are `0031:0000` throughout: 07 produces that
reply, and 2D leaves it unchanged. The emulator now reproduces the same
sequence after running the real boot ROM and resident initialization, with
CPU-side byte writes, commit, ready polling, reply reads, and acknowledgement.
It no longer needs a fixture caller to enter the dispatcher directly.

`tests/test_dsp_board_ndx.py` replays both exact captured DSP binaries and
checks the booted round trip, commit boundary, backpressure, held reply,
and independent input/output registers. PMST AVIS is masked in the instruction
comparison; its reset-state difference is outside these assertions.

Full dialing results are recorded separately below. Matching these mailbox
queries does not prove a working call, codec levels, or all ASIC registers.
