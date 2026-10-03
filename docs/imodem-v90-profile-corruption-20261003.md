# V.90 data corruption reproduction, 2026-10-03

The physical Courier reaches V.90, but the raw connection does not reliably
carry application data. A CONNECT result alone is not a passing test.

The independent SmartLink probe reproduces a receive failure without SIP,
Asterisk, or the VG224. Both modems negotiate V.90 at 44,000/31,200 bit/s.
The unsaved factory control receives all ten known messages correctly. The
saved live profile receives none of ten and emits unsolicited garbage.
Changing only its serial framing to 7E1, or its speed to 9600, does not fix it.

A profile written by the original firmware, with the live profile's 91-byte
ISDN block copied into it, also fails in both 8N1 and 7E1. In the 7E1 test,
all five emulator-to-SmartLink messages arrive intact after removing the
expected parity bits; none of five SmartLink-to-emulator messages arrive
intact. This narrows the reproduction but does not identify a faulty CPU or
DSP instruction. It also does not establish that this receive failure is
the same defect as the physical Courier's corrupt downstream.

Tests changing S67, S68, *V2, the synthetic factory capability header, or the
duplicate directory numbers did not repair the reproduction. NET3 and a
profile containing both factory SPIDs did not establish a data connection;
they are inconclusive data-integrity tests.

## Captured output reaches RTP unchanged

For all seven calls in the saved 02:20:29 UTC run, concatenated outbound RTP
payloads match the corresponding raw B-channel output exactly. The final
raw V.90 call matches across 7,380,000 bytes. Alignment uses a unique data
segment because different calls share their initial training waveform.
This rules out codeword modification by the emulator's RTP packetizer for
these captures, without ruling out receiver playout or other channel effects.

## Evidence and reproduction

- [Experiment comparison](../artifacts/imodem-slmodemd-v90-profile-framing-audit-20261003/comparison.json)
- [Factory control](../artifacts/imodem-slmodemd-v90-factory-profile-audit-20261003/result.json)
- [Saved live profile](../artifacts/imodem-slmodemd-v90-live-profile-audit-20261003/result.json)
- [Fresh saved profile, 7E1, valid ISDN block](../artifacts/imodem-slmodemd-v90-fresh-7e1-ni1-audit-20261003/payload-analysis.json)
- [RTP byte comparison](../artifacts/real-courier-pcm-trace-20261003T022029Z/rtp-bearer-byte-audit.json)

Use a fresh output directory on each run. This command uses the existing
isolated SmartLink test modem on Tower:

```sh
.venv/bin/python -m tools.probe_imodem_slmodemd \
  --protocol v90 --payload-check --payload-packets 5 \
  --payload-start-delay-blocks 200 --instructions 300000000 \
  --flash-nvram artifacts/imodem-slmodemd-v90-profile-framing-audit-20261003/nvram-firmware-fresh-7e1-ni1.sav \
  --imodem-initialization 'ATX1S54=0S58=1&A3&B1Q0&N0&U0&M0&K0' \
  --output artifacts/v90-profile-reproduction-new
.venv/bin/python -m tools.analyse_slmodemd_payload \
  artifacts/v90-profile-reproduction-new
```

Omit `--flash-nvram` for the working factory control. The probe retains the
supervisor RAM, native DSP program/data, both PCM streams, and both serial
streams. No production fix has been established by these experiments.
