# Inbound SIP: a real Courier calls the I-modem

This run reverses the existing live-call direction. A physical analogue
Courier originates a call through Asterisk; Asterisk sends the INVITE to the
emulator; the virtual NT presents a 3.1 kHz, mu-law Q.931 SETUP to the I-modem.
The SIP response follows what the I-modem actually does: 100 Trying on INVITE,
180 Ringing on ALERTING. Q.931 CONNECT starts the local bearer, but SIP 200 OK
with PCMU SDP waits for the DSP's answer waveform: at least 160 samples with
32 samples of decoded magnitude at least 128. The beginning of that waveform
is buffered and transmitted after accepting the call. This avoids exposing
the caller to the several seconds of idle bearer seen before the answer tone
in the 2026-10-03 physical Courier capture. Physical training with this change
still needs a live retest.

`--bri-sip-register` registers the local contact using the configured username
and password. Without it, configure the Asterisk extension as a static contact.
Registration is renewed at 80% of the registrar's accepted lifetime, with a
fresh authentication attempt on each renewal. The requested lifetime is 300
seconds; without renewal, the extension disappears after five minutes even
though the emulator is still running.
The `--bri-sip` address must be the Asterisk signalling address because the UDP
socket accepts the INVITE and subsequent dialog requests from that peer.

Incoming calls can be repeated in the same process after call clearing. The
incoming-call check uses the current idle call state, independently of the
one-shot guard for `--bri-call-at`. Clearing also resets the ringing flag and
answer/receive buffers, including when a caller cancels before answer.

Create an artifact directory, then run the emulator in terminal mode so it
stays available while the physical Courier originates:

The launcher defaults to 8N1, including when loading an older custom flash
profile. Set the physical Courier terminal to 8N1 too. Use `--dte-framing stored`
to preserve an explicitly saved serial format, or choose a format explicitly
with `--dte-framing`. Inspect ATI4 if received text has unexpected high-bit
characters.

```sh
mkdir -p artifacts/imodem-inbound-sip-live

.venv/bin/python -m courier_emu isdn-run Ie030002.nac --with-dsp \
    --terminal --report --flash-nvram artifacts/imodem-inbound-sip-live/nvram.sav \
    --bri-network --bri-establish terminal \
    --bri-call-to 7349195 \
    --bri-sip asterisk.net.cryan.nz --bri-sip-username 6000 \
    --bri-sip-register --bri-sip-local-port 5062 \
    --bri-sip-record artifacts/imodem-inbound-sip-live/caller-to-imodem.g711 \
    --bri-tx-g711 artifacts/imodem-inbound-sip-live/imodem-to-caller.g711
```

At the I-modem terminal, enter `ATS0=1`. Once it replies `OK`, dial the
extension from the real Courier. End the run with Ctrl-]. Save the JSON report
printed on stderr as `artifacts/imodem-inbound-sip-live/run.json` (or redirect
stderr when starting the command).

Analyze both directions and make listenable WAV files:

```sh
.venv/bin/python tools/analyze_bri_sip_audio.py \
    --from-caller artifacts/imodem-inbound-sip-live/caller-to-imodem.g711 \
    --from-imodem artifacts/imodem-inbound-sip-live/imodem-to-caller.g711 \
    --output artifacts/imodem-inbound-sip-live
```

The evidence has three independent parts:

1. `bri.media_peer.sip.rtp_octets_received` says how many caller octets reached
   the RTP socket. `bri.media_peer.octets.received_from_rtp` counts how many
   were taken by the B-channel bridge. The exact bearer accounting identity is
   `received_from_rtp + silence_filled == bri.media.rx_delivered`; received RTP
   can exceed the consumed count by a final queued partial block.
2. `imodem-to-caller.g711` is captured at the DSP-facing B channel before RTP.
   A strong 2100 Hz window (and, over a sufficiently long interval, the 15 Hz
   ANSam modulation sidebands) shows that the I-modem's answer signal reached
   the bearer.
3. `caller-to-imodem.g711` contains only actual received RTP payload, never
   silence inserted for pacing. Non-idle audio with V.8 V.21 energy near
   980/1180 Hz demonstrates that the originating Courier's negotiation traffic
   reached the bridge; the delivered counter above closes the path to the DSP
   bearer.

The original outbound scenario is unchanged: supplying `--bri-sip-target` (or
letting the modem's dialled digits populate it) still makes `BearerSipLine`
call `SipSession.start_call()` and use the existing authenticated INVITE flow.

During a live SIP B channel, the C51 digital-PCM peripheral is paced from
monotonic wall time at 40.32 MHz. The supervisor PIT and periodic RTOS/mailbox
service interrupts use wall time during the same live call. Previously those
timers followed CPU instruction progress, which could run substantially slower
than the real-time DSP under load. Clock transitions preserve elapsed time
across hangup and subsequent calls. The report's `pit.time_seconds` and
`pit.cpu_time_seconds` expose the difference. Offline instruction-budget runs
keep deterministic instruction coupling. A focused regression
checks that 100 ms produces 800 bearer frames and that leaving the call starts
a fresh clock epoch rather than catching up idle time.

Live DSP catch-up yields at a PCM-frame boundary after a one-millisecond
host-time slice so the supervisor can service interrupts during a backlog.
The absolute DSP target is retained for subsequent slices. Clock-source
agreement alone does not prove that the firmware receives every tick:
`pit.coalesced_timer_edges` counts timer requests lost to multiple elapsed
periods or an already-pending PIC request. The timestamped capture launcher
is `python -m tools.run_imodem_inbound_trace --extension 2903`; it saves each
run in a fresh directory and uses the existing PBX test account.

The 2026-10-03 hardware call reached V.34 at 31,200/33,600 with 37.5 dB
reported SNR, but was not error-free: the Courier reported 100 retransmissions
and 23 block errors; the I-modem reported 88 retransmissions and 826 block
errors. The endpoints reported roughly four minutes versus 52 seconds of
connected time. This prompted the supervisor clock correction; it does not
establish that timer drift caused the x2 failure. The pre-fix report and G.711
captures are preserved in `artifacts/real-courier-call-clock-audit-20261003/`.
A new hardware call is required to verify the effect on training and errors.

## Live result, 2026-09-13

Extension 6000 was registered on local UDP 5062 and a physical Courier on
`/dev/cu.usbserial-1140` (source extension 8403) dialled `ATDT6000`. Because the
I-modem's directory number is 7349195, the run used
`--bri-call-to 7349195` to map the PBX extension to that Q.931 number.

The signalling capture contains REGISTER/401/authenticated REGISTER/200,
INVITE/100/180/200/ACK, and BYE/200. Q.931 contains SETUP, ALERTING, CONNECT,
DISCONNECT cause 16, and RELEASE_COMPLETE. The active bearer delivered 107,871
octets, of which 107,681 came from RTP and only 190 were pacing fill. It emitted
107,871 octets toward RTP, 101,805 of them non-idle.

The caller capture has a strong 1300 Hz calling tone and V.21 energy at 980 and
1180 Hz. The I-modem capture has a 2100 Hz carrier with sideband-to-carrier
ratios 0.0915 at 2084.95 Hz and 0.0736 at 2115.05 Hz: ANSam reached the DSP
bearer. Both modems nevertheless ended `NO CARRIER`; transport is established,
but training did not complete. The machine-readable result, PCAP, raw G.711,
WAV files, and spectral report are in
`artifacts/imodem-inbound-sip-live-20260913/`.

## Pacing retest, 2026-09-13

The same physical Courier and `6000/6000` Asterisk account were used after the
wall-clock correction. The connected leg received 107,840 RTP octets and sent
108,320: 13.480 and 13.540 seconds respectively, a 0.45% duration difference.
The BRI bridge clocked 108,457 frames (13.557 seconds) and filled 1,314 frames
of genuine startup/network underrun. This replaces the earlier run's 13.48
seconds of transmitted bearer during a 29.74-second call.

The new caller capture contains V.21 energy at 980 and 1180 Hz. The I-modem
capture again has a strong 2100 Hz ANSam carrier and sideband-to-carrier ratios
of 0.0817 at 2084.95 Hz and 0.0689 at 2115.05 Hz. The physical call still did
not train to carrier, but the DSP bearer and RTP clock now agree; the evidence
is in `artifacts/imodem-inbound-sip-paced-20260913/`.
