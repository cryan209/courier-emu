# Two I-modems with x2 enabled, 2026-10-02

Two original `Ie030002.nac` supervisors and native C51 datapumps now connect
at **64000/64000 bps, x2/LAPM**, over a byte-exact PCMU digital B-channel.
Both distinct terminal payloads arrive at the opposite DTE with
`S54=0S58=48`, server and symmetric modes enabled, and a 230400-bps DTE
profile. The controls below document the earlier restricted-rate tests.

The pair harness now accepts `--protocol x2`. It sets `S58=32` on both ends:
V.90 is disabled, while x2 server and symmetric modes remain enabled. Detailed
result codes (`&A3`) and line-rate terminal operation (`&B0`) are selected.
The caller uses `*V2=3` and `ATD`; the answerer uses `ATA`. No carrier result,
DSP completion, or received payload is injected.

The following controls all return `CONNECT 9600/ARQ/V34/LAPM` on both ends
and deliver both markers:

| Settings | Evidence |
|---|---|
| `S58=32` | [detailed result](../artifacts/imodem-pair-x2-diagnostics-20261002/summary.json) |
| `S58=34`, asymmetric server disabled | [symmetric-only result](../artifacts/imodem-pair-x2-symmetric-only-20261002/summary.json) |
| `S54=0S58=34`, V.8 Call Indicate enabled | [V.8 result](../artifacts/imodem-pair-x2-v8-enabled-20261002/summary.json) |
| `S54=0S58=34&N0`, automatic line speed | [automatic-speed result](../artifacts/imodem-pair-x2-auto-speed-20261002/summary.json) |

The last control reads the live S-register file and confirms S54=0, S56=0,
and S58=34 on both ends. Both ISDN calls remain active, both DSPs report no
error, and both PCM receivers report zero underruns. Its compact
[verification](../artifacts/imodem-pair-x2-auto-speed-20261002/verification.json)
records these observations and explicitly marks `x2_verified` false.

`--link-diagnostics` waits after CONNECT, escapes with `+++`, queries the
guest's `ATI6`, then resumes with `ATO`. Both diagnostics report LAPM and
9600/9600, with zero retransmitted blocks, retrains, and link timeouts at the
query point. The queries run after the distinct markers have been sent.

Reproduce the automatic-speed control:

```sh
.venv/bin/python tools/probe_imodem_pair.py \
  --protocol x2 --settings 'S54=0S58=34&N0' \
  --instructions 200000000 --link-diagnostics \
  --originate-send X2-CALLER-123456789 \
  --answer-send X2-ANSWER-987654321 \
  --check-x2 --output artifacts/imodem-pair-x2-new
```

The command requires a local Unix socket. It saves both firmware reports and
the summary before failing the x2 check on the observed V.34 result.
`--check-connect` checks modem carrier only; `--check-x2` additionally requires
the CONNECT result to name x2, so a working V.34 connection cannot pass it.

The ten pair regression tests pass, including rejection of partial CONNECT
lines and embedded `DISCONNECT` text. The remaining issue is the x2
capability negotiation and modulation selection between two digital
datapumps; these controls do not establish its cause.

## Caller DTE restriction identified

The 9600-bps result is not the expected limit of two digital I-modems.
The target remains x2 symmetric at 64000 bps. A subsequent parameter-send
observer identifies a configuration restriction in the original harness:
the external DTE starts at 9600 bps (supervisor rate index 6).

The shipped supervisor's x2 eligibility function at `b27ef..b27f4` rejects
the originating modem when `2600:e496` bit 0 is set and the DTE rate index
at `2600:d1db` is below 8 (38400 bps). The answerer bypasses that rate test.
The live trace confirms the caller has flag 1/index 6 and sends no command
70, while the answerer has flag 0/index 6 and sends `0070:39ff`. Consequently
the original runs never allowed both sides to attempt x2.

The rate-mask routine at `b291c..b293c` adds another restriction. On the
originating path it intersects the PCM mask with `0003` for indices through
9 (57600), and with `0fff` for index 10 (115200). Index 11 (230400) leaves
the full mask available. The observed masks agree:

| Interface | Caller DTE index | Caller x2 command | Caller PCM mask | Answerer PCM mask |
|---|---:|---|---|---|
| External, 9600 | 6 | absent | `0003` | `ffff` |
| Internal, 57600 | 9 | `0070:39ff` | `0003` | `ffff` |
| Internal, 115200 | 10 | `0070:39ff` | `0fff` | `ffff` |

The [comparison](../artifacts/imodem-pair-x2-eligibility-20261002/eligibility-comparison.json)
is derived from the live mailbox observer, not from injected configuration
commands. Both internal-interface runs pass the initial x2 eligibility
check but finish without modem carrier. They therefore establish the
configuration defect, not a successful symmetric connection.

The harness now exposes `--trace-negotiation`, `--product-type`,
`--internal-baud`, `--nvram`, and `--establish` for these controls. Host UART
selection changes the emulated host's divisor register; the original
firmware reads and adopts it. Saved-profile controls change the packed DTE
setting and reseal its CRC.

## Full-rate test, 2026-10-02

The saved NET3 profile rejects the harness's mu-law bearer: the actual
NET3 validation branch at `5cb4e..5cb6d` requires A-law (`a3` or `23`).
Selecting National ISDN-1 (`*W=2`) in the sealed profile accepts the
mu-law SETUP and establishes both B channels. This resolves the saved-profile
setup blocker without modifying firmware or injecting carrier results.

The full-rate pair test boots both external units at 230400 bps, disables
V.90 with S58=32, and exchanges PCMU octets directly. Both sides send
`0070:39ff` (x2 capabilities) and `0071:ffff` (unrestricted PCM rate mask),
with the live DTE index equal to 11. They exchange 170 frames, or 136000
octets each way, before the caller clears normally and reports `NO CARRIER`.
Neither side reports modem CONNECT, and no application payload is delivered.

[Full-rate evidence](../artifacts/imodem-pair-x2-full-rate-ni1-20261002/verification.json).
This is a valid full-rate negotiation attempt, but it does not establish a
64000-bps symmetric connection. The earlier 9600 result was restricted by
DTE configuration; removing that restriction exposes a training failure with the initial S54=64 configuration. The additional
controls below establish x2 after enabling V.8.

The same saved profile and PCMU link succeed with x2 disabled (S58=43):
both units report `CONNECT 31200/ARQ/V34/LAPM`, and both application
markers arrive at the opposite DTE. This control isolates the current
failure to the negotiation/training path enabled for x2, rather than the
saved profile's call setup or basic bidirectional transport.
[Control results](../artifacts/imodem-pair-full-rate-v34-control-20261002/summary.json).

## V.8 and constellation controls

Both controls use the working National ISDN-1 saved profile with a live
DTE rate index of 11 and full `ffff` PCM rate mask. Server and symmetric
modes remain enabled in both runs.

| Live settings | Carrier | Data markers |
|---|---|---|
| S54=0, S58=32 | Both report 64000/x2/LAPM, then NO CARRIER | Neither delivered |
| S54=0, S58=48 | Both report 64000/x2/LAPM | Both delivered exactly |

S54=0 enables V.8 Call Indicate and V.8 mode. S58=48 disables V.90 and
adds the -6 dBm constellation; its server-disable and symmetric-disable
bits remain clear. The successful run sends `0070:3dff` and `0071:ffff`
on both sides, exchanges 252 complete 100 ms bearer frames, and records
zero PCM receive underruns and no CPU or DSP error. The short marker test
establishes symmetric carrier and bidirectional data, rather than sustained
64-kbit/s application throughput.

[Successful verification](../artifacts/imodem-pair-x2-full-rate-high-power-20261002/verification.json)
and [normal-constellation comparison](../artifacts/imodem-pair-x2-full-rate-v8-server-20261002/verification.json).

```sh
PYTHONPATH=. .venv/bin/python tools/probe_imodem_pair.py \
  --protocol x2 --settings 'S54=0S58=48' \
  --nvram artifacts/imodem-pair-x2-full-rate-routed-20261002/nvram-230400-switch2.sav \
  --trace-negotiation --instructions 180000000 \
  --originate-send CALLER-X2-S58-48 --answer-send ANSWER-X2-S58-48 \
  --check-connect --check-x2 --output artifacts/imodem-pair-x2-repeat
```
