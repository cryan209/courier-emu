# 3453C Si3034 serial codec

The 3453C recovered-ROM path now selects a native Si3034 codec instead of
letting its serial words pass through the legacy TDM/AC01 behavior. The
supervisor still loads the original DSP resident and overlays through the
recovered loader. Codec setup is performed by that DSP firmware.

The Si3034 datasheet, revision 2.02, sections 5.21 and 5.22 and registers
1–19 describe a different protocol from the AC01:

- In the reset 15-bit mode, primary word bit 0 requests a secondary frame.
  Bit 1 remains audio. Secondary controls use bit 13 for read/write,
  bits 12:8 for the address and bits 7:0 for data.
- PLL fields store their multiplier/divisor minus one. PLL2 writes latch
  the clock configuration; CGM applies the 16/25 ratio when PLL2 is not
  bypassed. With a 2.88 MHz MCLK, the guest's 0704, 083F, 0911 controls
  produce 7,200 Hz, not an AC01 A/B divider configuration.
- Register 6 controls line-side power; registers 2, 13 and 15 control
  receive enable, gains and mutes. Power-down mutes PCM while serial frames
  continue. The external modeled line supplies hook, ring and loop-current
  status for register reads.
- Country controls 16–18 retain their guest-written values. The observed
  proprietary register 20 is retained without assigning undocumented effects.

The native serial clock delivers primary PCM and secondary readback to DRR,
holds DAC output until replaced, and raises the serial receive/transmit
events. The 403 board's separate INT3 frame wiring is not applied to this
profile. Host mailbox input and output latches remain separate when the
serial codec is enabled; this is required to preserve DSP overlay requests.
DSP and codec resets restore Si3034 register defaults while retaining the
configured board MCLK. AC01 selection remains separate.

Source: [Si3034 datasheet](SI3034.PDF), especially Figures 24–27 and Table 19.
The 2.88 MHz MCLK is the existing model clock and is consistent with the
firmware's PLL settings, not a new measurement. Serial revision register 13
uses the board-profile inference of an international revision-C line side;
the recorded DAA identity is not a direct serial-register read.

## Execution evidence

The guest now writes its native codec registers, programs 7,200 Hz and
clears PDL. An independent ATI0 control still returns 5608A. The pair retest
executes 150 million 3453C instructions and 400 million I-modem instructions:
the codec clocks 244,305 primary frames, with 36 register writes, and drains
received PCM instead of leaving the whole input queue untouched.

The pair still does not connect. The complete AT dial command is consumed
and the relay goes off hook, but the 3453C remains in dialing; no incoming
call reaches the I-modem and transmitted PCM is zero. That result is a
remaining call-control/ASIC gap, not a successful interoperability test.
The run and raw captures are in
[the evidence bundle](../artifacts/3453c-si3034-20261003/).

The subsequent [codec/hook audit](../artifacts/3453c-codec-call-audit-20261003/README.md)
identified an earlier call-control abort: INT0 trips the supervisor watchdog
because the board tick is not resetting its counter.
The abort path then stalled on a missing UART TX-empty status bit. That
status read is now fixed, so the hook releases and cleanup completes; the
pair still does not connect. The subsequent
[watchdog fix](../artifacts/3453c-watchdog-20261003/README.md) selects the
80C186EB interrupt masks and recognizes the 2.3.x mailbox ISR return,
restoring the external tick at vector 0F. Internal CPU timer interrupts
are not the missing watchdog-reset source. The earlier timer-delivery
experiments are not enabled by default.

The audit also recovers host tags 7D/82/83 as Si3034 registers 16/17/18,
including termination, calibration and dialing controls. The bridge now
leaves their execution and replies to the C52, and no longer interprets
3453C tag 82 as the older ASIC's call-engine start/hold control.

## Serial readback timing

The active Si3034 port now moves DXR into its transmit shifter at FSYNC
and raises XINT then. It delivers the received word to DRR and raises RINT
16 SCLKs later. Section 5.22 specifies SCLK = 256 × Fs, so this interval
is one sixteenth of a primary period. The secondary exchange occurs halfway
through that period and returns its addressed register in the same exchange.
The following primary XINT handler can therefore read the completed secondary
reply before the new primary receive word replaces it.

The unchanged resident's `7C:0000` request sends `2CFF`, receives `0044`
for a connected off-hook line, and builds pending reply `0244` in data cell
`012F`. With no modeled loop current it receives `0040`. These results are
covered by guest-execution tests, alongside a serial word-completion test.
The timing applies to the active clocked port; synchronous control probes
with the transmitter in reset retain their direct-control API.

The subsequent pair retest completes without CPU/DSP or overlay errors and
now exchanges nonzero audio. The I-modem reports RING and answers the bearer,
but training ends in NO CARRIER, with no payload delivery. The detailed
[readback retest](../artifacts/3453c-watchdog-20261003/README.md) also records
the corrected overlay verifier: the resident restores BMAR from its saved
pointer before transferring, so verification uses its completed `7F62`
marker rather than the foreground's earlier BMAR value.

## Remaining model limits

This implements the guest's serial mode 0/1 setup and ordinary PCM path.
Hardware FC requests in 16-bit mode, daisy-chain/slave mode, physical PLL
lock transients, analog/digital loopback modes, persistent ring-detector
latching, and electrical/filter calibration are not fully modeled. Ring
status follows the existing coarse line-source cadence. The historical
AC'97-style `CodecBringUp` report remains separate from the native Si3034
registers; its `complete` flag does not establish datapump operation.
