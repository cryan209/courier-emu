# I-modem against an emulated analogue Courier

## 2026-10-02: regression for the first failed transition

The original `imodem-analog-pair-20261001/result.json` and September
`imodem-pair-connect-fix-20260930` control expose the same loader failure.
Q.931 establishes the telephone call and audio flows; neither failing run
reports a Hayes modem `CONNECT`. The September pair exchanges 176,000
mu-law octets each way (220 frames, 22 seconds), with no PCM receive
underruns. Its V.8 replies request image 6 (`0047:0006`), followed by
`0002:a000` at 19.5405 seconds on originate and 19.6150 on answer.
Two seconds later each supervisor repeats the command, sends `0083:0083`,
and reloads startup images `d100`/`9260`. Originate prints `NO CARRIER`
at instruction 143,707,136, then sends Q.931 DISCONNECT at 144,158,720;
answer prints it at 161,055,744 and disconnects at 161,505,280. Cause 16
is the supervisor's normal cleanup after the modem failure. The peer's
socket-close error follows that failure, rather than causing it.

The October analogue pair reaches the same image-6 request earlier,
at 5.4229 seconds, and repeats the timeout/reset sequence from 7.4150
seconds onward. Its I-modem call remains active at the capture limit,
despite those resets; the analogue end eventually reports `NO CARRIER`.
The zero `bri.media.rx_delivered` counter in that capture does not mean
the digital endpoint received no samples: this peer feeds the DSC directly,
and its `from_line` counter records 277,600 octets. The mailbox trace
demonstrates that negotiation reaches V.8 before the loader stalls.

The first failed transition is the supervisor's pre-download strobe to
the DSP's command-2 acknowledgement. The focused endpoint correction in
the working tree copies the destination to `0bff` and clears PA7 `0700`
along with command bit 0. It leaves the final completion strobe to native
DSP execution and returns startup reloads to the resident dispatcher.
Overlay ownership now also clears when the DSP instance closes, preventing
a fresh bootstrap from inheriting the previous foreground shortcut.

The automated handshake regression executes the original resident handler
at `840f..8413` as its reference, including preservation of unrelated PA7
bits. The paired-firmware regression is:

```sh
.venv/bin/python tools/probe_imodem_pair.py \
  --instructions 220000000 --check-keepalive \
  --output artifacts/imodem-pair-keepalive-regression-new
```

`--check-keepalive` requires active B1 calls, at least 250 exchanged frames,
the image-6 handoff and final download strobe, no DSP reset/timeouts, no
receive underruns, and no guest clearing or `NO CARRIER`. Both September
control sides fail this check. The corrected
[paired verification](../artifacts/imodem-pair-keepalive-20261002/summary.json)
passes on both sides at 220M instructions with 338 exchanged frames and
zero underruns. This verifies survival past the original teardown window;
it does not claim V.34 carrier acquisition. The Bell 103 evidence below
separately establishes a real modem connection and payload delivery.

## 2026-10-01: connected with terminal data in both directions

Both original firmware supervisors return Hayes `CONNECT` with Bell 103 at
300 bps. The I-modem keeps its ISDN call active and transmits the Bell 103
answer mark; the analogue Courier transmits the originate mark. This is a
native DSP connection, with no injected carrier result.
The [final preset verification](../artifacts/imodem-analog-pair-connected-data-20261001/summary.json)
records both CONNECT results, an active I-modem call, and both data-delivery
verdicts as true. The I-modem receives a 75-character Courier marker; the
analogue Courier receives a distinct 74-character I-modem marker.

```sh
.venv/bin/python tools/probe_imodem_analog_pair.py \
  --protocol bell103 --instructions 200000000 \
  --analog-send COURIER-12345 --imodem-send IMODEM-67890 \
  --output artifacts/imodem-analog-pair-connected-new
```

The preset fixes `&N1`, selects `B1`, disables V.8 (`S54=192`) and V.34/V.FC
(`S56=192`), selects normal mode (`&M0`), and follows the line's terminal rate
(`&B0`) on both ends. The originating
Courier also uses `S27=1`. The first carrier-only test retained the I-modem's
active call for the full 350M-instruction run, roughly 45 seconds of bearer
audio. The analogue worker reports `NO CARRIER` when the probe closes the
I-modem's socket at the instruction limit.

The failed earlier payload test exposed an unwired I-modem ASIC data window.
CPU ports `40h..56h` carry six words through DSP ports `58h..5dh`, separately
in each direction. CPU `18h` commits outgoing words and `1ah` acknowledges
incoming words, with DSP PA6 holding the occupancy bits. The I-modem model
kept returning the boot status from `18h`, returned zero from `1ah`, and did
not expose received words. It now implements the same bank handshake as the
analogue model; native DSP output registers also remain separate from input
registers. Both supervisors move the payload themselves.

The analogue DTE uses 7E1. Normal mode preserves the remote terminal's parity
bits in payload, so the report decodes its raw `serial_hex` as seven-bit
characters. The original byte stream remains in `result.json`. The probe
waits for CONNECT's terminating LF before sending payload, because sending
earlier aborts the I-modem's answer sequence.

The original fixed 9600-bps DTE setting passed the short markers but corrupted
the longer Courier-to-I-modem transfer. The native analogue transmit audio
independently decoded to the full expected message; line-level changes did
not consistently fix reception. Following the link rate with `&B0` delivered
the full messages in both directions at the default line level, and the
final preset run repeated that success. This is part of the Bell 103 preset.
Fixed-rate DTE operation still needs investigation.

V.34 carrier remains unresolved. Lower audio levels, a shorter bearer receive
cushion, a local hybrid-return experiment, V.32-only/V.22bis controls and an
older analogue firmware control did not establish a verified data connection.
The buffering and hybrid experiments were reverted. The codec history now
records clock changes even when divider registers stay identical, confirming
the 9.6 kHz to 10.2667 kHz change after symbol-rate index 5. Offline execution
of the I-modem's native mu-law decoder matches all 256 reference codewords.

## Earlier overlay blocker and V.34 investigation

The local pair establishes a 3.1 kHz mu-law ISDN bearer and exchanges audio.
The V.34 runs do **not yet establish a modem carrier**: neither side returns a Hayes
`CONNECT`. Q.931 `CONNECT`, `BCH_ENABLED`, and the socket's `answered` state
describe the telephone call, not successful modem training.

The pair runs the original `Ie030002.nac` supervisor and C51 firmware against
the captured 7.4.16 / DSP 3.1.2 analogue Courier image. No successful-carrier
reply or data connection is injected by this probe.

### The repaired blocker

The supervisor's loader at `b152c` first strobes port `1e` with `4`, then
sends mailbox command `0002:a000`. At `b1545` it waits for bit 2 of the
CPU-facing status to become ready before publishing any download words.

The existing foreground overlay shortcut acknowledged only PA7 bit 0.
Consequently PA7 bit 10 remained set, the supervisor waited two seconds,
and the loader reset the DSP. After that first failure, retaining call mode
also applied the shortcut to the startup pair and caused repeated reloads.

The shortcut now matches the acknowledgement in the resident handler at
`840f..8414`: write the destination cell `0bff` and clear PA7 `0700`, plus
the command-consumed bit. A startup `0002:d100` leaves call mode. The final
download strobe is passed to the DSP without rewinding its destination or
erasing its completion bit.

In the corrected 200M-instruction run, the DSP loads image 6 at `a000`:
**all 13,909 words match the firmware**, with zero mismatches. Both hashes are
`577e8280b68ae40287acb1b93f25900645161db3ec008652462ff229174c870d`.
The I-modem PCM endpoint reports zero receive underruns. The last mailbox
exchange is still the V.8 result `0047:0006`, followed by `0002:a000`; no
carrier result follows within that run.

Evidence is retained in
[the native-completion run](../artifacts/imodem-analog-pair-native-finish-20261001/result.json),
[overlay verification](../artifacts/imodem-analog-pair-native-finish-20261001/overlay-verification.json),
and that directory's `dsp-program.bin`, G.711 captures, WAVs and checkpoints.
A longer 400M-instruction run with the initial acknowledgement correction
ended with analogue `NO CARRIER`; it preceded the final-strobe correction.
The byte-exact two-I-modem control run also loads `a000` but has no Hayes
`CONNECT` at 200M instructions.

The final V.34-only run with both handshake corrections reaches a further DSP
reply, `0034:0005` at 16.1234 seconds of received bearer audio, but still has
no Hayes `CONNECT` at 220M instructions. Its compact
[summary](../artifacts/imodem-analog-pair-v34-fixed-20261001/summary.json)
records that result. Tracing the reply producer at `9b98..9b9d` shows that
tag `34` carries `@5b`, the symbol-rate index. The following code uses that
index to select rate-dependent tables. Thus `0034:0005` is a parameter
report during training, not a successful carrier indication or an identified
failure reason. Which caller produced it in this run is not yet traced.

Its end-state program comparison differs from the original image in the
contiguous range `ce00..d654`. This later comparison is not a transfer
checksum: whether that range is legitimately reused during V.34 operation
or corrupted remains to be determined. The zero-mismatch observation above
is specifically the earlier default-protocol run.

### Reproduce and inspect

```sh
.venv/bin/python tools/probe_imodem_analog_pair.py \
  --protocol v34 --instructions 220000000 \
  --analog-to-imodem-db -3 --imodem-to-analog-db -3 \
  --output artifacts/imodem-analog-pair-v34-new
```

The probe needs permission to bind a local Unix socket. It writes:

- `summary.json`: serial results and explicit carrier verdicts on both sides;
- `result.json`: full supervisor, DSP and bearer diagnostics;
- `checkpoints.json`: periodic DSP state and recent mailbox traffic;
- `dsp-program.bin`: the program memory actually present at the end;
- `dsp-data.bin`: data memory at the end;
- `imodem-{tx,rx}.g711` and `analog-{tx,rx}.wav`: audio in both directions.

`--protocol x2` sets S58 to 32 on both sides; `v90` sets 1; `v34` sets 33.
The previous analogue-side x2/V.90 test settings were reversed. These bits
**disable** their respective PCM protocols.

`--speed-index 1` fixes 300 bps on both sides for a lower-speed control.
That corrected dial-order run also establishes the audio call but does not
return `CONNECT` at 240M instructions. Its I-modem mailbox ends at
`0071:0002` / `004a:0000`, without an image-6 request.

The remaining investigation is the datapump's phase transition and carrier
acquisition after V.8. The verified overlay transfer and absence of receive
underruns remove those two specific failure modes from the corrected run;
they do not prove correct DSP arithmetic, waveform timing or training.
