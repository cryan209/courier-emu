# Two independent firmware instances over PCM

The `link` command launches two separate emulator processes. Add
`--line-audio-only` to exchange only a sample count and signed little-endian
PCM16 at 8,000 samples/second. Both ends must select this protocol. Each side
resamples between the common wire rate and its firmware-programmed codec rate.
Frames contain 100 ms of audio and synchronize the two processes. The socket
advances on each codec's conversion-frame clock, including silent frames;
CPU instruction counts do not determine the amount of audio exchanged.

```sh
./courier link artifacts/courier-board-21210-capture-403/courier-board.rom \
  --with-dsp --line-audio-only --socket /tmp/courier-audio.sock \
  --audio-dir artifacts/audio-only-peer-02/audio \
  --nvram-fixture idsdl403 --board-id 7 --dip-preset default --tick-ms 5 \
  --a-at ATX0 --a-at ATDT5551234 --b-at ATA \
  --instructions 85000000 --summary
```

Side A first sets `ATX0`, then sends `ATDT5551234`; side B answers with `ATA`.
`ATX0` disables waiting for exchange dial tone. There is no telephone exchange,
ringing, or dial tone in this
direct connection. Use explicit A/B commands: the older `link` default is
`ATA` on both sides. The default DIP preset in the command above also avoids
the older dedicated-line preset's carrier-detect override.

For separately launched processes, use `courier run` with the same ROM,
fixture, timer, and board options on both. Pass `--line-link
/tmp/courier-audio.sock --line-audio-only` to both, `--line-listen --at ATX0 --at ATDT5551234`
to the first, and `--at ATA` to the second. The socket listener role does not
determine the modem's originate/answer role. Start the second within 30 seconds.
Use `--line-record PREFIX` on a standalone instance to record `PREFIX-tx.wav`
and `PREFIX-rx.wav`. `link --audio-dir DIR` assigns prefixes `a` and `b`.
These are recordings at the socket boundary, before the receiving modem's
local hook gate. They are mono PCM16 WAV files at 8 kHz.

Audio-only mode does not transmit CPU instruction counts, hook state, ring
state, decoded bits, or modem commands. Local relay state gates local audio.
It disables command-parser seizure shortcuts, synthetic mailbox replies,
host-driven training entry, and synthetic carrier/CONNECT events. Firmware
mailbox traffic still passes through the emulated hardware registers.

## Verified result and remaining failure

`artifacts/audio-only-peer-01/summary.json` records the 4.03d pair above:
40 million CPU instructions per side, 78 frames and 62,400 samples sent and
received by each, with no socket errors and no synthetic connection events.
Both CPUs seize their local relay. Their DSP report tags differ (0008 on
originate, 000a on answer), but neither receives nonzero audio in this run.
That short run stopped just after the commands began executing, around
instruction 38 million; the initial conclusion that training audio never
reached the peer was premature.

`artifacts/audio-only-peer-02/before.json` repeats the original CPU-paced
transport for 150 million instructions with plain `ATDT5551234` and `ATA`.
The first answer audio arrives around instruction 40.9 million, after the
earlier run ended. The caller returns `NO DIAL TONE`, and the answerer's
transmit backlog grows to 115,429 line samples (14.4 seconds).

The codec-paced run with `ATX0` before `ATDT5551234` delivers audio in both
directions. Its largest transmit backlog is 21 samples (2.6 ms). Socket
recordings decode as `5551234` at the answerer's receive side. The answerer
sends a tone near 2100 Hz and a later changing waveform. These results verify
DTMF and waveform transport, **not completed training or data transfer**:
neither firmware reports `CONNECT` in the 150-million-instruction run.

The frame trace in each side's `dsp_bridge.line.audio_trace` separates the
pre-hook transmit peak, actual socket transmit/receive peaks, codec-input
peak, and transmit backlog. This distinguishes buffering from hook muting.
The trace keeps the latest 512 frames.

The 85-million-instruction recorded run is in `recorded-run.json`, with
waveform checks in `audio-analysis.json`. Every received PCM byte matches its
peer's transmitted stream. The caller sends one final 100 ms frame after the
answerer reaches its instruction limit; EOF at that point is test shutdown.
`audio/call-excerpt.wav` contains seconds 8–18, with the caller on the left
channel and answerer on the right. The four full recordings remain mono.

The older link mode remains available without the flag, including its hook/
ring side channel and behavioral call shortcuts. Its CONNECT result is not
evidence that the audio-only pair has trained.
