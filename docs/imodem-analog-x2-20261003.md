# Analog Courier to I-modem x2, 2026-10-03

The original analog Courier firmware now reports **53333/x2/LAPM/V42BIS**
when connected to the I-modem. Both distinct terminal markers arrive intact.
The I-modem reports 33333 at its own terminal; these are separate endpoint
results. Server mode remains enabled (live I-modem S58=48, bit 1 clear).

[Production repeat](../artifacts/imodem-analog-x2-53333-production-20261003/verification.json)
and [read-only diagnostic capture](../artifacts/imodem-analog-x2-fullband-highpower-20ms-20261003/verification.json)
record the higher rate. The native receiver reconstruction filter now reaches
the lower Nyquist frequency instead of cutting it by another 2 percent.
Its 128 taps, delay and sample clocks are unchanged. At 3.8 kHz, an independent
tone check improves from 39.36 to 61.90 dB SNR, including amplitude and phase
error without fitting either away. A native regression requires over 60 dB.

The working higher-rate configuration uses S58=48 on both ends: V.90 is
disabled and the higher-power constellation is selected, with server and
symmetric capabilities retained. With ordinary S58=32 settings, the same
full-bandwidth reconstruction reaches 52000 bps and delivers both markers.
No firmware training, carrier, negotiated rate or payload is injected.
Both 53333 runs finish with intact messages in both directions, no guest
NO CARRIER, no CPU/DSP error and no connected receive underruns. The analog
CPU limit is 450 million instructions and the I-modem limit is 600 million.
The short message exchange verifies the negotiated rate and data delivery;
it is not a measurement of sustained 53333-bps application throughput.

Subsequent [56000-bps controls](imodem-analog-x2-56000-20261003.md) do not
establish a stable higher-rate connection. 53333 remains the verified result.

## Previous 41333 baseline

[Native results and verification](../artifacts/imodem-analog-x2-normal-power-x1-20261003/verification.json),
[independent repeat](../artifacts/imodem-analog-x2-41333-repeat-20261003/verification.json),
and [original high-power settings with X1](../artifacts/imodem-analog-x2-matched-x1-20261003/verification.json)
all report 41333 at the analog end, exchange both markers, and have no CPU
or DSP error and no guest NO CARRIER during the 400-million-instruction runs.
No firmware training, carrier or rate is injected. The high-power repeat
also shows that the original 33333 figure characterized the I-modem result,
not the analog receiver: X0 had hidden the analog rate.

## Higher-rate acceptance target

For the clean modeled analog downstream, the acceptance target is
**at least 53333 bps**, with intact bidirectional payloads and retained carrier.
The higher-rate runs above meet it. The earlier 41333 result was a working
baseline and did not establish the maximum rate of an ideal analog line.
The requested PCM mask already included 53333 and the higher analog x2 rates.

Additional controls on 2026-10-03:

| Control | Analog result | Payloads | Evidence |
|---|---|---|---|
| 10 ms exchange, normal x2 settings | NO CARRIER, no CONNECT | Neither | [Summary](../artifacts/imodem-analog-x2-ideal-10ms-20261003/summary.json) |
| 20 ms exchange, V.90 only | No CONNECT within 300 million instructions | Neither | [Summary](../artifacts/imodem-analog-v90-ideal-20ms-20261003/summary.json) |
| 20 ms exchange, downstream level -3 dB | 41333/x2/LAPM/V42BIS | Both | [Summary](../artifacts/imodem-analog-x2-ideal-rx-minus3-20261003/summary.json) |
| 20 ms exchange, downstream level +3 dB | NO CARRIER, no CONNECT | Neither | [Summary](../artifacts/imodem-analog-x2-ideal-rx-plus3-20261003/summary.json) |

A separate diagnostic native build changes only the analog receive
reconstruction kernel from 128 to 512 taps and its cutoff from 0.49 to 0.5
cycles per 8-kHz input sample. It falls back to V.34 during the run.
The longer FIR also adds 24 ms of group delay, so this experiment does not
isolate bandwidth from training timing. The longer kernel was not adopted.
The [diagnostic patch](../artifacts/imodem-analog-x2-ideal-filter512-20261003/diagnostic-filter.patch)
records the exact experiment; it is not an adopted fix.

Two initial timestamp-observer runs (`fullband-soak` and `fullband-highpower`)
imported the transport before the paired CLI selected its default, leaving
100 ms on one side and 20 ms on the other. They are invalid controls and are
excluded. The successful captured run explicitly sets
`COURIER_LINE_FRAME_MS=20`; the production repeat uses the ordinary paired CLI
without the observer.

## Changes and evidence

The analog pair CLI now defaults to 20 ms socket exchanges, with the general
line default left at 100 ms. `COURIER_LINE_FRAME_MS` selects a common exchange
size for both processes and preserves their 8 kHz sample clock. The I-modem
still has a complete receive reserve; its size follows the exchange size.
The lower transit delay allows the original training scripts to proceed into
x2 rather than timing out and eventually connecting in V.34.

The probe's carrier parser now accepts lowercase `/x2` modulation names. The
old case-sensitive expression withheld the I-modem marker after a genuine
x2 CONNECT. A regression exercises the complete lowercase result line.
`--imodem-nvram` selects the working NI1 profile, `--link-diagnostics` queries
native ATI6 after carrier, and checkpoints retain terminal text.

The earlier table below records the I-modem result. X0 omitted the analog
rate in these runs.

| Exchange | I-modem result | Payloads | Evidence |
|---|---|---|---|
| 100 ms | 21600/V34/LAPM | Both arrived | [Control](../artifacts/imodem-analog-pair-x2-high-power-ni1-20261003/verification.json) |
| 20 ms | 33333/x2/LAPM | Both arrived | [Working x2](../artifacts/imodem-analog-pair-x2-20ms-default-filter-20261003/verification.json) |
| 5 ms | 33333/x2/LAPM, then guest NO CARRIER | Both arrived before clearing | [Lower-delay control](../artifacts/imodem-analog-pair-x2-5ms-20261003/verification.json) |

The 20 ms run uses the original 128-tap Kaiser reconstruction filter, has
zero connected analog receive underruns and zero I-modem PCM receive
underruns, and reports no CPU or DSP error. Foreground overlay assistance is
disabled. No guest carrier, training decision, rate or payload is injected.
An earlier full-Nyquist reconstruction experiment used a different setup and
fell back to V.34. Repeating it with the working 20 ms configuration establishes
the higher rates reported above.

## Reproduction

```sh
PYTHONPATH=. .venv/bin/python tools/probe_imodem_analog_pair.py \
  --analog-settings 'X1S27=1S54=0S58=48&A3&B1Q0&U26&N39' \
  --imodem-settings 'S54=0S58=48&A3&B1Q0' \
  --imodem-nvram artifacts/imodem-pair-x2-full-rate-routed-20261002/nvram-230400-switch2.sav \
  --instructions 600000000 --analog-instructions 450000000 \
  --analog-send ANALOG-X2-53333 \
  --imodem-send IMODEM-X2-53333 \
  --output artifacts/imodem-analog-x2-repeat
```

Set `COURIER_LINE_FRAME_MS=100` to reproduce the old transport delay.
The I-modem retains both server and symmetric capabilities. S58=48 disables
V.90 and selects the higher-power constellation. The analog &U26/&N39 request selects
40000..57333; the firmware still includes its lowest fallback bit. X1
reports the analog rate without requiring dial-tone detection. Fixed DTE rates and Q0 preserve
terminal operation and visible result codes across carrier establishment.

## Earlier rate investigation

The analog native DSP's reported bitmap `0275` confirms local x2, completed
V.8, remote x2, channel qualification, normal high-frequency rolloff and
recognition of the remote x2 server. Recognition therefore works.

A 6 dB receive attenuation control still reports 33333/x2 and delivers both
markers. A +6 dB gain control does not raise the reported rate and loses part
of the upstream marker. Neither establishes the requested higher speed.

The analog firmware's own help maps &N27 to 41333 and &N39 to 57333.
`&U27&N39` sends the PCM mask `7ffd` but still reports 33333/x2 and delivers
both markers. The original supervisor at `88fc9..89047` deliberately ORs
bit 0 into its PCM rate mask, including the lowest x2 rate even when a higher
minimum is requested. The minimum command therefore cannot by itself prove
or enforce a connection above 40 kbps.

[Rate request and native diagnostics](../artifacts/imodem-analog-pair-x2-rate27-20261003/verification.json).
ATI6 reports legacy Speed 24000/32000 despite the x2 result, so those fields
must be interpreted against the PCM reporting path rather than used as
independent evidence of a higher PCM rate. The earlier X0 result omitted
the analog speed entirely, so the I-modem's 33333 result was insufficient to
characterize both directions. The pair CLI now defaults to X1 and records
`connect_rate_bps` separately for each terminal. `--analog-result-mode 0`
reproduces the old bare CONNECT behavior.

A native read-only capture at overlay-6 PC a688 records the direction masks
and descriptor words. No capture reaches overlay-8 PC ece8 in the control
run. These observations remain diagnostic evidence rather than a substitute
for the modem's native CONNECT result. A separate X3 control reports 37333
at the analog end and then loses carrier; an asymmetric 20 ms control
delivers both markers but also loses analog carrier. Neither is the working
41333 configuration above.
