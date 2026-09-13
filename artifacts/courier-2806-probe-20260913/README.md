# Courier 2806 live ASIC probes — 2026-09-13

Target confirmed by ATI7: 25 MHz, supervisor 7.3.14, DSP 3.0.13, serial 22AEB36ACKND. Adapter /dev/cu.usbserial-FT4TQOFT at 115200 baud.

## Flash

Read 24 pages twice (48 reads): offsets 0000, 4000 and ff00 in each 64 KiB region from 80000 through fffff. Every repeated page was identical and matched the 2026-09-12 flash capture. This supports the current flat mapping, but does not exclude dormant bank selection. No bank register was written. Repeated blank pages are not evidence of address aliasing.

## ASIC CPU port space

Two idle passes, excluding mailbox ports 1c, 1e, 58–62 and the entire download window 40–62. All sampled odd ports below 80 returned zero. Every even port from 80 through fe returned its own address, and every odd port above 7f returned zero. This is consistent with the decode boundary previously observed and an undriven bus above it, rather than useful registers there. Zero odd reads agree with the mapped eight-bit CPU interface; the probe alone does not prove bus width.

Changes between passes:

{}

These are monitor observations, not direct CPU instruction probes; monitor-specific behaviour remains a limitation. No mailbox handshake, DSP-side aliases, clock frequency or interrupt route was measured. No configuration, RAM, ASIC register or flash writes, resets, calls or self-tests were issued. Final AT returned OK.

The first port attempt stopped on an incomplete trailing line ending at port 8b. ports.py repeated both passes and saved each result incrementally; results.json contains the completed passes and raw replies. Earlier serial.json records the echo-only attempt before DIP switches were corrected.
