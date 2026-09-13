# Inbound SIP: a real Courier calls the I-modem

This run reverses the existing live-call direction. A physical analogue
Courier originates a call through Asterisk; Asterisk sends the INVITE to the
emulator; the virtual NT presents a 3.1 kHz, mu-law Q.931 SETUP to the I-modem.
The SIP response follows what the I-modem actually does: 100 Trying on INVITE,
180 Ringing on ALERTING, and 200 OK with the emulator's PCMU SDP on CONNECT.

`--bri-sip-register` registers the local contact using the configured username
and password. Without it, configure the Asterisk extension as a static contact.
The `--bri-sip` address must be the Asterisk signalling address because the UDP
socket accepts the INVITE and subsequent dialog requests from that peer.

Create an artifact directory, then run the emulator in terminal mode so it
stays available while the physical Courier originates:

```sh
mkdir -p artifacts/imodem-inbound-sip-live

.venv/bin/python -m courier_emu isdn-run Ie030002.nac --with-dsp \
    --terminal --report --no-flash-nvram \
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
